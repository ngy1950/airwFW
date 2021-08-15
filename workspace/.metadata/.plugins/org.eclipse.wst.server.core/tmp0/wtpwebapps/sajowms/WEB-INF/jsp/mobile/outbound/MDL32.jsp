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

.n{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.w{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn26.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
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
			module : "WmsOutbound",
			command : "DL31",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		mobileDatePicker.setDatePicker({
			id : "RQSHPD",
			name : "RQSHPD",
			bindId : "scanArea"
		});
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		mobileCommon.select("","scanArea","CARCNT");
		
		
		//배송일 변경시, 차수 조회
		$("#scanArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
		});
		
		//차수, 회전, 도크 변경시 차량조회
		$("#scanArea [name=SHPDGR]").on("change",function(){
			$('#CARCNT').val("");
			$('#DOCKNO').val("");
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$(this).val());
		});
		
		$("#scanArea [name=CARCNT]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$('#SHPDGR').val());
		});
		
		$("#scanArea [name=DOCKNO]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$('#SHPDGR').val());
		});
		
		//차량 변경 시, 그리드 조회
		$("#scanArea [name=VEHINO]").on("change",function(){
			if(!isNull( $(this).val() )){
				searchData();
			}
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
		if(isNull(val)) {
			return;
		}
		
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		param.put("RQSHPD",val);
			
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
		$("#SHPDGR option:last").attr("selected", "true");
		searchvehino($('#RQSHPD').val().replace(/\./g,''),$("#SHPDGR").val());
	}
	
	function searchvehino(val1,val2){
		if(isNull(val1) || isNull(val2)){
			$("#VEHINO").find("[UIOption]").remove();
			return;
		}
		
		var carcnt, dockno;
		
		if($("#CARCNT").val() == "0" ) { carcnt = "";} else {carcnt = $("#CARCNT").val();}
		if($("#DOCKNO").val() == "0" ) { dockno = "";} else {dockno = $("#DOCKNO").val();}
		
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		param.put("RQSHPD", val1);
		param.put("SHPDGR", val2);
		param.put("CARCNT", carcnt);
		param.put("DOCKNO", dockno);
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "VEHINO_S_DL11",
			sendType : "list",
			param : param
		});
		
		$("#VEHINO").find("[UIOption]").remove();
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#VEHINO").append(optionHtml);
		$('#VEHINO').val("");
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			initTypeArea();
			gridList.resetGrid("gridList");
			
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("MENUID","MDL32");
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
		}else if(gridId == "gridList" && dataLength == 0){
			initTypeArea();
			
			gridList.resetGrid(gridId);
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					
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
				gridList.resetGrid("gridList");
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
				gridList.resetGrid("gridList");
				searchShpdgr(commonUtil.replaceAll(value,".",""));
			}
		}
	}
	
	function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				initTypeArea();
				gridList.resetGrid("gridList");
				searchShpdgr(value);
			}
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue) {
		if(gridId == "gridList"){
			if(colName == "CNLMAK" || colName == "CNLCFM" || colName == "PICCFM" || colName == "SIMYN" || colName == "FWDCFM") {
				if(colValue == "N"){
					return "n";
				} else {
					if(colName == "SIMYN") {
						return "d";
					} else {
						return "y";
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
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false>
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_CARCNT_DOCKNO"></th>
							<td colspan="3">
								<input type="text" name="CARCNT" id="CARCNT" UIFormat="N" style="width:40%;" maxlength="2"; />
								<span style="display: inline-block;width:17%;">&nbsp;/&nbsp;</span>
								<input type="text" name="DOCKNO" id="DOCKNO" UIFormat="N" style="width:40%;" maxlength="2"; />
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_VEHINO"></th>
							<td colspan="2">
								<select id="VEHINO" name="VEHINO" ComboCodeView=false style="width:100%;">
									<option value="" selected>전 체</option>
								</select>
							</td>
							<td >
								<button class="innerBtn" id="SHLOCKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
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
								<col width="25" />
								<col width="25" />
								<col width="80" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_CARCNT"></th>
									<th CL="STD_DOCKNO"></th>
									<th CL="STD_VEHINO"></th>
									<th CL="STD_CNLMAK"></th>
									<th CL="STD_ALLCNL"></th>
									<th CL="STD_PKJMAK"></th>
									<th CL="STD_SIMPROC"></th>
									<th CL="STD_OUTFSH"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="25" />
								<col width="25" />
								<col width="80" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
								<col width="30" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="text,CARCNT"></td>
									<td GCol="text,DOCKNO"></td>
									<td GCol="text,VEHINO"></td>
									<td GCol="icon,CNLMAK" GB="n"></td>
									<td GCol="icon,CNLCFM" GB="n"></td>
									<td GCol="icon,PICCFM" GB="n"></td>
									<td GCol="icon,SIMYN"  GB="n"></td>
									<td GCol="icon,FWDCFM" GB="n"></td>
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