<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.em.core.config.Config" %>
<%@ page import="com.em.core.config.PropertyConfig" %>
<%@ page import="com.em.core.config.Configuration" %>
<%@ page import="com.em.core.util.LabelUtility" %>
<%@ page import="com.em.core.util.MessageUtility" %>
<%@ page import="com.em.core.util.StringUtility" %>
<%@ page import="com.em.core.util.DateUtil" %>
<%@ page import="com.em.core.util.UIUtil" %>
<%@ page import="com.em.wms.entity.system.LabelEntity" %>

<%!
  public String getLabelShortText(String language, String group, String key) {
	  return LabelUtility.getLabelShortText(language, group, key);
  }

  public String getLabelMediumText(String language, String group, String key) {
	  return LabelUtility.getLabelMediumText(language, group, key);
  }

  public String getLabelLongText(String language, String group, String key) {
	return LabelUtility.getLabelLongText(language, group, key);
  }

  public String getLabelText(String language, String group, String key, String type) {
	  if (type == null) type = "M";

	  if (type == "M") return getLabelMediumText(language, group, key);
	  else
	  if (type == "L") return getLabelLongText(language, group, key);
	  else             return getLabelShortText(language, group, key);
  }
  
  public String getSetDate(int interval) {
	Date today = new Date();
	Date intvDay = new Date();
      
	intvDay.setDate(today.getDate()+interval);
	String intvDate = StringUtility.leftPad((intvDay.getYear()+1900+""), "0", 4)
					+ StringUtility.leftPad((intvDay.getMonth()+1+""), "0", 2)
					+ StringUtility.leftPad((intvDay.getDate()+""), "0", 2);
	return intvDate;
  }
  
  	public String szLabel(String key) {        
  		return szLabel("STD", key);
	}   
	
	public String szLabel(String group, String key) {
		String language = Locale.getDefault().getLanguage().toUpperCase();
		String returnText = key;

		try {
			LabelEntity label = 
				(LabelEntity) LabelUtility.labelCache.get(language, group, key);
			
			if (label != null) returnText = label.getLbltxl();
			
		} catch (Exception e) {
			returnText = e.getMessage();
		}
		
  		return returnText;
	} 
%>
<%
  	String warehouse = null;
	String userid = null;
	String ownrky = null;
	String company = null;
  	String language = null;
  	String systime = null;
  	String sysdate = null;
  	Locale locale = null;
  	String dateFm = "YYYY-MM-DD";
  	String dateDl = "-";
  	String decimalFm = "0";
  	String currencyFm = "";
  	String printerType = "";
  	String username = null;
  	String ftsize;
  	String ftname;
  	String serverUrl = null;
  	String $LHS = "<L id=\"\" width=\"15\" value=\"≫\"/>"; // Label Header Sign
  
  	request.setCharacterEncoding("UTF-8");
  	System.out.println("++++++++++++ JSP SESSION TOKEN[" + session.getAttribute(Configuration.SESSION_KEY_USERID) + ":" 
  		+ session.getAttribute(Configuration.SESSION_KEY_SESSIONTOKEN) + "] ++++++++++++++++");
  	System.out.println("++++++++++++ SESSION ID[" + session.getId() + "] ++++++++++++++++");
  	if (session.getAttribute(Configuration.SESSION_KEY_SESSIONTOKEN) == null) {
		%><script>
			alert("<%=MessageUtility.getMessageText(request.getLocale(), "COMMON", "M0005")%>");
			if (window.dialogArguments != null) self.close();
		  </script><%
		return;
  	}
	
  	warehouse = (String)session.getAttribute(Configuration.SESSION_KEY_WAREHOUSE);
  	userid = (String)session.getAttribute(Configuration.SESSION_KEY_USERID);
  	ownrky = (String)session.getAttribute(Configuration.SESSION_KEY_OWNER);
  	company = (String)session.getAttribute(Configuration.SESSION_KEY_COMPANY);
  	locale = (Locale)session.getAttribute(Configuration.SESSION_KEY_LOCALE);
  	username = (String)session.getAttribute(Configuration.SESSION_KEY_USERNAME);
  	language = locale.getLanguage().toUpperCase();
  	sysdate = DateUtil.getShortDateString();
  	systime = DateUtil.getShortTimeString();
  	String PROG_ID = request.getParameter("PROG_ID") == null ? "COMMON" : request.getParameter("PROG_ID");
  	String TAB_ID = request.getParameter("TAB_ID") == null ? "" : request.getParameter("TAB_ID");
  	dateFm = (String)session.getAttribute(Configuration.SESSION_KEY_USER_DATEFM);
  	dateDl = (String)session.getAttribute(Configuration.SESSION_KEY_USER_DATEDL);
  	decimalFm = (String)session.getAttribute(Configuration.SESSION_KEY_USER_DECIMALFM);
  	currencyFm = (String)session.getAttribute(Configuration.SESSION_KEY_USER_CURRENTYFM);
  	printerType = (String)session.getAttribute(Configuration.SESSION_KEY_PRINTER_TYPE);
  	Config solzardConfig = PropertyConfig.getConfig(Configuration.DEFAULT_PROPERTIES);
  	ftname = (String)session.getAttribute(Configuration.SESSION_KEY_USER_FONT);
  	ftsize = (String)session.getAttribute(Configuration.SESSION_KEY_USER_FONT_SIZE);
  	serverUrl = solzardConfig.getString(Configuration.SERVICE_URL);
  	
  	UIUtil ui = new UIUtil();
  	String doccat = null;
  	
