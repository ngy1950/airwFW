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
			module : "WmsApproval",
			command : "AP12",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
		
		gridList.setReadOnly("gridList", true, ["APRCOD"]);
		var $comboList = $('#searchArea').find("select[Combo]");
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}else if( btnName == "SaveData" ){
			SaveData();
			
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			
			var param = inputList.setRangeParam("searchArea");
			param.put("REQUSR", "<%=userid%>");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
			
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		var gridRowData = gridList.getRowData(gridId, rowNum);
		
		var param = new DataMap();
		param.put("APRCOD", gridRowData.get("APRCOD"));
		param.put("APRKEY", gridRowData.get("APRKEY"));
		param.put("WAREKY", "<%=wareky%>");
		param.put("USERID", "<%=userid%>");
		param.put("PROGID", "AP12");
		
		page.linkPopOpen("/wms/approval/POP/" + gridRowData.get("APRCOD") + "POP.page", param);
		
	}
	
	// 팝업 닫힐시 호출 
	function linkPopCloseEvent(){
		searchList();
	}
	
	//승인전환
	function SaveData(){
		var list = gridList.getSelectData("gridList", "A");
		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		var param = new DataMap();
		param.put("list", list);
		
		netUtil.send({
			url : "/wms/approval/json/saveAP12.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
	}
	
	function succsessSaveCallBack(json, status){
		if( json.data > 0 ){
			commonUtil.msgBox("MASTER_M0815", json.data); //{0}건이 저장되었습니다.
			gridList.resetGrid("gridList");
			searchList();
			
		}else if( json.data <= 0 ){
			commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			param.put("CODE","APRCOD");
			return param;
		}
	}
	
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="SaveData SAVE BTN_CHANGES"></button>
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
										<col width="450" />
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
											<th CL="STD_REQDAT"></th>
											<td>
												<input type="text" id="AM.REQDAT" name="AM.REQDAT" UIInput="B" UIFormat="C N" validate="required" MaxDiff="M1" />
											</td>
											<th CL="STD_APRCOD"></th>
											<td>
												<select id="APRCOD" name="APRCOD" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_MINERE"></th>
											<td>
												<input type="checkbox" id="USRCHK" name="USRCHK" value="V" checked />
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
												<td GH="40 STD_NUMBER"      GCol="rownum"></td>
												<td GH="40"                 GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_APRCOD"     GCol="text,ACODNM"></td>
												<td GH="100 STD_APSTUS"     GCol="text,ASTSNM"></td>
												<td GH="100 STD_APRNUM"     GCol="text,APRKEY"></td>
												<td GH="100 STD_REQDAT"     GCol="text,REQDAT"  GF="D"></td>
												<td GH="100 STD_REQTIM"     GCol="text,REQTIM"  GF="T"></td>
												<td GH="100 STD_REQUSR"     GCol="text,REQUSR"></td>
												<td GH="100 STD_RUSRNM"     GCol="text,RUSRNM"></td>
												<td GH="100 STD_RETEXT"     GCol="text,REQTXT"></td>
												<td GH="100 STD_APRDAT"     GCol="text,APRDAT"  GF="D"></td>
												<td GH="100 STD_APRTIM"     GCol="text,APRTIM"  GF="T"></td>
												<td GH="100 STD_APRUSR"     GCol="text,APRUSR"></td>
												<td GH="100 STD_AUSRNM"     GCol="text,AUSRNM"></td>
												<td GH="100 STD_APRTXT"     GCol="text,APRTXT"></td>
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