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
	var g_locaky = "";
	
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({
			isUse : false
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
		
		mobileSearchHelp.setSearchHelp({
			id : "skukey1",
			name : "SKUKEY",
			returnCol : "SKUKEY",
			bindId : "scanArea",
			title : "상품 검색",
			inputType : "scanNumber",
			buttonShow : false,
			grid : [
						{"width":70, "label":"STD_GUBUN","type":"text","col":"LT04NM"},
						{"width":90, "label":"STD_SKUKEY","type":"text","col":"SKUKEY"},
						{"width":150, "label":"STD_DESC01","type":"text","col":"DESC01"},
					],
			module : "Mobile",
			command : "SKUINF"
		});
		
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
		mobileCommon.initBindArea("scanArea",["DESC01","LOCATG"]);
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
				
				searchData();
				
				mobileCommon.select("","scanArea","LOCATG");
			}else{
				mobileSearchHelp.selectSearchHelp("skukey1");
			}
		}
	}
	
	function searchData(){
		if(validate.check("scanArea")){
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			param.put("TASOTY","320");
			
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
				param.put("MENUID","MMV03");
				
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
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		if(layerId == "skukey1_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			
			param.put("SKUKEY",skukey);
			
			return param;
		}else if(layerId == "SHLOCATG_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var skukey = data.get("SKUKEY");
			if(skukey == undefined ||  skukey == null || $.trim(skukey) == ""){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>상품코드</span>를 입력해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				
				return false;
			}
			
			if(isNull(g_locaky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>로케이션</span>을 스캔 또는 입력해주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","SKUKEY");
					}
				});
				
				return false;
			}
			
			param.put("MOBILE","TRUE");
			param.put("SKUKEY",skukey);
			param.put("LOCAKY",g_locaky);
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "skukey1_LAYER"){
			searchData();
			mobileCommon.select("","scanArea","LOCAKY");
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			var data = new DataMap();
			data.put("SKUKEY",gridList.getColData(gridId, 0, "SKUKEY"));
			data.put("DESC01",gridList.getColData(gridId, 0, "DESC01"));
			
			dataBind.dataBind(data, "scanArea");
			dataBind.dataNameBind(data, "scanArea");
			
			g_locaky = gridList.getColData(gridId,0,"LOCASR");
			
			setTimeout(function(){
				mobileCommon.select("","scanArea","LOCATG");
			}, 100);
		}else if(gridId == "gridList" && dataLength == 0){
			fail.play();
			
			mobileCommon.initSearch(null,true);
			
			g_locaky = "";
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.",
				confirm : function(){
					mobileCommon.focus("","scanArea","SKUKEY");
				}
			});
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
			
			data.put("WAREKY","<%=wareky%>");
			data.put("LOCAKY",g_locaky);
			data.put("LOTA_STATUS","00");
			
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
			
			if($.trim(locatg) == ""){
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>TO로케이션</span>을 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCATG");
					}
				});
				return;
			}
			
			if(locatg == g_locaky){
				mobileCommon.alert({
					message : "같은 로케이션으로 이동 할 수 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","LOCATG");
					}
				});
				return;
			}
			
			if((gridList.getColData("gridList",0,"LOCASR") != g_locaky)
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
						
						param.put("LOCAKY",g_locaky);
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
						<tr class="searchLine">
							<th CL="STD_SKUKEY">상품코드</th>
							<td colspan="2">
								<input type="text" name="SKUKEY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'getSkuInfData()')"/>
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
		</div>
	</div>
	<%@ include file="/common/include/mobileBottom.jsp" %>
</body>