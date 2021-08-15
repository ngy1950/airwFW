<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(200);
		gridList.setGrid({
	    	id : "gridList",
			editable : true,
			pkcol : "RECVKY",
			module : "WmsInbound",
			command : "GR20"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			module : "WmsInbound",
			command : "GR20Sub",
			defaultRowStatus : configData.GRID_ROW_STATE_START
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
		uiList.setActive("Save", false);
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	});
	
	var DOCUTY = "";
	function searchList(){
		if(validate.check("searchArea")){
			
			var param = inputList.setRangeParam("searchArea");
			var comboData = param.get("DOCUTY");
			if(DOCUTY != comboData){
				gridList.setComboOption("gridListSub", "RSNCOD", configData.INPUT_REASON_COMBO, comboData);
				DOCUTY = comboData;
			}
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });

			gridList.gridList({
		    	id : "gridListSub",
		    	param : param
		    });
			
			uiList.setActive("Save", true);
			gridList.setReadOnly("gridList", false);
			gridList.setReadOnly("gridListSub", false);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_ADD, true);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_DELETE, true);
			gridList.setReadOnly("gridListSub", true, ['LOTA06']);
		}
	}
	
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridListSub" && rowNum == 0){
			return false;
		}
		return true;
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridListSub"){
			var newData = gridList.getRowData("gridListSub", 0);
			newData.put("SKUKEY", "");
			newData.put("DESC01", "");
			newData.put("DESC02", "");
			newData.put("UOMKEY", "");
			newData.put("MEASKY", "");
			newData.put("TRNUID", "");
			newData.put("QTYRCV", "");
			newData.put("LOTA01", "");
			newData.put("LOTA02", "");
			newData.put("LOTA03", "");
			newData.put("LOTA04", "");
			newData.put("LOTA05", "");
			newData.put("LOTA06", "");
			newData.put("LOTA07", "");
			newData.put("LOTA08", "");
			newData.put("LOTA09", "");
			newData.put("LOTA10", "");
			newData.put("LOTA16", "");
			newData.put("LOTA17", "");
			newData.put("RSNCOD", "");
			newData.put("TASRSN", "");
			
			return newData;
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridListSub", "modify")) {

	 	 	if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var head = gridList.getRowData("gridList", 0);

	    	var list = gridList.getGridAvailData("gridListSub");

			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/saveGr03.data",
				param : param
			});

			if(json && json.data){
				commonUtil.msgBox("MASTER_M0564");
				var recvky = json.data;
				
				gridList.setColValue("gridList", 0, "RECVKY", recvky);
				
				gridList.setReadOnly("gridList", true);
				gridList.setReadOnly("gridListSub", true);
				uiList.setActive("Save", false);
				gridList.setBtnView("gridListSub", configData.GRID_BTN_ADD, false);
				gridList.setBtnView("gridListSub", configData.GRID_BTN_DELETE, false);
			}
		}
	}

	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if (gridId == "gridListSub") {
			if (colName == "SKUKEY") {
				if(colValue != ""){
					
					var param = inputList.setRangeParam("searchArea");
					param.put("SKUKEY", colValue);

					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "SKUKEYval",
						sendType : "map",
						param : param
					});
					
					
					if(json.data["CNT"] >= 1) {

						var param = new DataMap();
						var param = inputList.setRangeParam("searchArea");
						param.put("SKUKEY", colValue);
						
						var json = netUtil.sendData({
							module : "WmsInbound",
							command : "SKUKEY",
							sendType : "map",
							param : param
						});
						
						if(json && json.data){
							gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]);
							gridList.setColValue("gridListSub", rowNum, "DESC02", json.data["DESC02"]);
							gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);
							gridList.setColValue("gridListSub", rowNum, "MEASKY", json.data["MEASKY"]);
						}
					} else if (json.data["CNT"] < 1) {
						commonUtil.msgBox("VALID_M0206", colValue); //존재하지 않는 sku 입니다.
						
						gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
						gridList.setColValue("gridListSub", rowNum, "DESC01", "");
						gridList.setColValue("gridListSub", rowNum, "DESC02", "");
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", "");
						gridList.setColValue("gridListSub", rowNum, "MEASKY", "");
						gridList.setFocus("gridListSub", "SKUKEY");
					}
				}
			}else if (colName == "LOCAKY") {
				if(colValue != ""){
					var param = inputList.setRangeParam("searchArea");
					
					param.put("LOCAKY", colValue);
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "LOCAKYval",
						sendType : "map",
						param : param
					});
					
					if (json.data["CNT"] < 1) {
						commonUtil.msgBox("VALID_M0204", colValue);
						
						gridList.setColValue("gridListSub", rowNum, "LOCAKY", "");
						gridList.setFocus("gridListSub", "LOCAKY");
					}
				}
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param =dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHLOCMA"){
			var param = inputList.setRangeParam("searchArea");
			return param;
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
		<p class="util">
			<button CB="Create CREATE BTN_CREATE"></button>
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
						<td>
							<input type="text" name="WAREKY" size="8px"  value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY,2">입고창고</th>
						<td>
							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
								<!-- <option value="">선택</option> -->
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCUTY"></th>
						<td>
							<select Combo="WmsInbound,DOCUTYGR03" validate="required" name="DOCUTY">
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
						<li><a href="#tabs1-1" CL="STD_DOCUMENTINFO"><span></span></a></li>
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
												<th CL='STD_NUMBER'></th>
												<th CL='STD_RECVKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_AREANM'></th>
												<th CL='STD_DOCUTY'></th>
												<th CL='STD_DOCTNM'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM,2'></th>
												<th CL='STD_DOCTXT'></th>
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
												<td GCol="rownum"></td>
												<td GCol="text,RECVKY"></td>	
												<td GCol="text,WAREKY"></td>	
												<td GCol="text,WARENM"></td>	
												<td GCol="input,DOCDAT" GF="C N"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,AREANM"></td>
												<td GCol="text,DOCUTY"></td>
												<td GCol="text,DOCTNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATDONM"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
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
						<li><a href="#tabs1-1" CL="STD_DETAILLIST"><span></span></a></li>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_QTYRCV'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA11'></th>
												<!-- <th CL='STD_LOTA12'></th> -->
												<th CL='STD_LOTA13'></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
										</colgroup>
										<tbody id="gridListSub">
										<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="input,SKUKEY,SHSKUMA" validate="required,VALID_M0406" GF="S 20"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="input,LOCAKY,SHLOCMA" validate="required,VALID_M0404" GF="S 20"></td>	
												<td GCol="input,TRNUID" GF="S 30"></td>
												<td GCol="input,QTYRCV" validate="required,IN_M0062 gt(0)" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="input,LOTA02"></td>
												<td GCol="input,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select Combo="WmsInbound,LOTA06COMBO2"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="input,LOTA10"></td>
												<td GCol="input,LOTA16" GF="N 20,3"></td>
												<td GCol="input,LOTA17" GF="N 20,3"></td>
												<td GCol="input,LOTA11" GF="C N"></td>
												<!-- <td GCol="input,LOTA12" GF="C N"></td> -->
												<td GCol="input,LOTA13" GF="C N"></td>
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