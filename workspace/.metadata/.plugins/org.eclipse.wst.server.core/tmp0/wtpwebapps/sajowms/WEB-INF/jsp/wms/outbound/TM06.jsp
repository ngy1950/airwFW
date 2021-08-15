<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	var listFlag  = false;
	var dblIdx = -1;
	var sFlag = true;
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "EBELN",
			module : "WmsOutbound",
			command : "TM06"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			checkHead : "gridListSubCheckHead",
			pkcol : "EBELN",
			module : "WmsOutbound",
			command : "TM06Sub"
	    });
	});
	
	
	function searchList(){
		uiList.setActive("Save", true);
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridListHead",
	    	param : param
	    });
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
		
		var EBELN = gridList.getColData("gridListHead", headRowNum, "EBELN");
		var param = inputList.setRangeParam("searchArea");
			param.put("EBELN", EBELN);
	
		gridList.gridList({
			id : "gridListSub",
			command : "TM06I",
			param : param
		});

		dblIdx = headRowNum;
	}

	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridListHead" && dataLength > 0){
			searchSubList(0);
		}
	}

	function makeEBELN(){
		var param = new DataMap();
		var tempVal = gridList.getColData("gridListHead", 0, "BWART");
		param.put("BWART", tempVal);
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SETEBELN",
			sendType : "map",
			param : param
		});

		if(json && json.data){
			sFlag = false;
			gridList.setColValue("gridListHead", 0, "EBELN", json.data["EBELN"]);
			gridList.setColValue("gridListSub", 0, "EBELN", json.data["EBELN"]);
		}
		
		return json;
	}
	
	
	function saveData(){
		if (gridList.getModifyRowCount("gridListHead") == 0
				&& gridList.getModifyRowCount("gridListSub") == 0) {
			alert(commonUtil.getMsg("MASTER_M0545"));
			return;
		}//변경된 데이터가 없습니다.
		// all - select, modify
		if( gridList.validationCheck("gridListHead", "modify")) {
			var head = gridList.getRowData("gridListHead", 0);
			var listCnt = gridList.getGridDataCount("gridListSub");
			for(var i=0 ; i<listCnt ; i++){
				if( gridList.getColData("gridListSub", i, "SKUKEY") == "" || gridList.getColData("gridListSub", i, "SKUKEY") == " "
					|| gridList.getColData("gridListSub", i, "SKUKEY") == null ){
						// {0}을(를) 입력해주세요.
						commonUtil.msgBox("COMMON_M0009", "품번코드");
						return;
					}
				} 
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}

			var tmpEbeln = makeEBELN();
			var rowValue;
			var itemCnt = gridList.getGridDataCount("gridListSub");

			for (var j = 0; j < itemCnt; j++) {
				rowValue = gridList.getRowStatus("gridListSub", j);
				gridList.setColValue("gridListSub",j,"EBELN", tmpEbeln.data.EBELN);
				gridList.setColValue("gridListSub",j,"EBELP", (j+1));
			
			}
			
			var head = gridList.getGridData("gridListHead");
			var list = gridList.getGridData("gridListSub");
			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/outbound/json/SaveTM06.data",
				param : param
			});
			

			if(gridList.checkResult(json)){
				commonUtil.msgBox("VALID_M0001");
				//searchList();
				gridList.resetGrid("gridListHead");
				gridList.resetGrid("gridListSub");
				gridList.viewJsonData("gridListHead", json.data);
				searchSubItemList(0);
			}
			gridList.setReadOnly("gridListHead", true);
			gridList.setReadOnly("gridListSub", true);
			uiList.setActive("Save", false);
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId=="gridListHead" && colName=="PTNRKY"){
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
						gridList.setColValue("gridListHead", rowNum, "NAME01", json.data["NAME01"]); 
					} 
				} else if(json.data["CNT"] < 1){
					commonUtil.msgBox("IN_M0063", colValue);
					gridList.setColValue("gridListHead", rowNum, "PTNRKY", ""); 
				}
			}else if(colValue==""){
				gridList.setColValue("gridListHead", rowNum, "NAME01", "");
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
			param.put("PTNRTY","VD");
			return param;
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
</script>
</head>
<body>
	<!-- contentHeader -->
	<div class="contentHeader">
		<div class="util">
			<button CB="Save SAVE STD_SAVE"></button>
		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
		</div>
	</div>
	<!-- //contentHeader -->
	<!-- searchPop -->
	<div class="searchPop" id="searchArea">
		<button type="button" class="closer">X</button>
		<div class="searchInnerContainer">
			<p class="util">
				<button CB="Search CREATE BTN_CREATE"></button>
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
								<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SSHTYP">출고유형</th>
							<td GCol="select,BWART">
								<select Combo="WmsOutbound,BWARTCOMBO2" name="BWART"></select>
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
							<li><a href="#tabs1-1"><span>일반</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
												<col width="40" />
												<col width="100" />
												<col width="140" />
												<col width="100" />
												<col width="100" />
												<col width="140" />
												<col width="140" />


											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'></th>
													<!-- <th CL='STD_EBELN'></th> --><!-- SAP P/O No -->
													<th CL='STD_ORDRNM'></th><!-- 주문번호 -->
													<!-- <th CL='STD_BWART'></th> --><!-- 이동유형 -->
													<th CL='STD_SSHTYP'></th><!-- 출고유형 -->
													<!-- <th CL='STD_ZEKKO_AEDAT'></th> --><!-- 레코드생성일 -->
													<th CL='STD_WADAT'></th><!-- 출고요청일 -->
													<th CL='STD_WAREKY'></th><!-- 거점 -->
													<th CL='STD_SUPLNM'></th><!-- 업체코드 -->
													<th CL='STD_LOTA04NM'></th><!-- 업체명 -->
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
												<col width="40" />
												<col width="100" />
												<col width="140" />
												<col width="100" />
												<col width="100" />
												<col width="140" />
												<col width="140" />
											</colgroup>
											<tbody id="gridListHead">
												<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="text,EBELN"></td>
													<td GCol="select,BWART">
														<select Combo="WmsOutbound,BWARTCOMBO2"></select>
													</td>
													<td GCol="input,ZEKKO_AEDAT" GF="C 8"></td>
													<td GCol="text,WAREKY"></td>
													<td GCol="input,PTNRKY,SHBZPTN" validate="required,VALID_M0405"></td>
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2" id="commonMiddleArea">
							<li><a href="#tabs1-1"><span>Item 리스트</span></a></li>
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
												<col width="140" />
												<col width="140" />
												<col width="100" />
												<col width="100" />

											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'></th>
													<th CL='STD_ORDRNM'>주문번호</th>
													<th CL='STD_ORDRIT'></th><!-- 주문IT번호 -->
													<!-- <th CL='STD_MATNR'></th> --><!-- 품번코드 -->
													<th CL='STD_SKUKEY'></th><!-- 품번코드 -->
													<th CL='STD_DESC01'></th><!-- 품명 -->
													<th CL='STD_LFIMG'>수량</th><!-- 수량 -->
													<th CL='STD_UOMKEY'></th><!-- 기본 단위 -->
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
												<col width="140" />
												<col width="140" />
												<col width="100" />
												<col width="100" />
											</colgroup>
											<tbody id="gridListSub">
												<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="text,EBELN"></td>
													<td GCol="text,EBELP"></td>
													<!-- <td GCol="input,SKUKEY,SHSKUMA" validate="required,OUT_M0020,SKUKEY" ></td> -->
													<td GCol="input,SKUKEY,SHSKUMA"></td><!-- 품번코그 -->													
													<td GCol="text,DESC01"></td><!-- 품명 -->					
													<!-- <td GCol="input,MENGE" GF="N 3" validate="required max(GRID_COL_MENGE_*)" ></td> -->
													<td GCol="input,QTSIWH" validate="required" GF="N 3"></td><!-- 수량 -->													
													<td GCol="text,UOMKEY"></td><!-- 단위 -->
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
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>