<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
	$(document).ready(function() { 
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "HT01"
		});
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	function searchList() {
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>
	
	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
			<div class="bottomSect top" id="searchArea" style="height:100px">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_CREDAT"></th>
										<td>
											<input type="text" name="LOG.CREDAT" UIInput="B"  UIFormat="C N" validate="required" MaxDiff="M1" />
										</td>
										<th CL="STD_LOGTYP"></th>
										<td>
											<select name="LOG.LOGTYP" CommonCombo="LOGTYP" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_USERID"></th>
										<td>
											<input type="text" name="LOG.USERID" UIInput="SR,SHUSRMA" />
										</td>
										<th CL="STD_NMLAST"></th>
										<td>
											<input type="text" name="LOG.NMLAST" UIInput="SR" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_LIST'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER" GCol="rownum">1</td>
												<td GH="100 STD_USERID" GCol="text,USERID"></td>
												<td GH="100 STD_NMLAST" GCol="text,NMLAST"></td>
												<td GH="100 STD_ORGNNM" GCol="text,ORGNNM"></td>
												<td GH="100 STD_JOBDNM" GCol="text,JOBDNM"></td>
												<td GH="100 STD_LOGTYP" GCol="text,LOGTNM,center"></td>
												<td GH="100 STD_USERIP" GCol="text,USERIP,center"></td>
												<td GH="100 STD_CREDAT" GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_CRETIM" GCol="text,CRETIM,center" GF="T"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">0 Record</p>
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