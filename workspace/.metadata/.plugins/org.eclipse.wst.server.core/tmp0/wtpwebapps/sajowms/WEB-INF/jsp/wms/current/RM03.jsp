<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsAdmin",
			command : "RM03",
			excelRequestGridData : true
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Print"){
			print();
		}
			
	}
		
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea")
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		if( multyType == "true" && searchCode == "SHZONMA" ){
			var param = inputList.setRangeParam("searchArea");
			param.put("multyType", multyType);
			param.put("WAREKY", "<%=wareky%>");
			param.put("ARETYP", "STOR");
			param.put("SHPNOT", " ");
			
			page.linkPopOpen("/wms/inventory/POP/SJ03POP.page", param);
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if( multyType == "true" && data.get("searchCode") == "SHZONMA" ){
			var singleList = [];
			var zoneList = data.get("ZONEKY");
			for(var i=0; i<zoneList.length; i++){
				var rangeMap = new DataMap();
				rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
				rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
				rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, data.get("ZONEKY")[i]);
				singleList.push(rangeMap);
				
			}
			inputList.setRangeData("LM.ZONEKY", configData.INPUT_RANGE_TYPE_SINGLE, singleList);
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
			
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "LOTA06"){
				param.put("CODE", "LOTA06");
				param.put("USARG1","V");
			}
			
			return param;
		}
	}
	
	function print(){
// 		var param2 = inputList.setRangeParam("searchArea");
		
// 		var areaky = param2.get("RANGE_DATA_PARAM").get("AM.AREAKY_Single").replace(/E↓/g,"").replace(/↓OR↑/g,",").replace(/↓OR/g,"").split(",");
// 		var zoneky = param2.get("RANGE_DATA_PARAM").get("ZM.ZONEKY_Single");
		
		
<%-- 		var where = "ST.WAREKY = " + "'" + "<%=wareky%>" + "'"; --%>
// 		where += " AND AM.AREAKY IN (";
		
// 		for(var i=0; i < areaky.length;i++){
// 			 where += "'" + areaky[i] + "'";
// 			 if(i != areaky.length-1){
// 				 where += ",";
// 			 }
// 		}
		
// 		where += ")";
			
// 		if(typeof zoneky != 'undefined'){
// 			zoneky = zoneky.replace(/E↓/g,"").replace(/↓OR↑/g,",").replace(/↓OR/g,"");
// 			zoneky = zoneky.split(",");
// 			where += " AND ZM.ZONEKY IN (";
// 			for(var i=0; i < zoneky.length;i++){
// 				 where += "'" + zoneky[i] + "'";
// 				 if(i != zoneky.length-1){
// 					 where += ",";
// 				 }
// 			}
			
// 			where += ")";
// 		}
		
		
// 		console.log(where);

		var head = gridList.getSelectData("gridList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/printRM03.data",
			param : param
		});
		
		var map = new DataMap();
			map.put("LOTA06",$('#LOTA06').val());
		
		var url = "<%=systype%>" + "/rm03_list.ezg";
		var where = "PL.PRTSEQ =" + json.data;
		//var langKy = "KR";
		var width =  840;
		var heigth = 600;
		var langKy = "KR";
		
		WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Print PRINT BTN_PRINT"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" style="height:100px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_AREAKY">area</th>
											<td>
												<select id="AREAKY" name="AM.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY">존</th>
											<td>
												<input type="text" name="ZM.ZONEKY" UIInput="SR,SHZONMA" UIFormat="U"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_LOTA06">area</th>
											<td>
												<select id="LOTA06" name="LOTA06" Combo="Common,COMCOMBO" validate="required(STD_LOTA06)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottomT" style="top:110px;">
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
												<td GH="100 STD_WAREKY"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_AREAKY"    GCol="text,SHORTX"  ></td>
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="230 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="100 STD_BOXQTY"    GCol="text,BOXQTY" GF="N" ></td>
												<td GH="100 STD_LOTA06"    GCol="text,LOTA06"  ></td>
												<td GH="100 STD_BOX"    GCol="text,BOX" GF="N" ></td>
												<td GH="100 STD_EA"    GCol="text,EA" GF="N" ></td>
												<td GH="100 STD_QTSIWH"    GCol="text,QTSIWH" GF="N" ></td>
												<td GH="100 STD_LOTA09"    GCol="text,LOTA09" GF="D" ></td>
												<td GH="100 STD_IMMDAY"    GCol="text,CONTDAT" GF="D" ></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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