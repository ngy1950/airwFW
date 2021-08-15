<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	//var dblIdx = -1;
	var headFocusNum = -1;
	var dblIdx = 0;
	$(document).ready(function() {
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			pkcol : "OWNRKY,SKUKEY",
			module : "WmsAdmin",
			command : "SKUMA",
			validation : "OWNRKY,WAREKY,SKUKEY,MEASKY,LOCARV,PASTKY,DPUTLO,ALSTKY",
			bindArea : "tabs1-2"
		});
		gridList.setReadOnly('gridList',true, ['DELMAK','SKUG01','ASKU05','SKUL01','SKUL02']);
	});

	function searchList() {
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	 function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		} 
		if(gridList.validationCheck("gridList", "modify")){
			var head = gridList.getModifyList("gridList", "A");
			
			var vparam = new DataMap();
			vparam.put("list", head);
			vparam.put("key", "OWNRKY,WAREKY,SKUKEY,MEASKY,LOCARV,PASTKY,DPUTLO,ALSTKY,DPUTZO");
			var json = netUtil.sendData({
				url : "/wms/admin/json/validationSK01.data",
				param : vparam
			});
			
			if(json.data != "OK"){
				var msgList = json.data.split(" ");
				//var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				var msgTxt = commonUtil.getMsg(msgList[0], msgList[1]);
				commonUtil.msg(msgTxt);
				return false;
			}
		    
			var param = new DataMap();
			param.put("head", head);
			
			var json = netUtil.sendData({
				url : "/wms/admin/json/saveSK01.data",
				param : param
			});
			
			if(json && json.data){
				//alert(commonUtil.getMsg("HHT_T0008"));
				commonUtil.msgBox("HHT_T0008");
				searchList();
			}
		}
	}
	 
	/* function sendSynch(){
		var list = gridList.getFocusRowNum("gridList");
		var param = new DataMap();
		param.put("list", list);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/sendSynch.data",
			param : param
		});
	 } */

<%-- 	function gridListEventRowAddBefore(gridId, rowNum) {
		dblIdx = rowNum;
		
		var param=new DataMap();
		param.put("WAREKY","<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "WAHMA_ADDR05",
			sendType : "map",
			param : param
		});
		
		var newData = new DataMap();
		newData.put("OWNRKY", "<%=ownrky%>");
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("SKUG01", "001"); 
		newData.put("DUOMKY", "EA");
		newData.put("WEIGHT", "0");
		newData.put("LENGTH", "0");
		newData.put("WIDTHW", "0");
		newData.put("HEIGHT", "0");
		newData.put("CUBICM", "0");
		newData.put("CAPACT", "0"); 
		newData.put("QTYBOX", "0");
		newData.put("QTYCNT", "0");
		newData.put("QTDUOM", "0");
		
		return newData;
	} --%>
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		} else if(searchCode == "SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHMEASH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHVRCVLO1"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHPASTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHALSTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode=="SHCMCDV"){
			var param = new DataMap();
			param.put("CMCDKY", "SKUG01");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Print"){
			reportPrint();
		}/* else if(btnName == "Reflect"){
			sendSynch();
		} */
	}
	
function reportPrint(){
		
		var head = gridList.getSelectData("gridList");
		
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var url = "";
		var where = "AND (";
		for(var i=0; i<head.length; i++){
			var row = head[i];
			var key = row.get("SKUKEY");
			where += "SKUKEY='"+key+"'";
			if(i==head.length-1) break;
			where += " OR ";	
		}
		where += ")"; 
		//alert(where);
		url = "/ezgen/skuba_s.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", "<%=langky%>", map, 650, 350);
	}
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Save SAVE STD_SAVE"></button>
			<button CB="Print PRINT BTN_SKUPRINT"></button>
