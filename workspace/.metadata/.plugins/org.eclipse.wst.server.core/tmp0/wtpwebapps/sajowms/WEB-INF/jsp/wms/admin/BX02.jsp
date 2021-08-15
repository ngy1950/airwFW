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
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "BX02",
			itemGrid : "gridItemList",
			itemSearch : true,
			addType : true,
			excelRequestGridData : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsAdmin",
			command : "BX02Sub",
			selectRowDeleteType : false,
			addType : true,
			excelRequestGridData : true
		});
		
		$('#BOXDTL').val('00');
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
			
		}else if(btnName == "Save"){
			saveData();
			
		}else if( btnName == "Create" ){ //생성버튼
			var headCnt = gridList.getModifyRowCount("gridHeadList");
			var listCnt = gridList.getModifyRowCount("gridItemList"); 
			if(listCnt > 0 || headCnt > 0){
				if(!commonUtil.msgConfirm("변경중인 데이터가 있습니다. 그래도 진행하시겠습니까?")){
					return;
				}	
				
			}
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, false);
			gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
			
			var newData = new DataMap();  
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("BOXTYP", " ");
			newData.put("BOXDTL", " ");
			newData.put("MIXTYP", " ");
			gridList.addNewRow("gridHeadList", newData);
			gridList.setRowReadOnly("gridHeadList", 0, true, ["LASTBN","LASTBY"]);
			
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.setBtnActive("gridHeadList", configData.GRID_BTN_DELETE, true);
			gridList.setReadOnly("gridHeadList", true, ["WAREKY","SHBXKY"]);
			
			var param = inputList.setRangeParam("searchArea")
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
		
			if(gridList.getRowStatus(gridId, rowNum) == "C"){
				return false;
			}
			
			
			var param = getItemSearchParam(rowNum);
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
		}
	}
	
	// 아이템 그리드 Parameter
	function getItemSearchParam(rowNum){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		var param = inputList.setRangeParam("searchArea");
		param.putAll(rowData);
		
		return param;
	}
	
	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		
		if(gridId == "gridItemList"){
			var rowNum = gridList.getSearchRowNum("gridHeadList");
			if(rowNum == -1){
				return false;
			}else{
				param = getItemSearchParam(rowNum);
			}
		}
		
		return param;
	}
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength > 0 ){
			
		}else if( gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
			searchOpen(true);
		}else if( gridId == "gridItemList" && dataLength > 0 ){
			for(var i=0;i<dataLength;i++){
				gridList.setRowReadOnly(gridId, i, true);
			}
		}
	}
	
	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum){
	}
	
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	//그리드 위에 클릭시 아이템 리셋
	function gridListEventRowFocus(gridId, rowNum){
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "SHBXKY"){
				var shbxky = gridList.getColData("gridHeadList", rowNum, "SHBXKY");
				
				if(gridList.getRowStatus(gridId, rowNum) == "C"){
					var list = gridList.getGridData("gridItemList");
					if(list.length > 0 ){
						for(var i=0 ; i<list.length ; i++){
							gridList.setColValue("gridItemList", i, "SHBXKY", shbxky);
						}
					}
				}	
			}
		}
	}
	
	//저장
	function saveData(){
		if(gridList.getModifyRowCount("gridHeadList") == 0 && gridList.getModifyRowCount("gridItemList") == 0 ){
			alert(commonUtil.getMsg("MASTER_M0545"));
			return;
		}
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		if(gridList.validationCheck("gridHeadList", "modify") && gridList.validationCheck("gridItemList", "modify")){
			
			var head = gridList.getGridData("gridHeadList");
			var list = gridList.getGridData("gridItemList");
			
			
			var param = new DataMap();
			
			param.put("head", head);
			param.put("list", list);
			
			netUtil.send({
				url : "/wms/admin/json/saveBX02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}

	function succsessSaveCallBack(json , status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
	
	//그리드 행 추가 Before 이벤트
	function gridListEventRowAddBefore(gridId, rowNum) {
		if(gridId == "gridItemList"){
			var shbxky = gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "SHBXKY");
			if($.trim(shbxky) == ""){
				commonUtil.msgBox("최적화 전략이 존재하지 않습니다.");
				return false;
			}else{
				var newData = new DataMap();
					newData.put("SHBXKY",shbxky);
					newData.put("SKUCLS"," ");
					
					return newData;
			}
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");	
			}else if(name == "BOXDTL"){
				param.put("CODE", "BOXDTL");
			}else if(name == "MIXTYP"){
				param.put("CODE", "MIXTYP");
			}else if(name == "SKUCLS"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");
			}
			
			return param;
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Create ADD BTN_CREATE"></button>
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
											
											<th CL="STD_BOXTYP"></th>
											<td>
												<select id="BOXTYP" name="BOXTYP" Combo="Common,COMCOMBO" value="<%=wareky%>" UISave="false" ComboCodeView=false style="width:160px">
													<option value='' selected>전체</option>
												</select>
											</td>
											
											<th CL="STD_BOXDTL"></th>
											<td>
												<select id="BOXDTL" name="BOXDTL" Combo="Common,COMCOMBO" value="<%=wareky%>" UISave="false" ComboCodeView=false style="width:160px">
													<option value='' selected>전체</option>
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
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="select,WAREKY"  >
													<select Combo="WmsCommon,ROLCTWAREKY" id="WAREKY" name="WAREKY" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_SHBXKY"    GCol="input,SHBXKY" GF="S 10" validate="required" ></td>
												<td GH="100 STD_SHBXNM"    GCol="input,SHBXNM" GF="S 20" validate="required" ></td>
												<td GH="100 STD_BATSEQ"    GCol="input,BATSEQ" GF="N 2" validate="required gt(0),MASTER_M4002"  ></td>
												<td GH="100 STD_BOXTYP"    GCol="select,BOXTYP" validate="required" >
													<select Combo="Common,COMCOMBO" id="BOXTYP" name="BOXTYP" ComboCodeView=false>
														<option value=' ' selected>선택</option>
													</select>
												</td>
												<td GH="100 STD_BOXDTL"    GCol="select,BOXDTL" validate="required" >
													<select Combo="Common,COMCOMBO" id="BOXDTL" name="BOXDTL" ComboCodeView=false>
														<option value=' ' selected>선택</option>
													</select>
												</td>
												<td GH="100 STD_WCSSND"    GCol="check,WCSSND" ></td>
												<td GH="100 STD_MIXTYP"    GCol="select,MIXTYP" validate="required" >
													<select Combo="Common,COMCOMBO" id="MIXTYP" name="MIXTYP" ComboCodeView=false>
														<option value=' ' selected>선택</option>
													</select>
												</td>
<!-- 												<td GH="100 라벨채번"    GCol="check,LABINS" ></td> -->
<!-- 												<td GH="100 NonLast"    GCol="input,LASTBN" GF="S 1" ></td> -->
<!-- 												<td GH="100 Last"    GCol="input,LASTBY" GF="S 1" ></td> -->
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
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_SHBXKY"   GCol="text,SHBXKY"></td>
												<td GH="100 STD_SKUCLS"    GCol="select,SKUCLS" validate="required" >
													<select Combo="Common,COMCOMBO" id="SKUCLS" name="SKUCLS" ComboCodeView=false>
														<option value=' ' selected>선택</option>
													</select>
												</td>
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