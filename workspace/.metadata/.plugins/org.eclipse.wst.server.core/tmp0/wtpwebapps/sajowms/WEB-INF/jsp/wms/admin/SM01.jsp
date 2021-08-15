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
	$(document).ready(function() {
		setTopSize(300);
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			pkcol : "WAREKY,MEASKY",
			module : "WmsAdmin",
			command : "MEASH",
			validation : "WAREKY,MEASKY,SHORTX",
			bindArea : "tabs1-2" 
		});
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			pkcol : "WAREKY,MEASKY,ITEMNO",
			module : "WmsAdmin",
			validation : "WAREKY,MEASKY,ITEMNO",
			command : "MEASHSub"
	    });
		//gridList.setReadOnly('gridListSub',true, ['ITEMNO','QTPUOM','UOMKEY','INDDFU','DISREC','DISSHP','DISTAS']);
		gridList.setReadOnly('gridListSub',true, ['ITEMNO']);
	});

	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	function searchSubList(headRowNum){
		var param = inputList.setRangeParam("searchArea");
		var rowVal = gridList.getColData("gridList", headRowNum, "WAREKY");
		var rowMea = gridList.getColData("gridList", headRowNum, "MEASKY");
		param.put("WAREKY", rowVal);
		param.put("MEASKY", rowMea);
		
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
	
	// 상단 그리드 더블 클릭시 하단 그리드 조회
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
	//변경.
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
		} else if(gridId == "gridListSub"){
			
			 if(dblIdx == -1){
				var headNum = gridList.getGridDataCount("gridList") -1;
				if(gridList.getColData("gridList", headNum, "STATUS") == ""){
					//alert(commonUtil.getMsg("VALID_M0407"));
					commonUtil.msgBox("VALID_M0407");
					return false;
				}
	
				if(gridList.getColData("gridList", headNum, "STATUS") == "C"){
					var wareky = gridList.getColData("gridList", headNum, "WAREKY");
					var measky = gridList.getColData("gridList", headNum, "MEASKY");
					
					//gridList.setReadOnly('gridListSub',false, ['INDDFU','DISREC','DISSHP','DISTAS']);
					
					var itemno = 10;
					var lastRow = gridList.getGridDataCount("gridListSub");
					
					if(lastRow > 0){
						itemno= Number(gridList.getColData("gridListSub", lastRow-1, "ITEMNO"))+10;
					}
					
					if(itemno < 100){
						itemno = "0000" + itemno;
					}else if(itemno < 1000){
						itemno = "000" + itemno;
					}else if(itemno < 10000){
						itemno = "00" + itemno;
					}else if(itemno < 100000){
						itemno = "0" + itemno;
					}

					if(measky != ""){
						
							var newData = new DataMap();
							newData.put("WAREKY",wareky);
							newData.put("MEASKY",measky);
							newData.put("ITEMNO",itemno);	
							//newData.put("UOMKEY", "BOX");
							return newData;
					} else { 
						//alert(commonUtil.getMsg("VALID_M0407"));
						commonUtil.msgBox("VALID_M0407");
						return false;
					}
				}else{
					//alert(commonUtil.getMsg("TASK_M0003"));
					commonUtil.msgBox("TASK_M0003");
					return false;
				}
			}else{
				var wareky = gridList.getColData("gridList", dblIdx, "WAREKY");
				var measky = gridList.getColData("gridList", dblIdx, "MEASKY");
				var lastRow = gridList.getGridDataCount("gridListSub");
				var itemno = Number(gridList.getColData("gridListSub",lastRow - 1, "ITEMNO")) + 10;
				
				if(itemno < 100){
					itemno = "0000" + itemno;
				}else if(itemno < 1000){
					itemno = "000" + itemno;
				}else if(itemno < 10000){
					itemno = "00" + itemno;
				}else if(itemno < 100000){
					itemno = "0" + itemno;
				}
				
				var newData = new DataMap();
				newData.put("WAREKY", wareky);
				newData.put("MEASKY", measky);
				newData.put("ITEMNO", itemno);
				newData.put("UOMKEY", "BOX");
				

				return newData;
			}
		}
	}
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if (gridId == "gridList" && colName == "MEASKY") {
			if (colValue != "") {
				var wareky = gridList.getColData("gridList", rowNum, "WAREKY");
				
				var param = new DataMap();
				param.put("MEASKY", colValue);
				param.put("WAREKY", wareky);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "SM01MEASKYval",
					sendType : "map",
					param : param
				});

				if (json.data["CNT"] >= 1) {
					gridList.setColValue("gridList", rowNum, "MEASKY", "");
					//alert(commonUtil.getMsg("VALID_M0307", colValue));
					commonUtil.msgBox("VALID_M0307", colValue);
					return false;
				}
			}
			if(gridList.getGridDataCount("gridListSub") > 0){
				var listCnt = gridList.getGridDataCount("gridList");
				if(listCnt != 0){
					for(var i = 0; i < listCnt; i++){
						gridList.setColValue("gridListSub", i, "MEASKY", colValue);
					}
				}
			}
		}else if(gridId == "gridListSub" && colName == "ITEMNO"){
			if(colValue != ""){
				var wareky = gridList.getColData("gridListSub", rowNum, "WAREKY");
				var measky = gridList.getColData("gridListSub", rowNum, "MEASKY");
				
				var param = new DataMap();
				param.put("STEPNO",colValue);
				param.put("WAREKY",wareky);
				param.put("MEASKY",measky);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "ITEMNOval",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] >= 1) {
					gridList.setColValue("gridListSub", rowNum, "ITEMNO", "");
					//alert(commonUtil.getMsg("MASTER_M0100"));
					commonUtil.msgBox("MASTER_M0100");
					return false;
				}
			}
		}
	}

	function saveData(){
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
				url : "/wms/admin/json/saveSM01.data",
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
/* 	    var headNum = gridList.getGridDataCount("gridList") -1;
		
		if(gridList.getRowStatus("gridList",headNum) == "C" && gridList.getGridDataCount("gridListSub") == 0){
			alert(commonUtil.getMsg("OUT_M0045"));
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		if(gridList.validationCheck("gridList", "modify") && gridList.validationCheck("gridListSub", "modify")){
			var headCnt = gridList.getGridDataCount("gridList");
			var headMod = gridList.getModifyList("gridList", 'A');
			var head = gridList.getModifyList("gridList");
			
			var listCnt = gridList.getGridDataCount("gridListSub");
		    
			var list = gridList.getModifyList("gridListSub");
			
			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);
	
			var json = netUtil.sendData({
				url : "/wms/admin/json/saveSM01.data",
				param : param
			});
			
			if(json){
				if(json.data){
					alert(commonUtil.getMsg("HHT_T0008"));
					gridList.resetGrid("gridListSub");
					searchList();
				}
			}
		} */
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHMEASH"){
			return dataBind.paramData("searchArea");
		}
	}
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}/* else if(btnName == "Execute"){
			test3();
		} */ 
	}

	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		if(gridId == "gridListSub"){
			var rowNum = gridList.getFocusRowNum("gridList");
			var measky = gridList.getColData("gridList", rowNum, "MEASKY");
		
			param.put("MEASKY",measky);
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
			<!-- <button CB="Execute SAVE BTN_SAVE_APPLY_INV ">
			</button> -->
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
							<th CL="STD_WAREKY">Center Code</th>
							<td><input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>"/></td>
						</tr>
						<tr>
							<th CL="STD_MEASKY">단위구성</th>
							<td><input type="text" name="A.MEASKY" UIInput="R,SHMEASH" /></td>
						</tr>
						<tr>
							<th CL="STD_SHORTX">설명</th>
							<td><input type="text" name="A.SHORTX" UIInput="R" />
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
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
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
											<col width="120" />
											<col width="170" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_MEASKY'>단위구성</th>
												<th CL='STD_SHORTX'>설명</th>
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
											<col width="120" />
											<col width="170" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="add,MEASKY"></td>
												<td GCol="input,SHORTX"></td>
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
								<div class="rightArea"><p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2"  GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_DETAIL">상세</h2>
									<table class="table type1">
										<colgroup>
											<col width="100" />
											<col />
											<col width="100" />
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_MEASKY'>단위구성</th>
												<td>
													<input type="text" name="MEASKY" readonly="readonly"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_SHORTX'>설명</th>
												<td><input type="text" name="SHORTX" style="width:170PX" readonly="readonly"/></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1" CL="STD_ITEM"><span>아이템</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="70" />
											<col width="100" />
											<col width="140" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_ITEMNO'>순번</th>
												<th CL='STD_UOMKEY'>단위</th>
												<th CL='STD_QTPUOM'>Unit per measure</th>
												<th CL='STD_INDDFU'>기본 단위</th>
												<th CL='STD_DISREC'>조회(입하)</th>
												<th CL='STD_DISSHP'>조회(출하)</th>
												<th CL='STD_DISTAS'>조회(Task)</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="70" />
											<col width="100" />
											<col width="140" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridListSub">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,ITEMNO" validate="required" GF="S 6" ></td>
												<!-- <td GCol="select,UOMKEY" validate="required,VALID_M0402">
													<select CommonCombo="UOMKEY">
													</select>
												</td> -->
												<!--  <td GCol="select,UOMKEY,UOMKEYT" >-->
												<!-- <td GCol="select,UOMKEY" >
													<select Combo="WmsAdmin,UOMKEYCOMBO">
													</select>
												</td> -->
												<td GCol="input,UOMKEY"></td>
												<td GCol="input,QTPUOM"  GF="N 20,3"></td> <!-- GF="N 20,3" -->
												<td GCol="check,INDDFU,radio" ></td>
												<td GCol="check,DISREC,radio" ></td>
												<td GCol="check,DISSHP,radio" ></td>
												<td GCol="check,DISTAS,radio" ></td>
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
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>