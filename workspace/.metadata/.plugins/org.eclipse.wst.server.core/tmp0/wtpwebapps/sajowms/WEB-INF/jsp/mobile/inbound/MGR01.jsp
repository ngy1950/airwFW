<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var headCnt;
	var itemCnt;
	var todayDate;
	var numberTimer = null;
	
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
			module : "WmsTask",
			command : "MV01Sub",
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
			module : "WmsInbound",
			command : "ASNODSELECT"
		});
		
		//사은품검색
		mobileSearchHelp.setSearchHelp({
			id : "SKUKEY",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			buttonShow : false,
			photoView : true,
			grid : [
						{"width":80, "label":"STD_LOTL04,3","type":"text","col":"LT04NM"},
						{"width":80, "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":80, "label":"STD_DESC01","type":"text","col":"DESC01"}
					],
			module : "WmsInbound",
			command : "SKUKEYSELECT"
		});
		
		//scanArea 입고타입
		$("#RCPTTY").change(function(){
			init();
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
		});
		
		//detail 유통기한 체인지 이벤트
		$("#detail [name=LOTA09]").on("change",function(){
			changeLota09($(this).attr("id"));
		});
		
		//detail 제조일자 체인지 이벤트
		$("#detail [name=LOTA08]").on("change",function(){
			changeLota09($(this).attr("id"));
		});
		
		//detail 제조상태 체인지 이벤ㅌ,
		$("#detail [name=LOTA06]").on("change",function(){
			changeLota06($(this).val());
		});
		
		mobileCommon.focus("", "scanArea", "ASNSKU");
		
		today();
		
		numberInputReadOnly();
		
		parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType("detail");
		mobileCommon.openDetail("detail");
	});
	
	function numberInputReadOnly(){
		$("[name=LOTA06]").attr({"disabled" : true, "class": "readOnly"});
		$("[name=LOTA08]").attr({"readonly" : true}).css({"background": "#ededed"});
		$("[name=LOTA09]").attr({"readonly" : true}).css({"background": "#ededed"});
		$("[name=PRCUOM]").attr({"disabled" : true, "class": "readOnly"});
		$("[name=PRCQTY]").attr({"class": "readOnly"});
		
		var $obj = $("#detail [name=PRCQTY]");
		numberTimer = setInterval(function() {
			var type = $obj.attr("type");
			if(type == "tel"){
				clearInterval(numberTimer);
				numberTimer = null;
				$obj.attr("readonly",true);
			}
		});
	}
	
	function today(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	function packSkuSearch(){
		var data = new DataMap();
		data.put("WAREKY","");
		data.put("SEBELN","");
		data.put("SVBELN","");
		data.put("ASNDKY","");
		data.put("OWNRKY","");
		data.put("DOCDAT","");
		data.put("DPTNTY","");
		data.put("DPTNKY","");
		data.put("DPTNNM","");
		data.put("PGRC01","");
		dataBind.dataNameBind(data,"scanArea");
		
		var scanSku = dataBind.paramData("scanArea");
		var skukey = scanSku.get("ASNSKU");
		
		if(isNull(skukey)){
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품</span>을 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","ASNSKU");
					init();
				}
			});
			
			return;
		}
		
		scanSku.put("SKUKEY",skukey);//8801043020466
		var json = netUtil.sendData({
			url : "/mobile/json/getSkuInf.data",
			param : scanSku
		});
		
		if(json && json.data){
			var area = "scanArea";
			
			if(json.data.length == 0){
				mobileCommon.alert({
					message : "존재하지 않는 상품입니다.",
					confirm : function(){
						mobileCommon.select("",area,"ASNSKU");
					}
				});
				
				return;
			}else if(json.data.length == 1){
				var data = new DataMap();
				data.put("ASNSKU",json.data[0].SKUKEY);
				
// 				dataBind.dataBind(data, area);
				dataBind.dataNameBind(data, area);
			}
			searchData();
		}
	}
	
	
	//상품 조회
	function searchData(){
		if(validate.check("scanArea")){
			mobileCommon.initSearch(["detail"], true);
			
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			
			var rcptty = param.get("RCPTTY");
			var $lota06 = $("[name=LOTA06]");
			var $lota08 = $("[name=LOTA08]");
			var $lota09 = $("[name=LOTA09]");
			var $prcuom = $("[name=PRCUOM]");
			var $prcqty = $("[name=PRCQTY]");
			
			$lota06.attr({"disabled" : true, "class": "readOnly"});
			$lota08.attr("readonly", false).css({"background": "none"});
			$lota09.attr("readonly", false).css({"background": "none"});
			$prcuom.attr("disabled", false).removeClass("readOnly");
			$prcqty.attr("readonly", false).removeClass("readOnly");
			
			if( rcptty == "105" ){
				$lota06.attr("disabled", false).removeClass("readOnly");
				
			}else if( rcptty == "104" || rcptty == "103"){
				$prcuom.attr({"disabled" : true, "class": "readOnly"});
				$prcqty.attr({"readonly" : true, "class": "readOnly"});
			}
			
			//asnod cnt 조회
			netUtil.send({
				module : "WmsInbound",
				command : "SKUCHKLIST",
				param : param,
				sendType : "list",
				successFunction : "searchCntCallBack"
			});
		}
	}
	
	function searchCntCallBack(json){
		if( json && json.data ){
			headCnt = json.data[0];
			itemCnt = json.data[1];
			
			if( headCnt.CNT > 1 ){
				mobileSearchHelp.selectSearchHelp("ASNSKU"); //팝업 오픈
				
			}else if( headCnt.CNT == 1 ){
				headSearch(); //상품서치
				
			}else{
				mobileCommon.alert({
					message : "입고상품이 존재하지 않습니다.",
					confirm : function(){
						mobileCommon.select("", "scanArea", "ASNSKU");
					}
				});
				
				init();
			}
		}
	}
	
	//상품 세부 조회
	function headSearch(){
		var param = dataBind.paramData("scanArea");
		param.put("WAREKY","<%=wareky%>");
		param.put("ASNDKY", headCnt.ASNDKY);
		
		var json = netUtil.sendData({
			module : "WmsInbound",
			command : "ASNODSELECT",
			param : param,
			sendType : "list"
		});
		
		if( json && json.data ){
			var data = json.data;
			dataBind.dataNameBind(data[0], "scanArea");
			itemSearch(data[0].CHG_SKU_YN);
		}else{
			mobileCommon.alert({
				message : "입고상품이 존재하지 않습니다.",
				confirm : function(){
					init();
				}
			});
			return false;
		}
	}
	
	//입고상품 상세조회
	function itemSearch(CHG_SKU_YN){
		var param = dataBind.paramData("scanArea");
		param.put("WAREKY","<%=wareky%>");
		
		var rcptty = param.get("RCPTTY");
		if( rcptty == "101" || rcptty == "102" || rcptty == "103" ){
			var json = netUtil.sendData({
				module : "WmsInbound",
				command : "MGR01_1I",
				param : param,
				sendType : "map"
			});
			
			
		}else if( rcptty == "104" ){//센터간이동입고
			var json = netUtil.sendData({
				module : "WmsInbound",
				command : "MGR01_4I",
				param : param,
				sendType : "map"
			});
			
		}else if( rcptty == "105" ){//반품입고
			var json = netUtil.sendData({
				module : "WmsInbound",
				command : "MGR01_2I",
				param : param,
				sendType : "map"
			});
		}
		
		
		if( json && json.data ){
			var data = json.data;
			dataBind.dataNameBind(data, "detail");
			$("#BOXQTY").html(data.BOXQTY);
			
			if( rcptty == "101" || rcptty == "102" || rcptty == "103" ){
				if( CHG_SKU_YN == "Y"  && itemCnt.CNT > 1 ){
					mobileSearchHelp.selectSearchHelp("SKUKEY");
				}else{
					if( data.LOTL01 == "Y" ){
						$("[name=LOTA08]").attr("readonly",false).css("background","none");
						$("[name=LOTA09]").attr("readonly",false).css("background","none");
						mobileCommon.select("", "detail", "LOTA09");
					}else{
						$("[name=LOTA08]").attr("readonly",true).css("background","#ededed");
						$("[name=LOTA09]").attr("readonly",true).css("background","#ededed");
						mobileCommon.focus(data.PRCQTY,"detail","PRCQTY");
					}
				}
			}
			
		}else{
			mobileCommon.alert({
				message : "입고상품이 상세내역이 존재하지 않습니다.",
				confirm : function(){
					mobileCommon.select("", "scanArea", "ASNSKU");
				}
			});
			return false;
		}
	}
	
	// 서치헬프 오픈 이벤트
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var scanParam = dataBind.paramData("scanArea");
		var detailParam = dataBind.paramData("detail");
		scanParam.put("WAREKY","<%=wareky%>");
		
		if( layerId == "ASNSKU_LAYER" ){
			scanParam.put("POPUP", "POPUP");
			return scanParam;
			
		}else if( layerId == "SKUKEY_LAYER" ){
			scanParam.put("LOTA06", detailParam.get("LOTA06"));
			return scanParam;
		}
	}
	
	//서치헬프 닫힌 후 이벤트
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if( layerId == "ASNSKU_LAYER" ){
			dataBind.dataNameBind(data, "scanArea");
			itemSearch(data.get("CHG_SKU_YN"));
			
		}else if( layerId == "SKUKEY_LAYER" ){
			dataBind.dataNameBind(data, "detail");
			
			if(data.get("LOTL01") == "Y"){
				mobileCommon.select("", "detail", "LOTA09");
			}else{
				mobileCommon.focus("","detail","PRCQTY");
			}
			
			$("#BOXQTY").html(data.get("BOXQTY"));
			//searchData();
		}
	}
	
	//재고상태 변경
	function changeLota06(lota06){
		var scanParam = dataBind.paramData("scanArea");
		if( $.trim(scanParam.get("ASNSKU")) == "" ){
			mobileCommon.alert({
				message : "상품을 입력해주세요.",
				confirm : function(){
					$("[name=LOTA06]").val("");
					mobileCommon.select("", "scanArea", "ASNSKU");
				}
			});
			return false;
		}
		
		var detailParam = dataBind.paramData("detail");
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		param.put("LOTA06", lota06);
		
		if( lota06 == "00" || lota06 == "10" ){
			param.put("VALUE", "OK");
			param.put("SKUKEY", detailParam.get("SKUKEY"));
		}
		
		var json = netUtil.sendData({
			module : "WmsInbound",
			command : "GR02_LOTA06",
			sendType : "list",
			param : param
		});
		
		//일자체크
		var data = new DataMap();
		data.put("LOCAKY", "");
		data.put("LOCANM", "");
		data.put("LOTA06", "");
		data.put("AREAKY", "");
		data.put("MNGLT9", "");
		data.put("MNGMOV", "");
		
		if( json && json.data ){
			if( json.data.length > 0 ){
				data.put("LOCAKY", json.data[0].LOCAKY);
				data.put("LOCANM", json.data[0].LOCANM);
				data.put("LOTA06", json.data[0].LOTA06);
				data.put("AREAKY", json.data[0].AREAKY);
				data.put("MNGLT9", json.data[0].MNGLT9);
				data.put("MNGMOV", json.data[0].MNGMOV);
				
				dataBind.dataNameBind(data,"detail");
			}else{
				mobileCommon.alert({
					message : "해당 로케이션을 찾을 수 없습니다.",
					confirm : function(){
						dataBind.dataNameBind(data,"detail");
						mobileCommon.select("", "detail", "LOTA06");
					}
				});
			}
		}
	}
	
	//유통기한 변경
	function changeLota09(inputName){
		var inputId = inputName;
		var detailParam  = dataBind.paramData("detail");
		var duemon = detailParam.get("DUEMON");
		var dueday = detailParam.get("DUEDAY");
		var lota0 = detailParam.get(inputId);
		
		//제조일자 홛인
		if( inputId == "LOTA08" ){
			if( todayDate < lota0 ){
				mobileCommon.alert({
					message : "제조일자는 오늘날짜보다 클 수 없습니다.",
					confirm : function(){
						mobileCommon.focus("", "detail", inputId);
						$("input[name=LOTA09]").val("");
					}
				});
				return false;
			}
		}
		
		//유통기한은 계산 안함
		if( inputId == "LOTA09" ){
			$("input[name=LOTA08]").val("");
			return false;
		}
		
		//유통기한일수 미설정
		if( duemon == "0" && dueday == "0" || $.trim(lota0) == "" ){
			mobileCommon.alert({
				message : "유통기한 일수가 설정되어있지 않습니다.",
				confirm : function(){
					$("input[name=LOTA08]").val(" ");
					$("input[name=LOTA09]").val(" ");
				}
			});
			return false;
		}
		
		var param = new DataMap();
		param.put("A" + inputId, lota0);
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
			if( inputId == "LOTA09" && (todayDate < json.data[0].DUEDAY) ){
				mobileCommon.alert({
					message : "제조일자는 오늘날짜보다 클 수 없습니다.",
					confirm : function(){
						mobileCommon.select("", "detail", "LOTA09");
						$("input[name=LOTA08]").val("");
					}
				});
				return false;
			}
			
			if( json.data[0].DUEDAY != lota0 ){
				var dateFormat = json.data[0].DUEDAY.substr(0,4) + "." + json.data[0].DUEDAY.substr(4, 2) + "." + json.data[0].DUEDAY.substr(6, 2);
// 				if( inputId == "LOTA09" ){
// 					$("input[name=LOTA08]").val(dateFormat);
					
// 				}else 
					
				if( inputId == "LOTA08" ){
					$("input[name=LOTA09]").val(dateFormat);
				}
			}
		}else{
			mobileCommon.alert({
				message : "날짜 형식을 확인해 주세요.",
				confirm : function(){
					mobileCommon.select("", "detail", "LOTA09");
					$("input[name=LOTA08]").val("");
				}
			});
		}
	}
	
	//테이트피커 닫힌 후 이벤트
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "detail" && inputName == "LOTA09"){
			changeLota09(inputName);
		}else if(areaId == "detail" && inputName == "LOTA08"){
			changeLota09(inputName);
		}
	}
	
	
	// 단위변경시 초기화
	function changePrcuom(){
		$("input[name=PRCQTY]").val(0);
		$("input[name=QTVIWE]").val(0);
	}
	
	//수량 변경시
	function changeQty(){
		var scanParam  = dataBind.paramData("scanArea");
		if( $.trim(scanParam.get("ASNSKU")) == "" ){
			mobileCommon.alert({
				message : "상품을 스캔 또는 입력해주세요.",
				confirm : function(){
					mobileCommon.focus("","scanArea","ASNSKU");
				}
			});
			return false;
		}
		
		//디테일 수량 변경
		var param  = dataBind.paramData("detail");
		var prcuom = param.get("PRCUOM");
		var boxQty = commonUtil.parseInt(param.get("BOXQTY"));
		var inpqty = commonUtil.parseInt(param.get("INPQTY"));
		var palqty = commonUtil.parseInt(param.get("PALQTY"));
		var rcvqty = commonUtil.parseInt(param.get("RCVQTY")); //가능수량
		
		var prcqty = commonUtil.parseInt(param.get("PRCQTY"));
		if( prcqty <= 0 ){
			mobileCommon.alert({
				message : "<span class='msgColorRed'>0</span> 보다 작은 수량을 입력할 수 없습니다.",
				confirm : function(){
					mobileCommon.focus("","detail","PRCQTY");
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
		
		if( qty == 0 ){
			mobileCommon.alert({
				message : "수량은 <span class='msgColorRed'>0</span> 보다 커야합니다.",
				confirm : function(){
					mobileCommon.focus("0","detail","PRCQTY");
					$("input[name=QTVIWE]").val(0);
				}
			});
			return false;
		}
		
		if( qty > rcvqty ){
			mobileCommon.alert({
				message : "입고예정 수량보다 클 수 없습니다",
				confirm : function(){
					mobileCommon.focus("0","detail","PRCQTY");
					$("input[name=QTVIWE]").val(0);
				}
			});
			return false;
		}
		
		var data = new DataMap();
		data.put("QTVIWE",qty);
		
		dataBind.dataNameBind(data,"detail");
	}
	
	//입고타입 제외 초기화
	function init(){
		mobileCommon.initSearch(["detail"], true);
		
		var data = new DataMap();
		data.put("WAREKY","<%=wareky%>");
		data.put("SEBELN","");
		data.put("SVBELN","");
		data.put("ASNDKY","");
		data.put("OWNRKY","");
		data.put("DOCDAT","");
		data.put("DPTNTY","");
		data.put("DPTNKY","");
		data.put("DPTNNM","");
		data.put("PGRC01","");
		data.put("ASNSKU","");
		
		dataBind.dataNameBind(data,"scanArea");
		$("#BOXQTY").text("0");
		mobileCommon.focus("", "scanArea", "ASNSKU");
		
	}
	
	//초기화
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				mobileCommon.initSearch(null, true);
				mobileCommon.focus("", "scanArea", "ASNSKU");
				$("#BOXQTY").text("0");
			}
		});
	}
	
	function saveData(){
		var scanParam = dataBind.paramData("scanArea");
		var detailParam = dataBind.paramData("detail");
		scanParam.put("WAREKY","<%=wareky%>");
		detailParam.put("WAREKY","<%=wareky%>");
		
		var asnsku = scanParam.get("ASNSKU");
		var prcqty = Number(detailParam.get("PRCQTY"));
		var qtviwe = Number(detailParam.get("QTVIWE"));
		var mngmov = detailParam.get("MNGMOV"); //locma 유통기한 관리여부
		var usarg3 = detailParam.get("USARG3"); //cmcdw 유통기한 관리여부
		var lotl01 = detailParam.get("LOTL01"); //skuma 유통기한 관리여부
		var lotl02 = detailParam.get("LOTL02");
		var lota08 = detailParam.get("LOTA08"); //제조일자
		var lota09 = detailParam.get("LOTA09"); //유통기한
		var skukey = detailParam.get("SKUKEY");
		
		//lotl02(입고기준구분코드) 입고 통제일 조회
		if( lotl01 == "Y" && lotl02 == "1" || lotl01 == "Y" && lotl02 == "2" ){
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
					mobileCommon.alert({
						message : "상품코드["+ skukey +"]는 입고통제일 기준에 미달합니다.",
						confirm : function(){
							mobileCommon.focus("","detail","LOTA08");
							mobileCommon.focus("","detail","LOTA09");
						}
					});
					return false;
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
			mobileCommon.alert({
				message : "입고 수량은 <span class='msgColorRed'>0</span> 보다 커야 합니다.",
				confirm : function(){
					mobileCommon.focus("0", "detail", "PRCQTY");
				}
			});
			return false;
		}
		
		var head = [scanParam];
		var item = [detailParam];
		
		var saveData = new DataMap();
		saveData.put("head", head);
		saveData.put("item", item);
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
			mobileCommon.alert({
				message : "입고완료되었습니다.",
				confirm : function(){
					mobileCommon.focus("0", "detail", "PRCQTY");
					init();
				}
			});
		}else{
			mobileCommon.toast({
				type : "F",
				message : "입고실패하였습니다.",
				execute : function(){
					mobileCommon.focus("0", "detail", "PRCQTY");
					init();
				}
			});
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
	
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
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
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=LOTA06]"), configData.INPUT_COMBO, "Common,COMCOMBO", true);
	}
	
