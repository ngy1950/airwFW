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
	    	id : "gridHeadList",
	    	module : "Outbound",
			command : "PK02_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Outbound",
			command : "PK02_ITEM"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "Common,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "200");
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
			sajoUtil.setLayout(data); //팝업 데이터 적용
		}
	}
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="hidden" name="WAREKY" value="<%=wareky%>"/>
							<input type="text" class="input" value="<%=warekynm%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPMTY"></dt>
						<dd>
							<select name="SHPMTY" class="input" Combo="Common,DOCTM_COMCOMBO"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RQSHPD"></dt>
						<dd>
							<input type="text" class="input" name="S.RQSHPD" UIInput="R" UIFormat="C 0 0" PGroup="G1,G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt>
						<dd>
							<input type="text" class="input" name="I.SHPOKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELN"></dt>
						<dd>
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_EXPTNK"></dt>
						<dd>
							<input type="text" class="input" name="H.DPTNKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PGRC04"></dt>
						<dd>
							<input type="text" class="input" name="H.PTRCVR" UIInput="SR"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40"             GCol="rownum">1</td>
										<td GH="140 STD_SHPOKY" GCol="text,SHPOKY"></td>
										<td GH="100 STD_SHPMTY" GCol="text,SHPMNM"></td>
										<td GH="100 STD_STATDO" GCol="text,STATNM"></td>
										<td GH="100 STD_RQSHPD" GCol="text,RQSHPD" GF="D"></td>
										<td GH="140 STD_EXPTNK" GCol="text,PTNRNM"></td>
										<td GH="140 STD_PGRC04" GCol="text,PTRCNM"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="140 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="250 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="100 STD_STATIT"  GCol="text,STATNM"></td>
										<td GH="100 STD_LOCAKY"  GCol="input,LOCAKY"></td>
										<td GH="100 STD_QTALOC"  GCol="text,QTTAOR" GF="N 20"></td>
										<td GH="100 STD_QTJCMP"  GCol="text,QTCOMP" GF="N 20"></td>
										<td GH="100 STD_UOMKEY"  GCol="text,UOMKEY"></td>	
										<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
										<td GH="100 STD_LOTA02"  GCol="text,LOTA02" GF="D"></td>
										<td GH="100 STD_LOTA03"  GCol="text,LOTA03" GF="D"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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