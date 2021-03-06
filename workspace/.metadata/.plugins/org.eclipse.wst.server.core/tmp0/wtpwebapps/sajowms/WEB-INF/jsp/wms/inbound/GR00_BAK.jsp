<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">

	var searchCnt = 0; 
	var dblIdx = -1;
	var sFlag = true;
	
	$(document).ready(function(){
		setTopSize(200);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "EBELN",
			module : "WmsInbound",
			command : "GR00"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			checkHead : "gridListSubCheckHead",
			pkcol : "RECVKY,RECVIT",
			module : "WmsInbound",
			command : "GR00Sub"
	    });
	});
	
	
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			
			sFlag = true;
			
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
			
			gridList.gridList({
				id : "gridListSub",
				param : param
			});
			//searchOpen(false);
			
		}
	}


	function gridListEventDataBindEnd(gridId, dataLength){
		
		if(sFlag){
			if( gridId == "gridListHead" && dataLength > 0  ){
				//alert(" gridId : " + gridId + "\n dataLength : " + dataLength);
				searchSubList(0);
			}
		}
	}
	
	
	function searchSubList(headRowNum){
		//alert("headRowNum :" + headRowNum);
		//var data = gridList.getRowData("gridList", headRowNum);
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		dblIdx = headRowNum;
	}
	
	
	function validationCheck(){
		
		var head = gridList.getRowData("gridListHead", 0);
		var listCnt = gridList.getGridDataCount("gridListSub");
		var list = gridList.getGridData("gridListSub");
		
		var vparam = new DataMap();
		vparam.put("head", head);
		vparam.put("list", list);
		vparam.put("key", "DOCCAT,DOCUTY,WAREKY,LOCAKY,OWNRKY,DPTNKY,SKUKEY,MEASKY,UOMKEY,QTYRCV,QTYMAX,MANDT,EBELN,EBELP");
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/GR00_Validation.data",
			param : vparam
		});
		
		return json;
	}
	
	
	function saveData(){
		
		// all - select, modify
		if( gridList.validationCheck("gridListHead", "modify") && gridList.validationCheck("gridListSub", "modify") ) {
			
			var modifyList = gridList.getModifyRowCount("gridListSub");
			
			if( modifyList == 0){
				commonUtil.msgBox("VALID_M0406");
				//gridList.setFocus("gridListSub", "SKUKEY");
				return;
			}
			
			//searchCnt++;
			var head = gridList.getRowData("gridListHead", 0);

			var listCnt = gridList.getGridDataCount("gridListSub");
	    	var list = gridList.getGridData("gridListSub");
			
	    	
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var json = validationCheck();
			
			if(json.data != "OK"){
				var msgList = json.data.split(" ");
				var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				commonUtil.msg(msgTxt);
				return false;
			}
			
			
			//?????????????????? - ???????????????
			var arrDocNum = "";
			
			// ??????
			for(var i = 0; i < 1 ; i++) {
	
				// [120] ????????????
				var docunum = wms.getDocSeq("120");
				gridList.gridColModify("gridListHead", 0, "RECVKY", docunum);
				if(i == 0){
					arrDocNum += docunum;
				}else{
					arrDocNum += "','"+docunum;
				}
			}
			
			var head = gridList.getRowData("gridListHead", 0);
	    	var list = gridList.getGridData("gridListSub");
	    	
			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);
			
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/GR00_Save.data",
				param : param
			});
	
			if(json && json.data){
				searchCnt = 1;
				
				var paramH = new DataMap();
				paramH.put("RECVKY", arrDocNum);
				
				var wareky = gridList.getColData("gridListHead", 0, "WAREKY");
				paramH.put("WAREKY", wareky);
				
				gridList.gridList({
			    	id : "gridListHead",
			    	command : "GR09H",
			    	param : paramH
			    });
				
				gridList.gridList({
			    	id : "gridListSub",
			    	command : "GR09I",
			    	param : paramH
			    }); 
				
				gridList.setReadOnly("gridListHead");
				gridList.setReadOnly("gridListSub");
			}
		}
	}

	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if (gridId == "gridListSub" && colName == "SKUKEY") {
			
			if(colValue != ""){
				//var param = new DataMap();
				var param = inputList.setRangeParam("searchArea");
				
				param.put("SKUKEY", colValue);
				
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "SKUKEYval",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] >= 1) {
					
					var param = new DataMap();
					
					var param = inputList.setRangeParam("searchArea");
					param.put("SKUKEY", colValue);
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "SKUKEY",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						
						gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]);	//??????
						
						gridList.setColValue("gridListSub", rowNum, "MEASKY", json.data["MEASKY"]);	// ????????????
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);	// ?????? UOMKEY
						gridList.setColValue("gridListSub", rowNum, "DUOMKY", json.data["DUOMKY"]);	// ?????? DUOMKY
						gridList.setColValue("gridListSub", rowNum, "QTDUOM", json.data["QTDUOM"]);	// ??????
						gridList.setColValue("gridListSub", rowNum, "BOXQTY", json.data["BOXQTY"]);	// ?????????
						gridList.setColValue("gridListSub", rowNum, "REMQTY", json.data["REMQTY"]);	// ??????
						
						gridList.setColValue("gridListSub", rowNum, "SKUG05", json.data["SKUG05"]);	// ???????????????
						
						gridList.setColValue("gridListSub", rowNum, "GRSWGT", json.data["GRSWGT"]);	// ?????????
						gridList.setColValue("gridListSub", rowNum, "NETWGT", json.data["NETWGT"]);	// KIT?????????
						gridList.setColValue("gridListSub", rowNum, "WGTUNT", json.data["WGTUNT"]);	// ????????????
						
						gridList.setColValue("gridListSub", rowNum, "LENGTH", json.data["LENGTH"]);	// ??????
						gridList.setColValue("gridListSub", rowNum, "WIDTHW", json.data["WIDTHW"]);	// ??????
						gridList.setColValue("gridListSub", rowNum, "HEIGHT", json.data["HEIGHT"]);	// ??????
						
						gridList.setColValue("gridListSub", rowNum, "CUBICM", json.data["CUBICM"]);	// CBM
						gridList.setColValue("gridListSub", rowNum, "CAPACT", json.data["CAPACT"]);	// CAPA
						
					} 
				} else if (json.data["CNT"] < 1) {
					commonUtil.msgBox("COMMON_M0461", colValue);
					
					gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
					gridList.setFocus("gridListSub", "SKUKEY");
				}
			}
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
		<button CB="Save SAVE STD_SAVE false">
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
	<div class="searchInnerContainer">
		<p class="searchBtn"><input type="submit" onclick="searchList()" class="button type1 widthAuto" value="??????" CL="BTN_DISPLAY"/></p>
		<div class="searchInBox" id="searchArea">
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
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="WCD1" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">????????????</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,DOCUTY106COMBO" name="RCPTTY"></select>
						</td>
					</tr>
					
					<input type="hidden" name="OWNRKY" value="CMAS" />
					<input type="hidden" name="DOCCAT" value="100" />
					
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
						<li><a href="#tabs1-1"><span>??????</span></a></li>
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
											<col width="100" />
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
												
												<th CL='STD_RECVKY,2'></th>	<!-- ?????????????????? -->
												<th CL='STD_RCPTTY'></th>	<!-- ???????????? -->
												<th CL='STD_RCPTTYNM'></th>	<!-- ??????????????? -->
												<th CL='STD_WAREKY'></th>	<!-- ?????? -->
												<th CL='STD_WAREKYNM'></th>	<!-- ????????? -->
												<th CL='STD_DOCDAT'></th>	<!-- ???????????? -->
												
												<th CL='STD_ARCPTD'></th>	<!-- ???????????? -->
												<th CL='STD_DOCTXT'></th>	<!-- ?????? -->
												
												<th CL='STD_STATDO'></th>	<!-- ???????????? -->
												<th CL='STD_DOCCAT'></th>	<!-- ???????????? -->
												<th CL='STD_DOCCATNM'></th>	<!-- ??????????????? -->
												
												<th CL='STD_DPTNKY'></th>	<!-- ???????????? -->
												<th CL='STD_DPTNKYNM'></th>	<!-- ??????????????? -->
												
												<th CL='STD_USRID3'></th>	<!-- ???????????? -->
												<th CL='STD_UNAME3'></th>	<!-- ?????????????????? -->
												<th CL='STD_DEPTID3'></th>	<!-- ???????????? ?????? -->
												<th CL='STD_DNAME3'></th>	<!-- ???????????? ????????? -->
												
												<th CL='STD_USRID4'></th>	<!-- ???????????? -->
												<th CL='STD_UNAME4'></th>	<!-- ?????????????????? -->
												<th CL='STD_DEPTID4'></th>	<!-- ???????????? ?????? -->
												<th CL='STD_DNAME4'></th>	<!-- ???????????? ????????? -->
												
												<th CL='STD_USRID1'></th>	<!-- ????????? -->
												<th CL='STD_UNAME1'></th>	<!-- ???????????? -->
												<th CL='STD_DEPTID1'></th>	<!-- ????????? ?????? -->
												<th CL='STD_DNAME1'></th>	<!-- ????????? ????????? -->
												
												<th CL='STD_USRID2'></th>	<!-- ??????????????? -->
												<th CL='STD_UNAME2'></th>	<!-- ?????????????????? -->
												<th CL='STD_DEPTID2'></th>	<!-- ?????? ?????? -->
												<th CL='STD_DNAME2'></th>	<!-- ?????? ????????? -->
												
												<th CL='STD_CREDAT'></th>	<!-- ???????????? -->
												<th CL='STD_CRETIM'></th>	<!-- ???????????? -->
												<th CL='STD_CREUSR'></th>	<!-- ????????? -->
												<th CL='STD_CUSRNM'></th>	<!-- ???????????? -->
												<th CL='STD_LMODAT'></th>	<!-- ???????????? -->
												<th CL='STD_LMOTIM'></th>	<!-- ???????????? -->
												<th CL='STD_LMOUSR'></th>	<!-- ????????? -->
												<th CL='STD_LUSRNM'></th>	<!-- ???????????? -->
												
												
												<!-- <th CL='STD_SAPSTS'></th> -->	<!-- ERP Mvt -->
												<!-- <th CL='STD_PTNRKY1'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_DRELIN'></th> -->	<!-- ????????????????????? -->
												<!-- <th CL='STD_OWNRKY'></th> -->	<!-- ?????? -->
												<!-- <th CL='STD_INDRCN'></th> -->	<!-- ????????? -->
												<!-- <th CL='STD_CRECVD'></th> -->	<!-- ???????????? ?????? -->
												<!-- <th CL='STD_RSNCOD'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_ERPWM'></th> -->	<!-- ERP?????? -->
												<!-- <th CL='STD_ERPWMNM'></th> -->	<!-- ERP????????? -->
												<!-- th CL='STD_DPTNKYNM'></th> -->	<!-- ??????????????? -->
												
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
											<col width="100" />
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
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												
												<td GCol="text,RECVKY"></td>	<!-- ?????????????????? -->
												<td GCol="text,RCPTTY"></td>	<!-- ???????????? -->
												<td GCol="text,RCPTTYNM"></td>	<!-- ??????????????? -->
												<td GCol="text,WAREKY"></td>	<!-- ?????? -->
												<td GCol="text,WAREKYNM"></td>	<!-- ????????? -->
												<td GCol="input,DOCDAT"></td>	<!-- ???????????? -->
												
												<td GCol="text,ARCPTD"></td>	<!-- ???????????? -->
												<td GCol="input,DOCTXT"></td>	<!-- ?????? -->
												
												<td GCol="text,STATDO"></td>	<!-- ???????????? -->
												<td GCol="text,DOCCAT"></td>	<!-- ???????????? -->
												<td GCol="text,DOCCATNM"></td>	<!-- ??????????????? -->
												
												<td GCol="input,DPTNKY"></td>	<!-- ???????????? -->
												<td GCol="text,DPTNKYNM"></td>	<!-- ??????????????? -->
												
												<td GCol="input,USRID3"></td>	<!-- ???????????? -->
												<td GCol="text,UNAME3"></td>	<!-- ?????????????????? -->
												<td GCol="text,DEPTID3"></td>	<!-- ???????????? ?????? -->
												<td GCol="text,DNAME3"></td>	<!-- ???????????? ????????? -->
												
												<td GCol="input,USRID4"></td>	<!-- ???????????? -->
												<td GCol="text,UNAME4"></td>	<!-- ?????????????????? -->
												<td GCol="text,DEPTID4"></td>	<!-- ???????????? ?????? -->
												<td GCol="text,DNAME4"></td>	<!-- ???????????? ????????? -->
												
												<td GCol="text,USRID1"></td>	<!-- ????????? -->
												<td GCol="text,UNAME1"></td>	<!-- ???????????? -->
												<td GCol="text,DEPTID1"></td>	<!-- ????????? ?????? -->
												<td GCol="text,DNAME1"></td>	<!-- ????????? ????????? -->
												
												<td GCol="text,USRID2"></td>	<!-- ??????????????? -->
												<td GCol="text,UNAME2"></td>	<!-- ?????????????????? -->
												<td GCol="text,DEPTID2"></td>	<!-- ?????? ?????? -->
												<td GCol="text,DNAME2"></td>	<!-- ?????? ????????? -->
												
												<td GCol="text,CREDAT" GF="D"></td>	<!-- ???????????? -->
												<td GCol="text,CRETIM" GF="T"></td>	<!-- ???????????? -->
												<td GCol="text,CREUSR"></td>	<!-- ????????? -->
												<td GCol="text,CUSRNM"></td>	<!-- ???????????? -->
												<td GCol="text,LMODAT" GF="D"></td>	<!-- ???????????? -->
												<td GCol="text,LMOTIM" GF="T"></td>	<!-- ???????????? -->
												<td GCol="text,LMOUSR"></td>	<!-- ????????? -->
												<td GCol="text,LUSRNM"></td>	<!-- ???????????? -->
												
												
											</tr>		
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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
						<li><a href="#tabs1-1"><span>Item ?????????</span></a></li>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
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
												
												<!-- <th CL='STD_RECVKY'></th> -->	<!-- ?????????????????? -->
												
												<th CL='STD_RECVIT,2'></th>	<!-- ????????????????????? -->
												<th CL='STD_SKUKEY'></th>	<!-- ???????????? -->
												<th CL='STD_DESC01'></th>	<!-- ?????? -->
												<th CL='STD_LOCAKY'></th>	<!-- ?????? -->
												<th CL='STD_TRNUID'></th>	<!-- P/T ID -->
												
												
												<th CL='STD_QTYRCV'></th>	<!-- ???????????? -->
												<th CL='STD_UOMKEY'></th>	<!-- ?????? -->
												<th CL='STD_QTDUOM'></th>	<!-- ?????? -->
												<th CL='STD_BOXQTY'></th>	<!-- ????????? -->
												<th CL='STD_REMQTY'></th>	<!-- ?????? -->
												
												
												<th CL='STD_LOTA11'></th>	<!-- ???????????? -->
												<th CL='STD_LOTA01'></th>	<!-- S/N?????? -->
												<th CL='STD_LOTA06'></th>	<!-- ???????????? -->
												<th CL='STD_AREAKY'></th>	<!-- ?????? -->
												<th CL='STD_MEASKY'></th>	<!-- ???????????? -->
												
												<th CL='STD_DUOMKY'></th>	<!-- ?????? -->
												<th CL='STD_LOTA01NM'></th>	<!-- ??????????????? -->
												
												<th >ERP?????????</th>
												<th >?????? LOT</th>
												<th >??????</th>
												<th >????????????</th>
																								
												
												<th CL='STD_LOTA12'></th>	<!-- ???????????? -->
												<th CL='STD_DESC02'></th>	<!-- ?????? -->
																								
												
												
												<!-- <th CL='STD_LOTA05'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_LOTA02'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_RSNCOD'></th> -->	<!-- ???????????? -->
												
												<!-- <th CL='STD_LOTA03'></th> -->	<!-- ?????? -->
												<!-- <th CL='STD_LOTA04'></th> -->	<!-- ???????????? -->
												
												<!-- <th CL='STD_LOTA13'></th> -->	<!-- ???????????? -->

												
												<th CL='STD_ASKU01'></th>	<!-- WMS ???????????? -->
												<th CL='STD_ASKU02'></th>	<!-- ??????(E)/??????(D) -->
												<th CL='STD_ASKU03'></th>	<!-- ERP ???????????? -->
												<th CL='STD_ASKU04'></th>	<!-- ????????? ????????? -->
												<th CL='STD_ASKU05'></th>	<!-- ?????? -->
												
												<th CL='STD_EANCOD'></th>	<!-- EAN -->
												<th CL='STD_GTINCD'></th>	<!-- UPC -->
												
												<th CL='STD_SKUG01'></th>	<!-- ????????????1 -->
												<th CL='STD_SKUG02'></th>	<!-- ????????????2 -->
												<th CL='STD_SKUG03'></th>	<!-- ????????????3 -->
												
												<th CL='STD_SKUG04'></th>	<!-- ?????? -->
												<th CL='STD_SKUG05'></th>	<!-- ??????????????? -->
												<th CL='STD_GRSWGT'></th>	<!-- ?????????  -->
												<th CL='STD_NETWGT'></th>	<!-- KIT????????? -->
												<th CL='STD_WGTUNT'></th>	<!-- ???????????? -->
												<th CL='STD_LENGTH'></th>	<!-- ?????? -->
												<th CL='STD_WIDTHW'></th>	<!-- ?????? -->
												<th CL='STD_HEIGHT'></th>	<!-- ?????? -->
												<th CL='STD_CUBICM'></th>	<!-- CBM -->
												<th CL='STD_CAPACT'></th>	<!-- CAPA -->
												
												<th CL='STD_CREDAT'></th>	<!-- ???????????? -->
												<th CL='STD_CRETIM'></th>	<!-- ???????????? -->
												<th CL='STD_CREUSR'></th>	<!-- ????????? -->
												<th CL='STD_CUSRNM'></th>	<!-- ???????????? -->
												<th CL='STD_LMODAT'></th>	<!-- ???????????? -->
												<th CL='STD_LMOTIM'></th>	<!-- ???????????? -->
												<th CL='STD_LMOUSR'></th>	<!-- ????????? -->
												<th CL='STD_LUSRNM'></th>	<!-- ???????????? -->
												
												
												<!-- <th CL='STD_STATIT'></th> -->	<!-- ?????? -->
												<!-- <th CL='STD_SAPSTS'></th> -->	<!-- ERP Mvt -->
												<!-- <th CL='STD_LOTNUM'></th> -->	<!-- Lot no. -->
												
												<!-- <th CL='STD_SECTID'></th> -->	<!-- Sect.ID -->
												<!-- <th CL='STD_TRNUID'></th> -->	<!-- P/T -->
												
												<!-- <th CL='STD_PACKID'></th> -->	<!-- SET???????????? -->
												
												<!-- <th CL='STD_QTYDIF'></th> -->	<!-- ????????? -->
												<!-- <th CL='STD_QTYUOM'></th> -->	<!-- Quantity -->
												<!-- <th CL='STD_TRUNTY'></th> -->	<!-- ???????????? -->
												
												<!-- <th CL='STD_QTPUOM'></th> -->	<!-- Units pe -->
												
												<!-- <th CL='STD_INDRCN'></th> -->	<!-- ????????? -->
												<!-- <th CL='STD_CRECVD'></th> -->	<!-- ???????????? ?????? -->
												
												<!-- <th CL='STD_LOTA07'></th> -->	<!-- LOT??????7 -->
												<!-- <th CL='STD_LOTA08'></th> -->	<!-- LOT??????8 -->
												<!-- <th CL='STD_LOTA09'></th> -->	<!-- LOT??????9 -->
												<!-- <th CL='STD_LOTA10'></th> -->	<!-- LOT??????10 -->
												
												
												<!-- <th CL='STD_LOTA14'></th> -->	<!-- LOT??????14 -->
												<!-- <th CL='STD_LOTA15'></th> -->	<!-- LOT??????15 -->
												<!-- <th CL='STD_LOTA16'></th> -->	<!-- LOT??????16 -->
												<!-- <th CL='STD_LOTA17'></th> -->	<!-- LOT??????17 -->
												<!-- <th CL='STD_LOTA18'></th> -->	<!-- LOT??????18 -->
												<!-- <th CL='STD_LOTA19'></th> -->	<!-- LOT??????19 -->
												<!-- <th CL='STD_LOTA20'></th> -->	<!-- LOT??????20 -->
												
												<!-- <th CL='STD_AWMSNO'></th> -->	<!-- SEQ(ERP) -->
												<!-- <th CL='STD_REFDKY'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_REFDIT'></th> -->	<!-- ????????????It. -->
												<!-- <th CL='STD_REFCAT'></th> -->	<!-- ?????????????????? -->
												<!-- <th CL='STDREFDAT'></th> -->	<!-- ?????????????????? -->
												
												<!-- <th CL='STD_QTYORG'></th> -->	<!-- ???????????? -->
												<!-- <th CL='STD_SMANDT'></th> -->	<!-- Client -->
												
												<!-- <th CL='STD_SEBELN'></th> -->	<!-- ECMS ???????????? -->
												<!-- <th CL='STD_SEBELP'></th> -->	<!-- SAP P/O Item -->
												<!-- <th CL='STD_SZMBLNO'></th> -->	<!-- B/L NO -->
												<!-- <th CL='STD_SZMIPNO'></th> -->	<!-- B/L Item NO -->
												<!-- <th CL='STD_STRAID'></th> -->	<!-- SCM???????????? -->
												<!-- <th CL='STD_SVBELN'></th> -->	<!-- ECMS ???????????? -->
												<!-- <th CL='STD_SPOSNR'></th> -->	<!-- ECMS ??????Item -->
												<!-- <th CL='STD_STKNUM'></th> -->	<!-- ?????????????????? -->
												<!-- <th CL='STD_STPNUM'></th> -->	<!-- ?????? It -->
												<!-- <th CL='STD_SWERKS'></th> -->	<!-- ????????? -->
												<!-- <th CL='STD_SLGORT'></th> -->	<!-- ?????? ?????? -->
												<!-- <th CL='STD_SDATBG'></th> -->	<!-- ?????????????????? -->
												<!-- <th CL='STD_STDLNR'></th> -->	<!-- ????????? -->
												<!-- <th CL='STD_SSORNU'></th> -->	<!-- ???????????????????????? -->
												<!-- <th CL='STD_SSORIT'></th> -->	<!-- ???????????? ??????????????? -->
												<!-- <th CL='STD_SMBLNR'></th> -->	<!-- Mat.Doc. -->
												<!-- <th CL='STD_SZEILE'></th> -->	<!-- Mat.Doc.it. -->
												<!-- <th CL='STD_SMJAHR'></th> -->	<!-- M/D ?????? -->
												<!-- <th CL='STD_SXBLNR'></th> -->	<!-- ????????????????????? -->
												<!-- <th CL='STD_RCPRSN'></th> -->	<!-- ???????????? -->
												
												
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
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
												<!-- <td GCol="text,RECVKY"></td> -->	<!-- ?????????????????? -->
												
												<td GCol="text,RECVIT"></td>	<!-- ????????????????????? -->
												<td GCol="input,SKUKEY" validate="required,VALID_M0406" ></td>	<!-- ???????????? -->
												<td GCol="text,DESC01"></td>	<!-- ?????? -->
												<td GCol="input,LOCAKY" validate="required,VALID_M0404" ></td>	<!-- ?????? -->
												<td GCol="text,TRNUID"></td>	<!-- P/T ID -->
												
												
												<td GCol="input,QTYRCV" validate="required,IN_M0062" GF="N 3"></td>	<!-- ???????????? -->
												<td GCol="text,UOMKEY"></td>	<!-- ?????? -->
												<td GCol="text,QTDUOM"></td>	<!-- ?????? -->
												<td GCol="text,BOXQTY"></td>	<!-- ????????? -->
												<td GCol="text,REMQTY"></td>	<!-- ?????? -->
												
												
												<td GCol="text,LOTA11"></td>	<!-- ???????????? -->
												<td GCol="text,LOTA01"></td>	<!-- S/N?????? -->
												<td GCol="text,LOTA06"></td>	<!-- ???????????? -->
												<td GCol="text,AREAKY"></td>	<!-- ?????? -->
												<td GCol="text,MEASKY"></td>	<!-- ???????????? -->
												
																								
												<td GCol="text,DUOMKY"></td>	<!-- ?????? -->
												<td GCol="text,LOTA01NM"></td>	<!-- ??????????????? -->
												<td GCol="select,LOTA05">	<!-- ERP????????? -->
													<select Combo="WmsInbound,LOTA05COMBO">
														<!-- <option value="">??????</option> -->
													</select>
												</td>
												<td></td>
												<td></td>
												
												
												<td GCol="select,LOTA02">	<!-- ???????????? -->
													<select Combo="WmsInbound,LOTA02COMBO">
														<!-- <option value="">??????</option> -->
													</select>
												</td>
												<td GCol="text,LOTA12"></td>	<!-- ???????????? -->
												<td GCol="text,DESC02"></td>	<!-- ?????? -->	
												
												
												<!-- <td GCol="text,LOTA05"></td> -->	<!-- ???????????? -->
												<!-- <td GCol="text,LOTA02"></td> -->	<!-- ???????????? -->
												<!-- <td GCol="text,RSNCOD"></td> -->	<!-- ???????????? -->
												<!-- <td GCol="text,LOTA03"></td> -->	<!-- ?????? -->
												<!-- <td GCol="text,LOTA04"></td> -->	<!-- ???????????? -->
												<!-- <td GCol="text,LOTA13"></td> -->	<!-- ???????????? -->
												
												
												<td GCol="text,ASKU01"></td>	<!-- WMS ???????????? -->
												<td GCol="text,ASKU02"></td>	<!-- ??????(E)/??????(D) -->
												<td GCol="text,ASKU03"></td>	<!-- ERP ???????????? -->
												<td GCol="text,ASKU04"></td>	<!-- ????????? ????????? -->
												<td GCol="text,ASKU05"></td>	<!-- ?????? -->
												
												<td GCol="text,EANCOD"></td>	<!-- EAN -->
												<td GCol="text,GTINCD"></td>	<!-- UPC -->
												
												<td GCol="text,SKUG01"></td>	<!-- ????????????1 -->
												<td GCol="text,SKUG02"></td>	<!-- ????????????2 -->
												<td GCol="text,SKUG03"></td>	<!-- ????????????3 -->
												
												<td GCol="text,SKUG04"></td>	<!-- ?????? -->
												<td GCol="text,SKUG05"></td>	<!-- ??????????????? -->
												<td GCol="text,GRSWGT"></td>	<!-- ?????????  -->
												<td GCol="text,NETWGT"></td>	<!-- KIT????????? -->
												<td GCol="text,WGTUNT"></td>	<!-- ???????????? -->
												<td GCol="text,LENGTH"></td>	<!-- ?????? -->
												<td GCol="text,WIDTHW"></td>	<!-- ?????? -->
												<td GCol="text,HEIGHT"></td>	<!-- ?????? -->
												<td GCol="text,CUBICM"></td>	<!-- CBM -->
												<td GCol="text,CAPACT"></td>	<!-- CAPA -->
												
												<td GCol="text,CREDAT"></td>	<!-- ???????????? -->
												<td GCol="text,CRETIM"></td>	<!-- ???????????? -->
												<td GCol="text,CREUSR"></td>	<!-- ????????? -->
												<td GCol="text,CUSRNM"></td>	<!-- ???????????? -->
												<td GCol="text,LMODAT"></td>	<!-- ???????????? -->
												<td GCol="text,LMOTIM"></td>	<!-- ???????????? -->
												<td GCol="text,LMOUSR"></td>	<!-- ????????? -->
												<td GCol="text,LUSRNM"></td>	<!-- ???????????? -->
																								 
												
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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