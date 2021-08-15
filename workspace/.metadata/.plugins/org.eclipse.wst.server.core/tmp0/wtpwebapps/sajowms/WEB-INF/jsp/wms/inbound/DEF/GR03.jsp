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
	var reSearchFlag = "NO"; //재조회 flag - 일반 : NO / 재조회 : OK
	var headCols = [];
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInbound",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
// 			pkcol : "DPTNKY"
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInbound",
			autoCopyRowType : true,
			headGrid : "gridHeadList",
			pkcol : "SKUKEY"
		});
		
		init();
	});
	
	// 초기셋팅
	function init(){
		//1.commonCombo 이름 가져오기
		var $comboList = $('#searchArea').find("select[Combo]");
		
		//3.조회시 그리드 add, delete 버튼 숨김
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, false);
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, false);
		uiList.setActive("Save", false); //저장버튼 숨김
		
		//4.상품코드 입력시 grid col name 가져오기
		headCols = [];
		var gridBox = gridList.getGridBox("gridItemList");
		headCols = gridBox.cols.slice(2);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "Save" ){ //저장
			saveData();
		
		}else if( btnName == "Create" ){ //생성
			uiList.setActive("Save", true);
			gridList.appendCols("gridItemList", ["SKUPACK"]);
			gridList.setReadOnly("gridItemList", false, ["LOTA06", "LOCAKY", "PRCQTY", "PRCUOM"]);
			gridList.setReadOnly("gridItemList", true, ["SKUCLS"]);
			createRow();
			
		}
	}
	
	//헤더 조회 
	function searchList(RECVKY){
		if( validate.check("searchArea") ){
			//버튼 hide 및 컬럼 readonly
			uiList.setActive("Save", false);
			gridList.setReadOnly("gridItemList", true, ["LOTA06", "LOCAKY", "PRCQTY", "PRCUOM", "SKUCLS"]);
			gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, false);
			gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, false);
			
			reSearchFlag = "NO"; //재조회 플래그
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("RECVKY", RECVKY);
			
			gridList.gridList({
				id : "gridHeadList",
				command : "GR03H",
				param : param
			});
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		
		// 생성일땐 더블클릭 안탐
		if( rowData.get("GRowState") == "C" ){
			return false;
		}
		
		if(reSearchFlag != "OK"){
			rowData.putAll(inputList.setRangeMultiParam("searchArea"));
		}
		
		gridList.gridList({
			id : "gridItemList",
			command : "GR03I",
			param : rowData
		});
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridHeadList", "modify")
			&& gridList.validationCheck("gridItemList", "modify") ){
			
			var head = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			var item = gridList.getModifyData("gridItemList", "A");
			var itemLen = item.length;
			
			if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M9010"); //아이템 정보가 존재 하지 않습니다.
				return;
			}
			
			head.put("RCPTTY", "130"); //입고유형
