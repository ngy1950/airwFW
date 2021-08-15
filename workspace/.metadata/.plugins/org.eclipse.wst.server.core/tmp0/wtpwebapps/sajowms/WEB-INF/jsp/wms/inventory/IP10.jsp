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
			module : "WmsInventory",
			command : "IP10H",
			selectRowDeleteType : false,
			autoCopyRowType : false
		});
		
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
			gridList.resetGrid("gridList");
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}	
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
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
										<col width="80" />
										<col width="200" />
										<col width="80" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_IPDOCDT">수불반영일자</th>
										<td>
											<input type="text" name="IL.DOCDAT" id="DOCDAT" UIFormat="C Y" UIInput="B" validate="required" MaxDiff="M3" />
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
												<td GH="100 STD_WAREKY"     GCol="text,WARENM"></td>
												<td GH="100 STD_IPDOCDT"    GCol="text,DOCDAT"    GF="D"></td>
												<td GH="100 STD_SNDKEY"     GCol="text,SNDKEY"></td>
												<td GH="100 STD_UPDCHK"     GCol="text,UPDCHK"    GF="N"></td>
												<td GH="100 STD_WAITCNT"    GCol="text,WAIT_CNT"  GF="N"></td>
												<td GH="100 STD_SUSSCNT"    GCol="text,SUSS_CNT"  GF="N"></td>
												<td GH="100 STD_FAILCNT"    GCol="text,FAIL_CNT"  GF="N"></td>
												<td GH="100 STD_IPLDAT"     GCol="text,LMODAT,center"    GF="D"></td>
												<td GH="100 STD_IPLTIM"     GCol="text,LMOTIM,center"    GF="T"></td>
												<td GH="100 STD_IPLUID"     GCol="text,LMOUSR,center"></td>
												<td GH="100 STD_IPLUNM"     GCol="text,USERNM,center"></td>
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
<!-- 									<button type="button" GBtn="excel"></button> -->
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