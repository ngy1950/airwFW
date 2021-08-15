<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsOrder",
			command : "RL05"
		});
	});

	function searchList() {
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
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
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</div>
		<div class="util3">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
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
							<td><input type="text" name="WAREKY" readonly="readonly" value="<%=wareky%>" validation="required" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">품번코드</th>
							<td><input type="text" name="SKUKEY" UIInput="R,SHSKUMA" /></td>
						</tr>
						<tr>
							<th CL="STD_DESC01">품명</th>
							<td><input type="text" name="DESC01" UIInput="R" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<div class="content">
		<div class="innerContainer">

			<!-- contentContainer -->
			<div class="contentContainer">

				<div class="bottomSect type1">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_LIST'>탭메뉴1</span></a></li>
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_SKUKEY'></th>
<!-- 												<th CL='STD_STATUS'></th> -->
<!-- 												<th CL='STD_SKUG01'></th> -->
<!-- 												<th CL='STD_LOTL06'></th> -->
<!-- 												<th CL='STD_LOTL03'></th> -->
<!-- 												<th CL='STD_LOTL03NM'></th> -->
												<th CL='STD_DESC01'></th>
<!-- 												<th CL='STD_SKUL01'></th> -->
<!-- 												<th CL='STD_SKUL03'></th> -->
<!-- 												<th CL='STD_VENDKY'></th> -->
<!-- 												<th CL='STD_VENDKYNM'></th> -->
<!-- 												<th CL='STD_LOTL02'></th> -->
<!-- 												<th CL='STD_LOTL08'></th> -->
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTSINT'></th>
												<th CL='STD_GRDOCUTY'></th>
												<th CL='STD_GRDOCUTY_01'></th>
												<th CL='STD_GRDOCUTY_02'></th>
												<th CL='STD_GRDOCUTY_03'></th>
												<th CL='STD_GRDOCUTY_04'></th>
												<th CL='STD_GRDOCUTY_05'></th>
												<th CL='STD_GRDOCUTY_06'></th>
												<th CL='STD_GIDOCUTY'></th>
												<th CL='STD_GIDOCUTY_01'></th>
												<th CL='STD_GIDOCUTY_02'></th>
												<th CL='STD_GIDOCUTY_03'></th>
												<th CL='STD_GIDOCUTY_04'></th>
												<th CL='STD_GIDOCUTY_05'></th>
												<th CL='STD_GIDOCUTY_06'></th>
												<th CL='STD_GIDOCUTY_07'></th>
												<th CL='STD_GIDOCUTY_08'></th>
												<th CL='STD_GIDOCUTY_09'></th>
<!-- 												<th CL='STD_FLD003'></th> -->
<!-- 												<th CL='STD_FLD004'></th> -->
<!-- 												<th CL='STD_FLD005'></th> -->
<!-- 												<th CL='STD_FLD006'></th> -->
<!-- 												<th CL='STD_FLD007'></th> -->
<!-- 												<th CL='STD_FLD008'></th> -->
<!-- 												<th CL='STD_FLD009'></th> -->
<!-- 												<th CL='STD_FLD010'></th> -->
<!-- 												<th CL='STD_FLD011'></th> -->
<!-- 												<th CL='STD_FLD012'></th> -->
<!-- 												<th CL='STD_FLD013'></th> -->
<!-- 												<th CL='STD_FLD014'></th> -->
<!-- 												<th CL='STD_FLD015'></th> -->
<!-- 												<th CL='STD_CALUSR'></th> -->
<!-- 												<th CL='STD_CALUSRNM'></th> -->
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
<!-- 												<th CL='STD_INDBZL'></th> -->
<!-- 												<th CL='STD_INDARC'></th> -->
<!-- 												<th CL='STD_UPDCHK'></th> -->
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,DOCDAT" GF="D"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,SKUKEY"></td>
<!-- 												<td GCol="text,STATUS"></td> -->
<!-- 												<td GCol="text,SKUG01"></td> -->
<!-- 												<td GCol="text,LOTL06"></td> -->
<!-- 												<td GCol="text,LOTL03"></td> -->
<!-- 												<td GCol="text,LOTL03NM"></td> -->
												<td GCol="text,DESC01"></td>
<!-- 												<td GCol="text,SKUL01"></td> -->
<!-- 												<td GCol="text,SKUL03"></td> -->
<!-- 												<td GCol="text,VENDKY"></td> -->
<!-- 												<td GCol="text,VENDKYNM"></td> -->
<!-- 												<td GCol="text,LOTL02"></td> -->
<!-- 												<td GCol="text,LOTL08"></td> -->
												<td GCol="text,FLD001"></td>
												<td GCol="text,FLD002" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_01" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_02" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_03" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_04" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_05" GF="N 20,3"></td>
												<td GCol="text,GRDOCUTY_06" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_01" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_02" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_03" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_04" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_05" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_06" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_07" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_08" GF="N 20,3"></td>
												<td GCol="text,GIDOCUTY_09" GF="N 20,3"></td>
<!-- 												<td GCol="text,FLD003" GF="N"></td> -->
<!-- 												<td GCol="text,FLD004"></td> -->
<!-- 												<td GCol="text,FLD005"></td> -->
<!-- 												<td GCol="text,FLD006"></td> -->
<!-- 												<td GCol="text,FLD007"></td> -->
<!-- 												<td GCol="text,FLD008"></td> -->
<!-- 												<td GCol="text,FLD009"></td> -->
<!-- 												<td GCol="text,FLD010" GF="N"></td> -->
<!-- 												<td GCol="text,FLD011" GF="N"></td> -->
<!-- 												<td GCol="text,FLD012" GF="N"></td> -->
<!-- 												<td GCol="text,FLD013" GF="N"></td> -->
<!-- 												<td GCol="text,FLD014" GF="N"></td> -->
<!-- 												<td GCol="text,FLD015" GF="N"></td> -->
<!-- 												<td GCol="text,CALUSR"></td> -->
<!-- 												<td GCol="text,CALUSRNM"></td> -->
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
<!-- 												<td GCol="text,INDBZL"></td> -->
<!-- 												<td GCol="text,INDARC"></td> -->
<!-- 												<td GCol="text,UPDCHK" GF="N"></td> -->
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