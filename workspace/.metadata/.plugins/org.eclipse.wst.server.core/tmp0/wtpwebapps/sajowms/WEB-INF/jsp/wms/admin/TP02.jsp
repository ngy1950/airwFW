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
			editable : true,
			module : "WmsAdmin",
			command : "TP02" 
		});
		
		inputList.setMultiComboSelectAll($("#SKUCLS"), true);
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
			gridList.setReadOnly("gridList", true, ["SKUCLS", "ABCANV", "SKUGRP", "PASTKY", "LOTA06"]);
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	// 저장
	function saveData(){
		if( gridList.validationCheck("gridList", "modify") ){
			var head = gridList.getModifyList("gridList", "A");
			
			if( head.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			var param = new DataMap();
			param.put("head", head);
			
			netUtil.send({
				url : "/wms/admin/json/saveTP02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if( json && json.data ){
				commonUtil.msgBox("MASTER_M0815", json.data);
				searchList();
			}
		}
	}
	
	//그리드 컬럼 변겨 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if ( gridId == "gridList" && colName == "PASTKY" ){
			var param = dataBind.paramData("searchArea");
			param.put("PASTKY", $.trim(colValue));
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "PASTKYval",
				sendType : "list",
				param : param
			});
			
			if ( json.data.length < 1 ) {
				commonUtil.msgBox("MASTER_M0811");
				gridList.setColValue(gridId, rowNum, "PASTKY", "");
				
			}else if( json.data.length >= 1 ){
				gridList.setColValue(gridId, rowNum, "SHORTX", json.data[0].SHORTX);
			}

		}
	}
	
	//그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		gridList.setReadOnly("gridList", false, ["SKUCLS", "ABCANV", "SKUGRP", "PASTKY", "LOTA06"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		return newData;
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if( name == "SKUCLS" || id == "SKUCLS" ){
				param.put("WARECODE","Y");
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE","SKUCLS");
				
			}else if( name == "ABCANV" ){
				param.put("CODE","ABCANV");
				
			}else if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
			}
			
			return param;
			
		}else if( comboAtt == "WmsAdmin,SKGRPCOMBO" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}
	}
	
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"> </button>
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
											<th CL="STD_SKUCLS"></th>
											<td>
												<select id="SKUCLS" name="PT.SKUCLS" Combo="Common,COMCOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
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
												<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="text,NAME01"></td>
												<td GH="100 STD_SKUCLS"    GCol="select,SKUCLS"         validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="SKUCLS">
														<option value="">선택</option>
													</select>
												</td>
<!-- 												<td GH="100 STD_PARANK"    GCol="select,ABCANV"> -->
<!-- 													<select Combo="Common,COMCOMBO" ComboCodeView=false name="ABCANV"> -->
<!-- 														<option value=" ">선택</option> -->
<!-- 													</select> -->
<!-- 												</td> -->
												<td GH="100 STD_SKUGRP"    GCol="select,SKUGRP">
													<select Combo="WmsAdmin,SKGRPCOMBO" ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
												<td GH="100 STD_STEPNO"    GCol="input,STEPNO" GF="N 3" validate="required gt(0),MASTER_M4002"  ></td>
												<td GH="100 STD_LOTA06"    GCol="select,LOTA06"         validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="LOTA06">
														<option value=" ">선택</option>
													</select>
												</td>
												<td GH="100 STD_PASKEY"    GCol="input,PASTKY,SHPASTH"  validate="required" GF="U 10"></td>
												<td GH="200 STD_PASKYNM"   GCol="text,SHORTX"></td>
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"    GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"    GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"    GCol="text,LMODAT"  GF="D"></td>
												<td GH="100 STD_LMOTIM"    GCol="text,LMOTIM"  GF="T"></td>
												<td GH="100 STD_LMOUSR"    GCol="text,LMOUSR"></td>
												<td GH="100 STD_LUSRNM"    GCol="text,LUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
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