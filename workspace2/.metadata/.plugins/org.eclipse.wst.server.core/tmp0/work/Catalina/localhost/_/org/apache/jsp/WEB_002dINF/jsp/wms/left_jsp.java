/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.107
 * Generated at: 2021-07-01 08:41:37 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.wms;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import project.common.bean.*;
import java.util.*;

public final class left_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

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
      out.write("\r\n");

	//User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
	//List mlist = user.getMenuList();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
	String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String menugid = (String)request.getSession().getAttribute(CommonConfig.SES_MENU_GROUP_KEY);
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);
	
	String menuSearchId = request.getParameter("menuSearchId");

      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\r\n");
      out.write("<title>index left</title>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/theme/webdek/css/zTreeMenu.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/theme/webdek/css/left_tree.css\"/>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/json2.js\"></script>\r\n");
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
      out.write("<script type=\"text/javascript\" src=\"/common/js/commonUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/netUtil.js\"></script>\r\n");
      out.write("<!-- <link rel=\"stylesheet\" type=\"text/css\" href=\"/common/theme/webdek/css/zTreeStyle_menu.css\"/> -->\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.ztree.core.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.ztree.exedit.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.ztree.excheck.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/tree.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar windowH;//guick menu height 200px ??????\r\n");
      out.write("\t$(\".lnb_wrap\").css(\"height\", \"calc(100vh - 100px)\");\r\n");
      out.write("\t$(window).resize(function() {\r\n");
      out.write("\t\twindowH = $(window).height() - 150//guick menu height 200px ??????\r\n");
      out.write("\t\t$(\".lnb_wrap\").css(\"height\", \"calc(100vh - 100px)\");\r\n");
      out.write("\t\t$(\".guick_menu\").css(\"height\", \"calc(100vh - 100px)\")\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\tvar $menuSearch;\r\n");
      out.write("\tvar lastActiveMenuId;\r\n");
      out.write("\tvar openAllState = true;\r\n");
      out.write("\tvar $treeMenu;\r\n");
      out.write("\t$(document).ready(function(){\r\n");
      out.write("\t\twindowH = $(window).height() - 150;//guick menu height 200px ??????\r\n");
      out.write("\t\twindowH = $(window).height() - 150;//guick menu height 200px ??????\r\n");
      out.write("\t\t$(\".lnb_wrap\").css(\"height\", \"calc(100vh - 100px)\");\r\n");
      out.write("\t\t$(\".guick_menu\").css(\"height\", \"calc(100vh - 100px)\")\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(\".my_menu\").click(function() {\r\n");
      out.write("\t\t\t$(\"#tab2\").css(\"display\",\"block\");\r\n");
      out.write("\t\t\t$(\"#tab1\").css(\"display\",\"none\");\r\n");
      out.write("\t\t\t$(this).removeClass(\"off\").addClass(\"on\");\r\n");
      out.write("\t\t\t$(\".sys_menu\").removeClass(\"on\").addClass(\"off\");\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t  \r\n");
      out.write("\t\t$(\".sys_menu\").click(function() {\r\n");
      out.write("\t\t\t$(\"#tab1\").css(\"display\",\"block\");\r\n");
      out.write("\t\t\t$(\"#tab2\").css(\"display\",\"none\");\r\n");
      out.write("\t\t\t$(this).removeClass(\"off\").addClass(\"on\");\r\n");
      out.write("\t\t\t$(\".my_menu\").removeClass(\"on\").addClass(\"off\");\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//?????? ?????? ????????? \r\n");
      out.write("\t\tvar beforewidth = 0;\r\n");
      out.write("\t\t$(\".lnb_wrap\").scroll(function(){\r\n");
      out.write("\t\t\t$(\"#treeList > li\").css(\"width\",\"280px\");\r\n");
      out.write("\t\t\tvar width = $(\".lnb_wrap\").prop(\"scrollWidth\");\r\n");
      out.write("\t\t\t$(\"#treeList > li\").css(\"width\",width);\r\n");
      out.write("\t\t\tbeforewidth = width;\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(\".sort_box button\").click(function(){\r\n");
      out.write("\t\t\t$(\".sort_box button\").toggleClass(\"slide\");\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//????????????\r\n");
      out.write("\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\r\n");
      out.write(" \t\tvar bgDiv = \"<div class='bgDiv' style='height:\"+wh+\"px;width:\"+ww+\"px;position:absolute;top:-80px;left:0; z-index:-1;background-size:cover; background-color:#D1E5D0;'></div>\";\r\n");
      out.write("//\t\tvar bgDiv = \"<div class='bgDiv' style='height:\"+wh+\"px;width:\"+ww+\"px;position:absolute;top:-80px;left:0; z-index:-1;background:url(/common/theme/webdek/images/web_bg.png) repeat center center;background-size:cover;'></div>\";\r\n");
      out.write("\r\n");
      out.write("\t\t$('body',top.frames[\"left\"].document).append(bgDiv);\r\n");
      out.write("\t\t$('.bgDiv',top.frames[\"left\"].document).css({top:-80+\"px\", left:0 });\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.setTree({\r\n");
      out.write("\t    \tid       : \"treeList\",\r\n");
      out.write("\t    \tmodule   : \"Common\",\r\n");
      out.write("\t\t\tcommand  : \"MENU_TREE\",\r\n");
      out.write("\t\t\tpkCol    : \"MENUID\",\r\n");
      out.write("\t\t    pidCol   : \"PMENUID\",\r\n");
      out.write("\t\t    nameCol  : \"MENULABEL\",\r\n");
      out.write("\t\t    sortCol  : \"SORTORDER\",\r\n");
      out.write("\t\t    editable : false,\r\n");
      out.write("\t\t    isMove   : false,\r\n");
      out.write("\t\t    isCheck  : false\r\n");
      out.write("\t    });\r\n");
      out.write("\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.setTree({\r\n");
      out.write("\t    \tid       : \"treeList1\",\r\n");
      out.write("\t    \tmodule   : \"Common\",\r\n");
      out.write("\t\t\tcommand  : \"FMENU_TREE\",\r\n");
      out.write("\t\t\tpkCol    : \"MENUID\",\r\n");
      out.write("\t\t    pidCol   : \"PMENUID\",\r\n");
      out.write("\t\t    nameCol  : \"MENULABEL\",\r\n");
      out.write("\t\t    sortCol  : \"SORTORDER\",\r\n");
      out.write("\t\t    editable : false,\r\n");
      out.write("\t\t    isMove   : false,\r\n");
      out.write("\t\t    isCheck  : false\r\n");
      out.write("\t    });\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$treeMenu = $(\"#treeList\");\r\n");
      out.write("\t\tsearchList();\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\tfunction searchList(){\r\n");
      out.write("\t\tvar param = new DataMap();\r\n");
      out.write("\t\tparam.put(\"COMPID\",\"");
      out.print(compky);
      out.write("\");\r\n");
      out.write("\t\tparam.put(\"MENUGID\",\"");
      out.print(menugid);
      out.write("\");\r\n");
      out.write("\t\ttreeList.treeList({\r\n");
      out.write("\t\t\tid : \"treeList\",\r\n");
      out.write("\t    \tparam : param\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.treeList({\r\n");
      out.write("\t\t\tid : \"treeList1\",\r\n");
      out.write("\t    \tparam : param\r\n");
      out.write("\t\t});\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t// ?????? ??????\r\n");
      out.write("\tfunction loadingOpen() {\r\n");
      out.write("\r\n");
      out.write("\t\tvar loader = $('<div class=\"contentLoading\"></div>').appendTo('body');\r\n");
      out.write("\r\n");
      out.write("\t\tloader.stop().animate({\r\n");
      out.write("\t\t\ttop : '0px'\r\n");
      out.write("\t\t}, 30, function() {\r\n");
      out.write("\t\t});\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\t// ?????? ??????\r\n");
      out.write("\tfunction loadingClose() {\r\n");
      out.write("\r\n");
      out.write("\t\tvar loader = $('.contentLoading');\r\n");
      out.write("\r\n");
      out.write("\t\tloader.stop().animate({\r\n");
      out.write("\t\t\ttop : '100%'\r\n");
      out.write("\t\t}, 30, function() {\r\n");
      out.write("\t\t\tloader.remove();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction menuOpenAll(){\r\n");
      out.write("\t\tif(openAllState){\r\n");
      out.write("\t\t\topenAllState = false;\r\n");
      out.write("\t\t\ttreeList.openNodeAll(\"treeList\");\t\r\n");
      out.write("\t\t}else{\t\t\t\r\n");
      out.write("\t\t\topenAllState = true;\r\n");
      out.write("\t\t\ttreeList.closeNodeAll(\"treeList\");\r\n");
      out.write("\t\t}\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\tfunction changePage(rowData){\t\r\n");
      out.write("\t\tvar url = rowData.get(\"URI\");\r\n");
      out.write("\t\tvar menuId = rowData.get(\"MENUID\");\r\n");
      out.write("\t\tif(url.indexOf(\"?\") == -1){\r\n");
      out.write("\t\t\turl += \"?\"+configData.COMMON_MENU_ID_KEY+\"=\"+menuId;\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\turl += \"&\"+configData.COMMON_MENU_ID_KEY+\"=\"+menuId;\r\n");
      out.write("\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\tif(url.indexOf(\".page\") == -1){\r\n");
      out.write("\t\t\talert('????????? ???????????????.')\r\n");
      out.write("\t\t\treturn;\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\tvar tmpType = window.top.changePage(rowData.get(\"MENUNAME\"), rowData.get(\"MENULABEL\"), url, menuId);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tlastActiveMenuId = menuId;\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction menuSearch(menuIdp){\r\n");
      out.write("\t\tvar $menuSearch = $(\"#menuSearch\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tif(menuIdp.length > 0){\r\n");
      out.write("\t\t\tmenuIdp = menuIdp.toUpperCase();\r\n");
      out.write("\t\t\t$menuSearch.val(menuIdp);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tvar menuId = $menuSearch.val();\r\n");
      out.write("\t\tmenuId = menuId.toUpperCase();\r\n");
      out.write("\t\t$menuSearch.val(menuId);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.linkPage(\"treeList\", menuId);\r\n");
      out.write("\t\t$menuSearch.val(\"\");\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction checkFmenu(menuId){\r\n");
      out.write("\t\treturn treeList.checkNode(\"treeList1\", menuId);\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction menuSearchSB(){\r\n");
      out.write("\t\tvar $menuSearch = $(\"#menuSearch\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tvar menuId = $menuSearch.val();\r\n");
      out.write("\t\tmenuId = menuId.toUpperCase();\r\n");
      out.write("\t\t$menuSearch.val(menuId);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.linkPage(\"treeList\", menuId);\r\n");
      out.write("\t\t$menuSearch.val(\"\");\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("\tfunction addFmenu(menuId){\r\n");
      out.write("\t\tvar node = treeList.getNode(\"treeList\", menuId);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.addNode(\"treeList1\", node);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tvar param = new DataMap();\r\n");
      out.write("\t\tparam.put(\"COMPID\",\"");
      out.print(compky);
      out.write("\");\r\n");
      out.write("\t\tparam.put(\"MENUGID\",\"");
      out.print(menugid);
      out.write("\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.treeList({\r\n");
      out.write("\t\t\tid : \"treeList1\",\r\n");
      out.write("\t    \tparam : param\r\n");
      out.write("\t\t});\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction deleteFmenu(menuId){\r\n");
      out.write("\t\tvar node = treeList.getNode(\"treeList1\", menuId);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\ttreeList.removeNode(\"treeList1\", node);\r\n");
      out.write("\t}\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<div class=\"left_wrap\">\r\n");
      out.write("\t<div class=\"tab_wrap\"> \r\n");
      out.write("    \t<ul class=\"tabs\">\r\n");
      out.write("\t\t\t<li class=\"tab sys_menu on\">\r\n");
      out.write("\t\t\t\t<h1 class=\"btn_sysmenu\">\r\n");
      out.write("\t\t\t\t\t<a href=\"#tab1\"><span>System Menu</span></a>\t\r\n");
      out.write("\t\t\t\t</h1>\r\n");
      out.write("        \t</li>\r\n");
      out.write("\t        <li class=\"tab my_menu off\">\r\n");
      out.write("\t\t         <h1 class=\"btn_mymenu\">\r\n");
      out.write("\t\t\t\t\t<a href=\"#tab2\"><span>My Menu</span></a>\t\r\n");
      out.write("\t\t\t\t</h1>\r\n");
      out.write("\t        </li>\r\n");
      out.write("    \t</ul>\r\n");
      out.write(" \t\t<div class=\"tab_container\">\r\n");
      out.write("\t\t    <fieldset>\r\n");
      out.write("\t\t\t\t<legend>search</legend>\r\n");
      out.write("\t\t\t\t<p class=\"search_box\">\r\n");
      out.write("\t\t\t\t\t<input type=\"text\" class=\"serch_input serch_input_change\" id=\"menuSearch\" placeholder=\"??????????????? ????????? ?????????.\" onkeypress=\"commonUtil.enterKeyCheck(event,'menuSearch(this)')\"/>\r\n");
      out.write("\t\t\t\t\t<button type=\"button\" class=\"btn btn_search btn_search_change\" onclick=\"menuSearchSB()\"><span>??????????????? ????????? ?????????.</span></button>\r\n");
      out.write("\t\t\t\t\t<div class=\"sort_box sort_box_change\">\r\n");
      out.write("\t\t\t\t\t\t<button type=\"button\" class=\"btn_asc\" onclick=\"menuOpenAll(this)\"></button>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</p>\t\t\r\n");
      out.write("\t\t\t</fieldset>\t\r\n");
      out.write("\t\t\t<div id=\"tab1\" class=\"tab_content\">\t\r\n");
      out.write("\t\t\t\t<div class=\"lnb_wrap\">\r\n");
      out.write("\t\t\t\t\t<ul id=\"treeList\" style=\"width:100%;height:100%;\"></ul>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\t\r\n");
      out.write("\t\t\t<div id=\"tab2\" class=\"tab_content\" style=\"display:none;\">\r\n");
      out.write("\t\t\t\t<div class=\"guick_menu\">\r\n");
      out.write("\t\t\t\t\t<ul id=\"treeList1\" style=\"width:100%;height:100%;\"></ul>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t \t\t</div> \r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar $menuList = $(\"#menuList\");\r\n");
      out.write("\t$menuList.show();\r\n");
      out.write("</script>\r\n");
      out.write("<!-- // left_wrap -->\r\n");
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
