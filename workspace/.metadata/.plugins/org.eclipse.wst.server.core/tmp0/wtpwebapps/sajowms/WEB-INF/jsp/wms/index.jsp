<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,java.util.ArrayList,com.common.bean.CommonConfig"%>
<%@ page import="java.net.*"%>
<%@ page import="com.common.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	ArrayList list  = (ArrayList)request.getAttribute("WAHMACOMBO");
	ArrayList list1 = (ArrayList)request.getAttribute("LANGKY");
	ArrayList list2 = (ArrayList)request.getAttribute("MSG");
	
	DataMap row; 
	
	InetAddress Address = InetAddress.getLocalHost();
	String clientIp = Address.getHostAddress();
	
	Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	
	String sloId = sFilter.getXSSFilter((String)request.getAttribute("SLOID"));
	String sloPw = sFilter.getXSSFilter((String)request.getAttribute("SLOPW"));
	String sloWk = sFilter.getXSSFilter((String)request.getAttribute("SLOWK"));
	String sloLk = sFilter.getXSSFilter((String)request.getAttribute("SLOLK"));

	String theme = sFilter.getXSSFilter(CommonConfig.SYSTEM_THEME_PATH);
	
	RSA rsa = RSA.getEncKey();
	request.setAttribute("publicKeyModulus", rsa.getPublicKeyModulus());
	request.setAttribute("publicKeyExponent", rsa.getPublicKeyExponent());
	request.getSession().setAttribute("__rsaPrivateKey__", rsa.getPrivateKey());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>WMS</title>
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/login.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/theme.css">
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

