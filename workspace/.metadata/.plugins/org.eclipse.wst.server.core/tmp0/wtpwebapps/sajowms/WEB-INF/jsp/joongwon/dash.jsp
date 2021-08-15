<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig"%>
<%
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<%-- <link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/common.css"> --%>
<link rel="stylesheet" type="text/css" href="/common/theme/joongwon/css/dash.css">
</head>
<script type="text/javascript">
	$(document).ready(function(){
		$(".worktab ul.worktabul li").click(function(){
		$(".worktab ul.worktabul li").removeClass('active');
		$(this).addClass('active');
	});
		$(".weeknumber").hide();
		$(".weeknumberinner p").click(function(){
			$(".weeknumber").slideToggle(200);
		});
		$(".weeknumber li").click(function(){
			$(this).parent().slideUp();
			$(".weeknumberinner p").text($(this).text());
		});
		
	});
</script>
<body>
	<div class="mainpage">
		<div class="mainleft">
			<div class="present">
				<h3>출고 및 입고 현황 </h3>
				<table class="work">
			    <thead>
			      <tr>
			        <td>센터명</td>
			        <td>입고건수</td>
			        <td>입고율</td>
			        <td>출고건수</td>
			        <td>출고율</td>
			      </tr>
		      </thead>
		      <tbody>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			      <tr>
			        <td>김포통합물류센터</td>
			        <td>50,074건</td>
			        <td>67%</td>
			        <td>50,074</td>
			        <td>67%</td>
			      </tr>
			    </tbody>
			  </table>
			</div>
		</div>
		<div class="main_contact">
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon1.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>596</span></p>
			</div>
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon2.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>596</span></p>
			</div>
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon3.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>5556</span></p>
			</div>
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon4.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>596</span></p>
			</div>
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon5.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>5,916</span></p>
			</div>
			<div>
				<p class="contact_img"><img src="/common/theme/joongwon/image/icon6.png"></P>
				<p class="contact_text"><span>오더건수</span><br/><span>68596</span></p>
			</div>
		</div>
		<div class="graph-inner">
			<div>
				<img src="/common/theme/joongwon/image/img01.png">
			</div>
			<div>
				<img src="/common/theme/joongwon/image/img02.png">
			</div>
			<div>
				<img src="/common/theme/joongwon/image/img03.png">
			</div>
			<div>
				<img src="/common/theme/joongwon/image/img04.png">
			</div>
		</div>
	</div>
</body>
</html>