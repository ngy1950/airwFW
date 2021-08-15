<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var searchCnt = 0;
	var dblIdx = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	name : "gridList",
			editable : true,
			module : "WmsReport",
			command : "RL11TAB1"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	name : "gridList",
			editable : true,
			module : "WmsReport",
			command : "RL11TAB2"
	    });
	});
	
	/* function searchList() {
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	} */
	
	function searchList(){
		if(validate.check("searchArea")){
		var param = inputList.setRangeParam("searchArea");
		/* if(param.get("Opt") == "1" && !param.containsKey("STDDAT")){
			commonUtil.msgBox("VALID_required");
			$("#searchArea").find("[name=STDDAT]").focus();
			return;
		} */
		/* var fromData = param.get("LSHPCDF"); */
		var fromData = $("#LSHPCDF").val();
		/* var toData = param.get("LSHPCDT"); */
		var toData = $("#LSHPCDT").val();
		if(fromData.substring(0,7) != toData.substring(0,7)){
			commonUtil.msgBox("VALID_M0938");
			$("#searchArea").find("[name=LSHPCDT]").focus();
			return;
		}
	 	
		var gridId = "gridList"+param.get("Opt");
			
 		gridList.gridList({
	    	id : gridId,
	    	param : param
	    });  
 		
 		var tabIdx = param.get("Opt")-1 ; //0부터 시작하므로 -1 추가
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
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
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
			<h2 class="tit type1" CL="STD_IFDLMT">구분자</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<td>
							<input type="radio" name="Opt" value="1" checked="checked">
							<label for="Opt" CL="STD_BYSKUKEY1"></label>
							<input type="radio" name="Opt" value="2" />
							<label for="Opt" CL="STD_BYLOTA02"></label>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
				</colgroup>
				<tbody>
					<tr>
						<th CL='STD_DATE'></th>
						<td>
							<input type="text" name="LSHPCDF" id="LSHPCDF" UIFormat="C N" validate="required"/>~
						<!-- </td>
						<th CL='STD_TODATE1'></th>
						<td> -->
							<input type="text" name="LSHPCDT" id="LSHPCDT" UIFormat="C N" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUG04">产品区分</th>
						<td>
							<select Combo="WmsReport,RL11SKUG04COMBO"  name="SKUG04" validate="required">
								<option CL="STD_ALL" value = "ALL"></option>
							</select>
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
						<li><a href="#tabs1-1" id="tab01" onclick="tabChg(1);"><span CL='STD_BYSKUKEY1'>탭메뉴1</span></a></li>
						<li><a href="#tabs1-2" id="tab02" onclick="tabChg(2);"><span CL='STD_BYLOTA02'>탭메뉴1</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUL02'></th>
												<th CL='STD_AMTINI'></th>
												<th CL='STD_AMTREC'></th>
												<th CL='STD_AMTSHP'></th>
												<th CL='STD_AMTSTK'></th>
												<th CL='STD_SKUG04'></th>
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
										</colgroup>
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
											    <td GCol="text,SKUG02"></td>
											    <td GCol="text,SKUL02"></td>
											    <td GCol="text,AMTINI"GF="N"></td>
											    <td GCol="text,AMTREC"GF="N"></td>
											    <td GCol="text,AMTSHP"GF="N"></td>
											    <td GCol="text,AMTSTK"GF="N"></td>
											    <td GCol="text,SKUG04"GF="N"></td>
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
											<col width="100" />
											<col width="100" />
										    <col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA02NM'></th>
												<th CL='STD_AMTSHP'></th>
												<th CL='STD_AMTTOT'></th>
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
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
										        <td GCol="text,LOTA02"></td>
										        <td GCol="text,LOTA02NM"></td>
										        <td GCol="text,AMTSHP"GF="N"></td>
										        <td GCol="text,AMTTOT"GF="N"></td>
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