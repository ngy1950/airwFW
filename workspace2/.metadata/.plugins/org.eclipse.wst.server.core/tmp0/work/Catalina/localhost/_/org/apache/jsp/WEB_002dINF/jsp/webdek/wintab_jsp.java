/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.107
 * Generated at: 2021-07-09 01:24:37 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.webdek;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import project.common.bean.CommonConfig;

public final class wintab_jsp extends org.apache.jasper.runtime.HttpJspBase
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

	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);

	String color =(String)request.getSession().getAttribute("COLOR");

      out.write("\r\n");
      out.write("<!doctype html>\r\n");
      out.write("<html lang=\"ko\">\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n");
      out.write("<meta charset=\"utf-8\">\r\n");
      out.write("<title></title>\r\n");
      out.write("<meta name=\"viewport\" content=\"width=1150\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common/theme/webdek/css/wintab.css\"/>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataMap.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/configData.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/commonUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/netUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/ui.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar $multiList;\r\n");
      out.write("\tvar $tabObj;\r\n");
      out.write("\tvar $pathTitle;\r\n");
      out.write("\tvar $winTabLeft;\r\n");
      out.write("\tvar $winTabRight;\r\n");
      out.write("\t\r\n");
      out.write("\tvar tabBtnView = false;\r\n");
      out.write("\tvar windTabWidth;\r\n");
      out.write("\tvar activeIndex;\r\n");
      out.write("\tvar activeMenuid;\r\n");
      out.write("\tvar $liList;\r\n");
      out.write("\tvar $addFbtn;\r\n");
      out.write("\tvar $deleteFbtn;\r\n");
      out.write("\t$(document).ready(function(){\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(document.body).show();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$multiList = jQuery(\"#multiList\");\r\n");
      out.write("\t\t$tabObj = $multiList.find(\"li\").clone();\r\n");
      out.write("\t\t$multiList.find(\"li\").remove();\r\n");
      out.write("\t\t$pathTitle = $(\"#pathTitle\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tuiList.UICheck();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$winTabLeft = $(\"#winTabLeft\");\r\n");
      out.write("\t\t$winTabRight = $(\"#winTabRight\");\r\n");
      out.write("\t\t//2021.06.08 좌우버튼 show 수정  \r\n");
      out.write("// \t\t$winTabLeft.hide(); \r\n");
      out.write("// \t\t$winTabRight.hide();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$winTabLeft.show();\r\n");
      out.write("\t\t$winTabRight.show();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$addFbtn = $(\".btn_fav_before\");\r\n");
      out.write("\t\t$deleteFbtn = $(\".btn_fav_after\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$addFbtn.hide();\r\n");
      out.write("\t\t$deleteFbtn.hide();\r\n");
      out.write("\t});\r\n");
      out.write("\t$(window).resize(function(event){\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t});\r\n");
      out.write("\tfunction sizeToggle(self){\r\n");
      out.write("\t\twindow.top.sizeToggle();\r\n");
      out.write("\t}\r\n");
      out.write("\t/*\r\n");
      out.write("\tfunction setPathTitle(pathTitle){\r\n");
      out.write("\t\treturn;\r\n");
      out.write("\t\tif(pathTitle.length > 50){\r\n");
      out.write("\t\t\tpathTitle = \" \";\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t$pathTitle.text(pathTitle);\r\n");
      out.write("\t}\t\r\n");
      out.write("\t*/\r\n");
      out.write("\tfunction activeTab($tab){\r\n");
      out.write("\t\t$multiList.find(\"li\").removeClass(\"selected\");\r\n");
      out.write("\t\t$tab.addClass(\"selected\");\r\n");
      out.write("\t\tvar menuId = $tab.attr(\"menuId\");\r\n");
      out.write("\t\tactiveMenuid = menuId;\r\n");
      out.write("\t\twindow.top.changeWindow(menuId);\r\n");
      out.write("\t\tviewFbtn();\r\n");
      out.write("\t\t//var pathTitle = $tab.attr(\"pathTitle\");\r\n");
      out.write("\t\t//setPathTitle(pathTitle);\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction changeWindow(menuId){\r\n");
      out.write("\t\tvar $tab = $multiList.find(\"[menuId=\"+menuId+\"]\");\r\n");
      out.write("\t\tif($tab.hasClass(\"selected\")){\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\tactiveTab($tab);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction closeWindow(menuId){\r\n");
      out.write("\t\tvar $tabs = $multiList.find(\"[menuId=\"+menuId+\"]\");\r\n");
      out.write("\t\t$tabs.remove();\r\n");
      out.write("\t\tvar tmpActiveMenuId;\r\n");
      out.write("\t\tif($tabs.hasClass(\"selected\")){\r\n");
      out.write("\t\t\tvar $tabList = $multiList.find(\"[menuId]\");\r\n");
      out.write("\t\t\tif($tabList.length >= 1){\r\n");
      out.write("\t\t\t\tvar $tmpTab = $tabList.eq($tabList.length-1);\r\n");
      out.write("\t\t\t\tactiveTab($tmpTab);\r\n");
      out.write("\t\t\t\ttmpActiveMenuId = $tmpTab.attr(\"menuId\");\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\ttmpActiveMenuId = \" \";\r\n");
      out.write("\t\t}\t\t\r\n");
      out.write("\t\twindow.top.closeWindow(menuId, tmpActiveMenuId);\r\n");
      out.write("\t\t$(\"li[menuid=\"+menuId+\"]\",top.frames[\"left\"].document).removeClass(\"on\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tif($(\".tab_style01>li\").length==0){\r\n");
      out.write("\t\t\t$addFbtn.hide();\r\n");
      out.write("\t\t\t$deleteFbtn.hide();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction closeAll(){\r\n");
      out.write("\t\tvar tabList = $multiList.find(\"li\");\r\n");
      out.write("\t\tvar menuId;\r\n");
      out.write("\t\tfor(var i=0;i<tabList.length;i++){\r\n");
      out.write("\t\t\tmenuId = tabList.eq(i).attr(\"menuId\");\r\n");
      out.write("\t\t\tcloseWindow(menuId);\r\n");
      out.write("\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t\t$addFbtn.hide();\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction setPage(pathTitle, title, url, menuId){\r\n");
      out.write("\t\t//setPathTitle(pathTitle);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$multiList.find(\"li\").removeClass(\"selected\");\r\n");
      out.write("\t\tvar $tmpObj = $tabObj.clone();\r\n");
      out.write("\t\tvar $tmpText = $tmpObj.find(\"a\").eq(0);\r\n");
      out.write("\t\t//2021-01-11 CMU 텝에 T-CODE 출력되게 변경\r\n");
      out.write("\t\t//if(title.indexOf(\"]\") != -1){\r\n");
      out.write("\t\t//\t$tmpText.text(title.substring(title.indexOf(\"]\")+2));\r\n");
      out.write("\t\t//}else{\r\n");
      out.write("\t\t//\t$tmpText.text(title);\r\n");
      out.write("\t\t//}\r\n");
      out.write("\t\t$tmpText.text(title);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$tmpText.attr(\"title\", title.trim());\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$tmpObj.addClass(\"selected\");\r\n");
      out.write("\t\t$tmpObj.attr(\"menuId\",menuId);\r\n");
      out.write("\t\t//$tmpObj.attr(\"pathTitle\",pathTitle);\r\n");
      out.write("\t\t$tmpText.click(function(event){\r\n");
      out.write("\t\t\tvar $obj = $(event.target);\r\n");
      out.write("\t\t\tvar menuId = $obj.parents(\"[menuId]\").attr(\"menuId\");\r\n");
      out.write("\t\t\tchangeWindow(menuId);\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\tvar $btnList = $tmpObj.find(\"button\");\r\n");
      out.write("\t\t/*\r\n");
      out.write("\t\t$btnList.eq(0).click(function(event){\r\n");
      out.write("\t\t\twindow.top.refreshPage();\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$btnList.eq(1).click(function(event){\r\n");
      out.write("\t\t\talert(\"No files\");\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\t*/\r\n");
      out.write("\t\t$btnList.eq(0).click(function(event){\r\n");
      out.write("\t\t\tvar $obj = $(event.target);\r\n");
      out.write("\t\t\tvar menuId = $obj.parents(\"[menuId]\").attr(\"menuId\");\r\n");
      out.write("\t\t\tcloseWindow(menuId);\r\n");
      out.write("\t\t});\t\t\r\n");
      out.write("\t\t$multiList.append($tmpObj);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tactiveMenuid = menuId;\r\n");
      out.write("\t\tviewFbtn();\r\n");
      out.write("\t\tcheckTabListSize();\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tfunction checkTabListSize(){\r\n");
      out.write("\t\tvar tabWidth = commonUtil.getCssNum($multiList, \"width\");\r\n");
      out.write("\t\ttabWidth -= 140;\r\n");
      out.write("\t\tvar windTabWidth = 0;\r\n");
      out.write("\t\tvar activeWidth = 0;\r\n");
      out.write("\t\t$liList = $multiList.find(\"li\");\r\n");
      out.write("\t\tif($liList.length > 1){\r\n");
      out.write("\t\t\tvar $tmpObj;\r\n");
      out.write("\t\t\tvar tmpStr;\r\n");
      out.write("\t\t\tfor(var i=0;i<$liList.length;i++){\r\n");
      out.write("\t\t\t\t$tmpObj = $liList.eq(i);\r\n");
      out.write("\t\t\t\tif($tmpObj.hasClass(\"selected\")){\r\n");
      out.write("\t\t\t\t\tactiveWidth = windTabWidth;\r\n");
      out.write("\t\t\t\t\tactiveIndex = i;\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t\twindTabWidth += commonUtil.getCssNum($tmpObj, \"width\");\r\n");
      out.write("\t\t\t}\r\n");
      out.write("// \t\t\twindTabWidth -= ($liList.length-1)*7;\r\n");
      out.write("\t\t}\t\t\r\n");
      out.write("\t\tif(windTabWidth > tabWidth){\r\n");
      out.write("\t\t\ttabBtnView = true;\r\n");
      out.write("\t\t\tshowActiveTab();\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\ttabBtnView = false;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tif(tabBtnView){\r\n");
      out.write("\t\t\t$winTabLeft.show();\r\n");
      out.write("\t\t\t$winTabRight.show();\r\n");
      out.write("\t\t\t$pathTitle.css(\"margin-right\",\"7px\");\r\n");
      out.write("\t\t}else{\r\n");
      out.write("// \t\t\t$winTabLeft.hide();\r\n");
      out.write("// \t\t\t$winTabRight.hide();\r\n");
      out.write("\t\t\t$winTabLeft.show();\r\n");
      out.write("\t\t\t$winTabRight.show();\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tfor(var i=0;i<$liList.length;i++){\r\n");
      out.write("\t\t\t\t$liList.eq(i).show();\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\t$pathTitle.css(\"margin-right\",\"0px\");\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction showActiveTab(){\r\n");
      out.write("\t\tfor(var i=0;i<activeIndex;i++){\r\n");
      out.write("\t\t\t$liList.eq(i).hide();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tfor(var i=activeIndex;i<$liList.length;i++){\r\n");
      out.write("\t\t\t$liList.eq(i).show();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction tabLeft(){\r\n");
      out.write("\t\tif(activeIndex > 0){\r\n");
      out.write("\t\t\tactiveIndex --;\r\n");
      out.write("\t\t\tshowActiveTab();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction tabRight(){\r\n");
      out.write("\t\tif(activeIndex < $liList.length-1){\r\n");
      out.write("\t\t\tactiveIndex ++;\r\n");
      out.write("\t\t\tshowActiveTab();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction viewFbtn(){\r\n");
      out.write("\t\tif(top.checkFmenu(activeMenuid)){\r\n");
      out.write("\t\t\t$addFbtn.hide();\r\n");
      out.write("\t\t\t$deleteFbtn.show();\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\t$addFbtn.show();\r\n");
      out.write("\t\t\t$deleteFbtn.hide();\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction addFmenu(){\r\n");
      out.write("\t\tvar param = new DataMap();\r\n");
      out.write("\t\tparam.put(\"MENUID\", activeMenuid);\r\n");
      out.write("\t\tparam.put(\"SORTORDER\", 10);\r\n");
      out.write("\t\tvar json = netUtil.sendData({\r\n");
      out.write("\t\t\turl : \"/common/json/addFmenu.data\",\r\n");
      out.write("\t\t\tparam : param\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\tif(json && json.data){\r\n");
      out.write("\t\t\t$addFbtn.hide();\r\n");
      out.write("\t\t\t$deleteFbtn.show();\r\n");
      out.write("\t\t\ttop.addFmenu(activeMenuid);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction deleteFmenu(){\r\n");
      out.write("\t\tvar param = new DataMap();\r\n");
      out.write("\t\tparam.put(\"MENUID\", activeMenuid);\r\n");
      out.write("\t\tvar json = netUtil.sendData({\r\n");
      out.write("\t\t\turl : \"/common/json/deleteFmenu.data\",\r\n");
      out.write("\t\t\tparam : param\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\tif(json && json.data){\r\n");
      out.write("\t\t\t$addFbtn.show();\r\n");
      out.write("\t\t\t$deleteFbtn.hide();\r\n");
      out.write("\t\t\ttop.deleteFmenu(activeMenuid);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction loadingOpen() {\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\tfunction loadingClose() {\r\n");
      out.write("\t}\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<!-- content top -->\r\n");
      out.write("<div class=\"content_top\">\r\n");
      out.write("\t<button type=\"button\"  class=\"btn btn_bigger\" onclick=\"sizeToggle(this)\"><span>bigger</span></button>\r\n");
      out.write("\t<div class=\"tab_style_wrap\">\r\n");
      out.write("\t\t<ul class=\"tab_style01\" id=\"multiList\">\r\n");
      out.write("\t\t\t<li>\r\n");
      out.write("\t\t\t\t<a href=\"#\">defalut title</a>\r\n");
      out.write("\t\t\t\t<!-- button type=\"button\" class=\"btn btn_help\"><span>help</span></button -->\r\n");
      out.write("\t\t\t\t<button type=\"button\" class=\"btn btn_tab_del\"><span>tab deleted</span></button>\r\n");
      out.write("\t\t\t</li>\r\n");
      out.write("\t\t</ul>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<!-- // tab style 01 -->\r\n");
      out.write("\t<div class=\"btn_top\" id=\"pathTitle\">\r\n");
      out.write("\t\t<!-- btn 명은 변경해주 -->\r\n");
      out.write("\t\t<button type=\"button\" class=\"btn btn-1\" id=\"winTabLeft\" onClick=\"tabLeft()\"><span>btn-1</span></button>\r\n");
      out.write("\t\t<button type=\"button\"  class=\"btn btn-2\" id=\"winTabRight\" onClick=\"tabRight()\"><span>btn-2</span></button>\r\n");
      out.write("\t\t<button type=\"button\"  class=\"btn btn-3\" onclick=\"window.top.refreshPage()\"><span>btn-3</span></button>\r\n");
      out.write("\t\t<button type=\"button\"  class=\"btn btn-4\" onClick=\"closeAll()\"><span>btn-4</span></button>\r\n");
      out.write("\t\t<button type=\"button\"  class=\"btn btn_fav_before\" onClick=\"addFmenu()\"><span>btn-fav</span></button>\r\n");
      out.write("\t\t<button type=\"button\"  class=\"btn btn_fav_after\" onClick=\"deleteFmenu()\"><span>btn-fav</span></button>\r\n");
      out.write("\t\t<!-- button type=\"button\"  class=\"btn btn-5\"><span>btn-5</span></button-->\r\n");
      out.write("\t\t<!-- <button type=\"button\" class=\"btn btn_extend\" onclick=\"sizeToggle(this)\"><span>left menu close</span></button> -->\r\n");
      out.write("\t\t<!-- left menu open <button type=\"button\" class=\"btn btn_left_o\"><span>left menu open</span></button> -->\r\n");
      out.write("\t\t<!-- <button type=\"button\" class=\"btn btn_win_c\" onClick=\"closeAll()\"><span>widow close</span></button> -->\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("<!-- // content top -->\r\n");
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