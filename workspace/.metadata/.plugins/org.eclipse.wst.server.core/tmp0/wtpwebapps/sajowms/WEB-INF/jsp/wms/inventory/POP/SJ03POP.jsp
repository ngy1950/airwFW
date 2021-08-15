<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>zone</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	
	window.resizeTo('500','600');
	var data;
	
	$(document).ready(function(){
		setTopSize(125);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "SJ03POP",
			autoCopyRowType : false
		});
		
		data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		inputList.dataRangeBind(data.get("RANGE_DATA_PARAM"));
		
		var multyType = data.get("multyType");
		
		if(!multyType){
			$("#btn0").remove();
			$("#btn0Txt").remove();
		}
	});

	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//헤더 조회
	function searchList(){
		var param = inputList.setRangeDataParam("searchArea");
		param.put("ARETYP", data.get("ARETYP"));
		param.put("SHPNOT", data.get("SHPNOT"));
		
		gridList.gridList({
			id : "gridList",
			param : param
		}); 
		
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if( gridId == "gridList" ){
			var rowData = gridList.getRowData(gridId, rowNum);
			
			var param = new DataMap();
			param.put("data",rowData);
			
			page.linkPopClose(param);
		}
	}
	
	function multiSelect(){
		var selectData = gridList.getSelectData("gridList", true);
		var len = selectData.length;
		
		if( len > 0 ){
			var rowData;
			var dataList = new Array();
			for( var i=0; i<selectData.length; i++ ){
				rowData = selectData[i];
				dataList.push(rowData.get("ZONEKY"));
				
			}
// 			inputList.setSearchValue(dataList);
			
			
			var param = new DataMap();
			param.put("searchCode", "SHZONMA");
			param.put("ZONEKY", dataList);
			
			page.linkPopClose(param);
			
		}else{
			commonUtil.msgBox("VALID_M0006");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
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
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="STD_AREAKY"></th>
										<td>
											<input type="text" id="AREAKY" name="AR.AREAKY" UIInput="R,SHAREMN"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_ZONEKY"></th>
										<td>
											<input type="text" name="ZO.ZONEKY" UIInput="R"/>
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
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                  GCol="rownum">1</td>
												<td GH="40"                  GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"      GCol="text,WARENM"></td>
												<td GH="100 STD_AREAKY"      GCol="text,AREAKY"></td>
												<td GH="100 STD_AREANM"      GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY"      GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"      GCol="text,ZONENM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button id="btn0" class="type8" type="button" title="select" onclick="multiSelect()"><img src="/common/theme/darkness/images/grid_icon_01.png"></button>
									<span id="btn0Txt" CL="BTN_CHOOSE" style="vertical-align:middle;padding-left:5px;padding-right:5px"></span>
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