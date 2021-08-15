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
		setTopSize(80);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			pkcol : "LANGKY,MESGGR,MESGKY",
			module : "System",
			command : "MESSAGE",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
	});
	
	//조회
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
	
	//저장
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
	
	function loadMessage(){
		netUtil.send({
			url : "/common/message/json/reload.data",
			failFunction : "",
			successFunction : "saveDataCallBack"
		});
	}
	
	function saveDataCallBack(json, returnParam){
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			loadMessage();
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		
		var param = inputList.setRangeParam("searchArea");
		var langky = param.get("LANGKY");
		
		var newData = new DataMap();
		newData.put("LANGKY", "KR");
		
		return newData;
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
										<th CL="STD_MESGGR"></th> 
										<td>
<!-- 											<input type="hidden" name="LANGKY" value="KR" /> -->
											<input type="text" name="MESGGR" UIInput="SR" UIFormat="U" />
										</td>
										<th CL="STD_MESGKY"></th> 
										<td>
											<input type="text" name="MESGKY" UIInput="SR" UIFormat="U" />
										</td>
										<th CL="STD_MESGTX"></th> 
										<td>
											<input type="text" name="MESGTX" UIInput="SR" />
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
												<td GH="100 STD_LANGKY" GCol="text,LANGKY"></td>            
												<td GH="100 STD_MESGGR" GCol="input,MESGGR" GF="U 10"    validate="required" ></td>      
												<td GH="100 STD_MESGKY" GCol="input,MESGKY" GF="U 20"    validate="required" ></td>      
												<td GH="500 STD_MESGTX" GCol="input,MESGTX" GF="S 300"   validate="required"></td>
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