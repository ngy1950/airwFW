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
			command : "IO05",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		gridList.setGrid({
	    	id : "gridItemList",
			editable : true,
			module : "WmsOrder",
			command : "IO05SUB"
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");

		gridList.setReadOnly("gridHeadList", true, ['INDRCV','CONFIM']);
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Delete"){
			saveData();
		}
	}
	
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
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
	    	id : "gridHeadList",
	    	param : param
	    });
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
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
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
				var vparam = new DataMap();
				vparam.put("list", head);
				vparam.put("key", "OWNRKY,SEBELN");
				
				var json = netUtil.sendData({
					url : "/wms/order/json/validationIO05.data",
					param : vparam
				});
				
				if(json.data != "OK"){
					var msgList = json.data.split(" ");
					var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
					commonUtil.msg(msgTxt);
					return false;
				}else{
					var param = new DataMap();
					param.put("head", head); 
					
					var json = netUtil.sendData({
						url : "/wms/order/json/saveIO05.data",
						param : param
					});  
					
					if(json && json.data){
						commonUtil.msgBox("VALID_M0003");  //?????? ??????
						//searchList();
						gridList.resetGrid("gridHeadList");
						gridList.resetGrid("gridItemList");
						
						searchList();
					}
				}
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		var param = new DataMap();
		if(searchCode == "SHSKUMA" || searchCode == "SHBZPTN"){
			param.put("OWNRKY", $('#OWNRKY').val());
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(searchCode == "SHDOCTM"){
			param.put("DOCCAT", "100");
			param.put("DOCGRP", "ITF");
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
							<td colspan="3"><input type="text" name="WAREKY" validate="required,VALID_M0401" value="<%=wareky%>" 
							readonly="readonly" size="22px" /></td>
						</tr>
<!-- 						<tr> -->
<!-- 							<th CL="STD_AREAKY">??????</th> -->
<!-- 							<td><select Combo="WmsAdmin,AREACOMBO" name="AREAKY" id="USERAREA" validate="required"></select> -->
<!-- 							</td> -->
<!-- 						</tr> -->
						<!-- <tr>
							<th CL="STD_OWNRKY">??????</th>
							<td>
								<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
								</select>
							</td>
						</tr> -->
						<tr>
							<th CL="STD_OWNRKY">??????</th>
							<td>
								<input type="text" name="RQ.WERKS" UIInput="R,SHOWNER" />
							</td>
						</tr>
						<tr>
							<th CL="STD_RCPTTY">????????????</th>
							<td>
								<input type="text" name="RQ.BWART" UIInput="R,SHDOCTM" />
							</td>
						</tr>
						<tr>
							<th CL="STD_RCVDAT">??????????????????</th>
							<td>
								<input type="text" name="RQ.EINDT" UIInput="R" UIFormat="C"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DPTNKY,3">?????????</th>
							<td>
								<input type="text" name="RQ.LIFNR" UIInput="R,SHBZPTN" />
							</td>
						</tr>
						<tr>
							<th CL="STD_DPTNNM">????????????</th>
							<td>
								<input type="text" name="VD.NAME01" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">??????</th>
							<td>
								<input type="text" name="RQ.SKUKEY" UIInput="R,SHSKUMA"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01">??????</th>
							<td>
								<input type="text" name="RQ.DESC01" UIInput="R" />
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
						<li><a href="#tabs1-1" CL="STD_RECINQ"><span>??????????????????</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SEBELN'>??????????????????</th>	 
												<th CL='STD_WAREKY'>??????</th>
												<th CL='STD_WARENM'>?????????</th>
												
												<th CL='STD_OWNRKY'>??????</th>
												<th CL='STD_OWNRNM'>?????????</th>
												<th CL='STD_DPTNKY,3'>?????????/???????????????</th>
												<th CL='STD_DPTNNM'>?????????/??????????????????</th>
												<th CL='STD_RCVDAT'>??????????????????</th>
<!-- 												<th CL='STD_AREAKY'>??????</th> -->
<!-- 												<th CL='STD_AREANM'>?????????</th> -->

												<th CL='STD_RCPTTY'>????????????</th>
												<th CL='STD_RCPTTYNM'>???????????????</th>
												<th CL='STD_SKUCNT'>?????????</th>
												<th CL='STD_INDRCV'>????????????</th>												
<!-- 												<th CL='STD_DOCTXT'>??????</th> -->
												<th CL='STD_DELMAK'>??????</th>
												
												<th CL='STD_CRTBY'>?????????</th>
												<th CL='STD_SAEDAT'>????????????</th>
												<th CL='STD_CRETIM'>????????????</th>
												<th CL='STD_LMODAT'>????????????</th>
												<th CL='STD_LMOTIM'>????????????</th>
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
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNNM"></td>
												<td GCol="text,EINDT" GF="D"></td>
<!-- 												<td GCol="text,AREAKY"></td> -->
<!-- 												<td GCol="text,AREANM"></td> -->
												
												<td GCol="text,RCPTTY"></td>
												<td GCol="text,RCPTTYNM"></td>
												<td GCol="text,CNTSKU" GF="N"></td>
												<td GCol="check,INDRCV"></td>
<!-- 												<td GCol="text,DOCTXT"></td>  -->
												<td GCol="check,CONFIM"></td>  <!-- ?????? -->
												
												<td GCol="text,USRID"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
											
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
											</colgroup>
											<thead>
												<tr>
													<th CL='STD_NUMBER'>??????</th>
													<th CL='STD_SEBELN'>??????????????????</th>
													<th CL='STD_SEBELP'>??????????????????</th>
													<!-- <th CL='STD_RCVRQK'></th> -->
													<!-- <th CL='STD_RCVRQI'></th> -->
													<th CL='STD_SKUKEY'>??????</th>
													<th CL='STD_DESC01'>??????</th>
													<!-- <th CL='STD_DESC02'></th> -->
													<th CL='STD_QTYORD'></th>
													<th CL='STD_UOMKEY'></th>
													<th CL='STD_QTYRCV'></th>
													<th CL='STD_QTURCV'></th>
													
													
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
											</colgroup>
											<tbody id="gridItemList">
												<tr CGRow="true">
													<td GCol="rownum"></td>
													<td GCol="text,EBELN"></td> 
													<td GCol="text,EBELP"></td>
													<td GCol="text,SKUKEY"></td> <!-- ?????? -->       
													<td GCol="text,DESC01"></td> <!-- ?????? -->     
													<!-- <td GCol="text,DESC02"></td> -->
													<td GCol="text,QTYORD" GF="N"></td> <!-- ???????????? -->
													<td GCol="text,UOMKEY"></td> <!-- ?????? -->
													<td GCol="text,QTYRCV" GF="N"></td> <!-- ???????????? -->
													<td GCol="text,QTURCV" GF="N"></td> <!-- ???????????? -->
													<!-- <td GCol="text,LOTA10" GF="S 20"></td> -->   
													<!-- <td GCol="text,LOTA16" GF="N 20,3"></td> --> 
													<!-- <td GCol="text,LOTA17" GF="N 20,3"></td> --> 
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