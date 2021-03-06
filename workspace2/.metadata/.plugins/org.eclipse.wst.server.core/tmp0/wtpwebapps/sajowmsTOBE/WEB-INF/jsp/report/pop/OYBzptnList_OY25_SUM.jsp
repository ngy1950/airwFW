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
	var wareky = "";
	var otrqdt = "";
	var carnum = "";
	var ptnrto = "";
	var ptnrod = "";
	var c00102 = "";

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList1",
			module : "OyangReport",
			command : "OYBZPTN_OY25",
		    menuId : "OYBzptnListOY25_SUM"
		});
		
		
		if(page.getLinkPopData()){
			params = page.getLinkPopData();
		}
		
		searchList();
	});
	
	function searchList(){
		gridList.resetGrid("gridList1");
		if(validate.check("searchArea")){
			ownrky = params.get("OWNRKY");
		    wareky = params.get("WAREKY");
		    otrqdt = params.get("OTRQDT");
		    carnum = params.get("CARNUM");
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
			    						<td GH="50 STD_WAREKYNM" GCol="text,NAME01" GF="S 10">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
			    						<td GH="60 STD_DRCARNUM" GCol="text,CARNUM" GF="S 20">배송코스</td>	<!--배송코스-->
			    						<td GH="130 STD_DRCARNAME" GCol="text,CNUMNM" GF="S 20">배송코스명</td>	<!--배송코스명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td>	<!--입수-->
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0">총수량</td>	<!--총수량-->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
			    						<td GH="80 STD_QTJWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
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