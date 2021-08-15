<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.*,java.util.*"%>
<%
	ArrayList<DataMap> list = (ArrayList)request.getAttribute("LANGKY");

	String userid = (String)request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	String username = (String)request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY);
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	String deptid = (String)request.getSession().getAttribute(CommonConfig.SES_DEPT_ID_KEY);
	String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
	//Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	Object SES_USER_ID = null;

	User user = (User)session.getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
	
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);
	
	List<DataMap> mlist = (List)request.getSession().getAttribute(CommonConfig.SES_USER_ROOT_MENU_KEY);
	
	String pmenuid = (String)request.getSession().getAttribute("PMENUID");
	
	DataMap row;
	if(pmenuid != null && mlist!= null && mlist.size() > 0){
		row = (DataMap)mlist.get(0);
	}else{
		pmenuid = "";
	}
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Intro</title>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/intro.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/theme/webdek/js/theme.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script>

$(document).ready(function(){
	$(".menuBox>div").addClass("<%=compky%>");
	
	 // 기준정보, 공통 메뉴 제외
	if($(".menuDiv").length <= 0){
		window.location.href = "/gcim/main.page";
	}
	 
	$(".menuDiv").eq(0).addClass("focus");
	
	 // 메뉴 갯수에 따라 위치 변경
	if($(".menuDiv").length > 0){
		$(".menuBox .<%=compky%>").children().addClass("set"+$(".menuDiv").length);
		
	}else{
		window.location.href = "/gcim/main.page";
	}
	 
	
	$(".menuDiv").mouseover(function(){
		$(this).addClass("focus").siblings().removeClass("focus");
		console.log($(this).index());
		var pointSet = $(".menuPoint").attr("class").split(" ")[1];
		$(".menuPoint").removeClass(pointSet).addClass("focus"+($(this).index()+1));
	});
	
	$(".menuDiv").click(function(){
		window.location.href = "/gcim/main.page	?tab="+($(this).attr("menuid"));
	});
	
	$("body").mousemove(function(e){
		$(".skip").css({top:e.pageY+"px", left:e.pageX+"px"});
	});
	
	$(".skip").delay(5000).fadeOut();
	
	$(".skip").click(function(){
		$(".intro_text").css({animation:"none"}).children().css({animation:"none"});
		$(".menu").css({animation:"none",opacity:"1"});
		$(".logo").css({opacity:"1",animation:"none"});
		$(".menu_Wrap").css({width:"100%",animation:"none"});
		$(".skip").hide();
	});
	
	$("html").keydown(function(e){ 
		if(e.keyCode == 13){
			$(".intro_text").css({animation:"none"}).children().css({animation:"none"});
			$(".menu").css({animation:"none",opacity:"1"});
			$(".logo").css({opacity:"1",animation:"none"});
			$(".menu_Wrap").css({width:"100%",animation:"none"});
			$(".skip").hide();
		}
	}); 
	
});	
</script>
</head>	
<body class="<%=compky%>">
	<div class="intro_text">
		<div class="text_Wrap">
			<b>Think,</b> 
			<b>Plan,</b>
			<span>and <b> Work.</b></span> 
		</div>
	</div>
	<div class="menu">
		<div class="info">
			<h2><span class="username"><%=username%></span>님 환영합니다</h2>
			<div class="logoDiv">
				<div class="logo"></div>
			</div>
		</div>
		<div class="menu_Wrap">
			<div class= "menuBox">
				<div class="GCCL">
					<div class="menuBar">
						<div class="menuPoint focus1"></div>
					</div>
					<div class="menuList">
					<%
						for(int i=0;i<mlist.size();i++){
							row = (DataMap)mlist.get(i);
							if(!(row.getString("MENUID").equals("MD")) && !(row.getString("MENUID").equals("CM"))){
					%>
						<div class="menuDiv" menuid="<%=row.getString("MENUID")%>"><span class="menuName"><%=row.getString("LBLTXL")%></span></div>
					<%
							}
						}
					%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="skip"></div>
</body>
</html>