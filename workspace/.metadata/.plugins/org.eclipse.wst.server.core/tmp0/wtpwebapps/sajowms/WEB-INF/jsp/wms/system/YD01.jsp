<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function() {
		setTopSize(80);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			pkcol : "DDICKY",
			module : "System",
			command : "DATADIC",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
	});

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function searchList() {

		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum) {
		var param = inputList.setRangeParam("searchArea");
		var datfty = param.get("DATFTY");

		var newData = new DataMap();
		newData.put("DATFTY", datfty);

		return newData;
	}

	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		
		if(searchCode == "SHAREMA"){
			param.put("WAREKY", "<%= wareky%>");
			
			return param;
		}
	}
	
	function saveData(){
		var modCnt = gridList.getModifyRowCount("gridList");
		
		if(modCnt == 0){
			commonUtil.msgBox("MASTER_M0545");
			return;
		}
		
		//권한체크
		if(!commonUtil.roleCheck(configData.MENU_ID, "<%=userid%>", "Y", "", "")) {
			return;
		}
		
		if(gridList.validationCheck("gridList", "modify")){
			var param = dataBind.paramData("searchArea");
			var json = gridList.gridSave({
				id : "gridList",
				param : param
			});
			
			if(json && json.data){
				searchList();
			}	
		}
	}

	
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Save SAVE BTN_SAVE"></button>
		</div>
	</div>

	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
				
				<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_DDICKY"></th>
										<td>
											<input type="text" name="DDICKY" UIInput="SR" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
				
				
				
				<div class="bottomSect bottom">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GH="40 STD_NUMBER"   GCol="rownum">1</td>
													<td GH="120 STD_DDICKY"  GCol="input,DDICKY"           GF="S 20"     validate="required,SYSTEM_M0102" ></td>
													<td GH="120 STD_DATFTY"  GCol="input,DATFTY"           GF="S 20"     validate="required,MASTER_M0434"></td>
													<td GH="350 STD_SHORTX"  GCol="input,SHORTX"           GF="S 180"></td>
													<td GH="120 STD_DBFILD"  GCol="input,DBFILD"           GF="S 20"></td>
													<td GH="120 STD_PDATTY"  GCol="input,PDATTY"           GF="S 4"></td>
													<td GH="120 STD_OBJETY"  GCol="input,OBJETY"           GF="S 4"></td>
													<td GH="120 STD_DBLENG"  GCol="input,DBLENG"           GF="N 6"></td><!-- 
													<td GH="120 STD_DBDECP"  GCol="input,DBDECP"           GF="N 3"></td> -->
													<td GH="120 STD_OUTLEN"  GCol="input,OUTLEN"           GF="N 6"></td>
													<td GH="120 STD_SHLPKY"  GCol="input,SHLPKY,SHSHLPH"></td>
													<td GH="120 STD_FLDALN"  GCol="input,FLDALN"           GF="S 4"></td>
													<td GH="120 STD_LABLGR"  GCol="input,LABLGR,SHLBLGR"></td>
													<td GH="120 STD_LABLKY"  GCol="input,LABLKY,SHLBLKY"></td>
											   <!-- <td GH="120 STD_LBTXTY"  GCol="input,LBTXTY"           GF="S 4"></td>
													<td GH="120 STD_UCASOL"  GCol="check,UCASOL"></td> -->
													<td GH="120 STD_CREDAT"  GCol="text,CREDAT"            GF="D"></td>
													<td GH="120 STD_CRETIM"  GCol="text,CRETIM"            GF="T"></td>
													<td GH="120 STD_CREUSR"  GCol="text,CREUSR" ></td>
													<td GH="120 STD_CUSRNM"  GCol="text,CUSRNM"></td>
													<td GH="120 STD_LMODAT"  GCol="text,LMODAT"            GF="D"></td>
													<td GH="120 STD_LMOTIM"  GCol="text,LMOTIM"            GF="T"></td>
													<td GH="120 STD_LMOUSR"  GCol="text,LMOUSR"></td>
													<td GH="120 STD_LUSRNM"  GCol="text,LUSRNM"></td>
												</tr>       
											</tbody>        
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<button type="button" GBtn="add"></button>
										<button type="button" GBtn="delete"></button>
										<button type="button" GBtn="layout"></button>
										<button type="button" GBtn="total"></button>
										<button type="button" GBtn="excel"></button>										
									</div>
									<div class="rightArea">
										<p class="record" GInfoArea="true">17 Record</p>
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