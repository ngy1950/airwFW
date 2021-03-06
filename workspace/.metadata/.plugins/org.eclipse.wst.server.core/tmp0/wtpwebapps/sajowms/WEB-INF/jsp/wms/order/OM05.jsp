<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridHeadList",
			editable : true,
			module : "WmsOrder",
			command : "OM05",
			itemGrid : "gridItemList",
			itemSearch : true,
			validation : "SHPRQK"
	    });
		gridList.setGrid({
	    	id : "gridItemList",
			editable : true,
			module : "WmsOrder",
			command : "OM05SUB"
	    });
		
		gridList.setReadOnly("gridHeadList", true, ['INDTRN','INDRCV','INDDEL','INDSHP']);
		$("#USERAREA").val("<%=user.getUserg5()%>");
		
		var mangeMap = new DataMap();
		var rangeList = new Array();
		
		mangeMap.put("OPER", "E");
		mangeMap.put("DATA", "<%=userid%>");		
		rangeList.push(mangeMap);
		
		inputList.setRangeData("SR.CREUSR", configData.INPUT_RANGE_TYPE_SINGLE, rangeList);
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Delete"){
			saveData();
		}else if(btnName == "Print"){
			printList();
		}
	}
	
	/* function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
	        var rowData = gridList.getRowData(gridId, rowNum);
	        var param = inputList.setRangeParam("searchArea");
	        param.putAll(rowData);
	        
	        gridList.gridList({
	           id : "gridItemList",
	           param : param
	        });
		}
	}  */
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridItemList",
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
		}else if(gridId == "gridItemList"){
			 var rowNum = gridList.getSearchRowNum("gridHeadList");
			 if(rowNum == -1){
				 return false;
			 }else{
				 var param = getItemSearchParam(rowNum);
				 return param;
			 }
		}
	}
	
	/* function gridExcelDownloadEventBefore(gridId){
		//commonUtil.debugMsg("gridExcelDownloadEventBefore : ", arguments);
		if(gridId == "gridItemList" && dblIdx != -1){
			var param = getSearchSubParam(dblIdx); //?????? ????????? ?????????. ?????? ?????????????????? head ?????????????????? ????????? ????????? ????????? headRow??? ????????? dblIdx ????????? ?????? ?????? ??????. ???????????? headRow ???????????? ????????? ???????????? ?????? ??????.
			
			return param;
		}
	} */

	function saveData(){
		if(!commonUtil.msgConfirm("MASTER_M0020")){
			return;
		}
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var chkHeadIdx = gridList.getSelectRowNumList("gridHeadList");
			var chkHeadLen = chkHeadIdx.length;			
			if( chkHeadLen == 0 ){
				// ????????? ???????????? ????????????.
				commonUtil.msgBox("VALID_M0006");
				return;
			} else if (chkHeadLen > 0){
				var list = "";
				
				var head = gridList.getSelectData("gridHeadList");
			
				var param = new DataMap();
				param.put("head", head); 
				
				var json = netUtil.sendData({
					url : "/wms/order/json/saveOM05.data",
					param : param
				});   
				
				if(json.data.length > 5 && json.data.length != 10){
					var msgList = json.data.split("???");
					var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
					commonUtil.msg(msgTxt);
					return;
				} 
				
				if(json.data == "OK"){
					commonUtil.msgBox("VALID_M0003");  //?????? ??????
					//searchList();
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridItemList");
					
					searchList();
				}
			}
		}
	}
	