<!-- 			<button CB="Reflect REFLECT BTN_SYNCH"></button> -->
		</div>
		<div class="util3">
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
							<td><input type="text" name="WAREKY" readonly="readonly"
								value="<%=wareky%>" validation="required,VALID_M0401" /></td>
						</tr>
						<tr>
							<th CL="STD_OWNRKY">화주</th>
							<td>
								<input type="text" name="OWNRKY" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">품번코드</th>
							<td><input type="text" name="A.SKUKEY" UIInput="R,SHSKUMA" /></td>
						</tr>
						<tr>
							<th CL="STD_DESC01">품명</th>
							<td><input type="text" name="A.DESC01" UIInput="R" /></td>
						</tr>
						<tr>
							<th CL="STD_DESC02">모델</th>
							<td><input type="text" name="A.DESC02" UIInput="R" /></td>
						</tr>
						<!-- <tr>
							<th CL="STD_SKUG01">품목대분류</th>
							<td><input type="text" name="A.SKUG01" UIInput="R,SHCMCDV" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG02">품목중분류</th>
							<td><input type="text" name="A.SKUG02" UIInput="R" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG03">품목소분류</th>
							<td><input type="text" name="A.SKUG03" UIInput="R" /></td>
						</tr> -->
						<!-- <tr>
							<th CL="STD_SKUG04">시리즈</th>
							<td><input type="text" name="A.SKUG04" UIInput="R" /></td>
						</tr> -->
						<tr>
							<th CL="STD_SKUG05">규격</th>
							<td><input type="text" name="A.SKUG05" UIInput="R" /></td>
						</tr>
						<!-- <tr>
							<th CL="STD_TB_SKU_HDR4,3"></th>
							<td>
								<label CL="STD_ASKU05,3"></label>
								<input type="checkbox" name="ASKU05" value="V" />&nbsp;&nbsp;&nbsp;
								<label CL="STD_SKUL01,3"></label>
								<input type="checkbox" name="SKUL01" value="V" />&nbsp;&nbsp;&nbsp;
								<label CL="STD_SKUL02,3"></label>
								<input type="checkbox" name="SKUL02" value="V" />
							</td>
						</tr> -->
						<tr>
							<th CL="STD_DELMAK">삭제여부</th>
							<td>
								<select Combo="WmsAdmin,DELMAKCOMBO" name="DELMAK" id="DELMAK" validate="required">
									<!-- <option value="">선택</option> -->
								</select>
							</td>
						</tr>
					</tbody>
				</table>

			</div>
		</div>

		<div class="searchInnerContainer">
			<div class="searchInBox">
				<h2 class="tit" CL="STD_STRATEGYINFO"></h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_PASTKY">적치전략키</th>
							<td><input type="text" name="B.PASTKY" UIInput="R,SHPASTH" /></td>
						</tr>
						<tr>
							<th CL="STD_ALSTKY">할당전략키</th>
							<td><input type="text" name="B.ALSTKY" UIInput="R,SHALSTH" /></td>
						</tr>
						<!-- <tr>
							<th CL="STD_IBPROT">입고불허</th><td>
							<select Combo="WmsAdmin,IBPROTCOMBO" name="IBPROT" id="IBPROT" validate="required">
								<option value="">선택</option>
							</select>
						</td>
						</tr>
						<tr>
							<th CL="STD_OBPROT">출고제한상품</th><td>
							<select Combo="WmsAdmin,OBPROTCOMBO" name="OBPROT" id="OBPROT" validate="required">
								<option value="">선택</option>
							</select>
						</td>
						</tr> -->
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
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>탭메뉴1</span></a></li>
							<li><a href="#tabs1-2"><span CL='STD_DETAIL'>탭메뉴2</span></a></li>
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
											<!-- <col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_OWNRKY'>화주</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_SKUKEY'>품번코드</th>
												<th CL='STD_DELMAK'>삭제</th>
												<th CL='STD_DESC01'>품명</th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_DESC03'>INVOICE NAME</th>
												<th CL='STD_DESC04'>제조사명</th>
												<th CL='STD_DUOMKY'>DEFAULT UNIT OF MEASURE</th>
												<th CL='STD_MEASKY'>단위구성</th>
												<th CL='STD_DPUTZO'>DEFAULT PUTAWAY ZONE</th>
												<th CL='STD_DPUTLO'>DEFAULT PUTAWAY LOCATION</th>
												<th CL='STD_LOCARV'>기본입하지번</th>
												<th CL='STD_PLOCOV'>Default picking location for over allocation</th>
												<th CL='STD_PASTKY'>적치전략키</th>
												<th CL='STD_ALSTKY'>할당전략키</th>
												<th CL='STD_IBPROT'>Inbound protection</th>
												<th CL='STD_OBPROT'>Outbound protection</th>
												<th CL='STD_ABCANV'>ABC analyzed value</th>
												<th CL='STD_SKUG01'>품목유형1</th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'>시리즈</th>
												<th CL='STD_SKUG05'>규격</th>
												<th CL='STD_SKUL01,3'>납품방법</th>
												<th CL='STD_SKUL02,3'>분류체계명</th>
												<th CL='STD_LOTL01'>공급통화코드</th>
												<th CL='STD_LOTL02'>원산지국가코드</th>
												<th CL='STD_LOTL03'>구매담당자 id</th>
												<th CL='STD_LOTL04'>구매담당자 명</th>
												<th CL='STD_LOTL05'>구매담당자 폰번호</th>
												<th CL='STD_LOTL06'>구매담당자 전화번호</th>
												<th CL='STD_LOTL07'>구매담당자 이메일</th>
												<th CL='STD_LOTL08'>구매담당자 이메일2</th>
												<th CL='STD_EANCOD'>BARCODE</th>
												<th CL='STD_GTINCD'>BARCODE</th>
												<th CL='STD_WEIGHT'>중량</th>
												<th CL='STD_GRSWGT'>GROSS WEIGHT</th>
												<th CL='STD_NETWGT'>NET WEIGHT</th>
												<th CL='STD_WGTUNT'>WEIGHT UNIT</th>
												<th CL='STD_LENGTH'>LENGTH</th>
												<th CL='STD_WIDTHW'>WIDTH</th>
												<th CL='STD_HEIGHT'>높이</th>
												<th CL='STD_CUBICM'>CUBIC METER(CBM)</th>
												<th CL='STD_CAPACT'>CAPACITY</th>
												<th CL='STD_BATMNG'>적정관리여부</th>
												<th CL='STD_BUFMNG'></th>
												<th CL='STD_ASKU05,3'></th>
												<th CL='STD_CREDAT'>생성일자</th>
												<th CL='STD_CRETIM'>생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_NMLAST'>생성자명</th>
												<th CL='STD_LMODAT'>수정일자</th>
												<th CL='STD_LMOTIM'>수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_NMLAST,2'>생성자명</th>
												<th CL='STD_SKUTYPE'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="check,DELMAK"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,DESC03"></td>
												<td GCol="text,DESC04"></td>
												<td GCol="text,DUOMKY"></td>
												<td GCol="input,MEASKY"></td>
												<td GCol="input,DPUTZO,SHZONMA" GF="S 10"></td>
												<td GCol="input,DPUTLO,SHVRCVLO1" GF="S 20" ></td>
