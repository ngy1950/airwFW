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

.not{color: red !important;}
.notBg td{background-color: #666 !important;}
</style>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_head = [], grpoky = "";
	var gridType = "grid";
	var popskucls = "";
	var usid = "<%=userid%>";
// 	var usid = "AJSTEST";
	
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : true,
			type : "grid",
			gridId : "gridList",
			detailId : "detail"
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsOutbound",
			command : "DL11SUB",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		gridList.setGrid({
			id : "gridList2",
			module : "WmsOutbound",
			command : "MDL11_DTAIL_GRID",
			editable : false,
			emptyMsgType : false,
			gridMobileType : true
		});
		
		scanInput.setScanInput({
			id : "LOCAKY",
			name : "LOCAKY",
			bindId : "scanArea",
			type:"text"
		}); 
		

// 		scanInput.setScanInput({
// 			id : "SHIT05",
// 			name : "SHIT05",
// 			bindId : "scanArea",
// 			type:"number"
// 		});
		
// 		scanInput.setScanInput({
// 			id : "SHIT05",
// 			name : "SHIT05",
// 			bindId : "scanArea",
// 			type:"number"
// 		}); 
		
		mobileDatePicker.setDatePicker({
			id : "RQSHPD",
			name : "RQSHPD",
			bindId : "scanArea"
		}); 
		
		mobileSearchHelp.setSearchHelp({
			id : "SHSHIT05",
			name : "SHIT05",
			returnCol : "SHIT05",
			bindId : "scanArea",
			title : "피킹작업번호 검색",
			inputType : "scan",
			searchType : "in", /* in,out */
			search :[
						{"type":"select","label":"STD_SKUCLS","name":"SKUCLS","combo":"Common,COMCOMBO","codeView":false,"colspan":2},
						[
							{"type":"text","label":"STD_VEHINO","name":"MO_VEHINO"}, //,"uiFormat":"U 14"},
							{"type":"button","label":"none","id":"SHIT05_SEARCH","name":"BTN_DISPLAY","width":45 , "onclick":"test();"}
						]
						
				   ], 
			grid : [
						{"width":60, "label":"작업번호","type":"text","col":"SHIT05"},
						{"width":90,"label":"STD_VEHINO","type":"text","col":"VEHINO"},
						{"width":70, "label":"STD_LMOUSR","type":"text","col":"LMOUSRNM"},
						{"width":50, "label":"미작업","type":"text","col":"NQTJCMP","GF":"N"},
						{"width":70, "label":"STD_SKUCLSNM","type":"text","col":"SKUCLSNM"}
					],
			module : "WmsOutbound",
			command : "DL11"
			
		});

// 		mobileCommon.select("","scanArea","BOXLAB");
		
		var val = day(0);

		searchShpdgr(val);
		$("#scanArea [name=RQSHPD]").on("change",function(){
			popskucls = "";
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		$("#scanArea [name=SHPDGR]").on("change",function(){
			popskucls = "";
		});
				
		gridList.setReadOnly("gridList", true, ["CNLBOX"]);
		
		$("#SHIT05_SEARCH").on("click",function(){
			mobileSearchHelp.selectSearchHelp('SHSHIT05');
		});
		
		$('#SHSHIT05_INNER_SEARCH [name=SKUCLS]').on("change",function(){
			popskucls = $(this).val();
			mobileSearchHelp.selectSearchHelp('SHSHIT05');
		});
		
		$('#start').hide();
		
		
		mobileCommon.select("","scanArea","SHIT05");
// 		$('#SHIT05').focus();
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
// 		searchvehino($('#RQSHPD').val().replace(/\./g,''),"");

		
	}
    
    function searchvehino(val1,val2){
		var param = new DataMap();
			param.put("RQSHPD",val1);
			param.put("WAREKY", "<%=wareky%>");
			param.put("SHPDGR",val2);
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
			gridList.resetGrid("gridList");
			
			var paramchk = dataBind.paramData("scanArea");
				paramchk.put("WAREKY","<%=wareky%>");
				
			var json2 = netUtil.sendData({
		        module : "WmsOutbound",
		        command : "MDL11_SEARCHCHECK",
		        sendType : "map",
		        param : paramchk
		    });
			
			if(json2.data){
				if(json2.data["CREUSR"] != ' ' && json2.data["CREUSR"] != usid){
					mobileCommon.toast({
						type : "F",
						message : "다른 사람이 이미 작업 중입니다.",
						execute : function(){
							success.play();
						}
					});
					mobileCommon.focus("","scanArea","SHIT05");
					return ;
				}
			}else{
				mobileCommon.toast({
					type : "F",
					message : "존재하지 않는 작업 지시 번호 입니다.",
					execute : function(){
						success.play();
					}
				});
				
				return ;
			}
			

			gridList.resetGrid("gridList");
			$('#REDESC01').val('');
			
			var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
				param.put("PKJMAK","1")
				param.put("MOBILE","TRUE");
				param.put("GBN","MOBILE");
				
			var json = netUtil.sendData({
				module : "WmsOutbound",
				command : "DL11",
				sendType : "list",
				param : param
			});
			
			if(json.data.length > 0){
				g_head[0] = json.data[0];
				
				var start = new DataMap();
					start.put("head",g_head[0]);
				if(json2.data["CREUSR"] == ' '){
					netUtil.send({
						url : "/wms/outbound/json/savePickStart.data",
						param : start,
					});	
				}
				
			}else{
				g_head = [];
				return false;
				
			}
			
			param.put("ORDERBY","MOBILE");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			var row = gridList.getGridData("gridList");
			mobileCommon.setTotalViewCount();
			for(var i=0;i<row.length;i++){
				if( row[i].get("CNLBOX") == 'V' || parseInt(row[i].get("PCWORKQTY")) == 0 ){
					gridList.setRowReadOnly(gridId, i, true);
				}
			}
			mobileCommon.focus("","scanArea","LOCAKY");
		}
		
	}
	
// 	function initPage(){
// 		mobileCommon.confirm({
// 			message : "초기화 하시겠습니까?",
// 			confirm : function(){
// 				mobileCommon.initSearch(null,true);
// 				gridList.resetGrid("gridList");
// 				mobileCommon.focus("","scanArea","SKUKEY");
// 			}
// 		});
// 	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			
			var row = gridList.getGridData("gridList");
			var chk = 0;
			var list = [];

			for(var i=0;i<row.length;i++){
				if(row[i].get("PICKPABQTY") > 0 ){
					list[chk] = row[i];
					chk++;
				}
			}
			
			if(chk == 0){
				mobileCommon.alert({
		 			message : "선택된 데이터가 없습니다.",
		 			confirm : function(){
		 				mobileCommon.select("","scanArea","LOCAKY");
		 			}
		 		});
				return;
			}
			
			mobileCommon.confirm({
				message : "피킹완료 하시겠습니까?",
				confirm : function(){
					var param = dataBind.paramData("scanArea");
					var vehino = param.get("VEHINO");
					
					var param = new DataMap();
					
						param.put("head",g_head);
						param.put("list",list);
						param.put("PROGTP","PDA");
				
					netUtil.send({
						url : "/wms/outbound/json/saveDL11.data",
						param : param,
						successFunction : "succsessSaveCallBack"
					});
				}
			});
		}
		
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if(parseInt(json.data) > 0){
				mobileCommon.toast({
					type : "S",
					message : "피킹이 완료 되었습니다.",
					execute : function(){
						success.play();
						
						gridList.resetGrid("gridList");
						mobileCommon.select("","scanArea","LOCAKY");
						searchData();
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
	
	function gridListEventRowClick(id, rowNum, colName){
		if( colName == "CNLQTY" ){
			gridType = "detail";
			
			var param = dataBind.paramData("scanArea");
				param.put("WAREKY",gridList.getColData(id, rowNum, "WAREKY"));
				param.put("GRPOKY",gridList.getColData(id, rowNum, "GRPOKY"));
				param.put("VEHINO",gridList.getColData(id, rowNum, "VEHINO"));
				param.put("SKUCLS",gridList.getColData(id, rowNum, "SKUCLS"));
				param.put("SKUKEY",gridList.getColData(id, rowNum, "SKUKEY"));
				param.put("MOBILE","TRUE");
				param.put("SES_ENV", "<%=usradm%>");
			gridList.gridList({
				id : "gridList2",
				param : param
			});
			
			parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
			mobileCommon.openDetail(gridType);	
		}
	}
	
	function gridDetailEventNextView(gridId , rowNum ){

		var param = dataBind.paramData("scanArea");
			param.put("WAREKY",gridList.getColData(gridId, rowNum, "WAREKY"));
			param.put("GRPOKY",gridList.getColData(gridId, rowNum, "GRPOKY"));
			param.put("VEHINO",gridList.getColData(gridId, rowNum, "VEHINO"));
			param.put("SKUCLS",gridList.getColData(gridId, rowNum, "SKUCLS"));
			param.put("SKUKEY",gridList.getColData(gridId, rowNum, "SKUKEY"));
			param.put("MOBILE","TRUE");
			param.put("SES_ENV", "<%=usradm%>");
		gridList.gridList({
			id : "gridList2",
			param : param
		});
	}
	
	function gridDetailEventPrevView(gridId , rowNum ){
		var param = dataBind.paramData("scanArea");
			param.put("WAREKY",gridList.getColData(gridId, rowNum, "WAREKY"));
			param.put("GRPOKY",gridList.getColData(gridId, rowNum, "GRPOKY"));
			param.put("VEHINO",gridList.getColData(gridId, rowNum, "VEHINO"));
			param.put("SKUCLS",gridList.getColData(gridId, rowNum, "SKUCLS"));
			param.put("SKUKEY",gridList.getColData(gridId, rowNum, "SKUKEY"));
			param.put("MOBILE","TRUE");
			param.put("SES_ENV", "<%=usradm%>");
		gridList.gridList({
			id : "gridList2",
			param : param
		});
	}
	
	function closeKeyPadAfterEvent(areaId,name,value,$Obj){
		mobileCommon.select("","scanArea","LOCAKY");
	}
	
	function changeGridAndDetailAfter(type){
		mobileCommon.select("","scanArea","LOCAKY");
	}
	
	function checkLocaky(){
		var param = dataBind.paramData("scanArea");
		var locaky = param.get("LOCAKY");
		
		var list = gridList.getGridData("gridList");
		var chk = 0 , chk2 = 0;
		var row = -1;
		if(!isNull(locaky)){
			for(var i=0;i<list.length;i++){
				var grlocaky = list[i].get("LOCAKY");
				var pcworkqty = parseInt(list[i].get("PCWORKQTY"));
				var pkjmak = list[i].get("PKJMAK");
				var desc01 = list[i].get("DESC01");
				if(locaky == grlocaky ){
					if(pkjmak == 'V' || pcworkqty == 0){
						
						chk2++;
						chk++;
						break;
					}
					gridList.setColValue("gridList"	, i, "PICKPABQTY", pcworkqty );
					row = i;
					chk++;
					break;
				}
			}
			if(chk2 != 0){
				mobileCommon.toast({
					type : "F",
					message : "이미 작업이 완료된 로케이션 입니다.",
					execute : function(){
						success.play();
					}
				});
				$('#REDESC01').val('');
				mobileCommon.initBindArea("scanArea",["LOCAKY"]);
				mobileCommon.select("","scanArea","LOCAKY");
				return ;
			}
			
			if(chk == 0){
				mobileCommon.toast({
					type : "F",
					message : "일치하는 정보가 존재하지 않습니다.",
					execute : function(){
						success.play();
					}
				});
				$('#REDESC01').val('');
				mobileCommon.initBindArea("scanArea",["LOCAKY"]);
				mobileCommon.select("","scanArea","LOCAKY");
				return ;
			}
			
			var qtjcmp	= parseInt(gridList.getColData("gridList", row, "QTJCMP"));
			var pcowrkqty = parseInt(gridList.getColData("gridList", row , "PICKPABQTY"));
			var bepcowrkqty = parseInt(gridList.getColData("gridList", row, "BEPCWORKQTY"));
			var qyshpo = parseInt(gridList.getColData("gridList", row, "QTSHPO")); 
 			if(pcowrkqty > bepcowrkqty ){
 				mobileCommon.toast({
					type : "F",
					message : "입력 가능한 수량이 아닙니다.",
					execute : function(){
						success.play();
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
				gridList.setColValue("gridList", row, "PICKPABQTY", 0);
				gridList.setRowFocus("gridList", row, true);
				mobileCommon.initBindArea("scanArea",["LOCAKY"]);
				mobileCommon.select("","scanArea","LOCAKY");
 				return ;
 			}
 			gridList.setRowFocus("gridList", row, true);
 			$('#REDESC01').val(desc01);
			mobileCommon.initBindArea("scanArea",["LOCAKY"]);
			mobileCommon.select("","scanArea","LOCAKY");
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
			param.put("WAREKY","<%=wareky%>");
		
		if(layerId == "SHSHIT05_LAYER"){
			if(!isNull(popskucls)){
				$('#SHSHIT05_INNER_SEARCH [name=SKUCLS]').val(popskucls);	
			}
			
			
			var data   = dataBind.paramData("scanArea");
			
			var skucls = $('#SHSHIT05_INNER_SEARCH [name=SKUCLS]').val();
			var vehino = $('#SHSHIT05_INNER_SEARCH [name=MO_VEHINO]').val();
			var rqshpd = data.get("RQSHPD");
			var shpdgr = data.get("SHPDGR");
			
			
			
			
			param.put("MOBILE","TRUE");
			param.put("RQSHPD",rqshpd);
			param.put("SHPDGR",shpdgr);
			param.put("SKUCLS",skucls);
			param.put("PKJMAK","1");
			param.put("MO_VEHINO",vehino);
			param.put("GBN","MOBILE");
			param.put("ORDERBY","MOBILE");
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		var paramchk = dataBind.paramData("scanArea");
			paramchk.put("WAREKY","<%=wareky%>");
			
// 		if(parseInt(data.get("NQTJCMP")) == 0){
// 			mobileCommon.toast({
// 				type : "F",
// 				message : "이미 피킹이 완료 되었습니다.",
// 				execute : function(){
// 					success.play();
// 				}
// 			});
// 			mobileSearchHelp.selectSearchHelp('SHSHIT05');
// 			return ;
// 		}
		
		var json = netUtil.sendData({
	        module : "WmsOutbound",
	        command : "MDL11_SEARCHCHECK",
	        sendType : "map",
	        param : paramchk
	    });
		
		if(json.data){
			if(json.data["CREUSR"] != ' ' && json.data["CREUSR"] != usid){
				mobileCommon.toast({
					type : "F",
					message : "다른 사람이 이미 작업 중입니다.",
					execute : function(){
						success.play();
					}
				});
				mobileSearchHelp.selectSearchHelp('SHSHIT05');
				return ;
			}else if(json.data["CREUSR"] == ' '){
				var param = new DataMap();
					param.put("head",data);
				
				netUtil.send({
					url : "/wms/outbound/json/savePickStart.data",
					param : param,
				});
			}
		}

		popskucls = data.get("SKUCLS");
		data.put("PKJMAK","1");
		g_head[0] = data;
		$('#SHIT05').val(data.get("SHIT05"));
		data.put("GBN","MOBILE");
		gridList.gridList({
			id : "gridList",
			param : data
		});
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "PKJMAK"){
				if(colValue == "V"){
					return "y";	
				}else if($.trim(colValue) == ""){
					var pcworkqty = parseInt(gridList.getColData(gridId, rowNum, "PCWORKQTY"));
					if(pcworkqty == 0){
						return "y";
					}else{
						return "n";	
					}
					
				}
			}
		}
	}
	
	function scanSHIT05(){
		var param = dataBind.paramData("scanArea");
		var shit05 = param.get("SHIT05");
		
		if(!isNull(shit05)){
			searchData();
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	    if(gridId == "gridList"){
			var qtjcmp	= parseInt(gridList.getColData(gridId, rowNum, "QTJCMP"));
			var pcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "PICKPABQTY"));
			var bepcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "BEPCWORKQTY"));
			var qyshpo = parseInt(gridList.getColData(gridId, rowNum, "QTSHPO"));
			var desc01 = gridList.getColData(gridId, rowNum, "DESC01"); 
 			if(pcowrkqty > bepcowrkqty ){
 				mobileCommon.toast({
					type : "F",
					message : "입력 가능한 수량이 아닙니다.",
					execute : function(){
						success.play();
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
				gridList.setColValue(gridId, rowNum, "PICKPABQTY", 0);
				mobileCommon.initBindArea("scanArea",["LOCAKY"]);
				mobileCommon.select("","scanArea","LOCAKY");
				$('#REDESC01').val('');
 				return ;
 			}
 			mobileCommon.initBindArea("scanArea",["LOCAKY"]);
			mobileCommon.select("","scanArea","LOCAKY");
			$('#REDESC01').val(desc01);
	    }
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "Common,COMCOMBO" ){
			var selectName = paramName[0].name;
			param.put("WARECODE","Y");
			param.put("WAREKY","<%=wareky%>");
			if(selectName == "SKUCLS"){
				param.put("USARG1","03");
				param.put("CODE", "SKUCLS");
			}
			return param;
		}
	}
	
	function pickStart(){
		$('#start').hide();
		$('#end').show();
	}
	
	function pickEnd(){
		var param = new DataMap();
			param.put("head",g_head);
			param.put("GBN","MOBILE");
	
		netUtil.send({
			url : "/wms/outbound/json/savePickcancel.data",
			param : param,
		});
		$('#SHSHIT05').val();
		mobileCommon.select("","scanArea","SHIT05");
		gridList.resetGrid("gridList");
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
							<td >
								<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="D N" validate="required(STD_RQSHPD)" /> 
							</td>
						
							<td>
								<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false  validate="required(STD_SHPDGR)" >
									<option value="" selected>선 택</option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_SHIT05"></th>
							<td colspan="3">
								<input type="text" name="SHIT05" id="SHIT05" onkeypress="scanInput.enterKeyCheck(event, 'scanSHIT05(this)')" validate="required(피킹작업번호)" /> 
							</td>
							<td >
								<button class="innerBtn" id="SHLOCKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_LOCAKY"></th>
							<td colspan="4">
								<input type="text" name="LOCAKY" id=""LOCAKY"" UIFormat="U" onkeypress="scanInput.enterKeyCheck(event, 'checkLocaky()')" />
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01"></th>
							<td colspan="4">
								<input type="text" name="REDESC01" id="REDESC01" UIFormat="U" readonly="readonly" />
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
								<col width="65" />
								<col width="60" />
								<col width="45" />
								<col width="60" />
								<col width="40" />
								<col width="40" />
								
								<col width="80" />
								<col width="150" />
	
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_PKJMAK2"></th>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_QTJCMP"></th>
									<th CL="STD_NOTTSK"></th>
									<th CL="STD_PICKCOMP"></th>
									
									<th CL="STD_QTSIWH"></th>
									<th CL="BTN_CANCEL"></th>
									
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="65" />
								<col width="60" />
								<col width="45" />
								<col width="60" />
								<col width="40" />
								<col width="40" />
								
								<col width="80" />
								<col width="150" />
								
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="icon,PKJMAK" GB="n" ></td>
									<td GCol="text,LOCAKY" ></td>
									<td GCol="input,PICKPABQTY" GF="N" ></td>
									<td GCol="text,PCWORKQTY" GF="N" ></td>
									<td GCol="text,QTJCMP" GF="N" ></td>
									<td GCol="text,QTSIWH" GF="N" ></td>
									<td GCol="text,CNLQTY" GF="N" ></td>
									
									<td GCol="text,SKUKEY" ></td>
									<td GCol="text,DESC01" ></td>
									
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 1" onclick="saveData();">피킹완료</button>
						<button id="start" class="wid3 r btnBgW" onclick="pickStart();">작업시작</button>
						<button id="end" class="wid3 r btnBgW" onclick="pickEnd();">작업취소</button>
					</div>
				</div>
			</div>
			<!-- Detail Area -->
			<div class="detailArea" id="detail">
				<div class="detailContent">
					<div class="pageCount">
						<span class="txt">Page.</span><span class="count">0</span><span class="slush">/</span><span class="totalCount">0</span>
					</div>
					<div class="content">
						<table>
							<colgroup>
								<col width="70" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th CL="STD_SKUKEY"></th>
									<td>
										<input type="text" name="SKUKEY" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_DESC01"></th>
									<td>
										<input type="text" name="DESC01" readonly="readonly"/>
									</td>
								</tr>
							</tbody>
						</table>
							<div class="tableWrap_search section">
								<div class="tableHeader">
									<table style="width: 100%">
										<colgroup>
											<col width="40" />
											<col width="60" />
											<col width="80" />
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_SHPDSQ" style="text-align: center;"></th>
												<th CL="STD_SUSRNM" style="text-align: center;"></th>
												<th CL="STD_BOXLAB" style="text-align: center;"></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table style="width: 100%">
										<colgroup>
											<col width="40" />
											<col width="60" />
											<col width="80" />
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GCol="text,SHPDSQ" GF="N" ></td>
												<td GCol="text,SUSRNM" ></td>
												<td GCol="text,BOXLAB" ></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
					</div>
				</div>
				<!-- Detail Button Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<div class="button">
							<ul>
								<li class="prev"><p></p></li>
								<li class="btn">
									<button class="wid1 btnBgG" ><span></span></button>
								</li>
								<li class="next"><p></p></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>