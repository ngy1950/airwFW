<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%

	String wareky   = request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString();
	String userid   = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String compky   = request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY).toString();
	String langky   = request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();
	String theme    = request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY).toString();
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<title></title>
<meta name="viewport" content="width=1150">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/common.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/top.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/theme.css">
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
<script type="text/javascript" src="/common/js/page.js"></script>
<script>
(function() {

	$(function() {
		var gnb = $('.gnb')
			, trigger = gnb.find('.list').children('li')
			, list = trigger.children('ul');
		
		trigger.each(function() {
			var _this = $(this)
				, thisTrigger = _this.children('a')
				, thisList = _this.children('ul');
			
			thisTrigger.on({
				click : function() {
					list.hide();
					thisList.show();
					
					trigger.removeClass('active');
					_this.addClass('active');
				}
			});
		});
	});

})();

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

var topRoop = true;
$(document).ready(function(){
	inputList.setCombo();
	$("select[name=WAREKY]").val("<%=wareky%>");
	
	uiList.UICheck();
	
	//logoEffect();
	
	//결재현황, 재고이동 조회
	//countCall();
	
	//2분마다 결재현황, 재고이동 조회
	setInterval(function(){
		if(topRoop){
			countCall();
		};
	}, 120000);
	
});

function topRoopChk(){
	topRoop = false;
}

//결재현황, 재고이동 조회
function countCall(){
	var param = dataBind.paramData("searchArea");
	param.put("USERID", "<%=userid%>");
	
	var json = netUtil.sendData({
		module : "main",
		command : "TOPBIZ",
		sendType : "list",
		param : param
	});
	
	if(json && json.data){
		$(".leftArea p:eq(0) span").text(json.data[0].CNT); //결재현황 건수
		$(".leftArea p:eq(1) span").text(json.data[1].CNT); //재고이동 건수
	}
}

//센터 조회
function changeWareky(){
	var param = dataBind.paramData("searchArea");
	var json = netUtil.sendData({
		url : "/wms/common/json/changeWareky.data",
		param : param
	});
	
	if(json && json.data){
		
	}
	
	//window.top.closeAll();
	window.top.reloadPage()
}

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
		  backgroundColor: "#699bf8",
		  color: "#699bf8"
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

$(document).ready(function(){
	uiList.UICheck();
});
</script>
</head>
<body>
<!-- header -->
<div class="header">
	<div class="innerContainer">
		<span class="logo" id="" onClick="window.top.reloadPage();">
			<img src="/common<%=theme%>/images/login/logo_3.png" alt="logo" />
			<%-- <a href="#" onClick="window.top.reloadPage()"><img src="/common<%=theme%>/images/login/logo_2.png" alt="logo" /></a> --%>
			<!-- <span class="e">e</span>WMS -->
		</span>
		<div class="leftArea">
			<button class="menu"></button>
			<p>결재현황: 결재 진행 중 <a onclick="page.linkPageOpen('AP11', null)"><span class="textstyle"></span>건<img src="/common/theme/gsfresh/images/login_img/right_white.png" /></a></p>
			<p>재고이동: <a  onclick="page.linkPageOpen('SV02', null)"><span class="textstyle"></span>건<img src="/common/theme/gsfresh/images/login_img/right_white.png" /></a></p>
		</div>
		
		<div class="rightArea" id="searchArea">
			<div class="logout" onClick="logout()"></div>
			<div class="helloid"><span>안녕하세요, <%=username%>님</span></div>
			<div class="selection">
				<select Combo="Wms,WAHMACOMBO" name="WAREKY" onChange="changeWareky()" ></select>
			</div>
<!-- 			<div class="util"> -->
<%-- 				<p class="user" ><%=username%></p>&nbsp; --%>
<!-- 				button class="setting" type="button"><a href="/common/demo/tool/sql.jsp" target="_TOP">설정</a></button -->
<!-- 				<button class="logOut" type="button" onClick="logout()" CL="BTN_LOGOUT"></button>	 -->
<!-- 			</div> -->
		</div>
	</div>
</div>
<!-- //header -->
</body>
</html>