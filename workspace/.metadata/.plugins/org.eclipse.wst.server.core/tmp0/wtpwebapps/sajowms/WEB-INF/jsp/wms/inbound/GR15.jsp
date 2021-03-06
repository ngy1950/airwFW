<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(200);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			pkcol : "RECVKY",
			module : "WmsInbound",
			command : "GR15"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			module : "WmsInbound",
			command : "GR15Sub"
	    });
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });

			gridList.gridList({
		    	id : "gridListSub",
		    	param : param
		    });
			
			uiList.setActive("Save", true);
			uiList.setActive("Print", false);
			gridList.setReadOnly("gridListHead", false);
			gridList.setReadOnly("gridListSub", false);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_ADD, true);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_DELETE, true);
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		var param = inputList.setRangeParam("searchArea");
		var RCPTTY = param.get("RCPTTY");
		if(RCPTTY == "110"){
			gridList.setColValue("gridListSub", 0, "LOCAKY", "PRDLOC");
		}
		gridList.setRowState(gridId, configData.GRID_ROW_STATE_INSERT);
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
			newData.put("QTDUOM", "");
			newData.put("DUOMKY", "");
			newData.put("BOXQTY", "");
			newData.put("REMQTY", "");
			newData.put("UOMKEY", "");
			newData.put("LOTA01", "");
			newData.put("LOTA13", "");
			
			return newData;
		}
	}

	function gridListEventInputColFocus(gridId, rowNum, colName){
		if(gridId == "gridListSub" && colName == "LOTA03"){
			if(commonUtil.leftTrim(gridList.getColData("gridListSub",rowNum,"SKUKEY")," ") == ""){
				commonUtil.msgBox("VALID_M0937");
				gridList.setColFocus("gridListSub", rowNum, "SKUKEY");
			}
		}
	}
	
	function saveData(){
		if( gridList.validationCheck("gridListHead", "modify") && gridList.validationCheck("gridListSub", "modify") ) {

	 	 	if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var docunum = wms.getDocSeq("110");
	    	gridList.gridColModify("gridListHead", 0, "RECVKY", docunum);
			
			var head = gridList.getRowData("gridListHead", 0);

	    	var list = gridList.getGridData("gridListSub");

			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/saveGr15.data",
				param : param
			});
	
			if(json && json.data){
				
				commonUtil.msgBox("IN_M0093", docunum);
				
				var paramH = new DataMap();
				paramH.put("RECVKY", docunum);
			
				gridList.gridList({
			    	id : "gridListHead",
			    	command : "GR15H",
			    	param : paramH
			    });
				
				gridList.gridList({
			    	id : "gridListSub",
			    	command : "GR15I",
			    	param : paramH
			    }); 
				
				gridList.setReadOnly("gridListHead");
				gridList.setReadOnly("gridListSub");
				uiList.setActive("Save", false);
				uiList.setActive("Print", true);
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
							gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "DESC02", json.data["DESC02"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "LOTA05", json.data["SKUG04"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "LOTA13", json.data["RIMDMT"]);	
							gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "QTDUOM", json.data["QTDUOM"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "QTYRCV", '1');
							/* gridList.setColValue("gridListSub", rowNum, "BOXQTY", json.data["BOXQTY"]);	// ?????????
							gridList.setColValue("gridListSub", rowNum, "REMQTY", json.data["REMQTY"]);	// ?????? */
							gridList.setColValue("gridListSub", rowNum, "DUOMKY", json.data["DUOMKY"]);	// ??????
							gridList.setColValue("gridListSub", rowNum, "QTPUOM", json.data["QTPUOM"]);	// ?????? 
						}
					} else if (json.data["CNT"] < 1) {
						commonUtil.msgBox("VALID_M0206", colValue); //???????????? ?????? sku ?????????.
						
						gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
						gridList.setColValue("gridListSub", rowNum, "DESC01", "");
						gridList.setColValue("gridListSub", rowNum, "DESC02", "");
						gridList.setColValue("gridListSub", rowNum, "LOTA05", "");
						gridList.setColValue("gridListSub", rowNum, "LOTA13", "");
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", "");
						gridList.setColValue("gridListSub", rowNum, "QTDUOM", "");
						gridList.setColValue("gridListSub", rowNum, "QTYRCV", "");
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
			} else if (colName == "QTYRCV" && colValue != "") {
				var rowData = gridList.getRowData(gridId, rowNum);
				var qtyrcv = new Number(rowData.get("QTYRCV"));
				if(qtyrcv <=  0){
					commonUtil.msgBox("IN_M0048");
					gridList.setColValue("gridListSub", rowNum, "QTYRCV", ""); //????????????
					gridList.setColValue("gridListSub", rowNum, "BOXQTY", ""); //?????????
					gridList.setColValue("gridListSub", rowNum, "REMQTY", ""); //??????
					gridList.setFocus("gridListSub", rowNum, "QTYRCV");
					return;
				}
				var qtduom = new Number(rowData.get("QTDUOM"));
				var boxnum = parseInt(qtyrcv/qtduom);
				var remqty = qtyrcv - (qtduom*boxnum);
				gridList.setColValue(gridId, rowNum, "BOXQTY", boxnum);
				gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
			} 
		}
	}
	
	function reportPrint(){
		var list = gridList.getGridData("gridListSub");
		var url = "";
		var where = "AND BARCOD IN ("+commonUtil.getInParam(list, "BARCOD")+") ";
		alert(where);
		url = "/ezgen/barcodel.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", "<%=langky%>", map, 1250, 900);
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Print"){
			reportPrint();
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHBARCOD"){
			var rowNum = gridList.getFocusRowNum("gridListSub");
			var	skukey = gridList.getColData("gridListSub",rowNum,"SKUKEY");
			
			var param = new DataMap();
			param.put("SKUKEY", skukey)
			return param;
		}
	}
	
	function comboEventDataBindeBefore(comboAtt){
		if(comboAtt == "WmsInbound,RECDTYPEGR15"){
			var param = new DataMap();
			param.put("RCPTTY", configData.MENU_ID);
			return param;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Print PRINT BTN_PRINT"></button>
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
			<h2 class="tit" CL="STD_SELECTOPTIONS">????????????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">??????</th>
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">????????????</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,RECDTYPEGR15" name="RCPTTY"></select>
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
						<li><a href="#tabs1-1" CL="STD_GENERAL"><span>??????</span></a></li>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_RECVKY,2'></th>	<!-- ?????????????????? -->
												<th CL='STD_DOCCATNM'></th>	<!-- ???????????? -->
												<th CL='STD_WAREKY'></th>	<!-- ????????? -->
												<th CL='STD_DOCDAT'></th>	<!-- ???????????? -->
												<th CL='STD_ARCPTD'></th>	<!-- ???????????? -->
												<th CL='STD_RCPTTY'></th>	<!-- ???????????? -->
												<th CL='STD_RCPTTYNM'></th>	<!-- ??????????????? -->
												<th CL='STD_STATDO'></th>	<!-- ???????????? -->
												<th CL='STD_DOCTXT'></th>	<!-- ?????? -->
												<th CL='STD_USRID1'></th>     <!-- ?????????          -->
												<th CL='STD_UNAME1'></th>     <!-- ????????????        -->
												<th CL='STD_DEPTID1'></th>    <!-- ????????? ??????     -->
												<th CL='STD_DNAME1'></th>     <!-- ????????? ?????????   -->
												<th CL='STD_USRID2'></th>     <!-- ???????????????      -->
												<th CL='STD_UNAME2'></th>     <!-- ??????????????????    -->
												<th CL='STD_DEPTID2'></th>    <!-- ?????? ??????       -->
												<th CL='STD_DNAME2'></th>     <!-- ?????? ?????????     -->
												<th CL='STD_USRID3'></th>     <!-- ????????????        -->
												<th CL='STD_UNAME3'></th>     <!-- ??????????????????    -->
												<th CL='STD_DEPTID3'></th>    <!-- ???????????? ??????   -->
												<th CL='STD_DNAME3'></th>     <!-- ???????????? ????????? -->
												<th CL='STD_USRID4'></th>     <!-- ????????????        -->
												<th CL='STD_UNAME4'></th>     <!-- ??????????????????    -->
												<th CL='STD_DEPTID4'></th>    <!-- ???????????? ??????   -->
												<th CL='STD_DNAME4'></th>     <!-- ???????????? ????????? -->
												<th CL='STD_CREDAT'></th>	<!-- ???????????? -->
												<th CL='STD_CREUSR'></th>	<!-- ????????? -->
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,RECVKY"></td>	
												<td GCol="text,DOCCATNM"></td>
												<td GCol="text,WAREKY"></td>	
												<td GCol="text,DOCDAT"></td>	
												<td GCol="input,ARCPTD" validate="required,IN_M0123" GF="C 8"></td>
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
												<td GCol="text,USRID1"></td>	 
												<td GCol="text,UNAME1"></td>	 
												<td GCol="text,DEPTID1"></td>	 
												<td GCol="text,DNAME1"></td>	 
												<td GCol="text,USRID2"></td>	 
												<td GCol="text,UNAME2"></td>	 
												<td GCol="text,DEPTID2"></td>	 
												<td GCol="text,DNAME2"></td>	 
												<td GCol="input,USRID3"></td>	 
												<td GCol="text,UNAME3"></td>	 
												<td GCol="text,DEPTID3"></td>	 
												<td GCol="text,DNAME3"></td>	 
												<td GCol="text,USRID4"></td>	 
												<td GCol="text,UNAME4"></td>	 
												<td GCol="text,DEPTID4"></td>	 
												<td GCol="text,DNAME4"></td> 
												<td GCol="text,CREDAT"></td>
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
						<li><a href="#tabs1-1" CL="STD_ITEMLST"><span>Item ?????????</span></a></li>
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
												<th CL='STD_RECVIT,2'></th>	
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTYRCV'></th>
												<th CL='STD_LOCAKY'></th>
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
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_BOXQTY'>?????????</th>
												<th CL='STD_REMQTY'>??????</th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CREUSR'></th>
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
												<td GCol="rownum"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="input,SKUKEY,SHSKUMA" validate="required,VALID_M0406" GF="S 20"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="input,QTYRCV" validate="required,IN_M0062" GF="N 20"></td>
												<td GCol="input,LOCAKY,SHLOCMA" validate="required,VALID_M0404" GF="S 20"></td>	
												<td GCol="input,LOTA01" GF="S 20"></td>
												<td GCol="input,LOTA02" GF="S 20"></td>
												<td GCol="input,LOTA03,SHBARCOD" validate="required,VALID_M0936"></td>
												<td GCol="input,LOTA04" GF="S 20"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select Combo="WmsInbound,LOTA06COMBO"></select> 
												</td>
												<td GCol="input,LOTA07" GF="S 20"></td>
												<td GCol="input,LOTA08" GF="S 20"></td>
												<td GCol="input,LOTA09" GF="S 20"></td>
												<td GCol="input,LOTA10" GF="S 20"></td>
												<td GCol="input,LOTA11" GF="C 8"></td>
												<td GCol="input,LOTA12" GF="C 8"></td>
												<td GCol="input,LOTA13" GF="C 8"></td>
												<td GCol="input,LOTA14" GF="S 20"></td>
												<td GCol="input,LOTA15" GF="S 20"></td>
												<td GCol="input,LOTA16" GF="S 20,3"></td>
												<td GCol="input,LOTA17" GF="S 20,3"></td>
												<td GCol="input,LOTA18" GF="S 20,3"></td>
												<td GCol="input,LOTA19" GF="S 20,3"></td>
												<td GCol="input,LOTA20" GF="S 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTDUOM"></td>
												<td GCol="text,BOXQTY" GF="N"></td>
												<td GCol="text,REMQTY" GF="N"></td>
												<td GCol="text,CREDAT"></td>
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