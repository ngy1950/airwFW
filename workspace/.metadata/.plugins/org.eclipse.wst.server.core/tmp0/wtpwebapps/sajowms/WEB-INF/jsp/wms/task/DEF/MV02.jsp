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
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsTask",
			command : "MV02",
			itemGrid : "gridItemList",
			itemSearch : true,
			excelRequestGridData : true,
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsTask",
			command : "MV02Sub",
            excelRequestGridData : true,
			autoCopyRowType : false
	    });
		
		init();
	});
	
	function init(){
		var param = new DataMap();
		param.put("TASOTY","321");
		
		dataBind.dataBind(param,"searchArea");
		dataBind.dataNameBind(param,"searchArea");
		
		setBtn(param.get("TASOTY"));
		
		$("[name=TASOTY]").on("change",function(){
			var data = new DataMap();
			
			var key = $(this).val();
			switch (key) {
			case "320":
				data.put("STATIT","FPC");
				break;
			case "321":
				data.put("STATIT","NEW");
				break;
			default:
				break;
			}
			
			dataBind.dataBind(data,"searchArea");
			dataBind.dataNameBind(data,"searchArea");
		});
	}
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Save"){
			saveData();
		}else if( btnName == "Delete"){
			deleteData();
		}else if( btnName == "Movlist"){
			print();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			
			setBtn(param.get("TASOTY"));
			if(param.get("STATIT") == "FPC"){
				setBtn("320");
			}
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
    function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
        if(gridId == "gridHeadList"){
            searchSubList(rowNum);
        }
    }
	
    function searchSubList(rowNum){
    	var param = getItemSearchParam(rowNum);
		gridList.gridList({
	    	id : "gridItemList",
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
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	function setBtn(type){
		var readOlnyCols = ["PRCQTY","DUOMKY"];
		switch (type) {
		case "320":
			uiList.setActive("Save", false);
			uiList.setActive("Delete", false);
			gridList.setReadOnly("gridItemList",true,readOlnyCols);
			break;
		case "321":
			uiList.setActive("Save", true);
			uiList.setActive("Delete", true);
			gridList.setReadOnly("gridItemList",false,readOlnyCols);
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
		}else if(comboAtt == "WmsCommon,DOCTMCOMBO"){
			param.put("PROGID",configData.MENU_ID);
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("USARG1", "V");
			param.put("CODE", "MVSTATDO");
			return param;
			
		}
	}
	
	function validGridData(){
		var haed = gridList.getSelectData("gridHeadList",true);
		var haedLen = haed.length;
		
		var list = gridList.getSelectData("gridItemList",true);
		var listLen = list.length;
		
		var zoroList = list.filter(function(element,index,array){
			return element.get("QTTAOR") == 0
		});
		
		var zoroListLen = zoroList.length;
		
		if(haedLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}
		
		if(listLen > 0){
			if(zoroListLen > 0){
				commonUtil.msgBox("INV_M1011");
				
				var data = zoroList[0];
				var rowNum = data.get(configData.GRID_ROW_NUM);
				setTimeout(function(){
					gridList.setColFocus("gridItemList",rowNum,"PRCQTY");
				}, 100);
				
				return false;
			}
		}
		
		return true;
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm("TASK_M0078")){
            return;
        }
		
		if(validGridData()){
			var head = gridList.getSelectData("gridHeadList",true);
			var list = gridList.getSelectData("gridItemList",true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			param.put("MOBILE","FALSE");
			
			netUtil.send({
				url : "/wms/task/json/SaveMV02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data > 0){
				commonUtil.msgBox("TASK_M0080",json.data);
				searchList();
			}else{
				commonUtil.msgBox("MASTER_S0001");
			}
		}
	}
	
	function deleteData(){
		if(!commonUtil.msgConfirm("TASK_M0079")){
            return;
        }
		
		var head = gridList.getSelectData("gridHeadList",true);
		var list = gridList.getSelectData("gridItemList",true);
		
		if(head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("head",head);
		param.put("list",list);
		
		netUtil.send({
			url : "/wms/task/json/DeleteMV02.data",
			param : param,
			successFunction : "succsessDeleteCallBack"
		});
	}
	
	function succsessDeleteCallBack(json, status){
		if(json && json.data){
			if(json.data > 0){
				commonUtil.msgBox("TASK_M0081",json.data);
				searchList();
			}else{
				commonUtil.msgBox("MASTER_S0001");
			}
		}
	}
	
	function print(){
 		var head = gridList.getSelectData("gridHeadList");
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
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param,true);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
		var searchCode = data.get("searchCode");
		if(searchCode == "SHSKUMA"){
			skumaPopup.bindPopupData(data);
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_MOVCOMP"></button>
		<button CB="Delete DELETE BTN_CANCEL"></button>
		<button CB="Movlist PRINT BTN_MOVLIST"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" style="height:160px" id="searchArea">
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
										<col width="450" />
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
											<select Combo="WmsCommon,DOCTMCOMBO" name="TASOTY" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_STATIT"></th>
										<td>
											<select Combo="Common,COMCOMBO" name="STATIT" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									<tr>
										<th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="TI.AREAKY" Combo="WmsTask,MV01_AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="TI.ZONEKY" UIInput="SR,SHZONMN" UIFormat="U 10"/>
										</td>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="TI.LOCASR" UIInput="SR,SHLOCMN" UIformat="U 50"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="TI.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U 20" />
										</td>
										<th CL="STD_TASKKY"></th>
										<td>
											<input type="text" name="TH.TASKKY" UIInput="SR" UIformat="U 10" />
										</td>
										<th CL="STD_DOCDAT"></th>
										<td>
											<input type="text" name="TH.DOCDAT" UIInput="B" UIformat="C N" validate="required" MaxDiff="M1" />
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
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_WAREKYNM" GCol="text,WARENM,center"></td>
												<td GH="100 STD_TASKKY"   GCol="text,TASKKY"></td>
												<td GH="100 STD_TASOTY"   GCol="text,DOCTNM"></td>
												<td GH="100 STD_STATIT"   GCol="text,STATDONM"></td>
												<td GH="100 STD_DOCDAT"   GCol="text,DOCDAT,center" GF="D"></td>
												<td GH="200 STD_DOCTXT"   GCol="text,DOCTXT"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,NMLAST"></td>
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
							<div class="table type2">
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
												<td GH="100 STD_LOCATG" GCol="text,LOCATG"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_ORDQTY" GCol="text,ORDQTY"  GF="N 20,3"></td>
												<td GH="100 STD_PRCQTY" GCol="input,PRCQTY" GF="N 20,3" validate="required"></td>
												<td GH="100 STD_UOMKEY" GCol="select,DUOMKY">
													<select CommonCombo="UOMKEY" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_MOVQTY" GCol="text,QTTAOR" GF="N 20,3"></td>
												<td GH="100 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,3"></td>
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