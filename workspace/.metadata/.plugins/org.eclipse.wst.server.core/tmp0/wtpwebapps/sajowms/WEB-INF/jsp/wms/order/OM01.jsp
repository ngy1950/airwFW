<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	var shprqk;
	var ownrky;
	$(document).ready(function(){
		setTopSize(1000);
	 	gridList.setGrid({
	    	id : "gridList",
			editable : true,
			module : "WmsOrder",
			command : "OM01",
			defaultRowStatus : configData.GRID_ROW_STATE_INSERT,
			excelRequestGridData : true
		}); 
	 	
	 	ownrky = $('#OWNRKY').val();
		$('#OWNRKY').change(function(){
			clearData();
		});
	 	
	 	$("#AREAKY").val("<%=user.getUserg5()%>");
		searchList();
	});
	
	function searchList(){
		var param = inputList.setRangeParam("om01top");

		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		
		$('select[name="AREAKY"]').attr("disabled",false);
		$('select[name="SRQTYP"]').attr("disabled",false);
		$("#om01top").find("[name=RQSHPD]").attr("readonly",false);
		$("#om01top").find("[name=DOCTXT]").attr("readonly",false);
		gridList.setReadOnly("gridList", false);
		gridList.setReadOnly("gridList", true, ['ASKU05']);
		uiList.setActive("Save", true);
	}
	
	function saveData(){
		if(validate.check("om01top") && gridList.validationCheck("gridList", "select")){
			
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		var json = netUtil.sendData({
			module : "WmsOrder",
			command : "SEQSHPRQK",
			sendType : "map"
		});
		shprqk = json.data["SEQ"].trim();
		$('#SHPRQK').val(shprqk);
		
	        var param = dataBind.paramData("om01top");
	       //var list = gridList.getGridAvailData("gridList");
	        var list = gridList.getSelectData("gridList");
	        param.put("list", list);
	        param.put("SHPRQK",shprqk);

			var json = netUtil.sendData({
				url : "/wms/order/json/saveOM01.data",
				param : param
			});
	        
	        if(json && json.data){
	        	commonUtil.msgBox("MASTER_M0564");
	        	$('select[name="AREAKY"]').attr("disabled",true);
	        	$('select[name="SRQTYP"]').attr("disabled",true);
	        	$("#om01top").find("[name=RQSHPD]").attr("readonly",true);
	        	$("#om01top").find("[name=DOCTXT]").attr("readonly",true);
	        	gridList.setReadOnly("gridList", true);
	        	gridList.setReadOnly("gridList", true, ['ASKU05']);
				uiList.setActive("Save", false);
	        }
		}
	}
	
	function clearData(){
		if(!commonUtil.msgConfirm("VALID_M0011")){
			return;
		}
		
		var now = new Date();
		now.setDate(now.getDate());
		/* now.setDate(now.getDate()+1); */
		var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
		$("#om01top").find("[name=RQSHPD]").val(tmpValue).trigger("change");
		$("#om01top").find("[name=DOCTXT]").val("");
		$("#om01top").find("[name=PTRCVR]").val("");
		$("#om01top").find("[name=SHPRQK]").val("");
		$("#AREAKY").val("<%=user.getUserg5()%>");
		searchList();
	}
	
	function changeArea(){
		var now = new Date();
		now.setDate(now.getDate());
		var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
		$("#om01top").find("[name=RQSHPD]").val(tmpValue).trigger("change");
		$("#om01top").find("[name=DOCTXT]").val("");
		searchList();
	}
	
	function changeSrqtyp(){
		var now = new Date();
		now.setDate(now.getDate());
		var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
		$("#om01top").find("[name=RQSHPD]").val(tmpValue).trigger("change");
		$("#om01top").find("[name=DOCTXT]").val("");
		searchList();
	}

	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
 		if (gridId == "gridList") {
 			if (colName == "SKUKEY") {
 				if(colValue != ""){
 					var param = inputList.setRangeParam("om01top");
					param.put("OWNRKY", $('#OWNRKY').val());
					param.put("WAREKY", "<%=wareky%>");
					param.put("SKUKEY", colValue);

					<%-- var json = netUtil.sendData({
						module : "WmsOrder",
						command : "SKUKEYval",
						sendType : "map",
						param : param
					});
					if(json.data["CNT"] >= 1) {
						var param = new DataMap();
						var param = inputList.setRangeParam("om01top");
						param.put("INPUTSKU", colValue);
						param.put("OWNRKY", "<%=ownrky%>");
						param.put("WAREKY", "<%=wareky%>"); --%>
						
						var json = netUtil.sendData({
							module : "WmsOrder",
							command : "OM01SKUKEY",
							sendType : "map",
							param : param
						});
						
						/* if(json && json.data){
							gridList.setColValue("gridList", rowNum, "SKUKEY", json.data["SKUKEY"]);
							gridList.setColValue("gridList", rowNum, "MATNR",  json.data["MATNR"]);
							gridList.setColValue("gridList", rowNum, "DESC01", json.data["DESC01"]);
							gridList.setColValue("gridList", rowNum, "DESC02", json.data["DESC02"]);
							gridList.setColValue("gridList", rowNum, "UOMKEY", json.data["UOMKEY"]);
							gridList.setColValue("gridList", rowNum, "QTSIWH", json.data["QTSIWH"]);
							gridList.setColValue("gridList", rowNum, "QTTTWH", json.data["QTTTWH"]);
						} */
						if(json.data != null){
							gridList.setColValue("gridList", rowNum, "MATNR", json.data["MATNR"]);
							gridList.setColValue("gridList", rowNum, "ASKU05", json.data["ASKU05"]);
							gridList.setColValue("gridList", rowNum, "DESC01", json.data["DESC01"]);
							gridList.setColValue("gridList", rowNum, "DESC02", json.data["DESC02"]);
							gridList.setColValue("gridList", rowNum, "UOMKEY", json.data["UOMKEY"]);
							gridList.setColValue("gridList", rowNum, "QTSIWH", json.data["QTSIWH"]);
							gridList.setColValue("gridList", rowNum, "QTTTWH", json.data["QTTTWH"]);
							gridList.setColValue("gridList", rowNum, "TEXT", "");
							gridList.setRowCheck("gridList", rowNum, true);
						}else if(json.data == null){
							gridList.setColValue("gridList", rowNum, "DESC01", "");
							gridList.setColValue("gridList", rowNum, "DESC02", "");
							gridList.setColValue("gridList", rowNum, "UOMKEY", "");
							gridList.setColValue("gridList", rowNum, "QTSIWH", "");
							gridList.setColValue("gridList", rowNum, "QTTTWH", "");
							gridList.setColValue("gridList", rowNum, "QTYORD", "");
							gridList.setColValue("gridList", rowNum, "MATNR", "");
							gridList.setColValue("gridList", rowNum, "ASKU05", "");
							gridList.setColValue("gridList", rowNum, "TEXT",  "Not Exist IMV Item Code");
							gridList.setRowCheck("gridList", rowNum, false);
						}
					/* }else if (json.data["CNT"] < 1) {
						//commonUtil.msgBox("VALID_M0206", colValue); //존재하지 않는 sku 입니다.
						gridList.setColValue("gridList", rowNum, "INPUTSKU", "");
						gridList.setColValue("gridList", rowNum, "SKUKEY",   "");
						gridList.setColValue("gridList", rowNum, "MATNR",   "");
						gridList.setColValue("gridList", rowNum, "DESC01",   "");
						gridList.setColValue("gridList", rowNum, "DESC02",   "");
						gridList.setColValue("gridList", rowNum, "UOMKEY",   "");
						gridList.setColValue("gridList", rowNum, "QTSIWH",   "");
						gridList.setColValue("gridList", rowNum, "QTTTWH",   "");
						gridList.setColValue("gridList", rowNum, "QTYORD",   "");
						gridList.setRowCheck("gridList", rowNum, false);
						return;
					} */
					/* 
					var SRQTYP = $("#om01top").find("[name=SRQTYP]").val();
					if(SRQTYP == "4"){
						var json = netUtil.sendData({
							module : "WmsOrder",
							command : "OM01SKUKEY2",
							sendType : "map",
							param : param
						});
						
						if(json && json.data){
							null;
						}else{
							commonUtil.msgBox("VALID_M1564", colValue); //특수교환 상품이 아닙니다.
							gridList.setColValue("gridList", rowNum, "SKUKEY", "");
							gridList.setColValue("gridList", rowNum, "DESC01", "");
							gridList.setColValue("gridList", rowNum, "DESC02", "");
							gridList.setColValue("gridList", rowNum, "UOMKEY", "");
							gridList.setColValue("gridList", rowNum, "QTSIWH", "");
							gridList.setColValue("gridList", rowNum, "QTTTWH", "");
							gridList.setColValue("gridList", rowNum, "QTYORD", "");
							gridList.setColValue("gridList", rowNum, "MATNR",  "");
							gridList.setColValue("gridList", rowNum, "ASKU05",  "");
							gridList.setColValue("gridList", rowNum, "TEXT",   "");
							gridList.setRowCheck("gridList", rowNum, false);
						}
					} */
 				}else{//값이 지워졌을 떄
					gridList.setColValue("gridList", rowNum, "MATNR",   "");
					gridList.setColValue("gridList", rowNum, "DESC01", "");
					gridList.setColValue("gridList", rowNum, "DESC02", "");
					gridList.setColValue("gridList", rowNum, "UOMKEY", "");
					gridList.setColValue("gridList", rowNum, "QTSIWH", "");
					gridList.setColValue("gridList", rowNum, "QTTTWH", "");
					gridList.setColValue("gridList", rowNum, "QTYORD", "");
					gridList.setColValue("gridList", rowNum, "ASKU05",   "");
					gridList.setColValue("gridList", rowNum, "TEXT",   "");
					gridList.setRowCheck("gridList", rowNum, false);
				}
 			}
 		}
	}
 	
 	function gridListEventColBtnclick(gridId, rowNum, btnName){
 		if(gridId == "gridList"){
 			if(btnName == "Start"){
 				var rowData = gridList.getRowData(gridId, rowNum);
 				var itemData = dataBind.paramData("om01top");
 				var headData = gridList.getRowData("gridList", gridList.getFocusRowNum("gridList"));
 				rowData.putAll(headData);
 				rowData.putAll(itemData);
 				dataBind.paramData("searchArea", rowData);
 				page.linkPopOpen("/wms/order/OM01POP.page", rowData);
 			}
 		}
 	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		/* if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			dataBind.paramData("searchArea", rowData);
			page.linkPopOpen("/wms/order/SKU_IMG_POP.page", rowData);
		} */
	}
 	
 	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", $('#OWNRKY').val());
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHBZPTN"){
			var param = new DataMap();
			param.put("OWNRKY", $('#OWNRKY').val());
			if($('#SHPMTY').val() == "231"){
				param.put("PTNRTY", "VD");
			}else{
				param.put("PTNRTY", "CT");
			}
			return param;
		}
 	}
	 
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList"){
			var newData = new DataMap();
			newData.put("OWNRKY", $('#OWNRKY').val());
			return newData;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Check"){
			clearData();
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Check CHECK BTN_CLEAR"></button>
		<button CB="Save SAVE STD_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<!-- TOP FieldSet -->
			<div class="foldSect" id="foldSect">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_ORDERINFO'></span></a></li>
					</ul>
				<div id="tabs-1">
					<div class="section type1">
						<table class="table type1" id="om01top">
							<colgroup>
								<col width="200"/>
								<col />
								<col />
								<col />
								<col />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th CL="STD_SHPRQK"></th>
									<td>
										<input type="text" name="SHPRQK" id="SHPRQK" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th CL="STD_WAREKY">거점</th>
									<td>
										<input type="text" name="WAREKY" value="<%=wareky%>" size="8px" readonly="readonly" validate="required"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_OWNRKY">화주</th>
									<td>
										<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
										</select>
									</td>
								</tr>
								<tr>
									<th CL="STD_SSHTYP">출고유형</th>
									<td GCol="select,SHPMTY">
										<select Combo="WmsOrder,SHPMTYCOMBO" name="SHPMTY" id="SHPMTY">
										</select>
									</td>
								</tr>
								<tr>
									<th CL="STD_RQSHPD">출고요청일자</th>
									<td>
										<input type="text" name="RQSHPD" UIFormat="C N" validate="required"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_PTNRKY0,3">공급사</th>
									<td>
										<input type="text" name="PTRCVR" id="PTRCVR" UIInput="S,SHBZPTN" validate="required,INV_M0707"/>
									</td>
								</tr>
