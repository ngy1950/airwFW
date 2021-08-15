<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YL01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "JLBLM",
			pkcol : "LANGKY,LABLGR,LABLKY"
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
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGKY","<%=langky%>");
		return newData;
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
	
	function reloadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			reloadLabel();
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
					<input type="button" CB="Reload RESET BTN_REFLBL" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_LABLGR"></dt>
						<dd>
							<input type="text" class="input" name="LABLGR" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LABLKY"></dt>
						<dd>
							<input type="text" class="input" name="LABLKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LBLTXS"></dt>
						<dd>
							<input type="text" class="input" name="LBLTXS" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LBLTXM"></dt>
						<dd>
							<input type="text" class="input" name="LBLTXM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LBLTXL"></dt>
						<dd>
							<input type="text" class="input" name="LBLTXL" UIInput="SR"/>
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
										<td GH="140" GCol="input,LANGKY"></td>
										<td GH="140" GCol="input,LABLGR"></td>
										<td GH="140" GCol="input,LABLKY"></td>
										<td GH="140" GCol="input,LBLTXS"></td>
										<td GH="140" GCol="input,LBLTXM"></td>
										<td GH="140" GCol="input,LBLTXL"></td>
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