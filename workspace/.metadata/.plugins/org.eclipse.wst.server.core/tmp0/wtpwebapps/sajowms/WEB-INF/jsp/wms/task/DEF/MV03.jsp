<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsTask",
			command : "MV03",
			itemGrid : "gridItemList",
			itemSearch : true,
			excelRequestGridData : true,
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsTask",
			command : "MV03Sub",
            excelRequestGridData : true,
			autoCopyRowType : false
	    });
		
		init();
	});
    
	function init(){
		var $comboObj = $("#BOXTYP");
		inputList.setMultiComboValue($comboObj, ["01","02"]);
		
		$("#searchArea [name=TASOTY]").on("change",function(){
			var val = $(this).val();
			switch (val) {
			case "330":
				inputList.setMultiComboValue($comboObj, ["01","02"]);
				break;
			case "331":
				inputList.setMultiComboValue($comboObj, ["03"]);
				break;
			default:
				break;
			}
		});
		
		var val = day(0);
    	searchShpdgr(val);
		
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
	}
	
	function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
		$("#SHPDGR").val("");
	}
	
	function day(day){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 
		if( mm < 10 ) {
			mm = '0' + mm;
		}
		return String(yyyy) + String(mm) + String(dd);
	}
    
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if( btnName == "Reflect"){
			reflectGrid();
		}else if(btnName == "Save"){
			saveData();
		}
	}

	function linkPopCloseEvent(param){
    	 if(param != null){
    		 var locatg = param.get("LOCAKY");
    		 var rowNum  = gridList.getFocusRowNum("gridItemList");
             if(rowNum >=0){
            	 gridList.setColValue("gridItemList",rowNum,"LOCATG",locatg);
             }
    	 }
    }
	
	//헤더 조회 
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var tasoty = param.get("TASOTY");
			if(tasoty == "330"){
				setReadOnlyCols("gridItemList",false);
			}else if(tasoty == "331"){
				setReadOnlyCols("gridItemList",true);
			}
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
		
	} 
	
	function setReadOnlyCols(gridId,flag){
		var cols = ["PRCQTY","DUOMKY"];
		gridList.setReadOnly(gridId, flag, cols);
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
					gridList.setColValue("gridItemList", rowNum, "LOCATG", colValue==""?" ":colValue);
				}
				
				resetReflect()
			}
		}
	}

	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum, colName){
		
	}

	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}

	//저장
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select") && validGridData()){
			var head = gridList.getSelectData("gridHeadList");
			var list = gridList.getSelectData("gridItemList",true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",list);
			param.put("MOBILE","FALSE");
			
			netUtil.send({
				url : "/wms/task/json/SaveMV03.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data > 0){
				commonUtil.msgBox("MASTER_M0815",json.data);
				searchList();
			}
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
	
	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		
		if(gridId == "gridItemList"){
			param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridItemList");
		}else{
			param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridHeadList");
		}
		return param;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", wareky);
			return param;
		}else if(comboAtt == "WmsCommon,DOCTMCOMBO"){
			param.put("PROGID",configData.MENU_ID);
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var selectName = paramName[0].name;
			param.put("WARECODE","Y");
			param.put("WAREKY","<%=wareky%>");
			if(selectName == "SB.BOXTYP"){
				param.put("USARG1", "V");
				param.put("CODE", "BOXTYP");
			}else if(selectName == "SH.SHPDGR"){
				param.put("CODE", "SHPDGR");	
			}
			return param;
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if((searchCode == "SHLOCMA") && ($inputObj.name == undefined) && (rowNum != undefined)){
			var param = new DataMap();
			param.put("gridId","gridItemList");
			param.put("rowNum",rowNum);
			param.put("multyType",multyType);
			param.put("WAREKY",gridList.getColData("gridItemList",rowNum,"WAREKY"));
			param.put("WARENM",gridList.getColData("gridItemList",rowNum,"WARENM"));
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
	
	function validGridData(){
		var head = gridList.getSelectData("gridHeadList",true);
		var list = gridList.getSelectData("gridItemList",true);
		var headLen = head.length;
		var listLen = list.length;
		
		if(headLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}else{
			if(listLen > 0){
				var zoroList = list.filter(function(element,index,array){
					return element.get("QTTAOR") == 0
				});
				var zoroListLen = zoroList.length;
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
		}
		return true;
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
												<select Combo="WmsCommon,DOCTMCOMBO" name="TASOTY" style="width:160px"></select>
											</td>
					                        <th CL="STD_BOXTYPNM"></th>
											<td>
												<select id="BOXTYP" name="SB.BOXTYP" Combo="Common,COMCOMBO" ComboCodeView=false comboType="MS" style="width:160px"></select>
											</td>
										</tr>
										<tr>
											<th CL="STD_RQSHPD"></th>
											<td>
												<input type="text" name="RQSHPD" id="RQSHPD" UIFormat="C N" validate="required(STD_RQSHPD)"  style="width:160px"/>
											</td>
											<th CL="STD_DRVDGR"></th>
											<td>
												<select id="SHPDGR" name="SHPDGR" id="SHPDGR"   UISave="false" ComboCodeView=false style="width:160px" >
													<option value="" selected>전체</option>
												</select>
											</td>
											<th CL="STD_SBOXID"></th>
											<td>
												<input type="text" name="SB.SBOXID" UIInput="SR" UIformat="U 20" />
											</td>
										</tr>
										<tr>
											<th CL="STD_BOXLAB"></th>
											<td>
												<input type="text" name="SB.BOXLAB" UIInput="SR" UIformat="U 20" />
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="SK.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U 20" />
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
												<td GH="100 STD_WAREKY"   GCol="text,WARENM,center"></td>
												<td GH="100 STD_TASOTY"   GCol="text,TASTNM,center"></td>
												<td GH="100 STD_RQSHPD"   GCol="text,RQSHPD,center" GF="D"></td>
												<td GH="100 STD_DRVDGR"   GCol="text,SHPDGR,center"></td>
												<td GH="100 STD_BOXTYPNM" GCol="text,BOXTYPNM,center"></td>
												<td GH="120 STD_SBOXID"   GCol="text,SBOXID"></td>
												<td GH="120 STD_BOXLAB"   GCol="text,BOXLAB"></td>
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
								<select Combo="WmsTask,MV03_LOCACOMBO" ComboCodeView=false name="LOCAKY">
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
												<td GH="120 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="200 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_PRCQTY" GCol="input,PRCQTY" GF="N 20,3" validate="required"></td>
												<td GH="100 STD_UOMKEY" GCol="select,DUOMKY">
													<select CommonCombo="UOMKEY" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_MOVQTY" GCol="text,QTTAOR"  GF="N 20,3"></td>
												<td GH="100 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="S 8" validate="required"></td>
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