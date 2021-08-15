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
midAreaHeightSet = "200px";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			module : "WmsAdmin",
			command : "RM01H",
			excelRequestGridData : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			module : "WmsAdmin",
			command : "RM01I",
			headGrid : "gridHeadList",
			excelRequestGridData : true,
			emptyMsgType : false
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Pinrt"){
			print();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var param = inputList.setRangeParam("searchArea")
			param.put("USARG1", "STOR"); //가용 areaky
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
		}
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
			
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength > 0 ){
		
		}else if( gridId == "gridHeadList" && dataLength <= 0 ){
			
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
			
			if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				param.put("USARG1","V");
			}
			
			return param;
		}
	}
	
	function print(){
 		var head = gridList.getSelectData("gridItemList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/printRM01.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/rm01_list.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  840;
				var heigth = 620;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
				
				
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Pinrt PRINT BTN_LOCPAGE"></button>
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
												<select id="AREAKY" name="LO.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY">존</th>
											<td>
												<input type="text" name="LO.ZONEKY" UIInput="SR,SHZONMA" UIFormat="U"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_LOTA06"></th>
											<td>
												<select id="LOTA06" name="LOTA06" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">선택</option>
												</select>
											</td>
											<th CL="STD_FIXLOC">피킹로케이션</th>
											<td>
												<select id="FIXLOC" name="FIXLOC" style="width:160px">
													<option value="">전체</option>
													<option value="V">설정</option>
													<option value=" ">미설정</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1"> 
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"   GCol="text,NAME01"></td>
												<td GH="100 STD_AREAKY"   GCol="text,SHORTX"></td>
												<td GH="100 STD_ZONEKY"   GCol="text,ZONEKY"></td>
												<td GH="100 STD_LOCCNT"   GCol="text,LOCCNT"  GF="N"></td>
												<td GH="100 STD_SKUCNT"   GCol="text,SKUCNT"  GF="N"></td>
												<td GH="100 STD_QTSIWH"   GCol="text,SUMQTY"  GF="N"></td>
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
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_AREAKY"   GCol="text,AREANM"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="130 STD_KANCOD"   GCol="text,EANCOD"></td>
												<td GH="130 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="230 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_LOTA06"   GCol="text,CDESC1"></td>
												<td GH="100 STD_BOXQTY"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_QTSIWH"   GCol="text,QTSIWH"  GF="N"></td>
												<td GH="90 STD_SHOWYN"    GCol="text,SHOWYNNM"></td>
												<td GH="100 STD_SKUL01"   GCol="text,SKUL01"></td>
												<td GH="100 STD_SKUL02"   GCol="text,SKUL02"></td>
												<td GH="100 STD_SKUL03"   GCol="text,SKUL03"></td>
												<td GH="100 STD_SKUL04"   GCol="text,SKUL04"></td>
												<td GH="100 STD_STATUS"   GCol="text,ITMSTSNM"></td>
												<td GH="100 STD_STSDAT"   GCol="text,STSDAT"  GF="D"></td>
												<td GH="80 STD_PTNRKY"    GCol="text,DPTNKY"></td>
												<td GH="140 STD_PTNRNM"   GCol="text,NAME01"></td>
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