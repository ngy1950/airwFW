<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";
var flag;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			module : "System",
			command : "ROLDF",
			pkcol : "UROLKY",
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			module : "System",
			command : "ROLPG",
			pkcol : "PROGID"
		});
		
		gridList.appendCols("gridHeadList", ["WAREKY","UROTYP"]);
		gridList.appendCols("gridItemList", ["WAREKY"]);
		gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, false);
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "Save" ){ //저장
			saveData();
			
		}else if( btnName == "Create" ){ //생성
			flag = "C";
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, false);
			
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("UROTYP", "PG");
			newData.put("SAVMAK", "V");
			
			gridList.addNewRow("gridHeadList", newData);
			gridList.addNewRow("gridItemList", newData);
			
		}
	}
	
	//조회
	function searchList(){
		flag = "S";
		var param = inputList.setRangeParam("searchArea");
		param.put("UROTYP", "PG");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
		
		gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, true);
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
			if( gridList.getColData("gridHeadList", rowNum, "STATUS") == "C" ){
				return false;
			}
			
			var rowData = gridList.getRowData("gridHeadList", rowNum);
			
			gridList.gridList({
				id : "gridItemList",
				param : rowData
			});
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridHeadList", "modify") && gridList.validationCheck("gridItemList", "modify") ){
			var head = gridList.getModifyList("gridHeadList", "A");
			var item = gridList.getModifyList("gridItemList", "A");
			var headLen = head.length;
			var itemLen = item.length;
			
			if( headLen == 0 && itemLen == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return false;
			}
			
			// 생성시 활성화 체크
			for(var i=0; i<itemLen; i++){
				var savmak = $.trim(item[i].get("SAVMAK"));
				var prtmak = $.trim(item[i].get("PRTMAK"));
				if( savmak == "" && prtmak == "" ){
					commonUtil.msgBox("SYSTEM_M0012"); //자장불가 또는 출력불가 중 선택해 주세요.
					return false;
					break;
				}
			}
			
			// 저장, 수정, 삭제
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("UROTYP", "PG");
			
			var json = netUtil.sendData({
				url : "/wms/system/json/saveUR02.data",
				param : param
			});
			
			if( json && json.data ){
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				commonUtil.msgBox("MASTER_M0564");
				searchList();
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridHeadList" && colName == "UROLKY" ){
			
			//권한키 중복확인
			var param = new DataMap();
			param.put("UROLKY", colValue);
			param.put("UROTYP", "PG");
			
			var json = netUtil.sendData({
				module : "System",
				command : "ROLDFCHK",
				sendType : "map",
				param : param
			});
		
			if( json.data["CNT"] > 0 ) {
				commonUtil.msgBox("SYSTEM_M0015", colValue); //[{0}]는 이미 존재하는 권한키입니다. 다른이름으로 변경해주세요.
				gridList.setColValue(gridId, rowNum, colName, "");
				colValue = "";
			}
			
			var itemListId = "gridItemList";
			var itemList = gridList.getRowNumList(itemListId);
			var itemListLen = itemList.length;
			
			for( var i=0; i<itemListLen; i++ ){
				var rowNum = itemList[i];
				gridList.setColValue(itemListId, rowNum, "UROPRG", colValue);
			}
			
		}else if( gridId == "gridItemList" ){
			var itemRowData = gridList.getRowData(gridId, rowNum);
			var pgKey = itemRowData.get("UROPRG");
			if( $.trim(pgKey) == "" ){
				gridList.setColValue(gridId, rowNum, colName, "");
				alert("접속센터키 먼저 입력해주세요");
				return false;
			}
			
			if( colName == "PROGID" ){
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LBLTXL", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("SES_LANGUAGE", "KR");
				param.put("PROGID", colValue);
				param.put("WAREKY", itemRowData.get("WAREKY"));
				
				var json = netUtil.sendData({
					module : "System",
					command : "PROGMLBCHK",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					if( json.data.length > 0 ){
						gridList.setColValue(gridId, rowNum, "LBLTXL", json.data[0].LBLTXL);
					}else{
						alert("존재하지 않는 프로그램입니다. 다시입력해주세요");
						gridList.setColValue(gridId, rowNum, colName, "");
						gridList.setColValue(gridId, rowNum, "LBLTXL", "");
					}
				}
			}
		}
	}
	
	// 그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		if( gridId == "gridItemList" ){
			var headGridId = "gridHeadList";
			var headRowNum = gridList.getFocusRowNum(headGridId);
			var headKey = gridList.getColData(headGridId, headRowNum, "UROLKY");
			
			var newData = new DataMap();
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
			newData.put("UROPRG", headKey);
			newData.put("SAVMAK", "V");
			
			return newData;
		}
	}
	
	//로우 삭제시 권한키 사용여부 확인
	function gridListEventRowRemove(gridId, rowNum){
		if( gridId == "gridHeadList" ){
			var urolky = gridList.getColData("gridHeadList", rowNum, "UROLKY");
			var param = new DataMap();
			param.put("UROPRG", urolky);
			
			var json = netUtil.sendData({
				module : "System",
				command : "URORCTCHK",
				sendType : "map",
				param : param
			});
		
			if( json.data["CNT"] > 0 ) {
				commonUtil.msgBox("SYSTEM_M0013"); //사용중인 권한키는 삭제할 수 없습니다.
				return false;
			}
		}
	}
	
	//서치헬프 오픈이벤트
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		
		if(searchCode == "SHPROGM"){
			param.put("WAREKY", "<%= wareky%>");
			return param;
		}
	}
	
	
</script>
</head>
<body style="position: relative;">
<div class="contentHeader">
	<div class="util">
		<button CB="Create ADD BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" style="height:70px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_PRGKEY"></th>
											<td>
												<input type="text" name="UROLKY" UIInput="SR" UIFormat="U"/>
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
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1"> 
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
<!-- 												<td GH="40"               GCol="rowCheck"></td> -->
												<td GH="100 STD_PRGKEY"   GCol="input,UROLKY" GF="U 10"  validate="required"></td>
												<td GH="200 STD_SHORTX"   GCol="input,SHORTX" GF="S 180"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"   GCol="text,LMODAT"  GF="D"></td>
												<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM"  GF="T"></td>
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
<!-- 									<button type="button" GBtn="add"></button> -->
									<button type="button" GBtn="delete"></button>
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
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"       GCol="rownum">1</td>
												<td GH="100 STD_PRGKEY"      GCol="text,UROPRG"  validate="required"></td>
												<td GH="100 STD_PROGID"      GCol="input,PROGID,SHPROGM" GF="U" validate="required"></td>
												<td GH="200 STD_PROGRAMS,3"  GCol="text,LBLTXL"></td>
												<td GH="70 STD_SAVMAK"       GCol="check,SAVMAK"></td>
												<td GH="70 STD_PRTMAK"       GCol="check,PRTMAK"></td>
												<td GH="100 STD_CREDAT"      GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"      GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"      GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"      GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"      GCol="text,LMODAT"  GF="D"></td>
												<td GH="100 STD_LMOTIM"      GCol="text,LMOTIM"  GF="T"></td>
												<td GH="100 STD_LMOUSR"      GCol="text,LMOUSR"></td>
												<td GH="100 STD_LUSRNM"      GCol="text,LUSRNM"></td>
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