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
	var flag; //버튼 flag - 조회 : S / 생성 : C
	var reSearchFlag = "NO"; //재조회 flag - 일반 : NO / 재조회 : OK
	midAreaHeightSet = "200px";
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
		
		//멀티셀렉트 check
		inputList.setMultiComboSelectAll($("#SKUCLS"), true);
		var $comboList = $('#searchArea').find("select[Combo]");
		
		uiList.setActive("Save", false); //저장버튼 숨김
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList(btnName);
		}else if( btnName == "Save" ){ //저장
			saveData();
		}else if( btnName == "Create" ){ //생성
			searchList(btnName);
		}else if( btnName == "Reflect" ){ //일괄적용
			var selectData = $("select[name=Reflect]").val();
			var list = gridList.getSelectData("gridList2");
			var listLen = list.length;
			
			if( $.trim(selectData) == "" ){
				commonUtil.msgBox("OUT_M0300"); //폐기사유를 선택해주세요.
				return false;
			}
			
			if( listLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return false;
			}
			
			for( var i=0; listLen>i; i++ ){
				var listRowNum = list[i].get("GRowNum");
				gridList.setColValue("gridList2", listRowNum, "RSNADJ", selectData);
			}
		}
	}
	
	//헤더 조회 
	function searchList(btnName){
		if( validate.check("searchArea") ){
			reSearchFlag = "NO"; //재조회 플래그
			
			var param = inputList.setRangeMultiParam("searchArea");
			gridList.resetGrid("gridList2");
			gridList.setReadOnly("gridList2", true, ["PRCQTY", "PRCUOM", "RSNADJ", "SKUCLS"]);
			
			if( btnName == "Search" ){ //조회버튼
				param.put("INSTYP", "S");
				gridList.gridList({
					id : "gridList1",
					command : "S_EO11H",
					param : param
				});
				flag = "S";
			}else if( btnName == "Create" ){ //생성버튼
				gridList.setReadOnly("gridList2", false, ["PRCQTY", "PRCUOM", "RSNADJ"]);
				param.put("INSTYP", "C");	
				gridList.gridList({
					id : "gridList1",
					command : "C_EO11H",
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
				command : "S_EO11I",
				param : rowData
			});
		}else if( flag == "C" ){ //생성
			gridList.gridList({
				id : "gridList2",
				command : "C_EO11I",
				param : rowData
			});
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList1" && dataLength == 0 ){
			gridList.resetGrid("gridList2");
			$("select[name=Reflect]").val("");
			$("select[name=Reflect]").attr("disabled", true); //폐기사유 disabled
			uiList.setActive("Save", false);
			uiList.setActive("Reflect", false);
		}else if( gridId == "gridList1" && dataLength > 0 ){
			if(flag == "S") {
				$("select[name=Reflect]").val("");
				$("select[name=Reflect]").attr("disabled", true); //폐기사유 disabled
				uiList.setActive("Save", false);
				uiList.setActive("Reflect", false);
			} else if(flag == "C") {
				$("select[name=Reflect]").val("");
				$("select[name=Reflect]").attr("disabled", false);
				uiList.setActive("Save", true);
				uiList.setActive("Reflect", true);
			} else {
				$("select[name=Reflect]").val("");
				$("select[name=Reflect]").attr("disabled", true); //폐기사유 disabled
				uiList.setActive("Save", false);
				uiList.setActive("Reflect", false);
			}
		}
	}
	
	//저장후 조회
	function reSearchList(SADJKY){
		var sArea = inputList.setRangeMultiParam("searchArea");
		gridList.setReadOnly("gridList2", true, ["SKUCLS", "PRCQTY", "PRCUOM", "RSNADJ"]);
		
		uiList.setActive("Save", false); //저장버튼 숨김
		uiList.setActive("Reflect", false); //일괄적용버튼 숨김
		$("select[name=Reflect]").val(""); //폐기사유 초기값 
		$("select[name=Reflect]").attr("disabled", true); //폐기사유 disabled
		
		var reParam = new DataMap();
		reParam.put("WAREKY", sArea.get("WAREKY"));
		reParam.put("DOCUTY", sArea.get("DOCUTY"));
		reParam.put("SADJKY", SADJKY);
		reParam.put("INSTYP", "R");
		
		gridList.gridList({
			id : "gridList1",
			command : "S_EO11H",
			param : reParam
		});
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList2", "modify") ){
			var head = gridList.getRowData("gridList1", gridList.getFocusRowNum("gridList1"));
			var item = gridList.getSelectData("gridList2", "A");
			var headLen = head.length; 
			var itemLen = item.length; 
			
			if( headLen == 0 && itemLen == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}else if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return;
			}
			
			if( !commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM) ){
				return; // confirm : 저장하시겠습니까? 
			}
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("PROGID", "EO11");
			param.put("HHTTID", "WEB");
			param.put("INSTYP", "U");
			
			netUtil.send({
				url : "/wms/etcOutbound/json/saveEO11.data",
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
		
		if ( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
			var NumColValue = Number(colValue);
			var NumQtsiwh = Number(rowData.get("QTSIWH"));
			var prcuom = rowData.get("PRCUOM");
			
			if( NumColValue == 0 ){
				colChangeNum(gridId, rowNum, "N");
// 				commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다.
				return false;
			}
			
			if( NumQtsiwh < NumColValue ){
				colChangeNum(gridId, rowNum, "S");
				return false;
			}
			
			//반품수량 계산
			if( prcuom == "EA" ){ //낱개
				gridList.setColValue(gridId, rowNum, "QTADJU", NumColValue);
				
			}else if( rowData.get("PRCUOM") == "CS" ){//박스
				var csQty = Number(rowData.get("BOXQTY")) * NumColValue;
				if( csQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*박스 수량과 재고수량 비교
				if( NumQtsiwh < csQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", csQty);
				
			}else if( prcuom == "IP" ){ //이너팩
				var ipQty = Number(rowData.get("INPQTY")) * NumColValue;
				if( ipQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*이너팩 수량과 재고수량 비교
				if( NumQtsiwh < ipQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", ipQty);
				
			}else if( prcuom == "PL" ){ //팔레트
				var plQty = Number(rowData.get("PALQTY")) * NumColValue;
				if( plQty == 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량*팔레트 수량과 재고수량 비교
				if( NumQtsiwh < plQty ){
					colChangeNum(gridId, rowNum, "S");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "QTADJU", plQty);
			}
		}else if ( colName == "PRCUOM" ){ ////////////////////////////////단위////////////////////////////////
			colChangeNum(gridId, rowNum);
			return false;
		}
		
	}
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
		gridList.setColValue(gridId, rowNum, "QTADJU", 0); //반품수량
		
		if(select == "N"){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("OUT_M0299"); //폐기수량은 0보다 커야합니다.
			
		}else if( select == "S" ){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("OUT_M0298"); //폐기수량이 재고수량을 초과합니다. 다시 입력해 주세요.
		
		}
	}
	
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if( searchCode == "SHSKUMA" ){
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
			}else if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
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
											
											<th CL="STD_SKUCNM"></th>
											<td>
												<select id="SKUCLS" name="SW.SKUCLS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="SK.SKUKEY" UIInput="SR,SHSKUMA" />
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
												<td GH="100 STD_SADJKY,3"  GCol="text,SADJKY"></td><!-- 조정번호 -->
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td><!-- 물류센터 -->
												<td GH="100 STD_DISDAT"    GCol="text,DOCDAT"  GF="D"></td>
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
						
							<div class="reflect">
								폐기사유
								<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false name="Reflect">
									<option value="">선택</option>
								</select>
								<button CB="Reflect REFLECT BTN_REFLECT"></button>
							</div>
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridList2">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="120 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="80 STD_QTSIWH"    GCol="text,QTSIWH"   GF="N"></td>
												
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY"  GF="N 7" validate="required gt(0),MASTER_M4002"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM" validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_DISQTY"    GCol="text,QTADJU"   GF="N"></td>
												<td GH="100 STD_DISCOD"   GCol="select,RSNADJ" validate="required">
													<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"   GF="D"/></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"   GF="D"/></td>
												<td GH="80 STD_SKUCNM"    GCol="select,SKUCLS">
													<select Combo="Common,COMCOMBO" ComboCodeView=false id="SKUCLS" name="SKUCLS">
													</select>
												</td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="60 STD_AREAKY"    GCol="text,SHORTX"></td>
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