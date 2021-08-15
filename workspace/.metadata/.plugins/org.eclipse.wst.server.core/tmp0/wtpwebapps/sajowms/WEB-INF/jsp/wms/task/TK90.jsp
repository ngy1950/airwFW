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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsTask",
			command : "TK90"
	    });
	});
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHDOCTM"){
			var param = new DataMap();
			param.put("DOCCAT", "300");
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
		}else if(searchCode == "SHCMCDV"){
			var param = new DataMap();
			param.put("CMCDKY", "LOTA06");
		}
		return param;
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
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
			url : "/wms/task/json/savePrtseqTK90.data",
			param : param
		});

		var where = "AND PRTSEQ IN ('" + prtseq + "')";

		url = "/ezgen/task_list.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 650);
	}
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Print PRINT BTN_PRINT90"></button>

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
						<td><input type="text" name="WAREKY" size="8px" value="<%=wareky%>" readonly="readonly"/></td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">전기일자</th>
						<td>
							<input type="text" name="TH.DOCDAT" UIInput="R" UIFormat="C N" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">작업오더유형</th>
						<td>
							<input type="text" name="TH.TASOTY" UIInput="R,SHDOCTM" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TASKKY">작업오더번호</th>
						<td>
							<input type="text" name="TH.TASKKY" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SKUINFO">상품정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="SM.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="SM.DESC01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC02">품명</th>
						<td>
							<input type="text" name="SM.DESC02" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_LOTINFO">LOT 정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_LOTA01">공급업체</th>
						<td>
							<input type="text" name="TI.LOTA01" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA02">부서코드</th>
						<td>
							<input type="text" name="TI.LOTA02" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA03">개별바코드</th>
						<td>
							<input type="text" name="TI.LOTA03" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA06">재고상태</th>
						<td>
							<input type="text" name="TI.LOTA06" UIInput="R,SHCMCDV" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA11">제조일자</th>
						<td>
							<input type="text" name="TI.LOTA11" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA12">입고일자</th>
						<td>
							<input type="text" name="TI.LOTA12" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA13">유효기간</th>
						<td>
							<input type="text" name="TI.LOTA13" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA16">매입단가</th>
						<td>
							<input type="text" name="TI.LOTA16" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA17">매출단가</th>
						<td>
							<input type="text" name="TI.LOTA17" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA10">통화</th>
						<td>
							<input type="text" name="TI.LOTA10" UIInput="R" />
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

				<div class="bottomSect type1">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>리스트</span></a></li>
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
											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'>번호</th>
													<th GBtnCheck="true"></th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_WARENM'></th>
													<th CL='STD_AREAKY'></th>
													<th CL='STD_AREANM'></th>
													<th CL='STD_OWNRKY'></th>
													
													<th CL='STD_OWNRNM'></th>
													<th CL='STD_WARETG'></th>
													<th CL='STD_WARETGNM'></th>
													
													<th CL='STD_TASKKY'></th>
													<th CL='STD_DOCDAT'></th>
													<th CL='STD_TASOTY'></th>
													<th CL='STD_TASONM'></th>
													<th CL='STD_SKUKEY'></th>
													
													<th CL='STD_DESC01'></th>
													<th CL='STD_DESC02'></th>
													<th CL='STD_QTTAOR'></th>
													<th CL='STD_QTCOMP'></th>
													<th CL='STD_SUOMKY'></th>
													
													<th CL='STD_LOCASR'></th>
													<th CL='STD_RSNCOD'></th>
													<th CL='STD_RSNCDNM'></th>
													<th CL='STD_TASRSN'></th>
													<th CL='EZG_LOTA02'></th>
													<th CL='STD_CENTERNM'></th>
													
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
													<th CL='STD_DOCTXT'></th>
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
											</colgroup>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="rowCheck"></td>
													<td GCol="text,WAREKY">거점</td>
													<td GCol="text,WARENM">거점명</td>
													<td GCol="text,AREAKY"></td>
													<td GCol="text,AREANM">창고명</td>
													<td GCol="text,OWNRKY">화주</td>
													
													<td GCol="text,OWNRNM">화주명</td>
													<td GCol="text,WARETO">To 거점</td>
													<td GCol="text,WARETONM">To 거점명</td>
													
													<td GCol="text,TASKKY">작업지시번호</td>
													<td GCol="text,DOCDAT" GF="D">작업문서번호</td>
													<td GCol="text,TASOTY">작업유형</td>
													<td GCol="text,TASONM">작업유형명</td>
													<td GCol="text,SKUKEY"></td>
													
													<td GCol="text,DESC01"></td>
													<td GCol="text,DESC02"></td>
													<td GCol="text,QTTAOR" GF="N 20,3"></td>
													<td GCol="text,QTCOMP" GF="N 20,3"></td>
													<td GCol="text,UOMKEY"></td>
													
													<td GCol="text,LOCAKY"></td>
													<td GCol="text,RSNCOD"></td>
													<td GCol="text,RSNCODNM"></td>
													
													<td GCol="text,TASRSN"></td>
													<td GCol="text,WORKNM"></td>
													<td GCol="text,WORKNAME"></td>
													
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
													<td GCol="text,LOTA11" GF="D"></td>
													<td GCol="text,LOTA12" GF="D"></td>
													<td GCol="text,LOTA13" GF="D"></td>
													<td GCol="text,LOTA14"></td>
													
													<td GCol="text,LOTA15"></td>
													<td GCol="text,LOTA16" GF="N 20,3"></td>
													<td GCol="text,LOTA17" GF="N 20,3"></td>
													<td GCol="text,LOTA18"></td>
													<td GCol="text,LOTA19"></td>
													
													<td GCol="text,LOTA20"></td>
													<td GCol="text,DOCTXT"></td>
													<td GCol="text,CREDAT" GF="D">생성일자</td>
													<td GCol="text,CRETIM" GF="T">생성시간</td>
													<td GCol="text,CREUSR">생성자</td>
													<td GCol="text,LMODAT" GF="D">수정일자</td>
													<td GCol="text,LMOTIM" GF="T">수정시간</td>
													<td GCol="text,LMOUSR">수정자</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<button type="button" GBtn="copy"></button>
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