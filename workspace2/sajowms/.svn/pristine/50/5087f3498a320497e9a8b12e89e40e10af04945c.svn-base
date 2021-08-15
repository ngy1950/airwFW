<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>운송장 등록</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style>
#dlvReport {
	display:none;
}
.ListStyle {
	font-size: 3em;
	text-align: left;
	margin-top: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: #808080;
}
.btnGoBack{
	background: url(/common/theme/webdek/images/delete.png) no-repeat;
    background-size: 42px auto;
    width:7em;
    height:15em;
    margin-top: 8px;
}
.modal {
  display: none;
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  background: rgba(0, 0, 0, 0.8);
  z-index: 2;
}
.modal_content {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  width: 90%;
  height: 50%;
 
  background-color: white;
  overflow: auto;
}
.th {
	color: #222;
	background-color: #f7f8f9;
	border-top: 1px solid #dadfe2;
	border-right: 1px solid #dadfe2;
	border-bottom: 1px solid #bdc2c9;
	height: 3em;
	font-weight: bold;
	font-size: 3em;
	text-align: cent;	
}
.td {
	text-align: center;
	color: gray;
	height: 3em;
	font-size: 3em;
}
</style>
<script type="text/javascript">
	var fix_pup = false, fix_dvp = false;
	$(document).ready(function(){
		
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1901_ADDROW",
			gridMobileType : true,
			selectRowDeleteType : true
	    });
		
		jQuery('body').find("input[type='button'][data-custom-btn]").click(function () {
			customButtonClick($(this));
		});
		
		/* 뒤로가기 */
		$(".btnGoBack").on("click", function(){
			$("#dlvReport").fadeOut();
			$("#dlvList").fadeIn();
		});
		
		/* 리로드 시 디폴드 값 */
		//$("#CSTM_NM").val("");
