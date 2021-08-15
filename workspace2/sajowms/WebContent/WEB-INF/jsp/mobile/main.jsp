<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mobile</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Demo",
			command : "SYSLABEL",
			gridMobileType : true
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
</script>
</head>
<body >
<%-- <%@ include file="/common/include/mobile/top.jsp" %> --%>	
	<!-- top 시작 -->
	<div class="content_top" >
	
		<div class="title_wrap">
			<span class="title"></span>
		</div>
		
		<!-- <h1 class="btn_ghost">
			<a href="#none"><span>ghost</span></a>
		</h1> -->
		
		<!-- <div class="setting">
			<a href="#none"><span></span></a>
		</div> -->
	</div>
	<!-- top 끝 -->
	
	<!-- setting 시작 -->
	<!-- <div class="deem_setting off">
		<div class="top">
			<div class="left"></div>
			<div class="right">
				<div class="first"></div>
				<div class="second"></div>
			</div>
		</div>
		<div class="bot">
			<h2><span>관리자</span> 님</h2>
			<h3><span class="icon"></span><span>2020-04-17 오전 10:20</span></h3>
			<button><span>로그아웃</span></button>
		</div>
	</div> -->
	<!-- setting 끝 -->
	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:100px">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:30%" />
							<col style="width:70%" />
						</colgroup>
						<tr>
							<th>Search</th>
							<td>
								<input type="text" class="input" name="Search" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height:80%;">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>리스트</span></a></li>
					<li><a href="#tab1-2"><span>상세</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 70px);">
							<table class="table_c">
								<colgroup>
									<col style="width:10%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
								</colgroup>								
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="80" GCol="text,LABELGID"></td>
										<td GH="150" GCol="input,LABELID,SYSLABEL,multi"></td>
										<td GH="80" GCol="select,LANGCODE">
											<select class="input" CommonCombo="LANGKY">
											</select>
										</td>
										<td GH="150" GCol="input,LABEL"></td>
										<td GH="80" GCol="input,LABELTYPE"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<div class="btn_out_wrap">

						</div>
						<span class='txt_total' >총 <span GInfoArea='true'>4</span> 건</span>
					</div>
				</div>
				<div class="table_box" id="tab1-2" style="display:none;">
					<div class="inner_search_wrap">
					</div>
				</div>
			</div>			
			<!-- 하단 버튼 시작 -->
			<div class="foot_btn">
				<button onclick="searchList()"><span>조회</span></button>
				<button><span>저장</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>