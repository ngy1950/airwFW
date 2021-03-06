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
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
			id : "gridList",
			module : "WmsOutbound",
			command : "DL08",
			itemGrid : "gridListSub",
			itemSearch : true
	    });
		
		gridList.setGrid({
			id : "gridListSub",
			module : "WmsOutbound",
			command : "DL04Sub"
	    });
		
		$("#USERAREA").val("<%=user.getUserg5()%>");
		gridList.setReadOnly("gridList", true, ['INDDCL','OBPROTCT','OBPROTPT']);
		gridList.setReadOnly("gridListSub", true, ['OBPROT']);
	});
	
	/* var dblIdx;
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
	        var rowData = gridList.getRowData(gridId, rowNum);
	        var param = inputList.setRangeParam("searchArea");
	        param.putAll(rowData);
	        
	        gridList.gridList({
	           id : "gridListSub",
	           param : param
	        });
	        
	        dblIdx = rowNum;
		}
	} */
	
	var dblIdx;
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
	        var param = getItemSearchParam(rowNum);
	        
	        gridList.gridList({
	           id : "gridListSub",
	           param : param
	        });
	        
	        dblIdx = rowNum;
		}
	}
 	
 	function getItemSearchParam(rowNum){
 		var rowData = gridList.getRowData("gridList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
 	}
	
	
	function searchList(headList){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			var rqshpd1 = param.get("RQSHPD1");
			var rqshpd2 = param.get("RQSHPD2");
			var date1 = uiList.getDateObj(rqshpd1);
		    var date2 = uiList.getDateObj(rqshpd2);
		    var day = (date2 - date1)/1000/60/60/24; 
			
			if(day > 30){
				commonUtil.msgBox("OUT_M0169");  //????????? ??????????????? ????????? 30??? ????????? ??????????????????.
				return;
			}else if(date1 > date2){
				commonUtil.msgBox("OUT_M0170");
				return;
			}
			
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
	
	function saveCheck(selectType){		
		var param = dataBind.paramData("searchArea");
		var headList = gridList.getSelectData("gridList");
		var itemList;
		if(headList.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var modRowCnt = gridList.getModifyRowCount("gridListSub");
		if(modRowCnt > 0){
			if(gridList.validationCheck("gridListSub", "all")){
				itemList = gridList.getGridData("gridListSub");
				var headSelectList = gridList.getSelectRowNumList("gridList");
				for(var i=0;i<headSelectList.length;i++){
					if(dblIdx == headSelectList[i]){
						param.put("headModifyIndex", i);
					}
				}
				param.put("list", itemList);
			}else{
				return;
			}
		}
		param.put("headList", headList);
		
		return param;
	}
	
	function sendEcms(){
		if(gridList.validationCheck("gridListSub", "modify")){
			if(gridList.getSelectData("gridList").length == 0){
				commonUtil.msgBox("TASK_M0003"); //???????????? ???????????? ???????????????.
				return;
			}
			
			if(!commonUtil.msgConfirm("HHT_T0007")){ //?????????????????????????
				return;
			}
			
			var param = saveCheck();
			if(param != null){
			   var vjson = validCheck(param);
				if(vjson.data != "OK"){
					var msgList = vjson.data.split(" ");
					var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
					commonUtil.msg(msgTxt);
					return false;
				}
			   
				var json = save(param);
			   
			  
				if(gridList.checkResult(json)){
					commonUtil.msgBox("MASTER_M0564");
					gridList.resetGrid("gridList");
					gridList.resetGrid("gridListSub");
					gridList.viewJsonData("gridList", json.data);
					searchType=2;
					searchSubItemList(0);
				}
			   
			    gridList.setReadOnly("gridList", true);
			    gridList.setReadOnly("gridListSub", true);
			    
			}
			uiList.setActive("Send", false);
			uiList.setActive("Print", true);
			gridList.checkAll("gridList", true);
		}
	}
	
	function validCheck(param){
		var json = netUtil.sendData({
			url : "/wms/outbound/json/validateSendEcms.data",
			param : param
		});
		
		return json;
	}
	
	function save(param){
		var json = netUtil.sendData({
			url : "/wms/outbound/json/sendEcms.data",
			param : param
		});
		return json;
	}
	
	function inputListEventRangeDataChange(rangeName, singleData, rangeData){
		if(rangeName == "SH.SHPOKY" || rangeName == "SI.SVBELN" || rangeName == "SI.SEBELN" || rangeName == "SI.SKUKEY"){
			var dataCount = inputList.getDataCount("SH.SHPOKY")
	                      + inputList.getDataCount("SI.SVBELN")
	                      + inputList.getDataCount("SI.SEBELN")
	                      + inputList.getDataCount("SI.SKUKEY");
			if(dataCount == 0){
				var now = new Date();
	 			now.setDate(now.getDate());
	 			var tmpValue = uiList.dateFormat(now, site.COMMON_DATE_TYPE);
	 			$("#searchArea").find("[name=RQSHPD]").val(tmpValue);
	            inputList.addValidation("RQSHPD", "required");
			}else{
	            $("#searchArea").find("[name=RQSHPD]").val("");
	            inputList.removeValidation("RQSHPD", "required");
			}
		}      
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		var param = new DataMap();
		if(searchCode == "SHDOCTM"){
			param.put("DOCCAT", "200");
			return param;
		}else if(searchCode == "SHCMCDV"){
			param.put("CMCDKY", "STATDO");
			return param;
		}else if(searchCode == "SHBZPTN"){
			if($inputObj.name == "SH.PTRCVR"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "CT");
				return param;
			}else if($inputObj.name == "SH.DPTNKY"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("PTNRTY", "CT");
				return param;
			}
		}else if(searchCode == "SHSKUMA"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Send"){
			sendEcms();
		}else if(btnName == "Print"){
			PrintList();
		}else if(btnName == "Reflect"){
			setVehiCombo();
		}
	}
	
	function PrintList(){
		var url = "";
		var prtseq = "";
		
		var head = gridList.getSelectData("gridList");
		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var param = new DataMap();
		param.put("head", head);
		
		// SELECT SEQ_PRTSEQ.NEXTVAL FROM DUAL
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/savePrtseqDL09.data",
			param : param
		});

		var where = "AND PRTSEQ IN ('" + prtseq + "')";

		url = "/ezgen/shipping_list.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 850, 650);
	}
	
	function setVehiCombo(){
		var vehiCombo = $("#vehiCombo").val();

		if(vehiCombo){
			var selectNumList = gridList.getSelectRowNumList("gridList");
			var selectCnt = gridList.getSelectRowNumList("gridListSub").length;
		 	for(var i=0;i<selectNumList.length;i++){
				var rowNum = selectNumList[i];
				gridList.setColValue("gridList", rowNum, "DOCTXT", vehiCombo);
			} 
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Send SEND BTN_ERPSEND">
		</button>
		<button CB="Print PRINT BTN_PRINT_MH06">
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
						<td>
							<input type="text" name="WAREKY" size="8px" value="<%=wareky%>" readonly="readonly" validate="required"/>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_AREAKY"></th>
						<td>
							<select Combo="WmsOrder,AREAKYCOMBO" name="AREAKY" id="USERAREA" validate="required">
							</select>
						</td>
					</tr> -->
					<tr>
						<th CL="STD_STATDO">????????????</th>
						<td>
							<input type="checkbox" name="STAT01" value="V" />
							<label CL="STD_EMPTYTRAN">?????????</label>
							<input type="checkbox" name="STAT02" value="V" />
							<label CL="STD_ALLOCATE">??????</label>
							<input type="checkbox" name="STAT03" value="V" checked="checked"/>
							<label CL="STD_PICKIN">??????</label>
						</td>
					</tr>
					<tr>
						<th CL="STD_RQSHPD">??????????????????</th>
						<td>
							<!-- <input type="text" name="RQSHPD" UIFormat="C N" validate="required"/> -->
							<input type="text" name="RQSHPD1" UIFormat="C N" validate="required"/> ~ <input type="text" name="RQSHPD2" UIFormat="C +1" validate="required"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_OWNRKY">??????</th>
						<td>
							<input type="text" name="SH.OWNRKY" UIInput="R"/> 
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_LOTA07"></th>
						<td>
							<input type="text" name="SI.SEBELN" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA04"></th>
						<td>
							<input type="text" name="SI.LOTA04" UIInput="R"/>
						</td>
					</tr> -->
					<tr>
						<th CL="STD_SSHTYP">????????????</th>
						<td>
							<input type="text" name="SH.SHPMTY" UIInput="R,SHDOCTM"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DLTRRT">????????????</th>
						<td>
							<input type="checkbox" name="PGRC01" value="V" checked="checked" />
							<label CL="STD_DLV"></label>
							<input type="checkbox" name="PGRC02" value="V" checked="checked" />
							<label CL="STD_TRN"></label>
							<input type="checkbox" name="PGRC03" value="V" checked="checked" />
							<label CL="STD_RTN"></label>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="SI.SKUKEY" UIInput="R,SHSKUMA"/>
						</td>
					</tr> -->
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
						<th CL="STD_SHPOKY">??????????????????</th>
						<td>
							<input type="text" name="SH.SHPOKY" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SVBELN">??????????????????</th>
						<td>
							<input type="text" name="SI.SVBELN" UIInput="R"/>
						</td>
					</tr>				
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
			<h2 class="tit" CL="STD_CUSTINFO"></h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_PTRCVR,3">?????????</th>
						<td>
							<input type="text" name="SH.PTRCVR" UIInput="R,SHBZPTN"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_PTRCNM">????????????</th>
						<td>
							<input type="text" name="CT.NAME01" UIInput="R"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY2">?????????</th>
						<td>
							<input type="text" name="SH.DPTNKY" UIInput="R,SHBZPTN"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY2,3">????????????</th>
						<td>
							<input type="text" name="PT.NAME01" UIInput="R"/>
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
						<li><a href="#tabs"><span CL="STD_LIST">?????????</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
						<table class="util">
								<tr>
									<th CL="STD_VEHINO"></th>
									<td>
										<select Combo="WmsOutbound,VEHINO_COMBO" id="vehiCombo">
											<option value=""> </option>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
											<!-- <col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>??????</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARENM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_OWNRNM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_RQSHPD'></th>
												<th CL='STD_INDDCL'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_AREANM'></th>
												<th CL='STD_TOAREA'></th>
												<th CL='STD_AREATGNM'></th>
												<th CL='STD_SHPMTY'></th>
												<th CL='STD_SHPMNM'></th>
												<th CL='STD_DLTRRT'></th>
												<th CL='STD_DLTRRT,3'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_STATDONM'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_PTRCVR,3'></th>
												<th CL='STD_PTRCNM'></th>
												<th CL='STD_DPTNKY2'></th>
												<th CL='STD_DPTNKY2,3'></th>
												<th CL='STD_OBPROTCT'></th>
												<th CL='STD_OBPROTPT'></th>
												<th CL='STD_ITMCNT'></th>
												<!-- <th CL='STD_VEHINO,2'></th> -->
												<th CL='STD_VEHINO,3'></th>
												<th CL='STD_VEHINO'></th>
												<!-- <th CL='STD_DOCTXT'></th> -->
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
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" /> -->
											<!-- <col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARENM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,OWNRNM"></td>
												<td GCol="text,DOCDAT" GF="D"></td>
												<td GCol="text,RQSHPD" GF="D"></td>
												<td GCol="check,INDDCL"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,AREANM"></td>
												<td GCol="text,AREATO"></td>
												<td GCol="text,ARETNM"></td>
												<td GCol="text,SHPMTY"></td>
												<td GCol="text,SHPMNM"></td>
												<td GCol="text,DLTRRT"></td>
												<td GCol="text,DLTRRTNM"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,STATNM"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,PTRCVR"></td>
												<td GCol="text,PTRCNM"></td>
												<td GCol="text,DPTNKY"></td>
												<td GCol="text,DPTNNM"></td>
												<td GCol="check,OBPROTCT"></td>
												<td GCol="check,OBPROTPT"></td>
												<td GCol="text,ITMCNT" GF="N"></td>
												<!-- <td GCol="select,SLAND1">
													<select CommonCombo="SLAND1">
														<option value=" "></option>
													</select>
												</td> -->
												<!-- <td GCol="input,NAME01" GF="S 180"></td> -->
												<td GCol="input,SBKTXT" GF="S 75"></td>
												<td GCol="select,DOCTXT">
													<select Combo="WmsOutbound,VEHINO_COMBO">
														<option value=" "></option>
													</select>
												</td>
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
						<li><a href="#tabs1-1"><span CL="STD_DETAILLIST"></span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>											
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_STATNM'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_OBPROT'></th>
												<th CL='STD_QTYORG'></th>
												<th CL='STD_QTSHPO'></th>
												<th CL='STD_QTALOC'></th>
												<th CL='STD_QTUALO'></th>
												<th CL='STD_QTJCMP'></th>
												<th CL='STD_QTSHPD'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_MEASKY'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA13,3'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
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
											<col width="100" />
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
										<tbody id="gridListSub">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,STATNM"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="check,OBPROT"></td>
												<td GCol="text,QTYORG" GF="N 20,3"></td>
												<td GCol="text,QTSHPO" GF="N 20,3"></td>
												<td GCol="text,QTALOC" GF="N 20,3"></td>
												<td GCol="text,QTUALO" GF="N 20,3"></td>
												<td GCol="text,QTJCMP" GF="N 20,3"></td>
												<td GCol="text,QTSHPD" GF="N 20,3"></td>
												<td GCol="text,UOMKEY"></td>
												<td GCol="text,MEASKY"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,LOTA13" GF="D"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,NAME01"></td>
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