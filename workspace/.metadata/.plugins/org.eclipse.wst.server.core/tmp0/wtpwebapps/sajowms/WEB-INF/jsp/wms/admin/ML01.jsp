<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var flag = "U";
	var wareky = "";
	var locaky="";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "WAREKY,LOCAKY",
			module : "WmsAdmin",
			command : "LOCMA",
			validation : "WAREKY,ZONEKY,LOCAKY",
			bindArea : "tabs1-2" 
	    });
	});
	
	function searchList(){
		var flag = "U";
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function creatList(){
		flag = "I";
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			wareky = param.get("WAREKY");
			//locaky=param.get("RANGE_SQL");	
			locaky=$("[name=LOCAKY]").parent().find(".searchInput").val();
			
			if(!locaky){
				commonUtil.msgBox("HHT_T0032"); //지번을 입력하세요
				return;
			}
			
			param.put("LOCAKY",locaky);
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOCMAval",
				sendType : "map",
				param : param
			});
			
			if(json.data["CNT"] > 0) {
				commonUtil.msgBox("VALID_M0104",locaky); // 이미 존재하는 지번입니다.
				return;
			}
			
			/* gridList.gridList({
		    	id : "gridList",
		    	module : "WmsAdmin",
				command : "LOCMA2",
		    	param : param
		    }); */
		    
			var newData = new DataMap();
			newData.put("LOCAKY", locaky);
			newData.put("WAREKY", "<%=wareky%>");
			newData.put("LOCATY", "10"); 
			newData.put("STATUS", "00");
			newData.put("MAXCPC", 0);
			newData.put("ERPLOC", " ");
			newData.put("SFSTOK", 0);
			newData.put("WIDTHW", 0);
			newData.put("HEIGHT", 0);
			gridList.setAddRow("gridList", newData);
			newData.clear();
			searchOpen(false);
		}
	}
	
	function saveData(){
		if(checkValidationType){
			var param = dataBind.paramData("searchArea");
			var json = gridList.gridSave({
		    	id : "gridList",
		    	param : param,
		        modifyType : 'A'
		    });
			
			if(json && json.data){
				searchList();
			}	
		}
	}
	
	var checkValidationType = true;
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){		
		if(gridId == "gridList" && colName == "ZONEKY"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				param.put("ZONEKY",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "ZONEKYval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("WAREKY","<%=wareky%>");
					param.put("ZONEKY",colValue);
					var json = netUtil.sendData({
						module : "WmsAdmin",
						command : "AREAKY",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "AREAKY", json.data["AREAKY"]); 
					} 
					checkValidationType = true;
				} else if (json.data["CNT"] < 1) {
					commonUtil.msgBox("MASTER_M0044", colValue);
					gridList.setColValue("gridList", rowNum, "ZONEKY", ""); 
					checkValidationType = false;
				}
			}else if(colValue==""){
				gridList.setColValue("gridList", rowNum, "AREAKY", "");
				checkValidationType = true;
			}
		} else if (gridId == "gridList" && colName == "TKZONE") {
			if(colValue != ""){
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				param.put("TKZONE",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "TKZONEval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] < 1) {
					commonUtil.msgBox("MASTER_M0461", colValue);  //작업구역이 올바르지 않습니다.
					gridList.setColValue("gridList", rowNum, "TKZONE", ""); 
					checkValidationType = false;
				}else{
					checkValidationType = true;
				}
			}
		}
	}
	
	
	
 	function gridListEventRowAddBefore(gridId, rowNum){
 		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("LOCATY", "10"); 
		newData.put("STATUS", "00");
		newData.put("LENGTH", 0);
		newData.put("WIDTHW", 0);
		newData.put("HEIGHT", 0);
		newData.put("CUBICM", 0);
		newData.put("MAXCPC", 0);
		newData.put("MAXQTY", 0);
		newData.put("MAXWGT", 0);
		newData.put("MAXLDR", 0);
		newData.put("MAXSEC", 0);
		newData.put("QTYCHK", 0);
		
		return newData;
	}  
 	
 	
 	function locakyCheck(valueTxt, $colObj){
		var rowNum = gridList.getColObjRowNum("gridList", $colObj);
		var rowCount = gridList.getGridDataCount("gridList");
		for(var i=0;i<rowCount;i++){
			if(i != rowNum){
				var locaky = gridList.getColData("gridList", i, "LOCAKY");
				if(locaky == valueTxt){
					return false;
				}
			}			
		}
		return true;
	}
 	
 	function gridListEventRowRemove(gridId, rowNum){
		var rowWar = gridList.getColData("gridList", rowNum, "WAREKY");
		var rowLoc = gridList.getColData("gridList", rowNum, "LOCAKY");
		  if(gridId == "gridList"){
			var param = new DataMap();
			param.put("WAREKY", rowWar);
			param.put("LOCAKY", rowLoc);
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "LOCMADELval",
				sendType : "map",
				param : param
			});
			
			if(json && json.data){
				if(json.data["CNT"] > 0){
					commonUtil.msgBox("MASTER_M1004", rowNum);
					/* alert("선택한 지번에 재고수량이 존재하여 삭제할 수 없습니다."); */
					return false;
				} else if (json.data["CNT"] == 0){
					return true;
				}
			}
		}  
	}
 	function searchHelpEventOpenBefore(searchCode, gridType){
		 if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHLOCMA"){
			return dataBind.paramData("searchArea");
		}
	}
 	function commonBtnClick(btnName){
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
	<div class="util3">
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
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">창고</th>
						<td>
							<input type="text" name="AREAKY" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY">구역</th>
						<td>
							<input type="text" name="ZONEKY" UIInput="R,SHZONMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TKZONE">작업구역</th>
						<td>
							<input type="text" name="TKZONE" UIInput="R,SHZONMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="LOCAKY" UIInput="R,SHLOCMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCATY">로케이션유형</th>
						<td GCol="select,LOCATY">
							<select CommonCombo="LOCATY" name="LOCATY" style="width: 170px">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_STATUS">상태</th>
						<td GCol="select,STATUS">
							<select CommonCombo="STATUS" name="STATUS" style="width: 170px">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
					
					
						<th CL="STD_INDUPA">입고가능</th>
						<td>
							<input type="checkbox"  name="INDUPA" checked="checked"/>
						</td>
						<th CL="STD_INDUPK">피킹가능</th>
						<td>
							<input type="checkbox" name="INDUPK" checked="checked"/>
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
						<li><a href="#tabs1-1"><span CL='STD_ITEMLST'>Item리스트</span></a></li>
						<!-- <li><a href="#tabs1-2"><span CL='STD_ITEMDET'>Item상세</span></a></li> -->
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="100" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<!-- <col width="80" />
											<col width="80" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_LOCAKY'></th>
												<th CL='STD_TKZONE'></th>
												<th CL='STD_LOCATY'></th>
												<th CL='STD_STATUS'></th>
												<th CL='STD_INDUPA'></th>
												<th CL='STD_INDUPK'></th>
												<th CL='STD_INDCPC'></th>
												<th CL='STD_MAXCPC'></th>
												<!-- <th CL='STD_ERPLOC'></th>
												<th CL='STD_SFSTOK'></th> -->
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_MIXSKU'></th>
												<th CL='STD_MIXLOT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="100" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<!-- <col width="80" />
											<col width="80" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="input,ZONEKY,SHZONMA" GF="S 10"></td> 
												<td GCol="input,LOCAKY" validate="required,HHT_T0032" GF="S 20"></td>
												<td GCol="input,TKZONE,SHZONMA" GF="S 10"></td>
												<td GCol="select,LOCATY">
													<select CommonCombo="LOCATY">
													</select>
												</td>
												<td GCol="select,STATUS">
													<select CommonCombo="STATUS">
													</select>
												</td>
												<td GCol="check,INDUPA"></td>
												<td GCol="check,INDUPK"></td>
												<td GCol="check,INDCPC"></td>
												<td GCol="input,MAXCPC" GF="N 20,3"></td>
												<!-- <td GCol="input,ERPLOC" GF="S 20"></td>
												<td GCol="input,SFSTOK" GF="N 20,3"></td> -->
												<td GCol="input,WIDTHW" GF="N 20,3"></td>
												<td GCol="input,HEIGHT" GF="N 20,3"></td>
												<td GCol="check,MIXSKU"></td>
												<td GCol="check,MIXLOT"></td>
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
<!-- 					
					<div id="tabs1-2">
						<div class="section type1" style="overflow-y:scroll;">
							<div class="controlBtns type2"  GNBtn="gridList">
								<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
							</div>
							<div class="searchInBox">
								<table class="table type1">
									<colgroup>
										<col width="8%"/>
										<col width="15%"/>
										<col width="2%"/>
										<col width="15%"/>
										<col width="2%"/>
									</colgroup>
									<tbody>
										<tr>
											<th CL='STD_WAREKY'>거점</th>
											<td>
												<input type="text" name="WAREKY" readonly="readonly"/>
											</td>
											<th CL='STD_LOCAKY'>지번</th>
											<td>
												<input type="text" name="LOCAKY" readonly="readonly"/>
											</td>
											<th CL='STD_STATUS'>상태</th>
											<td GCol="select,STATUS">
												<select CommonCombo="STATUS" name="STATUS"></select>
											</td>
										</tr>
										<tr>
											<th CL='STD_LOCATY'>로케이션유형</th>
											<td GCol="select,LOCATY">
												<select CommonCombo="LOCATY" name="LOCATY"></select>
											</td>
											<th CL='STD_AREAKY'>창고</th>
											<td>
												<input type="text" name="AREAKY" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_ZONEKY'>구역</th>
											<td>
												<input type="text" name="ZONEKY"/>
											</td>
											<th CL='STD_TKZONE'>작업구역</th>
											<td>
												<input type="text" name='TKZONE'/>
											</td>
										</tr>
										<tr>
											<th CL='STD_INDCPC'>Capa체크</th>
											<td>
												<input type="checkbox" name='INDCPC' value="V"/>
											</td>
											<th CL='STD_MAXCPC'>최대Capa.</th>
											<td>
												<input type="text" name='MAXCPC'/>
											</td>
										</tr>
										<tr>
											<th CL='STD_INDUPA'>입고가능</th>
											<td>
												<input type="checkbox" name='INDUPA' value="V"/>
											</td>
											<th CL='STD_INDUPK'>파킹가능</th>
											<td>
												<input type="checkbox" name='INDUPK' value="V"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_LENWIDHGT,2'>길이*너비*높이</th>
											<td colspan="3">
												<input type="text" name="LENGTH"/> *
												<input type="text" name="WIDTHW"/> *
												<input type="text" name="HEIGHT"/> *
												<input type="text" name="CUBICM"/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
					
					</div>
				</div>	 -->			
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