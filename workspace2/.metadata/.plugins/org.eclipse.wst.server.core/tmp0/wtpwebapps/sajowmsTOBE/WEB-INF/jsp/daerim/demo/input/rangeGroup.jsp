<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Demo",
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
		}
	}

	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="SingleRange"></dt>
						<dd>
							<input type="text" class="input" name="SingleRange" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="SingleSearch"></dt>
						<dd>
							<input type="text" class="input" name="SingleSearch" UIInput="SR,SHAREMA" PGroup="G1"/>
						</dd>
					</dl>
					<dl>
						<dt CL="SingleCalendar"></dt>
						<dd>
							<input type="text" class="input" name="SingleCalendar" UIInput="SR" UIFormat="C N" PGroup="G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="BetweenCalendar"></dt>
						<dd>
							<input type="text" class="input" name="BetweenCalendar" UIInput="B" UIFormat="C M1" />
						</dd>
					</dl>
					<dl>
						<dt CL="RangeNumber"></dt>
						<dd>
							<input type="text" class="input" name="RangeNumber" UIInput="R" UIFormat="N 20" PGroup="G1"//>
						</dd>
					</dl>
					<dl>
						<dt CL="RangeSearch"></dt>
						<dd>
							<input type="text" class="input" name="RangeSearch" UIInput="R,SHAREMA" UIFormat="U" PGroup="G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="RangeCalendar"></dt>
						<dd>
							<input type="text" class="input" name="RangeCalendar" UIInput="R" UIFormat="C W1" PGroup="G1,G2"/>
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
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>