<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR02POP</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	var data;
	var popNm = "GR02_LOCMA";
	var g_grid_id = "";
	var g_row_num = 0;
	
	$(document).ready(function(){
		init();
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR02_LOCMA_POP"
		});
		
		searchList();
	});
	
	function init(){
		data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		g_grid_id = data.get("gridId");
		g_row_num = data.get("rowNum");
		
	}

	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
	//헤더 조회
	function searchList(){
		var param = inputList.setRangeDataParam("searchArea");
		param.put("SKUKEY", data.get("SKUKEY"));
		param.put("progId", data.get("progId"));
		
		gridList.gridList({
			id : "gridList",
			param : param
		}); 
		
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			
			var param = new DataMap();
			param.put("gridId",g_grid_id);
			param.put("rowNum",g_row_num);
			param.put("popNm",popNm);
			param.put("data",rowData);
			
			page.linkPopClose(param);
		}
	}
	
	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeDataParam("searchArea");
		if(gridId == "gridList"){
			param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridList");
		}
		return param;
		
	}
	
	function closeData(){
		this.close();
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
											<input type="hidden" id="WAREKY" name="WAREKY"/>
											<input type="text" id="WARENM" name="WARENM" disabled="disabled" style="width: 160px;"/>
										</td>
										<th CL="STD_AREAKY"></th>
										<td>
											<input type="text" name="A.AREAKY" UIInput="SR,SHAREMN" UIFormat="U 10"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_ZONEKY"></th>
										<td>
											<input type="text" name="A.ZONEKY" UIInput="SR,SHZONMN" UIFormat="U 10"/>
										</td>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="A.LOCAKY" UIInput="SR,SHLOCMN" UIformat="U 50"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="A.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U 20" />
										</td>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="A.DESC01" UIInput="SR" UIformat="S 40" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
	         </div>

			<div class="bottomSect bottomT" style="top: 145px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_SHORTX" GCol="text,SHORTX"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_LOCATY" GCol="text,LOCANM"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
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
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>