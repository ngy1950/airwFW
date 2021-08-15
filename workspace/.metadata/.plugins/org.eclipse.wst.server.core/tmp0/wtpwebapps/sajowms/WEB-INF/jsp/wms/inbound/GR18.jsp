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
		gridList.setGrid({
	    	id : "gridList",
			editable : true,
			pkcol : "WAREKY,SKUKEY",
			module : "WmsInbound",
			command : "GR18"
	    });

		$("#USERAREA").val("<%=user.getUserg5()%>");	
		gridList.setReadOnly("gridList", true, ['INDRCN']);
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
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
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		var param = new DataMap();
		
		if(searchCode == "SHDOCTM"){
			param.put("DOCCAT", "100");
			return param;
		}else if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHBZPTN"){
			if($inputObj.name == "VD.PTNRKY"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "VD");
				return param;
			}else if($inputObj.name == "CT.PTNRKY"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "CT");
				return param;
			}
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
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea"style="overflow-y:scroll;">
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
						<th CL="STD_WAREKY"></th>
						<td>
							<input type="text" name="WAREKY" name="WAREKY" value="<%=wareky%>" readonly="readonly" validate="required"/>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_AREAKY,2">입고창고</th>
						<td>
							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
							</select>
						</td>
					</tr>	 -->			
					<!-- <tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
							</select>
						</td>
					</tr> -->
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<input type="text" name="RH.OWNRKY" UIInput="R,SHOWNER" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">전기일자</th>
						<td>
							<input type="text" name="RH.DOCDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDAT,3">입고예정일자</th>
						<td>
							<input type="text" name="RI.REFDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입고유형</th>
						<td>
							<input type="text" name="RH.RCPTTY" UIInput="R,SHDOCTM" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RECVKY">입고문서번호</th>
						<td>
							<input type="text" name="RH.RECVKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_EBELN">구매오더번호</th>
						<td>
							<input type="text" name="RI.SEBELN" UIInput="R" />
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
						<td >
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
						<th CL="STD_SALCOM,3">판매처 회사코드</th>
						<td>
							<input type="text" name="RH.USRID3" UIInput="R,SHBZPTN2" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY1,3">반품매출처</th>
						<td>
							<input type="text" name="CT.PTNRKY" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNNM1,3">반품매출처명</th>
						<td>
							<input type="text" name="CT.NAME01" UIInput="R" />
						</td>
					</tr> -->
				</tbody>
			</table>
		</div>	
		<div class="searchInBox">
			<h2 class="tit type1" CL="STD_SKUINFO">상품정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="RI.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01"></th>
						<td>
							<input type="text" name="SM.DESC01" UIInput="R" />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_DESC02"></th>
						<td>
							<input type="text" name="SM.DESC02" UIInput="R" />
						</td>
					</tr> -->
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
						<th CL="STD_LOTA01"></th>
						<td>
							<input type="text" name="RI.LOTA01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA02"></th>
						<td>
							<input type="text" name="RI.LOTA02" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA03"></th>
						<td>
							<input type="text" name="RI.LOTA03" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA04"></th>
						<td>
							<input type="text" name="RI.LOTA04" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA05"></th>
						<td>
							<input type="text" name="RI.LOTA05" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA06"></th>
						<td>
							<input type="text" name="RI.LOTA06" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA07"></th>
						<td>
							<input type="text" name="RI.LOTA07" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA08"></th>
						<td>
							<input type="text" name="RI.LOTA08" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA09"></th>
						<td>
							<input type="text" name="RI.LOTA09" UIInput="R" />
						</td>
					</tr> -->
					<tr>
						<th CL="STD_LOTA11"></th>
						<td>
							<input type="text" name="RI.LOTA11" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA12"></th>
						<td>
							<input type="text" name="RI.LOTA12" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA13"></th>
						<td>
							<input type="text" name="RI.LOTA13" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_LOTA16"></th>
						<td>
							<input type="text" name="RI.LOTA16" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA17"></th>
						<td>
							<input type="text" name="RI.LOTA17" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA10"></th>
						<td>
							<input type="text" name="RI.LOTA10" UIInput="R" />
						</td>
					</tr> -->
				</tbody>
			</table>
		</div>	
	</div>
</div>
<!-- //searchPop -->

<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect type1">
				<div class="tabs"  id="bottomTabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab01"><span CL='STD_RECVDETAIL'>탭메뉴1</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_OWNRNM'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_AREANM'></th>
												<!-- <th CL='STD_DEPTID4'></th> -->
												<!-- <th CL='STD_DEPTID4NM'></th> -->
												<!-- <th CL='STD_SALCOM'></th>
												<th CL='STD_SALCOMNM'></th>
												<th CL='STD_SALPLT'></th>
												<th CL='STD_SALPLTNM'></th> -->
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_ASNDAT,3'></th>
												<th CL='STD_RECVKY'></th>
												<th CL='STD_RECVIT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_RCPTTY'></th>
												<th CL='STD_RCPTTYNM'></th>
												<th CL='STD_INDRCN'></th>
												<th CL='STD_CRECVD'></th>
												<th CL='STD_DPTNKY3'></th>
												<th CL='STD_DPTNKY3,3'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTYRCV'></th>
												<th CL='STD_UOMKEY'></th>
												<!-- <th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th> -->
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA06NM'></th>
												<!-- <th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th> -->
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<!-- <th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th> -->
												<th CL='STD_RSNCODDT'>취소사유코드</th>
												<th CL='STD_RSNCDNM'></th>
												<th CL='STD_RCPRSNDT'>취소상세사유</th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,AREANM"></td>
												<!--<td GCol="text,DEPTID4"></td> -->
												<!--<td GCol="text,DEPTID4NM"></td>-->
												<!--<td GCol="text,USRID3"></td>-->
												<!--<td GCol="text,USRID3NM"></td>-->
												<!--<td GCol="text,DEPTID3"></td>-->
												<!--<td GCol="text,DEPTID3NM"></td> -->
												<td GCol="text,DOCDAT" GF="C N"></td>
												<td GCol="text,ASNDAT" GF="C N"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTNM"></td>
												<td GCol="check,INDRCN"></td>
												<td GCol="text,CRECVD"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,NAME01"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,QTYRCV" GF="N"></td>
												<td GCol="text,UOMKEY"></td>
												<!-- <td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td> -->
												<td GCol="text,LOTA06"></td>
												<td GCol="text,LOTA06NM"></td>
												<!-- td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td> -->
												<td GCol="text,LOTA11" GF="C N"></td>
												<td GCol="text,LOTA12" GF="C N"></td>
												<td GCol="text,LOTA13" GF="C N"></td>
												<!-- <td GCol="text,LOTA16" GF="N 20,3"></td>
												<td GCol="text,LOTA17" GF="N 20,3"></td> -->
												<td GCol="text,RSNCOD"></td>
												<td GCol="text,RSNCDNM"></td>
												<td GCol="text,RCPRSN"></td>
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
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>