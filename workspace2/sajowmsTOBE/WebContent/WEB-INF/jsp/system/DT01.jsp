<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DC01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "DOCTM",
			menuId : "DT01"
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
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridList"){
			var rowState = gridList.getRowState(gridId, rowNum);
			if(rowState === configData.GRID_ROW_STATE_INSERT){
				gridList.setRowReadOnly(gridId, rowNum, false, ["DOCCAT", "DOCUTY"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["DOCCAT", "DOCUTY"]);
			}
		}
		return false;
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("DEFLIN",0);
		return newData;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "DOCCAT" && $.trim(colValue) != ""){
				var param = gridList.getRowData(gridId, rowNum);
				var json = netUtil.sendData({
					module : "System",
					command : "DOCCM",
					param : param,
					sendType : "map"
				});
				if(json && json.data){
					var doccatnm = json.data["SHORTX"];
					gridList.setColValue(gridId, rowNum, "DOCCATNM", doccatnm);
				}else{
					if(json.data == null){
						var label = uiList.getLabel("STD_DOCCAT");
						commonUtil.msgBox("SYSTEM_DOCNODATA",[label, colValue]);
						gridList.setColValue(gridId, rowNum, colName, "");
					}
				}
			}else if(colName == "DOCUTY" && $.trim(colValue) != ""){
				var isDulication = false;
				
				var param = gridList.getRowData(gridId, rowNum);
				var json = netUtil.sendData({
					module : "System",
					command : "DOCUTY_DUPLICATION",
					param : param,
					sendType : "map"
				});
				if(json && json.data){
					var label = uiList.getLabel("STD_DOCUTY");
					if(json.data["CNT"] > 0){
						isDulication = true;
						commonUtil.msgBox("SYSTEM_ISUSEDATA",[label, colValue]);
					}else{
						var duplicationDoccatCheck = gridList.getGridBox(gridId).duplicationCheck(rowNum, colName, colValue);
						if(!duplicationDoccatCheck){
							isDulication = true;
							commonUtil.msgBox("SYSTEM_DUPDATA",[label, colValue]);
						}
					}
				}
				
				if(isDulication){
					gridList.setColValue(gridId, rowNum, colName, "");
				}
			}
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var json = gridList.gridSave({
		    	id : "gridList",
		    	modifyType : 'A'
		    });
			
			if(json && json.data){
				if(json.data > 0){
					searchList();
				}
			}
		}
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
						<dt CL="STD_DOCCAT"></dt>
						<dd class="multiCombo">
							<select name="DT.DOCCAT" class="input" Combo="Common,DOCCM_COMCOMBO" ComboType="MS"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHORTX"></dt>
						<dd>
							<input type="text" class="input" name="DT.SHORTX" UIInput="SR"/>
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
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="100" GCol="input,DOCCAT" validate="required"></td>
										<td GH="100" GCol="text,DOCCATNM"></td>
										<td GH="100" GCol="input,DOCUTY" validate="required"></td>
										<td GH="200" GCol="input,SHORTX" validate="required"></td>
										<td GH="140" GCol="input,NUMOBJ"></td>
										<!-- <td GH="140" GCol="input,ITNINC"></td> -->
										<!-- <td GH="140" GCol="input,INSINC"></td> -->
										<td GH="140" GCol="input,TRNHTY"></td>
										<!-- <td GH="140" GCol="input,INVNDL"></td> -->
										<!-- <td GH="140" GCol="input,SKUVND"></td> -->
										<td GH="140" GCol="input,SYSLOC"></td>
										<!-- <td GH="140" GCol="input,ERPLOC"></td> -->
										<!-- <td GH="140" GCol="input,SBWART"></td> -->
										<td GH="140" GCol="input,TKFLKY"></td>
										<td GH="140" GCol="input,ALSTKY"></td>
										<td GH="140" GCol="input,IFTBLN"></td>
										<td GH="140" GCol="input,DOCGRP"></td>
										<td GH="140" GCol="input,CDOCTY"></td>
										<td GH="140" GCol="text,CREDAT" GF="D"></td>
										<td GH="140" GCol="text,CRETIM" GF="T"></td>
										<td GH="140" GCol="text,CREUSR"></td>
										<td GH="130" GCol="text,LMODAT" GF="D"></td>
										<td GH="130" GCol="text,LMOTIM" GF="T"></td>
										<td GH="130" GCol="text,LMOUSR"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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