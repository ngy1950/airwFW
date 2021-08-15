<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"></script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	var gridArr = ["gridSkuList","gridLocList","gridLotList"];
	var gridId = gridArr[0];
	var isTotalShow = new DataMap();
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : gridArr[0],
			module : "WmsInventory",
			command : "SD01_SKU"
	    });
		
		gridList.setGrid({
	    	id : gridArr[1],
			module : "WmsInventory",
			command : "SD01_LOC"
	    });
		
		gridList.setGrid({
	    	id : gridArr[2],
			module : "WmsInventory",
			command : "SD01_LOT"
	    });
		
		init();
	});
	
	function init(){
		for(var i in gridArr){
			var id = gridArr[i];
			isTotalShow.put(id,false);
		}
		
		$(".tabs ul li").on("click",function(){
			var tabIdx = $(this).index();
			gridId = gridArr[tabIdx];
			
			for(var i in gridArr){
				var id = gridArr[i];
				var gridBox = gridList.getGridBox(id);
				isTotalShow.put(id,gridBox.totalView);
			}
			
			searchList();
		});
		
		$("[name=LOTANM]").attr("disabled",true);
		
		$("#searchArea [name=LOTA09]").on("change",function(){
			var val = $(this).val();
			var lastVal = $(this).find("option:last").val();
			
			
			if(val == "02"){
				$("[name=LOTANM]").val("");
				$("[name=LOTANM]").attr("disabled",true);
			}else{
				$("[name=LOTANM]").attr("disabled",false);
				$("[name=LOTANM]").focus();
			}
		});
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
	//헤더 조회 
	function searchList(){
		var param = inputList.setRangeDataParam("searchArea");
		gridList.gridList({
            id : gridId,
            param : param
        });
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		var gridBox = gridList.getGridBox(gridId);
		if(isTotalShow.get(gridId)){
			gridBox.viewTotal();
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
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
											<select id="AREAKY" name="STK.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="STK.ZONEKY" UIInput="SR,SHZONMA" UIFormat="S 10"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="STK.LOCAKY" UIInput="SR,SHLOCMA" UIformat="S 50"/>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="STK.SKUKEY" UIInput="SR,SHSKUMA" UIformat="S 20" />
										</td>
										<th CL="STD_SKUCNM"></th>
										<td>
											<select id="SKUCLS" name="SKW.SKUCLS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOTA06"></th>
										<td>
											<select id="LOTA06" name="STK.LOTA06" CommonCombo="LOTA06" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_LOTL01"></th>
										<td>
											<select name="LOTL01" style="width: 160px;">
												<option value="" CL="STD_ALL"></option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
										<th CL="STD_DATEMG"></th>
										<td>
											<select name="DATEMNG" style="width:90px">
												<option value="">선택</option>
												<option value="DUE">유통기한</option>
												<option value="IMM">임박전환일</option>
<!-- 												<option value="SHP">출하통제일</option> -->
												<option value="RCV">입고통제일</option>
											</select>
											<select name="LOTA09" CommonCombo="LOTA09" ComboCodeView=false style="width:70px">
											</select>
											<input type="text" name="LOTANM" UIformat="N 3" style="width:115px"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
	         </div>

			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_BYSKUKEY"></span></a></li>
						<li><a href="#tabs1-2"><span CL="STD_BYLOCAKY"></span></a></li>
						<li><a href="#tabs1-3"><span CL="STD_BYLOTATY"></span></a></li>
					</ul>
					
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridSkuList">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_TOTSTK" GCol="text,TOTSTK" GF="N 20,3"></td>
												<td GH="100 STD_AVLSTK" GCol="text,AVLSTK" GF="N 20,3"></td>
												<td GH="100 STD_IMMSTK" GCol="text,IMMSTK" GF="N 20,3"></td>
												<td GH="100 STD_HLDSTK" GCol="text,HLDSTK" GF="N 20,3"></td>
												<td GH="100 STD_BADSTK" GCol="text,BADSTK" GF="N 20,3"></td>
												<td GH="100 STD_RTNSKT" GCol="text,RTNSKT" GF="N 20,3"></td>
												<td GH="100 STD_UNUSTK" GCol="text,UNUSTK" GF="N 20,3"></td>
												<td GH="100 STD_QTJCMP" GCol="text,QTJCMP" GF="N 20,3"></td>
												<td GH="100 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
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
									<button type="button" GBtn="total"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-2">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridLocList">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_QTTAOR" GCol="text,QTSPMO" GF="N 20,3"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
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
									<button type="button" GBtn="total"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridLotList">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_QTTAOR" GCol="text,QTSPMO" GF="N 20,3"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
												<td GH="100 STD_LOTL01" GCol="text,LOTL01,center"></td>
												<td GH="100 STD_LOTA08" GCol="text,LOTA08,center" GF="D"></td>
												<td GH="100 STD_LOTA09" GCol="text,LOTA09,center" GF="D"></td>
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
									<button type="button" GBtn="total"></button>
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