<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	
	var headFocusNum = -1;
	var dblIdx = 0;
	var searchType = 0;
	
	$(document).ready(function(){
		setTopSize(300);
		
		gridList.setGrid({
			id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL01HEAD"
	    });
		
		gridList.setGrid({
			id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsOutbound",
			command : "DL01"
	    });
		
		var headList = page.getLinkPageData("DL04");
		if(headList){
			//alert(headList);
			searchList(headList);
		}	
	});
	
	function linkPageOpenEvent(headList){
		//alert(headList);
		searchList(headList);
	}
	
	function searchList(){
		uiList.setActive("Search", false);
		
		searchType = 1;
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
			gridList.setReadOnly("gridHeadList", false);
			gridList.setReadOnly("gridList", false);
		}
	}
	
	function gridListEventDataViewEnd(gridId, dataLength){
		if(gridId == "gridHeadList"){
			uiList.setActive("Search", true);
		}else{
			var headCheckType = gridList.getSelectType("gridHeadList", headFocusNum);
			if(headCheckType){
				gridList.checkAll("gridList", true);
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			headFocusNum = 0;
			if(searchType == 1){				
				searchSubList(0);
			}else if(searchType == 2){
				searchSubItemList(0);
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Allocate"){
			saveAssignment();
		}else if(btnName == "Note"){
			linkPage();
		}
	}
	
	function searchSubList(rowNum){
		gridList.resetGrid("gridList");
		
		var rowVal = gridList.getColData("gridHeadList", rowNum,"SVBELN");
		
		var param = inputList.setRangeParam("searchArea");
			param.put("SVBELN", rowVal);		
		
		gridList.gridList({
			id : "gridList",
			param : param
		});

			headFocusNum = rowNum;
	}
	
	function searchSubItemList(rowNum){
		gridList.resetGrid("gridList");
		
		var SHPOKY = gridList.getColData("gridHeadList", rowNum, "SHPOKY");
		/* var shpoky = gridList.getColData("gridHeadList", rowNum, "SHPOKY"); */
		//alert(shpoky)
		//var param = inputList.setRangeParam("searchArea");
		var param = dataBind.paramData("searchArea");
		param.put("SHPOKY", "\u0027"+SHPOKY+"\u0027");
		/*
		var changeMap = new DataMap();
		changeMap.put("IFW.BWART", "TEST");
		var sqlTxt = inputList.changeRangeSql(changeMap);
		param.put("R_SQL", sqlTxt);
		*/
		gridList.gridList({
			id : "gridList",
			command : "DL04",
			param : param
		});

		headFocusNum = rowNum;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			dblIdx = rowNum;
			if(searchType == 1){				
				searchSubList(rowNum);
			}else if(searchType == 2){
				searchSubItemList(rowNum);
			}
			
		}else if(gridId == "gridList"){
			var SHPOKY = gridList.getColData("gridList", rowNum, "SHPOKY");
			if($.trim(SHPOKY) == "") return;
			
			var rowData = gridList.getRowData(gridId, rowNum);
			//dataBind.paramData("searchArea", rowData);
			page.linkPopOpen("/wms/outbound/DL04POP.page", rowData);
		}
	}
	
	function linkPopCloseEvent(){
		//alert(page.popData);	
		searchSubItemList(headFocusNum);
	}
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridHeadList"){
			gridList.checkAll("gridList", checkType);
		}else if(gridId == "gridList"){
			var chkCount = gridList.getSelectRowNumList("gridList").length;
			if(!checkType){
				if(chkCount == 0){
					gridList.setRowCheck("gridHeadList", dblIdx, checkType);
				}
			}else{
				gridList.setRowCheck("gridHeadList", dblIdx, checkType);
			}
		}
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		if(gridId == "gridList"){
			gridList.setRowCheck("gridHeadList", headFocusNum, checkType);
		}else if(gridId == "gridHeadList"){
			gridList.checkAll("gridList", checkType);
		}
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var modRowCnt = gridList.getModifyRowCount("gridList");
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridList");
					dblIdx = -1;
				}
			}else{
				if(commonUtil.msgConfirm("COMMON_M0462")){
					gridList.resetGrid("gridList");
					dblIdx = -1;
				}else{
					gridList.setRowFocus("gridHeadList", headFocusNum, false);
					gridList.setColFocus("gridHeadList", headFocusNum, "DOCDAT");
					return;
				}
			}
			headFocusNum = rowNum;
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}
	}
	
	function saveCheck(){		
		var param = dataBind.paramData("searchArea");
		var headList = gridList.getSelectData("gridHeadList");
		var itemList;
		
		if(headList.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var modRowCnt = gridList.getModifyRowCount("gridList");
		if(modRowCnt > 0){
			if(gridList.validationCheck("gridList", "select")){
				itemList = gridList.getSelectData("gridList");
				var headSelectList = gridList.getSelectRowNumList("gridHeadList");
				for(var i=0;i<headSelectList.length;i++){
					if(dblIdx == headSelectList[i]){
						param.put("headModifyIndex", i);
					}
				}
				param.put("list", itemList);
			}else{
				return;
			}
		}
		
		param.put("headList", headList);
		
		return param;
	}
	
	function saveAssignment(){
		if(gridList.validationCheck("gridList", "all")){
			if(!commonUtil.msgConfirm("OUT_M0081")){
				return;
			}
			
			var param = saveCheck();
			if(param != null){
				param.put("batch", "true");
				
			var json = save(param);
				
				if(gridList.checkResult(json)){
					commonUtil.msgBox("OUT_M0150");
					//searchList();
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridList");
					gridList.viewJsonData("gridHeadList", json.data);
					searchType=2;
					searchSubItemList(0);
				}
				gridList.setReadOnly("gridHeadList", true);
			    gridList.setReadOnly("gridList", true);
			}
			uiList.setActive("Allocate", false);
			uiList.setActive("Note", true);
		}
	}
	
	function save(param){
		var json = netUtil.sendData({
			url : "/wms/outbound/json/saveShpd.data",
			param : param
		});
		
		return json;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList" && colName == "ALSTKY"){
			
			if(colValue != ""){
				var param = new DataMap();
				
				param.put("ALSTKY", colValue);
				param.put("WAREKY", "<%=wareky%>");
				
				var json = netUtil.sendData({
					module : "WmsOutbound",
					command : "ALSTKYval",
					sendType : "map",
					param : param
				});
				
				if (json.data["CNT"] < 1) {
					commonUtil.msgBox("VALID_M0211", colValue);
					
					gridList.setColValue("gridList", rowNum, "ALSTKY", "");
				}
			}
		}
	}
	
	function linkPage(){
		var headList = gridList.getGridData("gridHeadList");
		page.linkPageOpen("DL04", headList);
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Allocate ALLOCATE BTN_ALLOCATE">
		</button>
		<button CB="Note NOTE BTN_MNGLINK false">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>거점</th>
						<td colspan="3">
							<input type="text" name="WAREKY" validate="required,M0434" value="<%=wareky%>" readonly="readonly"/>
							<input type="hidden" name="PROGID" value="DL03" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPMTY"></th>
						<td>
							<input type="text" name="IFW.BWART" UIInput="R,SHDOCTM" value="266" readonly="readonly"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_ERPSELECTOPTIONS">ERP 검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_GROUP">그룹</th>
						<td>
							<input type="radio" name="IFW.GROUP" checked /><span cl="STD_GRPRL1"></span>
						</td>
					</tr>
					<tr>
						<th CL="STD_ERDAT">지시일자</th>
						<td>
							<input type="text" name="IFW.ZLIKP_ERDAT" UIInput="R" UIFormat="C"  />
						</td>
					</tr>
					<tr>
						<th CL="STD_RQSHPD">출하요청일자</th>
						<td>
							<input type="text" name="IFW.WADAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_KUNAG">거래처</th>
						<td>
							<input type="text" name="IFW.KUNAG" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="IFW.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA05">재고분류</th>
						<td>
							<select name="LOTA05">
								<option value="">[] 정상</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_VBELN">ECMS 주문item</th>
						<td>
							<input type="text" name="IFW.VBELN" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs" CL="STD_LIST"><span>리스트</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_SHPMTY'></th>
												<th CL='STD_SHPMTYNM'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM'></th>
												<th CL='STD_DOCCAT'></th>
												<th CL='STD_DOCCATNM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCUTY'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_RQSHPD'></th>
												<th CL='STD_RQARRD'></th>
												<th CL='STD_RQARRT'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_SHIPTO'></th>
												<th CL='STD_SHIPTONM'></th>
												<th CL='STD_SOLDTO'></th>
												<th CL='STD_SOLDTONM'></th>
												<th CL='STD_PTNBLK'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_PGRC01'></th>
												<th CL='STD_PGRC02'></th>
												<th CL='STD_PGRC03'></th>
												<th CL='STD_PGRC04'></th>
												<th CL='STD_PGRC05'></th>
												<th CL='STD_VEHINO'></th>
												<th CL='STD_DRIVER'></th>
												<th CL='STD_DOCTXT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,SHPMTY"></td>
												<td GCol="text,SHPMTYNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATDONM"></td>
												<td GCol="text,DOCCAT"></td>
												<td GCol="text,DOCCATNM"></td>
												<td GCol="input,DOCDAT" GF="C 8"></td>
												<td GCol="text,DOCUTY"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,RQSHPD"></td>
												<td GCol="text,RQARRD"></td>
												<td GCol="text,RQARRT"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNKYNM"></td>
												<td GCol="text,PTRCVR"></td>
												<td GCol="text,PTRCVRNM"></td>
												<td GCol="text,PTNBLK"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,PGRC01"></td>
												<td GCol="text,PGRC02"></td>
												<td GCol="text,PGRC03"></td>
												<td GCol="text,PGRC04"></td>
												<td GCol="text,PGRC05"></td>
												<td GCol="text,VEHINO"></td>
												<td GCol="text,DRIVER"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
											</tr>								
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1"><span CL="STD_ITEMLST">ITEM 리스트</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_QTSORG'></th>
												<th CL='STD_QTSHPO'></th>
												<th CL='STD_QTUALO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_SHCMPL'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_WGTUNT'></th>
												<th CL='STD_LENGTH'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CAPACT'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_AWMSNO'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_OBLKYN'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LUSRNM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="input,ALSTKY,SHALSTH" GF="S 10"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,QTYORG"></td>
												<td GCol="input,QTSHPO" validate="max(GRID_COL_QTYORG_*),HHT_T0019" GF="N 20,3"></td>
												<td GCol="text,QTUALO"></td>
												<td GCol="text,QTALOC"></td>
												<td GCol="text,QTSHPD"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTPUOM"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,LOTA06"></td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11"></td>
												<td GCol="text,LOTA12"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16"></td>
												<td GCol="text,LOTA17"></td>
												<td GCol="text,LOTA18"></td>
												<td GCol="text,LOTA19"></td>
												<td GCol="text,LOTA20"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,OBLKYN"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //contentContainer -->
		<%@ include file="/common/include/bottom.jsp" %>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>