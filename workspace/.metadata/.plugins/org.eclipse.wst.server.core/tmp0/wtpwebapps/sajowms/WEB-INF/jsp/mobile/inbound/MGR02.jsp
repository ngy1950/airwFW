<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<style type="text/css">
.detailArea select[disabled]{
	background-color: #efefef;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	color: #000;
	font-weight: bold;
	padding-left: 4px;
}
}
</style>
<script type="text/javascript">
	var asnParam = new DataMap();
	var g_head = new DataMap();
	var skuChkTypList = ["101","102","103"];

	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false,
			type : "detail",
			gridId : "gridList",
			detailId : "detail"
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "MGR02_ITEM",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		
		mobileDatePicker.setDatePicker({
			id : "LOTA08",
			name : "LOTA08",
			bindId : "detail"
		});
		
		mobileDatePicker.setDatePicker({
			id : "LOTA09",
			name : "LOTA09",
			bindId : "detail"
		});
		
		//asnod 검색
		mobileSearchHelp.setSearchHelp({
			id : "ASNSKU",
			name : "ASNSKU",
			returnCol : "ASNSKU",
			bindId : "scanArea",
			title : "입고유형 선택",
			inputType : "scanNumber",
			buttonShow : false,
			grid : [
						{"width":80, "label":"STD_ASDNUM","type":"text","col":"PGRC01"},
						{"width":80, "label":"STD_RECDLI","type":"text","col":"ASNDKY"},
						{"width":80, "label":"STD_RCPTTY","type":"text","col":"ASNTNM"}
					],
			module : "Mobile",
			command : "MGR02_ASN_POP"
		});
		
		//사은품검색
		mobileSearchHelp.setSearchHelp({
			id : "SKUKEY",
			name : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			inputType : "scanNumber",
			buttonShow : false,
			photoView: true,
			grid : [
						{"width":70,  "label":"STD_GUBUN", "type":"text","col":"LT04NM"},
						{"width":90,  "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"},
					],
			module : "Mobile",
			command : "SKUINF"
		});
		
		//scanArea 입고타입
		$("#RCPTTY").change(function(){
			initAll();
			
			numberInputReadOnly();
			
			var comboParam = new DataMap();
			comboParam.put("WAREKY", "<%=wareky%>");
			comboParam.put("CODE", "LOTA06");
			
			if( $("#RCPTTY").val() == "105" ){
				comboParam.put("USARG3", "V");
			}
			
			var json = netUtil.sendData({
				module : "Common",
				command : "COMCOMBO",
				param : comboParam,
				sendType : "list"
			});
			
			if( json && json.data ){
				$("#LOTA06").find("[UIOption]").remove();
				var optionHtml = inputList.selectHtml(json.data, false);
				$("#LOTA06").append(optionHtml);
				$('#LOTA06').val("");
			}
			
			mobileCommon.focus("", "scanArea", "ASNSKU");
		});
		
		numberInputReadOnly();
		
		mobileCommon.focus("", "scanArea", "ASNSKU");
	});
	
	function numberInputReadOnly(){
		$("[name=LOTA06]").attr({"disabled" : true, "class": "readOnly"});
		$("[name=LOTA08]").attr({"readonly" : true}).css({"background": "#ededed"});
		$("[name=LOTA09]").attr({"readonly" : true}).css({"background": "#ededed"});
		$("[name=PRCUOM]").attr({"disabled" : true, "class": "readOnly"});
		$("#detail [name=PRCQTY]").attr("disabled",true);
		$("#detail [name=PRCQTY]").addClass("readOnly");
	}
	
	function today(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		return String(yyyy) + String(mm) + String(dd);
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var defaultParam = dataBind.paramData("scanArea");
		var wareky = defaultParam.get("WAREKY");
		
		var param = new DataMap();
		param.put("WAREKY", wareky);
		
		if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "MGR01");
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				var rcptty = $("[name=RCPTTY]").val();
				if( rcptty == "105" ){
					param.put("USARG3", 'V');
				}
			}else if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
			}
			return param;
		}
	}
	
	function getAsnInfData(){
		var valid102Check = true;
		
		var area = "scanArea";
		var param = dataBind.paramData(area);
		param.put("SKUKEY",param.get("ASNSKU"));
		
		var rcptty = param.get("RCPTTY");
		if(rcptty == "102"){
			var json = netUtil.sendData({
				module : "Mobile",
				command : "MGR02_ASN102_VALIDATION",
				param : param,
				sendType : "map"
			});
			
			if(json && json.data){
				var result = json.data["RESULT"];
				switch (result) {
				case "E1":
					valid102Check = false;
					
					fail.play();
					
					mobileCommon.alert({
						message : "슈퍼 센터에서 아직 출하확정 처리 하지 않았습니다.\n출하 확정 처리 후 진행할 수 있습니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
					break;
				case "E2":
					valid102Check = false;
					
					fail.play();
					
					mobileCommon.alert({
						message : " <span class='msgColorBlack'>입고 예정 수량</span>이  <span class='msgColorRed'>0</span> 으로 <span class='msgColorBlack'>출하확정</span> 되었습니다.\n슈퍼센터에 문의해주세요.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
					
					break;
				case "F":
					valid102Check = false;
					
					fail.play();
					
					mobileCommon.alert({
						message : "<span class='msgColorBlack'>입고예정</span>에 없는 <span class='msgColorBlack'>상품코드</span> 이거나 \n이미 <span class='msgColorRed'>마감</span>된 상품입니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
					
					break;	
				default:
					break;
				}
			}
		}
		
		if(!valid102Check){
			return;
		}
		
		var json = netUtil.sendData({
			module : "Mobile",
			command : "MBL_SKUMA_COUNT",
			param : param,
			sendType : "map"
		});
		
		if(json && json.data){
			if(json.data["CNT"] > 0){
				var asnJson = netUtil.sendData({
					module : "Mobile",
					command : "MGR02_ASN_POP",
					param : param,
					sendType : "list"
				});
				
				if(asnJson && asnJson.data){
					var asnData = asnJson.data;
					var asnDataLen = asnData.length;
					if(asnDataLen > 0){
						if(asnDataLen == 1){
							asnParam.putObject(asnData[0]);
							var skukey = asnParam.get("SKUKEY");
							getSkuInfData(skukey);
						}else{
							mobileSearchHelp.selectSearchHelp("ASNSKU");
						}
					}else{
						fail.play();
						
						mobileCommon.alert({
							message : "<span class='msgColorBlack'>입고예정</span>에 없는 <span class='msgColorBlack'>상품코드</span> 이거나 \n이미 <span class='msgColorRed'>마감</span>된 상품입니다.",
							confirm : function(){
								mobileCommon.select("","scanArea","ASNSKU");
							}
						});
					}
				}
			}else{
				fail.play();
				
				mobileCommon.alert({
					message : "등록되지 않은 <span class='msgColorBlack'>상품코드</span> 입니다.\n상품 마스터에 등록 후, 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","ASNSKU");
					}
				});
			}
		}
		
	}
	
	function getSkuInfData(skukey){
		var param = new DataMap();
		if(isNull(skukey)){
			fail.play();
			mobileCommon.alert({
				message : "상품 검색에 실패하였습니다.\n[ 입고예정 정보의 <span class='msgColorBlack'>상품코드</span>를 조회 할 수 없습니다. ]",
				confirm : function(){
					mobileCommon.select("","scanArea","ASNSKU");
				}
			});
			return;
		}
		
		var isPass = true;
		var rcptty = asnParam.get("RCPTTY");
		if(skuChkTypList.indexOf(rcptty) > -1){
			var chgSkuYn = asnParam.get("CHG_SKU_YN");
			if(chgSkuYn == "N"){
				isPass = false;
				searchHead(skukey);
			}
		}else{
			isPass = false;
			searchHead(skukey);
		}
		
		if(isPass){
			param.put("SKUKEY",skukey);
			
			var json = netUtil.sendData({
				url : "/mobile/json/getSkuInf.data",
				param : param
			});
			
			if(json && json.data){
				var dataLen = json.data.length;
				if(dataLen == 0){
					fail.play();
					
					mobileCommon.alert({
						message : "존재하지 않는 상품입니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
					
					return;
				}else if(dataLen == 1){
					var data = new DataMap();
					data.putObject(json.data[0]);
					
					var returnSkukey = data.get("SKUKEY");
					
					searchHead(returnSkukey);
				}else{
					mobileSearchHelp.selectSearchHelp("SKUKEY");
				}
			}
		}
	}
	
	function searchHead(skukey){
		asnParam.put("SKUKEY",skukey);
		netUtil.send({
			module : "Mobile",
			command : "MGR02_HEAD",
			param : asnParam,
			sendType : "list",
			successFunction : "searchHeadCallBack"
		});
	}
	
	function searchHeadCallBack(json, status){
		if(json && json.data){
			g_head.clear();
			asnParam.clear();
			
			if(json.data.length > 0){
				g_head.putObject(json.data[0]);
				gridList.gridList({
					id : "gridList",
					param : g_head
				});
			}
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList"){
			if(dataLength > 0){
				var isFail = false;
				
				var gridData = gridList.getGridData("gridList");
				var rowData = gridData[0];
				
				var skukey = rowData.get("SKUKEY");
				var rcptty = rowData.get("RCPTTY");
				var skucls = rowData.get("SKUCLS");
				var locaky = rowData.get("LOCAKY");
				var lotl01 = rowData.get("LOTL01");
				var usarg3 = rowData.get("USARG3");
				var mnglt9 = rowData.get("MNGLT9");
				var boxqty = rowData.get("BOXQTY");
				var qtyorg = rowData.get("QTYORG");
				var rvit04 = rowData.get("RVIT04");
				
				if(isNull(skucls)){
					isFail = true;
					
					fail.play();
					
					mobileCommon.alert({
						message : "물류분류가 등록되지 않았습니다.\n상품 마스터에 등록 후, 진행 해주세요.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
				}else if(isNull(locaky)){
					if(skuChkTypList.indexOf(rcptty) > -1){
						isFail = true;
						
						fail.play();
						
						mobileCommon.alert({
							message : "피킹로케이션이 등록되지 않은 상품입니다.\n피킹로케이션 등록 후, 진행 해주세요.",
							confirm : function(){
								mobileCommon.select("","scanArea","ASNSKU");
							}
						});
					}
				}else if(rcptty == "102" && rvit04 == "N" && qtyorg == 0){
					isFail = true;
					
					fail.play();
					
					mobileCommon.alert({
						message : " <span class='msgColorBlack'>입고 예정 수량</span>이  <span class='msgColorRed'>0</span> 으로 <span class='msgColorBlack'>출하확정</span> 되었습니다.\n슈퍼센터에 문의해주세요.",
						confirm : function(){
							mobileCommon.select("","scanArea","ASNSKU");
						}
					});
				}
				
				if(isFail){
					initAll();
				}else{
					var $lota06 = $("#detail [name=LOTA06]");
					var $lota08 = $("#detail [name=LOTA08]");
					var $lota09 = $("#detail [name=LOTA09]");
					var $prcuom = $("#detail [name=PRCUOM]");
					var $prcqty = $("#detail [name=PRCQTY]");
					
					$lota06.attr({"disabled" : true, "class": "readOnly"});
					
					if( lotl01 == "Y" && usarg3 == "Y" && mnglt9 != "V" ){
						$lota08.attr("readonly",false).css("background","none");
						$lota09.attr("readonly",false).css("background","none");
					}else{
						$lota08.attr("readonly",true).css("background","#ededed");
						$lota09.attr("readonly",true).css("background","#ededed");
					}
					
					$prcuom.attr("disabled", false).removeClass("readOnly");
					$prcqty.attr("disabled",false).removeClass("readOnly");
					
					if( rcptty == "105" ){
						$lota06.attr("disabled", false).removeClass("readOnly");
						$lota06.val("");
					}else if( rcptty == "104" || rcptty == "103"){
						$prcuom.attr({"disabled" : true, "class": "readOnly"});
						$prcqty.attr("disabled",true).addClass("readOnly");
					}
					
					$("#BOXQTY").html(boxqty);
				}
			}else{
				initAll();
			}
		}
	}
	
	// 서치헬프 오픈 이벤트
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = dataBind.paramData("scanArea");
		
		if( layerId == "ASNSKU_LAYER" ){
			return param;
		}else if( layerId == "SKUKEY_LAYER" ){
			var skukey = param.get("ASNSKU");
			param.put("SKUKEY",skukey);
			param.put("PROGID","MGR02");
			
			return param;
		}
	}
	
	//서치헬프 닫힌 후 이벤트
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if( layerId == "ASNSKU_LAYER" ){
			asnParam.putAll(data);
			var skukey = data.get("SKUKEY");
			getSkuInfData(skukey);
		}else if( layerId == "SKUKEY_LAYER" ){
			var skukey = data.get("SKUKEY");
			if(!isNull(skukey)){
				searchHead(skukey);
			}else{
				mobileCommon.select("","scanArea","ASNSKU");
			}
		}
	}
	
	function saveData(){
		var list = gridList.getGridData("gridList");
		var listLen = gridList.getGridDataCount("gridList");
		if(listLen == 0){
			fail.play();
			
			mobileCommon.alert({
				message : "조회된 데이터가 없습니다.\n조회 후에 진행해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","ASNSKU");
				}
			});
			
			return;
		}
		if(g_head.isEmpty()){
			fail.play();
			
			mobileCommon.alert({
				message : "입고예정정보가 유실 되었습니다.\n재 조회 후에 진행해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","ASNSKU");
				}
			});
			
			return;
		}
		
		var rowData = list[0];
		var asnsku = rowData.get("ASNSKU");
		var prcqty = commonUtil.parseInt(commonUtil.replaceAll(rowData.get("PRCQTY"), ",", ""));
		var qtviwe = commonUtil.parseInt(commonUtil.replaceAll(rowData.get("QTVIWE"), ",", ""));
		var mngmov = rowData.get("MNGMOV"); //locma 유통기한 관리여부
		var usarg3 = rowData.get("USARG3"); //cmcdw 유통기한 관리여부
		var lotl01 = rowData.get("LOTL01"); //skuma 유통기한 관리여부
		var lotl02 = rowData.get("LOTL02");
		var lota08 = rowData.get("LOTA08"); //제조일자
		var lota09 = rowData.get("LOTA09"); //유통기한
		var skukey = rowData.get("SKUKEY");
		
		//lotl02(입고기준구분코드) 입고 통제일 조회
		if( (lotl01 == "Y" && lotl02 == "1") || (lotl01 == "Y" && lotl02 == "2") ){
			if( !isNull(lota09) ){
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
					fail.play();
					
					mobileCommon.alert({
						message : "상품코드["+ skukey +"]는 입고통제일 기준에 미달합니다.",
						confirm : function(){
							mobileCommon.focus("","detail","LOTA08");
							mobileCommon.focus("","detail","LOTA09");
						}
					});
					
					return;
				}
			}
		}
		
		//상품
		if(isNull(asnsku)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span>를 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.initSearch(null,true);
					mobileCommon.select("","scanArea","ASNSKU");
				}
			});
			
			return;
		}
		
		//유통기한 필수입력 상품입니다.
		if( qtviwe != 0 && mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" ){
			if( $.trim(lota09) == "" ){
				fail.play();
				
				mobileCommon.alert({
					message : "유통기한 필수입력 상품입니다.",
					confirm : function(){
						mobileCommon.select("", "detail", "LOTA09");
					}
				});
				return false;
			}
		}
		
		//입고수량
		if(prcqty <= 0){
			fail.play();
			
			mobileCommon.alert({
				message : "입고 수량은 <span class='msgColorRed'>0</span> 보다 커야 합니다.",
				confirm : function(){
					mobileCommon.focus("0", "detail", "PRCQTY");
				}
			});
			
			return;
		}
		
		var head = new Array();
		head.push(g_head);
		
		var saveData = new DataMap();
		saveData.put("head", head);
		saveData.put("item", list);
		saveData.put("HHTTID", "PDA");
		saveData.put("saveFlag", "asdSave");
		
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR01.data",
			param : saveData,
			successFunction : "succsessSaveCallBack"
		});
	}
	
	function succsessSaveCallBack(json){
		if(json && json.data){
			if(json.data["reKey"] == "OK"){
				mobileCommon.toast({
					type : "S",
					message : "입고 완료 되었습니다.",
					execute : function(){
						success.play();
						initAll();
						
						mobileCommon.focus("","scanArea","ASNSKU");
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "입고실패하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","scanArea","ASNSKU");
					}
				});
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var scanParam  = dataBind.paramData("scanArea");
		if( $.trim(scanParam.get("ASNSKU")) == "" ){
			fail.play();
			
			mobileCommon.alert({
				message : "상품을 스캔 또는 입력해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","ASNSKU");
				}
			});
			return false;
		}
		
		if(gridId == "gridList"){
			if(colName == "PRCQTY"){
				var prcuom = gridList.getColData(gridId, rowNum, "PRCUOM");
				var boxQty = commonUtil.parseInt(commonUtil.replaceAll(gridList.getColData(gridId, rowNum, "BOXQTY"), ",", ""));
				var inpqty = commonUtil.parseInt(commonUtil.replaceAll(gridList.getColData(gridId, rowNum, "INPQTY"), ",", ""));
				var palqty = commonUtil.parseInt(commonUtil.replaceAll(gridList.getColData(gridId, rowNum, "PALQTY"), ",", ""));
				var rcvqty = commonUtil.parseInt(commonUtil.replaceAll(gridList.getColData(gridId, rowNum, "RCVQTY"), ",", "")); //가능수량
				
				var prcqty = commonUtil.parseInt(commonUtil.replaceAll(colValue, ",", ""));
				if( prcqty < 0 ){
					fail.play();
					
					mobileCommon.alert({
						message : "<span class='msgColorRed'>0</span> 보다 큰 수량을 입력 해주세요.",
						confirm : function(){
							mobileCommon.focus("","detail","PRCQTY");
							gridList.setColValue(gridId, rowNum, "QTVIWE", 0);
						}
					});
					
					return false;
				}
				
				var qty;
				if( prcuom == "EA" ){
					qty = 1 * prcqty;
					
				}else if( prcuom == "CS" ){//박스
					qty = boxQty * prcqty;
				}else if( prcuom == "IP" ){ //이너팩
					qty = inpqty * prcqty;
				}else if( prcuom == "PL" ){ //팔레트
					qty = palqty * prcqty;
				}
				
				if( qty > rcvqty ){
					fail.play();
					
					mobileCommon.alert({
						message : "입고예정 수량보다 클 수 없습니다",
						confirm : function(){
							mobileCommon.focus("","detail","PRCQTY");
							gridList.setColValue(gridId, rowNum, "QTVIWE", 0);
						}
					});
				}
				
				gridList.setColValue(gridId, rowNum, "QTVIWE", qty);
			}else if(colName == "PRCUOM"){
				gridList.setColValue("gridList", 0, "PRCQTY", 0);
				gridList.setColValue("gridList", 0, "QTVIWE", 0);
			}else if(colName == "LOTA06"){
				var param = new DataMap();
				
				var $lota08 = $("#detail [name=LOTA08]");
				var $lota09 = $("#detail [name=LOTA09]");
				
				var wareky = gridList.getColData(gridId, rowNum, "WAREKY");
				var lota06 = colValue;
				var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
				var lotl01 = gridList.getColData(gridId, rowNum, "LOTL01");
				var usarg3 = gridList.getColData(gridId, rowNum, "USARG3");
				
				param.put("WAREKY",wareky);
				param.put("LOTA06",lota06);
				
				if( lota06 == "00" || lota06 == "10" ){
					param.put("VALUE", "OK");
					param.put("SKUKEY", skukey);
				}
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "GR02_LOTA06",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					if( json.data.length > 0 ){
						var rowData = json.data[0];
						
						var locaky = rowData["LOCAKY"];
						var locanm = rowData["LOCANM"];
						var lota06 = rowData["LOTA06"];
						var areaky = rowData["AREAKY"];
						var mnglt9 = rowData["MNGLT9"];
						var mngmov = rowData["MNGMOV"];
						
						gridList.setColValue("gridList", 0, "LOCAKY", locaky);
						gridList.setColValue("gridList", 0, "LOCANM", locanm);
						gridList.setColValue("gridList", 0, "LOTA06", lota06);
						gridList.setColValue("gridList", 0, "AREAKY", areaky);
						gridList.setColValue("gridList", 0, "MNGLT9", mnglt9);
						gridList.setColValue("gridList", 0, "MNGMOV", mngmov);
						
						if( lotl01 == "Y" && usarg3 == "Y" && mnglt9 != "V"){
							$lota08.attr("readonly",false).css("background","none");
							$lota09.attr("readonly",false).css("background","none");
						}else{
							$lota08.attr("readonly",true).css("background","#ededed");
							$lota09.attr("readonly",true).css("background","#ededed");
						}
					}else{
						if($.trim(lota06) == ""){
							gridList.setColValue("gridList", 0, "LOCAKY", "");
							gridList.setColValue("gridList", 0, "LOCANM", "");
							gridList.setColValue("gridList", 0, "LOTA06", "");
							gridList.setColValue("gridList", 0, "AREAKY", "");
							gridList.setColValue("gridList", 0, "MNGLT9", "");
							gridList.setColValue("gridList", 0, "MNGMOV", "");
							
							$lota08.attr("readonly",true).css("background","#ededed");
							$lota09.attr("readonly",true).css("background","#ededed");
						}else{
							fail.play();
							
							mobileCommon.alert({
								message : "해당 로케이션을 찾을 수 없습니다.",
								confirm : function(){
									gridList.setColValue("gridList", 0, "LOCAKY", "");
									gridList.setColValue("gridList", 0, "LOCANM", "");
									gridList.setColValue("gridList", 0, "LOTA06", "");
									gridList.setColValue("gridList", 0, "AREAKY", "");
									gridList.setColValue("gridList", 0, "MNGLT9", "");
									gridList.setColValue("gridList", 0, "MNGMOV", "");
									
									gridList.setColValue("gridList", 0, "LOTA06", "");
									mobileCommon.select("", "detail", "LOTA06");
									
									$lota08.attr("readonly",true).css("background","#ededed");
									$lota09.attr("readonly",true).css("background","#ededed");
								}
							});
						}
					}
				}
			}else if(colName == "LOTA08"){
				changeDate(gridId,rowNum,colName,gridList.getRowData(gridId, rowNum));
			}else if(colName == "LOTA09"){
				changeDate(gridId,rowNum,colName,gridList.getRowData(gridId, rowNum));
			}
		}
	}
	
	function changeDate(gridId,rowNum,colName,rowData){
		var todayDate = today();
		var duemon = rowData.get("DUEMON");
		var dueday = rowData.get("DUEDAY");
		var colValue = commonUtil.replaceAll(rowData.get(colName),".","");
		
		//제조일자 홛인
		if( colName == "LOTA08" ){
			if( todayDate < colValue ){
				fail.play();
				
				mobileCommon.alert({
					message : "제조일자는 오늘날짜보다 클 수 없습니다.",
					confirm : function(){
						mobileCommon.focus("", "detail", colName);
						gridList.setColValue(gridId, rowNum, "LOTA09", "");
					}
				});
				
				return false;
			}
		}
		
		//유통기한은 계산 안함
		if( colName == "LOTA09" ){
			gridList.setColValue(gridId, rowNum, "LOTA08", "");
			return false;
		}
		
		//유통기한일수 미설정
		if( (duemon == "0" && dueday == "0") || $.trim(colValue) == "" ){
			fail.play();
			
			mobileCommon.alert({
				message : "유통기한 일수가 설정되어있지 않습니다.",
				confirm : function(){
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
				}
			});
			return false;
		}
		
		var param = new DataMap();
		param.put("A" + colName, colValue);
		param.put("DUEMON", duemon);
		param.put("DUEDAY", dueday);
		
		var json = netUtil.sendData({
			module : "WmsInventory",
			command : "SJ01DATE",
			sendType : "list",
			param : param
		});
		
		//일자체크
		if( json && json.data ){
			// 오늘일자 < 제조일자
			if( colName == "LOTA09" && (todayDate < json.data[0].DUEDAY) ){
				fail.play();
				
				mobileCommon.alert({
					message : "제조일자는 오늘날짜보다 클 수 없습니다.",
					confirm : function(){
						mobileCommon.select("", "detail", "LOTA09");
						gridList.setColValue(gridId, rowNum, "LOTA08", "");
					}
				});
				return false;
			}
			
			if( json.data[0].DUEDAY != colValue ){
				var dateFormat = json.data[0].DUEDAY.substr(0,4) + "." + json.data[0].DUEDAY.substr(4, 2) + "." + json.data[0].DUEDAY.substr(6, 2);
				if( colName == "LOTA08" ){
					gridList.setColValue(gridId, rowNum, "LOTA09", dateFormat);
				}
			}
		}else{
			fail.play();
			
			mobileCommon.alert({
				message : "날짜 형식을 확인해 주세요.",
				confirm : function(){
					mobileCommon.select("", "detail", "LOTA09");
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
				}
			});
		}
	}
	
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if((areaId == "detail" && inputName == "LOTA09") 
				|| (areaId == "detail" && inputName == "LOTA08")){
			
			var gridId = "gridList";
			var rowNum = 0;
			
			gridList.setColValue(gridId, rowNum, inputName, value);
			
			var rowData = gridList.getRowData(gridId, rowNum);
			changeDate(gridId, rowNum, inputName, rowData);
		}
	}
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=LOTA06]"), configData.INPUT_COMBO, "Common,COMCOMBO", true);
	}
	
	function initAll(){
		g_head.clear();
		asnParam.clear();
		gridList.resetGrid("gridList");
		
		mobileCommon.initSearch(["detail"], true);
		
		$("#BOXQTY").html("0");
		
		numberInputReadOnly();
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = dataBind.paramData("scanArea");
		if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "MGR01");
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				var rcptty = param.get("RCPTTY");
				if( rcptty == "105" ){
					param.put("USARG3", 'V');
				}
			}else if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
				
			}
			return param;
		}
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
	
	//초기화
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				g_head.clear();
				asnParam.clear();
				gridList.resetGrid("gridList");
				mobileCommon.initSearch(null, true);
				
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				
				dataBind.dataNameBind(param, "scanArea");
				
				numberInputReadOnly();
				
				$("#BOXQTY").html("0");
				
				mobileCommon.focus("", "scanArea", "ASNSKU");
			}
		});
	}
