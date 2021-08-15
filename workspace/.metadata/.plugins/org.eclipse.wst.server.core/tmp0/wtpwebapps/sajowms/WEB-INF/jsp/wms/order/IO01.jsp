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
	var wareky;
	var rcvrqk;
	var ownrky;
	
	$(document).ready(function(){
		setTopSize(1000);
	 	gridList.setGrid({
	    	id : "gridList",
			editable : true,
			module : "WmsOrder",
			command : "IO01",
			defaultRowStatus : configData.GRID_ROW_STATE_INSERT,
			excelRequestGridData : true
		}); 
	 	
		wareky = "<%= wareky%>";
		if(wareky == 'WH01'){
			$('select[name="AREAKY"]').val("V05");
			$("#USERAREA").attr("disabled",true);
		}else{
			$("#USERAREA").val("<%=user.getUserg5()%>");
		}
		
		ownrky = $('#OWNRKY').val();
		$('#OWNRKY').change(function(){
			clearData();
		});
		searchList();
	});
	
	function searchList(){
		var param = inputList.setRangeParam("io01top");
		
		var WAREKY = param.get("WAREKY");
		if(WAREKY == "WH01"){
			$("#io01top").find("[name=RQSHPD]").attr("readonly",true);
			$("#io01top").find("[name=PTRCVR]").attr("readonly",true);
		}else{
			$("#io01top").find("[name=RQSHPD]").attr("readonly",false);
			$("#io01top").find("[name=PTRCVR]").attr("readonly",false);
		}
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });

		if(wareky == 'WH01'){
			$('select[name="AREAKY"]').attr("disabled",true);
		}else{
			$('select[name="AREAKY"]').attr("disabled",false);
		}
    	$("#io01top").find("[name=ASNDAT]").attr("readonly",false);
    	$("#io01top").find("[name=DPTNKY]").attr("readonly",false);
    	$("#io01top").find("[name=DOCTXT]").attr("readonly",false);
    	$("#io01top").find("[name=OWNRKY]").attr("disabled",false);
    	$("#io01top").find("[name=RCPTTY]").attr("disabled",false);
    	
    	
    	gridList.setReadOnly("gridList", false);
		uiList.setActive("Save", true);
	}
	
	function saveData(){
		if(validate.check("io01top") && gridList.validationCheck("gridList", "modify")){
			
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		/* var json = netUtil.sendData({
			module : "WmsOrder",
			command : "SEQRCVRQK",
			sendType : "map"
		}); */
		
		//rcvrqk = json.data["SEQ"].trim();
		//$('#RCVRQK').val(rcvrqk);
		
			var param = dataBind.paramData("io01top");
			
			var json = netUtil.sendData({
				module : "WmsOrder",
				command : "BZPTNval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] <= 0) {
				commonUtil.msgBox("ORDER_M0001");
				$("#io01top").find("[name=DPTNKY]").val("").focus();
				return;
			}
			
	        var list = gridList.getGridAvailData("gridList");
	        param.put("list", list);
	        //param.put("RCVRQK",rcvrqk);
	        
	        var json = netUtil.sendData({
				url : "/wms/order/json/saveIO01.data",
				param : param
			});

	        if(json && json.data){
	        	$('select[name="AREAKY"]').attr("disabled",true);

		        commonUtil.msgBox("MASTER_M0564");
		        		
	        	$("#SEBELN").val(json.data);
	        	$("#io01top").find("[name=ASNDAT]").attr("readonly",true);
		        $("#io01top").find("[name=DPTNKY]").attr("readonly",true);
		        $("#io01top").find("[name=DOCTXT]").attr("readonly",true);
		        $("#io01top").find("[name=RQSHPD]").attr("readonly",true);
		        $("#io01top").find("[name=PTRCVR]").attr("readonly",true);
		        $("#io01top").find("[name=OWNRKY]").attr("disabled",true);
		        $("#io01top").find("[name=RCPTTY]").attr("disabled",true);
		        gridList.setReadOnly("gridList", true);
		        gridList.setBtnActive("gridList", configData.GRID_BTN_ADD, false);
		        gridList.setBtnActive("gridList", configData.GRID_BTN_DELETE, false);
		        
				uiList.setActive("Save", false);
	        }
		}
	}
	
	function clearData(){
		if(!commonUtil.msgConfirm("VALID_M0011")){
			$('#OWNRKY').val(ownrky);
			return;
		}
		
		ownrky = $('#OWNRKY').val();
		
		$("#io01top").find("[name=AREAKY]").val("V05");
		var now = new Date();
		now.setDate(now.getDate());
		var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
		
		/* var tomorrow = new Date();
		tomorrow.setDate(now.getDate()+1);
		var tmpValue2 = uiList.dateFormat(tomorrow, site.COMMON_DATE_TYPE); */
		
		$("#io01top").find("[name=RQSHPD]").val(tmpValue).trigger("change");
		$("#io01top").find("[name=ASNDAT]").val(tmpValue).trigger("change");
		$("#io01top").find("[name=DOCTXT]").val("");
		$("#io01top").find("[name=SEBELN]").val(""); 
		$("#io01top").find("[name=DPTNKY]").val("");
		$("#io01top").find("[name=DPTNNM]").val("");
		$("#io01top").find("[name=PTRCVR]").val("");
		$("#AREAKY").val("<%=user.getUserg5()%>");
		
    	gridList.setBtnActive("gridList", configData.GRID_BTN_ADD, true);
    	gridList.setBtnActive("gridList", configData.GRID_BTN_DELETE, true);
		searchList();
	}

 	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
 		if (gridId == "gridList") {
 			if (colName == "SKUKEY") {
 				if(colValue != ""){
 					if($("#io01top").find("[name=AREAKY]").val() == ""){
 						commonUtil.msgBox("MASTER_M0254");
 						gridList.setColValue("gridList", rowNum, "INPUTSKU", "");
 						$("#io01top").find("[name=AREAKY]").focus();
 					}else{
	 					var param = inputList.setRangeParam("io01top");
						//param.put("INPUTSKU", colValue);
						param.put("SKUKEY", colValue);
						param.put("OWNRKY", $('#OWNRKY').val());
						param.put("WAREKY", "<%=wareky%>");
	
						var json = netUtil.sendData({
							module : "WmsOrder",
							command : "SKUKEYval",
							sendType : "map",
							param : param
						});
						if(json.data["CNT"] >= 1) {
							var param = new DataMap();
							var param = inputList.setRangeParam("io01top");
							param.put("SKUKEY", colValue);
							param.put("OWNRKY", $('#OWNRKY').val());
							param.put("WAREKY", "<%=wareky%>");
							
							var json = netUtil.sendData({
								module : "WmsOrder",
								command : "IO01SKUKEY",
								sendType : "map",
								param : param
							});
							
							if(json && json.data){
								//gridList.setColValue("gridList", rowNum, "SKUKEY", json.data["SKUKEY"]);
 								//gridList.setColValue("gridList", rowNum, "MATNR",  json.data["MATNR"]);
 								//gridList.setColValue("gridList", rowNum, "DESC02", json.data["DESC02"]);
								gridList.setColValue("gridList", rowNum, "DESC01", json.data["DESC01"]);
								gridList.setColValue("gridList", rowNum, "UOMKEY", json.data["UOMKEY"]);
								gridList.setColValue("gridList", rowNum, "QTSIWH", json.data["QTSIWH"]);
							}
						}else if (json.data["CNT"] < 1) {
							commonUtil.msgBox("VALID_M0206", colValue); //존재하지 않는 sku 입니다.
							//gridList.setColValue("gridList", rowNum, "INPUTSKU", "");
							gridList.setColValue("gridList", rowNum, "SKUKEY", "");
							//gridList.setColValue("gridList", rowNum, "MATNR", "");
							gridList.setColValue("gridList", rowNum, "DESC01", "");
							//gridList.setColValue("gridList", rowNum, "DESC02", "");
							gridList.setColValue("gridList", rowNum, "UOMKEY", "");
							gridList.setColValue("gridList", rowNum, "QTSIWH", "");
							gridList.setFocus("gridList", "SKUKEY");
						}
 					}
 				}else{
 	 				gridList.setColValue("gridList", rowNum, "SKUKEY", "");
//  					gridList.setColValue("gridList", rowNum, "MATNR", "");
 					gridList.setColValue("gridList", rowNum, "DESC01", "");
// 					gridList.setColValue("gridList", rowNum, "DESC02", "");
 					gridList.setColValue("gridList", rowNum, "UOMKEY", "");
 					gridList.setColValue("gridList", rowNum, "QTSIWH", "");
 	 			}
 			}
 		}
	} 
	 
 	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		var param = new DataMap();
		if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", $('#OWNRKY').val());
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHBZPTN"){
			if($inputObj.name == "DPTNKY"){
				param.put("OWNRKY", $('#OWNRKY').val());
				param.put("PTNRTY", "VD");
				if($('#RCPTTY').val().substring(0,2) == "13"){
					param.put("PTNRTY", "CT");
				}
				return param;
			}else if($inputObj.name == "PTRCVR"){
				param.put("OWNRKY", $('#OWNRKY').val());
				param.put("PTNRTY", "CT");
				return param;
			}
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
	
	function dptVal(){
		var param = dataBind.paramData("io01top");
		
		if($("#io01top").find("[name=DPTNKY]").val() == "" ){
			$("#io01top").find("[name=DPTNNM]").val("");
			return;
		}		
		var json = netUtil.sendData({
			module : "WmsOrder",
			command : "BZPTNval",
			sendType : "map",
			param : param
		});
		
		if(json.data["CNT"] <= 0) {
			commonUtil.msgBox("ORDER_M0001");
			$("#io01top").find("[name=DPTNKY]").val("").focus();
			$("#io01top").find("[name=DPTNNM]").val("");
			return;
		}else {
			var json = netUtil.sendData({
				module : "WmsOrder",
				command : "BZPTNname",
				sendType : "map",
				param : param
			});
			
			$("#io01top").find("[name=DPTNNM]").val(json.data["NAME01"]);
		}
	}
	
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		var dptnNm = rowData.get("NAME01");
		$("#io01top").find("[name=DPTNNM]").val(dptnNm);
	}
	
	function comboEventDataBindeBefore(comboAtt){
		if(comboAtt == "WmsOrder,RCPTTYCOMBO"){
			var param = new DataMap();
			param.put("DOCCAT", "100");
			param.put("PROGID", configData.MENU_ID);
			return param;
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
						<table class="table type1" id="io01top">
							<colgroup>
								<col width="10%"/>
								<col width="13%"/>
								<col width="7%"/>
							</colgroup>
							<tbody>
								<tr>
								<!-- <th CL="STD_RCVRQK">입고요청번호</th>
									<td>
										<input type="text" name="RCVRQK" id="RCVRQK" readonly="readonly" />
									</td>
								</tr> -->
								<tr>
									<th CL="STD_SEBELN">구매오더번호</th>
									<td>
										<input type="text" name="SEBELN" id="SEBELN" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_WAREKY">거점</th>
									<td>
										<input type="text" name="WAREKY" value="<%=wareky%>" style="width:150px;" 
											   readonly="readonly" validate="required"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_OWNRKY">화주</th>
									<td>
										<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY" style="width:150px;" >
										</select>
									</td>
								</tr>
								<tr>
									<th CL="STD_RCPTTY">입고유형</th>
									<td>
										<select Combo="WmsOrder,RCPTTYCOMBO" name="RCPTTY" id="RCPTTY" style="width:150px;" >
										</select> 

									</td>
								</tr>
								<tr>
									<th CL="STD_ASNDAT,3">입고예정일자</th>
									<td>
										<input type="text" name="ASNDAT" UIFormat="C N" validate="required"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_DPTNKY,3">공급사</th>
									<td>
										<input type="text" name="DPTNKY" id="DPTNKY" UIInput="S,SHBZPTN" 
										 onchange="dptVal();" validate="required,INV_M0704"/>
									</td>
									<th CL="STD_DPTNNM1">공급사명</th>
									<td>
										<input type="text" name="DPTNNM" readonly="readonly" style="width:200px;" />
									</td>
								</tr>
								<!-- <tr>
									<th CL="STD_RQSHPD">출고예정일자</th>
									<td>
										<input type="text" name="RQSHPD" UIFormat="C N" validate="required"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_PTRCVR,3">매출처</th>
									<td>
										<input type="text" name="PTRCVR" validate="required" UIInput="S,SHBZPTN"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_AREAKY,2">입고창고</th>
									<td>
										<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="AREAKY" validate="required" >
											<option value="">선택</option>
										</select>
									</td>
								</tr> -->
								<tr>
									<th CL="STD_DOCTXT"></th>
									<td colspan="3">
										<input type="text" name="DOCTXT" style="width: 500px;"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				  </div>
				</div>
			</div>
			
			<!-- BOTTOM FieldSet -->
			<div class="bottomSect" style="top:260px;">
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
												<!-- <th CL='STD_SearchCode'></th> -->
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
<!-- 												<th CL='STD_MATNR,3'></th> -->
												<!-- <th CL='STD_SKUG05'></th> -->
												<th CL='STD_BDMNG'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTSCNT'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<!-- <td GCol="input,INPUTSKU,SHSKUMA" validate="required,INV_M0705" GF="S 20"></td> -->
												<td GCol="input,SKUKEY,SHSKUMA"></td>
												<td GCol="text,DESC01"></td>
<!-- 												<td GCol="text,MATNR"></td> -->
												<!-- <td GCol="text,DESC02"></td> -->
												<td GCol="input,QTYORD" validate="required,INV_M0706 gt(0),INV_M0706" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GCol="input,LOTA10" GF="S 20"></td>
												<td GCol="input,LOTA16" GF="N 20,3"></td>
												<td GCol="input,LOTA17" GF="N 20,3"></td>
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