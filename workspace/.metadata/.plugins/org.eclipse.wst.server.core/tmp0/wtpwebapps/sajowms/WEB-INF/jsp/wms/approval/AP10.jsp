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
		setTopSize(100);
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			module : "WmsApproval",
			command : "AP10",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
		
		gridList.setReadOnly("gridList", true, ["APRTYP", "CRETYP"]);
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
			
		}
	}
	
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		
		if( searchCode == "SHROLCT" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}
	}
	
	// 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHROLCT" ){
			gridList.setColValue("gridList", gridList.getFocusRowNum("gridList"), "USERNM", rowData.get("NMLAST"));
			
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
			
			if( name == "APRTYP" ){
				param.put("CODE","APRTYP");
				
			}else if( name == "CRETYP" ){
				param.put("CODE","CRETYP");
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
<!-- 		<button CB="Save SAVE BTN_SAVE"></button> -->
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
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_CREDAT"></th>
											<td>
												<input type="text" id="AD.CREDAT" name="AD.CREDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_GUCREUR"></th>
											<td>
												<select id="APRTYP" name="APRTYP" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
<!-- 											<th CL="STD_STATUS"></th> -->
<!-- 											<td> -->
<!-- 												<select id="CRETYP" name="CRETYP" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px"> -->
<!-- 													<option value="">전제</option> -->
<!-- 												</select> -->
<!-- 											</td> -->
											<th CL="STD_USERID"></th>
											<td>
												<input type="text" id="USERID" name="USERID" UIInput="S,SHROLCT" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
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
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
<!-- 												<td GH="100 STD_WAREKY"     GCol="text,WAREKY"></td> -->
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_GUCRETY"    GCol="select,APRTYP">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="APRTYP"></select>
												</td>
												<td GH="100 STD_STATUS"     GCol="select,CRETYP">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="CRETYP"></select>
												</td>
												<td GH="100 STD_USERID"     GCol="text,USERID"></td>
												<td GH="100 STD_NAME01"     GCol="text,NMLAST"></td>
												<td GH="100 STD_ASUBFDT"    GCol="text,APFDAT"  GF="D"></td>
												<td GH="100 STD_ASUBTDT"    GCol="text,APTDAT"  GF="D"></td>
												<td GH="100 STD_CREDAT"     GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"     GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR,3"   GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"     GCol="text,CUSRNM"></td>
												<td GH="100 STD_ENDDAT"     GCol="text,ENDDAT"  GF="D"></td>
												<td GH="100 STD_ENDTIM"     GCol="text,ENDTIM"  GF="T"></td>
												<td GH="100 STD_ENDUSR"     GCol="text,ENDUSR"></td>
												<td GH="100 STD_EUSRNM"     GCol="text,EUSRNM"></td>
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
			<!-- 그리드 -->
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>