</script>
</head>
<body>
	<div class="tem6_wrap">
		
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area" style="padding-top: 9px;">
				<table id="scanArea">
					<input type="hidden" name="SEBELN" value=""/>
					<input type="hidden" name="SVBELN" value=""/>
					<input type="hidden" name="ASNDKY" value=""/>
					<input type="hidden" name="OWNRKY" value=""/>
					<input type="hidden" name="WAREKY" value=""/>
					<input type="hidden" name="DOCDAT" value=""/>
					<input type="hidden" name="DPTNTY" value=""/>
					<input type="hidden" name="DPTNKY" value=""/>
					<input type="hidden" name="DPTNNM" value=""/>
					<input type="hidden" name="PGRC01" value=""/>
					
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_ASDTTY">입고타입</th>
							<td>
								<select Combo="WmsCommon,DOCTMCOMBO" name="RCPTTY" id="RCPTTY" ComboCodeView=false>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUINF">상품</th>
							<td>
								<input type="text" name="ASNSKU" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'packSkuSearch()')"/>
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
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">입고완료</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
			<!-- Detail Area -->
			<div class="detailArea" id="detail">
				<div class="detailContent">
					<div class="pageCount" style="height:4px;">
<!-- 						<span class="txt">Page.</span><span class="count">0</span><span class="slush">/</span><span class="totalCount">0</span> -->
					</div>
					<div class="content">
						<table>
						
						<input type="hidden" name="OWNRKY"/>
						<input type="hidden" name="MNGMOV"/><!-- locma 유통기한 관리여부 -->
						<input type="hidden" name="LOTL02"/>
						<input type="hidden" name="USARG3"/>
						<input type="hidden" name="MNGLT9"/>
						<input type="hidden" name="DUEMON"/>
						<input type="hidden" name="DUEDAY"/>
						<input type="hidden" name="BOXQTY"/>
						<input type="hidden" name="INPQTY"/>
						<input type="hidden" name="PALQTY"/>
						
						<input type="hidden" name="ORG_SKUKEY"/>
						<input type="hidden" name="DESC02"/>
						<input type="hidden" name="LOCAKY"/>
						<input type="hidden" name="AREAKY"/>
						<input type="hidden" name="QTYORG"/>
						<input type="hidden" name="QTYRCV"/>
						<input type="hidden" name="RSNCOD"/>
						<input type="hidden" name="RTNTXT"/>
						<input type="hidden" name="HHTTID"/>
						<input type="hidden" name="LOTA01"/>
						<input type="hidden" name="REFDKY"/>
						<input type="hidden" name="REFDIT"/>
						<input type="hidden" name="REFDTL"/>
						<input type="hidden" name="REFCAR"/>
						<input type="hidden" name="SEBELN"/>
						<input type="hidden" name="SEBELP"/>
						<input type="hidden" name="STRAID"/>
						<input type="hidden" name="SVBELN"/>
						<input type="hidden" name="SPOSNR"/>
						<input type="hidden" name="ASNDKY"/>
						<input type="hidden" name="ASNDIT"/>
						<input type="hidden" name="ASNTYP"/>
						<input type="hidden" name="QTYORD"/>
						<input type="hidden" name="DUOMKY"/>
						<input type="hidden" name="UOMORD"/>
						<input type="hidden" name="SHPDGR"/>
						<input type="hidden" name="SHPDGR"/>
						<input type="hidden" name="SHDTLN"/>
						<input type="hidden" name="SHCARN"/>
						<input type="hidden" name="SHOPID"/>
						<input type="hidden" name="SHPTYP"/>
						<input type="hidden" name="VTRCOD"/>
						<input type="hidden" name="PRODCD"/>
						<input type="hidden" name="PODATE"/>
						<input type="hidden" name="OUCOST"/>
						<input type="hidden" name="RVIT04"/>
						<input type="hidden" name="ASNSKU"/>
						<input type="hidden" name="SKUCLS"/>
						<input type="hidden" name="SKUPACK"/>
						<input type="hidden" name="REALQTY"/>
						<input type="hidden" name="SALESK"/>
						<input type="hidden" name="PACQTY"/>
						<input type="hidden" name="PACKYN"/>
						
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
										<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM" ComboCodeView=false onchange="changePrcuom();">
										</select>
									</td>
									<td>
										<input type="text" name="PRCQTY" id="PRCQTY" UIFormat="N 10" onchange="changeQty()" />
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
<!-- 								<li class="prev"><p></p></li> -->
								<li class="btn" style="width: 100%;">
									<button class="wid3 l" onclick="saveData();"><span>입고완료</span></button>
									<button class="wid3 l btnBgW" onclick="initPage();"><span>초기화</span></button>
								</li>
<!-- 								<li class="next"><p></p></li> -->
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>