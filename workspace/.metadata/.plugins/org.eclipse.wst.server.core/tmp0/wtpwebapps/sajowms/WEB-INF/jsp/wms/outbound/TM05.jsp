<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var searchCnt = 0; 
	var listFlag  = false;
	var dblIdx = -1;
	var sFlag = true;
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "VBELN",
			module : "WmsOutbound",
			command : "TM05"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "VBELN",
			module : "WmsOutbound",
			command : "TM05Sub"
	    });
	});
	
	function searchList(){
		uiList.setActive("Save", true);
		//var param = dataBind.paramData("searchArea");
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });

		// ADDED BY YUN
		gridList.setReadOnly("gridList", false);
		gridList.setReadOnly("gridListSub", false);
		uiList.setActive("Save", true);
		
	}
	function searchSubList(headRowNum){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridListSub",
	    	param : param
	    });
		dblIdx = headRowNum;
	}
	
	function searchSubItemList(headRowNum){
		gridList.resetGrid("gridListSub");
		
		var VBELN = gridList.getColData("gridList", headRowNum, "VBELN");
		var param = inputList.setRangeParam("searchArea");
			param.put("VBELN", VBELN);
	
		gridList.gridList({
			id : "gridListSub",
			command : "TM05I",
			param : param
		});

		dblIdx = headRowNum;
	}
	
	function makeVBELN(){
		var param = new DataMap();
		var tempVal = gridList.getColData("gridList", 0, "BWART");
		
		param.put("BWART", tempVal);
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SETVBELN",
			sendType : "map",
			param : param
		});
		
		if(json && json.data){
			sFlag = false;
			gridList.setColValue("gridList", 0, "VBELN", json.data["VBELN"]);
			gridList.setColValue("gridListSub", 0, "VBELN", json.data["VBELN"]);
			
		}
		
		return json;
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			searchSubList(0);
		}
	}
	
	 function saveData(){
		if (gridList.getModifyRowCount("gridList") == 0
				&& gridList.getModifyRowCount("gridListSub") == 0) {
			commonUtil.msgBox("MASTER_M0545");
			return;
		}//변경된 데이터가 없습니다.
		
		
		if(gridList.validationCheck("gridList", "modify")){
			var head = gridList.getRowData("gridList", 0);
			var listCnt = gridList.getGridDataCount("gridListSub");
			
			if( gridList.getColData("gridList", 0, "PTNRKY") == "" || gridList.getColData("gridList", 0, "PTNRKY") == " "
				|| gridList.getColData("gridList", 0, "PTNRKY") == null ){
				// {0}을(를) 입력해주세요.
				commonUtil.msgBox("COMMON_M0009", "거래처코드");
				return;
			}
			
			for(var i=0 ; i<listCnt ; i++){
				if( gridList.getColData("gridListSub", i, "SKUKEY") == "" || gridList.getColData("gridListSub", i, "SKUKEY") == " "
					|| gridList.getColData("gridListSub", i, "SKUKEY") == null ){
					// {0}을(를) 입력해주세요.
						commonUtil.msgBox("COMMON_M0009", "품번코드");
						return;
				}
			} 
			
			if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {
				return;
			}//저장하시겠습니까?


					// BLOCKED BY YUN
					/*
			var tmpVBELN = makeVBELN();
			var rowValue;
			var itemCnt = gridList.getGridDataCount("gridListSub");
			
			for (var j = 0; j < itemCnt; j++) {
				rowValue = gridList.getRowStatus("gridListSub", j);
				gridList.setColValue("gridListSub",j,"VBELN", tmpVBELN.data.VBELN);
				gridList.setColValue("gridListSub",j,"POSNR", (j+1));
			
			}
 */
 
			var head = gridList.getGridData("gridList");
			var list = gridList.getGridData("gridListSub");

			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);
			
			
		 	var json = netUtil.sendData({
				url : "/wms/outbound/json/SaveTM05.data",
				param : param
			}); 

		 	if(gridList.checkResult(json)){
				commonUtil.msgBox("VALID_M0001");
				//searchList();
				gridList.resetGrid("gridList");
				gridList.resetGrid("gridListSub");
				gridList.viewJsonData("gridList", json.data);
				searchSubItemList(0);
			}
			gridList.setReadOnly("gridList", true);
			gridList.setReadOnly("gridListSub", true);
			uiList.setActive("Save", false);
		}
	} 

	 
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId=="gridList" && colName=="PTNRKY"){
			if(colValue != ""){
				var param=new DataMap();
				param.put("PTNRKY",colValue);
				var json = netUtil.sendData({
					module : "WmsOutbound",
					command : "WARETGval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("PTNRKY",colValue);
					json = netUtil.sendData({
						module : "WmsOutbound",
						command : "WARETGNAME",
						sendType : "map",
						param : param
					});
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "NAME01", json.data["NAME01"]); 
					} 
				} else if(json.data["CNT"] < 1){
					commonUtil.msgBox("IN_M0063", colValue);
					gridList.setColValue("gridList", rowNum, "PTNRKY", ""); 
				}
			}else if(colValue==""){
				gridList.setColValue("gridList", rowNum, "NAME01", "");
			}
		}else if(gridId == "gridListSub" && colName == "SKUKEY"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("SKUKEY",colValue);
				var json = netUtil.sendData({
					module : "WmsOutbound",
					command : "SKUval",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("SKUKEY",colValue);
					json = netUtil.sendData({
						module : "WmsOutbound",
						command : "SKUCODE",
						sendType : "map",
						param : param
					});
					if(json && json.data){
						gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]); 
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);
					}
				}else if(json.data["CNT"] < 1){
						commonUtil.msgBox("IN_M0063", colValue);
						gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
					}
				}else if(colValue==""){
					gridList.setColValue("gridListSub", rowNum, "DESC01", "");
					gridList.setColValue("gridListSub", rowNum, "UOMKEY", "");
				}
			}
		}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
	
		 if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHBZPTN"){
			var param = new DataMap();
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("PTNRTY","CT");
			return param;
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
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
		<!-- <p class="searchBtn"><input type="submit" onclick="searchList()" class="button type7 widthAuto" value="생성" CL="BTN_CREATE"/></p> -->
		<p class="util">
			<button CB="Search CREATE BTN_CREATE"></button>
		</p>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
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
						<th CL="STD_BWART">출고유형</th>
						<td GCol="select,BWART">
							<select Combo="WmsOutbound,BWARTCOMBO" name="BWART">
							</select>
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
						<li><a href="#tabs1-1"><span>헤더</span></a></li>
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
											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_ORDRNM'>주문번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_SSHTYP'>출고유형</th>
												<th CL='STD_WADAT'>출고요청일</th>
												<th CL='STD_CUSTNM'>거래처코드</th>
												<th CL='STD_PTNRNM'>거래처명</th>
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
											
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="select,BWART">
													<select Combo="WmsOutbound,BWARTCOMBO">
														<!-- <option value="">선택</option> -->
													</select>
												</td>
												<td GCol="input,ZEKKO_AEDAT" GF="C 8"></td>
												<td GCol="input,PTNRKY,SHBZPTN" ></td><!-- validate="required,VALID_M0405" -->
												<td GCol="text,NAME01"></td>
												
											</tr>									
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
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

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1"><span>Item리스트</span></a></li>
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
										
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_ORDRNM'>주문번호</th>
												<th CL='STD_ORDRIT'>주문IT번호</th>
												<th CL='STD_SKUKEY'>품번코드</th>
												<th CL='STD_DESC01'>품명</th>
												<th CL='STD_LFIMG'>수량</th>
												<th CL='STD_UOMKEY'>단위</th>
												<th CL='STD_CUBICM'>CBM</th>
											
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
											
										</colgroup>
										<tbody id="gridListSub">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="input,SKUKEY,SHSKUMA" ></td>
												<td GCol="text,DESC01"></td>
												<td GCol="input,QTSIWH" validate="required"></td>
												<td GCol="text,UOMKEY" ></td>
												<td GCol="text,CUBICM"></td>
											
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