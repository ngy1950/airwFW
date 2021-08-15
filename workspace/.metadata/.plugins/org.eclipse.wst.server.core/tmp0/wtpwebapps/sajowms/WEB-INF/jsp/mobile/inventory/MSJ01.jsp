<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var gridType = "grid";
	var todayDate;
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : true,
			type : "grid",
			gridId : "gridList",
			detailId : "detail"
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsInventory",
			command : "MSJ01",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		scanInput.setScanInput({
			id : "skukey1",
			name : "SKUKEY",
			bindId : "scanArea",
			type:"number"
		});
		
		mobileDatePicker.setDatePicker({
			id : "date1",
			name : "ALOTA09",
			bindId : "detail",
			gridId : "gridList"
		});
		
		mobileDatePicker.setDatePicker({
			id : "date2",
			name : "ALOTA08",
			bindId : "detail",
			gridId : "gridList"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SHLOCAKY",
			name : "LOCAKY",
			returnCol : "LOCAKY",
			bindId : "scanArea",
			title : "로케이션 검색",
			inputType : "scan",
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "Mobile",
			command : "SKU_TO_LOCMA"
			
		});
		
		//사은품검색
		mobileSearchHelp.setSearchHelp({
			id : "SKUKEY",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			buttonShow : false,
			grid : [
						{"width":80, "label":"STD_LOTL04,3","type":"text","col":"LT04NM"},
						{"width":80, "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":80, "label":"STD_DESC01","type":"text","col":"DESC01"}
					],
			module : "WmsInbound",
			command : "SKUKEYSELECT"
		});
		
		gridList.resetGrid("gridList");
		mobileCommon.select("","scanArea","SKUKEY");
		day();
	});
	
	function day(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		if( dd < 10 ) {dd ='0' + dd;}
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 상품조회
	function getSkuInfData(){
		gridList.resetGrid("gridList");
		var scanParam  = dataBind.paramData("scanArea");
		scanParam.put("WAREKY", "<%=wareky%>");
		
		var skukey = scanParam.get("SKUKEY");
		var locaky = scanParam.get("LOCAKY");
		
		if( $.trim(skukey) == "" ){
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("", "scanArea", "SKUKEY");
				}
			});
			return;
		}
		
// 		var json = netUtil.sendData({
// 			module : "Mobile",
// 			command : "SKUINF",
// 			param : scanParam,
// 			sendType : "list"
// 		});
		
		var json = netUtil.sendData({
			url : "/mobile/json/getSkuInf.data",
			param : scanParam
		});
		
		if(json && json.data){
			var area = "scanArea";
			
			if(json.data.length == 0){
				mobileCommon.alert({
					message : "존재하지 않는 상품입니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				
				return;
			}else if(json.data.length == 1){
				var data = new DataMap();
				data.putObject(json.data[0]);
				
				dataBind.dataBind(data, area);
				dataBind.dataNameBind(data, area);
				
				mobileCommon.select("","scanArea","LOCAKY");
				mobileCommon.focus("","scanArea","LOCAKY");
				mobileCommon.initBindArea("scanArea", ["DESC01"]);
			}else{
				mobileSearchHelp.selectSearchHelp("SKUKEY");
			}
		}
		
	}
	
	// 조회
	function searchData(){
		mobileCommon.initBindArea("scanArea", ["DESC01"]);
		gridList.resetGrid("gridList");
		
		var scanParam  = dataBind.paramData("scanArea");
		scanParam.put("WAREKY", "<%=wareky%>");
		
		var skukey = scanParam.get("SKUKEY");
		var locaky = scanParam.get("LOCAKY");
		if( $.trim(locaky) == "" ){
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>로케이션</span>을 스캔 또는 입력해주세요.",
				confirm : function(){
					mobileCommon.select("", "scanArea", "LOCAKY");
				}
			});
			return;
		}
		
		var json = netUtil.sendData({
			module : "Mobile",
			command : "LOCINF",
			param : scanParam,
			sendType : "list"
		});
			
		if(json && json.data){
			if(json.data.length > 0){
				if(json.data[0]["CNT"] > 0){
					if(json.data[1]["CNT"] > 0){
						if(isNull(skukey)){
							fail.play();
							
							mobileCommon.alert({
								message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해주세요.",
								confirm : function(){
									mobileCommon.select("","scanArea","SKUKEY");
								}
							});
							
							return;
						}
					}
				}else{
					fail.play();
					
					mobileCommon.alert({
						message : "존재하지 않는  <span class='msgColorBlack'>로케이션</span> 입니다.",
						confirm : function(){
							mobileCommon.focus("","scanArea","LOCAKY");
						}
					});
					
					return;
				}
			}
		}
		
		gridList.gridList({
			id : "gridList",
			param : scanParam
		});
		
		
	}
	
	
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList" && dataLength == 0 ){
			fail.play();
			
