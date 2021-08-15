<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(250);
		
		var rangeMap = new DataMap();
		var rangeList = new Array();
		
		rangeMap.put("OPER", "E");
		rangeMap.put("DATA", "210");
		rangeList.push(rangeMap);
		
		inputList.setRangeData("TASDH.TASOTY", configData.INPUT_RANGE_TYPE_SINGLE, rangeList);

		gridList.setGrid({
			id : "gridHeadList",
			//pkcol : "TASKKY, WAREKY",
			module : "WmsTask",
			command : "DL06HEAD",
			itemGrid : "gridList",
			itemSearch : true
	    });
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsTask",
			command : "DL06"
	    });
		
<%-- 		$("#USERAREA").val("<%=user.getUserg5()%>"); --%>
// 		gridList.setReadOnly("gridList", true, ['LOTA06']);
	});
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridList",
	           param : param
	        });
		}
	}
 	
 	function getItemSearchParam(rowNum){
 		var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
 	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
// 			var refdat1 = param.get("REFDAT1");
// 			var refdat2 = param.get("REFDAT2");
// 			var date1 = uiList.getDateObj(refdat1);
// 		    var date2 = uiList.getDateObj(refdat2);
// 		    var day = (date2 - date1)/1000/60/60/24; 
			
// 			if(day > 30){
// 				commonUtil.msgBox("OUT_M0169");  //입출고 요청일자의 범위를 30일 이내로 지정해주세요.
// 				return;
// 			}else if(date1 > date2){
// 				commonUtil.msgBox("OUT_M0170");
// 				return;
// 			}
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridHeadList"){
			var param = inputList.setRangeParam("searchArea");
			return param;
		}else if(gridId == "gridList"){
			 var rowNum = gridList.getSearchRowNum("gridHeadList");
			 if(rowNum == -1){
				 return false;
			 }else{
				 var param = getItemSearchParam(rowNum);
				 return param;
			 }
		}
	}
	
	function pkComplete(){ // 피킹완료
		if(!commonUtil.msgConfirm("OUT_M0151")){   									//피킹 완료하시겠습니까?
			return;
		}
		
		var head = gridList.getSelectData("gridHeadList");
	
		if(head.length == 0){
			commonUtil.msgBox("VALID_M0006");     									// 선택된 데이터가 없습니다.
			return;
		}
		
		var chkRowCnt = gridList.getGridData("gridList").length;
		var chkRowIdx = gridList.getGridData("gridList");
		var qtableMap = new DataMap();
		var qtcompMap = new DataMap();
		var skukeyMap = new DataMap();
				
		// 화면 작업수량 할당가능수량 비교
		for(var i = 0; i < chkRowCnt; i++){
    		var qtable  = gridList.getColData("gridList", chkRowIdx[i].get("GRowNum"),"QTABLE");
    		var qtcomp  = gridList.getColData("gridList", chkRowIdx[i].get("GRowNum"),"QTCOMP");
    		var SHPOIT  = gridList.getColData("gridList", chkRowIdx[i].get("GRowNum"),"SHPOIT");
    		
    		var taskit  = gridList.getColData("gridList", chkRowIdx[i].get("GRowNum"),"TASKIT");
    		var skukey  = gridList.getColData("gridList", chkRowIdx[i].get("GRowNum"),"SKUKEY");
    		    		
    		if(qtableMap.containsKey(SHPOIT)){
    			var sumQtcomp = (Number)(qtcompMap.get(SHPOIT)) + (Number)(qtcomp);
    			qtcompMap.put(SHPOIT, sumQtcomp);
    		}else{
    			qtableMap.put(SHPOIT, qtable);
        		qtcompMap.put(SHPOIT, qtcomp);
    			skukeyMap.put(SHPOIT, skukey);
    		}			
    		
    		if(qtcomp == "" || (Number)(qtcomp) < 1 ){
    			commonUtil.msgBox("TASK_M0065",taskit,skukey);					     	//* 작업오더아이템:상품의 완료수량은 1보다 작을수 없습니다.	
    			return false;
			}
    	}
		
		var keys = qtableMap.keys();
		for(var i=0; i<keys.length; i++){
			var rowQtable = qtableMap.get(keys[i]);
			var sumQtcomp = qtcompMap.get(keys[i]);
			var rowSkukey = skukeyMap.get(keys[i]);

	    	if((Number)(rowQtable) < (Number)(sumQtcomp)){  
				commonUtil.msgBox("TASK_M0066",[rowSkukey,sumQtcomp,rowQtable]);		//* 상품의 완료수량이 할당가능수량를 초과하였습니다.
				return false;
	    	}
		}   
				
		var list = gridList.getSelectData("gridList");				
		var param = new DataMap();
		param.put("list", list);
		var json = netUtil.sendData({
			url : "/wms/task/json/PkStockValidation.data",			
			param : param
		});								
		if(json.data != "OK"){
			var msgList = json.data.split("†");
 			var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));  
			commonUtil.msg(msgTxt);														//TASK_M0068 * 지번,팔렛트의 상품,로트넘버의 입력수량이 가용재고를 초과하였습니다.			
			return;
		}		
		
	
 		var head = gridList.getSelectData("gridHeadList");
		var list = gridList.getSelectData("gridList");				
		var param = new DataMap();
 		param.put("head", head);
		param.put("list", list);
		
		json = netUtil.sendData({
			url : "/wms/task/json/DL06SaveEnd.data",
			param : param
		});				
		if(json && json.data){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridList");
			commonUtil.msgBox("COOMON_M0463");								//저장이 완료되었습니다.
			searchList();
			}			
		
	}
	
	
	function inputListEventRangeDataChange(rangeName, singleData, rangeData){
		if(rangeName == "TASDI.SHPOKY" || rangeName == "TASDI.SVBELN" || rangeName == "TASDI.SEBELN" || rangeName == "TASDI.SKUKEY"){
			var dataCount = inputList.getDataCount("TASDI.SHPOKY")
	                      + inputList.getDataCount("TASDI.SVBELN")
	                      + inputList.getDataCount("TASDI.SEBELN")
	                      + inputList.getDataCount("TASDI.SKUKEY");
			if(dataCount == 0){
				var now = new Date();
	 			now.setDate(now.getDate());
	 			var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
	 			$("#searchArea").find("[name=REFDAT]").val(tmpValue);
	            inputList.addValidation("REFDAT", "required");
			}else{
	            $("#searchArea").find("[name=REFDAT]").val("");
	            inputList.removeValidation("REFDAT", "required");
			}
		}      
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Work"){
			pkComplete();
		}else if(btnName == "pkCompleteItem"){
			pkCompleteItem();
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){		
		if(gridId == "gridList"){						
			var clkRowData = gridList.getRowData(gridId, rowNum);
			var clkRowSkukey = clkRowData.get("SKUKEY");			

			var gridData = 	gridList.getGridData("gridList");			
			var dataRowMap = new DataMap();
			
			for(var i=0;i<gridData.length;i++){
				var rowData = gridData[i];
				if (clkRowSkukey == rowData.get("SKUKEY")) {
					var LOTNUM = rowData.get("LOTNUM")+rowData.get("LOCASR")+rowData.get("TRNUSR");
					
					if(dataRowMap.containsKey(LOTNUM)){
						var sumData = dataRowMap.get(LOTNUM);					
						var sumQty = (Number)(sumData.get("QTCOMP")) + (Number)(rowData.get("QTCOMP"));
						sumData.put("QTCOMP",sumQty);					
					}else{
						dataRowMap.put(LOTNUM, rowData);
					}									
				}
			}

			var sb = " ";
			var keys = dataRowMap.keys();
			for(var i=0; i<keys.length; i++){
				var rowStd = dataRowMap.get(keys[i]);
				if(sb != " " ) sb = sb + " UNION ALL ";
				sb = sb + " SELECT '"+ rowStd.get("LOTNUM") + "' AS LOTNUM, ";
				sb = sb + "        '"+ rowStd.get("LOCASR") + "' AS LOCAKY, ";
				sb = sb + "        '"+ rowStd.get("TRNUSR") + "' AS TRNUID, ";
				sb = sb + "         "+ rowStd.get("QTCOMP") + "  AS QTSWRK FROM DUAL ";	    			
			}

 			clkRowData.put("APPEND_QUERY",sb);
 			
 			dataBind.paramData("searchArea", clkRowData);
 			page.linkPopOpen("/wms/outbound/DL06POP.page", clkRowData);
		}
	}

	function linkPopCloseEvent(data){
		var taskit = data.get("TASKIT");
		var chkRowCnt = gridList.getGridData("gridList").length;
		var chkRowIdx = gridList.getGridData("gridList");
				
		// 클릭한 SKU를 비교하여 lotnum, loc, id 넘기기 
		for(var i = 0; i < chkRowCnt; i++){
			var rownum = chkRowIdx[i].get("GRowNum");
    		var rowtaskit  = gridList.getColData("gridList", rownum, "TASKIT");
	    		    		
    		if(rowtaskit == taskit ){
    			gridList.setColValue("gridList", rownum, "LOTNUM", data.get("LOTNUM"));		
    			gridList.setColValue("gridList", rownum, "LOCASR", data.get("LOCAKY"));		
    			gridList.setColValue("gridList", rownum, "TRNUSR", data.get("TRNUID"));		
    			gridList.setColValue("gridList", rownum, "QTTAOR", data.get("QTSAVB"));		
    			gridList.setColValue("gridList", rownum, "QTCOMP", data.get("QTSAVB"));		
    			return true;
    		}
    	}
		
	}	
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Work WORK STD_PICKYNDOC">
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
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td colspan="3">
							<input type="text" name="WAREKY" value="<%= wareky %>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">작업타입</th>
						<td>
							<input type="text" name="TASDH.TASOTY" UIInput="R,SHDOCTM" value="" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_RQSHPD">출고요청일자</th>
						<td>
							<!-- <input type="text" name="REFDAT" UIFormat="C N" validate="required"/> -->
							<input type="text" name="REFDAT1" UIFormat="C" /> ~ <input type="text" name="REFDAT2" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<input type="text" name="SHPDH.OWNRKY" UIInput="R"/> 
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="TASDI.SKUKEY" UIInput="R,SHSKUMA"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01"></th>
						<td>
							<input type="text" name="TASDI.DESC01" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC02"></th>
						<td>
							<input type="text" name="TASDI.DESC02" UIInput="R"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_WMSINFO">WMS 정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_TASKKY">작업지시번호</th>
						<td>
							<input type="text" name="TASDH.TASKKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">출하문서번호</th>
						<td>
							<input type="text" name="TASDI.SHPOKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">ECMS 주문번호</th>
						<td>
							<input type="text" name="TASDI.SVBELN" UIInput="R" />
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
											<col width="40" />
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
												<th CL='STD_TASKKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_TASOTY'></th>
												<th CL='STD_TASONM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_CONAME'></th>
												<th CL='STD_BUPLANT'></th>
												<th CL='STD_BUCHRG'></th>
												<th CL='STD_TOVCHRG'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
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
												<td GCol="text,TASKKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,TASOTY"></td>
												<td GCol="text,TASONM"></td>
												<td GCol="text,DOCDAT" GF="C"></td>
												<td GCol="text,CREDAT" GF="C"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="C"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,BUNAME"></td>
												<td GCol="text,BUPLANT"></td>
												<td GCol="text,BUCHRG"></td>
												<td GCol="text,TOVCHRG"></td>
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
							<table class="util">
								<tr>

<!-- 										<button CB="pkCompleteItem WORK STD_PICKYNITEM"> -->
<!-- 										</button> -->
										<div style="color:red; font-weight:bold; text-align:right">
											* Double Click:가용 재고 확인 
										</div>

								</tr>
							</table>
							<div class="table type2" style="top:30
							
							px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
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
												<th CL='STD_TASKKY'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_QTABLE'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_LOCASR'></th>
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_LOTNUM'></th>
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
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
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
												<td GCol="text,TASKKY"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,QTABLE" GF="N"></td>
												<td GCol="text,QTTAOR" GF="N"></td>
												<td GCol="input,QTCOMP" GF="N 20,3" validate="required max(GRID_COL_QTTAOR_*),TASK_M0033"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="input,LOCASR"></td>
												<td GCol="input,TRNUSR"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11" GF="C"></td>
												<td GCol="text,LOTA12" GF="C"></td>
												<td GCol="text,LOTA13" GF="C"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
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

	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>