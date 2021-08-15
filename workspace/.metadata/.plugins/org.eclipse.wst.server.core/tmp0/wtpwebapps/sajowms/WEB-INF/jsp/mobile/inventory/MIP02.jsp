<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<style>
.gridIcon-center{text-align: center;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}

.minusQtyTitle{width: 50px;height: 35px;padding-right: 20px;text-align: left;font-weight: bold;float: left;}
.minusQtyTitle .t1{padding-top: 2px;padding-bottom: 0px;}
.minusQtyTitle .t2{padding-left: 10px;}
.minusQtyContent{width: calc(100% - 70px);height: 35px;float: left;}
.minusQtyContent input[type=checkbox]{width: 34px !important;height: 34px !important;float: left;margin-top: 1px !important;}
.minusQtyContent p{width: calc(100% - 70px);height: 15px;float: left;font-weight: bold;text-align: left;padding-top: 17px;color: #f14f4f;}
.minusQtyContent .infoRed{background: url(/mobile/img/ico/ico_info_red.png) no-repeat;background-size: 15px;float: left;width: 16px;margin: 19px 5px 0 10px;padding: 0;}
.minusTxt{width: 17px;height: 30px;float: left;display: none;}
.minusTxt div{padding: 14px 7px 14px 0px;}
.minusTxt div p{width: 100%;height: 0;background-size: 16px;border: 1px solid #f14f4f;}
</style>
<script type="text/javascript">
	var g_head = null;
	var g_locaky = "";
	var scanAreaHeight = 0;
	
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false,
			type : "grid",
			gridId : "gridList",
			detailId : "detail"
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "MIP02_USER",
			editable : false,
			emptyMsgType : false,
			gridMobileType : true,
			firstRowFocusType: false
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "phyiky",
			name : "PHYIKY",
			returnCol : "PHYIKY",
			bindId : "scanArea",
			title : "조사리스트 검색",
			inputType : "scanNumber",
			grid : [
						{"width":80,  "label":"STD_PHYIKY", "type":"text", "col":"PHYIKY"},
						{"width":150, "label":"STD_DOCTXT", "type":"text", "col":"DOCTXT"},
						{"width":80,  "label":"STD_DOCDAT", "type":"text", "col":"DOCDAT", "GF":"D"},
					],
			module : "Mobile",
			command : "MIP02_PHY_POP"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SHLOCAKY",
			name : "LOCAKY",
			returnCol : "LOCAKY",
			bindId : "scanArea",
			inputType : "scan",
			title : "로케이션 검색",
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "WmsTask",
			command : "MV01_LOCMA_POP"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "skukey",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			inputType : "scanNumber",
			buttonShow : false,
			grid : [
						{"width":70,  "label":"STD_GUBUN", "type":"text","col":"LT04NM"},
						{"width":90,  "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"},
					],
			module : "Mobile",
			command : "SKUINF"
		});
		
		init();
		
		mobileCommon.select("","scanArea","PHYIKY");
	});
	
	function getSkuInfData(){
		var param = dataBind.paramData("scanArea");
		
		var phyiky = param.get("PHYIKY");
		if(isNull(phyiky)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>조사번호</span>를 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.initBindArea("scanArea",["SKUKEY"]);
					mobileCommon.select("","scanArea","PHYIKY");
				}
			});
			return;
		}
		
		var skukey = param.get("SKUKEY");
		if(isNull(skukey)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해 주세요.",
				confirm : function(){
					var data = new DataMap();
					data.put("DESC01","");
					data.put("QTYBOX",0);
					data.put("QTYEA",0);
					data.put("BOXQTY",0);
					data.put("QTSPHY",0);
					dataBind.dataBind(data, "scanArea");
					dataBind.dataNameBind(data, "scanArea");
					mobileCommon.select("","scanArea","SKUKEY");
				}
			});
			return;
		}
		
		mobileCommon.initBindArea("scanArea",["PHYIIT","OWNRKY","DESC01","DESC02","LOTA01","LOTA06","SKUCLS","SKUGRD"]);
		
		var data = new DataMap();
		data.put("CRETYP","C");
		data.put("DUOMKY","EA");
		data.put("QTYBOX",0);
		data.put("QTYEA",0);
		data.put("BOXQTY",0);
		data.put("QTSPHY",0);
		data.put("HHTTID","PDA");
		
		dataBind.dataBind(data,"scanArea");
		dataBind.dataNameBind(data,"scanArea");
		
		gridList.resetGrid("gridList");
		
		var json = netUtil.sendData({
			url : "/mobile/json/getSkuInf.data",
			param : param
		});
		
		if(json && json.data){
			var area = "scanArea";
			
			if(json.data.length == 0){
				fail.play();
				
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
				
				var param = dataBind.paramData(area);
				if(isNull(param.get("LOCAKY"))){
					mobileCommon.select("","scanArea","LOCAKY");
				}else{
					mobileCommon.select("","scanArea","SKUKEY");
				}
				
				searchData();
			}else{
				mobileSearchHelp.selectSearchHelp("skukey");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			var param = dataBind.paramData("scanArea");
			
			var phyiky = param.get("PHYIKY");
			if(isNull(phyiky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>조사번호</span>를 입력 또는 스캔해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","PHYIKY");
					}
				});
				
				return;
			}
			
			gridList.resetGrid("gridList");
			
			netUtil.send({
				url : "/mobile/json/searchMIP02.data",
				param : param,
				sendType : "map",
				successFunction : "searchCallBack"
			});
		}
	}
	
	function searchCallBack(json){
		if(json && json.data){
			
			var result = json.data["result"];
			if(result == "T1" || result == "T2" || result == "T3" || result == "T4"){
				var area = "scanArea";
				
				var resultData = new DataMap();
				resultData.put("DESC01","");
				resultData.put("BOXQTY",0);
				resultData.put("QTYBOX",0);
				resultData.put("QTYEA",0);
				resultData.put("QTSPHY",0);
				
				var data = json.data["resultData"];
				var keys = Object.keys(data);
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						if(key != "QTYBOX" && key != "QTYEA" && key != "QTSPHY"){
							resultData.put(key,data[key]);
						}
					}
				}
				dataBind.dataBind(resultData, area);
				dataBind.dataNameBind(resultData, area);
				
				var param = dataBind.paramData(area);
				var phyiky = param.get("PHYIKY");
				var skukey = param.get("SKUKEY");
				var locaky = param.get("LOCAKY");
				
				if(isNull(locaky)){
					mobileCommon.select("",area,"LOCAKY");
				}else if(isNull(skukey)){
					if(!isNull(locaky) && result == "T4"){
						fail.play();
						
						mobileCommon.alert({
							message :  "로케이션 [ " + locaky +" ]에 등록된 상품이 아닙니다.",
							confirm : function(){
								mobileCommon.select("",area,"SKUKEY");
							}
						});
						
						return;
					}
					mobileCommon.select("",area,"SKUKEY");
				}else{
					var browser = navigator.userAgent;
					if(browser.indexOf("GsWmsPda") > -1){
						//mobileCommon.select("","scanArea","QTYBOX");
						setTimeout(function() {
							window.wmsBridge.openKeyPad("QTYEA");
						}, 300);
					}else{
						//mobileCommon.select("",area,"QTYEA");
						//mobileCommon.select("",area,"QTYBOX");
						appOpenKeyPad("QTYEA");
						setTimeout(function() {
							mobileKeyPad.openMobileKeyPad($("#scanArea [name=QTYEA]"));
						}, 300);
					}
				}
				
				if(result == "T4"){
					$("#hold").prop("checked",false);
				}
				
				gridList.resetGrid("gridList");
				
				if(!isNull(phyiky)&& !isNull(skukey) && !isNull(locaky)){
					gridList.gridList({
						id : "gridList",
						param : param
					});
				}
			}else if(result == "E1"){
				fail.play();
				
				mobileCommon.alert({
					message : "센터코드가 세팅되지 않았습니다.\n재 접속 후 다시 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","PHYIKY");
					}
				});
			}else if(result == "E2"){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>조사번호</span>를 입력 또는 스캔해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","PHYIKY");
					}
				});
			}else if(result == "E3"){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>로케이션</span>을 입력 또는 스캔해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else if(result == "E4"){
				fail.play();
				
				mobileCommon.alert({
					message : "존재하는 로케이션이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else if(result == "E5"){
				fail.play();
				
				mobileCommon.alert({
					message : "존재하는 상품이 아닙니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
			}
			/* else if(result == "E6"){
				mobileCommon.alert({
					message : "해당 로케이션에 등록된 상품이 아닙니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
			} */
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		if(layerId == "phyiky_LAYER"){
			return param;
		}else if(layerId == "SHLOCAKY_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			var locaky = data.get("LOCAKY");
			
			param.put("SKUKEY",skukey);
			param.put("LOCAKY",locaky);
			
			return param;
		}else if(layerId == "skukey_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			param.put("SKUKEY",skukey);
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "phyiky_LAYER"){
			checkPhyiky(data.get("PHYIKY"));
		}else if(layerId == "SHLOCAKY_LAYER"){
			searchData();
		}else if(layerId == "skukey_LAYER"){
			searchData();
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "SHLOCAKY_LIST" && dataLength == 0){
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.closeSearchArea("SHLOCAKY_LAYER");
					mobileCommon.focus("","scanArea","LOCAKY");
				}
			});
		}
	}
	
	function init(){
		mobileCommon.initSearch(null,true);
		
		var data = new DataMap();
		data.put("WAREKY","<%=wareky%>");
		data.put("PHYIIT","");
		data.put("CRETYP","C");
		data.put("AREAKY","");
		data.put("ZONEKY","");
		data.put("LOCAKY","");
		data.put("DUOMKY","EA");
		data.put("OWNRKY","");
		data.put("SKUKEY","");
		data.put("DESC01","");
		data.put("DESC02","");
		data.put("LOTA01","");
		data.put("LOTA06","");
		data.put("SKUCLS","");
		data.put("SKUGRD","");
		data.put("QTYBOX",0);
		data.put("QTYEA",0);
		data.put("BOXQTY",0);
		data.put("QTSPHY",0);
		data.put("HHTTID","PDA");
		
		dataBind.dataBind(data,"scanArea");
		dataBind.dataNameBind(data,"scanArea");
		
		gridList.resetGrid("gridList");
		
		$("#scanArea [name=QTYBOX]").unbind("keydown").on("keydown",function(){
			if(event.keyCode == 13){
				changeQty(1);
			}
		});
		
		$("#scanArea [name=QTYEA]").unbind("keydown").on("keydown",function(){
			if(event.keyCode == 13){
				changeQty(2);
			}
		});
		
		//scanAreaHeight = $(".scan_area").height();
		mobileKeyPad.areaObjHeight = $(".scan_area").height();
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				mobileCommon.initSearch(null,true);
				$("#hold").prop("checked",false);
				$("#QTYMIN").prop("checked",false);
				$(".minusTxt").hide();
				$("#scanArea [name=QTYBOX]").css("width","100%");
				$("#scanArea [name=QTYEA]").css("width","100%");
				gridList.resetGrid("gridList");
				
				var data = new DataMap();
				data.put("QTYBOX",0);
				data.put("QTYEA",0);
				data.put("BOXQTY",0);
				data.put("QTSPHY",0);
				
				dataBind.dataBind(data,"scanArea");
				dataBind.dataNameBind(data,"scanArea");
				
				mobileCommon.focus("","scanArea","PHYIKY");
			}
		});
	}
	
	function saveData(){
		var param = dataBind.paramData("scanArea");
		
		var phyiky = param.get("PHYIKY");
		var locaky = param.get("LOCAKY");
		var skukey = param.get("SKUKEY");
		var cretyp = param.get("CRETYP");
		var qtsphy = commonUtil.parseInt(param.get("QTSPHY"));
		
		if(isNull(phyiky)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>조사번호</span>를 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","PHYIKY");
				}
			});
			
			return;
		}
		
		if(isNull(locaky)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>로케이션</span>을 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","LOCAKY");
				}
			});
			
			return;
		}
		
		if(isNull(skukey)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span>를 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","SKUKEY");
				}
			});
			
			return;
		}
		
		if(cretyp == "U"){
			if(qtsphy <= 0){
				fail.play();
				
				mobileCommon.alert({
					message : "지시되지 않은 상품입니다.\n<span class='msgColorRed'>0</span> 이상의 수량을 입력해 주세요.",
					confirm : function(){
						var browser = navigator.userAgent;
						if(browser.indexOf("GsWmsPda") > -1){
							window.wmsBridge.openKeyPad("QTYEA");
						}else{
							mobileCommon.select("","scanArea","QTYEA");
						}
					}
				});
				
				return;
			}
		}
		/* else{
			if(qtsphy < 0){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorRed'>0</span> 보다 작은 수량을 입력할 수 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","QTYBOX");
					}
				});
				
				return;
			}
		} */
		
		var isMinus = $("#QTYMIN").is(":checked");
		if(isMinus){
			if(qtsphy <= 0){
				fail.play();
				
				mobileCommon.alert({
					message : "차감수량은 <span class='msgColorRed'>0</span> 이상의 수량만 입력 가능합니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","QTYEA");
					}
				});
				return;
			}
			
			param.put("isMinus","Y");
			
		}else{
			param.put("isMinus","N");
		}
		
		netUtil.send({
			url : "/mobile/json/saveMIP02.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["result"] == "S"){
				mobileCommon.toast({
					type : "S",
					message : "조사 완료 되었습니다.",
					execute : function(){
						success.play();
						
						var data = new DataMap();
						
						data.put("WAREKY","<%=wareky%>");
						data.put("PHYIIT","");
						data.put("CRETYP","C");
						
						data.put("DUOMKY","EA");
						data.put("OWNRKY","");
						data.put("SKUKEY","");
						data.put("DESC01","");
						data.put("DESC02","");
						data.put("SKUCLS","");
						data.put("SKUGRD","");
						data.put("QTYBOX",0);
						data.put("QTYEA",0);
						data.put("BOXQTY",0);
						data.put("QTSPHY",0);
						data.put("HHTTID","PDA");
						
						var isHold = $("#hold").is(":checked");
						if(!isHold){
							data.put("AREAKY","");
							data.put("ZONEKY","");
							data.put("LOCAKY","");
							data.put("LOTA01","");
							data.put("LOTA06","");
						}
						
						dataBind.dataBind(data,"scanArea");
						dataBind.dataNameBind(data,"scanArea");
						
						gridList.resetGrid("gridList");
						if(isHold){
							mobileCommon.select("","scanArea","SKUKEY");
						}else{
							mobileCommon.select("","scanArea","LOCAKY");
						}
						
						var isMinus = $("#QTYMIN").is(":checked");
						if(isMinus){
							$("#QTYMIN").prop("checked",false);
							$(".minusTxt").hide();
							$("#scanArea [name=QTYBOX]").css("width","100%");
							$("#scanArea [name=QTYEA]").css("width","100%");
						}
					}
				});
			}else if(json.data["result"] == "F"){
				fail.play();
				mobileCommon.alert({
					message : "확정된 조사번호는 처리 할 수 없습니다.",
					confirm : function(){
						mobileCommon.initSearch(null,true);
						$("#hold").prop("checked",false);
						gridList.resetGrid("gridList");
						mobileCommon.focus("","scanArea","PHYIKY");
					}
				});
			}else if(json.data["result"] == "N1"){
				fail.play();
				mobileCommon.alert({
					message : "지시되지 않은 상품은 조사수량을 차감할 수 없습니다.",
					confirm : function(){
						$("#QTYMIN").prop("checked",false);
						$(".minusTxt").hide();
						$("#scanArea [name=QTYBOX]").css("width","100%");
						$("#scanArea [name=QTYEA]").css("width","100%");
						mobileCommon.select("","scanArea","QTYEA");
					}
				});
			}else if(json.data["result"] == "N2"){
				fail.play();
				mobileCommon.alert({
					message : "차감수량은 <span class='msgColorRed'>0</span> 이상의 수량만 입력 가능합니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","QTYEA");
					}
				});
			}else if(json.data["result"] == "N3"){
				fail.play();
				mobileCommon.alert({
					message : "조사한 수량이 없습니다.\n조사수량 차감은 본인이 조사한 수량만 차감 가능합니다.",
					confirm : function(){
						$("#QTYMIN").prop("checked",false);
						$(".minusTxt").hide();
						$("#scanArea [name=QTYBOX]").css("width","100%");
						$("#scanArea [name=QTYEA]").css("width","100%");
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else if(json.data["result"] == "N4"){
				fail.play();
				mobileCommon.alert({
					message : "차감 수량은 본인이 조사한 수량 보다 클 수 없습니다. (차감 가능 수량 : <span class='msgColorRed'>"+(json.data["sum"])+"</span> EA)",
					confirm : function(){
						mobileCommon.select("","scanArea","QTYEA");
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "시스템 오류 입니다. *관리자에게 문의해 주세요.",
					execute : function(){
						fail.play();
					}
				});
			}
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
	
	function closeKeyPadAfterEvent(areaId,name,value,$Obj){
		if(areaId == "scanArea"){
			switch (name) {
			case "QTYBOX":
				sumChangeQty();
				isClose = true;
				$(".gridArea .excuteArea").show();
				break;
			case "QTYEA":
				sumChangeQty();
				
				$(".gridArea .excuteArea").show();
				break;
			default:
				$(".gridArea .excuteArea").show();
				break;
			}
		}
	}
	
	function nextFocus(){
		var param = dataBind.paramData("scanArea");
		
		var phyiky = param.get("PHYIKY");
		if(isNull(phyiky)){
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>조사번호</span>를 입력 또는 스캔해주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","PHYIKY");
				}
			});
			
			return;
		}
		
		checkPhyiky(phyiky);
	}
	
	function checkPhyiky(phyiky){
		setInitData();
		
		var param = new DataMap();
		param.put("PHYIKY",phyiky);
		
		var json = netUtil.sendData({
			url : "/mobile/json/searchMIP02CheckPhyiky.data",
			param : param
		});
		
		if(json && json.data){
			var result = json.data["result"];
			if(result == "S"){
				mobileCommon.select("","scanArea","LOCAKY");
			}else if(result == "F1"){
				fail.play();
				mobileCommon.alert({
					message : "존재하지 않는 조사번호 입니다.",
					confirm : function(){
						mobileCommon.focus("","scanArea","PHYIKY");
					}
				});
			}else if(result == "F2"){
				fail.play();
				mobileCommon.alert({
					message : "이미 확정된 조사번호 입니다.",
					confirm : function(){
						mobileCommon.focus("","scanArea","PHYIKY");
					}
				});
			}else{
				fail.play();
				mobileCommon.alert({
					message : "시스템 오류 입니다.\n*관리자에게 문의해 주세요.",
					confirm : function(){
						mobileCommon.focus("","scanArea","PHYIKY");
					}
				});
			}
		}
	}
	
	function setInitData(){
		var data = new DataMap();
		data.put("WAREKY","<%=wareky%>");
		data.put("PHYIIT","");
		data.put("CRETYP","C");
		data.put("AREAKY","");
		data.put("ZONEKY","");
		data.put("LOCAKY","");
		data.put("DUOMKY","EA");
		data.put("OWNRKY","");
		data.put("SKUKEY","");
		data.put("DESC01","");
		data.put("DESC02","");
		data.put("LOTA01","");
		data.put("LOTA06","");
		data.put("SKUCLS","");
		data.put("SKUGRD","");
		data.put("QTYBOX",0);
		data.put("QTYEA",0);
		data.put("BOXQTY",0);
		data.put("QTSPHY",0);
		data.put("HHTTID","PDA");
		
		dataBind.dataBind(data,"scanArea");
		dataBind.dataNameBind(data,"scanArea");
		
		gridList.resetGrid("gridList");
	}
	
	var isClose = false;
	var keyPadCloseTimer = null;
	
	function closeCheck(){
		keyPadCloseTimer = setInterval(function(){
			if(isClose == true){
				isClose = false;
				clearInterval(keyPadCloseTimer);
				keyPadCloseTimer = null;
					
				var browser = navigator.userAgent;
				if(browser.indexOf("GsWmsPda") > -1){
					window.wmsBridge.openKeyPad("QTYEA");
				}else{
					mobileCommon.select("","scanArea","QTYEA");
				}
			}
		});
	}
	
	function appOpenKeyPad(inputName){
		var $obj = $("#scanArea [name="+inputName+"]");
		
		$obj.focus();
		$obj.select();
		
		mobileKeyPad.focusOnEvent($obj);
	}
	
	function sumChangeQty(){
		var param  = dataBind.paramData("scanArea");
		
		var boxQty = commonUtil.parseInt(isNull(param.get("BOXQTY"))?0:param.get("BOXQTY"));
		var box    = commonUtil.parseInt(isNull(param.get("QTYBOX"))?0:param.get("QTYBOX"));
		var ea     = commonUtil.parseInt(isNull(param.get("QTYEA"))?0:param.get("QTYEA"));
		var qtsphy = (boxQty*box) + ea;
		
		var data = new DataMap();
		data.put("QTSPHY",qtsphy);
		
		dataBind.dataBind(data,"scanArea");
		dataBind.dataNameBind(data,"scanArea");
	}
	
	function changeQty(type){
		sumChangeQty();
		
		switch (type) {
		case 1:
			if(commonUtil.isMobile()){
				//closeCheck();
				var browser = navigator.userAgent;
				if(browser.indexOf("GsWmsPda") > -1){
					window.wmsBridge.openKeyPad("QTYEA");
				}else{
					//mobileCommon.select("","scanArea","QTYEA");
					var $obj = $("#scanArea [name=QTYEA]");
					mobileKeyPad.focusOnEvent($obj);
					$obj.focus();
					$obj.select();
				}
			}else{
				//mobileCommon.select("","scanArea","QTYEA");
				var $obj = $("#scanArea [name=QTYEA]");
				mobileKeyPad.focusOnEvent($obj);
				$obj.focus();
				$obj.select();
			}
			break;
		case 2:
			saveData();
			break;
		default:
			var isHold = $("#hold").is(":checked");
			if(isHold){
				mobileCommon.select("","scanArea","SKUKEY");
			}else{
				mobileCommon.select("","scanArea","LOCAKY");
			}
			break;
		}
	}
	
	function selectHoldCheckBox(){
		$(".gridArea .excuteArea").show();
		
		var data   = dataBind.paramData("scanArea");
		var phyiky = data.get("PHYIKY");
		var locaky = data.get("LOCAKY");
		var skukey = data.get("SKUKEY");
		
		if(isNull(phyiky)){
			mobileCommon.select("","scanArea","PHYIKY");
		}else{
			if(!isNull(locaky) && !isNull(skukey)){
				mobileCommon.select("","scanArea","SKUKEY");
			}else if(isNull(locaky) && !isNull(skukey)){
				mobileCommon.select("","scanArea","LOCAKY");
			}else if(!isNull(locaky) && isNull(skukey)){
				mobileCommon.select("","scanArea","SKUKEY");
			}else{
				mobileCommon.select("","scanArea","LOCAKY");
			}
		}
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
		
		if(gridId == "gridList"){
			if(colName == "DELMAK"){
				if(colValue == "V"){
					return "d";
				}else{
					return "y";
				}
			}
		}
	}
	
	function minusQty(){
		var $obj = $("#QTYMIN");
		var isCheck = $obj.is(":checked");
		if(isCheck){
			$(".minusTxt").show();
			$("#scanArea [name=QTYBOX]").css("width","calc(100% - 20px)");
			$("#scanArea [name=QTYEA]").css("width","calc(100% - 20px)");
		}else{
			$(".minusTxt").hide();
			$("#scanArea [name=QTYBOX]").css("width","100%");
			$("#scanArea [name=QTYEA]").css("width","100%");
		}
		
		var browser = navigator.userAgent;
		if(browser.indexOf("GsWmsPda") > -1){
			window.wmsBridge.openKeyPad("QTYEA");
		}else{
			//mobileCommon.select("","scanArea","QTYEA");
			var $obj = $("#scanArea [name=QTYEA]");
			mobileKeyPad.openMobileKeyPad($obj);
			$obj.select();
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
					<input type="hidden" name="WAREKY" value=""/>
					<input type="hidden" name="PHYIIT" value=""/>
					<input type="hidden" name="CRETYP" value=""/>
					<input type="hidden" name="AREAKY" value=""/>
					<input type="hidden" name="ZONEKY" value=""/>
					<input type="hidden" name="DUOMKY" value=""/>
					<input type="hidden" name="OWNRKY" value=""/>
					<input type="hidden" name="DESC02" value=""/>
					<input type="hidden" name="LOTA01" value=""/>
					<input type="hidden" name="LOTA06" value=""/>
					<input type="hidden" name="SKUCLS" value=""/>
					<input type="hidden" name="SKUGRD" value=""/>
					<input type="hidden" name="HHTTID" value=""/>
					
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr class="searchLine">
							<th CL="STD_PHYKEY">재고조사번호</th>
							<td colspan="4">
								<input type="text" name="PHYIKY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'nextFocus()')"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_LOCAKY">로케이션</th>
							<td colspan="3">
								<input type="text" name="LOCAKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td>
								<ul>
									<li style="float: left;width: 34px;height: 34px;margin: 0 3px;"><input type="checkbox" id="hold" style="width: 100%;height: 100%;" onchange="selectHoldCheckBox();"></li>
									<li style="float: left;line-height: 34px;font-weight: bold;"><span>고정</span></li>
								</ul>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">상품코드</th>
							<td colspan="4">
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01">상품명</th>
							<td colspan="4">
								<input type="text" name="DESC01" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_PRCQTY" rowspan="2"></th>
							<td style="width: 30%;">
								<div class="minusTxt"><div><p></p></div></div>
								<input type="text" name="QTYBOX" UIFormat="N 10"/>
							</td>
							<td style="width: 10%;">BOX</td>
							<th CL="STD_BOXQTY" style="text-align: center;"></th>
							<td style="width: 20%;">
								<input type="text" name="BOXQTY" UIFormat="N 10" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td>
								<div class="minusTxt"><div><p></p></div></div>
								<input type="text" name="QTYEA" UIFormat="N 10"/>
							</td>
							<td>EA</td>
							<td colspan="2">
								<input type="text" name="QTSPHY" readonly="readonly" UIFormat="N 10" style="color: #f14f4f;text-align: right;padding-right: 5px;"/>
							</td
						</tr>
						<tr>
							<td colspan="5">
								<div class="minusQtyTitle"><p class="t1">조사수량 </p><p class="t2">차감</p></div>
								<div class="minusQtyContent">
									<input type="checkbox" id="QTYMIN" name="QTYMIN" onclick="minusQty();"/>
									<p class="infoRed"></p><p>수량 차감시 클릭 해주세요.</p>
								</div>
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
								<col width="90" />
								<col width="70" />
								<col width="70" />
								<col width="80" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th CL="STD_WORUSR"></th>
									<th CL="STD_BOX"></th>
									<th CL="STD_EA"></th>
									<th CL="STD_TOTEA"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="90" />
								<col width="70" />
								<col width="70" />
								<col width="80" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="icon,DELMAK" GB="n"></td>
									<td GCol="text,CREUNM"></td>
									<td GCol="text,BOXQTY" GF="N 10"></td>
									<td GCol="text,EAQTY"  GF="N 10"></td>
									<td GCol="text,QTSPHY" GF="N 10"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">조사완료</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>