<!-- 												<td GCol="input,DPUTLO,SHVRCVLO1" GF="S 20" validate="required"></td> -->
												<td GCol="input,LOCARV,SHVRCVLO1" GF="S 20" ></td>
<!-- 												<td GCol="input,LOCARV,SHVRCVLO1" GF="S 20" validate="required,VALID_M0904"></td> -->
												<td GCol="input,PLOCOV"></td>
												<td GCol="input,PASTKY,SHPASTH" GF="S 20"></td>
<!-- 												<td GCol="input,PASTKY,SHPASTH" validate="required,VALID_M0408" GF="S 20"></td> -->
												<td GCol="input,ALSTKY,SHALSTH" GF="S 10"></td>
<!-- 												<td GCol="input,ALSTKY,SHALSTH" validate="required,VALID_M0411" GF="S 10"></td> -->
												<td GCol="check,IBPROT"></td>
												<td GCol="check,OBPROT" ></td> 
												<td GCol="input,ABCANV" GF="S 4"></td>
												<td GCol="text,SKUG01"></td>
												<!-- <td GCol="select,SKUG01">
													<select CommonCombo="SKUG01">
														<option value=""> </option>
													</select>
												</td> -->
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>                                                        
												<td GCol="text,SKUG05"></td>  
												<td GCol="check,SKUL01"></td>
												<td GCol="check,SKUL02"></td>
												<td GCol="text,LOTL01"></td>
												<td GCol="text,LOTL02"></td>
												<td GCol="text,LOTL03"></td>
												<td GCol="text,LOTL04"></td>
												<td GCol="text,LOTL05"></td>
												<td GCol="text,LOTL06"></td>
												<td GCol="text,LOTL07"></td>
												<td GCol="text,LOTL08"></td>
												<td GCol="input,EANCOD"></td>
												<td GCol="input,GTINCD"></td>
												<td GCol="input,WEIGHT"></td>
												<td GCol="input,GRSWGT"></td>
												<td GCol="input,NETWGT"></td>
												<td GCol="input,WGTUNT"></td>
												<td GCol="input,LENGTH"></td>
												<td GCol="input,WIDTHW"></td>
												<td GCol="input,HEIGHT"></td>
												<td GCol="input,CUBICM"></td>
												<td GCol="input,CAPACT"></td>
											<!-- 	
												<td GCol="input,PASTKY,SHPASTH" validate="required,VALID_M0408" GF="S 20"></td>
												<td GCol="input,ALSTKY,SHALSTH" validate="required,VALID_M0411" GF="S 10"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="select,ASKU04">
													<select>
														<option value=""></option>
														<option value="S" CL='STD_ASKU_S'></option>
														<option value="P" CL='STD_ASKU_P'></option>
													</select>
												</td>
												<td GCol="text,ASKL02"></td>
												
												<td GCol="text,SKUL03"></td>
												<td GCol="text,SKUL04"></td>                                                        
												<td GCol="text,SKUL05"></td>    
												<td GCol="text,QTDUOM" GF="N"></td>
												<td GCol="text,QTYSTD" GF="N"></td>
												<td GCol="text,QTYCNT" GF="N"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKL01"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,OUTDMT"></td>
												<td GCol="input,RIMDMT" GF="N 5"></td>
 												<td GCol="input,INNDPT" GF="N 5">
												<td GCol="select,INNDPT">
													<select>
														<option value=""></option>
														<option value="1" CL='STD_WEEK01'></option>
														<option value="2" CL='STD_WEEK02'></option>
														<option value="3" CL='STD_WEEK03'></option>
														<option value="4" CL='STD_WEEK04'></option>
													</select>
												</td>
												<td GCol="input,SECTWD" GF="N 5"></td> -->
												<td GCol="check,BATMNG"></td>
												<td GCol="check,BUFMNG"></td>
												<td GCol="check,ASKU05"></td>
												<!-- <td GCol="text,UOMDIN"></td>
												<td GCol="text,UOMDOU"></td>
												<td GCol="text,UOMDTA"></td>
												<td GCol="input,WEIGHT" GF="N 20,3"></td>
												<td GCol="select,WEIGHT">
													<select Combo="WmsAdmin,WEIGHTCOMBO"></select> 
												</td> -->
												<td GCOL="text,CREDAT" GF="C"></td>
												<td GCOL="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCOL="text,CUSRNM"></td>
												<td GCOL="text,LMODAT" GF="C"></td>
												<td GCOL="text,LMOTIM" GF="T"></td>
												<td GCOL="text,LMOUSR"></td>
												<td GCOL="text,LUSRNM"></td>
												<td GCol="select,ASKL03">
													<select CommonCombo="ASKL03">
														<option value="">SELECT</option>
													</select>
												</td>
											</tr>									
										</tbody>
									</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">	
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<!-- <button type="button" GBtn="copy"></button> -->
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

						<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2"  GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_GENERAL">일반</h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="5%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_SKUKEY'>품번코드</th>
												<td>
													<input type="text" name="SKUKEY" readonly="readonly"/>
													<select CommonCombo="SKUG01" name="SKUG01" disabled="disabled"></select>
												</td>
												<!-- <td GCol="select,SKUG01">
												</td> -->
												<th CL='STD_DELMAK'></th>
												<td>
													<input type="checkbox" name="DELMAK" value="V" disabled="disabled"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_DESC01'>품명</th>
												<td>
													<input type="text" name="DESC01" size="60" readonly="readonly"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_WAREKY'>거점</th>
												<td>
													<input type="text" name="WAREKY" readonly="readonly"/>
												</td>
												<th CL='STD_OWNRKY'>화주</th>
												<td>
													<input type="text" name="OWNRKY" readonly="readonly"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_SKUINFO"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_DUOMKY'>단위</th>
												<td>
													<input type="text" name="DUOMKY" readonly="readonly"/>
												</td>
												<th CL='STD_MEASKY'>단위구성</th>
												<td>
													<input type="text" name="MEASKY" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_TB_SKU_ITM1_5"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_PASTKY'>적치전략키</th>
												<td>
													<input type="text" name="PASTKY"/>
												</td>
												<th  CL='STD_DPUTZO'>기본 적치구역</th>
												<td>
													<input type="text" name="DPUTZO"/>
												</td>
												<th  CL='STD_DPUTLO'>기본 적치지번</th>
												<td>
													<input type="text" name="DPUTLO"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_ETC"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_LOCARV'>기본입하지번</th>
												<td>
													<input type="text" name="LOCARV"/>
												</td>
												<th CL='STD_ALSTKY'>할당전략키</th>
												<td>
													<input type="text" name="ALSTKY"/>
												</td>
												<th CL='STD_OBPROT'>출하불허</th>
												<td>
													<input type="checkbox" name="OBPROT" value="V" disabled="disabled"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_SAFQTY'>안전재고수량</th>
												<td>
													<input type="text" name="SAFQTY"/>
												</td>
												<th CL='STD_QTYBOX'>박스수량</th>
												<td>
													<input type="text" name="QTYBOX" readonly="readonly"/>
												</td>
											</tr>
										</tbody>
									</table>
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