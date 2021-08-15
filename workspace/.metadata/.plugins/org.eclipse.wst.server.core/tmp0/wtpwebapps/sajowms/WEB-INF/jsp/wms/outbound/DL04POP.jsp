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
			module : "WmsOutbound",
			command : "DL04POP"
	    });
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		dataBind.dataNameBind(data, "dl04POP");

		searchList();
		gridList.setReadOnly("gridList", true, ['LOTA06']);
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
			
		 gridList.gridList({
	    	id : "gridList",
	    	param : param
	    }); 
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		sumQtasloSet();
	}
	
	function sumQtasloSet(){
	      var rowCnt = gridList.getGridDataCount("gridList");
	      var sumQtsalo = 0;
	      for(var i = 0; i < rowCnt; i++){
	         sumQtsalo = sumQtsalo + parseInt(gridList.getColData("gridList", i, "QTSALO"));
	      }

	      var param = inputList.setRangeParam("dl04POP");
	      var qtable = parseInt(param.get("QTABLE"));
	      param.put("QTALOC", sumQtsalo);
	      param.put("QTUALO", qtable - sumQtsalo);
	      dataBind.dataNameBind(param, "dl04POP");
	   }
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "QTSALO"){
			var oriVal = parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
			var modVal = parseInt(gridList.getColData(gridId, rowNum, colName));
			
			if(oriVal < modVal){
				commonUtil.msgBox("TASK_M0023");
				gridList.setColValue(gridId, rowNum, colName, 0);
			}else{
				sumQtasloSet();				
			}
		}
	}
	
	function fn_closing(){
		this.close();
		  //var data = gridList.getGridData("gridList");
	      //wms.linkPopClose(data);
	}
	
	function fn_reflect(){
		if(gridList.validationCheck("gridList", "select")){
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
		
			var cnt = gridList.getModifyRowCount("gridList");
			if(cnt < 1){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var param1 = inputList.setRangeParam("dl04POP");
			var qtualo = commonUtil.parseInt(param1.get("QTUALO"));
		    if(qtualo < 0){
		         alert("저장할 수 없습니다.");
		         return;
			}
			
			var list = gridList.getGridData("gridList");
			
			var param = inputList.setRangeParam("searchArea");
			param.put("list",list);
				
			var json = netUtil.sendData({
				url : "/wms/outbound/json/DL04POPSave.data",
				param : param
			});
			
			if(json && json.data){
				var data = inputList.setRangeParam("dl04POP");
			    //wms.linkPopClose(data);
				page.linkPopClose(data);
			}else{
				commonUtil.msgBox("VALID_M0002");
			}
		}
	}
	
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
		<button CB="Search SEARCH BTN_CLEAR">
		</button>
		<button CB="Reflect SAVE STD_SAVE">
		</button>
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
						<th CL="STD_SHPOKY">거점</th>
						<td>
							<input type="text" name="SHPOKY" UIInput="S"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPOIT">거점</th>
						<td>
							<input type="text" name="SHPOIT" UIInput="S"/>
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
							<div id="dl04POP">
								<table class="table type1">
								<colgroup>
									<col width="100" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY">거점</th>
										<td>
											<input type="text" name="WAREKY" size="10px" readonly="readonly"/>
											<input type="text" name="WARENM" size="40px" readonly="readonly"/>
										</td>
										<th CL="STD_QTSHPO">출고작업수량</th>
										<td>
											<input type="text" name="QTSHPO" size="10px" readonly="readonly"/>
											<input type="text" name="UOMKEY" size="7px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_OWNRKY">화주</th>
										<td>
											<input type="text" name="OWNRKY" size="10px" readonly="readonly"/>
											<input type="text" name="OWNRNM" size="40px" readonly="readonly"/>
										</td>
										<th CL="STD_QTJCMP">피킹완료수량</th>
										<td>
											<input type="text" name="QTJCMP" size="10px" readonly="readonly"/>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<label CL="STD_QTABLE"></label>
											<input type="text" name="QTABLE" size="10px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_AREAKY">창고</th>
										<td>
											<input type="text" name="AREAKY" size="10px" readonly="readonly"/>
											<input type="text" name="AREANM" size="40px" readonly="readonly"/>
										</td>
										<th CL="STD_QTALOC">할당수량</th>
										<td>
											<input type="text" name="QTALOC" size="10px" readonly="readonly"/>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<label CL="STD_QTUALO"></label>&nbsp;&nbsp;
											<input type="text" name="QTUALO" size="10px" readonly="readonly"/>
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
										<th CL="STD_DPTNKY,2">배송처</th>
										<td>
											<input type="text" name="DPTNKY" size="10px" readonly="readonly"/>
											<input type="text" name="DPTNNM" size="40px" readonly="readonly"/>
										</td>
										<th CL="STD_PTRCVR,3">매출처</th>
										<td>
											<input type="text" name="PTRCVR" size="10px" readonly="readonly"/>
											<input type="text" name="PTRCNM" size="30px" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SHPOKY">출고문서번호</th>
										<td>
											<input type="text" name="SHPOKY" size="10px" readonly="readonly"/>
											<input type="text" name="SHPOIT" size="7px" readonly="readonly"/>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<label CL="STD_SVBELN"></label>
											<input type="text" name="SVBELN" size="10px" readonly="readonly"/>
											<input type="text" name="SPOSNR" size="7px" readonly="readonly"/>
										</td>
										<th CL="STD_ALSTKY"></th>
										<td>
											<input type="text" name="ALSTKY" size="10px" readonly="readonly"/>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<label CL="STD_LOTA13"></label>&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="text" name="LOTA13" size="10px" readonly="readonly"/>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_ROWCK'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TRNUID'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_QTSIWH'></th>
												<th CL='STD_QTSALO'></th>
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
										</colgroup>
										<tbody id="gridList">
										<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="check,CHECKROW"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,ZONEKY"></td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,TRNUID"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GCol="input,QTSALO" GF="N 20,3" validate="gt(0)"></td>
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
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>	
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