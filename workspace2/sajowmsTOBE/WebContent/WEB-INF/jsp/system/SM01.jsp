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
	var measky ="";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "System",
			command : "MEASH",
			pkcol : "WAREKY,MEASKY",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "System",
			command : "MEASI",
			pkcol : "UOMKEY"
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
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
			measky = rowData.get("MEASKY");
		}
	}

	function saveData(){
		if(gridList.validationCheck("gridList", "data") 
		&& gridList.validationCheck("gridItemList", "data")){
	        var list = gridList.getGridData("gridItemList");
	        
	        var inddfu = 0;
	        for(var i=0; i<list.length; i++){
	        	if(list[i].get("INDDFU") != "" && list[i].get("GRowState") != "D"){
	        		inddfu ++;
	        	}  
        	}
	        if(inddfu == 0){
				commonUtil.msgBox("기본 판매단위는 필수입니다.");
				return;
	        }
			
			
	        gridList.gridSave({
		    	id : "gridItemList",
		    	modifyType : "A",
		    });
	        
			searchList();
			
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	

    function gridListEventRowAddBefore(gridId, rowNum) {

    	if(gridId == 'gridItemList'){
	    	if(measky == ""){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return false;
	    	}
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            newData.put("WAREKY","<%=wareky%>");
            newData.put("OWNRKY","<%=compky%>");
            newData.put("MEASKY",measky);
            newData.put("WIDTHW",0);
            newData.put("HEIGHT",0);
            newData.put("CUBICM",0);
            newData.put("LENGTH",0);
            
            return newData;
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
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
							<input type="text" class="input" name="WAREKY"  value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" name="MEASKY"  UIFormat="U"/>
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
				<div class="content_layout tabs content_left">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
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
											<td GH="100 STD_WAREKY"   GCol="text,WAREKY"></td>
											<td GH="100 STD_SKUKEY"   GCol="text,MEASKY"></td>
											<td GH="150 STD_DESC01"   GCol="text,DESC01"></td>
											<td GH="100 STD_LMODAT"   GCol="text,LMODAT" GF="D"></td>
											<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM" GF="T"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
                                            <td GH="100 STD_SKUKEY" GCol="text,MEASKY"></td>
                                            <td GH="100 STD_UOMKEY" GCol="add,UOMKEY" GF="U"  validate="required"></td>
											<td GH="100 STD_QTPUOM" GCol="add,QTPUOM" validate="required gt(0)" GF="N 20"></td>
											<td GH="100 STD_DUOMKY" GCol="check,INDDFU,radio" ></td>						
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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