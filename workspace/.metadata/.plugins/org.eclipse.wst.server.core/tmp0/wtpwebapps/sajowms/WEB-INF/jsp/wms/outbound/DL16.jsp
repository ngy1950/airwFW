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
		setTopSize(300);
		
		var rangeMap = new DataMap();
		var rangeList = new Array();
		
		rangeMap.put("OPER", "E");
		rangeMap.put("DATA", "210");
		rangeList.push(rangeMap);
		
		inputList.setRangeData("TASDH.TASOTY", configData.INPUT_RANGE_TYPE_SINGLE, rangeList);

		gridList.setGrid({
			id : "gridHeadList",
			//pkcol : "TASKKY, WAREKY",
			module : "WmsOutbound",
			command : "DL06HEAD",
			itemGrid : "gridList",
			itemSearch : true
	    });
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsOutbound",
			command : "DL06"
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridList", true, ['LOTA06']);
	});
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridList",
	           param : param
	        });
		}
	}
 	
 	function getItemSearchParam(rowNum){
 		var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
 	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			var refdat1 = param.get("REFDAT1");
			var refdat2 = param.get("REFDAT2");
			var date1 = uiList.getDateObj(refdat1);
		    var date2 = uiList.getDateObj(refdat2);
		    var day = (date2 - date1)/1000/60/60/24; 
			
			if(day > 30){
				commonUtil.msgBox("OUT_M0169");  //????????? ??????????????? ????????? 30??? ????????? ??????????????????.
				return;
			}else if(date1 > date2){
				commonUtil.msgBox("OUT_M0170");
				return;
			}
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridExcelDownloadEventBefore(gridId){
		if(gridId == "gridHeadList"){
			var param = inputList.setRangeParam("searchArea");
			return param;
		}else if(gridId == "gridList"){
			 var rowNum = gridList.getSearchRowNum("gridHeadList");
			 if(rowNum == -1){
				 return false;
			 }else{
				 var param = getItemSearchParam(rowNum);
				 return param;
			 }
		}
	}
	
	function pkComplete(){ // ????????????
		if(!commonUtil.msgConfirm("OUT_M0151")){
			return;
		}
	
		//var headRowNum = gridList.getFocusRowNum("gridHeadList");
		//var head = gridList.getRowData("gridHeadList", headRowNum);
		var list = gridList.getSelectData("gridList");
		
		if(list.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("list", list);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/CompleteDL16.data",
			param : param
		});
		
		if(json && json.data){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridList");
			commonUtil.msgBox("OUT_M0152");
			searchList();
		}
	}
	
	function inputListEventRangeDataChange(rangeName, singleData, rangeData){
		if(rangeName == "TASDI.SHPOKY" || rangeName == "TASDI.SVBELN" || rangeName == "TASDI.SEBELN" || rangeName == "TASDI.SKUKEY"){
			var dataCount = inputList.getDataCount("TASDI.SHPOKY")
	                      + inputList.getDataCount("TASDI.SVBELN")
	                      + inputList.getDataCount("TASDI.SEBELN")
	                      + inputList.getDataCount("TASDI.SKUKEY");
			if(dataCount == 0){
				var now = new Date();
	 			now.setDate(now.getDate());
	 			var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
	 			$("#searchArea").find("[name=REFDAT]").val(tmpValue);
	            inputList.addValidation("REFDAT", "required");
			}else{
	            $("#searchArea").find("[name=REFDAT]").val("");
	            inputList.removeValidation("REFDAT", "required");
			}
		}      
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Work"){
			pkComplete();
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Work WORK STD_PICKYN">
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
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">????????????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">??????</th>
						<td colspan="3">
							<input type="text" name="WAREKY" value="<%= wareky %>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">????????????</th>
						<td>
							<input type="text" name="TASDH.TASOTY" UIInput="R,SHDOCTM" value="" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">??????</th>
						<td>
							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_RQSHPD">??????????????????</th>
						<td>
							<!-- <input type="text" name="REFDAT" UIFormat="C N" validate="required"/> -->
							<input type="text" name="REFDAT1" UIFormat="C N" validate="required"/> ~ <input type="text" name="REFDAT2" UIFormat="C N" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA07"></th>
						<td>
							<input type="text" name="TASDI.SEBELN" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA04"></th>
						<td>
							<input type="text" name="TASDI.LOTA04" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="TASDI.SKUKEY" UIInput="R,SHSKUMA"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_WMSINFO">WMS ??????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_TASKKY">??????????????????</th>
						<td>
							<input type="text" name="TASDH.TASKKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">??????????????????</th>
						<td>
							<input type="text" name="TASDI.SHPOKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">ECMS ????????????</th>
						<td>
							<input type="text" name="TASDI.SVBELN" UIInput="R" />
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
						<li><a href="#tabs" CL="STD_LIST"><span>?????????</span></a></li>
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
												<th CL='STD_NUMBER'>??????</th>
												<th CL='STD_TASKKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_TASOTY'></th>
												<th CL='STD_TASONM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA04'></th>
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
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,TASKKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,TASOTY"></td>
												<td GCol="text,TASONM"></td>
												<td GCol="text,DOCDAT" GF="C"></td>
												<td GCol="text,CREDAT" GF="C"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="C"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,LOTA04"></td>
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
						<li><a href="#tabs1-1"><span CL="STD_ITEMLST">ITEM ?????????</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_TASKKY'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_LOCASR'></th>
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
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,TASKKY"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,QTTAOR" GF="N"></td>
												<td GCol="input,QTCOMP" GF="N 20,3" validate="required max(GRID_COL_QTTAOR_*),TASK_M0033"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11" GF="C"></td>
												<td GCol="text,LOTA12" GF="C"></td>
												<td GCol="text,LOTA13" GF="C"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
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