<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript" src="/wms/js/jsbn.js"></script>
<script type="text/javascript" src="/wms/js/rsa.js"></script>
<script type="text/javascript" src="/wms/js/prng4.js"></script>
<script type="text/javascript" src="/wms/js/rng.js"></script>
<style type="text/css">
input:-webkit-autofill{
	transition: background-color 5000s ease-in-out 0s;
	-webkit-text-fill-color: #fff !important;
	caret-color: #fff;
}
</style>
<script>
<%
for(int i=0;i<list2.size();i++){
	row = (DataMap)list2.get(i);
	
	String mesgky = sFilter.getXSSFilter(row.getString("MESGKY"));
	String mesgtx = sFilter.getXSSFilter(row.getString("MESGTX"));
%>
commonMessage.message.put("<%=mesgky%>","<%=mesgtx%>");
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

//로딩 열기
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

var topLabelFrame;

$(document).ready(function(){
	$langky = jQuery("#LANGKY");
	
	topLabelFrame = window;
	
	inputList.setCombo();
	
<%
	if(sloId != null && !sloId.equals("")){
		list = new ArrayList();
		DataMap data = new DataMap();
		data.put("VALUE_COL", sloWk);
		data.put("TEXT_COL", sloWk);
		list.add(data);
		list1 = new ArrayList();
		DataMap row1 = new DataMap();
		row1.put("VALUE_COL", sloLk);
		row1.put("TEXT_COL", sloLk);
		list1.add(row1);
		
		
%>
	jQuery("#USERID").val("<%=sloId%>");
	jQuery("#WAREKY").val("<%=sloWk%>");
	jQuery("#LANGKY").val("<%=sloLk%>");
	login();
<%
	}else if(SES_USER_ID != null && !SES_USER_ID.toString().equals("")){
%>
	this.location.href = "/common/main.page";
<%
	}else{
%>
	$("select[name=LANGKY]").val("KR");
	
	var WAREKY = $.cookie("WAREKY");
	if(WAREKY){
		jQuery("#WAREKY").val(WAREKY);
		jQuery("#WAREKY").text($(".selectoption1 ul li#" + WAREKY + "").text());
	}
	
	var USERID = $.cookie("USERID");
	if(USERID){
		jQuery("#USERID").val(USERID);
	}
<%
	}
%>
	$("body").show();
	
	
	// 20200409 gsfresh wareky 변경
	$(".selectoption1 ul").hide();
	$('.bg img:gt(0)').hide(); //배경화면 슬라이드
	
	//wareky select 효과
	$(".selectoption1 p").click(function(){
		$(".selectoption1 ul").slideToggle();
	});
	
	$(".selectoption1 ul li").click(function(){
		$(this).parent().slideUp();
		$(".selectoption1 p").text($(this).text());
		$(".selectoption1 p").val($(this).attr("value"));
	});
	
});

function login(){
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		param.put("WAREKY", $(".selectoption1 p").val());
		
		var paramv = new DataMap();
		
		for(var propv in param.map){
			paramv.put(propv, param.get(propv));
		};
		
		var rsaPublicKeyModulus = document.getElementById("rsaPublicKeyModulus").value;
		var rsaPublicKeyExponent = document.getElementById("rsaPublicKeyExponent").value;
		
		var encUserid   = fnRsaEnc($('input[name=USERID]').val(), rsaPublicKeyModulus, rsaPublicKeyExponent);
		var encPassword = fnRsaEnc($('input[name=PASSWD]').val(), rsaPublicKeyModulus, rsaPublicKeyExponent);
		
		paramv.put("USERID", encUserid);
		paramv.put("PASSWD", encPassword);
		
		var json = netUtil.sendData({
			url : "/common/json/login.data",
			param : paramv
		});
		
		if(json && json.data){
			if(json.data == "F"){
				 commonUtil.msg(getMsg("M0001"));
			}else if(json.data == "F_LOGIN_DEL"){
				commonUtil.msg(getMsg("M0002"));
			}else if(json.data == "F_LOGIN_CONF"){
				commonUtil.msg(getMsg("M0003"));
			}else if(json.data == "F_LOGIN_CNT_OVER"){
				commonUtil.msg(getMsg("M0004"));
			}else if(json.data == "F_LOGIN_DATE_OVER"){
				commonUtil.msg(getMsg("M0005"));
			}else if(json.data == "F_LOGIN_WAREKY_ALL"){
				commonUtil.msg(getMsg("M0007"));
			}else if(json.data == "F_LOGIN_WAREKY"){
				commonUtil.msg(getMsg("M0008"));
			}else if(json.data == "F_LOGIN_OWNRKY_ALL"){
				commonUtil.msg(getMsg("M0016"));
			}else if(json.data == "F_LOGIN_OWNRKY"){
				commonUtil.msg(getMsg("M0017"));
			}else if(json.data == "F_LOGIN_RSA"){
				commonUtil.msg(getMsg("M0037"));
				this.location.reload();
			}else{
				for(var prop in param.map){
					if(prop != "PASSWD"){
						$.cookie(prop, param.get(prop),{
							 "expires" : 7
						});
					}
				} 
				this.location.href = "/common/main.page";
			}
		}
	}	
}

function validationEventMsg(valObjType, objIndex, objId, objName, objValue, valType){
	if(objName == "USERID"){
		return getMsg("M0009");
	}else if(objName == "PASSWD"){
		return getMsg("M0010");
	}else if(objName == "WAREKY"){
		return getMsg("M0011");
	}else if(objName == "LANGKY"){
		return getMsg("M0012");
	}
}

function checkEZPlatformApp() 
{
	if(typeof window.localStorage == 'undefined') {
		commonUtil.msg(getMsg("M0013"));
		return;
	}
	var version = window.localStorage.getItem('EZPlatformApp');
	if( version != "1.0.0.7" ){
		location.href = '/downloadPlatformApp.html';
	}
}

function linkEZ(){
	location.href = '/downloadPlatformApp.html';
}

function changePassword(){
	var param = new DataMap();
    var data = dataBind.paramData("searchArea");
    param.put("LANGKY",data.get("LANGKY"));
    param.put("WAREKY",data.get("WAREKY"));
    param.put("USERID",data.get("USERID"));
    
    
    page.linkPopOpen("/wms/index/indexPOP.page", param);
    
    return;
}

//값 존재 체크
function isNull(sValue) {
	 var value = (sValue+"").replace(" ", "");
	 
	 if( new String(value).valueOf() == "undefined")
	     return true;
	 if( value == null )
	     return true;
	 if( value.toString().length == 0 )
	     return true;
	 
	 return false;
}

