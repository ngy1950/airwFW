<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	var flag = "U";
	var rangelist = [ "LOTA01", "LOTA02", "LOTA03", "AREAKY", "ZONEKY",
			"LOCAKY" ];
	function searchList() {
		flag = "U";
		//var param = dataBind.paramData("searchArea");
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			var lotrky = param.get("LOTRKY");
			var lotrkyChk = new DataMap();

			lotrkyChk.put("LOTRKY", lotrky);

			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOTRKYval",
				sendType : "map",
				param : param
			});

			if (json.data["CNT"] > 0) {
				netUtil.send({
					module : "WmsAdmin",
					command : "TF01",
					bindId : "tabs1-1",
					sendType : "map",
					bindType : "field",
					param : param
				});

				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "TF01SUB",
					bindId : "tabs1-2",
					sendType : "list",
					bindType : "field",
					param : param
				});
				var list = json.data;

				var tabs2_data = new DataMap();
				$.each(list, function(i, obj) {
					var name = obj.DBFILD.toUpperCase();
					if (name != "LOTA01" && name != "LOTA02"
							&& name != "LOTA03" && name != "AREAKY"
							&& name != "ZONEKY" && name != "LOCAKY") {
						if (name == "LOTA11" && obj.RNGVOP != "GT") {
							var rngvop = obj.RNGVOP;
							if (rngvop == "BW") {
								//LOTA11LSCK LOTA11TSCK
								tabs2_data.put("LOTA11LSCK", "V");
								tabs2_data.put("LOTA11TSCK", "V");
							} else if (rngvop == "LK" && obj.RNGVMI == "1") {
								tabs2_data.put("LOTA11LSCK", "V");
								tabs2_data.put("LOTA11TSCK", " ");
							} else if (rngvop == "LK" && obj.RNGVMI == "0") {
								tabs2_data.put("LOTA11LSCK", "");
								tabs2_data.put("LOTA11TSCK", "V");
							}
						} else {
							tabs2_data.put(name, obj.RNGVMI);
						}
					}
				});

				dataBind.dataNameBind(tabs2_data, "tabs1-2");
				$.each(rangelist, function(num, data) {
					var rangeList = new Array();
					var rngvop = "";
					$.each(list, function(i, obj) {
						if (obj.DBFILD.toUpperCase() == data) {
							var mangeMap = new DataMap();
							rngvop = obj.RNGVOP;
							if (rngvop == "BW") {
								mangeMap.put("OPER", "E");
								mangeMap.put("FROM", obj.RNGVMI);
								mangeMap.put("TO", obj.RNGVMX);
							}else if (rngvop == "NB") {
								mangeMap.put("OPER", "N");
								mangeMap.put("FROM", obj.RNGVMI);
								mangeMap.put("TO", obj.RNGVMX);	
							}else if (rngvop == "EQ") {
								mangeMap.put("OPER", "E");
								mangeMap.put("DATA", obj.RNGVMI);
							}else if (rngvop == "NE") {
								mangeMap.put("OPER", "N");
								mangeMap.put("DATA", obj.RNGVMI);
							}else if (rngvop == "LT") {
								mangeMap.put("OPER", "LT");
								mangeMap.put("DATA", obj.RNGVMI);
							}else if (rngvop == "GT") {
								mangeMap.put("OPER", "GT");
								mangeMap.put("DATA", obj.RNGVMI);
							}else if (rngvop == "LE") {
								mangeMap.put("OPER", "LE");
								mangeMap.put("DATA", obj.RNGVMI);
							}else if (rngvop == "GE") {
								mangeMap.put("OPER", "GE");
								mangeMap.put("DATA", obj.RNGVMI);
							}
							rangeList.push(mangeMap);
						}
					});
					if (rngvop == "BW" ||  rngvop == "NB") {
						inputList.setRangeData(data,
								configData.INPUT_RANGE_TYPE_RANGE, rangeList);
					} else {
						inputList.setRangeData(data,
								configData.INPUT_RANGE_TYPE_SINGLE, rangeList);
					}
				});

				searchOpen(false);
				//dataBind.dataNameBind(map,"tabs1-2")
				//alert(JSON.stringify(map))
			} else {
				commonUtil.msgBox("MASTER_M0099");

			}

		}
	}

	function creatList() {
		flag = "I";
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			var lotrky = param.get("LOTRKY");
			var lotrkyChk = new DataMap();

			lotrkyChk.put("LOTRKY", lotrky);

			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOTRKYval",
				sendType : "map",
				param : param
			});

			if (json.data["CNT"] > 0) {
				//alert(commonUtil.getMsg("MASTER_M0025", lotrky));
				commonUtil.msgBox("MASTER_M0025", lotrky);
				return;
			}

			netUtil.send({
				module : "WmsAdmin",
				command : "TF01New",
				bindId : "tabs1-1",
				sendType : "map",
				bindType : "field",
				param : param
			});

			netUtil.send({
				module : "WmsAdmin",
				command : "TF01SubNew",
				bindId : "tabs1-2",
				sendType : "map",
				bindType : "field",
				param : param
			});
			searchOpen(false);
		}
	}
	function saveData() {
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		var head = dataBind.paramData("tabs1-1");//상단 필드셋 
		//하단 !
		var list = dataBind.paramData("tabs1-2");

		$.each(rangelist, function(i, obj) {
			var singleListLot = inputList.getRangeData(obj,
					configData.INPUT_RANGE_TYPE_SINGLE);
			var rangeListLot = inputList.getRangeData(obj,
					configData.INPUT_RANGE_TYPE_RANGE);
			if (singleListLot.length > 0) {
				list.put(obj, singleListLot);
			} else {
				list.put(obj, rangeListLot);
			}
		});
		//alert(list)
		//return false;

		var param = new DataMap();
		param.put("head", head);
		param.put("list", list);
		param.put("STATUS", flag);
		var json = netUtil.sendData({
			url : "/wms/admin/json/TF01.data",
			param : param
		});

		if (json && json.data) {
			commonUtil.msgBox("HHT_T0008");
			searchList();
		}

	}
	function delData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
			return;
		}
		var head = dataBind.paramData("tabs1-1");//상단 필드셋 
		
		var param = new DataMap();
		param.put("head", head);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/delTF01.data",
			param : param
		});
	
		if (json && json.data) {
			commonUtil.msgBox("VALID_M0003");
			searchOpen(true);
		}
	}
	function searchHelpEventOpenBefore(searchCode, gridType) {
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if (searchCode == "SHWAHMA") {
			return dataBind.paramData("searchArea");
		} else if (searchCode == "SHRLRRH") {
			return dataBind.paramData("searchArea");
		} else if (searchCode == "SHAREMA") {
			return dataBind.paramData("searchArea");
		} else if (searchCode == "SHZONMA") {
			return dataBind.paramData("searchArea");
		} else if (searchCode == "SHLOCMA") {
			return dataBind.paramData("searchArea");
		}
	}


	function commonBtnClick(btnName) {
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Delete") {
			delData();
		} else if (btnName == "Create") {
			creatList();
		}
	}
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Save SAVE STD_SAVE"></button>
		    <button CB="Delete DELETE BTN_DELETE"></button>
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
				<button CB="Create CREATE BTN_CREATE"></button>
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
							<td><input type="text" id="WAREKY" name="WAREKY"
								readonly="readonly" value="<%=wareky%>" /></td>
						</tr>
						<tr>
							<th CL="STD_LOTRKY">할당필터링키</th>
							<td><input type="text" id="LOTRKY" name="LOTRKY"
								UIInput="S,SHRLRRH" validate="required,MASTER_M1001" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- //searchPop -->

	<!-- content -->
	<!-- content -->
	<div class="content">
		<div class="innerContainer" id="content">

			<!-- contentContainer -->
			<div class="contentContainer">

				<div class="foldSect">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL="STD_GENERAL">일반</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1 hei200">
								<div class="table type1">
									<table>
										<tr> 
											<th CL="STD_WAREKY">거점</th>
											<td><input type="text" name="WAREKY" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_LOTRKY">할당필터링키</th>
											<td><input type="text" name="LOTRKY" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SHORTX">설명</th>
											<td><input type="text" name="SHORTX" /></td>
										</tr>
									</table>

								</div>
							</div>
						</div>
					</div>
				</div>
				<!--  -->
				<div class="bottomSect type2">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>조회</span></a></li>
						</ul>
						<div id="tabs1-2">
							<div class="section type1" style="overflow: scroll">
								<div class="searchInBox">

									<div class="table type1">
										<!-- 	Lot 속성 -->
										<table>
											<tr>
												<th><h2 class="tit" CL="STD_LOTAAT"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th CL="STD_LOTA01">S/N번호</th>
												<td><input type="text" name="LOTA01" UIInput="R" /></td>
											</tr>
											<tr>
												<th CL="STD_LOTA02">재고유형</th>
												<td><input type="text" name="LOTA02" UIInput="R" /></td>
											</tr>
											<tr>
												<th CL="STD_LOTA03">벤더</th>
												<td><input type="text" name="LOTA03" UIInput="R" /></td>
											</tr>
											<tr>
												<th><h2 class="tit"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th><h2 class="tit" CL="STD_PRODDT"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th CL="STD_LSYEAR">전년도</th>
												<td><input type="checkbox" name="LOTA11LSCK" value="V" /></td>
											</tr>
											<tr>
												<th CL="STD_TSYEAR">당해년도</th>
												<td><input type="checkbox" name="LOTA11TSCK" value="V" /></td>
											</tr>
											<tr>
												<th CL="STD_WHNDAY">월기한</th>
												<td><input type="text" name="LOTA11" /><label CL="STD_PERMON" ></label></td>
											</tr>
											<tr>
												<th><h2 class="tit"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th><h2 class="tit" CL="STD_POSINFO"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th CL="STD_AREAKY">창고</th>
												<td><input type="text" name="AREAKY"
													UIInput="R,SHAREMA" /></td>
											</tr>
											<tr>
												<th CL="STD_ZONEKY">구역</th>
												<td><input type="text" name="ZONEKY"
													UIInput="R,SHZONMA" /></td>
											</tr>
											<tr>
												<th CL="STD_LOCAKY">지번</th>
												<td><input type="text" name="LOCAKY"
													UIInput="R,SHLOCMA" /></td>
											</tr>
											<tr>
												<th CL="STD_TKZONE">작업구역</th>
												<td GCol="select,TKZONE"><select CommonCombo="TKZONE"
													name="TKZONE">
														<option value=" "></option>
												</select></td>
											</tr>
											<tr>
												<th><h2 class="tit"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th><h2 class="tit" CL="TAB_QTYINFO"></h2></th>
												<td></td>
											</tr>
											<tr>
												<th CL="STD_STKQTY">재고수량</th>
												<td GCol="select,STKQTY"><select CommonCombo="STKQTY"
													name="STKQTY">
														<option value=" "></option>
												</select></td>
											</tr>
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
     </div>
		<!-- //content -->
<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>