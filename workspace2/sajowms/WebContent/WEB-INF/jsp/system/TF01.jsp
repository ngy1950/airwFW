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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "TF01_HEAD",
			bindId : "detail"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function saveData(){
		var list = gridList.getModifyData("gridList", "A");
		var listLen = list.length;
		if(listLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("list",list);
		
		netUtil.send({
			url : "/system/json/saveTF01.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount == 0){
			resetDetailArea("init",null);
		}else{
			var rowNum = gridList.getFocusRowNum(gridId);
			var data = gridList.getRowData(gridId, rowNum);
			dataBind.dataBind(data, "detail");
			dataBind.dataNameBind(data, "detail");
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == "gridList"){
            var newData = new DataMap();
            newData.put("COMPKY","WDSCM");
            newData.put("TKFLKY","");
            newData.put("SHORTX","");
            newData.put("STEP01","000");
            newData.put("STEP02","000");
            newData.put("STEP03","000");
            newData.put("STEP04","ASC");
            
            var status = gridList.getRowState(gridId, rowNum);
            if(status == configData.GRID_ROW_STATE_ATT){
            	gridList.setRowReadOnly(gridId, rowNum, false, ["SHORTX"]);
            }
            
            return newData;
    	}
    }
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "Common,CMCDV_COMBO"){
			var cmcdky = "";
			
			var comboName = $comboObj[0].name;
			switch (comboName) {
			case "STEP01":
				cmcdky = "TAFGRP"
				break;
			case "STEP02":
				cmcdky = "TAFSRT"
				break;
			case "STEP03":
				cmcdky = "TAFSOT"
				break;
			case "STEP04":
				cmcdky = "SORTCD"
				break;	
			default:
				break;
			}	
			param.put("CMCDKY", cmcdky);
		}
		return param;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "SHORTX"){
				var data = new DataMap();
				data.put("SHORTX",colValue);
				
				dataBind.dataBind(data, "detail");
				dataBind.dataNameBind(data, "detail");
			}
		}
	}
	
	function resetDetailArea(type,data){
		var param = new DataMap();
		if(type == "init"){
			param.put("TKFLKY","");
			param.put("SHORTX","");
			param.put("STEP01","000");
			param.put("STEP02","000");
			param.put("STEP03","000");
			param.put("STEP04","ASC");
		}else{
			param.putAll(data);
		}
		
		dataBind.dataBind(param, "detail");
		dataBind.dataNameBind(param, "detail");
	}
	
	function fn_change_input(colName){
		var gridId = "gridList";
		var rowNum = gridList.getFocusRowNum(gridId);
		
		var $obj = $("#detail").find("[name="+colName+"]");
		var colValue = $obj.val();
		
		gridList.setColValue(gridId, rowNum, colName, colValue);
		
		gridList.setRowCheck(gridId, rowNum, true);
	}
	
	function gridListEventRowClick(gridId, rowNum, colName) {
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			resetDetailArea('data',rowData);
		}
	}

	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridList"){
			var rowState = gridList.getRowState(gridId, rowNum);
			if(rowState === configData.GRID_ROW_STATE_INSERT){
				gridList.setRowReadOnly(gridId, rowNum, false, ["SHORTX"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["SHORTX"]);
			}
		}
		return false;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_PASTKY"></dt>
						<dd>
							<input type="text" class="input" name="TKFLKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHORTX"></dt>
						<dd>
							<input type="text" class="input" name="SHORTX" UIInput="SR" />
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
				</ul>
	            <div id="tab1-1" class="inner_tablebox_wrap">
					<div class="table_box section content_left">
						<div class="table_list01">
							<div class="scroll" style="height: calc(100% - 55px);">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="100 STD_PASTKY" GCol="text,TKFLKY"></td>
											<td GH="300 STD_SHORTX" GCol="input,SHORTX"></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_lit tableUtil">
								<button type='button' GBtn="find"></button>
								<button type='button' GBtn="sortReset"></button>
								<button type='button' GBtn="add"></button>
								<button type='button' GBtn="delete"></button>
								<button type='button' GBtn="layout"></button>
								<button type='button' GBtn="excel"></button>
								<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
							</div>
						</div>
					</div>
	                <div class="table_box section content_right">
		                <div class="inner_search_wrap">
		                    <table class="detail_table" id="detail" style="min-width: 500px;">
		                        <colgroup>
		                            <col width="20%" />
		                            <col width="80%"/>
		                        </colgroup>
		                        <tbody>         
		                            <tr>
		                                <th CL="STD_PASTKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="TKFLKY" readonly="readonly" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
		                                </td>
		                            </tr>   
		                            <tr>    
		                                <th CL="STD_SHORTX"></th>
		                                <td>
		                                    <input type="text" class="input" name="SHORTX" onchange="fn_change_input('SHORTX');" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
		                                </td>
		                            </tr>
		                            <tr>
		                                <th CL="STD_TFSGRP"></th>
		                                <td>
		                                    <select name="STEP01" class="input" Combo="Common,CMCDV_COMBO" ComboCodeView="false" onchange="fn_change_input('STEP01');" style="width: 304px;"></select>
		                                </td>
		                            </tr>
		                            <tr>
		                                <th CL="STD_TFSUOM"></th>
		                                <td>
		                                    <select name="STEP02" class="input" Combo="Common,CMCDV_COMBO" ComboCodeView="false" onchange="fn_change_input('STEP02');" style="width: 304px;"></select>
		                                </td>
		                            </tr>
		                            <tr>
		                            	<th CL="STD_TFSSRT"></th>
		                                <td>
		                                    <select name="STEP03" class="input" Combo="Common,CMCDV_COMBO" ComboCodeView="false" onchange="fn_change_input('STEP03');"></select>
		                                    <select name="STEP04" class="input" Combo="Common,CMCDV_COMBO" ComboCodeView="false" onchange="fn_change_input('STEP04');"></select>
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
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