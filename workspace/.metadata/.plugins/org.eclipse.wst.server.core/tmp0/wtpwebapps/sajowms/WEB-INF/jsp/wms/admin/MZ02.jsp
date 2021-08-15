
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
		setTopSize(80);
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			pkcol : "WAREKY,ZONEKY,AREAKY,ZFLOOR",
			module : "WmsAdmin",
			command : "ZONMA",
			autoCopyRowType : false
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		gridList.appendCols("gridList", ["WAREKY"]);
	});
	
	//공통버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}else if( btnName == "Save" ){
			saveData();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			gridList.setReadOnly("gridList", true, ["AREAKY", "ZFLOOR", "EQUMAK"]);
			
			var param = inputList.setRangeParam("searchArea");
			param.put("AREATY", "SYST");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList", "modify") ){
			var head = gridList.getModifyList("gridList", "A");
			
			if( head.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			var param = new DataMap();
			param.put("head", head);
			param.put("sysChk", "system");
			
			netUtil.send({
				url : "/wms/admin/json/saveMZ01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
		}
	}
	
	//그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		gridList.setReadOnly("gridList", false, ["AREAKY", "ZFLOOR", "EQUMAK"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		
		return newData;
	} 
	
	//그리드 컬럼변경시 ZONE(시스템) 존재 여부 확인
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridList" ){
			if( colName == "ZONEKY" ){
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				param.put("ZONEKY", colValue);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "ZONMAval",
					sendType : "map",
					param : param
				});
			
				if( json.data["CNT"] > 0 ) {
					commonUtil.msgBox("VALID_M0103", colValue); //[{0}]는 이미 존재하는 ZONE 입니다.
					gridList.setColValue(gridId, rowNum, "ZONEKY","");
					
					return;
				}
			}
		}
		
	}
	
	//그리드 로우 삭제시 존에 속하는 로케이션 여부 확인
	function gridListEventRowRemove(gridId, rowNum){
		var rowAea = gridList.getColData(gridId, rowNum, "ZONEKY");
		
		if( gridId == "gridList" ){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("ZONEKY", rowAea);
			param.put("LOADCD", rowAea);
			param.put("LOADTP", "Z");
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "ZONELOCMAval",
				sendType : "map",
				param : param
			});
			
			if( json && json.data ){
				if( json.data["CNT"] > 0 ){
					commonUtil.msgBox("VALID_M9264", rowAea); //지정된 존[{0}]에 로케이션이 존재하기 때문에 삭제할 수 없습니다.
					return false;
				}
			}
			
			// 적재기준 존재여부 확인
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOADMchk",
				sendType : "map",
				param : param
			});
			
			if( json && json.data ){
				if( json.data["CNT"] >= 1 ){
					commonUtil.msgBox("MASTER_M5010", rowAea); //적재기준에서 사용중인 zone[ {0} ]는 삭제할 수 없습니다.
					return false;
					
				} else if ( json.data["CNT"] < 1 ){
					return true;
				}
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "SYST");
			
			return param;
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
<!-- 	<div class="util2"> -->
<!-- 		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button> -->
<!-- 	</div> -->
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
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_AREAKY">창고</th>
											<td>
												<select id="AREAKY" name="Z.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ZONEKY">Zone Code</th>
											<td>
												<input type="text" name="ZONEKY" UIInput="SR" UIformat="U 10" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
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
<!-- 												<td GH="100 STD_WAREKY"   GCol="text,WAREKY"></td> -->
												<td GH="100 STD_WAREKYNM" GCol="text,NAME01"></td>
												<td GH="100 STD_ZONEKY"   GCol="input,ZONEKY"  GF="U 10" validate="required"></td>
												<td GH="100 STD_AREAKY"   GCol="select,AREAKY" validate="required">
													<select Combo="WmsAdmin,AREACOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_ZFLOOR"   GCol="input,ZFLOOR"  GF="N 1"  validate="required gt(0),MASTER_M4002"></td>
												<td GH="100 STD_ZONENM"   GCol="input,SHORTX"  GF="S 10" validate="required"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT"   GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM"   GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"   GCol="text,LMODAT"   GF="D"></td>
												<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM"   GF="T"></td>
												<td GH="100 STD_LMOUSR"   GCol="text,LMOUSR"></td>
												<td GH="100 STD_LUSRNM"   GCol="text,LUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excel"></button>
									<!-- <button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
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