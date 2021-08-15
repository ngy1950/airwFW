<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsApproval",
			command : "AP13H",
			itemGrid : "gridItemList",
			itemSearch : true,
			selectRowDeleteType : false,
			autoCopyRowType : false
			
		});
			
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsApproval",
			command : "AP13I",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
		
		var $comboList = $('#searchArea').find("select[Combo]");
		inputList.setMultiComboValue($("#WAREKY"), ["<%=wareky%>"]);
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
			
		}
	}
	
	//아이템조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		var param = getItemSearchParam(gridId, rowNum);
		param.put("WAREKY", gridList.getColData(gridId, rowNum, "WAREKY"));
		
		gridList.gridList({
			id : "gridItemList",
			param : param
		});
	}
	
	// 아이템 그리드 Parameter
	function getItemSearchParam(gridId, rowNum){
		return inputList.setRangeParam("searchArea");
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			
		}else if( gridId == "gridHeadList" && dataLength > 0 ){
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			param.put("USERID", "<%=userid%>");
 			param.put("USRADM", "V");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("CODE","APRCOD");
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
			<div class="bottomSect top" style="height:70px" id="searchArea">
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
										<col width="450" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="AM.WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" comboType="MS" validate="required(STD_WAREKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_REQDAT"></th>
											<td>
												<input type="text" id="AM.REQDAT" name="AM.REQDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_APRCOD"></th>
											<td>
												<select id="APRCOD" name="APRCOD" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
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
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_APTCNT"     GCol="text,TOTCNT" GF="N"></td>
												<td GH="100 STD_REQCNT"     GCol="text,REQCNT" GF="N"></td>
												<td GH="100 STD_CMPCNT"     GCol="text,CMPCNT" GF="N"></td>
												<td GH="100 STD_NOTCNT"     GCol="text,NOTCNT" GF="N"></td>
												<td GH="100 STD_ENDCNT"     GCol="text,ENDCNT" GF="N"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
<!-- 									<button type="button" GBtn="layout"></button> -->
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
			<!-- 그리드 -->
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2"  id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL="STD_ITEMLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_APRCOD"     GCol="text,CDESC1"></td>
												<td GH="100 STD_REQDAT"     GCol="text,REQDAT" GF="D"></td>
												<td GH="100 STD_APTCNT"     GCol="text,TOTCNT" GF="N"></td>
												<td GH="100 STD_REQCNT"     GCol="text,REQCNT" GF="N"></td>
												<td GH="100 STD_CMPCNT"     GCol="text,CMPCNT" GF="N"></td>
												<td GH="100 STD_NOTCNT"     GCol="text,NOTCNT" GF="N"></td>
												<td GH="100 STD_ENDCNT"     GCol="text,ENDCNT" GF="N"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
<!-- 									<button type="button" GBtn="layout"></button> -->
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