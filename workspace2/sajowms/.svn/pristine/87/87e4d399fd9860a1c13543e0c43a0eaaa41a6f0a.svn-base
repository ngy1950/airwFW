<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항-상세</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
	.input { width: 100%; font-size: 1.0em !important; height: 100%; }
</style>
<script type="text/javascript">

	$(document).ready(function(){
		var param = new DataMap();
		param.put("NOTI_SEQ_NO", this.location.search.substring(5));
		
		var json = netUtil.sendData({
			module : "MB1000",
			command : "MB9010",
			param : param,
			sendType : "map"
		 });
		
		$('#TITLE').val(json.data.TITLE);
		$('#DRAW_PR_NM').val(json.data.DRAW_PR_NM);
		$('#FROM_TO').val(json.data.FROM_DTTM + " ~ " + json.data.TO_DTTM);
		$('#SRCH_CNT').val(json.data.SRCH_CNT);
		$('#CNTS').val(json.data.CNTS.trim());
	   
	});
	
	/* 뒤로가기 */
	function goBack(){
		this.location.href = "/mobile/MB9010.page";
	}

</script>
</head>
<body > 
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_layout tabs" style="height:99%;">
				<ul class="tab tab_style02">
					<li class="btn_zoom_wrap">
						<ul>
							<li>
								<div class="foot_btn">
									<button onclick="goBack()" style="width: 300px; height: 80px; margin-top: -11px;">뒤로가기</button>
								</div>
							</li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01" style="height: calc(100% - 130px);">
						<div class="scroll" style="height: calc(100% - 5px);">
							<div class="table_inner_wrap" style="width: 100%;height:100%;">
								<div class="inner_search_wrap table_box" style="height:100%;">
									<table class="detail_table" id="areaData" style="height:100%;">
										<colgroup>
											<col width="30%" />
											<col width="70%" />
										</colgroup>
										<tbody>			
											<tr height="7%">
												<th CL="STD_TITLE"></th>
												<td>
													<input type="text" class="input" id="TITLE" name="TITLE"  readonly="readonly" />
												</td>
											</tr>
											<tr height="7%">
												<th CL="STD_CREATEUSERNM"></th>
												<td>
													<input type="text" class="input" id="DRAW_PR_NM" name="DRAW_PR_NM" readonly="readonly" />
												</td>
											</tr>
											<tr height="7%">
												<th CL="STD_FROM_TO"></th>
												<td>
													<input type="text" class="input" id="FROM_TO" name="FROM_TO" readonly="readonly" />
												</td>
											</tr>
											<tr height="7%">
												<th CL="STD_SRCH_CNT"></th>
												<td>
													<input type="text" class="input" name="SRCH_CNT" id="SRCH_CNT"  readonly="readonly" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div style="height: calc(100% - 608px); width: 99.5%;font-size: 3.0em; margin-top: 5px;"><textarea type="text" class="input" id="CNTS" name="CNTS" readonly="readonly"></textarea></div>
			</div>
		</div>
		<!-- content 끝 -->
	</div>
</body>
</html>