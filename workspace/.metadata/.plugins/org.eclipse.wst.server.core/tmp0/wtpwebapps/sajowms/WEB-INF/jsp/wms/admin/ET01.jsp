<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<style>
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
	-webkit-appearance: none;
	margin: 0;
}
input[type="number"] {
	padding-left: 10px;
	border: 1px solid #cdcdcd;
}
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "WHOFF",
			excelRequestGridData : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsAdmin",
			command : "HOLID",
			excelRequestGridData : true,
			emptyMsgType : false
		});
		
		sysdate();
		gridList.setReadOnly("gridHeadList", true, ["OFFSUN", "OFFMON", "OFFTUE", "OFFWED", "OFFTHU", "OFFFRI", "OFFSAT"]);
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeParam("searchArea");
			
// 			if( !$.isNumeric(param.get("HOYEAR")) ){
// 				alert("연도는 숫자만 입력 가능합니다.");
// 				return false;
// 			}
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
			
			gridList.gridList({
				id : "gridItemList",
				param : param
			});
		}
	}
	
	//날짜
	function sysdate(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		} 
		
		$("#HOYEAR").val(yyyy);
		inputList.setMultiComboValue($("#HOLMON"), [mm]);
		
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("CODE", "MONTH");
			
			return param;
			
		}
	}
	
	
	//header 그리드 내 아이콘 조절
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if( gridId == "gridHeadList" ){
			if( colName == "OFFSUN"
			 || colName == "OFFMON"
			 || colName == "OFFTUE"
			 || colName == "OFFWED"
			 || colName == "OFFTHU"
			 || colName == "OFFFRI"
			 || colName == "OFFSAT"){
				if( colValue == "V" ){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
		}
	}
</script>
</head>
<body style="position: relative;">
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
<!-- 		<button CB="Save SAVE BTN_SAVE"></button> -->
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
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_HOYEAR"></th>
											<td>
												<input type="text" id="HOYEAR" name="HOYEAR" UIFormat="NS 4"  validate="required" />
											</td>
											<th CL="STD_HOLMON"></th>
											<td>
												<select id="HOLMON" name="HOLMON" Combo="Common,COMCOMBO" comboType="MS" ComboCodeView=false validate="required(STD_HOLMON)" style="width:160px">
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
												<td GH="100 STD_WAREKYNM" GCol="text,NAME01"></td>
												<td GH="100 STD_OFFSUN"   GCol="icon,OFFSUN" GB="regAft"></td>
												<td GH="100 STD_HOLMON"   GCol="icon,OFFMON" GB="regAft"></td>
												<td GH="100 STD_OFFTUE"   GCol="icon,OFFTUE" GB="regAft"></td>
												<td GH="100 STD_OFFWED"   GCol="icon,OFFWED" GB="regAft"></td>
												<td GH="100 STD_OFFTHU"   GCol="icon,OFFTHU" GB="regAft"></td>
												<td GH="100 STD_OFFFRI"   GCol="icon,OFFFRI" GB="regAft"></td>
												<td GH="100 STD_OFFSAT"   GCol="icon,OFFSAT" GB="regAft"></td>
												<td GH="100 STD_LMODAT"   GCol="text,LMODAT" GF="D"></td>
												<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM" GF="T"></td>
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
												<td GH="100 STD_HOLDAT"   GCol="text,HOLDAT" GF="D"></td>
												<td GH="100 STD_HOLTXT"   GCol="text,HOLTXT"></td>
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