function saveData2(){
		
		if(!commonUtil.msgConfirm("MASTER_M0687")){
			return;
		}
		
		if(gridList.validationCheck("gridHeadList", "select")){
			alert(11)
			var head = gridList.getSelectData("gridHeadList");
			
			if(head.length == 0){
				commonUtil.msgBox("INV_M0055");
				return;
			}
			
			var param = new DataMap();
			
			param.put("head", head);
			
			var json = netUtil.sendData({
				url : "/wms/order/json/savePrtseq.data",
				param : param
			});
			
			if(json && json.data){
				
				var data = gridList.getRowData("gridList", headFocusNum);
				var param = new DataMap();
				param.put("PRTSEQ", data.get("SHPRQK"));
				
				gridList.gridList({
			    	id : "gridList",
			    	param : param
			    });
				
				var phyiitlist = "";
				var list = gridList.getSelectData("gridListSub");
				for(var i=0;i<list.length;i++){
					if(i != 0){
						phyiitlist += ",";
					}
					phyiitlist += "'"+list[i].get("SHPRQK")+"'";
				}
				
				commonUtil.msgBox("INV_M0051"); 
				
				param.put("PHYIITLIST", phyiitlist);
				
				gridList.gridList({
			    	id : "gridListSub",
			    	param : param
			    });
				
			}
		}
	}
	
	function printList(){
		
		var url = "";
		var prtseq = "";
		var head = gridList.getSelectData("gridHeadList");
		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		if(!commonUtil.msgConfirm("MASTER_M0687")){
			return;
		}
		
		var param = new DataMap();
		param.put("head", head);
		
		// SELECT SEQ_PRTSEQ.NEXTVAL FROM DUAL
		var json = netUtil.sendData({
			module : "WmsOrder",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		
		var json = netUtil.sendData({
			url : "/wms/order/json/savePrtseq.data",
			param : param
		});
		
		var where =   "AND PRTSEQ IN ('" + prtseq + "')";
		
		url = "/ezgen/shipping_req_list.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);	
		}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", "<%=ownrky%>");
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
			<button CB="Delete DELETE BTN_DELETE"></button>
			<button CB="Print PRINT BTN_PRINT33"></button>
		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
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
							<td colspan="3"><input type="text" name="WAREKY" size="8px" validate="required,VALID_M0401" value="<%=wareky%>" readonly="readonly" /></td>
						</tr>
						<tr>
							<th CL="STD_OWNRKY">??????</th>
							<td>
								<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_RQSHPD">??????????????????</th>
							<td>
								<input type="text" name="SR.RQSHPD" UIInput="R" UIFormat="C N" validate="required,VALID_M1555" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SHPOKY"></th>
							<td>
								<input type="text" name="SR.SHPOKY" UIInput="R"/>
							</td>
						</tr>
						</tr>
						<tr>
							<th CL="STD_SHPRQK"></th>
							<td>
								<input type="text" name="SR.SHPRQK" UIInput="R"/>
							</td>
						</tr>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">????????????</th>
							<td>
								<input type="text" name="SR.SKUKEY" UIInput="R,SHSKUMA"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01">??????</th>
							<td>
								<input type="text" name="SM.DESC01" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_CREUSR">??????</th>
							<td>
								<input type="text" name="SR.CREUSR" UIInput="R" validate="required"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

	</div>
	
<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_OUTINQ"><span>????????????</span></a></li>
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SHPRQK'>??????????????????</th>	 
<!-- 												<th CL='STD_SRQTYP'>????????????</th>	  -->
<!-- 												<th CL='STD_SRQTNM'>???????????????</th>	  -->
												<th CL='STD_WAREKY'>??????</th>
												<th CL='STD_WARENM'>?????????</th>
												<th CL='STD_RQSHPD'>??????????????????</th>
<!-- 												<th CL='STD_AREAKY'>??????</th> -->
<!-- 												<th CL='STD_AREANM'>?????????</th> -->
												<th CL='STD_SKUCNT'>?????????</th>
<!-- 												<th CL='STD_INDTRN'>??????????????????</th> -->
<!-- 												<th CL='STD_INDRCV,3'>??????????????????</th> -->
												<th CL='STD_INDDEL'>??????????????????</th>
												<th CL='STD_INDSHP'>??????????????????</th>
<!-- 												<th CL='STD_RDDALL'></th> -->
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
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
<!-- 											<col width="100" /> -->
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SHPRQK"></td>   <!-- ??????????????????-->
<!-- 												<td GCol="text,SRQTYP"></td>   ???????????? -->
<!-- 												<td GCol="text,SRQTNM"></td>   ??????????????? -->
												<td GCol="text,WAREKY"></td>   <!-- ??????  -->
												<td GCol="text,WARENM"></td>   <!-- ????????? -->
												<td GCol="text,RQSHPD" GF="D"></td>   <!-- ?????????????????? -->
<!-- 												<td GCol="text,AREAKY"></td>   ?????? -->
<!-- 												<td GCol="text,AREANM"></td>   ????????? -->
												<td GCol="text,CNTSKU" GF="N"></td>   <!-- ????????? -->
<!-- 												<td GCol="check,INDTRN"></td>  ?????????????????? -->
<!-- 												<td GCol="check,INDRCV"></td>  ?????????????????? -->
												<td GCol="check,INDDEL"></td>  <!-- ?????????????????? -->
												<td GCol="check,INDSHP"></td>  <!-- ?????????????????? -->
<!-- 												<td GCol="text,RDDALL"></td>  -->
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2" id="commonMiddleArea">
							<li><a href="#tabs1-1" CL="STD_ITEMLST"><span>Item ?????????</span></a></li>
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
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'>??????</th>
													<th CL='STD_SHPRQK'>??????????????????</th>
													<th CL='STD_SHPRQI'>??????????????????</th>
													<th CL='STD_SKUKEY'>??????</th>
													<th CL='STD_DESC01'>??????</th>
<!-- 													<th CL='STD_MATNR,3'>??????</th> -->
													
													<th CL='STD_DESC02'>??????</th>
													<th CL='STD_QTYORD'>??????????????????</th>
													<th CL='STD_UOMKEY'>??????</th>
<!-- 													<th CL='STD_QTYTRN'>??????????????????</th> -->
<!-- 													<th CL='STD_QTYTRS'>??????????????????</th> -->
													
<!-- 													<th CL='STD_QTYTRR'>??????????????????</th> -->
													<th CL='STD_QTALOC'>????????????</th>
													<th CL='STD_QTJCMP'>??????????????????</th>
													<th CL='STD_QTSHPD'>??????????????????</th>
													<th CL='STD_QTUSHP'>????????????</th>
													
<!-- 													<th CL='STD_TRNSHP'>????????????????????????</th> -->
<!-- 													<th CL='STD_TRNITM'>????????????????????????</th> -->
													<th CL='STD_SHPOKY'>??????????????????</th>
													<th CL='STD_SHPOIT'>??????????????????</th>
													<th CL='STD_LOTA10'></th>
													<th CL='STD_LOTA16'></th>
													<th CL='STD_LOTA17'></th>
<!-- 													<th CL='STD_LOTA02'></th> -->
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
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
<!-- 												<col width="100" /> -->
											</colgroup>
											<tbody id="gridItemList">
												<tr CGRow="true">
													<td GCol="rownum"></td>                 
													<td GCol="text,SHPRQK"></td>           <!-- ?????????????????? -->
													<td GCol="text,SHPRQI"></td>           <!-- ?????????????????? -->
													<td GCol="text,SKUKEY"></td>           <!-- ??????             -->
													<td GCol="text,DESC01"></td>           <!-- ??????              -->
<!-- 													<td GCol="text,MATNR"></td>            BQMS Code              -->
													
													<td GCol="text,DESC02"></td>           <!-- ??????              -->
													<td GCol="text,QTYORD" GF="N"></td>    <!-- ??????????????????  -->
													<td GCol="text,UOMKEY"></td>           <!-- ??????              -->
<!-- 													<td GCol="text,QTYTRN" GF="N"></td>    ??????????????????  -->
<!-- 													<td GCol="text,QTYTRS" GF="N"></td>    ??????????????????  -->
													
<!-- 													<td GCol="text,QTYTRR" GF="N"></td>    ??????????????????  -->
													<td GCol="text,QTALOC" GF="N"></td>    <!-- ????????????        -->
													<td GCol="text,QTJCMP" GF="N"></td>    <!-- ??????????????????  -->
													<td GCol="text,QTSHPD" GF="N"></td>    <!-- ??????????????????  -->
													<td GCol="text,QTUSHP" GF="N"></td>    <!-- ????????????        -->
													
<!-- 													<td GCol="text,TRNSHP"></td>           ???????????????????????? -->
<!-- 													<td GCol="text,TRNSHI"></td>           ???????????????????????? -->
													<td GCol="text,SHPOKY"></td>           <!-- ??????????????????  -->
													<td GCol="text,SHPOIT"></td>           <!-- ??????????????????  -->
													<td GCol="input,LOTA10" GF="S 20"></td>
													<td GCol="input,LOTA16" GF="N 20,3"></td>
													<td GCol="input,LOTA17" GF="N 20,3"></td>
<!-- 													<td GCol="text,LOTA02"></td>           ??????????????????  -->
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
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>