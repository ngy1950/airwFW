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
	var gridType = "grid";
	var isSave = false;
	
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
			module : "WmsTask",
			command : "MV02Sub",
			bindArea : "detail",
			emptyMsgType : false,
			gridMobileType : true
		});
		
		mobileSearchHelp.setSearchHelp({
			id : "TASKKY",
			name : "TASKKY",
			returnCol : "TASKKY",
			bindId : "scanArea",
			title : "작업번호 검색",
			inputType : "scanNumber",
			grid : [
						{"width":80,  "label":"STD_TASKKY", "type":"text", "col":"TASKKY"},
						{"width":150, "label":"STD_DOCTXT", "type":"text", "col":"DOCTXT"},
						{"width":80,  "label":"STD_DOCDAT", "type":"text", "col":"DOCDAT", "GF":"D"}
					],
			module  : "WmsTask",
			command : "MV02"
		});
		
		scanInput.setScanInput({
			id : "scanky",
			name : "SCANKY",
			bindId : "scanArea",
			type:"text"
		});
		
		mobileCommon.select("","scanArea","TASKKY");
	});
	
	function selectGridData(){
		var param = dataBind.paramData("scanArea");
		var value = param.get("SCANKY");
		
		var gridId = "gridList";
		var listLen = gridList.getGridDataCount(gridId);
		if(listLen > 0){
			var list = gridList.getGridData(gridId);
			
			var searchType = false;
			var data = new DataMap();
			
			var skuList = list.filter(function(element,index,array){
				return element.get("SKUKEY") == value;
			});
			if(skuList.length > 0){
				searchType = true;
				data = skuList[0];
			}
			
			var locList = list.filter(function(element,index,array){
				return element.get("LOCASR") == value;
			});
			if(locList.length > 0){
				searchType = true;
				data = locList[0];
			}
			
			if(searchType){
				var rowNum = data.get("GRowNum");
				gridList.setRowFocus(gridId,rowNum,true);
				
				setTimeout(function() {
					gridType =	"detail";
					parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
					mobileCommon.openDetail(gridType);
				});
			}else{
				fail.play();
				
				mobileCommon.alert({
					message : "지시되지 않은 상품 또는 로케이션 입니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
			}
		}else{
			fail.play();
			
			mobileCommon.alert({
				message : "검색된 데이터가 없습니다.\n<span class='msgColorBlack'>작업번호<span> 스캔 또는 입력 후에 진행해 주세요.",
				confirm : function(){
					mobileCommon.select("","scanArea","TASKKY");
				}
			});
		}
		
	}
	
	function searchData(){
		isSave = false;
		
		if(validate.check("scanArea")){
			var param = dataBind.paramData("scanArea");
			param.put("WAREKY","<%=wareky%>");
			
			var taskky = param.get("TASKKY");
			if(isNull(taskky)){
				fail.play();
				
				mobileCommon.alert({
					message : "<span class='msgColorBlack'>작업번호</span> 스캔 또는 입력 후에 진행해 주세요.",
					confirm : function(){
						mobileCommon.select("","scanArea","TASKKY");
					}
				});
				
				return;
			}
			
			netUtil.send({
				module : "WmsTask",
				command : "MV02",
				param : param,
				sendType : "list",
				successFunction : "searchHeadCallBack"
			});
		}
	}
	
	function searchHeadCallBack(json){
		if(json && json.data){
			if(json.data.length > 0){
				g_head = json.data;
				
				var param = dataBind.paramData("scanArea");
				gridList.gridList({
					id : "gridList",
					param : param
				});
			}else{
				fail.play();
				
				g_head = null;
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","TASKKY");
					}
				});
			}
		}
	}
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		if(layerId == "TASKKY_LAYER"){
			var data   = dataBind.paramData("scanArea");
			var tasoty = data.get("TASOTY");
			var statit = data.get("STATIT");
			
			param.put("TASOTY",tasoty);
			param.put("STATIT",statit);
			
			return param;
		}
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		if(layerId == "TASKKY_LAYER"){
			searchData();
			mobileCommon.select("","scanArea","SCANKY");
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			mobileCommon.setTotalViewCount();
			setTimeout(function(){
				mobileCommon.select("","scanArea","SCANKY");
			});
		}else if(gridId == "gridList" && dataLength == 0){
			g_head = null;
			
			gridType = "grid";
			
			parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
			mobileCommon.openDetail(gridType);
			
			mobileCommon.initBindArea("scanArea",["TASKKY","SCANKY"]);
			gridList.resetGrid("gridList");
			
			if(isSave){
				mobileCommon.alert({
					message : "재고 이동 작업이 모두 완료 되었습니다.",
					confirm : function(){
						mobileCommon.focus("","scanArea","TASKKY");
					}
				});
				
				isSave = false;
			}else{
				fail.play();
				
				mobileCommon.alert({
					message : "검색된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.focus("","scanArea","TASKKY");
					}
				});
			}
			
			mobileCommon.setTotalViewCount();
		}
	}
	
	function initPage(){
		mobileCommon.confirm({
			message : "초기화 하시겠습니까?",
			confirm : function(){
				g_head = null;
				
				gridType = "grid";
				
				parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
				mobileCommon.openDetail(gridType);
				
				mobileCommon.initBindArea("scanArea",["TASKKY","SCANKY"]);
				gridList.resetGrid("gridList");
				
				mobileCommon.focus("","scanArea","TASKKY");
			}
		});
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			if(gridType == "detail"){
				var rowNum = gridList.getFocusRowNum("gridList");
				gridList.setRowCheck("gridList",rowNum,true);
			}
			
			var list = gridList.getSelectData("gridList",true);
			if(list.length == 0){
				fail.play();
				
				mobileCommon.alert({
					message : "선택된 데이터가 없습니다.",
					confirm : function(){
						mobileCommon.select("","scanArea","SCANKY");
					}
				});
				return;
			}
			
			var skuList = list.filter(function(element,index,array){
				return commonUtil.parseInt(element.get("QTTAOR")) <= 0;
			});
			
			if(skuList.length > 0){
				fail.play();
				
				mobileCommon.alert({
					message : "이동 수량은 <span class='msgColorRed'>0</span> 이상의 수를 입력해야 합니다.",
					confirm : function(){
						if(gridType == "detail"){
							mobileCommon.select("","detail","QTTAOR");
						}else if(gridType == "grid"){
							var rowNum = skuList[0].get("GRowNum");
							gridList.setColFocus("gridList",rowNum,"QTTAOR");
						}
					}
				});
				
				return;
			}
			
			isSave = true;
			
			var param = new DataMap();
			param.put("head",g_head);
			param.put("list",list);
			param.put("MOBILE","TRUE");
			
			netUtil.send({
				url : "/wms/task/json/SaveMV02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data > 0){
				mobileCommon.toast({
					type : "S",
					message : "이동 완료 하였습니다.",
					execute : function(){
						success.play();
						
						gridType = "grid";
						
						parent.frames["topFrame"].contentWindow.changeOpenDetailButtonType(gridType);
						mobileCommon.openDetail(gridType);
						
						mobileCommon.initBindArea("scanArea",["SCANKY"]);
						
						gridList.resetGrid("gridList");
						
						var param = dataBind.paramData("scanArea");
						gridList.gridList({
							id : "gridList",
							param : param
						});
					}
				});
			}else{
				mobileCommon.toast({
					type : "F",
					message : "이동에 실패 하였습니다.",
					execute : function(){
						fail.play();
						mobileCommon.select("","scanArea","SCANKY");
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
		mobileCommon.select("","scanArea","SCANKY");
	}
	
	function changeGridAndDetailAfter(type){
		gridType = type;
		mobileCommon.select("","scanArea","SCANKY");
	}
	
	function numberKeyPadEnterEvent(){
		mobileCommon.select("","scanArea","SCANKY");
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
					<input type="hidden" name="MENUID" value="MMV05">
					<input type="hidden" name="TASOTY" value="321">
					<input type="hidden" name="STATIT" value="NEW">
					<colgroup>
						<col width="90" />
						<col />
					</colgroup>
					<tbody>
						<tr class="searchLine">
							<th CL="STD_TASKKY">작업번호</th>
							<td>
								<input type="text" id="TASKKY" name="TASKKY" UIFormat="NS 14" onkeypress="scanInput.enterKeyCheck(event, 'searchData()')"/>
							</td>
							<td style="width: 50px;">
								<button class="innerBtn" id="TASKKY_SEARCH" onclick="searchData();"><p cl="BTN_DISPLAY">조회</p></button>
							</td>
						</tr>
						<tr>
							<th>상품/로케이션</th>
							<td colspan="2">
								<input type="text" name="SCANKY" UIFormat="U 14" onkeypress="scanInput.enterKeyCheck(event, 'selectGridData()')"/>
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
								<col width="70" />
								<col width="90" />
								<col width="150" />
								<col width="70" />
								<col width="70" />
								<col width="80" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<tr>
									<th GBtnCheck="true"></th>
									<th CL="STD_LOCAKY"></th>
									<th CL="STD_SKUKEY"></th>
									<th CL="STD_DESC01"></th>
									<th CL="STD_MMVORD"></th>
									<th CL="STD_MMVQTY"></th>
									<th CL="STD_TOLOCA"></th>
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
								<col width="70" />
								<col width="90" />
								<col width="150" />
								<col width="70" />
								<col width="70" />
								<col width="80" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GCol="rowCheck"></td>
									<td GCol="text,LOCASR"></td>
									<td GCol="text,SKUKEY"></td>
									<td GCol="text,DESC01"></td>
									<td GCol="text,ORDQTY" GF="N 10"></td>
									<td GCol="input,QTTAOR" GF="N 10" validate="required"></td>
									<td GCol="text,LOCATG"></td>
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
						<button class="wid3 l" onclick="saveData();">이동완료</button>
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
									<th CL="STD_LOCAKY"></th>
									<td>
										<input type="text" name="LOCASR" readonly="readonly"/>
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
									<th CL="STD_ORDQTY"></th>
									<td>
										<input type="text" name="ORDQTY" UIFormat="N 10" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_MOVQTY"></th>
									<td>
										<input type="text" id="QTTAOR" name="QTTAOR" UIFormat="N 10" onkeypress="scanInput.enterKeyCheck(event, 'numberKeyPadEnterEvent()')"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_TOLOCA"></th>
									<td>
										<input type="text" id="LOCATG" name="LOCATG" readonly="readonly"/>
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
									<button class="wid3 l" onclick="saveData();"><span>이동완료</span></button>
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