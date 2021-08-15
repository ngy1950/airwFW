<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var dblIdx = -1;
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "WAREKY,PACKID,SKUKEY",
			module : "WmsAdmin",
			command : "PAKMA"
			//validation : "WAREKY,PACKID"
			
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			pkcol : "WAREKY,PACKID,SKUKEY",
			module : "WmsAdmin",
			command : "PAKMAsub"
			//validation : "SKUKEY"
		});
		
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			searchSubList(0);
		}
	}
	
	
	function searchSubList(headRowNum){
		var param = inputList.setRangeParam("searchArea");
		var rowVal = gridList.getColData("gridList", headRowNum, "WAREKY");
		var rowPac = gridList.getColData("gridList", headRowNum, "PACKID");
		param.put("WAREKY", rowVal);
		param.put("PACKID", rowPac);
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
	
		dblIdx = headRowNum;
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
				if(confirm(commonUtil.getMsg("COMMON_M0049"))){ // '이동하시겠습니까?' 메세지로 교체 
					dblIdx = rowNum;
					searchSubList(rowNum);
				}else{
					return;
				}
			}
		}
	}

	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.resetGrid("gridListSub");
		}
	}
	
	function saveData(){
		var headNum = gridList.getGridDataCount("gridList") -1;
		var itemNum = gridList.getGridDataCount("gridListSub") -1;
		var headDel = gridList.getModifyList("gridList");
		var itemState = gridList.getModifyList("gridListSub");
		
		if(gridList.getRowStatus("gridList",headNum) == "C" && gridList.getGridDataCount("gridListSub") == 0){
			alert(commonUtil.getMsg("OUT_M0045"));
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		} 
		if(gridList.validationCheck("gridList", "modify") && gridList.validationCheck("gridListSub", "modify")){
			//var listCnt;
			//var head;
			//var headStatus;
			/* if(dblIdx < 0){
				var idx = parseInt(gridList.getGridDataCount("gridList"))-1;
				head = gridList.getRowData("gridList", idx);
				headStatus = gridList.getRowStatus("gridList", idx);
			}else{
				head = gridList.getRowData("gridList", dblIdx);
				headStatus = gridList.getRowStatus("gridList", dblIdx);
				
			} */
			var headCnt = gridList.getGridDataCount("gridList");
			var headMod = gridList.getModifyList("gridList", 'A');
			var head = gridList.getModifyList("gridList");
			
			var listCnt = gridList.getGridDataCount("gridListSub");
		    var headNum = gridList.getGridDataCount("gridList") -1;
			
			var list = gridList.getModifyList("gridListSub");
			//if(!gridList.getRowStatus("gridList",headDel) == "D" ) {
				if(gridList.getRowStatus("gridListSub",itemNum) == "C" || gridList.getRowStatus("gridList",headDel) == "C") {
					var vparam = new DataMap();
					vparam.put("list", list);
					vparam.put("key", "PACKID,SKUKEY");
					var json = netUtil.sendData({
						url : "/wms/admin/json/validationSP01.data",
						param : vparam
					});
					
				
					if(json.data != "OK"){
						var msgList = json.data.split(" ");
						var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
						commonUtil.msg(msgTxt);
						return false;
					}  
				}
			//}
				
			
			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			//param.put("headStatus", headStatus);
	
			var json = netUtil.sendData({
				url : "/wms/admin/json/saveSP01.data",
				param : param
			});
			if(json){
				if(json.data){
					alert(commonUtil.getMsg("HHT_T0008"));
					gridList.resetGrid("gridListSub");
					searchList();
				}
			}
		}
	}
	
		//변경.
	function gridListEventRowAddBefore(gridId, rowNum) { //PAKQTY
		if(gridId == "gridList"){
			var listCnt = gridList.getModifyRowCount("gridListSub");
			var headCnt = gridList.getModifyRowCount("gridList");
			if(listCnt > 0 || headCnt > 0){
				alert("변경된 row를 저장 후 행추가 하십시요.");
				return false;
			}else{
				var newData = new DataMap();
				newData.put("WAREKY", "<%=wareky%>");
				newData.put("PAKQTY", "1");
				newData.put("STATUS", "C");
				return newData;		
			}
		} else if(gridId == "gridListSub"){
			if(dblIdx == -1){
				var headNum = gridList.getGridDataCount("gridList") -1;
				
				if(gridList.getColData("gridList", headNum, "STATUS") == ""){
					alert(commonUtil.getMsg("MASTER_M0678"));
					return false;
				}
				
				if(gridList.getColData("gridList", headNum, "STATUS") == "C"){
					var wareky = gridList.getColData("gridList", headNum, "WAREKY");
					var packid = gridList.getColData("gridList", headNum, "PACKID");
					var rowSho = gridList.getColData("gridList", headNum, "SHORTX");
					var rowpak = gridList.getColData("gridList", headNum, "PAKQTY");
					
					if(packid != ""){
						var param = new DataMap();
						param.put("WAREKY", wareky);
						param.put("PACKID", packid);
						var json = netUtil.sendData({
							module : "WmsAdmin",
							command : "SORTSQval",
							sendType : "map",
							param : param
						});
						if(json.data["CNT"] > 0){
							var param = new DataMap();
							param.put("WAREKY", wareky);
							param.put("PACKID", packid);
							var json = netUtil.sendData({
								module : "WmsAdmin",
								command : "SORTSQ",
								sendType : "map",
								param : param
							});
							var newData = new DataMap();
							newData.put("WAREKY", wareky);
							newData.put("PACKID", packid);
							newData.put("SHORTX", rowSho);
							newData.put("PAKQTY", rowpak);
							newData.put("SORTSQ",json.data["SORTSQ"]);
							return newData;
						} else {
							var newData = new DataMap();
							newData.put("WAREKY", wareky);
							newData.put("PACKID", packid);
							newData.put("SHORTX", rowSho);
							newData.put("PAKQTY", rowpak);
							newData.put("SORTSQ","1");
							return newData;
						}
						
					}else{
						alert(commonUtil.getMsg("MASTER_M0996"));
						return false;
					}
				}else{
					alert("헤더를 선택하세요.");
					return false;
				}
			}else{
				var wareky = gridList.getColData("gridList", dblIdx, "WAREKY");
				var packid = gridList.getColData("gridList", dblIdx, "PACKID");
				var rowSho = gridList.getColData("gridList", dblIdx, "SHORTX");
				var rowpak = gridList.getColData("gridList", dblIdx, "PAKQTY");
				var param = new DataMap();
				param.put("WAREKY", wareky);
				param.put("PACKID", packid);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "SORTSQval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0){
					var param = new DataMap();
					param.put("WAREKY", wareky);
					param.put("PACKID", packid);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "SORTSQ",
						sendType : "map",
						param : param
					});
					var newData = new DataMap();
					newData.put("WAREKY", wareky);
					newData.put("PACKID", packid);
					newData.put("SHORTX", rowSho);
					newData.put("PAKQTY", rowpak);
					newData.put("SORTSQ",json.data["SORTSQ"]);
					return newData;
				} else {
					var newData = new DataMap();
					newData.put("WAREKY", wareky);
					newData.put("PACKID", packid);
					newData.put("SHORTX", rowSho);
					newData.put("PAKQTY", rowpak);
					newData.put("SORTSQ","1");
					return newData;
				}
			}
		}
	}
		
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList" && colName == "PACKID"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("PACKID",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "PACKIDval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("PACKID",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "SET",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "SHORTX", json.data["SHORTX"]); 
					} 
				} else if (json.data["CNT"] < 1) {
					//gridList.setColValue("gridList", rowNum, "PACKID", ""); 
					gridList.setColValue("gridList", rowNum, "SHORTX", ""); 
				}
			}
		} 
		if(gridId == "gridListSub" && colName == "SKUKEY"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("SKUKEY",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "SKUKEY2val",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("SKUKEY",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "BOM",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]); 
					} 
				} else if (json.data["CNT"] < 1) {
					//gridList.setColValue("gridList", rowNum, "SKUKEY", ""); 
					gridList.setColValue("gridListSub", rowNum, "DESC01", ""); 
				}
			} 
		} 
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHWAHMA"){
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
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
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
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_PACKID">SET제품</th>
						<td>
							<input type="text" name="PACKID" UIInput="R" />
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
						<li><a href="#tabs1-1"><span>상세</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="60" /> 
											<col width="180" /> 
											<col width="180" />
											<col width="180" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_SETSKU'>SET 제품</th>
												<th CL='STD_SETSKUNM'>SET 제품명</th>
												<th CL='STD_PAKQTY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="60" /> 
											<col width="180" /> 
											<col width="180" />
											<col width="180" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="input,PACKID" GF="S 30" validate="required"></td>
												<td GCol="text,SHORTX"></td>
												<td GCol="text,PAKQTY"></td>
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
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2"  id="commonMiddleArea">
						<li><a href="#tabs1-1"><span>아이템</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="120" /> 
											<col width="180" />
											<col width="60" /> 
											<col width="70" /> 
											<col width="70" />
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
												<th CL='STD_BOMSKU'></th>
												<th CL='STD_BOMSKUNM'></th>
												<th CL='STD_BOMQTY'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
												<th CL='STD_STATUS'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="120" /> 
											<col width="180" />
											<col width="60" /> 
											<col width="70" /> 
											<col width="70" />
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
												<td GCol="input,SKUKEY" GF="S 20" validate="required"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="input,UOMQTY"></td><!--GF="N 5"-->
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
												<td GCol="text,STATUS"></td>
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