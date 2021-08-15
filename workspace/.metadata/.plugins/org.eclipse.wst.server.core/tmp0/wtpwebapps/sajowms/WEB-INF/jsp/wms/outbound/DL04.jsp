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
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
			id : "gridList",
			module : "WmsOutbound",
			command : "DL04",
			itemGrid : "gridListSub",
			itemSearch : true
	    });
		
		gridList.setGrid({
			id : "gridListSub",
			module : "WmsOutbound",
			command : "DL04Sub"
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridList", true, ['INDDCL','OBPROTCT','OBPROTPT']);
		gridList.setReadOnly("gridListSub", true, ['OBPROT']);
	
		var wareky = "<%= wareky%>";
		if(wareky == 'WH00'){
			uiList.setActive("Work", false);
		}
		
		var headList = page.getLinkPageData("DL04");
		if(headList){
			linkSetParam(headList);
			searchList(headList);
		}	
	});
	
	function linkSetParam(headList){
		var param = inputList.setRangeParam("searchArea");
		if(headList && headList.length>0){
			var mangeMap = new DataMap();
			var rangeList = new Array();

			var rowMap;
			for(var i=0; i<headList.length; i++){
				rowMap = headList[i];
				mangeMap = new DataMap();
				mangeMap.put("OPER", "E");
				mangeMap.put("DATA", rowMap.get("SHPOKY"));	
				rangeList.push(mangeMap);	
			}
			inputList.setRangeData("SH.SHPOKY", configData.INPUT_RANGE_TYPE_SINGLE, rangeList);
		}
	}
	
	function linkPageOpenEvent(headList){
		linkSetParam(headList);
		searchList(headList);
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridListSub" && colName != "ALSTKY"){
			var statit = gridList.getColData(gridId, rowNum, "STATIT");
			if(statit == "NEW" || statit == "PAL" || statit == "FAL" || statit == "PPC"){
				var headData = gridList.getRowData("gridList", gridList.getFocusRowNum("gridList"));
				var rowData = gridList.getRowData(gridId, rowNum);
				rowData.putAll(headData);
				dataBind.paramData("searchArea", rowData);
				page.linkPopOpen("/wms/outbound/DL04POP.page", rowData);
			}
		}
	}
	
	/* function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
	        var rowData = gridList.getRowData(gridId, rowNum);
	        var param = inputList.setRangeParam("searchArea");
	        param.putAll(rowData);
	        
	        gridList.gridList({
	           id : "gridListSub",
	           param : param
	        });
		}
	} */
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridListSub",
	           param : param
	        });
		}
	}
 	
 	function getItemSearchParam(rowNum){
 		var rowData = gridList.getRowData("gridList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
 	}
	
	function searchList(headList){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			var rqshpd1 = param.get("RQSHPD1");
			var rqshpd2 = param.get("RQSHPD2");
			var date1 = uiList.getDateObj(rqshpd1);
		    var date2 = uiList.getDateObj(rqshpd2);
		    var day = (date2 - date1)/1000/60/60/24; 
			
			if(day > 30){
				commonUtil.msgBox("OUT_M0169");  //입출고 요청일자의 범위를 30일 이내로 지정해주세요.
				return;
			}else if(date1 > date2){
				commonUtil.msgBox("OUT_M0170");
				return;
			}
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridList"){
			var param = inputList.setRangeParam("searchArea");
			return param;
		}else if(gridId == "gridListSub"){
			 var rowNum = gridList.getSearchRowNum("gridList");
			 if(rowNum == -1){
				 return false;
			 }else{
				 var param = getItemSearchParam(rowNum);
				 return param;
			 }
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var head = gridList.getSelectData("gridList");
			
			if(head.length == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var param = new DataMap();
			param.put("head", head);
			
			var json = netUtil.sendData({
				url : "/wms/outbound/json/saveDL04.data",
				param : param
			});
			
			if(json && json.data){
				searchList();
				commonUtil.msgBox("MASTER_M0564");
			}
		}
	}
	
	function saveItemData(){
		if(gridList.validationCheck("gridListSub", "modify")){
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var list = gridList.getGridData("gridListSub");
			
			var param = new DataMap();
			param.put("list",list);
			
			var json = netUtil.sendData({
				url : "/wms/outbound/json/saveDL04Sub.data",
				param : param
			});
			
			if(json && json.data){
				commonUtil.msgBox("MASTER_M0564");
			}
		}
	}
	
	function allocate(){
		if(!commonUtil.msgConfirm("OUT_M0081")){
			return;
		}
		
		var head = gridList.getSelectData("gridList");
		var list = gridList.getGridData("gridListSub");
		
		if(head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("head", head);
		param.put("list", list);
		
		var json = netUtil.send({
			url : "/wms/outbound/json/AssignDL04.data",
			param : param,
			successFunction : "allocateSuccess"
		});
	}
	
	function allocateSuccess(json){
		if(json && json.SHPOKY == "OK"){
			commonUtil.msgBox("OUT_M0150");
			gridList.resetGrid("gridList");
			gridList.resetGrid("gridListSub");
			searchList();
		}else{
			commonUtil.msgBox("IN_M0134", json.SHPOKY);
			//alert("재고가 부족하여 출고문서번호를 할당할 수 없습니다.");
		}
	}
	
	function unallocate(){
		if(!commonUtil.msgConfirm("OUT_M0153")){
			return;
		}
		
		var head = gridList.getSelectData("gridList");
		var list = gridList.getGridData("gridListSub");
		
		if(head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("head", head);
		param.put("list", list);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/UnallocateDL04.data",
			param : param
		});
		
		if(json && json.data){
			commonUtil.msgBox("OUT_M0154");
			gridList.resetGrid("gridList");
			gridList.resetGrid("gridListSub");
			searchList();
		}
	}
	
	function pkComplete(){ // 피킹완료
		if(!commonUtil.msgConfirm("OUT_M0151")){
			return;
		}
	
		var head = gridList.getSelectData("gridList");
		
		if(head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("head", head);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/CompleteDL04.data",
			param : param
		});
		
		if(json && json.data){
			commonUtil.msgBox("OUT_M0152");
			gridList.resetGrid("gridList");
			gridList.resetGrid("gridListSub");
			searchList();
		}
	}
	
	function inputListEventRangeDataChange(rangeName, singleData, rangeData){
		if(rangeName == "SH.SHPOKY" || rangeName == "SI.SVBELN" || rangeName == "SI.SEBELN" || rangeName == "SI.SKUKEY"){
			var dataCount = inputList.getDataCount("SH.SHPOKY")
	                      + inputList.getDataCount("SI.SVBELN")
	                      + inputList.getDataCount("SI.SEBELN")
	                      + inputList.getDataCount("SI.SKUKEY");
			if(dataCount == 0){
				var now = new Date();
	 			now.setDate(now.getDate());
	 			var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
	 			$("#searchArea").find("[name=RQSHPD]").val(tmpValue);
	            inputList.addValidation("RQSHPD", "required");
			}else{
	            $("#searchArea").find("[name=RQSHPD]").val("");
	            inputList.removeValidation("RQSHPD", "required");
			}
		}      
	}
	
	function linkPopCloseEvent(data){
		searchList();
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		var param = new DataMap();
		if(searchCode == "SHDOCTM"){
			param.put("DOCCAT", "200");
			return param;
		}else if(searchCode == "SHCMCDV"){
			param.put("CMCDKY", "STATDO");
			return param;
		}else if(searchCode == "SHBZPTN"){
			if($inputObj.name == "SH.PTRCVR"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "CT");
				return param;
			}else if($inputObj.name == "SH.DPTNKY"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "CT");
				return param;
			}
		}else if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SaveItem"){
			saveItemData();
		}else if(btnName == "Allocate"){
			allocate();
		}else if(btnName == "Wcancle"){
			unallocate();
		}else if(btnName == "soList"){
			printList();
		}else if(btnName == "Work"){
			pkComplete();
		}else if(btnName == "ClsOrder"){
			closingOrder();
		}
	}
	
	
	
	function printList(){
		var url = "";
		var prtseq = "";
		var head = gridList.getSelectData("gridList");
		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = new DataMap();
		param.put("head", head);
		param.put("opt",$("input[name='BARSEC']:checked").val());
		var json = netUtil.sendData({
			url : "/wms/outbound/json/savePrtseqDL04.data",
			module : "WmsOutbound",
			param : param
		});
		
		/* var param = new DataMap();
		param.put("head", head);
		var json = netUtil.sendData({
			module : "WmsInbound",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		}); */
		
		var prtseq = json.data;
		param.put("PRTSEQ", prtseq);

		var where = "AND PRTSEQ IN ('" + prtseq + "')";
		
		if( $("input[name='BARSEC']:checked").val() == 'INDUPK'){
			url = "/ezgen/picking_list_by_1_sku.ezg";
			var map = new DataMap();
			WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 600);
		} else if ( $("input[name='BARSEC']:checked").val() == 'INDUPA'){
			url = "/ezgen/picking_list_by_2_ptn.ezg";
			var map = new DataMap();
			WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 600);
		} else if ( $("input[name='BARSEC']:checked").val() == 'INDUPB'){
			url = "/ezgen/picking_list_by_3_ord.ezg";
			var map = new DataMap();
			WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 600);
			}
		}
		
		function closingOrder(){
			if(gridList.validationCheck("gridList", "select")){
				if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
					return;
				}
				
				var head = gridList.getSelectData("gridList");
				
				if(head.length == 0){
					commonUtil.msgBox("VALID_M0006");
					return;
				}
				
				var param = new DataMap();
				param.put("head", head);
				
				var json = netUtil.sendData({
					url : "/wms/outbound/json/closingDL04.data",
					param : param
				});
				
				if(json.data != "OK"){
					var msgList = json.data.split("†");
					var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
					commonUtil.msg(msgTxt);
					return;
				} 
				
				if(json && json.data){
					searchList();
					commonUtil.msgBox("MASTER_M0564");
				}
			}
		}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Allocate ALLOCATE BTN_ALLOCATE"></button>
		<button CB="Wcancle WCANCLE BTN_UNALLO"></button>
		<button CB="Work WORK STD_PICKYN"></button>
		<button CB="ClsOrder CLOSE BTN_CLSORD"></button>
		<tr>
	<th CL="STD_BARSEC"><label CL="STD_PRINTDIVI" ></label></th>
	<td>
		<input type="radio" name="BARSEC" value="INDUPK" /><label CL="STD_BYSKUKEY" ></label>
		<input type="radio" name="BARSEC" value="INDUPA" checked/><label CL="STD_CTGROUP1" ></label>
		<input type="radio" name="BARSEC" value="INDUPB" /><label CL="STD_GRPRL1" ></label>
	</td>