<!-- 								<tr> -->
<!-- 									<th CL="STD_SRQTYP">출고 타입</th> -->
<!-- 									<td GCol="select,SRQTYP"> -->
<!-- 										<select Combo="WmsOrder,OM01COMBO" onchange="changeSrqtyp();" name="SRQTYP" id="SRQTYP" validate="required"> -->
<!-- 										</select> -->
<!-- 									</td> -->
<!-- 								</tr> -->
								<!-- <tr>
									<th CL="STD_DOCTXT"></th>
									<td>
										<input type="text" name="DOCTXT" style="width: 500px"/>
									</td>
								</tr> -->
							</tbody>
						</table>
					</div>
				</div>
				</div>
			</div>
			<!-- BOTTOM FieldSet -->
			<div class="bottomSect" style="top:215px;">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_LIST'></span></a></li>
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
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
<!-- 												<th CL='STD_OWNRKY'></th> -->
<!-- 												<th CL='STD_OWNERNAME'></th> -->
												<th CL='STD_SKUKEY'></th>
<!-- 												<th CL='STD_SearchCode,3'></th> -->
												<th CL='STD_DESC01'></th>
<!-- 												<th CL='STD_MATNR,3'></th> -->
												<th CL='STD_SKUG05'></th>
<!-- 												<th CL='STD_ASKU05'></th> -->
												<th CL='STD_BDMNG'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTSCNT'></th>
												<th CL='STD_QTTTTWH'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
