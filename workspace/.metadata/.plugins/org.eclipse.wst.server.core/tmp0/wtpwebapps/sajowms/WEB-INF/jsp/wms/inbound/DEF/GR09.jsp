<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "200px";
	var todayDate;
	
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInbound",
			command : "GR09H",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInbound",
			command : "GR09I",
			autoCopyRowType : false,
			headGrid : "gridHeadList",
			totalCols : ["PRCQTY","VIEWCNL","QTADJU"]
		});
		
		date();
	});
	
	//오늘날짜
	function date(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "Save" ){ //입고취소
			saveData();
			//8801117671105
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("ASNTYP", $.trim(param.get("ASNTYP")));
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
	}
	
	//저장
	function saveData(){
		var head = gridList.getSelectData("gridHeadList", "A");
		var item = gridList.getSelectData("gridItemList", "A");
		var headLen = head.length;
		var itemLen = item.length;
		
		if( headLen > 1 ){
			commonUtil.msgBox("IN_M0007"); //한 개의 센터를 선택해주세요.
			return;
			
		}else if( itemLen == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		if( gridList.validationCheck("gridItemList", "select") ){
			if( !commonUtil.msgConfirm("IN_M0030") ){ //입고취소 하시겠습니까?
				return false;
			}
		}else{
			return false;
		}
		
		var param = new DataMap();
		param.put("head", head);
		param.put("item", item);
		param.put("ADJUTY", "480");
		param.put("proId", "GR09");
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR09.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			var data = json.data;
			
			if( data ){
				alert("저장에 성공하였습니다.");
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				searchList();
				
			}else if( !data ){
				commonUtil.msgBox("MASTER_M0101"); //저장에 실패 하였습니다. 관리자에게 문의 하세요. 내역:[{0}]
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var ItemData = gridList.getRowData(gridId, rowNum);
		
		if( gridId == "gridItemList" ){
			if( colName == "PRCUOM" ){//////////////////////////////////////단위////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
				gridList.setColValue(gridId, rowNum, "QTADJU", 0); //취소수량
				
			}else if( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
				
				var NumColValue = Number(colValue);
				var viewcnl = Number(ItemData.get("VIEWCNL")); //취소가능 (낱개) 수량
				var prcuom = ItemData.get("PRCUOM"); //단위
				
				//음수 입력 불가
				if( NumColValue <= 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량 계산
				if( prcuom == "EA" ){
					if( NumColValue > viewcnl ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTADJU", NumColValue); //취소수량
					
				}else if( prcuom == "CS" ){//박스
					var csQty = Number(ItemData.get("BOXQTY")) * NumColValue;
					if( csQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( csQty > viewcnl ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTADJU", csQty); //취소수량
					
				}else if( prcuom == "IP" ){ //이너팩
					var ipQty = Number(ItemData.get("INPQTY")) * NumColValue;
					if( ipQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( ipQty > viewcnl ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTADJU", ipQty); //취소수량
					
				}else if( prcuom == "PL" ){ //팔레트
					var plQty = Number(ItemData.get("PALQTY")) * NumColValue;
					if( plQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( plQty > viewcnl ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTADJU", plQty); //취소수량
				}
			}
		}
	}
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
		gridList.setColValue(gridId, rowNum, "QTADJU", "0");
		
		if(select == "N"){
			commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다
			
		}else if( select == "S" ){
			commonUtil.msgBox("IN_M0029"); //수량(낱개)은 취소가능수량(낱개) 갯수보다 클 수 없습니다.
		}
	}
	
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			
		}else if( gridId == "gridItemList" && dataLength > 0 ){
			
			// 그리드 로우 리드온리
			for( var i=0; i<dataLength; i++ ){
				var rowData = gridList.getRowData(gridId, i);
				var viewcnl = Number(rowData.get("VIEWCNL")); //취소가능수량(낱개)
				var rcptty = rowData.get("RCPTTY"); //입고유형
				
				// 취소가능 갯수가 0이면 수정 불가
				if( viewcnl == 0 || rcptty == "105" ){
					gridList.setRowReadOnly(gridId, i, true, ["PRCQTY", "PRCUOM"]);
					
				}
				
			}
		}
	}
	
	// 취소완료된건 선택 불가
	function gridListCheckBoxDrawBeforeEvent(gridId,rowNum){
		if( gridId == "gridItemList" ){
			var viewcnl = $.trim(gridList.getColData(gridId, rowNum, "VIEWCNL"));
			var endmak = gridList.getColData(gridId, rowNum, "ENDMAK");
			
			if( endmak == "Y" || Number(viewcnl) == 0 ){
				return true;
			}
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID","GR09");
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
				
			}else if( name == "ASNTYP" ){
				var rcptty = $("[name=RCPTTY]").val();
				param.put("CODE", "ASNTYP");
				param.put("USARG1", rcptty);
				param.put("USARG3", 'V');
				
			}
			
			return param;
		}
	}
	
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=ASNTYP]"), configData.INPUT_COMBO, "Common,COMCOMBO", true);
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_CANCELRCV"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" style="height:150px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="400" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ASDTTY">입고타입</th>
											<td>
												<select id="RCPTTY" name="RCPTTY" Combo="WmsCommon,DOCTMCOMBO" ComboCodeView=false UISave="false" style="width:160px" onchange="fn_changeArea();">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_RCPTTY">입고유형</th>
											<td>
												<select Combo="Common,COMCOMBO" name="ASNTYP" id="ASNTYP" comboType="C,Combo" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_SVBELN">주문번호</th>
											<td>
												<input type="text" name="RI.SVBELN" UIInput="SR" />
											</td>
											<th CL="STD_ASNDKY">입고예정번호</th>
											<td>
												<input type="text" name="RH.ASNDKY" UIInput="SR" />
											</td>
											<th CL="STD_ASDDKY">공급사코드</th>
											<td>
												<input type="text" name="RH.DPTNKY" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="STD_ASDDAT">입고예정일자</th>
											<td>
												<input type="text" name="RH.DOCDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_VEHINO">차량번호</th>
											<td>
												<input type="text" name="AO.VEHINO" UIInput="SR" />
											</td>
											<th CL="STD_SKUKEY">상품코드</th>
											<td>
												<input type="text" name="RI.SKUKEY" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="STD_ASDNUM">발주번호</th>
											<td>
												<input type="text" name="RI.SEBELN" UIInput="SR" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-3" ><span CL="STD_RECDLI"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40 STD_ROWCK"      GCol="rowCheck,radio"></td>
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td>
												<td GH="100 STD_ASDTTY"    GCol="text,RCTYNM"></td>
												<td GH="100 STD_RCPTTY"    GCol="text,ASNTNM"></td>
												<td GH="100 STD_ASDDAT"    GCol="text,DOCDAT"  GF="D"></td>
												<td GH="100 STD_ASDNUM"    GCol="text,SEBELN"></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"></td>
												<td GH="100 STD_SHCARN"    GCol="text,SHCARN"></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"></td>
												<td GH="100 STD_ASDDTY"    GCol="text,DPTYNM"></td>
												<td GH="240 STD_ASDDKY"    GCol="text,DPTNKY"></td>
												<td GH="240 STD_ASDDNM,3"  GCol="text,STARNM"></td>
												<td GH="100 STD_FINDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_ASNDKY"    GCol="text,ASNDKY"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 													<button type="button" GBtn="total"></button> -->
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-4" ><span CL="STD_ITEMLIST"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_ASDTTY"   GCol="text,RCTYNM"></td>
												<td GH="130 STD_ASDSKU"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_ASNTNM"   GCol="text,ASNDS1"></td>
												<td GH="130 STD_ASNSKU"   GCol="text,SKUKEY"></td>
												<td GH="240 STD_ASNSNM"   GCol="text,DESC01"></td>
												<td GH="80 STD_AREANM"    GCol="text,AREANM"></td>
												<td GH="100 STD_ZONENM"   GCol="text,ZONENM"></td>
												<td GH="80 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LO06NM"></td>
												
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM" validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
													</select>
												</td>
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY" GF="N 7" validate="required gt(0),MASTER_M4002"></td>
												<td GH="100 STD_CNLQTY,3" GCol="text,VIEWCNL" GF="N"></td>
												<td GH="80 STD_CNLQTY"    GCol="text,QTADJU"  GF="N"></td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"  GF="D"></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"  GF="D"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKUCNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,SKUGRD"></td>
												<td GH="80 STD_ENDMAK"    GCol="text,ENDMAK,center"></td>
												<td GH="100 STD_ASDNUM"   GCol="text,SEBELN"></td>
												<td GH="100 STD_SVBELN"   GCol="text,SVBELN"></td>
												<td GH="100 STD_SHCARN"   GCol="text,SHCARN"></td>
												<td GH="100 STD_STRAID,3" GCol="text,STRAID"></td>
												<td GH="100 STD_SPOSNR"   GCol="text,SPOSNR"></td>
												<td GH="100 STD_ASNDKY"   GCol="text,ASNDKY"></td>
												<td GH="100 STD_ASNDIT"   GCol="text,ASNDIT"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>