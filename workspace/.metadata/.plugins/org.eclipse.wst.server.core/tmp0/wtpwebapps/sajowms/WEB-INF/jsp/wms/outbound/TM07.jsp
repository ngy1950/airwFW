<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	
	//var searchCnt = 0;
	//var listFlag  = false;
	var dblIdx = -1;

	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsOutbound",
			command : "TM07",
			validation : "WAREKY"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsOutbound",
			command : "TM07Sub",
			validation : "WAREKY"
	    });
	});
	
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
		}
	}

	
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridListHead" && dataLength > 0 ){
			searchSubList(0);
		}
	}
	

	function gridListEventRowDblclick(gridId, rowNum){
		if( gridId == "gridListHead" ){
			searchSubList(rowNum);
		}	
	}
	
	
	function searchSubList(headRowNum){
		var rowVal  = gridList.getColData("gridListHead", headRowNum, "VBELN");
		
		var param = inputList.setRangeParam("searchArea");
		param.put("VBELN", rowVal);
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		dblIdx = headRowNum;
	}
	
			
	function deleteData(){
		
		//헤더 선택 후, 삭제하면 아이템리스트도 일괄 삭제 되야함.
		var chkHeadLen = gridList.getSelectRowNumList("gridListHead").length;
		var chkHeadIdx = gridList.getSelectRowNumList("gridListHead");
		
		var head = gridList.getSelectData("gridListHead");
		
		if( chkHeadLen == 0 ){
			// 선택된 데이터가 없습니다.
			commonUtil.msgBox("VALID_M0006");
			return;
			
		}else{
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
				return;
				
			}else{
				var param = new DataMap();
				
				param.put("head", head);
				
				var json = netUtil.sendData({
					url : "/wms/outbound/json/TM07_Delete.data",
					param : param
				});
				
				if(json && json.data){
					gridList.resetGrid("gridListHead");
					gridList.resetGrid("gridListSub");
					searchList();
				}
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		 if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Delete"){
			deleteData();
		}
	}
	
</script>

</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Delete DELETE BTN_DELETE">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>
<!-- //contentHeader -->

