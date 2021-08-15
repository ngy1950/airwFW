<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>운행일지 조회</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB9021",
			gridMobileType : true
	    });
		searchList();
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OPRAT_DT",this.location.search.substring(4));
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function goBack(){
		this.location.href = "/mobile/MB9020.page";
	}

</script>
</head>
<body >

	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			
			<div class="content_layout tabs" style="height:95%;">
				<ul class="tab tab_style02">
					<li class="btn_zoom_wrap">
						<ul>
							<li>
								<div class="foot_btn">
									<button onclick="goBack()" style="width: 250px; height: 80px; margin-top: -11px;">뒤로가기</button>
								</div>
							</li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 70px);">
							<table class="table_c">	
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="100" 					GCol="rownum">1</td>
										<td GH="200 STD_DT" 			GCol="text,OPRAT_DT" GF="C"></td><!-- 일자 -->
										<td GH="250 BL_OPRAT_DSTC_KM" 	GCol="text,OPRAT_DSTC" GF="N"></td><!-- 운행거리 -->
										<td GH="300 BL_OILING_QY_L" 	GCol="text,OILING_QY"  GF="N"></td><!-- 주유량 -->
										<td GH="300 BL_OILING_AMT" 		GCol="text,OILING_AMT" GF="N"></td><!-- 주유금액 -->
										<td GH="300 BL_HPSS_AMT" 		GCol="text,HPSS_AMT"   GF="N"></td><!-- 하이패스금액 -->
										<td GH="350" 					GCol="text,UDT_DT"   GF="DT"></td><!-- 등록자 -->
										<td GH="200" 					GCol="text,UDT_ID"></td><!-- 등록자 -->
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
		</div>
		<!-- content 끝 -->
		
	</div>
</body>
</html>