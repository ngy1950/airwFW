<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	$(document).ready(function(){
		mobileCommon.useSearchPad(true);
		
		mobileCommon.setOpenDetailButton({
			isUse : true,
			type : "grid",
			gridId : "gridList",
			detailId : "detail"
		});
		
		gridList.setGrid({
			id : "gridList",
			module : "Mobile",
			command : "DEMO_PICLOC",
			editable : false,
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		gridList.setGrid({
			id : "gridList2",
			module : "Mobile",
			command : "DEMO_STKKY",
			editable : false,
			emptyMsgType : false,
			gridMobileType : true
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SHZONEKY",
			name : "ZONEKY",
			returnCol : "ZONEKY",
			bindId : "searchArea",
			title : "ZONE 검색",
			inputType : "scan",
			searchType : "in", /* in,out */
			search :[
						{"type":"select","label":"STD_AREAKY","name":"AREAKY","combo":"WmsAdmin,AREACOMBO","codeView":false,"colspan":2},
						[
							{"type":"text","label":"STD_ZONEKY","name":"ZONEKY","uiFormat":"U 14"},
							{"type":"button","label":"none","id":"SHZONEKY_SEARCH","name":"BTN_DISPLAY","width":45}
						]
					],
			grid : [
						{"width":60, "label":"STD_ZONEKY","type":"text","col":"ZONEKY"},
						{"width":110,"label":"STD_SHORTX","type":"text","col":"ZONENM"}
					],
			module : "Mobile",
			command : "DEMO_ZONMA"
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "SHLOCAKY",
			name : "LOCAKY",
			returnCol : "LOCAKY",
			bindId : "searchArea",
			title : "로케이션 검색",
			inputType : "scan",
			searchType : "out", /* in,out */
			search :[
						{"type":"select","label":"STD_AREAKY","name":"AREAKY","combo":"WmsAdmin,AREACOMBO","codeView":false,"colspan":2},
						{"type":"text","label":"STD_ZONEKY","name":"ZONEKY","uiFormat":"U 14"}
					],
			grid : [
						{"width":110,"label":"STD_LOCAKY","type":"text","col":"LOCAKY"},
						{"width":110,"label":"STD_SHORTX","type":"text","col":"LOCANM"}
					],
			module : "Mobile",
			command : "DEMO_LOCMA"
		});
	});
	
	function searchOpenAfter(){
		//mobileCommon.select(null,"scanArea","SKUKEY");
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		
		if(layerId == "SHZONEKY_LAYER"){
			var data   = dataBind.paramData("searchArea");
			var areaky = data.get("AREAKY");
			
			param.put("AREAKY",areaky);
			
			dataBind.dataNameBind(param, "SHZONEKY_INNER_SEARCH");
			
			return param;
		}else if(layerId == "SHLOCAKY_LAYER"){
			var data   = dataBind.paramData("searchArea");
			var areaky = data.get("AREAKY");
			var zoneky = data.get("ZONEKY");
			
			if(isNull(zoneky)){
				fail.play();
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>존</span>을 스캔 또는 입력해 주세요.",
					confirm : function(){
						mobileCommon.select("","searchArea","ZONEKY");
					}
				});
				return false;
			}
			
			param.put("AREAKY",areaky);
			param.put("ZONEKY",zoneky);
			
			dataBind.dataNameBind(param, "SHLOCAKY_INNER_SEARCH");
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "SHZONEKY_LAYER"){
			dataBind.dataNameBind(data, "searchArea");
			var searchAreaData = dataBind.paramData("searchArea");
			var zoneky = searchAreaData.get("ZONEKY");
			if($.trim(zoneky) != ""){
				mobileCommon.select("", "searchArea", "LOCAKY");
			}
		}else if(layerId == "SHLOCAKY_LAYER"){
			dataBind.dataNameBind(data, "searchArea");
			var searchAreaData = dataBind.paramData("searchArea");
			var locaky = searchAreaData.get("LOCAKY");
			if($.trim(locaky) != ""){
				mobileCommon.select("", "searchArea", "SKUKEY");
			}
		}
	}
	
	function searchHelpUserButtonClickEvent(layerId,gridId,module,command,searchId,btnId){
		if(searchId == "SHZONEKY_INNER_SEARCH"){
			var param = dataBind.paramData(searchId);
			param.put("WAREKY","<%=wareky%>");
			
			gridList.gridList({
				id : gridId,
				param : param
			});
		}else if(searchId == "SHLOCAKY_INNER_SEARCH"){
			var param = dataBind.paramData(searchId);
			param.put("WAREKY","<%=wareky%>");
			
			gridList.gridList({
				id : gridId,
				param : param
			});
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		
		var param = new DataMap();
		if(comboAtt == "WmsAdmin,AREACOMBO"){
			param.put("WAREKY",wareky);
			return param;
		}
	}
	
	function searchData(){
		var param = dataBind.paramData("searchArea");
		param.put("WAREKY","<%=wareky%>");
		
		var zoneky = param.get("ZONEKY");
		if(isNull(zoneky)){
			fail.play();
			mobileCommon.alert({
				message : "<span class='msgColorBlack'>존</span>을 스캔 또는 입력해 주세요.",
				confirm : function(){
					mobileCommon.select("","searchArea","ZONEKY");
				}
			});
			return;
		}
		
		gridList.gridList({
			id : "gridList",
			param : param
		});
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList"){
			if(dataLength > 0){
				mobileCommon.setTotalViewCount();
				setTimeout(function(){
					mobileCommon.closeSearchArea();
				}, 100);
			}else{
				fail.play();
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다."
				});
				
				mobileCommon.setTotalViewCount();
			}
		}
	}
	
	function changeGridAndDetailAfter(type){
		if(type == "detail"){
			var gridCount = gridList.getGridDataCount("gridList");
			if(gridCount > 0){
				var rowNum = gridList.getFocusRowNum("gridList");
				if(rowNum < 0){
					rowNum = 0;
				}
				
				var param = gridList.getRowData("gridList", rowNum);
				gridList.gridList({
					id : "gridList2",
					param : param
				});
			}
		}else if(type == "grid"){
			gridList.resetGrid("gridList2");
		}
	}
	
	function gridDetailEventPrevView(gridId , rowNum ){
		if(gridId == "gridList" && rowNum > 0){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
				id : "gridList2",
				param : param
			});
		}
	}
	
	function gridDetailEventNextView(gridId , rowNum){
		if(gridId == "gridList" && rowNum > 0){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
				id : "gridList2",
				param : param
			});
		}
	}
	
	function saveData(){
		mobileCommon.toast({
			type : "S",
			message : "저장 버튼 클릭",
			execute : function(){
				
			}
		});
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				gridList.resetGrid("gridList");
				gridList.resetGrid("gridList2");
				mobileCommon.initSearch(null,true);
			}
		});
	}
	
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
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Search Area -->
		<div class="tem6_search">
			<div class="tem6_search_content">
				<table id="searchArea">
					<colgroup>
						<col width="70" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_AREAKY">창고</th>
							<td>
								<select id="AREAKY" name="AREAKY" Combo="WmsAdmin,AREACOMBO" UISave="false" ComboCodeView=false></select>
							</td>
						</tr>
						<tr>
							<th CL="STD_ZONEKY">존</th>
							<td>
								<input type="text" id="ZONEKY" name="ZONEKY" UIFormat="U 14"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_LOCAKY">로케이션</th>
							<td>
								<input type="text" id="LOCAKY" name="LOCAKY" UIFormat="U 14"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">상품코드</th>
							<td>
								<input type="text" name="SKUKEY" UIFormat="NS 14"/>
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
		</div>
		<!-- Content Area -->
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area"></div>
			<!-- Grid Area -->
			<div class="gridArea">
				<div class="tableWrap_search section">
					<div class="tableHeader">
						<table style="width: 100%">
							<colgroup>
								<col width="40" />
								<col width="70" />
								<col width="50" />
								<col width="90" />
								<col width="90" />
								<col width="250" />
								<col width="60" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th CL="STD_AREAKY"></th>
									<th CL="STD_ZONEKY"></th>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_LOTA06"></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="40" />
								<col width="70" />
								<col width="50" />
								<col width="90" />
								<col width="90" />
								<col width="250" />
								<col width="60" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol=rownum></td>
									<td GCol="text,AREANM"></td>
									<td GCol="text,ZONEKY"></td>
									<td GCol="text,LOCAKY"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01"></td>
									<td GCol="text,LT06NM"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Grid Bottom Area -->
				<div class="excuteArea">
					<div class="buttonArea">
						<button class="wid3 l" onclick="saveData();">저장</button>
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
									<th CL="STD_AREAKY"></th>
									<td>
										<input type="text" name="AREANM" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_ZONEKY"></th>
									<td>
										<input type="text" name="ZONEKY" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_LOCAKY"></th>
									<td>
										<input type="text" name="LOCAKY" readonly="readonly"/>
									</td>
								</tr>
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
								<tr>
									<th CL="STD_LOTA06"></th>
									<td>
										<input type="text" name="LT06NM" readonly="readonly"/>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="tableWrap_search section">
							<div class="tableHeader">
								<table style="width: 100%">
									<colgroup>
										<col width="100" />
										<col width="100" />
										<col width="100" />
									</colgroup>
									<thead>
										<tr>
											<th CL="STD_QTSIWH"></th>
											<th CL="STD_LOTA08"></th>
											<th CL="STD_LOTA09"></th>
										</tr>
									</thead>
								</table>
							</div>
							<div class="tableBody">
								<table style="width: 100%">
									<colgroup>
										<col width="100" />
										<col width="100" />
										<col width="100" />
									</colgroup>
									<tbody id="gridList2">
										<tr CGRow="true">
											<td GCol="text,QTSIWH" GF="N 20,3"></td>
											<td GCol="text,LOTA08" GF="D"></td>
											<td GCol="text,LOTA09" GF="D"></td>
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
									<button class="wid3 l" onclick="saveData();"><span>저장</span></button>
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