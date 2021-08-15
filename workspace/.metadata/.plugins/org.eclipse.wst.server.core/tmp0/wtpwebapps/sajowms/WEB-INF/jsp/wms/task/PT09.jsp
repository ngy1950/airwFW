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
    var dblIdx = -1;
	$(document).ready(function(){
		setTopSize(400);
		gridList.setGrid({
	    	id : "gridList",
			module : "WmsTask",
			command : "PT09",
			itemGrid : "gridListSub",
			itemSearch : true
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
			module : "WmsTask",
			command : "PT09Sub"
	    });
		
		var rdata = new DataMap();
		//rdata.put(configData.INPUT_RANGE_OPERATOR, "E");
		
		rdata = new DataMap();
		rdata.put(configData.INPUT_RANGE_OPERATOR, "E");
		rdata.put(configData.INPUT_RANGE_SINGLE_DATA, 310);
		rdata.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		inputList.setRangeData("A.STATDO", configData.INPUT_RANGE_TYPE_SINGLE, [rdata]);
		//inputList.setRangeData("A.TASOTY", configData.INPUT_RANGE_TYPE_SINGLE, [rdata]);

		
		$("#USERAREA").val("<%=user.getUserg5()%>");
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });		
			
			gridList.setReadOnly("gridListSub", true, ['LOTA06']);
		}
	}
	
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
	
 	/* function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			searchSubList(0);
		}
	}
	
	function searchSubList(headRowNum){
		var data = gridList.getRowData("gridList", headRowNum);
		var param = new DataMap();
		param.put("TASKKY", data.get("TASKKY"));
		
		gridList.gridList({
	    	id : "gridListSub",
	    	command : "PT09Sub",
	    	param : param
	    });

		lastFocusNum = rowNum;
	}

	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			if(gridList.getColData("gridList", rowNum, "STATUS") == "C"){
				return false;
			}
			dblIdx = rowNum;
			searchSubList(rowNum);
		}
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridList"){
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
			}
		}
	} */
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			printList();
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
		
		// SELECT SEQ_PRTSEQ.NEXTVAL FROM DUAL
		var json = netUtil.sendData({
			module : "WmsTask",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		
		var json = netUtil.sendData({
			url : "/wms/task/json/savePrtseq.data",
			param : param
		});

		var where = "AND PRTSEQ IN ('" + prtseq + "')";

		url = "/ezgen/putaway_list.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		if(searchCode == "SHZONMA"){
			var param = dataBind.paramData("searchArea");
			param.put("AREAKY", param.get("AREA"));
			return param;
		}else if(searchCode == "SHLOCMA"){
			var param = dataBind.paramData("searchArea");
			param.put("AREAKY", param.get("AREA"));
			return param;
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%= wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}

</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Print PRINT BTN_PRINT32"></button>		

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
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" size="8px" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
							</select>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th CL="STD_AREAKY">창고</th> -->
<!-- 						<td><select Combo="WmsAdmin,AREACOMBO" name="AREA" id="USERAREA" validate="required"></select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th CL="STD_ZONEKY"></th>
						<td>
							<input type="text" name="ZONE" id="ZONE" UIInput="R,SHZONMA" />
						</td>
						</tr>
					<tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="B.LOCASR" UIInput="R,SHLOCMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">작업타입</th>
						<td><input type="text" name="A.TASOTY" UIInput="R" /></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="searchInBox">
			<h2 class="tit type1" CL="STD_WMSINFO">WMS 정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_TASKKY">작업지시번호</th>
						<td>
							<input type="text" name="A.TASKKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">문서일자</th>
						<td >
							<input type="text" name="A.DOCDAT" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">문서상태</th>
						<td>
							<input type="text" name="A.STATDO" UIInput="R" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RECVKY,2">입하문서번호</th>
						<td>
							<input type="text" name="B.RECVKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="B.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="B.DESC01" UIInput="R" />
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
						<li><a href="#tabs1-1"><span CL="STD_GENERAL">일반</span></a></li>
					</ul>
					<div id="tabs1-1">
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<th CL="STD_TASKKY"></th>
												<th CL="STD_WAREKY"></th>
												<th CL="STD_TASOTY"></th>
												<th CL="STD_DOCDAT"></th>
												<th CL="STD_DOCCAT"></th>
												<th CL="STD_DOCCATNM"></th>
												<th CL="STD_STATDO"></th>
												<th CL="STD_QTTAOR"></th>
												<th CL="STD_QTCOMP"></th>
												<th CL="STD_DRELIN"></th>
												<th CL="STD_TSPKEY"></th>
												<th CL="STD_KEEPTS"></th>
												<th CL="STD_WARETG"></th>
												<th CL="STD_TASSTX"></th>
												<th CL="STD_AREATG"></th>
												<th CL="STD_DOCTXT"></th>
												<th CL="STD_STATDONM"></th>
												<th CL="STD_RECVKY"></th>
												<th CL="STD_SHPOKY"></th>
												<th CL="STD_SHPMTY"></th>
												<th CL="STD_SEBELN"></th>
												<th CL="STD_SZMBLNO"></th>
												<th CL="STD_SZMIPNO"></th>
												<th CL="STD_STRAID"></th>
												<th CL="STD_SVBELN"></th>
												<th CL="STD_STKNUM"></th>
												<th CL="STD_STDLNR"></th>
												<th CL="STD_SSORNU"></th>
												<th CL="STD_SMBLNR"></th>
												<th CL="STD_SXBLNR"></th>
												<th CL="STD_AREAKY"></th>
												<th CL="STD_SHSTATDO"></th>
												<th CL="STD_SHSTATDONM"></th>
												<th CL="STD_DPTNKY"></th>
												<th CL="STD_DPTNKYNM"></th>
												<th CL="STD_CREDAT"></th>
												<th CL="STD_CRETIM"></th>
												<th CL="STD_CREUSR"></th>
												<th CL="STD_CUSRNM"></th>
												<th CL="STD_LMODAT"></th>
												<th CL="STD_LMOTIM"></th>
												<th CL="STD_LMOUSR"></th>
												<th CL="STD_LUSRNM"></th>
												<th CL="STD_UPDCHK"></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<td GCol="text,WAREKY"></td>    
												<td GCol="text,TASOTY"></td>    
												<td GCol="text,DOCDAT" GF="D"></td>    
												<td GCol="text,DOCCAT"></td>    
												<td GCol="text,DOCCATNM"></td>  
												<td GCol="text,STATDO"></td>    
												<td GCol="text,QTTAOR" GF="N"></td>    
												<td GCol="text,QTCOMP" GF="N"></td>    
												<td GCol="text,DRELIN"></td>    
												<td GCol="text,TSPKEY"></td>    
												<td GCol="text,KEEPTS"></td>    
												<td GCol="text,WARETG"></td>    
												<td GCol="text,TASSTX"></td>    
												<td GCol="text,AREATG"></td>    
												<td GCol="text,DOCTXT"></td>    
												<td GCol="text,STATDONM"></td>  
												<td GCol="text,RECVKY"></td>    
												<td GCol="text,SHPOKY"></td>    
												<td GCol="text,SHPMTY"></td>    
												<td GCol="text,SEBELN"></td>    
												<td GCol="text,SZMBLNO"></td>   
												<td GCol="text,SZMIPNO"></td>   
												<td GCol="text,STRAID"></td>    
												<td GCol="text,SVBELN"></td>    
												<td GCol="text,STKNUM"></td>    
												<td GCol="text,STDLNR"></td>    
												<td GCol="text,SSORNU"></td>    
												<td GCol="text,SMBLNR"></td>    
												<td GCol="text,SXBLNR"></td>    
												<td GCol="text,AREAKY"></td>    
												<td GCol="text,SHSTATDO"></td>  
												<td GCol="text,SHSTATDONM"></td>
												<td GCol="text,DPTNKY"></td>    
												<td GCol="text,DPTNKYNM"></td>  
												<td GCol="text,CREDAT" GF="D"></td>    
												<td GCol="text,CRETIM" GF="T"></td>    
												<td GCol="text,CREUSR"></td>    
												<td GCol="text,CUSRNM"></td>    
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
												<td GCol="text,UPDCHK"></td>
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
						<li><a href="#tabs1-1"><span CL="STD_ADJLIST">조정 가능 목록</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<th CL="STD_TASKKY"></th>
												<th CL="STD_TASKIT"></th>
												<th CL="STD_TASKTY"></th>
												<th CL="STD_RSNCOD"></th>
												<th CL="STD_TASRSN"></th>
												<th CL="STD_STATIT"></th>
												<th CL="STD_QTTAOR"></th>
												<th CL="STD_QTCOMP"></th>
												<th CL="STD_OWNRKY"></th>
												<th CL="STD_SKUKEY"></th>
												<th CL="STD_DESC01"></th>
												<th CL="STD_DESC02"></th>
												<th CL="STD_ASKU03"></th>
												<th CL="STD_LOTNUM"></th>
												<th CL="STD_ACTCDT"></th>
												<th CL="STD_ACTCTI"></th>
												<th CL="STD_QTYUOM"></th>
												<th CL="STD_TKFLKY"></th>
												<th CL="STD_STEPNO"></th>
												<th CL="STD_LSTTFL"></th>
												<th CL="STD_LOCASR"></th>
												<th CL="STD_SECTSR"></th>
												<th CL="STD_PAIDSR"></th>
												<th CL="STD_TRNUSR"></th>
												<th CL="STD_STRUTY"></th>
												<th CL="STD_SMEAKY"></th>
												<th CL="STD_SUOMKY"></th>
												<th CL="STD_QTSPUM"></th>
												<th CL="STD_SDUOKY"></th>
												<th CL="STD_QTSDUM"></th>
												<th CL="STD_LOCATG"></th>
												<th CL="STD_SECTTG"></th>
												<th CL="STD_PAIDTG"></th>
												<th CL="STD_TRNUTG"></th>
												<th CL="STD_TTRUTY"></th>
												<th CL="STD_TMEAKY"></th>
												<th CL="STD_TUOMKY"></th>
												<th CL="STD_QTTPUM"></th>
												<th CL="STD_TDUOKY"></th>
												<th CL="STD_QTTDUM"></th>
												<th CL="STD_LOCAAC"></th>
												<th CL="STD_SECTAC"></th>
												<th CL="STD_PAIDAC"></th>
												<th CL="STD_TRNUAC"></th>
												<th CL="STD_ATRUTY"></th>
												<th CL="STD_AMEAKY"></th>
												<th CL="STD_AUOMKY"></th>
												<th CL="STD_QTAPUM"></th>
												<th CL="STD_ADUOKY"></th>
												<th CL="STD_QTADUM"></th>
												<th CL="STD_REFDKY"></th>
												<th CL="STD_REFDIT"></th>
												<th CL="STD_REFCAT"></th>
												<th CL="STD_REFDAT"></th>
												<th CL="STD_ASNDKY"></th>
												<th CL="STD_ASNDIT"></th>
												<th CL="STD_RECVKY"></th>
												<th CL="STD_RECVIT"></th>
												<th CL="STD_SHPOKY"></th>
												<th CL="STD_SHPOIT"></th>
												<th CL="STD_SADJKY"></th>
												<th CL="STD_SADJIT"></th>
												<th CL="STD_SDIFKY"></th>
												<th CL="STD_SDIFIT"></th>
												<th CL="STD_PHYIKY"></th>
												<th CL="STD_PHYIIT"></th>
												<th CL="STD_DROPID"></th>
												<th CL="STD_ASKU01"></th>
												<th CL="STD_ASKU02"></th>
												<th CL="STD_ASKU04"></th>
												<th CL="STD_ASKU05"></th>
												<th CL="STD_EANCOD"></th>
												<th CL="STD_GTINCD"></th>
												<th CL="STD_SKUG01"></th>
												<th CL="STD_SKUG02"></th>
												<th CL="STD_SKUG03"></th>
												<th CL="STD_SKUG04"></th>
												<th CL="STD_SKUG05"></th>
												<th CL="STD_GRSWGT"></th>
												<th CL="STD_NETWGT"></th>
												<th CL="STD_WGTUNT"></th>
												<th CL="STD_LENGTH"></th>
												<th CL="STD_WIDTHW"></th>
												<th CL="STD_HEIGHT"></th>
												<th CL="STD_CUBICM"></th>
												<th CL="STD_CAPACT"></th>
												<th CL="STD_WORKID"></th>
												<th CL="STD_WORKNM"></th>
												<th CL="STD_HHTTID"></th>
												<th CL="STD_AREAKY"></th>
												<th CL="STD_LOTA01"></th>
												<th CL="STD_LOTA02"></th>
												<th CL="STD_LOTA03"></th>
												<th CL="STD_LOTA04"></th>
												<th CL="STD_LOTA05"></th>
												<th CL="STD_LOTA06"></th>
												<th CL="STD_LOTA07"></th>
												<th CL="STD_LOTA08"></th>
												<th CL="STD_LOTA09"></th>
												<th CL="STD_LOTA10"></th>
												<th CL="STD_LOTA11"></th>
												<th CL="STD_LOTA12"></th>
												<th CL="STD_LOTA13"></th>
												<th CL="STD_LOTA14"></th>
												<th CL="STD_LOTA15"></th>
												<th CL="STD_LOTA16"></th>
												<th CL="STD_LOTA17"></th>
												<th CL="STD_LOTA18"></th>
												<th CL="STD_LOTA19"></th>
												<th CL="STD_LOTA20"></th>
												<th CL="STD_PTLT01"></th>
												<th CL="STD_PTLT02"></th>
												<th CL="STD_PTLT03"></th>
												<th CL="STD_PTLT04"></th>
												<th CL="STD_PTLT05"></th>
												<th CL="STD_PTLT06"></th>
												<th CL="STD_PTLT07"></th>
												<th CL="STD_PTLT08"></th>
												<th CL="STD_PTLT09"></th>
												<th CL="STD_PTLT10"></th>
												<th CL="STD_PTLT11"></th>
												<th CL="STD_PTLT12"></th>
												<th CL="STD_PTLT13"></th>
												<th CL="STD_PTLT14"></th>
												<th CL="STD_PTLT15"></th>
												<th CL="STD_PTLT16"></th>
												<th CL="STD_PTLT17"></th>
												<th CL="STD_PTLT18"></th>
												<th CL="STD_PTLT19"></th>
												<th CL="STD_PTLT20"></th>
												<th CL="STD_AWMSNO"></th>
												<th CL="STD_AWMSTS"></th>
												<th CL="STD_SMANDT"></th>
												<th CL="STD_SEBELN"></th>
												<th CL="STD_SEBELP"></th>
												<th CL="STD_STRAID"></th>
												<th CL="STD_SVBELN"></th>
												<th CL="STD_SPOSNR"></th>
												<th CL="STD_STKNUM"></th>
												<th CL="STD_STPNUM"></th>
												<th CL="STD_SWERKS"></th>
												<th CL="STD_SLGORT"></th>
												<th CL="STD_SDATBG"></th>
												<th CL="STD_STDLNR"></th>
												<th CL="STD_SSORNU"></th>
												<th CL="STD_SSORIT"></th>
												<th CL="STD_SMBLNR"></th>
												<th CL="STD_SZEILE"></th>
												<th CL="STD_SMJAHR"></th>
												<th CL="STD_SXBLNR"></th>
												<th CL="STD_SAPSTS"></th>
												<th CL="STD_DOORKY"></th>
												<th CL="STD_CREDAT"></th>
												<th CL="STD_CRETIM"></th>
												<th CL="STD_CREUSR"></th>
												<th CL="STD_CUSRNM"></th>
												<th CL="STD_LMODAT"></th>
												<th CL="STD_LMOTIM"></th>
												<th CL="STD_LMOUSR"></th>
												<th CL="STD_LUSRNM"></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<td GCol="rownum">
												<td GCol="text,TASKKY"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,TASKTY"></td>
												<td GCol="input,RSNCOD"></td>
												<td GCol="input,TASRSN"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,QTTAOR" GF="N"></td>
												<td GCol="text,QTCOMP" GF="N"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,ACTCDT"></td>
												<td GCol="text,ACTCTI"></td>
												<td GCol="text,QTYUOM" GF="N"></td>
												<td GCol="text,TKFLKY"></td>
												<td GCol="text,STEPNO"></td>
												<td GCol="text,LSTTFL"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,SECTSR"></td>
												<td GCol="text,PAIDSR"></td>
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,STRUTY"></td>
												<td GCol="text,SMEAKY"></td>
												<td GCol="text,SUOMKY"></td>
												<td GCol="text,QTSPUM" GF="N"></td>
												<td GCol="text,SDUOKY"></td>
												<td GCol="text,QTSDUM" GF="N"></td>
												<td GCol="text,LOCATG"></td>
												<td GCol="text,SECTTG"></td>
												<td GCol="text,PAIDTG"></td>
												<td GCol="text,TRNUTG"></td>
												<td GCol="text,TTRUTY"></td>
												<td GCol="text,TMEAKY"></td>
												<td GCol="text,TUOMKY"></td>
												<td GCol="text,QTTPUM" GF="N"></td>
												<td GCol="text,TDUOKY"></td>
												<td GCol="text,QTTDUM"></td>
												<td GCol="text,LOCAAC"></td>
												<td GCol="text,SECTAC"></td>
												<td GCol="text,PAIDAC"></td>
												<td GCol="text,TRNUAC"></td>
												<td GCol="text,ATRUTY"></td>
												<td GCol="text,AMEAKY"></td>
												<td GCol="text,AUOMKY"></td>
												<td GCol="text,QTAPUM" GF="N"></td>
												<td GCol="text,ADUOKY"></td>
												<td GCol="text,QTADUM" GF="N"></td>
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT" GF="D"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,SADJIT"></td>
												<td GCol="text,SDIFKY"></td>
												<td GCol="text,SDIFIT"></td>
												<td GCol="text,PHYIKY"></td>
												<td GCol="text,PHYIIT"></td>
												<td GCol="text,DROPID"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
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
												<td GCol="text,WORKID"></td>
												<td GCol="text,WORKNM"></td>
												<td GCol="text,HHTTID"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<!-- <td GCol="text,LOTA06"></td> -->
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11" GF="D"></td>
												<td GCol="text,LOTA12" GF="D"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,LOTA18" GF="N"></td>
												<td GCol="text,LOTA19" GF="N"></td>
												<td GCol="text,LOTA20" GF="N"></td>
												<td GCol="text,PTLT01"></td>
												<td GCol="text,PTLT02"></td>
												<td GCol="text,PTLT03"></td>
												<td GCol="text,PTLT04"></td>
												<td GCol="text,PTLT05"></td>
												<td GCol="text,PTLT06"></td>
												<td GCol="text,PTLT07"></td>
												<td GCol="text,PTLT08"></td>
												<td GCol="text,PTLT09"></td>
												<td GCol="text,PTLT10"></td>
												<td GCol="text,PTLT11"></td>
												<td GCol="text,PTLT12"></td>
												<td GCol="text,PTLT13"></td>
												<td GCol="text,PTLT14"></td>
												<td GCol="text,PTLT15"></td>
												<td GCol="text,PTLT16" GF="N"></td>
												<td GCol="text,PTLT17" GF="N"></td>
												<td GCol="text,PTLT18" GF="N"></td>
												<td GCol="text,PTLT19" GF="N"></td>
												<td GCol="text,PTLT20" GF="N"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,AWMSTS"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,STDLNR"></td>
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="text,SAPSTS"></td>
												<td GCol="text,DOORKY"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
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
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>