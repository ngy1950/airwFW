<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">
	var menuId = configData.MENU_ID;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsTask",
			command : "TK32"
	    });
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			pkcol : "WAREKY,STOKKY",
			module : "WmsTask",
			command : "TK32SUB"
	    });
		$("#USERAREA").val("<%=user.getUserg5()%>");
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reflect"){
			setRsncod();
		}
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var tasoty = param.get("TASOTY");
			param.put("TASOTY",tasoty);		
			param.put("MENUID", menuId);
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
			
			$("#rsncodCombo").val("");
		}
	}
	
 	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridItemList" && dataLength > 0){
			searchSubList();
		}
	} 
	
 	function searchSubList(){
 		var param = inputList.setRangeParam("searchArea");
 		
		gridList.gridList({
	    	id : "gridHeadList",
	    	param : param
	    });
	}
 	
	function setRsncod(){
		var rsncodCombo = $("#rsncodCombo").val();
		var selectNumList = gridList.getSelectRowNumList("gridItemList");

		if(selectNumList.length < 1){
			commonUtil.msgBox("VALID_M1501"); //"사유코드를 적용할 레코드를 선택해주세요"
		}
		if(rsncodCombo){
			for(var i=0;i<selectNumList.length;i++){
				var rowNum = selectNumList[i];
				gridList.setColValue("gridItemList", rowNum, "RSNCOD", rsncodCombo);
			}
			gridList.setColFocus("gridItemList", rowNum, "RSNCOD");
		}
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridItemList", "select")){
			var chkRowCnt = gridList.getSelectRowNumList("gridItemList").length;
			var chkRowIdx = gridList.getSelectRowNumList("gridItemList");
			
			if(chkRowCnt > 0){
				var head = gridList.getRowData("gridHeadList", 0);
				var list = gridList.getSelectData("gridItemList");
				
				var param = new DataMap();
				param.put("head", head);
				param.put("list", list);
				param.put("MNUID", "TK33");
				
				var json = netUtil.sendData({
					url : "/wms/task/json/saveTK32.data",
					param : param
				});
				
				if(json && json.data){
					commonUtil.msgBox("MASTER_M0564");
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridItemList");
					searchList();
				}
			}else{
				commonUtil.msgBox("TASK_M0003");
				return false;
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = dataBind.paramData("searchArea");
		if(searchCode == "SHZONMA" || searchCode == "SHLOCMA" || searchCode == "SHSKUMA" || searchCode == "SHBZPTN"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("PTNRTY", "VD");
			return param;
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY"></th>
						<td><input type="text" name="WAREKY" value="<%=wareky%>" size="8px" readonly="readonly"/></td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">작업타입</th>
						<td GCol="select,TASOTY">
							<select Combo="WmsTask,TK33DOCUTYCOMBO" name="TASOTY">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">창고</th>
						<td>
							<input type="text" name="ST.AREAKY" id="AREAKY" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY">구역</th>
						<td>
							<input type="text" name="ST.ZONEKY" UIInput="R,SHZONMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="ST.LOCAKY" UIInput="R,SHLOCMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TRNUID">팔레트 ID</th>
						<td>
							<input type="text" name="ST.TRNUID" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_STINFO">재고정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="ST.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="ST.DESC01" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_LOTINFO">LOT 정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_LOTA01">공급업체</th>
						<td>
							<input type="text" name="ST.LOTA01" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA02">부서코드</th>
						<td>
							<input type="text" name="ST.LOTA02" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA03">개별바코드</th>
						<td>
							<input type="text" name="ST.LOTA03" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA06">재고상태</th>
						<td>
							<input type="text" name="ST.LOTA06" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA11">제조일자</th>
						<td>
							<input type="text" name="ST.LOTA11" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA12">입고일자</th>
						<td>
							<input type="text" name="ST.LOTA12" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA13">유효기간</th>
						<td>
							<input type="text" name="ST.LOTA13" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA16">매입단가</th>
						<td>
							<input type="text" name="ST.LOTA16" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA17">매출단가</th>
						<td>
							<input type="text" name="ST.LOTA17" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA10">통화</th>
						<td>
							<input type="text" name="ST.LOTA10" UIInput="R" />
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

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs" CL="STD_LIST"><span>리스트</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_TASKKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_DOCDAT'></th>
												
<!-- 												<th CL='STD_AREAKY'></th> -->
<!-- 												<th CL='STD_AREANM'></th> -->
												<th CL='STD_DOCUTY'></th>
												<th CL='STD_DOCTNM'></th>
												<th CL='STD_STATDO'></th>
												
												<th CL='STD_STATDONM,2'></th>
												<th CL='STD_DOCTXT'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,TASKKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="input,DOCDAT" GF="C 8"></td>
<!-- 												<td GCol="text,AREAKY"></td> -->
<!-- 												<td GCol="text,AREANM"></td> -->
												<td GCol="text,TASOTY"></td>
												<td GCol="text,DOCTNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATNM"></td>
												<td GCol="input,DOCTXT"></td>
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

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_ITEMLST"><span>ITEM 리스트</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="util">
								<tr>
									<th CL="STD_RSNCOD"></th>
									<td>
										<select ReasonCombo="399" id="rsncodCombo" validate="required,INV_M0054">
										</select>
									</td>
									<td>
										<button CB="Reflect REFLECT BTN_REFLECT">
										</button>
									</td>
								</tr>
							</table>
							<div class="table type2" style="top:45px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												
												<th CL='STD_DESC02'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_QTSIWH'></th>
												<th CL='STD_UOMKEY'></th>
												
												<th CL='STD_MEASKY'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA03'></th>
												
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												
												<!-- <th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th> -->
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<!-- <th CL='STD_LOTA18'></th>
												
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th> -->
												<th CL='STD_RSNCOD'></th>
												<th CL='STD_TASRSN'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,STOKKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
											
												<td GCol="text,DESC02"></td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,TRNUID"></td>
												<td GCol="text,QTSIWH" GF="N"></td>
												<td GCol="text,UOMKEY"></td>
											
												<td GCol="text,MEASKY"></td>
												<td GCol="input,QTTAOR" GF="N" validate="max(GRID_COL_QTSIWH_*),TASK_M0023"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
											
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,LOTA06"></td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
											
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11" GF="D"></td>
												<td GCol="text,LOTA12" GF="D"></td>
												<td GCol="text,LOTA13" GF="D"></td>
											
												<!-- <td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td> -->
												<td GCol="text,LOTA16" GF="N 20,3"></td>
												<td GCol="text,LOTA17" GF="N 20,3"></td>
												<!-- <td GCol="text,LOTA18"></td>
											
												<td GCol="text,LOTA19"></td>
												<td GCol="text,LOTA20"></td> -->
												
												<td GCol="select,RSNCOD" validate="required,VALID_M0413">
													<select ReasonCombo="399">
														<option value=""> </option>
													</select>
												</td>
												<td GCol="input,TASRSN" GF="S 255"></td>
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