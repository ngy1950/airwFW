<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PUD</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB5000",
			command : "MB5303",
			gridMobileType : true
	    });
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	/* 출력 */
	function clean(){
		$("input[name='DRIVR_NM']").val("");
		gridList.resetGrid("gridList");
	}

</script>
</head>
<body >
	<div class="content_top" > 
		<div class="title_wrap">
			<span class="title"></span>
		</div> 
	</div> 
	
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
							<th CL="STD_DRIVR_NM"></th>
							<td>
								<input type="text" class="input" name="DRIVR_NM" UIFormat="S 50" /><!-- 기사명 -->
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height:80%;">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span CL="STD_DRIVR_INFO"></span></a></li>
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
										<td GH="50" GCol="rownum">1</td>
										<td GH="120 STD_DRIVR_NM" 		GCol="text,DRIVR_NM"></td><!-- 기사명 -->
										<td GH="150 STD_CTTPC" 	GCol="text,CPH"></td><!-- 온도조건 -->
										<td GH="200 STD_CLNT_NAME" 		GCol="text,CLNT_NM"></td><!-- 운송사명 -->
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
				<button onclick="clean()"><span>초기화</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>