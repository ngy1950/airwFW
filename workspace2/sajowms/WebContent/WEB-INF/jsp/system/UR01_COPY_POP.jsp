<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "UR01_MENUCOPY",
			pkcol : "COMPID,MENUGID",
			editable : true
		});
		
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
		}
	}
	
	//로우 더블클릭
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		var param = gridList.getRowData("gridList", rowNum);
		param.put("CLOSE_TYPE", "COPY");
		page.linkPopClose(param);
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" /><!-- 조회 -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMPID"></dt><!-- 회사  ID -->
						<dd>
							<input type="text" class="input" name="COMPID" IAname="Search" maxlength="10" readonly="true" value="<%= compky%>"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MENUGROUPID"></dt><!-- 메뉴그룹ID -->
						<dd>
							<input type="text" class="input" name="MENUGID" IAname="Search" maxlength="10" UIFormat="U" />
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><label CL="STD_MSTMENUG"></label></a></li>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="100 STD_COMPID"      GCol="text,COMPID" GF="U"></td><!-- 회사  ID -->
										<td GH="100 STD_MENUGROUPID" GCol="text,MENUGID"></td><!-- 메뉴 그룹 ID	 -->
										<td GH="100 STD_MENUGNAME"   GCol="text,MENUGNAME"></td><!-- 메뉴 그룹명 -->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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