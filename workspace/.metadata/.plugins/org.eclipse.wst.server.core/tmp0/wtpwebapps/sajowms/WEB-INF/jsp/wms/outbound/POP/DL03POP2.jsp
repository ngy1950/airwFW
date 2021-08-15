<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>미등록상품</title>
<%@ include file="/common/include/popHead.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/css/innerGridContent.css">
<script type="text/javascript" src="/common/js/head-h.js"></script>
<script type="text/javascript">
var gbn = "";
	
	window.resizeTo('1600','900');
	midAreaHeightSet = "100px";
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL03_02POP1",
			autoCopyRowType : false ,
			emptyMsgType : false
		});
		
		gridList.setGrid({
			id : "gridHeadList2",
			editable : true,
			module : "WmsOutbound",
			command : "DL03_02POP2",
			autoCopyRowType : false
		});
		
		var data = page.getLinkPopData();
		
		
		var val = data.get("RQSHPD");
		gbn = data.get("PROGID");
		searchShpdgr(val);
		
		dataBind.dataNameBind(data, "searchArea");
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		gridList.setReadOnly("gridHeadList", true, ["RCVERR"]);
		gridList.setReadOnly("gridHeadList2", true, ["RCVERR"]);
		searchList();
		
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml)
	}
    
    function day(day){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		return String(yyyy) + String(mm) + String(dd);
	}

	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
	   if(btnName == "Check"){
			closeData();
		}else if(btnName == "Search"){
			var data = dataBind.paramData("searchArea");
			searchList(data);
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	//헤더 조회
	function searchList(){
		var param = dataBind.paramData("searchArea");
			param.put("GBN", gbn);
		 gridList.gridList({
			id : "gridHeadList",
			param : param
		}); 
		
	}
	
	function saveData(){
		if( gridList.validationCheck("gridHeadList2", "modify") ){
			var list = gridList.getModifyList("gridHeadList2", "A");
			
			if( list.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			var param = new DataMap();
			param.put("list", list);
			
			var json = netUtil.sendData({
				url : "/wms/outbound/json/saveDL03SKUMA.data",
				param : param
			});
			
			if( json && json.data ){
				commonUtil.msgBox("MASTER_M0815", json.data);
				searchList();
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList2"){
			if(colName == "WIDTHW" || colName == "LENGTH" || colName == "HEIGHT"){
				var wid = gridList.getColData(gridId, rowNum, "WIDTHW");
				var len = gridList.getColData(gridId, rowNum, "LENGTH");
				var hei = gridList.getColData(gridId, rowNum, "HEIGHT");
				
				var cbm = parseFloat(wid)*parseFloat(len)*parseFloat(hei);
					cbm = cbm.toFixed(1);
				gridList.setColValue(gridId, rowNum, "CUBICM" , cbm);
			}
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)   
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList"){
			var param = dataBind.paramData("searchArea");
			param.put("GBN", gbn);
			
			 gridList.gridList({
				id : "gridHeadList2",
				param : param
			});
		}
	}
	
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){

	}
	
	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		
		if(gridId == "gridHeadList"){
			param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridHeadList");
		}
		return param;
		
	}
	
	function closeData(){
		this.close();
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "SC.SKUCLS" || name == "SKUCLS"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");	
			}else if(name == "ABCANV"){
				param.put("CODE", "ABCANV");
			}else if(name == "SO.SHPDGR"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}else if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");
			}else if(name == "RCVERR"){
				param.put("CODE", "RCVERR");
			}
			
			
			return param;
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Check CHECK BTN_CLOSE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="fildSect" id="searchArea">
			
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col width="250" />
									<col width="50" />
									   <col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false"  UIFormat="C N" disabled="disabled" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
										
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			 </div>

			<div class="bottomSect2 bottom3" style="top:100px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span >피킹로케이션 미등록</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
<!-- 												<td GH="40"					GCol="rownum">1</td> -->
												<td GH="115 STD_SKUKEY"		GCol="text,SKUKEY" ></td>
												<td GH="200 STD_DESC01"		GCol="text,DESC01" ></td>
												<td GH="100 STD_SKUCLSNM"	GCol="text,SKUCLSNM" ></td>
												<td GH="100 STD_LOTA06NM"	GCol="text,LOTA06NM" ></td>
												<td GH="100 STD_LOCAKY"		GCol="text,LOCAKY" ></td>
												<td GH="170 STD_RCVERR2"		GCol="select,RCVERR" >
													<select Combo="Common,COMCOMBO" id="RCVERR" name="RCVERR"  ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
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

			<div class="bottomSect2 bottom4" style="top: 100px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span >체적/중량 미등록</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList2">
											<tr CGRow="true">
<!-- 												<td GH="40"					GCol="rownum">1</td> -->
												<td GH="115 STD_SKUKEY"		GCol="text,SKUKEY" ></td>
												<td GH="200 STD_DESC01"		GCol="text,DESC01" ></td>
												<td GH="75 STD_WIDTHW"		GCol="input,WIDTHW" GF="N 8,1" validate="required gt(-1),MASTER_M4002" ></td>
												<td GH="75 STD_LENGTH"		GCol="input,LENGTH" GF="N 8,1" validate="required gt(-1),MASTER_M4002" ></td>
												<td GH="75 STD_HEIGHT"		GCol="input,HEIGHT" GF="N 8,1" validate="required gt(-1),MASTER_M4002" ></td>
												
												<td GH="75 STD_BOXWID"		GCol="text,BOXWID" GF="N 8,1"  ></td>
												<td GH="75 STD_BOXLEN"		GCol="text,BOXLEN" GF="N 8,1"  ></td>
												<td GH="75 STD_BOXHGT"		GCol="text,BOXHGT" GF="N 8,1"  ></td>
												
												<td GH="80 STD_CUBICM"		GCol="text,CUBICM" GF="N" ></td>
												<td GH="70 STD_FIL_BOXCBM"	GCol="text,FIL_BOXCBM" GF="N" ></td>
												<td GH="170 STD_RCVERR2"		GCol="select,RCVERR" >
													<select Combo="Common,COMCOMBO" id="RCVERR" name="RCVERR"  ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
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
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>