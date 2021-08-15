<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "200px";
	var todayDate;
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInbound",
			command : "GR02H",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInbound",
			command : "GR02I",
			autoCopyRowType : false,
			headGrid : "gridHeadList"
		});
		
		gridList.setGrid({
			id : "gridSubList",
			editable : true,
			module : "WmsInbound",
			command : "GR02SUB",
			autoCopyRowType : false,
			emptyMsgType : false
		});
		
		init();
	});
	
	function init(){
		//그리드 컬럼 리드온리
		gridList.setReadOnly("gridItemList", true, ["ENDMAK"]);
		gridList.appendCols("gridItemList", ["SALESK", "PACQTY", "PACKYN"]);
		
		$("#STATUS").val("NEW"); //검색조건 입고상태 : 미작업
		$("#ENDMAK").val("N"); //검색조건 마감여부 : 미마감
		
		//오늘날짜
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "asdSave" ){ //입고완료
			saveData("asdSave");
			
		}else if( btnName == "asdLabel" ){ //입고라벨
			print("label");
			
		}else if( btnName == "asdList" ){ //입고리스트
			print("list");
		
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	//헤더 재 조회 
	function reSearchList(data){
		var param = new DataMap();
		param.put("SVBELN", data);
		param.put("WAREKY", "<%=wareky%>");
		param.put("RESERCH", "OK");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
		
		gridList.gridList({
			id : "gridSubList",
			param : rowData
		});
		
	}
	
	//저장
	function saveData(saveFlag){
		if( gridList.validationCheck("gridItemList", "select") ){
			var head = gridList.getSelectData("gridHeadList", "A");
			var headLen = head.length;
			var item = gridList.getSelectData("gridItemList", "A");
			var itemLen = item.length;
			var param = new DataMap();
			var date_flag = "";
			
			if( headLen > 1 ){ //헤더 두개이상 선택시
				var sameAsndky;
				var itemAsndky = item[0].get("ASNDKY");
				for( var i=0; i<headLen; i++ ){
					var headAsndky = head[i].get("ASNDKY");
					if( headAsndky == itemAsndky ){
						sameAsndky = [head[i]];
					}
				}
				param.put("head", sameAsndky);
				
			}if( headLen == 1 ){
				param.put("head", head);
				
			}else if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return;
			}
			
			//입고통제일 확인
			for( var i=0; i<itemLen; i++ ){
				var mngmov = item[i].get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = item[i].get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = item[i].get("LOTL01"); //skuma 유통기한 관리여부
				var lotl02 = item[i].get("LOTL02"); //입고통제기준코드
				var lota06 = item[i].get("LOTA06"); //재고상태
				var lota08 = item[i].get("LOTA08"); //제조일자
				var lota09 = item[i].get("LOTA09"); //유통기한
				var skukey = item[i].get("SKUKEY");
				var locaky = item[i].get("LOCAKY");
				
				//로케이션을 선택해주세요.
				if( $.trim(locaky) == "" ){
					commonUtil.msgBox("IN_M0006");
					return false;
				}
				
				//유통기한 필수입력 상품입니다.
				if( lota06 == "00" || lota06 == "10" ){
					if( mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" ){
						if( $.trim(lota09) == "" ){
							commonUtil.msgBox("IN_M0012");
							return false;
						}
					}
				}
				
				//lotl02(입고기준구분코드) 입고 통제일 조회(1:유통기한 / 2:제조일자)
				if( lotl01 == "Y" && lotl02 == "1" || lotl01 == "Y" && lotl02 == "2" ){
					if( $.trim(lota09) != "" ){
						var rcvParam = new DataMap();
						rcvParam.put("LOTA08", lota08);
						rcvParam.put("LOTA09", lota09);
						rcvParam.put("SKUKEY", skukey);
						
						//입고통제일 확인
						var json = netUtil.sendData({
							module : "WmsInbound",
							command : "RCV_DAT",
							sendType : "map",
							param : rcvParam
						});
						
						if( json.data["DAT_FLAG"] != "OK" ){
							if( !confirm("상품코드["+ skukey +"]는 입고통제일을 초과했습니다. 그래도 입고 진행하시겠습니까?") ){
								return false;
							}else{
								date_flag = "Y";
							}
						}
					}
				}
			}
			
			param.put("item", item);
			param.put("HHTTID", "WEB");
			param.put("saveFlag", saveFlag);
			
			
			if ( date_flag != "Y" ){
				//입고완료 하시겠습니까?
				if( !commonUtil.msgConfirm("IN_M0014") ){
					return false;
				}
			}
			
		}else{
			return false;
		}
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR01.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			
			if( data ){
				commonUtil.msgBox(data.msg);
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				searchList();
				
				//저장건 재조회
// 				if(data.reKey == "OK"){
// 					reSearchList(data.key);
// 				}
				
			}else if( !data ){
				commonUtil.msgBox("MASTER_M0101"); //저장에 실패 하였습니다. 관리자에게 문의 하세요. 내역:[{0}]
			}
		}
	}
	
	//입고취소
	function cancel(){
		var head = gridList.getSelectData("gridHeadList", "A");
		var item = gridList.getSelectData("gridItemList", "A");
		var headLen = head.length;
		var itemLen = item.length;
		
		if( headLen > 1 ){
			commonUtil.msgBox("IN_M0007"); //한 개의 센터를 선택해주세요.
			return;
			
		}else if( itemLen == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		if( gridList.validationCheck("gridItemList", "select") ){
			if( !commonUtil.msgConfirm("IN_M0030") ){ //입고취소 하시겠습니까?
				return false;
			}
		}else{
			return false;
		}
		
		var param = new DataMap();
		param.put("head", head);
		param.put("item", item);
		param.put("ADJUTY", "480");
		param.put("proId", "GR02");
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR09.data",
			param : param,
			successFunction : "succsessCancelCallBack"
		});
		
	}
	
	function succsessCancelCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			
			if( data ){
				alert("저장에 성공하였습니다.");
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				searchList();
				
			}else if( !data ){
				commonUtil.msgBox("MASTER_M0101"); //저장에 실패 하였습니다. 관리자에게 문의 하세요. 내역:[{0}]
			}
		}
		
	}
	

	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var ItemData = gridList.getRowData(gridId, rowNum);
		
		if( gridId == "gridItemList" ){
			if( colName == "PRCUOM" ){//////////////////////////////////////단위////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
				gridList.setColValue(gridId, rowNum, "QTVIWE", 0); //입고수량
				
			}else if( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
				
				var NumColValue = Number(colValue);
				var rcvqty = Number(ItemData.get("RCVQTY")); //입고가능 (낱개) 수량
				var prcuom = ItemData.get("PRCUOM"); //단위
				
				//음수 입력 불가
				if( NumColValue < 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량 계산
				if( prcuom == "EA" ){
					gridList.setColValue(gridId, rowNum, "QTVIWE", NumColValue); //실수량
					
					if( NumColValue > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
				}else if( prcuom == "CS" ){//박스
					var csQty = Number(ItemData.get("BOXQTY")) * NumColValue;
					if( csQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( csQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", csQty); //입고수량
					
				}else if( prcuom == "IP" ){ //이너팩
					var ipQty = Number(ItemData.get("INPQTY")) * NumColValue;
					if( ipQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( ipQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", ipQty); //입고수량
					
				}else if( prcuom == "PL" ){ //팔레트
					var plQty = Number(ItemData.get("PALQTY")) * NumColValue;
					if( plQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( plQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", plQty); //입고수량
				}
			}else if ( colName == "LOTA08" ){ /////////////////////////////제조일자////////////////////////////////////////////
				// 오늘일자 < 제조일자
				if( todayDate < colValue ){
					commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("ALOTA08", colValue);
				param.put("DUEMON", ItemData.get("DUEMON"));
				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
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
				
			}else if ( colName == "LOTA09" ){ /////////////////////////////유통기한////////////////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "LOTA08", "");
				
// 				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
// 					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
// 					gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 					gridList.setColValue(gridId, rowNum, colName, "");
// 					return false;
// 				}
				
// 				var param = new DataMap();
// 				param.put("ALOTA09", colValue);
// 				param.put("DUEMON", ItemData.get("DUEMON"));
// 				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
// 				var json = netUtil.sendData({
// 					module : "WmsInventory",
// 					command : "SJ01DATE",
// 					sendType : "list",
// 					param : param
// 				});
				
// 				//일자체크
// 				if( json && json.data ){
					
// 					// 오늘일자 < 제조일자
// 					if( todayDate < json.data[0].DUEDAY ){
// 						commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
// 						gridList.setColValue(gridId, rowNum, colName, "");
// 						gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 						return false;
// 					}
					
// 					if( json.data[0].DUEDAY != colValue ){
// 						gridList.setColValue(gridId, rowNum, "LOTA08", json.data[0].DUEDAY);
// 					}
// 				}
			}else if ( colName == "LOTA06" || colName == "LOCAKY" ){ /////////////////////////////재고상태////////////////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "LOCAKY", "");
					gridList.setColValue(gridId, rowNum, "AREAKY", "");
					gridList.setColValue(gridId, rowNum, "MNGLT9", "");
					gridList.setColValue(gridId, rowNum, "LOTA06", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("WAREKY", ItemData.get("WAREKY"));
				
				if( colName == "LOTA06" ){
					param.put("LOTA06", colValue);
					
					if( colValue == "00" || colValue == "10" ){
						param.put("VALUE", "OK");
						param.put("SKUKEY", ItemData.get("SKUKEY"));
					}
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "GR02_LOTA06",
						sendType : "list",
						param : param
					});
					
				}else if ( colName == "LOCAKY" ){
					param.put("LOCAKY", colValue);
					param.put("SKUKEY", ItemData.get("SKUKEY"));
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "GR02_LOCAKY",
						sendType : "list",
						param : param
					});
				}
				
				//일자체크
				if( json && json.data ){
					if( json.data.length > 0 ){
						gridList.setColValue(gridId, rowNum, "LOCAKY", json.data[0].LOCAKY);
						gridList.setColValue(gridId, rowNum, "AREAKY", json.data[0].AREAKY);
						gridList.setColValue(gridId, rowNum, "MNGLT9", json.data[0].MNGLT9);
						gridList.setColValue(gridId, rowNum, "LOTA06", json.data[0].LOTA06);
						gridList.setColValue(gridId, rowNum, "MNGMOV", json.data[0].MNGMOV);
					}else{
						alert("해당 로케이션을 찾을 수 없습니다.");
						gridList.setColValue(gridId, rowNum, "LOCAKY", "");
						gridList.setColValue(gridId, rowNum, "AREAKY", "");
						gridList.setColValue(gridId, rowNum, "MNGLT9", "");
						gridList.setColValue(gridId, rowNum, "LOTA06", "");
						gridList.setColValue(gridId, rowNum, "MNGMOV", "");
					}
				}
			}
		}
	}
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
		gridList.setColValue(gridId, rowNum, "QTVIWE", "0");
		
		if(select == "N"){
			commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다
			
		}else if( select == "S" ){
			commonUtil.msgBox("IN_M0017"); //수량(낱개)은 입고가능(낱개) 갯수보다 클 수 없습니다.
		}
	}
	
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridSubList");
			
		}else if( gridId == "gridItemList" && dataLength > 0 ){
			
			// 그리드 로우 리드온리
			for( var i=0; i<dataLength; i++ ){
				var rowData = gridList.getRowData(gridId, i);
				var lotl01 = rowData.get("LOTL01");
				var endmak = rowData.get("ENDMAK");
				var rcvqty = Number(rowData.get("RCVQTY")); //입고가능(낱개)
				
				// 유통기한 관리 안하는 상품은 readonly
				if( lotl01 == "N" ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA08", "LOTA09"]);
				}
				
				// 마감완료된 건은 수정불가
				if( endmak == "Y" ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA06", "LOCAKY", "LOTA08", "LOTA09", "PRCQTY", "PRCUOM"]);
				}
				
				// 입고가능 갯수가 0이면 수정 불가
				if( rcvqty == 0 ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA06", "LOCAKY", "LOTA08", "LOTA09", "PRCQTY", "PRCUOM"]);
				}
				
			}
		}
	}
	
	// 서치헬프 오픈이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if( (searchCode == "SHLOCMA") && ($inputObj.name == undefined) && (rowNum != undefined) ){
			var param = new DataMap();
			param.put("gridId", "gridItemList");
			param.put("rowNum", rowNum);
			param.put("multyType", multyType);
			param.put("WAREKY", gridList.getColData("gridHeadList", 0, "WAREKY"));
			param.put("WARENM", gridList.getColData("gridHeadList", 0, "WARENM"));
			param.put("SKUKEY", gridList.getColData("gridItemList", rowNum, "SKUKEY"));
			
			var option = "height=600,width=800,resizable=yes";
			page.linkPopOpen("/wms/inbound/POP/GR02_LOCMA_POP.page", param, option);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		var gridId = data.map.gridId;
		var rowNum = data.map.rowNum;
		var areaky = data.map.data.get("AREAKY"); //AREA
		var locaky = data.map.data.get("LOCAKY"); //로케이션
		var lota06 = data.map.data.get("LOTA06"); //재고상태
		var mnglt9 = data.map.data.get("MNGLT9"); //유통기한 관리여부
		
		gridList.setColValue(gridId, rowNum, "AREAKY", areaky);
		gridList.setColValue(gridId, rowNum, "LOCAKY", locaky);
		gridList.setColValue(gridId, rowNum, "LOTA06", lota06);
		gridList.setColValue(gridId, rowNum, "MNGLT9", mnglt9);
	}
	
	
	// 선택 활성화 : 회수여부(CARCMP) = 'Y' 건만 입고 가능
// 	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
// 		if( gridId == "gridItemList" ){
// 			var headRowNum = gridList.getFocusRowNum("gridHeadList");
// 			var tmscmp = gridList.getColData("gridHeadList", headRowNum, "TMSCMP"); //회수여부
// 			var rcvqty = $.trim(gridList.getColData(gridId, rowNum, "RCVQTY")); //입고가능(낱개)
// 			var endmak = gridList.getColData(gridId, rowNum, "ENDMAK"); //마감여부
			
// 			if( tmscmp == "N" || rcvqty == "0" || endmak == "Y" ){
// 				return true;
// 			}
// 		}
// 	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "STATUS" ){
				param.put("CODE","RCVSTATDO");
				param.put("USARG1", "V");
				
			}else if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
				
			}else if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				param.put("USARG3", "V");
			}
			
			return param;
		}
	}
	
	//입고라벨 / 입고예정리스트 프린트
	function print(btnName){
		var head = gridList.getSelectData("gridHeadList");
		if ( head.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		var param = dataBind.paramData("searchArea");
		param.put("PROGID", configData.MENU_ID);
		param.put("PRTCNT", 1);
		param.put("head", head);
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/printGR01.data",
			param : param
		});
		
		if( btnName == "list" ){
			if ( json && json.data ){
				var url = "<%=systype%>" + "/input_gr01_list.ezg";
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  600;
				var heigth = 800;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}else if(  btnName == "label" ){
			if ( json && json.data ){
				var url = "<%=systype%>" + "/input_gr01_list.ezg"; //변경하기
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  600;
				var heigth = 800;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}
	}
	
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="asdSave REFLECT BTN_ASDFIN"></button>
<!-- 		<button CB="asdLabel PRINT BTN_ASDLAB"></button> -->
		<button CB="asdList PRINT BTN_ASDLIST"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" style="height:130px" id="searchArea">
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
										<col width="450" />
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
											<th CL="STD_VHDDAT">회수예정일자</th>
											<td>
												<input type="text" name="AO.DOCDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_RCPSTU">입고상태</th>
											<td>
												<select Combo="Common,COMCOMBO" name="STATUS" id="STATUS" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_SVBELN">주문번호</th>
											<td>
												<input type="text" name="AO.SVBELN" UIInput="SR" />
											</td>
											<th CL="STD_REFCAR">배차ID</th>
											<td>
												<input type="text" name="AO.REFCAR" UIInput="SR" />
											</td>
											<th CL="STD_VEHINO">차량번호</th>
											<td>
												<input type="text" name="AO.VEHINO" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUKEY">상품코드</th>
											<td>
												<input type="text" name="AO.SKUKEY" UIInput="SR" />
											</td>
											<th CL="STD_ENDMAK">마감여부</th>
											<td>
												<select id="ENDMAK" name="ENDMAK" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
													<option value="N">미마감</option>
													<option value="Y">마감완료</option>
												</select>
											</td>
											
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-3" ><span CL="STD_RECDLI"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td>
												<td GH="100 STD_VHDDAT"    GCol="text,DOCDAT"  GF="D"></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"></td>
												<td GH="100 STD_REFCAR"    GCol="text,REFCAR"></td>
												<td GH="100 STD_STARNM"    GCol="text,STARNM"></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"></td>
												<td GH="100 STD_DRIVNM"    GCol="text,DRIVER"></td>
												<td GH="100 STD_CARCMP"    GCol="text,CARCMP,center"></td>
												<td GH="100 STD_TMSCMP"    GCol="text,TMSCMP,center"></td>
												<td GH="100 STD_RCPSTU"    GCol="text,RCVSATANM"></td>
												<td GH="100 STD_ASNDKY,3"  GCol="text,ASNDKY"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 													<button type="button" GBtn="total"></button> -->
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
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-4" ><span CL="STD_ITEMLIST"></span></a></li>
						<li><a href="#tabs1-5" ><span CL="STD_DTITEM"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_RCPTTY"   GCol="text,ASNTNM"></td>
												<td GH="130 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="240 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_QTYASN"   GCol="text,QTYASN"  GF="N"></td>
												<td GH="100 STD_QTYOEA"   GCol="text,QTYORG"  GF="N"></td>
												<td GH="100 STD_QTYREA"   GCol="text,QTYRCV"  GF="N"></td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												<td GH="100 STD_RCVQTY"   GCol="text,RCVQTY"  GF="N"></td>
												<td GH="100 STD_RCVQOM,3" GCol="text,QTYORD"  GF="N"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM" validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
													</select>
												</td>
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY" GF="N 7" validate="required gt(0),MASTER_M4002"></td>
												<td GH="80 STD_QTYRCV"    GCol="text,QTVIWE"  GF="N"></td>
												<td GH="80 STD_LOTL01"    GCol="text,LOTL01"></td>
												<td GH="80 STD_LOTA06"    GCol="select,LOTA06" validate="required">
													<select Combo="Common,COMCOMBO" name="LOTA06" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_LOCAKY"   GCol="input,LOCAKY,SHLOCMA" validate="required"></td>
												<td GH="100 STD_LOTA08"   GCol="input,LOTA08" GF="C"></td>
												<td GH="100 STD_LOTA09"   GCol="input,LOTA09" GF="C"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												<td GH="100 STD_SVBELN"   GCol="text,SVBELN"></td>
												<td GH="100 STD_STRAID,3" GCol="text,STRAID"></td>
												<td GH="100 STD_REFCAR"   GCol="text,REFCAR"></td>
												<td GH="100 STD_SPOSNR"   GCol="text,SPOSNR"></td>
												<td GH="100 STD_ENDMAK"   GCol="text,ENDMAK,center"></td>
												<td GH="100 STD_RECDAT"   GCol="text,RECDAT"  GF="C"></td>
												<td GH="100 STD_RECTIM"   GCol="text,RECTIM"  GF="T"></td>
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 													<button type="button" GBtn="total"></button> -->
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					
					<div id="tabs1-5">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridSubList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="100 STD_RCPTTY"   GCol="text,ASNTNM"></td>
												<td GH="130 STD_SKUKEY"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_DESC01"   GCol="text,ASNDS1"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,SKUGRD"></td>
												<td GH="100 STD_QTYRCV"   GCol="text,QTYRCV" GF="N"></td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LO06NM"></td>
												<td GH="100 STD_AREAKY"   GCol="text,AREAKY"></td>
												<td GH="100 STD_ZONEKY"   GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"   GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08" GF="C"></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09" GF="C"></td>
												<td GH="100 STD_SVBELN"   GCol="text,SVBELN"></td>
												<td GH="100 STD_STRAID,3" GCol="text,STRAID"></td>
												<td GH="100 STD_REFCAR"   GCol="text,REFCAR"></td>
												<td GH="100 STD_SPOSNR"   GCol="text,SPOSNR"></td>
												<td GH="100 STD_ENDMAK"   GCol="text,ENDMAK,center"></td>
												<td GH="100 STD_RECVKY"   GCol="text,RECVKY"></td>
												<td GH="100 STD_REITEM"   GCol="text,RECVIT"></td>
												<td GH="100 STD_RECDAT"   GCol="text,CREDAT" GF="C"></td>
												<td GH="100 STD_RECTIM"   GCol="text,CRETIM" GF="T"></td>
												<td GH="100 STD_RECDID"   GCol="text,CREUSR"></td>
												<td GH="100 STD_RECUSR"   GCol="text,CUSRNM"></td>
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 													<button type="button" GBtn="total"></button> -->
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