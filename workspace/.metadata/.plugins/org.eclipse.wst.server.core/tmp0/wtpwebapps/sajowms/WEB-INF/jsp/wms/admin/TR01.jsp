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
			pkcol : "WAREKY,SEQCUS",
			module : "WmsAdmin",
			command : "ALCUS",
			validation : "WAREKY,ALSTKY,CUSTMR,NATNKY"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea")
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });			
		}
	}
	
	function saveData(){
		var param = dataBind.paramData("searchArea");
		
		//alert(param);
		
		//return;
		//param.put("REGN01", "test");
		
		var json = gridList.gridSave({
	    	id : "gridList",
	    	param : param
	    });
		
		
		//alert(json);
		/*
		alert("param > " + param);
		//alert(json);
		if(json && json.data){
			alert("json.data > " + json.data);
			searchList();
		}
		*/
		if(json && json.data){
			searchCnt = 1;
					
			var param = dataBind.paramData("searchArea");
			
			gridList.gridList({
				id : "gridList",
		    	param : param

		    });
			
			listFlag = true;

			//gridList.setReadOnly("gridList");
		}
	}

	function gridListEventRowAddBefore(gridId, rowNum) {
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			return newData;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList" && colName == "ALSTKY"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("ALSTKY",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "ALSTKYval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] >1) {
					var param = new DataMap();
					param.put("ALSTKY",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "ALSTKYY",
						sendType : "map",
						param : param
					});
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "SHORTX", json.data["SHORTX"]); 
					} 
				} else if (json.data["CNT"] < 1) {
					gridList.setColValue("gridList", rowNum, "ALSTKY", ""); 
				}
			}else if(colValue==""){
				gridList.setColValue("gridList", rowNum, "SHORTX", "");
			}
		} else if (gridId == "gridList" && colName == "CUSTMR") {
			if(colValue != ""){
				var param = new DataMap();
				param.put("CUSTMR",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "PTNRKYval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] >= 1) {
					var param = new DataMap();
					param.put("CUSTMR",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "NAME012",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "CUSTMRNM", json.data["NAME01"]); 
					} 
				} else if (json.data["CNT"] < 1) {
					gridList.setColValue("gridList", rowNum, "CUSTMRNM", ""); 
				}
			}
		}else if (gridId == "gridList" && colName == "NATNKY") {
			if(colValue != ""){
				var param = new DataMap();
				param.put("NATNKY",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "NATNKYval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] >= 1) {
					var param = new DataMap();
					param.put("NATNKY",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "NATNKY",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "NATNKYNM", json.data["DESC01"]); 
					} 
				} else if (json.data["CNT"] < 1) {
					gridList.setColValue("gridList", rowNum, "NATNKYNM", ""); 
				}
			}
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
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHALSTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHBZPTN"){
			
		}
	}
</script>
</head>
<body style="position: relative;">
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE ">
		</button>
	</div>
	<div class="util3">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
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
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" readonly="readonly"  value="<%=wareky%>"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_ALSTKY">할당전략키</th>
						<td>
							<input type="text" id="ALSTKY" name="ALSTKY" UIInput="R,SHALSTH" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SLGORT">영업부문</th>
						<td>
							<input type="text" id="SLGORT" name="SLGORT" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_NATNKY">국가키</th>
						<td>
							<input type="text" id="NATNKY" name="NATNKY" UIInput="R,SHVNATNKY" />
						</td>
					</tr>
					<tr>
						<th CL="STD_CUSTMR">거래처</th>
						<td>
							<input type="text" id="CUSTMR" name="CUSTMR" UIInput="R,SHBZPTN" />
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
											<col width="170" />
											<col width="80" /> 
											<col width="80" /> 
											<col width="120" />
											<col width="80" />
											<col width="120" />
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
												<th CL='STD_WAREKY'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_SHORTX'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_CUSTMR'></th>
												<th CL='STD_PTNRKYNM'></th>
												<th CL='STD_NATNKY'></th>
												<th CL='STD_NATNKYNM'></th>
												<th CL='STD_CREDAT'>생성일자</th>
												<th CL='STD_CRETIM'>생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_CUSRNM'>생성자명</th>
												<th CL='STD_LMODAT'>수정일자</th>
												<th CL='STD_LMOTIM'>수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_LUSRNM'>수정자명</th>
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
											<col width="170" />
											<col width="80" /> 
											<col width="80" /> 
											<col width="120" />
											<col width="80" />
											<col width="120" />
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
												<td GCol="text,WAREKY" ></td>
												<td GCol="input,ALSTKY,SHALSTH" validate="required,MASTER_M0097" GF="S 10"></td>
												<td GCol="text,SHORTX"></td>
												<td GCol="input,SLGORT" GF="S 10"></td>
												<td GCol="input,CUSTMR,SHBZPTN" GF="S 10"></td>
												<td GCol="text,CUSTMRNM"></td>
												<td GCol="input,NATNKY,SHVNATNKY" GF="S 3"></td>
												<td GCol="text,NATNKYNM"></td> 
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
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
		</div>
		<!-- //contentContainer -->
	</div>
</div>

<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>