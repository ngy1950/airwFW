<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>모바일TO마감</title>
<%@ page import="project.common.bean.*,project.common.util.*,java.util.*"%>
<%
	String langky = "KO";
	String theme = "/theme/webdek";
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_top_green.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_layout.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_left_green.css"/>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_content_ui.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_multiple-select.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.custom.js"></script>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-ko.js"></script>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>
<script type="text/javascript" src="/common/js/jquery.form.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/jquery.mousewheel.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.monthpicker.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.timepicker.js"></script>
<script type="text/javascript" src="/common/js/multiple-select.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/big.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common<%=theme%>/js/mobile_theme.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/mobile_ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/dataRequest.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/layoutSave.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>

<script type="text/javascript" src="/common/js/bl.js"></script>

<script type="text/javascript" src="/common<%=theme%>/js/mobile_head.js"></script>
<% String TONO = (String) request.getParameter("TONO"); %>
<% String TELNO = (String) request.getParameter("TELNO"); %>

<style>
#dlvReport {
	display:none;
}
.ListStyle {
	font-size: 3em;
	text-align: center;
	margin-top: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: #808080;
}
.btnGoBack{
	background: url(/common/theme/webdek/images/reset.png) no-repeat;
    background-size: 42px auto;
    width:7em;
    height:15em;
    margin-top: 8px;
}



 /* .btn {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 150px;
        height: 50px;
        line-height: 50px;
        border: 1px solid red;
        cursor: pointer;
        text-align: center;
      } */
      
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
	
	$(document).ready(function(){
		var param = new DataMap();
		param.put("TONO","<%=TONO%>");
		param.put("TELNO","<%=TELNO%>");
		var tonoStatus = netUtil.sendData({
			url : "/GCLC/mobile/json/getTonoStatus.ndo",
			param : param
		});
		
		if(bl.isNull(tonoStatus) || bl.isNull(tonoStatus.data) || bl.isNull(tonoStatus.data.END_YN)) {
			$th = $("<th>").attr("colspan","2").append("주문정보를 가져오는 도중 오류가 발생하였습니다.");
			$tr = $("<tr>").append($th);
			$("#areaData").append($tr);
			$(".foot_btn").html("");
		}else if(tonoStatus.data.END_YN == "E") {
			$th = $("<th>").attr("colspan","2").append("잘못된 배차주문번호 입니다.");
			$tr = $("<tr>").append($th)
			$("#areaData").append($tr);
			$(".foot_btn").html("");
		}else if(tonoStatus.data.END_YN == "V") {
			$th = $("<th>").attr("colspan","2").append("해당 주문은 이미 마감되었습니다.");
			$tr = $("<tr>").append($th);
			$("#areaData").append($tr);
			$(".foot_btn").html("");
		}else if(tonoStatus.data.SMS_TEL_YN == "N") {
			$th = $("<th>").attr("colspan","2").append("올바른 전화번호가 아닙니다.");
			$tr = $("<tr>").append($th);
			$("#areaData").append($tr);
			$(".foot_btn").html("");
		}
	});
	
	function exit() {
		$(".foot_btn").html("");
		$th = $("<th>").attr("colspan","2").append("취소되었습니다.");
		$tr = $("<tr>").append($th)
		$("#areaData").append($tr);
	}
	
	function TONOclose() {
		
		if(!commonUtil.msgConfirm("마감하시겠습니까?")){
			return;
		}
		
		var param = new DataMap();
		param.put("TONO",$("#TONO").val());
		param.put("TELNO",$("#TELNO").val());
		var result = netUtil.sendData({
			url : "/GCLC/mobile/json/TONOclose.ndo",
			param : param
		});
		
		if(result.data) {
			commonUtil.msgBox(result.data.result);
			if(result.data.code == "S") {
				location.reload();
			}
		}else {
			commonUtil.msgBox("마감 처리시 알수 없는 오류가 발생하였습니다.");
		}
	}
</script>
</head>
<body > 
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner" id="dlvList">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>SMS메세지 마감</span></a></li><!-- SMS메세지 TO마감 -->
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01" style="height: calc(100% - 130px);">
						<div class="table_inner_wrap" style="width: 100%; height:100%;">
							<div class="inner_search_wrap table_box" >
								<table class="detail_table" id="areaData" style="height:100%;">
									<colgroup>
										<col width="30%" />
									</colgroup>
									<tbody>			
										<tr>
											<th >배차주문번호</th><!-- 고객명 --> 
											<td>
												<input type="text" class="input" id="TONO" name="TONO" readonly="readonly" value="<%=TONO%>"/>
												<input type="hidden" id="TELNO" name="TELNO" value="<%=TELNO%>" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="foot_btn">
				<button onclick="exit()"><span>취소</span></button>
				<button onclick="TONOclose()"><span>마감</span></button>
			</div>
		</div>
		<!-- content 끝 -->
		
	</div>	
	
	
	 <div class="modal">
	  <div class="modal_content">
	  	<table id="modalTable" style="width: 100%; border-top: 1px solid black; border-collapse: collapse;">
		  	<thead>
				<tr class="th">
					
					<th>유형1</th>
					<th>유형2</th>
					<th>유형3</th>
					<th>유형4</th>
					<th>유형5</th>
					<th>유형6</th>
				</tr>
			</thead>
			<tbody id="table">
			</tbody>
	  	</table>
      	<!-- <a href="javascript:void(0)" class="btn_close">클릭하면 창이 닫힙니다</a> -->
      </div>
    </div>



	
	
	
	
	
</body>
</html>