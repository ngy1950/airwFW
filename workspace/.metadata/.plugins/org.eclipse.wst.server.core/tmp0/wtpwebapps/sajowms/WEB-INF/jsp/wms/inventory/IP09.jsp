<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var yesterday;
	var todayDate;
	var todayTime;
	$(document).ready(function(){
		setTopSize(100);
		
		//오늘날짜
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		var hours = today.getHours(); // 시
		var minutes = today.getMinutes(); // 분
		var seconds = today.getSeconds(); // 초
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		if( hours < 10 ) {hours = '0' + hours;}
		if( minutes < 10 ) {minutes = '0' + minutes;}
		if( seconds < 10 ) {seconds = '0' + seconds;}
		
		todayDate = String(yyyy) + String(mm) + String(dd); //오늘
		
		
		//어제날짜
		var yday = new Date();
		yday.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000));
		var Ydd = yday.getDate();
		var Ymm = yday.getMonth() + 1;
		var Yyyyy = yday.getFullYear();
		
		if( Ydd < 10 ) {Ydd = '0' + Ydd;} 
		if( Ymm < 10 ) {Ymm = '0' + Ymm;}
		
		yesterday = String(Yyyyy) + String(Ymm) + String(Ydd); //어제
		
		//수불반영일자는 당일 06:00부터 익일 06:00까지
		todayTime = String(hours) + String(minutes) + String(seconds);
		if( todayTime > "060000" ){
			//오전 6시 이후에는 오늘일자
			$("#SHOWDAT").val(String(yyyy) +"."+ String(mm) +"."+ String(dd));
			$("#DOCDAT").val(todayDate);
		}else{
			//오전 6시 이전에는 전일자
			$("#SHOWDAT").val(String(Yyyyy) +"."+ String(Ymm) +"."+String(Ydd));
			$("#DOCDAT").val(yesterday);
		}
		
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Save" ){
			saveData();
		}
	}
	
	//저장
	function saveData(){
		if( !confirm("재고조사 내역에 대해 전송 및 재고 수불 반영하시겠습니까?") ){
			return; // confirm : 저장하시겠습니까? 
		}
		
		var param = dataBind.paramData("searchArea");
		param.put("USERID", "<%=userid%>");
		
		var json = netUtil.sendData({
			url : "/wms/inventory/json/saveIP09.data",
			param : param
		});
		
		if( json && json.data ){
			commonUtil.msgBox("INV_M0036"); //재고수불반영이 완료되었습니다.
			searchList();
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Save SAVE BTN_IPSEND"></button>
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
									<col width="200" />
									<col width="80" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										<th CL="STD_IPDOCDT">수불반영일자</th>
										<td>
											<input type="text" name="SHOWDAT" id="SHOWDAT" disabled />
											<input type="hidden" name="DOCDAT" id="DOCDAT" disabled />
										</td>
									</tr>
								</tbody>
							</table>
							<p style="font-size: 16px; font-weight: bold; margin-top: 10px;">※ 수불반영일자는 당일 06:00부터 익일 06:00까지입니다.</p>
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