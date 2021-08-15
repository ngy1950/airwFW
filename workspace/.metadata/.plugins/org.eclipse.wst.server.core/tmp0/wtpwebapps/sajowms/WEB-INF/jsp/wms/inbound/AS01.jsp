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
			//pkcol : "WAREKY,SEBELN,ASNDIT,ASNTTY",
			module : "WmsInbound",
			command : "AS01",
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			//pkcol : "WAREKY,SEBELN,ASNDIT,ASNTTY",
			module : "WmsInbound",
			command : "AS01Sub"
	    });
	});
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Save"){
			saveData();
		}
		else if(btnName == "Search"){
			searchList();
		} 
	}
	
	function searchList(){
		searchFlag = 1;
		
		uiList.setActive("Save", true);
		gridList.setReadOnly("gridListHead", false);
		gridList.setReadOnly("gridListSub", false);
		
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
		searchFlag = 2;
		
		var doccat = gridList.getColData("gridListHead", 0, "DOCCAT");
		var asntty = gridList.getColData("gridListHead", 0, "ASNTTY");
		paramH.put("DOCCAT",doccat);
		paramH.put("ASNTTY",asntty);
		
		gridList.gridList({
			id : "gridListHead",
			command : "AS01H",
			param : paramH
	    });  
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridListHead" && dataLength > 0 ){
			if(searchFlag == 1){
				searchSubList(0);
			}else if(searchFlag == 2){
				reSearchSubList(0);
			}
		}
	}
	
	function searchSubList(headRowNum){
		
		var rowVal = gridList.getColData("gridListHead", headRowNum, "SEBELN");
		var rowOwn = gridList.getColData("gridListHead", headRowNum, "OWNRKY");
		var param = new DataMap();
		
		param.put("SEBELN", rowVal);
		param.put("OWNRKY", rowOwn);
		param.put("WAREKY", "<%= wareky%>");
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		dblIdx = headRowNum;
		subIdx = headRowNum;
	}
	
	function reSearchSubList(headRowNum){
		var rowVal = gridList.getColData("gridListHead", headRowNum, "ASNDKY");
		var paramI = new DataMap();
		paramI.put("ASNDKY", rowVal);
		
		gridList.gridList({
			id : "gridListSub",
			command : "AS01I",
			param : paramI
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
			}else if(modRowCnt > 0 && dblIdx != -1){
				if(commonUtil.msgConfirm("COMMON_M0462")){
					gridList.resetGrid("gridListSub");
					gridList.setColFocus("gridListHead", rowNum, "DOCDAT");
				}else{
					gridList.setRowFocus("gridListHead", dblIdx, false);
					gridList.setColFocus("gridListSub", 0, "QTYASN");
					return false;
				}
			}
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		//commonUtil.debugMsg("gridListEventColValueChange : ", arguments);
		if( gridId == "gridListHead" || gridId == "gridListSub" ){
			uiList.setActive("Save", true);
		}
	}

	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridListSub", "modify")){
			var chkHeadIdx = gridList.getSelectRowNumList("gridListHead");
			var chkHeadLen = chkHeadIdx.length;			
			var itemModCnt = gridList.getModifyRowCount("gridListSub");
			
			if( chkHeadLen == 0 ){
				// 선택된 데이터가 없습니다.
				commonUtil.msgBox("VALID_M0006");
				return;
			} else if (chkHeadLen > 0){
				for(var i = 0 ; i < chkHeadLen ; i ++){
					var paramV = new DataMap();
					
					var valSebeln = gridList.getColData("gridListHead", i, "SEBELN");
					var valOwnrky = gridList.getColData("gridListHead", i, "OWNRKY");
					paramV.put("EBELN", valSebeln);
					paramV.put("WAREKY", "<%= wareky%>");
					paramV.put("OWNRKY", valOwnrky);
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "SKUval",
						sendType : "map",
						param : paramV
					});
					
					var ebeln = json.data["EBELN"];
					//alert(ebeln);
					
					if (json.data["SKU_CNT"] > 0) {
						commonUtil.msgBox("구매오더번호"+ebeln+"의 품번코드이 입력되지 않았습니다.");
						return;
					}else if (json.data["MEA_CNT"] > 0) {
						commonUtil.msgBox("구매오더번호"+ebeln+"의 단위구성이 입력되지 않았습니다.");
						return;
					}
				}
				
				var list = "";
				if(itemModCnt > 0 && dblIdx == subIdx){
					var head = gridList.getRowData("gridListHead", dblIdx);
					list = gridList.getGridData("gridListSub");
					
					headSebeln = gridList.getColData("gridListHead", dblIdx, "SEBELN");
				}
				
				var head = gridList.getSelectData("gridListHead");
				
				var param = new DataMap();
				param.put("head", head); 
				param.put("list", list);
				//param.put("docArray", docArray);
				param.put("headSebeln", headSebeln);
				
				var json = netUtil.sendData({
					url : "/wms/inbound/json/SaveAS01.data",
					param : param
				});  
				
				if(json && json.data){
					commonUtil.msgBox("MASTER_M0564");
					paramH.put("ASNDKY", json.data["ASNDKY"]);
					paramH.put("WAREKY", "<%= wareky%>");
						
					dblIdx = -1;
					
					uiList.setActive("Save", false);
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
		if(searchCode == "SHBZPTN"){
			var param = new DataMap();
			param.put("WAREKY", <%= wareky%>);
			param.put("OWNRKY", "<%= ownrky%>");
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
							<input type="text" name="WAREKY" validate="required,MASTER_M0434" value="<%=wareky%>" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY" style="width: 150px;">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNTTY">ASN 타입</th>
						<td>
							<select name="ASNTTY" id="ANSTTY" style="width: 150px;">
								<option value="051">[051] 입하예정(벤더)</option>
							</select>
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
						<th CL="STD_SEBELN">구매오더번호</th>
						<td >
							<input type="text" name="EBELN" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_AEDAT">ERP P/O 생성일</th>
						<td >
							<input type="text" name="IFWMS103.ZEKKO_AEDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY,3">공급사</th>
						<td>
							<input type="text" name="LIFNR" UIInput="R,SHBZPTN" />
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
											<col width="200" />
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												
												<th CL='STD_SEBELN'></th>	<!-- 구매오더번호 -->
												<th CL='STD_ASNDKY'></th>	<!-- ASN 문서번호 -->
												<th CL='STD_WAREKY'></th>	<!-- 거점 -->
												<th CL='STD_WAREKYNM'></th>	<!-- 거점명 -->
												<th CL='STD_ASNTTY'></th>	<!-- ASN 타입 -->
												<th CL='STD_ASNTTYNM'></th>	<!-- ASN 타입명 -->
												<th CL='STD_STATDO'></th>	<!-- 문서상태 -->
												<th CL='STD_DOCDAT'></th>	<!-- 문서일자 -->
												<th CL='STD_DOCCAT'></th>	<!-- 문서유형 -->
												<th CL='STD_DOCCATNM'></th>	<!-- 문서유형명 -->
												
												<th Cl='STD_OWNRKY'></th>	<!-- 화주 -->
												<th Cl='STD_DPTNKY'></th>	<!-- 업체코드 -->
												<th Cl='STD_DPTNKYNM'></th>	<!-- 업체코드명 -->
												<th Cl='STD_DRELIN'></th>	<!-- 문서연관구분자 -->
												<th Cl='STD_PRCPTD'></th>	<!-- 입고계획일자 -->
												<th Cl='STD_LRCPTD'></th>	<!-- 최종입하일자 -->
												<th Cl='STD_INDDCL'></th>	<!-- 송장발행 -->
												<th Cl='STD_RSNCOD'></th>	<!-- 사유코드 -->
												<th Cl='STD_RSNRET'></th>	<!-- 반품사유코드 -->
												<th Cl='STD_QTYASN'></th>	<!-- 예정량 -->
												
												<th Cl='STD_QTYRCV'></th>	<!-- 입고수량 -->
<!-- 												<th Cl='STD_LGORT'></th>	Fr.ERP창고 -->
<!-- 												<th Cl='STD_LGORTNM'></th>	Fr.ERP창고명 -->
<!-- 												<th Cl='STD_USRID1'></th>	입력자 -->
<!-- 												<th Cl='STD_UNAME1'></th>	입력자명 -->
<!-- 												<th Cl='STD_DEPTID1'></th>	입력자 부서 -->
<!-- 												<th Cl='STD_DNAME1'></th>	입력자 부서명 -->
<!-- 												<th Cl='STD_USRID2'></th>	업무담당자 -->
<!-- 												<th Cl='STD_UNAME2'></th>	업무담당자명 -->
<!-- 												<th Cl='STD_DEPTID2'></th>	업무 부서 -->
												
<!-- 												<th Cl='STD_DNAME2'></th>	업무 부서명 -->
<!-- 												<th Cl='STD_USRID3'></th>	현장담당 -->
<!-- 												<th Cl='STD_UNAME3'></th>	현장담당자명 -->
<!-- 												<th Cl='STD_DEPTID3'></th>	현장담당 부서 -->
<!-- 												<th Cl='STD_DNAME3'></th>	현장담당 부서명 -->
<!-- 												<th Cl='STD_USRID4'></th>	현장책임 -->
<!-- 												<th Cl='STD_UNAME4'></th>	현장책임자명 -->
<!-- 												<th Cl='STD_DEPTID4'></th>	현장책임 부서 -->
<!-- 												<th Cl='STD_DNAME4'></th>	현장책임 부서명 -->
<!-- 												<th Cl='STD_DOCTXT'></th>	비고 -->
												
												<th Cl='STD_EBELN'></th>	<!-- SAP P/O No -->
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
											<col width="200" />
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
											<col width="100" />
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												
												<td GCol="text,SEBELN"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,ASNTTY"></td>
												<td GCol="text,ASNTTYNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="input,DOCDAT" GF="C 8"></td>
												<td GCol="text,DOCCAT"></td>
												<td GCol="text,DOCCATNM"></td>
												
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNKYNM"></td>
												<td GCol="text,DRELIN"></td>
												<td GCol="input,PRCPTD" GF="C 8"></td>
												<td GCol="text,LRCPTD"></td>
												<td GCol="text,INDDCL"></td>
												<td GCol="text,RSNCOD"></td>
												<td GCol="text,RSNRET"></td>
												<td GCol="text,QTYASN"></td>
																								
												<td GCol="text,QTYRCV"></td>
<!-- 												<td GCol="text,LGORT"></td> -->
<!-- 												<td GCol="text,LGORTNM"></td> -->
<!-- 												<td GCol="text,USRID1"></td> -->
<!-- 												<td GCol="text,UNAME1"></td> -->
<!-- 												<td GCol="text,DEPTID1"></td> -->
<!-- 												<td GCol="text,DNAME1"></td> -->
<!-- 												<td GCol="text,USRID2"></td> -->
<!-- 												<td GCol="text,UNAME2"></td> -->
<!-- 												<td GCol="text,DEPTID2"></td> -->
																								
<!-- 												<td GCol="text,DNAME2"></td> -->
<!-- 												<td GCol="text,USRID3"></td> -->
<!-- 												<td GCol="text,UNAME3"></td> -->
<!-- 												<td GCol="text,DEPTID3"></td> -->
<!-- 												<td GCol="text,DNAME3"></td> -->
<!-- 												<td GCol="text,USRID4"></td> -->
<!-- 												<td GCol="text,UNAME4"></td> -->
<!-- 												<td GCol="text,DEPTID4"></td> -->
<!-- 												<td GCol="text,DNAME4"></td> -->
<!-- 												<td GCol="input,DOCTXT" GF="S 255"></td> -->
												
												<td GCol="text,EBELN"></td>
												
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
											<col width="100" />
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
<!-- 											<col width="100" /> -->
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<!-- <th CL='STD_SEBELN'></th> -->
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_ASNDIT'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_QTYASN'>예정량</th>
												<th CL='STD_QTYASN1,2'>기예정량</th>
												<th CL='STD_QTYORD'>오더수량</th>
												<th CL='STD_QTYRCV'>입고수량</th>
												<th CL='STD_INQTYASN'>입력예정수량</th>
												<!-- <th CL='STD_QTYUOM'>quantity</th> -->
												<th CL='STD_MEASKY'></th>
												<th CL='STD_UOMKEY'></th>
												
												<!-- <th CL='STD_QTPUOM'></th>
												<th CL='STD_DUOMKY'></th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_BOXQTY'></th> -->
<!-- 												<th CL='STD_REMQTY'>잔량</th> -->
<!-- 												<th CL='STD_RCSTKY'></th> -->
												<th CL='STD_LOCARV'>기본입하지번</th>
<!-- 												<th CL='STD_LOTA01'></th> -->
<!-- 												<th CL='STD_LOTA01NM'></th> -->
<!-- 												<th CL='STD_LOTA02'></th> -->
												
<!-- 												<th CL='STD_LOTA03'></th> -->
<!-- 												<th CL='STD_LOTA04'></th> -->
<!-- 												<th CL='STD_LOTA05'></th> -->
<!-- 												<th CL='STD_LOTA06'></th> -->
<!-- 												<th CL='STD_LOTA07'></th> -->
<!-- 												<th CL='STD_LOTA08'></th> -->
<!-- 												<th CL='STD_LOTA09'></th> -->
<!-- 												<th CL='STD_LOTA10'></th> -->
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												
												<th CL='STD_LOTA13'></th>
<!-- 												<th CL='STD_LOTA14'></th> -->
<!-- 												<th CL='STD_LOTA15'></th> -->
<!-- 												<th CL='STD_LOTA16'></th> -->
<!-- 												<th CL='STD_LOTA17'></th> -->
<!-- 												<th CL='STD_LOTA18'></th> -->
<!-- 												<th CL='STD_LOTA19'></th> -->
<!-- 												<th CL='STD_LOTA20'></th> -->
												<th CL='STD_LRCPTD'></th>
												<th CL='STD_REFDKY'></th>
												
												<!-- <th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_EASNKY'></th>
												<th CL='STD_EASNIT'></th> -->
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
<!-- 												<th CL='STD_ASKU01'></th> -->
<!-- 												<th CL='STD_ASKU02'></th> -->
<!-- 												<th CL='STD_ASKU03'></th> -->
<!-- 												<th CL='STD_ASKU04'></th> -->
												
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
												<th CL='STD_SBKTXT'></th>
												<th CL='STD_AWMSNO'></th>

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
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<td GCol="rownum"></td>
												<!-- <td GCol="text,SEBELN"></td> -->
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="input,QTYASN" validate="max(GRID_COL_QTYUOM_*),IN_M0077" GF="N 20">예정량</td>
												<td GCol="text,QTYASN1" GF="N">기예정량</td>
												<td GCol="text,QTYORD" GF="N">오더수량</td>
												<td GCol="text,QTYRCV" GF="N">입고수량</td>
												<td GCol="text,INQTYASN" GF="N">입력예정수량</td>
												<!-- <td GCol="text,QTYUOM" GF="N">quantity</td> -->
												<td GCol="text,MEASKY"></td>
												<td GCol="text,UOMKEY"></td>
												
<!-- 												<td GCol="text,QTPUOM"></td> -->
<!-- 												<td GCol="text,DUOMKY"></td> -->
<!-- 												<td GCol="text,QTDUOM"></td> -->
<!-- 												<td GCol="text,BOXQTY"></td> -->
<!-- 												<td GCol="text,REMQTY">잔량</td> -->
		<!-- 										<td GCol="text,RCSTKY"></td> -->
												<td GCol="text,LOCARV"></td>
<!-- 												<td GCol="text,LOTA01"></td> -->
<!-- 												<td GCol="text,LOTA01NM"></td> -->
<!-- 												<td GCol="text,LOTA02"></td> -->
												
<!-- 												<td GCol="text,LOTA03"></td> -->
<!-- 												<td GCol="text,LOTA04"></td> -->
<!-- 												<td GCol="text,LOTA05"></td> -->
<!-- 												<td GCol="text,LOTA06"></td> -->
<!-- 												<td GCol="text,LOTA07"></td> -->
<!-- 												<td GCol="text,LOTA08"></td> -->
<!-- 												<td GCol="text,LOTA09"></td> -->
<!-- 												<td GCol="text,LOTA10"></td> -->
												<td GCol="input,LOTA11" GF="C 8"></td>
												<td GCol="text,LOTA12"></td>
												
												<td GCol="text,LOTA13"></td>
<!-- 												<td GCol="text,LOTA14"></td> -->
<!-- 												<td GCol="text,LOTA15"></td> -->
<!-- 												<td GCol="text,LOTA16"></td> -->
<!-- 												<td GCol="text,LOTA17"></td> -->
<!-- 												<td GCol="text,LOTA18"></td> -->
<!-- 												<td GCol="text,LOTA19"></td> -->
<!-- 												<td GCol="text,LOTA20"></td> -->
												<td GCol="text,LRCPTD"></td>
												<td GCol="text,REFDKY"></td>
												
<!-- 												<td GCol="text,REFDIT"></td> -->
<!-- 												<td GCol="text,REFCAT"></td> -->
<!-- 												<td GCol="text,EASNKY"></td> -->
<!-- 												<td GCol="text,EASNIT"></td> -->
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
<!-- 												<td GCol="text,ASKU01"></td> -->
<!-- 												<td GCol="text,ASKU02"></td> -->
<!-- 												<td GCol="text,ASKU03"></td> -->
<!-- 												<td GCol="text,ASKU04"></td> -->
												
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
												<td GCol="text,SBKTXT"></td>
												<td GCol="text,AWMSNO"></td>
												
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