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
	    	module : "Task",
			command : "PT01_ITEM"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
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
				url : "/task/json/savePT01.data",
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
						<dt CL="STD_SEBELN"></dt>
						<dd>
							<input type="text" class="input" name="I.SEBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SZMBLNO"></dt>
						<dd>
							<input type="text" class="input" name="I.SZMBLNO" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DPTNKY1"></dt>
						<dd>
							<input type="text" class="input" name="I.DPTNKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RECVKY"></dt>
						<dd>
							<input type="text" class="input" name="I.RECVKY" UIInput="SR"/>
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="140 STD_LOTNUM"  GCol="text,LOTNUM"></td>
										<td GH="100 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="250 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="100 STD_QTYRCV"  GCol="text,QTTAOR" GF="N 20"></td>
										<td GH="100 STD_QTTAOR"  GCol="input,QTCOMP" GF="N 20" validate="required"></td>
										<td GH="140 STD_LOCASR"  GCol="input,LOCASR" validate="required"></td>
										<td GH="100 STD_UOMKEY"  GCol="text,SUOMKY"></td>
										<td GH="100 STD_LOTA01"  GCol="text,LT01NM"></td>
										<td GH="100 STD_LOTA02"  GCol="text,LOTA02"></td>
										<td GH="100 STD_LOTA03"  GCol="text,LOTA03"></td>	
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