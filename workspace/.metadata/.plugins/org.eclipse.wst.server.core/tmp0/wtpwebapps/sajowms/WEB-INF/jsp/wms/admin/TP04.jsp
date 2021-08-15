<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";
	
	$(document).ready(function() {
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "TP04H",
			pkcol : "SKUGRP",
			itemGrid : "gridItemList",
			itemSearch : true,
			selectRowDeleteType : false,
			autoCopyRowType : false
			
		});
			
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsAdmin",
			command : "TP04I",
			pkcol : "ASKL01",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
		
		gridList.appendCols("gridHeadList", ["WAREKY"]);
		gridList.appendCols("gridItemList", ["WAREKY", "SKUGNM"]);
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
			
		}else if(btnName == "Save"){
			saveData();
			
		}else if( btnName == "Create" ){ //생성버튼
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, false);
		
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName("gridHeadList", "WAHMA", "<%=wareky%>", "NAME01"));
			gridList.addNewRow("gridHeadList", newData);
			
			newData.put("SKUGNM", "");
			gridList.addNewRow("gridItemList", newData);
		}
	}
	
	//헤더 조회 
	function searchList() {
		gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, true);
		
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
	
	}
	
	//아이템조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		
		if( gridList.getRowState(gridId, rowNum) == "C"){
			return false;
		}
		
		var rowData = gridList.getRowData(gridId, rowNum);
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
	}
	
	//저장
	function saveData() {
		var headId = "gridHeadList";
		var itemId = "gridItemList";
		
		if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {//저장하시겠습니까?
			return;
		}
		
		if ( gridList.validationCheck(headId, "modify")
		  && gridList.validationCheck(itemId, "modify") ) {
			
			var head = gridList.getModifyList(headId, "A");
			var item = gridList.getModifyList(itemId, "A");
			var headStatus = gridList.getRowStatus(headId, gridList.getFocusRowNum(headId));
			
			if( head.length == 0 && item.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return false;
				
			}else if( headStatus == "C" && item.length == 0 ){
				commonUtil.msgBox("VALID_M9010"); //아이템 정보가 존재 하지 않습니다.
				return false;
			}
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			
			netUtil.send({
				url : "/wms/admin/json/saveTP04.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if (json) {
			if (json.data) {
				commonUtil.msgBox("VALID_M0001"); //저장이 성공하였습니다.
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				searchList();
			}
		}
	}
	
	//헤드 삭제시 서브도 날리기.
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.resetGrid("gridItemList");
		}
	}
	
	
	//그리드 행 추가 Before 이벤트
	function gridListEventRowAddBefore(gridId, rowNum) {
		if ( gridId == "gridHeadList" ) {
			
			var headCnt = gridList.getModifyRowCount("gridHeadList");
			var listCnt = gridList.getModifyRowCount("gridItemList");
			
			if( listCnt > 0 || headCnt > 0 ){
				commonUtil.msgBox("MASTER_M0804"); //변경된 row를 저장 후 행추가 하십시요.
				return false;
			}
			
			gridList.setReadOnly("gridHeadList", false, ["SKUGRP"]);
			
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			
			return newData;
			
			
		} else if ( gridId == "gridItemList" ) {
			
			if( gridList.getGridDataCount("gridHeadList") == 0 ){
				commonUtil.msgBox("MASTER_M4010"); //입고전략키를 입력해주세요.
				return false;
			}
			
			var headData = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			if ( headData.get("SKUGRP") == " " || headData.get("SKUGRP") == "" ) {
				commonUtil.msgBox("MASTER_M4013"); //상품군을 입력해주세요.
				return false;
				
			}
			
			gridList.setReadOnly("gridItemList", false, ["ASKL01"]);
			
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			newData.put("SKUGRP", headData.get("SKUGRP"));
			newData.put("SKUGNM", headData.get("SKUGNM"));
			
			return newData;
			
		}
	}
	
	//서치헬프 오픈이벤트
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		
		if(searchCode == "SHCMCDV"){
			param.put("CMCDKY", "ASKL01");
			
			return param;
			
		}
	}
	
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if (gridId == "gridHeadList" && colName == "SKUGRP") {
			
			var headWareky = gridList.getColData(gridId, rowNum, "WAREKY")
			
			var param = new DataMap();
			param.put("SKUGRP", colValue);
			param.put("WAREKY", headWareky);
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "SKUGRPCHK",
				sendType : "list",
				param : param
			});
			
			if ( json.data.length >= 1 ){
				commonUtil.msgBox("MASTER_M4014", colValue); //[{0}]는 존재하는 상품군입니다.
				gridList.setColValue(gridId, rowNum, "SKUGRP", "");
				gridList.setColValue(gridId, rowNum, "SKUGNM", "");
				
			}else if ( json.data.length < 1 ){
				var listCnt = gridList.getGridDataCount("gridItemList");
				for( var i=0; i<listCnt; i++ ){
					gridList.setColValue("gridItemList", i, "SKUGRP", colValue);
				}
			}
			
		}else if (gridId == "gridHeadList" && colName == "SKUGNM") {
			
			var listCnt = gridList.getGridDataCount("gridItemList");
			for( var i=0; i<listCnt; i++ ){
				gridList.setColValue("gridItemList", i, "SKUGNM", colValue);
			}
			
			
		}else if( gridId=="gridItemList" && colName=="ASKL01" ){
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, colName, "");
				gridList.setColValue(gridId, rowNum, "ASKLNM", "");
				return false;
			}
			
			var param = new DataMap();
			param.put("CMCDKY", colName);
			param.put("CMCDVL", colValue);
			
			//대분류 유무 확인
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "CMCDVOBJECT",
				sendType : "map",
				param : param
			});
			
			if(json && json.data){
				gridList.setColValue(gridId, rowNum, "ASKLNM", json.data["CDESC1"]);
			} else {
				commonUtil.msgBox("MASTER_M4012", colValue); //[{0}]은 존재하지 않는 대분류입니다.
				gridList.setColValue(gridId, rowNum, "ASKL01", "");
				gridList.setColValue(gridId, rowNum, "ASKLNM", "");
			}
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
			
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
		<div class="contentContainer">
		
			<div class="bottomSect top" style="height:70px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<tr>
												<th CL="STD_WAREKY"></th>
												<td>
													<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
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
						<li><a href="#tabs1-1"><span CL="STD_GENERAL"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"   GCol="text,NAME01"></td>
												<td GH="100 STD_SKUGRP"   GCol="input,SKUGRP" validate="required" GF="U 5"></td>
												<td GH="200 STD_SKUGNM"   GCol="input,SKUGNM" validate="required" GF="S 30"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
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
					<ul class="tab type2"  id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL="STD_ITEMLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_SKUGRP"   GCol="text,SKUGRP"></td>
												<td GH="100 STD_ASKL01"   GCol="input,ASKL01,SHCMCDV"  validate="required"  GF="S 2"></td>
												<td GH="200 STD_ASKLNM"   GCol="text,ASKLNM"  validate="required"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"   GCol="text,LMODAT"  GF="D"></td>
												<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM"  GF="T"></td>
												<td GH="100 STD_LMOUSR"   GCol="text,LMOUSR"></td>
												<td GH="100 STD_LUSRNM"   GCol="text,LUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
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
  <%@ include file="/common/include/bottom.jsp" %>

</body>
</html>