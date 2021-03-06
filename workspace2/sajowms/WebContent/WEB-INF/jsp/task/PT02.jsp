<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var searchType = 0;
	var g_taskky = "";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Task",
			command : "PT01_ITEM",
			firstRowFocusType : false,
			emptyMsgType : false
	    });
		
		gridList.setGrid({
	    	id : "gridTaskList",
	    	module : "Task",
			command : "PT01_TASK",
			firstRowFocusType : false,
			emptyMsgType : false
	    });
		
		gridList.setGrid({
	    	id : "gridCompList",
	    	module : "Task",
			command : "PT01_TASK",
			firstRowFocusType : false
	    });
		
		moveTab(0);
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			$(".tabs").tabs("option","active",0);
			moveTab(0);
			
			var dataCount = gridList.getGridDataCount("gridTaskList");
			if(dataCount > 0){
				if(!commonUtil.msgConfirm("TASK_M0400")){
					$(".tabs").tabs("option","active",1);
		            return;
		        }
			}
			
			searchType = 0;
			g_taskky = "";
			
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function searchTaskList(taskky){
		$(".tabs").tabs("option","active",1);
		moveTab(1);
		
		var param = inputList.setRangeDataParam("searchArea");
		param.put("TASKKY", taskky);
		param.put("TYPE", "T");
		
		gridList.gridList({
	    	id : "gridTaskList",
	    	param : param
	    });
	}
	
	function searchCompList(taskky){
		var param = inputList.setRangeDataParam("searchArea");
		param.put("TASKKY", taskky);
		param.put("TYPE", "C");
		
		gridList.gridList({
	    	id : "gridCompList",
	    	param : param
	    });
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList"){
			if(searchType == 0){
				g_taskky = "";
				if(dataCount == 0){
					commonUtil.msgBox("SYSTEM_DATAEMPTY");
				}else{
					gridList.resetGrid("gridTaskList");
					gridList.resetGrid("gridCompList");
				}
			}else if(searchType == 1){
				saveType = 0;
				searchTaskList(g_taskky);
			}
		}else if(gridId == "gridTaskList"){
			if(searchType == 2){
				searchCompList(g_taskky);
				if(dataCount == 0){
					$(".tabs").tabs("option","active",2);
					moveTab(2);
				}
			}else{
				if(searchType == 4){
					if(dataCount == 0){
						g_taskky = "";
						searchList();
					}else{
						searchType = 2;
					}
				}else{
					g_taskky = "";
				}
			}
		}
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "Common,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("IFTBLN", "PT");
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var zero = list.filter(function (e) {
			    return commonUtil.parseInt(e.get("QTTAOR")) <= 0;
			});
			
			if(zero.length > 0){
				var rowNum = zero[0].get(configData.GRID_ROW_NUM);
				commonUtil.msgBox("TASK_M0021",[0]);
				gridList.setColFocus("gridList", rowNum, "QTTAOR");
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/task/json/savePT02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				searchList();
				searchType = 1;
				g_taskky = json.data["TASKKY"];
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function saveCompData(){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridTaskList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var zero = list.filter(function (e) {
			    return commonUtil.parseInt(e.get("QTCOMP")) <= 0;
			});
			
			if(zero.length > 0){
				var rowNum = zero[0].get(configData.GRID_ROW_NUM);
				commonUtil.msgBox("TASK_M0021",[0]);
				gridList.setColFocus("gridList", rowNum, "QTCOMP");
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/task/json/savePT02Comp.data",
				param : param,
				successFunction : "successSaveCompCallBack"
			});
		}
	}
	
	function successSaveCompCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
				searchType = 2;
				g_taskky = json.data["TASKKY"];
				
				searchTaskList(g_taskky);
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function deleteData(){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridTaskList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			if(!commonUtil.msgConfirm("TASK_M0401")){ // ?????????????????????????
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/task/json/deletePT02.data",
				param : param,
				successFunction : "successDeleteCallBack"
			});
		}
	}
	
	function successDeleteCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("TASK_M0402");
				
				searchType = 4;
				g_taskky = json.data["TASKKY"];
				
				searchTaskList(g_taskky);
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function moveTab(idx){
		switch (idx) {
		case 0:
			uiList.setActive("Save",true);
			uiList.setActive("Comp",false);
			uiList.setActive("Delete",false);
			break;
        case 1:
        	uiList.setActive("Save",false);
    		uiList.setActive("Comp",true);
    		uiList.setActive("Delete",true);
			break;
	    case 2:
	    	uiList.setActive("Save",false);
			uiList.setActive("Comp",false);
			uiList.setActive("Delete",false);
			break;
		default:
			break;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Comp"){
			saveCompData();
		}else if(btnName == "Delete"){
			deleteData();
		}
	}
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Comp SAVE BTN_SAVE" />
					<input type="button" CB="Delete DELETE BTN_DELETE" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="hidden" name="WAREKY" value="<%=wareky%>"/>
							<input type="text" class="input" value="<%=warekynm%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASOTY"></dt>
						<dd>
							<select name="TASOTY" class="input" Combo="Common,DOCTM_COMCOMBO"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ARCPTD"></dt>
						<dd>
							<input type="text" class="input" name="H.ARCPTD" UIInput="R" UIFormat="C 0 0" PGroup="G1,G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RECVKY"></dt>
						<dd>
							<input type="text" class="input" name="I.RECVKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input type="text" class="input" name="I.DESC01" UIInput="SR"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li onclick="moveTab(0);"><a href="#tab1-1"><span>??????</span></a></li>
					<li onclick="moveTab(1);"><a href="#tab1-2"><span>??????</span></a></li>
					<li onclick="moveTab(2);"><a href="#tab1-3"><span>??????</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>??????</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="140 STD_LOTNUM"  GCol="text,LOTNUM"></td>
										<td GH="100 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="250 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="100 STD_QTYRCV"  GCol="text,QTYAOR" GF="N 20"></td>
										<td GH="100 STD_QTTAOR"  GCol="input,QTTAOR" GF="N 20"></td>
										<td GH="100 STD_UOMKEY"  GCol="text,SUOMKY"></td>	
										<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
										<td GH="100 STD_LOTA02"  GCol="text,LOTA02" GF="D"></td>
										<td GH="100 STD_LOTA03"  GCol="text,LOTA03" GF="D"></td>	
										<td GH="120 STD_SEBELN"  GCol="text,SEBELN"></td>
										<td GH="120 STD_SEBELP"  GCol="text,SEBELP"></td>							
										<td GH="120 STD_RECVKY"  GCol="text,RECVKY"></td>							
										<td GH="120 STD_RECVIT"  GCol="text,RECVIT"></td>							
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >??? ?????? : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridTaskList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="140 STD_LOTNUM"  GCol="text,LOTNUM"></td>
										<td GH="100 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="250 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="100 STD_QTTAOR"  GCol="text,QTTAOR" GF="N 20"></td>
										<td GH="100 STD_QTCOMP"  GCol="input,QTCOMP" GF="N 20"></td>
										<td GH="140 STD_LOCASR"  GCol="text,LOCASR"></td>	
										<td GH="140 STD_LOCATG"  GCol="input,LOCATG"></td>	
										<td GH="100 STD_UOMKEY"  GCol="text,UOMKEY"></td>	
										<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
										<td GH="100 STD_LOTA02"  GCol="text,LOTA02" GF="D"></td>
										<td GH="100 STD_LOTA03"  GCol="text,LOTA03" GF="D"></td>	
										<td GH="120 STD_SEBELN"  GCol="text,SEBELN"></td>
										<td GH="120 STD_SEBELP"  GCol="text,SEBELP"></td>							
										<td GH="120 STD_RECVKY"  GCol="text,RECVKY"></td>							
										<td GH="120 STD_RECVIT"  GCol="text,RECVIT"></td>							
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >??? ?????? : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridCompList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="140 STD_LOTNUM"  GCol="text,LOTNUM"></td>
										<td GH="100 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="250 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="100 STD_QTTAOR"  GCol="text,QTTAOR" GF="N 20"></td>
										<td GH="100 STD_QTCOMP"  GCol="text,QTCOMP" GF="N 20"></td>
										<td GH="140 STD_LOCASR"  GCol="text,LOCASR"></td>	
										<td GH="140 STD_LOCAAC"  GCol="text,LOCAAC"></td>	
										<td GH="100 STD_UOMKEY"  GCol="text,UOMKEY"></td>	
										<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
										<td GH="100 STD_LOTA02"  GCol="text,LOTA02" GF="D"></td>
										<td GH="100 STD_LOTA03"  GCol="text,LOTA03" GF="D"></td>	
										<td GH="120 STD_SEBELN"  GCol="text,SEBELN"></td>
										<td GH="120 STD_SEBELP"  GCol="text,SEBELP"></td>							
										<td GH="120 STD_RECVKY"  GCol="text,RECVKY"></td>							
										<td GH="120 STD_RECVIT"  GCol="text,RECVIT"></td>							
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >??? ?????? : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>