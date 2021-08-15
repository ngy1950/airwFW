<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
midAreaHeightSet = "200px";
	var flag; //버튼 flag - 조회 : S / 생성 : C
	var reSearchFlag = "NO"; //재조회 flag - 일반 : NO / 재조회 : OK
	var todayDate;
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridList1",
			editable : true,
			module : "EtcOutbound",
			autoCopyRowType : false,
			itemGrid : "gridList2",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridList2",
			editable : true,
			module : "EtcOutbound",
			autoCopyRowType : false,
			headGrid : "gridList1"

		});
		
		var $comboList = $('#searchArea').find("select[Combo]");
		uiList.setActive("Save", false); //저장버튼 숨김
		
		day(); //오늘날짜 구하기
	});
	
	function day(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			uiList.setActive("Save", false);
			uiList.tabOpen("gridTebs", 0);
			searchList(btnName);
			
		}else if( btnName == "Save" ){ //저장
			saveData();
		
		}else if( btnName == "Create" ){ //생성
			uiList.setActive("Save", true);
			uiList.tabOpen("gridTebs", 0);
			searchList(btnName);
		}
	}
	
	//헤더 조회 
	function searchList(btnName){
		if( validate.check("searchArea") ){
			reSearchFlag = "NO"; //재조회 플래그
			
			var param = inputList.setRangeMultiParam("searchArea");
			gridList.setReadOnly("gridList2", true, ["SKUCLS", "RSNADJ", "PRCQTY"]);
			
			if( btnName == "Search" ){ //조회버튼 
				param.put("INSTYP", "S");
				gridList.gridList({
					id : "gridList1",
					command : "S_EO12H",
					param : param
				});
				flag = "S";
			}else if( btnName == "Create" ){ //생성버튼
				gridList.setReadOnly("gridList2", false, ["PRCQTY"]);
				param.put("INSTYP", "C");
				gridList.gridList({
					id : "gridList1",
					command : "C_EO12H",
					param : param
				});
				flag = "C";
			}
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridList1", rowNum);
		
		if(reSearchFlag != "OK"){
			rowData.putAll(inputList.setRangeMultiParam("searchArea"));
		}
		
		if( flag == "S" ){ //조회 또는 재조회
			gridList.gridList({
				id : "gridList2",
				command : "S_EO12I",
				param : rowData
			});
			
		}else if( flag == "C" ){ //생성
			gridList.gridList({
				id : "gridList2",
				command : "C_EO12I",
				param : rowData
			});
			
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList1" && dataLength == 0 ){
			gridList.resetGrid("gridList2");
			uiList.setActive("Save", false);
		}else if( gridId == "gridList1" && dataLength > 0 ){
			if(flag == "S") {
				uiList.setActive("Save", false);
			} else if(flag == "C") {
				uiList.setActive("Save", true);
			}
		}
	}
	
	//저장후 조회
	function reSearchList(SADJKY){
		var sArea = inputList.setRangeMultiParam("searchArea");
		gridList.setReadOnly("gridList2", true, ["SKUCLS", "PRCQTY", "RSNADJ"]);
		
		uiList.setActive("Save", false); //저장버튼 숨김
		
		var reParam = new DataMap();
		reParam.put("WAREKY", sArea.get("WAREKY"));
		reParam.put("SADJKY", SADJKY);
		reParam.put("RESEARCH", "OK");
		reParam.put("INSTYP", "R");
		
		gridList.gridList({
			id : "gridList1",
			command : "S_EO12H",
			param : reParam
		});
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList2", "modify") ){
			var head = gridList.getRowData("gridList1", gridList.getFocusRowNum("gridList1"));
			var item = gridList.getSelectData("gridList2", "A");
			var itemLen = item.length;
			
			if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return;
			}
			
			if( head.get("CREDAT") != todayDate ){
				commonUtil.msgBox("OUT_M0301"); //당일 폐기요청건만 취소 가능합니다
				return false;
			}
			
			if( !commonUtil.msgConfirm("OUT_M0305") ){ //폐기취소 하시겠습니까?
				return false;
			}
			
			head.put("CNLKEY", head.get("SADJKY"));
			head.put("PROGID", "EO12");
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("HHTTID", "WEB");
			param.put("INSTYP", "C");
			
			netUtil.send({
				url : "/wms/etcOutbound/json/saveEO12.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			if( data.CNT > 0 ){
				commonUtil.msgBox("MASTER_M0815", data.CNT); //[{0}]이 저장되었습니다.
				gridList.resetGrid("gridList1");
				gridList.resetGrid("gridList2");
				
				//저장건 재조회
				reSearchFlag = "OK"; //재조회
				flag = "S"; //조회버튼쿼리
				reSearchList(data.SADJKY);
				
				//top 재조회
				window.parent.parent.frames["header"].countCall();
			}else if( data.CNT < 1 ){
				commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
			}
		}
	}
	
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		if ( colName == "PRCQTY" ){//수량
			var NumColValue = Number(colValue);
			var orginalQty = Number(rowData.get("ORGPRCQTY"));
			
			if( NumColValue == 0 ){
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
// 				commonUtil.msgBox("OUT_M0299"); //폐기수량은 0보다 커야합니다.
				alert("취소수량은 0보다 커야 합니다.");
				return false;
			}
			
			if( orginalQty <= NumColValue ){
				gridList.setColValue(gridId, rowNum, "PRCQTY", orginalQty); //기존반품수량
				commonUtil.msgBox("OUT_M0302"); //폐기취소수량은 기존 폐기수량보다 클 수 없습니다.
				return false;
			}
			
		}
		
	}


	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param, true);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if(data.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(data);
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			param.put("WARECODE","Y");
			
			if( id == "SKUCLS" ){
				param.put("CODE", "SKUCLS");
			}
			
			return param;
			
		}else if( comboAtt == "WmsInventory,RSNADJCOMBO" ){
			param.put("DOCUTY","423");
			return param;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Create ADD BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" style="height:100px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="450" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="SKUKEY" UIInput="SR,SHSKUMA" />
											</td>
											<th CL="STD_SADJKY,3"></th>
											<td>
												<input type="text" name="AH.SADJKY" UiRange="2" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DISDAT"></th>
											<td>
												<input type="text" name="AH.DOCDAT" UiRange="2" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-3" ><span CL="STD_DISUSD"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList1">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td><!-- 물류센터 -->
												<td GH="100 STD_SADJKY,3"  GCol="text,SADJKY"></td><!-- 조정번호 -->
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td><!-- 생성일자 -->
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td><!-- 생성시간 -->
												<td GH="100 STD_CREUSR"    GCol="text,CREUSR"></td><!-- 생성자명 -->
												<td GH="100 STD_CUSRNM"    GCol="text,CUSRNM"></td>
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
<!-- 													<button type="button" GBtn="total"></button> -->
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
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-4" ><span CL="STD_RESKUNM"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList2">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="120 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												
												<td GH="80 STD_ATTL10"    GCol="input,PRCQTY"  GF="N 7" validate="required gt(0),MASTER_M4002"></td>
												<td GH="100 STD_DISCOD"   GCol="select,RSNADJ" validate="required">
													<select Combo="WmsInventory,RSNADJCOMBO"   ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"   GF="D"/></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"   GF="D"/></td>
												<td GH="80 STD_SKUCNM"    GCol="select,SKUCLS" readonly>
													<select Combo="Common,COMCOMBO" ComboCodeView=false id="SKUCLS" name="SKUCLS">
													</select>
												</td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="60 STD_AREAKY"    GCol="text,AREANM"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="80 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"   GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"   GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"   GF="N"></td>
												
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
<!-- 													<button type="button" GBtn="total"></button> -->
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