<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			editable : true,
			pkcol : "WAREKY,ZONEKY",
			module : "WmsAdmin",
			command : "ZONMA",
			validation : "WAREKY,AREAKY,ZONEKY",
			validationType : "C"
	    });
		
		gridList.setGrid({
	    	id : "gridListItem",
			editable : true,
			pkcol : "WAREKY,ZONEKY",
			module : "WmsAdmin",
			command : "ZONMA",
			validation : "WAREKY,AREAKY,ZONEKY",
			validationType : "C"
	    });
		
		$("#CTest").datepicker({
		      showButtonPanel: true,
		      dateFormat: site.COMMON_DATE_TYPE_UI 
	    });
		
		$("#CTest").datepicker(
			$.datepicker.regional[ "ko" ]
	    );
	});
	
	function searchList(){
		//uiList.setActive("Search", false);
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			//inputList.appendRangeParam(param, "AREAKY", "TEST");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			gridList.gridList({
		    	id : "gridListItem",
		    	param : param
		    });
		}
		uiList.setActive("Wcancle", true);
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var param = dataBind.paramData("searchArea");
			var json = gridList.gridSave({
		    	id : "gridList",
		    	param : param
		    });
			
			//alert(json);
			if(json && json.data){
				searchList();
			}
		}		
	}
	
	function createData(){
		alert(createData);
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		//alert(gridId+" "+rowNum);
	}
	
	function gridListEventRowAddBefore(gridId, rowNum, beforeData){
		var zonetyt = inputList.getComboData("ZONETY", "STOR");
		var areakyt = inputList.getComboData("WmsAdmin_AREAKYCOMBO", "MMM");
		
		var newData = dataBind.paramData("searchArea");
		newData.put("ZONETY", "STOR");
		newData.put("ZONETYT", zonetyt);
		newData.put("AREAKY", "MMM");
		newData.put("AREAKYT", areakyt);
		
		return newData;
	}
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		//commonUtil.debugMsg("gridListEventRowCheck : ", arguments);
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		//commonUtil.debugMsg("gridListEventRowCheckAll : ", arguments);
	}
	
	function gridListEventRowRemove(gridId, rowNum){
		//commonUtil.debugMsg("gridListEventRowRemove : ", arguments);
		return true;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		//commonUtil.debugMsg("gridListEventRowDblclick : ", arguments);
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		//commonUtil.debugMsg("gridListEventColValueChange : ", arguments);
		if(gridId == "gridList"){
			//uiList.setActive("Save", true);
		}
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		//commonUtil.debugMsg("gridListEventRowFocus : ", arguments);
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		//commonUtil.debugMsg("gridListEventDataBindEnd : ", arguments);
	}
	
	function gridListEventDataViewEnd(gridId, dataLength){
		//commonUtil.debugMsg("gridListEventDataViewEnd : ", arguments);
		if(gridId == "gridList"){
			//uiList.setActive("Search", true);
		}
	}
	
	function validationEventMsg(valObjType, objIndex, objId, objName, objValue, valType){
		//commonUtil.debugMsg("validationEventMsg : ", arguments);
		if(valObjType == configData.VALIDATION_OBJECT_TYPE_GRID){
			if(objId == "gridList" && objName == "WAREKY,ZONEKY" && valType == configData.VALIDATION_DUPLICATION){
				var param = new Array();
				param.push(objValue);
				return commonUtil.getMsg("MASTER_M0017", param);
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		/*
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			var param = new DataMap();
			param.put("WAREKY", "PMS0");
			return param;
		}
		*/
	}
	
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		//commonUtil.debugMsg("searchHelpEventCloseAfter : ", arguments);
	}
	
	function gridListEventColBtnClick(gridId, rowNum, colName){
		commonUtil.debugMsg("gridListEventColBtnClick : ", arguments);
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Omcopy"){
			test8();
		}else if(btnName == "Execute"){
			test10();
		}else if(btnName == "Pencil"){
			test();
		}else if(btnName == "Expand"){
			test(false);
		}else if(btnName == "Reflect"){
			test6();
		}else if(btnName == "Check"){
			test7();
		}else if(btnName == "Print"){
			showClipSave();
		}else if(btnName == "Left"){
			dataMove("gridSubList", "gridList");
		}else if(btnName == "Right"){
			dataMove("gridList", "gridSubList");
		}
	}
	function dataMove(sourceGridId, targetGridId){
		var selectList = gridList.getSelectData(sourceGridId);
		var rowData;
		var rowNum;
		for(var i=0;i<selectList.length;i++){
			rowData = selectList[i];
			rowNum = rowData.get(configData.GRID_ROW_NUM);
			gridList.addNewRow(targetGridId, rowData);
			gridList.deleteRow(sourceGridId, rowNum, false);
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		//commonUtil.debugMsg("gridExcelDownloadEventBefore : ", arguments);
		var param = inputList.setRangeParam("searchArea");
		param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "zone");
		//param.put("url", "/sample/WmsAdmin/excel/ZONMA.data");//공통 처리가 아닌경우 사용
		return param;
	}
	
	function commonShortKeyEvent(keyCode, keyCodeChar){
		//commonUtil.debugMsg("commonShortKeyEvent : ", arguments);
		/*
		if(keyCode == configData.COMMON_KEY_EVENT_SEARCH_CODE){
			searchList();
		}else if(keyCode == configData.COMMON_KEY_EVENT_SAVE_CODE){
			saveData();
		}
		*/
	}
	
	/*
	function zonekyCheck(valueTxt, $colObj){
		var rowNum = gridList.getColObjRowNum("gridList", $colObj);
		var rowCount = gridList.getGridDataCount("gridList");
		for(var i=0;i<rowCount;i++){
			if(i != rowNum){
				var zoneky = gridList.getColData("gridList", i, "ZONEKY");
				if(zoneky == valueTxt){
					return false;
				}
			}			
		}
		
		return true;
	}
	*/
	function test(readonlyType){
		gridList.setReadOnly("gridList", readonlyType);
	}
	
	function test1(readonlyType){
		gridList.removeUnselect("gridList");
	}
	function test2(){
		gridList.checkAll("gridList", true);
	}
	function test3(){
		var singleList = inputList.getRangeData("AREAKY", configData.INPUT_RANGE_TYPE_SINGLE);
		alert(singleList);
		var rangeList = inputList.getRangeData("AREAKY", configData.INPUT_RANGE_TYPE_RANGE);
		alert(rangeList);
	}
	
	function test4(){
		var json = netUtil.sendData({
			url : "/IF/list/json/TEST.data"
		});
		alert(json);
	}
	
	function test5(){
		var json = netUtil.sendData({
			url : "/common/IF/list/json/TEST.data"
		});
		alert(json);
	}
	
	function test6(){
		//inputList.resetRange();
		inputList.resetRange("NAME01");
	}
	
	function test7(){
		gridList.addSort("gridList", "SHORTX", true, true);
	}
	
	function test8(){
		gridList.setRowReadOnly("gridList", 0);
	}
	
	function test9(){
		var cols = new Array();
		cols.push("ZONETY");
		
		gridList.setRowReadOnly("gridList", 1, cols);
	}
	
	function test10(){
		gridList.setRowReadOnly("gridList", 0, false);
	}
	
	function test11(){
		alert(JSON.stringify(Browser));
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Execute EXECUTE BTN_EXECUTE" CS="E"></button>
		<button CB="Omcopy ADD BTN_ADD"></button>
		<button CB="Pencil PENCIL BTN_PENCIL">
			Pencil Copy
		</button>
		<button CB="Expand EXPAND BTN_EXPAND">
			Expand
		</button>
		<button CB="Reflect REFLECT BTN_REFLECT"></button>
		<button CB="Check CHECK BTN_CLOSE"></button>
		<button CB="Print PRINT BTN_PRINT"></button>
		<button CB="Send SEND BTN_ERPSEND"></button>
		<button CB="Work WORK STD_PICKYN"></button>
		<button CB="Speak SPEAK BTN_PUTAWAY"></button>
		<button CB="File FILE BTN_CRFILE"></button>
		<button CB="Copy COPY BTN_OMCOPY"></button>
		<button CB="Up UP BTN_UPBTTN"></button>
		<button CB="Down DOWN BTN_DONBTN"></button>
		<button CB="Insfld INSFLD BTN_INSFLD,2"></button>
		<button CB="Cart CART BTN_CART">
			자동적재
		</button>
		<button CB="Allocate ALLOCATE BTN_ALLOCATE"></button>
		<button CB="Note NOTE BTN_MNGLINK"></button>
		<button CB="Create CREATE BTN_CREATE"></button>
		<button CB="Recall RECALL BTN_GETVARIANT"></button>
		<button CB="Saveas SAVEAS BTN_SAVEVARIANT"></button>
		<button CB="Delete DELETE BTN_DELETE"></button>
		<button CB="Wcancle WCANCLE BTN_CANCLE false"></button>
	</div>
	<div class="util7">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Create CREATE BTN_CREATE"></button>
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>  <!-- top_icon_22.png -->
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button> <!-- top_icon_23.png --> 
		</p>
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" id="WAREKY" name="WAREKY" UIInput="S,SHAREMA" validate="required,MASTER_M0434" value="<%=wareky%>"/>
						</td>
					</tr>
					 <tr>
						<th>SIZE TEST</th>
						<td>
							<input type="text" value="<%=compky%>" style="width:300px"/>
						</td>
					</tr> 
					<tr>
						<th CL="STD_AREAKY">구역 *</th>
						<td>
							<input type="text" name="NAME01" UIInput="R,SHWAHMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_CREADAT">설명</th>
						<td>
							<input type="text" name="CREADAT" UIInput="R" UIFormat="C"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_CREADAT">거점</th>
						<td>
							<input type="text" name="LMODAT" UIFormat="C Y"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_CREADAT">설명</th>
						<td>
							<input type="text" name="CREADAT1" UIInput="R" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th>Calender Test</th>
						<td>
							<input type="text" id="CTest" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->
<!-- content -->
<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
				<div class="bottomSect2 top6">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span>일반</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
												<col width="40" />
												<col width="40" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />											
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'>번호</th>
													<th GBtnCheck="true"></th>
													<th CL='STD_WAREKY'>거점</th>
													<th CL='STD_AREAKY'>창고</th>
													<th CL='STD_ZONEKY'>구역</th>
													<th CL='STD_ZONETY'>구역타입</th>
													<th CL='STD_SHORTX'>설명</th>
													<th CL='STD_CREDAT'>생성일자</th>
													<th CL='STD_CRETIM'>생성시간</th>
													<th CL='STD_CREUSR'>생성자</th>
													<th CL='STD_LMODAT'>수정일자</th>
													<th CL='STD_LMOTIM'>수정시간</th>
													<th CL='STD_LMOUSR'>수정자</th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
												<col width="40" />
												<col width="40" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />											
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
											</colgroup>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="rowCheck"></td>
													<td GCol="text,WAREKY"></td>
													<td GCol="input,AREAKY,SHAREMA" GF="S 10" validate="required,MASTER_M0254"></td>
													<td GCol="input,ZONEKY,SHZONMA" validate="required" ></td>
													<td GCol="select,ZONETY" validate="required">
														<select CommonCombo="ZONETY">
															<option value=" "></option>
														</select>
													</td>
													<td GCol="input,SHORTX" GF="S 180"></td> 
													<td GCol="text,CREDAT"></td>
													<td GCol="text,CRETIM"></td>
													<td GCol="text,CREUSR"></td>
													<td GCol="text,LMODAT" GF="D"></td>
													<td GCol="text,LMOTIM" GF="T"></td>
													<td GCol="text,LMOUSR"></td>
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
										<button type="button" GBtn="copy"></button>
										<button type="button" GBtn="delete"></button>
										<button type="button" GBtn="layout"></button>
										<button type="button" GBtn="total"></button>
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
				<div class="bottomSect bottom3">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_GENERAL"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_AREAKY'>창고</th>
												<th CL='STD_ZONEKY'>구역</th>
												<th CL='STD_ZONETY'>구역타입</th>
												<th CL='STD_SHORTX'>설명</th>
												<th CL='STD_CREDAT'>생성일자</th>
												<th CL='STD_CRETIM'>생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_LMODAT'>수정일자</th>
												<th CL='STD_LMOTIM'>수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="input,AREAKY,SHAREMA" GF="S 10" validate="required,MASTER_M0254"></td>
												<td GCol="input,ZONEKY,SHZONMA" validate="required" ></td>
												<td GCol="select,ZONETY" validate="required">
													<select CommonCombo="ZONETY">
														<option value=" "></option>
													</select>
												</td>
												<td GCol="input,SHORTX" GF="S 180"></td> 
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
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
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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

			<div class="bottomSect bottom4">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="100" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TKZONE'></th>
												<th CL='STD_LOCATY'></th>
												<th CL='STD_STATUS'></th>
												<th CL='STD_INDUPA'></th>
												<th CL='STD_INDUPK'></th>
												<th CL='STD_INDCPC'></th>
												<th CL='STD_MAXCPC'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_MIXSKU'></th>
												<th CL='STD_MIXLOT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="100" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<tbody id="gridListItem">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="input,ZONEKY,SHZONMA" GF="S 10"></td> 
												<td GCol="input,LOCAKY" validate="required,HHT_T0032" GF="S 20"></td>
												<td GCol="input,TKZONE,SHZONMA" GF="S 10"></td>
												<td GCol="select,LOCATY">
													<select CommonCombo="LOCATY">
													</select>
												</td>
												<td GCol="select,STATUS">
													<select CommonCombo="STATUS">
													</select>
												</td>
												<td GCol="check,INDUPA"></td>
												<td GCol="check,INDUPK"></td>
												<td GCol="check,INDCPC"></td>
												<td GCol="input,MAXCPC" GF="N 20,3"></td>
												<td GCol="input,WIDTHW" GF="N 20,3"></td>
												<td GCol="input,HEIGHT" GF="N 20,3"></td>
												<td GCol="check,MIXSKU"></td>
												<td GCol="check,MIXLOT"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
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
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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