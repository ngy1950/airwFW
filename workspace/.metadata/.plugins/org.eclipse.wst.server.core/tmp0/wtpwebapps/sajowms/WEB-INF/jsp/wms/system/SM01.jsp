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
		setTopSize(130);
		gridList.setGrid({
			id : "gridList",
			module : "IF",
			command : "SEND_SMS"
		});
	});
	
	//버튼
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	//조회
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = new DataMap();
			netUtil.send({
				url : "/wms/system/json/searchSM01.data",
				sendType : "list",
				param : param,
				bindId : "gridList",
				sendType : "list",
				bindType : "grid"
			});
		}
	}
	
	//저장
	function saveData(){
		var param = dataBind.paramData("searchArea");
		netUtil.send({
			url : "/wms/system/json/saveSM01Send.data",
			sendType : "map",
			param : param,
			successFunction : "succsessSendCallBack"
		});	
	}
	
	function succsessSendCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("전송 요청 완료.");
				
				var data = new DataMap();
				data.get("MESSAGE","");
				data.get("MOBILENO","");
				
				dataBind.dataBind(data, "searchArea");
				dataBind.dataNameBind(data, "searchArea");
				
				searchList();
			}
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>메세지</th>
										<td>
											<input type="text" name="MESSAGE" style="width: 500px;">
										</td>
									</tr>
									<tr>
										<th>수신번호</th>
										<td>
											<input type="text" name="MOBILENO">
										</td>
									</tr>
									<tr>
										<th>발신번호(고정)</th>
										<td>
											<input type="text" name="CALLBACKNO" readonly="readonly" value="1577-1588">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER" GCol="rownum">1</td>
												<td GH="400 STD_backup_message" GCol="text,backup_message"></td>
												<td GH="100 STD_contents_type" GCol="text,contents_type,center"></td>
												<td GH="100 STD_job_type" GCol="text,job_type,center"></td>
												<td GH="150 STD_receive_mobile_no" GCol="text,receive_mobile_no"></td>
												<td GH="150 STD_callback_no" GCol="text,callback_no"></td>
												<td GH="180 STD_send_reserve_date" GCol="text,send_reserve_date"></td>
												<td GH="100 STD_send_flag" GCol="text,send_flag"></td>
												<td GH="180 STD_send_date" GCol="text,send_date"></td>
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
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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