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
			command : "UM01",
			pkcol : "COMPKY,MENUID"
	    });
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}

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
		if(gridList.validationCheck("gridList", "data")){
	        
	        gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A",
		    });
	        
			searchList();
			
		}
	}

	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList"){
			var newData = new DataMap();
			newData.put("COMPID","<%=compky%>");
			return newData;
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
<!-- 					<input type="button" CB="Save SAVE BTN_SAVE" /> -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="CMCDKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MENUID"></dt>
						<dd>
							<input type="text" class="input" name="MENUID"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MENUNAME"></dt>
						<dd>
							<input type="text" class="input" name="MENUNAME"/>
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
					<li><a href="#tab1-1"><span>??????</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40"					GCol="rownum">1</td>
										<td GH="80"					GCol="add,MENUID" validate="required"></td>
										<td GH="150"				GCol="input,MENUNAME"></td>
<!-- 										<td GH="150"				GCol="input,URI"></td> -->
										<td GH="80 STD_CREUSR"		GCol="text,CREATEUSER"></td>
										<td GH="80 STD_CREDAT"		GCol="text,CREATEDATE" GF="D"></td>
										<td GH="80 STD_LMOUSR"		GCol="text,UPDATEUSER"></td>
										<td GH="80 STD_LMODAT"		GCol="text,UPDATEDATE" GF="D"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
<!-- 						<button type='button' GBtn="add"></button> -->
<!-- 						<button type='button' GBtn="copy"></button> -->
<!-- 						<button type='button' GBtn="delete"></button> -->
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
<!-- 						<button type='button' GBtn="excelUpload"></button> -->
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