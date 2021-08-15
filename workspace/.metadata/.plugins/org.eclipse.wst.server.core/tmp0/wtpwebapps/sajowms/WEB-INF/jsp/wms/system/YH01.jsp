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
	var flag = "";
	midAreaHeightSet = "200px";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			pkcol : "SHLPKY",
			module : "System",
			command : "SHLPH",
			itemGrid : "gridItemList",
			itemSearch : true,
			addType : true,
			excelRequestGridData : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			pkcol : "SHLPKY,DBFILD",
			module : "System",
			command : "SHLPI",
			headGrid : "gridHeadList",
			selectRowDeleteType : false,
			autoCopyRowType : false,
			emptyMsgType : false
		});
	});
	
	
	//버튼
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Delete"){
			delData();
		}else if(btnName == "Create"){
			creatList();
		}else if(btnName == "Reload"){
			loadSearch();
		}
	}
	
	//생성
	function creatList(){
		flag = "I";
		uiList.setActive("Delete", false);
		gridList.resetGrid('gridHeadList');
		gridList.resetGrid('gridItemList');
		
		var param = new DataMap();
		param.put("SHLPKY", "");
		param.put("EXECTY", 'V'); //실행타입
		param.put("STARGO", ""); //오브젝트(테이블명)
		param.put("SHORTX", ""); //설명
		param.put("DWHERE", ""); //서치조건
		param.put("DORDER", ""); //서치정렬
		param.put("WIDTHW", 0);
		param.put("HEIGHT", 0);
		
		gridList.addNewRow("gridHeadList", param);
		
		param.put("DBFILD", "");
		param.put("DDICKY", "");
		gridList.addNewRow("gridItemList", param);
	}
	
	//조회
	function searchList(){
		flag = "U";
		var param = inputList.setRangeParam("searchArea");
		
		
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
		
		uiList.setActive("Delete", true);
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
			if(gridList.getColData("gridHeadList", rowNum, "STATUS") == "C"){
				return false;
			}
			
			var param = gridList.getRowData(gridId, rowNum);
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
		}
	}
	
	//저장
	function saveData(){
		var headId = "gridHeadList";
		var itemId = "gridItemList";
		
		var head = gridList.getModifyData(headId, "E");
		var item = gridList.getModifyData(itemId, "E");
		
		if( head.length == 0 && item.length == 0 ){
			alert(commonUtil.getMsg("MASTER_M0545")); //* 변경된 데이터가 없습니다.
			return false;
		}
		
		var headNum = gridList.getFocusRowNum(headId);
		if( gridList.getRowStatus(headId, headNum) == "C" && item.length == 0 ){
			alert(commonUtil.getMsg("COMMON_M0008")); //처리를 위한 아이템이 존재하지 않습니다.
			return false;
		}
		
		//item 반환필트 체크 1개만 가능
		var indrvlCnt = 0 ;
		var itemGridCnt = gridList.getGridDataCount("gridItemList");
		for(var i=0; i<itemGridCnt; i++){
			var indrvl = gridList.getColData("gridItemList", i, "INDRVL"); //반환필드
			if(indrvl == 'V'){
				indrvlCnt ++
			}
		}
		
		if(indrvlCnt > 1){
			commonUtil.msgBox("SYSTEM_M9999"); //반환필드는 1개만 선택 가능합니다.
			return;
		}
		
		if(gridList.validationCheck("gridHeadList", "modify") && gridList.validationCheck("gridItemList", "modify")){
			if( !confirm(commonUtil.getMsg(configData.MSG_MASTER_SAVE_CONFIRM)) ){ //저장하시겠습니까?
				return false;
			}
			
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("flag", flag);
			
			var json = netUtil.sendData({
				url : "/wms/system/json/saveYH01.data",
				param : param
			}); 
			
			if( json && json.data ){
				if(json.data > 0){
					commonUtil.msgBox("VALID_M0001"); //저장이 성공하였습니다.
					gridList.resetGrid("gridItemList");
					searchList();
				}
			}
		}
	}
	
	//삭제
	function delData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){ //삭제하시겠습니까?
			return;
		}
		
		var headId = "gridHeadList";
		var itemId = "gridItemList";
		var head = gridList.getRowData(headId, gridList.getFocusRowNum(headId));
		var item = gridList.getGridData(itemId);
		
		var param = new DataMap();
		param.put("head", head);
		param.put("item", item);
		param.put("flag", "deleteBtn");
		
		var json = netUtil.sendData({
			url : "/wms/system/json/saveYH01.data",
			param : param
		}); 
	
		if (json && json.data) {
			if(json.data > 0){
				commonUtil.msgBox("VALID_M0003"); //삭제가 성공하였습니다.
				gridList.resetGrid("gridItemList");
				searchList();
			}
		}
	}
	
	//리로드
	function loadSearch(){
	netUtil.send({
		url : "/common/search/json/reload.data",
		failFunction : "",
		successFunction : "saveDataCallBack"
	});
	}
	
	//컬럼 체인지 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if( gridId == "gridHeadList" && colName == "SHLPKY" ){
			if( $.trim(colValue) == "" ){
				return false;
			}
			
			var param = new DataMap();
			param.put(colName, colValue);
			
			var json = netUtil.sendData({
				module : "System",
				command : "SHLPKYval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] > 0) {
				commonUtil.msgBox("SYSTEM_M0035", colValue); //{0} 이미 존재하는 서치 핼프 오브젝트 키 입니다.
				gridList.setColValue(gridId, rowNum, colName, "");
				return;
			}
			
			var HeadlistCnt = gridList.getGridDataCount(gridId);
			var ItemlistCnt = gridList.getGridDataCount("gridItemList");
			if( ItemlistCnt > 0 ){
				if( HeadlistCnt != 0 ){
					for( var i=0; i<ItemlistCnt; i++ ){
						gridList.setColValue("gridItemList", i, "SHLPKY", colValue);
					}
				}
			}
			
		}else if( gridId == "gridItemList" ){
			var induls = gridList.getColData(gridId, rowNum, "INDULS");
			var indrvl = gridList.getColData(gridId, rowNum, "INDRVL");
			var shlpky = gridList.getColData(gridId, rowNum, "SHLPKY");
			
			if( $.trim(shlpky) == "" ){
				alert("서치헬프키를 입력해주세요.");
				return false;
			}
			
			if( colName == "INDRVL" && indrvl=="V" ){
				if(induls==" "){
					gridList.setColValue(gridId, rowNum, colName, " ");
				}
				
			}else if( colName == "DDICKY" ){
				if( colValue != "" ){
					var param = inputList.setRangeParam("searchArea");
					param.put(colName, colValue);
					
					var json = netUtil.sendData({
						module : "System",
						command : "DDICKYval",
						sendType : "map",
						param : param
					});
					
					if( json.data["CNT"] < 1 ){
						commonUtil.msgBox("SYSTEM_M0124");
						
						gridList.setColValue(gridId, rowNum, colName, "");
						gridList.setRowFocus(gridId, rowNum, colName);
					}
				}
			}
		}
	}
	
	//로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		if( gridId == "gridItemList" ){
			var headNum = gridList.getFocusRowNum("gridHeadList");
			var shlpky = gridList.getColData("gridHeadList", headNum, "SHLPKY");
			
			if( $.trim(shlpky) == "" ){
				alert("서치헬프키를 입력해주세요.");
				return false;
			}
			
			var newData = new DataMap();
			newData.put("SHLPKY", shlpky);
			return newData;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
	<button CB="Create CREATE BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Delete DELETE BTN_DELETE"></button>
		<button CB="Reload EXECUTE BTN_RELOAD"></button>
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
											<th CL="STD_SHLPKY,3"></th>
											<td>
												<input type="text" name="SHLPKY" UIInput="S,SHSHLPH"/>
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
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
												<td GH="120 STD_SHLPKY,3"   GCol="input,SHLPKY" GF="U"   validate="required" ></td>
												<td GH="100 STD_EXECTY"     GCol="check,EXECTY" ></td>
												<td GH="130 STD_STARGO"     GCol="input,STARGO" ></td>
												<td GH="240 STD_SHORTX"     GCol="input,SHORTX" GF="S 180"></td>
												<td GH="100 STD_DWHERE"     GCol="input,DWHERE" ></td>
												<td GH="100 STD_DORDER"     GCol="input,DORDER" ></td>
												<td GH="100 STD_WIDTHW"     GCol="input,WIDTHW" GF="N"></td>
												<td GH="100 STD_HEIGHT"     GCol="input,HEIGHT" GF="N"></td>
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
												<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
												<td GH="120 STD_SHLPKY,3"  GCol="input,SHLPKY" GF="S 10" validate="required">서치헬프키</td>
												<td GH="120 STD_DBFILD"    GCol="input,DBFILD" GF="S 20" validate="required">DB필드</td>
												<td GH="120 STD_DDICKY"    GCol="input,DDICKY" GF="S 20">데이터사전키</td>
												<td GH="100 STD_INDUSO,2"  GCol="check,INDUSO">검색조건사용여부</td>
												<td GH="110 STD_POSSOS"    GCol="input,POSSOS" GF="S 3">검색조건순번</td>
												<td GH="100 STD_INDNED,2"  GCol="check,INDNED">수정가능여부</td>
												<td GH="120 STD_RQFLDS"    GCol="check,RQFLDS">검색조건필수여부</td>
												<td GH="100 STD_INDULS,2"  GCol="check,INDULS">그리드 사용여부</td>
												<td GH="100 STD_POSLIS,2"  GCol="input,POSLIS" GF="S 3">그리드순번</td>
												<td GH="100 STD_INDRVL"    GCol="check,INDRVL">Return값 여부</td>
												<td GH="150 STD_DFVSOS,2"  GCol="input,DFVSOS" GF="S 60"검색조건 Default값></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record"></p>
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