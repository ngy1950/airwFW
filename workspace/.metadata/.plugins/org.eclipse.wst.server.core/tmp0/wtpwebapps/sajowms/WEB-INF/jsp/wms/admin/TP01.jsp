<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	var dblIdx = 0;
	$(document).ready(function() {
		setTopSize(250);
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			pkcol : "WAREKY,PASTKY",
			module : "WmsAdmin",
			command : "TP01",
	    	bindArea : "tabs1-2"

		});

		gridList.setGrid({
			id : "gridListSub",
			name : "gridListSub",
			editable : true,
			pkcol : "WAREKY,PASTKY,STEPNO",
			module : "WmsAdmin",
			command : "TP01Sub"
		});
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
	});

	function searchList() {
		if($("#searchArea").find("[name=ZONE]").prop("checked") == false 
			&& $("#searchArea").find("[name=LOC]").prop("checked") == false){
			inputList.addValidation("H.PASTKY", "required");
		}
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function searchSubList(headRowNum) {
		var rowVal = gridList.getColData("gridList", headRowNum, "WAREKY");
		var rowMea = gridList.getColData("gridList", headRowNum, "PASTKY");
		var param = inputList.setRangeParam("searchArea");
		param.put("WAREKY", rowVal);
		param.put("PASTKY", rowMea);

		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		lastFocusNum = rowNum;
		dblIdx = rowNum;
	}
	
	var lastFocusNum = -1;
	function gridListEventDataBindEnd(gridId, dataLength) {
		//alert( " gridId : " + gridId + "\n dataLength : " + dataLength );
		if (gridId == "gridList" && dataLength > 0) {
			searchSubList(0);
		}
	}

	// 상단 그리드 더블 클릭시 하단 그리드 조회
	function gridListEventRowDblclick(gridId, rowNum) {
		if (gridId == "gridList") {
			if (gridList.getColData("gridList", rowNum, "STATUS") == "C") {
				return false;
			}
			dblIdx = rowNum;
			searchSubList(rowNum);
		}
	}

	//그리드 위에 클릭시 아이템 리셋
	function gridListEventRowFocus(gridId, rowNum) {
		if (gridId == "gridList") {
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			if (modRowCnt == 0) {
				if (dblIdx != rowNum) {
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
				//저장
			} else {
				if (confirm(commonUtil.getMsg("COMMON_M0024"))) {
					saveData();
				} else {
					gridList.resetGrid("gridListSub");
				}
			}
		}
	}
	
	//헤드 삭제시 서브도 날리기.
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.resetGrid("gridListSub");
		}
	}

	function gridListEventRowAddBefore(gridId, rowNum) {
		if (gridId == "gridList") {
			var headCnt = gridList.getModifyRowCount("gridList");
			var listCnt = gridList.getModifyRowCount("gridListSub");
			if (listCnt > 0 || headCnt > 0) {
				//alert("변경된 row를 저장 후 행추가 하십시요.");
				commonUtil.msgBox("MASTER_M0686");
				return false;
			} else {
				var newData = new DataMap();
				newData.put("WAREKY", "<%=wareky%>");
				newData.put("STATUS", "C");

				return newData;
			}
		} else if (gridId == "gridListSub") { 
			if (dblIdx == -1) {
				var headNum = gridList.getGridDataCount("gridList") - 1;
				if (gridList.getColData("gridList", headNum, "STATUS") == "") {
					//alert(commonUtil.getMsg("MASTER_M0577"));
					commonUtil.msgBox("MASTER_M0577");
					return false;
				}

				if (gridList.getColData("gridList", headNum, "STATUS") == "C") {
					var wareky = gridList.getColData("gridList", headNum,
							"WAREKY");
					var pastky = gridList.getColData("gridList", headNum,
							"PASTKY");
					
					var stepno = 1;

					var lastRow = gridList.getGridDataCount("gridListSub");
					if(lastRow > 0){
						stepno = parseInt(gridList.getColData("gridListSub", lastRow-1, "STEPNO"))+1;
					}
					
					if(stepno < 10){
						stepno = "00" + stepno;
					}else if(stepno < 100){
						stepno = "0" + stepno;
					}

					if (pastky != "") {
						var newData = new DataMap();
						newData.put("WAREKY", wareky);
						newData.put("PASTKY", pastky);
						newData.put("STEPNO",stepno);
						return newData;
					} else {
						//alert(commonUtil.getMsg("MASTER_M0242"));
						commonUtil.msgBox("MASTER_M0242");
						return false;
					}

				} else {
					//alert("적치전략키를 선택하세요.");
					commonUtil.msgBox("MASTER_M0687");
					return false;

				}
			} else {

				var wareky = gridList.getColData("gridList", dblIdx, "WAREKY");
				var pastky = gridList.getColData("gridList", dblIdx, "PASTKY");

				var newData = new DataMap();
				newData.put("WAREKY", wareky);
				newData.put("PASTKY", pastky);
				return newData;
			}
		}

	}

	function saveData() {
		
		if (gridList.getModifyRowCount("gridList") == 0
				&& gridList.getModifyRowCount("gridListSub") == 0) {
			//alert(commonUtil.getMsg("MASTER_M0545"));
			commonUtil.msgBox("MASTER_M0545");
			return;
		}//변경된 데이터가 없습니다.

		if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {
			return;
		}//저장하시겠습니까?

		if (gridList.validationCheck("gridList", "modify")
				&& gridList.validationCheck("gridListSub", "modify")) {

			var headNum = gridList.getGridDataCount("gridList") - 1;

			if (gridList.getRowStatus("gridList", headNum) == "C"
					&& gridList.getGridDataCount("gridListSub") == 0) {
				//alert(commonUtil.getMsg("OUT_M0045"));
				commonUtil.msgBox("OUT_M0045");
				
				return;//처리를 위한 아이템이 존재하지 않습니다.
			}

			var headCnt = gridList.getGridDataCount("gridList");
			var itemCnt = gridList.getGridDataCount("gridListSub");
			var colValue;
			var rowValue;
			for (var i = 0; i < headCnt; i++) {
				colValue = gridList.getRowStatus("gridList", i);
				gridList.setColValue("gridList", i, "STATUS", colValue);
			}

			for (var j = 0; j < itemCnt; j++) {
				rowValue = gridList.getRowStatus("gridListSub", j);
				gridList.setColValue("gridListSub", j, "STATUS", rowValue);
			}

			var head = gridList.getGridData("gridList");
			var list = gridList.getGridData("gridListSub");
	
			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);

		

			var json = netUtil.sendData({
				url : "/wms/admin/json/saveTP01.data",
				param : param
			});

			
			if (json && json.data) {
				alert(commonUtil.getMsg(json.data));
				gridList.resetGrid("gridListSub");
				searchList();
			}
		}
	}

	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if (gridId == "gridList" && colName == "PASTKY") {
			if (colValue != "") {
				var wareky = gridList.getColData("gridList", rowNum, "WAREKY");
				
				var param = new DataMap();
				param.put("PASTKY", colValue);
				param.put("WAREKY", wareky);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "TP01PASTHval",
					sendType : "map",
					param : param
				});

				if (json.data["CNT"] >= 1) {
					commonUtil.msgBox("VALID_M0308", colValue);
					gridList.setColValue("gridList", rowNum, "PASTKY", "");
					//return false;
				}
			}
			if(gridList.getGridDataCount("gridListSub") > 0){
				var listCnt = gridList.getGridDataCount("gridList");
				if(listCnt != 0){
					for(var i = 0; i < listCnt; i++){
						gridList.setColValue("gridListSub", i, "PASTKY", colValue);
					}
				}
			}
		}else if(gridId == "gridListSub" && colName == "STEPNO"){
			if(colValue != ""){
				var wareky = gridList.getColData("gridListSub", rowNum, "WAREKY");
				var pastky = gridList.getColData("gridListSub", rowNum, "PASTKY");
				
				var param = new DataMap();
				param.put("STEPNO",colValue);
				param.put("WAREKY",wareky);
				param.put("PASTKY",pastky);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "TP01STEPNOval",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] >= 1) {
					gridList.setColValue("gridListSub", rowNum, "STEPNO", "");
					//alert(commonUtil.getMsg("MASTER_M0100"));
					commonUtil.msgBox("MASTER_M0100");
					return false;
				}
			}
		}else if(gridId=="gridListSub" && colName=="LOCASR"){
				if (colValue != "") {
					var param=new DataMap();
					param.put("LOCASR",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "LOCAval",
						sendType : "map",
						param : param
					});
					if(json.data["CNT"] < 1){
						commonUtil.msgBox("MASTER_M0477", colValue);
						gridList.setColValue("gridListSub", rowNum, "LOCASR", ""); 
					}
				}
			}else if(gridId=="gridListSub" && colName=="ZONETG"){
				if (colValue != "") {
					var param=new DataMap();
					param.put("ZONETG",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "ZONETGval",
						sendType : "map",
						param : param
					});
					if(json.data["CNT"] < 1){
						commonUtil.msgBox("MASTER_M0044", colValue);
						gridList.setColValue("gridListSub", rowNum, "ZONETG", ""); 
					}
				}
			}else if(gridId=="gridListSub" && colName=="LOCATG"){
				if (colValue != "") {
					var param=new DataMap();
					param.put("LOCATG",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "LOCATGval",
						sendType : "map",
						param : param 
					});
					if(json.data["CNT"] < 1){
						commonUtil.msgBox("MASTER_M0477", colValue);
						gridList.setColValue("gridListSub", rowNum, "LOCATG", ""); 
					}
				}
			}
	}
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHRLRRH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHPASTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHLOCMA"){
			return dataBind.paramData("searchArea");
		}
		
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			test3();
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		if(gridId == "gridListSub"){
			var rowNum = gridList.getFocusRowNum("gridList");
			var pastky = gridList.getColData("gridList", rowNum, "PASTKY");
		
			param.put("PASTKY",pastky);
		}
		return param;
	}
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY">
			</button>
			<button CB="Save SAVE STD_SAVE ">
			</button>
		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
		</div>
	</div>
	<!-- searchPop -->
	<div class="searchPop" id="searchArea">
		<button type="button" class="closer">X</button>
		<div class="searchInnerContainer">
		
			<p class="util">
				<button CB="Search SEARCH BTN_DISPLAY"></button>
				<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
				<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
			</p>
			
			<div class="searchInBox">
				<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_WAREKY">거점</th>
							<td><input type="text" name="WAREKY"  value="<%=wareky%>" readonly="readonly" /></td>
						</tr>
						<!-- <tr>
							<th CL="STD_AREAKY"></th>
							<td>
								<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
								</select>
							</td>
						</tr> -->
						<tr>
							<th CL="STD_PASTKY">적치전략키</th>
							<td>
								<input type="text" name="H.PASTKY" UIInput="R" />
							</td>
						</tr>
						<!-- <tr>
							<th CL="STD_NOSETZ">Zone 미설정</th>
							<td>
								<input type="checkbox" name="ZONE" value="V" checked="checked" />
							</td>
						</tr>
						<tr>
							<th CL="STD_NOSETL">Loc.미설정</th>
							<td>
								<input type="checkbox" name="LOC" value="V" />
							</td>
						</tr> -->
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</div>
	</div>
	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<div class="contentContainer">
				<div class="bottomSect top">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1" CL="STD_GENERAL"><span>일반</span></a></li>
							<li><a href="#tabs1-2" CL="STD_DETAIL"><span>상세</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
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
													<th CL='STD_WAREKY'></th>
													<th CL='STD_PASTKY'></th>
													<th CL='STD_SHORTX'></th>
													<th CL='STD_CREDAT'></th>
													<th CL='STD_CRETIM'></th>
													<th CL='STD_CREUSR'></th>
													<th CL='STD_CUSRNM'></th>
													<th CL='STD_LMODAT'></th>
													<th CL='STD_LMOTIM'></th>
													<th CL='STD_LMOUSR'></th>
													<th CL='STD_LUSRNM'></th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
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
													<td GCol="text,WAREKY"></td>
													<td GCol="input,PASTKY" validate="required"></td>
													<td GCol="input,SHORTX" validate="required" GF="S 10"></td>
													<td GCol="text,CREDAT" GF="D"></td>
													<td GCol="text,CRETIM" GF="T"></td>
													<td GCol="text,CREUSR"></td>
													<td GCol="text,CUSRNM"></td>
													<td GCol="text,LMODAT" GF="D"></td>
													<td GCol="text,LMOTIM" GF="T"></td>
													<td GCol="text,LMOUSR"></td>
													<td GCol="text,LUSRNM"></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<button type="button" GBtn="copy"></button>
										<button type="button" GBtn="add"></button>
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
						<div id="tabs1-2">
							<div class="section type1" style="overflow-y: scroll;">
								<div class="searchInBox">
									<h2 class="tit" CL='STD_MANAGE'></h2>
									<table class="table type1">
										<colgroup>
											<col width="8%" />
											<col />
											<col width="8%" />
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th CL="STD_WAREKY">거점</th>
												<td>
													<input type="text" readonly="readonly" name="WAREKY" />
												</td>
											</tr>
											<tr>
												<th CL="STD_PASTKY">적치</th>
												<td>
													<input type="text" readonly="readonly" name="PASTKY" />
												</td>
											</tr>
											<tr>
												<th CL="STD_SHORTX">설명</th>
												<td>
													<input type="text" name="SHORTX" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="bottomSect bottom">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2"  id="commonMiddleArea">
							<li><a href="#tabs1-1" CL="STD_ITEM"><span></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
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
													<th CL='STD_STEPNO'>단계번호</th>
													<th CL='STD_AREAKY'>창고</th>
													<th CL='STD_RMTGLS,2'>적치지번 탐색방법</th>
													<th CL='STD_LOCATG'>To 지번</th>
													<th CL='STD_ZONETG'>도착구역</th>
													<th CL='STD_CAPACR'></th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_PASTKY'></th>
													<th CL='STD_SRMEKY,2'></th>
													<th CL='STD_USDOCT'></th>
													<th CL='STD_CREDAT' GF="D"></th>
													<th CL='STD_CRETIM' GF="T"></th>
													<th CL='STD_CREUSR'></th>
													<th CL='STD_CUSRNM'></th>
													<th CL='STD_LMODAT' GF="D"></th>
													<th CL='STD_LMOTIM' GF="T"></th>
													<th CL='STD_LMOUSR'></th>
													<th CL='STD_LUSRNM'></th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
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
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
											</colgroup>
											<tbody id="gridListSub">
												<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="input,STEPNO" validate="required" GF="S 3"></td>
													<td GCol="input,LOCASR,SHLOCMA" ></td>
													<td GCol="select,RMTGLS">
														<select Combo="WmsAdmin,PATYPECOMBO"></select>
													</td>
													<td GCol="input,LOCATG"></td>
													<td GCol="input,ZONETG"></td>
													<td GCol="input,CAPACR"></td>
													<td GCol="input,WAREKY"></td>
													<td GCol="input,PASTKY"></td>
													<td GCol="input,SRMEKY"></td>
													<td GCol="input,USDOCT"></td>
													<td GCol="text,CREDAT" GF="D"></td>
													<td GCol="text,CRETIM" GF="T"></td>
													<td GCol="text,CREUSR"></td>
													<td GCol="text,CUSRNM"></td>
													<td GCol="text,LMODAT" GF="D"></td>
													<td GCol="text,LMOTIM" GF="T"></td>
													<td GCol="text,LMOUSR"></td>
													<td GCol="text,LUSRNM"></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<button type="button" GBtn="copy"></button>
										<button type="button" GBtn="add"></button>
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
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>