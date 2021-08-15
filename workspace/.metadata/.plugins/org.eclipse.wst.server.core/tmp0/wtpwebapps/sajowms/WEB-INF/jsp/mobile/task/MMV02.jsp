<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	var g_head = null;
	
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
			module : "WmsTask",
			command : "MV01Sub",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		/* scanInput.setScanInput({
			id : "skukey1",
			name : "SKUKEY",
			bindId : "scanArea",
			type:"number"
		}); */
		
		/* mobileDatePicker.setDatePicker({
			id : "date1",
			name : "DATE",
			bindId : "searchArea"
		}); */
		
		 /* mobileDatePicker.setDatePicker({
			id : "date2",
			name : "LOTA08",
			bindId : "detail",
			gridId : "gridList"
		}); */
		
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
			searchType : "in", /* in,out */
			/* search :[
						{"type":"text",  "label":"STD_SKUKEY","name":"SKUKEY","uiFormat":"NS 14","colspan":2},
						{"type":"text",  "label":"STD_LOCAKY","name":"LOCAKY","colspan":2}, 
						{"type":"select","label":"STD_BOXTYP","name":"BOXTYP","combo":"Common,COMCOMBO","codeView":false,"colspan":2},
						{"type":"select","label":"STD_LOTA06","name":"LOTA06","combo":"LOTA06","colspan":2}, 
						[
							{"type":"text","label":"STD_LOCAKY","name":"LOCAKY","uiFormat":"U 14"},
							{"type":"button","label":"none","id":"SHLOCKAY_SEARCH","name":"BTN_DISPLAY","width":45}
						]
					], */
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "Mobile",
			command : "SKU_TO_LOCMA"
			
		});
		
		/* mobileSearchHelp.setSearchHelp({
			id : "SHLOCKY",
			name : "LOCAKY",
			returnCol : "LOCAKY",
			bindId : "scanArea",
			title : "로케이션 검색",
			inputType : "scan",
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "WmsTask",
			command : "MV01_LOCMA_POP"
			
		}); */
		
		mobileSearchHelp.setSearchHelp({
			id : "SHLOCATG",
			name : "LOCATG",
			returnCol : "LOCAKY",
			bindId : "scanArea",
			inputType : "scan",
			title : "로케이션 검색",
			grid : [
						{"width":60, "label":"STD_AREAKY","type":"text","col":"AREANM"},
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"SHORTX"},
						{"width":70, "label":"STD_LOTA06","type":"text","col":"LT06NM"},
						{"width":70, "label":"STD_INDUPK","type":"icon","col":"INDUPK"}
					],
			module : "WmsTask",
			command : "MV01_LOCMA_POP"
		});
		
		mobileCommon.select("","scanArea","SKUKEY");
	});
	
	function searchOpenAfter(){
		mobileCommon.select(null,"scanArea","SKUKEY");
	}
	
	function getSkuInfData(){
		mobileCommon.initBindArea("scanArea",["LOCAKY","DESC01","LOCATG"]);
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
				
				mobileCommon.select("","scanArea","LOCAKY");
			}else{
				mobileSearchHelp.selectSearchHelp("skukey1");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			mobileCommon.initBindArea("scanArea",["DESC01","LOCATG"]);
			gridList.resetGrid("gridList");
			
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("TASOTY","320");
			
			var skukey = param.get("SKUKEY");
			var locaky = param.get("LOCAKY");
			if(isNull(locaky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>로케이션</span>을 스캔 또는 입력해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
				
				return;
			}
			
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
			
			netUtil.send({
				module : "WmsTask",
				command : "MV01",
				param : param,
				sendType : "list",
				successFunction : "searchHeadCallBack"
			});
		}
	}
	
	function searchHeadCallBack(json){
		if(json && json.data){
			if(json.data.length > 0){
				g_head = json.data[0];
				
				var param = dataBind.paramData("scanArea");
				param.put("WAREKY","<%=wareky%>");
				param.put("MOBILE","TRUE");
				
				gridList.gridList({
					id : "gridList",
					param : param
				});
			}else{
				g_head = null;
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
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
							mobileCommon.focus(skukey,bindId,"SKUKEY");
						}
					});
					return false;
				}
			}
			
			return param;
		}else if(layerId == "SHLOCATG_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			var locaky = data.get("LOCAKY");
			if(skukey == undefined ||  skukey == null || $.trim(skukey) == ""){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>상품코드</span>를 입력해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				
				//mobileCommon.openSearchArea();
				
				return false;
			}
			
			if(isNull(locaky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>로케이션</span>을 스캔 또는 입력해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
				
				return false;
			}
			
			param.put("MOBILE","TRUE");
			param.put("SKUKEY",skukey);
			param.put("LOCAKY",locaky);
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "skukey1_LAYER"){
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
			
			setTimeout(function(){
				mobileCommon.closeSearchArea();
				mobileCommon.select("","scanArea","LOCATG");
			}, 100);
		}else if(gridId == "gridList" && dataLength == 0){
			fail.play();
			
			mobileCommon.initSearch(null,true);
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.focus("","scanArea","LOCAKY");
				}
			});
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
	
	function saveData(type){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridList");
			if(list.length == 0){
				fail.play();
				if(type == 0){
					mobileCommon.toast({
						type : "W",
						message : "이동할 데이터 선택 후, <span class='msgColorRed'>[ 이동완료 ]</span> 버튼을 눌러주세요.",
						execute : function(){
							mobileCommon.select("","scanArea","LOCATG");
						}
					});
				}else{
					mobileCommon.alert({
						message : "선택된 데이터가 없습니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","LOCATG");
						}
					});
				}
				return;
			}
			
			var data = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			var locatg = data.get("LOCATG");
			var locaky = data.get("LOCAKY");
			
			data.put("WAREKY","<%=wareky%>");
			data.put("LOTA_STATUS","03");
			
			var sumQty = 0;
			for(var i = 0; i < list.length; i++){
				var QTSIWH = commonUtil.parseInt(list[i].get("QTSIWH"));
				var QTTAOR = commonUtil.parseInt(list[i].get("QTTAOR"));
				if(QTSIWH < QTTAOR){
					mobileCommon.alert({
						message : "이동 수량이 재고수량 보다 클 수 없습니다.",
						confirm : function(){
							mobileCommon.select("","scanArea","LOCAKY");
						}
					});
					return;
				}
				if(QTTAOR == 0){
					mobileCommon.alert({
						message : "이동 수량은 <span class='msgColorRed'>0</span> 보다 커야 합니다.",
						confirm : function(){
							var rowNum = gridList.getFocusRowNum("gridList");
							gridList.setColFocus("gridList",rowNum,"QTTAOR");
						}
					});
					return;
				}
				sumQty = sumQty + QTTAOR;
			}
			
			data.put("SUMQTY",sumQty);
			data.put("CHKCNT","1");
			
			if($.trim(skukey) == ""){
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>상품코드</span>를 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				return;
			}
			
			if($.trim(locaky) == ""){
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>로케이션</span>을 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCAKY");
					}
				});
				return;
			}
			
			if($.trim(locatg) == ""){
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>TO로케이션</span>을 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCATG");
					}
				});
				return;
			}
			
			if(locatg == locaky){
				mobileCommon.alert({
					message : "같은 로케이션으로 이동 할 수 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCATG");
					}
				});
				return;
			}
			
			if((gridList.getColData("gridList",0,"LOCASR") != locaky)
					|| (gridList.getColData("gridList",0,"SKUKEY") != skukey)){
				mobileCommon.alert({
					message : "검색 조건이 변경 되었습니다.\n<span class='msgColorRed'>*</span>재조회 후 다시 진행해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				return;
			}
			
			var json = netUtil.sendData({
				url : "/wms/task/json/checkMV01PickLocation.data",
				param : data
			});
			
			if(json && json.data){
				var msg = "이동 완료 하시겠습니까?";
				var result = json.data["result"];
				if(result == "C1" || result == "C2"){
					msg = json.data["msg"];
				}
				
				mobileCommon.confirm({
					message : msg,
					confirm : function(){
						var lotaStauts = data.get("LOTA_STATUS");
						
						var head = new DataMap(g_head);
						head.put("MOBILE","TRUE");
						
						var param = new DataMap();
						param.put("head",head);
						param.put("list",list);
						
						param.put("SKUKEY",skukey);
						param.put("LOCAKY",locaky);
						param.put("LOCATG",locatg);
						param.put("SUMQTY",sumQty);
						param.put("CHKCNT","2");
						param.put("LOTA_STATUS",lotaStauts);
						
						netUtil.send({
							url : "/wms/task/json/SaveMV01.data",
							param : param,
							successFunction : "succsessSaveCallBack"
						});
					}
				});
			}
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
						
						g_head = new DataMap();
						mobileCommon.initSearch(null,false);
						gridList.resetGrid("gridList");
						mobileCommon.select("","scanArea","SKUKEY");
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
		if(gridId == "SHLOCATG_LIST"){
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
		//mobileCommon.select("","scanArea","LOCATG");
	}
	
	function changeGridAndDetailAfter(type){
		//mobileCommon.select("","scanArea","LOCATG");
	}
	
	<%-- function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "Common,COMCOMBO" ){
			var selectName = paramName[0].name;
			param.put("WARECODE","Y");
			param.put("WAREKY","<%=wareky%>");
			if(selectName == "BOXTYP"){
				param.put("USARG1", "V");
				param.put("CODE", "BOXTYP");
			}
			return param;
		}
	} --%>
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Search Area -->
		<!-- <div class="tem6_search">
			<div class="tem6_search_content">
				<table id="searchArea">
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_MOVTYP">이동유형</th>
							<td colspan="2">
								<select name="MOVTYP">
									<option value="00">일반</option>
									<option value="01">폐기이동</option>
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">상품코드</th>
							<td>
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_LOCAKY">로케이션</th>
							<td>
								<input type="text" id="LOCAKY" name="LOCAKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="search_btn_area">
					<button class="search_btn" CL="BTN_SEARCH" onclick="searchData();">조회</button>
				</div>
			</div>
			<div class="tem6_search_btn">
				<p class="left_line"></p>
				<p class="arrow"></p>
				<p class="right_line"></p>
			</div>
		</div> -->
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
						<tr>
							<th CL="STD_TOLOCA">TO로케이션</th>
							<td colspan="2">
								<input type="text" name="LOCATG" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event,'saveData(0)')"/>
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
								<col width="50" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_PRCQTY"></th>
									<th CL="STD_MMVQTY"></th>
									<th CL="STD_LOTA09"></th>
									<th CL="STD_LOTA08"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30" />
								<col width="50" />
								<col width="50" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="text,QTSIWH"  GF="N 10"></td>
									<td GCol="input,QTTAOR" GF="N 10" validate="required"></td>
									<td GCol="text,LOTA09"  GF="D"></td>
									<td GCol="text,LOTA08"  GF="D"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData(1);">이동완료</button>
						<button class="wid3 r btnBgW" onclick="initPage();">초기화</button>
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
									<th CL="STD_QTSIWH"></th>
									<td>
										<input type="text" name="QTSIWH" UIFormat="N 10" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_PRCQTY"></th>
									<td>
										<input type="text" id="PRCQTY" name="PRCQTY" UIFormat="N 10"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA09"></th>
									<td>
										<input type="text" name="LOTA09" UIFormat="D" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOTA08"></th>
									<td>
										<input type="text" name="LOTA08" UIFormat="D" readonly="readonly"/>
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
									<button class="wid3 l" onclick="saveData(1);"><span>이동완료</span></button>
									<button class="wid3 l btnBgW" onclick="initPage();"><span>초기화</span></button>
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