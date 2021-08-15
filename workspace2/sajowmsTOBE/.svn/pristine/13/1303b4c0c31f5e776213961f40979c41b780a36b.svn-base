<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Page</title>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_top_green.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_layout.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_left_green.css"/>
<script type="text/javascript" src="/common/js/jquery.js"></script>
</head>
<script type="text/javascript">
	$(document).ready(function(){
		
		$(".btn_ghost").on("click",function(){
			$(".deemLayer3").show();
			$(".left_wrap").show();
		});
		
		$(".deemLayer3").on("click",function(){
			$(this).hide();
			$(".left_wrap").hide();
		});
		
		$(".setting span").on("click",function(){
			if($(".deem_setting").hasClass("on")){
				$(".deem_setting").addClass("off");
				$(".deem_setting").removeClass("on");
				$(".deemLayer4").removeClass("on");
				$(".deemLayer4").addClass("off");
				$(".deemLayer5").removeClass("on");
				$(".deemLayer5").addClass("off");
			}else{
				$(".deem_setting").addClass("on");
				$(".deem_setting").removeClass("off");
				$(".deemLayer4").removeClass("off");
				$(".deemLayer4").addClass("on");
				$(".deemLayer5").removeClass("off");
				$(".deemLayer5").addClass("on");
			}
			
		});
		
		$menuSearch = jQuery("#menuSearch");
		$dep01 = $(".lnb_dep01 > li");
		$dep02 = $(".lnb_dep02 > li");
		$dep03 = $(".lnb_dep03 > li");
		//menuSearch("SAMPLE");
		
		$menuList.find("[AMNUID=root]").addClass("open");
		
		$dep01.on("click",function(e){
			if($dep02.children(".lnb_dep03").hasClass("open")){
				$(this).toggleClass("dep01_focus");
				$(this).children(".lnb_dep02").toggleClass("open");
				$(this).children(".lnb_dep02").children("li").toggleClass("open");
			}else{
				$(this).toggleClass("dep01_focus");
				$(this).children(".lnb_dep02").toggleClass("open");
				$(this).children(".lnb_dep02").children("li").addClass("dep02_focus_off").toggleClass("open");
			}
		});
		
		$dep02.on("click",function(e){
			e.stopPropagation();
			$(this).toggleClass("on");
			$(this).children(".lnb_dep03").toggleClass("open");
			$(this).children(".lnb_dep03").children("li").addClass("open");
			if($(this).hasClass("dep02_focus_off")){
				$(this).toggleClass("dep02_focus_on");
			}
		});
		
		$dep03.on("click",function(e){
			e.stopPropagation();
		});
		
	});
	

</script>
<body>
	<div class="deemLayer3" style="display:none">
	</div>
	<div class="deemLayer4 off">
	</div>
	
	<!-- 메뉴 시작 -->
	<div class="left_wrap" style="display:none">
		<div class="tab_wrap">
			<h1 class="left-top-logo">
				<a href="#"><img class="left-top-webdek" src="/common/theme/webdek/mobile_img/logo_w.png" /></a>
			</h1> 
			 <div class="tab_container">
				 <div id="tab1" class="tab_content">	
					<div class="lnb_wrap">
						<ul class="lnb_dep01" id="menuList" style="display:block">
							<li>
								<a href="#none">1 레벨 메뉴</a>
								<ul class="lnb_dep02">
									<li>
										<a href="#none">2 레벨 메뉴</a>
										<ul class="lnb_dep03">
											<li><a href="#none">3 레벨 메뉴</a></li>
										</ul>
									</li>
								</ul>
							</li>
						</ul>
					</div>
				 </div>
			 </div>
		</div>
	</div>
	<!-- 메뉴 끝 -->
	
	
	<!-- top 시작 -->
	<div class="content_top" >
		<h1 class="btn_ghost">
			<a href="#none"><span>ghost</span></a>
		</h1>
		<div class="title_wrap">
			<span class="title">수탁</span>
		</div>
		<div class="setting">
			<a href="#none"><span></span></a>
		</div>
	</div>
	<!-- top 끝 -->
	
	<!-- setting 시작 -->
	<div class="deem_setting off">
		<div class="top">
			<div class="left"></div>
			<div class="right">
				<div class="first"></div>
				<div class="second"></div>
			</div>
		</div>
		<div class="bot">
			<h2><span>관리자</span> 님</h2>
			<h3><span class="icon"></span><span>2020-04-17 오전 10:20</span></h3>
			<button><span>로그아웃</span></button>
		</div>
	</div>
	<!-- setting 끝 -->
	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:30%" />
							<col style="width:70%" />
						</colgroup>
						<tr>
							<th>Search</th>
							<td>
								<input type="text" class="input" name="Search" />
							</td>
						</tr>
						<tr>
							<th>Search readonly</th>
							<td>
								<input type="text" class="input" name="Search2" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th>SearchText</th>
							<td>
								<input type="text" class="input" name="Search"  />
							</td>
						</tr>
						<tr>
							<th>Calendar</th>
							<td>
								<input type="text" class="input" name="Calendar" />
							</td>
						</tr>
						<tr>
							<th>Calendar readonly</th>
							<td>
								<input type="text" class="input" name="Calendar2"  readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th>SingleRange</th>
							<td>
								<input type="text" class="input" name="SingleRange" />
							</td>
						</tr>
					</table>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
					</div>
				</div>
			</div>
			<div class="content_layout tabs" style="height:47%;">
				<ul class="tab_style02">
					<li class="selected"><a href="#tab1-1"><span>리스트</span></a></li>
					<li><a href="#tab1-2"><span>상세</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 107px);">
					<div class="table_list01" style="height:100%;">
						<div class="scroll" style="height:100%;">
							<table class="table_c">
								<colgroup>
									<col style="width:10%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>이름</th>
										<th>내용</th>
										<th>날짜</th>
										<th>주소</th>
										<th>연락처</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1</td>
										<td>에스씨엠이노</td>
										<td>녹십자GC</td>
										<td>2020/04/14</td>
										<td>경기도 용인</td>
										<td>010-0000-0000</td>
										<td>123123 TEST</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
				</div>
				<div class="table_box" id="tab1-2" style="display:none;">
					<div class="inner_search_wrap">
					</div>
				</div>
			</div>
			<div class="btn_lit tableUtil">
				<div class="btn_out_wrap">
					<input type="button" class="btn_grid_align" />
					<input type="button" class="btn_grid_filter" />
				</div>
				<span class='txt_total' >총 <span>4</span> 건</span>
			</div>
			<!-- 하단 버튼 시작 -->
			<div class="foot_btn">
				<button><span>조회</span></button>
				<button><span>저장</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>