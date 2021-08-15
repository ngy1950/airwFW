<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("UTF-8");

	String snd_Dttm = request.getParameter("SND_DTTM");
	String p_Snd = request.getParameter("P_SND");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PUSH보관함</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
	#gridList td { font-size: 3.0em; }
</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "MB1000",
			command : "MB9013",
			gridMobileType : true
		});
		var snd = "<%=p_Snd%>";
		
		
		if(snd != "null"){
			var sendDt = "<%=snd_Dttm%>";
			var pSendDt = sendDt.substr(0,4)+"."+sendDt.substr(4,2)+"."+sendDt.substr(6,2);
			
			$("input[name='SND_DTTM_D']").val(pSendDt);
			$("input:radio[name='SND'][value='"+ snd + "']").attr("checked", "checked");
			searchList()
		}
		
		
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			param.put("FORMAT","YYYYMMDD"); // SYSDATE
			
			var resultJson = netUtil.sendData({
				module : "BLCOMMON",
				command : "GETDATETIME",
				param : param,
				sendType : "map"
			 });
			
			param.put("TO_DTTM", resultJson.data.DATIM);
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	/* Row 클릭 이벤트 */
	function gridListEventRowClick(gridId, rowNum, colName) {
		if(gridId == "gridList"){
			var param = gridList.getRowData(gridId, rowNum);
			$("input[name='TITLE_CNTS']").val(param.get("TITLE_CNTS"));
			$("input[name='SND_DTTM']").val(param.get("SND_DTTM"));
			$("input[name='SND_USER_NM']").val(param.get("SND_USER_ID"));
			$("input[name='RCVR_NM']").val(param.get("RCVR_ID"));
			$("input[name='MSG_CNTS']").val(param.get("MSG_CNTS"));
			$("input[name='P_SND']").val($("input:radio[name='SND']:checked").val());
			$("#submit").trigger("click");
		}
	}

</script>
</head>
<body>
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:300px">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:30%" />
							<col style="width:70%" />
						</colgroup>
						<tr>
							<th CL="STD_DT"></th><!-- 일자 -->
							<td>
								<input type="text" class="input" id="SND_DTTM_D" name="SND_DTTM_D" UIInput="SB" UIFormat="C N"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_GUBUN"></th><!-- 구분 -->
							<td>
								<input type="radio" class="input" id="SND_RADIO_1" name="SND" value="SND_USER_ID" style="width:2em;height:2em;" checked="checked"/><label for="radio1" style="margin-right:70px"><span>요청</span></label>
								<input type="radio" class="input" id="SND_RADIO_2" name="SND" value="RCVR_ID" style="width:2em;height:2em;"/><label for="radio1"><span>응답</span></label>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 480px);">
<!-- 			<div class="content_layout tabs"> -->
				<div class="table_box section" id="tab1-1" style="height: 100%;">
<!-- 				<div class="table_box section" id="tab1-1" > -->
					<div class="table_list01" style="height: calc(100% - 65px);">
<!-- 					<div class="table_list01"> -->
						<div class="scroll" style="height:calc(100% - 115px);">
<!-- 						<div class="scroll"> -->
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40"        GCol="rownum">1</td>
										<td GH="150 제목"    GCol="text,TITLE_CNTS"></td><!-- 제목 -->
										<td GH="80 요청자"    GCol="text,SND_USER_NM"></td><!--  -->
										<td GH="80 응답자"    GCol="text,RCVR_NM"></td><!--  -->
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
				<div class="table_box" id="tab1-2" style="display:none;">
					<div class="inner_search_wrap">
					</div>
				</div>
			</div>
			<div class="foot_btn">
				<button onclick="searchList()" style="width:100%"><span>조회</span></button>
			</div>
			<form method="post" action="/mobile/MB9014.page" style="display:none">
				<input type="text" name="TITLE_CNTS">
				<input type="text" name="SND_DTTM">
				<input type="text" name="SND_USER_NM">
				<input type="text" name="RCVR_NM">
				<input type="text" name="MSG_CNTS">
				<input type="text" name="P_SND">
				<button type="submit" id="submit"></button>
			</form>
		</div>
	</div>
	<!-- content 끝 -->
</body>
</html>