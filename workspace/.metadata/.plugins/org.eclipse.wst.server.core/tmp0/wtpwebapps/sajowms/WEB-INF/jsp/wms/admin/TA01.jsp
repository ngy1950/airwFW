<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	var dblIdx = 0;
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "WAREKY,ALSTKY",
			module : "WmsAdmin",
			command : "TA01",
			validation : "WAREKY,ALSTKY,SHORTX",
			bindArea : "tabs1-2"
	    });
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			pkcol : "WAREKY,ALSTKY,STEPNO",
			module : "WmsAdmin",
			command : "TA01Sub",
			validation : "WAREKY,ALSTKY,STEPNO"
	    });
	}); 
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	function searchSubList(headRowNum){
		var rowVal = gridList.getColData("gridList", headRowNum, "WAREKY");
		var rowMea = gridList.getColData("gridList", headRowNum, "ALSTKY");
		var param = inputList.setRangeParam("searchArea");
		param.put("WAREKY", rowVal);
		param.put("ALSTKY", rowMea);
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});

		lastFocusNum = rowNum;
		dblIdx = rowNum;
	}
	
	var lastFocusNum = -1;
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			searchSubList(0);
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			if(gridList.getColData("gridList", rowNum, "STATUS") == "C"){
				return false;
			}
			
			dblIdx = rowNum;
			
			searchSubList(rowNum);
		}
	}
	
	//그리드 위에 클릭시 아이템 리셋
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridList"){
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
			//저장
			}else{
				if(confirm(commonUtil.getMsg("COMMON_M0024"))){
				//if(confirm("값이 변화된 데이터가 있습니다. 이동하시겠습니까?")){
					gridList.resetGrid("gridListSub");
				}else{
					return false;
				}
			}
		}
	}
	
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.resetGrid("gridListSub");
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum) {
		if(gridId == "gridList"){
			var headCnt = gridList.getModifyRowCount("gridList");
			var listCnt = gridList.getModifyRowCount("gridListSub");
			if(listCnt > 0 || headCnt > 0){
				//alert("변경된 row를 저장 후 행추가 하십시요.");
				commonUtil.msgBox("MASTER_M0686");
				return false;
			}else{
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
					var alstky = gridList.getColData("gridList", headNum,
							"ALSTKY");

					var stepno = 1;

					var lastRow = gridList.getGridDataCount("gridListSub");
					if (lastRow > 0) {
						stepno = parseInt(gridList.getColData("gridListSub",
								lastRow - 1, "STEPNO")) + 1;
					}

					if (stepno < 10) {
						stepno = "00" + stepno;
					} else if (stepno < 100) {
						stepno = "0" + stepno;
					}

					if (alstky != "") {
						var newData = new DataMap();
						newData.put("WAREKY", wareky);
						newData.put("ALSTKY", alstky);
						newData.put("ALORTO", "100");
						newData.put("ALUNIT", "1");
						newData.put("STEPNO", stepno);

						return newData;
					} else {
						//alert(commonUtil.getMsg("MASTER_M0097"));
						commonUtil.msgBox("MASTER_M0097");
						return false;
					}
				} else {
					//alert(commonUtil.getMsg("TASK_M0003"));
					commonUtil.msgBox("TASK_M0003");
					return false;
				}
			} else {

				var wareky = gridList.getColData("gridList", dblIdx, "WAREKY");
				var alstky = gridList.getColData("gridList", dblIdx, "ALSTKY");

				var lastRow = gridList.getGridDataCount("gridListSub");
				var stepno = parseInt(gridList.getColData("gridListSub",
						lastRow - 1, "STEPNO")) + 1;

				if (stepno < 10) {
					stepno = "00" + stepno;
				} else if (stepno < 100) {
					stepno = "0" + stepno;
				}

				var newData = new DataMap();
				newData.put("WAREKY", wareky);
				newData.put("ALSTKY", alstky);
				newData.put("ALORTO", "100");
				newData.put("ALUNIT", "1");
				newData.put("STEPNO", stepno);

				return newData;
			}
		}
	}

	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if (gridId == "gridList" && colName == "ALSTKY") {
			if (colValue != "") {
				var wareky = gridList.getColData("gridList", rowNum, "WAREKY");

				var param = new DataMap();
				param.put("ALSTKY", colValue);
				param.put("WAREKY", wareky);

				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "TA01ALSTKYval",
					sendType : "map",
					param : param
				});

				if (json.data["CNT"] >= 1) {
					gridList.setColValue("gridList", rowNum, "ALSTKY", " ");
					//alert(commonUtil.getMsg("VALID_M0111", colValue));
					commonUtil.msgBox("VALID_M0111", colValue);
					return false;
				}
			}
			if (gridList.getGridDataCount("gridListSub") > 0) {
				var listCnt = gridList.getGridDataCount("gridList");
				if (listCnt != 0) {
					for (var i = 0; i < listCnt; i++) {
						gridList.setColValue("gridListSub", i, "ALSTKY",
								colValue);
					}
				}
			}
		}
	}

	function saveData() {
		if (gridList.getModifyRowCount("gridList") == 0
				&& gridList.getModifyRowCount("gridListSub") == 0) {
			//alert(commonUtil.getMsg("MASTER_M0545"));
			commonUtil.msgBox("MASTER_M0545");
			return;
		}

		if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {
			return;
		}

		if (gridList.validationCheck("gridList", "modify")
				&& gridList.validationCheck("gridListSub", "modify")) {
			var headNum = gridList.getGridDataCount("gridList") - 1;
			if (gridList.getRowStatus("gridList", headNum) == "C"
					&& gridList.getGridDataCount("gridListSub") == 0) {
				//alert(commonUtil.getMsg("OUT_M0045"));
				commonUtil.msgBox("OUT_M0045");
				return;
			}

			var headCnt = gridList.getGridDataCount("gridList");
			for (var i = 0; i < headCnt; i++) {

				gridList.setColValue("gridList", i, "STATUS", gridList
						.getRowStatus("gridList", i));
			}
			var head = gridList.getGridData("gridList");

			var listCnt = gridList.getGridDataCount("gridListSub");
			for (var i = 0; i < listCnt; i++) {
				gridList.setColValue("gridListSub", i, "STATUS", gridList
						.getRowStatus("gridListSub", i));
			}

			var list = gridList.getGridData("gridListSub");

			var param = new DataMap();

			param.put("head", head);
			param.put("list", list);

			var json = netUtil.sendData({
				url : "/wms/admin/json/saveTA01.data",
				param : param
			});

			//alert(commonUtil.getMsg(json.data));
			if (json) {
				if (json.data) {
					gridList.resetGrid("gridListSub");
					searchList();
				}
			}
		}
	}
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHRLRRH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSTSRH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}
		
		
	}
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		if(gridId == "gridListSub"){
			var rowNum = gridList.getFocusRowNum("gridList");
			var alstky = gridList.getColData("gridList", rowNum, "ALSTKY");
		
			param.put("ALSTKY",alstky);
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
			<button CB="Save SAVE STD_SAVE">
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
							<td><input type="text" name="WAREKY" value="<%=wareky%>"
								readonly="readonly"  /></td>
						</tr>
						<tr>
							<th CL="STD_ALSTKY">할당전략키</th>
							<td><input type="text" name="ALSTKY" UIInput="R,SHALSTH" />
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

				<div class="bottomSect top">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>일반</span></a></li>
							<li><a href="#tabs1-2"><span CL='STD_DETAIL'>상세</span></a></li>
							<!--li><a href="#tabs1-3"><span value="Item상세">관리</span></a></li-->
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
												<col width="180" />
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
													<th CL='STD_NUMBER'></th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_ALSTKY'></th>
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
												<col width="40" />
												<col width="100" />
												<col width="180" />
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
													<td GCol="input,ALSTKY" validate="required,MASTER_M0097"
														GF="S 10"></td>
													<td GCol="input,SHORTX" validate="required" GF="S 180"></td>
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
						<!--  -->
						<div id="tabs1-2">
							<div class="section type1 hei200">
								<div class="searchInBox">
									<div class="table type1">
										<table>
											<colgroup>
												<col width="100" />
												<col />
												<col width="100" />
												<col />
											</colgroup>
											<tbody id="gridList">
												<tr>
													<th CL='STD_WAREKY'></th>
													<td><input type="text" name="WAREKY" readonly /></td>
												</tr>
												<tr>
													<th CL='STD_ALSTKY'></th>
													<td><input type="text" name="ALSTKY" readonly /></td>
												</tr>
												<tr>
													<th CL='STD_SHORTX'></th>
													<td><input type="text" name="SHORTX" /></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<!-- div id="tabs1-3">
						<div class="section type1 hei200">
							<div class="searchInBox">
								<div class="table type1">
									관리
									<table>
										<tr>
											<th>생성일시</th>
											<td>
												<input type="text" /><input type="text" />
											</td>
											<th>수정일시</th>
											<td>
												<input type="text" /><input type="text" />
											</td>
										</tr>
										<tr>
											<th>생성자</th>
											<td>
												<input type="text" />
											</td>
											<th>수정자</th>
											<td>
												<input type="text" />
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					<!--  -->
					</div>
				</div>

				<div class="bottomSect bottom">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2" id="commonMiddleArea">
							<li><a href="#tabs1-1" CL='STD_ITEM'><span>아이템</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1" style="overflow-y: scroll;">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
												<col width="40" />
												<col width="80" />
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
													<th CL='STD_NUMBER'></th>
													<th CL='STD_STEPNO'></th>
													<th CL='STD_ALFTKY'></th>
													<th CL='STD_SSORKY'></th>
													<th CL='STD_ALORTO'></th>
													<th CL='STD_ALUNIT'></th>
													<th CL='STD_SUALKY'></th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_ALSTKY'></th>
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
												<col width="80" />
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
													<td GCol="input,STEPNO" validate="duplication" GF="S 3"></td>
													<td GCol="input,ALFTKY,SHRLRRH" validate="required"
														GF="S 10"></td>
													<td GCol="input,SSORKY,SHSTSRH" validate="required"
														GF="S 10"></td>
													<td GCol="input,ALORTO" validate="max(100)"></td>
													<td GCol="input,ALUNIT"></td>
													<td GCol="input,SUALKY" GF="S 10"></td>
													<td GCol="text,WAREKY"></td>
													<td GCol="text,ALSTKY"></td>
													<td GCol="text,CREDAT" GF="D"></td>
													<td GCol="text,CRETIM" GF="T"></td>
													<td GCol="text,CREUSR"></td>
													<td GCol="text,CREUNM"></td>
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
	<!-- //content -->
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>