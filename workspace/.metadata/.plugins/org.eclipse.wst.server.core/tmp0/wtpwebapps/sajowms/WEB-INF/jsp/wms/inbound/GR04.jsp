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
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
			id : "gridList",
			module : "WmsInbound",
			command : "GR04",
			itemGrid : "gridListSub",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridListSub",
			module : "WmsInbound",
			command : "GR04Sub",
			defaultRowStatus : configData.GRID_ROW_STATE_START
		});
	   
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridListSub", true, ['LOTA06']);
	});
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridListSub",
	           param : param
	        });
		}
	}
 	
 	function getItemSearchParam(rowNum){
 		var rowData = gridList.getRowData("gridList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
 	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.resetGrid("gridList");
			gridList.resetGrid("gridListSub");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridList"){
			var param = inputList.setRangeParam("searchArea");
			return param;
		}else if(gridId == "gridListSub"){
			 var rowNum = gridList.getSearchRowNum("gridList");
			 if(rowNum == -1){
				 return false;
			 }else{
				 var param = getItemSearchParam(rowNum);
				 return param;
			 }
		}
	}
	
	function saveData(){
		var mCount = gridList.getGridDataCount("gridListSub");
		if(mCount > 0 && gridList.validationCheck("gridListSub", "modify")){
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var list = gridList.getGridData("gridListSub");
			var rowData;
			for(var i=0;i<list.length;i++){
				rowData = list[i];
				
				var QTYORD = new Number(rowData.get("QTYORD"));
				var QTYRCV = new Number(rowData.get("QTYRCV"));
				if((QTYORD - QTYRCV) < 0){
					commonUtil.msgBox("IN_M0124");
					return;
				}
			}
			
			var rowData1;
			for(var j=0; j<list.length; j++){
				rowData1 = list[j];
                if(rowData1.get("ASKU05") != "V"){
                   if(commonUtil.msgConfirm("IN_M0133")){ //메인이미지가 등록되지 않은 상품이 있습니다. 그래도 저장하시겠습니까?
                      break;
                   }else{
                      return;
                   }
                }
	       	}
				
			var headRowNum = gridList.getFocusRowNum("gridList");
			var head = gridList.getRowData("gridList", headRowNum);
			
			var param = new DataMap();
			
			param.put("head",head);
			param.put("list",list);
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/SaveGR01.data",
				param : param
			});
			
			if(json.data.length > 5 && json.data.length != 10){
				var msgList = json.data.split("†");
				var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
				commonUtil.msg(msgTxt);
				return;
			}
			
			if(json && json.data){
				commonUtil.msgBox("MASTER_M0564");
				gridList.resetGrid("gridList");
				gridList.resetGrid("gridListSub");
				searchList();
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode == "SHBZPTN"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("PTNRTY", "CT");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
		
	</div>
</div>
<!-- //contentHeader -->

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer" id="searchArea">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<!-- searchInBox -->		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY"></th>
						<td>
							<input type="text" name="WAREKY" name="WAREKY" size="8px"  value="<%=wareky%>" readonly="readonly" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY,2">입고창고</th>
						<td>
							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
								<!-- <option value="">선택</option> -->
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDAT,3">입고예정일자</th>
						<td>
							<input type="text" name="EINDT" UIInput="R" UIFormat="C N"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_EBELN">구매오더번호</th>
						<td>
							<input type="text" name="PO.EBELN" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY1,3"></th>
						<td>
							<input type="text" name="PO.LIFNR" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNNM1,3"></th>
						<td>
							<input type="text" name="BZ.NAME01" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_MATNR">품번</th>
						<td>
							<input type="text" name="PO.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="SM.DESC01" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- //searchInBox -->
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
						<li><a href="#tabs1-1" CL="STD_RECORDER"><span></span></a></li>
					</ul>
					<div id="tabs1-1">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_RECVKY'></th>
												<th CL='STD_EBELN'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_ASNDAT,3'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_AREANM'></th>
												<th CL='STD_DPTNKY1,3'></th>
												<th CL='STD_DPTNNM1,3'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,ASNDAT" GF="C N"></td>
												<td GCol="input,DOCDAT" GF="C N"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,AREANM"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNNM"></td>
												<td GCol="text,DOCUTY"></td>
												<td GCol="text,DOCTNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATDONM"></td>
												<td GCol="text,DOCTXT"></td>
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
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1" CL="STD_DETAILLIST"><span></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="util">
								<tr>
									<td>
										<button CB="Save SAVE STD_SAVE">
										</button>
									</td>
								</tr>
							</table>
							<div class="table type2" style="top:45px;">
								<div class="tableHeader">
									<table>
										<colgroup>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_LOCAKY,3'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_QTYORD'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_QTYRCV'></th>
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
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA11'></th>
												<!-- <th CL='STD_LOTA12'></th> -->
												<th CL='STD_LOTA13'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_RECVKY'></th>
												<th CL='STD_RECVIT'></th>
												<th CL='STD_ASKU05'></th>
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
										</colgroup>
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,LOCAKY" validate="required"></td>
												<td GCol="input,TRNUID" GF="S 30"></td>
												<td GCol="text,QTYORD" validate="unequal(0)" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,QTYRCV" GF="N 20,3"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="input,LOTA02"></td>
												<td GCol="input,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA16" GF="N 20,3"></td>
												<td GCol="text,LOTA17" GF="N 20,3"></td>
												<td GCol="input,LOTA11" GF="C N"></td>
												<!-- <td GCol="input,LOTA12" GF="C N"></td> -->
												<td GCol="input,LOTA13" GF="C N"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,ASKU05"></td>
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