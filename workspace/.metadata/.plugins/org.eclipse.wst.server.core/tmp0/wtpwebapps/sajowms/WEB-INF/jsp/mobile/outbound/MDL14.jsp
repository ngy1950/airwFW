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
	var g_count = 0;
	var g_totcount = 0;
	var reparam = new DataMap();
	var savetype = true;

	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsOutbound",
			command : "DL14",
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
			id : "SKUSCN",
			name : "SKUSCN",
			bindId : "inputArea",
			type:"number"
		});
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		$(".scan_area").css("padding-top",7);
		
		mobileCommon.select("","scanArea","SCANKY");
		
// 		$("#scanArea [name=RQSHPD]").on("change",function(){
// 			searchShpdgr($(this).val().replace(/\./g,''));
			
// 		});
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
				param.put("PROGID", 'MDL14');
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
			
			var shit04 = param.get("SHIT04");
			if(isNull(shit04)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>작업구역</span>을 선택해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SHIT04");
					}
				});
				return;
			}
			
			var scanky = param.get("SCANKY");
			
			if($.trim(scanky) != ""){
				netUtil.send({
					module : "WmsOutbound",
					command : "MDL14_TYPE",
					param : param,	
					sendType : "map",
					successFunction : "searchHeadCallBack"
				});
			}else{
				savetype = false;
				reparam.putAll(param);
				
				searchGridData(param);
				
// 				gridList.gridList({
// 					id : "gridList",
// 					param : param
// 				});
			}
		}
	}
	
	function searchHeadCallBack(json,status){
		if(json && json.data){
			var data = json.data;
			if(!isNull(json.data["SHPOKY"])){
				var boxtyp = data["BOXTYP"];
				var shpmty = data["SHPMTY"];
				var shpoky = data["SHPOKY"];
				
// 				$('#SHPMTY').val(shpmty);
// 				$('#boxtyp').val(BOXTYP);
				
				var param = dataBind.paramData("scanArea");
					param.put("WAREKY","<%=wareky%>");
					param.put("PROGID", 'MDL14')
					param.put("SHPOKY",shpoky);
				
				dataBind.dataBind(data, "scanArea");
				dataBind.dataNameBind(data, "scanArea");
				
				savetype = true;
				
				searchGridData(param);
			}else{
				fail.play();
				
				initTypeArea();
				gridList.resetGrid("gridList");
				
				mobileCommon.alert({
					message : "조회된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}
		}
	}
	
	function searchGridData(param){
		
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
				
				var worksts = gridList.getColData(gridId,rowNum,"WORKSTS");
				if(worksts == "V"){
					$("#"+gridId+" tr:eq("+rowNum+") td[gcolname=SCANCHK]").find("input").remove();
						g_count++;
					
				}
				
				g_totcount++;
			}
			
			$("#count").html(g_count);
			$("#totCount").html(g_totcount);
			
			mobileCommon.select("","inputArea","SKUSCN");
		}else if(gridId == "gridList" && dataLength == 0){
			fail.play();
			
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
				
				initTypeArea();
				
				$("[name=SKUSCN]").val("");
				
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
	
	function saveData(){
		
		if(!savetype){
			fail.play();
			
			mobileCommon.alert({
				message : "전체조회 시 저장 기능은 사용 하실 수 없습니다.",
				confirm : function(){
					mobileCommon.select("","scanArea","SCANKY");
				}
			});
			
			return false;
		}
		var Alllist = gridList.getGridData("gridList", true	);		
		var list = Alllist.filter(function(element,index,array){
			return ( ($.trim(element.get("SCANCHK")) == 'V') );
		});
		
		var listLen = list.length;
		if(listLen > 0){
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/outbound/json/saveDL14.data",
				param : param,
				successFunction : "succsessSaveCallBack",
			});
		}else{
			fail.play();
			
			mobileCommon.alert({
				message : "선택된 데이터가 없습니다.",
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
						mobileCommon.select("","inputArea","SKUSCN");
					}
				});
			}
		}
	}
	
	function gridScanSKUCodeCheck(){
		var data = dataBind.paramData("inputArea");
		var SKUSCN = $.trim(data.get("SKUSCN"));
		
		if(isNull(SKUSCN)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>상품코드</span> 를 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","SKUSCN");
				}
			});
			return;
		}
		
		if(!savetype){
			reparam.put("SKUKEY",SKUSCN);
			
			searchGridData(reparam);
		}else{
			
			var list = gridList.getGridData("gridList",true);
			var checkList = list.filter(function(element,index,array){
				return ( (($.trim(element.get("SKUKEY")) == SKUSCN) || ($.trim(element.get("SALESK")) == SKUSCN) || ($.trim(element.get("EANCOD")) == SKUSCN))
						&& ($.trim(element.get("WORKSTS")) == 'N')
				);
			});
			 
			if(checkList.length > 0){
				for(var i=0 ; i< checkList.length ; i++){
					var row    = checkList[i];
					var rowNum = row.get("GRowNum");
					var scanchk = row.get("SCANCHK");
					
					if($.trim(scanchk) != 'V'){
						
						gridList.setColValue("gridList",rowNum,"SCANCHK","V");
						g_count++;
							
					}
				}
				
				success.play();
				
				$("#count").html(g_count);
			}else{
				mobileCommon.toast({
					type : "F",
					message : "지시된 <span class='msgColorRed'>상품코드 검색되지 않습니다. 상품명 으로 확인 하세요.",
					execute : function(){
						fail.play();
						mobileCommon.focus("","inputArea","SKUSCN");
					}
				});
			}
		}
		
		
		setTimeout(function(){
			mobileCommon.focus("","inputArea","SKUSCN");
		});			
			
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList") {
			if(colName == "SCANCHK"){
				var value = "n";
				
				if(colValue == "V"){
					g_count++;
				}else{
					g_count--;
				}

				
				$("#count").html(g_count);
				
				setTimeout(function(){
					mobileCommon.focus("","inputArea","SKUSCN");
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
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "WORKSTS"){
				var worksts = gridList.getColData(gridId, rowNum, "WORKSTS");
				if(worksts == "V"){
					return "y";
				}else{
					return "n";
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
					<input type="hidden" name="SHPOKY"/>
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
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false  >
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_WORKZO"></th>
							<td colspan="3">
								<select id="SHIT04" name="SHIT04" ComboCodeView=false  >
									<option value="" >선택</option>
									<option value="N">대체정상</option>
									<option value="Y">BYPASS</option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_SCANKY"></th>
							<td colspan="2">
								<input type="text" name="SCANKY" UIFormat="NS 20" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
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
							<th CL="STD_SHPMTY"></th>
							<td id="SHPMTY"></td>
							<th CL="STD_BOX"></th>
							<td id="BOXTYP"></td>
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
							<th CL="STD_SKUKEY"></th>
							<td>
								<input type="text" name="SKUSCN" UIFormat="N" onkeypress="scanInput.enterKeyCheck(event, 'gridScanSKUCodeCheck()')"/>
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
								<col width="30" />
								<col width="90" />
								<col width="150" />
								<col width="40" />
								<col width="40" />
								<col width="40" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
								<col width="100" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_SHMSTS"></th>
									<th CL="STD_SCANCHK"></th>
									<th CL="STD_SCHQTY"></th>
									<th CL="STD_QTJCMP"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_DOCKNO"></th>
									<th CL="STD_CARCNT"></th>
									<th CL="STD_SHPDSQ"></th>
									<th CL="STD_SUSRNM"></th>
									<th CL="STD_SVBELN"></th>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_SVBELN"></th>
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
								<col width="30" />
								<col width="90" />
								<col width="150" />
								<col width="40" />
								<col width="40" />
								<col width="40" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
								<col width="100" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="icon,WORKSTS" GB="n"></td>
									<td GCol="check,SCANCHK"></td>
									<td GCol="text,QTYAVE"></td>
									<td GCol="text,QTJCMP"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01"></td>
									<td GCol="text,DOCKNO"></td>
									<td GCol="text,CARCNT"></td>
									<td GCol="text,SHPDSQ"></td>
									<td GCol="text,SUSRNM"></td>
									<td GCol="text,VEHINO"></td>
									<td GCol="text,LOCAKY"></td>
									<td GCol="text,SVBELN"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="l" onclick="saveData();" style="width: 50%;">피킹완료</button>
						<button class="l btnBgW" onclick="initPage();" style="width: 50%;">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>