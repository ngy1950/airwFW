<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("UTF-8");

	String title_Cnts = request.getParameter("TITLE_CNTS");
	String snd_Dttm = request.getParameter("SND_DTTM");
	String snd_User_Nm = request.getParameter("SND_USER_NM");
	String rcvr_Nm = request.getParameter("RCVR_NM");
	String msg_Cnts = request.getParameter("MSG_CNTS");
	String p_Snd = request.getParameter("P_SND");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PUSH보관함-상세</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
	.input { width: 100%; font-size: 1.0em !important; height: 100%; }
</style>
<script type="text/javascript">

	
	/* 뒤로가기 */
	function goBack(){
		$("#submit").trigger("click");
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
												<th CL="제목"></th>
												<td>
													<input type="text" class="input" name="TITLE_CNTS" value="<%=title_Cnts%>" readonly="readonly" />
												</td>
											</tr>
											<tr height="7%">
												<th CL="요청시간"></th>
												<td>
													<input type="text" class="input" name="SND_DTTM" value="<%=snd_Dttm%>" readonly="readonly" UIFormat="DT"/>
												</td>
											</tr>
											<tr height="7%">
												<th CL="요청자"></th>
												<td>
													<input type="text" class="input" name="SND_USER_NM" value="<%=snd_User_Nm%>" readonly="readonly" />
												</td>
											</tr>
											<tr height="7%">
												<th CL="응답자"></th>
												<td>
													<input type="text" class="input" name="RCVR_NM" value="<%=rcvr_Nm%>" readonly="readonly" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div style="height: calc(100% - 608px); width: 99.5%;font-size: 3.0em; margin-top: 5px;">
					<textarea type="text" class="input" name="MSG_CNTS" readonly="readonly"><%=msg_Cnts%></textarea>
				</div>
				<form method="post" action="/mobile/MB9013.page" style="display:none">
				<input type="text" name="SND_DTTM" value="<%=snd_Dttm%>">
				<input type="text" name="P_SND" value="<%=p_Snd%>">
				<button type="submit" id="submit"></button>
			</form>
			</div>
		</div>
		<!-- content 끝 -->
	</div>
</body>
</html>