<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UI01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "AC01"
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
				gridList.setRowReadOnly(gridId, rowNum, false, ["COMPNM", "BIZNUM", "MNGRNM", "TELNUM"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["COMPNM", "BIZNUM", "MNGRNM", "TELNUM"]);
			}
		}
		return false;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getModifyData("gridList", "A");
			if(list.length == 0){
				commonUtil.msgBox("MASTER_M0545");
				return;
			}
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/system/json/saveAC01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
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
						<dt CL="STD_APLCOD"></dt>
						<dd>
							<input type="text" class="input" name="APLCOD" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CONAME"></dt>
						<dd>
							<input type="text" class="input" name="BIZNUM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TAXCD1"></dt>
						<dd>
							<input type="text" class="input" name="COMPNM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MNGRNM"></dt>
						<dd>
							<input type="text" class="input" name="MNGRNM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TELNUM"></dt>
						<dd>
							<input type="text" class="input" name="TELNUM" UIInput="SR"/>
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
										<td GH="40"  GCol="rownum">1</td>
										<td GH="245 STD_APLCOD" GCol="text,APLCOD"></td>
										<td GH="150 STD_CONAME" GCol="input,COMPNM" validate="required" GF="S 300"></td>
										<td GH="140 STD_TAXCD1" GCol="input,BIZNUM" validate="required" GF="S 30"></td>
										<td GH="140 STD_MNGRNM" GCol="input,MNGRNM" validate="required" GF="S 20"></td>
										<td GH="100 STD_TELNUM" GCol="input,TELNUM" validate="required" GF="S 15"></td>
										<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D"></td>
										<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T"></td>
										<td GH="100 STD_CREUSR" GCol="text,CREUSR"></td>
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