<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	var headCols = [];
	var todayDate;
	$(document).ready(function(){
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			//pkcol : "SKUKEY,LOCAKY,LOTA06",
			autoCopyRowType : true
		});
		
		init();
	});
	
	// 초기셋팅
	function init(){
		//오늘날짜 구하기
		day();
		
		var gridId = "gridList";
		//1.검색조건 멀티셀렉트 전제선택 체크
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		
		//2.grid select readonly
		gridList.setReadOnly(gridId, true, ["SKUCLS", "AREAKY"]);
		
		//3. 그리드내 존재해야하는 컬럼
		gridList.appendCols(gridId, ["WAREKY", "NAME01", "OWNRKY", "DUEMON", "DUEDAY", "TRNUID", "LOTA01", "STOKKY", "LOTNUM", "DUOMKY", "MNGLT9", "MNGMOV", "USARG3", "PACKYN"]);
		
		//4.조회시 그리드 add, delete 버튼 숨김
		gridList.setBtnActive(gridId, configData.GRID_BTN_ADD, false);
		gridList.setBtnActive(gridId, configData.GRID_BTN_DELETE, false);
		
		//5.상품코드 입력시 grid col name 가져오기
		headCols = [];
		var gridBox = gridList.getGridBox(gridId);
		headCols = gridBox.cols.slice(2);
	}
	
	//오늘날짜
	function day(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		var gridId = "gridList";
		if( btnName == "Search" ){ //조회
			gridList.setBtnActive(gridId, configData.GRID_BTN_ADD, false);
			gridList.setBtnActive(gridId, configData.GRID_BTN_DELETE, false);
			searchList();

		}else if( btnName == "Save" ){ //저장
			saveData();
			
		}else if( btnName == "Create" ){ //생성
			gridList.resetGrid(gridId);
			gridList.setBtnActive(gridId, configData.GRID_BTN_ADD, true);
			gridList.setBtnActive(gridId, configData.GRID_BTN_DELETE, true);
			gridList.setReadOnly("gridList", false, ["SKUKEY", "LOTA06", "LOCAKY", "LOTA08", "LOTA09"]);
			
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			newData.put("PRCUOM", "EA");
			newData.put("DUOMKY", "EA");
			gridList.addNewRow(gridId, newData);
			
		}else if( btnName == "Reflect" ){ //일괄적용
			var selectData = $("select[name=Reflect]").val();
			var list = gridList.getSelectData(gridId);
			var listLen = list.length;
			
			if( listLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return false;
			}
			
			for( var i=0; listLen>i; i++ ){
				var gridRowNum = list[i].get("GRowNum");
				gridList.setColValue(gridId, gridRowNum, "RSNADJ", selectData);
			}
		}
	}
	
	//헤더 조회 
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			$("select[name=Reflect]").val("");
			
			if( param.get("QTYYN") == "V" ){
				// 재고수량 0인 상품
				gridList.gridList({
					command : "SJ03_QTY",
					id : "gridList",
					param : param
				});
			}else{
				gridList.gridList({
					command : "SJ03",
					id : "gridList",
					param : param
				});
			}
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList", "select") ){
			
			if( !commonUtil.msgConfirm("COMMON_M0100") ){ //저장하시겠습니까?
				return false;
			}
			
			var gridId = "gridList";
			var head = new DataMap();
			var list = gridList.getSelectData(gridId);
			var listLen = list.length;
			
			if( listLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return false;
			}
			
			for ( var i=0; i<listLen; i++){
				var listRowData = list[i];
				var rowNum = listRowData.get("GRowNum");
				var mngmov = listRowData.get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = listRowData.get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = listRowData.get("LOTL01"); //skuma 유통기한 관리여부
				var lota06 = listRowData.get("LOTA06"); //재고상태
				var qtviwe = listRowData.get("QTVIWE");
				var lota08 = $.trim(listRowData.get("LOTA08")); //입력제조일자
				var lota09 = $.trim(listRowData.get("LOTA09")); //입력유통기한
				var desc01 = listRowData.get("DESC01"); //상품명
				
				//유통기한 필수여부 체크
// 				if( lota06 == "00" || lota06 == "10" ){
// 					if( mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" && lota09 == "" ){
// 						commonUtil.msgBox("INV_M1013", desc01); //[{0}]은 유통기한 필수입력 상품입니다.
// 						return false;
// 					}
// 				}
				
				if( listRowData.get("PRCQTY") + listRowData.get("QTADJU") == 0 ){
					commonUtil.msgBox("INV_M1014"); //수량 또는 조정수량은 0보다 커야합니다.
					return false;
				}
				
				//실수량과 재고수량 비교, 재고수량보다 아래인 값은 처리 불가
				if( qtviwe < 0 ){
					alert("수량 및 조정수량의 값은 재고수량 미만으로 설정할 수 없습니다. 다시 입력해 주세요.");
					return false;
				}
				
				//실수량과 재고수량이 같으면 변경된 데이터 없음
				if( qtviwe == listRowData.get("QTSIWH") ){
					alert("[" + desc01 + "]는 변경될 수량이 없습니다.");
					gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
					gridList.setColValue(gridId, rowNum, "PRCUOM", "EA"); //단위
					gridList.setColValue(gridId, rowNum, "QTVIWE", "0"); //실수량
					gridList.setColValue(gridId, rowNum, "QTADJU", "0"); //조정수량
// 					gridList.setColValue(gridId, rowNum, "RSNADJ", ""); //사유
					return false;
				}
				
			}
			
			var param = new DataMap();
			param.put("list", list);
			param.put("ADJUTY", "450");
			param.put("HHTTID", "WEB");
			param.put("PROGID", "SJ03");
			param.put("WAREKY", "<%=wareky%>");
			
			netUtil.send({
				url : "/wms/inventory/json/saveSJ03.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			var data = json.data;
			
			if( data.CNT > 0 ){
				commonUtil.msgBox("MASTER_M0815", data.CNT); //[{0}]이 저장되었습니다.
				searchList();
				
				//top 재조회
				window.parent.parent.frames["header"].countCall();
			}else if( data.CNT < 1 ){
				commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId == "gridList") {
		
			var rowData = gridList.getRowData(gridId, rowNum);
			var rowState = rowData.get("GRowState");
			var skukey = rowData.get("SKUKEY");
			//상품코드 먼저 입력
			if( $.trim(skukey) == "" ){
				setRowData(gridId, gridId, rowNum, "init");
				commonUtil.msgBox("INV_M1016"); //상품코드를 입력해주세요.
				return false;
			}
			
			if( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
				var NumColValue = Number(colValue);
				var prcuom = rowData.get("PRCUOM");
				var qtsiwh = Number(rowData.get("QTSIWH"));
				
				//생성일때
				if( rowState == "C" ){
					// 음수 입력 불가
					if( NumColValue <= 0 ){
						colChangeNum(gridId, rowNum);
						commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다.
						return false;
					}
					
					//재고수량보다 작을 순 없음.
					if(qtsiwh > NumColValue){
						colChangeNum(gridId, rowNum);
						alert("수량은 재고수량보다 작을 수 없습니다.");
						return false;
					}
				}
				
				//조정수량 계산
				if( prcuom == "EA" ){
					gridList.setColValue(gridId, rowNum, "QTVIWE", NumColValue); //실수량
					gridList.setColValue(gridId, rowNum, "QTADJU", NumColValue - qtsiwh ); //조정수량
					
				}else if( prcuom == "CS" ){//박스
					var csQty = Number(rowData.get("BOXQTY")) * NumColValue;
					if( csQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", csQty); //실수량
					gridList.setColValue(gridId, rowNum, "QTADJU", csQty - qtsiwh ); //조정수량
					
				}else if( prcuom == "IP" ){ //이너팩
					var ipQty = Number(rowData.get("INPQTY")) * NumColValue;
					if( ipQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", ipQty); //실수량
					gridList.setColValue(gridId, rowNum, "QTADJU", ipQty - qtsiwh ); //조정수량
					
				}else if( rprcuom == "PL" ){ //팔레트
					var plQty = Number(rowData.get("PALQTY")) * NumColValue;
					if( plQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", plQty); //실수량
					gridList.setColValue(gridId, rowNum, "QTADJU", plQty - qtsiwh ); //조정수량
				}
				
			}else if ( colName == "QTADJU" ){////////////////////////////////조정수량////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
				var NumColValue = Number(colValue);
				var changeQty = Number(rowData.get("QTSIWH")) + NumColValue;
				
				if( NumColValue == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				if( rowState == "C" && NumColValue <= 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
					
				}
				
				gridList.setColValue(gridId, rowNum, "PRCQTY", changeQty); //수량
				gridList.setColValue(gridId, rowNum, "QTVIWE", changeQty); //실수량
				
			}else if ( colName == "PRCUOM" ){ ////////////////////////////////단위//////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
				gridList.setColValue(gridId, rowNum, "QTVIWE", 0); //실수량
				gridList.setColValue(gridId, rowNum, "QTADJU", 0); //조정수량
				
			}else if ( colName == "LOTA08" ){ ////////////////////////////////제조일자////////////////////////////////
				// 오늘일자 < 제조일자
				if( todayDate < colValue ){
					commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("ALOTA08", colValue);
				param.put("DUEMON", rowData.get("DUEMON"));
				param.put("DUEDAY", rowData.get("DUEDAY"));
				
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "SJ01DATE",
					sendType : "list",
					param : param
				});
				
				//일자체크
				if( json && json.data ){
					if( json.data[0].DUEDAY != colValue ){
						gridList.setColValue(gridId, rowNum, "LOTA09", json.data[0].DUEDAY);
					}
				}
				
			}else if ( colName == "LOTA09" ){ ////////////////////////////////유통기한////////////////////////////////
				if( $.trim(colValue) == ""  ){
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
					return false;
				}
				
				if( $.trim(rowData.get("LOTA08")) != "" ){
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
				}
				
	// 			if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" ){
	// 				commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
	// 				gridList.setColValue(gridId, rowNum, colName, "");
	// 				gridList.setColValue(gridId, rowNum, "LOTA08", "");
	// 				return false;
	// 			}
				
	// 			var param = new DataMap();
	// 			param.put("ALOTA09", colValue);
	// 			param.put("DUEMON", rowData.get("DUEMON"));
	// 			param.put("DUEDAY", rowData.get("DUEDAY"));
				
	// 			var json = netUtil.sendData({
	// 				module : "WmsInventory",
	// 				command : "SJ01DATE",
	// 				sendType : "list",
	// 				param : param
	// 			});
				
	// 			//일자체크
	// 			if( json && json.data ){
	// 				if( json.data[0].DUEDAY != colValue ){
						
	// 					// 오늘일자 < 제조일자
	// 					if( todayDate < json.data[0].DUEDAY ){
	// 						commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
	// 						gridList.setColValue(gridId, rowNum, colName, "");
	// 						gridList.setColValue(gridId, rowNum, "LOTA08", "");
	// 						return false;
	// 					}
						
	// 					gridList.setColValue(gridId, rowNum, "LOTA08", json.data[0].DUEDAY);
	// 				}
	// 			}
			}else if ( colName == "SKUKEY" ){ ////////////////////////////////상품코드////////////////////////////////
				var param = new DataMap();
				param.put("WAREKY", rowData.get("WAREKY"));
				param.put("SKUKEY", colValue);
				
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "SKUKEYQTY",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					var dataLen = data.length;
					
					if( dataLen > 0 ){
						setRowColsData(gridId, data[0], rowNum, "no");
						
						
					}else if( json.data.length <= 0 ){
						gridList.setColValue(gridId, rowNum, "SKUKEY", "");
						gridList.setColValue(gridId, rowNum, "DESC01", ""); 
						alert("상품상세내역이 존재하지 않습니다.");
					}
				}
				
				
			}else if ( colName == "LOCAKY" ){ ////////////////////////////////로케이션////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "AREAKY", "");
					gridList.setColValue(gridId, rowNum, "ZONEKY", "");
					gridList.setColValue(gridId, rowNum, "ZONENM", "");
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA06", "");
					gridList.setColValue(gridId, rowNum, "MNGLT9", "");
					gridList.setColValue(gridId, rowNum, "QTSIWH", "");
					gridList.setColValue(gridId, rowNum, "PRCQTY", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("WAREKY", rowData.get("WAREKY"));
				param.put("OWNRKY", rowData.get("OWNRKY"));
				param.put("SKUKEY", skukey);
				param.put("LOCAKY", colValue);
				
				//로케이션 가능여부 체크
				var chkloc = netUtil.sendData({
					module : "WmsInventory",
					command : "FN_LOCAKY",
					sendType : "map",
					param : param
				});
				
				if( chkloc && chkloc.data ){
					var chklocData = chkloc.data["CHK"];
					
					if( chklocData != "1" ){
						setRowData(gridId, chklocData, rowNum, "init");
						var comboName = gridList.getGridBox("gridList").comboDataMap.get("LOTA06").get(rowData.get("LOTA06"));
						alert("[상품코드 : " + skukey + " / 재고상태 : " + comboName+ " ]에 적합한 로케이션[ " + colValue + " ]이 아닙니다."); //상품코드/재고상태[/]에 적합한 로케이션[]이 아닙니다.
						setRowData(gridId, chklocData, rowNum, "init");
						return false;
					}
				}
				
				//로케이션 정보 조회
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "LOCAKYLOTA06",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					
					if( data.length == 0 ){
						alert("[ 상품코드 : " + skukey + " ]에 적합한 로케이션[ " + colValue + " ]이 아닙니다.");
						setRowData(gridId, data, rowNum, "init");
						gridList.setColValue(gridId, rowNum, "PRCQTY", "0");
						
					}else if( data.length > 0 ){
						setRowColsData(gridId, data[0], rowNum); //해당 컬럼만 변경
						gridList.setColValue(gridId, rowNum, "PRCQTY", data[0].QTSIWH);
					}
				}
				
			}else if( colName == "LOTA06" ){ ////////////////////////////////재고상태////////////////////////////////
				var param = new DataMap();
				param.put("WAREKY", rowData.get("WAREKY"));
				param.put("OWNRKY", rowData.get("OWNRKY"));
				param.put("SKUKEY", skukey);
				param.put("LOTA06", colValue);
				
				//로케이션 가능여부 체크
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "FN_LOTA06",
					sendType : "map",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					var locaky = data["LOCAKY"];
					
					if( $.trim(locaky) == "" || locaky == "0" ){
						setRowColsData(gridId, data, rowNum, "init");
						gridList.setColValue(gridId, rowNum, "PRCQTY", "0");
	// 					var comboName = gridList.getGridBox("gridList").comboDataMap.get("LOTA06").get(colValue).split("]")[1];
						var comboName = gridList.getGridBox("gridList").comboDataMap.get("LOTA06").get(colValue);
						alert("[상품코드 : " + skukey + " / 재고상태 : " + comboName+ " ]에 적합한 로케이션이 없습니다.");
						return;
					}else{
						setRowColsData(gridId, data, rowNum);
						gridList.setColValue(gridId, rowNum, "PRCQTY", data.QTSIWH);
					}
				}
			}
		}
	}
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
		gridList.setColValue(gridId, rowNum, "QTVIWE", "0"); //실수량
		gridList.setColValue(gridId, rowNum, "QTADJU", "0"); //조정수량
		
		if( select == "N" ){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA"); //단위
			commonUtil.msgBox("INV_M1014"); //수량 또는 조정수량은 0보다 커야합니다.
			return false;
			
		}else if( select == "S" ){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("INV_M1007"); //조정수량이 재고수량을 초과합니다. 다시 입력해 주세요.
		
		}
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var gridId = "gridList";
		var param = new DataMap();
		if( searchCode == "SHGRID" && ($inputObj.name == undefined) && (rowNum != undefined) ){
			var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
			if( $.trim(skukey) == "" ){
				commonUtil.msgBox("INV_M1016"); //상품코드를 입력해주세요.
				return false;
			}
			
			var param = new DataMap();
			param.put("gridId", gridId);
			param.put("rowNum", rowNum);
			param.put("multyType", multyType);
			param.put("WAREKY", "<%=wareky%>");
			param.put("WARENM", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			param.put("SKUKEY", skukey);
			param.put("progId", "GR03"); //lota06 = '00', '10' 만 조회함
			
			var option = "height=600,width=800,resizable=yes";
			page.linkPopOpen("/wms/inbound/POP/GR02_LOCMA_POP.page", param, option);
			
			return false;
			
		}else if( searchCode == "SHZONMA" ){
			var param = inputList.setRangeParam("searchArea");
			param.put("multyType", multyType);
			param.put("WAREKY", "<%=wareky%>");
			param.put("ARETYP", "STOR");
			param.put("SHPNOT", " ");
			
			page.linkPopOpen("/wms/inventory/POP/SJ03POP.page", param);
			return false;
			
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			skumaPopup.open(param);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if( data.get("searchCode") == "SHZONMA" ){
			var singleList = [];
			var zoneList = data.get("ZONEKY");
			for(var i=0; i<zoneList.length; i++){
				var rangeMap = new DataMap();
				rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
				rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
				rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, data.get("ZONEKY")[i]);
				singleList.push(rangeMap);
				
			}
			inputList.setRangeData("LO.ZONEKY", configData.INPUT_RANGE_TYPE_SINGLE, singleList);
			
		}else if( data.get("popNm") == "GR02_LOCMA" ){
			var gridId = data.map.gridId;
			var rowNum = data.map.rowNum;
			var gridData = data.map.data;
			var areaky = gridData.get("AREAKY"); //AREA
			var zoneky = gridData.get("ZONEKY"); //존
			var zonenm = gridData.get("ZONENM"); //존명
			var locaky = gridData.get("LOCAKY"); //로케이션
			var lota06 = gridData.get("LOTA06"); //재고상태
			var mnglt9 = gridData.get("MNGLT9"); //유통기한 관리여부
			var mngmov = gridData.get("MNGMOV"); //유통기한 관리여부
			var qtsiwh = gridData.get("QTSIWH"); //재고수량
			
			gridList.setColValue(gridId, rowNum, "AREAKY", areaky);
			gridList.setColValue(gridId, rowNum, "ZONEKY", zoneky);
			gridList.setColValue(gridId, rowNum, "ZONENM", zonenm);
			gridList.setColValue(gridId, rowNum, "LOCAKY", locaky);
			gridList.setColValue(gridId, rowNum, "LOTA06", lota06);
			gridList.setColValue(gridId, rowNum, "MNGLT9", mnglt9);
			gridList.setColValue(gridId, rowNum, "MNGMOV", mngmov);
			gridList.setColValue(gridId, rowNum, "QTSIWH", qtsiwh);
			gridList.setColValue(gridId, rowNum, "PRCQTY", qtsiwh);
			
		}else if( data.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(data);
			
			var returnData = skumaPopup.bindPopupData(data);
			var openType = returnData.get("openType");
			var gridId = returnData.get("gridId");
			var rowNum = returnData.get("rowNum");
			var colValue = returnData.get("colValue");
			
			if(openType == "grid"){
				gridListEventColValueChange(gridId, rowNum, "SKUKEY", colValue);
			}
		}
	}
	
	
	// 그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		newData.put("PRCUOM", "EA");
		newData.put("DUOMKY", "EA");
		return newData;
	}
	
	// 그리드 로우 삭제 이벤트
	function gridListEventRowRemove(gridId, rowNum){
		var grid = gridList.getRowData(gridId, rowNum);
		if( grid.get("GRowState") != "C" ){
			alert("새로 추가된 행만 삭제 가능합니다");
			return false;
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
			
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			param.put("WARECODE","Y"); //시스템일경우 Y 넘김
			param.put("WAREKY","<%=wareky%>");
			
			if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
// 				param.put("USARG1", "V");
				
			}else if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				param.put("USARG1", "V");

			}else if( name == "SKUCLS" ){
				param.put("CODE","SKUCLS");
			}
			
			return param;
			
		}else if( comboAtt == "WmsInventory,RSNADJCOMBO" ){
			param.put("WAREKY","<%=wareky%>");
			param.put("DOCUTY","450");
			
			return param;
		}
	}
	
	//컬럼데이터 바인드
	function setRowData(gridId, data, rowNum, type){
		for( var i in headCols ){
			var colName = headCols[i];
			var colValue = "";
			
			if( type == "init" ){
				if( colName == "WAREKY" ){
					colValue = "<%=wareky%>";
				}else if( colName == "PRCUOM" || colName == "DUOMKY" ){
					colValue = "EA";
				}else{
					colValue = "";
				}
			}else{
				colValue = data[colName];
			}
			
			gridList.setColValue(gridId, rowNum, colName, colValue);
		}
	}
	
	//해당컬럼만 변경
	function setRowColsData(gridId, data, rowNum, type){
		var cols = Object.keys(data);
		var len = cols.length;
		
		for( var i = 0; i < len; i++ ){
			var colName = cols[i];
			var colValue = "";
			
			if( type == "init" ){
				colValue = "";
			}else{
				colValue = data[colName];
				if( $.trim(data[colName]) == "" ){
					colValue = "";
				}
			}
			gridList.setColValue(gridId, rowNum, colName, colValue);
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList"){
			var param = dataBind.paramData("searchArea");
			if(param.get("QTYYN") == "V"){
				gridList.setReadOnly(gridId, true, ["SKUKEY", "LOTA06", "LOCAKY", "AREAKY", "SKUCLS"]);
			} else{
				gridList.setReadOnly(gridId, true, ["SKUKEY", "LOTA06", "LOCAKY", "AREAKY", "SKUCLS", "LOTA08", "LOTA09"]);
			}
			
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Create ADD BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_AREAKY"></th>
											<td>
												<select id="AREAKY" name="AR.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY"></th>
											<td>
												<input type="text" id="ZONEKY" name="LO.ZONEKY" UIInput="SR,SHZONMA" UIformat="U" />
											</td>
										</tr>
										<tr>
											<th CL="STD_LOCAKY"></th>
											<td>
												<input type="text" name="LO.LOCAKY" UIInput="SR,SHLOCMA" UIformat="U" />
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" id="SKUKEY" name="SU.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" />
											</td>
											<th CL="STD_ASKL01"></th>
											<td>
												<select id="AREAKY" name="SU.ASKL01" CommonCombo="ASKL01" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											
										</tr>
										<tr>
											<th CL="STD_QTYYNM">재고 '0'인 상품 조회</th>
											<td>
<!-- 												<select id="QTYYN" name="QTYYN" style="width:160px"> -->
<!-- 													<option value="Y">재고 존재</option> -->
<!-- 													<option value="N">재고 미존재</option> -->
<!-- 												</select> -->
												<input type="checkbox"  id="QTYYN" name="QTYYN" value="V" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" ><span CL="STD_LIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							
							<div class="reflect">
								조정사유
								<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false name="Reflect">
									<option value="">선택</option>
								</select>
								<button CB="Reflect REFLECT BTN_REFLECT"></button>
							</div>
							
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_SKUL01"   GCol="text,SKUL01"></td>
												<td GH="120 STD_SKUKEY"   GCol="input,SKUKEY,SHSKUMA"     validate="required"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY"    GCol="select,AREAKY">
													<select Combo="WmsAdmin,AREACOMBO" ComboCodeView=false name="AREAKY">
														<option value=""></option>
													</select>
												</td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"   GCol="text,ZONENM"></td>
												<td GH="80 STD_LOCAKY"    GCol="input,LOCAKY,SHGRID" validate="required"></td>
												<td GH="80 STD_LOTA06"    GCol="select,LOTA06">
													<select Combo="Common,COMCOMBO" name="LOTA06">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_QTSIWH"    GCol="text,QTSIWH"    GF="N"></td><!-- 재고수량 -->
												
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY"   GF="N 7"  validate="required"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM"            validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_QTVIWE"    GCol="text,QTVIWE"    GF="N"></td>
												<td GH="80 STD_QTADJU"    GCol="input,QTADJU"   GF="N 7"  validate="required"></td>
												<td GH="100 STD_RSNADJ,3" GCol="select,RSNADJ"            validate="required">
													<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_LOTL01"   GCol="text,LOTL01"/></td>
												<td GH="100 STD_LOTA08"   GCol="input,LOTA08"   GF="C"/></td>
												<td GH="100 STD_LOTA09"   GCol="input,LOTA09"   GF="C"/></td>
												<td GH="80 STD_SKUCNM"    GCol="select,SKUCLS">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="SKUCLS">
														<option value=""></option>
													</select>
												</td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"    GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"    GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"    GF="N"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 									<button type="button" GBtn="total"></button> -->
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>