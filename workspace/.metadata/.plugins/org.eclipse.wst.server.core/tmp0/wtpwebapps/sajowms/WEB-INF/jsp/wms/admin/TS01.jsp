<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	var flag="U";
	$(document).ready(function() {
		gridList.setGrid({
			id : "gridList1",
			editable : true,
			module : "WmsAdmin",
			validation :"SORTSQ,INDASD",
			command : "STSRITOP"
		});
	});

	function creatList(){
		flag = "I";
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			var ssorky = param.get("SSORKY");
			
			var ssorkyChk = new DataMap();
			
			ssorkyChk.put("SSORKY",ssorky);
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "SSORKYval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] > 0) {
				//alert(commonUtil.getMsg("MASTER_M0025",ssorky));
				commonUtil.msgBox("MASTER_M0025",ssorky);
				return;
			}
	
			netUtil.send({
				module : "WmsAdmin",
				command : "STSRH2",
				bindId : "tabs1-1",
				sendType : "map",
				bindType : "field",
				param : param
			});
				
			gridList.gridList({
		    	id : "gridList1",
		    	module : "WmsAdmin",
				command : "STSRH22",
		    	param : param
		    });
		}
	}	

///////////////////////////////////////////////////
	function searchList() {
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			
			var ssorky = param.get("SSORKY");
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "SSORKYval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] > 0) {
				netUtil.send({
					module : "WmsAdmin",
					command : "STSRHead",
					bindId : "tabs1-1",
					sendType : "map",
					bindType : "field",
					param : param
				});
				
				gridList.gridList({
			    	id : "gridList1",
			    	param : param
			    });
			}else{
				commonUtil.msgBox("MASTER_M0070");
			}
		}
	}		
	
		 
