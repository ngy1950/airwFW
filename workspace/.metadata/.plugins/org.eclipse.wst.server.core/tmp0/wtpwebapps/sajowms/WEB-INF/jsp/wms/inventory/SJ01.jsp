<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	var todayDate;
	$(document).ready(function(){
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory", 
			command : "SJ01",
			autoCopyRowType : false
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
// 		var areaList = inputList.getMultiComboValue("AREAKY");
// 		var newList = new Array();
// 		for(var i=0; i<areaList.length; i++){
// 			if( areaList[i] != "STK" ){ //강서 비가용 = 'STK'
// 				newList.push(areaList[i]);
// 			}
// 		}
// 		inputList.setMultiComboValue($("#AREAKY"), newList);
		
		day(); //오늘날짜 구하기
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}else if( btnName == "Save" ){
			saveData();
		}
	}
	
	//헤더 조회 
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList", "select") ){
			var head = new DataMap();
			var list = gridList.getSelectData("gridList");
			
			if( list.length == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return false;
			}
			
			var listRowData;
			for ( var i=0; i< list.length; i++){
				listRowData = list[i];
				var mnglt9 = $.trim(listRowData.get("MNGLT9")); //유통기한관리여부
				var mngmov = listRowData.get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = listRowData.get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = listRowData.get("LOTL01"); //skuma 유통기한 관리여부
				var lota06 = listRowData.get("LOTA06"); //재고상태
				var alota08 = $.trim(listRowData.get("ALOTA08")); //입력제조일자
				var alota09 = $.trim(listRowData.get("ALOTA09")); //입력유통기한
				var desc01 = listRowData.get("DESC01"); //상품명
				
				// 제조일자 및 유통기한 변경 안된건 체크
				if( alota08 == listRowData.get("LOTA08") 
				 || alota09 == listRowData.get("LOTA09")){
					commonUtil.msgBox("INV_M1015"); //제조일자 및 유통기한 변경이 안된 상품이 존재합니다.
					return false;
				}
				
				//유통기한 필수여부 체크
// 				if( lota06 == "00" || lota06 == "10" ){
// 					if( mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" && alota09 == "" ){
// 						commonUtil.msgBox("INV_M1013", desc01); //[{0}]은 유통기한 필수입력 상품입니다.
// 						return false;
// 					}
// 				}
				
				//제조일자 필수여부 체크
// 				if( lotl01 == "Y" && mnglt9 == "" && $.trim(alota08) == "" ){
// 					commonUtil.msgBox("INV_M1017", desc01); //[{0}]은 제조일자는 필수입력 상품입니다.
// 					return false;
// 				}
			}
			
			var param = new DataMap();
			param.put("list", list);
			param.put("ADJUTY", "410");
			param.put("HHTTID", "WEB");
			param.put("INSTYP", "U");
			param.put("WAREKY", "<%=wareky%>");
			
			
			netUtil.send({
				url : "/wms/inventory/json/saveSJ01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
// 			if( json && json.data ){
// 				if( json.data.CNT > 0 ){
// 					commonUtil.msgBox("MASTER_M0815", json.data.CNT); //[{0}]이 저장되었습니다.
// 					searchList();
// 				}else if( json.data.CNT < 1 ){
// 					commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
// 				}
// 			}
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if( json.data.CNT > 0 ){
				commonUtil.msgBox("MASTER_M0815", json.data.CNT); //[{0}]이 저장되었습니다.
				searchList();
			}else if( json.data.CNT < 1 ){
				commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		if ( colName == "PRCQTY" ){ //수량
			var NumColValue = Number(colValue);
			var prcuom = rowData.get("PRCUOM");
			
			if( NumColValue <= 0 ){
				gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
				gridList.setColValue(gridId, rowNum, "QTADJU", "0"); //조정수량
				commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다.
				return false;
				
			}else if( Number(rowData.get("QTSIWH")) < NumColValue ){
				gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
				gridList.setColValue(gridId, rowNum, "QTADJU", "0"); //조정수량
				commonUtil.msgBox("INV_M1012"); //수량은 재고수량보다 작거나 같아야합니다.
				return false;
			}
			
			//조정수량 계산
			if( prcuom == "EA" ){
				gridList.setColValue(gridId, rowNum, "QTADJU", NumColValue); //낱개
				
			}else if( prcuom == "CS" ){
				var csQty = Number(rowData.get("BOXQTY")) * NumColValue;
				if( csQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*박스 수량과 재고수량 비교
				if( Number(rowData.get("QTSIWH")) < csQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", csQty);
				
			}else if( prcuom == "IP" ){
				var ipQty = Number(rowData.get("INPQTY")) * NumColValue;
				if( ipQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*이너팩 수량과 재고수량 비교
				if( Number(rowData.get("QTSIWH")) < ipQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", ipQty);
				
			}else if( prcuom == "PL" ){
				var plQty = Number(rowData.get("PALQTY")) * NumColValue;
				if( plQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*팔레트 수량과 재고수량 비교
				if( Number(rowData.get("QTSIWH")) < plQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", plQty);
			}
			
		}else if ( colName == "PRCUOM" ){ //단위
			gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
			gridList.setColValue(gridId, rowNum, "QTADJU", "0"); //조정수량
			
		}else if ( colName == "ALOTA08" ){ //제조일자
			// 오늘일자 < 제조일자
			if( todayDate < colValue ){
				commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
				gridList.setColValue(gridId, rowNum, colName, rowData.get("LOTA08"));
				gridList.setColValue(gridId, rowNum, "ALOTA09", rowData.get("LOTA09"));
				return false;
			}
			
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, colName, "");
				gridList.setColValue(gridId, rowNum, "ALOTA09", "");
				return false;
			}
		
			if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" ){
				commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
				gridList.setColValue(gridId, rowNum, colName, "");
				gridList.setColValue(gridId, rowNum, "ALOTA09", "");
				return false;
			}
			
			var param = new DataMap();
			param.put("ALOTA08", colValue);
			param.put("DUEMON", rowData.get("DUEMON"));
			param.put("DUEDAY", rowData.get("DUEDAY"));
			
			var json = netUtil.sendData({
				module : "WmsInventory",
				command : "SJ01DATE",
				sendType : "list",
				param : param
			});
			
			//일자체크
			if( json && json.data ){
				if( json.data[0].DUEDAY != colValue ){
					gridList.setColValue(gridId, rowNum, "ALOTA09", json.data[0].DUEDAY);
				}
			}
			
		}else if ( colName == "ALOTA09" ){ //유통기한
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, colName, "");
				gridList.setColValue(gridId, rowNum, "ALOTA08", "");
				return false;
			}
			
			if( $.trim(rowData.get("ALOTA08")) != "" ){
				gridList.setColValue(gridId, rowNum, "ALOTA08", "");
			}
			
// 			if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" ){
// 				commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
// 				gridList.setColValue(gridId, rowNum, colName, "");
// 				gridList.setColValue(gridId, rowNum, "ALOTA08", "");
// 				return false;
// 			}
			
// 			var param = new DataMap();
// 			param.put("ALOTA09", colValue);
// 			param.put("DUEMON", rowData.get("DUEMON"));
// 			param.put("DUEDAY", rowData.get("DUEDAY"));
			
// 			var json = netUtil.sendData({
// 				module : "WmsInventory",
// 				command : "SJ01DATE",
// 				sendType : "list",
// 				param : param
// 			});
			
// 			//일자체크
// 			if( json && json.data ){
				
// 				// 오늘일자 < 제조일자
// 				if( todayDate < json.data[0].DUEDAY ){
// 					commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
// 					gridList.setColValue(gridId, rowNum, colName, rowData.get("LOTA09"));
// 					gridList.setColValue(gridId, rowNum, "ALOTA08", rowData.get("LOTA08"));
// 					return false;
// 				}
				
// 				if( json.data[0].DUEDAY != colValue ){
// 					gridList.setColValue(gridId, rowNum, "ALOTA08", json.data[0].DUEDAY);
// 				}
// 			}
		}
	}
	
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
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
		gridList.setColValue(gridId, rowNum, "QTADJU", 0); //반품수량
		
		if(select == "N"){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("INV_M1010"); //조정수량은 0보다 커야합니다.
			
		}else if( select == "S" ){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("INV_M1007"); //조정수량이 재고수량을 초과합니다. 다시 입력해 주세요.
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
		if( data.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(data);
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsInventory,SJ_AREACOMBO" ){
			//검색조건 AREA 콤보
// 			param.put("USARG1", "STOR");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "PRCUOM" ){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("CODE", "UOMKEY");
// 				param.put("USARG1", "V");
				
			}
			return param;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="420" />
										<col width="50" />
										<col width="420" />
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
											<th CL="STD_AREAKY"></th>
											<td>
												<select id="AREAKY" name="AR.AREAKY" Combo="WmsInventory,SJ_AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY"></th>
											<td>
												<input type="text" name="SK.ZONEKY" UIInput="SR,SHZONMA" UIformat="U" />
											</td>
										</tr>
										<tr>
											<th CL="STD_LOCAKY"></th>
											<td>
												<input type="text" name="SK.LOCAKY" UIInput="SR,SHLOCMA" UIformat="U" />
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" id="SKUKEY" name="SK.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" />
											</td>
											<th CL="STD_LOTA01"></th>
											<td>
												<select id="LOTL01" name="LOTL01" style="width:160px">
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_LOTA08"></th>
											<td>
												<input type="text" name="SK.LOTA08" UIInput="R" UIFormat="C" />
											</td>
											<th CL="STD_LOTA09"></th>
											<td>
												<input type="text" name="SK.LOTA09" UIInput="R" UIFormat="C" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" ><span CL="STD_LIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="120 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY"    GCol="text,SHORTX"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"   GCol="text,ZONENM"></td>
												<td GH="80 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LOT6NM"></td>
												<td GH="80 STD_QTSIWH"    GCol="text,QTSIWH"    GF="N"></td>
												
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY"   GF="N 7" validate="required gt(0),MASTER_M4002"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM"  validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_QTADJU"    GCol="text,QTADJU"     GF="N" validate="required gt(0),MASTER_M4002"></td>
												<td GH="100 STD_LOTL01"   GCol="text,LOTL01"/></td>
												<td GH="100 STD_LOTA08"   GCol="input,ALOTA08"   GF="C"/></td>
												<td GH="100 STD_LOTA09"   GCol="input,ALOTA09"   GF="C"/></td>
												
												<td GH="80 STD_SKUCNM"    GCol="text,SKUCNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"    GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"    GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"    GF="N"></td>
												
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