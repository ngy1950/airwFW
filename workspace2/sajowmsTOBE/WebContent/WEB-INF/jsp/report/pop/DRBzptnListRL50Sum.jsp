<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OYBzptnList</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	
	var params ;
	var orddat = "";
	var wareky = "";
	var otrqdt = "";
	var carnum = "";
	var ptnrto = "";
	var ptnrod = "";
	var c00102 = "";

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList1",
			module : "Report",
			command : "DRBzptnListRL50Sum",
		    menuId : "DRBzptnListRL50Sum"
		});
		
		
		if(page.getLinkPopData()){
			params = page.getLinkPopData();
		}
		
		searchList();
	});
	
	function searchList(){
		gridList.resetGrid("gridList1");
		if(validate.check("searchArea")){
		    wareky = params.get("WAREKY");
		    otrqdt = params.get("OTRQDT");
		    carnum = params.get("CARNUM");
		    orddat = params.get("ORDDAT");
		    ptnrod = params.get("PTNROD");
		    ptnrto = params.get("PTNRTO");
		    c00102 = params.get("C00102");
		    
			gridList.gridList({
		    	id : "gridList1",
		    	param : params
		    });
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
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02" id="tabs">
					<li><a href="#tab1-1">거래처별 상세물량집계표</a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="50 STD_WAREKYNM" GCol="text,NAME01" GF="S 10">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="C 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_CARNUM"" GCol="text,CARNUM" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DRCARNUM" GCol="text,CNUMNM" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="90 총중량(kg)" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
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