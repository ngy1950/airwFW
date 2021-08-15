<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,java.util.ArrayList,com.common.bean.CommonConfig"%>
<%
	ArrayList list = (ArrayList)request.getAttribute("WAHMACOMBO");
	ArrayList list1 = (ArrayList)request.getAttribute("LANGKY");
	ArrayList list2 = (ArrayList)request.getAttribute("MSG");
	
	DataMap row;
	
	Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	
	String sloId = (String)request.getAttribute("SLOID");
	String sloPw = (String)request.getAttribute("SLOPW");
	String sloWk = (String)request.getAttribute("SLOWK");
	String sloLk = (String)request.getAttribute("SLOLK");
	
	//String theme = CommonConfig.SYSTEM_THEME_PATH;
	String theme = "/theme/gsfresh";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>WMS</title>
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/login.css">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/theme.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script>
<%
for(int i=0;i<list2.size();i++){
	row = (DataMap)list2.get(i);
%>
commonMessage.message.put("<%=row.get("MESGKY")%>","<%=row.get("MESGTX")%>");
<%
}
%>

function getMsg(msgCode){
	msgCode = $langky.val()+"_"+msgCode;
	return commonMessage.message.get(msgCode);
}

function getLabel(){
	return "";
}

var $langky;

var $contentLoading;
//로딩 열기
function loadingOpen() {
	
	$contentLoading.show();
}

//로딩 닫기
function loadingClose() {
	
	$contentLoading.hide();
}

var topLabelFrame;

$(document).ready(function(){
	$langky = jQuery("#LANGKY");
	
	topLabelFrame = window;
	
	$contentLoading = jQuery("#contentLoading");
	
	inputList.setCombo();
	//checkEZPlatformApp();
	
	$("select[name=WAREKY]").val("WH01");
	$("select[name=LANGKY]").val("KR");
	var WAREKY = $.cookie("WAREKY");
	if(WAREKY){
		jQuery("#WAREKY").val(WAREKY);
	}
	var LANGKY = $.cookie("LANGKY");
	if(LANGKY){
		jQuery("#LANGKY").val(LANGKY);
	}
	var USERID = $.cookie("USERID");
	if(USERID){
		jQuery("#USERID").val(USERID);
	}
	var PASSWD = $.cookie("PASSWD");
	if(PASSWD){
		jQuery("#PASSWD").val(PASSWD);
	}

	$("body").show();
});

function login(){
	//this.location.href = "/common/main.page";
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		var json = netUtil.send({
			url : "/common/json/login.data",
			param : param,
			returnParam : param,
			successFunction : "loginEnd"
		});
	}	
}

function loginEnd(json, param){
	if(json && json.data){
		if(json.data == "F"){
			//commonUtil.msg("아이디 또는 비밀번호가 일치 하지 않습니다.");  //LOGIN_M0001
			alert(getMsg("M0001"));
		}else{
			for(var prop in param.map){
				$.cookie(prop, param.get(prop),{
				     "expires" : 365
				});
			}
			//this.location.href = "/common/mainPop.page";
			this.location.href = "/gsfresh/main.page";
		}
	}
}

function validationEventMsg(valObjType, objIndex, objId, objName, objValue, valType){
	//commonUtil.debugMsg("validationEventMsg : ", arguments);
	if(objName == "USERID"){
		//return "사용자 ID를 입력하세요.";       //LOGIN_M0002
		return getMsg("M0002");
	}else if(objName == "PASSWD"){
		//return "사용자 Password를 입력하세요."; //LOGIN_M0003
		return getMsg("M0003");
	}else if(objName == "WAREKY"){
		//return "거점을 선택하세요.";			  //LOGIN_M0004
		return getMsg("M0004");
	}else if(objName == "LANGKY"){
		//return "사용 언어를 선택하세요.";		  //LOGIN_M0005
		return getMsg("M0005");
	}
}

function checkEZPlatformApp() 
{
	if(typeof window.localStorage == 'undefined') {
		//alert("로컬 스토리지를 지원하지 않습니다."); //LOGIN_M0006
		alert(getMsg("M0006"));
		return;
	}
	var version = window.localStorage.getItem('EZPlatformApp');
	if( version != "1.0.0.7" ){
		location.href = '/downloadPlatformApp.html';
	}
}

