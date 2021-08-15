<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
	 	gridList.setGrid({
	    	id : "gridList",
			editable : true,
			validation : "ASNDAT,VENDOR,RQSHPD,PTRCVR,AREAKY,DOCTXT,SKUKEY,DESC01,DESC02,QTYORD,UOMKEY,LOTA10,LOTA16,LOTA17",
			validationType : "CRU"
		}); 
	 	gridList.setReadOnly("gridList", false);
	});
	
	function gridListEventDataBindEnd(gridId, dataCount, excelLoadType){
		if(excelLoadType){
			vCheck();
		}
	}
	
	function validationCheck(){
		var list = gridList.getGridData("gridList");
		if(list.length == 0){
			commonUtil.msgBox("ORDER_M0004");
		}else{
			vCheck();
		}
	}
	
	function vCheck(){
		var param = gridList.getGridValidationData("gridList");
		
		var json = netUtil.send({
			url : "/wms/order/json/validationIO02.data",
			param : param,
			bindType : "grid",
			bindId : "gridList",
			sendType : "list"
		});
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		var list = gridList.getGridData("gridList");
		
		if(list.length == 0){
			commonUtil.msgBox("ORDER_M0005");
			return;
		}
		
		var rowData;
		for(var i=0;i<list.length;i++){
			rowData = list[i];
			if(rowData.get("MSG") != "OK"){
				commonUtil.msgBox("ORDER_M0003");
				return;
			}
		}
		
		var param = dataBind.paramData("io02top");
		param.put("list",list);
		
		var json = netUtil.sendData({
			url : "/wms/order/json/saveIO02.data",
			param : param
		});
		
		if(json && json.data == 0){
			commonUtil.msgBox("MASTER_M0564");
			gridList.setReadOnly("gridList", true);
		}
	}
	
	function clearData(){
		if(!commonUtil.msgConfirm("VALID_M0011")){
			return;
		}
		gridList.resetGrid("gridList");
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			gridList.setColValue("gridList", rowNum, "MSG", "");
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reflect"){
			validationCheck();
		}else if(btnName == "Check"){
			clearData();
		}
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
		<button CB="Reflect REFLECT BTN_VALIDCHECK"></button>
		<button CB="Save SAVE STD_SAVE"></button>
	</div>
</div>

<div class="content">
	<div class="innerContainer">
		<div class="contentContainer">
			
			<!-- TOP FieldSet -->
			<div class="foldSect" id="foldSect">
				<div class="tabs">
				  <ul class="tab type2">
					<li><a href="#tabs-1"><span CL='STD_ORDERINFO'></span></a></li>
				  </ul>
				  <div id="tabs-1">
					<div class="section type1">
						<table class="table type1" id="io02top">
							<colgroup>
								<col />
								<col />
								<col />
								<col />
								<col />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th CL="STD_OWNRKY" style="width:150px;">화주</th>
									<td>
										<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
										</select>
									</td>
								</tr>
								<tr>
									<th CL="STD_RCPTTY">입고유형</th>
									<td>
										<select Combo="WmsOrder,RCPTTYCOMBO" name="RCPTTY" id="RCPTTY">
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				  </div>
				</div>
			</div>
			
			
			<div class="bottomSect" style="top:120px;">
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_RCVDAT'></th>
												<th CL='STD_DPTNKY,3'></th>
<!-- 												<th CL='STD_RQSHPD'></th> -->
<!-- 												<th CL='STD_PTRCVR,3'></th> -->
<!-- 												<th CL='STD_AREAKY'></th> -->
												<th CL='STD_DOCTXT'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTYORD'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_VALIDC'></th>
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="input,ASNDAT" GF="C 8" ></td>
												<td GCol="input,VENDOR"></td>
<!-- 												<td GCol="input,RQSHPD" GF="C 8"></td> -->
<!-- 												<td GCol="input,PTRCVR"></td> -->
<!-- 												<td GCol="input,AREAKY"></td> -->
												<td GCol="input,DOCTXT"></td>
												<td GCol="input,SKUKEY"></td>
												<td GCol="input,DESC01"></td>
												<td GCol="input,DESC02"></td>
												<td GCol="input,QTYORD" GF="N"></td>
												<td GCol="input,UOMKEY"></td>
												<td GCol="input,LOTA10"></td>
												<td GCol="input,LOTA16" GF="N"></td>
												<td GCol="input,LOTA17" GF="N"></td>
												<td GCol="text,MSG"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excelUpload"></button>
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
	</div>
</div>
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>