</tr>
	    <button CB="soList PRINT BTN_PRINT16"></button>
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
			<button CB="Search SEARC
			H BTN_DISPLAY"></button>
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
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">문서상태</th>
						<td>
							<input type="checkbox" name="STAT01" value="V" checked="checked" />
							<label CL="STD_EMPTYTRAN"></label>
							<input type="checkbox" name="STAT02" value="V" checked="checked" />
							<label CL="STD_ALLOCATE">할당</label>
							<input type="checkbox" name="STAT03" value="V" />
							<label CL="STD_PICKIN">피킹</label>
							<input type="checkbox" name="STAT04" value="V" />
							<label CL="STD_SHPCOM">출고완료</label>
							<input type="checkbox" name="STAT05" value="V" />
							<label CL="STD_CLOSING">Closing</label>
						</td>
					</tr>
					<tr>
						<th CL="STD_RQSHPD">출고요청일자</th>
						<td>
							<input type="text" name="RQSHPD1" UIFormat="C" "/> ~ <input type="text" name="RQSHPD2" UIFormat="C" /> 
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<input type="text" name="SH.OWNRKY" UIInput="R"/> 
						</td>
					</tr>
					<tr>
						<th CL="STD_SSHTYP">출고유형</th>
						<td>
							<input type="text" name="SH.SHPMTY" UIInput="R,SHDOCTM"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DLTRRT">출고구분</th>
						<td>
							<input type="checkbox" name="PGRC01" value="V" checked="checked" />
							<label CL="STD_DLV"></label>
							<input type="checkbox" name="PGRC02" value="V" checked="checked" />
							<label CL="STD_TRN"></label>
							<input type="checkbox" name="PGRC03" value="V" checked="checked" />
							<label CL="STD_RTN"></label>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="SI.SKUKEY" UIInput="R,SHSKUMA"/>
						</td>
					</tr> -->
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
						<th CL="STD_SHPOKY">출고문서번호</th>
						<td>
							<input type="text" name="SH.SHPOKY" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">출고오더번호</th>
						<td>
							<input type="text" name="SI.SVBELN" UIInput="R"/>
						</td>
					</tr>				
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_CUSTINFO"></h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_PTRCVR,3">매출처</th>
						<td>
							<input type="text" name="SH.PTRCVR" UIInput="R,SHBZPTN"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_PTRCNM">매출처명</th>
						<td>
							<input type="text" name="CT.NAME01" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY2">납품처</th>
						<td>
							<input type="text" name="SH.DPTNKY" UIInput="R,SHBZPTN"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY2,3">납품처명</th>
						<td>
							<input type="text" name="PT.NAME01" UIInput="R"/>
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
						<li><a href="#tabs"><span CL="STD_LIST">리스트</span></a></li>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<!-- <col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_OWNRNM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_RQSHPD'></th>
												<th CL='STD_INDDCL'></th>
