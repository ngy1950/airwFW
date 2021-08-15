<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var userInfoData;
	$(document).ready(function(){
		setTopSize(200);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			pkcol : "RECVKY",
			module : "WmsInbound",
			command : "GR15"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			module : "WmsInbound",
			command : "GR15Sub"
	    });
		
		userInfoData = page.getUserInfo();
		dataBind.dataNameBind(userInfoData, "searchArea");
		
		//$("#combo112").hide();
		$("#LOCA").removeAttr("readonly");
		$("#LOCA").val("");
		
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });

			gridList.gridList({
		    	id : "gridListSub",
		    	param : param
		    });
			
			uiList.setActive("Save", true);
			uiList.setActive("Print", false);
			gridList.setReadOnly("gridListHead", false);
			gridList.setReadOnly("gridListSub", false);
			gridList.setReadOnly("gridListSub", true, ['LOTA06']);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_ADD, true);
			gridList.setBtnView("gridListSub", configData.GRID_BTN_DELETE, true);
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		/* var param = inputList.setRangeParam("searchArea");
		var RCPTTY = param.get("RCPTTY");
		if(RCPTTY == "111"){
			gridList.setColValue("gridListSub", 0, "LOCAKY", "PRDLOC");
		} */
		gridList.setRowState(gridId, configData.GRID_ROW_STATE_INSERT);
		gridList.setColFocus("gridListSub", 0, "SKUKEY");          
	}
	
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridListSub" && rowNum == 0){
			return false;
		}
		return true;
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridListSub"){
			var newData = gridList.getRowData("gridListSub", 0);
			newData.put("SKUKEY", "");
			newData.put("DESC01", "");
			newData.put("DESC02", "");
			newData.put("QTDUOM", "");
			newData.put("DUOMKY", "");
			newData.put("BOXQTY", "");
			newData.put("REMQTY", "");
			newData.put("UOMKEY", "");
			newData.put("LOTA01", "");
			newData.put("LOTA03", "");
			newData.put("LOTA09", "");
			newData.put("LOTA13", "");
			newData.put("LOTA14", "");
			newData.put("LOTA16", "");
			newData.put("SKUG05", "");
			newData.put("QTYRCV", "");
			newData.put("LOCAKY", "");
			
			return newData;
		}
	}

	function gridListEventInputColFocus(gridId, rowNum, colName){
		if(gridId == "gridListSub" && colName == "LOTA03"){
			if(commonUtil.leftTrim(gridList.getColData("gridListSub",rowNum,"SKUKEY")," ") == ""){
				commonUtil.msgBox("VALID_M0937");
				gridList.setColFocus("gridListSub", rowNum, "SKUKEY");
			}
		}
	}
	
	function saveData(){
		if( gridList.validationCheck("gridListHead", "modify") && gridList.validationCheck("gridListSub", "modify") ) {

	 	 	if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
	 	 	var RCPTTY = $("#searchArea").find("[name=RCPTTY]").val();
	 	 	var docunum = wms.getDocSeq(RCPTTY);
	    	gridList.gridColModify("gridListHead", 0, "RECVKY", docunum);
			
			var head = gridList.getRowData("gridListHead", 0);

	    	var list = gridList.getGridData("gridListSub");

			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/saveGr15.data",
				param : param
			});
	
			if(json && json.data){
				
				commonUtil.msgBox("IN_M0093", docunum);
				
				var paramH = new DataMap();
				paramH.put("RECVKY", docunum);
				
				var RCPTTY = inputList.setRangeParam("searchArea").get("RCPTTY");
				var RCPTTYNM = $("#searchArea").find("[name=RCPTTY]").find("option[value="+RCPTTY+"]").text();
				paramH.put("RCPTTYNM",RCPTTYNM);
			
				gridList.gridList({
			    	id : "gridListHead",
			    	command : "GR15H",
			    	param : paramH
			    });
				
				gridList.gridList({
			    	id : "gridListSub",
			    	command : "GR15I",
			    	param : paramH
			    }); 
				
				gridList.setReadOnly("gridListHead");
				gridList.setReadOnly("gridListSub");
				uiList.setActive("Save", false);
				uiList.setActive("Print", true);
				gridList.setBtnView("gridListSub", configData.GRID_BTN_ADD, false);
				gridList.setBtnView("gridListSub", configData.GRID_BTN_DELETE, false);
			}
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if (gridId == "gridListSub") {
			if (colName == "SKUKEY") {
				if(colValue != ""){
					
					var param = inputList.setRangeParam("searchArea");
					param.put("SKUKEY", colValue);

					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "SKUKEYval",
						sendType : "map",
						param : param
					});
					
					
					if(json.data["CNT"] >= 1) {

						var param = new DataMap();
						var param = inputList.setRangeParam("searchArea");
						param.put("SKUKEY", colValue);
						
						var json = netUtil.sendData({
							module : "WmsInbound",
							command : "SKUKEY",
							sendType : "map",
							param : param
						});
						
						if(json && json.data){
							gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]);	// 품명
							gridList.setColValue("gridListSub", rowNum, "DESC02", json.data["DESC02"]);	// 품명
							gridList.setColValue("gridListSub", rowNum, "LOTA05", json.data["SKUG04"]);	// 품명
							gridList.setColValue("gridListSub", rowNum, "LOTA13", json.data["RIMDMT"]);	
							gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);	// 단위
							gridList.setColValue("gridListSub", rowNum, "QTDUOM", json.data["QTDUOM"]);	// 입수
							gridList.setColValue("gridListSub", rowNum, "QTYRCV", '1');
							/* gridList.setColValue("gridListSub", rowNum, "BOXQTY", json.data["BOXQTY"]);	// 박스수
							gridList.setColValue("gridListSub", rowNum, "REMQTY", json.data["REMQTY"]);	// 잔량 */
							gridList.setColValue("gridListSub", rowNum, "DUOMKY", json.data["DUOMKY"]);	// 단뒤
							gridList.setColValue("gridListSub", rowNum, "QTPUOM", json.data["QTPUOM"]);	// 단뒤 
							gridList.setColValue("gridListSub", rowNum, "SKUG05", json.data["SKUG05"]);
						}
					} else if (json.data["CNT"] < 1) {
						commonUtil.msgBox("VALID_M0206", colValue); //존재하지 않는 sku 입니다.
						
						gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
						gridList.setColValue("gridListSub", rowNum, "DESC01", "");
						gridList.setColValue("gridListSub", rowNum, "DESC02", "");
						gridList.setColValue("gridListSub", rowNum, "LOTA05", "");
						gridList.setColValue("gridListSub", rowNum, "LOTA13", "");
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", "");
						gridList.setColValue("gridListSub", rowNum, "QTDUOM", "");
						gridList.setColValue("gridListSub", rowNum, "QTYRCV", "");
						gridList.setFocus("gridListSub", "SKUKEY");
					}
				}
				
			} else if (colName == "LOCAKY") {
				if(colValue != ""){
					var param = inputList.setRangeParam("searchArea");
					
					param.put("LOCAKY", colValue);
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "LOCAKYval",
						sendType : "map",
						param : param
					});
					
					if (json.data["CNT"] < 1) {
						commonUtil.msgBox("VALID_M0204", colValue);
						
						gridList.setColValue("gridListSub", rowNum, "LOCAKY", "");
						gridList.setFocus("gridListSub", "LOCAKY");
					}
				}
				
			} else if (colName == "QTYRCV" && colValue != "") {
				var rowData = gridList.getRowData(gridId, rowNum);
				var qtyrcv = new Number(rowData.get("QTYRCV"));
				if(qtyrcv <=  0){
					commonUtil.msgBox("IN_M0048");
					gridList.setColValue("gridListSub", rowNum, "QTYRCV", ""); //입고수량
					gridList.setColValue("gridListSub", rowNum, "BOXQTY", ""); //박스수
					gridList.setColValue("gridListSub", rowNum, "REMQTY", ""); //잔량
					gridList.setFocus("gridListSub", rowNum, "QTYRCV");
					return;
				}
				var qtduom = new Number(rowData.get("QTDUOM"));
				var boxnum = parseInt(qtyrcv/qtduom);
				var remqty = qtyrcv - (qtduom*boxnum);
				gridList.setColValue(gridId, rowNum, "BOXQTY", boxnum);
				gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				
			} else if (colName == "LOTA09" && colValue == "00") {
				gridList.setReadOnly("gridListSub", true, ['LOTA07','LOTA08']);
				
			} else if (colName == "LOTA09" && colValue == "10") {
				gridList.setReadOnly("gridListSub", false, ['LOTA07','LOTA08']);
				
			} /* else if (colName == "LOTA16") {
				var rowData = gridList.getRowData(gridId, rowNum);
				var qtyrcv = new Number(rowData.get("QTYRCV"));
				var lota16 = new Number(rowData.get("LOTA16"));
				var lota17 = lota16 * qtyrcv;
				gridList.setColValue(gridId, rowNum, "LOTA17", lota17);
				
			} *//*  else if (colName == "LOTA03") {
				if(colValue != ""){
					var param = inputList.setRangeParam("searchArea");
					
					param.put("LOTA03", colValue);
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "BARCOD",
						sendType : "map",
						param : param
					});
					if(json && json.data){
						gridList.setColValue("gridListSub", rowNum, "LOTA14", json.data["LOTA14"]);	
					}
				}
			} */else if (colName == "LOTA02"){
				var param = new DataMap();
				param.put("LOTA02", colValue);
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "NAME01",
					sendType : "map",
					param : param
				});
				if(json && json.data){
					gridList.setColValue("gridListSub", rowNum, "LOTA02NM", json.data["NAME01"]);	
				}
			}
		}
	}
	
	function reportPrint(){
		var recvky = gridList.getColData(gridListHead, 0, "RECVKY");
		var url = "";
		var where = "AND RH.RECVKY IN ('"+ recvky +"') ";
		
		url = "/ezgen/receiveing_label.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", "<%=langky%>", map, 1250, 900);
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Print"){
			reportPrint();
		}else if(btnName == "Create"){
			barcodCreate();
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHBARCOD"){
			var rowNum = gridList.getFocusRowNum("gridListSub");
			var	skukey = gridList.getColData("gridListSub",rowNum,"SKUKEY");
			
			var param = new DataMap();
			param.put("SKUKEY", skukey)
			return param;
		}else if(searchCode == "SHLOCMA"){
			var param = dataBind.paramData("searchArea");
			param.put("AREAKY", param.get("AREA"));
			param.put("ZONEKY", param.get("ZONE"));
			return param;
		}
	}
	
	function changeRcpty(obj){
		var $obj = $(obj);
		var tmpVal = $obj.val();
		var $lota06 = $("#LOTA06");
		var $loca = $("#LOCA");
		$lota06.removeAttr("disabled");
		if(tmpVal == "111"){
			$("#LOCA").removeAttr("readonly");
			userInfoData.LOCA = "";
			$lota06.val("00");
			$loca.val(userInfoData.LOCA);
		}else if(tmpVal == "112"){
			$lota06.val("10");
			$loca.val(userInfoData.LOCA1);
			$loca.attr("readOnly","readOnly");
		}
		//$lota06.attr("disabled", "disabled");
	}
	
	/* function changeRcpty(obj){
		var $obj = $(obj);
		var tmpVal = $obj.val();
		var $lota06 = $("#LOTA06");
		var $loca = $("#LOCA");
		$lota06.removeAttr("disabled");
		$loca.removeAttr("readOnly");
		if(tmpVal == "111"){
			$lota06.val("00");
			$loca.val(userInfoData.LOCA);
		}else if(tmpVal == "112"){
			$lota06.val("10");
			$loca.val(userInfoData.LOCA1);
		}
		$lota06.attr("disabled", "disabled");
		$loca.attr("readOnly","readOnly");
	} */
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Create CREATE BTN_BARCODCREATE"></button>
		<button CB="Print PRINT BTN_PRINT"></button>
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
			<button CB="Create CREATE BTN_CREATE"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_CONDITIONS">조건</h2>
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
						<th CL="STD_AREAKY"></th>
						<td>
							<input type="text" name="AREA" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY">소속공정</th>
						<td>
							<input type="text" name="ZONE" id="ZONE" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCAKY"></th>
						<td>
							<input type="text" name="LOCA" id="LOCA" readonly="readonly"/>
						</td>
						<td>
							<input type="hidden" name="DEPART" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입하유형</th>
						<td>
							<select Combo="WmsInbound,RECDTYPEGR15" name="RCPTTY" onchange="changeRcpty(this)"></select>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA06">재고상태</th>
						<td>
							<select Combo="WmsInbound,LOTA06COMBO" name="LOTA06" id="LOTA06" ></select>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<th CL='STD_RECVKY,2'></th>	<!-- 입하문서번호 -->
												<th CL='STD_DOCCATNM'></th>	<!-- 문서유형 -->
												<th CL='STD_WAREKY'></th>	<!-- 거점명 -->
												<th CL='STD_DOCDAT'></th>	<!-- 문서일자 -->
												<th CL='STD_ARCPTD'></th>	<!-- 입하일자 -->
												<th CL='STD_RCPTTY'></th>	<!-- 입하유형 -->
												<th CL='STD_RCPTTYNM'></th>	<!-- 입하유형명 -->
												<th CL='STD_STATDO'></th>	<!-- 문서상태 -->
												<th CL='STD_DOCTXT'></th>	<!-- 비고 -->
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
												<th CL='STD_CREDAT'></th>	<!-- 생성일자 -->
												<th CL='STD_CREUSR'></th>	<!-- 생성자 -->
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
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,RECVKY"></td>	
												<td GCol="text,DOCCATNM"></td>
												<td GCol="text,WAREKY"></td>	
												<td GCol="text,DOCDAT"></td>	
												<td GCol="input,ARCPTD" GF="C 8"></td>
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
												<td GCol="text,USRID1"></td>	 
												<td GCol="text,UNAME1"></td>	 
												<td GCol="text,DEPTID1"></td>	 
												<td GCol="text,DNAME1"></td>	 
												<td GCol="text,USRID2"></td>	 
												<td GCol="text,UNAME2"></td>	 
												<td GCol="text,DEPTID2"></td>	 
												<td GCol="text,DNAME2"></td>	 
												<td GCol="input,USRID3"></td>	 
												<td GCol="text,UNAME3"></td>	 
												<td GCol="text,DEPTID3"></td>	 
												<td GCol="text,DNAME3"></td>	 
												<td GCol="text,USRID4"></td>	 
												<td GCol="text,UNAME4"></td>	 
												<td GCol="text,DEPTID4"></td>	 
												<td GCol="text,DNAME4"></td> 
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CREUSR"></td>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
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
												<th CL='STD_RECVIT,2'></th>	
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTYRCV'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOCAKY'></th>
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
												<th CL='STD_SKUG05'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_BOXQTY'>박스수</th>
												<th CL='STD_REMQTY'>잔량</th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CREUSR'></th>
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
										</colgroup>
										<tbody id="gridListSub">
										<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="input,SKUKEY,SHSKUMA" validate="required,VALID_M0406" GF="S 20"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="input,QTYRCV" validate="required,IN_M0062" GF="N 20"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="input,LOCAKY,SHLOCMA" validate="required,VALID_M0404" GF="S 20"></td>	
												<td GCol="input,LOTA01" GF="S 20"></td>
												<!-- <td GCol="select,LOTA02">
													<select Combo="WmsInbound,LOTA02COMBO"></select> 
												</td> -->
												<td GCol="input,LOTA02,SHBZNAME01" validate="required"></td>
												<td GCol="text,LOTA02NM"></td>
												<td GCol="input,LOTA03,SHBARCOD" validate="required,VALID_M0936"></td>
												<td GCol="input,LOTA04" GF="S 20"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select Combo="WmsInbound,LOTA06COMBO"></select> 
												</td>
												<td GCol="input,LOTA07" GF="S 20"></td>
												<td GCol="input,LOTA08" GF="S 20"></td>
												<td GCol="input,LOTA09" GF="S 20"></td>
												<td GCol="input,LOTA10" GF="S 20"></td>
												<td GCol="input,LOTA11" GF="C 8"></td>
												<td GCol="input,LOTA12" GF="C 8"></td>
												<td GCol="input,LOTA13" GF="C 8"></td>
												<td GCol="input,LOTA14" GF="S 20"></td>
												<td GCol="input,LOTA15" GF="S 20"></td>
												<td GCol="input,LOTA16" GF="N 20,3"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="input,LOTA18" GF="N 20,3"></td>
												<td GCol="input,LOTA19" GF="N 20,3"></td>
												<td GCol="input,LOTA20" GF="N 20,3"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTDUOM" GF="N"></td>
												<td GCol="text,BOXQTY" GF="N"></td>
												<td GCol="text,REMQTY" GF="N"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CREUSR"></td>
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
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>	
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