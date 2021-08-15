
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
    var zoneky= "";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			checkHead : "gridListCheckHead", 
			pkcol : "WAREKY,,ZONEKY",
			module : "WmsAdmin",
			command : "STORY",
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
//		 flag = "I";
		gridList.resetGrid("gridList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			wareky = param.get("WAREKY");
			lstory=$("[name=LSTORY]").parent().find(".searchInput").val();
			
//			param.put("LSTORY",lstory);
			
			if(!lstory.trim()){
// 				commonUtil.msgBox("VALID_M0403");
// 				return;
				lstory ="";
			}
					    
			var newData = new DataMap();
		    newData.put("WAREKY", wareky);
		    newData.put("LSTORY", lstory);
		    newData.put("LSTOTY", "00");
			gridList.setAddRow("gridList", newData);
			newData.clear();
			searchOpen(false);
			
		 }
	}
	
	function saveData(){
		
		var list = gridList.getModifyList("gridList", "A");
		if(list.length < 1){
			commonUtil.msgBox("VALID_M1573"); //변경된 Data가 없습니다.
			return;
		}
		
		var param = new DataMap();		
		param.put("list",list);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/SaveMR01.data",
			param : param
		});
		
		if(json.data.length > 5 ){
			var msgList = json.data.split("†");
			var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
			commonUtil.msg(msgTxt);
			return;
		} 
		
		
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
	
 	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
	    var lstory = gridList.getColData("gridList", rowNum-1, "LSTORY");	    
	    var lstoty = gridList.getColData("gridList", rowNum-1, "LSTOTY");	    
	    var shortx = gridList.getColData("gridList", rowNum-1, "SHORTX");	    
	    var lbuild = gridList.getColData("gridList", rowNum-1, "LBUILD");	    
	    newData.put("LSTORY", lstory);
	    newData.put("LSTOTY", lstoty);
	    newData.put("SHORTX", shortx);
	    newData.put("LBUILD", lbuild);

		return newData;
	} 
 	
 	function gridListEventRowAddAfter(gridId, rowNum){ 
 		if (gridList.getColData("gridList", rowNum, "LSTORY") == "") {
 		    gridList.setColFocus("gridList", rowNum, "LSTORY"); 	 			
 		}else {
 		    gridList.setColFocus("gridList", rowNum, "ZONEKY"); 	 			
 		}
 	}
 	
 	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){		
		if(gridId == "gridList" && colName == "ZONEKY"){
			var param = new DataMap();
			param.put("WAREKY","<%=wareky%>");
			param.put("ZONEKY",colValue);
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "AREAKY2",
				sendType : "map",
				param : param
			});				
			if( json && json.data ){
				gridList.setColValue("gridList", rowNum, "ZONENM", json.data["ZONENM"]); 
				gridList.setColValue("gridList", rowNum, "AREAKY", json.data["AREAKY"]); 
				gridList.setColValue("gridList", rowNum, "AREANM", json.data["AREANM"]); 
			}else {
				gridList.setColValue("gridList", rowNum, "ZONEKY", "");
				gridList.setColValue("gridList", rowNum, "ZONENM", ""); 
				gridList.setColValue("gridList", rowNum, "AREAKY", ""); 
				gridList.setColValue("gridList", rowNum, "ZONENM", ""); 
			}
		}else if(gridId == "gridList" && colName == "LSTOTY"){	
			for(var i=0;i<gridList.getGridDataCount("gridList");i++)
				if(gridList.getColData("gridList", i, "LSTOTY") != colValue)
					gridList.setColValue("gridList", i, "LSTOTY", colValue );	
		}else if(gridId == "gridList" && colName == "SHORTX"){	
			for(var i=0;i<gridList.getGridDataCount("gridList");i++)
				if(gridList.getColData("gridList", i, "SHORTX") != colValue)
					gridList.setColValue("gridList", i, "SHORTX", colValue );	
 		}else if(gridId == "gridList" && colName == "LBUILD"){	
			for(var i=0;i<gridList.getGridDataCount("gridList");i++)
				if(gridList.getColData("gridList", i, "LBUILD") != colValue)
					gridList.setColValue("gridList", i, "LBUILD", colValue );	
 		}		
	}
 	
 	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		//console.log("searchCode : "+searchCode+"\ngridType : "+gridType);
		if(searchCode == "SHSTORY"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHBUILD"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHZONMA"){
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
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_LSTORY">층</th>
						<td>
							<input type="text" name="LSTORY" UIInput="R,SHSTORY" />
						</td>
					</tr>
					<tr>
						<th CL="STD_LBUILD">동</th>
						<td>
							<input type="text" name="LBUILD" UIInput="R,SHBUILD" />
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
											<col width="100" />
											<col width="100" />
											<col width="100" />		
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_LSTORY'>층</th>
												<th CL='STD_LSTOTY'>구역타입</th>
												<th CL='STD_SHORTX'>설명</th>
												<th CL='STD_LBUILD'>동</th>
												<th CL='STD_ZONEKY'>구역</th>												
												<th CL='STD_ZONENM'>구역설명</th>								
												<th CL='STD_AREAKY'>창고</th>
												<th CL='STD_AREANM'>창고설명</th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY"></td>
												<td GCol="input,LSTORY,SHSTORY" GF="S 10" validate="required" ></td>
												<td GCol="select,LSTOTY" validate="required">
													<select CommonCombo="LSTOTY">
													</select>
												</td>																								
												<td GCol="input,SHORTX" GF="S 180"></td> 
												<td GCol="input,LBUILD,SHBUILD" GF="S 10" validate="required" ></td>
												<td GCol="input,ZONEKY,SHZONMA" GF="S 10" validate="required" ></td>
												<td GCol="text,ZONENM"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,AREANM"></td>
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
											<col width="4%"/>
											<col width="15%"/>
											<col width="4%"/>
										</colgroup>

										<tbody>
										<tr>
											<th CL='STD_WAREKY'>거점</th>
											<td><input type="text" name="WAREKY" readonly="readonly" /></td>
										</tr>
										<tr>
											<th CL='STD_LSTORY'>층</th>
											<td><input type="text" name="LSTORY" /></td>
											<th CL='STD_SHORTX'>설명</th>
											<td ><input type="text" name="SHORTX" /></td>
										</tr>
										<tr>
											<th CL='STD_LSTOTY'>층타입</th>
											<td GCol="select,LSTOTY">
													<select CommonCombo="LSTOTY" name="LSTOTY"  style="width: 150px" ></select>   <!--  -->
											</td>
										</tr>										

										<tr>
											<th CL='STD_LBUILD'>동</th>
											<td ><input type="text" name="LBUILD" /></td>
										</tr>
										<tr>
											<th CL='STD_ZONEKY'>구역</th>
											<td><input type="text" name="ZONEKY" /></td>
											<th CL='STD_ZONENM'>구역명</th>
											<td><input type="text" name="ZONENM" readonly="readonly" /></td>
										</tr>										
										<tr>
											<th CL='STD_AREAKY'>창고</th>
											<td ><input type="text" name="AREAKY" readonly="readonly" /></td>
											<th CL='STD_AREANM'>창고명</th>
											<td><input type="text" name="AREANM" readonly="readonly" /></td>
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