<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">

	var searchCnt = 0; 
	var listFlag  = false;
	var dblIdx = -1;
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			pkcol : "WAREKY,RECVKY,RECVIT",
			module : "WmsInbound",
			command : "GR01"
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			pkcol : "WAREKY,RECVKY,RECVIT",
			module : "WmsInbound",
			command : "GR01Sub"
	    });
	});
	
	
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
			
			//searchOpen(false);
		}
	}
	
	
	function gridListEventDataBindEnd(gridId, dataLength){
		//alert(" gridId : " + gridId + "\n dataLength : " + dataLength);

		if( gridId == "gridListHead" && dataLength > 0 ){
			searchSubList(0);
		}
	}
	
	
	function gridListEventRowDblclick(gridId, rowNum){
		//alert(" gridId : " + gridId + "\n dataLength : " + rowNum);
		
		if( gridId == "gridListHead" ){
			searchSubList(rowNum);
		}	
	}
	
	
	function searchSubList(headRowNum){
		var rowVal = gridList.getColData("gridListHead", headRowNum, "ASNDKY");
		
		var param = inputList.setRangeParam("searchArea");
		param.put("ASNDKY", rowVal);
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		//lastFocusNum = headRowNum;
		dblIdx = headRowNum;
	}

		
	//체크박스 선택시 상단리스트 체크시, 하단리스트 체크
	//하단리스트 체크시, 상단리스트 체크
	function gridListEventRowCheck(gridId, rowNum, checkType){
		
		if(gridId == "gridListHead"){
			gridList.checkAll("gridListSub", checkType);
		}else if(gridId == "gridListSub"){
			var chkCount = gridList.getSelectRowNumList("gridListSub").length;
			
			//alert(chkCount);
			//alert(checkType);
			
			if(!checkType){
				if(chkCount == 0){
					gridList.setRowCheck("gridListHead", dblIdx, checkType);
				}
			}else{
				gridList.setRowCheck("gridListHead", dblIdx, checkType);
			}
		}
	}
	
	
	//그리드 위에 클릭시 아이템 리셋
	/*
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridListHead"){
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;	
				}
			}
		}
	}
	*/
	function gridListEventRowFocus(id, rowNum){
		if(id == "gridListHead"){
			
			var modCnt = gridList.getModifyRowCount("gridListSub");
			var chkCnt = gridList.getSelectData("gridListSub").length;
			
			//alert(chkCnt);
			
			//변경 컬럼이 없을 경우
			if( modCnt == 0 && chkCnt == 0 ){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
				
			}else{
				// 저장하시겠습니까?			
				if(commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
					saveData();
				}else{
					//alert(dblIdx);
					gridList.setColFocus("gridListHead", dblIdx , "ASNDKY" );
				
				}
				
				dblIdx = -1;
			}
		}
	}
	
	function validationCheck(){
		
		//alert("11111");
		
		// 여러건일경우
		//var head = gridList.getSelectData("gridList");
		// 한건일 경우
		var head = gridList.getRowData("gridListHead", dblIdx);
		
		
		var list = gridList.getSelectData("gridListSub");
		
		//var param = new DataMap();
		//param.put("head", head);
		//param.put("list", list);
		
		// 입고지시 밸리데이션
		var vparam = new DataMap();
		vparam.put("head", head);
		vparam.put("list", list);
		vparam.put("key", "DOCCAT,DOCUTY,WAREKY,LOCAKY,OWNRKY,DPTNKY,SKUKEY,MEASKY,UOMKEY,QTYRCV,QTYMAX,MANDT,EBELN,EBELP");
		
		//alert("22222");
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/GR02_Validation.data",
			param : vparam
		});
		
		return json;
		
		
	}
	
	
	function saveData(){
		//searchCnt++;
		//체크된 로우의 로우넘 전부 가져오는 함수
		
		var chkHeadLen = gridList.getSelectRowNumList("gridListHead").length;
		var chkHeadIdx = gridList.getSelectRowNumList("gridListHead");
		//alert("체크된 Head 갯수 : " + chkHeadLen);
		
		
		
		var chkItemLen = gridList.getSelectRowNumList("gridListSub").length;
		var rowItemIdx = gridList.getSelectRowNumList("gridListSub");
		//alert("체크된 item 갯수 : " + chkItemLen);
		
		
    		
		if(chkHeadLen == 0 && chkItemLen == 0 ){
			//msg 선택된 데이터가 없습니다.
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		//return;
		
		var json = validationCheck();
		
		
		if(json.data != "OK"){
			var msgList = json.data.split(" ");
			var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
			commonUtil.msg(msgTxt);
			return false;
		}
		
		
		//입하문서번호 - 재조회할때
		var arrDocNum = "";
		
		// 채번
		for(var i = 0; i < chkHeadLen ; i++) {
			
			// [166] 센터간이동입하
			var docunum = wms.getDocSeq("112");
			
			gridList.gridColModify("gridListHead", chkHeadIdx[i], "RECVKY", docunum);
			if(i == 0){
				arrDocNum += docunum;
			}else{
				arrDocNum += "','"+docunum;
			}
		}
		
		
		var head = gridList.getRowData("gridListHead", dblIdx);

		//var list = gridList.getGridData("gridListSub");
    	var list = gridList.getSelectData("gridListSub");
    	//alert("체크된 Item list" + list);
    	
    	
    	
    	
    	//return;
    	
		var param = new DataMap();
		param.put("head", head);
		param.put("list", list);
		
		
		// 인서트시 무결성 제약조건 발생
		var json = netUtil.sendData({
			url : "/wms/inbound/json/GR02_1.data",
			param : param
		});
		
		

		if(json && json.data){
			searchCnt = 1;
			
			
			//alert("저장후 REFRESH 시작");
			//alert("arrDocNum : " + arrDocNum);
			
			var paramH = new DataMap();
			paramH.put("RECVKY", arrDocNum);
			
			var wareky = gridList.getColData("gridListHead", dblIdx, "WAREKY");
			paramH.put("WAREKY", wareky);
			
			
			gridList.gridList({
		    	id : "gridListHead",
		    	command : "GR09H",
		    	param : paramH
		    });
			
			gridList.gridList({
		    	id : "gridListSub",
		    	command : "GR09I",
		    	param : paramH
		    }); 
			
			listFlag = true;
			
			gridList.setReadOnly("gridListHead");
			gridList.setReadOnly("gridListSub");
		}
	}
	
	
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button class="button type1 last" type="button" onclick="searchList()"><img src="/common/images/top_icon_03.png" alt="Search" /></button>
		<span CL='STD_SEARCH'>조회</span>&nbsp;
		<button class="button type1 last" type="button" onclick="saveData()"><img src="/common/images/top_icon_06.png" alt="Save" /></button>
		<span CL='STD_SAVE'>저장</span>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>
<!-- //contentHeader -->

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer" id="searchArea">
		<p class="searchBtn"><input type="submit" class="button type1 widthAuto" value="검색" onclick="searchList()" CL="BTN_DISPLAY"/></p>
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
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" validate="required,M0434" value="PMS0"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입하유형</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,DOCUTY112COMBO" name="RCPTTY"></select>
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDKY">ASN 문서번호</th>
						<td>
							<input type="text" name="ASNDKY" UIInput="R,SHASN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">ASN 생성일</th>
						<td>
							<input type="text" name="DOCDAT" UIInput="R" UIFormat="C 8" />
						</td>
					</tr>
					
					<input type="hidden" name="OWNRKY" value="CMAS" />
					
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
						<th CL="STD_EBELN">SAP P/O No</th>
						<td >
							<input type="text" name="EBELN" UIInput="R" />
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
					<tr>
						<th CL="STD_STRAID">SCM주문번호</th>
						<td >
							<input type="text" name="STRAID" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY">업체코드</th>
						<td >
							<input type="text" name="DPTNKY" UIInput="R,SHBZPTN" />
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
											
											<!-- 
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											 -->											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
																								
												<th CL='STD_RECVKY'></th>	<!-- 입하문서번호 -->
												<th CL='STD_SEBELN'></th>	<!-- ECMS 주문번호 -->
												<th CL='STD_ASNDKY'></th>	<!-- ASN 문서번호 -->
												<th CL='STD_RCPTTYNM'></th>	<!-- 입하유형명 -->
												<th CL='STD_WAREKY'></th>	<!-- 거점 -->
												<th CL='STD_WAREKYNM'></th>	<!-- 거점명 -->
												<th CL='STD_DOCDAT'></th>	<!-- 문서일자 -->
												<th CL='STD_DPTNKY'></th>	<!-- 업체코드 -->
												<th CL='STD_DPTNKYNM'></th>	<!-- 업체코드명 -->
												<th CL='STD_DOCTXT'></th>	<!-- 비고 -->
												
												<th CL='STD_RCPTTY'></th>   <!-- 입하유형 -->
												<th CL='STD_STATDO'></th>   <!-- 문서상태 -->
												<th CL='STD_DOCCAT'></th>   <!-- 문서유형 -->
												<th CL='STD_DOCCATNM'></th> <!-- 문서유형명 -->
												<th CL='STD_ARCPTD'></th>   <!-- 입하일자 -->
												
												<th CL='STD_USRID1'></th>   <!-- 입력자 -->
												<th CL='STD_UNAME1'></th>   <!-- 입력자명 -->
												<th CL='STD_DEPTID1'></th>  <!-- 입력자 부서 -->
												<th CL='STD_DNAME1'></th>   <!-- 입력자 부서명 -->
												
												<th CL='STD_USRID2'></th>   <!-- 업무담당자 -->
												<th CL='STD_UNAME2'></th>   <!-- 업무담당자명 -->
												<th CL='STD_DEPTID2'></th>  <!-- 업무 부서 -->
												<th CL='STD_DNAME2'></th>   <!-- 업무 부서명 -->
												
												<th CL='STD_USRID3'></th>   <!-- 현장담당 -->
												<th CL='STD_UNAME3'></th>   <!-- 현장담당자명 -->
												<th CL='STD_DEPTID3'></th>  <!-- 현장담당 부서 -->
												<th CL='STD_DNAME3'></th>   <!-- 현장담당 부서명 -->
												
												<th CL='STD_USRID4'></th>   <!-- 현장책임 -->
												<th CL='STD_UNAME4'></th>   <!-- 현장책임자명 -->
												<th CL='STD_DEPTID4'></th>  <!-- 현장책임 부서 -->
												<th CL='STD_DNAME4'></th>   <!-- 현장책임 부서명 -->
												
												<th CL='STD_CREDAT'></th>	<!-- 생성일자 -->
												<th CL='STD_CRETIM'></th>	<!-- 생성시간 -->
												<th CL='STD_CREUSR'></th>	<!-- 생성자 -->
												<th CL='STD_CUSRNM'></th>	<!-- 생성자명 -->
												<th CL='STD_LMODAT'></th>	<!-- 수정일자 -->
												<th CL='STD_LMOTIM'></th>	<!-- 수정시간 -->
												<th CL='STD_LMOUSR'></th>	<!-- 수정자 -->
												<th CL='STD_LUSRNM'></th>	<!-- 수정자명 -->

												
												<!-- <th CL='STD_SAPSTS'></th> -->	<!-- ERP Mvt -->
												<!-- <th CL='STD_DRELIN'></th> -->	<!-- 문서연관구분자 -->
												<!-- <th CL='STD_OWNRKY'></th> -->	<!-- 화주 -->
												<!-- <th CL='STD_INDRCN'></th> -->	<!-- 취소됨 -->
												<!-- <th CL='STD_CRECVD'></th> -->	<!-- 입고취소 일자 -->
												<!-- <th CL='STD_RSNCOD'></th> -->	<!-- 사유코드 -->
												<!-- <th CL='STD_PUTSTS'></th> -->	<!-- 입고상태 -->
												<!-- <th CL='STD_LGORT'></th> -->	<!-- Fr.ERP창고 -->
												<!-- <th CL='STD_LGORTNM'></th> -->	<!-- Fr.ERP창고명 -->
												
												
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
												<td GCol="text,RECVKY"></td>   <!-- 입하문서번호 -->
												<td GCol="text,SEBELN"></td>   <!-- ECMS 주문번호 -->
												<td GCol="text,ASNDKY"></td>   <!-- ASN 문서번호 -->    
												<td GCol="text,RCPTTYNM"></td> <!-- 입하유형명 -->
												<td GCol="text,WAREKY"></td>   <!-- 거점 -->
												<td GCol="text,DOCDAT"></td>   <!-- 문서일자 -->      
												<td GCol="text,DPTNKY"></td>   <!-- 업체코드 -->      
												<td GCol="text,DPTNKYNM"></td> <!-- 업체코드명 -->     
												<td GCol="text,DOCTXT"></td>   <!-- 비고 -->        
												<td GCol="text,USRID3"></td>   <!-- 현장담당 -->      
												<td GCol="text,UNAME3"></td>   <!-- 현장담당자명 -->    
												<td GCol="text,WAREKYNM"></td> <!-- 거점명 -->       
												<td GCol="text,RCPTTY"></td>   <!-- 입하유형 -->      
												<td GCol="text,STATDO"></td>   <!-- 문서상태 -->      
												<td GCol="text,SAPSTS"></td>   <!-- ERP Mvt -->   
												<td GCol="text,DOCCAT"></td>   <!-- 문서유형 -->      
												<td GCol="text,DOCCATNM"></td> <!-- 문서유형명 -->     
												<td GCol="text,DRELIN"></td>   <!-- 문서연관구분자 -->   
												<td GCol="text,ARCPTD"></td>   <!-- 입하일자 -->      
												<td GCol="text,OWNRKY"></td>   <!-- 화주 -->        
												<td GCol="text,INDRCN"></td>   <!-- 취소됨 -->       
												<td GCol="text,CRECVD"></td>   <!-- 입고취소 일자 -->   
												<td GCol="text,RSNCOD"></td>   <!-- 사유코드 -->      
												<td GCol="text,PUTSTS"></td>   <!-- 입고상태 -->      
												<td GCol="text,LGORT"></td>    <!-- Fr.ERP창고 -->  
												<td GCol="text,LGORTNM"></td>  <!-- Fr.ERP창고명 --> 
												<td GCol="text,USRID1"></td>   <!-- 입력자 -->       
												<td GCol="text,UNAME1"></td>   <!-- 입력자명 -->      
												<td GCol="text,DEPTID1"></td>  <!-- 입력자 부서 -->    
												<td GCol="text,DNAME1"></td>   <!-- 입력자 부서명 -->   
												<td GCol="text,USRID2"></td>   <!-- 업무담당자 -->     
												<td GCol="text,UNAME2"></td>   <!-- 업무담당자명 -->    
												<td GCol="text,DEPTID2"></td>  <!-- 업무 부서 -->     
												<td GCol="text,DNAME2"></td>   <!-- 업무 부서명 -->    
												<td GCol="text,DEPTID3"></td>  <!-- 현장담당 부서 -->   
												<td GCol="text,DNAME3"></td>   <!-- 현장담당 부서명 -->  
												<td GCol="text,USRID4"></td>   <!-- 현장책임 -->      
												<td GCol="text,UNAME4"></td>   <!-- 현장책임자명 -->    
												<td GCol="text,DEPTID4"></td>  <!-- 현장책임 부서 -->   
												<td GCol="text,DNAME4"></td>   <!-- 현장책임 부서명 -->  
											</tr>							
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button" GBtnCheck="true"><img src="/common/images/grid_icon_01.png" alt="CheckAll" /></button>									
									<button class="button type4" type="button" GBtnFind="true"><img src="/common/images/grid_icon_03.png" alt="Find" /></button>
									<button class="button type4" type="button" GBtnLayout="true"><img src="/common/images/grid_icon_07.png" alt="Layout" /></button>
									<button class="button type4" type="button" GBtnTotal="true"><img src="/common/images/grid_icon_08.png" alt="Total" /></button>
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
					<ul class="tab type2">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_RECVIT,2'></th> <!-- 입하문서아이템 -->
												<th CL='STD_SKUKEY'></th>   <!-- 품번코드 -->
												<th CL='STD_DESC01'></th>   <!-- 품명 -->
												<th CL='STD_LOCAKY'></th>   <!-- 지번 -->
												<th CL='STD_ASNQTY'></th>   <!-- ASN수량 -->
												<th CL='STD_QTYRCV'></th>   <!-- 입고수량 -->
												<th CL='STD_DUOMKY'></th>   <!-- 단위 -->
												<th CL='STD_QTDUOM'></th>   <!-- 입수 -->
												<th CL='STD_BOXQTY'></th>   <!-- 박스수 -->
												<th CL='STD_REMQTY'></th>   <!-- 잔량 -->
												<th CL='STD_LOTA01'></th>   <!-- S/N번호 -->
												<th CL='STD_LOTA11'></th>   <!-- 제조일자 -->
												<th CL='STD_LOTA03'></th>   <!-- 벤더 -->
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
												<th CL='STD_QTPUOM'></th>   <!-- Unitys pe -->
												<th CL='STD_INDRCN'></th>   <!-- 취소됨 -->
												<th CL='STD_CRECVD'></th>   <!-- 입고취소 일자 -->
												<th CL='STD_RSNCOD'></th>   <!-- 사유코드 -->
												<th CL='STD_LOTA01NM'></th> <!-- 영업부문명 -->
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
												<th CL='STD_SEBELN'></th>   <!-- ECMS 주문번호 -->
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
												<th CL='STD_SSORNU,2'></th>   <!-- 반품출하문서번호 -->
												<th CL='STD_SSORIT,2'></th>   <!-- 반품출하 문서아이템 -->
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
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVIT"></td>  <!-- 입하문서아이템 -->        
												<td GCol="text,SKUKEY"></td>  <!-- 품번코드 -->           
												<td GCol="text,DESC01"></td>  <!-- 품명 -->             
												<td GCol="input,LOCAKY"></td>  <!-- 지번 -->             
												<td GCol="text,ASNQTY"></td>  <!-- ASN수량 -->          
												<td GCol="input,QTYRCV" validate="max(GRID_COL_QTYRCV_*)"></td>  <!-- 입고수량 -->           
												<td GCol="text,DUOMKY"></td>  <!-- 단위 -->             
												<td GCol="text,QTDUOM"></td>  <!-- 입수 -->             
												<td GCol="text,BOXQTY"></td>  <!-- 박스수 -->            
												<td GCol="text,REMQTY"></td>  <!-- 잔량 -->             
												<td GCol="text,LOTA01"></td>  <!-- S/N번호 -->          
												<td GCol="text,LOTA11"></td>  <!-- 제조일자 -->           
												<td GCol="text,LOTA03"></td>  <!-- 벤더 -->             
												<td GCol="text,RECVKY"></td>  <!-- 입하문서번호 -->         
												<td GCol="text,STATIT"></td>  <!-- 상태 -->             
												<td GCol="text,SAPSTS"></td>  <!-- ERP Mvt -->        
												<td GCol="text,LOTNUM"></td>  <!-- Lot no. -->        
												<td GCol="text,AREAKY"></td>  <!-- 창고 -->             
												<td GCol="text,SECTID"></td>  <!-- Sect.ID -->        
												<td GCol="text,TRNUID"></td>  <!-- P/T -->            
												<td GCol="text,PACKID"></td>  <!-- SET품번코드 -->        
												<td GCol="text,QTYDIF"></td>  <!-- 차이량 -->            
												<td GCol="text,QTYUOM"></td>  <!-- Quantity -->       
												<td GCol="text,TRUNTY"></td>  <!-- 팔렛타입 -->           
												<td GCol="text,MEASKY"></td>  <!-- 단위구성 -->           
												<td GCol="text,UOMKEY"></td>  <!-- 단위 -->             
												<td GCol="text,QTPUOM"></td>  <!-- Unitys pe -->      
												<td GCol="text,INDRCN"></td>  <!-- 취소됨 -->            
												<td GCol="text,CRECVD"></td>  <!-- 입고취소 일자 -->        
												<td GCol="text,RSNCOD"></td>  <!-- 사유코드 -->           
												<td GCol="text,LOTA01NM"></td><!-- 영업부문명 -->          
												<td GCol="text,LOTA02"></td>  <!-- 재고유형 -->           
												<td GCol="text,LOTA04"></td>  <!-- 문서번호 -->           
												<td GCol="text,LOTA05"></td>  <!-- 재고분류 -->           
												<td GCol="text,LOTA06"></td>  <!-- 재고상태 -->           
												<td GCol="text,LOTA07"></td>  <!-- LOT속성7 -->         
												<td GCol="text,LOTA08"></td>  <!-- LOT속성8 -->         
												<td GCol="text,LOTA09"></td>  <!-- LOT속성9 -->         
												<td GCol="text,LOTA10"></td>  <!-- LOT속성10 -->        
												<td GCol="text,LOTA12"></td>  <!-- 입고일자 -->           
												<td GCol="text,LOTA13"></td>  <!-- 유효기간 -->           
												<td GCol="text,LOTA14"></td>  <!-- LOT속성14 -->        
												<td GCol="text,LOTA15"></td>  <!-- LOT속성15 -->        
												<td GCol="text,LOTA16"></td>  <!-- LOT속성16 -->        
												<td GCol="text,LOTA17"></td>  <!-- LOT속성17 -->        
												<td GCol="text,LOTA18"></td>  <!-- LOT속성18 -->        
												<td GCol="text,LOTA19"></td>  <!-- LOT속성19 -->        
												<td GCol="text,LOTA20"></td>  <!-- LOT속성20 -->        
												<td GCol="text,AWMSNO"></td>  <!-- SEQ(ERP) -->       
												<td GCol="text,REFDKY"></td>  <!-- 참조문서 -->           
												<td GCol="text,REFDIT"></td>  <!-- 참조문서It. -->        
												<td GCol="text,REFCAT"></td>  <!-- 참조문서유형 -->         
												<td GCol="text,REFDAT"></td>  <!-- 참조문서일자 -->         
												<td GCol="text,DESC02"></td>  <!-- 규격 -->             
												<td GCol="text,ASKU01"></td>  <!-- WMS 통합코드 -->       
												<td GCol="text,ASKU02"></td>  <!-- 수출(E)/내수(D) -->    
												<td GCol="text,ASKU03"></td>  <!-- ERP 오더유형 -->       
												<td GCol="text,ASKU04"></td>  <!-- 거래처 입고빈 -->        
												<td GCol="text,ASKU05"></td>  <!-- 재질 -->             
												<td GCol="text,EANCOD"></td>  <!-- EAN -->            
												<td GCol="text,GTINCD"></td>  <!-- UPC -->            
												<td GCol="text,SKUG01"></td>  <!-- 품목유형1 -->          
												<td GCol="text,SKUG02"></td>  <!-- 품목유형2 -->          
												<td GCol="text,SKUG03"></td>  <!-- 품목유형3 -->          
												<td GCol="text,SKUG04"></td>  <!-- 품종 -->             
												<td GCol="text,SKUG05"></td>  <!-- 모업체품번 -->          
												<td GCol="text,GRSWGT"></td>  <!-- 총중량 -->            
												<td GCol="text,NETWGT"></td>  <!-- KIT순중량 -->         
												<td GCol="text,WGTUNT"></td>  <!-- 중량단위 -->           
												<td GCol="text,LENGTH"></td>  <!-- 길이 -->             
												<td GCol="text,WIDTHW"></td>  <!-- 가로 -->             
												<td GCol="text,HEIGHT"></td>  <!-- 높이 -->             
												<td GCol="text,CUBICM"></td>  <!-- CBM -->            
												<td GCol="text,CAPACT"></td>  <!-- CAPA -->           
												<td GCol="text,QTYORG"></td>  <!-- 실입고량 -->           
												<td GCol="text,SMANDT"></td>  <!-- Client -->         
												<td GCol="text,SEBELN"></td>  <!-- ECMS 주문번호 -->      
												<td GCol="text,SEBELP"></td>  <!-- SAP P/O Item -->   
												<td GCol="text,SZMBLNO"></td> <!-- B/L NO -->         
												<td GCol="text,SZMIPNO"></td> <!-- B/L Item NO -->    
												<td GCol="text,STRAID"></td>  <!-- SCM주문번호 -->        
												<td GCol="text,SVBELN"></td>  <!-- ECMS 주문번호 -->      
												<td GCol="text,SPOSNR"></td>  <!-- ECMS 주문Item -->    
												<td GCol="text,STKNUM"></td>  <!-- 총괄계획번호 -->         
												<td GCol="text,STPNUM"></td>  <!-- 예약 It -->          
												<td GCol="text,SWERKS"></td>  <!-- 출발지 -->            
												<td GCol="text,SLGORT"></td>  <!-- 영업 부문 -->          
												<td GCol="text,SDATBG"></td>  <!-- 출하계획일시 -->         
												<td GCol="text,STDLNR"></td>  <!-- 작업장 -->            
												<td GCol="text,SSORNU"></td>  <!-- 반품출하문서번호 -->       
												<td GCol="text,SSORIT"></td>  <!-- 반품출하 문서아이템 -->     
												<td GCol="text,SMBLNR"></td>  <!-- Mat.Doc. -->       
												<td GCol="text,SZEILE"></td>  <!-- Mat.Doc. -->       
												<td GCol="text,SMJAHR"></td>  <!-- M/D 년도 -->         
												<td GCol="text,SXBLNR"></td>  <!-- 인터페이스번호 -->        
												<td GCol="text,SBKTXT"></td>  <!-- Text -->           
												<td GCol="text,RCPRSN"></td>  <!-- 상세사유 -->	        
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button" GBtnCheck="true"><img src="/common/images/grid_icon_01.png" alt="CheckAll" /></button>									
									<button class="button type4" type="button" GBtnFind="true"><img src="/common/images/grid_icon_03.png" alt="Find" /></button>
									<button class="button type4" type="button" GBtnLayout="true"><img src="/common/images/grid_icon_07.png" alt="Layout" /></button>
									<button class="button type4" type="button" GBtnTotal="true"><img src="/common/images/grid_icon_08.png" alt="Total" /></button>
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