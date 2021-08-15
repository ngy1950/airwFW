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
			module : "WmsAdmin",
			command : "LOADM"
		});
		
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
			gridList.setReadOnly("gridList", true, ["SKUCLS", "ABCANV", "SKUGRP", "LOADTP", "LOADCD", "LOADYN"]);
			
			var param = inputList.setRangeParam("searchArea");
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
			
			netUtil.send({
				url : "/wms/admin/json/saveTP03.data",
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
	
	//그리드 로우추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		gridList.setReadOnly("gridList", false, ["SKUCLS", "ABCANV", "SKUGRP", "LOADTP", "LOADCD", "LOADYN"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		return newData;
	}
	
	//그리드 컬럼 체인지 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( colName == "LOADTP" ){
			gridList.setColValue(gridId, rowNum, "LOADCD", "");
			gridList.setColValue(gridId, rowNum, "LOADNM", "");
			
		}else if ( colName == "LOADCD" ){
			if($.trim(colValue) == ""){
				gridList.setColValue(gridId, rowNum, "LOADNM", ""); //위치코드명
				return false;
			}
			
			var rowData = gridList.getRowData(gridId, rowNum);
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOADNM",
				sendType : "map",
				param : rowData
			});
			
			if( json && json.data ){
				if( json.data.LOADNM != "" ){
					gridList.setColValue(gridId, rowNum, "LOADNM", json.data.LOADNM);
					
				}else{
					commonUtil.msgBox("MASTER_M5008"); //유효하지 않은 값 입니다. 적재타입 또는 위치코드를 확인해주세요.
					gridList.setColValue(gridId, rowNum, "LOADCD", ""); //위치코드
					gridList.setColValue(gridId, rowNum, "LOADNM", ""); //위치코드명
				}
			}
		}
	}
	
	//서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if( searchCode == "SHLOADCD" ){
			var isOpen = true;
			var gridId = "gridList";
			var loadtp = gridList.getColData(gridId,rowNum,"LOADTP");
			
			switch (loadtp) {
			case "A":
				searchCode = "SHAREMA";
				break;
			case "Z":
				searchCode = "SHZONMA";
				break;
			case "L":
				searchCode = "SHLOCMA";
				break;	
			default:
				isOpen = false;
				break;
			}
			
			if( isOpen ){
				page.searchHelp($inputObj, searchCode, false, rowNum, gridId);
			}else{
				commonUtil.msgBox("MASTER_M4017"); //적재타입을 선택해 주세요.
			}
			return false;
			
		}else if( searchCode=="SHZONMA" ){
			return dataBind.paramData("searchArea");
			
		}else if( searchCode=="SHLOCMA" ){
			return dataBind.paramData("searchArea");
			
		}
		
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "SKUCLS" ){
				param.put("WARECODE","Y");
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE","SKUCLS");
				
			}else if( name == "ABCANV" ){
				param.put("CODE","ABCANV");
				
			}else if( name == "LOADTP" ){
				param.put("CODE","LOADTP");
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
		<button CB="Save SAVE BTN_SAVE"></button>
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
											<select id="SKUCLS" name="SKUCLS" Combo="Common,COMCOMBO" ComboCodeView=false style="width:160px">
												<option value="">선택</option>
											</select>
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
														<option value="">전체</option>
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
												<td GH="100 STD_LOADTP"    GCol="select,LOADTP"         validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="LOADTP">
														<option value=" ">선택</option>
													</select>
												</td>
												<td GH="100 STD_LOADCD"    GCol="input,LOADCD,SHLOADCD"  name="LOADCD" GF="U 10" validate="required"></td>
												<td GH="100 STD_LOADNM"    GCol="text,LOADNM"></td>
												<td GH="100 STD_LOADYN"    GCol="select,LOADYN"         validate="required">
													<select >
														<option value="">선택</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</td>
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