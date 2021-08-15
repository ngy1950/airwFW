<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,project.common.bean.CommonConfig"%>
<%
	String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<title></title>
<meta name="viewport" content="width=1150">
<!-- <link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_navy.css"/> -->
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_red.css"/>
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script>
//로딩 열기
function loadingOpen() {

	var loader = $('<div class="contentLoading"></div>').appendTo('body');

	loader.stop().animate({
		top : '0px'
	}, 30, function() {
	});
}

// 로딩 닫기
function loadingClose() {

	var loader = $('.contentLoading');

	loader.stop().animate({
		top : '100%'
	}, 30, function() {
		loader.remove();
	});
}
$(document).ready(function(){
	inputList.setCombo();

	uiList.UICheck();
	
	//logoEffect();
});


function logout(){
	location.href = "/common/json/logout.page";
}

function changePage(menuId){	
	window.top.menuPage(menuId);
}

function logoEffectStart(){
	state = true;
	effectType = true;
	logoEffect();
}

function logoEffectStop(){
	state = false;
	effectType = false;
	logoEffect();
	$( "#effect" ).stop(true,true);
}

var state = true;
var effectType = true;
function logoEffect(){	
	if ( state ) {
		$( "#effect" ).animate({
		  backgroundColor: "#ffffff",
		  color: "#ffffff"
		}, 1000 );
	} else {
		$( "#effect" ).animate({
		  backgroundColor: "#2f313a",
		  color: "#2f313a"
		}, 1000 );
	}
	
	if(effectType){
		state = !state;
		setTimeout(logoEffect, 1000);
	}	
}

var lastWareKey;
$(document).ready(function(){
	uiList.UICheck();
	lastWareKey = $("[name=WAREKY]").val();
});
</script>
</head>
<body>
	<div class="content_top" >
		<div class="logos">
			<h1 class="logo">
				<a href="#none"><span>webdek</span></a>
			</h1>
		</div>
		<h1 class="btn_ghost">
			<a href="#none"><span>ghost</span></a>	
		</h1>
		<!-- <div class="btn_top" id="pathTitle">
			<button type="button" class="btn btn_extend" onclick="sizeToggle(this)"><span>left menu close</span></button>
			left menu open <button type="button" class="btn btn_left_o"><span>left menu open</span></button>
			<button type="button" class="btn btn_win_c" onClick="closeAll()"><span>widow close</span></button>
		</div> -->
		<ul class="header_tab">
			<li><a href="#" class="selected">TOP1</a></li>
			<li><a href="#">TOP2</a></li>
			<li><a href="#">TOP3</a></li>
			<li><a href="#">TOP4</a></li>
			<li><a href="#">TOP5</a></li>
		</ul>
		<ul class="header_right">
			<li class="last_time">최종접속시간 : 2019-11-08 오전 10:48</li>
			<li class="user_nm"><span>관리자</span> 님</li>
			<li class="alert"><a href="#">icon</a></li>
			<li class="setting"><a href="#">icon</a></li>
			<li class="logout"><a href="#">icon</a></li>
		</ul>
		
	</div>
</body>
</html>