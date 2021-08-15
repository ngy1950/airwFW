<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	var g_labelSeq = 0;

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "WAREKY,LOCAKY",
			module : "WmsAdmin",
			command : "LOCMA",
			autoCopyRowType : false
	    });
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName =="Print"){
			print("1");
		}else if(btnName =="Print2"){
			print("2");
		}else if(btnName =="Print3"){
			print("3");
		}
	}
	
	//그리드 조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
 		gridList.setReadOnly("gridList",true, ['INDUPA','INDUPK','INDCPC','MIXSKU','MIXLOT']);
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
	}

	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum, colName){
	}

	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
	}

	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	}
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
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
	
 	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
	}
 	
 
 	function print(flg){
 		var head = gridList.getSelectData("gridList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		if(flg == "1"){
			param.put("EZFILE" , "/ezgen/hwmsEzgen/Forms/location_label_org.ezg");
		}else{
			param.put("EZFILE" , "/ezgen/hwmsEzgen/Forms/location_label.ezg");
		}
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/labal/json/saveLB02Print.data",
			param : param
		});
		
		if ( json && json.data ){
			if( json.data["PRTSEQ"] != "E" && json.data["EZFILE"] != "E" ){
				var url = $.trim(json.data["EZFILE"]);
				var where = "AND PL.PRTSEQ =" + json.data["PRTSEQ"];
				//var langKy = "KR";
				var width =  300;
				var heigth = 200;
				var langKy = "KR";
				var map = new DataMap();
				map.put("FLAG",flg);
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
			}else {
				commonUtil.msgBox("VALID_M0206",param.get("SKUKEY"));
				return ;
			}
		}else{
			commonUtil.msgBox("IN_M9036");
			return ;
		}
	}
 	
 	//이지젠 라벨 출력
 	function print_bak(){
		var head = gridList.getSelectData("gridList");
		var param = "";
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		//beforePrintData();
		var url = "";
		var where1 = " AND(";
		//var where2 = " AND(";
		for(var i=0; i<head.length; i++){
			var row = head[i];
			var locaky = row.get("LOCAKY");
			where1 += "LM.LOCAKY='"+locaky+"'";
			//where2 +="LBLSEQ ='" + g_labelSeq + "'";
			if(i==head.length-1) break;
			where1 += " OR ";	
			//where2 += " OR ";	 
		}
		where1 += ")"; 
		//where2 += ")"; 
		//var where = where1 + where2;
		url = "/ezgen/hwmsEzgen/Forms/location_label.ezg";
		var map = new DataMap();
		map.put("i_wareky",head[0].get("WAREKY"));
		
		WriteEZgenElement(url, where1, "", "<%=langky%>", map,280,170);
		
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Print PRINT BTN_LABEL"></button>
		<button CB="Print2 PRINT BTN_LABEL2"></button>
		<button CB="Print3 PRINT BTN_LABEL3"></button>
	</div>
	<div class="util3">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer"></button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
			<table class="table type1">
				<colgroup>
					<col width="7%" /><col />
					<!-- <col width="7%" />
					<col width="7%" />
					<col /> -->
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY"></th>
						<td>
							<input type="text" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY"></th>
						<td>
							<input type="text" name="AREAKY" UIInput="R,SHAREMA" UIFormat="U"  />
						</td>
					</tr>
					<tr>
						<th CL="STD_ZONEKY"></th>
						<td>
							<input type="text" name="ZONEKY" UIInput="R,SHZONMA" UIFormat="U"  />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_TKZONE"></th>
						<td GCol="select,TKZONE">
							<select CommonCombo="TKZONE" name="TKZONE">
							 <option value="">SELECT</option>
							</select>
						</td>
					</tr> -->
					<tr>
						<th CL="STD_LOCAKY"></th>
						<td>
							<input type="text" name="LOCAKY" UIInput="R,SHLOCMA" UIFormat="U"  />
						</td>
					</tr>
					<tr>
						<th CL="STD_LOCATY"></th>
						<td GCol="select,LOCATY">
							<select CommonCombo="LOCATY" name="LOCATY" style="width: 170px">
								<option value="">SELECT</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_STATUS"></th>
						<td GCol="select,STATUS">
							<select CommonCombo="STATUS" name="STATUS" style="width: 170px">
								<option value="">SELECT</option>
							</select>
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_INDUPA"></th>
						<td>
							<input type="checkbox"  name="INDUPA" />
						</td>
						<th CL="STD_INDUPK"></th>
						<td>
							<input type="checkbox" name="INDUPK"/>
						</td>
					</tr> -->
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
						<li><a href="#tabs1-1"><span CL='STD_ITEMLIST'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"   GCol="rownum">1</td>
												<td GH="40"              GCol="rowCheck"></td>
										   <!-- <td GH="80 STD_PRINTQTY" GCol="input,PRINTQTY"></td> -->
												<td GH="80 STD_WAREKY"   GCol="text,WAREKY"></td>
												<td GH="80 STD_AREAKY"   GCol="text,AREAKY"></td>
												<td GH="80 STD_ZONEKY"   GCol="text,ZONEKY"></td> 
												<td GH="80 STD_LOCAKY"   GCol="text,LOCAKY" ></td>
												<td GH="80 STD_LOCAKYNM" GCol="text,SHORTX" ></td>
										   <!-- <td GH="00 STD_TKZONE"   GCol="text,TKZONE"></td>
												<td GH="80 STD_LOCATY"   GCol="text,LOCATY"></td>
												<td GH="80 STD_STATUS"   GCol="text,STATUS"></td>
												<td GH="80 STD_INDUPA"   GCol="check,INDUPA"></td>
												<td GH="80 STD_INDUPK"   GCol="check,INDUPK"></td>
												<td GH="80 STD_INDCPC"   GCol="check,INDCPC"></td>
												<td GH="80 STD_LENGTH"   GCol="text,MAXCPC" ></td>
												<td GH="80 STD_WIDTHW"   GCol="text,LENGTH" ></td>
												<td GH="80 STD_HEIGHT"   GCol="text,WIDTHW"></td>
												<td GH="80 STD_MIXSKU"   GCol="text,HEIGHT" ></td>
												<td GH="80 STD_MIXLOT"   GCol="check,MIXSKU"></td>
												<td GH="80 STD_CREDAT"   GCol="check,MIXLOT"></td>
												<td GH="80 STD_CRETIM"   GCol="text,CREDAT"></td>
												<td GH="80 STD_MIXLOT"   GCol="text,CRETIM"></td>
												<td GH="80 STD_CREUSR"   GCol="text,CREUSR"></td>
												<td GH="80 STD_MAXQTY"   GCol="text,MAXQTY"></td> -->
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