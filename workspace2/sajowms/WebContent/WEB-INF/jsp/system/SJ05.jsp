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
			command : "SJ05"
	    });
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "SJ05SUB"
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
		    	id : "gridItemList",
		    	param : param
		    });

		}
	}

    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType) {
		if(gridId == "gridItemList"){
        	if(dataLength > 0) {
    			var param = inputList.setRangeParam("searchArea");
    			gridList.gridList({
    		    	id : "gridList",
    		    	param : param
    		    });
        	}
        }
    }

	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var list = gridList.getSelectData("gridItemList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("head",gridList.getRowData("gridList", 0));
			param.put("list",list);
			
			netUtil.send({
				url : "/inventory/json/saveSJ05.data",
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
	
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
    	if(gridId == "gridItemList"){
    		if(colName == "QTADJU"){
    			var qtsiwh = gridList.getColData(gridId, rowNum, "QTSIWH");
    			var qty = parseInt(colValue) + parseInt(qtsiwh);
    			if(qty < 0){
    				commonUtil.msgBox("IN_M0149");
    				gridList.setColValue(gridId, rowNum, colName, 0);
    				return;
    			}else{
    				gridList.setColValue(gridId, rowNum, "AQTADJU", qty);
    			}
    		}
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
							<input type="text" class="input" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STOKKY"></dt>
						<dd>
							<input type="text" class="input" name="STOKKY"  UIFormat="U"/>
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
				<div class="content_layout tabs right-search" style="height: 200px;">
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
											<td GH="40"  GCol="rownum">1</td>
											<td GH="100" GCol="text,SADJKY"></td>
<!-- 											<td GH="100" GCol="text,WAREKY"></td> -->
<!-- 											<td GH="100" GCol="text,DOCCAT"></td> -->
<!-- 											<td GH="100" GCol="text,DOCCATNM"></td> -->
											<td GH="120" GCol="text,ADJUTY"></td>
											<td GH="100" GCol="text,ADJSTX"></td>
											<td GH="200" GCol="input,DOCTXT" GF="S 1000"></td>
											<td GH="100 STD_DOCDAT4" GCol="text,DOCDAT" GF="C"></td>
<!-- 											<td GH="100" GCol="text,CREDAT" GF="D"></td> -->
<!-- 											<td GH="100" GCol="text,CRETIM" GF="T"></td> -->
											<td GH="100" GCol="text,CREUSR"></td>
<!-- 											<td GH="100" GCol="text,LMODAT" GF="D"></td> -->
<!-- 											<td GH="100" GCol="text,LMOTIM" GF="T"></td> -->
<!-- 											<td GH="100" GCol="text,LMOUSR"></td> -->
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
				<div class="content_layout tabs"  style="height: calc(100% - 220px);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>상세</span></a></li>
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
									<tbody id=gridItemList>
										<tr CGRow="true">
											<td GH="40"  GCol="rownum">1</td>
											<td GH="40"  GCol="rowCheck"></td>
											<td GH="100" GCol="text,STOKKY"></td>
											<td GH="100" GCol="text,SKUKEY"></td>
											<td GH="100" GCol="text,DESC01"></td>
											<td GH="100" GCol="text,AREAKY"></td>
											<td GH="100" GCol="text,ZONEKY"></td>
											<td GH="100" GCol="text,LOCAKY"></td>
											<td GH="100" GCol="text,QTSIWH" GF="N"></td>
											<td GH="100" GCol="text,DUOMKY"></td>
											<td GH="100" GCol="select,RSNADJ">
												<select Combo="Common,RSNCD_COMBO,490" ComboCodeView="false">
													<option value="" CL="STD_SELECT"></option>
												</select>
											</td>
											<td GH="100" GCol="input,ADJRSN"  GF="S 255"></td>
											<td GH="100" GCol="input,QTADJU" GF="N 20" validate="required"></td>
											<td GH="100 STD_TQTPROC" GCol="text,AQTADJU" GF="N 20" validate="min(0) unequal(GRID_COL_QTSIWH_*),INV_M0711"></td>
<!-- 											<td GH="100" GCol="text,LOTA01"></td> -->
											<td GH="100 STD_LOTA01" GCol="text,LT01NM"></td>
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
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="total"></button>
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