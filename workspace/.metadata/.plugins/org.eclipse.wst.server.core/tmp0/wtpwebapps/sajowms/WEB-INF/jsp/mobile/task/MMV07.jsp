<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var isSave = false;

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
			id : "SKUKEY1",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			buttonShow : false,
			grid : [
						{"width":70,  "label":"STD_GUBUN", "type":"text","col":"LT04NM"},
						{"width":90,  "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"},
					],
			module : "Mobile",
			command : "SKUINF"
			
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SKUKEY2",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "주문 취소 이동 상품 목록 조회",
			inputType : "scanNumber",
			buttonShow : true,
			grid : [
						{"width":90,  "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"},
						{"width":70,  "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":100, "label":"STD_SKUCNM","type":"text","col":"SKUCNM"}
					],
			module : "WmsTask",
			command : "MV03Sub"
			
		});
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		$("#SKUKEY").parent().css("width","calc(100% - 10px)");
		
		mobileCommon.select("","scanArea","SKUKEY");
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
		mobileCommon.initBindArea("scanArea",["DESC01"]);
		gridList.resetGrid("gridList");
		
		var param = dataBind.paramData("scanArea");
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
		
		var json = netUtil.sendData({
			url : "/mobile/json/getSkuInf.data",
			param : param
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
				
				mobileCommon.select("","scanArea","SKUKEY");
				
				searchData();
			}else{
				mobileSearchHelp.selectSearchHelp("SKUKEY1");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("MENUID","MMV07");
			
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
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		if(layerId == "SKUKEY1_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			param.put("SKUKEY",skukey);
			
			return param;
		}else if(layerId == "SKUKEY2_LAYER"){
			param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("MENUID","MMV07");
			
			var rqshpd = param.get("RQSHPD");
			if(isNull(rqshpd)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>배송일</span>을 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","RQSHPD");
					}
				});
				return false;
			}else{
				return param;
			}
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "SKUKEY1_LAYER"){
			searchData();
		}else if(layerId == "SKUKEY2_LAYER"){
			searchData();
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			var desc01 = gridList.getColData(gridId,0,"DESC01");
			
			var data = new DataMap();
			data.put("DESC01",desc01);
			
			dataBind.dataBind(data,"scanArea");
			dataBind.dataNameBind(data,"scanArea");
			
			setTimeout(function(){
				mobileCommon.select("","scanArea","SKUKEY");
			});
		}else if(gridId == "gridList" && dataLength == 0){
			mobileCommon.initBindArea("scanArea",["SKUKEY","DESC01"]);
			gridList.resetGrid(gridId);
			
			if(!isSave){
				fail.play();
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
			}else{
				isSave = false;
			}
			
			setTimeout(function(){
				mobileCommon.select("","scanArea","SKUKEY");
			});
		}
		
		if(gridId == "SKUKEY2_LIST" && dataLength == 0){
			fail.play();
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileSearchHelp.searchHelpCloseEvent("SKUKEY2");
				}
			});
		}
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				mobileCommon.initBindArea("scanArea",["SKUKEY","DESC01"]);
				gridList.resetGrid("gridList");
				
				mobileCommon.focus("","scanArea","SKUKEY");
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
			
			var param = dataBind.paramData("scanArea");
			param.put("list",list);
			param.put("MOBILE","TRUE");
			
			netUtil.send({
				url : "/mobile/json/saveMMV07.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				mobileCommon.toast({
					type : "S",
					message : "이동 완료 하였습니다.",
					execute : function(){
						success.play();
						searchData();
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
				mobileCommon.initBindArea("scanArea",["SKUKEY","DESC01"]);
				gridList.resetGrid("gridList");
				
				isSave = false;
				
				searchShpdgr(commonUtil.replaceAll(value,".",""));
				
				mobileCommon.select("","scanArea","SKUKEY");
			}
		}
	}
	
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				mobileCommon.initBindArea("scanArea",["SKUKEY","DESC01"]);
				gridList.resetGrid("gridList");
				
				isSave = false;
				
				searchShpdgr(value);
				
				mobileCommon.select("","scanArea","SKUKEY");
			}
		}
	}
	
	function changeSelectBox(){
		var param = dataBind.paramData("scanArea");
		var skukey = param.get("SKUKEY");
		if(isNull(skukey)){
			mobileCommon.select("","scanArea","SKUKEY");
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
					<input type="hidden" name="TASOTY" value="331"/>
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
									<option value="" CL="STD_ALL"></option>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY"></th>
							<td style="width: calc(100% - 50px);" >
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
							</td>
							<td style="width: 50px;">
								<button class="innerBtn" id="TASKKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01"></th>
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
								<col width="60" />
								<col width="80" />
								<col width="70" />
								<col width="120" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_SHPDGR"></th>
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
								<col width="50" />
								<col width="60" />
								<col width="80" />
								<col width="70" />
								<col width="120" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="text,SHPDGR"></td>
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