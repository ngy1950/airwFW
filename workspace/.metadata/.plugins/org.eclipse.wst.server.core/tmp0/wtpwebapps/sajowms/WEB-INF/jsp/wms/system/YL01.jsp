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
		setTopSize(100);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			pkcol : "LANGKY,LABLGR,LABLKY",
			module : "System",
			command : "LABEL",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
	});
	
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("LANGKY", "KR");
			
			//alert(param);
			gridList.gridList({
				id : "gridList",
				param : param
			});
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
			
			//alert(json);
			if(json && json.data){
				//loadLabel();
				searchList();
			}	
		}
	}
	
	function loadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data",
			failFunction : "",
			successFunction : "saveDataCallBack"
		});
	}
	
	function saveDataCallBack(json, returnParam){
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		
		var newData = new DataMap();
		newData.put("LANGKY", "KR");
		
		return newData;
	}
	
	function lablkyCheck(valueTxt, $colObj){
		var rowNum = gridList.getColObjRowNum("gridList", $colObj);
		var rowCount = gridList.getGridDataCount("gridList");
		for(var i=0;i<rowCount;i++){
			if(i != rowNum){
				var lablky = gridList.getColData("gridList", i, "LABLKY");
				if(lablky == valueTxt){
					return false;
				}
			}
		}
		
		return true;
	}
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			loadLabel();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Reload EXECUTE BTN_RELOAD"></button>
	</div>
<!-- 	<div class="util2"> -->
<!-- 		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button> -->
<!-- 	</div> -->
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
									<col width="250" />
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_LABLGR"></th>
										<td>
											<input type="text" name="LABLGR" UIInput="SR" />
										</td>
										<th CL="STD_LABLKY"></th>
										<td>
											<input type="text" name="LABLKY" UIInput="SR" />
										</td>
										<th CL="STD_LBLTXS"></th>
										<td>
											<input type="text" name="LBLTXS" UIInput="SR" />
										</td>
									</tr>
									<tr>
										<th CL="STD_LBLTXM"></th>
										<td>
											<input type="text" name="LBLTXM" UIInput="SR" />
										</td>
										<th CL="STD_LBLTXL"></th>
										<td>
											<input type="text" name="LBLTXL" UIInput="SR" />
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
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="40 STD_LANGKY"  GCol="text,LANGKY"           GF="S 3"      validate="required,SYSTEM_M0014" ></td>
												<td GH="150 STD_LABLGR" GCol="input,LABLGR,SHLBLGR"  GF="S 10"     validate="required" ></td>
												<td GH="150 STD_LABLKY" GCol="input,LABLKY"          GF="S 20"     validate="required" ></td>
												<td GH="150 STD_LBLTXS" GCol="input,LBLTXS"          GF="S 24"></td>
												<td GH="150 STD_LBLTXM" GCol="input,LBLTXM"          GF="S 45"></td>
												<td GH="150 STD_LBLTXL" GCol="input,LBLTXL"          GF="S 180"></td>
												<td GH="150 STD_CREDAT" GCol="text,CREDAT"           GF="D"></td>
												<td GH="150 STD_CRETIM" GCol="text,CRETIM"           GF="T"></td>
												<td GH="150 STD_CREUSR" GCol="text,CREUSR"></td>
												<td GH="150 STD_LMODAT" GCol="text,LMODAT"           GF="D"></td>
												<td GH="150 STD_LMOTIM" GCol="text,LMOTIM"           GF="T"></td>
												<td GH="150 STD_LMOUSR" GCol="text,LMOUSR"></td>
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