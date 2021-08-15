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
			command : "MP10"
		});
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
        	print('list');
        }else if(btnName == "Print2"){
        	print('label');
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
			param.put("WARECODE","Y");
			param.put("WAREKY",wareky);
			param.put("CODE", "SKUCLS");
			return param;
			
		}
	}
	
	function print(gbn){
 		var head = gridList.getSelectData("gridList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var url = "";
		var	width = 0;
		var height = 0;
		var filenm = "";
		
		if(gbn == "list"){
			url = "/wms/admin/json/printMP10.data";
			width = 600;
			height = 820;
			filenm = "/change_location_mp10_list.ezg";
		}else if( gbn =="label"){
			url = "/wms/admin/json/printMP01.data";
			width = 316;
			height = 203;
			filenm = "/location_label2.ezg";
		}
		
		var json = netUtil.sendData({
			url : url,
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + filenm;

				
				var where = "PL.PRTSEQ =" + json.data;
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
		<button CB="Print PRINT BTN_LIST"></button>
		<button CB="Print2 PRINT BTN_LABEL"></button>
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
									<col width="250" />
									<col width="50" />
									<col width="420" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_APLDAT"></th>
										<td>
											<input type="text" name="LT.CREDAT" UIInput="B" UIFormat="C 0 0" validate="required" MaxDiff="M1"/>
										</td>
										<th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="LC.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="LC.ZONEKY" UIInput="SR,SHZONSR" UIFormat="U 10"/>
										</td>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="LC.LOCAKY" UIInput="SR,SHLOCSR" UIFormat="U 13"/>
										</td>
										<th CL="STD_APLSKU"></th>
										<td>
											<input type="text" name="LT.SKUKEY" UIInput="SR,SHSKUMA" UIformat="S 20" />
										</td>
									</tr>
									<tr>
										<th CL="STD_BEFSKU"></th>
										<td>
											<input type="text" name="LT.BEFSKU" UIInput="SR,SHSKUMA" UIformat="S 20" />
										</td>
										<th CL="STD_CURSKU"></th>
										<td>
											<input type="text" name="LC.SKUKEY" UIInput="SR,SHSKUMA" UIformat="S 20" />
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
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="40"             GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_STATIT" GCol="text,INSTYP"></td>
												<td GH="120 STD_BEFSKU" GCol="text,BEFSKU"></td>
												<td GH="200 STD_BEFDSC" GCol="text,BEFSNM"></td>
												<td GH="100 STD_BEFLT6" GCol="text,BEFLT6,center"></td>
												<td GH="120 STD_APLSKU" GCol="text,SKUKEY"></td>
												<td GH="200 STD_APLSNM" GCol="text,DESC01"></td>
												<td GH="100 STD_APLT06" GCol="text,LOTA06,center"></td>
												<td GH="120 STD_CURSKU" GCol="text,CURSKU"></td>
												<td GH="200 STD_CURSNM" GCol="text,CURSNM"></td>
												<td GH="100 STD_CRLT06" GCol="text,CUTLT6,center"></td>
												<td GH="100 STD_APLDAT" GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_APLTIM" GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_APLUSR" GCol="text,CREUSR"></td>
												<td GH="100 STD_APLUNM" GCol="text,CREUNM"></td>
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