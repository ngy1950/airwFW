<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	
	$(document).ready(function() { 
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsAdmin",
			command : "RM04"
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		inputList.setMultiComboSelectAll($("#ITMSTS"), true);
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
        	print();
        }
	}
	function searchList() {
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
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
			param.put("USARG1","STOR");
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "Z.ITMSTS"){
				param.put("CODE", "ITMSTS");	
			}else if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");
			}
			
			return param;
		}
	}
	
	function print(){
 		var head = gridList.getSelectData("gridList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var url = "/wms/admin/json/printRM04.data";
		var width = 840;
		var height = 620;
		
		var json = netUtil.sendData({
			url : url,
			param : param
		});
		
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/rm04_list.ezg";

				
				var where = "PRTSEQ =" + json.data;
				//var langKy = "KR";
				
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
				
				
		}
	}
	
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			if($inputObj.name == "LC.SKUKEY" || $inputObj.name == "LT.SKUKEY"){
				param.put("FIXLOC","V");
			}else{
				param.put("FIXLOC","");
			}
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
		<button CB="Print PRINT BTN_RM04PRINT"></button>
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
									<col width="450" />
									<col width="50" />
									<col width="450" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_AREAKY">area</th>
										<td>
											<select id="AREAKY" name="Z.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="Z.ZONEKY" UIInput="SR,SHZONSR" UIFormat="U 10"/>
										</td>
									</tr>
									<tr>
										
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="Z.LOCAKY" UIInput="SR,SHLOCSR" UIFormat="U 13"/>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="Z.SKUKEY" UIInput="SR" UIformat="S" />
										</td>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="DESC01" UIformat="S" />
										</td>
									</tr>
									<tr>
										<th CL="STD_ITMSTSNM">ITMSTS</th>
										<td>
											<select id="ITMSTS" name="Z.ITMSTS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										
										<th CL="STD_NWESKU"></th>
										<td>
											<select id="NWESKU" name="NWESKU" style="width:160px">
												<option value="" selected>전체</option>
												<option value="1">등록</option>
												<option value="2">미등록</option>
											</select>
										</td>
										
										<th CL="STD_PACKYN"></th>
										<td>
											<select id="PACKYN" name="PACKYN" style="width:160px">
												<option value="">전체</option>
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
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_AREANM"    GCol="text,AREANM"  ></td>
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="120 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="230 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="100 STD_ITMSTSNM"    GCol="text,ITMSTSNM"  ></td>
												<td GH="100 STD_WIDTHW"    GCol="text,WIDTHW" GF="N" ></td>
												<td GH="100 STD_LENGTH"    GCol="text,LENGTH" GF="N" ></td>
												<td GH="100 STD_HEIGHT"    GCol="text,HEIGHT" GF="N" ></td>
												<td GH="100 STD_CUBICM"    GCol="text,CUBICM" GF="N" ></td>
												<td GH="100 STD_WEIGHT"    GCol="text,WEIGHT" GF="N" ></td>
												<td GH="100 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="120 STD_PACK_SKUKEY"    GCol="text,PACK_SKUKEY"  ></td>
												<td GH="230 STD_PACK_DESC01"    GCol="text,PACK_DESC01"  ></td>
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