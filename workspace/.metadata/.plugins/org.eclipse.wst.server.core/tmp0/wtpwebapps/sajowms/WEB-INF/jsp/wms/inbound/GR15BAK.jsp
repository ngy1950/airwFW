<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
		
	var searchCnt = 0; 
	var listFlag  = false;
	var dblIdx = -1;
	var subIdx = 0;
	var searchFlag = 1;
	var headShpoky = "";
	var paramH = new DataMap();	
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
			editable : true,
			//pkcol : "WAREKY,RECVKY,RECVIT,SEBELN",
			module : "WmsInbound",
			command : "GR15"
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			//pkcol : "WAREKY,RECVKY,RECVIT",
			module : "WmsInbound",
			command : "GR15Sub"
	    });
	});
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function searchList(){
		searchFlag = 1;
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
		}
	}
	
	function reSearchList(){
		alert(11);
		searchFlag = 2;
		
		gridList.gridList({
			id : "gridListHead",
			command : "GR15R",
			param : paramH
	    }); 
	}
	
	var itemChkIdx = "";
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridListHead" && dataLength > 0 ){
			if(searchFlag == 1){
				searchSubList(0);
			}else if(searchFlag == 2){
				reSearchSubList(0);
			}
		}else if(gridId == "gridListSub" && dataLength > 0 ){
			var chkVal = $("td[gcoltype='rowCheck']").eq(iChkIdx).attr("gcolvalue");
			//alert(chkVal);
			if(chkVal == 'V'){
				gridList.checkAll("gridListSub", 'true');
			} 
		}
	}

	function searchSubList(headRowNum){
		iChkIdx = headRowNum;
		var rowVal = gridList.getColData("gridListHead", headRowNum, "SHPOKY");
		
		var param = inputList.setRangeParam("searchArea");
		param.put("SHPOKY", rowVal);
		param.put("WAREKY", "<%= wareky%>");
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
	
		dblIdx = headRowNum;
		subIdx = headRowNum;
	}
	
	function reSearchSubList(headRowNum){
		var rowVal = gridList.getColData("gridListHead", headRowNum, "RECVKY");
		var param = new DataMap();
		param.put("RECVKY", rowVal);
		
		gridList.gridList({
			id : "gridListSub",
			command : "GR15IR",
			param : param
	    });
		
		dblIdx = headRowNum;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		//alert(" gridId : " + gridId + "\n dataLength : " + rowNum);
		if( gridId == "gridListHead" && searchFlag != 2){
			searchSubList(rowNum);
		}else if( gridId == "gridListHead" && searchFlag == 2 ){
			reSearchSubList(rowNum);
		}
	}
	
 	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridListHead"){
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
			}else if(modRowCnt > 0 && dblIdx != -1 && rowNum != preRowNum){
				//if(confirm(commonUtil.getMsg("COMMON_M0024"))){
				if(commonUtil.msgConfirm("COMMON_M0462")){
					gridList.resetGrid("gridListSub");
					gridList.setColFocus("gridListHead", rowNum, "DOCDAT");
				}else{
					gridList.setRowFocus("gridListHead", dblIdx, false);
					gridList.setColFocus("gridListSub", 0, "LOCAKY");
					return false;
				}
			}
		}
	} 
	
	// HEAD 체크시, ITEM 전채체크, ITEM 체크시, HEAD 체크
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridListHead"){
			gridList.checkAll("gridListSub", checkType);
			
		}else if(gridId == "gridListSub"){
			var chkRowNum = gridList.getSelectRowNumList("gridListSub");
			var chkCount = gridList.getSelectRowNumList("gridListSub").length;
			
			if(!checkType){
				if(chkCount == 0){
					gridList.setRowCheck("gridListHead", dblIdx, checkType);
				}
			}else{
				gridList.setRowCheck("gridListHead", dblIdx, checkType);
			}
		}
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		var chkRowNum = gridList.getSelectRowNumList("gridListSub");
		var chkCount = gridList.getSelectRowNumList("gridListSub").length;

		if(gridId == "gridListSub"){
			gridList.setRowCheck("gridListHead", dblIdx, checkType);
		}else if(gridId == "gridListHead"){
			gridList.checkAll("gridListSub", checkType);
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridListSub" && colName == "LOCAKY"){
			
			if(colValue != ""){
				var param = new DataMap();
				
				param.put("LOCAKY", colValue);
				param.put("WAREKY", "<%= wareky%>");
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "LOCAKYval",
					sendType : "map",
					param : param
				});
				
				if (json.data["CNT"] < 1) {
					commonUtil.msgBox("MASTER_M0507", colValue);
					
					gridList.setColValue("gridListSub", rowNum, "LOCAKY", "");
				}
			}
		}
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridListSub", "all")){
			var chkHeadIdx = gridList.getSelectRowNumList("gridListHead");
			var chkHeadLen = chkHeadIdx.length;			
			var itemModCnt = gridList.getModifyRowCount("gridListSub");
			var itemChkCnt = gridList.getSelectRowNumList("gridListSub").length;
			
			if( chkHeadLen == 0 ){
				// 선택된 데이터가 없습니다.
				commonUtil.msgBox("VALID_M0006");
				return;
			} else if (chkHeadLen > 0){
				var list = "";
				if((itemModCnt > 0 && dblIdx == subIdx) || (itemChkCnt > 0 && dblIdx == subIdx)){
					var head = gridList.getRowData("gridListHead", dblIdx);
					list = gridList.getSelectData("gridListSub");
					
					headShpoky = gridList.getColData("gridListHead", dblIdx, "SHPOKY");
					//alert(headShpoky);
				}
				
				var head = gridList.getSelectData("gridListHead");
				
				var param = new DataMap();
				param.put("head", head); 
				param.put("list", list);
				param.put("headShpoky", headShpoky);
			
				var json = netUtil.sendData({
					url : "/wms/inbound/json/SaveGR15.data",
					param : param
				});  

				if(json && json.data){
					paramH.put("RECVKY", json.data["RECVKY"]);
					paramH.put("WAREKY", "<%=wareky%>");
					
					//dblIdx = -1;
					gridList.resetGrid("gridListHead");
					gridList.resetGrid("gridListSub");
					
					reSearchList();
					
					gridList.setReadOnly("gridListHead", true);
					gridList.setReadOnly("gridListSub", true);
				}
		
			}
		}
	}
	
	function resetSub(){
		gridList.resetGrid("gridListSub");
		
		gridList.setReadOnly("gridListHead", false);
		gridList.setReadOnly("gridListSub", false);
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		var param = new DataMap();
		
		if(searchCode == "SHWAHMA" || searchCode == "SHSKUMA" || searchCode == "SCLOCMA_RS"){
			param.put("WAREKY", "<%= wareky%>");
			param.put("AREATY", "RECV");
			param.put("PTNL05", "<%= ownrky%>");
			param.put("AREATY", "RECV");
			return param;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button" onclick="resetSub()"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer" id="searchArea">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
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
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입하유형</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,DOCUTY166COMBO" name="RCPTTY"></select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="searchInBox">
			<h2 class="tit type1">ERP 검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREFR">From 거점</th>
						<td >
							<input type="text" name="WAREFR" UIInput="R,SHWAHMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">출하문서번호</th>
						<td >
							<input type="text" name="SHPOKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td >
							<input type="text" name="SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td >
							<input type="text" name="DESC01" UIInput="R" />
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
						<li><a href="#tabs1-1"><span>일반</span></a></li>
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
											<!-- <col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_RECVKY,2'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_RCPTTY,2'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_SAPSTS'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCCAT'></th>
												<th CL='STD_DPTNKY'></th>
												<th CL='STD_DRELIN'></th>
												<th CL='STD_ARCPTD'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_INDRCN'></th>
												<th CL='STD_CRECVD'></th>
												<th CL='STD_RSNCOD'></th>
												<!-- <th CL='STD_SEBELN'></th>
												<th CL='STD_ERPWM'></th>
												<th CL='STD_ERPWMNM'></th> -->
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_USRID1'></th>
												<th CL='STD_UNAME1'></th>
												<th CL='STD_DEPTID1'></th>
												<th CL='STD_DNAME1'></th>
												<th CL='STD_USRID2'></th>
												<th CL='STD_UNAME2'></th>
												<th CL='STD_DEPTID2'></th>
												<th CL='STD_DNAME2'></th>
												<th CL='STD_USRID3'></th>
												<th CL='STD_UNAME3'></th>
												<th CL='STD_DEPTID3'></th>
												<th CL='STD_DNAME3'></th>
												<th CL='STD_USRID4'></th>
												<th CL='STD_UNAME4'></th>
												<th CL='STD_DEPTID4'></th>
												<th CL='STD_DNAME4'></th>
												<th CL='STD_DOCTXT'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_RCPTTYNM'></th>
												<th CL='STD_DOCCATNM'></th>
												<th CL='STD_DPTNKYNM'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<!-- <col width="100" />
											<col width="100" />
											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,SAPSTS"></td>
												<td GCol="input,DOCDAT" GF="C 8"></td>
												<td GCol="text,DOCCAT"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DRELIN"></td>
												<td GCol="text,ARCPTD"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,INDRCN"></td>
												<td GCol="text,CRECVD"></td>
												<td GCol="text,RSNCOD"></td>
												<!-- <td GCol="text,SEBELN"></td>
												<td GCol="text,LGORT"></td>
												<td GCol="text,LGORTNM"></td> -->
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,USRID1"></td>
												<td GCol="text,UNAME1"></td>
												<td GCol="text,DEPTID1"></td>
												<td GCol="text,DNAME1"></td>
												<td GCol="text,USRID2"></td>
												<td GCol="text,UNAME2"></td>
												<td GCol="text,DEPTID2"></td>
												<td GCol="text,DNAME2"></td>
												<td GCol="text,USRID3"></td>
												<td GCol="text,UNAME3"></td>
												<td GCol="text,DEPTID3"></td>
												<td GCol="text,DNAME3"></td>
												<td GCol="text,USRID4"></td>
												<td GCol="text,UNAME4"></td>
												<td GCol="text,DEPTID4"></td>
												<td GCol="text,DNAME4"></td>
												<td GCol="input,DOCTXT" GF="S 255"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="text,DOCCATNM"></td>
												<td GCol="text,DPTNKYNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
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
									<p class="record" GInfoArea="true">17 Record</p>
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
						<li><a href="#tabs1-1"><span>Item 리스트</span></a></li>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<th CL='STD_RECVKY,2'></th>
												<th CL='STD_RECVIT,2'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_SAPSTS'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_SECTID'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_PACKID'></th>
												<th CL='STD_QTYRCV'></th>
												<th CL='STD_QTYDIF'></th>
												<th CL='STD_QTYUOM'></th>
												<th CL='STD_TRUNTY'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_DUOMKY'></th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_BOXQTY'></th>
												<th CL='STD_REMQTY'></th>
												<th CL='STD_INDRCN'></th>
												<th CL='STD_CRECVD'></th>
												<th CL='STD_RSNCOD'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA01NM'></th>
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
												<th CL='STD_REFDKY'></th>
												<th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_REFDAT'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
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
												<th CL='STD_QTYORG'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_SZMBLNO'></th>
												<th CL='STD_SZMIPNO'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_STPNUM'></th>
												<th CL='STD_SWERKS'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_SDATBG'></th>
												<th CL='STD_STDLNR'></th>
												<th CL='STD_SSORNU,2'></th>
												<th CL='STD_SSORIT,2'></th>
												<th CL='STD_SMBLNR'></th>
												<th CL='STD_SZEILE'></th>
												<th CL='STD_SMJAHR'></th>
												<th CL='STD_SXBLNR'></th>
												<th CL='STD_RCPRSN'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum">1</td> 
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,SAPSTS"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="input,LOCAKY,SCLOCMA_RS" validate="required,VALID_M0404" GF="S 20"></td>
												<td GCol="text,SECTID"></td>
												<td GCol="text,TRNUID"></td>
												<td GCol="text,PACKID"></td>
												<td GCol="text,QTYRCV"></td>
												<td GCol="text,QTYDIF"></td>
												<td GCol="text,QTYUOM"></td>
												<td GCol="text,TRUNTY"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTPUOM"></td>
												<td GCol="text,DUOMKY"></td>
												<td GCol="text,QTDUOM"></td>
												<td GCol="text,BOXQTY"></td>
												<td GCol="text,REMQTY"></td>
												<td GCol="text,INDRCN"></td>
												<td GCol="text,CRECVD"></td>
												<td GCol="text,RSNCOD"></td>
												<td GCol="input,LOTA01" GF="S 20"></td>
												<td GCol="text,LOTA01NM"></td>
												<td GCol="select,LOTA02">
													<select Combo="WmsInbound,LOTA02COMBO"></select> <!-- 재고유형 -->
												</td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="select,LOTA05">
													<select Combo="WmsInbound,LOTA05COMBO"></select> <!-- 재고분류 -->
												</td>
												<td GCol="text,LOTA06"></td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="input,LOTA11" GF="C 8"></td>
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
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
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
												<td GCol="text,QTYORG"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SZMBLNO"></td>
												<td GCol="text,SZMIPNO"></td>
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
												<td GCol="text,RCPRSN"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
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
									<p class="record" GInfoArea="true">17 Record</p>
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