<!-- 												<th CL='STD_AREAKY'></th> -->
<!-- 												<th CL='STD_AREANM'></th> -->
												<th CL='STD_TOAREA'></th>
												<th CL='STD_AREATGNM'></th>
												<th CL='STD_SHPMTY'></th>
												<th CL='STD_SHPMNM'></th>
												<th CL='STD_DLTRRT'></th>
												<th CL='STD_DLTRRT,3'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_PTRCVR,3'></th>
												<th CL='STD_PTRCNM'></th>
												<th CL='STD_DPTNKY2'></th>
												<th CL='STD_DPTNKY2,3'></th>
												<th CL='STD_OBPROTCT'></th>
												<th CL='STD_OBPROTPT'></th>
												<th CL='STD_ITMCNT'></th>
<!-- 												<th CL='STD_LOTA07'></th> -->
<!-- 												<th CL='STD_LOTA04'></th> -->
<!-- 												<th CL='STD_IFPRINT'></th> -->
												<!-- <th CL='STD_DOCTXT'></th> -->
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<!-- <col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<td GCol="input,DOCDAT" validate="required" GF="C"></td>
												<td GCol="text,RQSHPD" GF="C"></td>
												<td GCol="check,INDDCL"></td>
<!-- 												<td GCol="text,AREAKY"></td> -->
<!-- 												<td GCol="text,AREANM"></td> -->
												<td GCol="text,AREATO"></td>
												<td GCol="text,ARETNM"></td>
												<td GCol="text,SHPMTY"></td>
												<td GCol="text,SHPMNM"></td>
												<td GCol="text,DLTRRT"></td>
												<td GCol="text,DLTRRTNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATNM"></td>
												<td GCol="input,ALSTKY" validate="required"></td>
												<td GCol="text,PTRCVR"></td>
												<td GCol="text,PTRCNM"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNNM"></td>
												<td GCol="check,OBPROTCT"></td>
												<td GCol="check,OBPROTPT"></td>
												<td GCol="text,ITMCNT" GF="N"></td>
