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
	var reqtxt; //결제요청 의견
	midAreaHeightSet = "200px";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "EtcOutbound",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList", 
			editable : true,
			module : "EtcOutbound",
			autoCopyRowType : false,
			headGrid : "gridHeadList"

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
		}
	}
	
	//헤더 조회 
	function searchList(btnName){
		if( validate.check("searchArea") ){
			reSearchFlag = "NO"; //재조회 플래그
			reqtxt = "";
			
			var param = inputList.setRangeMultiParam("searchArea");
			gridList.setReadOnly("gridHeadList", true, ["PTNRKY"]);
			gridList.setReadOnly("gridItemList", true, ["PRCQTY", "PRCUOM", "SKUCLS"]);
			
			if( btnName == "Search" ){ //조회버튼
				param.put("INSTYP", "S");
				gridList.gridList({
					id : "gridHeadList",
					command : "S_EO01H",
					param : param
				});
				flag = "S";
			}else if( btnName == "Create" ){ //생성버튼
				gridList.setReadOnly("gridItemList", false, ["PRCQTY", "PRCUOM"]);
				
				// 협력업체반품
				if( param.get("DOCUTY") == "421" ){
					gridList.setReadOnly("gridHeadList", false, ["PTNRKY"]);
				}
				
				// 센터반품
				if( param.get("DOCUTY") == "422" && param.get("PTNRKY") == undefined ){
					commonUtil.msgBox("OUT_M0294"); //반품처코드를 입력해주세요.
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridItemList");
					return false;
				}
				param.put("INSTYP", "C");
				gridList.gridList({
					id : "gridHeadList",
					command : "C_EO01H",
					param : param
				});
				flag = "C";
			}
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		
		if(reSearchFlag != "OK"){
			rowData.putAll(inputList.setRangeMultiParam("searchArea"));
		}
		
		if( flag == "S" ){ //조회 또는 재조회
			gridList.gridList({
				id : "gridItemList",
				command : "S_EO01I",
				param : rowData
			});
			
		}else if( flag == "C" ){ //생성
			
			//헤더 반품처 코드가 변경되었다면 이전 반품처로 아이템 조회
			if( rowData.get("OLDPTN") != rowData.get("PTNRKY") ){
				rowData.put("PTNRKY", rowData.get("OLDPTN"));
			}
			
			gridList.gridList({
				id : "gridItemList",
				command : "C_EO01I",
				param : rowData
			});
			
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			uiList.setActive("Save", false);
		}else if( gridId == "gridHeadList" && dataLength > 0 ){
			if(flag == "S") {
				uiList.setActive("Save", false);
			} else if(flag == "C") {
				uiList.setActive("Save", true);
			} else {
				uiList.setActive("Save", false);
			}
		}
	}
	
	//저장후 조회
	function reSearchList(SADJKY){
		var sArea = inputList.setRangeMultiParam("searchArea");
		gridList.setReadOnly("gridHeadList", true, ["PTNRKY"]);
		gridList.setReadOnly("gridItemList", true, ["SKUCLS", "PRCQTY", "PRCUOM"]);
		
		uiList.setActive("Save", false); //저장버튼 숨김
		
		var reParam = new DataMap();
		reParam.put("WAREKY", sArea.get("WAREKY"));
		reParam.put("DOCUTY", sArea.get("DOCUTY"));
		reParam.put("SADJKY", SADJKY);
		reParam.put("INSTYP", "R");
		
		gridList.gridList({
			id : "gridHeadList",
			command : "S_EO01H",
			param : reParam
		});
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridItemList", "select") ){
			var headId = "gridHeadList";
			var itemId = "gridItemList";
			var headRowNum = gridList.getFocusRowNum(headId);
			var head = gridList.getRowData(headId, headRowNum);
			var item =  gridList.getSelectData(itemId, "A");
			var headLen = head.length;
			var itemLen = item.length;
			
			if(headLen == 0 && itemLen == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다. 
				return;
			}else if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return;
			}
			
			var docuty = head.get("DOCUTY");
			
			// 협력업체반품일때 반품처와 상품코드 조회
			if( docuty == "421" ){
				var chkParam = new DataMap();
				chkParam.put("PTNRKY", head.get("PTNRKY"));
				
				for( var i=0; item.length>i; i++ ){
					var itemDataRow = item[i];
					var itemRowNum = item[i].get("GRowNum");
					
					chkParam.put("WAREKY", itemDataRow.get("WAREKY"));
					chkParam.put("SKUKEY", itemDataRow.get("SKUKEY"));
					chkParam.put("OWNRKY", itemDataRow.get("OWNRKY"));
					
					var json = netUtil.sendData({
						module : "EtcOutbound",
						command : "SKUSPval",
						sendType : "map",
						param : chkParam
					});
					
					if( json && json.data ){
						if ( json.data["CNT"] < 1 ){
							commonUtil.msgBox("OUT_M0291", itemDataRow.get("DESC01")); //상품[{0}]는 해당 협력사 상품이 아닙니다.
							gridList.setColValue(headId, headRowNum, "PTNRKY", head.get("OLDPTN")); //반품처코드
							gridList.setColValue(headId, headRowNum, "NAME01", head.get("OLDPNM")); //반품처명
// 							gridList.setColValue(itemId, itemRowNum, "PRCQTY", 0); //수량
// 							gridList.setColValue(itemId, itemRowNum, "PRCUOM", "EA"); //단위
// 							gridList.setColValue(itemId, itemRowNum, "QTADJU", 0); //반품수량
							return false;
						}
						break;
					}
				}
			}else if( docuty == "422" ){
				
				var chkParam = new DataMap();
				chkParam.put("DOCUTY", docuty);
				
				for( var i=0; item.length>i; i++ ){
					var itemDataRow = item[i];
					var itemRowNum = item[i].get("GRowNum");
					
					chkParam.put("PTNRTY", "S");
					chkParam.put("SKUKEY", itemDataRow.get("SKUKEY"));
					chkParam.put("OWNRKY", itemDataRow.get("OWNRKY")); 
					chkParam.put("LOTA01", head.get("PTNRKY"));
					
					var json = netUtil.sendData({
						module : "EtcOutbound",
						command : "SKUWHval",
						sendType : "map",
						param : chkParam
					});
					
					if( json && json.data ){
						if ( json.data["CNT"] < 1 ){
							commonUtil.msgBox("OUT_M0304", itemDataRow.get("DESC01")); //[{0}]는 해당 센터반품 상품이 아닙니다.
// 							gridList.setColValue(itemId, itemRowNum, "PRCQTY", 0); //수량
// 							gridList.setColValue(itemId, itemRowNum, "PRCUOM", "EA"); //단위
// 							gridList.setColValue(itemId, itemRowNum, "QTADJU", 0); //반품수량
							return false;
						}
						break;
					}
				}
			}
			
			//결재권자 팝업
			page.linkPopOpen("/wms/approval/POP/APCOMM.page", head);
		}
	}
	
	// 팝업 닫힐시 호출 
	function linkPopCloseEvent(closeParam){
		if( closeParam.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(closeParam);
		}else{
			
			reqtxt = closeParam.get("REQTXT");
			
	// 		if( $.trim(reqtxt) == "" || reqtxt == undefined ){
	// 			commonUtil.msgBox("OUT_M0303"); //결제요청의견을 작성해주세요.
	// 			return false;
				
	// 		}
			
			var head = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			var item =  gridList.getSelectData("gridItemList", "A");
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("REQTXT", reqtxt);
			param.put("PROGID", "EO01");
			param.put("HHTTID", "WEB");
			param.put("INSTYP", "U");
		
			netUtil.send({
				url : "/wms/etcOutbound/json/saveEO01.data",
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
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
			
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
			
			if( NumColValue <= 0 ){
				colChangeNum(gridId, rowNum, "N");
				return false;
			}
			
			if( NumQtsiwh < NumColValue ){
				colChangeNum(gridId, rowNum, "S");
				return false;
			}
			
			//반품수량 계산
			if( prcuom == "EA" ){ //낱개
				gridList.setColValue(gridId, rowNum, "QTADJU", NumColValue);
				
			}else if( prcuom == "CS" ){//박스
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
			commonUtil.msgBox("OUT_M0290"); //반품수량은 0보다 커야합니다.
			
		}else if( select == "S" ){
			gridList.setColValue(gridId, rowNum, "PRCUOM", "EA");
			commonUtil.msgBox("OUT_M0246"); //반품수량은 재고수량보다 클 수 없습니다.
		
		}
	}
	
	
	
	// 서치헬프 오픈 이벤트
	var searchHelpPosition;
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var search = inputList.setRangeMultiParam("searchArea");
		if(searchCode == "SHBZPTN"){
			searchHelpPosition = (multyType == undefined) ? "search" : "grid";
			
			var param = new DataMap();
			
			if( search.get("DOCUTY") == "421" ){ //협력업체 반품
				param.put("PTNRTY","V");
				
			}else if( search.get("DOCUTY") == "422" ){ //센터반품
				param.put("PTNRTY","S");
				param.put("PTNG04", "V");
				
			}
			return param;
			
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param, true);
			
			return false;
		}
	}
	
	// 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHBZPTN" ){
			if( searchHelpPosition == "grid" ){
				gridList.setColValue("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "NAME01", rowData.get("NAME01"));
				
			}
		}
	}
	
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "EO01");
			
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
										<col width="250" />
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
											
											<th CL="STD_DOCUEO"></th>
											<td>
												<select id="DOCUTY" name="DOCUTY" Combo="WmsCommon,DOCTMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_DPTNEO"></th>
											<td>
												<input type="text" name="PTNRKY" UIInput="S,SHBZPTN" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUCNM"></th>
											<td>
												<select id="SKUCLS" name="SW.SKUCLS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="SK.SKUKEY" UIInput="SR,SHSKUMA" />
											</td>
											<th CL="STD_DOCDTO"></th>
											<td>
												<input type="text" name="AH.DOCDAT" UiRange="2" UIInput="B" UIFormat="C 0 1" validate="required" MaxDiff="M1" />
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
						<li><a href="#tabs1-3" ><span CL="STD_RETURN"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_SADJKY,3"  GCol="text,SADJKY"></td><!-- 조정번호 -->
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td><!-- 물류센터 -->
												<td GH="100 STD_DOCDTO"    GCol="text,DOCDAT"  GF="D"></td><!-- 반품일자 -->
												<td GH="100 STD_DOCUEO"    GCol="text,SHORTX"></td><!-- 반품구분 -->
												<td GH="100 STD_DPTNEO"    GCol="input,PTNRKY,SHBZPTN"></td><!-- 반품처코드 -->
												<td GH="180 STD_DPTNME"    GCol="text,NAME01"></td><!-- 반품처명 -->
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
										<tbody id="gridItemList">
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
												<td GH="80 STD_RETQTY"    GCol="text,QTADJU"   GF="N"></td>
												
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