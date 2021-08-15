/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.107
 * Generated at: 2021-08-06 01:56:08 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.mobile;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import project.common.bean.*;
import project.common.util.*;
import java.util.*;

public final class MDL12_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(3);
    _jspx_dependants.put("/mobile/include/mtop.jsp", Long.valueOf(1623374592575L));
    _jspx_dependants.put("/mobile/include/msubmenu.jsp", Long.valueOf(1623374592560L));
    _jspx_dependants.put("/mobile/include/mobile_head.jsp", Long.valueOf(1624008020312L));
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<meta charset=\"utf-8\" name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\r\n");
      out.write('\r');
      out.write('\n');

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

      out.write("\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n");
      out.write("<META HTTP-EQUIV=\"Expires\" CONTENT=\"Mon, 06 Jan 1990 00:00:01 GMT\">\r\n");
      out.write("<META HTTP-EQUIV=\"Expires\" CONTENT=\"-1\">\r\n");
      out.write("<META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\r\n");
      out.write("<META HTTP-EQUIV=\"Cache-Control\" CONTENT=\"no-cache\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/mobile/css/mobile.css\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/mobile/css/mobile_content_ui.css\">\r\n");
      out.write("<link rel=\"shortcut icon\" href=\"/mobile/images/logo01.png\" type=\"image/x-ico\" />\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery-ui.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery-ui.custom.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/datepicker/jquery.ui.datepicker-ko.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.plugin.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.form.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.cookie.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.mousewheel.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.ui.monthpicker.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.ui.timepicker.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/multiple-select.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/json2.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/big.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataMap.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/configData.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/label.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/label-");
      out.print(langky);
      out.write(".js?v=");
      out.print(System.currentTimeMillis());
      out.write("\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/message-");
      out.print(langky);
      out.write(".js?v=");
      out.print(System.currentTimeMillis());
      out.write("\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/site.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/commonUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataBind.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/input.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/netUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/ui.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/worker-ajax.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/bigdata.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataRequest.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/grid.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/layoutSave.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/validateUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/page.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/mobile/js/mobile_theme.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/mobile/js/mobile_head.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/sajoUtil.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script>\r\n");
      out.write("$(window).load(function(){\r\n");
      out.write("\t\r\n");
      out.write("\t//ê·¸ë¦¬ë ëì´ ì¡°ì \r\n");
      out.write("\tvar data_box_height = $(\".mobile-data-top .mobile-data-box\").outerHeight(true); //ê²ìì°½ìë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar mbile_header_height = $(\".mbile_header\").outerHeight(true); //í¤ë ë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar label_btn_height = $(\".label-btn\").outerHeight(true); //ë²í¼ ë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar win_height = window.innerHeight; //ì°½ì ì¤ì  height\r\n");
      out.write("\tvar realheight = win_height - (data_box_height + mbile_header_height + label_btn_height + 15); //15ë ììë í¨ë©ê°ì´ë¼ê³  ìê°í´ì¼í¨\r\n");
      out.write("\t$(\".mobile-data-box.section\").outerHeight(realheight);\r\n");
      out.write("\t\r\n");
      out.write("\t//íì ê·¸ë¦¬ë ëì´ì¡°ì \r\n");
      out.write("\tvar layer_data_box_height = $(\".layer_popup .mobile-data-top .mobile-data-box\").outerHeight(true); //ê²ìì°½ìë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar layer_title_height = $(\".layer_popup .layer_title\").outerHeight(true); //íì´í ë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar layer_label_btn_height = $(\".layer_popup .label-btn\").outerHeight(true); //ë²í¼ ë§ì§ì í¬í¨í ëì´;\r\n");
      out.write("\tvar layer_realheight = win_height - (layer_data_box_height + layer_title_height + layer_label_btn_height + 15); //15ë ììë í¨ë©ê°ì´ë¼ê³  ìê°í´ì¼í¨\r\n");
      out.write("\t$(\".layer_popup .mobile-data-box.section\").outerHeight(layer_realheight);\r\n");
      out.write("});\r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("var input = '';\r\n");
      out.write("var mode = '';\r\n");
      out.write("\t$(document).ready(function(){\r\n");
      out.write("\t\tgridList.setGrid({\r\n");
      out.write("\t    \tid : \"gridList\",\r\n");
      out.write("\t\t\tmodule : \"MobileOutbound\",\r\n");
      out.write("\t\t\tcommand : \"MDL12\",\r\n");
      out.write("\t\t\tgridMobileType : true\r\n");
      out.write("\t    });\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(\"#BARCODE\").keyup(function(e){if(e.keyCode == 13)searchList();});\r\n");
      out.write("\t\t$(\"#BARCODE\").focus();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//검색값 클릭시 초기화\r\n");
      out.write("\t\t$(\"#BARCODE\").click(function(){$(this).select()}); \r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//가상키보드 제어\r\n");
      out.write("\t\t$('input').attr(\"inputmode\",\"none\");\r\n");
      out.write("\t\tinput = \"#BARCODE\";\r\n");
      out.write("\r\n");
      out.write("\t\t$('#searchArea input').focus(function(){\r\n");
      out.write("\t\t\tinput = this;\r\n");
      out.write("\t\t\tif(mode != 'key'){\r\n");
      out.write("\t\t\t\t$(this).attr(\"inputmode\",\"none\")\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif($(this).hasClass(\"calendarInput\") == false && $(this).prop(\"readonly\") == false && $(this).prop(\"type\") != \"button\" && mode != 'key'){\r\n");
      out.write("\t\t\t\t$('#keyboardBtn').fadeIn(\"fast\");\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tmode = 'none'\r\n");
      out.write("\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t$('#searchArea input').blur(function(){\r\n");
      out.write("\t\t\tvar input = this;\r\n");
      out.write("\t\t\t$('#keyboardBtn').fadeOut(\"fast\");\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$('#keyboardBtn').click(function(){\r\n");
      out.write("\t\t\tmode = 'key';\r\n");
      out.write("\t\t\t$('#keyboardBtn').fadeOut(\"fast\");\r\n");
      out.write("\t\t\t$(input).attr(\"inputmode\",\"text\");\r\n");
      out.write("\t\t\t$(input).focus();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t});\r\n");
      out.write("\r\n");
      out.write("\tfunction searchList(){\r\n");
      out.write("\t\tif(validate.check(\"searchArea\")){\r\n");
      out.write("\t\t\tvar param = inputList.setRangeParam(\"searchArea\");\r\n");
      out.write("\t\t\tparam.put(\"OWNRKY\", \"");
      out.print(ownrky);
      out.write("\");\r\n");
      out.write("\t\t\tparam.put(\"WAREKY\", \"");
      out.print(wareky);
      out.write("\");\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tgridList.gridList({\r\n");
      out.write("\t\t    \tid : \"gridList\",\r\n");
      out.write("\t\t    \tparam : param\r\n");
      out.write("\t\t    });\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t$(\"#WORKSUM2\").val(\"\");\r\n");
      out.write("\t\t\t// 검색조건 선택후 블러처리\r\n");
      out.write("\t\t\t$(\"#BARCODE\").focus();\r\n");
      out.write("\t\t\t$(\"#BARCODE\").select();\r\n");
      out.write("\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\t\r\n");
      out.write("\r\n");
      out.write("\t//그리드 바인드 후\r\n");
      out.write("\tfunction gridListEventDataBindEnd(gridId, dataCount){\r\n");
      out.write("\t\tif(gridId == \"gridList\" && dataCount > 0){\r\n");
      out.write("\t\t\tcalTotal();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t//합계 계산\r\n");
      out.write("\tfunction calTotal(){\r\n");
      out.write("\t\tvar worksum1 = 0;\r\n");
      out.write("\t\tvar worksum2 = 0;\r\n");
      out.write("\t\tvar list = gridList.getSelectData(\"gridList\");\r\n");
      out.write("\t\tvar list2 = gridList.getGridData(\"gridList\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//선택 합계\r\n");
      out.write("\t\tfor(var i=0; i<list.length; i++){\r\n");
      out.write("\t\t\tvar gridMap = list[i].map;\r\n");
      out.write("\t\t\tworksum1 = worksum1+(Number)(gridList.getColData(\"gridList\", list[i].get(\"GRowNum\"), \"QTYWRK\"));\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//총 합계\r\n");
      out.write("\t\tfor(var i=0; i<list2.length; i++){\r\n");
      out.write("\t\t\tvar gridMap = list2[i].map;\r\n");
      out.write("\t\t\tworksum2 = worksum2+(Number)(gridList.getColData(\"gridList\", list2[i].get(\"GRowNum\"), \"QTSIWH\"));\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(\"#WORKSUM1\").val(worksum1);\r\n");
      out.write("\t\t$(\"#WORKSUM2\").val(worksum2);\r\n");
      out.write("\t} \r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("\t");
      out.write("\t\r\n");
      out.write("\t<script type=\"text/javascript\">\r\n");
      out.write("\t\t$(document).ready(function(){\r\n");
      out.write("\t\t    \r\n");
      out.write("\t\t    searchwareky('");
      out.print(ownrky );
      out.write("');\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\t$(\"#WAREKY\").val('");
      out.print(wareky );
      out.write("').prop(\"selected\", true);\t\r\n");
      out.write("\t\t\tdrawMenu();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\r\n");
      out.write("\t\t$(function(){\t\r\n");
      out.write("\t\t\t$('.submenu_all').click(function(){\r\n");
      out.write("\t\t\t\t$('.mobile_submenu').animate({left:0},400);\r\n");
      out.write("\t\t\t\t$('.mobile_submenu .back').css({'display': 'block', 'opacity': 0}).animate({'opacity': 0.6}, 300);\r\n");
      out.write("\t\t    });\r\n");
      out.write("\t\t\t$('.mobile_submenu_close').click(function(){\r\n");
      out.write("\t\t\t\t$('.mobile_submenu').animate({left:'-100%'},400);\r\n");
      out.write("\t\t\t\t$('.mobile_submenu .back').animate({'opacity': 0}, 300, function(){\r\n");
      out.write("\t\t\t\t\t$(this).css({'display' : 'none'});\r\n");
      out.write("\t\t\t\t});\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//로그아웃\r\n");
      out.write("\t\tfunction logout(){\r\n");
      out.write("\t\t\tlocation.href = \"/mobile/json/logout.page\";\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//거점 콤보 \r\n");
      out.write("\t\tfunction searchwareky(val){\r\n");
      out.write("\t\t\tvar param = new DataMap();\r\n");
      out.write("\t\t\tparam.put(\"OWNRKY\",val);\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tvar json = netUtil.sendData({\r\n");
      out.write("\t\t\t\tmodule : \"SajoCommon\",\r\n");
      out.write("\t\t\t\tcommand : \"LOGIN_WAREKY_COMCOMBO\",\r\n");
      out.write("\t\t\t\tsendType : \"list\",\r\n");
      out.write("\t\t\t\tparam : param\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t$(\"#WAREKY\").find(\"[UIOption]\").remove();\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tvar optionHtml = inputList.selectHtml(json.data, false);\r\n");
      out.write("\t\t\t$(\"#WAREKY\").append(optionHtml);\r\n");
      out.write("\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//거점 체인지(세션변경)\r\n");
      out.write("\t\tfunction warekyChange(){\r\n");
      out.write("\t\t\tvar param = new DataMap();\r\n");
      out.write("\t\t\tparam.put(\"WAREKY\", $(\"#WAREKY\").val());\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\tvar json = netUtil.sendData({\r\n");
      out.write("\t\t\t\turl : \"/mobile/json/changeSession.data\",\r\n");
      out.write("\t\t\t\tparam : param\r\n");
      out.write("\t\t\t}); \r\n");
      out.write("\r\n");
      out.write("\t\t\tif(json && json.data){\r\n");
      out.write("\t\t\t\tlocation.reload();\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//메뉴 그리기\r\n");
      out.write("\t\tfunction drawMenu(){\r\n");
      out.write("\t\t\tvar param = new DataMap();\r\n");
      out.write("\t\t\tparam.put(\"MENUKEY\", \"");
      out.print(menukey );
      out.write("\");\r\n");
      out.write("\r\n");
      out.write("\t\t\tvar json = netUtil.sendData({\r\n");
      out.write("\t\t\t\tmodule : \"SajoCommon\",\r\n");
      out.write("\t\t\t\tcommand : \"MOBILE_MENU\",\r\n");
      out.write("\t\t\t\tsendType : \"list\",\r\n");
      out.write("\t\t\t\tparam : param\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\r\n");
      out.write("\t\t\tif(json && json.data){\r\n");
      out.write("\t\t\t\tvar list = json.data;\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("// \t\t\t\tvar btnCtn = 2;\r\n");
      out.write("\t\t\t\tvar innerHTML = \"\";\r\n");
      out.write("\t\t\t\tvar innerMain = \"\";\r\n");
      out.write("\t\t\t\tvar subcnt = 0;\r\n");
      out.write("\t\t\t\tfor(var i=0; i<list.length; i++){\r\n");
      out.write("\t\t\t\t\tvar menuNm = list[i].MENUNAME;\r\n");
      out.write("\t\t\t\t\tvar menuLb = list[i].MENULABEL;\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\tif(list[i].LV == 1){//대메뉴\r\n");
      out.write("\t\t\t\t\t\tif(i!=0){ //탭마감\r\n");
      out.write("\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\tinnerHTML+='\t</ul>';\r\n");
      out.write("\t\t\t\t\t\t\tinnerHTML+='</li>';\r\n");
      out.write("\t\t\t\t\t\t\tif(subcnt%2 == 1){\r\n");
      out.write("\t\t\t\t\t\t\t\tinnerMain+='<button style=\"background-color:rgb(255,255,255);\"></button>';\r\n");
      out.write("\t\t\t\t\t\t\t\tsubcnt = 0;\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\tinnerMain+='</div>';\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\tinnerHTML+='<li class=\"msubmenu_nav2\">';\r\n");
      out.write("\t\t\t\t\t\tinnerHTML+='\t<a href=\"#\"class=\"botton_lines click_nav\">'+menuNm+'<span class=\"icons\"></span></a>';\r\n");
      out.write("\t\t\t\t\t\tinnerHTML+='\t<ul class=\"msubmenu_nav2_1\">';\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("// \t\t\t\t\t\tinnerMain+='<input type=\"checkbox\" id=\"button'+btnCtn+'\">';\r\n");
      out.write("// \t\t\t\t\t\tinnerMain+='<label class=\"mainmeun\" for=\"button'+btnCtn+'\">'+menuNm+'<span></span></label>';\r\n");
      out.write("// \t\t\t\t\t\tinnerMain+='<p class=\"mobile_meun_button mobile_meun_button'+btnCtn+'\">';\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\tvar dbtnCtn = parseInt(list[i].SORT.substr(0,1)) + 1;\r\n");
      out.write("\t\t\t\t\t\tinnerMain+='<input type=\"checkbox\" id=\"button'+dbtnCtn+'\">';\r\n");
      out.write("\t\t\t\t\t\tinnerMain+='<label class=\"mainmeun\" for=\"button'+dbtnCtn+'\">'+menuNm+'<span></span></label>';\r\n");
      out.write("\t\t\t\t\t\tinnerMain+='<div class=\"mobile_meun_button mobile_meun_button'+dbtnCtn+'\">';\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("// \t\t\t\t\t\tbtnCtn+=1;\r\n");
      out.write("\t\t\t\t\t}else{\r\n");
      out.write("\t\t\t\t\t\tvar uri = list[i].URI;\r\n");
      out.write("\t\t\t\t\t\tvar img = \"background:url(\"+list[i].IMGPTH+\")no-repeat;\";\r\n");
      out.write("\t\t\t\t\t\tvar dbtnCtn = parseInt(list[i].SORT.substr(0,1)) + 1;\r\n");
      out.write("\t\t\t\t\t\t//소메뉴\r\n");
      out.write("\t\t\t\t\t\tinnerHTML+='<li><span class=\"icon\" style=\"'+img+'\">'\r\n");
      out.write("\t\t\t\t\t\tinnerHTML+='</span><a href=\"'+uri+'\">'+menuNm+'</a></li>';\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\tinnerMain+='<button onClick=\"location.href=\\''+uri+'\\'\" ><span class=\"iconImg\" style=\"'+img+'\"></span><span class=\"lbNm\">'+menuLb+'</span></button>';\r\n");
      out.write("// \t\t\t\t\t\tbackground:url(/mobile/images/mobile_ico/m-ico-201.png)no-repeat center;\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\tsubcnt++;\r\n");
      out.write("\t\t\t\t\t\tif(i+1 == list.length){\r\n");
      out.write("\t\t\t\t\t\t\tif(subcnt%2 == 1){\r\n");
      out.write("\t\t\t\t\t\t\t\tinnerMain+='<button style=\"background-color:rgb(255,255,255);\"></button>';\r\n");
      out.write("\t\t\t\t\t\t\t\tsubcnt = 0;\r\n");
      out.write("\t\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\tinnerMain+='</div>';\r\n");
      out.write("\t\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\t\r\n");
      out.write("\t\t\t\t} \r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t\t$(\"#menuDiv\").html(innerHTML);\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\tif($(\"#mainMenu\")){\r\n");
      out.write("\t\t\t\t\t$(\"#mainMenu\").html(innerMain);\t\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t//이벤트 적용   //메뉴 화살표 아이콘 on off                                                               \r\n");
      out.write("\t\t\t    $(\".msubmenu_nav .click_nav\").click(function(){\r\n");
      out.write("\t\t\t        var submenu = $(this).next(\".msubmenu_nav2_1\");\r\n");
      out.write("\t\t\t        var icon = $(this).children(\".icons\");\r\n");
      out.write("\r\n");
      out.write("\t\t\t        if( submenu.is(\":visible\") ){\r\n");
      out.write("\t\t\t            submenu.slideUp();\r\n");
      out.write("\t\t\t            icon.css({'transform':'rotate(90deg)'})\r\n");
      out.write("\r\n");
      out.write("\t\t\t        }else{\r\n");
      out.write("\t\t\t            submenu.slideDown();\r\n");
      out.write("\t\t\t            icon.css({'transform':'rotate(-90deg)'})\r\n");
      out.write("\t\t\t        } \r\n");
      out.write("\t\t\t    });\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t</script>\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"mobile_submenu\">\r\n");
      out.write("\t\t<div class=\"back mobile_submenu_close\"></div>\r\n");
      out.write("\t\t<div class=\"contents\" >\r\n");
      out.write("\t\t\t<div class=\"contImgArea\">\r\n");
      out.write("\t\t\t\t<p class=\"imgArea\">\r\n");
      out.write("\t\t\t\t\t<span><a href=\"/mobile/main.page\"><img src=\"/mobile/images/sajo-wms0.png\" alt=\"logo\" title=\"webdek\" /></a></span>\r\n");
      out.write("\t\t\t\t\t<span class=\"mobile_submenu_close\"></span>\r\n");
      out.write("\t\t\t\t</p>\r\n");
      out.write("\t\t\t\t<p class=\"userStatus\" id=\"logout\">\r\n");
      out.write("\t\t\t\t\t<span class=\"nameArea\">");
      out.print(username );
      out.write("님, 안녕하세요.</span>\r\n");
      out.write("\t\t\t\t</p>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"contWhare\">\r\n");
      out.write("\t\t\t\t<p id=\"ownrky\"><span>[");
      out.print(ownrky );
      out.write(']');
      out.print(ownrkynm );
      out.write("</span></p>\r\n");
      out.write("\t\t\t\t<form>\r\n");
      out.write("\t\t\t\t\t<select name=\"select\" id=\"WAREKY\" onchange=\"warekyChange()\">\r\n");
      out.write("\t\t\t\t\t\t<option value=\"거점\">거점을 선택해주세요</option>\r\n");
      out.write("\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t</form>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"container\">\r\n");
      out.write("\t\t\t\t<!-- <p class=\"userStatus\" id=\"login\"><button onClick=\"location.href='/mobile/index.page'\">로그인</button></p> -->\r\n");
      out.write("\t\t\t\t<ul class=\"msubmenu_nav\" id=\"menuDiv\">\r\n");
      out.write("\t\t\t\t\t<!-- <li class=\"msubmenu_nav2\">\r\n");
      out.write("\t\t\t\t\t\t<a href=\"#\"class=\"botton_lines click_nav\">grid<span class=\"icons\"></span></a>\r\n");
      out.write("\t\t\t\t\t\t<ul class=\"msubmenu_nav2_1\">\r\n");
      out.write("\t\t\t\t\t\t\t<li><span class=\"icon\"></span><a href=\"/demo/mobile/gridSingle.page\">메뉴1</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t<li><span class=\"icon\"></span><a>메뉴2</a></li>\r\n");
      out.write("\t\t\t\t\t\t</ul>\r\n");
      out.write("\t\t\t\t\t</li>\r\n");
      out.write("\t\t\t\t\t<li><a href=\"#\"class=\"botton_lines click_nav\">input<span class=\"icons\"></span></a>\r\n");
      out.write("\t\t\t\t\t\t<ul class=\"msubmenu_nav2_1\">\r\n");
      out.write("\t\t\t\t\t\t\t<li><span class=\"icon\"></span><a href=\"/demo/mobile/input.page\">메뉴1</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t<li><span class=\"icon\"></span><a>메뉴2</a></li>\r\n");
      out.write("\t\t\t\t\t\t</ul>\r\n");
      out.write("\t\t\t\t\t</li> -->\r\n");
      out.write("\t\t\t\t</ul>\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t\t<div class=\"btnLog\">\r\n");
      out.write("\t\t\t\t\t<span><a href=\"/mobile/main.page\"><img src=\"/sajo/images/sajo_wms02.png\" alt=\"logo\" title=\"webdek\" /></a></span>\r\n");
      out.write("\t\t\t\t\t<button onClick=\"logout()\">로그아웃</button>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>");
      out.write("\r\n");
      out.write("\t<div class=\"mobile_order\">\r\n");
      out.write("\t\t");
      out.write("\t<script>\r\n");
      out.write("\t $(function(){\r\n");
      out.write("\t\t $(\".mobile-data-color li\").click(function(){\r\n");
      out.write("\t\t\tvar tabType = $(this).index();\r\n");
      out.write("\t\t\t$('.mobile-data').hide();\r\n");
      out.write("\t\t\t$('.mobile-data').eq(tabType).show();\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tif( tabType > 0) {\r\n");
      out.write("\t\t\t\t$('.mobile-data-color li').eq(1).css({'color':'#ea552b'});\r\n");
      out.write("\t\t\t}else {\r\n");
      out.write("\t\t\t\t$('.mobile-data-color li').eq(1).css({'color':'#666666'});\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif( tabType > 1) {\r\n");
      out.write("\t\t\t\t$('.mobile-data-color li').eq(2).css({'color':'#ea552b'});\r\n");
      out.write("\t\t\t}else  {\r\n");
      out.write("\t\t\t\t$('.mobile-data-color li').eq(2).css({'color':'#666666'});\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif( tabType > 0) {\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(0).css({'display':'none'});\r\n");
      out.write("\t\t\t}else {\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(0).css({'display':'block'});\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif( tabType > 1) {\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(1).css({'display':'none'});\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(2).css({'display':'none'});\r\n");
      out.write("\t\t\t}else {\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(1).css({'display':'block'});\r\n");
      out.write("\t\t\t\t$('.label-btn label').eq(2).css({'display':'block'});\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}); \r\n");
      out.write("\t\t\r\n");
      out.write("\t\t/* $('.mobile-departure').show();\r\n");
      out.write("\t\t$('label[for=\"data1\"]').click(function(){\r\n");
      out.write("\t\t\t$(this).hide();\r\n");
      out.write("\t\t\t$('label[for=\"data2\"]').show();\r\n");
      out.write("\t\t\t$('label[for=\"data3\"]').show();\r\n");
      out.write("\t\t\t$('.mobile-data-color li').eq(1).css({'color':'#ea552b'});\r\n");
      out.write("\t\t\t$('.mobile-data').hide();\r\n");
      out.write("\t\t\t$('.mobile-data').eq(1).show();\r\n");
      out.write("\t\t}); */\r\n");
      out.write("\t\t$('label[for=\"data3\"]').click(function(){\r\n");
      out.write("\t\t\t$('label[for=\"data2\"],label[for=\"data3\"]').hide();\r\n");
      out.write("\t\t\t$('label[for=\"data4\"],label[for=\"data5\"]').show();\r\n");
      out.write("\t\t\t$('.mobile-data-color li').eq(2).css({'color':'#ea552b'});\r\n");
      out.write("\t\t\t$('.mobile-data').hide();\r\n");
      out.write("\t\t\t$('.mobile-data').eq(2).show();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t$('label[for=\"data2\"]').click(function(){\r\n");
      out.write("\t\t\t$(this).hide();\r\n");
      out.write("\t\t\t$('label[for=\"data1\"]').show();\r\n");
      out.write("\t\t\t$('.mobile-data-color li').eq(1).css({'color':'#666666'});\r\n");
      out.write("\t\t\t$('.mobile-data').hide();\r\n");
      out.write("\t\t\t$('.mobile-data').eq(0).show();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t$('label[for=\"data4\"]').click(function(){\r\n");
      out.write("\t\t\t$('label[for=\"data4\"],label[for=\"data5\"]').hide();\r\n");
      out.write("\t\t\t$('label[for=\"data2\"],label[for=\"data3\"]').show();\r\n");
      out.write("\t\t\t$('.mobile-data-color li').eq(2).css({'color':'#666666'});\r\n");
      out.write("\t\t\t$('.mobile-data').hide();\r\n");
      out.write("\t\t\t$('.mobile-data').eq(1).show();\r\n");
      out.write("\t\t});\r\n");
      out.write(" \t}); \r\n");
      out.write("\t</script>\r\n");
      out.write("    <div class=\"mbile_header\">\r\n");
      out.write("\t\t<button class=\"submenu_all\"><img src=\"/mobile/images/mobile-menu02.png\" /></button>\r\n");
      out.write("\t\t<button class=\"mobile-user\"><a href=\"/mobile/main.page\"><img src=\"/sajo/images/sajo_wms02.png\" /></a></button>\r\n");
      out.write("\t\t<!-- <button class=\"mobile-user\"><img src=\"/redeess/images/mobile-user.png\" /></button> -->\r\n");
      out.write("\t</div>\r\n");
      out.write("    ");
      out.write("\r\n");
      out.write("\t\t<div class=\"m_menutitle\"><span>재고보충관리</span></div>\r\n");
      out.write("\t\t<div class=\"mobile-data-top\">\r\n");
      out.write("\t\t\t<div class=\"mobile-data-box\">\r\n");
      out.write("\t\t\t\t<div class=\"content_layout_wrap\" id=\"searchArea\">\r\n");
      out.write("\t\t\t\t\t<table>\r\n");
      out.write("\t\t\t\t\t\t<tbody>\r\n");
      out.write("\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th CL=\"STD_SKUKEY\">제품코드<span class=\"make\">*</span></th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<td><input type=\"text\" id=\"BARCODE\" name=\"BARCODE\" class=\"input input-width\" ></td>\r\n");
      out.write("\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th CL=\"STD_TASKDT\">작업지시일<span class=\"make\"></span></th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<td><input type=\"text\" id=\"DOCDAT\" name=\"DOCDAT\" class=\"input input-width\" UIFormat=\"C N\" validate=\"STD_TASKDT\"></td>\r\n");
      out.write("\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t</tbody>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\t\t\r\n");
      out.write("\t\t<div class=\"mobile-data-inner\">\r\n");
      out.write("\t\t\t<div class=\"mobile-data mobile-departure content_layout\" >\r\n");
      out.write("\t\t\t\t<div class=\"mobile-data-box section\" style=\"height:calc(100vh - 200px);\">\r\n");
      out.write("\t\t\t\t\t<div class=\"scroll\" style=\"width:100%;height: calc(100% - 30px);overflow:auto;white-space: nowrap;\">\r\n");
      out.write("\t\t\t\t\t\t<table>\r\n");
      out.write("\t\t\t\t\t\t\t<tbody id=\"gridList\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<tr CGRow=\"true\">     \r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"110 STD_CARDAT\" GCol=\"text,CARDAT\" GF=\"D 90\">배송일자</td>\t<!--배송일자-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"88 STD_SHIPSQ\" GCol=\"text,SHIPSQ\" GF=\"N 60,0\">배송차수</td>\t<!--배송차수-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"160 STD_SKUKEY\" GCol=\"text,SKUKEY\" GF=\"S 20\">제품코드</td>\t<!--제품코드-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"200 STD_DESC01\" GCol=\"text,DESC01\" GF=\"S 60\">제품명</td>\t<!--제품명-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"80 STD_STATITNM\" GCol=\"text,STATITNM\" GF=\"S 20\">상태명</td>\t<!--상태명-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"160 STD_LOCASR\" GCol=\"text,LOCASR\" GF=\"S 20\">로케이션</td>\t<!--로케이션-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"160 STD_LOCATG\" GCol=\"text,LOCATG\" GF=\"S 20\">To 로케이션</td>\t<!--To 로케이션-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"80 STD_QTTAOR\" GCol=\"text,QTTAOR\" GF=\"N 20,0\">작업수량</td>\t<!--작업수량-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"80 STD_PLTQTY\" GCol=\"text,PLTQTY\" GF=\"N 17,2\">팔레트수량</td>\t<!--팔레트수량-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"80 STD_BOXQTY\" GCol=\"text,BOXQTY\" GF=\"N 17,1\">박스수량</td>\t<!--박스수량-->\r\n");
      out.write("\t\t    \t\t\t\t\t\t<td GH=\"80 STD_REMQTY\" GCol=\"text,REMQTY\" GF=\"N 17,0\">잔량</td>\t<!--잔량-->\r\n");
      out.write("\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t\t</tbody>\r\n");
      out.write("\t\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"tableUtil\">\r\n");
      out.write("\t\t\t\t\t\t<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"label-btn\">\r\n");
      out.write("\t\t\t\t<!-- 버튼 1개 시에는 id=\"long\" 2개일떄는 half 3개일떄 threeP 4개일때 quarter -->\r\n");
      out.write("\t\t\t\t<label id=\"half\" onClick=\"searchList()\">검색</label>\r\n");
      out.write("\t\t\t\t<label id=\"half\" onClick=\"window.location.reload()\">초기화</label>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"keyboardBtn\">키보드열기</div>\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
