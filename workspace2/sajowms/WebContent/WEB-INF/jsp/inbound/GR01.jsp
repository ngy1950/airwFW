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
	    	id : "gridHeadList",
	    	module : "Inbound",
			command : "GR01_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inbound",
			command : "GR01_ITEM"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "Common,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
		}else if(comboAtt == "Common,CMCDV_COMBO"){
			param.put("CMCDKY", "LOTA01");
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/inbound/json/saveGR01.data",
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
						<dt CL="STD_RCPTTY"></dt>
						<dd>
							<select name="RCPTTY" class="input" Combo="Common,DOCTM_COMCOMBO"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ARCPTD"></dt>
						<dd>
							<input type="text" class="input" name="A.DOCDAT" UIInput="R" UIFormat="C 0 0" PGroup="G1,G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELN"></dt>
						<dd>
							<input type="text" class="input" name="A.SEBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SZMBLNO"></dt>
						<dd>
							<input type="text" class="input" name="A.SZMBLNO" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ORDMVNO"></dt>
						<dd>
							<input type="text" class="input" name="A.SVBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DPTNKY1"></dt>
						<dd>
							<input type="text" class="input" name="A.DPTNKY" UIInput="SR"/>
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
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>??????</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40"              GCol="rownum">1</td>
										<td GH="40"              GCol="rowCheck"></td>
										<td GH="140 STD_SEBELN"  GCol="text,SEBELN"></td>
										<td GH="140 STD_RCPTTY"  GCol="text,RCPTNM"></td>
										<td GH="140 STD_OWNRKY"  GCol="text,OWNRNM"></td>
										<td GH="140 STD_DPTNKY1" GCol="text,DNAME1"></td>
										<td GH="140 STD_ORDMVNO" GCol="text,SVBELN"></td>
										<td GH="140 STD_ARCPTD"  GCol="text,DOCDAT" GF="D"></td>
										<td GH="140 STD_SZMBLNO" GCol="text,SZMBLNO"></td>
										<td GH="140 STD_ASNDKY"  GCol="text,ASNDKY"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >??? ?????? : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>??????</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>??????</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="140 STD_SEBELP"  GCol="text,SEBELP"></td>
										<td GH="140 STD_SKUKEY"  GCol="text,SKUKEY"></td>
										<td GH="140 STD_DESC01"  GCol="text,DESC01"></td>
										<td GH="140 STD_QTYASN"  GCol="text,QTYORG" GF="N 20"></td>
										<td GH="140 STD_QTYRCV"  GCol="input,QTYRCV" GF="N 20"></td>
										<td GH="140 STD_UOMKEY"  GCol="text,UOMKEY"></td>	
										<td GH="140 STD_LOTA01"  GCol="select,LOTA01">
											<select Combo="Common,CMCDV_COMBO" name="LOTA01">
												<option value="" CL="STD_SELECT"></option>
											</select>
										</td>
										<td GH="140 STD_LOTA02"  GCol="text,LOTA02"></td>
										<td GH="140 STD_LOTA03"  GCol="text,LOTA03"></td>								
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