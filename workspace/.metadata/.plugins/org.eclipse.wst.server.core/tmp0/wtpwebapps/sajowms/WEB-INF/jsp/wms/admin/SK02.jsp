<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	//var dblIdx = -1;
	var headFocusNum = -1;
	var dblIdx = 0;
	$(document).ready(function() {
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			pkcol : "OWNRKY,SKUKEY",
			module : "WmsAdmin",
			command : "SKUMA",
			validation : "OWNRKY,WAREKY,SKUKEY,MEASKY,LOCARV,PASTKY,DPUTLO,ALSTKY",
			bindArea : "tabs1-2"
		});
		gridList.setReadOnly('gridList',true, ['DELMAK','OBPROT','SKUG01']);
	});

	function searchList() {
		//var param = dataBind.paramData("searchArea");
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			param.put("PROGID","SK02");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		} 
		if(gridList.validationCheck("gridList", "modify")){
			var head = gridList.getModifyList("gridList", "A");
			
			var vparam = new DataMap();
			vparam.put("list", head);
			vparam.put("key", "OWNRKY,WAREKY,SKUKEY,MEASKY,LOCARV,PASTKY,DPUTLO,ALSTKY,DPUTZO");
			var json = netUtil.sendData({
				url : "/wms/admin/json/validationSK01.data",
				param : vparam
			});
			
			
			if(json.data != "OK"){
				var msgList = json.data.split(" ");
				var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				commonUtil.msg(msgTxt);
				return false;
			}
			
		    
			var param = new DataMap();
			param.put("head", head);
			
			var json = netUtil.sendData({
				url : "/wms/admin/json/saveSK01.data",
				param : param
			});
			
			
			if(json && json.data){
				alert(commonUtil.getMsg("HHT_T0008"));
				searchList();
			}
		}
	}

	<%-- function gridListEventRowAddBefore(gridId, rowNum) {
		dblIdx = rowNum;
		/*
		var param=new DataMap();
		param.put("WAREKY","<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "WAHMA_ADDR05",
			sendType : "map",
			param : param
		});
		*/
		
		var newData = new DataMap();
		newData.put("OWNRKY", "<%=ownrky%>");
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("SKUG01", "001"); 
		newData.put("DUOMKY", "EA");
		newData.put("WEIGHT", "0");
		newData.put("LENGTH", "0");
		newData.put("WIDTHW", "0");
		newData.put("HEIGHT", "0");
		newData.put("CUBICM", "0");
		newData.put("CAPACT", "0"); 
		newData.put("QTYBOX", "0");
		newData.put("QTYCNT", "0");
		newData.put("QTDUOM", "0");
		
		return newData;
	} --%>
	
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		} else if(searchCode == "SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHMEASH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHVRCVLO1"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHPASTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHALSTH"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHSKUMA"){
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}else if(searchCode=="SHCMCDV"){
			var param = new DataMap();
			param.put("CMCDKY", "SKUG01");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
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
		<div class="util3">
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
							<th CL="STD_WAREKY">Center Code</th>
							<td><input type="text" name="WAREKY" UIInput="S,SHWAHMA"
								value="<%=wareky%>" validation="required,VALID_M0401" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">????????????</th>
							<td><input type="text" name="A.SKUKEY" UIInput="R,SHSKUMA" /></td>
						</tr>
						<tr>
							<th CL="STD_DESC01">??????</th>
							<td><input type="text" name="A.DESC01" UIInput="R" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG01">???????????????</th>
							<td><input type="text" name="A.SKUG01" UIInput="R,SHCMCDV" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG02">???????????????</th>
							<td><input type="text" name="A.SKUG02" UIInput="R,SHCMCDV" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG03">???????????????</th>
							<td><input type="text" name="A.SKUG03" UIInput="R,SHCMCDV" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG04">?????????</th>
							<td><input type="text" name="A.SKUG04" UIInput="R,SHCMCDV" /></td>
						</tr>
						<tr>
							<th CL="STD_SKUG05">??????</th>
							<td><input type="text" name="A.SKUG05" UIInput="R,SHCMCDV" /></td>
						</tr>
					</tbody>
				</table>

			</div>
		</div>

		<div class="searchInnerContainer">
			<div class="searchInBox">
				<h2 class="tit" value="??????">??????</h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_PASTKY">???????????????</th>
							<td><input type="text" name="B.PASTKY" UIInput="R,SHPASTH" /></td>
						</tr>
						<tr>
							<th CL="STD_ALSTKY">???????????????</th>
							<td><input type="text" name="B.ALSTKY" UIInput="R,SHALSTH" /></td>
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
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>?????????1</span></a></li>
							<li><a href="#tabs1-2"><span CL='STD_DETAIL'>?????????2</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>??????</th>
												<th CL='STD_OWNRKY'>??????</th>
												<th CL='STD_WAREKY'>??????</th>
												<th CL='STD_SKUKEY'>????????????</th>
												<th CL='STD_DELMAK'>??????</th>
												<th CL='STD_DESC01'>??????</th>
												<th CL='STD_LOTL01'>??????</th>
												<th CL='STD_MEASKY'>????????????</th>
												<th CL='STD_LOTL03'></th>
												<th CL='STD_DUOMKY'></th>
												<th CL='STD_ABCANV'></th>
												<th CL='STD_QCRCYN'></th>
												<th CL='STD_QCRCTP'></th>
												<th CL='STD_QCSHYN'></th>
												<th CL='STD_QCSHTP'></th>
												<th CL='STD_LOCARV'>??????????????????</th>
												<th CL='STD_PASTKY'>???????????????</th>
												<th CL='STD_DPUTZO'>?????? ????????????</th>
												<th CL='STD_DPUTLO'>?????? ????????????</th>
												<th CL='STD_ALSTKY'>???????????????</th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKL02'></th>
												<th CL='STD_SKUG01'>???????????????</th>
												<th CL='STD_SKUG02'>???????????????</th>
												<th CL='STD_SKUG03'>???????????????</th>
												<th CL='STD_SKUG04'>?????????</th>
												<th CL='STD_SKUG05'>??????</th>
												<th CL='STD_SKUL01'>??????????????????</th>
												<th CL='STD_SKUL02'>??????????????????</th>
												<th CL='STD_SKUL03'>??????????????????</th>
												<th CL='STD_SKUL04'>????????????</th>
												<th CL='STD_SKUL05'>?????????</th>
												<th CL='STD_QTDUOM'></th>
												<th CL='STD_OBPROT'>????????????</th>
												<th CL='STD_QTYSTD'></th>
												<th CL='STD_QTYCNT'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKL01'></th>
												<th CL='STD_CREDAT'>????????????</th>
												<th CL='STD_CRETIM'>????????????</th>
												<th CL='STD_CREUSR'>?????????</th>
												<th CL='STD_NMLAST'>????????????</th>
												<th CL='STD_LMODAT'>????????????</th>
												<th CL='STD_LMOTIM'>????????????</th>
												<th CL='STD_LMOUSR'>?????????</th>
												<th CL='STD_NMLAST,2'>????????????</th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">												                                                           
												<td GCol="rownum">1</td>                                                            
												<td GCol="text,OWNRKY"></td>                                                        
												<td GCol="text,WAREKY"></td>                                                        
												<td GCol="text,SKUKEY"></td>                                                        
												<td GCol="check,DELMAK"></td>                                                       
												<td GCol="text,DESC01"></td>                                                        
												<td GCol="text,LOTL01"></td>                                                        
												<td GCol="text,MEASKY"></td>                                                        
												<td GCol="text,LOTL03"></td>                                                        
												<td GCol="text,DUOMKY"></td>                                                        
												<td GCol="input,ABCANV" GF="S 4"></td>                                              
												<td GCol="text,QCRCYN"></td>                                                        
												<td GCol="text,QCRCTP"></td>                                                        
												<td GCol="text,QCSHYN"></td>                                                        
												<td GCol="text,QCSHTP"></td>                                                        
												<td GCol="input,LOCARV,SHVRCVLO1" GF="S 20" validate="required,VALID_M0904"></td>   
												<td GCol="input,PASTKY,SHPASTH" validate="required,VALID_M0408" GF="S 20"></td>     
												<td GCol="input,DPUTZO,SHZONMA" GF="S 10"></td>                                     
												<td GCol="input,DPUTLO,SHVRCVLO1" GF="S 20" validate="required"></td>               
												<td GCol="input,ALSTKY,SHALSTH" validate="required,VALID_M0411" GF="S 10"></td>     
												<td GCol="text,ASKU02"></td>                                                        
												<td GCol="text,ASKL02"></td>                                                        
												<td GCol="select,SKUG01">                                                    
													<select CommonCombo="SKUG01" disabled="disabled">
														<option value=""> </option>
													</select>                                      
												</td>                                                                               
												<td GCol="text,SKUG02"></td>                                                        
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>                                                        
												<td GCol="text,SKUG05"></td>                                                              
												<td GCol="text,SKUL01"></td>                                                        
												<td GCol="text,SKUL02"></td>                                                        
												<td GCol="text,SKUL03"></td>    
												<td GCol="text,SKUL04"></td>                                                        
												<td GCol="text,SKUL05"></td>                                                     
												<td GCol="text,QTDUOM" GF="N"></td>                                                        
												<td GCol="check,OBPROT" ></td>                                                      
												<td GCol="text,QTYSTD" GF="N"></td>                                                        
												<td GCol="text,QTYCNT" GF="N"></td>                                                        
												<td GCol="text,ASKU01"></td>                                                        
												<td GCol="text,ASKL01"></td>                                                        
												<td GCOL="text,CREDAT" GF="D"></td>                                                        
												<td GCOL="text,CRETIM" GF="T"></td>                                                        
												<td GCol="text,CREUSR"></td>                                                        
												<td GCOL="text,CUSRNM"></td>                                                        
												<td GCOL="text,LMODAT" GF="D"></td>                                                        
												<td GCOL="text,LMOTIM" GF="T"></td>                                                        
												<td GCOL="text,LMOUSR"></td>                                                        
												<td GCOL="text,LUSRNM"></td>  
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

						<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2"  GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_GENERAL">??????</h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="5%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_SKUKEY'>????????????</th>
												<td>
													<input type="text" name="SKUKEY" readonly="readonly"/>
													<select CommonCombo="SKUG01" name="SKUG01"disabled="disabled"></select>
												</td>
												<!-- <td GCol="select,SKUG01">
												</td> -->
												<th CL='STD_DELMAK'></th>
												<td>
													<input type="checkbox" name="DELMAK" value="V" disabled="disabled"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_DESC01'>??????</th>
												<td>
													<input type="text" name="DESC01" size="60" readonly="readonly"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_WAREKY'>??????</th>
												<td>
													<input type="text" name="WAREKY" readonly="readonly"/>
												</td>
												<th CL='STD_OWNRKY'>??????</th>
												<td>
													<input type="text" name="OWNRKY" readonly="readonly"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_SKUINFO"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_DUOMKY'>??????</th>
												<td>
													<input type="text" name="DUOMKY" readonly="readonly"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_TB_SKU_ITM1_5"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_PASTKY'>???????????????</th>
												<td>
													<input type="text" name="PASTKY"/>
												</td>
												<th  CL='STD_DPUTZO'>?????? ????????????</th>
												<td>
													<input type="text" name="DPUTZO"/>
												</td>
												<th  CL='STD_DPUTLO'>?????? ????????????</th>
												<td>
													<input type="text" name="DPUTLO"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_ETC"></h2>
									<table class="table type1">
										<colgroup>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
											<col width="13%"/>
											<col width="5%"/>
										</colgroup>
										<tbody>
											<tr>
												<th CL='STD_LOCARV'>??????????????????</th>
												<td>
													<input type="text" name="LOCARV"/>
												</td>
												<th CL='STD_ALSTKY'>???????????????</th>
												<td>
													<input type="text" name="ALSTKY"/>
												</td>
												<th CL='STD_OBPROT'>????????????</th>
												<td>
													<input type="checkbox" name="OBPROT" value="V" disabled="disabled"/>
												</td>
											</tr>
											<tr>
												<th CL='STD_SAFQTY'>??????????????????</th>
												<td>
													<input type="text" name="SAFQTY"/>
												</td>
												<th CL='STD_QTYBOX'>????????????</th>
												<td>
													<input type="text" name="QTYBOX" readonly="readonly"/>
												</td>
											</tr>
										</tbody>
									</table>
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