//////////////////////////////////////////////////////	

	function saveData() {
	
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		if(gridList.validationCheck("gridList1", "modify")){
			//var ssorky=dataBind.paramData("searchArea").get("SSORKY");
			var list = dataBind.paramData("foldSect");//?????? ????????? 
			var itemList = gridList.getGridData("gridList1");
			
			var itemCount = gridList.getGridDataCount("gridList1");
			//var arrFlag = 0;///question!!!!!!
			var saveFalg = 0;
			for(var i = 0; i < itemCount; i++){
				var actvat = gridList.getColData("gridList1", i, "ACTVAT");
				var sortsq = gridList.getColData("gridList1", i, "SORTSQ");
				if(actvat == "V" && !actvat=="V"){
					if(sortsq == "" || sortsq==" "){
						saveFalg++;
					}
				}
			}
			if(saveFalg > 0){
				//alert("??????????????? ??????????????????");
				commonUtil.msgBox("MASTER_M0688");
				return;
			}
			
			var param = new DataMap();
			param.put("list", list);
			param.put("itemList", itemList);
			//param.put("arrFlag", arrFlag);
			param.put("STATUS",flag);
			param.put("ACTVAT",actvat);
			var json = netUtil.sendData({
				url : "/wms/admin/json/TSu01.data",
				param : param
			});  
			
			if (json && json.data) {
				//alert(commonUtil.getMsg("HHT_T0008"));
				commonUtil.msgBox("HHT_T0008");
				searchList();
			}
		}
	}
	///////////////////////////////////////////////////////
	var sortsq = 0;
	var maxSortNum = 0;
	 function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		 //console.log("gridList SORTSQ : ");
		
		if(colName == "ACTVAT"){
			//console.log(gridId +" | " + rowNum +" | " + colName +" | " + colValue)
			if(colValue=="V"){
				var cnt = gridList.getGridDataCount("gridList1");
			
				for(var i=0; i < cnt; i++){
					if(rowNum != i){
						
						sortsq = parseInt(gridList.getColData("gridList1", i, "SORTSQ"));
						if(maxSortNum < sortsq){
							maxSortNum = sortsq;
						}
					}
				}
				sortsq = parseInt(maxSortNum)+1;
				gridList.setColValue("gridList1", rowNum, "SORTSQ", sortsq);
				//gridList.setColValue("gridList1", rowNum, "SORTSQ", ++sortsq);
				gridList.setColValue("gridList1", rowNum, "INDASD", "A");	
			}else{
				gridList.setColValue("gridList1", rowNum, "SORTSQ", "0");
				gridList.setColValue("gridList1", rowNum, "INDASD", " ");
				//--sortsq;
			}
		}
		
	}

	function gridListEventRowRemove(gridId, rowNum){
		//alert(11)
		var rowAea = gridList.getColData("gridList1", rowNum, "SSORKY");
		  if(gridId == "gridList1"){
			var param = new DataMap();
			param.put("SSORKY", rowAea);
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "SSORKval",
				sendType : "map",
				param : param
				
			});
			
			if(json && json.data){
				if(json.data["CNT"] >= 1){
					commonUtil.msgBox("MASTER_M0689");
					//alert("?????????????????? ???????????? ????????? ?????? ??? ??? ????????????.");// messegeUtik
					return false;
				} else if (json.data["CNT"] <= 1){
					return true;
				}
			}
		}
	}
	//////////////////////////////////////////////////////////////////////
	
 	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSTSRH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHWAHMA"){
			return dataBind.paramData("searchArea");
		}
	}
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Create"){
			creatList();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE">
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
			<button CB="Create CREATE BTN_CREATE"></button>
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
						<td><input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly" /></td>
					</tr>
					<tr>
						<th CL="STD_ALSRKY">???????????????</th>
						<td><input type="text" name="SSORKY" UIInput="S,SHSTSRH" validate="required,VALID_M0411" GF="S 10"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<div class="content" >
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="foldSect">
				<button type="button" class="button type2 fullSizer">
					<img src="/common/images/ico_full.png" alt="Full Size">
				</button>
				<div class="tabs" id="tabs1-1" >
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_GENERAL"><span>??????</span></a></li>
						<!-- <li><a href="#tabs1-2"><span>??????</span></a></li> -->
					</ul>

					<div  id="tabs1-1">
						<div class="section type1" >
							<div class="searchInBox" >
								<h2 class="tit" CL="STD_GENERAL"></h2>
								<table class="table type1" >
									<colgroup>
										<col width="8%" />
										<col />
										<col width="8%" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY">??????</th>
											<td><input type="text" readonly="readonly"
												name="WAREKY" /></td>
										</tr>
										<tr>
											<th CL="STD_ALSRKY">???????????????</th>
											<td><input type="text" readonly="readonly"
												name="SSORKY" /></td>
										</tr>
										<tr>
											<th CL="STD_SHORTX">??????</th>
											<td><input type="text" name="SHORTX" /></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<!-- <div id="tabs1-2">
						<div class="section type1" style="overflow-y: scroll;">
							<div class="searchInBox">
								<h2 class="tit">??????</h2>
								<table class="table type1" >
									<colgroup>
										<col width="8%" />
										<col />
										<col width="8%" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_CREDAT">????????????</th>
											<td><input type="text" readonly="readonly" 
											name="CREDAT"/><input
												type="text" readonly="readonly" name="CRETIM"/></td>
											<th CL="STD_LMODAT">????????????</th>
											<td><input type="text" readonly="readonly" name="LMODAT"/><input
												type="text" readonly="readonly" name="LMOTIM"/></td>
										</tr>
										<tr>
											<th CL="STD_CREUSR">?????????</th>
											<td><input type="text" readonly="readonly" name="CREUSR"/> ?????????</td>
											<th CL="STD_LMOUSR">?????????</th>
											<td><input type="text" readonly="readonly" name="LMOUSR"/> ?????????</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div> -->
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer">
					<img src="/common/images/ico_full.png" alt="Full Size">
				</button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_ITEMLIST" ><span>Item?????????</span></a></li>
						<!-- <li><a href="#tabs1-2"><span>Item??????</span></a></li> -->
					</ul>
					<div >
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_ITEMNO'>LineNo.</th>
												<th CL='STD_FIELDN'>?????? ???</th>
												<th CL='STD_FLDCMT'>??????</th>
												<th CL='STD_ACTVAT'>?????????</th>
												<th CL='STD_SORTSQ'>?????? ??????</th>
												<th CL='STD_INDASD'>Asc/Desc</th>
												<th CL='STD_WAREKY'>??????</th>
												<th CL='STD_ALSRKY'>???????????????</th>
												<th CL='STD_CREDAT'>????????????</th>
												<th CL='STD_CRETIM'>????????????</th>
												<th CL='STD_CREUSR'>?????????</th>
												<th CL='STD_CUSRNM'>????????????</th>
												<th CL='STD_LMODAT'>????????????</th>
												<th CL='STD_LMOTIM'>????????????</th>
												<th CL='STD_LMOUSR'>?????????</th>
												<th CL='STD_LUSRNM'>????????????</th>

											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />

										</colgroup>
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="text,ITEMNO"></td>
												<td GCol="text,FIELDN"></td>
												<td GCol="text,FLDCMT"></td>
												<td GCol="check,ACTVAT"></td>
												<td GCol="input,SORTSQ" GF="N 20"></td>
												<td GCol="select,INDASD">
													<select CommonCombo="INDASD">
														<option value=" "></option>
													</select>
												</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,SSORKY"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
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
									<button type="button" GBtn="copy"></button>
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
					<!-- <div id="tabs1-2">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead id="">
											<tr>
												<th></th>
												<th CL='STD_WAREKY'>??????</th>
												<th CL='STD_ALSRKY'>???????????????</th>
												<th CL='STD_FIELDN'>?????? ???</th>
												<th CL='STD_STEPNO'>?????? ??????</th>
												<th CL='STD_GRDVAL'>Item ??????</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div> -->
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