// 		$("#ho").prop("checked", true);

		$("#in").prop("checked", true);
		$("#DELIV_REQ_DT").val(uiList.dateFormat(uiList.getDateObj(),"yyyy.mm.dd")); // 배송요청일자	
		
		/* 본사 0, 입력 1 */
		$("input[type='radio']").change(function(){
			var check =  $('input:radio[name="radio"]:checked').val();
			if(check == "0"){
				$("#DVP_NM").attr("readonly", "readonly");
				$("#deliverySearchBtn").prop("disabled", true);
				$("#DVP_NM").val("");
			}else{
				$("#DVP_NM").removeAttr("readonly", "readonly");
				$("#deliverySearchBtn").removeAttr("disabled", true);
			}
		});
		
		/* 페이지 리로드시 강제로 change 이벤트 발생 */
		$("input[name='radio']").trigger("change");
		
		/* 배송요청일자에 따른 배송구분 value change */
		$("#DELIV_REQ_DT").change(function(){
			var nowDate = uiList.dateFormat(uiList.getDateObj(),"yyyymmdd"); 
			var param = inputList.setRangeParam("areaData");
			
			if(param.get("DELIV_REQ_DT") == nowDate){ 
				$("#TRANS_CNDT_CD").val("0002");
			}else if(param.get("DELIV_REQ_DT") > nowDate){ 
				$("#TRANS_CNDT_CD").val("0001");
			}
		});
		
		$("#DELIV_REQ_DT").trigger("change");
		
		gridList.setReadOnly("gridList", true, ["TRMT_ITM_CD", "GOAL_TEMPER_CD"]);
		
		
		$("#modalTable").delegate('.td',"click", function(){
			var tr = $(this); // tr.text() = row 전체
			/* var tdArr = new Array(); */
			var td = tr.children();
			
			/* td.each(function(i){
				tdArr.push(td.eq(i).text());
			});
			 */
			
			console.log(td.eq(3).text());
			$("#TRANS_CNDT_CD").val(td.eq(3).text());
			$(".modal").fadeOut();
			
		});
		
		$("#CSTM_NM").keydown(function(e){
			if(e.keyCode == "13"){
				customButtonClick($("#customerSearchBtn"));
			}
		});
	});
	
	/* 공통 버튼 */
	function commonBtnClick(btnName){
		if(btnName == "New"){
			addNewdata();
		}else if(btnName == "Del"){
			deletedata();
		}
	}
	
	/* 커스텀 버튼 */
	function customButtonClick(obj) {
		var btnId = $(obj).attr("id");
		
		if(btnId == "customerSearchBtn"){ 
			if($("#CSTM_NM").val() == ""){ 
				commonUtil.msgBox("BL_VALID_INPUT", uiList.getLabel("STD_CSTM_NM")); // 조회하실 {0}을(를) 입력해주세요.
				$("#CSTM_NM").focus();
				return;			
			}
			customerSearchList(); 
		}else if(btnId == "pickupSearchBtn"){ 
			if($("#PUP_NM").val() == ""){
				commonUtil.msgBox("BL_VALID_INPUT", uiList.getLabel("STD_PUP")); 
				return;
			}
			clntSearchList("p");
		}else if(btnId == "deliverySearchBtn"){ 
			if($("#DVP_NM").val() == ""){
				commonUtil.msgBox("BL_VALID_INPUT", uiList.getLabel("STD_DVP")); 
				return;
			}
			clntSearchList("d");
		}
	}
	
	/* 고객명 조회 */
	function customerSearchList(){
		var param = new DataMap();
		param.put("CSTM_NM", $("#CSTM_NM").val());
		
		var customerResultList = netUtil.sendData({
			module : "MB1000",
			command : "CSTM_NM",
			sendType : "list",
			param : param
		});
		
		if(customerResultList.data.length == 0){
			commonUtil.msgBox("BL_NO_DATA", uiList.getLabel("STD_CSTM_NM")); // 존재하지 않는 {0}입니다.
			$("#CSTM_NM").val("");
			$("#CSTM_NM").focus();
			return;	
		}else{
			var data;
			var str = "";
			for(var i = 0; i < customerResultList.data.length; i++){
				data = customerResultList.data[i];
				str += "<div style='border:1px solid #acb3b9'>"
				str += "<ul class='ListStyle'>"
				str += "<li>계약번호 : "+data.CTRT_CD+"</li>" // 계약코드
				str += "<li> 계약명 : "+data.CTRT_NM+"</li>" // 계약명
				str += "<li> 고객명 : "+data.CSTM_NM+"</li>" // 고객명
				str += "<li> 운송조건 : "+data.OD_GRP5_NM+"</li>" // 고객명
				str += "<li> 상차지 : "+data.ON_RGN_NM+" | 상차권역 : "+data.ON_DSTR_NM+"</li>"
				str += "<li> 하차지 : "+data.ARV_RGN_NM+" | 하차권역 : "+data.ARV_DSTR_NM+"</li>"
				str += "<li> 서비스단위 : "+data.UNIT_NM+" | TYPE : "+data.UNIT_TYP_NM+"</li>"
				str += "</ul>"
				str += "<div class='foot_btn'>"
				str += "<button style='width: 100%' onclick='customerVal("+JSON.stringify([data.CSTM_NM, data.CTRT_CD, data.CSTM_CD,data.CTRT_DTL_SN,data.TRF_NO,data.TRF_SN,data.ON_RGN_CD,data.ON_DSTR_CD,data.ARV_RGN_CD,data.ARV_DSTR_CD,data.ON_RGN_NM,data.ARV_RGN_NM])+")'>선택</button>"	
				str += "</div>"
				str += "</div>"		
			}
			$("#dataList").html(str);
			$("#dlvReport").fadeIn();
			$("#dlvList").fadeOut();
		}
	}
	
	function customerVal(data){
		fix_pup = false;
		fix_dvp = false;
		$("#eono").val("");
		$('input[name="radio"]').removeAttr("disabled");
		$("#dlvReport").fadeOut();
		$("#dlvList").fadeIn();
		$("#CSTM_NM").val(data[0]);
		$("#CTRT_CD").val(data[1]);
		$("#CSTM_CD").val(data[2]);
		$("#CTRT_DTL_SN").val(data[3]);
		$("#TRF_NO").val(data[4]);
		$("#TRF_SN").val(data[5]);
		$("#ON_RGN_CD").val(data[6]);
		$("#ON_DSTR_CD").val(data[7]);
		$("#ARV_RGN_CD").val(data[8]);
		$("#ARV_DSTR_CD").val(data[9]);
		
		if(data[6] != ""){
			$("#PUP_NM").val(data[10])
			$("#PUP_CD").val(data[6]);
			fix_pup = true;
		}else{
			$("#PUP_NM").val("");
			$("#PUP_CD").val("");
		}
		
		if(data[8] != ""){
			$("#DVP_NM").val(data[11])
			$("#DVP_CD").val(data[8]);
			fix_dvp = true;
			$('input[name="radio"]').attr("disabled",true);
		}else{
			$("#DVP_NM").val("")
			$("#DVP_CD").val("");
			$('input[name="radio"]').removeAttr("disabled");
		}
	}
	
	/* 픽업지, 배송지 조회 */
	function clntSearchList(selectInput){
		var param = new DataMap();
		param.put("CTRT_NO", $("#CTRT_CD").val());
		param.put("CTRT_DTL_SN", $("#CTRT_DTL_SN").val());
		
		if(selectInput == "p"){
			if(fix_pup){
				commonUtil.msgBox("선택하신 서비스의 상차지 정보가 존재합니다.\n픽업지 정보를 변경하실 수 없습니다.");
				return;
			}
			param.put("CLNT_NM", $("#PUP_NM").val());
			param.put("DSTR_CD", $("#ON_DSTR_CD").val());
		}else{
			if(fix_dvp){
				commonUtil.msgBox("선택하신 서비스의 하차지 정보가 존재합니다.\n배송지 정보를 변경하실 수 없습니다.");
				return;
			}
			param.put("CLNT_NM", $("#DVP_NM").val());
			param.put("DSTR_CD", $("#ARV_DSTR_CD").val());
		}
		
		var clntResultList = netUtil.sendData({
			module : "MB1000",
			command : "CLNT_NM",
			sendType : "list",
			param : param
		});
		
		if(clntResultList.data.length == 0){
			if(selectInput == "p"){
				commonUtil.msgBox("BL_NO_DATA", uiList.getLabel("STD_PUP")); // 존재하지 않는 {0}입니다.
				return;
			}else{
				commonUtil.msgBox("BL_NO_DATA", uiList.getLabel("STD_DVP"));
				return;
			}
		}else{
			var data;
			var str = "";
			for(var i = 0; i < clntResultList.data.length; i++){
				data = clntResultList.data[i];
				str += "<div style='border:1px solid #acb3b9'>"
				str += "<ul class='ListStyle'>"
				str += "<li>"+data.CLNT_NM+"</li>"
				str += "</ul>"
				str += "<div class='foot_btn'>"
				str += "<button style='width: 100%' onclick='clntVal("+JSON.stringify([selectInput, data.CLNT_NM, data.CLNT_CD])+")'>선택</button>"	
				str += "</div>"
				str += "</div>"
			}
			$("#dataList").html(str);
			$("#dlvReport").fadeIn();
			$("#dlvList").fadeOut();
		}
	}
	
	function clntVal(data){
		$("#dlvReport").fadeOut();
		$("#dlvList").fadeIn();
		
		if(data[0] == "p"){
			$("#PUP_NM").val(data[1]);
			$("#PUP_CD").val(data[2]);
		}else{
			$("#DVP_NM").val(data[1]);
			$("#DVP_CD").val(data[2]);
		}
	}
	
	/* 운송대상 그리드 행 추가 버튼 */
	function addNewdata(){ 
		var param = inputList.setRangeParam("areaData");
		
		if(param.get("QY") == undefined){ // 수량 입력 X
			commonUtil.msgBox("VALID_required", uiList.getLabel("STD_QY"));
			$("#QY").focus();
			return;
		}else if(Number(param.get("QY")) <= 0){ // 수량 입력 0 이하
			commonUtil.msgBox("BL_ValidateQty");
			$("#QY").val("");
			$("#QY").focus();
			return;
		}else{
			if(gridList.getGridDataCount("gridList") == 0){ // 그리드 전체 행의 갯수가 0 이면 DUAL 조회
				var param = new DataMap();
				param.put("TRMT_ITM_CD", $("#TRMT_ITM_CD").val());
				param.put("GOAL_TEMPER_CD", $("#GOAL_TEMPER_CD").val());
				param.put("QY", $("#QY").val());
				param.put("INNCG_QY", $("#INNCG_QY").val());
				
				gridList.gridList({
					id : "gridList",
					param : param
				});			
			}else{
				var newData = new DataMap();
				newData.put("TRMT_ITM_CD", $("#TRMT_ITM_CD").val());
				newData.put("GOAL_TEMPER_CD", $("#GOAL_TEMPER_CD").val());
				newData.put("QY", $("#QY").val());
				newData.put("INNCG_QY", $("#INNCG_QY").val());
				gridList.addNewRow("gridList", newData);
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList"){
			gridList.setRowState(gridId, "C", dataCount-1);
		}
	}
	
	/* 주문생성 */
	function saveData(){
		$("#eono").val("");
		var list1 = inputList.setRangeParam("areaData");
		var list2 = gridList.getModifyList("gridList", "A");
		
		var param = new DataMap();
		param.put("list1", list1);
		param.put("list2", list2);
		netUtil.send({
			url : "/GCLC/Mobile/json/saveMB1901.data",
			param : param,
			successFunction : "saveDataCallBack"
		});
	}
	
	function saveDataCallBack(json, returnParam){
		if(json.data.msg){
			commonUtil.msgBox(json.data.msg);
			if(json.data.eono != ""){
				$("#eono").val(json.data.eono);
				print();
			}
			/*
			var result = json.data.msg.split(",");
			var param = new DataMap();
			param.put("CTRT_NO", result[1]);
			param.put("CTRT_DTL_SN", result[2]);
			param.put("SVC_CTG", result[3]);
			var json = netUtil.sendData({
				module : "MB1000",
				command : "TEST",
				sendType : "list",
				param : param
			});
			if(json.data.length != 0){
				var data;
				var str = "";
				for(var i = 0; i < json.data.length; i++){
					data = json.data[i];
					str += "<tr class='td'>"
					// str += "<td style='display:none'>"+data.TRF_SN+"</td>" 
					str += "<td>"+data.OD_GRP1_NM+"</td>"
					str += "<td>"+data.OD_GRP2_NM+"</td>"
					str += "<td>"+data.OD_GRP4_NM+"</td>"
					str += "<td style='display:none;'>"+data.OD_GRP5_CD+"</td>"
					str += "<td>"+data.OD_GRP5_NM+"</td>"
					str += "<td>"+data.OD_GRP6_NM+"</td>"
					str += "<div class='foot_btn'>"
					str += "<button style='width: 100%' onclick='clntVal()'>선택</button>"	
					str += "</div>"
					str += "</tr>"
					
				}
				$("#table").html(str);
				$(".modal").fadeIn();
			}
			*/
		} 
	}
	
	function print(){
		if($("#eono").val() == ""){
			return false;
		}
		var param = new DataMap();
		param.put("EONO",$("#eono").val());
		param.put("USERID",$("#USERID").val());
		var a = netUtil.sendData({
			module : "MB1000",
			command : "MB1901_WYBILL_PRINT",
			sendType : "list",
			param : param
		});
		
		if(a && a.data){
			 window.GCLABCELL_BRIDGE.printmkmbWaybill(JSON.stringify(a.data));
		}else{
			commonUtil.msgBox("운송장 출력 조회 중 오류가 발생했습니다.");
		}
	}
	
	function deletedata(){
		gridList.gridMap.get("gridList").deleteSelectRow();
	}
</script>
</head>
<body > 
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner" id="dlvList">
			<div class="content_layout tabs">
				 
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01" style="height: calc(100% - 130px);">
						<div class="table_inner_wrap" style="width: 100%; height:100%;">
							<div class="inner_search_wrap table_box" style="height: 1605px;">
								<table class="detail_table" id="areaData" style="height:100%;">
									<colgroup>
										<col width="30%" />
									</colgroup>
									<tbody>			
										<tr>
											<th CL="STD_CSTM_NM"></th><!-- 고객명 --> 
											<td>
												<input type="text" class="input" id="CSTM_NM" name="CSTM_NM" validate="required" />
												<input type="button" class="btn btn_search" id="customerSearchBtn" data-custom-btn style="position: static;" />
												<input type="hidden" id="CSTM_CD" name="CSTM_CD" />
												<input type="hidden" id="USERID" name="USERID" value="<%=userid%>" />
											</td>
										</tr>
										<tr>
											<th CL="STD_CTRT_NO"></th><!-- 계약코드 -->
											<td>
												<input type="text" class="input" id="CTRT_CD" name="CTRT_CD" validate="required" />
<!-- 												<select class="input" id="CTRT_CD" name="CTRT_CD" Combo="MB1000,CTRTCDCOMBO" ComboCodeView="false" > -->
<!-- 													<option value="" CL="STD_SEL"></option> -->
<!-- 												</select> -->
												<input type="hidden" id="CTRT_NM" name="CTRT_NM" /><!-- 계약명 -->
												<input type="hidden" id="CTRT_DTL_SN" name="CTRT_DTL_SN" /><!-- 계약상세순번 -->
												
												<input type="hidden" id="TRF_NO" name="TRF_NO" /><!-- 계약명 -->
												<input type="hidden" id="TRF_SN" name="TRF_SN" /><!-- 계약명 -->
												<input type="hidden" id="ON_RGN_CD" name="ON_RGN_CD" /><!-- 계약명 -->
												<input type="hidden" id="ON_DSTR_CD" name="ON_DSTR_CD" /><!-- 계약명 -->
												<input type="hidden" id="ARV_RGN_CD" name="ARV_RGN_CD" /><!-- 계약명 -->
												<input type="hidden" id="ARV_DSTR_CD" name="ARV_DSTR_CD" /><!-- 계약명 -->
											</td>
										</tr>
										<tr>
											<th CL="STD_PUP"></th><!-- 픽업지 -->
											<td>
												<input type="text" class="input" id="PUP_NM" name="PUP_NM" validate="required" />
												<input type="button" class="btn btn_search" id="pickupSearchBtn" data-custom-btn style="position: static;" />
												<input type="hidden" id="PUP_CD" name="PUP_CD" value="BL0000001455"/>
											</td>
										</tr>
										<tr>
											<th rowspan="2" CL="STD_DVP"></th><!-- 배송지 -->
											<td>
												<span>
												<label for="ho" CL="STD_HEAD_OFFICE"></label>
												<input type="radio" name="radio" value="0" id="ho" style="width:30px; height:30px;">
												</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<span>
												<label for="in" CL="STD_INPU"></label>
												<input type="radio" name="radio" value="1" id="in" style="width:30px; height:30px;">
												</span>
											</td>
										</tr>
										<tr>
											<td>
												<input type="text" class="input" name="DVP_NM" id="DVP_NM" validate="required" />
												<input type="button" class="btn btn_search" id="deliverySearchBtn" data-custom-btn style="position: static;" />
												<input type="hidden" id="DVP_CD" name="DVP_CD" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DELIV_REQ_DT"></th><!-- 배송요청일자 -->
											<td>
												<input type="text" class="input" name="DELIV_REQ_DT" id="DELIV_REQ_DT" UIFormat="C" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DELIV_REQ_TM"></th><!-- 배송요청시간 -->
											<td>
												<input type="text" class="input" name="DELIV_REQ_HHMM" id="DELIV_REQ_HHMM" UIFormat="THM" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DELIV_MNG"></th><!-- 배송담당자 -->
											<td>
												<input type="text" class="input" name="DVP_MNG_NM" id="DVP_MNG_NM" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DVP_CTTPC"></th><!-- 배송지연락처 -->
											<td>
												<input type="text" class="input" name="DVP_CTTPC" id="DVP_CTTPC" />
											</td>
										</tr>
										<tr>
											<th CL="비고"></th><!-- 비고 -->
											<td>
												<input type="text" class="input" name="RMK_CNTS" id="RMK_CNTS" />
											</td>
										</tr>
<!-- 										<tr> -->
<!-- 											<th CL="STD_TRANS_CNDT"></th>운송조건 -->
<!-- 											<td> -->
<!-- 												<select class="input" id="TRANS_CNDT_CD" name="TRANS_CNDT_CD" Combo="MB1000,TRANSCNDTCDCOMBO" ComboCodeView="false" ></select> -->
<!-- 											</td> -->
<!-- 										</tr> -->
<!-- 										<tr> -->
<!-- 											<th CL="취급아이템"></th> -->
<!-- 											<td> -->
<!-- 												<select class="input" id="TRMT_ITM_CD" name="TRMT_ITM_CD" Combo="BLCOMMON,TRMTITMCDCOMBO" ComboCodeView="false" ></select> -->
<!-- 											</td> -->
<!-- 										</tr> -->
										<tr>
											<th CL="대상온도"></th>
											<td>
												<select class="input" id="GOAL_TEMPER_CD" name="GOAL_TEMPER_CD" Combo="BLCOMMON,GOALTEMPERCDCOMBO" ComboCodeView="false" >
													<option value="" CL="STD_SEL"></option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="운송건수"></th>
											<td>
												<input type="text" class="input" name="QY" id="QY" UIFormat="N" onfocus = "this.select()"/>
											</td>
										</tr>
										<tr>
											<th CL="내품수량"></th>
											<td>
												<input type="text" class="input" name="INNCG_QY" id="INNCG_QY" UIFormat="N" onfocus = "this.select()"/>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<!-- <input type="button" data-custom-btn id="cotgtAddBtn"  value="운송대상추가"> -->
												<!-- <input type="button" cb="New ADD BTN_ODNEW" class="button btn_basic basic_add_new" cbtntype="ADD" cbtnname="New" cbtnactivetype="true"/> -->
												<!-- <button id="btn222" onClick="addNewdata()">l,lkfdgdfg</button> -->
												<div class="btn_lit tableUtil rightGrid_tabelUtil">
													<input type="button" CB="New DEL BTN_TRANS_TRGT_ADD" style="background-color: #3c3c3f; font-size: 1em; width: 50%; height: 100%; color: #fff" />
													<input type="button" CB="Del DEL BTN_TRANS_TRGT_DEL" style="background-color: #3c3c3f; font-size: 1em; width: 50%; height: 100%; color: #fff" />
												</div>
											</td>
										</tr>	
									</tbody>
								</table>
								<div class="table_box section" id="tab1-1"><!-- style="height: calc(100% - 30px); -->
									<div class="table_list01"><!-- style="height: calc(100% - 175px);" -->
										<div class="scroll" style="height: 300px;">
											<table class="table_c">
												<tbody id="gridList">
													<tr CGRow="true">
<!-- 														<td GH="80 취급아이템" GCol="select,TRMT_ITM_CD"> -->
<!-- 															<select Combo="BLCOMMON,TRMTITMCDCOMBO" ComboCodeView="false"></select> -->
<!-- 														</td> -->
														<td GH="40"                   GCol="rowCheck"></td>
														<td GH="150 대상온도" GCol="select,GOAL_TEMPER_CD">
															<select Combo="BLCOMMON,GOALTEMPERCDCOMBO" ComboCodeView="false"></select>
														</td>
														<td GH="80 운송건수" GCol="text,QY"></td>
														<td GH="80 내품수량" GCol="text,INNCG_QY"></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="btn_lit tableUtil">
										<div class="btn_out_wrap">
											
										</div>
										<span class='txt_total' >총 <span GInfoArea='true'>4</span> 건</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="foot_btn">
<!-- 				<button onclick="print()"><span>운송장출력</span></button> -->
				<button onclick="saveData()" style="width:100%"><span>주문생성</span></button>
				<input type="hidden" id="eono" name="eono" />
			</div>
		</div>
		<!-- content 끝 -->
		<!--  -->
		<div class="content_inner" id="dlvReport">
			<div class="content_layout tabs" style="height: calc(100% - 10px);">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>고객및계약선택</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btnGoBack" title="닫기"></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100%);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" id="dataList" style="height:calc(100%);">
						</div>
					</div>
				</div>
			</div>	
		</div>
		<!--  -->
	</div>	
	<!-- modal -->
	<div class="modal">
	  <div class="modal_content">
	  	<table id="modalTable" style="width: 100%; border-top: 1px solid black; border-collapse: collapse;">
		  	<thead>
				<tr class="th">
					
					<th>유형1</th>
					<th>유형2</th>
					<!-- <th>유형3</th> -->
					<th>유형4</th>
					<th>유형5</th>
					<th>유형6</th>
				</tr>
			</thead>
			<tbody id="table">
			</tbody>
	  	</table>
      </div>
    </div>
    <!-- modal -->
</body>
</html>