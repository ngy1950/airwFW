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
	    	id : "gridList1",
			editable : true,
			module : "WmsReport",
			command : "RL02TAB1"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			editable : true,
			module : "WmsReport",
			command : "RL02TAB2"
	    });
		gridList.setGrid({
	    	id : "gridList3",
			editable : true,
			module : "WmsReport",
			command : "RL02TAB3"
	    });
		gridList.setGrid({
	    	id : "gridList4",
			editable : true,
			module : "WmsReport",
			command : "RL02TAB4"
	    });
		
		userInfoData = page.getUserInfo();
		dataBind.dataNameBind(userInfoData, "searchArea");
	});
	
	function searchList(){

		var param = inputList.setRangeParam("searchArea");
			
	 		gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });  
	 		$('.tabs').tabs("option","active",0);
	}
	
	function tabChg(num){
		var gridId = "gridList"+num;
		var param = inputList.setRangeParam("searchArea");
		$("input[value='"+ num +"']").prop("checked",true);
		
		gridList.gridList({
	    	id : gridId,
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
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>

</div>

<!-- searchPop -->
<div class="searchPop" style="overflow-y:scroll;">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS">일반정보</h2>
	
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
						<th CL="STD_DOCDAT">생성일자</th>
						<td>
							<input type="text" name="SH.LOTA11" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="SI.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="SI.DESC01" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab01" onclick="tabChg(1);"><span CL='STD_BYMONTH'></span></a></li>
						<li><a href="#tabs1-2" id="tab02" onclick="tabChg(2);"><span CL='STD_BYDAY'></span></a></li>
						<li><a href="#tabs1-3" id="tab03" onclick="tabChg(3);"><span CL='STD_BYSKUKEY'></span></a></li>
						<li><a href="#tabs1-4" id="tab04" onclick="tabChg(4);"><span CL='STD_BYDOCUTY'></span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_YEAR'></th>
												<th CL='STD_MONTH'></th>
											    <th CL='STD_QTSHPO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_SNDQTY'></th>
												<th CL='STD_AMOUNT'></th>
												<th CL='STD_CUBICT'></th>
												<th CL='STD_LOTA10'></th>
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
										</colgroup>
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
											    <td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,YEAR"></td>
												<td GCol="text,MONTH"></td>
												<td GCol="text,QTSHPO" GF="N"></td>
												<td GCol="text,QTALOC" GF="N"></td>
												<td GCol="text,QTJCMP" GF="N"></td>
												<td GCol="text,QTSHPD" GF="N"></td>
												<td GCol="text,AMOUNT" GF="N"></td>
												<td GCol="text,CUBICT" GF="N"></td>   
												<td GCol="text,LOTA10"></td>                                              
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
					<div id="tabs1-2">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_YEAR'></th>
												<th CL='STD_MONTH'></th>
											    <th CL='STD_DAY'></th>
												<th CL='STD_QTSHPO' GF="N"></th>
												<th CL='STD_QTALOC' GF="N"></th>
												<th CL='STD_QTJCMP' GF="N"></th>
												<th CL='STD_SNDQTY' GF="N"></th>
												<th CL='STD_AMOUNT' GF="N"></th>
												<th CL='STD_CUBICT' GF="N"></th>
												<th CL='STD_LOTA10'></th>
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
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
										        <td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,YEAR"></td>
												<td GCol="text,MONTH"></td>
												<td GCol="text,DAY"></td>
												<td GCol="text,QTSHPO" GF="N"></td>
												<td GCol="text,QTALOC" GF="N"></td>
												<td GCol="text,QTJCMP" GF="N"></td>
												<td GCol="text,QTSHPD" GF="N"></td>
												<td GCol="text,AMOUNT" GF="N"></td>
												<td GCol="text,CUBICT" GF="N"></td>
												<td GCol="text,LOTA10"></td>
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
					<div id="tabs1-3">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
											    <th CL='STD_QTSHPO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_SNDQTY'></th>
												<th CL='STD_UNCOST'></th>
												<th CL='STD_AMOUNT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CUBICT'></th>
												<th CL='STD_LOTA10'></th>
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
										</colgroup>
										<tbody id="gridList3">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
											    <td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,QTSHPO" GF="N"></td>
												<td GCol="text,QTALOC" GF="N"></td>
												<td GCol="text,QTJCMP" GF="N"></td>
												<td GCol="text,QTSHPD" GF="N"></td>
												<td GCol="text,HEIGHT" GF="N"></td>
												<td GCol="text,AMOUNT" GF="N"></td>
												<td GCol="text,CUBICM" GF="N"></td>
												<td GCol="text,CUBICT" GF="N"></td>
												<td GCol="text,LOTA10"></td>
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
					<div id="tabs1-4">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_DOCUTY'></th>
												<th CL='STD_DOCUTYNM'></th>
											    <th CL='STD_QTSHPO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_SNDQTY'></th>
												<th CL='STD_AMOUNT'></th>
												<th CL='STD_CUBICT'></th>
												<th CL='STD_LOTA10'></th>
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
										</colgroup>
										<tbody id="gridList4">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
									    		<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,DOCUTY"></td>
												<td GCol="text,DOCUTYNM"></td>
												<td GCol="text,QTSHPO" GF="N"></td>
												<td GCol="text,QTALOC" GF="N"></td>
												<td GCol="text,QTJCMP" GF="N"></td>
												<td GCol="text,QTSHPD" GF="N"></td>
												<td GCol="text,AMOUNT" GF="N"></td>
												<td GCol="text,CUBICT" GF="N 20,3"></td>
												<td GCol="text,LOTA10"></td>
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
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>