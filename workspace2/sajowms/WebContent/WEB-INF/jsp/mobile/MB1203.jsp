<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>포장 바코드 출력</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
 .input{width: 100%}
</style>
<script type="text/javascript">

	$(document).ready(function(){
		$("input[name='RCVR']").attr("readonly", true);
	});
	
	function rcvCheck(){
		if($("select[name='RCV_PL']").val().split("|")[0] == "ETC"){
			$("input[name='RCVR']").attr("readonly", false);
		}else {
			$("input[name='RCVR']").val("");
			$("input[name='RCVR']").attr("readonly", true);
		}
	}
	
	function print(){
		var Rcvpl = $("select[name='RCV_PL']").val();
		var Rcvr = $("input[name='RCVR']").val();
		var Pblsqy = $("input[name='PBLS_QY']").val();
		var Rtext = null;
		
		if(Rcvpl.split("|")[0] == "ETC" && Rcvr.length == 0){
			commonUtil.msgBox("VALID_required",uiList.getLabel("STD_RCVR"));//{0}은(는) 필수 입력항목입니다.
			 $("input[name='RCVR']").focus();
			return;
		}
		
		if(Pblsqy == 0){
			commonUtil.msgBox("VALID_required",uiList.getLabel("STD_PBLS_QY"));//{0}은(는) 필수 입력항목입니다.
			$("input[name='PBLS_QY']").focus();
			return;
		}
		
		if(Rcvpl.split("|")[0] != "ETC"){
			Rcvr = inputList.getComboData("MB1000_MB1203_GLBCD_COMBO", Rcvpl, null);
		}
		
		var array = new Array();
		
		for (var i = 0; i < Pblsqy; i++) {
			var aJson = new Object();
			aJson.RCV_PL = Rcvpl.split("|")[0];
			aJson.PRINTTIME = Rcvpl.split("|")[1];
			aJson.PRINTNM = Rcvpl.split("|")[2];
			aJson.RCVR = Rcvr;
			array.push(aJson);
		}
// 		return;
		window.GCLABCELL_BRIDGE.printPgbarcode(JSON.stringify(array));
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if(comboAtt[1] == "MB1203_GLBCD_COMBO"){
			param.put("USERID",'<%=userid%>');
		}
		return param;
	}
</script>
</head>
<body >
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_layout tabs" style="height:80%;">
<!-- 				<ul class="tab tab_style02"> -->
<!-- 					<li class="selected"><a href="#tab1-1"><span CL="수신처"></span></a></li> -->
<!-- 				</ul> -->
				<div class="table_box section" id="tab1-1" style="height: 100%;">
					<div class="table_list01" style="height: calc(100% - 130px);">
						<div class="scroll" style="height: calc(100% - 5px);">
							<div class="table_inner_wrap" style="width: 100%;height:100%;">
								<div class="inner_search_wrap table_box" id="inputInfoArea" style="height:50%;">
									<table class="detail_table" id="areaData" style="height:100%;">
										<colgroup>
											<col width="30%" />
											<col width="70%" />
										</colgroup>
										<tbody>			
											<tr height="3%">
												<th CL="STD_RCV_PL"></th><!-- 수신처 -->
												<td>
													<select class="input" name="RCV_PL" id="RCV_PL" Combo="MB1000,MB1203_GLBCD_COMBO" ComboCodeView="false" style="height:100%; font-size:1.5em" onChange="rcvCheck()">
														<option value="">선택</option>
													</select>
												</td>
											</tr>
											<tr height="3%">
												<th CL="STD_RCVR"></th><!-- 수신자 -->
												<td>
													<input type="text" class="input" id="" name="RCVR" id="RCVR" UIFormat="S 15" style="height:100%; font-size:1.5em"/>	
												</td>
											</tr>
											<tr height="3%">
												<th CL="STD_PBLS_QY"></th><!-- 발행수량 -->
												<td>
													<input type="text" class="input" name="PBLS_QY" UIFormat="N 2" value="1" style="width:100%; height:100%; font-size:1.5em" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="foot_btn">
				<button onclick="print()" class="btn_full"><span>출력</span></button>
			</div>
		</div>
		<!-- content 끝 -->
	</div>
</body>
</html>