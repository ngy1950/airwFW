<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<style>
.n{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_head = null, grpoky = "";
	
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
			module : "WmsOutbound",
			command : "DL21SUB",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		scanInput.setScanInput({
			id : "BOXLAB",
			name : "BOXLAB",
			bindId : "scanArea",
			type:"number"
		}); 
		
		mobileDatePicker.setDatePicker({
			id : "RQSHPD",
			name : "RQSHPD",
			bindId : "scanArea"
		}); 

		mobileCommon.select("","scanArea","BOXLAB");
		
		var val = day(0);

		searchShpdgr(val);
		$("#scanArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		$("#scanArea [name=SHPDGR]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$(this).val());
			
		});
		$("#scanArea [name=VEHINO]").on("change",function(){
			if(!isNull( $(this).val() )){
				searchData();
			}
			
		});
		
		
		gridList.setReadOnly("gridList", true, ["CNLBOX"]);
		
		
    });

    
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
		getMaxSHPDGR();
		searchvehino($('#RQSHPD').val().replace(/\./g,''),"");
	}
    
    function searchvehino(val1,val2){
		var param = new DataMap();
			param.put("RQSHPD",val1);
			param.put("WAREKY", "<%=wareky%>");
			param.put("SHPDGR",val2);
			param.put("CANCEL","V");
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
    
    function day(day){
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
		
		return String(yyyy) + String(mm) + String(dd);
	}
    
    function getMaxSHPDGR(){
    	var param = new DataMap();
    		param.put("WAREKY","<%=wareky%>");
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "MAX_SHPDGR",
            sendType : "map",
            param : param
        });
    	
    	$('#SHPDGR').val(json.data["SHPDGR"]);
    }
    
    function confirmDatePickerEvent(areaId,inputName,value,$returnObj){
		if(areaId == "scanArea"){
			if(inputName == "RQSHPD"){
				searchShpdgr(value.replace(/\./g,''));
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			mobileCommon.initBindArea("scanArea",["BOXLAB"]);
			gridList.resetGrid("gridList");
			
			var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
			
			var json = netUtil.sendData({
	              module : "WmsOutbound",
	              command : "MDL21_BOXCHK",
	              sendType : "map",
	              param : param
			});
			
			if(parseInt(json.data["CNT"]) == 0){
				mobileCommon.alert({
		 			message : "출하 취소대상이 존재하지 않습니다.",
		 			confirm : function(){
		 				mobileCommon.select("","scanArea","BOXLAB");
		 			}
		 		});
				return ;
			}
						
			netUtil.send({
				module : "WmsOutbound",
				command : "MDL21_GRPOKY",
				param : param,
				sendType : "map",
				successFunction : "searchHeadCallBack"
			});
		}
	}
	
	function searchHeadCallBack(json){
		if(json && json.data){
			grpoky = json.data["GRPOKY"];
			var param = dataBind.paramData("scanArea");
				param.put("GRPOKY",grpoky);
				param.put("MOBILE","TRUE");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			var row = gridList.getGridData("gridList");

			for(var i=0;i<row.length;i++){
				if(row[i].get("CNLBOX") == 'V'){
					gridList.setRowReadOnly(gridId, i, true);
				}
			}
		}
		
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				mobileCommon.initSearch(null,true);
				gridList.resetGrid("gridList");
				mobileCommon.focus("","scanArea","SKUKEY");
			}
		});
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			
			var row = gridList.getGridData("gridList");
			var chk = 0;
			var arraylist = [];
			var list = [];

			for(var i=0;i<row.length;i++){
				if(row[i].get("SCANCHK") == 'V'){
					arraylist[chk] = row[i].get("SBOXSQ");
					list[chk] = row[i];
					chk++;
				}
			}
			
			if(chk == 0){
				mobileCommon.alert({
		 			message : "선택된 데이터가 없습니다.",
		 			confirm : function(){
		 				mobileCommon.select("","scanArea","BOXLAB");
		 			}
		 		});
				return;
			}
			
			var paramchk = new DataMap();
				paramchk.put("SBOXSQLIST",arraylist);
				paramchk.put("WAREKY" , "<%=wareky%>");
				paramchk.put("GRPOKY" , grpoky);
			
			var json2 = netUtil.sendData({
	            module : "WmsOutbound",
	            command : "CHKECK_CNLCNT",
	            sendType : "map",
	            param : paramchk
	        });
			
			if(list.length != parseInt(json2.data["CNT"])){
				mobileCommon.alert({
		 			message : "취소요청한 주문중에 이미 취소된 주문이 존재 합니다.\n재조회 후 실행 하시기 바랍니다.",
		 			confirm : function(){
		 				mobileCommon.select("","scanArea","BOXLAB");
		 			}
		 		});
				return;
			}
			mobileCommon.confirm({
				message : "출하취소 하시겠습니까?",
				confirm : function(){
					var param = dataBind.paramData("scanArea");
					var vehino = param.get("VEHINO");
					var headitem = new DataMap();
						headitem.put("WAREKY","<%=wareky%>");
						headitem.put("VEHINO",vehino);
						headitem.put("MOBILE","TRUE");
						headitem.put("GRPOKY",grpoky);
					
					var headlist = [];
						headlist[0] = headitem;
					
					var param = new DataMap();
					
						param.put("head",headlist);
						param.put("list",list);
				
					netUtil.send({
						url : "/wms/outbound/json/saveDL21.data",
						param : param,
						successFunction : "succsessSaveCallBack"
					});
				}
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if(json.data == "OK"){
				mobileCommon.toast({
					type : "S",
					message : "출하취소에 성공 하였습니다.",
					execute : function(){
						success.play();
						
						gridList.resetGrid("gridList");
						mobileCommon.select("","scanArea","BOXLAB");
						searchData();
					}
				});
				
			}else {
				mobileCommon.toast({
					type : "F",
					message : "출하취소에 실패 하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","scanArea","BOXLAB");
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
		mobileCommon.select("","scanArea","BOXLAB");
	}
	
	function changeGridAndDetailAfter(type){
		mobileCommon.select("","scanArea","BOXLAB");
	}
	
	function cancelcheck(){
		var param = dataBind.paramData("scanArea");
		var boxlab = param.get("BOXLAB");
		
		var list = gridList.getGridData("gridList");
		var chk = 0;
		var crow = 0;
		if(!isNull(boxlab)){
			for(var i=0;i<list.length;i++){
				var sboxid = list[i].get("SBOXID");
				var label = list[i].get("BOXLAB");
				var cnlbox = list[i].get("CNLBOX");
				if(boxlab == label || boxlab == sboxid){
					if(cnlbox == 'V'){
						mobileCommon.toast({
							type : "F",
							message : "이미취소된 박스 입니다.",
							execute : function(){
								success.play();
							}
						});
						chk++;
						break;
					}
					gridList.setColValue("gridList"	, i, "SCANCHK", 'V');
					crow = i;
					chk++;
					break;
				}
			}
 			
			if(chk == 0){
				mobileCommon.toast({
					type : "F",
					message : "일치하는 정보가 존재하지 않습니다.",
					execute : function(){
						success.play();
					}
				});
			}
			gridList.setRowFocus("gridList", crow, true);
			mobileCommon.initBindArea("scanArea",["BOXLAB"]);
			mobileCommon.select("","scanArea","BOXLAB");
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "CNLBOX"){
				if(colValue == "V"){
					return "d";
				}else if($.trim(colValue) == ""){
					
						return "n";
				}
			}
		}
	}
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Search Area -->
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area">
				<table id="scanArea">
					<colgroup>
						<col width="80" />
						<col width="153"/>
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_RQSPDGR"></th>
							<td>
								<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="D N" validate="required(STD_RQSHPD)" />
							</td>
						
							<td>
								<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false  validate="required(STD_SHPDGR)" >
									<option value="" selected>선 택</option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_VEHINO"></th>
							<td >
								<select id="VEHINO" name="VEHINO"  UISave="false" ComboCodeView=false style="width:100%;" validate="required(STD_VEHINO)">
									<option value="" selected>선 택</option>
								</select>
							</td>
							<td >
								<button class="innerBtn" id="SHLOCKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_BOXLAB2"></th>
							<td colspan="2">
								<input type="text" name="BOXLAB" onkeypress="scanInput.enterKeyCheck(event, 'cancelcheck()')" />
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
								<col width="40" />
								<col width="60" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_MCNLBOX"></th>
									<th CL="STD_SCANCHK"></th>
									<th CL="STD_SHPDSQ"></th>
									<th CL="STD_SUSRNM"></th>
									<th CL="STD_BOXTYPNM"></th>
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
									<td GCol="icon,CNLBOX" GB="n" ></td>
									<td GCol="check,SCANCHK" ></td>
									<td GCol="text,SHPDSQ" ></td>
									<td GCol="text,SUSRNM" ></td>
									<td GCol="text,BOXTYPNM" ></td>
									<td GCol="text,SBOXID"  ></td>
									<td GCol="text,BOXLAB"  ></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid1 1" onclick="saveData();">출하취소</button>
<!-- 						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>