// 			gridType = "grid";
			
			mobileCommon.initSearch(null, true);
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.focus("", "scanArea", "SKUKEY");
					
// 					setTimeout(function() {
// 						parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
// 						mobileCommon.openDetail(gridType);
// 					});
				}
			});
		}else if( gridId == "gridList" && dataLength > 0 ){
			mobileCommon.setTotalViewCount();
			
			var data = new DataMap();
			data.put("SKUKEY", gridList.getColData(gridId, 0, "SKUKEY"));
			data.put("DESC01", gridList.getColData(gridId, 0, "DESC01"));
			
			dataBind.dataNameBind(data, "scanArea");
			
// 			if( dataLength == 1 ){
// 				gridType = "detail";
// 			}else{
// 				gridType = "grid";
// 			}
		}
		
		if(gridId == "SHLOCAKY_LIST" && dataLength > 0){
			setTimeout(function(){
				mobileCommon.closeSearchArea("SHLOCAKY_LAYER");
			}, 100);
			
		}else if(gridId == "SHLOCAKY_LIST" && dataLength == 0){
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다."
			});
		}
	}
	
	//테이트피커 닫힌 후 이벤트
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		var rowNum = gridList.getFocusRowNum("gridList");
		
		if( areaId == "detail" && inputName == "ALOTA09" ){
			gridList.setRowCheck("gridList", rowNum, true);
			gridListEventColValueChange("gridList", rowNum, inputName, value);
			
		}else if( areaId == "detail" && inputName == "ALOTA08" ){
			gridList.setRowCheck("gridList", rowNum, true);
			gridListEventColValueChange("gridList", rowNum, inputName, value);
		}
	}
	
	// 서치헬프 오픈 이벤트
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var scanParam = dataBind.paramData("scanArea");
		scanParam.put("WAREKY","<%=wareky%>");
		
		if( layerId == "SHLOCAKY_LAYER" ){
			return scanParam;
			
		}else if( layerId == "SKUKEY_LAYER" ){
			scanParam.put("ASNSKU", scanParam.get("SKUKEY"))
			return scanParam;
		}
	}
	
	//서치헬프 닫힌 후 이벤트
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if( layerId == "SHLOCAKY_LAYER" ){
			mobileCommon.initBindArea("scanArea", ["DESC01"]);
			gridList.resetGrid("gridList");
			
		}else if( layerId == "SKUKEY_LAYER" ){
			var param = new DataMap();
			param.put("SKUKEY", data.get("SKUKEY"));
			param.put("WAREKY","<%=wareky%>");
			dataBind.dataNameBind(param, "scanArea");
			mobileCommon.focus("", "scanArea", "LOCAKY");
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var rowData = gridList.getRowData(gridId, rowNum);
		if ( colName == "ALOTA08" ){ //제조일자/////////////////////////////////////////////////////////////////////////
			// 오늘일자 < 제조일자
			if( todayDate < colValue ){
				mobileCommon.alert({
					message : "제조일자는 오늘날짜보다 클 수 없습니다.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, colName, rowData.get("LOTA08"));
						gridList.setColValue(gridId, rowNum, "ALOTA09", rowData.get("LOTA09"));
					}
				});
				return false;
			}
		
			if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
				mobileCommon.alert({
					message : "유통기한 일수가 설정되어있지 않습니다.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, colName, "");
						gridList.setColValue(gridId, rowNum, "ALOTA09", "");
					}
				});
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
			}else{
				mobileCommon.alert({
					message : "날짜형식을 확인해 주세요.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, colName, "");
						gridList.setColValue(gridId, rowNum, "ALOTA09", "");
					}
				});
			}
			
		}else if ( colName == "ALOTA09" ){ //유통기한/////////////////////////////////////////////////////////////////////////
			if( rowData.get("DUEMON") == "0" && rowData.get("DUEDAY") == "0" ){
				mobileCommon.alert({
					message : "유통기한 일수가 설정되어있지 않습니다.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, colName, "");
						gridList.setColValue(gridId, rowNum, "ALOTA08", "");
					}
				});
				return false;
			}
			
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, colName, "");
				gridList.setColValue(gridId, rowNum, "ALOTA08", "");
				return false;
			}
			
			if( $.trim(rowData.get("ALOTA08")) != "" ){
				gridList.setColValue(gridId, rowNum, "ALOTA08", "");
			}
			
			
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
// 					mobileCommon.alert({
// 						message : "제조일자는 오늘날짜보다 클 수 없습니다.",
// 						confirm : function(){
// 							gridList.setColValue(gridId, rowNum, colName, rowData.get("LOTA09"));
// 							gridList.setColValue(gridId, rowNum, "ALOTA08", rowData.get("LOTA08"));
// 						}
// 					});
// 					return false;
// 				}
				
