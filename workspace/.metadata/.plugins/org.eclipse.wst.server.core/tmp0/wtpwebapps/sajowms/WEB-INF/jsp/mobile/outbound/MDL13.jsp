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

.mdl13AlertWrap{width: 100%;min-height: 160px;padding: 10px;box-sizing: border-box;overflow: hidden;}
.mdl13AlertWrap .head{width: 100%;height: 75px;}
.mdl13AlertWrap .head ul{width: 100%;height: 100%;}
.mdl13AlertWrap .head ul li{width: 100%;height: 25px;font-weight: bold;}
.mdl13AlertWrap .content{width: 100%;overflow: auto;}
.mdl13AlertWrap .content .row{width: 100%;height: 104px;margin-top: 5px;}
.mdl13AlertWrap .content .row .num{width: 30px;height: 102px;float: left;text-align: center;border: 1px solid #A9A9A9;line-height: 104px;background-color: #efefef;}
.mdl13AlertWrap .content .row .col1{width: calc(100% - 34px);height: 25px;float: left;border: 1px solid #A9A9A9;border-left: 0;padding-left: 0;}
.mdl13AlertWrap .content .row .col1.pad{width: calc(100% - 39px);padding-left: 5px;background-color: #efefef;}
.mdl13AlertWrap .content .row .col1 ul{width: 100%;height: 100%;}
.mdl13AlertWrap .content .row .col1 ul .c1{width: 60px;height: 25px;float: left;border-right: 1px solid #A9A9A9;padding-left: 5px;background-color: #efefef;}
.mdl13AlertWrap .content .row .col1 ul .c2{width: calc(100% - 72px);height: 25px;float: left;    padding-left: 5px;}
.mdl13AlertWrap .content .row .col2{width: calc(100% - 34px);height: 50px;float: left;border-right: 1px solid #A9A9A9;}
.mdl13AlertWrap .content .row .col2 ul{width: 100%;height: 100%;}
.mdl13AlertWrap .content .row .col2 ul .c1{width: 60px;height: 50px;float: left;border-right: 1px solid #A9A9A9;padding-left: 5px;line-height: 53px;background-color: #efefef;}
.mdl13AlertWrap .content .row .col2 ul .c2{width: calc(100% - 72px);height: 50px;float: left;padding-left: 5px;}
</style>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_count = 0;
	var g_totcount = 0;
	var beforeList = [];
	var failList = [];

	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "MDL13",
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
			id : "LOCAKY",
			name : "LOCAKY",
			bindId : "inputArea"
		});
		
		$("#RQSHPD").val(day(0,true));
		searchShpdgr(day(0,false));
		
		$("#ZONEKY").hide();
		$("#AREAKY").css("width","100%");
		$(".scan_area").css("padding-top",7);
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
		
		var lastVal = $("#SHPDGR option").last().val();
		$("#SHPDGR").val(lastVal);
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			initTypeArea();
			gridList.resetGrid("gridList");
			
			var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
			
			var zoneky = $.trim(param.get("ZONEKY"));
				param.put("ZONEKY",zoneky);
				
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
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		this.g_count = 0;
		this.g_totcount = 0;
		
		if(gridId == "gridList" && dataLength > 0){
			var rowNumList = gridList.getRowNumList(gridId);
			for(var i = 0; i < dataLength; i++){
				var rowNum = rowNumList[i];
				var shod04 = gridList.getColData(gridId,rowNum,"SHOD04");
				var locaky = gridList.getColData(gridId,rowNum,"LOCAKY");
				if(shod04 == "V"){
					g_count++;
				}else{
					if(beforeList.indexOf(locaky) > -1){
						gridList.setRowCheck(gridId, rowNum, true);
					}
				}
			}
			
			g_totcount = dataLength;
			
			$("#count").html(g_count);
			$("#totCount").html(g_totcount);
			
			mobileCommon.select("","inputArea","LOCAKY");
		}else if(gridId == "gridList" && dataLength == 0){
			fail.play();
			
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
		mobileCommon.initBindArea("inputArea", ["LOCAKY"]);
		
		typeAreaMapping("QTSHPO","");
		typeAreaMapping("DESC01","");
		
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
				beforeList = [];
				failList = [];
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
	
	function saveData(){
		var list    = gridList.getSelectData("gridList",true);
		var listLen = list.length;
		if(listLen > 0){
			beforeList = [];
			
			for(var i = 0; i < listLen; i++){
				var row = list[i];
				var locaky = row.get("LOCAKY");
				beforeList.push(locaky);
			}
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/mobile/json/SaveMDL13.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}else{
			fail.play();
			
			var isFocus = true;
			var msg = "";
			
			var gridLen = gridList.getGridDataCount("gridList");
			if(gridLen > 0){
				msg = "<span class='msgColorBlack'>스캔</span> 또는 <span class='msgColorBlack'>체크</span> 된 데이터가 없습니다.";
			}else{
				isFocus = false;
				msg = "조회된 데이터가 없습니다."
			}
			mobileCommon.alert({
				message : msg,
				confirm : function(){
					if(isFocus){
						mobileCommon.select("","inputArea","LOCAKY");
					}
				}
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			failList = [];
			
			var code = json.data["code"];
			var reqCount  = json.data["reqCount"];
			var succCount = json.data["succCount"];
			var failCount = json.data["failCount"];
			
			if(code == "S"){
				if(failCount > 0){
					mdl13AlertResult("1",[reqCount,succCount,failCount]);
					failList = json.data["failList"];
					mdl13AlertOpen();
				}else{
					mobileCommon.toast({
						type : "S",
						message : "피킹 완료 되었습니다.",
						execute : function(){
							beforeList = [];
							success.play();
							searchData();
						}
					});
				}
				
			}else if(code == "F1"){
				mdl13AlertResult("1",[reqCount,succCount,failCount]);
				failList = json.data["failList"];
				mdl13AlertOpen();
			}else if(code == "F2"){
				mobileCommon.toast({
					type : "F",
					message : "처리할 데이터가 없습니다.",
					execute : function(){
						
					}
				});
			}
		}
	}
	
	function setFailListObject(){
		var $ul = $("<ul>");
		var $li = $("<li>");
		var $input = $("<input>");
		
		var $row = $ul.clone().addClass("row");
		var $rowItem1 = $li.clone().addClass("num");
		var $rowItem2 = $li.clone().addClass("col1");
		var $rowItem3 = $li.clone().addClass("col2");
		var $rowItem4 = $li.clone().addClass("col1").addClass("pad");
		
		var $checkBox = $input.attr({"type":"checkbox"});
		var $tit = $li.clone().addClass("c1");
		var $col = $li.clone().addClass("c2");
		
		$rowItem1.append($checkBox);
		$rowItem2.append($ul.clone().append($tit.clone().html("로케이션")).append($col.clone()));
		$rowItem3.append($ul.clone().append($tit.clone().html("상품명")).append($col.clone()));
		
		return $row.append($rowItem1).append($rowItem2).append($rowItem3).append($rowItem4);
	}
	
	function drawFailList(){
		var $failListArea = $("#failListArea");
		if($failListArea.children().length > 0){
			$failListArea.children().remove();
		}
		
		var len = failList.length;
		if(len > 0){
			for(var i = 0; i < len; i++){
				var row = failList[i];
				
				var rowNum = i;
				var locaky = row["LOCAKY"];
				var desc01 = row["DESC01"];
				var qtshpo = row["QTSHPO"];
				var qtyinp = row["QTYINP"];
				
				var $obj = setFailListObject().clone();
				
				$obj.find(".num").find("input").val(rowNum);
				$obj.find(".col1").eq(0).find(".c2").html(locaky);
				$obj.find(".col2").find(".c2").html(desc01);
				$obj.find(".col1").eq(1).html("수량이 <span class='msgColorRed'>" + qtyinp +"</span> -> <span class='msgColorGreen'>" + qtshpo + "</span> 로 변경되었습니다.");
				
				$failListArea.append($obj);
			}
			
		}
	}
	
	function gridScanLocaky(){
		var data = dataBind.paramData("inputArea");
		var scanLocaky = data.get("LOCAKY");
		if(isNull(scanLocaky)){
			fail.play();
			
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>로케이션</span> 을 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","inputArea","LOCAKY");
				}
			});
			return;
		}
		
		var list = gridList.getGridData("gridList",true);
		var checkList = list.filter(function(element,index,array){
			return ($.trim(element.get("LOCAKY")) == scanLocaky && $.trim(element.get("SHOD04")) != "V");
		});
			
		if(checkList.length > 0){
			var row    = checkList[0];
			var rowNum = row.get("GRowNum");
			
			var $gridWrap = $("#gridList").parents(".tableBody");
			var $obj      = $("#gridList tr:eq("+rowNum+")");
			
			var isPass = true;
			
			var rowCheckList = gridList.getSelectRowNumList("gridList");
			if(rowCheckList.indexOf(String(rowNum)) > -1){
				isPass = false;
				
				mobileCommon.toast({
					type : "F",
					message : "이미 <span class='msgColorRed'>스캔</span> 또는 <span class='msgColorRed'>체크</span>한 로케이션 입니다.",
					execute : function(){
						fail.play();
						mobileCommon.focus("","inputArea","LOCAKY");
					}
				});
			}
			
			if(isPass){
				success.play();
				gridList.setRowCheck("gridList", rowNum, true);
			}
			
			setTimeout(function(){
				var offsetTop = $obj[0].offsetTop;
				$gridWrap.scrollTop(offsetTop);
				gridList.setRowFocus("gridList", rowNum, true);
				mobileCommon.focus("","inputArea","LOCAKY");
			});
		}else{
			var compLocList = list.filter(function(element,index,array){
				return ($.trim(element.get("LOCAKY")) == scanLocaky && $.trim(element.get("SHOD04")) == "V");
			});
			
			if(compLocList.length > 0){
				var row    = compLocList[0];
				var rowNum = row.get("GRowNum");
				var qtshpo = row.get("QTSHPO");
				var desc01 = row.get("DESC01");
				
				var $gridWrap = $("#gridList").parents(".tableBody");
				var $obj      = $("#gridList tr:eq("+rowNum+")");
				
				typeAreaMapping("QTSHPO",qtshpo);
				typeAreaMapping("DESC01",desc01);
				
				mobileCommon.toast({
					type : "W",
					message : "이미 피킹 처리된<span class='msgColorRed'>로케이션</span> 입니다.",
					execute : function(){
						fail.play();
						mobileCommon.focus("","inputArea","LOCAKY");
					}
				});
				
				setTimeout(function(){
					var offsetTop = $obj[0].offsetTop;
					$gridWrap.scrollTop(offsetTop);
					gridList.setRowFocus("gridList", rowNum, true);
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "지시된 <span class='msgColorRed'>로케이션</span> 이 아닙니다.",
					execute : function(){
						fail.play();
						mobileCommon.focus("","inputArea","LOCAKY");
					}
				});
			}
		}
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
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "SHOD04"){
				if(colValue == "V"){
					return "y";
				}else if($.trim(colValue) == ""){
					return "n";
				}
			}
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if( gridId == "gridList" ){
			var shod04 = gridList.getColData(gridId, rowNum, "SHOD04");
			if( shod04 == "V" ){
				return true;
			}
		}
	}
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridList"){
			var qtshpo = gridList.getColData(gridId, rowNum, "QTSHPO");
			var desc01 = gridList.getColData(gridId, rowNum, "DESC01");
			
			if(checkType){
				g_count++;
			}else{
				g_count--;
			}
			
			typeAreaMapping("QTSHPO",qtshpo);
			typeAreaMapping("DESC01",desc01);
			
			$("#count").html(g_count);
			
			setTimeout(function(){
				mobileCommon.focus("","inputArea","LOCAKY");
			});
		}
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		if(gridId == "gridList"){
			if(checkType){
				g_count = g_totcount;
				$("#count").html(g_count);
			}else{
				var list = gridList.getGridData(gridId, true);
				var compLocList = list.filter(function(element,index,array){
					return $.trim(element.get("SHOD04")) == "V";
				});
				
				g_count = compLocList.length;
				
				$("#count").html(g_count);
			}
			
			typeAreaMapping("QTSHPO","");
			typeAreaMapping("DESC01","");
			
			setTimeout(function(){
				mobileCommon.focus("","inputArea","LOCAKY");
			});
		}
	}
	
	function gridListEventRowClick(gridId, rowNum, colName){
		if(gridId == "gridList"){
			var qtshpo = gridList.getColData(gridId, rowNum, "QTSHPO");
			var desc01 = gridList.getColData(gridId, rowNum, "DESC01");
			
			typeAreaMapping("QTSHPO",qtshpo);
			typeAreaMapping("DESC01",desc01);
			
			setTimeout(function(){
				mobileCommon.focus("","inputArea","LOCAKY");
			});
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if(comboAtt == "WmsAdmin,AREACOMBO"){
			param.put("WAREKY",wareky);
			param.put("USARG1","STOR");
			return param;
		}else if(comboAtt == "WmsAdmin,ZONECOMBO"){
			var data = dataBind.paramData("scanArea");
			var areaky = data.get("AREAKY");
			
			param.put("WAREKY",wareky);
			param.put("AREAKY",areaky);
			return param;
		}
	}
	
	function changeShpdgrEvent(){
		initTypeArea();
		gridList.resetGrid("gridList");
	}
	
	function changeAreaCombo(){
		var data = $("#AREAKY").val();
		var th = $("#scanArea tr").find("[CL=STD_AREAKY]");
		if(isNull(data)){
			th.html("AREA");
			$("#ZONEKY").val("");
			$("#ZONEKY").hide();
			$("#AREAKY").css("width","100%");
		}else{
			th.html("AREA/ZONE");
			$("#AREAKY").css("width","55%");
			$("#ZONEKY").show();
			inputList.reloadCombo($("#ZONEKY"), configData.INPUT_COMBO, "WmsAdmin,ZONECOMBO", false);
			setTimeout(function(){
				$("#ZONEKY").val("");
			});
		}
	}
	
	function mdl13AlertResult(type,dataArr){
		switch (type) {
		case "1":
			$("#t1").html("요청 건수");
			$("#t2").html("피킹 완료");
			$("#t3").html("주문 변경");
			break;
		case "2":
			$("#t1").html("재요청 건수");
			$("#t2").html("재처리 완료");
			$("#t3").html("미처리 건수");
			break;
		default:
			break;
		}
		
		$("#v1").html(dataArr[0]);
		$("#v2").html(dataArr[1]);
		$("#v3").html(dataArr[2]);
	}
	
	function mdl13AlertOpen(){
		drawFailList();
		
		var bodyHeight = $("body").height();
		var maxWrapHeight = bodyHeight - 10;
		var headHeight = $(".mdl13AlertWrap .head").height();
		var rowHeight = 109;
		var rowCount = $(".mdl13AlertWrap .content .row").length;
		var contentHeight = rowHeight*rowCount;
		var contentWrapHeight = contentHeight + headHeight;
		if(contentWrapHeight >= maxWrapHeight){
			contentWrapHeight = maxWrapHeight - headHeight;
		}else{
			contentWrapHeight = contentWrapHeight + 10;
		}
		var wrapHeight = contentWrapHeight + headHeight - 25;
		var top = (bodyHeight - wrapHeight)/2;
		
		$(".modalContent").css("height",wrapHeight);
		$(".mdl13AlertWrap").css("height",contentWrapHeight);
		$(".mdl13AlertWrap .content").css("height",contentWrapHeight - (headHeight + 10));
		$(".modalContent").css("top",top);
		
		$("#MDL13Alert").show();
	}
	
	function mdl13AlertClose(){
		mdl13AlertResult("1",[0,0,0]);
		
		$(".modalContent").removeAttr("style");
		$(".mdl13AlertWrap").removeAttr("style");
		$(".mdl13AlertWrap .content").removeAttr("style");
		
		$("#MDL13Alert").hide();
	}
	
	function reSaveData(){
		var selectList = [];
		var selectNotList = [];
		
		var $checkInput = $(".row").find("input:checked");
		if($checkInput.length > 0){
			$checkInput.each(function(){
				var rowNum = $(this).val();
				var row = failList[rowNum];
				selectList.push(new DataMap(row));
			});
			
			var $notCheckInput = $(".row").find("input:not(:checked)");
			if($notCheckInput.length > 0){
				$notCheckInput.each(function(){
					var rowNum = $(this).val();
					var row = failList[rowNum];
					selectNotList.push(new DataMap(row));
				});
			}
			
			var param = new DataMap();
			param.put("selectList",selectList);
			param.put("selectNotList",selectNotList);
			
			netUtil.send({
				url : "/mobile/json/SaveMDL13Re.data",
				param : param,
				successFunction : "succsessReSaveCallBack"
			});
		}else{
			mobileCommon.toast({
				type : "F",
				message : "선택된 데이터가 없습니다.",
				execute : function(){
					fail.play();
				}
			});
		}
	}
	
	function succsessReSaveCallBack(json, status){
		if(json && json.data){
			failList = [];
			
			var code = json.data["code"];
			var reqCount  = json.data["reqCount"];
			var succCount = json.data["succCount"];
			var failCount = json.data["failCount"];
			
			if(code == "S1"){
				mobileCommon.toast({
					type : "S",
					message : "재처리 완료 되었습니다.",
					execute : function(){
						success.play();
						mdl13AlertClose();
						searchData();
					}
				});
			}else if(code == "S2"){
				failList = json.data["failList"];
				mdl13AlertResult("2",[reqCount,succCount,failCount]);
				mdl13AlertOpen();
				
				mobileCommon.toast({
					type : "S",
					message : "재처리 완료 되었습니다.",
					execute : function(){
						success.play();
						searchData();
					}
				});
				
				drawFailList();
			}else if(code == "F1"){
				failList = json.data["failList"];
				mdl13AlertResult("2",[reqCount,succCount,failCount]);
				mdl13AlertOpen();
				searchData();
			}else if(code == "F2"){
				mobileCommon.toast({
					type : "F",
					message : "처리할 데이터가 없습니다.",
					execute : function(){
						
					}
				});
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
								<select id="SHPDGR" name="SHPDGR" ComboCodeView=false onchange="changeShpdgrEvent();">
									<option value="" CL="STD_SELECT"></option>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_WORKZO"></th>
							<td colspan="3">
								<select id="SHIT04" name="SHIT04">
									<option value="N" CL="STD_D13OP1"></option>
									<option value="Y" CL="STD_D13OP2"></option>
								</select>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_AREAKY"></th>
							<td colspan="2">
								<select id="AREAKY" name="AREAKY" Combo="WmsAdmin,AREACOMBO" ComboCodeView=false style="width: 55%" onchange="changeAreaCombo();">
									<option value="" CL="STD_ALL"></option>
								</select>
								<select id="ZONEKY" name="ZONEKY"  Combo="WmsAdmin,ZONECOMBO" ComboType="Combo,C" ComboCodeView=false style="width: 43%">
									<option value="" CL="STD_ALL"></option>
								</select>
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
							<th CL="STD_PRCQTY"></th>
							<td id="QTSHPO"></td>
						</tr>
						<tr>
							<th CL="STD_DESC01"></th>
							<td id="DESC01"></td>
						</tr>
					</tbody>
				</table>
				<table id="inputArea" style="margin-top: 10px;">
					<colgroup>
						<col width="60"/>
						<col width="140"/>
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_LOCAKY"></th>
							<td>
								<input type="text" name="LOCAKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'gridScanLocaky()')"/>
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
								<col width="40" />
								<col width="90" />
								<col width="60" />
								<col width="90" />
								<col width="150" />
								<col width="60" />
								<col width="60" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_SHMSTS"></th>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_QTJCMP"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_QTSIWH2"></th>
									<th CL="STD_PACKYN"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="40" />
								<col width="90" />
								<col width="60" />
								<col width="90" />
								<col width="150" />
								<col width="60" />
								<col width="60" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="icon,SHOD04" GB="n"></td>
									<td GCol="text,LOCAKY"></td>
									<td GCol="text,QTSHPO" GF="N 20,3"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01" style="text-align: left;"></td>
									<td GCol="text,QTSIWH" GF="N 20,3"></td>
									<td GCol="text,PACKYN"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">피킹완료</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="mobilePopArea">	
		<div class="modalWrap" id="MDL13Alert">
			<div class="modal">
				<div class="modalContent">
					<div class="text">
						<div class="mdl13AlertWrap">
							<div class="head">
								<ul>
									<li>■ <span id="t1">요청 건수</span> : <span id="v1">0</span> 건</li>
									<li>■ <span id="t2">피킹 완료</span> : <span id="v2">0</span> 건</li>
									<li>■ <span id="t3">주문 변경</span> : <span id="v3">0</span> 건</li>
								</ul>
							</div>
							<div class="content" id="failListArea">
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
								
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
								
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
								
								<ul class="row">
									<li class="num">
										<input type="checkbox">
									</li>
									<li class="col1">
										<ul>
											<li class="c1">로케이션</li>
											<li class="c2">W1A01A05</li>
										</ul>
									</li>
									<li class="col2">
										<ul>
											<li class="c1">상품명</li>
											<li class="c2">고당도)안동 사과(4~6입/봉)</li>
										</ul>
									</li>
									<li class="col1 pad">
										수량이 <span id="">1</span> -> <span id="">3</span> 으로 변경 되었습니다.
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="button">
						<button class="cancel btnWid2 btnBod2 btnAlinL" onclick="mdl13AlertClose();">
							<span>닫기</span>
						</button>
						<button class="confirm btnWid2 btnBod1 btnAlinR" onclick="reSaveData();">
							<span>재처리</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>