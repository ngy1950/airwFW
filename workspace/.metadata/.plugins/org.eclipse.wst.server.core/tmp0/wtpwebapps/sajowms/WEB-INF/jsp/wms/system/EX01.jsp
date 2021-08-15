<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
		
		netUtil.setForm("excelUp");
		
		setTopSize(200);
		
		gridList.setGrid({
	    	id : "gridTotalList",
	    	name : "gridTotalList",
			editable : true,
			module : "System",
			command : "EX01"
	    });
		
		
	});
	
	
	function inputNumberOnly(val) {
	       re = /[^0-9]/gi;
	       return re.test(val);
	}
	
	function excelLoad(){
		netUtil.sendForm("excelUp");
	}
	
	function netUtilEventSetFormSuccess(formId, data){
		//commonUtil.debugMsg("netUtilEventSetFormSuccess : ", arguments);
		var list = commonUtil.getAjaxUploadFileList(data);
		if(list.length > 0){
			var param = new DataMap();
			param.put("UUID", list[0]);
			
			netUtil.send({
				bindId : "gridTotalList",
				sendType : "excelLoad",
				url : "/common/load/excel/json/grid.data",
		    	param : param
			});
		}
	}
	
/* 	function gridListEventDataBindEnd(gridId, dataLength){	
		if( gridId == "gridTotalList"){
			 for( i=0; i<dataLength; i++){
				var data = gridList.getColData("gridTotalList", i, "QTYRCV");
				if ( inputNumberOnly(data) ){
				 	gridList.setColValue("gridTotalList", i, "QTYRCV", "100"); 
				 jQuery("#chkRcv").css("background-color","#f9f2dc !important"); 
				}
			} 
		}
	}
*/
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else  if(btnName == "Save"){
			/* saveData(); */
		}
	}
	
	function searchList(){
		var list = 	gridList.getGridData("gridTotalList");
		var count = gridList.getGridDataCount("gridTotalList");
		
		for( var i=0; i<count; i++){
			
			gridList.setColValue("gridTotalList", i, "CHK", colValue)
		}
		
	}
	
	function saveData(){
		var list = gridList.getGridData("gridTotalList");
    	
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		
		
		var param = new DataMap();
		param.put("list", list);
		var json = netUtil.sendData({
			url : "/wms/system/json/saveEX01Upload.data",
			param : param
		});
		
		if(json && json.data ){
			uiList.setActive("Save", false);
			//저장 성공
			commonUtil.msgBox("VALID_M0001");
				
		} else {
			//저장 실패
			commonUtil.msgBox("VALID_M0002");
		}
	}
	
	
	/* 
	var dblIdx = -1;
	var sFlag = true; */
	
	
	
	<%-- function searchList(){
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var day = date.getDay();
		var hour = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();
		
		var changeFlie = "E_"+year+""+month+""+day+""+hour+""+minutes+""+seconds+".xlsx";
		$("#saveFile").val("D:/wms/file/excel/"+changeFlie);
		var frm = document.fileForm;
		frm.action = "/wms/system/json/fileUploadEX01.data";
		frm.submit();
		
		var filePath = $("#saveFile").val();
		
		if(filePath.length < 20){
			alert("No Excel File.");
			$("#saveFile").val("");
			return false;
		}
		
		commonUtil.msgBox("Excel upload后查询需要点时间.\n请稍等片刻.");
		
		var param = new DataMap();
		param.put("FILEPATH", filePath);
		netUtil.send({
			url : "/wms/system/json/excelUploadEX01.data",
			bindId : "gridTotalList",
			param : param
		}); 
	}
	
	function saveData(){
		
		var list = gridList.getGridData("gridTotalList");
	    	
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
			
		
		var param = new DataMap();
		param.put("list", list);
		param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			url : "/wms/system/json/saveEX01Upload.data",
			param : param
		});
		
		if(json && json.data){
			uiList.setActive("Save", false);
			//저장 성공
			commonUtil.msgBox("VALID_M0001");
				
		} else {
			//저장 실패
			commonUtil.msgBox("VALID_M0002");
		}
	}
	

	function fn_filedown(){
		var frm = document.fileForm;
		frm.action = "/wms/system/json/fileDownloadEX01.data";
		frm.submit();
	} --%>
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<!-- <button CB="Save SAVE BTN_SAVE"></button> -->
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
		<p class="util">
			<!-- <button CB="Search SEARCH BTN_DISPLAY"></button> -->
		</p>
		<div class="searchInBox" id="searchArea">
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
<%-- 							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" /> --%>
							<%-- <input type="text" name="WAREKY" value="<%=wareky%>" readonly/> --%>
						</td>
					</tr>
					<!-- <tr>
						<th>FILE DOWN</th>
						<td>
							<a href="/file/template/excelupload_sample.xlsx">Template File Down</a>
							<a href="javascript:fn_filedown();">Template File Down</a>
						</td>
					</tr> -->
					<tr>
						<th>FILE UPLOAD</th>
						<td>
						   <form action="/common/grid/excel/fileUp/excel.data" enctype="multipart/form-data" method="post" id="excelUp">
					            <input type="file" name="ExcelFile" validate="required"/>
					            <input type="submit" value="upload"/>
					       </form>
							<!-- <form name="fileForm" id="fileForm" method="post" action="/wms/system/json/fileUploadEX01.data" enctype="multipart/form-data">
								<input type="file" name="excelFile" id="excelFile">
								<input type="hidden" name="saveFile" id="saveFile" value="">
							</form> -->
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
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_LIST'>일반</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="50" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_KEY'></th>
												<th CL='STD_TEXT'></th>
												<th CL='STD_CHK'></th> 
												<th CL='STD_Query'></th> 
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="50" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridTotalList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="input,KEY"></td>
												<td GCol="input,TEXT"></td>
												<td GCol="input,CHK"></td>
												<td GCol="input,Query"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button>								 -->
<!-- 									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excel"></button>
									<button type="button" GBtn="total"></button> -->
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