function linkEZ(){
	window.location.href = '/downloadPlatformApp.html';
}

function changePassword(){
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		param.put("PASSWD","");
		page.linkPopOpen("/common/password.page", param);
	}	
}
$(document).ready(function(){
 	 $("#WAREKY,#LANGKY").hide();
     $('.bg img:gt(0)').hide();
 	
 	 $(".selectoption1 p").click(function(){
 		 $("#WAREKY").slideToggle();
 	 });
 	 $("#WAREKY li").click(function(){
 		 $(this).parent().slideUp();
 		 $(".selectoption1 p").text($(this).text());
 	 });
 	 
 	
 	
});

setInterval(function(){
		$('.bg > img:first')
		.fadeOut(5000)
		.next()
		.fadeIn(5000)
		.end()
		.appendTo('.bg');
	},10000);
		
</script>
</head>
<body style="display:none">
	<div class="bg">
		<img src="/common/theme/gsfresh/images/login/loginbg.jpg">
		<img src="/common/theme/gsfresh/images/login/loginbg2.jpg">
	</div>
	<div class="foot_logo"><img src="/common/theme/gsfresh/images/login/foot_logo.png"></div>
		<div class="GSRetail"><img src="/common<%=theme%>/images/login/GSRetail.png" /></div>
		<div class="loginWrap">
			<h1 class="logo"><img src="/common<%=theme%>/images/login/logo.png" alt="air-WMS" /></h1>
			<div class="innerWrap" id="searchArea">
				<input type="text" id="USERID" name="USERID" validate="required" placeholder="아이디"/>
				<input type="password" id="PASSWD" name="PASSWD" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="비밀번호"/>
				<!-- div class="changePassword"><a href="#">비밀번호 변경<img src="/common<%=theme%>/images/login/ico_arrow.png" alt="" /></a></div-->
				<div class="selectoption selectoption1">
				<p>센터 선택</p>
					<ul id="WAREKY" name="WAREKY" >
						<%
						for(int i=0;i<list.size();i++){
							row = (DataMap)list.get(i);
					%>
						<li value='<%=row.get("VALUE_COL")%>'>[<%=row.get("VALUE_COL")%>]<%=row.get("TEXT_COL")%></li>
						<%
						}
					%>
					</ul>
					</div>
					<div class="selectoption selectoption2">
					
					</ul>
					<%-- <select id="WAREKY" name="WAREKY" validate="required" >
					<%
						for(int i=0;i<list.size();i++){
							row = (DataMap)list.get(i);
					%>
						<option value='<%=row.get("VALUE_COL")%>'>[<%=row.get("VALUE_COL")%>]<%=row.get("TEXT_COL")%></option>
					<%
						}
					%>
					</select>
				</div>
				<div class="selectWrap"> --%>
					<select id="LANGKY" name="LANGKY" validate="required" >
					<%
						for(int i=0;i<list1.size();i++){
							row = (DataMap)list1.get(i);
					%>
						<option value='<%=row.get("VALUE_COL")%>'>[<%=row.get("VALUE_COL")%>]<%=row.get("TEXT_COL")%></option>
					<%
						}
					%>
					</select>
				</div>
					<input type="submit" value="Login" onclick="login()" />
					<!-- button style="margin-top: 8px; width: 108px" onclick="changePassword();">패스워드변경</button -->
				<div class="selectWrap">
					<button onclick="linkEZ()">프린트 설치</button>
					<button onclick="changePassword()">비밀번호 변경</button>
				</div>
			</div>
		</div>
	
	<div class="contact">
		<p class="copywrite">COPYTIGHY ©2020 <span>GSRetail.Co.Ltd.</span> ALL RIGHTS RESERVED.</p>
		<!-- <select id="SITEKY" name="SITEKY" validate="required" >
			<option>Famlry Site</option>
		</select> -->
	</div>
	<div class="contentLoading" id="contentLoading"></div>
</body>
</html>