// 			head.put("DPTNTY", "V"); //거래처타입
			head.put("ASNDTY", "050"); //입고예정 문서타입
			head.put("WAREKY", "<%=wareky%>");
			head.put("OWNRKY", "<%=ownrky%>");
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("HHTTID", "WEB");
			
			netUtil.send({
				url : "/wms/inbound/json/SaveGR03.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			if( data.CNT > 0 ){
				commonUtil.msgBox("MASTER_M0815", data.CNT); //[{0}]이 저장되었습니다.
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				//저장건 재조회
				reSearchFlag = "OK"; //재조회
				searchList(data.RECVKY);
				
			}else if( data.CNT < 1 ){
				commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
			}
		}
	}
	
	// 생성버튼 클릭시
	function createRow(){
		resetGrid();
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, true);
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, true);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName("gridHeadList", "WAHMA", "<%=wareky%>", "NAME01"));
		
		gridList.addNewRow("gridHeadList", newData);
		
		newData.put("PRCUOM", "EA");
		newData.put("LOTA06", "00");
		gridList.addNewRow("gridItemList", newData);
	}
	
	//그리드 행 추가 Before 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		if( gridId == "gridItemList" ){
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			newData.put("UOMORD", "EA");
			newData.put("LOTA06", "00");
			
			return newData;
		}
	}
	
	// 그리드 로우 삭제 이벤트
	function gridListEventRowRemove(gridId, rowNum){
		var grid = gridList.getRowData(gridId, rowNum);
		if( grid.get("GRowState") != "C" ){
			commonUtil.msgBox("IN_M0019"); //새로 추가된 행만 삭제 가능합니다.
			return false;
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var ItemData = gridList.getRowData(gridId, rowNum);
		var rowState = ItemData.get("GRowState");
		var itemSkukey = ItemData.get("SKUKEY");
		
		if( gridId == "gridHeadList" ){
			if( colName == "DPTNKY" ){
				
				var param = new DataMap();
				param.put("DPTNKY", colValue);
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "PTNRKYNAME",
					sendType : "map",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					var dataLen = data.length;
					gridList.setColValue(gridId, rowNum, "DPTNNM", data.NAME01);
				}else{
					commonUtil.msgBox("IN_M0018"); //존재하지 않는 거래처입니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "DPTNNM", "");
				}
				
			}
		}else if( gridId == "gridItemList" ){
			var headRowNum = gridList.getFocusRowNum("gridHeadList");
			
// 			var headDptnky = gridList.getColData("gridHeadList", headRowNum, "DPTNKY")
// 			if( $.trim(headDptnky) == "" ){
// 				setRowData(gridId, gridId, rowNum, "init");
// 				commonUtil.msgBox("IN_M0020"); //거래처 코드를 입력해주세요.
// 				return false;
// 			}
			
			if( colName != "LOTA06" && $.trim(itemSkukey) == "" ){
				setRowData(gridId, gridId, rowNum, "init");
				commonUtil.msgBox("INV_M1016"); //상품코드를 입력해주세요.
				return false;
			}
			
			if( colName == "PRCUOM" ){//////////////////////////////////////단위////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
				gridList.setColValue(gridId, rowNum, "QTYORG", 0); //입고수량
				
			}else if( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
				var NumColValue = Number(colValue);
				var prcuom = ItemData.get("PRCUOM");
				
				//음수 입력 불가
				if( NumColValue <= 0 ){
					colChangeNum(gridId, rowNum);
					return false;
				}
				
				//수량 계산
				if( prcuom == "EA" ){
					gridList.setColValue(gridId, rowNum, "QTYORG", NumColValue); //실수량
					
				}else if( prcuom == "CS" ){//박스
					var csQty = Number(ItemData.get("BOXQTY")) * NumColValue;
					if( csQty == 0 ){
						colChangeNum(gridId, rowNum)
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTYORG", csQty); //입고수량
					
				}else if( prcuom == "IP" ){ //이너팩
					var ipQty = Number(ItemData.get("INPQTY")) * NumColValue;
					if( ipQty == 0 ){
						colChangeNum(gridId, rowNum)
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTYORG", ipQty); //입고수량
					
				}else if( prcuom == "PL" ){ //팔레트
					var plQty = Number(ItemData.get("PALQTY")) * NumColValue;
					if( plQty == 0 ){
						colChangeNum(gridId, rowNum)
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTYORG", plQty); //입고수량
				}
			}else if ( colName == "SKUKEY" ){ ////////////////////////////////상품코드////////////////////////////////
			
				var param = new DataMap();
				param.put("WAREKY", "<%=wareky%>");
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("LOTL04", "02");
				param.put("SKUKEY", colValue);
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "SKUMAINFO",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					var dataLen = data.length;
					
					if( dataLen > 0 ){
						setRowColsData(gridId, data[0], rowNum);
// 						gridList.setColValue(gridId, rowNum, "LOTA06", ItemData.get("LOTA06"));
						gridListEventColValueChange(gridId, rowNum, "LOTA06", ItemData.get("LOTA06")); //재고상태 컬럼체인지 바로 실행
						
					}else if( json.data.length <= 0 ){
						setRowData(gridId, data, rowNum, "init");
						alert("외부 사은품 상품이 아닙니다.");
					}
				}
				
			}else if ( colName == "LOCAKY" ){ ////////////////////////////////로케이션////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "AREAKY", "");
					gridList.setColValue(gridId, rowNum, "AREANM", "");
					gridList.setColValue(gridId, rowNum, "ZONEKY", "");
					gridList.setColValue(gridId, rowNum, "ZONENM", "");
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "MNGLT9", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("WAREKY", "<%=wareky%>");
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("SKUKEY", itemSkukey);
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
						var comboName = gridList.getGridBox("gridItemList").comboDataMap.get("LOTA06").get(ItemData.get("LOTA06")).split("]")[1];
						alert("[상품코드 : " + itemSkukey + " / 재고상태 : " + comboName+ " ]에 적합한 로케이션[ " + colValue + " ]이 아닙니다."); //상품코드/재고상태[/]에 적합한 로케이션[]이 아닙니다.
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
						alert("[ 상품코드 : " + itemSkukey + " ]에 적합한 로케이션[ " + colValue + " ]이 아닙니다."); //상품코드/재고상태[/]에 적합한 로케이션[]이 아닙니다.
						setRowData(gridId, data, rowNum, "init");
						
					}else if( data.length > 0 ){
						gridList.setColValue(gridId, rowNum, "AREAKY", data[0].AREAKY);
						gridList.setColValue(gridId, rowNum, "AREANM", data[0].SHORTX);
						gridList.setColValue(gridId, rowNum, "ZONEKY", data[0].ZONEKY);
						gridList.setColValue(gridId, rowNum, "MNGLT9", data[0].MNGLT9);
						
					}
				}
				
			}else if( colName == "LOTA06" ){ ////////////////////////////////재고상태////////////////////////////////
				if($.trim(ItemData.get("SKUKEY")) == ""){
					setRowData(gridId, data, rowNum, "init");
					return false;
				}
				
				var param = new DataMap();
				param.put("WAREKY", "<%=wareky%>");
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("SKUKEY", itemSkukey);
				param.put("LOTA06", colValue);
				param.put("PROGRM", "GR03");
				
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
						setRowData(gridId, data, rowNum, "init");
						var comboName = gridList.getGridBox("gridItemList").comboDataMap.get("LOTA06").get(colValue);
						alert("[상품코드 : " + itemSkukey + " / 재고상태 : " + comboName+ " ]에 적합한 로케이션이 없습니다."); //상품코드/재고상태[/]에 적합한 로케이션이 없습니다.)
// 						gridList.setColValue(gridId, rowNum, colName, "00");
					}else{
						gridList.setColValue(gridId, rowNum, "ZONEKY", data["ZONEKY"]);
						gridList.setColValue(gridId, rowNum, "AREAKY", data["AREAKY"]);
						gridList.setColValue(gridId, rowNum, "AREANM", data["AREANM"]);
						gridList.setColValue(gridId, rowNum, "LOCAKY", data["LOCAKY"]);
					}
				}
			}////////////////////////////////////////////////////////////////////////////////////////////////////
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
				}else if( colName == "LOTA06" ){
					colValue = "00";
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
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum){
		gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
		gridList.setColValue(gridId, rowNum, "QTYORG", 0); //입고수량
		gridList.setColValue(gridId, rowNum, "PRCUOM", "EA"); //단위
		
		commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다.
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		if( searchCode == "SHBZPTN" ){
			param.put("PTNRTY","V");
			return param;
			
		}else if( searchCode == "SHLOCMA" && ($inputObj.name == undefined) && (rowNum != undefined) ){
			var param = new DataMap();
			param.put("gridId", "gridItemList");
			param.put("rowNum", rowNum);
			param.put("multyType", multyType);
			param.put("WAREKY", "<%=wareky%>");
			param.put("WARENM", gridList.getColData("gridHeadList", 0, "WARENM"));
			param.put("SKUKEY", gridList.getColData("gridItemList", rowNum, "SKUKEY"));
			param.put("progId", "GR03");
			
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
		var areanm = data.map.data.get("AREANM"); //AREA명
		var zoneky = data.map.data.get("ZONEKY"); //존
		var locaky = data.map.data.get("LOCAKY"); //로케이션
		var lota06 = data.map.data.get("LOTA06"); //재고상태
		var mnglt9 = data.map.data.get("MNGLT9"); //유통기한 관리여부
		
		gridList.setColValue(gridId, rowNum, "AREAKY", areaky);
		gridList.setColValue(gridId, rowNum, "AREANM", areanm);
		gridList.setColValue(gridId, rowNum, "ZONEKY", zoneky);
		gridList.setColValue(gridId, rowNum, "LOCAKY", locaky);
		gridList.setColValue(gridId, rowNum, "LOTA06", lota06);
		gridList.setColValue(gridId, rowNum, "MNGLT9", mnglt9);
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if( name == "UOMORD" ){
				param.put("CODE", "UOMKEY");
				
			}else if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				param.put("USARG1", "V");

			}else if( id == "SKUCLS" ){
				param.put("WARECODE", "Y");
				param.put("CODE", "SKUCLS");
			}
			
			return param;
		}
	}
	
	// 그리드 리셋
	function resetGrid(){
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
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
		
			<div class="bottomSect top" style="height:70px" id="searchArea">
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
											<th CL="STD_CREDAT"></th>
											<td>
												<input type="text" name="RH.CREDAT" UiRange="2" UIInput="B" UIFormat="C N" MaxDiff="M1" />
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="RI.SKUKEY" UIInput="SR,SHSKUMAEX" />
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
						<li><a href="#tabs1-3" ><span CL="STD_GENERAL"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_RECVKY"    GCol="text,RECVKY"></td>
												<td GH="100 STD_WAREKY"    GCol="text,NAME01"></td><!-- 물류센터 -->
<!-- 												<td GH="100 STD_PTNRKY"    GCol="input,DPTNKY,SHBZPTN"  validate="required"></td> -->
<!-- 												<td GH="130 STD_PTNRNM"    GCol="text,DPTNNM"></td> -->
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td><!-- 생성일자 -->
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td><!-- 생성시간 -->
												<td GH="100 STD_CREUSR"    GCol="text,CREUSR"></td><!-- 생성자명 -->
												<td GH="100 STD_CUSRNM"    GCol="text,CUSRNM"></td>
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
						<li><a href="#tabs1-4" ><span CL="STD_RESKUNM"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="80 STD_LOTA06"    GCol="select,LOTA06"         validate="required">
													<select Combo="Common,COMCOMBO" name="LOTA06" ComboCodeView=false>
													</select>
												</td>
												<td GH="130 STD_SKUKEY"   GCol="input,SKUKEY,SHSKUMAEX"  validate="required"></td>
												<td GH="240 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY"   GCol="text,AREANM"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												
												<td GH="100 STD_LOCAKY"   GCol="input,LOCAKY,SHLOCMA"></td>
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY" GF="N 7"  validate="required gt(0),MASTER_M4002"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM"          validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="UOMORD">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_QTYRCV"    GCol="text,QTYORG"  GF="N"></td>
												
												<td GH="80 STD_SKUCNM"    GCol="select,SKUCLS">
													<select Combo="Common,COMCOMBO" ComboCodeView=false  id="SKUCLS" name="SKUCLS">
														<option value=""></option>
													</select>
												</td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												
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