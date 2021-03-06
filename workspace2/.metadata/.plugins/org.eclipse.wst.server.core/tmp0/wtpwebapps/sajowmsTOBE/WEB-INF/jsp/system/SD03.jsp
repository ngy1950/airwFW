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
	    	module : "Inventory",
			command : "SD03",
			pkcol : "COMPKY,WAREKY,ZONEKY"
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
		
		gridList.setReadOnly("gridList", true);
	}


	function commonBtnClick(btnName){
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
	<div class="content_inner contentH_inner">
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
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="CMCDKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="text" class="input" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" name="SKUKEY"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA01"></dt>
						<dd>
							<select class="input" name="LOTA01" Combo="Common,CMCDV_COMBO,LOTA01" ComboCodeView="false">
								<option value="" CL="STD_SELECT"></option>
							</select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA02"></dt>
						<dd>
							<input type="text" class="input" name="LOTA02"  UIFormat="C" UIInput="R" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03"  UIFormat="C" UIInput="R" />
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>??????</span></a></li>
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
											<td GH="100" GCol="text,SKUKEY"></td>
											<td GH="100" GCol="text,DESC01"></td>
											<td GH="100" GCol="text,TOTQTY" GF="N"></td>
											<td GH="100" GCol="text,UOMKEY"></td>
											<td GH="100" GCol="select,LOTA01">
												<select Combo="Common,CMCDV_COMBO,LOTA01" ComboCodeView="false">
													<option value="" CL="STD_SELECT"></option>
												</select>
											</td>
											<td GH="100" GCol="text,LOTA02" GF="D"></td>
											<td GH="100" GCol="text,LOTA03" GF="D"></td>
											<td GH="120" GCol="text,LOTNUM"></td>
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
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >??? ?????? : <span GInfoArea='true'>4</span></span>
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