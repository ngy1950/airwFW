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
</style>
<title><%=documentTitle%></title>
<script type="text/javascript">
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "MRS03",
			emptyMsgType : false,
			gridMobileType : true
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
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
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
	
	function searchData(){
		if(validate.check("scanArea")){
			initTypeArea();
			gridList.resetGrid("gridList");
			
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
			
			gridList.resetGrid("gridList");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			initTypeArea();
			
			var keys = ["SHORTX","BOXTYP","CNLMAK","CNLBOX","SHPSTATUS"];
			for(var i in keys){
				var colName = keys[i];
				var value   = gridList.getColData(gridId,0,colName);
				typeAreaMapping(colName,value);
			}
			mobileCommon.select("","scanArea","SCANKY");
		}else if(gridId == "gridList" && dataLength == 0){
			initTypeArea();
			
			gridList.resetGrid(gridId);
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.select("","scanArea","SCANKY");
				}
			});
		}
	}
	
	function initTypeArea(){
		$("#typeArea tr td").html("");
	}
	
	function typeAreaMapping(colName,value){
		var $obj = $("#typeArea tr td[id="+colName+"]");
		$obj.html(value);
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				$("#RQSHPD").val(day(0,true));
				searchShpdgr(day(0,false));
				
				initTypeArea();
				
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
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Content Area -->
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area" style="padding-top: 9px;">
				<table id="scanArea">
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
								<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="D N" validate="required(STD_RQSHPD)" />
							</td>
							<td colspan="2">
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false onchange="changeSelectBox();">
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr>
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
						<col width="80"/>
						<col width="60">
						<col />
					</colgroup>
					<tbody id="typeArea">
						<tr>
							<th CL="STD_SHPMTY"></th>
							<td id="SHORTX"></td>
							<th CL="STD_BOXTYP"></th>
							<td id="BOXTYP"></td>
						</tr>
						<tr>
							<th CL="STD_CNLMAK"></th>
							<td id="CNLMAK"></td>
							<th CL="STD_CNLBOX"></th>
							<td id="CNLBOX"></td>
						</tr>
						<tr>
							<th CL="STD_STATUS"></th>
							<td colspan="3" id="SHPSTATUS"></td>
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
								<col width="90" />
								<col width="90" />
								<col width="150" />
								<col width="60" />
								<col width="60" />
								<col width="60" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_MMVORD"></th>
									<th CL="STD_QTJCMP2"></th>
									<th CL="STD_QTSHPC2"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="90" />
								<col width="90" />
								<col width="150" />
								<col width="60" />
								<col width="60" />
								<col width="60" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="text,LOCAKY"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01"></td>
									<td GCol="text,QTSHPO" GF="N 20,3"></td>
									<td GCol="text,QTJCMP" GF="N 20,3"></td>
									<td GCol="text,QTSHPC" GF="N 20,3"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid1 btnBgG" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>