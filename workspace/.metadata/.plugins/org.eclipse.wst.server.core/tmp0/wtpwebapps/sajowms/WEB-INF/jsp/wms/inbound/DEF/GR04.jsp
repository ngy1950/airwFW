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
<script type="text/javascript">
	midAreaHeightSet = "200px";
	var todayDate;
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInbound",
			command : "GR04H",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInbound",
			command : "GR04I",
			autoCopyRowType : false,
			headGrid : "gridHeadList"
		});
		
		$("#STATUS").val("NEW"); //검색조건 입고상태 : 미작업
		
		date();
	});
	
	//오늘날짜
	function date(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "asdSave" ){ //입고완료
			saveData("asdSave");
			
		}else if( btnName == "asdList" ){ //입고리스트  
			print("list");
		
		}else if( btnName == "asdLabel" ){ //입고라벨  
			print("label");
		
		}else if( btnName == "asdCancel" ){ //입고불가상품
			var param = inputList.setRangeDataParam("searchArea");
			param.put("WAREKY", "<%=wareky%>");
			param.put("USERID", "<%=userid%>");
			param.put("PROGID", "GR04");
			
			page.linkPopOpen("/wms/inbound/POP/GR01POP.page", param);
		
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("RCPTTY", "104");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	//헤더 재 조회 
	function reSearchList(data){
		var param = new DataMap();
		param.put("SVBELN", data);
		param.put("WAREKY", "<%=wareky%>");
		param.put("RCPTTY", "104");
		param.put("RESERCH", "OK");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
	}
	
	//저장
	function saveData(saveFlag){
		if( gridList.validationCheck("gridItemList", "select") ){
			var head = gridList.getSelectData("gridHeadList", "A");
			var item = gridList.getSelectData("gridItemList", "A");
			var headLen = head.length;
			var itemLen = item.length;
			var param = new DataMap();
			var date_flag = "";
			
			if( headLen > 1 ){ //헤더 두개이상 선택시
				var sameAsndky;
				var itemAsndky = item[0].get("ASNDKY");
				for( var i=0; i<headLen; i++ ){
					var headAsndky = head[i].get("ASNDKY");
					if( headAsndky == itemAsndky ){
						sameAsndky = [head[i]];
					}
				}
				param.put("head", sameAsndky);
				
			}if( headLen == 1 ){
				param.put("head", head);
				
			}else if( itemLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return;
			}
			
			
			//입고통제일 확인
			for( var i=0; i<itemLen; i++ ){
				var mngmov = item[i].get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = item[i].get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = item[i].get("LOTL01"); //skuma 유통기한 관리여부
				var lotl02 = item[i].get("LOTL02"); //입고통제기준코드
				var lota08 = item[i].get("LOTA08"); //제조일자
				var lota09 = item[i].get("LOTA09"); //유통기한
				var skukey = item[i].get("SKUKEY");
				var locaky = item[i].get("LOCAKY");
				
				//로케이션을 선택해주세요.
				if( $.trim(locaky) == "" ){
					commonUtil.msgBox("IN_M0006");
					return false;
				}
				
				//유통기한 필수입력 상품입니다.
				if( mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" ){
					if( $.trim(lota09) == "" ){
						commonUtil.msgBox("IN_M0012");
						return false;
					}
				}
				
				//lotl02(입고기준구분코드) 입고 통제일 조회(1:유통기한 / 2:제조일자)
				if( lotl01 == "Y" && lotl02 == "1" || lotl01 == "Y" && lotl02 == "2" ){
					if( $.trim(lota09) != "" ){
						var rcvParam = new DataMap();
						rcvParam.put("LOTA08", lota08);
						rcvParam.put("LOTA09", lota09);
						rcvParam.put("SKUKEY", skukey);
						
						//입고통제일 확인
						var json = netUtil.sendData({
							module : "WmsInbound",
							command : "RCV_DAT",
							sendType : "map",
							param : rcvParam
						});
						
						if( json.data["DAT_FLAG"] != "OK" ){
							if( !confirm("상품코드["+ skukey +"]는 입고통제일을 초과했습니다. 그래도 입고 진행하시겠습니까?") ){
								return false;
							}else{
								date_flag = "Y";
							}
						}
					}
				}
			}
			
			
			
			param.put("item", item);
			param.put("HHTTID", "WEB");
			param.put("saveFlag", saveFlag);
			
			if( !commonUtil.msgConfirm("IN_M0014") ){ //입고완료 하시겠습니까?
				return false;
			}
		}else{
			return false;
		}
		
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR01.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
		
		
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			
			if( data ){
				commonUtil.msgBox(data.msg);
				gridList.resetGrid("gridHeadList");
				
				//저장건 재조회
				if(data.reKey == "OK"){
					reSearchList(data.key);
				}
				
			}else if( !data ){
				commonUtil.msgBox("MASTER_M0101"); //저장에 실패 하였습니다. 관리자에게 문의 하세요. 내역:[{0}]
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var ItemData = gridList.getRowData(gridId, rowNum);
		
		if( gridId == "gridItemList" ){
			if ( colName == "LOTA08" ){ /////////////////////////////제조일자////////////////////////////////////////////
				// 오늘일자 < 제조일자
				if( todayDate < colValue ){
					commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
			
				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("ALOTA08", colValue);
				param.put("DUEMON", ItemData.get("DUEMON"));
				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "SJ01DATE",
					sendType : "list",
					param : param
				});
				
				//일자체크
				if( json && json.data ){
					if( json.data[0].DUEDAY != colValue ){
						gridList.setColValue(gridId, rowNum, "LOTA09", json.data[0].DUEDAY);
					}
				}
				
			}else if ( colName == "LOTA09" ){ /////////////////////////////유통기한////////////////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "LOTA08", "");
				
				
// 				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
// 					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
// 					gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 					gridList.setColValue(gridId, rowNum, colName, "");
// 					return false;
// 				}
				
// 				var param = new DataMap();
// 				param.put("ALOTA09", colValue);
// 				param.put("DUEMON", ItemData.get("DUEMON"));
// 				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
// 				var json = netUtil.sendData({
// 					module : "WmsInventory",
// 					command : "SJ01DATE",
// 					sendType : "list",
// 					param : param
// 				});
				
// 				//일자체크
// 				if( json && json.data ){
					
// 					// 오늘일자 < 제조일자
// 					if( todayDate < json.data[0].DUEDAY ){
// 						commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
// 						gridList.setColValue(gridId, rowNum, colName, "");
// 						gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 						return false;
// 					}
					
// 					if( json.data[0].DUEDAY != colValue ){
// 						gridList.setColValue(gridId, rowNum, "LOTA08", json.data[0].DUEDAY);
// 					}
// 				}
			}
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			
		}else if( gridId == "gridItemList" && dataLength > 0 ){
			
			// 그리드 로우 리드온리
			for( var i=0; i<dataLength; i++ ){
				var rowData = gridList.getRowData(gridId, i);
				var lotl01 = rowData.get("LOTL01");
				var endmak = rowData.get("ENDMAK");
				
				// 유통기한 관리 안하는 상품은 readonly
				if( lotl01 == "N" ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA08", "LOTA09"]);
				}
				
				// 마감완료된 건은 수정불가
				if( endmak == "Y" ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA08", "LOTA09"]);
				}
				
			}
		}
	}
	
	// 입고완료된건 선택 불가
	function gridListCheckBoxDrawBeforeEvent(gridId,rowNum){
		if( gridId == "gridItemList" ){
			var qtyorg = $.trim(gridList.getColData(gridId, rowNum, "QTYORG"));
			var qtyrcv = $.trim(gridList.getColData(gridId, rowNum, "QTYRCV"));
			
			if( qtyorg == qtyrcv ){
				return true;
			}
			
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
			
			if( name == "STATUS" ){
				param.put("CODE","RCVSTATDO");
				param.put("USARG1", "V");
				
			}
			
			return param;
		}
	}
	
	//입고예정리스트 프린트
	function print(btnName){
		var head = gridList.getSelectData("gridHeadList");
		var item = gridList.getGridData("gridItemList", "A");
		if ( head.length == 0 ){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		
		
		var param = dataBind.paramData("searchArea");
		param.put("PROGID", configData.MENU_ID);
		param.put("PRTCNT", 1);
		param.put("head", head);
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/printGR01.data",
			param : param
		});
		if(  btnName == "list" ){
			if ( json && json.data ){
				var url = "<%=systype%>" + "/input_gr01_list.ezg";
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  600;
				var heigth = 800;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}else if(  btnName == "label" ){
			for(var i=0; i<head.length; i++){
				var loccnt = head[i].get("LOCCNT");
				if( loccnt == "Y" ){
					alert("입고불가상품이 존재합니다. 라벨출력이 불가합니다.");
					return false;
				}
			}
			
			for(var i=0; i<item.length; i++){
				var locaky = item[i].get("LOCAKY");
				if( $.trim(locaky) == "" ){
					alert("로케이션 미지정 상품이 존재합니다. 라벨출력이 불가합니다.");
					return false;
				}
			}
			
			if ( json && json.data ){
				var url = "<%=systype%>" + "/inbound_label.ezg"; //변경하기
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  316;
				var heigth = 203;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="asdSave REFLECT BTN_ASDFIN"></button>
		<button CB="asdCancel DELETE BTN_ASDCAN"></button>
		<button CB="asdLabel PRINT BTN_ASDLAB"></button>
		<button CB="asdList PRINT BTN_ASDLIST"></button>
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
											<th CL="STD_RCPSTU">입고상태</th>
											<td>
												<select Combo="Common,COMCOMBO" name="STATUS" id="STATUS" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_ASDDAT">입고예정일자</th>
											<td>
												<input type="text" name="AO.DOCDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
										</tr>
										<tr>
											<th CL="STD_ASNDKY">입고예정번호</th>
											<td>
												<input type="text" name="AO.ASNDKY" UIInput="SR" />
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
						<li><a href="#tabs1-3" ><span CL="STD_RECDLI"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td>
												<td GH="100 STD_ASDDAT"    GCol="text,DOCDAT"  GF="D"></td>
												<td GH="100 STD_ASNDKY"    GCol="text,ASNDKY"></td>
												<td GH="100 STD_GRWARE"    GCol="text,DPTNNM"></td>
												<td GH="100 STD_RCPSTU"    GCol="text,RCVSATANM"></td>
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
						<li><a href="#tabs1-4" ><span CL="STD_ITEMLIST"></span></a></li>
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
												<td GH="130 STD_SKUKEY"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LO06NM"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="100 STD_QTYOEA"   GCol="text,QTYORG"  GF="N"></td>
												<td GH="100 STD_BOXORG"   GCol="text,BOXORG"  GF="N"></td>
												<td GH="100 STD_QTYRCV"   GCol="text,QTYRCV"  GF="N"></td>
												<td GH="100 STD_LOTL01"   GCol="text,LOTL01"></td>
												<td GH="100 STD_LOTA08"   GCol="input,LOTA08" GF="C"></td>
												<td GH="100 STD_LOTA09"   GCol="input,LOTA09" GF="C"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												<td GH="100 STD_ASNDKY"   GCol="text,ASNDKY"></td>
												<td GH="100 STD_ASNDIT"   GCol="text,ASNDIT"></td>
												<td GH="100 STD_ENDMAK"   GCol="text,ENDMAK,center"></td>
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
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