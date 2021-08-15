
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>바코드 출력 현황</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB2002",
			gridMobileType : true
	    });
		
		searchList();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("USERID",'<%=userid%>');
		
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
</script>
</head>
<body >
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
							<th CL="STD_DT"></th>
							<td>
								<input type="text" class="input" style="width: 75%;" name="REQ_DAT" UIInput="SB" UIFormat="C N" validate="required"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 345px);">
<!-- 				<ul class="tab tab_style02"> -->
<!-- 					<li class="selected"><a href="#tab1-1"><span>바코드 출력 현황</span></a></li> -->
<!-- 				</ul> -->
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 70px);">
					<div class="table_list01" style="height: calc(100% - 4px);">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="80" GCol="rownum">1</td>
										<td GH="400 STD_REQ_BACODE_CD" 		GCol="text,VIEW_REQ_BARCODE_CD"></td>
										<td GH="350 STD_IVS_REQ_BACODE" 	GCol="text,VIEW_RV_REQ_BARCODE_CD"></td>
										<td GH="360 STD_REQUEST_NO" 		GCol="text,VIEW_REQ_NO_CD"></td>
										<td GH="280 STD_IVS_REQ_NO"   		GCol="text,RV_REQ_BACODE_CD"></td>
										<td GH="270 STD_PRINT_QTY"   		GCol="text,PRTN_CNT"></td>
										<td GH="250 STD_PRTN_ID"  		    GCol="text,REG_ID"></td>
										<td GH="350 STD_PRTN_DT"  		    GCol="text,REG_DT" GF="DT"></td>
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
				<button onclick="searchList()" class="btn_full"><span>조회</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>