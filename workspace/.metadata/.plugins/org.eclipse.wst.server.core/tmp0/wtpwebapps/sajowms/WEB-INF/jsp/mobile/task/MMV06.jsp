<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_head = [];
	var isSave = false;
	var searchType = 0;

	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsTask",
			command : "MV03Sub",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		mobileDatePicker.setDatePicker({
			id : "RQSHPD",
			name : "RQSHPD",
			bindId : "scanArea"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SCANKY",
			name : "SCANKY",
			bindId : "scanArea",
			title : "배송차수를 선택해 주세요.",
			inputType : "scanNumber",
			buttonShow : false,
			grid : [
						{"width":80, "label":"STD_RQSHPD", "type":"text", "col":"RQSHPD", "GF":"D"},
						{"width":90, "label":"STD_DRVDGR", "type":"text", "col":"SHPDGR"},
						{"width":80, "label":"STD_SBOXID", "type":"text", "col":"SBOXID"},
						{"width":80, "label":"STD_BOXLAB", "type":"text", "col":"BOXLAB"},
					],
			module : "WmsTask",
			command : "MV03"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SKUKEY",
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
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		$("#SCANKY").parent().css("width","calc(100% - 10px)");
		
		mobileCommon.select("","scanArea","SCANKY");
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
	
	function getSkuInfData(){
		var param = dataBind.paramData("scanArea");
		var rqshpd = param.get("RQSHPD");
		if(isNull(rqshpd)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>배송일</span>을 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","RQSHPD");
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
		
		var skukey = param.get("SKUKEY");
		if(isNull(skukey)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","SKUKEY");
				}
			});
			return;
		}
		
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
				
				mobileCommon.select("","scanArea","SKUKEY");
				
				innerSearchData();
			}else{
				mobileSearchHelp.selectSearchHelp("SKUKEY");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			searchType = 0;
			
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("MENUID","MMV06");
			
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
			
			g_head = [];
			gridList.resetGrid("gridList");
			mobileCommon.initBindArea("scanArea", ["SKUKEY"]);
			
			netUtil.send({
				module : "WmsTask",
				command : "MV03",
				param : param,	
				sendType : "list",
				successFunction : "searchHeadCallBack"
			});
		}
	}
	
	function searchHeadCallBack(json, status){
		if(json && json.data){
			var data = json.data;
			var dataLen = data.length;
			if(dataLen > 0){
				if(dataLen == 1){
					var head = new DataMap(data[0]);
					g_head.push(head);
					
					var srchData = dataBind.paramData("scanArea");
					var param = new DataMap();
					param.put("TASOTY",srchData.get("TASOTY"));
					param.put("WAREKY",head.get("WAREKY"));
					param.put("GRPOKY",head.get("GRPOKY"));
					param.put("SBOXID",head.get("SBOXID"));
					param.put("BOXLAB",head.get("BOXLAB"));
					param.put("BOXTYP",head.get("BOXTYP"));
					
					gridList.gridList({
						id : "gridList",
						param : param
					});
				}else{
					mobileSearchHelp.selectSearchHelp("SCANKY");
				}
			}else{
				g_head = [];
				
				fail.play();
				
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
				gridList.resetGrid("gridList");
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}
		}
	}
	
	function innerSearchData(){
		searchType = 1;
		
		var head = g_head[0];
		
		var param = dataBind.paramData("scanArea");
		param.put("WAREKY",head.get("WAREKY"));
		param.put("GRPOKY",head.get("GRPOKY"));
		param.put("SBOXID",head.get("SBOXID"));
		param.put("BOXLAB",head.get("BOXLAB"));
		param.put("BOXTYP",head.get("BOXTYP"));
		
		gridList.gridList({
			id : "gridList",
			param : param
		});
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		if(layerId == "SKUKEY_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			param.put("SKUKEY",skukey);
			
			return param;
		}else if(layerId == "SCANKY_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var tasoty = data.get("TASOTY");
			var rqshpd = data.get("RQSHPD");
			var shpdgr = data.get("SHPDGR");
			var scanky = data.get("SCANKY");
			
			param.put("TASOTY",tasoty);
			param.put("MENUID","MMV06");
			param.put("RQSHPD",rqshpd);
			param.put("SHPDGR",shpdgr);
			param.put("SCANKY",scanky);
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "SKUKEY_LAYER"){
			innerSearchData();
		}else if(layerId == "SCANKY_LAYER"){
			if(!data.isEmpty()){
				$("#SHPDGR").val(data.get("SHPDGR"));
				
				searchData();
				
				mobileCommon.select("","scanArea","SKUKEY");
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			if(isSave){
				mobileCommon.focus("","scanArea","SKUKEY");
			}else{
				if(searchType == 0){
					mobileCommon.focus("","scanArea","SKUKEY");
				}else{
					mobileCommon.select("","scanArea","SKUKEY");
				}
			}
		}else if(gridId == "gridList" && dataLength == 0){
			mobileCommon.initBindArea("scanArea",["SKUKEY"]);
			gridList.resetGrid(gridId);
			if(isSave){
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
				gridList.resetGrid("gridList");
				
				mobileCommon.alert({
					message : "해당 박스에 대한 작업이 모두 완료 되었습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				
				isSave = false;
				searchType = 0;
			}else{
				fail.play();
				
				if(searchType == 0){
					$("#RQSHPD").val(day(0,true));
					searchShpdgr(day(0,false));
					
					mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
					gridList.resetGrid("gridList");
					
					mobileCommon.focus("","scanArea","SCANKY");
					
					mobileCommon.alert({
						message : "검색된 데이터가 없습니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","SCANKY");
						}
					});
				}else{
					mobileCommon.alert({
						message : "조회된 상품이 없습니다.",
						confirm : function(){
							innerSearchData();
							mobileCommon.select("","scanArea","SKUKEY");
						}
					});
					
					searchType = 0;
				}
			}
		}
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
				gridList.resetGrid("gridList");
				
				mobileCommon.focus("","scanArea","SCANKY");
				
				searchType = 0;
				isSave = false;
			}
		});
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridList",true);
			if(list.length == 0){
				fail.play();
				
				mobileCommon.alert({
					message : "선택된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				return;
			}
			
			var locList = list.filter(function(element,index,array){
				return $.trim(element.get("LOCATG")) == "";
			});
			
			if(locList.length > 0){
				fail.play();
				
				mobileCommon.alert({
					message : "To 로케이션은 필수 항목입니다.",
					confirm : function(){
						var rowNum = locList[0].get("GRowNum");
						gridList.setColFocus("gridList",rowNum,"LOCATG");
					}
				});
				
				return;
			}
			
			isSave = true;
			
			var srchData = dataBind.paramData("scanArea");
			
			var param = new DataMap();
			param.put("head",g_head);
			param.put("item",list);
			param.put("TASOTY",srchData.get("TASOTY"));
			param.put("MOBILE","TRUE");
			
			netUtil.send({
				url : "/wms/task/json/SaveMV03.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data > 0){
				mobileCommon.toast({
					type : "S",
					message : "이동 완료 하였습니다.",
					execute : function(){
						success.play();
						
						mobileCommon.initBindArea("scanArea",["SKUKEY"]);
						
						innerSearchData();
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "이동에 실패 하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","scanArea","SKUKEY");
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
	
	function closeKeyPadAfterEvent(areaId,inputName,value,$obj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
				gridList.resetGrid("gridList");
				
				searchType = 0;
				isSave = false;
				
				searchShpdgr(commonUtil.replaceAll(value,".",""));
				mobileCommon.select("","scanArea","SCANKY");
			}
		}
	}
	
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				mobileCommon.initBindArea("scanArea",["SCANKY","SKUKEY"]);
				gridList.resetGrid("gridList");
				
				searchType = 0;
				isSave = false;
				
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
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "Common,COMCOMBO" ){
			var selectName = paramName[0].name;
			if(selectName == "LOTA06"){
				param.put("USARG1", "V");
				param.put("CODE", "LOTA06");
			}
			
			return param;
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "LOTA06"){
				var beforeLota06 = "";
				if(colValue == "00"){
					beforeLota06 = "10";
				}else if(colValue == "10"){
					beforeLota06 = "00";
				}
				
				var lt06nm = $("#gridList tr:eq("+rowNum+") td[gcolname="+colName+"] select option[value="+colValue+"]").text();
				var beforeLocatg = gridList.getColData(gridId, rowNum, "LOCATG");
				
				var param = gridList.getRowData(gridId, rowNum);
				param.put("LOTA06",colValue);
				
				var json = netUtil.sendData({
					module : "Mobile",
					command : "MMV07_LOCAKY",
					sendType : "map",
					param : param
				});
				
				if(json && json.data){
					var locaky = json.data["LOCAKY"];
					if(isNull(locaky)){
						fail.play();
						
						mobileCommon.alert({
							message : "[ <span class='msgColorBlack'>" + lt06nm +"</span> ] 으로 등록된 피킹로케이션이 없습니다.",
							confirm : function(){
								gridList.setColValue(gridId, rowNum, colName, beforeLota06);
								gridList.setColValue(gridId, rowNum, "LOCATG", beforeLocatg);
							}
						});
					}else{
						gridList.setColValue(gridId, rowNum, "LOCATG", locaky);
					}
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
			<div class="scan_area" style="padding-top: 9px;">
				<table id="scanArea">
					<input type="hidden" name="TASOTY" value="330"/>
					<colgroup>
						<col width="90" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_RQSHPD"></th>
							<td colspan="2">
								<input type="text" name="RQSHPD" id="RQSHPD"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DRVDGR"></th>
							<td colspan="2">
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false onchange="changeSelectBox();">
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th>박스SCAN</th>
							<td>
								<input type="text" name="SCANKY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td style="width: 50px;">
								<button class="innerBtn" id="TASKKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY"></th>
							<td colspan="2">
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
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
								<col width="150" />
								<col width="60" />
								<col width="80" />
								<col width="70" />
								<col width="120" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_MMVQTY"></th>
									<th CL="STD_TOLOCA"></th>
									<th CL="STD_LOTA06"></th>
									<th CL="STD_SKUCNM"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="90" />
								<col width="150" />
								<col width="60" />
								<col width="80" />
								<col width="70" />
								<col width="120" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01"></td>
									<td GCol="text,QTTAOR" GF="N 10"></td>
									<td GCol="text,LOCATG"></td>
									<td GCol="select,LOTA06">
										<select name="LOTA06" Combo="Common,COMCOMBO" ComboCodeView=false></select>
									</td>
									<td GCol="text,SKUCNM"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">이동완료</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>