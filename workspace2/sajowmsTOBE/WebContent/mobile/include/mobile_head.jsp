<%@ page import="project.common.bean.*,project.common.util.*,java.util.*"%>
<%
	DataMap paramDataMap = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	if(paramDataMap == null){
		paramDataMap = new DataMap(request);
	}
	String menuId = paramDataMap.getString(CommonConfig.MENU_ID_KEY);

	String userid = (String)request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	String username = (String)request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY);
	String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
	String deptid = (String)request.getSession().getAttribute(CommonConfig.SES_DEPT_ID_KEY);
	String menukey = (String)request.getSession().getAttribute(CommonConfig.SES_MENU_GROUP_KEY);
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	String ownrky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_KEY);
	String ownrkynm = (String)request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_NM_KEY);
	String wareky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY);
	String warekynm = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY);
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link rel="stylesheet" type="text/css" href="/mobile/css/mobile.css">
<link rel="stylesheet" type="text/css" href="/mobile/css/mobile_content_ui.css">
<link rel="shortcut icon" href="/mobile/images/logo01.png" type="image/x-ico" />
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.custom.js"></script>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-ko.js"></script>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>
<script type="text/javascript" src="/common/js/jquery.form.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/jquery.mousewheel.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.monthpicker.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.timepicker.js"></script>
<script type="text/javascript" src="/common/js/multiple-select.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/big.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/dataRequest.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/layoutSave.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript" src="/mobile/js/mobile_theme.js"></script>
<script type="text/javascript" src="/mobile/js/mobile_head.js"></script>
<script type="text/javascript" src="/common/js/sajoUtil.js"></script>


<script>
$(window).load(function(){
	
	//그리드 높이 조절
	var data_box_height = $(".mobile-data-top .mobile-data-box").outerHeight(true); //검색창의마진을 포함한 높이;
	var mbile_header_height = $(".mbile_header").outerHeight(true); //헤더 마진을 포함한 높이;
	var label_btn_height = $(".label-btn").outerHeight(true); //버튼 마진을 포함한 높이;
	var win_height = window.innerHeight; //창의 실제 height
	var realheight = win_height - (data_box_height + mbile_header_height + label_btn_height + 15); //15는 위아래 패딩값이라고 생각해야함
	$(".mobile-data-box.section").outerHeight(realheight);
	
	//팝업 그리드 높이조절
	var layer_data_box_height = $(".layer_popup .mobile-data-top .mobile-data-box").outerHeight(true); //검색창의마진을 포함한 높이;
	var layer_title_height = $(".layer_popup .layer_title").outerHeight(true); //타이틀 마진을 포함한 높이;
	var layer_label_btn_height = $(".layer_popup .label-btn").outerHeight(true); //버튼 마진을 포함한 높이;
	var layer_realheight = win_height - (layer_data_box_height + layer_title_height + layer_label_btn_height + 15); //15는 위아래 패딩값이라고 생각해야함
	$(".layer_popup .mobile-data-box.section").outerHeight(layer_realheight);
});
</script>
