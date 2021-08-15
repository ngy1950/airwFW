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
	var headSebeln = "";
	var paramH = new DataMap();
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
			editable : true,
			module : "WmsInbound",
			command : "GR02"
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			module : "WmsInbound",
			command : "GR02Sub"
	    });
		
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	});
	
	function linkPageOpenEvent(headList){
		//alert(headList);
		searchList(headList);
	}
	
	function linkPage(){
		var headList = gridList.getGridData("gridListHead");
		page.linkPageOpen("DL01", headList);
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Note"){
			linkPage();
		}else if(btnName == "Send"){
			sendSMS();
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
		uiList.setActive("Note", false);
		gridList.setReadOnly("gridListHead", false);
		gridList.setReadOnly("gridListSub", false);
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	}
	
	function reSearchList(){
		searchFlag = 2;
		
		gridList.gridList({
			id : "gridListHead",
			command : "GR02R",
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
			//var chkVal = $("input[gcoltype='rowCheck']").eq(iChkIdx).is(":checked");
			var chkVal = gridList.getSelectType("gridListHead", iChkIdx);
			if(chkVal == true){
				gridList.checkAll("gridListSub", 'true');
			}  
		}
	}

	function searchSubList(headRowNum){
		iChkIdx = headRowNum;
		var rowVal = gridList.getColData("gridListHead", headRowNum, "SEBELN");
		
		var param = inputList.setRangeParam("searchArea");
		param.put("SEBELN", rowVal);
		
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
			command : "GR02IR",
			param : param
	    });
		
		dblIdx = headRowNum;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
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
			}else if(modRowCnt > 0 && dblIdx != -1 && dblIdx != rowNum){
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
		
		/* if(gridList.validationCheck("gridListSub", "all")){ */
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
				
				headSebeln = gridList.getColData("gridListHead", dblIdx, "SEBELN");
				//alert(headSebeln);
			}
			
			var head = gridList.getSelectData("gridListHead");
			
			var param = new DataMap();
			param.put("head", head); 
			param.put("list", list);
			param.put("headSebeln", headSebeln);
		
			var json = netUtil.sendData({
				url : "/wms/inbound/json/SaveGR02.data",
				param : param
			});  

			if(json && json.data){
				
				commonUtil.msgBox("COMMON_M0007");
				
				paramH.put("RECVKY", json.data["RECVKY"]);
				paramH.put("WAREKY", "<%=wareky%>");
				
				//dblIdx = -1;
				gridList.resetGrid("gridListHead");
				gridList.resetGrid("gridListSub");
				
				reSearchList();
				
				gridList.setReadOnly("gridListHead", true);
				gridList.setReadOnly("gridListSub", true);
				
				var param = inputList.setRangeParam("searchArea");
				var RCPTTY = param.get("RCPTTY");
				if(RCPTTY != "102"){
					uiList.setActive("Note", true);
				}
			}
		}
	}
	/* } */
	
	function resetSub(){
		gridList.resetGrid("gridListSub");
		
		gridList.setReadOnly("gridListHead", false);
		gridList.setReadOnly("gridListSub", false);
	}
	
	function sendSMS(){
		var list = gridList.getSelectData("gridListHead");
		var param = new DataMap();
		param.put("list", list);
	
		var json = netUtil.sendData({
			url : "/wms/inbound/json/SendSMS.data",
			param : param
		});
		
		if(json && json.data){
			commonUtil.msgBox("IN_M0094");
			searchList();
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		
		if(searchCode == "SHBZPTN" || searchCode == "SHSKUMA" || searchCode == "SCLOCMA_RS" || searchCode == "SHBZPTN"){
			param.put("OWNRKY", "<%= ownrky%>");
			param.put("WAREKY", "<%= wareky%>");
			param.put("PTNRTY", "VD");
			param.put("PTNL05", "<%= ownrky%>");
			return param;
		}
	}
	
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button> 
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Send SEND SMS"></button>
		<button CB="Note NOTE STD_SSHMOV"></button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button" onclick="resetSub()"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>
<!-- //contentHeader -->

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
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입하유형</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,DOCUTY102COMBO" name="RCPTTY"></select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="searchInBox">
			<h2 class="tit type1" CL="STD_ERPSELECTOPTIONS">ERP 검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_EBELN">SAP P/O No</th>
						<td>
							<input type="text" name="EBELN" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_AEDAT">ERP P/O 생성일</th>
						<td >
							<input type="text" name="IFWMS103.ZEKKO_AEDAT" UIInput="R" UIFormat="C 8" />
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
							<input type="text" name="IFWMS103.DESC01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY">업체코드</th>
						<td >
							<input type="text" name="IFWMS103.LIFNR" UIInput="R,SHBZPTN" />
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
						<li><a href="#tabs1-1" CL="STD_GENERAL"><span>일반</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_RECVKY,2'></th>   <!-- 입하문서번호    -->
												<th CL='STD_SEBELN'></th>     <!-- ECMS 주문번호   -->
												<th CL='STD_CONFIM'></th>     <!-- 컨펌여부        -->
												<th CL='STD_RCPTTYNM'></th>   <!-- 입하유형명       -->
												<th CL='STD_WAREKY'></th>     <!-- 거점                -->
												<th CL='STD_DOCDAT'></th>     <!-- 문서일자         -->
												<th CL='STD_DPTNKY'></th>     <!-- 업체코드          -->
												<th CL='STD_DPTNKYNM'></th>   <!-- 업체코드명       -->
												<th CL='STD_DOCTXT'></th>     <!-- 비고            -->
												<th CL='STD_WAREKYNM'></th>   <!-- 거점명             -->
												<th CL='STD_RCPTTY'></th>     <!-- 입하유형          -->
												<th CL='STD_STATDO'></th>     <!-- 문서상태          -->
												<th CL='STD_SAPSTS'></th>     <!-- ERP Mvt  -->
												<th CL='STD_DOCCAT'></th>     <!-- 문서유형         -->
												<th CL='STD_DOCCATNM'></th>   <!-- 문서유형명       -->
												<th CL='STD_DRELIN'></th>     <!-- 문서연관구분자  -->
												<th CL='STD_ARCPTD'></th>     <!-- 입하일자        -->
												<th CL='STD_OWNRKY'></th>     <!-- 화주            -->
												<th CL='STD_INDRCN'></th>     <!-- 취소됨          -->
												<th CL='STD_CRECVD'></th>     <!-- 입고취소 일자   -->
												<th CL='STD_RSNCOD'></th>     <!-- 사유코드        -->
												<th CL='STD_PUTSTS'></th>     <!-- 입고상태        -->
												<th CL='STD_LGORT'></th>      <!-- Fr.ERP창고      -->
												<th CL='STD_LGORTNM'></th>    <!-- Fr.ERP창고명    -->
												<th CL='STD_USRID1'></th>     <!-- 입력자          -->
												<th CL='STD_UNAME1'></th>     <!-- 입력자명        -->
												<th CL='STD_DEPTID1'></th>    <!-- 입력자 부서     -->
												<th CL='STD_DNAME1'></th>     <!-- 입력자 부서명   -->
												<th CL='STD_USRID2'></th>     <!-- 업무담당자      -->
												<th CL='STD_UNAME2'></th>     <!-- 업무담당자명    -->
												<th CL='STD_DEPTID2'></th>    <!-- 업무 부서       -->
												<th CL='STD_DNAME2'></th>     <!-- 업무 부서명     -->
												<th CL='STD_USRID3'></th>     <!-- 현장담당        -->
												<th CL='STD_UNAME3'></th>     <!-- 현장담당자명    -->
												<th CL='STD_DEPTID3'></th>    <!-- 현장담당 부서   -->
												<th CL='STD_DNAME3'></th>     <!-- 현장담당 부서명 -->
												<th CL='STD_USRID4'></th>     <!-- 현장책임        -->
												<th CL='STD_UNAME4'></th>     <!-- 현장책임자명    -->
												<th CL='STD_DEPTID4'></th>    <!-- 현장책임 부서   -->
												<th CL='STD_DNAME4'></th>     <!-- 현장책임 부서명 -->
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
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVKY"></td>		   
												<td GCol="text,SEBELN"></td>		 
												<td GCol="check,CONFIM"></td>		 
												<td GCol="text,RCPTTYNM"></td>		 
												<td GCol="text,WAREKY"></td>		 
												<td GCol="input,DOCDAT" GF="C 8"></td>	 
												<td GCol="text,DPTNKY"></td>		 
												<td GCol="text,DPTNKYNM"></td>		 
												<td GCol="input,DOCTXT" GF="S 255"></td>		 
												<td GCol="text,WAREKYNM"></td>	 
												<td GCol="text,RCPTTY"></td>	 
												<td GCol="text,STATDO"></td>	 
												<td GCol="text,SAPSTS"></td>	 
												<td GCol="text,DOCCAT"></td>	 
												<td GCol="text,DOCCATNM"></td>	 
												<td GCol="text,DRELIN"></td>	 
												<td GCol="text,ARCPTD"></td>	 
												<td GCol="text,OWNRKY"></td>	 
												<td GCol="text,INDRCN"></td>	 
												<td GCol="text,CRECVD"></td>	 
												<td GCol="text,RSNCOD"></td>	 
												<td GCol="text,PUTSTS"></td>	 
												<td GCol="text,LGORT"></td>		 
												<td GCol="text,LGORTNM"></td>	
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
						<li><a href="#tabs1-1" CL="STD_ITEMLST"><span>Item 리스트</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_RECVIT,2'></th> <!-- 입하문서아이템 -->
												<th CL='STD_SKUKEY'></th>   <!-- 품번코드 -->
												<th CL='STD_DESC01'></th>   <!-- 품명 -->
												<th CL='STD_LOCAKY'></th>   <!-- 지번 -->
												<th CL='STD_QTYPOR'></th>   <!-- 구매수량 -->
												<th CL='STD_QTYRCV'></th>   <!-- 입고수량 -->
												<th CL='STD_DUOMKY'></th>   <!-- 단위 -->
												<th CL='STD_QTDUOM'></th>   <!-- 입수 -->
												<th CL='STD_BOXQTY'></th>   <!-- 박스수 -->
												<th CL='STD_REMQTY'></th>   <!-- 잔량 -->
												<th CL='STD_LOTA01'></th>   <!-- S/N번호 -->
												<th CL='STD_LOTA11'></th>   <!-- 제조일자 -->
												<th CL='STD_LOTA03'></th>   <!-- 벤더 -->
												<th CL='STD_SEBELN'></th>   <!-- ECMS 주문번호 -->
												<th CL='STD_RECVKY,2'></th> <!-- 입하문서번호 -->
												<th CL='STD_STATIT'></th>   <!-- 상태 -->
												<th CL='STD_SAPSTS'></th>   <!-- ERP Mvt -->
												<th CL='STD_LOTNUM'></th>   <!-- Lot no. -->
												<th CL='STD_AREAKY'></th>   <!-- 창고 -->
												<th CL='STD_SECTID'></th>   <!-- Sect.ID -->
												<th CL='STD_TRNUID'></th>   <!-- P/T -->
												<th CL='STD_PACKID'></th>   <!-- SET품번코드 -->
												<th CL='STD_QTYDIF'></th>   <!-- 차이량 -->
												<th CL='STD_QTYUOM'></th>   <!-- Quantity -->
												<th CL='STD_TRUNTY'></th>   <!-- 팔렛타입 -->
												<th CL='STD_MEASKY'></th>   <!-- 단위구성 -->
												<th CL='STD_UOMKEY'></th>   <!-- 단위 -->
												<th CL='STD_QTPUOM'></th>   <!-- Units pe -->
												<th CL='STD_INDRCN'></th>   <!-- 취소됨 -->
												<th CL='STD_CRECVD'></th>   <!-- 입고취소 일자 -->
												<th CL='STD_RSNCOD'></th>   <!-- 사유코드 -->
												<th CL='STD_LOTA01NM'></th> <!-- 영업부분명 -->
												<th CL='STD_LOTA02'></th>   <!-- 재고유형 -->
												<th CL='STD_LOTA04'></th>   <!-- 문서번호 -->
												<th CL='STD_LOTA05'></th>   <!-- 재고분류 -->
												<th CL='STD_LOTA06'></th>   <!-- 재고상태 -->
												<th CL='STD_LOTA07'></th>   <!-- LOT속성7 -->
												<th CL='STD_LOTA08'></th>   <!-- LOT속성8 -->
												<th CL='STD_LOTA09'></th>   <!-- LOT속성9 -->
												<th CL='STD_LOTA10'></th>   <!-- LOT속성10 -->
												<th CL='STD_LOTA12'></th>   <!-- 입고일자 -->
												<th CL='STD_LOTA13'></th>   <!-- 유효기간 -->
												<th CL='STD_LOTA14'></th>   <!-- LOT속성14 -->
												<th CL='STD_LOTA15'></th>   <!-- LOT속성15 -->
												<th CL='STD_LOTA16'></th>   <!-- LOT속성16 -->
												<th CL='STD_LOTA17'></th>   <!-- LOT속성17 -->
												<th CL='STD_LOTA18'></th>   <!-- LOT속성18 -->
												<th CL='STD_LOTA19'></th>   <!-- LOT속성19 -->
												<th CL='STD_LOTA20'></th>   <!-- LOT속성20 -->
												<th CL='STD_AWMSNO'></th>   <!-- SEQ(ERP) -->
												<th CL='STD_REFDKY'></th>   <!-- 참조문서 -->
												<th CL='STD_REFDIT'></th>   <!-- 참조문서It. -->
												<th CL='STD_REFCAT'></th>   <!-- 참조문서유형 -->
												<th CL='STD_REFDAT'></th>   <!-- 참조문서일자 -->
												<th CL='STD_DESC02'></th>   <!-- 규격 -->
												<th CL='STD_ASKU01'></th>   <!-- WMS 통합코드 -->
												<th CL='STD_ASKU02'></th>   <!-- 수출(E)/내수(D) -->
												<th CL='STD_ASKU03'></th>   <!-- ERP 오더유형 -->
												<th CL='STD_ASKU04'></th>   <!-- 거래처 입고빈 -->
												<th CL='STD_ASKU05'></th>   <!-- 재질 -->
												<th CL='STD_EANCOD'></th>   <!-- EAN -->
												<th CL='STD_GTINCD'></th>   <!-- UPC -->
												<th CL='STD_SKUG01'></th>   <!-- 품목유형1 -->
												<th CL='STD_SKUG02'></th>   <!-- 품목유형2 -->
												<th CL='STD_SKUG03'></th>   <!-- 품목유형3 -->
												<th CL='STD_SKUG04'></th>   <!-- 품종 -->
												<th CL='STD_SKUG05'></th>   <!-- 모업체품번 -->
												<th CL='STD_GRSWGT'></th>   <!-- 총중량 -->
												<th CL='STD_NETWGT'></th>   <!-- KIT순중량 -->
												<th CL='STD_WGTUNT'></th>   <!-- 중량단위 -->
												<th CL='STD_LENGTH'></th>   <!-- 길이 -->
												<th CL='STD_WIDTHW'></th>   <!-- 가로 -->
												<th CL='STD_HEIGHT'></th>   <!-- 높이 -->
												<th CL='STD_CUBICM'></th>   <!-- CBM -->
												<th CL='STD_CAPACT'></th>   <!-- CAPA -->
												<th CL='STD_QTYORG'></th>   <!-- 실입고량 -->
												<th CL='STD_SMANDT'></th>   <!-- Client -->
												<th CL='STD_SEBELP'></th>   <!-- SAP P/O Item -->
												<th CL='STD_SZMBLNO'></th>  <!-- B/L NO -->
												<th CL='STD_SZMIPNO'></th>  <!-- B/L Item NO -->
												<th CL='STD_STRAID'></th>   <!-- SCM주문번호 -->
												<th CL='STD_SVBELN'></th>   <!-- ECMS 주문번호 -->
												<th CL='STD_SPOSNR'></th>   <!-- ECMS 주문Item -->
												<th CL='STD_STKNUM'></th>   <!-- 총괄계획번호 -->
												<th CL='STD_STPNUM'></th>   <!-- 예약 It -->
												<th CL='STD_SWERKS'></th>   <!-- 출발지 -->
												<th CL='STD_SLGORT'></th>   <!-- 영업 부문 -->
												<th CL='STD_SDATBG'></th>   <!-- 출하계획일시 -->
												<th CL='STD_STDLNR'></th>   <!-- 작업장 -->
												<th CL='STD_SSORNU,2'></th> <!-- 반품출하문서번호 -->
												<th CL='STD_SSORIT,2'></th> <!-- 반품출하 문서아이템 -->
												<th CL='STD_SMBLNR'></th>   <!-- Mat.Doc. -->
												<th CL='STD_SZEILE'></th>   <!-- Mat.Doc. -->
												<th CL='STD_SMJAHR'></th>   <!-- M/D 년도 -->
												<th CL='STD_SXBLNR'></th>   <!-- 인터페이스번호 -->
												<th CL='STD_SBKTXT'></th>   <!-- Text -->
												<th CL='STD_RCPRSN'></th>	<!-- 상세사유 -->			
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
										</colgroup>
										<tbody id="gridListSub">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVIT"></td>	<!-- 입하문서아이템 -->
												<td GCol="text,SKUKEY"></td>	<!-- 품번코드 -->
												<td GCol="text,DESC01"></td>	<!-- 품명 -->
												<td GCol="input,LOCAKY,SCLOCMA_RS" validate="required,VALID_M0404" GF="S 20"></td>	<!-- 지번 -->
												<td GCol="text,ASNQTY" GF="N"></td>	<!-- ASN수량 -->
												<td GCol="input,QTYRCV" validate="required,SYSTEM_M0045 max(GRID_COL_ASNQTY_*),IN_M0077" GF="N 20"></td>   <!-- 입고수량 -->
												<td GCol="text,DUOMKY"></td>   <!-- 단위 -->
												<td GCol="text,QTDUOM"></td>   <!-- 입수 -->
												<td GCol="text,BOXQTY"></td>   <!-- 박스수 -->
												<td GCol="text,REMQTY"></td>   <!-- 잔량 -->
												<td GCol="text,LOTA01" GF="S 20"></td>   <!-- S/N번호 -->
												<td GCol="text,LOTA11" GF="C 8"></td>   <!-- 제조일자 -->
												<td GCol="text,LOTA03"></td>   <!-- 벤더 -->
												<td GCol="text,SEBELN"></td>   <!-- ECMS 주문번호 -->
												<td GCol="text,RECVKY"></td>   <!-- 입하문서번호 -->
												<td GCol="text,STATIT"></td>   <!-- 상태 -->
												<td GCol="text,SAPSTS"></td>   <!-- ERP Mvt -->
												<td GCol="text,LOTNUM"></td>   <!-- Lot no. -->
												<td GCol="text,AREAKY"></td>   <!-- 창고 -->
												<td GCol="text,SECTID"></td>   <!-- Sect.ID -->
												<td GCol="text,TRNUID"></td>   <!-- P/T -->
												<td GCol="text,PACKID"></td>   <!-- SET품번코드 -->
												<td GCol="text,QTYDIF"></td>   <!-- 차이량 -->
												<td GCol="text,QTYUOM"></td>   <!-- Quantity -->
												<td GCol="text,TRUNTY"></td>   <!-- 팔렛타입 -->
												<td GCol="text,MEASKY"></td>   <!-- 단위구성 -->
												<td GCol="text,UOMKEY"></td>   <!-- 단위 -->
												<td GCol="text,QTPUOM"></td>   <!-- Units pe -->
												<td GCol="text,INDRCN"></td>   <!-- 취소됨 -->
												<td GCol="text,CRECVD"></td>   <!-- 입고취소 일자 -->
												<td GCol="text,RSNCOD"></td>   <!-- 사유코드 -->
												<td GCol="text,LOTA01NM"></td> <!-- 영업부분명 -->
												<!-- <td GCol="select,LOTA02">
													<select Combo="WmsInbound,LOTA02COMBO"></select> 재고유형
												</td> -->
												<td GCol="text,LOTA02"></td>   <!-- 사유코드 -->
												<td GCol="text,LOTA04"></td>   <!-- 문서번호 -->
												<td GCol="text,LOTA05"></td>   <!-- 문서번호 -->
												<!-- <td GCol="select,LOTA05">
													<select Combo="WmsInbound,LOTA05COMBO"></select> 재고분류
												</td>   --> <!-- 재고분류 -->
												<td GCol="select,LOTA06">
													<select Combo="WmsInbound,LOTA06COMBO"></select> 
												</td>
												<!-- <td GCol="text,LOTA06"></td>   재고상태 -->
												<td GCol="text,LOTA07"></td>   <!-- LOT속성7 -->
												<td GCol="text,LOTA08"></td>   <!-- LOT속성8 -->
												<td GCol="text,LOTA09"></td>   <!-- LOT속성9 -->
												<td GCol="text,LOTA10"></td>   <!-- LOT속성10 -->
												<td GCol="text,LOTA12" GF="C"></td>   <!-- 입고일자 -->
												<td GCol="text,LOTA13" GF="C"></td>   <!-- 유효기간 -->
												<td GCol="text,LOTA14"></td>   <!-- LOT속성14 -->
												<td GCol="text,LOTA15"></td>   <!-- LOT속성15 -->
												<td GCol="text,LOTA16" GF="N"></td>   <!-- LOT속성16 -->
												<td GCol="text,LOTA17" GF="N"></td>   <!-- LOT속성17 -->
												<td GCol="text,LOTA18"></td>   <!-- LOT속성18 -->
												<td GCol="text,LOTA19"></td>   <!-- LOT속성19 -->
												<td GCol="text,LOTA20"></td>   <!-- LOT속성20 -->
												<td GCol="text,AWMSNO"></td>   <!-- SEQ(ERP) -->
												<td GCol="text,REFDKY"></td>   <!-- 참조문서 -->
												<td GCol="text,REFDIT"></td>   <!-- 참조문서It. -->
												<td GCol="text,REFCAT"></td>   <!-- 참조문서유형 -->
												<td GCol="text,REFDAT"></td>   <!-- 참조문서일자 -->
												<td GCol="text,DESC02"></td>   <!-- 규격 -->
												<td GCol="text,ASKU01"></td>   <!-- WMS 통합코드 -->
												<td GCol="text,ASKU02"></td>   <!-- 수출(E)/내수(D) -->
												<td GCol="text,ASKU03"></td>   <!-- ERP 오더유형 -->
												<td GCol="text,ASKU04"></td>   <!-- 거래처 입고빈 -->
												<td GCol="text,ASKU05"></td>   <!-- 재질 -->
												<td GCol="text,EANCOD"></td>   <!-- EAN -->
												<td GCol="text,GTINCD"></td>   <!-- UPC -->
												<td GCol="text,SKUG01"></td>   <!-- 품목유형1 -->
												<td GCol="text,SKUG02"></td>   <!-- 품목유형2 -->
												<td GCol="text,SKUG03"></td>   <!-- 품목유형3 -->
												<td GCol="text,SKUG04"></td>   <!-- 품종 -->
												<td GCol="text,SKUG05"></td>   <!-- 모업체품번 -->
												<td GCol="text,GRSWGT"></td>   <!-- 총중량 -->
												<td GCol="text,NETWGT"></td>   <!-- KIT순중량 -->
												<td GCol="text,WGTUNT"></td>   <!-- 중량단위 -->
												<td GCol="text,LENGTH"></td>   <!-- 길이 -->
												<td GCol="text,WIDTHW"></td>   <!-- 가로 -->
												<td GCol="text,HEIGHT"></td>   <!-- 높이 -->
												<td GCol="text,CUBICM"></td>   <!-- CBM -->
												<td GCol="text,CAPACT"></td>   <!-- CAPA -->
												<td GCol="text,QTYORG"></td>   <!-- 실입고량 -->
												<td GCol="text,SMANDT"></td>   <!-- Client -->
												<td GCol="text,SEBELP"></td>   <!-- SAP P/O Item -->
												<td GCol="text,SZMBLNO"></td>  <!-- B/L NO -->
												<td GCol="text,SZMIPNO"></td>  <!-- B/L Item NO -->
												<td GCol="text,STRAID"></td>   <!-- SCM주문번호 -->
												<td GCol="text,SVBELN"></td>   <!-- ECMS 주문번호 -->
												<td GCol="text,SPOSNR"></td>   <!-- ECMS 주문Item -->
												<td GCol="text,STKNUM"></td>   <!-- 총괄계획번호 -->
												<td GCol="text,STPNUM"></td>   <!-- 예약 It -->
												<td GCol="text,SWERKS"></td>   <!-- 출발지 -->
												<td GCol="text,SLGORT"></td>   <!-- 영업 부문 -->
												<td GCol="text,SDATBG"></td>   <!-- 출하계획일시 -->
												<td GCol="text,STDLNR"></td>   <!-- 작업장 -->
												<td GCol="text,SSORNU"></td>   <!-- 반품출하문서번호 -->    
												<td GCol="text,SSORIT"></td>   <!-- 반품출하 문서아이템 -->  
												<td GCol="text,SMBLNR"></td>   <!-- Mat.Doc. -->
												<td GCol="text,SZEILE"></td>   <!-- Mat.Doc. -->
												<td GCol="text,SMJAHR"></td>   <!-- M/D 년도 -->
												<td GCol="text,SXBLNR"></td>   <!-- 인터페이스번호 -->
												<td GCol="text,SBKTXT"></td>   <!-- Text -->
												<td GCol="text,RCPRSN"></td>   <!-- 상세사유 -->
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