%>
<script type="text/javascript" src="/sajowms/include/HashMap.js"></script>
<script type="text/javascript">
<!--
	var USER_ID = "<%=userid%>";
	var PROG_ID = "<%=PROG_ID%>";
	var DATE_FM = "<%=dateFm%>";
	var DECIMAL_FM = "<%=decimalFm%>";
	var TAB_ID = "<%=TAB_ID%>";
	var TAB_BLOCK = new HashMap();
	var PRINTER_TYPE = "<%=printerType%>";
	var ftsize = "<%=ftsize%>";
	var ftname = "<%=ftname%>";
	var serverUrl = "<%=serverUrl%>";
	
//-->
</script>
<XML id="_MODIFY_ON_OFF">
  <DS N="_MODIFY_ON_OFF">
    <M>MODIFY_ON_OFF</M>
    <P>ACT_STATUS↑U</P>
  </DS>
</XML>
<XML id="LOAD_LAYOUT">
    <DS N="LOAD_LAYOUT">
		<M>COMMON.LOAD_USER_LAYOUT</M>
		<P>PORG_ID↑<%=PROG_ID %></P>
		<D N="UserLayout" IO="O"/>
	</DS>
</XML>
<XML id="SAVE_LAYOUT">
    <DS N="SAVE_LAYOUT">
		<M>COMMON.SAVE_USER_LAYOUT</M>
		<P>PORG_ID↑<%=PROG_ID %></P>
		<D N="UserLayout" IO="O"/>
	</DS>
</XML>
<?xml version="1.0" encoding="UTF-8"?>
<XML id="UserLayout">
  <D N="UserLayout">
	<C>progid</C>
	<C>compid</C>
	<C>laotid</C>
	<C>layout</C>
  </D>
</XML>

<form name="report1" method="POST">
	<input type="hidden" name="i_where" id="i_where"/>
	<input type="hidden" name="i_orderby" id="i_orderby"/>
	<input type="hidden" name="i_qtyprt" id="i_qtyprt"/>
	<input type="hidden" name="i_qtystd" id="i_qtystd"/>
	<input type="hidden" name="i_locaky" id="i_locaky"/>
	
	<input type="hidden" name="i_wareky" id="i_wareky"/>
	<input type="hidden" name="i_ownrky" id="i_ownrky"/>
	<input type="hidden" name="i_makdat" id="i_makdat"/>
	<input type="hidden" name="i_filenm" id=i_filenm/>
</form>