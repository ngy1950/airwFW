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
midAreaHeightSet = "300px";
var comboFlag = "A";

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "CC02H",
			itemGrid : "gridItemList",
			itemSearch : true,
			excelRequestGridData : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			pkcol : "WAREKY,CMCDVL",
			module : "WmsAdmin",
			command : "CC02I",
			selectRowDeleteType : false,
			addType : true,
			excelRequestGridData : true,
			emptyMsgType : false
		});
		
		$("select[name=CKEYYN]").val("Y"); //DEF 값
	});
	
	// 공통 버튼 클릭 이벤트
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
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
			var param = new DataMap();
			var rowData = gridList.getRowData(gridId, rowNum);
			param.putAll(rowData);
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
		}
	}
	
	//저장
	function saveData(){
		if( gridList.getModifyRowCount("gridHeadList") == 0 && gridList.getModifyRowCount("gridItemList") == 0 ){
			commonUtil.msgBox("MASTER_M0545"); //변경된 데이터가 없습니다.
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return; // confirm : 저장하시겠습니까? 
		}
		
		if(gridList.validationCheck("gridHeadList", "modify") && gridList.validationCheck("gridItemList", "modify")){
			
			var head = gridList.getModifyList("gridHeadList", "A");
			var item = gridList.getModifyList("gridItemList", "A");
			
			if( head.length == 0 && item.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			//저장 시작
			var param = new DataMap();
			param.put("head", head);
			param.put("item", item);
			param.put("progId", "CC02");
			
			var json = netUtil.sendData({
				url : "/wms/admin/json/saveCC02.data",
				param : param
			});
			
			if( json && json.data ){
				commonUtil.msgBox("VALID_M0001"); //저장이 성공하였습니다.
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				searchList();
			}
		}
	}
	
	
	// 그리드 AJAX 이후
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength > 0 ){
		
		}else if( gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
		}
		
		if( gridId == "gridItemList" && dataLength > 0 ){
			comboFlag = "OK";
			
			setTimeout(function(){
				gridList.setComboOption(gridId, "CMCDVL", configData.INPUT_COMBO, "WmsAdmin,CMCDVLCOMBO");
				gridList.reloadView(gridId, true);
				
				comboFlag = "A";
			}, 100);
		}
	}
	
	// 그리드 컬럼 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridItemList" ){
			if( colName == "WAREKY" || colName == "CMCDVL" ){
				
				var cmcdky = gridList.getColData(gridId, rowNum, "CMCDKY"); //공통코드키
				var cmcdvl = gridList.getColData(gridId, rowNum, "CMCDVL"); //공통코드값
				var wareky = gridList.getColData(gridId, rowNum, "WAREKY"); //물류센터
				
				var param = new DataMap();
				param.put("CMCDKY", cmcdky);
				param.put("CMCDVL", cmcdvl);
				param.put("WAREKY", wareky);
				
				// 코드값 중복여부 확인
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "CC02CMCDVLCNT",
					sendType : "map",
					param : param
				});
				
				if( json.data["CNT"] >= 1 ) {
					gridList.setColValue(gridId, rowNum, "CMCDVL", "");
					gridList.setColValue(gridId, rowNum, "CDESC1", "");
					commonUtil.msgBox("MASTER_M0318"); // 이미 존재하는 Item번호 입니다.
					return false;
				}
				
				// 코드설명 가져오기
				var nameJson = netUtil.sendData({
					module : "WmsAdmin",
					command : "CC02CDESC1",
					sendType : "map",
					param : param
				});
				
				if( nameJson && nameJson.data ) {
					gridList.setColValue(gridId, rowNum, "CDESC1", nameJson.data.CDESC1);
				}
			}
		}
	}
	
	//그리드 행 추가 Before 이벤트
	function gridListEventRowAddBefore(gridId, rowNum) {
		if( gridId == "gridItemList" ){
			var headRowNum = gridList.getFocusRowNum("gridHeadList");
			var cmcdky = gridList.getColData("gridHeadList", headRowNum, "CMCDKY");
			
			var newData = new DataMap();
			newData.put("CMCDKY", cmcdky);
			comboFlag = "OK";
			
			return newData;
		}
	}
	
	// 그리드 행 추가 after 이벤트 : 콤보값 변경
	function gridListEventRowAddAfter(gridId,rowNum){
		if( gridId == "gridItemList" ){
			gridList.setComboOption(gridId, "CMCDVL", configData.INPUT_COMBO, "WmsAdmin,CMCDVLCOMBO");
			gridList.reloadView(gridId, true);
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "Wms,WAHMACOMBO" ){
			return param;
			
		}else if( comboAtt == "WmsAdmin,CMCDVLCOMBO" && comboFlag == "OK"){
			var gridId = "gridHeadList";
			var headRowNum = gridList.getFocusRowNum(gridId);
			var cmcdky = gridList.getColData(gridId, headRowNum, "CMCDKY");
			
			param.put("CMCDKY", cmcdky);
			return param;
		}
	}
	
	
</script>
</head>
<body style="position: relative;">
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
			<div class="bottomSect top" style="height:70px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="80" />
										<col width="250" />
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_CMCDKY">공통코드키</th>
											<td>
												<input type="text" name="CM.CMCDKY" UIInput="SR" />
											</td>
											<th CL="STD_CKEYYN">공통코드값 존재여부</th>
											<td>
												<select name="CKEYYN" style="width:160px;">
													<option value=" ">전체</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
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
												<td GH="100 STD_CMCDKY"   GCol="text,CMCDKY"></td>
												<td GH="100 STD_SHORTX"   GCol="text,SHORTX"  GF="S 180"></td>
												<td GH="100 STD_DBFILD"   GCol="text,DBFILD"  GF="S 10"></td>
												<td GH="100 STD_USARG1,2" GCol="text,USARL1"  GF="S 10"></td>
												<td GH="100 STD_USARG2,2" GCol="text,USARL2"  GF="S 10"></td>
												<td GH="100 STD_USARG3,2" GCol="text,USARL3"  GF="S 10"></td>
												<td GH="100 STD_USARG4,2" GCol="text,USARL4"  GF="S 10"></td>
												<td GH="100 STD_USARG5,2" GCol="text,USARL5"  GF="S 10"></td>
												<td GH="100 STD_CKEYYN"   GCol="text,CKEYYN"></td>
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
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"   GCol="select,WAREKY" validate="required">
													<select id="WAREKY" name="WAREKY" Combo="Wms,WAHMACOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_CMCDKY"   GCol="text,CMCDKY"></td>
												<td GH="100 STD_CMCDVL,2" GCol="select,CMCDVL" validate="required">
													<select Combo="WmsAdmin,CMCDVLCOMBO" ComboType="C,Combo">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="50 STD_UNUSED"    GCol="check,DELMAK"></td>
												<td GH="100 STD_SORTSQ"   GCol="input,SORTSQ" GF="N 5"></td>
												<td GH="100 STD_CDESC1"   GCol="input,CDESC1" GF="S 100"></td>
												<td GH="100 STD_CDESC2"   GCol="input,CDESC2" GF="S 100"></td>
												<td GH="100 STD_USARG1,2" GCol="input,USARG1" GF="S 3"></td>
												<td GH="100 STD_USARG2,2" GCol="input,USARG2" GF="S 3"></td>
												<td GH="100 STD_USARG3,2" GCol="input,USARG3" GF="S 3"></td>
												<td GH="100 STD_USARG4,2" GCol="input,USARG4" GF="S 3"></td>
												<td GH="100 STD_USARG5,2" GCol="input,USARG5" GF="S 3"></td>
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