<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	var searchCnt = 0;
	var dblIdx = -1;
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsReport",
			command : "RL19",
			maxViewDataCell : 1000
	    });
		$("#USERAREA").val("<%=user.getUserg5()%>");
	});
	
	/* function searchList() {
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
			id : "gridList",
			param : param
		});
	} */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
		    	param : param,
		    	url : "/wms/report/json/ebelnRL19.data"
		    });
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHWAHMA"){
			var param = new DataMap();
			param.put("COMPKY", "<%=compky%>");
			return param;
	    }else if(searchCode == "SHAREMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHZONMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHLOCMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridList"){
			
			var param = inputList.setRangeParam("searchArea");
			param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "RL19");
			return param;
			
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
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea" style="overflow-y:scroll;">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">

		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" value="<%= wareky %>" style="width: 134px" readonly/>
						</td>
					</tr>
					<tr>
						<th CL="STD_EBELN">구매오더번호</th>
						<td>
							<input type="text" name="EBELN" UIInput="R" validate="required,VALID_M1572"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_EBELN'>운송지시번호</th>
												<th CL='STD_EXRECV'>입고예정</th>
												<th CL='STD_EXRECP'>입고완료</th>
												<th CL='STD_EXSHIP'>출고예정</th>
												<th CL='STD_ALLOCA'>할당완료</th>
												<th CL='STD_PICKED'>피킹완료</th>
												<th CL='STD_SHIPED'>출고완료</th>
												<th CL='STD_EXSHEC'>SEHC 입고예정</th>
												<th CL='STD_EXSHECP'>SEHC 입고완료</th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,EBELN"></td>
												<td GCol="text,EXRECV"></td>
												<td GCol="text,EXRECP"></td>
												<td GCol="text,EXSHIP"></td>
												<td GCol="text,ALLOCA"></td>
												<td GCol="text,PICKED"></td>
												<td GCol="text,SHIPED"></td>
												<td GCol="text,EXSHEC"></td>
												<td GCol="text,EXSHECP"></td>
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
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
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>