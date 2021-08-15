<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<style>
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regNot{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn26.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(170);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "EtcOutbound",
			command : "EO10",
			autoCopyRowType : false
		});
		
		
		//멀티셀렉트 check
		inputList.setMultiComboSelectAll($("#ADJUTY"), true);
		gridList.setReadOnly("gridList", true, ["ADJUTY", "RSNADJ", "SKUCLS"]);
		
		$("#ADJT02").val(" ");
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","V");
			
			skumaPopup.open(param, true);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if(data.get("searchCode") == "SHSKUMA" ){
			skumaPopup.bindPopupData(data);
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "EO10");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("WARECODE","Y");
			param.put("CODE", "SKUCLS");
			
			return param;
		}else if( comboAtt == "WmsInventory,RSNADJCOMBO" ){
			return param;
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if( gridId == "gridList" && colName == "ADJT02" ){
			if( colValue == "V" ){
				return "impflg";
			}
		}
	}
</script>
</head>
<body>

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
		
			<div class="foldSect" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
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
											<th CL="STD_CREDAT">생성일자</th>
											<td>
												<input type="text" name="AH.CREDAT" UIFormat="C N" UIInput="B" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_GUADTY,3">기타출하타입</th>
											<td>
												<select id="ADJUTY" name="AH.ADJUTY" Combo="WmsCommon,DOCTMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_DPTNEO">반품처코드</th>
											<td>
												<input type="text" name="PTNRKY" UIInput="SR,SHBZPTN" />
											</td>
											<th CL="STD_SKUKEY">상품코드</th>
											<td>
												<input type="text" name="SKUKEY" UIInput="SR,SHSKUMA" />
											</td>
											<th CL="STD_SADJKY,3">조정번호</th>
											<td>
												<input type="text" name="SADJKY" UIInput="SR"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_AUTOEO">자동반품/폐기</th>
											<td>
												<select id="ADJT02" name="ADJT02" style="width:160px">
													<option>전체</option>
													<option value="V">Y</option>
													<option value=" ">N</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect" style="top: 135px;">
				<div class="tabs" id="gridTebs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" ><span CL="STD_DISUSD"></span></a></li>
					</ul>
					<div id="#tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="100 STD_SADJKY,3" GCol="text,SADJKY"></td><!-- 조정번호 -->
												<td GH="100 STD_WAREKY"   GCol="text,WARENM"></td><!-- 물류센터 -->
												<td GH="100 STD_GUADTY"   GCol="select,ADJUTY">
													<select Combo="WmsCommon,DOCTMCOMBO" ComboCodeView=false>
													</select>
												</td>
												<td GH="100 STD_DPTNEO"   GCol="text,PTNRKY"></td>
												<td GH="100 STD_DPTNME"   GCol="text,PTNRNM"></td>
												<td GH="100 STD_AUTOEO"   GCol="icon,ADJT02" GB="regAft"></td>
												<td GH="120 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="80 STD_PRCQTY"    GCol="text,QTADJU"  GF="N"></td>
												<td GH="100 STD_RELRSN"   GCol="select,RSNADJ">
													<select Combo="WmsInventory,RSNADJCOMBO" ComboCodeView=false>
														<option value=""></option>
													</select>
												</td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08"  GF="D"/></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"  GF="D"/></td>
												<td GH="80 STD_SKUCNM"    GCol="select,SKUCLS">
													<select Combo="Common,COMCOMBO" ComboCodeView=false>
													</select>
												</td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												<td GH="60 STD_AREAKY"    GCol="text,AREANM"></td>
												<td GH="60 STD_ZONEKY"    GCol="text,ZONEKY"></td>
												<td GH="80 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT"  GF="D"></td><!-- 생성일자 -->
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM"  GF="T"></td><!-- 생성시간 -->
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td><!-- 생성자명 -->
												<td GH="100 STD_CUSRNM"   GCol="text,CUSRNM"></td>
												
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
<!-- 									<button type="button" GBtn="total"></button> -->
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