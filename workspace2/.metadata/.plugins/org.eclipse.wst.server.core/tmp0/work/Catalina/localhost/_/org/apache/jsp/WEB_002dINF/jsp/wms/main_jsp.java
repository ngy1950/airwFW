/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.107
 * Generated at: 2021-07-14 01:51:09 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.wms;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import project.common.bean.DataMap;
import java.util.*;
import project.common.bean.CommonConfig;

public final class main_jsp extends org.apache.jasper.runtime.HttpJspBase
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

	String langky = request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();

	String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);

      out.write("\r\n");
      out.write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\">\r\n");
      out.write("<html>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\">\r\n");
      out.write("<title>SAJO WMS</title>\r\n");
      out.write("<link rel=\"shortcut icon\" href=\"/common/theme/webdek/images/logo01.png\" type=\"image/x-ico\" />\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/json2.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataMap.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/configData.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/commonUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/netUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("MultiWindow = function(index, pathTitle, title, url, menuId) {\r\n");
      out.write("\tthis.index = index;//?????? ??????\r\n");
      out.write("\tthis.pathTitle = pathTitle;\r\n");
      out.write("\tthis.title = title;\r\n");
      out.write("\tthis.url = url;\r\n");
      out.write("\tthis.menuId = menuId;\t\r\n");
      out.write("\tthis.bodyFrame = rightFrame;\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("MultiWindow.prototype = {\r\n");
      out.write("\tsetFrame : function() {\r\n");
      out.write("\t\treturn \"MultiWindow\";\r\n");
      out.write("\t},\r\n");
      out.write("\ttoString : function() {\r\n");
      out.write("\t\treturn \"MultiWindow\";\r\n");
      out.write("\t}\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("window.moveTo(0,0);\r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/label.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/label-");
      out.print(langky);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/message-");
      out.print(langky);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/page.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar leftState = true;\r\n");
      out.write("\tvar $middleFrame;\r\n");
      out.write("\tvar middleCols;\r\n");
      out.write("\t\r\n");
      out.write("\tvar topState = true;\r\n");
      out.write("\tvar $topFrame;\r\n");
      out.write("\tvar topRows;\r\n");
      out.write("\t\r\n");
      out.write("\tvar $rightFrame;\r\n");
      out.write("\tvar $bodyFrame;\r\n");
      out.write("\tvar $headFrame;\r\n");
      out.write("\tvar $navFrame;\r\n");
      out.write("\tvar $footerFrame;\r\n");
      out.write("\tvar bodyUrl;\r\n");
      out.write("\tvar selectMenuId = \"root\";\r\n");
      out.write("\tvar menuTabMap = new DataMap();\r\n");
      out.write("\tvar menuWindowStat = new Array();\r\n");
      out.write("\tvar bodyIndex = 0;\r\n");
      out.write("\t\r\n");
      out.write("\tvar singletonMap = new DataMap();\r\n");
      out.write("\t\r\n");
      out.write("\t// ????????????\r\n");
      out.write("\t$(window).load(function(){\r\n");
      out.write("\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\tvar ww = $(window.top).width();\r\n");
      out.write("\r\n");
      out.write("\t\tvar bgDiv = \"<div class='bgDiv' style='height:\"+wh+\"px;width:\"+ww+\"px;position:fixed;bottom:0;right:0; z-index:-1;background-size:cover; background-color:#A2CBA1;'></div>\";\r\n");
      out.write("// \t\tvar bgDiv = \"<div class='bgDiv' style='height:\"+wh+\"px;width:\"+ww+\"px;position:fixed;bottom:0;right:0; z-index:-1;background:url(/common/theme/webdek/images/web_bg.png) repeat center center;background-size:cover;'></div>\";\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$('body',top.frames[\"header\"].document).append(bgDiv);\r\n");
      out.write("\t\t$('body',top.frames[\"nav\"].document).append(bgDiv);\r\n");
      out.write("\t\t$('body',top.frames[\"main\"].document).append(bgDiv);\r\n");
      out.write("\r\n");
      out.write("\t\t$('.bgDiv',top.frames[\"header\"].document).css({top:0,left:0 });\r\n");
      out.write("\t\t$('.bgDiv',top.frames[\"nav\"].document).css({top:-80+\"px\",left:-280+\"px\" });\r\n");
      out.write("\t\t$('.bgDiv',top.frames[\"main\"].document).css({top:-120+\"px\", left:-280+\"px\", bottom:0});\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\t$(window).resize(function(){\r\n");
      out.write("\t\tvar frameAll = $(\"frame\", $(\"#topFrame\"));\r\n");
      out.write("\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tfor(var i = 0; i<frameAll.length ; i++){\r\n");
      out.write("\t\t\tvar frameId = $(frameAll[i]).attr(\"id\");\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[frameId].document).css({height:wh+\"px\", width: ww+\"px\"});\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t});\r\n");
      out.write("\t\t\r\n");
      out.write("\t\r\n");
      out.write("\t$(document).ready(function(){\r\n");
      out.write("\t\t$middleFrame = $(\"#middleFrame\");\r\n");
      out.write("\t\tmiddleCols = $middleFrame.attr(\"cols\");\r\n");
      out.write("\t\t$rightFrame = $(\"#rightFrame\");\r\n");
      out.write("\t\t$bodyFrame = $(\"#body0\");\r\n");
      out.write("\t\t$headFrame = $(\"#header\");\r\n");
      out.write("\t\t$navFrame = $(\"#nav\");\r\n");
      out.write("\t\t$footerFrame = $(\"#footer\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$topFrame = $(\"#topFrame\");\r\n");
      out.write("\t\ttopRows = $topFrame.attr(\"rows\");\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tfor(var i=0;i<configData.MAX_MENU_TAB;i++){\r\n");
      out.write("\t\t\tmenuWindowStat.push(true);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\ttry{\r\n");
      out.write("\t\t\tif(!opener.window.name){\r\n");
      out.write("\t\t\t\topener.window.open(\"\", '_self').close();\r\n");
      out.write("\t\t\t}\t\r\n");
      out.write("\t\t} catch (e) {\r\n");
      out.write("\t\t\t// TODO: handle exception\r\n");
      out.write("\t\t}\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("// \tfunction sizeToggle(){\r\n");
      out.write("// \t\tif(leftState){\r\n");
      out.write("// \t\t\t$middleFrame.attr(\"cols\",\"0px,*\");\r\n");
      out.write("\t\t\t\r\n");
      out.write("// \t\t\tleftState = false;\r\n");
      out.write("// \t\t\tvar wh = $(window.top).height();\r\n");
      out.write("// \t\t\tvar ww = $(window.top).width();\r\n");
      out.write("// \t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\", left: 0});\r\n");
      out.write("// \t\t\t$('.bgDiv',top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left: 0});\r\n");
      out.write("\t\t\t\r\n");
      out.write("// \t\t}else{\r\n");
      out.write("// \t\t\t$middleFrame.attr(\"cols\",middleCols);\r\n");
      out.write("\t\t\t\r\n");
      out.write("// \t\t\tleftState = true;\r\n");
      out.write("// \t\t\tvar wh = $(window.top).height();\r\n");
      out.write("// \t\t\tvar ww = $(window.top).width();\r\n");
      out.write("// \t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\", left:-280+\"px\"});\r\n");
      out.write("// \t\t\t$('.bgDiv',top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left:-280+\"px\"});\r\n");
      out.write("// \t\t}\r\n");
      out.write("// \t}\r\n");
      out.write("\tfunction sizeToggleGrid(fullSizeType){\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tif(fullSizeType){\r\n");
      out.write("\t\t\t$topFrame.attr(\"rows\",\"0px,*\");\r\n");
      out.write("\t\t\t$middleFrame.attr(\"cols\",\"0px,*\");\r\n");
      out.write("\t\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\", left:0, top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv', top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left:0, top: 0});\r\n");
      out.write("\t\t\ttopState = false;\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body0\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body1\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body2\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body3\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body4\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body5\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body6\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body7\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body8\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body9\"].document).css({top: 0});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t}else{\r\n");
      out.write("// \t\telse if(topState){\r\n");
      out.write("\t\t\t$topFrame.attr(\"rows\",topRows);\r\n");
      out.write("\t\t\t$middleFrame.attr(\"cols\",middleCols);\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\",left: -280 +\"px\" , top:-80+\"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left: -280 +\"px\" , top:-80+\"px\"});\r\n");
      out.write("\t\t\ttopState = true;\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body0\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body1\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body2\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body3\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body4\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body5\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body6\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body7\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body8\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body9\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction sizeToggle(){\r\n");
      out.write("\t\tif(topState){\r\n");
      out.write("\t\t\t$topFrame.attr(\"rows\",\"0px,*\");\r\n");
      out.write("\t\t\t$middleFrame.attr(\"cols\",\"0px,*\");\r\n");
      out.write("\t\t\ttopState = false;\r\n");
      out.write("\t\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\", left:0, top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv', top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left:0, top: 0});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body0\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body1\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body2\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body3\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body4\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body5\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body6\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body7\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body8\"].document).css({top: 0});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body9\"].document).css({top: 0});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\t$topFrame.attr(\"rows\",topRows);\r\n");
      out.write("\t\t\t$middleFrame.attr(\"cols\",middleCols);\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\ttopState = true;\r\n");
      out.write("\t\t\tvar wh = $(window.top).height();\r\n");
      out.write("\t\t\tvar ww = $(window.top).width();\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"nav\"].document).css({height:wh+\"px\", width:ww+\"px\",left: -280 +\"px\" , top:-80+\"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"main\"].document).css({height:wh+\"px\", width:ww+\"px\", left: -280 +\"px\" , top:-80+\"px\"});\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body0\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body1\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body2\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body3\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body4\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body5\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body6\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body7\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body8\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t\t$('.bgDiv',top.frames[\"body9\"].document).css({top: -120 + \"px\"});\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\t\r\n");
      out.write("\tfunction setActivePageInfo(multiWindow){\r\n");
      out.write("\t\tbodyUrl = multiWindow.url;\r\n");
      out.write("\t\tbodyIndex = multiWindow.index;\r\n");
      out.write("\t\tselectMenuId = multiWindow.menuId;\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction menuPage(menuId){\r\n");
      out.write("\t\tframes.left.menuSearch(menuId);\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction linkPage(menuId, data, reloadType){ \r\n");
      out.write("\t\tsingletonMap.put(menuId, data);\t\t\r\n");
      out.write("\t\tif(menuTabMap.containsKey(menuId)){\r\n");
      out.write("\t\t\tmultiWindow = menuTabMap.get(menuId);\r\n");
      out.write("\t\t\t//bodyIndex = multiWindow.index;\r\n");
      out.write("\t\t\t//selectMenuId = multiWindow.menuId;\r\n");
      out.write("\t\t\tsetActivePageInfo(multiWindow);\r\n");
      out.write("\t\t\tthis.nav.changeWindow(multiWindow.menuId);\r\n");
      out.write("\t\t\tif(reloadType){\r\n");
      out.write("\t\t\t\trefreshPage();\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\ttry{\r\n");
      out.write("\t\t\t\tframes[\"body\"+bodyIndex].linkPageOpenEvent(data);\r\n");
      out.write("\t\t\t}catch(e){\r\n");
      out.write("\t\t\t\t\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\tframes.left.menuSearch(menuId);\r\n");
      out.write("\t\t}\t\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction getLinkData(menuId){\r\n");
      out.write("\t\tvar data = singletonMap.get(menuId);\r\n");
      out.write("\t\tsingletonMap.remove(menuId);\r\n");
      out.write("\t\treturn data;\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction changePage(pathTitle, title, url, menuId){\t\r\n");
      out.write("\t\tvar multiWindow;\r\n");
      out.write("\t\tif(menuTabMap.containsKey(menuId)){\r\n");
      out.write("\t\t\tmultiWindow = menuTabMap.get(menuId);\r\n");
      out.write("\t\t\tbodyIndex = multiWindow.index;\r\n");
      out.write("\t\t\tthis.nav.changeWindow(multiWindow.menuId);\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\tvar tmpIndex = getAvailedWindowIndex();\r\n");
      out.write("\t\t\tif(tmpIndex == configData.MAX_MENU_TAB){\r\n");
      out.write("\t\t\t\t//commonUtil.msgBox(\"MASTER_MAX_MENU_TAB\");\r\n");
      out.write("\t\t\t\talert(commonUtil.format(commonMessage.getMessage(configData.MSG_WINDOWMAX),configData.MAX_MENU_TAB));\r\n");
      out.write("\t\t\t\t//????????? ?????? ????????? {0}??? ?????????.\r\n");
      out.write("\t\t\t\treturn false;\r\n");
      out.write("\t\t\t} \r\n");
      out.write("\t\t\tmultiWindow = new MultiWindow(tmpIndex, pathTitle, title, url, menuId);\r\n");
      out.write("\t\t\tmenuTabMap.put(menuId, multiWindow);\t\t\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tmenuWindowOpen(multiWindow, true);\r\n");
      out.write("\t\t\tmenuWindowStat[tmpIndex] = false;\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t\t\tthis.nav.setPage(multiWindow.pathTitle, multiWindow.title, multiWindow.url, multiWindow.menuId);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t//bodyUrl = multiWindow.url;\r\n");
      out.write("\t\t//bodyIndex = multiWindow.index;\r\n");
      out.write("\t\t//selectMenuId = multiWindow.menuId;\r\n");
      out.write("\t\tsetActivePageInfo(multiWindow);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\treturn true;\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction getAvailedWindowIndex(){\r\n");
      out.write("\t\tfor(var i=0;i<configData.MAX_MENU_TAB;i++){\r\n");
      out.write("\t\t\tif(menuWindowStat[i]){\r\n");
      out.write("\t\t\t\treturn i;\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t\treturn configData.MAX_MENU_TAB;\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction menuWindowOpen(multiWindow, realodType){\r\n");
      out.write("\t\tbIndex = multiWindow.index;\t\r\n");
      out.write("\t\tvar tmpRows = \"40px,0\";\r\n");
      out.write("\t\tfor(var i=0;i<configData.MAX_MENU_TAB;i++){\r\n");
      out.write("\t\t\tif(i==bIndex){\r\n");
      out.write("\t\t\t\ttmpRows += \",*\";\r\n");
      out.write("\t\t\t}else{\r\n");
      out.write("\t\t\t\ttmpRows += \",0\";\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t$rightFrame.attr(\"rows\", tmpRows);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tif(realodType){\r\n");
      out.write("\t\t\t$(\"#body\"+bIndex).attr(\"src\", multiWindow.url);\r\n");
      out.write("\t\t\tbodyUrl = multiWindow.url;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t//bodyIndex = multiWindow.index;\r\n");
      out.write("\t\t//selectMenuId = multiWindow.menuId;\r\n");
      out.write("\t\tsetActivePageInfo(multiWindow);\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction changeWindow(menuId){\r\n");
      out.write("\t\t//alert(menuId);\r\n");
      out.write("\t\tvar multiWindow = menuTabMap.get(menuId);\r\n");
      out.write("\t\t//bodyUrl = multiWindow.url;\r\n");
      out.write("\t\t//selectMenuId = multiWindow.menuId;\r\n");
      out.write("\t\t//bodyIndex = multiWindow.index;\r\n");
      out.write("\t\tsetActivePageInfo(multiWindow);\r\n");
      out.write("\t\tmenuWindowOpen(multiWindow);\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction closeAll(){\r\n");
      out.write("\t\tvar keys = menuTabMap.keys();\r\n");
      out.write("\t\tfor(var i=keys.length-1;i>=0;i--){\r\n");
      out.write("\t\t\tframes.nav.closeWindow(keys[i]);\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction closeWindow(menuId, tmpActiveMenuId){\r\n");
      out.write("\t\t//alert(menuId);\r\n");
      out.write("\t\t//2021.04.07  CMU ??????????????? ??? ????????? ???????????? ??????\r\n");
      out.write("\t\t//frames.left.setLastActiveMenuId(tmpActiveMenuId);\r\n");
      out.write("\t\tvar multiWindow = menuTabMap.get(menuId);\r\n");
      out.write("\t\tvar tmpIndex = multiWindow.index;\r\n");
      out.write("\t\t$(\"#body\"+tmpIndex).attr(\"src\", \"\");\r\n");
      out.write("\t\tmenuWindowStat[tmpIndex] = true;\r\n");
      out.write("\t\tmenuTabMap.remove(menuId);\r\n");
      out.write("\t\t\r\n");
      out.write("\t\tif(tmpIndex == bodyIndex){\t\t\t\r\n");
      out.write("\t\t\tvar tmpWin;\r\n");
      out.write("\t\t\tfor(var prop in menuTabMap.map){\r\n");
      out.write("\t\t\t\ttmpWin = menuTabMap.get(prop);\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif(tmpWin){\r\n");
      out.write("\t\t\t\tmenuWindowOpen(tmpWin);\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tif(menuTabMap.size() == 0){\r\n");
      out.write("\t\t\t$rightFrame.attr(\"rows\", \"40px,*,0,0,0,0,0\");\r\n");
      out.write("\t\t}\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction refreshPage(){\r\n");
      out.write("\t\tif(menuTabMap.size()){\r\n");
      out.write("\t\t\t$(\"#body\"+bodyIndex).attr(\"src\", bodyUrl);\r\n");
      out.write("\t\t}\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction getMenuId(){\r\n");
      out.write("\t\tif(selectMenuId){\r\n");
      out.write("\t\t\treturn selectMenuId;\r\n");
      out.write("\t\t}else{\r\n");
      out.write("\t\t\treturn \"MENUID\";\r\n");
      out.write("\t\t}\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\tfunction reloadPage(){\r\n");
      out.write("\t\tlocation.reload();\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction logoEffectStart(){\r\n");
      out.write("\t\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\tfunction logoEffectStop(){\r\n");
      out.write("\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction reloadLeft(){\r\n");
      out.write("\t\t//frames.left.reloadPage();\r\n");
      out.write("\t\tframes.left.location.href=\"/gcim/left.data\";\r\n");
      out.write("\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction changeTopMenu(menuSelect){\r\n");
      out.write("\t\tframes.header.changeMenuFocus(menuSelect);\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction checkFmenu(menuId){\r\n");
      out.write("\t\treturn frames.left.checkFmenu(menuId);\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction reloadInfo(pmenuId){\r\n");
      out.write("\t\tframes.left.reloadPage();\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction addFmenu(menuId){\r\n");
      out.write("\t\tframes.left.addFmenu(menuId);\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tfunction deleteFmenu(menuId){\r\n");
      out.write("\t\tframes.left.deleteFmenu(menuId);\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("</script>\r\n");
      out.write("<frameset id=\"topFrame\" name=\"topFrame\" rows=\"80px,*\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("    <frame id=\"header\" name=\"header\" src=\"/wms/top.data\" noresize framespacing=0 frameborder=no border=0 scrolling=\"no\">\r\n");
      out.write("    <frameset id=\"middleFrame\" name=\"middleFrame\" cols=\"280px,*\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("        <!-- frame id=\"left\" name=\"left\" src=\"/common/html/lnb.html\" name=\"lnb\" noresize framespacing=0 frameborder=no border=0 -->\r\n");
      out.write("        <frame id=\"left\" name=\"left\" src=\"/wms/left.data\" name=\"lnb\" noresize framespacing=0 frameborder=no border=0>\r\n");
      out.write("        <frameset id=\"rightFrame\" name=\"rightFrame\" rows=\"40px,*,0,0,0,0,0\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"nav\" name=\"nav\" src=\"/webdek/wintab.page\" noresize framespacing=0 frameborder=no border=0 scrolling=\"no\">\r\n");
      out.write("\t\t\t<frame id=\"main\" name=\"main\" src=\"/wms/info.page\" noresize framespacing=0 frameborder=no border=0>\r\n");
      out.write("\t\t\t<!-- frame id=\"main\" name=\"main\" src=\"/board/scmBoard.page?ID=2\" noresize framespacing=0 frameborder=no border=0 -->\r\n");
      out.write("\t\t\t<frame id=\"body0\" name=\"body0\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body1\" name=\"body1\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body2\" name=\"body2\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body3\" name=\"body3\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body4\" name=\"body4\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body5\" name=\"body5\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body6\" name=\"body6\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t\t<frame id=\"body7\" name=\"body7\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("            <frame id=\"body8\" name=\"body8\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("            <frame id=\"body9\" name=\"body9\" src=\"\" noresize framespacing=0 frameborder=no border=0 >\r\n");
      out.write("\t\t</frameset>\r\n");
      out.write("    </frameset>\r\n");
      out.write("</frameset>\r\n");
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
