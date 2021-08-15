<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>[APCOMM]결재요청</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	window.resizeTo('680','340');
	var lindData;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsApproval",
			command : "APCOMM",
			autoCopyRowType : false
		});
		
		lindData = page.getLinkPopData();
		searchList(page.getLinkPopData());
	});

	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "SaveRequest"){
			saveRequest();
		}
	}
	
	//헤더 조회
	function searchList(data){
			
		gridList.gridList({
			id : "gridList",
			param : data
		}); 
		
	}
	
	//팝업클로즈 이벤트
	function saveRequest(){
		var text = $("input[name=requestText]").val();
// 		if( $.trim(text) == "" ){
// 			commonUtil.msgBox("OUT_M0303"); //결제요청의견을 작성해주세요.
// 			return false;
// 		}
		
		var closeParam = new DataMap();
		closeParam.put("REQTXT", text);
		
		page.linkPopClose(closeParam);
	}
	
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="SaveRequest SAVE BTN_REQUEST"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
	
			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_PAYMENT"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							
							<div class="reflect">
								결제요청의견
								<input type="text" name="requestText" UIFormat="S 30" style="width: calc(100% - 82px);" />
							</div>
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="120 STD_GUCREUR"   GCol="text,APRTNM"></td>
												<td GH="150 STD_USERID"    GCol="text,USERID"></td>
												<td GH="100 STD_NAME01"    GCol="text,USERNM"></td>
												<td GH="100 STD_ASUBFDT"   GCol="text,APFDAT" GF="D"></td>
												<td GH="100 STD_ASUBTDT"   GCol="text,APTDAT" GF="D"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="sortReset"></button> -->
<!-- 									<button type="button" GBtn="layout"></button> -->
<!-- 									<button type="button" GBtn="excel"></button> -->
<!-- 									<button type="button" GBtn="total"></button> -->
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