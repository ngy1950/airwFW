<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>랙 바코드 출력</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
	 
	});
	
	/* 출력 */
	function printList(){
		
		if ( $("#PBLS_QY").val() == null || $("#PBLS_QY").val() == 0 ){
			commonUtil.msgBox('BL_NO_INPUT_QTY'); // 수량을 입력해 주세요 (1 ~ 9)			
			return ;
		}
		
		var param = new DataMap();
		param.put("PBLS_QY", $("#PBLS_QY").val());
		param.put("USERID", "<%=userid%>");
		
		netUtil.send({
			url : "/GCLC/Mobile/json/mobileMB1201.data",
			param : param,
			successFunction : "saveDataCallBack"
		}); 
	}
	
	function saveDataCallBack(json, returnParam) {
		if( json && json.data ){ 
			//alert(JSON.stringify(json.data));
			window.GCLABCELL_BRIDGE.printRackBarcode(JSON.stringify(json.data));
		}
	}

</script>
</head>
<body>
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:100px">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:40%" />
							<col style="width:60%" />
						</colgroup>
						<tr>
							<th CL="STD_PBLS_QY"></th>
							<td>
								<input type="text" class="input" id="PBLS_QY" name="PBLS_QY" value="1" UIFormat="N 2"/><!-- 발행수량 -->
							</td>
						</tr>
					</table>
				</div>
			</div>
			 		
			<!-- 하단 버튼 시작 -->
			<div class="foot_btn">
				<button onClick="printList()" class="btn_full"><span>출력</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>