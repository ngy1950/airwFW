<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "200px";

	var g_type = "S";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			name : "gridHeadList",
			editable : true,
			module : "System",
			command : "MENU",
			itemGrid : "gridList",
			itemSearch : true,
			autoCopyRowType : false
		});
		
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			tree : "MENULV,LBLTXL,AMNUID,MENUID,SORTSQ",
			pkcol : "MENUKY,MENUID",
			module : "System",
			command : "MENU_SUB",
			selectRowDeleteType : false,
			autoCopyRowType : false

		});
	});
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Create"){
			createData();
		}else if(btnName == "Delete"){
			deleteData();
		}
	}
	
	function createData(){
		var param = inputList.setRangeParam("searchArea");
		var cpmenuky = param.get("CPMENUKY");
		var menuky = param.get("MENUKY");
		
		if ( $.trim(menuky) == "" ){
			commonUtil.msgBox("COMMON_M0009", commonLabel.getLabel("STD_MENUKY", 1));
			return ;
		}
		
		var json = netUtil.sendData({
			module : "System",
			command : "MENUKYval",
			sendType : "map",
			param : param
		});
		
		if(json.data["CNT"] > 0) {
			commonUtil.msgBox("MASTER_M0025",menuky);
			return;
		}
		
		gridList.resetGrid("gridHeadList");
		var rowData = new DataMap();
			rowData.put("MENUKY",menuky);
		gridList.addNewRow("gridHeadList", rowData)
		
		g_type = "C";
		gridList.setDefaultRowState('gridList','C');
		
		
		if ( $.trim(cpmenuky) != "" ){
			param.put("WAREKY", "<%=wareky%>");
			
			netUtil.send({
				module : "System",
				command : "CPMENU",
				bindId : "gridList",
				sendType : "list",
				bindType : "grid",
				param : param
			});
		}
	}
	
	function searchList(){

		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridList");
		gridList.setDefaultRowState('gridList',configData.GRID_ROW_STATE_START);

		 g_type = "S";
		
		var param = inputList.setRangeParam("searchArea");

		if(validate.check("searchArea")){
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){

		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridList");
			searchOpen(true);
		}else if(gridId == "gridList" && dataLength > 0){
			var list = gridList.getGridData(gridId, true);
			for(var i = 0; i < dataLength; i++){
				var row = list[i];
				var rowNum  = row.get(configData.GRID_ROW_NUM);
				var amenuid = row.get("AMNUID");
				if(amenuid == "root"){
					gridList.setRowReadOnly(gridId, rowNum, false, ["IMGPTH"])
				}else{
					gridList.setRowReadOnly(gridId, rowNum, true, ["IMGPTH"])
				}
			}
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){  
		var param = getItemSearchParam(rowNum);

		gridList.gridList({
			id : "gridList",
			param : param
		});
	}
	
	// 아이템 그리드 Parameter
	function getItemSearchParam(rowNum){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		var param = inputList.setRangeParam("searchArea");
		param.putAll(rowData);
		
		return param;
	}
	
	
	function gridListEventRowAddBefore(gridId, rowNum){
		
		if(gridId == "gridList"){
			var param = inputList.setRangeParam("searchArea");
			
			var MENUKY = param.get("MENUKY");
			var newData = new DataMap();
			newData.put("MENUKY", MENUKY);
			
			return newData;
		}
	}
	
	function gridListEventRowAddAfter(gridId, rowNum){
		if(gridId == "gridList"){
			var amenuid = gridList.getColData(gridId, rowNum, "AMENUID");
			if(amenuid == "root"){
				gridList.setRowReadOnly(gridId, rowNum, false, ["IMGPTH"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["IMGPTH"]);
			}
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId=="gridList" && colName=="AMNUID"){
			if(colValue != ""){
				if(gridList.getGridDataCount("gridList") > 0){
					
					var menuChk = gridList.getGridBox('gridList').duplicationCheck(rowNum, "MENUID", colValue);
					
					if(menuChk){
						commonUtil.msgBox("SYSTEM_M0071", colValue);
						gridList.setColValue("gridList", rowNum, "AMNUID", "");
					}
				}
			}
			
		}else if(gridId=="gridList" && colName=="MENUID"){
			if(colValue != ""){
				if(gridList.getGridDataCount("gridList") > 0){
					
					var menuChk = gridList.getGridBox('gridList').duplicationCheck(rowNum, colName, colValue);
					
					if(!menuChk){
						commonUtil.msgBox("SYSTEM_M0070", colValue);
						gridList.setColValue("gridList", rowNum, "MENUID", "");
					}else{
						gridList.setColValue("gridList", rowNum, "PROGID", colValue); 
						gridList.setColValue("gridList", rowNum, "LABLKY", colValue); 
						
						labelColValueChange(gridId, rowNum, colName, colValue);
						progColValueChange(gridId, rowNum, colName, colValue);
					}
				}
			}
		}else if(gridId=="gridList" && colName=="LABLKY"){
			labelColValueChange(gridId, rowNum, colName, colValue);
		}else if(gridId=="gridList" && colName=="PROGID"){
			progColValueChange(gridId, rowNum, colName, colValue);
		}
	}

 	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHMENLB"){
			var param = new DataMap();
			param.put("LABLGR", "MENU");
			param.put("LANGKY", "<%=langky%>");
			return param;
		}else if(searchCode == "SHPROGM"){
			var param = new DataMap();
			param.put("WAREKY", "<%= wareky%>");
			return param;
		}else if(searchCode == "SHICOLT"){
			var param = new DataMap();
			param.put("gridId","gridList");
			param.put("rowNum",rowNum);
			
			page.linkPopOpen("/wms/system/POP/UM01POP.page",param);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
		if(data != null && data != undefined){
			var popNm = data.get("popNm")==undefined?"":data.get("popNm");
			if(popNm == "UM01POP"){
				var gridId = data.get("gridId");
				var rowNum = data.get("rowNum");
				var returnData = data.get("data");
				var path = returnData.get("PATH");
				
				gridList.setColValue(gridId, rowNum, "IMGPTH", path);
			}
		}
	}
 	
 	function labelColValueChange(gridId, rowNum, colName, colValue){
 		if(gridId == "gridList"){
 			if(colValue != ""){
 		 		var lablgr = gridList.getColData("gridList", rowNum, "LABLGR");
 				var param = new DataMap();
 				param.put("LABLKY",colValue);
 				param.put("LABLGR",lablgr);
 				
 				var json = netUtil.sendData({
 					module : "System",
 					command : "UM01LABEL",
 					sendType : "map",
 					param : param
 				});
 				
 				if(json && json.data){
 					gridList.setColValue("gridList", rowNum, "LBLTXL", json.data["LBLTXL"]); 
 				}else{
 					gridList.setColValue("gridList", rowNum, "LABLKY", ""); 
 					gridList.setColValue("gridList", rowNum, "LBLTXL", ""); 
 				}
 	 		}else{
 				gridList.setColValue("gridList", rowNum, "LBLTXL", " ");	
 			}
 		}
 	}
	
 	function progColValueChange(gridId, rowNum, colName, colValue){
 		if(gridId == "gridList"){
 			if(colValue != ""){
 				var param = new DataMap();
 				param.put("PROGID",colValue);
 				
 				var json = netUtil.sendData({
 					module : "System",
 					command : "UM01PROG",
 					sendType : "map",
 					param : param
 				});
 				
 				if(json && json.data){
 					gridList.setColValue("gridList", rowNum, "PGPATH", json.data["PGPATH"]); 
 				}else{
 					gridList.setColValue("gridList", rowNum, "PROGID", "");
 					gridList.setColValue("gridList", rowNum, "PGPATH", "");
 				}
 			}else{
 				gridList.setColValue("gridList", rowNum, "PGPATH", " ");
 			}
 		}
 	}
 	
	function saveData(){
		var type = "";
		
		if(g_type == "C"){
			type = "data";
		}else{
			type = "select";
		}
		
		if( gridList.validationCheck("gridHeadList", type) ){
			if( gridList.validationCheck("gridHeadList", "all") ){
				var modifyCnt = gridList.getModifyRowCount('gridList');
				var head = gridList.getGridData("gridHeadList");
				var list = gridList.getGridData("gridList");
				var param = new DataMap();
					param.put("head",head);
					param.put("list",list);
				
				if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
		            return;
		        }
			   	   
				var json = netUtil.sendData({
					url : "/wms/system/json/saveUM01.data",
					param : param
				});
				
				
				if(json && json.data){
					commonUtil.msgBox("메뉴가 저장 되었습니다.");
					
					var param2 = new DataMap();
					
					var json2 = netUtil.sendData({
						module : "System",
						command : "MENUKEY",
						sendType : "list",
						param : param2
					});
					
					$("#CPMENUKY").find("[UIOption]").remove();
					
					var optionHtml = inputList.selectHtml(json2.data, false);
					$("#CPMENUKY").append(optionHtml)
					
					searchList();	
				}
			}
		}
	}
	
	function deleteData(){
		var list = gridList.getSelectData("gridHeadList");
		
		if(list.length < 1){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		var arraylist = [];
		var chk = true;
		var chk2 = true;
		for(var i=0;i<list.length;i++){
			var menuky = list[i].get("MENUKY");
			if(list[i].get("GRowState") == "C"){
				chk = false;
			}
			
			if(menuky == 'NPDA' || menuky == 'NWMS'){
				chk2 = false;
			}
			
			arraylist[i] = menuky;
		}
		 
		
		if(!chk){
			commonUtil.msgBox("저장된 메뉴키가 아닙니다.삭제할 수  없습니다.");
			return false;
		}
		
		if(!chk2){
			commonUtil.msgBox("기본값( NPDA , NWMS )은 삭제 할 수 없습니다.");
			return false;
		}
		
		var paramchk = new DataMap();
			paramchk.put("MENUKYLIST",arraylist);
		
		if(!commonUtil.msgConfirm("MASTER_M0020")){
            return;
        }
		
		var json2 = netUtil.sendData({
              module : "System",
              command : "CHK_MENUKY",
              sendType : "map",
              param : paramchk
		});
		
		
		if(parseInt(json2.data["CNT"]) > 0){
			commonUtil.msgBox("사용중인 메뉴가 포함되어 있 삭제하실 수 없습니다."); 
			return ;
		}
		
		var param = new DataMap();
			param.put("list",list);
			
		var json = netUtil.sendData({
			url : "/wms/system/json/deleteUM01.data",
			param : param
		});
		
		if(json && json.data){
			commonUtil.msgBox("VALID_M0003");
			
			var param2 = new DataMap();
			
			var json2 = netUtil.sendData({
				module : "System",
				command : "MENUKEY",
				sendType : "list",
				param : param2
			});
			
			$("#CPMENUKY").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json2.data, false);
			$("#CPMENUKY").append(optionHtml)
			
			searchList();	
		}
		
	}
 	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "SC.SKUCLS" || name == "SKUCLS"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");	
			}else if(name == "ABCANV" || name == "SC.ABCANV"){
				param.put("CODE", "ABCANV");
			}
			
			
			return param;
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			
			return param;
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Create CREATE BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Delete DELETE BTN_DELETE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:70px" id="searchArea">
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
										<col />
									</colgroup>
									<tbody>
										<tr>
										
											<th CL="STD_MENUKY"></th>
											<td>
												<input type="text" id="MENUKY" name="MENUKY" />
											</td>
											
											<th CL="STD_CPMENUKY"></th>
											<td>
												<select id="CPMENUKY" name="CPMENUKY" Combo="System,MENUKEY"  UISave="false" ComboCodeView=false style="width:160px">
												</select>
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
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"				GCol="rownum">1</td>
												<td GH="40"				GCol="rowCheck"></td>
												<td GH="100 STD_MENUKY"	GCol="text,MENUKY"  ></td>
												<td GH="200 STD_SHORTX"	GCol="input,SHORTX" validate="required" ></td>
												<td GH="100 STD_CREDAT"	GCol="text,CREDAT" GF="D" ></td>
												<td GH="100 STD_CRETIM"	GCol="text,CRETIM" GF="T" ></td>
												<td GH="100 STD_CREUSR"	GCol="text,CREUSR"  ></td>
												<td GH="100 STD_LMODAT"	GCol="text,LMODAT" GF="D" ></td>
												<td GH="100 STD_LMOTIM"	GCol="text,LMOTIM" GF="T" ></td>
												<td GH="100 STD_LMOUSR"	GCol="text,LMOUSR"  ></td>
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
									<!-- <button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="300 STD_MENUTX" GCol="tree"></td>
												<td GH="150 STD_MENUKY" GCol="text,MENUKY"		  validate="required" ></td>
												<td GH="150 STD_AMNUID" GCol="input,AMNUID"		 validate="required" ></td>
												<td GH="150 STD_MENUID" GCol="input,MENUID,SHMENLB" validate="required" ></td>
												<td GH="200 STD_ICOIMG" GCol="input,IMGPTH,SHICOLT" GF="S 500"></td>
												<td GH="150 STD_LBLTXL" GCol="text,LBLTXL"></td>
												<td GH="150 STD_PGPATH" GCol="text,PGPATH"></td>
												<td GH="150 STD_INDMUK" GCol="input,INDMUK"		 validate="required"></td>
												<td GH="150 STD_SORTSQ" GCol="input,SORTSQ"		 validate="required" ></td>
												<td GH="150 STD_PROGID" GCol="input,PROGID,SHPROGM"></td>
												<td GH="150 STD_MENULV" GCol="text,MENULV"></td>
												<td GH="150 STD_LABLGR" GCol="text,LABLGR"></td>
												<td GH="150 STD_LABLKY" GCol="input,LABLKY"		 validate="required" ></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="up"></button>
									<button type="button" GBtn="down"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="copy"></button>
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
			
		</div>
		<!-- //contentContainer -->
  </div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>