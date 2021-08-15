<%@ page import="project.common.bean.CommonConfig,project.common.bean.DataMap,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	List list = (List)request.getAttribute("list");

	String langky = request.getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();
	String compky = request.getAttribute(CommonConfig.SES_USER_COMPANY_KEY).toString();
	String wareky = request.getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString();
	String warenm = request.getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY).toString();
	String userid = request.getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String usernm = request.getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	
	String env = "";
	if(request.getAttribute("ENV") != null){
		env = request.getAttribute("ENV").toString();
	}
%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>WMS PDA</title>
<link rel="shortcut icon" href="/pda/img/favicon.png" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="/pda/css/mobile.css" />
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/pda/js/topMenu.js"></script>
<script type="text/javascript" src="/pda/js/mobileCommon.js"></script>
<script type="text/javascript">
	var g_menuId = "index";
	var g_menuOpen = false;
	var g_user = new DataMap();
	var g_menu_list = new DataMap();
	
	configData.isMobile = true;
	
	$(document).ready(function(){
		setOpenDetailButton(false);
	});
	
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
		var warenm = "<%=warenm%>";
		var usernm = "<%=usernm%>";
		
		g_user.put("WARENM", warenm);
		g_user.put("USERNM", usernm);
		
		$("#WAREKY").html(warenm);
		$("#USRID").html("안녕하세요, "+ usernm + " 님");
		
		$(window).resize(function(){
			var topH = window.top.menuHeightReturn();
			menuHeightSetting(topH);
		});
		
		setMenuListData();
	});
	
	function menuOpen(){
		window.top.menuOpen();
		
		var topH = window.top.menuHeightReturn();
		menuHeightSetting(topH);
	}
	
	function openPage(menuId, url){
		g_menuId = menuId;
		//window.parent.configData.MENU_ID = g_menuId;
		var menuName = parent.$bodyFrame[0].contentWindow.setMenuName(menuId);
		$("#title p").removeClass("info");
		$("#title p").html(menuName);
		window.top.openPage(menuId, url);
	}
	
	function logout(){
		top.logout();
	}
	
	function goMain() {
		window.top.goMain();
	}
	
	function openDetail(){
		var $obj = $(".main_header ul li.t02");
		if($obj.hasClass("detail")){
			changeOpenDetailButtonType("grid");
			parent.frames["bodyFrame"].contentWindow.mobileCommon.openDetail("grid");
		}else if($obj.hasClass("grid")){
			changeOpenDetailButtonType("detail");
			parent.frames["bodyFrame"].contentWindow.mobileCommon.openDetail("detail");
		}
	}
	
	function changeOpenDetailButtonType(type){
		var $obj = $(".main_header ul li.t02");
		
		switch (type) {
		case "grid":
			$obj.removeClass("detail");
			$obj.addClass("grid");
			$obj.find("img").attr("src","/pda/img/ico/bullets-white.png");
			break;
		case "detail":
			$obj.removeClass("grid");
			$obj.addClass("detail");
			$obj.find("img").attr("src","/pda/img/ico/grid-white.png");
			break;
		default:
			break;
		}
	}
	
	function setOpenDetailButton(isUse,type){
		var $obj = $(".main_header ul li.t02");
		if(isUse){
			$obj.show();
			switch (type) {
			case "grid":
				$obj.removeClass("detail");
				$obj.addClass("grid");
				$obj.find("img").attr("src","/pda/img/ico/bullets-white.png");
				break;
			case "detail":
				$obj.removeClass("grid");
				$obj.addClass("detail");
				$obj.find("img").attr("src","/pda/img/ico/grid-white.png");
				break;
			default:
				break;
			}
		}else{
			$obj.hide();
		}
	}
	
	function menuHeightSetting(menuHeight){
		var topH = menuHeight;
		if(topH > 35){
			g_menuOpen = true;
		}else{
			g_menuOpen = false;
		}
		
		var divH = $(".main_header").height();
		
		var height = topH - divH;
		
		$("#user_wrap").height(height);
	}
	
	function mainHeadTitle(){
		var $obj = $("#title");
		var $p = $("<p>").clone();
		var $span = $("<span>").clone().addClass("e");
		
		$p.append($span.html("e"));
		$p.append("WMS");
		$p.addClass("info");
		$obj.html($p);
	}
	
	function leftMenuOpen(idx){
		var $target = $('#user_wrap table.tdOpen').parent('div');
		var $targetItem = $target.find("ul");
		
		$target.find('.tdOpen').find("img").attr('src','/pda/img/ico/arr_2.png');
		$target.removeClass("open");
		$targetItem.hide();
		
		var $targetObj = $("#user_wrap .box[data-menuid="+idx+"]").find("ul");
		$targetObj.parent("div").find(".tdOpen").find("img").attr('src','/pda/img/ico/arr_1.png');
		$targetObj.parent("div").addClass("open");
		$targetObj.show();
		
		menuOpen();
	}
	
	function goHome(){
		g_menuId = "index";
		window.top.$bodyFrame.attr("src","/pda/info.page");
		
		setTimeout(function(){
			setOpenDetailButton(false);
			mainHeadTitle();
			menuOpen();
		},150);
	}
	
	function changeMenuTitle(menuId,menuName){
		g_menuId = menuId;
		$("#title p").removeClass("info");
		$("#title p").html(menuName);
	}
	
	function setMenuListData(){
		var $menuList = $(".box").find("li");
		$menuList.each(function(){
			var att = $(this).attr("menu_att");
			if(att.indexOf(",") > -1){
				var attList = att.split(",");
				var menuId = $.trim(attList[0]);
				var url = $.trim(attList[1]);
				var menuName = $(this).text();
				if(menuId != "" && url != ""){
					var data = new DataMap();
					data.put("menuName",menuName);
					data.put("url",url);
					g_menu_list.put(menuId,data);
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="main_wrap">
		<div class="main_header">
			<ul>
				<li class="t01" onClick="menuOpen()"><img src="/pda/img/ico/menu.png" width="22"></li>
				<li class="tit" id="title"><p class="info"><span class="e">e</span>WMS</p></li>
				<li class="t02 detail" onclick="openDetail()"><img src="/pda/img/ico/bullets-white.png" width="18"></li>
			</ul>
		</div>
		<div class="user_wrap" id="user_wrap">
			<div class="user" >
				<ul>
					<li class="btn"><button onclick="logout()">logout</button></li>
					<li class="txt">
						<p class="color" id="WAREKY"></p>
						<p class="top"   id="USRID"></p>
					</li>
					<li class="home" onclick="goHome();"><p></p></li>
				</ul>
			</div>
				<%
				DataMap map;
				String url;
				for(int i=0; i<list.size(); i++) {
					map = (DataMap)list.get(i);
					
					url = map.getString("PGPATH");
					
					String amenuid = map.getString("AMNUID");
					String menuid  = map.getString("MENUID");
					String lbltxl  = map.getString("LBLTXL");
					String imgpth  = map.getString("IMGPTH");
					String mnutyp  = map.getString("MNUTYP");
					
					boolean isFld = ("F".equals(mnutyp));
					if(isFld) {
				%>
				<%
						if(i != 0) {
				%>
					</ul>
				</div>
				<%
						}
				%>
				<div class="box open" data-menuid="<%=menuid%>">
					<table class="tdOpen">
						<colgroup>
							<col />
							<col width="10%"/>
						</colgroup>
						<tr>
						<%if("root".equals(amenuid)){%>
							<td style="background:url(<%=imgpth%>) no-repeat 10px center;"><%=lbltxl%></td>
						<%}else{%>
							<td><%=lbltxl%></td>
						<%}%>	
							<td><img src="/pda/img/ico/arr_1.png"/></td>
						</tr>
					</table>
					<ul class="menu">
				<%
					} else {
				%>
						<li menu_att="<%=menuid%>,<%=url%>" onClick="openPage('<%=menuid%>','<%=url%>')"><img src="/pda/img/ico/icon06-2.png"><%=lbltxl%></li>
				<%
					}
					if(i == list.size()-1) {
				%>
					</ul>
				</div>
				<%
					}
				}
				%>
				</div>
			</div>
		</div>
	</div>		
</body>