<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL04POP</title>
<%@ include file="/common/include/popHead.jsp" %>
<%
	String wareky = request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString();
	String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String compky = request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY).toString();
	String ownrky = request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_KEY).toString();
%>
<script type="text/javascript">

	window.resizeTo('1000','700');
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsTask",
			command : "DL06POP"
	    });
		
		var data = page.getLinkPopData();
		
		dataBind.dataNameBind(data, "searchArea");
		dataBind.dataNameBind(data, "dl06POP");

		searchList(data);
		gridList.setReadOnly("gridList", true, ['LOTA06']);
	});
	
	function searchList(data){
		var param = inputList.setRangeParam("searchArea");
	    var appendQuery = data.get("APPEND_QUERY");
// 		alert("data.APPEND_QUERY--->"+ data.get("APPEND_QUERY"));
		
	    param.put("APPEND_QUERY",appendQuery);
// 		alert("param ---> " + param);
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    }); 
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
			var rowData = gridList.getRowData(gridId, rowNum);
			var headData = inputList.setRangeParam("dl06POP");
			rowData.put("TASKIT",headData.get("TASKIT"));
			
			page.linkPopClose(rowData);
	}
	
	
// 	function gridListEventDataBindEnd(gridId, dataLength){
// 		sumQtasloSet();
// 	}
	
// 	function sumQtasloSet(){
// 	      var rowCnt = gridList.getGridDataCount("gridList");
// 	      var sumQtsalo = 0;
// 	      for(var i = 0; i < rowCnt; i++){
// 	         sumQtsalo = sumQtsalo + parseInt(gridList.getColData("gridList", i, "QTSALO"));
// 	      }

// 	      var param = inputList.setRangeParam("dl06POP");
// 	      var qtable = parseInt(param.get("QTABLE"));
// 	      param.put("QTALOC", sumQtsalo);
// 	      param.put("QTUALO", qtable - sumQtsalo);
// 	      dataBind.dataNameBind(param, "dl04POP");
// 	   }
	
// 	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
// 		if(colName == "QTSALO"){
// 			var oriVal = parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
// 			var modVal = parseInt(gridList.getColData(gridId, rowNum, colName));
			
// 			if(oriVal < modVal){
// 				commonUtil.msgBox("TASK_M0023");
// 				gridList.setColValue(gridId, rowNum, colName, 0);
// 			}else{
// 				sumQtasloSet();				
// 			}
// 		}
// 	}
	
	function fn_closing(){
		this.close();
		  //var data = gridList.getGridData("gridList");
	      //wms.linkPopClose(data);
	}
	
// 	function fn_reflect(){
// 		if(gridList.validationCheck("gridList", "select")){
// 			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
// 				return;
// 			}
		
// 			var cnt = gridList.getModifyRowCount("gridList");
// 			if(cnt < 1){
// 				commonUtil.msgBox("VALID_M0006");
// 				return;
// 			}
			
// 			var param1 = inputList.setRangeParam("dl04POP");
// 			var qtualo = commonUtil.parseInt(param1.get("QTUALO"));
// 		    if(qtualo < 0){
// 		         alert("저장할 수 없습니다.");
// 		         return;
// 			}
			
// 			var list = gridList.getGridData("gridList");
			
// 			var param = inputList.setRangeParam("searchArea");
// 			param.put("list",list);
				
// 			var json = netUtil.sendData({
// 				url : "/wms/outbound/json/DL04POPSave.data",
// 				param : param
// 			});
			
// 			if(json && json.data){
// 				var data = inputList.setRangeParam("dl04POP");
// 			    //wms.linkPopClose(data);
// 				page.linkPopClose(data);
// 			}else{
// 				commonUtil.msgBox("VALID_M0002");
// 			}
// 		}
// 	}
	
	function commonBtnClick(btnName){
		if(btnName == "Reflect"){
			fn_reflect();
		}else if(btnName == "Check"){
			fn_closing();
		}else if(btnName == "Search"){
			searchList();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
<!-- 		<button CB="Search SEARCH BTN_CLEAR"> -->
<!-- 		</button> -->
<!-- 		<button CB="Reflect SAVE STD_SAVE"> -->
<!-- 		</button> -->
		<button CB="Check CHECK BTN_CLOSE">
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
						<td>
							<input type="text" name="WAREKY" UIInput="S"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<input type="text" name="OWNRKY" UIInput="S"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">SKU</th>
						<td>
							<input type="text" name="SKUKEY" UIInput="S"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_TASKKY">작업지시번호</th>
						<td>
							<input type="text" name="TASKKY" UIInput="S"/>
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
						<li><a href="#tabs"><span CL="STD_LIST">리스트</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div id="dl06POP" >
								<table class="table type1">
								<colgroup>
									<col width="100" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_TASKKY">작업문서번호</th>
										<td>
											<input type="text" name="TASKKY" size="10px" readonly="readonly"/>
											<input type="text" name="TASKIT" size="7px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_WAREKY">거점</th>
										<td>
											<input type="text" name="WAREKY" size="10px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_OWNRKY">화주</th>
										<td>
											<input type="text" name="OWNRKY" size="10px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SKUKEY">품번</th>
										<td>
											<input type="text" name="SKUKEY" size="10px" readonly="readonly"/>
											<input type="text" name="DESC01" size="40px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SHPOKY">출고문서번호</th>
										<td>
											<input type="text" name="SHPOKY" size="10px" readonly="readonly"/>
											<input type="text" name="SHPOIT" size="7px" readonly="readonly"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
				<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_DETAILLIST"><span></span></a></li>
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
												<th CL='STD_AREAKY'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTSAVB'></th>
												<th CL='STD_QTSIWHAVB'></th>
												<th CL='STD_QTSWRK'></th>
												<th CL='STD_UOMKEY'></th>
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
										<tbody id="gridList">
										<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,ZONEKY"></td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,TRNUID"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,QTSAVB" GF="N 20,3"></td>
												<td GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GCol="text,QTSWRK" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
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
												<td GCol="text,LOTA11" GF="C N"></td>
												<td GCol="text,LOTA12" GF="C N"></td>
												<td GCol="text,LOTA13" GF="C N"></td>
												<td GCol="text,LOTA16" GF="N 20,3"></td>
												<td GCol="text,LOTA17" GF="N 20,3"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="copy"></button> -->
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button>	 -->
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
		<!-- //contentContainer -->
	    
	    </div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>