</script>
</head>
<body>
	<div class="tem6_wrap">
		
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area" style="padding-top: 9px;">
				<table id="scanArea">
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<input type="hidden" name="WAREKY" value="<%=wareky%>"/>
						<tr>
							<th CL="STD_ASDTTY">입고타입</th>
							<td>
								<select Combo="WmsCommon,DOCTMCOMBO" name="RCPTTY" id="RCPTTY" ComboCodeView=false></select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUINF">상품</th>
							<td>
								<input type="text" name="ASNSKU" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'getAsnInfData()')"/>
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
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- Detail Area -->
			<div class="detailArea" id="detail">
				<div class="detailContent">
					<div class="pageCount" style="height:4px;"></div>
					<div class="content">
						<table>
							<colgroup>
								<col width="70" />
								<col />
							</colgroup>
							<tbody>
								<tr>
								<th CL="STD_MSNSKU">입고상품</th>
								<td colspan="2">
										<input type="text" name="SKUKEY" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_DESC01">상품명</th>
									<td colspan="2">
										<input type="text" name="DESC01" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA06">재고상태</th>
									<td colspan="2">
										<select Combo="Common,COMCOMBO" name="LOTA06" id="LOTA06" ComboCodeView=false>
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOCAKY">로케이션</th>
									<td colspan="2">
										<input type="text" name="LOCANM" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTL01">유통기한</th>
									<td>
										<input type="text" name="LOTL01" readonly="readonly"/>
									</td>
									<td>
										<input type="text" name="LTL1NM" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA09">유통기한</th>
									<td colspan="2">
										<input type="text" name="LOTA09"  UIFormat="D"/>
									</td>
									
								</tr>
								<tr>
									<th CL="STD_LOTA08">제조일자</th>
									<td colspan="2">
										<input type="text" name="LOTA08" UIFormat="D" />
									</td>
								</tr>
								<tr>
									<th CL="STD_RECDLI">입고예정</th>
									<td style="text-align:left;">
										<input type="text" name="BOXORG" UIFormat="N" readonly="readonly" style="width:42px;"/> <!-- 박스 -->
										<span>&nbsp;/&nbsp;</span>
										<input type="text" name="EAORG" UIFormat="N" readonly="readonly" style="width:50px;"/><!-- 나머지 낱개 -->
									</td>
									<td style="text-align:right;">
										<span>낱개&nbsp;&nbsp;</span> <input type="text" name="RCVQTY" UIFormat="N" readonly="readonly" style="width:50px;"/><!-- 종 낱개 갯수 -->
									</td>
								</tr>
								<tr>
									<th CL="STD_QTYRCV">입고수량</th>
									<td>
										<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM" ComboCodeView=false></select>
									</td>
									<td>
										<input type="text" name="PRCQTY" id="PRCQTY" UIFormat="N 10"/>
									</td>
								</tr>
								<tr>
									<th></th>
									<td>
										<input type="text" name="QTVIWE" UIFormat="N" readonly="readonly"/>
									</td>
									<td>
										BOX입수 : <span id="BOXQTY">0</span>
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
								<li class="btn" style="width: 100%;">
									<button class="wid3 l" onclick="saveData();"><span>입고완료</span></button>
									<button class="wid3 l btnBgW" onclick="initPage();"><span>초기화</span></button>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>