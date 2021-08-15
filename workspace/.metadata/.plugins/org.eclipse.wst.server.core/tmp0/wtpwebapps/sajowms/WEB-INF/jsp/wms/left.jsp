<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig,com.common.bean.DataMap,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	
	List list = (List)request.getAttribute("list");

	String theme =  sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY));
	String userid = sFilter.getXSSFilter(request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS Left</title>
<meta name="viewport" content="width=1150">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/common.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/left.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/theme.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript">
	var $menuSearch;
	var menuMap = new DataMap();
	var $lastActiveObj;
	var lastActiveMenuId;

	$(document).ready(function(){
		$menuSearch = jQuery("#menuSearch");
		
		$("body").on('mousedown', function(e) { 
		   if( e.which == 2 ) {
		      e.preventDefault();
		      e.stopPropagation();
		      e.stopImmediatePropagation();
		      alert("mouse wheel click is not possible!");
		      return false;
		   }
		});
		$("body").on('click', function(e) { 
			if( e.which == 2 ) {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				return false;
			}
		});
	});
	
	function goPage(obj, url){
		var $obj = $(obj).parent();
		var menuId = $obj.attr(configData.COMMON_MENU_ID_KEY);
		var title = $obj.find("span").text();
		url = '/wms'+url;
		changePage(obj, title, url, menuId);
	}
	
	function changePage(obj, title, url, menuId){	
		var $obj = $(obj).parent();
		
		titleTxt = "";
		
		getTitle($obj);
		
		if(url.indexOf("?") == -1){
			url += "?"+configData.COMMON_MENU_ID_KEY+"="+menuId;
		}else{
			url += "&"+configData.COMMON_MENU_ID_KEY+"="+menuId;
		}
		
		var tmpType = window.top.changePage(titleTxt, title, url, menuId);
		if(tmpType){
			if($lastActiveObj){
				$lastActiveObj.removeClass("active");
			}
			$obj.addClass("active");
			$lastActiveObj = $obj;
			$menuSearch.val("");
		}
		
		lastActiveMenuId = menuId;
	}
	
	var titleTxt = "";
	function getTitle($obj){
		
		if(titleTxt){
			titleTxt = $obj.text() + " > " + titleTxt;
		}else{
			titleTxt = $obj.text();
		}		
		var $pObj = $obj.parent().parent().parent().siblings().find('span');
		if($pObj.length != 0){
			getTitle($pObj);
		}
	}
	
	 function setLastActiveMenuId(menuId,tmpActiveMenuId){
		var $premenu = $menuList.find("li").filter("[MENUID="+menuId+"]").filter("[AMNUID!=FAVORITE]");
		tmpActiveMenuId = $.trim(tmpActiveMenuId);
		$premenu.removeClass("active");
		lastActiveMenuId = tmpActiveMenuId;
		
		if(tmpActiveMenuId){
			var $nowmenu = $menuList.find("li").filter("[MENUID="+tmpActiveMenuId+"]").filter("[AMNUID!=FAVORITE]");
				$nowmenu.addClass("active");
			$lastActiveObj = $nowmenu;
		}else{
			$lastActiveObj = "";
		}
	} 
	
	function menuSearch(menuId){
		if(!menuId){
			menuId = $menuSearch.val();
			menuId = menuId.toUpperCase();
			$menuSearch.val(menuId);
		}
		
		var $menu = $menuList.find("li").filter("[MENUID="+menuId+"]").filter("[AMNUID!=FAVORITE]");
		if( $menu.length > 0 ){
			setMenuClick(menuId);
		}else{
			$menuSearch.val("");
		}
	}
	
	function setMenuClick(menuId){
		var $menu = $menuList.find("li").filter("[MENUID="+menuId+"]").filter("[AMNUID!=FAVORITE]");
		var pmenuId = $menu.attr("AMNUID");
		if(!$menu.hasClass('active')){
			$menu.find("> a").trigger("click");
		}
		if(pmenuId != "root"){
			setMenuClick(pmenuId);
		}	
	}
	
	function fmenuInsert(){
		if(lastActiveMenuId){
			var fmenu = $menuList.find("[AMNUID=FAVORITE]").find("[MENUID="+lastActiveMenuId+"]");
			if(fmenu.length == 0){
				var param = new DataMap();
				param.put("MENUID",lastActiveMenuId);
				var json = netUtil.sendData({
					module : "Common",
					command : "FMENU",
					sendType : "insert",
					param : param
				});
				
				
				var $menu = $menuList.find("li").filter("[MENUID="+lastActiveMenuId+"]");
				var $fmenu = $menuList.find("[MENUID=FAVORITE]");
				var $tmpMenu = $($menu.clone().wrapAll("<div/>").parent().html());
				$tmpMenu.filter("li").attr("AMNUID", "FAVORITE").removeClass("active").addClass("favmnu");
				$tmpMenu.append("<button class='delFav' onClick=\"fmenuDelete('"+lastActiveMenuId+"', this)\"> - </button>");
				$fmenu.find("#START").append($tmpMenu);
			}
		}
	}
	
	function fmenuDelete(menuId, obj){
		var param = new DataMap();
		param.put("MENUID",menuId);
		var json = netUtil.sendData({
			module : "Common",
			command : "FMENU",
			sendType : "delete",
			param : param
		});
		
		jQuery(obj).parent().remove();
	}
	
	// 로딩 열기
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
	
	/*
	2017.05.17 탭 클릭시 좌측메뉴 class add
	*/
	function changeClass(menuId){
		var $menu = $menuList.find("li").filter("[MENUID="+menuId+"]").filter("[AMNUID!=FAVORITE]");
		if($lastActiveObj){
			$lastActiveObj.removeClass("active");
		}
		$menu.addClass("active");
		$lastActiveObj = $menu;
        lastActiveMenuId = menuId;
	}
</script>
</head>
<body>
<!-- 검색어 입력, 즐겨찾기, 새로고침 -->
<div class="icons">
	<span class="ellipse_center">
		<input type="text" id="menuSearch" size="14" onkeypress="commonUtil.enterKeyCheck(event,'menuSearch()')" placeholder="검색어를 입력하세요."/>
	</span>
	<div class="rightArea">
		<button class="button type1 second" type="button" onclick="fmenuInsert()">
			<img src="/common/theme/gsfresh/images/login_img/ico_left2.png" alt="favorite">
			즐겨찾기
		</button>
		<button class="button type1" type="button" onclick="window.top.refreshPage()">
			<img src="/common/theme/gsfresh/images/login_img/ico_left3.png" alt="refresh">
			새로고침
		</button>
	</div>
</div>

<!-- lnb 메뉴리스트 --->
<div class="lnb">
	<ul class="list" id="menuList" style="display:none;">
<%
	DataMap map;
	String url;
	String amnuid;
	String menuid;
	String spanClass;
	String lbltxl;
	String imgpth;
	for(int i=0;i<list.size();i++){
		map = (DataMap)list.get(i);
		url    = sFilter.getXSSFilter(map.getString("PGPATH"));
		amnuid = sFilter.getXSSFilter(map.getString("AMNUID"));
		menuid = sFilter.getXSSFilter(map.getString("MENUID"));
		lbltxl = sFilter.getXSSFilter(map.getString("LBLTXL"));
		imgpth = sFilter.getXSSFilter(map.getString("IMGPTH"));
		if(url.indexOf("jsp") != -1){
			url = url.substring(1);
			url = url.substring(0, url.length()-3)+"page";
		}else{
			url = "";
		}
%>
<%
		if("FAVORITE".equals(amnuid)){
			spanClass = "fmnuTxt";			
%>			
		<li class="favmnu" AMNUID="<%=amnuid%>" MENUID="<%=menuid%>">
<% 		
		}else{
			spanClass = "mnuTxt";
			if("root".equals(amnuid) && !"FAVORITE".equals(menuid) && !"".equals(imgpth.trim())){
%>
			<li AMNUID="<%=amnuid%>" MENUID="<%=menuid%>" style="background-image: url(<%=imgpth%>);">
<%
			}else{ 
%>
			<li AMNUID="<%=amnuid%>" MENUID="<%=menuid%>">
<%
			}
		}	
%>

<%
		if(url.equals("")){
%>
			<a href="#">
<%
		}else{
%>
			<a href="#" menuId="<%=menuid%>" onclick="goPage(this, '<%=url%>')">
<%
		}
%>
				<span class="<%=spanClass%>"><%=lbltxl%></span>
			</a>
<%
		if(menuid.equals("FAVORITE")){
%>
			<ul id="START" style="display:none;"></ul>
<%
		}
%>
<%
		if(amnuid.equals("FAVORITE")){
%>
			<button class="delFav" onClick="fmenuDelete('<%=menuid%>', this)"> - </button>
<%
		}
%>
		</li>
<%
	}
%>
	</ul>
</div>
<!-- //lnb -->
<script type="text/javascript">
	var keyMap = new DataMap();
	var $menuList = $("#menuList");
	$menuList.hide();
	$menuList.find('[AMNUID]').each(function(i,findElement){
		var $obj = jQuery(findElement);
		var AMNUID = $obj.attr("AMNUID");
		if(AMNUID != "root" && !keyMap.containsKey(AMNUID)){
			keyMap.put(AMNUID, AMNUID);
			var $groupList = $menuList.find("[AMNUID='"+AMNUID+"']");
			$menuList.find("[MENUID='"+AMNUID+"']").append($groupList);
			$groupList.wrapAll("<ul>");
		}
	});
	$menuList.show();
</script>
<script>
(function() {

	$(function() {

		var lnbTrigger = $('.lnbCloser')
			, lnb = $('.lnb')
			, tab = $('.tab.type1')
			, contHeader = $('.contentHeader')
			, content = $('.content')
			, depth1Trigger = lnb.find('.list').children('li')
			, depth2List = depth1Trigger.children('ul')
			, depth2Trigger = depth2List.children('li')
			, depth3List = depth2Trigger.children('ul')
			, motionTime = 0.35
			, xDist = 190;


		depth1Trigger.each(function() {
			var _this = $(this)
				, thisTrigger = _this.children('a')
				, thisDepth2List = _this.children('ul');

			thisTrigger.on({
				click : function() {
					if ( thisDepth2List.is(':hidden') ) {
						_this.addClass('active');
						thisDepth2List.stop().slideDown(200);
					} else {
						_this.removeClass('active');
						thisDepth2List.stop(true, true).slideUp(200);
					}
				}
			});
		});

		depth2Trigger.each(function() {
			var _this = $(this)
				, thisTrigger = _this.children('a')
				, thisDepth3List = _this.children('ul');

			if ( thisDepth3List.length ) {
				_this.addClass('hasDepth')
			}

			thisTrigger.on({
				click : function() {
					if ( thisDepth3List.is(':hidden') ) {
						_this.addClass('active');
						thisDepth3List.stop().slideDown(200);
					} else {
						_this.removeClass('active');
						thisDepth3List.stop(true, true).slideUp(200);
					}
				}
			});
		});
	});
})();
</script>
</body>
</html>