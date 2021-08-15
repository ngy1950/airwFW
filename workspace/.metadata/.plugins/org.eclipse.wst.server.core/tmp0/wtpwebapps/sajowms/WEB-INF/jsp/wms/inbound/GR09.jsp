<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	//var dblIdx = -1;
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR09",
			validation : "INDRCN,RECVKY",  //공통으로 쓰는 경우 사용
			itemGrid : "gridListSub",
			itemSearch : true
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			module : "WmsInbound",
			command : "GR09Sub"
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridList", true, ['INDRCN']);
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Wcancle"){
			deleteData();
		}else if(btnName == "Print"){
			printList();
		}/* else if(btnName == "Finprint"){
			printFinList();
		} 20160608주석처리 */
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param,
		    	url : "/wms/inbound/json/ebelnGR09.data"
		    });
		}
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
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
			module : "WmsInbound",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		param.put("PRTTYP", "RECV");
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/savePrtseq.data",
			param : param
		});

		var where = "AND PRTSEQ IN ('" + prtseq + "')";

		url = "/ezgen/receiving_list.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 650);
	}
	
	function deleteData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridList", "select")){
			var chkHeadIdx = gridList.getSelectRowNumList("gridList");
			var chkHeadLen = chkHeadIdx.length;	
			if( chkHeadLen == 0 ){
				// 선택된 데이터가 없습니다.
				commonUtil.msgBox("VALID_M0006");
				return;
			} else if (chkHeadLen > 0){
				var list = "";
				var head = gridList.getSelectData("gridList");
				
				var vparam = new DataMap();
				vparam.put("list", head);
				vparam.put("key", "RECVKY,INDRCN");
				var json = netUtil.sendData({
					url : "/wms/inbound/json/validationGR09.data",
					param : vparam
				});
			
				if(json.data != "OK"){
					var msgList = json.data.split(" ");
					var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
					commonUtil.msg(msgTxt);
					return false;
				}else{
				var param = new DataMap();
				param.put("head", head); 
				
				var json = netUtil.sendData({
					url : "/wms/inbound/json/deleteGR09.data",
					param : param
					
				});  
				
				if(json && json.data){
					// 입고가 취소되었습니다.
				   commonUtil.msgBox("VALID_M1560");
				   searchList();
				}else{
					// 입고취소가 실패하였습니다.
					commonUtil.msgBox("VALID_M1561");
				}
			}
		}
	}
	}
		
	
	
	<%-- function printFinList(){
		var url = "";
		var recvky ;
		
		var list = gridList.getSelectRowNumList("gridList");
		
		if(list.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}

		var where =   "AND RH.RECVKY IN (" ;
		for(var i=0 ; i<list.length ; i++){
			recvky = gridList.getColData("gridList", list[i], "RECVKY");
			if(i>0){
				where += ", "
			}
			where += "'" + recvky +"'";
		}
		where += ")";

		url = "/ezgen/receiving_list_fin_height.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);	
		
	} 20160608 주석처리--%>
	
	/* function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			searchSubList(0);
		}
	} */
	
	// subGrid조회시 조회 조건을 생성해줌. excel다운로드시 동일한 조건으로 사용해야 하므로 함수로 별도처리
	/* function getSearchSubParam(headRowNum){
		var data = gridList.getRowData("gridList", headRowNum);
		var param = new DataMap();
		param = inputList.setRangeParam("searchArea");
		param.put("RECVKY", data.get("RECVKY"));
		param.put("WAREKY", data.get("WAREKY"));
		param.put("AREAKY", data.get("AREAKY"));
		
		return param;
	} */
	
	/* function searchSubList(headRowNum){
		var param = getSearchSubParam(headRowNum); // 조회조건을 가져옴. head더블클릭시는 head의 rowNum이 명확하므로 인자로 받아 처리함
		gridList.gridList({
	    	id : "gridListSub",
	    	command : "GR09Sub",
	    	param : param
	    });

		lastFocusNum = rowNum;
	} */
	
	/* function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridList"){
			var param = inputList.setRangeParam("searchArea");
			return param;
		}else if(gridId == "gridListSub" && dblIdx != -1){
			var param = getSearchSubParam(dblIdx); //조회 조건을 가져옴. 엑셀 다운로드시는 head 더블클릭으로 가져온 데이타 이므로 headRow를 저장한 dblIdx 값으로 조회 조건 생성. 화면마다 headRow 저장하는 변수가 다르므로 주의 할것.
			return param;
		}
	} */
	
	//그리드 더블 클릭시 발생하는 이벤트
	//헤더 더블클릭 하면 아이템 뿌려준다.
	/* function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			if(gridList.getColData("gridList", rowNum, "STATUS") == "C"){
				return false;
			}
			dblIdx = rowNum;
			searchSubList(rowNum);
		}
		
	} */
	
	/* function gridListEventRowFocus(gridId, rowNum){
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
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		if(searchCode == "SHDOCTM" || searchCode == "SHASN" || searchCode == "SHSKUMA" || searchCode == "SHBZPTN"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("PTNRTY", "VD");
			<%-- param.put("PTNL05", "<%=ownrky%>"); --%>
			return param;
		}else if(searchCode == "SHCMCDV"){
			var param = new DataMap();
			if($inputObj.name == "S.SKUG01"){
				param.put("CMCDKY", "SKUG01");
			}else{
				param.put("CMCDKY", "LOTA06");
			}
			return param;
		}else if(searchCode == "SHBZPTN2"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("PTNRTY", "CT");
			return param;
		}
	}
	
</script>
</head>
<body>

	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Wcancle WCANCLE BTN_CANCELRCV"></button>
			<button CB="Print PRINT BTN_PRINT3"></button>
			<!-- <button CB="Finprint PRINT BTN_PRINT24"></button>			20160608주석처리 -->
		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
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
							<td colspan="3"><input type="text" name="WAREKY" 
								validate="required,M0434" value="<%=wareky%>"
								readonly="readonly" /></td>
						</tr>
						<tr>
							<th CL="STD_OWNRKY">화주</th>
							<td>
								<input type="text" name="RH.OWNRKY" UIInput="R,SHOWNER" />
							</td>
						</tr>
						<tr>
							<th CL="STD_DOCDAT">전기일자</th>
							<td>
								<input type="text" name="RH.DOCDAT" UIInput="R" UIFormat="C"/>
							</td>
						</tr>
						<!-- <tr>
							<th CL="STD_REFDAT">참조일자</th>
							<td>
								<input type="text" name="RI.REFDAT" UIInput="R" UIFormat="C" />
							</td>
						</tr> -->
						<tr>
							<th CL="STD_ASNDAT,3">입고예정일자</th>
							<td>
								<input type="text" name="RI.REFDAT" UIInput="R" UIFormat="C" />
							</td>
						</tr>
						<tr>
							<th CL="STD_RCPTTY">입하유형</th>
							<td><input type="text" name="RH.RCPTTY" UIInput="R,SHDOCTM" />
							</td>
						</tr>
						<tr>
							<th CL="STD_RECVKY">입고문서번호</th>
							<td>
								<input type="text" name="RH.RECVKY" UIInput="R"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_EBELN">ERP 주문번호</th>
							<td><input type="text" name="RI.SEBELN" UIInput="R" />
						</td>
						</tr>
						<!-- <tr>
							<th CL="STD_AREAKY">창고</th>
							<td>
								<input type="text" name="RI.AREAKY" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_ZONEKY">구역</th>
							<td>
								<input type="text" name="ZM.ZONEKY" UIInput="R,SHZONMA" />
							</td>
						</tr> -->
						<tr>
							<th CL="STD_LOCAKY">지번</th>
							<td>
								<input type="text" name="RI.LOCAKY" UIInput="R,SHLOCMA" />
							</td>
						</tr>
						<tr>
							<th CL="STD_INDRCN">취소여부</th>
							<td>
								<input type="radio" name="Opt" checked="checked" /><label CL="STD_ALL" ></label>
								<input type="radio" name="Opt" value="1" /><label CL="STD_INBOUND" ></label>
								<input type="radio" name="Opt" value="2" /><label CL="STD_CANCEL" ></label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="searchInBox">
				<h2 class="tit type1" CL="STD_CUSTINFO">거래처정보</h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
						<th CL="STD_DPTNKY,3">공급사</th>
						<td>
							<input type="text" name="RH.DPTNKY" UIInput="R,SHBZPTN" />
						</td>
						</tr>
						<tr>
						<th CL="STD_DPTNNM">공급사명</th>
						<td>
							<input type="text" name="VD.NAME01" UIInput="R" />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_SALCOM,3"></th>
						<td>
							<input type="text" name="RH.USRID3" UIInput="R,SHBZPTN2"" />
						</td>
					</tr> -->
					</tbody>
				</table>
			</div>
			<div class="searchInBox">
		<h2 class="tit type1" CL="STD_SKUINFO">품목정보</h2>
		<table class="table type1">
			<colgroup>
				<col width="100" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th CL="STD_SKUKEY">품번코드</th>
					<td><input type="text" name="RI.SKUKEY" UIInput="R,SHSKUMA" /></td>
				</tr>
				<tr>
					<th CL="STD_DESC01"></th>
					<td>
						<input type="text" name="SM.DESC01" UIInput="R" />
					</td>
				</tr>
			</tbody>
		</table>
   	 	</div>
   	 		<div class="searchInBox">
	<h2 class="tit type1" CL="STD_LOTINFO">LOT정보</h2>
	<table class="table type1">
		<colgroup>
			<col width="100" />
			<col />
		</colgroup>
		<tbody>
				<!-- <tr>
					<th CL="STD_LOTA01">공급업체</th>
					<td>
						<input type="text" name="RI.LOTA01" UIInput="R" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOTA02">부서코드</th>
					<td>
						<input type="text" name="DEPART" />
						<input type="text" name="RI.LOTA02" UIInput="R" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOTA03">개별바코드</th>
					<td>
						<input type="text" name="RI.LOTA03" UIInput="R" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOTA06">재고상태</th>
					<td>
						<input type="text" name="RI.LOTA06" UIInput="R,SHCMCDV" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOTA07">Mall SD번호</th>
					<td>
						<input type="text" name="LOTA07" UIInput="R" />
					</td>
				</tr> -->
				<tr>
					<th CL="STD_LOTA11">제조일자</th>
					<td>
						<input type="text" name="RI.LOTA11" UIInput="R" UIFormat="C" />
					</td>
					</tr>
				<tr>
					<th CL="STD_LOTA12">입고일자</th>
					<td>
						<input type="text" name="RI.LOTA12" UIInput="R" UIFormat="C" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOTA13">유효기간</th>
					<td>
						<input type="text" name="RI.LOTA13" UIInput="R" UIFormat="C" />
					</td>
				</tr>
			</tbody>
	</table>
    </div>
		</div>
	</div>
	
<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_RECINQ"><span>입고조회</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" /><!--체크박스  -->
											<col width="40" /><!--rownum  -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<!-- <th CL='STD_SEBELN'>운송지시번호</th> -->
												<!-- <th CL='STD_LOTA07'>MALL SD No.</th> -->
												<!-- <th CL='STD_DOCCATNM'>문서유형</th> -->
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_WAREKYNM'>CenterName</th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_OWNRNM'></th>
												<!-- <th CL='STD_AREAKY'>창고</th> -->
												<!-- <th CL='STD_AREAKYNM'>창고명</th> -->
												<th CL='STD_DOCDAT'>문서일자</th>
												<th CL='STD_ARCPTD'>입하일자</th>
												<th CL='STD_DPTNKY,3'>공급사</th>
												<th CL='STD_DPTNNM'>공급사명</th>
												<!-- <th CL='STD_SALCOM'>판매처 회사코드</th> -->
												<!-- <th CL='STD_SALCOMNM'>판매처 회사명</th> -->
												<!-- <th CL='STD_SALPLT'>판매처 플랜트코드</th> -->
												<!-- <th CL='STD_SALPLTNM'>판매처 플랜트명</th> --> 
												<!-- <th CL='STD_DEPTID4'>FROM창고</th>    -->
												<!-- <th CL='STD_DEPTID4NM'>FROM창고명</th> -->
												<th CL='STD_RCPTTY'>입하유형</th>
												<th CL='STD_RCPTTYNM'>입하유형</th>
												<th CL='STD_RSNCODDT'>취소사유코드</th>
												<th CL='STD_RCPRSNDT'>취소상세사유</th>
												<th CL='STD_INDRCN'>입고취소여부</th>
												<th CL='STD_STATDO'>문서상태</th>
												<th CL='STD_DOCTXT'>비고</th>
												<!-- <th CL='STD_USRID1'></th>     입력자         
												<th CL='STD_UNAME1'></th>     입력자명       
												<th CL='STD_DEPTID1'></th>    입력자 부서    
												<th CL='STD_DEPTID1NM'></th>    입력자 부서    
												<th CL='STD_DNAME1'></th>     입력자 부서명  
												<th CL='STD_USRID2'></th>     업무담당자     
												<th CL='STD_UNAME2'></th>     업무담당자명   
												<th CL='STD_DEPTID2'></th>    업무 부서      
												<th CL='STD_DNAME2'></th>     업무 부서명    
												<th CL='STD_USRID3'></th>     현장담당       
												<th CL='STD_UNAME3'></th>     현장담당자명   
												<th CL='STD_DEPTID3'></th>    현장담당 부서  
												<th CL='STD_DNAME3'></th>     현장담당 부서명
												<th CL='STD_USRID4'></th>     현장책임       
												<th CL='STD_UNAME4'></th>     현장책임자명   
												<th CL='STD_DEPTID4'></th>    현장책임 부서  
												<th CL='STD_DNAME4'></th>     현장책임 부서명 20160608 주석처리-->
												<th CL='STD_CREDAT' GF="D">생성일자</th>
												<th CL='STD_CRETIM' GF="T">생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_CUSRNM'>생성자명</th>
												<th CL='STD_LMODAT' GF="D">수정일자</th>
												<th CL='STD_LMOTIM' GF="T">수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_LUSRNM'>수정자명</th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVKY"></td>
												<!-- <td GCol="text,SEBELN"></td> -->
												<!-- <td GCol="text,LOTA07"></td> -->
												<!-- <td GCol="text,DOCCATNM"></td> -->
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<!-- <td GCol="text,AREAKY"></td> -->
												<!-- <td GCol="text,AREAKYNM"></td> -->
												<td GCol="text,DOCDAT" GF="C"></td>
												<td GCol="text,ARCPTD" GF="C 8"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNKYNM"></td>
												<!-- <td GCol="text,USRID3"></td> -->
												<!-- <td GCol="text,USRID3NM"></td> -->
												<!-- <td GCol="text,DEPTID3"></td> -->
												<!-- <td GCol="text,DEPTID3NM"></td> -->
												<!-- <td GCol="text,DEPTID4"></td> -->
												<!-- <td GCol="text,DEPTID4NM"></td> -->
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="select,RSNCOD" validate="required,MASTER_M0688">
													<select Combo="WmsInbound,GR09RSNCODCOMBO">
														<option value="">Select</option>
													</select> <!-- 사유코드 -->
												</td>
												<td GCol="input,RCPRSN"></td>
												<!-- <td GCol="select,INDRCN">
													<select Combo="WmsInbound,GR09INDRCNCOMBO" >
														<option value=""></option>
													</select> 사유코드
												</td> -->
												<td GCol="check,INDRCN"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,DOCTXT" GF="S 255"></td>
												<!-- <td GCol="text,USRID1"></td>	 
												<td GCol="text,UNAME1"></td>	 
												<td GCol="text,DEPTID1"></td>	 
												<td GCol="text,DEPTID1NM"></td>	 
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
												<td GCol="text,DNAME4"></td>  20160608 주석처리-->
												<td GCol="text,CREDAT" GF="D">생성일자</td>
												<td GCol="text,CRETIM" GF="T">생성시간</td>
												<td GCol="text,CREUSR">생성자</td>
												<td GCol="text,CUSRNM">생성자명</td>
												<td GCol="text,LMODAT" GF="D">수정일자</td>
												<td GCol="text,LMOTIM" GF="T">수정시간</td>
												<td GCol="text,LMOUSR">수정자</td>
												<td GCol="text,LUSRNM">수정자명</td>
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
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
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
												<col width="100" />
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
													<th CL='STD_RECVIT,2'></th><!-- 입하문서아이템 -->
													<th CL='STD_SKUKEY'></th><!-- 품목코드 -->
													<th CL='STD_DESC01'></th><!-- 품명 -->
													<th CL='STD_LOCAKY'></th><!-- Location -->
													<th CL='STD_DUOMKY'></th><!-- 단위 -->
													<th CL='STD_QTDUOM'></th><!-- 입수 -->
													<th CL='STD_BOXQTY'></th><!-- 박스수 -->
													<th CL='STD_REMQTY'></th><!-- 잔량 -->
													<th CL='STD_QTYRCV'></th><!-- 입고수량 -->
													<th CL='STD_QTYORG'></th>
													<!-- <th CL='STD_LOTA01'></th>
													<th CL='STD_LOTA01NMN'></th>
													<th CL='STD_LOTA02'></th>
													<th CL='STD_LOTA02NM'></th>
													<th CL='STD_LOTA03'></th>
													<th CL='STD_LOTA04'></th>
													<th CL='STD_LOTA05'></th> -->
													<th CL='STD_LOTA06'></th>
													<!-- <th CL='STD_LOTA07'></th> -->
													<!-- <th CL='STD_LOTA08'></th>
													<th CL='STD_LOTA09'></th>
													<th CL='STD_LOTA10'></th> -->
													<th CL='STD_LOTA11'></th>
													<th CL='STD_LOTA12'></th>
													<th CL='STD_LOTA13'></th>
													<!-- <th CL='STD_LOTA14'></th>
													<th CL='STD_LOTA15'></th>
													<th CL='STD_LOTA16'></th>
													<th CL='STD_LOTA17'></th>
													<th CL='STD_LOTA18'></th>
													<th CL='STD_LOTA19'></th>
													<th CL='STD_LOTA20'></th> -->
													<th CL='STD_SKUG01'></th>
													<th CL='STD_SKUG02'></th>
													<th CL='STD_SKUG03'></th>
													<th CL='STD_SKUG05'></th>
													<th CL='STD_CREDAT'></th>
													<th CL='STD_CRETIM'></th>
													<th CL='STD_CREUSR'></th>
													<th CL='STD_CUSRNM'></th>
													<th CL='STD_LMODAT'></th>
													<th CL='STD_LMOTIM'></th>
													<th CL='STD_LMOUSR'></th>
													<th CL='STD_LUSRNM'></th>
													<!-- <th CL='STD_ZONEKY'></th> -->
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
											</colgroup>
											<tbody id="gridListSub">
												<tr CGRow="true">
													<td GCol="rownum"></td>
													<td GCol="text,RECVIT"></td><!-- 입하문서아이템 -->
													<td GCol="text,SKUKEY"></td><!-- 품번코드 -->
													<td GCol="text,DESC01"></td><!-- 품명 -->
													<td GCol="text,LOCAKY"></td><!-- Location -->
													<td GCol="text,DUOMKY"></td><!-- 단위 -->
													<td GCol="text,QTDUOM" GF="N"></td><!-- 입수 -->
													<td GCol="text,BOXQTY" GF="N"></td><!-- 박스수 -->
													<td GCol="text,REMQTY" GF="N"></td><!-- 잔량 -->
													<td GCol="text,QTYRCV" GF="N"></td><!-- 입고수량 -->
													<td GCol="text,QTYORG" GF="N">
													<!-- <td GCol="text,LOTA01"></td>
													<td GCol="text,LOTA01NMN"></td>
													<td GCol="text,LOTA02"></td>
													<td GCol="text,LOTA02NM"></td>
													<td GCol="text,LOTA03"></td>
													<td GCol="text,LOTA04"></td>
													<td GCol="text,LOTA05"></td> -->
													<td GCol="select,LOTA06">
														<select Combo="WmsInbound,LOTA06COMBO"></select> 
													</td>
													<!-- <td GCol="text,LOTA07"></td>
													<td GCol="text,LOTA08"></td>
													<td GCol="text,LOTA09"></td>
													<td GCol="text,LOTA10"></td> -->
													<td GCol="text,LOTA11" GF="D"></td>
													<td GCol="text,LOTA12" GF="D"></td>
													<td GCol="text,LOTA13" GF="D"></td>
													<!-- <td GCol="text,LOTA14"></td>
													<td GCol="text,LOTA15"></td>
													<td GCol="text,LOTA16" GF="N 20,3"></td>
													<td GCol="text,LOTA17" GF="N 20,3"></td>
													<td GCol="text,LOTA18" GF="N"></td>
													<td GCol="text,LOTA19" GF="N"></td>
													<td GCol="text,LOTA20" GF="N"></td> -->
													<td GCol="text,SKUG01"></td>
													<td GCol="text,SKUG02"></td>
													<td GCol="text,SKUG03"></td>
													<td GCol="text,SKUG05"></td>
													<td GCol="text,CREDAT" GF="D"></td>
													<td GCol="text,CRETIM" GF="T"></td>
													<td GCol="text,CREUSR"></td>
													<td GCol="text,CUSRNM"></td>
													<td GCol="text,LMODAT" GF="D"></td>
													<td GCol="text,LMOTIM" GF="T"></td>
													<td GCol="text,LMOUSR"></td>
													<td GCol="text,LUSRNM"></td>
													<!-- <td GCol="text,MIPNO"></td> -->
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
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>