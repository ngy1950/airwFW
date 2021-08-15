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
	gridLayoutPadding = 340;
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
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap"  >
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">
				<div class="content_layout tabs content_left">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li><a href="#tab1-2"><span>상세</span></a></li>
						<li class="tab_btn">
							<div class="fl_r">
								<input type="button" CB="Search SEARCH BTN_SEARCH" />
								<input type="button" CB="Save SAVE BTN_SAVE" />
								<input type="button" CB="New ADD BTN_NEW" />
								<input type="button" CB="Delete DELETE BTN_DELETE" />
								<input type="button" CB="Reset RESET BTN_RESET" />
							</div>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="inner_search_wrap top_layout">
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
							<div class="scroll bottom_layout">
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
					<div class="table_box" id="tab1-2">
						<div class="btn_wrap">
							<div class="fl_l">
								<strong>Freight Information</strong>
							</div>
							<div class="fl_r">
								<input type="button" class="btn_red" value="저장" />
								<input type="button" class="btn_gray" value="취소" />
							</div>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" >
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li><a href="#tab1-2"><span>상세</span></a></li>
						<li class="tab_btn">
							<div class="fl_r">
								<input type="button" CB="Search SEARCH BTN_SEARCH" />
								<input type="button" CB="Save SAVE BTN_SAVE" />
								<input type="button" CB="New ADD BTN_NEW" />
								<input type="button" CB="Delete DELETE BTN_DELETE" />
								<input type="button" CB="Reset RESET BTN_RESET" />
							</div>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="inner_search_wrap top_layout">
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
							<div class="scroll bottom_layout">
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>