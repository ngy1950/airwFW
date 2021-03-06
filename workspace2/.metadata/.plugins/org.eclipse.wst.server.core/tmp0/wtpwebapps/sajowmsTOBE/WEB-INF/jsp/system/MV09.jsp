<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Inventory",
			command : "MV09",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "MV09SUB"
	    });
	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });

		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	


	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
<!-- 					<input type="button" CB="Save SAVE BTN_SAVE" /> -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="CMCDKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="text" class="input" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKKY"></dt>
						<dd>
							<input type="text" class="input" name=TASKKY  UIFormat="U"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs right-search" style="height: 200px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>??????</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>??????</span></button></li> -->
								<li><button class="btn btn_bigger"><span>??????</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40"  GCol="rownum">1</td>
<!-- 											<td GH="40"  GCol="rowCheck"></td> -->
											<td GH="100" GCol="text,TASKKY"></td>
											<td GH="100" GCol="text,TASOTY"></td>
											<td GH="100" GCol="text,TASSTX"></td>
											<td GH="100" GCol="text,STATDO"></td>
											<td GH="100" GCol="text,QTTAOR" GF="N"></td>
											<td GH="100" GCol="text,QTCOMP" GF="N"></td>
											<td GH="100" GCol="text,CREDAT" GF="C"></td>
											<td GH="100" GCol="text,CRETIM" GF="T"></td>
											<td GH="100" GCol="text,CREUSR"></td>
											<td GH="100" GCol="text,LMODAT" GF="C"></td>
											<td GH="100" GCol="text,LMOTIM" GF="T"></td>
											<td GH="100" GCol="text,LMOUSR"></td>
											
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs"  style="height: calc(100% - 220px);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>??????</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>??????</span></button></li> -->
								<li><button class="btn btn_bigger"><span>??????</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id=gridItemList>
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
<!-- 											<td GH="40" GCol="rowCheck"></td> -->
											<td GH="100" GCol="text,TASKKY"></td>
											<td GH="100" GCol="text,TASKIT"></td>
											<td GH="100" GCol="text,SKUKEY"></td>
											<td GH="100" GCol="text,DESC01"></td>
											<td GH="100" GCol="text,AREAKY"></td>
											<td GH="100" GCol="text,ZONEKY"></td>
											<td GH="100" GCol="text,LOCAAC"></td>
											<td GH="100" GCol="text,QTTAOR" GF="N"></td>
											<td GH="100" GCol="text,QTCOMP" GF="N"></td>
											<td GH="100" GCol="text,SUOMKY"></td>
											<td GH="100" GCol="text,LOCASR"></td>
											<td GH="100" GCol="text,LOCATG"></td>
<!-- 										<td GH="100" GCol="text,LOTA01"></td>	 -->
											<td GH="100" GCol="text,LOTNUM"></td>
											<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
											<td GH="100" GCol="text,LOTA02" GF="D"></td>
											<td GH="100" GCol="text,LOTA03" GF="D"></td>
											<td GH="100" GCol="text,CREDAT" GF="C"></td>
											<td GH="100" GCol="text,CRETIM" GF="T"></td>
											<td GH="100" GCol="text,CREUSR"></td>
											<td GH="100" GCol="text,LMODAT" GF="C"></td>
											<td GH="100" GCol="text,LMOTIM" GF="T"></td>
											<td GH="100" GCol="text,LMOUSR"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>