// 				if( json.data[0].DUEDAY != colValue ){
// 					gridList.setColValue(gridId, rowNum, "ALOTA08", json.data[0].DUEDAY);
// 				}
// 			}else{
// 				mobileCommon.alert({
// 					message : "날짜형식을 확인해 주세요.",
// 					confirm : function(){
// 						gridList.setColValue(gridId, rowNum, colName, "");
// 						gridList.setColValue(gridId, rowNum, "ALOTA08", "");
// 					}
// 				});
// 			}
			
		}else if ( colName == "PRCQTY" ){ //수량/////////////////////////////////////////////////////////////////////////
			var NumColValue = Number(colValue);
			
			if( NumColValue <= 0 ){
				mobileCommon.alert({
					message : "수량은 <span class='msgColorRed'>0</span> 보다 커야 합니다.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
						gridList.setColFocus(gridId, rowNum, "PRCQTY");
					}
				});
				return false;
				
			}else if( Number(rowData.get("QTSIWH")) < NumColValue ){
				mobileCommon.alert({
					message : "수량은 재고수량보다 작거나 같아야합니다.",
					confirm : function(){
						gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
						gridList.setColFocus(gridId, rowNum, "PRCQTY");
					}
				});
				return false;
			}
		}//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	}
	
	
	// 저장
	function saveData(){
		if( gridList.validationCheck("gridList", "select") ){
			var list = gridList.getSelectData("gridList");
			if( list.length == 0 ){
				mobileCommon.alert({
					message : "선택된 데이터가 없습니다."
				});
				return;
			}
			
			var data = dataBind.paramData("scanArea");
			data.put("WAREKY","<%=wareky%>");
			var skukey = data.get("SKUKEY");
			var locaky = data.get("LOCAKY");
			
			for(var i = 0; i < list.length; i++){
				var listRowData = list[i];
				var rowNum = gridList.getFocusRowNum("gridList");
				var qtsiwh = commonUtil.parseInt(listRowData.get("QTSIWH"));
				var prcqty = commonUtil.parseInt(listRowData.get("PRCQTY"));
				var mnglt9 = $.trim(listRowData.get("MNGLT9")); //유통기한관리여부
				var mngmov = listRowData.get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = listRowData.get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = listRowData.get("LOTL01"); //skuma 유통기한 관리여부
				var lota06 = listRowData.get("LOTA06"); //재고상태
				var alota08 = $.trim(listRowData.get("ALOTA08")); //입력제조일자
				var alota09 = $.trim(listRowData.get("ALOTA09")); //입력유통기한
				var desc01 = listRowData.get("DESC01"); //상품명
				
				//재고수량보다 조정수량이 클수 없음
				if( qtsiwh < prcqty ){
					mobileCommon.alert({
						message : "조정 수량이 재고수량 보다 클 수 없습니다.",
						confirm : function(){
							gridList.setColFocus("gridList", rowNum, "PRCQTY");
						}
					});
					return;
				}
				
				//조정수량은 0보다 커야함
				if( prcqty == 0 ){
					mobileCommon.alert({
						message : "조정 수량은 <span class='msgColorRed'>0</span> 보다 커야 합니다.",
						confirm : function(){
							gridList.setColFocus("gridList", rowNum, "PRCQTY");
						}
					});
					return;
				}
				
				// 제조일자 및 유통기한 변경 안된건 체크
				if( alota08 == listRowData.get("LOTA08") || alota09 == listRowData.get("LOTA09")){
					mobileCommon.alert({
						message : "제조일자 및 유통기한 변경이 안된 상품이 존재합니다."
					});
					return false;
				}
				
				//유통기한 필수여부 체크
				if( lota06 == "00" || lota06 == "10" ){
					if( mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" && alota09 == "" ){
						mobileCommon.alert({
							message : "[ " + desc01 + " ]은 유통기한 필수입력 상품입니다."
						});
						return false;
					}
				}
				
				//제조일자 필수여부 체크
// 				if( lotl01 == "Y" && mnglt9 == "" && $.trim(alota08) == "" ){
// 					mobileCommon.alert({
// 						message : "[ " + desc01 + " ]은  제조일자는 필수입력 상품입니다."
// 					});
// 					return false;
// 				}
				
				listRowData.put("QTADJU", prcqty);
			}
			
			
			var param = new DataMap();
			param.put("list", list);
			param.put("ADJUTY", "410");
			param.put("HHTTID", "PDA");
			param.put("INSTYP", "U");
			param.put("WAREKY", "<%=wareky%>");
			
			
			
			netUtil.send({
				url : "/wms/inventory/json/saveSJ01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if( json.data.CNT > 0 ){
				mobileCommon.toast({
					type : "S",
					message : "[ " + json.data.CNT + " ]이 저장되었습니다.",
					execute : function(){
						success.play();
						mobileCommon.initSearch(null, false);
						mobileCommon.select("", "scanArea", "SKUKEY");
						mobileCommon.openDetail("grid");
						gridList.resetGrid("gridList");
						
// 						setTimeout(function() {
// 							parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
// 							mobileCommon.openDetail(gridType);
// 							gridList.resetGrid("gridList");
// 						});
					}
				});
			}else if( json.data.CNT < 1 ){
				mobileCommon.toast({
					type : "F",
					message : "저장이 실패하였습니다.",
					execute : function(){
						fail.play();
					}
				});
			}
		}
	}
	
	// 초기화 버튼
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				mobileCommon.initSearch(null,true);
				gridList.resetGrid("gridList");
				mobileCommon.focus("", "scanArea", "SKUKEY");
			}
		});
	}
	
	// 값 존재 체크
	function isNull(sValue) {
		var value = (sValue+"").replace(" ", "");
		
		if( new String(value).valueOf() == "undefined")
			return true;
		if( value == null )
			return true;
		if( value.toString().length == 0 )
			return true;
		
		return false;
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "SHLOCAKY_LIST"){
			if(colName == "INDUPK"){
				if(colValue == "Y"){
					return "yIcon";	
				}else if($.trim(colValue) == "N"){
					return "nIcon";
				}
			}
		}
	}
	
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Content Area -->
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area">
				<table id="scanArea">
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_SKUKEY">상품코드</th>
							<td colspan="2">
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_LOCAKY">로케이션</th>
							<td>
								<input type="text" id="LOCAKY" name="LOCAKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td style="width: 50px;">
								<button class="innerBtn" id="SHLOCKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUINF">상품</th>
							<td colspan="2">
								<input type="text" name="DESC01" readonly="readonly"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- Grid Area -->
			<div class="gridArea">
				<div class="tableWrap_search section">
					<div class="tableHeader">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="50" />
								<col width="50" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_PRCQTY"></th>
									<th CL="STD_CHAGQT"></th>
									<th CL="STD_LOTA09"></th>
									<th CL="STD_DATE09"></th>
									<th CL="STD_LOTA08"></th>
									<th CL="STD_DATE08"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="50" />
								<col width="50" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="text,QTSIWH"    GF="N 10"></td>
									<td GCol="input,PRCQTY"   GF="N 10" validate="required"></td>
									<td GCol="text,LOTA09"    GF="D"></td>
									<td GCol="input,ALOTA09"  GF="D"></td>
									<td GCol="text,LOTA08"    GF="D"></td>
									<td GCol="input,ALOTA08"  GF="D"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">저장</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
			<!-- Detail Area -->
			<div class="detailArea" id="detail">
				<div class="detailContent">
					<div class="pageCount">
						<span class="txt">Page.</span><span class="count">0</span><span class="slush">/</span><span class="totalCount">0</span>
					</div>
					<div class="content">
						<table>
							<colgroup>
								<col width="70" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th CL="STD_QTSIWH"></th>
									<td>
										<input type="text" name="QTSIWH" UIFormat="N 10" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_CHAGQT"></th>
									<td>
										<input type="text" id="PRCQTY" name="PRCQTY" UIFormat="N 10"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA08"></th>
									<td>
										<input type="text" name="LOTA08" UIFormat="D" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA09"></th>
									<td>
										<input type="text" name="LOTA09" UIFormat="D" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_DATE08"></th>
									<td>
										<input type="text" name="ALOTA08" UIFormat="D" />
									</td>
								</tr>
								<tr>
									<th CL="STD_DATE09"></th>
									<td>
										<input type="text" name="ALOTA09" UIFormat="D" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Detail Button Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<div class="button">
							<ul>
								<li class="prev"><p></p></li>
								<li class="btn">
									<button class="wid3 l" onclick="saveData();"><span>저장</span></button>
									<button class="wid3 l btnBgW" onclick="initPage();"><span>초기화</span></button>
								</li>
								<li class="next"><p></p></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>