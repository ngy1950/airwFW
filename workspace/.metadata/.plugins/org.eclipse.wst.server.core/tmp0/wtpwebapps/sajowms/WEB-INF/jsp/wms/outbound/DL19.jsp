<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridListHeader",
	    	name : "gridListHeader",
			editable : true,
			module : "WmsOutbound",
			command : "DL19"
	    });
		
		userInfoData = page.getUserInfo();
		dataBind.dataNameBind(userInfoData, "searchArea");
		
		if(userInfoData.AREA != "PV"){ //메인일경우
			$("#ZONE").removeAttr("readonly");
			$("#ZONE").val("");
			$("#AREA").removeAttr("readonly");
			userInfoData.ZONE = "";
		}else if(userInfoData.AREA == "PV"){
			$("#ZONE").attr("readonly","readonly");
		}
		
		var rdata = new DataMap();
		rdata.put(configData.INPUT_RANGE_OPERATOR, "E");
		rdata.put(configData.INPUT_RANGE_SINGLE_DATA, userInfoData.AREA);
		
		inputList.setRangeData("AREAKY", configData.INPUT_RANGE_TYPE_SINGLE, [rdata]);		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridListHeader",
		    	param : param
		    });
		}
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			test3();
		}
	}
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHBZPTN"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHDOCTM"){
			return dataBind.paramData("searchArea");
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
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
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
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">창고</th>
						<td>
							<!--  <input type="text" name="AREA" id="AREA" readonly="readonly" />  -->
							<input type="text" name="AREAKY" id="AREA" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY"></th>
						<td>
							<input type="text" name="ZONE" id="ZONE" UIInput="S,SHZONMA" readonly="readonly"/>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="LOCAKY" UIInput="R,SHLOCMA" />
						</td>
					</tr> -->
					<tr>
						<th CL="STD_DOCUTY">문서타입</th>
						<td>
							<input type="text" name="DOCUTY" UIInput="R,SHDOCTM" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">출하문서번호</th>
						<td>
							<input type="text" name="SHPOKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">문서일자</th>
						<td>
							<input type="text" name="DOCDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">문서상태</th>
						<td>
							<input type="text" name="STATDO" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_ERPSELECTOPTIONS">ERP 검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_CUSTMR">거래처</th>
						<td>
							<input type="text" name="DPTNKY" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">ECMS 주문번호</th>
						<td>
							<input type="text" name="SVBELN" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STKNUM">총괄계획번호</th>
						<td>
							<input type="text" name="STKNUM" UIInput="R" />
						</td>
					</tr>
						<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="DESC01" UIInput="R" />
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

			<div class="bottomSect type1">
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
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
												<th CL='STD_SHPMTY'></th>
												<th CL='STD_SHPMTYNM'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCCAT'></th>
												<th CL='STD_DOCCATNM'></th>
												<th CL='STD_PRORTY'></th>
												<th CL='STD_DOCUTY'></th>
												<th CL='STD_DOCUTYNM'></th>
												<th CL='STD_OWNRKY'>화주</th>
												<th CL='STD_DRELIN'></th>
												<th CL='STD_RQSHPD'></th>
												<th CL='STD_RQARRD'></th>
												<th CL='STD_RQARRT'></th>
												<th CL='STD_LSHPCD'></th>
												<th CL='STD_DPTNKY'></th>
												<th CL='STD_DPTNKYNM'></th>
												<th CL='STD_PTRCVR'></th>
												<th CL='STD_PTRCVRNM'></th>
												<th CL='STD_PGRC01'></th>
												<th CL='STD_PGRC02'></th>
												<th CL='STD_PGRC03'></th>
												<th CL='STD_PGRC04'></th>
												<th CL='STD_PGRC05'></th>
												<th CL='STD_VEHINO'></th>
												<th CL='STD_DRIVER'></th>
												<th CL='STD_LOCADT'></th>
												<th CL='STD_LOCADK'></th>
												<th CL='STD_INDDCL'></th>
												<th CL='STD_RSNCOD'></th>
												<th CL='STD_RSNRET'></th>
												<th CL='STD_USRID1'></th>
												<th CL='STD_UNAME1'></th>
												<th CL='STD_DEPTID1'></th>
												<th CL='STD_VEHINO'></th>
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
											    <th CL='STD_DEPTID4'></th>
											    <th CL='STD_DNAME4'></th>
											    <th CL='STD_DOCTXT'></th>
											    <th CL='STD_STATIT'></th>
											    <th CL='STD_STATITNM'></th>
											    <th CL='STD_SKUKEY'></th>
											    <th CL='STD_QTYORG'></th>
											    <th CL='STD_QTSHPO'></th>
											    <th CL='STD_QTYREF'></th>
											    <th CL='STD_QTAPPO'></th>
											    <th CL='STD_QTALOC'></th>
											    <th CL='STD_QTJCMP'></th>
											    <th CL='STD_QTSHPD'></th>
											    <th CL='STD_QTSHPC'></th>
											    <th CL='STD_QTYUOM'></th>
											    <th CL='STD_MEASKY'></th>
											    <th CL='STD_UOMKEY'></th>
											    <th CL='STD_QTPUOM'></th>
											    <th CL='STD_DUOMKY'></th>
											    <th CL='STD_QTDUOM'></th>
											 	<th CL='STD_SASTKY'></th>
											 	<th CL='STD_TKFLKY'></th>
											 	<th CL='STD_ESHPKY'></th>
											 	<th CL='STD_ESHPIT'></th>
											 	<th CL='STD_OPURKY'></th>
											 	<th CL='STD_REFDKY'></th>
											 	<th CL='STD_REFDIT'></th>
											 	<th CL='STD_REFCAT'></th>
											 	<th CL='STD_REFDAT'></th>
											 	<th CL='STD_EXSUBS'></th>
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
											    <th CL='STD_PROCHA'></th>
											    <th CL='STD_AREAKY'></th>
											    <th CL='STD_LOTA01'></th>
											    <th CL='STD_LOTA02'></th>
											    <th CL='STD_LOTA02NM'></th>
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
											    <th CL='STD_SSORNU'></th>
											    <th CL='STD_SSORIT'></th>
											    <th CL='STD_SMBLNR'></th>
											    <th CL='STD_SZEILE'></th>
											    <th CL='STD_SMJAHR'></th>
											    <th CL='STD_SXBLNR'></th>
											    <th CL='STD_SAPSTS'></th>
											    <th CL='STD_SAPSTSNM'></th>
											    <th CL='STD_PTNRKY'></th>
											    <th CL='STD_NAME01'></th>
											    <th CL='STD_SLAND1'></th>
											    <th CL='STD_SBKTXT'></th>
											    <th CL='STD_CREDAT'></th>
											    <th CL='STD_CRETIM'></th>
											    <th CL='STD_CREUSR'></th>
											    <th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_LUSRNM'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_PZPTNANM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
											<col width="100"/>
										</colgroup>
										<tbody id="gridListHeader">
											<tr CGRow="true">
											<td GCol="rownum">1</td>
											<td GCol="text,SHPOKY"></td>
											<td GCol="text,SHPOIT"></td>
											<td GCol="text,WAREKY"></td>
											<td GCol="text,WAREKYNM"></td>
											<td GCol="text,SHPMTY"></td>
											<td GCol="text,SHPMTYNM"></td>
											<td GCol="text,ALSTKY"></td>
											<td GCol="text,STATDO"></td>
											<td GCol="text,STATDONM"></td>
											<td GCol="text,DOCDAT"></td>
											<td GCol="text,DOCCAT"></td>
											<td GCol="text,DOCCATNM"></td>
											<td GCol="text,PRORTY"></td>
											<td GCol="text,DOCUTY"></td>
											<td GCol="text,DOCUTYNM"></td>
											<td GCol="text,OWNRKY"></td>
											<td GCol="text,DRELIN"></td>
											<td GCol="text,RQSHPD"></td>
											<td GCol="text,RQARRD"></td>
											<td GCol="text,RQARRT"></td>
											<td GCol="text,LSHPCD"></td>
											<td GCol="text,DPTNKY"></td>
											<td GCol="text,DPTNKYNM"></td>
											<td GCol="text,PTRCVR"></td>
											<td GCol="text,PTRCVRNM"></td>
											<td GCol="text,PGRC01"></td>
											<td GCol="text,PGRC02"></td>
											<td GCol="text,PGRC03"></td>
											<td GCol="text,PGRC04"></td>
											<td GCol="text,PGRC05"></td>
											<td GCol="text,VEHINO"></td>
											<td GCol="text,DRIVER"></td>
											<td GCol="text,LOCADT"></td>
											<td GCol="text,LOCADK"></td>
											<td GCol="text,INDDCL"></td>
											<td GCol="text,RSNCOD"></td>
											<td GCol="text,RSNRET"></td>
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
											<td GCol="text,DOCTXT"></td>
											<td GCol="text,STATIT"></td>
											<td GCol="text,STATITNM"></td>
											<td GCol="text,SKUKEY"></td>
											<td GCol="text,QTYORG" GF="N"></td>
											<td GCol="text,QTSHPO" GF="N"></td>
											<td GCol="text,QTYREF" GF="N"></td>
											<td GCol="text,QTAPPO" GF="N"></td>
											<td GCol="text,QTALOC" GF="N"></td>
											<td GCol="text,QTJCMP" GF="N"></td>
											<td GCol="text,QTSHPD" GF="N"></td>
											<td GCol="text,QTSHPC" GF="N"></td>
											<td GCol="text,QTYUOM" GF="N"></td>
											<td GCol="text,MEASKY"></td>
											<td GCol="text,UOMKEY"></td>
											<td GCol="text,QTPUOM" GF="N"></td>
											<td GCol="text,DUOMKY"></td>
											<td GCol="text,QTDUOM"></td>
											<td GCol="text,SASTKY"></td>
											<td GCol="text,TKFLKY"></td>
											<td GCol="text,ESHPKY"></td>
											<td GCol="text,ESHPIT"></td>
											<td GCol="text,OPURKY"></td>
											<td GCol="text,REFDKY"></td>
											<td GCol="text,REFDIT"></td>
											<td GCol="text,REFCAT"></td>
											<td GCol="text,REFDAT"></td>
											<td GCol="text,EXSUBS"></td>
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
											<td GCol="text,PROCHA"></td>
											<td GCol="text,AREAKY"></td>
											<td GCol="text,LOTA01"></td>
											<td GCol="text,LOTA02"></td>
											<td GCol="text,LOTA02NM"></td>
											<td GCol="text,LOTA03"></td>
											<td GCol="text,LOTA04"></td>
											<td GCol="text,LOTA05"></td>
											<td GCol="text,LOTA06"></td>
											<td GCol="text,LOTA07"></td>
											<td GCol="text,LOTA08"></td>
											<td GCol="text,LOTA09"></td>
											<td GCol="text,LOTA10"></td>
											<td GCol="text,LOTA11"></td>
											<td GCol="text,LOTA12"></td>
											<td GCol="text,LOTA13"></td>
											<td GCol="text,LOTA14"></td>
											<td GCol="text,LOTA15"></td>
											<td GCol="text,LOTA16" GF="N"></td>
											<td GCol="text,LOTA17" GF="N"></td>
											<td GCol="text,LOTA18" GF="N"></td>
											<td GCol="text,LOTA19" GF="N"></td>
											<td GCol="text,LOTA20" GF="N"></td>
											<td GCol="text,AWMSNO"></td>
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
											<td GCol="text,SAPSTS"></td>
											<td GCol="text,SAPSTSNM"></td>
											<td GCol="text,PTNRKY"></td>
											<td GCol="text,NAME01"></td>
											<td GCol="text,SLAND1"></td>
											<td GCol="text,SBKTXT"></td>
											<td GCol="text,CREDAT"></td>
											<td GCol="text,CRETIM"></td>
											<td GCol="text,CREUSR"></td>
											<td GCol="text,CUSRNM"></td>
											<td GCol="text,LMODAT"></td>
											<td GCol="text,LMOTIM"></td>
											<td GCol="text,LMOUSR"></td>
											<td GCol="text,LUSRNM"></td>
											<td GCol="text,QTCOMP"></td>
											<td GCol="text,ZONEKY"></td>
											<td GCol="text,ZONENM"></td>
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
	</div>

<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>