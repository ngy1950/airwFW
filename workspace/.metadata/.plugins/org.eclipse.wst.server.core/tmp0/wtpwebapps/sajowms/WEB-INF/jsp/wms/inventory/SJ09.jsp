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
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
midAreaHeightSet = "200px";
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridList1",
			editable : true,
			module : "WmsInventory",
			command : "SJ09H",
			autoCopyRowType : false,
			itemGrid : "gridList2",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridList2",
			editable : true,
			module : "WmsInventory",
			command : "SJ09I",
			autoCopyRowType : false,
			headGrid : "gridList1"
		});
		
		//멀티셀렉트 check
		gridList.setReadOnly("gridList2", true, ["RSNADJ"]);
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList1",
				param : param
			});
			
			
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridList1", rowNum);
		
		gridList.gridList({
			id : "gridList2",
			param : rowData
		});
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList1" && dataLength == 0 ){
			gridList.resetGrid("gridList2");
			
		}
	}
	

	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param, true);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if(data.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(data);
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			//검색조건 AREA 콤보
			param.put("PROGID", "SJ09");
			
			return param;
			
		}else if( comboAtt == "WmsInventory,SJ_AREACOMBO" ){
			//검색조건 AREA 콤보
// 			param.put("USARG1", "STOR");
			
			return param;
		}else if( comboAtt == "WmsInventory,RSNADJCOMBO" ){
			param.put("DOCUTY","450");
			return param;
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
		
			<div class="bottomSect top" style="height:130px" id="searchArea">
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
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_CHANGEDATE"></th>
											<td>
												<input type="text" name="AH.DOCDAT" UIInput="B" UIFormat="C N"  validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_ADJUTY"></th>
											<td>
												<select id="ADJUTY" name="ADJUTY" Combo="WmsCommon,DOCTMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_AREAKY"></th>
											<td>
												<select id="AREAKY" name="AI.AREAKY" Combo="WmsInventory,SJ_AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY"></th>
											<td>
												<input type="text" name="LO.ZONEKY" UIInput="SR,SHZONMA" UIformat="U" />
											</td>
											<th CL="STD_LOCAKY"></th>
											<td>
												<input type="text" name="AI.LOCAKY" UIInput="SR,SHLOCMA" UIformat="U" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="AI.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top: 155px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-3" ><span CL="STD_LIST"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList1">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="text,NAME01"></td>
												<td GH="100 STD_SADJKY,3"  GCol="text,SADJKY"></td>
												<td GH="100 STD_ADJUTY"    GCol="text,SHORTX"></td>
												<td GH="100 STD_CHANGEDATE"  GCol="text,CREDAT" GF="D"></td>
												<td GH="100 STD_CHAGTIM"   GCol="text,CRETIM" GF="T"></td>
												<td GH="100 STD_CHAGID"    GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM,3"  GCol="text,CUSRNM"</td>
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
<!-- 													<button type="button" GBtn="total"></button> -->
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
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-4" ><span CL="STD_DETAIL"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList2">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="120 STD_SADJKY,3"   GCol="text,SADJKY"></td>
												<td GH="120 STD_ADJNUM"   GCol="text,SADJIT"></td>
												<td GH="120 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY"    GCol="text,SHORTX"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"    GCol="text,ZONENM"></td>
												<td GH="80 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LOT6NM"></td>
												<td GH="80 STD_QTADJU"    GCol="text,QTADJU"   GF="N"></td>
												<td GH="100 STD_RSNADJ,3" GCol="select,RSNADJ">
													<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"   GF="D"/></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"   GF="D"/></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKUCNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"   GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"   GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"   GF="N"></td>
												
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
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>