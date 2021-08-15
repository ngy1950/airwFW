<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR10H",
			autoCopyRowType : false
		});
		
// 		inputList.setMultiComboSelectAll($("#RCPTTY"), true);
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
// 		var areaList = inputList.getMultiComboValue("AREAKY");
// 		var newList = new Array();
// 		for(var i=0; i<areaList.length; i++){
// 			if( areaList[i] != "SHP " ){
// 				newList.push(areaList[i]);
// 			}
// 		}
// 		inputList.setMultiComboValue($("#AREAKY"), newList);
	$("#RVIT05").val("N");
	
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			param.put("ASNTYP", $.trim(param.get("ASNTYP")));
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList" && dataLength > 0 ){
		
		}else if( gridId == "gridList" && dataLength <= 0 ){
		
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("USRADM", "<%=usradm%>");
			param.put("USERID", "<%=userid%>");
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "GR10");
			return param;
			
		}else if( comboAtt == "WmsInventory,SJ_AREACOMBO" ){
// 			param.put("USARG1", "STOR");
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			
			var rcptty = $("[id=RCPTTY]").val();
			param.put("CODE", "ASNTYP");
			param.put("USARG1", rcptty);
			
			return param;
		}
	}
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=ASNTYP]"), configData.INPUT_COMBO, "Common,COMCOMBO", true);
	}
	
</script>
</head>
<body style="position: relative;">
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>


<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="searchArea">
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
												<select Combo="Common,COMCOMBO" name="ASNTYP" id="ASNTYP"  comboType="C,Combo" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_AREAKY"></th>
											<td>
												<select id="AREAKY" name="RI.AREAKY" Combo="WmsInventory,SJ_AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ASNDKY">입고예정번호</th>
											<td>
												<input type="text" name="RH.ASNDKY" UIInput="SR" />
											</td>
											<th CL="STD_SKUKEY">상품코드</th>
											<td>
												<input type="text" name="RI.SKUKEY" UIInput="SR" />
											</td>
											
										</tr>
										<tr>
											<th CL="STD_ASDDAT">입고예정일자</th>
											<td>
												<input type="text" name="RH.DOCDAT" UIInput="B" UIFormat="C N" MaxDiff="M1" />
											</td>
											<th CL="STD_ASDDKY">공급사코드</th>
											<td>
												<input type="text" name="RH.DPTNKY" UIInput="SR" />
											</td>
											<th CL="STD_RCPTTY">상품회수여부</th>
											<td>
												<select name="RVIT05" id="RVIT05" ComboCodeView=false style="width:160px">
													<option value="N">회수상품</option>
													<option value="Y">미회수상품</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"   GCol="text,WARENM"></td>
												<td GH="100 STD_ASDTTY"   GCol="text,RCTYNM"></td>
												<td GH="100 STD_RCPTTY"   GCol="text,ASNTNM"></td>
												<td GH="100 STD_ASDDAT"   GCol="text,DOCDAT" GF="D"></td>
												<td GH="100 STD_ASNDKY"   GCol="text,ASNDKY"></td>
												<td GH="100 STD_ASNDIT"   GCol="text,ASNDIT"></td>
												<td GH="100 STD_ASDDTY"   GCol="text,DPTYNM"></td>
												<td GH="240 STD_ASDDKY"   GCol="text,DPTNKY"></td>
												<td GH="240 STD_ASDDNM,3" GCol="text,DPTNNM"></td>
												<td GH="130 STD_ASDSKU"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_ASNTNM"   GCol="text,ASNDS1"></td>
												<td GH="130 STD_ASNSKU"   GCol="text,SKUKEY"></td>
												<td GH="240 STD_ASNSNM"   GCol="text,DESC01"></td>
												<td GH="80 STD_AREANM"    GCol="text,AREANM"></td>
												<td GH="80 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="100 STD_ZONENM"   GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="100 STD_LOTA06"   GCol="text,LO06NM"></td>
												<td GH="100 STD_PRCQTY"   GCol="text,QTYRCV"  GF="N"></td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"  GF="D"></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"  GF="D"></td>
												<td GH="100 STD_ASDNUM"   GCol="text,SEBELN"></td>
												<td GH="100 STD_SELPNM"   GCol="text,SEBELP"></td>
												<td GH="100 STD_SVBELN"   GCol="text,SVBELN"></td>
												<td GH="100 STD_SHCARN"   GCol="text,SHCARN"></td>
												<td GH="100 STD_STRAID,3" GCol="text,SHDTLN"></td>
												<td GH="100 STD_SPOSNR"   GCol="text,SPOSNR"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,SKUGRD"></td>
												<td GH="80 STD_ENDMAK"    GCol="text,ENDMAK"></td>
												<td GH="100 STD_RECVNO"   GCol="text,RECVKY"></td>
												<td GH="100 STD_REITEM"   GCol="text,RECVIT"></td>
												<td GH="100 STD_RECDAT"   GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_RECTIM"   GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_RECDID"   GCol="text,CREUSR"></td>
												<td GH="100 STD_RECUSR"   GCol="text,CUSRNM"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>

<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>