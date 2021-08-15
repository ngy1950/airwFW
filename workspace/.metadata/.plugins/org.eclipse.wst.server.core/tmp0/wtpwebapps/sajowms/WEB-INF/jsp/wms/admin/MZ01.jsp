
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
    var zoneky="";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			checkHead : "gridListCheckHead", 
			pkcol : "WAREKY,ZONEKY",
			module : "WmsAdmin",
			command : "ZONMA",
			//validation : "WAREKY,AREAKY",
			bindArea : "tabs1-2" 
		});
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		
	}
	
	function creatList(){
		 flag = "I";
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			wareky = param.get("WAREKY");
			range = param.get("RANGE_SQL");		
			
			zoneky=$("[name=ZONEKY]").parent().find(".searchInput").val();
			areaky=$("[name=AREAKY]").parent().find(".searchInput").val();
			
			param.put("ZONEKY",zoneky);
			
			if(!zoneky){
				commonUtil.msgBox("VALID_M0403");
				return;
			}
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "ZONMAval",
				sendType : "map",
				param : param
			});
			if(json.data["CNT"] > 0) {
				//alert(commonUtil.getMsg("MASTER_M0025",zoneky));//이미존재합니다.
				commonUtil.msgBox("VALID_M0103",zoneky);
				return;
			} 
			
			/* gridList.gridList({
		    	id : "gridList",
		    	module : "WmsAdmin",
				command : "ZONMA2",
		    	param : param 
		    	
		    }); */
		    
			var newData = new DataMap();
		    newData.put("WAREKY", wareky);
		    newData.put("AREAKY", areaky);
		    newData.put("ZONEKY", zoneky);
			gridList.setAddRow("gridList", newData);
			newData.clear();
			searchOpen(false);
			
		 }
	}
	
	function saveData(){
		var param = dataBind.paramData("searchArea");
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
	
 	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		//newData.put("ZONETY", "STOR");
		
		return newData;
	} 
 	
 	function gridListEventRowRemove(gridId, rowNum){
		var rowAea = gridList.getColData("gridList", rowNum, "ZONEKY");
		  if(gridId == "gridList"){
			var param = new DataMap();
			param.put("ZONEKY", rowAea);
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "ZONMAval",
				sendType : "map",
				param : param
			});
			
			if(json && json.data){
				if(json.data["CNT"] > 0){
					//alert("로케이션이 존재하여 하위를 삭제 할 수 없습니다.");// messegeUtik
					commonUtil.msgBox("MASTER_M0685");
					return false;
				} else if (json.data["CNT"] <= 1){
					return true;
				}
			}
		}  
	}
 	
/*  	function zonekyCheck(valueTxt, $colObj){
		var rowNum = gridList.getColObjRowNum("gridList", $colObj);
		var rowCount = gridList.getGridDataCount("gridList");
		for(var i=0;i<rowCount;i++){
			if(i != rowNum){
				var zoneky = gridList.getColData("gridList", i, "ZONEKY");
				if(zoneky == valueTxt){
					return false;
				}
			}			
		}
		
		return true;
	} */
 	
 	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		//console.log("searchCode : "+searchCode+"\ngridType : "+gridType);
		if(searchCode == "SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHAREMA"){
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
							<input type="text" name="WAREKY" <%--UIInput="S,SHWAHMA"--%> value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY">창고</th>
						<td>
							<input type="text" name="AREAKY" UIInput="R,SHAREMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY">Zone Code</th>
						<td>
							<input type="text" name="ZONEKY" UIInput="R,SHZONMA" />
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
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>리스트</span></a></li>
						<li><a href="#tabs1-2"><span CL='STD_GENERAL'>일반</span></a></li>
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_AREAKY'>창고</th>
												<th CL='STD_ZONEKY'>구역</th>
												<th CL='STD_ZONETY'>구역타입</th>
												<th CL='STD_SHORTX'>설명</th>
												<th CL='STD_CREDAT'>생성일자</th>
												<th CL='STD_CRETIM'>생성시간</th>
												<th CL='STD_CREUSR'>생성자</th>
												<th CL='STD_CUSRNM'>생성자명</th>
												<th CL='STD_LMODAT'>수정일자</th>
												<th CL='STD_LMOTIM'>수정시간</th>
												<th CL='STD_LMOUSR'>수정자</th>
												<th CL='STD_LUSRNM'>수정자명</th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="input,AREAKY,SHAREMA" GF="S 10" validate="required,MASTER_M0254"></td>
												<td GCol="input,ZONEKY,SHZONMA" validate="required" ></td>
												<td GCol="select,ZONETY" validate="required">
													<select CommonCombo="ZONETY">
														<option value=" "></option>
													</select>
												</td>
												<td GCol="input,SHORTX" GF="S 180"></td> 
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
					
					<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2" GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_GENERAL">일반</h2>
									<table class="table type1" >
										<colgroup>
											<col width="4%" />
											<col />
										</colgroup>
										<tbody>
										<tr>
											<th CL='STD_WAREKY'>거점</th>
											<td><input type="text" name="WAREKY" readonly="readonly" /></td>
										</tr>
										<tr>
											<th CL='STD_AREAKY'>창고</th>
											<td ><input type="text" name="AREAKY"  /></td>
										<tr>
											<th CL='STD_ZONEKY'>구역</th>
											<td><input type="text" name="ZONEKY" readonly="readonly" /></td>
										</tr>
										<tr>
											<th CL='STD_ZONETY'>구역타입</th>
											<td GCol="select,ZONETY">
													<select CommonCombo="ZONETY" name="ZONETY"  style="width: 140px" ></select>   <!--  -->
											</td>
										</tr>
										<tr>
											<th CL='STD_SHORTX'>설명</th>
											<td ><input type="text" name="SHORTX" /></td>
										</tr>
									</tbody>
									</table>
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