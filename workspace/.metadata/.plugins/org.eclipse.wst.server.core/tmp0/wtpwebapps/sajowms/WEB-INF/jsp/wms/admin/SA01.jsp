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
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			//pkcol : "WAREKY,AREAKY,OWNRKY,",
			module : "WmsAdmin",
			command : "SA01",
			validation : "WAREKY,AREAKY,OWNRKY,SKUKEY"
	    });
		$("#USERAREA").val("<%=user.getUserg5()%>");
	});
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHAREMA"){
			var param = new DataMap();
			param.put("COMPKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
		}else if(searchCode == "SHWAHMA"){
			var param = new DataMap();
			param.put("COMPKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
		}else if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
		}
		return param;
	}
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		searchOpen(false);
	}
	
	function saveData(){
		var duplist = gridList.getModifyList("gridList", "A");
		if(duplist.length < 1){
			commonUtil.msgBox("수정된 데이터가 없습니다.");
			return;
		}
		
		var vparam = new DataMap();
		vparam.put("list", duplist);
		vparam.put("key", "WAREKY,AREAKY,OWNRKY,SKUKEY");
		var json = netUtil.sendData({
			url : "/wms/admin/json/validationSA01.data",
			param : vparam
		});
	
		if(json.data != "OK"){
			var msgList = json.data.split(" ");
			var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
			commonUtil.msg(msgTxt);
			return false;
		}else{
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			
			var json = gridList.gridSave({
		    	id : "gridList",
		    	param : param
		    });
			
			if(json){
				if(json.data){
					searchList();
				}
			}
		}		
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId=="gridList" && colName=="WAREKY"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("WAREKY",colValue);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "WAREKYNM",
					sendType : "map",
					param : param
				});
				
				if(json && json.data){
					gridList.setColValue("gridList", rowNum, "NAME01", json.data["NAME01"]); 
				}else{
					commonUtil.msgBox("MASTER_M1103");  //거점을 확인해주세요.
					gridList.setColFocus(gridId, rowNum, "WAREKY");
					gridList.setColValue("gridList", rowNum, "WAREKY", "");
					gridList.setColValue("gridList", rowNum, "NAME01", "");
				}
			}
		}else if(gridId=="gridList" && colName=="AREAKY"){
			var wareky = gridList.getColData(gridId, rowNum, "WAREKY");
			if(colValue != ""){
				if(wareky == ""){
					commonUtil.msgBox("MASTER_M1102"); //거점을 먼저 입력해주세요.
					gridList.setColFocus(gridId, rowNum, "WAREKY");
				}else{
					var param = new DataMap();
					param.put("AREAKY",colValue);
					param.put("WAREKY",wareky);
					
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "AREAKYNM",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "SHORTX", json.data["SHORTX"]); 
					}else{
						commonUtil.msgBox("MASTER_M1101"); //창고를 확인해주세요.
						gridList.setColFocus(gridId, rowNum, "AREAKY");
						gridList.setColValue("gridList", rowNum, "AREAKY", "");
						gridList.setColValue("gridList", rowNum, "SHORTX", "");
					}
				}
			}
		}else if(gridId=="gridList" && colName=="SKUKEY"){
			var ownrky = gridList.getColData(gridId, rowNum, "OWNRKY");
			if(colValue != ""){
				if(ownrky == ""){
					commonUtil.msgBox("MASTER_M1105"); //화주를 확인해주세요.
					gridList.setColFocus(gridId, rowNum, "OWNRKY");
				}else{
					var param = new DataMap();
					param.put("SKUKEY", colValue);
					param.put("OWNRKY", ownrky);
					
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "SKUKEYNM",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "DESC01", json.data["DESC01"]); 
					}else{
						commonUtil.msgBox("MASTER_M1104"); //품번을 확인해주세요.
						gridList.setColFocus(gridId, rowNum, "SKUKEY");
						gridList.setColValue("gridList", rowNum, "SKUKEY", "");
						gridList.setColValue("gridList", rowNum, "DESC01", "");
					}
				}
			}
		}
	}
	
 	function gridListEventRowAddBefore(gridId, rowNum){
		var param = dataBind.paramData("searchArea");
		param.put("OWNRKY", "<%=ownrky%>");

		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "SA01ROWADD",
			sendType : "map",
			param : param
		});
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", json.data["NAME01"]);
		newData.put("OWNRKY", "<%=ownrky%>");
		newData.put("OWNRNM", json.data["OWNRNM"]);
		newData.put("AREAKY", param.get("AREAKY"));
		newData.put("SHORTX", json.data["SHORTX"]);

		return newData;
	} 
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Save SAVE STD_SAVE"></button>

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
				<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_WAREKY">거점</th>
							<td><input type="text" name="WAREKY" value="<%=wareky%>" id="WAREKY" readonly="readonly" /></td>
						</tr>
						<tr>
							<th CL="STD_AREAKY">창고</th>
							<td><select Combo="WmsAdmin,AREACOMBO" name="AREAKY" id="USERAREA" ></select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">품번코드</th>
							<td><input type="text" name="SKUKEY" UIInput="R,SHSKUMA" /></td>
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>리스트</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
												<col width="40" />
												<col width="60" />
												<col width="50" />
												<col width="150" />
												<col width="120" />

												<col width="100" />
												<col width="100" />
												<col width="100" />
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
													<th CL='STD_NUMBER'>번호</th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_WARENM'></th>
													<th CL='STD_AREAKY'></th>
													<th CL='STD_AREANM'>창고명</th>

													<th CL='STD_OWNRKY'></th>
													<th CL='STD_OWNRNM'></th>
													<th CL='STD_SKUKEY'></th>
													<th CL='STD_DESC01'></th>
													<th CL='STD_QTYROP'></th>

													<th CL='STD_QTYMSL'></th>
													<th CL='STD_CREDAT'></th>
													<th CL='STD_CRETIM'></th>
													<th CL='STD_CREUSR'></th>
													<th CL='STD_LMODAT'></th>

													<th CL='STD_LMOTIM'></th>
													<th CL='STD_LMOUSR'></th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
												<col width="40" />
												<col width="60" />
												<col width="50" />
												<col width="150" />
												<col width="120" />

												<col width="100" />
												<col width="100" />
												<col width="100" />
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
													<td GCol="text,WAREKY,SHWAHMA" validate="required,VALID_M0401">거점</td>
													<td GCol="text,NAME01">거점명</td>
													<td GCol="text,AREAKY,SHAREMA" id="AREAKY"
														validate="required,COMMON_M0035"></td>
													<td GCol="text,SHORTX">창고명</td>

													<td GCol="text,OWNRKY">화주</td>
													<td GCol="text,OWNRNM">화주명</td>
													<td GCol="add,SKUKEY,SHSKUMA" validate="required,VALID_M1551">품목</td>
													<td GCol="text,DESC01">품명</td>
													<td GCol="input,QTYROP" GF="N 20"
														validate="required,VALID_M1553">ROP</td>

													<td GCol="input,QTYMSL" GF="N 20"
														validate="required,VALID_M1554">MSL</td>
													<td GCol="text,CREDAT" GF="D">생성일자</td>
													<td GCol="text,CRETIM" GF="T">생성시간</td>
													<td GCol="text,CREUSR">생성자</td>
													<td GCol="text,LMODAT" GF="D">수정일자</td>

													<td GCol="text,LMOTIM" GF="T">수정시간</td>
													<td GCol="text,LMOUSR" >수정자</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
<!-- 										<button type="button" GBtn="copy"></button> -->
<!-- 										<button type="button" GBtn="add"></button> -->
<!-- 										<button type="button" GBtn="delete"></button> -->
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