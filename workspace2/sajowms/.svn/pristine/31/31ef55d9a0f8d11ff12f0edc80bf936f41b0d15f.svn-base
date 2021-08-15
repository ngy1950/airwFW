<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.*,java.util.*"%>
<%
	String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	String compid = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
    String deptid = (String)request.getSession().getAttribute(CommonConfig.SES_DEPT_ID_KEY);

	User user = (User)session.getAttribute(CommonConfig.SES_USER_OBJECT_KEY);

	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);

	List<DataMap> mlist = (List)request.getSession().getAttribute(CommonConfig.SES_USER_ROOT_MENU_KEY);

	String pmenuid = (String)request.getSession().getAttribute("PMENUID");

	DataMap row;
	if(pmenuid != null && mlist!= null && mlist.size() > 0){
		row = (DataMap)mlist.get(0);
		if(pmenuid.equals(row.getString("MENUID"))){
			pmenuid = "";
		}
	}else{
		pmenuid = "";
	}
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<title></title>
<meta name="viewport" content="width=1150">
<%
	if(compid.equals("GCCL")){
%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_GCCL.css"/>
<%
	}
%>
	<%
	if(compid.equals("PORTAL")){
%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_GCCL.css"/>
<%
	}
%>
<%
	if(compid.equals("GCLC")){
%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_green.css"/>
<%
	}
%>
<!-- <link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_navy.css"/> -->
<!-- <link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_white.css"/> -->
<!-- <link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/top_red.css"/> -->
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
<script type="text/javascript" src="/common/js/site.js"></script>
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
	window.top.location.href = "/portal/json/logout.page";
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
var menuSelect = '<%=pmenuid%>';
$(document).ready(function(){
	uiList.UICheck();
	lastWareKey = $("[name=WAREKY]").val();

	var lastTime = $("#lastTime").text();
	lastTime = uiList.getDataFormat([configData.INPUT_FORMAT_DATETIMESECOND], lastTime, true);
	$("#lastTime").text(lastTime);

    if(window.top.location.href.split("?")[1]){
        menuSelect = window.top.location.href.split("?")[1].split("=")[1];
        changeMenu($(".header_tab").find("a[menuid='"+menuSelect+"']"), menuSelect);
    }else{
        menuSelect = $(".header_tab").find("a").eq(0).attr("menuid");
        changeMenu($(".header_tab").find("a[menuid='"+menuSelect+"']"), menuSelect);
    }

});

function changeMenu(obj, menuid){
	console.log(obj)
	var $obj = commonUtil.getJObj(obj);
	console.log($obj)
	$obj.parents("UL").find("a").removeClass("selected");
	$obj.addClass("selected");
	var param = new DataMap();
	param.put("PMENUID", menuid);
	var json = netUtil.sendData({
		url : "/portal/json/menuChange.data",
		param : param
	});
	if(json && json.data){
		window.top.reloadLeft();
		//window.top.reloadInfo(menuid);
	}
}

function changeMenuFocus(menuSelect){
	$(".header_tab").find("a").removeClass("selected");
	$(".header_tab").find("[menuid='"+menuSelect+"']").addClass("selected");
}
</script>
</head>
<body style="min-width:1100px">
	<div class="content_top" >
		<div class="logos">
			<h1 class="GCCL">
				<a href="#none"><span></span></a>
			</h1>
		</div>
<!-- 		<h1 class="btn_ghost"> -->
			<!-- <a href="#none"><span>ghost</span></a> -->
<!-- 		</h1> -->
		<!-- <div class="btn_top" id="pathTitle">
			<button type="button" class="btn btn_extend" onclick="sizeToggle(this)"><span>left menu close</span></button>
			left menu open <button type="button" class="btn btn_left_o"><span>left menu open</span></button>
			<button type="button" class="btn btn_win_c" onClick="closeAll()"><span>widow close</span></button>
		</div> -->
		<ul class="header_tab">
<%
	for(int i=0;i<mlist.size();i++){
		row = (DataMap)mlist.get(i);
%>
			<li style="min-width:100px;"><a href="#" menuid="<%=row.getString("MENUID")%>" onclick="changeMenu(this, '<%=row.getString("MENUID")%>')"><%=row.getString("LBLTXL")%></a></li>
<%
	}
%>
		</ul>
		<ul class="header_right">
			<li class="last_time">최종접속시간 : </li>
			<li class="last_time" id="lastTime"><%=user.getLogindate()%></li>
			<li class="user_nm"><span><%if(("").equals(deptid) || deptid == null) { %> <%} else{ %> <%=deptid %> <%} %><%=username%></span> 님</li>
			<!-- li class="alert"><a href="#">icon</a></li-->
<!-- 			<li class="setting"><a href="#">icon</a></li> -->
			<li class="logout" onClick="logout()"><a href="#">icon</a></li>
		</ul>

	</div>
</body>
</html>