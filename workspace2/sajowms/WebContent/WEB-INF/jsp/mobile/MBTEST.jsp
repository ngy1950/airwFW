<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MBTEST</title>
<%@ include file="/common/include/mobile/head.jsp" %>
</head>
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "MB1000",
		command : "MB1202",
		gridMobileType : true
    });
});
/*  user 내가속한영업소 가져오기 */
/* 조회 */
function searchList(){
	if(validate.check("searchArea")){
		var param = inputList.setRangeParam("searchArea");
		param.put("USERID", "<%=userid%>");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
}
</script>
<body>
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:390px">
			<!-- 검색 조건의 갯수에 따라 높이 조절이 필요합니다. -->
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:40%" />
							<col style="width:60%" />
						</colgroup>
						<tr>
							<th>Text Input</th>
							<td>
								<input type="text" class="input" />
							</td>
						</tr>
						<tr>
							<th>SearchHelp</th>
							<td>
								<input type="text" class="input" UIInput="S" />
							</td>
						</tr>
						<tr>
							<th>Calendar</th>
							<td>
								<input type="text" class="input" UIFormat="C N"/>
							</td>
						</tr>
						<tr>
							<th>Month</th>
							<td>
								<input type="text" class="input" name="Month" UIFormat="MS" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 585px);">
			<!-- calc를 쓰지않고 %로만 값을 주면 아이패드에서 화면이 깨질 확률이 높음, content_serch의 높이값에 따라 content-layout의 height값 변경 필요 -->
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>MBTEST</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="150 STD_PUCH_CD" 		GCol="text,PUCH_CD"></td>
										<td GH="120 STD_TEMPER_CNDT" 	GCol="text,OD_TYP_NM"></td>
										<td GH="120 STD_BIZOFFICE" 		GCol="text,BZO_NM"></td>
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
				<button><span>조회</span></button>
				<button><span>저장</span></button>
				<!-- 버튼 3개 시작 -->
				<!-- <button class="btn_first"><span>BTN 1</span></button>
				<button class="btn_second"><span>BTN 2</span></button>
				<button class="btn_third"><span>BTN 3</span></button> -->
				<!-- 버튼 3개 끝 -->
				<!-- 버튼 1개 시작 -->
				<!-- <button class="btn_full"><span>BTN 3</span></button> -->
				<!-- 버튼 1개 끝 -->
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>