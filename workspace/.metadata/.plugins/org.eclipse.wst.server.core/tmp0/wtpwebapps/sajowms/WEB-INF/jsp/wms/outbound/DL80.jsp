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
	    	name : "gridList",
			editable : true,
			module : "WmsOutbound",
			command : "DL80"
	    });
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
			
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

	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
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
<div class="searchPop" id="searchArea">
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
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCUTY">문서타입</th>
						<td>
							<input type="text" name="SH.DOCUTY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">출하문서번호</th>
						<td>
							<input type="text" name="SH.SHPOKY" UIInput="R,SHSHPOKY" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">문서일자</th>
						<td>
							<input type="text" name="SH.DOCDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">문서상태</th>
						<td>
							<input type="text" name="SH.STATDO" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit">ERP 검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_SVBELN">거래처</th>
						<td>
							<input type="text" name="SI.SVBELN" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STKNUM">품번코드</th>
						<td>
							<input type="text" name="SI.STKNUM" UIInput="R" />
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
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>탭메뉴1</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_SHPMTY'></th>
												<th CL='STD_SHPMTYNM'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM'></th>
												<th CL='STD_DPTNKY'></th>
												<th CL='STD_DPTNKYNM'></th>
												<th CL='STD_QTSHPO'></th>
												<th CL='STD_STATUS'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_STATUS'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_STATUS'></th>
												<th CL='STD_QTSHPD'></th>
												<th CL='STD_STATUS'></th>
												<th CL='ITF_ESHPKY,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,DOCDAT"></td>
												<td GCol="text,SHPMTY"></td>
												<td GCol="text,SHPMTYNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATDONM"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNKYNM"></td>
												<td GCol="text,QTSHPO"></td>
												<td GCol="text,ICSTAT"></td>
												<td GCol="text,QTALOC"></td>
												<td GCol="text,ICALOC"></td>
												<td GCol="text,QTJCMP"></td>
												<td GCol="text,ICJCMP"></td>
												<td GCol="text,QTSHPD"></td>
												<td GCol="text,ICSHPD"></td>
												<td GCol="text,ESHPKY"></td>
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
		 		</div>
			</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>