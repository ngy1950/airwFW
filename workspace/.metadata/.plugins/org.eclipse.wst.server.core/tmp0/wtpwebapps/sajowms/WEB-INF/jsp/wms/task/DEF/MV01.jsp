<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
midAreaHeightSet = "150px";

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsTask",
			command : "MV01"
		});
			
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsTask",
			command : "MV01Sub"
		});
		
		setBtn("search");
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Reflect"){
			reflectGrid();
		}else if( btnName == "Save"){
			saveData();
		}else if( btnName == "Movlist"){
			print();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			setBtn("search");
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			gridList.setReadOnly("gridHeadList",false);
			gridList.setReadOnly("gridItemList",false);
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
			
		}
	}
	
	function setBtn(type){
		switch (type) {
		case "save":
			$("#reflect").hide();
			$("#reflect").next().attr("style","top : 9px;");
			uiList.setActive("Save", false);
			uiList.setActive("Movlist", true);
			break;
		case "search":
			$("#reflect").show();
			$("#reflect").next().attr("style","top : 45px;");
			uiList.setActive("Save", true);
			uiList.setActive("Movlist", false);
			break;
		default:
			break;
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "PRCQTY" && $.trim(colValue) != ""){
				var qty = 1;
				var uomkey = gridList.getColData(gridId,rowNum,"DUOMKY");
				switch (uomkey) {
				case "CS": //BOX
					qty = gridList.getColData(gridId,rowNum,"BOXQTY");
					break;
				case "IP": //PACK
					qty = gridList.getColData(gridId,rowNum,"INPQTY");
					break;
				case "PL": //PAL
					qty = gridList.getColData(gridId,rowNum,"PALQTY");
					break;
				default:
					qty = 1;
					break;
				}
				
				var qttaor = colValue*qty;
				var qtsiwh = gridList.getColData(gridId,rowNum,"QTSIWH");
				if(qttaor > qtsiwh){
					commonUtil.msgBox("TASK_M1013");
					
					gridList.setColValue(gridId, rowNum, "PRCQTY", 0);
					gridList.setColValue(gridId, rowNum, "QTTAOR", 0);
					setTimeout(function(){
						gridList.setColFocus(gridId,rowNum,"PRCQTY");
					}, 100);
				}else{
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);	
				}
			}else if(colName == "DUOMKY"){
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0);
				gridList.setColValue(gridId, rowNum, "QTTAOR", 0);
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"PRCQTY");
				}, 100);
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", wareky);
			return param;
		}else if(comboAtt == "WmsTask,MV01_AREACOMBO"){
			param.put("WAREKY",wareky);
			return param;
		}else if(comboAtt == "WmsTask,MV01_LOCACOMBO"){
			param.put("WAREKY",wareky);
			return param;
		}else if(comboAtt == "WmsCommon,DOCTMCOMBO"){
			param.put("PROGID",configData.MENU_ID);
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("WARECODE","Y");
			param.put("WAREKY",wareky);
			param.put("CODE", "UOMKEY");
			return param;
			
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if((searchCode == "SHLOCMA") && ($inputObj.name == undefined) && (rowNum != undefined)){
			var param = new DataMap();
			param.put("gridId","gridItemList");
			param.put("rowNum",rowNum);
			param.put("multyType",multyType);
			param.put("WAREKY",gridList.getColData("gridHeadList",0,"WAREKY"));
			param.put("WARENM",gridList.getColData("gridHeadList",0,"WARENM"));
			param.put("SKUKEY",gridList.getColData("gridItemList",rowNum,"SKUKEY"));
			
			var option = "height=600,width=800,resizable=yes";
			page.linkPopOpen("/wms/task/POP/MV01_LOCMA_POP.page",param,option);
			
			return false;
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param,true);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
        if(data != null && data != undefined){
        	var popNm = data.get("popNm")==undefined?"":data.get("popNm");
        	if(popNm == "MV01_LOCMA"){
        		var gridId = data.get("gridId");
            	var rowNum = data.get("rowNum");
            	var paramData = data.get("data");
            	
            	gridList.setColValue(gridId,rowNum,"LOCATG",paramData.get("LOCAKY"));
            	gridList.setRowCheck(gridId,rowNum,true);
        	}else{
        		var searchCode = data.get("searchCode");
        		if(searchCode == "SHSKUMA"){
        			skumaPopup.bindPopupData(data);
        		}
        	}
        }
    }
	
	function reflectGrid(){
		var data = dataBind.paramData("reflect");
		var locaky = data.get("LOCAKY");
		if(locaky == undefined || locaky == null || $.trim(locaky) == ""){
			commonUtil.msgBox("MASTER_M4011");
			return;
		}
		
		var list = gridList.getSelectData("gridItemList",true);
		var len  = list.length;
		if(len == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}	
		
		var isSelectLoc = false;
		var lota06 = "";
		switch (locaky) {
		case "PKLOC00_SELECT":
			lota06 = "00";
			isSelectLoc = true;
			break;
		case "PKLOC10_SELECT":
			lota06 = "10";
			isSelectLoc = true;
			break;
		default:
			isSelectLoc = false; 
			break;
		}
		
		if(isSelectLoc){
			var param = new DataMap();
			param.put("lota06",lota06);
			param.put("list",list);
			netUtil.send({
				url : "/wms/task/json/selectMV01Location.data",
				param : param,
				successFunction : "setLocationCallBack"
			});
		}else{
			$("#contentLoading").show();
			setTimeout(function(){
				for(var i = 0; i < len; i++){
					var row = list[i];
					var rowNum = row.get(configData.GRID_ROW_NUM);
					gridList.setColValue("gridItemList", rowNum, "LOCATG", locaky);
				}
				
				$("#contentLoading").hide();
				
				resetReflect();
			}, 100);
		}
	}
	
	function resetReflect(){
		$("#reflect [name=LOCAKY]").val("");
	}
	
	function setLocationCallBack(json, status){
		if(json && json.data){
			var data = json.data;
			var len  = data.length;
			if(len > 0){
				for(var i in data){
					var row = data[i];
					var rowNum   = row["NUM"]
					var colValue = $.trim(row["LOCAKY"]);
					gridList.setColValue("gridItemList", rowNum, "LOCATG", colValue==""?"":colValue);
				}
				
				resetReflect()
			}
		}
	}
	
	function validGridData(){
		var list = gridList.getSelectData("gridItemList",true);
		var listLen = list.length;
		var dupList = list.filter(function(element,index,array){
			return element.get("LOCASR") == element.get("LOCATG")
		});
		var zoroList = list.filter(function(element,index,array){
			return element.get("QTTAOR") == 0
		});
		var dupListLen = dupList.length;
		var zoroListLen = zoroList.length;
		if(listLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return false;
		} else if(dupListLen > 0){
			//commonUtil.msgBox("TASK_M0077");
			if(dupListLen == listLen){
				commonUtil.msgBox("TASK_M0092");
				return false;
			}else{
				return true;
			}
		}else if(zoroListLen > 0){
			commonUtil.msgBox("INV_M1011");
			
			var data = zoroList[0];
			var rowNum = data.get(configData.GRID_ROW_NUM);
			setTimeout(function(){
				gridList.setColFocus("gridItemList",rowNum,"PRCQTY");
			}, 100);
			
			return false;
		}
		
		return true;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select") && validGridData()){
			var head = gridList.getGridData("gridHeadList")[0];
			head.put("MOBILE","FALSE");
			
			var list = gridList.getSelectData("gridItemList",true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/task/json/SaveMV01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				if(json.data["FAIL"] > 0){
					commonUtil.msgBox("TASK_M0091",[json.data["CNT"],json.data["FAIL"]]);
				}else{
					commonUtil.msgBox("MASTER_M0815",json.data["CNT"]);
				}
				
				setBtn("save");
				
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				gridList.setReadOnly("gridHeadList",true);
				gridList.setReadOnly("gridItemList",true);
				
				var param = new DataMap();
				param.put("TASKKY",json.data["TASKKY"]);
				
				netUtil.send({
					module : "WmsTask",
					command : "MV01RH",
					param : param,
					bindId : "gridHeadList",
					sendType : "list",
		            bindType : "grid"
				});
				
				netUtil.send({
					module : "WmsTask",
					command : "MV01RI",
					param : param,
					bindId : "gridItemList",
					sendType : "list",
		            bindType : "grid"
					
				});
			}else{
				//commonUtil.msgBox("MASTER_S0001");
				commonUtil.msgBox("TASK_M0092");
			}
		}
	}
	
	function print(){
 		var head = gridList.getGridData("gridHeadList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/task/json/printMV01.data",
			param : param
		});
		
		if ( json && json.data ){
			var	url = "<%=systype%>" + "/mv01_list.ezg";
			var	width = 610;
			var	height = 810;
				
			var where = "AND PL.PRTSEQ =" + json.data;
			//var langKy = "KR";
			
			var langKy = "KR";
			var map = new DataMap();
			WriteEZgenElement(url , where , "" , langKy, map , width , height );
				
				
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Movlist PRINT BTN_MOVLIST"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" style="height:130px" id="searchArea">
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
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_TASOTY"></th>
										<td>
											<select Combo="WmsCommon,DOCTMCOMBO" name="TASOTY" style="width:160px" disabled="disabled" ></select>
										</td>
				                        <th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="STK.AREAKY" Combo="WmsTask,MV01_AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="STK.ZONEKY" UIInput="SR,SHZONMN" UIFormat="U 10"/>
										</td>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="STK.LOCAKY" UIInput="SR,SHLOCMN" UIformat="U 13"/>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="STK.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U 20" />
										</td>
									</tr>
									<tr>
										<th CL="STD_LOTL01"></th>
										<td>
											<select name="LOTL01" style="width: 160px;">
												<option value="" CL="STD_ALL"></option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_LIST'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM" GCol="text,WARENM,center"></td>
												<td GH="100 STD_TASKKY"   GCol="text,TASKKY"></td>
												<td GH="100 STD_TASOTY"   GCol="text,DOCTNM"></td>
												<td GH="100 STD_STATIT"   GCol="text,STATNM"></td>
												<td GH="100 STD_DOCDAT"   GCol="text,DOCDAT"  GF="C" validate="required" ></td>
												<td GH="200 STD_DOCTXT"   GCol="input,DOCTXT" GF="S 25"></td>
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
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2"  id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL="STD_DETAIL"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="reflect" id="reflect">
								<span CL="STD_LOCAKY">로케이션</span>
								<select Combo="WmsTask,MV01_LOCACOMBO" ComboCodeView=false name="LOCAKY">
									<option value="" CL="STD_SELECT"></option>
								</select>
								<button CB="Reflect REFLECT BTN_REFLECT"></button>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="40"             GCol="rowCheck"></td>
												<td GH="100 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCASR"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_QTSIWH" GCol="text,QTSIWH"  GF="N 20,3"></td>
												<td GH="100 STD_PRCQTY" GCol="input,PRCQTY" GF="N 20,3" validate="required"></td>
												<td GH="100 STD_UOMKEY" GCol="select,DUOMKY">
													<select CommonCombo="UOMKEY" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_MOVQTY" GCol="text,QTTAOR"  GF="N 20,3"></td>
												<td GH="100 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="S 8" validate="required"></td>
												<td GH="100 STD_LOTL01" GCol="text,LOTL01,center"></td>
												<td GH="100 STD_LOTA08" GCol="text,LOTA08,center" GF="D"></td>
												<td GH="100 STD_LOTA09" GCol="text,LOTA09,center" GF="D"></td>
												<td GH="100 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
												<td GH="100 STD_BOXQNM" GCol="text,BOXQTY" GF="N 20,3"></td>
												<td GH="100 STD_INPQNM" GCol="text,INPQTY" GF="N 20,3"></td>
												<td GH="100 STD_PALQNM" GCol="text,PALQTY" GF="N 20,3"></td>
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