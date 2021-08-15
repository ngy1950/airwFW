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
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(200);
		
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "SJ04"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			module : "WmsInventory",
			command : "SJ04Sub"
	    });
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridListSub", true, ['ALOTA06']);
	});
	
	var searchType = true;
	
	function searchList(){
		searchType = true;
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			/* var json = netUtil.sendData({
				module : "WmsInbound",
				command : "AREAKYval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] <= 0) {
				commonUtil.msgBox("MASTER_M0048");
				$("#searchArea").find("[name=AREA]").val("").focus();
				return;
			} */
			
			gridList.gridList({
		    	id : "gridListSub",
		    	param : param
		    });
		}
		uiList.setActive("Save", true);
		uiList.setActive("Reflect", true);
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList"){
			uiList.setActive("Search", true);
		}/* else if(gridId == "gridListSub" && dataLength > 0){
			searchHeadList();
	} */else if(gridId == "gridListSub" && dataCount > 0 && searchType){
			uiList.setActive("Search", false);
			uiList.setActive("Save", true);
			uiList.setActive("Reflect", true);
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });

			$("#arsnadjCombo").val("");
			
			gridList.setReadOnly("gridList", false);
			gridList.setReadOnly("gridListSub", false);
			gridList.setReadOnly("gridListSub", true, ['ALOTA06']);
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			uiList.setActive("Save", true);
		}else if(gridId == "gridListSub"){
			uiList.setActive("Reflect", true);			
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reflect"){
			setArsnadj();
		}
	}
	
	function saveData(){	
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridListSub", "select")){
			
			var docunum = wms.getDocSeq(gridList.getColData("gridList", 0, "ADJUTY"));
			gridList.gridColModify("gridList", 0, "SADJKY", docunum);

			var head = gridList.getRowData("gridList", 0);
			
			var list = gridList.getSelectModifyList("gridListSub");
			
			if(list.length == 0){
				commonUtil.msgBox("INV_M0055",docunum);
				return;
			}
			
			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/inventory/json/saveAdjd.data",
				param : param
			});
			
			if(json && json.data){
				
				commonUtil.msgBox("INV_M0010", docunum);
				
				searchType = false;
				
				var paramH = new DataMap();
				paramH.put("SADJKY", docunum);
				
				gridList.gridList({
			    	id : "gridList",
			    	command : "SJ04L",
			    	param : paramH
			    });
				
				gridList.gridList({
			    	id : "gridListSub",
			    	command : "SJ04M",
			    	param : paramH
			    });
				
				gridList.setReadOnly("gridList", true);
				gridList.setReadOnly("gridListSub", true);
			}
			uiList.setActive("Save", false);
			uiList.setActive("Reflect", false);
		}
	}
	
	function setArsnadj(){
		var arsnadjCombo = $("#arsnadjCombo").val();
		if(arsnadjCombo){
			var selectNumList = gridList.getSelectRowNumList("gridListSub");
			for(var i=0;i<selectNumList.length;i++){
				var rowNum = selectNumList[i];
				gridList.setColValue("gridListSub", rowNum, "ARSNADJ", arsnadjCombo);
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("WAREKY", "<%= wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHCMCDV"){
			var param = new DataMap();
			param.put("CMCDKY", "LOTA06");
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
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
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
							<input type="text" name="WAREKY"  value="<%=wareky%>" size="8px"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">창고</th>
						<td>
							<input type="text" name="S.AREAKY" id="AREAKY" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY"></th>
						<td>
							<input type="text" name="S.ZONEKY" id="ZONE" UIInput="R,SHZONMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="S.LOCAKY" UIInput="R,SHLOCMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TRNUID">P/T ID</th>
						<td>
							<input type="text" name="S.TRNUID" UIInput="R" />
						</td>
					</tr>
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
						<td>
							<input type="text" name="S.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="S.DESC01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC02">품명</th>
						<td>
							<input type="text" name="S.DESC02" UIInput="R" />
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
					<tr>
						<th CL="STD_LOTA01">업체코드</th>
						<td>
							<input type="text" name="S.LOTA01" UIInput="R" />
						</td>
					</tr>
					<tr>
					<th CL="STD_LOTA02">부서코드</th>
						<td>
							<input type="text" name="S.LOTA02" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA03">개별바코드</th>
						<td>
							<input type="text" name="S.LOTA03" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA04">Mall PO번호</th>
						<td>
							<input type="text" name="S.LOTA04" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA05">Mall PO Item번호</th>
						<td>
							<input type="text" name="S.LOTA05" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA06">재고상태</th>
						<td>
							<input type="text" name="S.LOTA06" UIInput="R,SHCMCDV" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA07">Mall SD번호</th>
						<td>
							<input type="text" name="S.LOTA07" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA09">WMS PO번호</th>
						<td>
							<input type="text" name="S.LOTA09" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA11">제조일자</th>
						<td>
							<input type="text" name="S.LOTA11" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA12">입고일자</th>
						<td>
							<input type="text" name="S.LOTA12" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA13">유효기간</th>
						<td>
							<input type="text" name="S.LOTA13" UIInput="R" UIFormat="C" />
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
						<li><a href="#tabs1-1" CL="STD_GENERAL"><span></span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_SADJKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_ADJUTY'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCCAT'></th>
												<th CL='STD_DOCCATNM'></th>
												<th CL='STD_ADJUCA'></th>
												<th CL='STD_ADJUCANM'></th>
												<th CL='STD_DOCTXT'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,ADJUTY"></td>
												<td GCol="input,DOCDAT" GF="C 8"></td>
												<td GCol="text,DOCCAT"></td>
												<td GCol="text,DOCCATNM"></td>
												<td GCol="text,ADJUCA"></td>
												<td GCol="text,ADJUCANM"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
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

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1" CL="STD_ADJLIST"><span>조정 가능 목록</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="util">
									<tr>
										<th CL="STD_RSNADJ"></th>
										<td>
											<select ReasonCombo="430" id="arsnadjCombo">
												<option value=""> </option>
											</select>
										</td>
										<td>
											<button CB="Reflect REFLECT BTN_REFLECT">
											</button>
										</td>
									</tr>
								</table>
							<div class="table type2"  style="top:45px;">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_SECTID'></th>
												<th CL='STD_PACKID'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_TRUNTY'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_DUOMKY'></th>
												<th CL='STD_QTYUOM'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_QTSIWH'></th>
												<th CL='STD_USEQTY'></th>
												<th CL='STD_QTSBLK'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
											    <th CL='STD_BATMNG'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_RSNADJ'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_SECTID'></th>
												<th CL='STD_PACKID'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_CHNSKUKEY'></th>
												<th CL='STD_TRUNTY'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_QTADJU'></th>
												<th CL='STD_DUOMKY'></th>
												<th CL='STD_QTYUOM'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_QTBLKD'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_PTLT01'></th>
												<th CL='STD_PTLT02'></th>
												<th CL='STD_LOTA02NM'></th>
												<th CL='STD_PTLT03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06_TO'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11_TO'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13_TO'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_BATMNG_1'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_MASKU03_1'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05_TO'></th>
												<th CL='STD_ADJRSN'></th>
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
										</colgroup>
										<tbody id="gridListSub">
										<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,STOKKY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,SECTID"></td>
												<td GCol="text,PACKID"></td>
												<td GCol="text,TRNUID"></td>
												<td GCol="text,TRUNTY"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,DUOMKY"></td>
												<td GCol="text,QTYUOM" GF="N"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTPUOM" GF="N"></td>
												<td GCol="text,QTDUOM" GF="N"></td>
												<td GCol="text,QTSIWH" GF="N"></td>
												<td GCol="text,USEQTY" GF="N"></td>
												<td GCol="text,QTSBLK"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,BATMNG"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,ASTOKKY"></td>
												<td GCol="select,ARSNADJ" validate="required,INV_M0054">
													<select ReasonCombo="430">
														<option value=""> </option>
													</select>
												</td>
												<td GCol="text,ALOTNUM"></td>
												<td GCol="text,ALOCAKY"></td>
												<td GCol="text,ASECTID"></td>
												<td GCol="text,APACKID"></td>
												<td GCol="text,ATRNUID" GF="S 30"></td>
												<td GCol="text,AOWNRKY"></td>
												<td GCol="text,ASKUKEY"></td>
												<td GCol="text,ATRUNTY"></td>
												<td GCol="text,AMEASKY"></td>
												<td GCol="input,AQTADJU" validate="max(GRID_COL_AQTADJU_*),INV_M0024" GF="N 20,3"></td>
												<td GCol="text,ADUOMKY"></td>
												<td GCol="text,AQTYUOM"></td>
												<td GCol="text,AUOMKEY"></td>
												<td GCol="text,AQTPUOM" GF="N"></td>
												<td GCol="text,AQTBLKD" GF="N"></td>
												<td GCol="text,ADESC01"></td>
												<td GCol="input,ALOTA01" GF="S 20"></td>
												<!-- <td GCol="select,ALOTA02">
													<select CommonCombo="LOTA02">
													</select>
												</td> -->
												<td GCol="text,ALOTA02"></td>
												<td GCol="text,LOTA02NM"></td>
												<td GCol="input,ALOTA03" GF="S 20"></td>
												<td GCol="input,ALOTA04" GF="S 20"></td>
												<td GCol="input,ALOTA05" GF="S 20"></td>
												<!-- <td GCol="text,ALOTA06"></td> -->
												<td GCol="select,ALOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,ALOTA07"></td>
												<td GCol="text,ALOTA08"></td>
												<td GCol="text,ALOTA09"></td>
												<td GCol="text,ALOTA10"></td>
												<td GCol="input,ALOTA11" GF="C 8"></td>
												<td GCol="input,ALOTA12" GF="C 8"></td>
												<td GCol="input,ALOTA13" GF="C 8"></td>
												<td GCol="text,ALOTA14"></td>
												<td GCol="text,ALOTA15"></td>
												<td GCol="text,ALOTA16" GF="N"></td>
												<td GCol="text,ALOTA17" GF="N"></td>
												<td GCol="text,ALOTA18" GF="N"></td>
												<td GCol="text,ALOTA19" GF="N"></td>
												<td GCol="text,ALOTA20" GF="N"></td>
												<td GCol="text,ADESC02"></td>
												<td GCol="text,AEANCOD"></td>
												<td GCol="text,AGTINCD"></td>
												<td GCol="text,ASKUG01"></td>
												<td GCol="text,ASKUG02"></td>
												<td GCol="text,ASKUG03"></td>
												<td GCol="text,ASKUG04"></td>
												<td GCol="text,ASKUG05"></td>
												<td GCol="text,AGRSWGT"></td>
												<td GCol="text,ANETWGT"></td>
												<td GCol="text,AAREAKY"></td>
												<td GCol="text,ABATMNG"></td>
												<td GCol="text,AASKU01"></td>
												<td GCol="text,AASKU02"></td>
												<td GCol="text,AASKU03"></td>
												<td GCol="text,AASKU04"></td>
												<td GCol="text,AASKU05"></td>
												<td GCol="input,AADJRSN" GF="S 255"></td>
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