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
<style>
.gridIcon-center{text-align: center;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.n{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script type="text/javascript">
	var isReSearch = true;

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInventory",
			command : "IP01",
			itemGrid : "gridItemList",
			itemSearch : true,
			emptyMsgType : false
		});
			
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInventory",
			command : "IP01Sub",
			emptyMsgType : false
		});
		
		setBtn("init");
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			searchList("00");
		}if( btnName == "Search" ){
			searchList("01");
		}else if( btnName == "Save"){
			saveData();
		}else if( btnName == "Delete"){
			deleteData();
		}else if( btnName == "Invlist"){
			print();
		}
	}
	
	//조회
	function searchList(type){
		if( validate.check("searchArea") ){
			//setBtn("search");
			setBtn(type);
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var param = inputList.setRangeDataMultiParam("searchArea");
			param.put("TYPE",type);
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
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
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList"){
			if(dataLength == 0 && isReSearch){
				commonUtil.msgBox("SYSTEM_M0016");
				gridList.resetGrid("gridItemList");
			}else{
				if(dataLength == 0){
					gridList.resetGrid("gridItemList");
				}
				if(!isReSearch){
					isReSearch = true;
				}
			}
		}
		
		if(gridId == "gridItemList"){
			if(dataLength == 0 && isReSearch){
				var gridHeadLen = gridList.getGridDataCount("gridHeadList");
				if(gridHeadLen > 0){
					commonUtil.msgBox("SYSTEM_M0016");
				}
			}else{
				if(!isReSearch){
					isReSearch = true;
				}
			}
		}
	}
    
 	// 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeDataMultiParam("searchArea");
        param.putAll(rowData);
        
        return param;
    }
	
	function setBtn(type){
		switch (type) {
		case "init":
			uiList.setActive("Save", false);
			uiList.setActive("Delete", false);
			uiList.setActive("Invlist", false);
			break;
		case "00":
			gridList.setReadOnly("gridHeadList",false,["DOCTXT"]);
			uiList.setActive("Save", true);
			uiList.setActive("Delete", false);
			uiList.setActive("Invlist", false);
			break;
		case "01":
			gridList.setReadOnly("gridHeadList",true,["DOCTXT"]);
			
			uiList.setActive("Save", false);
			uiList.setActive("Delete", true);
			uiList.setActive("Invlist", true);
			break;
		default:
			break;
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			
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
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var head = gridList.getGridData("gridHeadList");
			var list = gridList.getSelectData("gridItemList",true);
			
			if(list.length == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/inventory/json/SaveIP01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("MASTER_M0815",json.data["CNT"]);
				
				var PHYIKY = json.data["PHYIKY"];
				var type = "01";
				
				var PHSCTY = $("#PHSCTY option:eq(0)").val();
				
				var data = new DataMap();
				data.put("PHSCTY",PHSCTY);
				
				dataBind.dataBind(data, "searchArea");
				dataBind.dataNameBind(data, "searchArea");
				
				inputList.resetMultiComboValue($("#AREAKY"));
				inputList.resetMultiComboValue($("#ASKL01"));
				inputList.resetRange("PHD.DOCDAT");
				inputList.resetRange("STK.ZONEKY");
				$("#DOCDAT").next().datepicker("setDate", "today");
				
				setBtn(type);
				
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				var param = inputList.setRangeDataMultiParam("searchArea");
				param.put("TYPE",type);
				param.put("PHYIKY",PHYIKY);
				
				gridList.gridList({
					id : "gridHeadList",
					param : param
				});
			}
		}
	}
	
	function deleteData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList");
			var list = gridList.getSelectData("gridItemList",true);
			
			if(head.length == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
				return;
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/inventory/json/DeleteIP01.data",
				param : param,
				successFunction : "succsessDeleteCallBack"
			});
		}
	}
	
	function succsessDeleteCallBack(json, status){
		if(json && json.data){
			isReSearch = false;
			
			var isReLoad = true;
			
			var succ = commonUtil.parseInt(json.data["SUCC"]);
			var fail = commonUtil.parseInt(json.data["FAIL"]);
			
			if(succ > 0 && fail == 0){
				commonUtil.msgBox("INV_M0002",succ);
			}else if(succ > 0 && fail > 0){
				commonUtil.msgBox("INV_M0003",succ);
			}else if(succ == 0 && fail > 0){
				commonUtil.msgBox("INV_M0004");
			}else{
				isReLoad = false;
				commonUtil.msgBox("INV_M0005");
			}
			
			if(isReLoad){
				var type = "01";
				
				var param = inputList.setRangeDataMultiParam("searchArea");
				param.put("TYPE",type);
				
				gridList.gridList({
					id : "gridHeadList",
					param : param
				});
			}
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "INDDCL"){
				if(colValue == "V"){
					var aprsts = gridList.getColData(gridId, rowNum, "APRSTS");
					if(aprsts == "END"){
						return "d";
					}else{
						return "y";	
					}
				}else if($.trim(colValue) == ""){
					return "n";
				}
			}
		}
	}
	
	function print(gbn){
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
			url : "/wms/inventory/json/printIP01.data",
			param : param
		});
		
		if ( json && json.data ){
				var	url = "<%=systype%>" + "/stock_ip01_list.ezg";
				var	width = 600;
				var	height = 800;
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
		<button CB="Create CREATE BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Delete DELETE BTN_DELETE"></button>
		<button CB="Invlist PRINT BTN_INVLIST"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="searchArea" style="height: 100px;">
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
										<th CL="STD_PHSCTY"></th>
										<td>
											<select Combo="WmsCommon,DOCTMCOMBO" id="PHSCTY" name="PHSCTY" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_TASDAT"></th>
										<td>
											<input type="text" id="DOCDAT" name="PHD.DOCDAT" UIInput="B" UIformat="C 0 0" UiRange="2" validate="required" MaxDiff="M1" />
										</td>
									</tr>
									<tr>
										<th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="STK.AREAKY" Combo="WmsTask,MV01_AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="STK.ZONEKY" UIInput="SR,SHZONMN" UIFormat="U 10"/>
										</td>
										<th CL="STD_SKUL01"></th>
										<td>
											<select id="ASKL01" name="SKM.ASKL01" CommonCombo="ASKL01" comboType="MS" ComboCodeView=false style="width:160px"></select>
										</td>
									</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
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
												<td GH="120 STD_PHYIKY"   GCol="text,PHYIKY,center"></td>
												<td GH="130 STD_PHSCTY"   GCol="text,PHSCNM"></td>
												<td GH="80 STD_COMPYN"    GCol="icon,INDDCL" GB="n"></td>
												<td GH="200 STD_DOCTXT"   GCol="input,DOCTXT" GF="S 300"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR,center"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CREUNM,center"></td>
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
						<li><a href="#tabs1-1"><span CL="STD_LIST"></span></a></li>
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
												<td GH="120 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="250 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="120 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_SKUL01" GCol="text,AL01NM,center"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="130 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
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