//keyPress Enter 처리 함수
function checkList(num){
	 // 필수입력값 체크 
	 // 모두 입력 sendData
	 // 미입력 빈값 포커스
	 
	 var param  = dataBind.paramData("searchArea");
	 
	 var USERID = $.trim(param.get("USERID"));
	 var PASSWD = $.trim(param.get("PASSWD"));
	     
	 if( isNull( USERID ) ||  isNull( PASSWD )){
	     if(isNull( USERID )){
	         $("[name='USERID']").focus();
	     }else if ( isNull( PASSWD ) ){
	         $("[name='PASSWD']").focus();
	     }
	 }else{
	     login();
	}
}


function fnRsaEnc(value, rsaPublicKeyModulus, rsaPpublicKeyExponent) {

	var rsa = new RSAKey();
	rsa.setPublic(rsaPublicKeyModulus, rsaPpublicKeyExponent);
	var encValue = rsa.encrypt(value); 
	return encValue;

}

// 배경화면 fadeIn/fadeOut
setInterval(function(){
	$('.bg > img:first')
	.fadeOut(5000)
	.next()
	.fadeIn(5000)
	.end()
	.appendTo('.bg');
}, 8000);

</script>
</head>
<body style="display:none">
	<div class="bg">
		<img src="/common/theme/gsfresh/images/login_img/loginbg2.jpg">
		<img src="/common/theme/gsfresh/images/login_img/loginbg3-1.png">
		<img src="/common/theme/gsfresh/images/login_img/loginbg4-1.png">
		<img src="/common/theme/gsfresh/images/login_img/loginbg.jpg">
	</div>
	<div class="foot_logo"><img src="/common/theme/gsfresh/images/login_img/foot_logo_3.png"/></div>
	<div class="GSRetail"><img src="/common/theme/gsfresh/images/login_img/GSRetail.png" /></div>
	<div class="loginWrap">
		<h1 class="logo">
			<img src="/common<%=theme%>/images/login/logo_3.png" alt="WMS" width="103px;"/>
			<!-- <span>e</span>WMS -->
		</h1>
		<div class="innerWrap" id="searchArea">
			<input type="hidden" id="rsaPublicKeyModulus" value="${publicKeyModulus}">
			<input type="hidden" id="rsaPublicKeyExponent" value="${publicKeyExponent}">
			
			<div class="input id">
				<input type="text" id="USERID" name="USERID" validate="required" placeholder="아이디" />
			</div>
			<div class="input pw">
				<input type="password" id="PASSWD" name="PASSWD" validate="required" placeholder="비밀번호" onkeypress="commonUtil.enterKeyCheck(event, 'login()')"/>
			</div>
			<div class="selectoption selectoption1">
				<p id="WAREKY" name="WAREKY" validate="required">물류센터 선택</p>
				<ul name="WAREKY" >
				<%
					for( int i=0; i<list.size(); i++ ){
						row = (DataMap)list.get(i);
						
						String valueCol = sFilter.getXSSFilter(row.getString("VALUE_COL"));
						String textCol = sFilter.getXSSFilter(row.getString("TEXT_COL"));
				%>
					<li id="<%=valueCol%>" value="<%=valueCol%>">[<%=valueCol%>] <%=textCol%></li>
				<%
					}
				%>
				</ul>
				
			</div>
			<input type="hidden" value='KR' id="LANGKY" name="LANGKY" />
			<input type="hidden" value='E' id="OWNRKY" name="OWNRKY" />
			<div class="btn login">
				<input type="submit" value="로그인" onclick="login()" /><br/>
			</div>
			
			<div class="selectWrap">
				<button onclick="linkEZ()">프린트 설치</button>
				<button onclick="changePassword()">비밀번호 변경</button>
			</div>
			
		</div>
	</div>
	
	<div class="contact">
		<p class="copywrite">Copyright ©2020 <span>GSRetail.Co.Ltd.</span> ALL RIGHTS RESERVED.</p>
	</div>
	<div class="contentLoading" id="contentLoading"></div>
</body>
</html>