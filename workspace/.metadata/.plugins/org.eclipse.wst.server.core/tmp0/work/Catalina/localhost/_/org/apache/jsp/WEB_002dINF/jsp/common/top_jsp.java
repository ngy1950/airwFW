/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.69
 * Generated at: 2020-10-23 07:44:31 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.common;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.common.bean.DataMap;
import com.common.bean.CommonConfig;

public final class top_jsp extends org.apache.jasper.runtime.HttpJspBase
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

	String wareky = request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString();
	String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
	String username = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
	String compky = request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY).toString();
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);

      out.write("\r\n");
      out.write("<!doctype html>\r\n");
      out.write("<html lang=\"ko\">\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n");
      out.write("<meta charset=\"utf-8\">\r\n");
      out.write("<title></title>\r\n");
      out.write("<meta name=\"viewport\" content=\"width=1150\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common");
      out.print(theme);
      out.write("/css/common.css\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common");
      out.print(theme);
      out.write("/css/top.css\">\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"/common");
      out.print(theme);
      out.write("/css/theme.css\">\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/jquery-ui.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/json2.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataMap.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/configData.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/label.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/label-");
      out.print(langky);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/lang/message-");
      out.print(langky);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/commonUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/dataBind.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/input.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/netUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/validateUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/common/js/ui.js\"></script>\r\n");
      out.write("<script>\r\n");
      out.write("(function() {\r\n");
      out.write("\r\n");
      out.write("\t$(function() {\r\n");
      out.write("\r\n");
      out.write("\t\tvar gnb = $('.gnb')\r\n");
      out.write("\t\t\t, trigger = gnb.find('.list').children('li')\r\n");
      out.write("\t\t\t, list = trigger.children('ul');\r\n");
      out.write("\r\n");
      out.write("\t\ttrigger.each(function() {\r\n");
      out.write("\t\t\tvar _this = $(this)\r\n");
      out.write("\t\t\t\t, thisTrigger = _this.children('a')\r\n");
      out.write("\t\t\t\t, thisList = _this.children('ul');\r\n");
      out.write("\r\n");
      out.write("\t\t\tthisTrigger.on({\r\n");
      out.write("\t\t\t\tclick : function() {\r\n");
      out.write("\t\t\t\t\tlist.hide();\r\n");
      out.write("\t\t\t\t\tthisList.show();\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\ttrigger.removeClass('active');\r\n");
      out.write("\t\t\t\t\t_this.addClass('active');\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t});\r\n");
      out.write("\t});\r\n");
      out.write("\r\n");
      out.write("})();\r\n");
      out.write("//로딩 열기\r\n");
      out.write("function loadingOpen() {\r\n");
      out.write("\r\n");
      out.write("\tvar loader = $('<div class=\"contentLoading\"></div>').appendTo('body');\r\n");
      out.write("\r\n");
      out.write("\tloader.stop().animate({\r\n");
      out.write("\t\ttop : '0px'\r\n");
      out.write("\t}, 30, function() {\r\n");
      out.write("\t});\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("// 로딩 닫기\r\n");
      out.write("function loadingClose() {\r\n");
      out.write("\r\n");
      out.write("\tvar loader = $('.contentLoading');\r\n");
      out.write("\r\n");
      out.write("\tloader.stop().animate({\r\n");
      out.write("\t\ttop : '100%'\r\n");
      out.write("\t}, 30, function() {\r\n");
      out.write("\t\tloader.remove();\r\n");
      out.write("\t});\r\n");
      out.write("}\r\n");
      out.write("$(document).ready(function(){\r\n");
      out.write("\tinputList.setCombo();\r\n");
      out.write("\t$(\"select[name=WAREKY]\").val(\"");
      out.print(wareky);
      out.write("\");\r\n");
      out.write("\t\r\n");
      out.write("\tuiList.UICheck();\r\n");
      out.write("\t\r\n");
      out.write("\t//logoEffect();\r\n");
      out.write("});\r\n");
      out.write("\r\n");
      out.write("function changeWareky(){\r\n");
      out.write("\tif(!commonUtil.msgConfirm(\"MASTER_WAREKYCHANGE\")){// 창고를 변경하는 경우 열려진 화면이 모두 닫힙니다.\\n 변경 하시겠습니까?\r\n");
      out.write("\t\t$(\"[name=WAREKY]\").val(lastWareKey);\r\n");
      out.write("\t\treturn;\r\n");
      out.write("\t}\r\n");
      out.write("\tvar param = dataBind.paramData(\"searchArea\");\r\n");
      out.write("\tlastWareKey = param.get(\"WAREKY\");\r\n");
      out.write("\tvar json = netUtil.sendData({\r\n");
      out.write("\t\turl : \"/wms/common/json/changeWareky.data\",\r\n");
      out.write("\t\tparam : param\r\n");
      out.write("\t});\r\n");
      out.write("\t\r\n");
      out.write("\tif(json && json.data){\r\n");
      out.write("\t\t\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\twindow.top.closeAll();\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function logout(){\r\n");
      out.write("\tlocation.href = \"/common/json/logout.page\";\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function changePage(menuId){\t\r\n");
      out.write("\twindow.top.menuPage(menuId);\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function logoEffectStart(){\r\n");
      out.write("\tstate = true;\r\n");
      out.write("\teffectType = true;\r\n");
      out.write("\tlogoEffect();\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("function logoEffectStop(){\r\n");
      out.write("\tstate = false;\r\n");
      out.write("\teffectType = false;\r\n");
      out.write("\tlogoEffect();\r\n");
      out.write("\t$( \"#effect\" ).stop(true,true);\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("var state = true;\r\n");
      out.write("var effectType = true;\r\n");
      out.write("function logoEffect(){\t\r\n");
      out.write("\tif ( state ) {\r\n");
      out.write("\t\t$( \"#effect\" ).animate({\r\n");
      out.write("\t\t  backgroundColor: \"#ffffff\",\r\n");
      out.write("\t\t  color: \"#ffffff\"\r\n");
      out.write("\t\t}, 1000 );\r\n");
      out.write("\t} else {\r\n");
      out.write("\t\t$( \"#effect\" ).animate({\r\n");
      out.write("\t\t  backgroundColor: \"#2f313a\",\r\n");
      out.write("\t\t  color: \"#2f313a\"\r\n");
      out.write("\t\t}, 1000 );\r\n");
      out.write("\t}\r\n");
      out.write("\t\r\n");
      out.write("\tif(effectType){\r\n");
      out.write("\t\tstate = !state;\r\n");
      out.write("\t\tsetTimeout(logoEffect, 1000);\r\n");
      out.write("\t}\t\r\n");
      out.write("}\r\n");
      out.write("\r\n");
      out.write("var lastWareKey;\r\n");
      out.write("$(document).ready(function(){\r\n");
      out.write("\tuiList.UICheck();\r\n");
      out.write("\tlastWareKey = $(\"[name=WAREKY]\").val();\r\n");
      out.write("});\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<!-- header -->\r\n");
      out.write("<div class=\"header\">\r\n");
      out.write("\t<div class=\"innerContainer\">\r\n");
      out.write("\t\t<span class=\"logo\" id=\"effect\">\r\n");
      out.write("\t\t\t<a href=\"#\" onClick=\"window.top.reloadPage()\">\r\n");
      out.write("\t\t\t\t<img src=\"/common");
      out.print(theme);
      out.write("/images/logo.png\" alt=\"\" />\r\n");
      out.write("\t\t\t</a>\r\n");
      out.write("\t\t</span>\r\n");
      out.write("\t\t<div class=\"rightArea\" id=\"searchArea\">\r\n");
      out.write("\t\t\t<div class=\"selection\">\r\n");
      out.write("\t\t\t\t<select Combo=\"Wms,WAHMACOMBO\" name=\"WAREKY\" onChange=\"changeWareky()\" >\r\n");
      out.write("\t\t\t\t</select>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"util\">\r\n");
      out.write("\t\t\t\t<p class=\"user\">");
      out.print(username);
      out.write("</p>\r\n");
      out.write("\t\t\t\t<button class=\"logOut\" type=\"button\" onClick=\"logout()\" CL=\"BTN_LOGOUT\"></button>\r\n");
      out.write("\t\t\t\t<!-- button class=\"setting\" type=\"button\"><a href=\"/common/demo/tool/sql.jsp\" target=\"_TOP\">설정</a></button-->\r\n");
      out.write("\t\t\t</div>\t\t\t\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("<!-- //header -->\r\n");
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