<!-- 												<td GCol="text,SEBELN"></td> -->
<!-- 												<td GCol="text,LOTA04"></td> -->
<!-- 												<td GCol="text,DOORKY"></td> -->
												<!-- <td GCol="text,DOCTXT"></td> -->
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
						<li><a href="#tabs1-1"><span CL="STD_DETAILLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="util">
								<tr>
									<td>
										<button CB="SaveItem SAVE STD_SAVE">
										</button>
									</td>
								</tr>
							</table>
							<div class="table type2" style="top:45px;">
								<div class="tableHeader">
									<table>
										<colgroup>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>											
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_STATNM'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_OBPROT'></th>
												<th CL='STD_QTYORG'></th>
												<th CL='STD_QTSHPO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_QTUALO'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_QTSHPD'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA13,3'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_DOCTXT'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
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
										</colgroup>
										<tbody id="gridListSub">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,STATNM"></td>
												<td GCol="input,ALSTKY" validate="required"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="check,OBPROT"></td>
												<td GCol="text,QTYORG" GF="N 20,3"></td>
												<td GCol="text,QTSHPO" GF="N 20,3"></td>
												<td GCol="text,QTALOC" GF="N 20,3"></td>
												<td GCol="text,QTUALO" GF="N 20,3"></td>
												<td GCol="text,QTJCMP" GF="N 20,3"></td>
												<td GCol="text,QTSHPD" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="input,LOTA13" GF="C" validate="required"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,NAME01"></td>
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