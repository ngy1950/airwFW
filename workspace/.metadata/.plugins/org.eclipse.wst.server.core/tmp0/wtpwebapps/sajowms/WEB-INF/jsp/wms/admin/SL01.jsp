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
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "LOTNUM",
			module : "WmsAdmin",
			command : "LOTAT",
			bindArea : "tabs1-2"
			
	    });
	});
	
	function searchList() {
		//var param = dataBind.paramData("searchArea");
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function saveData() {
		var param = dataBind.paramData("searchArea");
		var json = gridList.gridSave({
			id : "gridList",
			param : param
			//modifyType : 'A'
		});
		//alert(json.MSG);
		if (json) {
			if (json.data) {
				searchList();
			}
		}
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}/* else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			
		} */
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY">
			</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button">
		<img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">Center Code</th>
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="searchInnerContainer">
		<div class="searchInBox">
			<h2 class="tit" value="LOT정보">LOT정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_LOTNUM">Lot Number</th>
						<td>
							<input type="text" name="LOTNUM" UIInput="R,SHLOTAT" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA01">원산지</th>
						<td>
							<input type="text" name="LOTA01" UIInput="R,SHCMCDV" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA02">ERP창고</th>
						<td>
							<input type="text" name="LOTA02" UIInput="R,SHCMCDV" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA03">임가공업체</th>
						<td>
							<input type="text" name="LOTA03" UIInput="R,SHCMCDV" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA11">생산일자</th>
						<td>
							<input type="text" name="LOTA11" UIInput="R" UIFormat="C"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>Item리스트</span></a></li>
						<li><a href="#tabs1-2"><span CL='STD_DETAIL'>상세</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="120" />
											<col width="70" />
											<col width="70" />
											<col width="120" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="90" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />					
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_LOTNUM'>Lot Number</th>
												<th CL='STD_WAREKY'>Center Code</th>
												<th CL='STD_OWNRKY'>Owner Code</th>
												<th CL='STD_SKUKEY'>품번코드</th>
												<th CL='STD_LOTA01'>원산지</th>
												<th CL='STD_LOTA02'>ERP창고</th>
												<th CL='STD_LOTA03'>임가공업체</th>
												<th CL='STD_LOTA04'>참조문서번호</th>
												<th CL='STD_LOTA05'>박스번호</th>
												<th CL='STD_LOTA06'>재고상태</th>
												<th CL='STD_LOTA07'>발주부서</th>
												<th CL='STD_LOTA08'>생산업체</th>
												<th CL='STD_LOTA09'>입고오더번호</th>
												<th CL='STD_LOTA10'>출하의뢰번호</th>
												<th CL='STD_LOTA11'>생산일자</th>
												<th CL='STD_LOTA12'>입고일자</th>
												<th CL='STD_LOTA13'>포장일자</th>
												<th CL='STD_LOTA14'>LOT속성14</th>
												<th CL='STD_LOTA15'>수주번호</th>
												<th CL='STD_LOTA16'>LOT속성16</th>
												<th CL='STD_LOTA17'>LOT속성17</th>
												<th CL='STD_LOTA18'>LOT속성18</th>
												<th CL='STD_LOTA19'>LOT속성19</th>
												<th CL='STD_LOTA20'>LOT속성20</th>
												<th CL='STD_CREDAT'>생성일자</th>
												<th CL='STD_CRETIM'>생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_CUSRNM'>생성자명</th>
												<th CL='STD_LMODAT'>수정일자</th>
												<th CL='STD_LMOTIM'>수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_LUSRNM'>수정자명</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="120" />
											<col width="70" />
											<col width="70" />
											<col width="120" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="90" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
											<col width="90" />
											<col width="70" />
											<col width="70" />
											<col width="70" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTA01"></td> <!-- S/N번호 SHCMCDV 재고유형 SHCMCDV 문서번호SHCMCDV-->
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,LOTA06"></td>
												<td GCol="text,LOTA07">발주부서</td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11" GF="D"></td>
												<td GCol="text,LOTA12" GF="D"></td>
												<td GCol="text,LOTA13" GF="D"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16"></td>
												<td GCol="text,LOTA17"></td>
												<td GCol="text,LOTA18"></td>
												<td GCol="text,LOTA19"></td>
												<td GCol="text,LOTA20"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
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
				<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2" GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_GENERAL">일반</h2>
									<table class="table type1">
										<colgroup>
											<col width="7%"/>
											<col width="26%"/>
											<col width="7%"/>
											<col width="25%"/>
											<col width="7%"/>
											<col width=""/>
										</colgroup>
										<tbody>
										<tr>
											<th CL='STD_LOTNUM'></th>
											<td>
												<input type="text" name="LOTNUM" readonly="readonly"/>
											</td>
											<th CL='STD_WAREKY'></th>
											<td>
												<input type="text" name="WAREKY" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_OWNRKY'></th>
											<td>
												<input type="text" name="OWNRKY" readonly="readonly"/>
											</td>
											<th CL='STD_SKUKEY'></th>
											<td>
												<input type="text" name="SKUKEY" readonly="readonly"/>
											</td>
										</tr>
									</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_DETAIL">상세</h2>
									<table class="table type1">
										<colgroup>
											<col width="7%"/>
											<col width="26%"/>
											<col width="7%"/>
											<col width="25%"/>
											<col width="7%"/>
											<col width=""/>
										</colgroup>
										<tbody>
										<tr>
											<th CL='STD_LOTA01'>원산지</th>
											<td>
												<input type="text" name="LOTA01" readonly="readonly"/>
											</td>
											<th CL='STD_LOTA04'>참조문서번호</th>
											<td>
												<input type="text" name="LOTA04" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_LOTA02'>ERP창고</th>
											<td>
												<input type="text" name="LOTA02"readonly="readonly"/>
											</td>
											<th CL='STD_LOTA11'>생산일자</th>
											<td>
												<input type="text" name="LOTA11" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_LOTA03'>임가공업체</th>
											<td>
												<input type="text" name="LOTA03" readonly="readonly"/>
											</td>
										</tr>
									</tbody>
									</table>
								</div>
							</div>
						</div>
		<!-- //contentContainer -->
	</div>
</div>
</div>
</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>