<!-- 												<th CL='EZG_LOTA02'></th> -->
<!-- 												<th CL='STD_ETCBTN'></th> -->
												<th CL='STD_VALIDC'></th>
												<th CL='STD_DOCTXT'></th>
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
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
<!-- 												<td GCol="text,OWNRKY" validate="required" GF="S 10"></td> -->
<!-- 												<td GCol="text,OWNRNM"></td> -->
												<td GCol="input,SKUKEY,SHSKUMA" validate="required" GF="S 20"></td>
<!-- 												<td GCol="text,SKUKEY"></td> -->
												<td GCol="text,DESC01"></td>
<!-- 												<td GCol="text,MATNR"></td> -->
												<td GCol="text,DESC02" ></td>
<!-- 												<td GCol="check,ASKU05" ></td> -->
												<td GCol="input,QTYORD" validate="required gt(0)" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GCol="text,QTTTWH" GF="N 20,3"></td>
												<td GCol="input,LOTA10" GF="S 20"></td>
												<td GCol="input,LOTA16" GF="N 20,3"></td>
												<td GCol="input,LOTA17" GF="N 20,3"></td>
<!-- 												<td GCol="select,COSTCT"> -->
<!-- 													<select Combo="WmsOrder,COSTCTCOMBO"></select> -->
<!-- 												</td> -->
<!-- 												<td GCol="btn,ETCBTN" GB="Start EXTCUTE ..."></td> -->
												<td GCol="text,TEXT"></td>
												<td GCol="input,DOCTXT" GF="S 180"></td>
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