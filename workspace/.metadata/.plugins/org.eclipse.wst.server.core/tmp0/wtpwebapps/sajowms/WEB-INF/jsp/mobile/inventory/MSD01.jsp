<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<style>
.scanTable{width: 100%;margin-top: 3px;box-sizing: border-box;}
.scanTable th{text-align: center !important;border: 1px solid #A9A9A9;background: #666;color: #fff;padding: 2px 0 2px 0;font-size: 80%;}
.scanTable td{border: 1px solid #A9A9A9;height: 30px !important;color: #666;font-size: 95%;font-weight: 600;}
.scanTable .hei{height: 20px !important;}
.scanTable td table{border: 0;}
.scanTable td table td{border: 0;height: 15px !important;}
.scanTable td table td.line{border-bottom: 1px solid #A9A9A9;border-right: 1px solid #A9A9A9;width: 75px;}
.thWid{width: 20%;}
.scanTableIn{color: #f04f4f !important;}
</style>
<script type="text/javascript">
	var g_head = null;
	var g_type = "sku";
	
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
			module : "WmsInventory",
			command : "SD01_LOT",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "skukey1",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			inputType : "scanNumber",
			buttonShow : false,
			photoView : true,
			grid : [
						{"width":70,  "label":"STD_GUBUN", "type":"text","col":"LT04NM"},
						{"width":90,  "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"}
					],
			module : "Mobile",
			command : "SKUINF"
			
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SHLOCAKY",
			name : "LOCAKY",
			returnCol : "LOCAKY",
			bindId : "scanArea",
			title : "로케이션 검색",
			inputType : "scan",
			searchType : "in", 
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "Mobile",
			command : "SKU_TO_LOCMA"
			
		});
		
		mobileCommon.select("","scanArea","SKUKEY");
		
		$(".scanTable").click(function(e){
			var type = $(e.target).attr("data-idx");
			skuInfTableClickEvt(type);
			
		});
	});
	
	function searchAfterFocusSkuInfTableEvt(){
		var type = "";
		
		var data = dataBind.paramData("scanArea");
		var locaky = data.get("LOCAKY");
		if(!isNull(locaky)){
			var avlLoc = commonUtil.replaceAll($("#AVLLOC").text(),"-","");
			var immLoc = commonUtil.replaceAll($("#IMMLOC").text(),"-","");
			
			switch (locaky) {
			case avlLoc:
				type = "01";
				break;
			case immLoc:
				type = "02";
				break;
			case "BAD":
				type = "04";
				break;
			case "RTN":
				type = "05";
				break;
			case "LOCK":
				type = "06";
				break;
			default:
				break;
			}
		}
		
		//if(type != ""){
		focusSkuInfTableEvt(type);
		//}
	}
	
	function focusSkuInfTableEvt(type){
		$(".scanTable").find("[data-idx]").removeClass("scanTableIn");
		$(".scanTable").find("[data-idx='"+type+"']").addClass("scanTableIn");
	}
	
	function skuInfTableClickEvt(type){
		var param = dataBind.paramData("scanArea");
		param.put("WAREKY","<%=wareky%>");
		param.put("MENUID","MSD01");
		
		var isSearch = false;
		switch (type) {
		case "00":
			isSearch = true;
			param.put("LOCAKY","");
			break;
		case "01":
			var avlstk = commonUtil.replaceAll($("#AVLSTK").text(),",","");
			var locaky = commonUtil.replaceAll($("#AVLLOC").text(),"-","");
			if(isNull(locaky)){
				fail.play();
				
				mobileCommon.alert({
					message : "등록된 [ 정상 ] 로케이션이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else if(avlstk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "[ 정상 ] 로케이션에 등록된 재고가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY",locaky);
			break;
		case "02":
			var immstk = commonUtil.replaceAll($("#IMMSTK").text(),",","");
			var locaky = commonUtil.replaceAll($("#IMMLOC").text(),"-","");
			if(isNull(locaky)){
				fail.play();
				
				mobileCommon.alert({
					message : "등록된 [ 임박 ] 로케이션이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else if(immstk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "[ 임박 ] 로케이션에 등록된 재고가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY",locaky);
			break;
		case "03":
			var qtspmo = commonUtil.replaceAll($("#QTSPMO").text(),",","");
			if(qtspmo == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "지시된 작업 수량이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY","");
			param.put("SCHTSK","TRUE");
			break;
		case "04":
			var badstk = commonUtil.replaceAll($("#BADSTK").text(),",","");
			if(badstk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "[ 폐기 ] 로케이션에 등록된 재고가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY","BAD");
			break;
		case "05":
			var rtnstk = commonUtil.replaceAll($("#RTNSTK").text(),",","");
			if(rtnstk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "[ 반품 ] 로케이션에 등록된 재고가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY","RTN");
			break;
		case "06":
			var hldstk = commonUtil.replaceAll($("#HLDSTK").text(),",","");
			if(hldstk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "[ 보류 ] 로케이션에 등록된 재고가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY","");
			break;
		case "07":
			var unustk = commonUtil.replaceAll($("#UNUSTK").text(),",","");
			if(unustk == "0"){
				fail.play();
				
				mobileCommon.alert({
					message : "불용 수량이 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
			}else{
				isSearch = true;
			}
			param.put("LOCAKY","");
			param.put("SCHUSK","TRUE");
			break;	
		default:
			break;
		}
		
		if(isSearch){
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
			
			mobileCommon.focus("","scanArea","LOCAKY");
			
			focusSkuInfTableEvt(type)
			
			gridList.resetGrid("gridList");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}else{
			mobileCommon.select("","scanArea","LOCAKY");
		}
	}
	
	function getSkuInfData(){
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
						initData("ALL");
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				
				return;
			}else if(json.data.length == 1){
				var data = new DataMap();
				data.putObject(json.data[0]);
				
				dataBind.dataBind(data, area);
				dataBind.dataNameBind(data, area);
				
				searchData();
				
				mobileCommon.select("","scanArea","LOCAKY");
			}else{
				mobileSearchHelp.selectSearchHelp("skukey1");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("MENUID","MSD01");
			
			var skukey = param.get("SKUKEY");
			var locaky = param.get("LOCAKY");
			
			if(!isNull(locaky)){
				var json = netUtil.sendData({
					module : "Mobile",
					command : "LOCINF",
					param : param,	
					sendType : "list"
				});
					
				if(json && json.data){
					if(json.data.length > 0){
						if(json.data[0]["CNT"] > 0){
							if(json.data[1]["CNT"] > 0){
								if(isNull(skukey)){
									fail.play();
									
									mobileCommon.alert({
										message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해주세요.",
										confirm : function(){
											mobileCommon.select("","scanArea","SKUKEY");
										}
									});
									
									return;
								}
							}
						}else{
							fail.play();
							
							mobileCommon.alert({
								message : "존재하지 않는  <span class='msgColorBlack'>로케이션</span> 입니다.",
								confirm : function(){
									mobileCommon.focus("","scanArea","LOCAKY");
								}
							});
							
							return;
						}
					}
				}
			}else{
				if(isNull(skukey)){
					fail.play();
					
					mobileCommon.alert({
						message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해주세요.",
						confirm : function(){
							mobileCommon.select("","scanArea","SKUKEY");
						}
					});
					
					return;
				}
			}
			
			gridList.resetGrid("gridList");
			
			searchAfterFocusSkuInfTableEvt();
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function searchSkuInf(){
		var param = dataBind.paramData("scanArea");
		param.put("WAREKY","<%=wareky%>");
		param.put("MENUID","MSD01");
		
		var json1 = netUtil.sendData({
			module : "Mobile",
			command : "SKU_TO_AREA",
			param : param,
			sendType : "list"
		});
			
		if(json1 && json1.data){
			var data = json1.data;
			if(data.length > 0){
				var noTxt = "-";
				
				$("#AVLLOC").html(noTxt);
				$("#AVLARE").html(noTxt);
				$("#IMMLOC").html(noTxt);
				$("#IMMARE").html(noTxt);
				
				var $obj = $("#scanArea");
				
				for(var i = 0; i < data.length; i++){
					var row = data[i];
				
					var lota06 = row["LOTA06"];
					var locanm = row["LOCANM"];
					var areanm = row["AREANM"];
					
					if(lota06 == "00"){
						$("#AVLLOC").html(locanm);
						$("#AVLARE").html(areanm);
					}
					
					if(lota06 == "10"){
						$("#IMMLOC").html(locanm);
						$("#IMMARE").html(areanm);
					}
				}
			}
		}
		
		var json2 = netUtil.sendData({
			module : "Mobile",
			command : "SKU_TO_STKKY",
			param : param,
			sendType : "list"
		});
			
		if(json2 && json2.data){
			var data = json2.data;
			if(data.length > 0){
				var row = data[0];
				
				var QTSIWH = mobileCommon.numberComma(row["QTSIWH"]);
				var QTSPMO = mobileCommon.numberComma(row["QTSPMO"]);
				var AVLSTK = mobileCommon.numberComma(row["AVLSTK"]);
				var IMMSTK = mobileCommon.numberComma(row["IMMSTK"]);
				var BADSTK = mobileCommon.numberComma(row["BADSTK"]);
				var RTNSTK = mobileCommon.numberComma(row["RTNSTK"]);
				var HLDSTK = mobileCommon.numberComma(row["HLDSTK"]);
				var UNUSTK = mobileCommon.numberComma(row["UNUSTK"]);
				
				if(QTSIWH == "0" && QTSPMO == "0" && AVLSTK == "0" && IMMSTK == "0" 
						&& BADSTK == "0" && RTNSTK == "0" && HLDSTK == "0" && UNUSTK == "0"){
					fail.play();
					
					mobileCommon.alert({
						message : "검색된 데이터가 없습니다.",
						confirm : function(){
							initData("ALL");
							mobileCommon.focus("","scanArea","SKUKEY");
						}
					});
					
					return;
				}
				
				$("#QTSIWH").html(QTSIWH);
				$("#QTSPMO").html(QTSPMO);
				$("#AVLSTK").html(AVLSTK);
				$("#IMMSTK").html(IMMSTK);
				$("#BADSTK").html(BADSTK);
				$("#RTNSTK").html(RTNSTK);
				$("#HLDSTK").html(HLDSTK);
				$("#UNUSTK").html(UNUSTK);
			}else{
				fail.play();
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.focus("","scanArea","SKUKEY");
					}
				});
			}
		}
	}
	
	function searchHelpUserButtonClickEvent(layerId,gridId,module,command,searchId,btnId){
		if(searchId == "SHLOCKY_INNER_SEARCH"){
			var data = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			var param = dataBind.paramData(searchId);
			param.put("WAREKY","<%=wareky%>");
			param.put("SKUKEY",skukey);
			
			gridList.gridList({
				id : gridId,
				param : param
			});
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		
		if(layerId == "skukey1_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			param.put("SKUKEY",skukey);
			
			return param;
		}else if(layerId == "SHLOCAKY_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			if(skukey == undefined ||  skukey == null || $.trim(skukey) == ""){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>상품코드</span>를 입력해주세요.",
					confirm : function(){
						mobileCommon.select("",bindId,"SKUKEY");
					}
				});
				return false;
			}
			param.put("SKUKEY",skukey);
			
			var json = netUtil.sendData({
				module : "Mobile",
				command : "SKU_TO_LOCMA_COUNT",
				param : param,	
				sendType : "map"
			});
			
			if(json && json.data){
				if(json.data["CNT"] == 0){
					fail.play();
					
					mobileCommon.alert({
						message : "검색된 데이터가 없습니다.",
						confirm : function(){
							mobileCommon.focus("",bindId,"LOCAKY");
						}
					});
					return false;
				}
			}
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "skukey1_LAYER"){
			g_type = "sku";
			searchData();
			mobileCommon.select("","scanArea","LOCAKY");
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			mobileCommon.setTotalViewCount();
			
			var data = new DataMap();
			data.put("SKUKEY",gridList.getColData(gridId, 0, "SKUKEY"));
			data.put("DESC01",gridList.getColData(gridId, 0, "DESC01"));
			
			dataBind.dataBind(data, "scanArea");
			dataBind.dataNameBind(data, "scanArea");
			
			searchSkuInf();
			
			setTimeout(function(){
				mobileCommon.closeSearchArea();
				mobileCommon.select("","scanArea","LOCAKY");
			}, 100);
		}else if(gridId == "gridList" && dataLength == 0){
			searchSkuInf();
			mobileCommon.setTotalViewCount();
		}
		
		if(gridId == "SHLOCAKY_LIST" && dataLength > 0){
			setTimeout(function(){
				mobileCommon.closeSearchArea("SHLOCAKY_LAYER");
			}, 100);
		}else if(gridId == "SHLOCAKY_LIST" && dataLength == 0){
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.focus("","SHLOCAKY_INNER_SEARCH","LOCAKY");
				}
			});
		}
	}
	
	function initSkuInf(){
		var noTxt = "-";
		
		$("#AVLLOC").html(noTxt);
		$("#AVLARE").html(noTxt);
		$("#IMMLOC").html(noTxt);
		$("#IMMARE").html(noTxt);
		
		$("#QTSIWH").html(0);
		$("#QTSPMO").html(0);
		$("#AVLSTK").html(0);
		$("#IMMSTK").html(0);
		$("#BADSTK").html(0);
		$("#RTNSTK").html(0);
		$("#HLDSTK").html(0);
		$("#UNUSTK").html(0);
		
		$(".scanTable").find("[data-idx]").removeClass("scanTableIn");
	}
	
	function initData(type){
		if(type == "ALL"){
			initSkuInf();
		}
		mobileCommon.initSearch(null,true);
		gridList.resetGrid("gridList");
		mobileCommon.focus("","scanArea","SKUKEY");
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				initData("ALL");
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
	}
	
	function closeKeyPadAfterEvent(areaId,name,value,$Obj){
		mobileCommon.select("","scanArea","LOCAKY");
	}
	
	function changeGridAndDetailAfter(type){
		mobileCommon.select("","scanArea","LOCAKY");
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
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_SKUKEY">상품코드</th>
							<td colspan="2">
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
							</td>
						</tr>
						<tr class="searchLine">
							<th CL="STD_LOCAKY">로케이션</th>
							<td>
								<input type="text" id="LOCAKY" name="LOCAKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td style="width: 50px;">
								<button class="innerBtn" id="SHLOCKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUINF">상품</th>
							<td colspan="2">
								<input type="text" name="DESC01" readonly="readonly"/>
							</td>
						</tr>
					</tbody>
				</table>
				<table class="scanTable">
					<tr>
						<th class="thWid" data-idx="00">재고</th>
						<th data-idx="01">정상</th>
						<th data-idx="02">임박</th>
					</tr>
					<tr>
						<td id="QTSIWH" data-idx="00">0</td>
						<td>
							<table>
								<tr>
									<td class="line" id="AVLLOC" data-idx="01">-</td>
									<td rowspan="2"  id="AVLSTK" data-idx="01">0</td>
								</tr>
								<tr>
									<td id="AVLARE" data-idx="01">-</td>
								</tr>
							</table>
						</td>
						<td>
							<table>
								<tr>
									<td class="line" id="IMMLOC" data-idx="02">-</td>
									<td rowspan="2"  id="IMMSTK" data-idx="02">0</td>
								</tr>
								<tr>
									<td id="IMMARE" data-idx="02">-</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table class="scanTable">
					<tr>
						<th data-idx="03">작업</th>
						<th data-idx="04">폐기</th>
						<th data-idx="05">반품</th>
						<th data-idx="06">보류</th>
						<th data-idx="07">불용</th>
					</tr>
					<tr>
						<td class="hei" id="QTSPMO" data-idx="03">0</td>
						<td class="hei" id="BADSTK" data-idx="04">0</td>
						<td class="hei" id="RTNSTK" data-idx="05">0</td>
						<td class="hei" id="HLDSTK" data-idx="06">0</td>
						<td class="hei" id="UNUSTK" data-idx="07">0</td>
					</tr>
				</table>
			</div>
			<!-- Grid Area -->
			<div class="gridArea">
				<div class="tableWrap_search section">
					<div class="tableHeader">
						<table style="width: 100%">
							<colgroup>
								<col width="80" />
								<col width="50" />
								<col width="60" />
								<col width="60" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th CL="STD_LOCAKY"></th>
									<th>상태</th>
									<th>재고</th>
									<th>작업</th>
									<th CL="STD_LOTA08"></th>
									<th CL="STD_LOTA09"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="80" />
								<col width="50" />
								<col width="60" />
								<col width="60" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="text,LOCANM"></td>
									<td GCol="text,LT06NM"></td>
									<td GCol="text,QTSIWH" GF="N 10"></td>
									<td GCol="text,QTSPMO" GF="N 10"></td>
									<td GCol="text,LOTA08" GF="D"></td>
									<td GCol="text,LOTA09" GF="D"></td>
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
									<th CL="STD_LOCAKY"></th>
									<td>
										<input type="text" name="LOCANM" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA06"></th>
									<td>
										<input type="text" name="LT06NM" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_QTSIWH"></th>
									<td>
										<input type="text" name="QTSIWH" UIFormat="N 10" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_QTTAOR"></th>
									<td>
										<input type="text" name="QTSPMO" UIFormat="N 10" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA08"></th>
									<td>
										<input type="text" name="LOTA08" UIFormat="D" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA09"></th>
									<td>
										<input type="text" name="LOTA09" UIFormat="D" readonly="readonly"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Detail Button Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<div class="button">
							<ul>
								<li class="prev"><p></p></li>
								<li class="btn">
									<button class="wid1 btnBgG" onclick="initPage();"><span>초기화</span></button>
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