<!-- searchPop -->
<div class="searchPop">
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
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input name="WAREKY" UIInput="S,SHWAHMA" validate="required,MASTER_M0434" value="<%=wareky%>"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_WADAT">출고요청일</th>
						<td>
							<input type="text" name="BEDAT" UIInput="R" UIFormat="C 8" />
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
			<!-- <div class="bottomSect type1"> -->
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
											<!-- <col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												
												<th Cl='STD_VBELN'></th>	<!-- ECMS 주문Item -->
												<!-- <th Cl='STD_BWART'></th> -->	<!-- 이동유형 -->
												<th Cl='STD_WADAT'></th>	<!-- 출고요청일 -->
												<th Cl='STD_WAREKY'></th>	<!-- 거점 -->
												<!-- <th Cl='STD_USRID1'></th> -->	<!-- 입력자 -->
												<th Cl='STD_WARETG'></th>	<!-- To 거점 -->
												<th Cl='STD_DEPTID1'></th>	<!-- 입력자 부서 -->
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
											<!-- <col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												
												<td GCol="text,VBELN"></td>
												<!-- <td GCol="text,BWART"></td> -->
												<td GCol="text,WADAT"></td>        
												<td GCol="text,WAREKY"></td>
												<!-- <td GCol="text,USRID1"></td> -->
												<td GCol="text,WARETG"></td>
												<td GCol="text,DEPTID1"></td>
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
											
											<!-- 
											<col width="150" />
											<col width="150" />
											 -->
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												
												<!-- <th Cl='STD_MANDT'></th> -->	<!-- Client -->
												<!-- <th Cl='STD_SEQNO'></th> -->	<!-- Seq.No -->
												<th Cl='STD_EBELN'></th>	<!-- SAP P/O No -->
												<th Cl='STD_EBELP'></th>	<!-- ERP P/O Item -->
												<th Cl='STD_LIFNR'></th>	<!-- 업체코드 -->
												<th Cl='STD_BWART'></th>	<!-- 이동유형 -->
												<th Cl='STD_BEDAT'></th>	<!-- 구매증빙일  -->
												<th Cl='STD_ZEKKO_AEDAT'></th>	<!-- 레코드생성일 -->
												<th Cl='STD_LOEKZ'></th>	<!-- 삭제지시자 -->
												<th Cl='STD_MATNR'></th>	<!-- 품번코드 -->
												 
												<th Cl='STD_MAKTX_K'></th>
												<th Cl='STD_MAKTX_E'></th>
												<th Cl='STD_MAKTX_C'></th>
												<th Cl='STD_MENGE'></th>	<!-- 수량 -->
												<th Cl='STD_MEINS'></th>	<!-- 기본 단위 -->
												<th Cl='STD_WERKS'></th>	<!-- 거점 -->
												<th Cl='STD_LGORT'></th>	<!-- Fr.ERP창고 -->
												<th Cl='STD_EINDT'></th>	<!-- 납품일 -->
												<th Cl='STD_ZEKPO_AEDAT'></th>	<!-- 자재변경일 -->
												<th Cl='STD_MENGE_B'></th>	<!-- 기입고수량 -->
												
												<th Cl='STD_MENGE_R'></th>	<!-- 구매오더잔량 -->
												<th Cl='STD_BWTAR'></th>	<!-- 영업부문 -->
												<th Cl='STD_VGBEL'></th>	<!-- 고객 P/O번호 -->
												<th Cl='STD_VGPOS'></th>	<!-- 참조자재번호 -->
												<th Cl='STD_VGDAT'></th>
												<th Cl='STD_ELIKZ'></th>	<!-- 납품완료지시자 -->
												<th Cl='STD_STATUS'></th>	<!-- 상태 -->
												<th Cl='STD_TDATE'></th>	<!-- 전송일자 -->
												<th Cl='STD_CDATE'></th>	<!-- 처리일자 -->
												<th Cl='STD_IFFLG'></th>	<!-- IF유무 -->
												
												<th Cl='STD_ERTXT'></th>	<!-- 에러 메시지 -->
												<th Cl='STD_WAREKY'></th>	<!-- 거점 -->
												<th Cl='STD_SKUKEY'></th>	<!-- 품번코드 -->
												<th Cl='STD_DESC01'></th>	<!-- 품명 -->
												<th Cl='STD_DESC02'></th>	<!-- 규격 -->
												<th Cl='STD_USRID1'></th>	<!-- 입력자 -->
												<th Cl='STD_DEPTID1'></th>	<!-- 입력자 부서 -->
												<th Cl='STD_USRID2'></th>	<!-- 업무담당자 -->
												<th Cl='STD_DEPTID2'></th>	<!-- 업무 부서 -->
												<th Cl='STD_USRID3'></th>	<!-- 현장담당 -->
												
												<th Cl='STD_DEPTID3'></th>	<!-- 현장담당 부서 -->
												<th Cl='STD_USRID4'></th>	<!-- 현장책임 -->
												<th Cl='STD_DEPTID4'></th>	<!-- 현장책임 부서 -->
												<th Cl='STD_CREDAT'></th>	<!-- 생성일자 -->
												<th Cl='STD_CRETIM'></th>	<!-- 생성시간 -->
												<th Cl='STD_LMODAT'></th>	<!-- 수정일자 -->
												<th Cl='STD_LMOTIM'></th>	<!-- 수정시간 -->
												
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											
											<!-- 
											<col width="150" />
											<col width="150" />
											 -->
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
										</colgroup>
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												
												<!-- <td GCol="text,MANDT"></td> -->
												<!-- <td GCol="text,SEQNO"></td> -->
												<td GCol="text,EBELN"></td>
												<td GCol="text,EBELP"></td>
												<td GCol="text,LIFNR"></td>
												<td GCol="text,BWART"></td>
												<td GCol="text,BEDAT"></td>
												<td GCol="text,ZEKKO_AEDAT"></td>
												<td GCol="text,LOEKZ"></td>
												<td GCol="text,MATNR"></td>
												
												<td GCol="text,MAKTX_K"></td>
												<td GCol="text,MAKTX_E"></td>
												<td GCol="text,MAKTX_C"></td>
												<td GCol="text,MENGE"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,LGORT"></td>
												<td GCol="text,EINDT"></td>
												<td GCol="text,ZEKPO_AEDAT"></td>
												<td GCol="text,MENGE_B"></td>
												
												<td GCol="text,MENGE_R"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,VGBEL"></td>
												<td GCol="text,VGPOS"></td>
												<td GCol="text,VGDAT"></td>
												<td GCol="text,ELIKZ"></td>
												<td GCol="text,STATUS"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												
												<td GCol="text,ERTXT"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,USRID1"></td>
												<td GCol="text,DEPTID1"></td>
												<td GCol="text,USRID2"></td>
												<td GCol="text,DEPTID2"></td>
												<td GCol="text,USRID3"></td>
												
												<td GCol="text,DEPTID3"></td>
												<td GCol="text,USRID4"></td>
												<td GCol="text,DEPTID4"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												
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