<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>입고불가 상품 조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	
	window.resizeTo('1200','800');
	var linkData; 
	
	$(document).ready(function(){
		setTopSize(80);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR01POP",
			autoCopyRowType : false
		});
		
		linkData = page.getLinkPopData();
		//gridList.setReadOnly("gridList", true, ["SKUCLS"]);
		
		searchList("init");
	});

	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Save" ){
			saveData();
		}else if( btnName == "Reflect" ){ //일괄적용
			var gridId = "gridList";
			var selectData = $("#btnSkucls").val();
			var list = gridList.getSelectData(gridId);
			var listLen = list.length;
			
			if( listLen == 0 ){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return false; 
			}
			
			for( var i=0; listLen>i; i++ ){
				var chk_skucls = $.trim(list[i].get("CHK_SKUCLS"));
				var gridRowNum = list[i].get("GRowNum");
				if( chk_skucls == "" ){
					gridList.setColValue(gridId, gridRowNum, "SKUCLS", selectData);
				}
			}
		}
	}
	
	//헤더 조회
	function searchList(type){
		if( validate.check("searchArea") ){
			if(type == "init"){
				if(linkData.containsKey(configData.INPUT_RNAGE_DATA_PARAM)){
					var setKey = "AO.DOCDAT";
					var rageDataParam = linkData.get(configData.INPUT_RNAGE_DATA_PARAM);
					if(rageDataParam != null && rageDataParam != undefined){
						var bindKey = "";
						
						var keys = rageDataParam.keys();
						for(var i in keys){
							var key = keys[i];
							if(key.indexOf(setKey) > -1){
								bindKey = key;
							}
						}
						
						if(bindKey != ""){
							if(bindKey.indexOf("_") > -1){
								var fKeyArr = bindKey.split("_");
								var fKey = fKeyArr[0];
								var rangeType = fKeyArr[1];
								
								var rangeData = rageDataParam.get(bindKey);
								if($.trim(rangeData) != "" && rangeData != null && rangeData != undefined){
									var rangeDataArr = rangeData.split("↓");
									
									inputList.resetRange(fKey);
									
									var mangeMap = new DataMap();
									switch (rangeType) {
									case configData.INPUT_RANGE_TYPE_RANGE:
										mangeMap.put("OPER", rangeDataArr[0]);
										mangeMap.put("FROM", rangeDataArr[1]);
										mangeMap.put("TO", rangeDataArr[2]);
										break;
									case configData.INPUT_RANGE_TYPE_SINGLE:
										mangeMap.put("OPER", rangeDataArr[0]);
										mangeMap.put("DATA", rangeDataArr[1]);
										mangeMap.put("LOGICAL", rangeDataArr[2]);
										break;	
									default:
										break;
									}
									
									var rangeList = new Array();
									rangeList.push(mangeMap);
									
									inputList.setRangeData(fKey,rangeType,rangeList);
								}
							}
						}
					}
				}
			}
			
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("PROGID", linkData.get("PROGID"));
			$("#btnSkucls").val("");
			
			gridList.gridList({
				id : "gridList",
				param : param
			}); 
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList", "modify" )){
			var gridId = "gridList";
			var list = gridList.getModifyList(gridId, "A");
			
			if( list.length == 0 ){
				alert("수정된 내용이 없습니다");
				return false;
			}
			
			var param = new DataMap();
			param.put("list", list);
			
			netUtil.send({
				url : "/wms/inbound/json/SaveGR01POP.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564"); //저장 완료되었습니다.
			searchList();
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( colName == "WIDTHW" || colName == "LENGTH" || colName == "HEIGHT" ){ 
			var width = gridList.getColData(gridId, rowNum, "WIDTHW");
			var length = gridList.getColData(gridId, rowNum, "LENGTH");
			var height = gridList.getColData(gridId, rowNum, "HEIGHT");
			
			var cbm = parseFloat(width)*parseFloat(length)*parseFloat(height);
				cbm = cbm.toFixed(1);
			gridList.setColValue(gridId, rowNum, "CUBICM" , cbm);
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList" && dataLength == 0 ){
			gridList.resetGrid("gridList");
			
		}else if( gridId == "gridList" && dataLength > 0 ){
			
			// 그리드 로우 리드온리
			for( var i=0; i<dataLength; i++ ){
				var skucls = gridList.getColData("gridList", i, "SKUCLS");
				if( $.trim(skucls) == "" ){
					gridList.setRowReadOnly(gridId, i, false, ["SKUCLS"]);
				}else{
					gridList.setRowReadOnly(gridId, i, true, ["SKUCLS"]);
				}
			}
		}
	}
	
	/* function gridListColIconRemove(gridId, rowNum, colName, colValue){
		var skucls = gridList.getColData("gridList", rowNum, "SKUCLS");
		if( $.trim(skucls) == "" ){
			gridList.setRowReadOnly("gridList", rowNum, false, ["SKUCLS"]);
		}
	} */
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if( name == "SKUCLS"){
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
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										<th CL="STD_ASDDAT">입고예정일자</th>
										<td>
											<input type="text" name="AO.DOCDAT" UIInput="B" UIFormat="C N" validate="required"/>
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
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="reflect">
								물류분류
								<select Combo="Common,COMCOMBO" name="SKUCLS" id="btnSkucls">
									<option value="">선택</option>
								</select>
								<button CB="Reflect REFLECT BTN_REFLECT"></button>
							</div>
							
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                  GCol="rownum">1</td>
												<td GH="40"                  GCol="rowCheck"></td>
												<td GH="130 STD_SKUKEY"      GCol="text,SKUKEY"></td>
												<td GH="240 STD_DESC01"      GCol="text,DESC01"></td>
												<td GH="100 STD_SKUCNM,3"    GCol="text,LL05NM"></td>
												<td GH="80 STD_SKUCLSNM"     GCol="select,SKUCLS">
													<select id="SKUCLS" name="SKUCLS" Combo="Common,COMCOMBO">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_ABCANV"       GCol="text,ABCANV"></td>
												<td GH="80 STD_LOTA06"       GCol="text,LOTA06NM"></td>
												<td GH="100 STD_FIXLOC"      GCol="text,LOCAKY"></td>
												<td GH="80 STD_WIDTHW"       GCol="input,WIDTHW"    GF="N 8,1"></td>
												<td GH="80 STD_LENGTH"       GCol="input,LENGTH"    GF="N 8,1"></td>
												<td GH="80 STD_HEIGHT"       GCol="input,HEIGHT"    GF="N 8,1"></td>
												<td GH="80 STD_CUBICM"       GCol="text,CUBICM"     GF="N 8,1"></td>
												<td GH="100 STD_BOXCBM"      GCol="text,FIL_BOXCBM" GF="N"></td>
												<td GH="100 STD_WEIGHT"      GCol="text,WEIGHT"     GF="N"></td>
												<td GH="240 STD_RCVERR"      GCol="text,RCVERRNM"></td>
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
									<button type="button" GBtn="total"></button>
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
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>