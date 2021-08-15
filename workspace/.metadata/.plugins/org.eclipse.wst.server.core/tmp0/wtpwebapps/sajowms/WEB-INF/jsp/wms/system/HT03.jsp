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
			editable : true,
			module : "System",
			command : "HT03H",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "System",
			command : "HT03I",
			autoCopyRowType : false,
			headGrid : "gridHeadList"
		});
		
		date();
	});
	
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
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
		
			<div class="bottomSect top" style="height:80px" id="searchArea">
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
											<th CL="STD_CREDAT">입고예정일자</th>
											<td>
												<input type="text" name="CREDAT" UIFormat="C N" validate="required" />
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
						<li><a href="#tabs1-3" ><span CL="STD_GENERAL"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_BATCOD"    GCol="text,BATCOD"></td>
												<td GH="100 STD_BATCNM"    GCol="text,BATCNM"></td>
												<td GH="100 STD_SYSUSA"    GCol="text,USARG1"></td>
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_BATTOT"    GCol="text,TOTCNT"></td>
												<td GH="100 STD_BATERR"    GCol="text,ERRCNT"></td>
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
						<li><a href="#tabs1-4" ><span CL="STD_ITEMLIST"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_LOGSEQ"    GCol="text,LOGSEQ"></td>
												<td GH="100 STD_BATCOD"    GCol="text,BATCOD"></td>
												<td GH="100 STD_BATCNM"    GCol="text,BATCNM"></td>
												<td GH="100 STD_LOGTEX"    GCol="text,LOGTEX"></td>
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"    GCol="text,JOBKEY"></td>
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