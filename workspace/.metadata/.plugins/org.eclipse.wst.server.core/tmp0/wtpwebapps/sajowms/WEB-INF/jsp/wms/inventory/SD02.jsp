<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	
	$(document).ready(function() { 
		setTopSize(160);
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsInventory",
			command : "SD02"
		});
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	function searchList() {
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			var json = netUtil.sendData({
				module : "WmsInventory",
				command : "SD02_CNT",
				sendType : "map",
				param : param
			});
			
			if(json && json.data){
				if(json.data["CNT"] > 0){
					if(json.data["CNT"] > 30000){
						commonUtil.msgBox("MASTER_M0006", [json.data["CNT"] + "건"]); 
					}else{
						gridList.gridList({
							id : "gridList",
							param : param
						});
					}
				}else{
					commonUtil.msgBox("SYSTEM_M0016");
				}
			}
		}
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", wareky);
			return param;
		}else if(comboAtt == "WmsAdmin,AREACOMBO"){
			param.put("WAREKY",wareky);
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("WARECODE","Y");
			param.put("WAREKY",wareky);
			param.put("CODE", "SKUCLS");
			return param;
			
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param,true);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
		var searchCode = data.get("searchCode");
		if(searchCode == "SHSKUMA"){
			skumaPopup.bindPopupData(data);
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>
	
	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="420" />
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
				                        <th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="WHT.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="WHT.ZONEKY" UIInput="SR,SHZONMA" UIFormat="S 10"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="WHT.LOCAKY" UIInput="SR,SHLOCMA" UIformat="S 50"/>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="WHT.SKUKEY" UIInput="SR,SHSKUMA" UIformat="S 20" />
										</td>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="SKM.DESC01" UIInput="SR" UIformat="S 120" />
										</td>
									</tr>
									<tr>
										<th CL="STD_CREDAT"></th>
										<td>
											<input type="text" name="WHT.CREDAT" UIInput="B" UIFormat="C 0 0" validate="required(STD_CREDAT)" MaxDiff="M1" />
										</td>
										<th CL="STD_LOTA06"></th>
										<td>
											<select name="WHT.LOTA06" CommonCombo="LOTA06" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_SKUCNM"></th>
										<td>
											<select id="SKUCLS" name="WHT.SKUCLS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOTL01"></th>
										<td>
											<select name="LOTL01" style="width: 160px;">
												<option value="" CL="STD_ALL"></option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_LIST'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="100 STD_TRNNUM" GCol="text,TRNHKY,center"></td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_TRNTYP" GCol="text,DOCTNM,center"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_PRCQTY" GCol="text,QTPROC" GF="N 20,3"></td>
												<td GH="100 STD_LOTL01" GCol="text,LOTL01,center"></td>
												<td GH="100 STD_LOTA08" GCol="text,LOTA08,center" GF="D"></td>
												<td GH="100 STD_LOTA09" GCol="text,LOTA09,center" GF="D"></td>
												<td GH="100 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
												<td GH="100 STD_RECVKY" GCol="text,RECVKY,center"></td>
												<td GH="100 STD_SHPOKY" GCol="text,SHPOKY,center"></td>
												<td GH="100 STD_SADJKY" GCol="text,SADJKY,center"></td>
												<td GH="100 STD_TASKKY" GCol="text,TASKKY,center"></td>
												<td GH="100 STD_STOKKY" GCol="text,STOKKY,center"></td>
												<td GH="100 STD_CREDAT" GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_CRETIM" GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_CREUSR" GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM" GCol="text,CUSRNM"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">0 Record</p>
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