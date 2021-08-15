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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "WmsReport",
			command : "RL31"
	    });
		
		
		var areaky = "<%=user.getUserg5()%>";
		var wareky = "<%=wareky%>";
		
		var param = new DataMap();
		param.put("WAREKY",wareky);
		param.put("AREAKY",areaky);
	
		var json = netUtil.sendData({
			module : "WmsInventory",
			command : "AREAKYVal",
			sendType : "map",
			param : param
		});
		
		if(json.data["CNT"] != 0){
			inputList.setRangeData("AREAKY", configData.INPUT_RANGE_RANGE_FROM, areaky);
		}
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function proCall(){
		var param = inputList.setRangeParam("searchArea");

		var json = netUtil.sendData({
			module : "WmsReport",
			command : "RL31",
			sendType : "map",
			param : param
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			proCall();
		}else if(btnName == "Check1"){
			changeDate(1);
		}else if(btnName == "Check2"){
			changeDate(2);
		}else if(btnName == "Check3"){
			changeDate(3);
		}
	}
	
	function changeDate(type){
		if(type == 1){
			var dt = new Date();
			var year = dt.getFullYear();
			var month = dt.getMonth()+1;
			var date = dt.getDate()

			if(month < 10){
				month = '0'+month;
			}
			if(date < 10){
				date = '0'+date;
			}
			
			var today = year + '.' + month  +'.'+ date;
			$('#CYDAT1').val(today);
			$('#CYDAT2').val(today);
		}else if(type == 2){
			var dt = new Date();
			var Tdate = dt.getDate();
			
			dt.setDate(dt.getDate() - 7);
			var year = dt.getFullYear();
			var month = dt.getMonth()+1;
			var date = dt.getDate()
			
			if(month < 10){
				month = '0'+month ;
			}
			if(date < 10){
				date = '0'+date;
			}
			var yesterDay = year + '.' + month  +'.'+ date;
			var today = year + '.' + month  +'.'+ Tdate;
			$('#CYDAT1').val(yesterDay);
			$('#CYDAT2').val(today);
		}else if(type == 3){
			var dt = new Date();
			
			var year = dt.getFullYear();
			var month = dt.getMonth()+1;
			var Tdate = dt.getDate();
			
			if(month < 10){
				month = '0'+month;
			}
			if(Tdate < 10){
				Tdate = '0'+Tdate;
			}
			var thisMonth = year +'.'+ month +'.'+'01';
			var today = year +'.'+ month +'.'+Tdate;
			$('#CYDAT1').val(thisMonth);
			$('#CYDAT2').val(today);
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
			<button CB="Save SAVE BTN_RECPAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
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
						<th CL="STD_DOCDAT">문서일자</th>
						<td>
							<input type="text" name="CYDAT1" id="CYDAT1" UIFormat="C N" validate="required"/> ~ <input type="text" name="CYDAT2" id="CYDAT2" UIFormat="C N" validate="required"/>
						</td>
						<button CB="Check1 CHECK Today"></button><button CB="Check2 CHECK Week"></button><button CB="Check3 CHECK Month"></button>
					</tr>
					<tr>
						<th CL="STD_WAREKY">물류센터</th>
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" UIInput="R,SHWHAMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY"></th>
						<td>
							<input type="text" name="AREAKY" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번</th>
						<td>
							<input type="text" name="SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="DESC01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUG05">규격</th>
						<td>
							<input type="text" name="SKUG05" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC04">제조사</th>
						<td>
							<input type="text" name="DESC04" UIInput="R" />
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
											<col width="100" />
											<col width="100" /> 
											<col width="100" />
											<col width="100" />
											<col width="100" /> 
											<col width="100" />
											<col width="100" />
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
												<th CL='STD_WAREKY'>언어</th>
												<th CL='STD_AREAKY'>라벨그룹</th>
												<th CL='STD_OWNRKY'>라벨 키</th>
												<th CL='STD_SKUKEY'>언어</th>
												<th CL='STD_DESC01'>라벨그룹</th>
												<th CL='STD_DESC02'>라벨 키</th>
												<th CL='STD_SKUG05'>언어</th>
												<th CL='STD_DESC04'>라벨그룹</th>
												<th CL='STD_SKUG02'>라벨 키</th>
												<th CL='STD_LOTL03'>언어</th>
												<th CL='STD_LOTL04'>라벨그룹</th>
												<th CL='STD_SKUG01'>라벨 키</th>
												<th CL='STD_QTINIT'>라벨 키</th>
												<th CL='STD_GRQTYT'>언어</th>
												<th CL='STD_GIQTYT'>라벨그룹</th>
												<th CL='STD_QTCOMP'>라벨 키</th>
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
											<col width="100" />
											<col width="100" />
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
												<td GCol="text,WAREKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,DESC04"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,LOTL03"></td>
												<td GCol="text,LOTL04"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,QTINIT"></td>
												<td GCol="text,GRQTYT"></td>
												<td GCol="text,GIQTYT"></td>
												<td GCol="text,QTCOMP"></td>
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
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
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