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
		rangeMap.put("DATA", "310");
		rangeList.push(rangeMap);
		
		inputList.setRangeData("TASDH.TASOTY", configData.INPUT_RANGE_TYPE_SINGLE, rangeList);

		gridList.setGrid({
			id : "gridHeadList",
			//pkcol : "TASKKY, WAREKY",
			module : "WmsTask",
			command : "PT02HEAD",
			itemGrid : "gridList",
			itemSearch : true
	    });
		
		gridList.setGrid({
			id : "gridList",
			module : "WmsTask",
			command : "PT02"
	    });
		
<%-- 		$("#USERAREA").val("<%=user.getUserg5()%>"); --%>
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
	

	function pkComplete(){
		
		// 적치완료
		var chkRowCnt = gridList.getSelectRowNumList("gridList").length;
		var chkRowIdx = gridList.getSelectRowNumList("gridList");			
		if(chkRowCnt < 1){
			commonUtil.msgBox("COMMON_M0053"); 						 		//아이템 리스트상의 작업 대상이 선택되지 않았습니다.
			return false;
		}			
		
		if(!commonUtil.msgConfirm("HHT_T0007")){							//저장하시겠습니까?
			return;
		}	
		
		// 밸리데이션 체크-수량,지번 입력 여부 
		for(var i = 0; i < chkRowCnt; i++){
			var taskit = gridList.getColData("gridList", chkRowIdx[i], "TASKIT");
			var qtcomp = gridList.getColData("gridList", chkRowIdx[i], "QTCOMP");
			var qttaor = gridList.getColData("gridList", chkRowIdx[i], "QTTAOR");					
			var locaac = gridList.getColData("gridList", chkRowIdx[i], "LOCAAC");					
			if ( parseInt(qtcomp) > parseInt(qttaor) ){
				commonUtil.msgBox("TASK_M0062",[taskit,qttaor,qtcomp]);	//작업아이템번호의 완료량이 지시량이 많습니다.
				return false;					
			}
    		if(locaac == null || locaac == "NaN" || locaac == "null" || locaac.trim() == ""){
    			commonUtil.msgBox("TASK_M0063",taskit);					//작업아이템번호의 지번이 입력되지 않았습니다.
				return false;			    		
    		}
		}
			
			// 지번 밸리데이션
 		var head = gridList.getSelectData("gridHeadList");
		var list = gridList.getSelectData("gridList");				
		var param = new DataMap();
 		param.put("head", head);
		param.put("list", list);
		var json = netUtil.sendData({
			url : "/wms/task/json/PTLocacValidation.data",			
			param : param
		});								
		if(json.data != "OK"){
			var msgList = json.data.split("†");
 			var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
			commonUtil.msg(msgTxt);										//작업아이템번호에 입력된 지번은 등록되지 않았습니다.
			return;
		}

			
// 		var workType = "2";				
// 		param.put("workType", workType);

		json = netUtil.sendData({
			url : "/wms/task/json/PT02SaveEnd.data",
			param : param
		});				
		if(json && json.data){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridList");
			commonUtil.msgBox("COOMON_M0463");								//저장이 완료되었습니다.
			searchList();
			}			
	}
		
	
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Work"){
			pkComplete();
		}else if(btnName == "Delete"){
			taskDelete();
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId=="gridList" && colName=="LOCAAC"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("LOCAKY", colValue);
				param.put("WAREKY", "<%=wareky%>");
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "LOCMAval",
					sendType : "map",
					param : param
				});

				if(json.data["CNT"] < 1){
					commonUtil.msgBox("HHTPROC_M0011"); //지번이 존재하지 않습니다.
					return;
				}
			}
		}
	}
	
	function taskDelete(){
		if(!commonUtil.msgConfirm("COMMON_M0026")){ //삭제하시겠습니까?
			return;
		}
	
		var list = gridList.getSelectData("gridList");
		
		if(list.length == 0){
			commonUtil.msgBox("VALID_M0006");			//선택된 데이터가 없습니다.
			return;
		}
		
		var param = new DataMap();
		param.put("list", list);
		
		var json = netUtil.sendData({
			url : "/wms/task/json/DeletePT02.data",
			param : param
		});
		
		if(json && json.data){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridList");
			commonUtil.msgBox("VALID_M0003");
			searchList();
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Work WORK BTN_PCONFIRM">
		</button>
		<button CB="Delete DELETE BTN_DELETE">
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
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td colspan="3">
							<input type="text" name="WAREKY" value="<%= wareky %>" readonly="readonly"/>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th CL="STD_OWNRKY">화주</th> -->
<!-- 						<td> -->
<!-- 							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY"> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th CL="STD_TASOTY">작업타입</th>
						<td>
							<input type="text" name="TASDH.TASOTY" UIInput="R,SHDOCTM" value="" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">전기일자</th>
						<td>
							<input type="text" name="DOCDAT1" UIFormat="C" /> ~ <input type="text" name="DOCDAT2" UIFormat="C"/> 
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_WMSINFO">WMS 정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
<!-- 					<tr> -->
<!-- 						<th CL="STD_AREAKY">창고</th> -->
<!-- 						<td> -->
<!-- 							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required"> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th CL="STD_TASKKY">작업지시번호</th>
						<td>
							<input type="text" name="TASDH.TASKKY" UIInput="R" />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_RQSHPD">출고요청일자</th>
						<td>
							<input type="text" name="REFDAT" UIFormat="C N" /> 
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOKY">출하문서번호</th>
						<td>
							<input type="text" name="TASDI.SHPOKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">ECMS 주문번호</th>
						<td>
							<input type="text" name="TASDI.SVBELN" UIInput="R" />
						</td>
					</tr> -->
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
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
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,TASKKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,TASOTY"></td>
												<td GCol="text,TASONM"></td>
												<td GCol="input,DOCDAT" GF="C"></td>
												<td GCol="text,CREDAT" GF="C"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="C"></td>
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
						<li><a href="#tabs1-1"><span CL="STD_ITEMLST">ITEM 리스트</span></a></li>
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
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_TRNUTG'></th>
												<th CL='STD_TRNUAC'></th>
												<th CL='STD_LOCAAC'></th>
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
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,LOCATG"></td>
												<td GCol="text,TRNUTG"></td>
												<td GCol="input,TRNUAC"></td>
												<td GCol="input,LOCAAC,SHLOCMA"></td>
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