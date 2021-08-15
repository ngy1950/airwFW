<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,com.common.bean.CommonConfig,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>

<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	request.setCharacterEncoding("UTF-8");

	DataMap paramDataMap = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

	if(paramDataMap == null){
		paramDataMap = new DataMap(request);
	}
	
	String langky = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY));
	String wareky = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY));
	String warenm = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY));
	String ownrky = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_KEY));
    String ownatnky = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_NATNKY_KEY));
    String userid = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY));
    String usernm = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY));
    String theme = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY));
    String usradm = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_ADMIN_AUTH));
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
<!-- <link rel="manifest" href="/mobile/manifest/manifest.json">
<link rel="shortcut icon" href="/mobile/img/favicon.png" type="image/x-icon"> -->
<link rel="stylesheet" type="text/css" href="/mobile/css/mobile.css" />
<link rel="stylesheet" type="text/css" href="/common/css/jquery/jquery-ui.css" />
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<%
	if(langky != null && (langky.equals("CN") || langky.equals("ZH"))){
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-zh-CN.js"></script>
<%
	}else if(langky != null && langky.equals("EN")){
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-en-GB.js"></script>
<%
	}else{
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-ko.js"></script>
<%
	}
%>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>
<script type="text/javascript" src="/common/js/jquery.form.js"></script>
<script type="text/javascript" src="/common/js/jquery.mousewheel.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js?20170828"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/js/site.js?20170622"></script>
<script type="text/javascript" src="/common/js/commonUtil.js?20170622"></script>
<script type="text/javascript" src="/common/js/theme.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js?20170828"></script>
<script type="text/javascript" src="/common/js/netUtil.js?20170828"></script>
<script type="text/javascript" src="/common/js/ui.js?20170622"></script>
<script type="text/javascript" src="/common/js/validateUtil.js?20170622"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/dataRequest.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script><!-- ?20170828 -->
<script type="text/javascript" src="/mobile/js/mobile.js"></script>
<script type="text/javascript" src="/mobile/js/mobileHead.js"></script>
<script type="text/javascript" src="/mobile/js/mobileSearchHelp.js"></script>
<script type="text/javascript" src="/mobile/js/mobileDatePicker.js"></script>
<script type="text/javascript" src="/mobile/js/mobileCommon.js"></script>
<script type="text/javascript" src="/mobile/js/mobileKeyPad.js"></script>
<script type="text/javascript" src="/mobile/js/scanInput.js"></script>
<script type="text/javascript" src="/wms/js/wms.js?20171106"></script>
<script>
	var moveCount = 0;
	configData.isMobile = true;
	
	var success = new Audio("/mobile/sound/success-beep.wav");
	var fail = new Audio("/mobile/sound/error-beep.wav");
	
	history.pushState(null, null, location.href);
	window.onpopstate = function () {
		history.go(1);
		moveCount++;
		if(moveCount == 1){
			var isMenuOpen = parent.frames["topFrame"].contentWindow.g_menuOpen;
			if(isMenuOpen){
				parent.frames["topFrame"].contentWindow.menuOpen();
			}else{
				goMain();
			}
		}else if(moveCount > 1){
			moveCount = 0;
		}
	};
	
	window.onpageshow = function (e) {
		if(e.persisted || (window.performance && window.performance.navigation.type == 2)){
			window.parent.location.replace("/mobile/index.page?isBack=Y");
		}else{
			if(window.parent.isBack == "Y"){
				window.parent.isBack = "N";
				goMain();
			}
		}
	};
	
	var windowHeight = $(window).height();
	mobileKeyPad.pdaHeight = windowHeight;
	
	$(window).load(function() {
		mobileKeyPad.setInputAreaFormatAll();
	});
	
	$(window).resize(function(){
		if(this.resizeTO) {
			clearTimeout(this.resizeTO);
		}
		this.resizeTO = setTimeout(function(){
			$(this).trigger("keyPad");
		},0);
	});

	$(window).on("keyPad",function(){
		var currentPadHeight = $(window).height();
		setTimeout(function(){
			if(currentPadHeight == windowHeight){
				mobileKeyPad.closeMobileKeyPad();
			}
		});
	});
	
	$(document).ready(function(){
		setGridPosition();
		
		setGridHeadColColor();
		
		$(".tem6_wrap").find(".tem6_search_btn").on("click",function(){
			var $obj = $(".tem6_wrap").find(".tem6_search");
			var $btn = $(this);
			var on = $btn.hasClass("on");
			if(on){
				$btn.removeClass("on");
				$obj.animate({top:0},300);
				$btn.find(".arrow").css({"margin-bottom":"-6px","transform": "rotate(224deg)","webkit-transform": "rotate(224deg)"});
				
				if(commonUtil.checkFn("searchOpenAfter")){
					searchOpenAfter();
				}
			}else{
				var isOpen = true;
				if(commonUtil.checkFn("searchOpenBefore")){
					isOpen = searchOpenBefore();
				}
				
				if(isOpen){
					$btn.addClass("on");
					
					var $content = $obj.find(".tem6_search_content");
					var height = $content.height();
					
					$obj.animate({top:-(height + 2)},300);
					$btn.find(".arrow").css({"margin-bottom":"3px","transform": "rotate(45deg)","webkit-transform": "rotate(45deg)"});
				}
			}
		});
		
		$(".tem6_wrap,.innerLayer").find("select").on("click",function(){
			mobileKeyPad.focusOnEvent($(this));
		});
		
		$("html").click(function(e){
			if($(e.target)[0].tagName != "INPUT" && $(e.target)[0].tagName != "SELECT"){
				$(".tem6_wrap,.innerLayer").find(".focus_in").removeClass("focus_in");
			}
		});
		
		$(".tem6_wrap,.innerLayer").find("input").each(function(){
			var $obj = $(this);
			if($obj[0].type != "hidden"){
				$obj.attr("autocomplete","off");
			}
		});
		
		$("input[readonly=readonly]").addClass("readOnly");
		
		mobileDatePicker.set({
			beforeYear : 10,
			afterYear  : 10,
			yearTitle  : "Year",
			monthTitle : "Month",
			dayTitle   : "Day"
		});
	});
	
	function goMain(){
		var menuid     = parent.frames["topFrame"].contentWindow.g_menuId;
		mobileCommon.confirm({
			message : menuid == "index"?"로그아웃 하시겠습니까?":"메인 화면으로 이동 하시겠습니까?",
			confirm : function(){
				if(menuid == "index"){
					parent.frames["topFrame"].contentWindow.logout();
				}else{
					parent.frames["topFrame"].contentWindow.menuOpen();
					
					parent.frames["topFrame"].contentWindow.openPage("index", "/mobile/info.page");
					parent.frames["topFrame"].contentWindow.setOpenDetailButton(false)
					parent.frames["topFrame"].contentWindow.mainHeadTitle();
				}
			}
		});
		
	}
	
	function setGridPosition(){
		var wrapHeight = $(".tem6_wrap .tem6_content").height();
		var scanHeight = $(".tem6_wrap .tem6_content .scan_area").height();
		
		var gridHeight = wrapHeight - scanHeight;
		var $gridWapper = $(".tem6_wrap .tem6_content .gridArea");
		$gridWapper.css("height",gridHeight - 35);
		
		var $grid = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search");
		$grid.css("height",gridHeight - 70);
		
		mobileKeyPad.gridHeight = gridHeight - 70;
		
		$gridWapper.css("z-index",999);
		
		var $head = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search .tableHeader");
		var gridWidth = $head.find("table").width();
		$head.next().css("width",gridWidth);
		
		var $body = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search .tableBody");
		$body.css("height",$body.height() - 35);
	}
	
	function setGridHeadColColor(){
		var $gridHeadTable = $(".gridArea .tableWrap_search .tableHeader table tr th");
		var $gridTable = $(".gridArea .tableWrap_search .tableBody table tr td");
		if($gridTable.length > 0){
			$gridTable.each(function(){
				var type = $(this).attr("GCol");
				if(type != undefined && type != null && $.trim(type) != ""){
					var colType = type.split(",")[0];
					if(colType == "input"){
						var idx = $(this).index();
						
						var validate = $(this).attr("validate");
						if(validate != undefined && validate != null && $.trim(validate) != ""){
							if(validate.indexOf("required") > -1){
								$gridHeadTable.eq(idx).addClass("inputHeadReqiredCol");
							}else{
								$gridHeadTable.eq(idx).addClass("inputHeadCol");
							}
						}else{
							$gridHeadTable.eq(idx).addClass("inputHeadCol");
						}
					}
				}
			});
		}
	}
	
	function setMenuName(menuId){
		var menuId = "MENU_"+menuId;
		var menuName = uiList.getLabel(menuId,3);
		if(menuName == undefined || menuName == null || menuName == ""){
			menuName = menuId;
		}
		return menuName;
	}
</script>
<%
	String documentTitle = "eWMS";
%>