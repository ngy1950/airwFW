<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String REGINO = request.getParameter("REGINO");
%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>슈피겐코리아 모바일 WMS</title>
<%@ include file="/mobile/include/head.jsp" %>
<script>
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			editable : false,
			module : "Mobile",
			command : "MDL6L",
			bindArea : "searchArea",
			gridMobileType : true
	    });
		gridList.checkAll("gridList", true);
		searchList();
	});
	
	function searchList(){
		var regino = "<%=REGINO%>";
		var param = new DataMap();
		param.put("REGINO", regino);
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		
		$('#REGINO').val(regino);
		$('#REGINO').attr("disabled",true);
	
		showMain();
	}
	
	function showMain() {
		$("#main_container").show();
	}
	function showDetailInfo() {
		$("#main_container").hide();
	}
	
	function showDetail(){ 
		showDetailInfo();
	}
	
 	
 	function gridListEventDataBindEnd(gridId, dataLength){
		if( dataLength == 0 ){
			location.href="/mobile/MDL6L.page";
		}
 	}
 	
 	function clearText(data){
		if(data!=null||data!=""){
	    	data.value="";
	    }      
	}
	
</script>
</head>
<body>
	<div class="main_wrap" >
	<div id="main_container">
		<div class="tem3_content">
			<div class="searchWrap">
				<table>
					<colgroup>
						<col width="50px"  />
						<col />
						<col width="60px" />
					</colgroup>
					<tbody>
						<tr class="t_title">
							<th>운송장번호</th>
							<td>
								<input type="text" class="text" id="REGINO" readonly="readonly" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="tem5_content">
			<div class="tableWrap_search section">
				<div class="tableHeader">
					<table>
						<colgroup>
							<col width="40" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
						</colgroup>
						<thead>
							<tr>
								<th CL='STD_NUMBER'></th>
								<th>품번코드</th>
								<th>품명</th>
								<th>수량</th>
							</tr>
						</thead>
					</table>				
				</div>					
				<div class="tableBody">
					<table>
						<colgroup>
							<col width="40" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
						</colgroup>
						<tbody id="gridList">
							<tr CGRow="true">
								<td GCol="rownum">1</td>
								<td GCol="text,SKUKEY"></td>
								<td GCol="text,DESC01"></td>
								<td GCol="text,QTY"></td>
							</tr>
						</tbody>
					</table>
				</div>
				</div>
				<!-- end table_body -->
				<div class="footer_5">
					<table>
						<tr>
							<td onclick="searchList()">새로고침</td>
						</tr>
					</table>
				</div><!-- end footer_5 -->	
			</div>
	</div>
	</div>
</body>