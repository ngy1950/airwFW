<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript">
	var dblIdx = -1;
	var subIdx = 0;
	var headSebeln = "";
	var headRownum = "";

	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
			id : "gridList",
			module : "WmsInbound",
			command : "GR00",
			itemGrid : "gridListSub",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridListSub",
			module : "WmsInbound",
			command : "GR00Sub",
         	validation : "LOCAKY",
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
	        
	        dblIdx = rowNum;
			subIdx = rowNum;
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
		if(mCount > 0  && gridList.validationCheck("gridListSub", "modify")){
			var chkItemIdx = gridList.getSelectRowNumList("gridListSub");
			var chkItemLen = chkItemIdx.length;	
			var itemModCnt = gridList.getSelectRowNumList("gridList").length;
			
			if( chkItemLen == 0 ){
				// 선택된 데이터가 없습니다.
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var selectSub = gridList.getGridData("gridListSub");
			
			var rowData;
			for(var i=0;i<selectSub.length;i++){
				rowData = selectSub[i];
				
				var QTYORD = new Number(rowData.get("QTYORD")); //오더수량
				var QTYRCV = new Number(rowData.get("QTYRCV")); //입고수량
				if((QTYORD - QTYRCV) < 0){
					commonUtil.msgBox("IN_M0078");
					return;
				}
			}
			
			var list = "";
			if(itemModCnt > 0 && dblIdx == subIdx){
				var head = gridList.getRowData("gridList", dblIdx);
				//list = gridList.getGridData("gridListSub");
				list = gridList.getSelectData("gridListSub");
				
				headSebeln = gridList.getColData("gridList", dblIdx, "SEBELN");
				headRownum = head.get("GRowNum");
			}
			
			var head = gridList.getSelectData("gridList");
			
			var param = new DataMap();
			param.put("head", head); 
			param.put("list", list);
			param.put("headSebeln", headSebeln);
			param.put("headRownum", headRownum);
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/SaveGR00.data",
				param : param
			});
			
			if(json.data["RESULTMSG"]){
				var msgList = json.data["RESULTMSG"].split("†");
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
			param.put("PTNRTY", "VD");
			return param;
		}else if(searchCode == "SHBZPTN2"){
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
		}else if(btnName == "Print"){
			reportPrint();
		}
	}
	
	function reportPrint(){
		//var listcnt = gridList.getGridDataCount("gridList");
		var head = gridList.getSelectData("gridList");

		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var prtseq = "";
		var param = new DataMap();
		param.put("head",head);
		
		// SELECT SEQ_PRTSEQ.NEXTVAL FROM DUAL (채번)
		var json = netUtil.sendData({
			module : "WmsInbound",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		param.put("PRTTYP","ASN");
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/savePrtseq.data",
			param : param
		});

		var url = "/ezgen/asn_receiving_list_rcv_order.ezg";
		var where = "AND PL.PRTSEQ = '" + prtseq + "'";
				
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%=langky%>', map, 650, 350);	
		
	}	
	
	function comboEventDataBindeBefore(comboAtt){
		if(comboAtt == "WmsOrder,RCPTTYCOMBO"){
			var param = new DataMap();
			param.put("DOCCAT", "100");
			param.put("PROGID", configData.MENU_ID);
			return param;
		}
	}
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE STD_SAVE"></button>
		<!-- <button CB="Print PRINT BTN_RCVPRINT"></button> -->
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
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" name="WAREKY" value="<%=wareky%>" readonly="readonly" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">화주</th>
						<td>
							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY" style="width: 150px;">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입고유형</th>
						<td>
							<select Combo="WmsOrder,RCPTTYCOMBO" name="RCPTTY" id="RCPTTY" style="width: 150px;">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDAT,3">입고예정일자</th>
						<td>
							<input type="text" name="EINDT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY,3"></th>
						<td>
							<input type="text" name="PO.LIFNR" UIInput="R,SHBZPTN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNNM"></th>
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_RECVKY'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_OWNRNM'></th>
												<th CL='STD_ASNDAT,3'></th>
												<th CL='STD_LOTA12'></th>
<!-- 												<th CL='STD_AREAKY'></th> -->
<!-- 												<th CL='STD_AREANM'></th> -->
												<th CL='STD_DPTNKY,3'></th>
												<th CL='STD_DPTNNM'></th>
												<th CL='STD_RCPTTY'></th>
												<th CL='STD_RCPTTYNM'></th>
												<th CL='STD_STATDO'></th>
<!-- 												<th CL='STD_STATDONM,2'></th> -->
												<th CL='STD_DOCTXT'></th>
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<td GCol="text,ASNDAT" GF="C N"></td>
												<td GCol="input,DOCDAT" GF="C N"></td>
<!-- 												<td GCol="text,AREAKY"></td> -->
<!-- 												<td GCol="text,AREANM"></td> -->
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNKYNM"></td>
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="text,STATDO"></td>
<!-- 												<td GCol="text,STATDONM"></td> -->
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
					<ul class="tab type2" id="commonMiddleArea">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>  
												<th GBtnCheck="true"></th>            
												<th CL='STD_ASNDKY'></th>   	       
												<th CL='STD_ASNDIT'></th>              
												<th CL='STD_SKUKEY'></th> 	       
												<th CL='STD_DESC01'></th>
												<th CL='STD_LOCARV'>기본입하지번</th>               
												<th CL='STD_QTYASN'>예정량</th>  	
												<th CL='STD_QTYRCV'>입고수량</th>      
												 
												<th CL='STD_UOMKEY'></th>              
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
										</colgroup>
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="input,LOCAKY,SHLOCMA" validate="required,VALID_M0904"></td>
												<td GCol="text,ASNQTY" GF="N 20,3"></td>
												<td GCol="input,QTYRCV" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
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