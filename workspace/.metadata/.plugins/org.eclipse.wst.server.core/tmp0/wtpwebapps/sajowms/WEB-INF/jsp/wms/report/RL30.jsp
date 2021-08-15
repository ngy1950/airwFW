<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "WmsReport",
			command : "RL30"
	    });
		searchList();
	});
	
	function searchList(){
		var param = new DataMap();
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
	</div>
</div>
<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>탭메뉴1</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_SUBLSQ'></th>
												<th CL='STD_FRDATE'></th>
												<th CL='STD_TODATE'></th>
												<th CL='STD_USERID'></th>
												<th CL='STD_USERNM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
											<col width="100" /> 
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="text,SUBLSQ"></td>
												<td GCol="text,FRDATE" GF="D"></td>
												<td GCol="text,TODATE" GF="D"></td>
												<td GCol="text,USERID"></td>
												<td GCol="text,USERNM"></td>
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>	
					
			</div>
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>