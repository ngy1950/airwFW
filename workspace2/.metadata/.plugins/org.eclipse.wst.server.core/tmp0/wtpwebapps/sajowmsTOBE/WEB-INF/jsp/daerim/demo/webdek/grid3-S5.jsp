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
	var buttomAutoResize = false;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "System",
			command : "SYSLABEL"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "System",
			command : "SYSLABEL"
	    });
		
		gridList.setGrid({
	    	id : "gridList3",
	    	module : "System",
			command : "SYSLABEL"
	    });
		
	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			gridList.gridList({
		    	id : "gridList2",
		    	param : param
		    });
			
			gridList.gridList({
		    	id : "gridList3",
		    	param : param
		    });
		}
	}
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A"
		    });
		}
	}

	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
</script>
</head>
<body style="min-width:1394px;">
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
						<dt CL="Search"></dt>
						<dd>
							<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>??????</span></a></li>
					<li><a href="#tab1-2"><span>??????</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<!-- <li><button class="btn btn_smaller"><span>??????</span></button></li> -->
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
										<td GH="80" GCol="text,LABELGID"></td>
										<td GH="150" GCol="text,LABELID"></td>
										<td GH="80" GCol="select,LANGCODE">
											<select class="input" CommonCombo="LANGKY">
											</select>
										</td>
										<td GH="150" GCol="text,LABEL"></td>
										<td GH="80" GCol="text,LABELTYPE"></td>								
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="copy"></button>
						<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="excelUpload"></button>
						<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
				<div class="table_box" id="tab1-2">
					<div class="inner_search_wrap">
						<table class="detail_table">
							<colgroup>
								<col width="14%" />
								<col width="19%" />
								<col width="14%" />
								<col width="19%" />
								<col width="14%" />
								<col width="19%" />
							</colgroup>
							<tbody>			
								<tr>
									<th CL="Search"></th>
									<td>
										<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
									</td>
									<th CL="Calendar"></th>
									<td>
										<input type="text" class="input" name="Calendar" UIFormat="C Y" />
									</td>
									<th CL="SingleRange"></th>
									<td>
										<input type="text" class="input" name="SingleRange" UIInput="SR"/>
									</td>
								</tr>
								<tr>
									<th CL="SingleSearch"></th>
									<td>
										<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
									</td>
									<th CL="SingleCalendar"></th>
									<td>
										<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
									</td>
									<th CL="BetweenCalendar"></th>
									<td>
										<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
									</td>
								</tr>
								<tr>
									<th CL="RangeNumber"></th>
									<td>
										<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
									</td>
									<th CL="RangeSearch"></th>
									<td>
										<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
									</td>
									<th CL="RangeCalendar"></th>
									<td>
										<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
									</td>
								</tr>
								<tr>
									<th CL="Month"></th>
									<td>
										<input type="text" class="input" name="Month" UIFormat="MS" />
									</td>
									<th CL="Time"></th>
									<td>
										<input type="text" class="input" name="Time" UIFormat="THM" />
									</td>
									<th CL="CommonCombo"></th>
									<td>
										<select name="CommonCombo" class="input" CommonCombo="LANGKY">
										</select>
									</td>
								</tr>
								<tr>
									<th CL="Combo"></th>
									<td>
										<select name="Combo" class="input" Combo="Common,COMCODE">
										</select>
									</td>
									<th>input</th>
									<td>
										<input type="text" class="input" />
									</td>
									<th>MEMO</th>
									<td>
										<input type="text" class="input" style="width: 100%;"/>
									</td>
								</tr>
								<tr>
									<th>input</th>
									<td>
										<input type="text" class="input" />
									</td>
									<th>MEMO</th>
									<td colspan="3">
										<input type="text" class="input" style="width: 100%;"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="content-horizontal-wrap h-wrap-min bottom_layout" style="min-height: 860px;">
				<div class="content-vertical-wrap content_left">	
					<div class="content_layout tabs more_H_layout">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
						</ul>
						<div class="inner_search_wrap">
							<table class="detail_table">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>			
									<tr>
										<th CL="Search"></th>
										<td>
											<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
										</td>
										<th CL="Calendar"></th>
										<td>
											<input type="text" class="input" name="Calendar" UIFormat="C Y" />
										</td>
									</tr>	
									<tr>	
										<th CL="SingleRange"></th>
										<td>
											<input type="text" class="input" name="SingleRange" UIInput="SR"/>
										</td>
										<th CL="SingleSearch"></th>
										<td>
											<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
										</td>
									</tr>
									<tr>
										<th CL="SingleCalendar"></th>
										<td>
											<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
										</td>
										<th CL="BetweenCalendar"></th>
										<td>
											<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeNumber"></th>
										<td>
											<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
										</td>
										<th CL="RangeSearch"></th>
										<td>
											<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeCalendar"></th>
										<td>
											<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
										</td>
										<th CL="Month"></th>
										<td>
											<input type="text" class="input" name="Month" UIFormat="MS" />
										</td>
									</tr>
									<tr>
										<th CL="Time"></th>
										<td>
											<input type="text" class="input" name="Time" UIFormat="THM" />
										</td>
										<th CL="CommonCombo"></th>
										<td>
											<select name="CommonCombo" class="input" CommonCombo="LANGKY">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="Combo"></th>
										<td>
											<select name="Combo" class="input" Combo="Common,COMCODE">
											</select>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td>
											<input type="text" class="input" style="width: 100%;"/>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td colspan="3">
											<input type="text" class="input" style="width: 100%;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="content_layout tabs  more_H_layout">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
						</ul>
						<div class="inner_search_wrap">
							<table class="detail_table">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>			
									<tr>
										<th CL="Search"></th>
										<td>
											<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
										</td>
										<th CL="Calendar"></th>
										<td>
											<input type="text" class="input" name="Calendar" UIFormat="C Y" />
										</td>
									</tr>	
									<tr>	
										<th CL="SingleRange"></th>
										<td>
											<input type="text" class="input" name="SingleRange" UIInput="SR"/>
										</td>
										<th CL="SingleSearch"></th>
										<td>
											<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
										</td>
									</tr>
									<tr>
										<th CL="SingleCalendar"></th>
										<td>
											<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
										</td>
										<th CL="BetweenCalendar"></th>
										<td>
											<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeNumber"></th>
										<td>
											<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
										</td>
										<th CL="RangeSearch"></th>
										<td>
											<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeCalendar"></th>
										<td>
											<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
										</td>
										<th CL="Month"></th>
										<td>
											<input type="text" class="input" name="Month" UIFormat="MS" />
										</td>
									</tr>
									<tr>
										<th CL="Time"></th>
										<td>
											<input type="text" class="input" name="Time" UIFormat="THM" />
										</td>
										<th CL="CommonCombo"></th>
										<td>
											<select name="CommonCombo" class="input" CommonCombo="LANGKY">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="Combo"></th>
										<td>
											<select name="Combo" class="input" Combo="Common,COMCODE">
											</select>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td>
											<input type="text" class="input" style="width: 100%;"/>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td colspan="3">
											<input type="text" class="input" style="width: 100%;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="content_layout tabs more_H_layout" >
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
						</ul>
						<div class="inner_search_wrap">
							<table class="detail_table">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>			
									<tr>
										<th CL="Search"></th>
										<td>
											<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
										</td>
										<th CL="Calendar"></th>
										<td>
											<input type="text" class="input" name="Calendar" UIFormat="C Y" />
										</td>
									</tr>	
									<tr>	
										<th CL="SingleRange"></th>
										<td>
											<input type="text" class="input" name="SingleRange" UIInput="SR"/>
										</td>
										<th CL="SingleSearch"></th>
										<td>
											<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
										</td>
									</tr>
									<tr>
										<th CL="SingleCalendar"></th>
										<td>
											<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
										</td>
										<th CL="BetweenCalendar"></th>
										<td>
											<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeNumber"></th>
										<td>
											<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
										</td>
										<th CL="RangeSearch"></th>
										<td>
											<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeCalendar"></th>
										<td>
											<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
										</td>
										<th CL="Month"></th>
										<td>
											<input type="text" class="input" name="Month" UIFormat="MS" />
										</td>
									</tr>
									<tr>
										<th CL="Time"></th>
										<td>
											<input type="text" class="input" name="Time" UIFormat="THM" />
										</td>
										<th CL="CommonCombo"></th>
										<td>
											<select name="CommonCombo" class="input" CommonCombo="LANGKY">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="Combo"></th>
										<td>
											<select name="Combo" class="input" Combo="Common,COMCODE">
											</select>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td>
											<input type="text" class="input" style="width: 100%;"/>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td colspan="3">
											<input type="text" class="input" style="width: 100%;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="content_layout tabs more_H_layout">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
							<li><a href="#tab1-2"><span>??????</span></a></li>
							<li class="btn_zoom_wrap">
								<ul>
									<!-- <li><button class="btn btn_smaller"><span>??????</span></button></li> -->
									<li><button class="btn btn_bigger"><span>??????</span></button></li>
								</ul>
							</li>
						</ul>
						<div class="table_box section" id="tab1-1">
							<div class="table_list01">
								<div class="scroll">
									<table class="table_c">
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="40" GCol="rowCheck"></td>
												<td GH="80" GCol="text,LABELGID"></td>
												<td GH="150" GCol="text,LABELID"></td>
												<td GH="80" GCol="select,LANGCODE">
													<select class="input" CommonCombo="LANGKY">
													</select>
												</td>
												<td GH="150" GCol="text,LABEL"></td>
												<td GH="80" GCol="text,LABELTYPE"></td>								
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="btn_lit tableUtil">
								<button type='button' GBtn="find"></button>
								<button type='button' GBtn="sortReset"></button>
								<button type='button' GBtn="add"></button>
								<button type='button' GBtn="copy"></button>
								<button type='button' GBtn="delete"></button>
								<button type='button' GBtn="total"></button>
								<button type='button' GBtn="layout"></button>
								<button type='button' GBtn="excel"></button>
								<button type='button' GBtn="excelUpload"></button>
								<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
							</div>
						</div>
						<div class="table_box" id="tab1-2">
							<div class="inner_search_wrap">
								<table class="detail_table">
									<colgroup>
										<col width="14%" />
										<col width="19%" />
										<col width="14%" />
										<col width="19%" />
										<col width="14%" />
										<col width="19%" />
									</colgroup>
									<tbody>			
										<tr>
											<th CL="Search"></th>
											<td>
												<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
											</td>
											<th CL="Calendar"></th>
											<td>
												<input type="text" class="input" name="Calendar" UIFormat="C Y" />
											</td>
											<th CL="SingleRange"></th>
											<td>
												<input type="text" class="input" name="SingleRange" UIInput="SR"/>
											</td>
										</tr>
										<tr>
											<th CL="SingleSearch"></th>
											<td>
												<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
											</td>
											<th CL="SingleCalendar"></th>
											<td>
												<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
											</td>
											<th CL="BetweenCalendar"></th>
											<td>
												<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
											</td>
										</tr>
										<tr>
											<th CL="RangeNumber"></th>
											<td>
												<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
											</td>
											<th CL="RangeSearch"></th>
											<td>
												<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
											</td>
											<th CL="RangeCalendar"></th>
											<td>
												<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
											</td>
										</tr>
										<tr>
											<th CL="Month"></th>
											<td>
												<input type="text" class="input" name="Month" UIFormat="MS" />
											</td>
											<th CL="Time"></th>
											<td>
												<input type="text" class="input" name="Time" UIFormat="THM" />
											</td>
											<th CL="CommonCombo"></th>
											<td>
												<select name="CommonCombo" class="input" CommonCombo="LANGKY">
												</select>
											</td>
										</tr>
										<tr>
											<th CL="Combo"></th>
											<td>
												<select name="Combo" class="input" Combo="Common,COMCODE">
												</select>
											</td>
											<th>input</th>
											<td>
												<input type="text" class="input" />
											</td>
											<th>MEMO</th>
											<td>
												<input type="text" class="input" style="width: 100%;"/>
											</td>
										</tr>
										<tr>
											<th>input</th>
											<td>
												<input type="text" class="input" />
											</td>
											<th>MEMO</th>
											<td colspan="3">
												<input type="text" class="input" style="width: 100%;"/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				
				<div class="content-vertical-wrap content_right">
					<div class="content_layout tabs content_H_3set">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
						</ul>
						<div class="inner_search_wrap">
							<table class="detail_table">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>			
									<tr>
										<th CL="Search"></th>
										<td>
											<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
										</td>
										<th CL="Calendar"></th>
										<td>
											<input type="text" class="input" name="Calendar" UIFormat="C Y" />
										</td>
									</tr>	
									<tr>	
										<th CL="SingleRange"></th>
										<td>
											<input type="text" class="input" name="SingleRange" UIInput="SR"/>
										</td>
										<th CL="SingleSearch"></th>
										<td>
											<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
										</td>
									</tr>
									<tr>
										<th CL="SingleCalendar"></th>
										<td>
											<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
										</td>
										<th CL="BetweenCalendar"></th>
										<td>
											<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeNumber"></th>
										<td>
											<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
										</td>
										<th CL="RangeSearch"></th>
										<td>
											<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeCalendar"></th>
										<td>
											<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
										</td>
										<th CL="Month"></th>
										<td>
											<input type="text" class="input" name="Month" UIFormat="MS" />
										</td>
									</tr>
									<tr>
										<th CL="Time"></th>
										<td>
											<input type="text" class="input" name="Time" UIFormat="THM" />
										</td>
										<th CL="CommonCombo"></th>
										<td>
											<select name="CommonCombo" class="input" CommonCombo="LANGKY">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="Combo"></th>
										<td>
											<select name="Combo" class="input" Combo="Common,COMCODE">
											</select>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td>
											<input type="text" class="input" style="width: 100%;"/>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td colspan="3">
											<input type="text" class="input" style="width: 100%;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div class="content_layout tabs content_H_3set">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
						</ul>
						<div class="inner_search_wrap">
							<table class="detail_table">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tbody>			
									<tr>
										<th CL="Search"></th>
										<td>
											<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
										</td>
										<th CL="Calendar"></th>
										<td>
											<input type="text" class="input" name="Calendar" UIFormat="C Y" />
										</td>
									</tr>	
									<tr>	
										<th CL="SingleRange"></th>
										<td>
											<input type="text" class="input" name="SingleRange" UIInput="SR"/>
										</td>
										<th CL="SingleSearch"></th>
										<td>
											<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
										</td>
									</tr>
									<tr>
										<th CL="SingleCalendar"></th>
										<td>
											<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
										</td>
										<th CL="BetweenCalendar"></th>
										<td>
											<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeNumber"></th>
										<td>
											<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
										</td>
										<th CL="RangeSearch"></th>
										<td>
											<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
										</td>
									</tr>
									<tr>
										<th CL="RangeCalendar"></th>
										<td>
											<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
										</td>
										<th CL="Month"></th>
										<td>
											<input type="text" class="input" name="Month" UIFormat="MS" />
										</td>
									</tr>
									<tr>
										<th CL="Time"></th>
										<td>
											<input type="text" class="input" name="Time" UIFormat="THM" />
										</td>
										<th CL="CommonCombo"></th>
										<td>
											<select name="CommonCombo" class="input" CommonCombo="LANGKY">
											</select>
										</td>
									</tr>
									<tr>
										<th CL="Combo"></th>
										<td>
											<select name="Combo" class="input" Combo="Common,COMCODE">
											</select>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td>
											<input type="text" class="input" style="width: 100%;"/>
										</td>
										<th>input</th>
										<td>
											<input type="text" class="input" />
										</td>
									</tr>
									<tr>
										<th>MEMO</th>
										<td colspan="3">
											<input type="text" class="input" style="width: 100%;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div class="content_layout tabs content_H_3set">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>??????</span></a></li>
							<li><a href="#tab1-2"><span>??????</span></a></li>
							<li class="btn_zoom_wrap">
								<ul>
									<!-- <li><button class="btn btn_smaller"><span>??????</span></button></li> -->
									<li><button class="btn btn_bigger"><span>??????</span></button></li>
								</ul>
							</li>
						</ul>
						<div class="table_box section" id="tab1-1">
							<div class="table_list01">
								<div class="scroll">
									<table class="table_c">
										<tbody id="gridList3">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="40" GCol="rowCheck"></td>
												<td GH="80" GCol="text,LABELGID"></td>
												<td GH="150" GCol="text,LABELID"></td>
												<td GH="80" GCol="select,LANGCODE">
													<select class="input" CommonCombo="LANGKY">
													</select>
												</td>
												<td GH="150" GCol="text,LABEL"></td>
												<td GH="80" GCol="text,LABELTYPE"></td>								
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="btn_lit tableUtil">
								<button type='button' GBtn="find"></button>
								<button type='button' GBtn="sortReset"></button>
								<button type='button' GBtn="add"></button>
								<button type='button' GBtn="copy"></button>
								<button type='button' GBtn="delete"></button>
								<button type='button' GBtn="total"></button>
								<button type='button' GBtn="layout"></button>
								<button type='button' GBtn="excel"></button>
								<button type='button' GBtn="excelUpload"></button>
								<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
							</div>
						</div>
						<div class="table_box" id="tab1-2">
							<div class="inner_search_wrap">
								<table class="detail_table">
									<colgroup>
										<col width="14%" />
										<col width="19%" />
										<col width="14%" />
										<col width="19%" />
										<col width="14%" />
										<col width="19%" />
									</colgroup>
									<tbody>			
										<tr>
											<th CL="Search"></th>
											<td>
												<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
											</td>
											<th CL="Calendar"></th>
											<td>
												<input type="text" class="input" name="Calendar" UIFormat="C Y" />
											</td>
											<th CL="SingleRange"></th>
											<td>
												<input type="text" class="input" name="SingleRange" UIInput="SR"/>
											</td>
										</tr>
										<tr>
											<th CL="SingleSearch"></th>
											<td>
												<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA"/>
											</td>
											<th CL="SingleCalendar"></th>
											<td>
												<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N"/>
											</td>
											<th CL="BetweenCalendar"></th>
											<td>
												<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C W1"/>
											</td>
										</tr>
										<tr>
											<th CL="RangeNumber"></th>
											<td>
												<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20"/>
											</td>
											<th CL="RangeSearch"></th>
											<td>
												<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U"/>
											</td>
											<th CL="RangeCalendar"></th>
											<td>
												<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1"/>
											</td>
										</tr>
										<tr>
											<th CL="Month"></th>
											<td>
												<input type="text" class="input" name="Month" UIFormat="MS" />
											</td>
											<th CL="Time"></th>
											<td>
												<input type="text" class="input" name="Time" UIFormat="THM" />
											</td>
											<th CL="CommonCombo"></th>
											<td>
												<select name="CommonCombo" class="input" CommonCombo="LANGKY">
												</select>
											</td>
										</tr>
										<tr>
											<th CL="Combo"></th>
											<td>
												<select name="Combo" class="input" Combo="Common,COMCODE">
												</select>
											</td>
											<th>input</th>
											<td>
												<input type="text" class="input" />
											</td>
											<th>MEMO</th>
											<td>
												<input type="text" class="input" style="width: 100%;"/>
											</td>
										</tr>
										<tr>
											<th>input</th>
											<td>
												<input type="text" class="input" />
											</td>
											<th>MEMO</th>
											<td colspan="3">
												<input type="text" class="input" style="width: 100%;"/>
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
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>