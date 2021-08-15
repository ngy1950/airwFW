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
			pkcol : "WAREKY",
			module : "WmsReport",
			command : "RL01TAB1"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsReport",
			command : "RL01TAB2"
	    });
		gridList.setGrid({
	    	id : "gridList3",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsReport",
			command : "RL01TAB3"
	    });
		gridList.setGrid({
	    	id : "gridList4",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsReport",
			command : "RL01TAB4"
	    });
		
		userInfoData = page.getUserInfo();
		dataBind.dataNameBind(userInfoData, "searchArea");
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var gridId = "gridList1"
				
		 		gridList.gridList({
			    	id : gridId,
			    	param : param
			    });  
		 		$('#bottomTabs').tabs("option", "active", tabIdx);
		}
	}
	
	function tabChg(num){
		var gridId = "gridList"+num;
		var param = inputList.setRangeParam("searchArea");
		$("input[value='"+ num +"']").prop("checked",true); //현재 TAB 재조회를 위해 추가
		
		gridList.gridList({
	    	id : gridId,
	    	param : param
	    });
	}
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments); 
		if(searchCode == "SHSKUMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHLOCMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHCMCDV"){
			var param = new DataMap();
			if($inputObj.name == "S.SKUG01"){
				param.put("CMCDKY", "SKUG01");
			}else{
				param.put("CMCDKY", "LOTA06");
			}
			return param; 
		}
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			test3();
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
							<input type="text" name="WAREKY" readonly="readonly" value="<%=wareky%>"/><!--  UIInput="S,SHWAHMA" validate="required,MASTER_M0434" -->
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">문서일자</th>
						<td>
							<input type="text" name="RH.DOCDAT" UIInput="R" UIFormat="C"  />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="RI.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="RI.DESC01" UIInput="R" />
						</td>
					</tr>
					<tr>
					<th CL="STD_LOTA02"></th>
						<td>
							<input type="text" name="DEPART" />
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
				<div class="tabs"  id="bottomTabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab01" onclick="tabChg(1);"><span CL='STD_BYMONTH'>탭메뉴1</span></a></li>
						<li><a href="#tabs1-2" id="tab02" onclick="tabChg(2);"><span CL='STD_BYDAY'>탭메뉴1</span></a></li>
						<li><a href="#tabs1-3" id="tab03" onclick="tabChg(3);"><span CL='STD_BYSKUKEY'>탭메뉴1</span></a></li>
						<li><a href="#tabs1-4" id="tab04" onclick="tabChg(4);"><span CL='STD_BYDOCUTY'>탭메뉴1</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_WAREKYNM'>거점명</th>
												<th CL='STD_YEAR'>년도</th>
												<th CL='STD_MONTH'>월</th>
												<th CL='STD_QTYRCV'>WMS입하수량</th>
												<th CL='STD_AMOUNT'>전송수량</th>
												<th CL='STD_CUBICT'>총금액</th>
												<th CL='STD_LOTA10'>통화</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,YEAR"></td>
												<td GCol="text,MONTH"></td>
												<td GCol="text,QTYRCV" GF="N 20,3"></td>
												<td GCol="text,AMOUNT" GF="N 20,3"></td>
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
					<div id="tabs1-2">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_WAREKYNM'>거점명</th>
												<th CL='STD_YEAR'>년도</th>
												<th CL='STD_MONTH'>월</th>
												<th CL='STD_DAY'>일</th>
												<th CL='STD_QTYRCV'>WMS입하수량</th>
												<th CL='STD_AMOUNT'>전송수량</th>
												<th CL='STD_CUBICT'>총금액</th>
												<th CL='STD_LOTA10'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,YEAR"></td>
												<td GCol="text,MONTH"></td>
												<td GCol="text,DAY"></td>
												<td GCol="text,QTYRCV"  GF="N 20,3"></td>
												<td GCol="text,AMOUNT"  GF="N 20,3"></td>
												<td GCol="text,CUBICT"  GF="N 20,3"></td>
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
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_WAREKYNM'>거점명</th>
												<th CL='STD_SKUKEY'>제품코드</th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_QTYRCV'>WMS입하수량</th>
												<th CL='STD_QTYORG'>입하수량</th>
												<th CL='STD_HEIGHT'>?</th>
												<th CL='STD_AMOUNT'>전송수량</th>
												<th CL='STD_CUBICM'>단가</th>
												<th CL='STD_CUBICT'>총금액</th>
												<th CL='STD_LOTA10'></th>
											</tr>       
										</thead>        
									</table>            
								</div>                  
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridList3">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,QTYRCV" GF="N 20,3"></td>
												<td GCol="text,QTYORG" GF="N 20,3"></td>
												<td GCol="text,HEIGHT" GF="N 20,3"></td>
												<td GCol="text,AMOUNT" GF="N 20,3"></td>
												<td GCol="text,CUBICM" GF="N 20,3"></td>
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
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_WAREKYNM'>거점명</th>
												<th CL='STD_DOCUTY'>제품코드</th>
												<th CL='STD_DOCUTYNM'></th>
												<th CL='STD_QTYRCV'>WMS입하수량</th>
												<th CL='STD_QTYORG'>입하수량</th>
												<th CL='STD_AMOUNT'>전송수량</th>
												<th CL='STD_CUBICT'>총금액</th>
												<th CL='STD_LOTA10'></th>
											</tr>       
										</thead>        
									</table>            
								</div>                  
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
										 	<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridList4">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,DOCUTY"></td>
												<td GCol="text,DOCUTYNM"></td>
												<td GCol="text,QTYRCV" GF="N 20,3"></td>
												<td GCol="text,QTYORG" GF="N 20,3"></td>
												<td GCol="text,AMOUNT" GF="N 20,3"></td>
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