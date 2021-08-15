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
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/dash.css">
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
		
		se
		
	});
</script>
<body>
	<div class="mainpage">
		<div class="mainleft">
			<div class="present">
				<h3>센터 작업 진행 현황 <span class="number">(12/23)</span></h3>
				<div class="worktab">
					<ul class="worktabul">
						<li>입하</li>
						<li class="active">피킹</li>
						<li>상차/출하</li>
					</ul>
					<div class="weeknumberinner">
						<p>차수</p>
						<ul class="weeknumber">
							<li>1</li>
							<li>2</li>
							<li>3</li>
						</ul>
					</div>
				</div>
				<table class="work">
			    <thead>
			      <tr>
			        <td class="area">AREA</td>
			        <td>주문건수</td>
			        <td>완료건수</td>
			        <td>진행율</td>
			        <td>생산성</td>
			        <td>결품</td>
			      </tr>
			      </thead>
			      <tbody>
			      <tr>
			        <td>상온</td>
			        <td>500건</td>
			        <td>250건</td>
			        <td>50%</td>
			        <td>430건/hr</td>
			        <td class="soldout">3건</td>
			      </tr>
			      <tr>
			        <td>상온(Bypass)</td>
			        <td>300건</td>
			        <td>200건</td>
			        <td>66%</td>
			        <td>430건/hr</td>
			        <td class="soldout"></td>
			      </tr>
			      <tr>
			        <td>저온</td>
			        <td>400건</td>
			        <td>300건</td>
			        <td>75%</td>
			        <td>430건/hr</td>
			        <td class="soldout">5건</td>
			      </tr>
			      <tr>
			        <td>저온(Bypass)</td>
			        <td>300건</td>
			        <td>200건</td>
			        <td>66%</td>
			        <td>430건/hr</td>
			        <td class="soldout"></td>
			      </tr>
			    </tbody>
			  </table>
			</div>
			<div class="KPI">
				<h3>센터 KPI <span>(당월)</span></h3>
				<table class="work">
			    <thead>
			      <tr>
			        <td>항목</td>
			        <td>전월</td>
			        <td>전주</td>
			        <td>전일</td>
			      </tr>
			      </thead>
			      <tbody>
			      <tr>
			        <td>주문건수(일평균)</td>
			        <td>3,500</td>
			        <td>4,150</td>
			        <td>4,200</td>
			      </tr>
			      <tr>
			        <td>결품율</td>
			        <td>0.32%건</td>
			        <td>0.28%</td>
			        <td>0.25%</td>
			      </tr>
			      <tr>
			        <td>자량당 배송건수</td>
			        <td>38.5</td>
			        <td>40.1</td>
			        <td>42.5</td>
			      </tr>
			    </tbody>
			  </table>
			</div>
		</div>
		<div class="mainright">
			<div class="notice">
				<h3>공지사항<button>더보기</button></h3>
				<p><a href="#" class="sirentitle"><span class="siren">긴급</span>e커머스 본부 주문 수신 지연으로 센터 작업 지시 대기<span class="noticeday">2020.02.07</span></a></p>
				<p><a href="#">WMS 서버 정기 정검 예정 (12/15(일)03:00~05:00사용불가)<span class="noticeday">2020.01.31</span></a></p>
				<p><a href="#" class="sirentitle"><span class="siren">긴급</span>위해 상품 등록 1건 - 출고 금지<span class="noticeday">2020.01.31</span></a></p>
			</div>
			<div class="pickinghr">
				<h3>피킹생산성</h3>
				<div class="pickinghrimg">
					<span class="textafter">455</span>	
					<span class="textday">486</span>	
					<span class="textday textdaycenter">486</span>	
				</div>
			</div>
			<div class="carhr">
				<h3>차량 생산성</h3>
				<div class="carhrimg">
					<span class="textafter">455</span>	
					<span class="textday">486</span>	
					<span class="textday textdaycenter">486</span>
				</div>
			</div>
		</div>
		<div class="mainfooter">
			<button class="ecommerce">e커머스 본부</button>
			<button class="TMS">TMS</button>
			<button class="Gsfresh">　</button>
			<button class="happycall">해피콜</button>
			<button class="portal">포탈</button>
		</div>
	</div>
</body>
</html>