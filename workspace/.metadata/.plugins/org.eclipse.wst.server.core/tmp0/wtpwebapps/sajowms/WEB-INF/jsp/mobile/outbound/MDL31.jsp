<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<style>
.scanTable{width: 100%;margin-top: 3px;box-sizing: border-box;}
.scanTable th{text-align: center !important;border: 1px solid #A9A9A9;background: #666;color: #fff;padding: 2px 0 2px 0;font-size: 95%;}
.scanTable td{border: 1px solid #A9A9A9;height: 30px !important;color: #000;font-size: 95%;font-weight: 600;text-align: left;padding-left: 10px;}

.scanTextArea{width: 100%;height: 100%;}
.scanTextArea p{padding-top: 15px;width: 20%;float: left;text-align: center;}
.scanTextArea .title{padding-top: 15px;font-weight: bold;width: 50%;float: left;}
.scanTextArea .dash{width: 10%;}

.n{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.w{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn26.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}

.chk{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn20.png) no-repeat 3px 3px; background-size:18px; background-position: center; text-indent:-500em;}
.nck{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn17.png) no-repeat 3px 3px; background-size:18px; background-position: center; text-indent:-500em;}

.not{color: red !important;}
.notBg td{background-color: #666 !important;}
</style>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_head = [];
	var g_count = 0;
	var g_totcount = 0;

	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "MDL31",
			emptyMsgType : false,
			gridMobileType : true,
			firstRowFocusType : false,
			colorType : true
		});
		
		mobileDatePicker.setDatePicker({
			id : "RQSHPD",
			name : "RQSHPD",
			bindId : "scanArea"
		});
		
		scanInput.setScanInput({
			id : "SCANKY",
			name : "SCANKY",
			bindId : "scanArea",
			type:"number"
		});
		
		scanInput.setScanInput({
			id : "BOXSCN",
			name : "BOXSCN",
			bindId : "inputArea",
			type:"number"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "TRSLST",
			title : "대체리스트",
			buttonShow : false,
			grid : [
						{"width":50,  "label":"수취인",  "type":"text", "col":"SUSRNM"},
						{"width":90,  "label":"상품코드", "type":"text", "col":"SKUKEY"},
						{"width":120, "label":"상품명",  "type":"text", "col":"DESC01"},
						{"width":70,  "label":"수량",   "type":"text", "col":"QTSHPO", "GF":"N 10"},
						{"width":70,  "label":"박스유형", "type":"text", "col":"BOXTYP"}
					],
			module : "Mobile",
			command : "MDL31_SUB"
		});
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		$(".scan_area").css("padding-top",7);
		
		mobileCommon.select("","scanArea","SCANKY");
		
		$("#scanArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
	});
	
	function day(day,isSpot){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 
		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		var returnData = String(yyyy) + String(mm) + String(dd);
		if(isSpot){
			returnData = String(yyyy) + "." +String(mm) +  "."  + String(dd);
		}
		
		return returnData;
	}
	
	function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
		$("#SHPDGR").val("");
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			initTypeArea();
			gridList.resetGrid("gridList");
			
			var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
				param.put("SES_ENV", "<%=usradm%>");
			var rqshpd = param.get("RQSHPD");
			if(isNull(rqshpd)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>배송일</span>을  입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","RQSHPD");
					}
				});
				return;
			}
			
			var shpdgr = param.get("SHPDGR");
			if(isNull(shpdgr)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>배송차수</span>를 선택해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SHPDGR");
					}
				});
				return;
			}
			
			var scanky = param.get("SCANKY");
			if(isNull(scanky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>박스ID</span> 또는  <span class='msgColorBlack'>출하라벨</span>을 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				return;
			}
			
			initTypeArea();
			g_head = [];
			gridList.resetGrid("gridList");
			
			netUtil.send({
				module : "Mobile",
				command : "MDL31_VEHINO",
				param : param,	
				sendType : "list",
				successFunction : "searchHeadCallBack"
			});
		}
	}
	
	function searchHeadCallBack(json,status){
		if(json && json.data){
			var data = json.data;
			var dataLen = data.length;
			if(dataLen > 0){
				var row = data[0];
				var vehino = row["VEHINO"];
				
				var mapData = new DataMap(row);
				var rowData = mapData.putObject(row);
				g_head.push(mapData);
				
				typeAreaMapping("VEHINO",vehino);
				
				var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
				param.put("VEHINO",vehino);
				
				dataBind.dataBind(param, "scanArea");
				dataBind.dataNameBind(param, "scanArea");
				
				searchGridData(param);
			}else{
				fail.play();
				
				mobileCommon.alert({
					message : "해당 차량에 지시된 작업이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}
		}
	}
	
	function searchGridData(param){
		var chkData = netUtil.sendData({
			module : "Mobile",
			command : "MDL31_VALID",
			param : param,	
			sendType : "list"
		});
		
		if(chkData && chkData.data){
			var chk      = chkData.data[0];
			var cnlCofm  = chk["CNL_COFM"];
			var pkCofm   = chk["PK_COFM"];
			var simCofm  = chk["SIM_COFM"];
			var repCofm  = chk["REPORD_NOT"];
			var labCofm  = chk["LABEL_NOT"];
			
			if(cnlCofm == "Y"){
				fail.play();
				
				mobileCommon.alert({
					message : "주문취소확정을 완료한 후, 상차검수를 진행해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				return;
			}else if(pkCofm == "Y"){
				fail.play();
				
				mobileCommon.alert({
					message : "피킹이 완료되지 않았습니다.\n피킹완료 후, 상차검수를 진행해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				return;
			}else if(simCofm == "Y"){
				fail.play();
				
				mobileCommon.alert({
					message : "결품 처리가 안된 주문이 남아있습니다.\n잠시후 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				return;
			}else if(repCofm == "Y"){
				fail.play();
				
				mobileCommon.alert({
					message : "대체 주문이 아직 미생성 되었습니다.\n잠시후 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				return;
			}else if(labCofm == "Y"){
				fail.play();
				
				mobileCommon.alert({
					message : "대체 주문에 대한 라벨이 아직 미생성 되었습니다.\n잠시후 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				return;
			}
		}
		
		var infoData = netUtil.sendData({
			module : "Mobile",
			command : "MDL31_INFO",
			param : param,	
			sendType : "list"
		});
		
		if(infoData && infoData.data){
			var info = infoData.data;
			var infoLen = info.length;
			if(infoLen > 0){
				var infoRow = info[0];
				
				typeAreaMapping("DRYBOX",infoRow["DRYBOX"]);
				typeAreaMapping("WETBOX",infoRow["WETBOX"]);
				typeAreaMapping("BYPASSBOX",infoRow["BYPASSBOX"]);
				
				var repmak = infoRow["REPMAK"];
				typeAreaMapping("REPMAK",repmak);
				
				if(repmak == "Y"){
					$("#REPMAK").addClass("chk");/* not */
					$("#REPMAK").attr("onclick","mobileSearchHelp.selectSearchHelp('TRSLST')");
				}else{
					$("#REPMAK").removeClass("chk");
					$("#REPMAK").addClass("nck");
					$("#REPMAK").removeAttr("onclick");
				}
			}else{
				typeAreaMapping("DRYBOX","");
				typeAreaMapping("WETBOX","");
				typeAreaMapping("BYPASSBOX","");
				typeAreaMapping("REPMAK","");
				
				$("#REPMAK").removeClass("chk");
				$("#REPMAK").removeClass("nck");
				$("#REPMAK").removeAttr("onclick");
			}
		}
		
		gridList.gridList({
			id : "gridList",
			param : param
		});
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		this.g_count = 0;
		this.g_totcount = 0;
		
		if(gridId == "gridList" && dataLength > 0){
			var rowNumList = gridList.getRowNumList(gridId);
			for(var i = 0; i < dataLength; i++){
				var rowNum = rowNumList[i];
				var cnlMak = gridList.getColData(gridId,rowNum,"CNLMAK");
				if(cnlMak == "V"){
					$("#"+gridId+" tr:eq("+rowNum+") td[gcolname=BXTL01]").find("input").remove();
				}else{
					var bxtl01 = gridList.getColData(gridId,rowNum,"BXTL01");
					if(bxtl01 == "V"){
						g_count++;
					}
					g_totcount++;
				}
			}
			
			$("#count").html(g_count);
			$("#totCount").html(g_totcount);
			
			mobileCommon.select("","inputArea","BOXSCN");
		}else if(gridId == "gridList" && dataLength == 0){
			fail.play();
			
			initTypeArea();
			g_head = [];
			gridList.resetGrid(gridId);
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.select("","scanArea","SCANKY");
				}
			});
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		if(layerId == "TRSLST_LAYER"){
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			return param;
		}
	}
	
	function initTypeArea(){
		mobileCommon.initBindArea("scanArea", ["VEHINO"]);
		
		$("#typeArea tr td").each(function(){
			var $obj = $(this);
			if($obj.attr("id") != undefined){
				$obj.html("");
			}else{
				$obj.children().removeClass("chk");
				$obj.children().removeClass("nck");
			}
		});
		g_count = 0;
		g_totcount = 0;
		
		$("#count").html(0);
		$("#totCount").html(0);
	}
	
	function typeAreaMapping(colName,value){
		var $obj = $("#typeArea tr td[id="+colName+"]");
		if($obj.length > 0){
			$obj.html(value);
		}
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				g_head = [];
				
				initTypeArea();
				
				$("[name=BOXSCN]").val("");
				
				mobileCommon.initBindArea("scanArea",["SCANKY"]);
				
				gridList.resetGrid("gridList");
				
				mobileCommon.focus("","scanArea","SCANKY");
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
	
	function reSearchData(){
		initTypeArea();
		gridList.resetGrid("gridList");
		
		var param = g_head[0];
		if(param.isEmpty()){
			fail.play();
			
			mobileCommon.alert({
				message : "필수 검색 조건이 없습니다.\n검색 조건 입력 후, 재 조회 해주세요."
			});
			
			return;
		}
		
		var vehino = param.get("VEHINO");
		typeAreaMapping("VEHINO", vehino);
		
		dataBind.dataNameBind(param,"scanArea");
		
		searchGridData(param);
	}
	
	function tempData(){
		var list = gridList.getModifyData("gridList","A");
		if(list.length == 0){
			mobileCommon.toast({
				type : "W",
				message : "변경된 내역이 없습니다.",
				execute : function(){
					fail.play();
					mobileCommon.select("","inputArea","BOXSCN");
				}
			});
			return;
		}
		
		var param = new DataMap();
		param.put("list",list);
		
		netUtil.send({
			url : "/mobile/json/SaveMDL31TempData.data",
			param : param,
			successFunction : "succsessTempCallBack"
		});
	}
	
	function succsessTempCallBack(json,status){
		if(json && json.data){
			if(json.data > 0){
				mobileCommon.toast({
					type : "S",
					message : "저장 되었습니다.",
					execute : function(){
						success.play();
						reSearchData();
						mobileCommon.select("","inputArea","BOXSCN");
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "저장 실패 하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","inputArea","BOXSCN");
					}
				});
			}
		}
	}
	
	function saveData(){
		var list    = gridList.getGridData("gridList",true);
		var listLen = list.length;
		if(listLen > 0){
			if(g_head.length == 0){
				fail.play();
				
				mobileCommon.alert({
					message : "데이터가 변경되었습니다.\n재조회 후, 다시 진행 해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}
			
			if(g_totcount > g_count){
				fail.play();
				
				mobileCommon.alert({
					message : "검수하지 않은 <span class='msgColorBlack'>박스ID</span> 또는  <span class='msgColorBlack'>출하라벨</span>이 있습니다.\n모두 검수 후에, 진행 해주세요.",
					confirm : function(){
						mobileCommon.select("","inputArea","BOXSCN");
					}
				});
				
				return;
			}
			
			var param = new DataMap();
			param.put("head",g_head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/outbound/json/saveDL31.data",
				param : param,
				successFunction : "succsessSaveCallBack",
				failFunction : "failSaveCallBack"
			});
		}else{
			fail.play();
			
			mobileCommon.alert({
				message : "조회된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.select("","scanArea","SCANKY");
				}
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if(json.data == "OK"){
				mobileCommon.toast({
					type : "S",
					message : "출하 완료 하였습니다.",
					execute : function(){
						success.play();
						
						var paramData = dataBind.paramData("scanArea");
						var rqshpd = paramData.get("RQSHPD");
						var shpdgr = paramData.get("SHPDGR");
						
						//$("#RQSHPD").val(day(0,true));
						searchShpdgr(rqshpd);
						$("#SHPDGR").val(shpdgr);
						
						g_head = [];
						initTypeArea();
						mobileCommon.initBindArea("scanArea",["SCANKY"]);
						gridList.resetGrid("gridList");
						
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "출하 완료 실패 하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","inputArea","BOXSCN");
					}
				});
			}
		}
	}
	
	function failSaveCallBack(a, b, c){
		fail.play();
		
		var errTxt = a.responseText;
			errTxt = commonUtil.replaceAll(errTxt, "\r\n", "");
			errTxt = commonUtil.replaceAll(errTxt, "\\n", "\n");
		if(errTxt.indexOf("user error") != -1){
			errTxt = errTxt.substring(errTxt.lastIndexOf("@") + 1);
		}
		
		mobileCommon.alert({
			message : errTxt + "\n( *처리한 내역은 임시 저장 됩니다. )",
			confirm : function(){
				var list = gridList.getModifyData("gridList","A");
				if(list.length > 0){
					var param = new DataMap();
					param.put("list",list);
					
					netUtil.send({
						url : "/mobile/json/SaveMDL31TempData.data",
						param : param,
						successFunction : "returnFailCallBack"
					});
				}
			}
		});
	}
	
	function returnFailCallBack(json){
		if(json && json.data){
			if(json.data > 0){
				reSearchData();
				mobileCommon.select("","inputArea","BOXSCN");
			}
		}
	}
	
	function gridScanBoxCodeCheck(){
		var data = dataBind.paramData("inputArea");
		
		var boxscn = data.get("BOXSCN");
		if(isNull(boxscn)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>박스ID</span> 또는  <span class='msgColorBlack'>출하라벨</span>을 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","SCANKY");
				}
			});
			return;
		}
		
		var list = gridList.getGridData("gridList",true);
		var checkList = list.filter(function(element,index,array){
			return (($.trim(element.get("SBOXID")) == boxscn) || ($.trim(element.get("BOXLAB")) == boxscn));
		});
			
		if(checkList.length > 0){
			var row    = checkList[0];
			var rowNum = row.get("GRowNum");
			var cnlMak = row.get("CNLMAK");
			var bxtl01 = row.get("BXTL01");
			if(cnlMak == "V"){
				fail.play();
				
				mobileCommon.alert({
					message : "취소된 주문 입니다.",
					confirm : function(){
						mobileCommon.select("","inputArea","BOXSCN");
					}
				});
				return;
			}else{
			
				var $gridWrap = $("#gridList").parents(".tableBody");
				
				var $obj      = $("#gridList tr:eq("+rowNum+")");
				var $checkBox = $obj.find("td[gColName=BXTL01]").children();
				var $icon     = $obj.find("td[gColName=CNLMAK]");
				
				if(bxtl01 != "V"){
					$icon.attr("gf","y");
					
					var $iconObj = $icon.children().children();
					var iconObjClass = $iconObj.attr("class");
					
					$iconObj.removeClass(iconObjClass);
					$iconObj.addClass("y");
					
					
					gridList.setColValue("gridList",rowNum,"BXTL01","V");
					
					g_count++;
					
					success.play();
					
					$("#count").html(g_count);
				}else{
					mobileCommon.toast({
						type : "W",
						message : "검수 체크한 <span class='msgColorRed'>박스ID</span> 또는  <span class='msgColorRed'>출하라벨</span>입니다.",
						execute : function(){
							fail.play();
							mobileCommon.focus("","inputArea","BOXSCN");
						}
					});
				}
				
				setTimeout(function(){
					var offsetTop = $obj[0].offsetTop;
					$gridWrap.scrollTop(offsetTop);
					gridList.setRowFocus("gridList", rowNum, true);
					mobileCommon.focus("","inputArea","BOXSCN");
				});
			}
		}else{
			mobileCommon.toast({
				type : "F",
				message : "지시된 <span class='msgColorRed'>박스ID</span> 또는  <span class='msgColorRed'>출하라벨</span>이 아닙니다.",
				execute : function(){
					fail.play();
					mobileCommon.focus("","inputArea","BOXSCN");
				}
			});
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList") {
			if(colName == "BXTL01"){
				var $obj  = $("#gridList tr:eq("+rowNum+")");
				var $icon = $obj.find("td[gColName=CNLMAK]");
				var value = "n";
				
				if(colValue == "V"){
					value = "y";
					g_count++;
				}else{
					value = "n";
					g_count--;
				}
				
				$icon.attr("gf",value);
				
				var $iconObj = $icon.children().children();
				var iconObjClass = $iconObj.attr("class");
				
				$iconObj.removeClass(iconObjClass);
				$iconObj.addClass(value);
				
				$("#count").html(g_count);
				
				setTimeout(function(){
					mobileCommon.focus("","inputArea","BOXSCN");
				});
			}
		}
	}
	
	function closeKeyPadAfterEvent(areaId,inputName,value,$obj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				initTypeArea();
				
				mobileCommon.initBindArea("scanArea",["SCANKY"]);
				
				gridList.resetGrid("gridList");
				
				searchShpdgr(commonUtil.replaceAll(value,".",""));
				mobileCommon.select("","scanArea","SCANKY");
			}
		}
	}
	
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				initTypeArea();
				
				mobileCommon.initBindArea("scanArea",["SCANKY"]);
				
				gridList.resetGrid("gridList");
				
				searchShpdgr(value);
				mobileCommon.select("","scanArea","SCANKY");
			}
		}
	}
	
	function changeSelectBox(){
		var param = dataBind.paramData("scanArea");
		var scanky = param.get("SCANKY");
		if(isNull(scanky)){
			mobileCommon.select("","scanArea","SCANKY");
		}else{
			searchData();
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "CNLMAK"){
				if(colValue == "V"){
					return "d";
				}else if($.trim(colValue) == ""){
					var bxtl01 = gridList.getColData(gridId, rowNum, "BXTL01");
					if(bxtl01 == "V"){
						return "y";
					}else{
						return "n";
					}
				}
			}
		}
	}
	
	function gridListRowBgColorChange(gridId, rowNum, removeType){
		if(gridId == "gridList"){
			var colValue = gridList.getColData(gridId, rowNum, "CNLMAK");
			if(colValue == "V"){
				return "notBg";
			}
		}
	}
	
	function gridListRowTextColorChange(gridId, rowNum, removeType){
		if(gridId == "gridList"){
			var colValue = gridList.getColData(gridId, rowNum, "CNLMAK");
			if(colValue == "V"){
				return "not";
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
			<div class="scan_area" style="padding-top: 9px;">
				<table id="scanArea">
					<input type="hidden" name="VEHINO"/>
					<colgroup>
						<col width="90"/>
						<col width="135"/>
						<col width="50"/>
						<col width="50"/>
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_RQSPDGR"></th>
							<td>
								<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="D N" validate="required(STD_RQSHPD)"/>
							</td>
							<td colspan="2">
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false onchange="changeSelectBox();">
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_SCANKY"></th>
							<td colspan="2">
								<input type="text" name="SCANKY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td>
								<button class="innerBtn" id="TASKKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
					</tbody>
				</table>
				<table class="scanTable">
					<colgroup>
						<col width="60"/>
						<col />
						<col width="60"/>
						<col />
					</colgroup>
					<tbody id="typeArea">
						<tr>
							<th CL="STD_VEHINO"></th>
							<td colspan="3" id="VEHINO"></td>
						</tr>
						<tr>
							<th CL="STD_DRYBOX"></th>
							<td id="DRYBOX"></td>
							<th CL="STD_WETBOX"></th>
							<td id="WETBOX"></td>
						</tr>
						<tr>
							<th CL="STD_BYPASSBOX"></th>
							<td id="BYPASSBOX"></td>
							<th CL="STD_REPMAK"></th>
							<td style="padding-left: 0;">
								<div id="REPMAK" style="width: 100%;"></div>
							</td>
						</tr>
					</tbody>
				</table>
				<table id="inputArea" style="margin-top: 10px;">
					<colgroup>
						<col width="80"/>
						<col width="140"/>
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_BOXSCN"></th>
							<td>
								<input type="text" name="BOXSCN" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'gridScanBoxCodeCheck()')"/>
							</td>
							<td style="font-size: 15px;">
								<div class="scanTextArea">
									<p class="title">Scan : </p>
									<p id="count">0</p>
									<p class="dash">/</p>
									<p id="totCount">0</p>
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
								<col width="30" />
								<col width="30" />
								<col width="50" />
								<col width="60" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_SHMSTS"></th>
									<th CL="STD_SCANCHK"></th>
									<th CL="STD_DRVSEQ"></th>
									<th CL="STD_SUSRNM">수취인</th>
									<th CL="STD_BOXTYP"></th>
									<th CL="STD_SBOXID2"></th>
									<th CL="STD_BOXLAB"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="30" />
								<col width="30" />
								<col width="50" />
								<col width="60" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="icon,CNLMAK" GB="n"></td>
									<td GCol="check,BXTL01"></td>
									<td GCol="text,SHPDSQ"></td>
									<td GCol="text,SUSRNM"></td>
									<td GCol="text,BOXTYP"></td>
									<td GCol="text,SBOXID"></td>
									<td GCol="text,BOXLAB"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="l btnBgG" onclick="tempData();" style="width: 30%;">임시저장</button>
						<button class="l" onclick="saveData();" style="width: 40%;">출하완료</button>
						<button class="l btnBgW" onclick="initPage();" style="width: 30%;">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>