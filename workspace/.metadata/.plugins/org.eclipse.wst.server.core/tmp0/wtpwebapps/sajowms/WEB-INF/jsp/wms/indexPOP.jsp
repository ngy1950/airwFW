<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,java.util.ArrayList,com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%@ page import="java.net.*"%>
<%@ page import="com.common.util.*"%>

<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	ArrayList list2 = (ArrayList)request.getAttribute("MSG");
	DataMap row; 
	String theme = sFilter.getXSSFilter(CommonConfig.SYSTEM_THEME_PATH);
	
	RSA rsa = RSA.getEncKey();
	request.setAttribute("publicKeyModulus", rsa.getPublicKeyModulus());
	request.setAttribute("publicKeyExponent", rsa.getPublicKeyExponent());
	request.getSession().setAttribute("__rsaPrivateKey2__", rsa.getPrivateKey());
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
<script type="text/javascript" src="/common/js/configData.js"></script>

<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-KR.js"></script>
<script type="text/javascript" src="/common/lang/message-KR.js"></script>

<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript" src="/common/js/kor-En-Conversion.js"></script>

<script type="text/javascript" src="/wms/js/jsbn.js"></script>
<script type="text/javascript" src="/wms/js/rsa.js"></script>
<script type="text/javascript" src="/wms/js/prng4.js"></script>
<script type="text/javascript" src="/wms/js/rng.js"></script>


<script>
	window.resizeTo('500','610');

	var msgMap = new DataMap();
	<%
		for(int i=0;i<list2.size();i++){
			row = (DataMap)list2.get(i);
			
			String mesgky = sFilter.getXSSFilter(row.getString("MESGKY"));
			String mesgtx = sFilter.getXSSFilter(row.getString("MESGTX"));
	%>
		msgMap.put("<%=mesgky%>","<%=mesgtx%>");
	<%
		}
	%>
	var $langky;

	function getMsg(msgCode){
		msgCode = $langky.val()+"_"+msgCode;
		return msgMap.get(msgCode);
	}
	
	$(document).ready(function(){
		var data = page.getLinkPopData();
		var param = new DataMap();
		param.put("LANGKY", data.get("LANGKY"));
		dataBind.dataNameBind(param, "searchArea");
		
		$langky = jQuery("#LANGKY");
		$(".mobileNum").prop("checked", true);
	});
	

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
	
	var originName;
	var userKrName;
	var userTel1;
	var userTel2;
	function checkNumber(){
		var userid = $("input[id=USERID]").val();
		if( $.trim(userid) == "" ){
			commonUtil.msg(getMsg("M0009"));
			return;
		}
		
		var mail = $(".mailAdd:checked").val();
		var phone = $(".mobileNum:checked").val();
		if( mail != "V" && phone != "V"){
			alert("인증번호 전송 방식을 선택해주세요. (핸드폰 또는 메일)");
			return;
		}
		
		var randomNum = Math.floor(Math.random() * 1000000) + 100000;
		if( randomNum > 1000000 ){
			randomNum = randomNum - 100000;
		}
		
		//암호화
		var rsaPublicKeyModulus = document.getElementById("rsaPublicKeyModulus").value;
		var rsaPublicKeyExponent = document.getElementById("rsaPublicKeyExponent").value;
		var encUserid   = fnRsaEnc($('input[name=USERID]').val(), rsaPublicKeyModulus, rsaPublicKeyExponent);
		
		var param = new DataMap();
		param.put("POBPC1", randomNum);
		param.put("USERID", encUserid);
		
		if( mail == "V" ){
			param.put("SENDTYPE", "MAIL");
		}else if( phone == "V" ){
			param.put("SENDTYPE", "PHONE");
		}
		
		var json = netUtil.sendData({
			url : "/wms/json/savepasswordPOBPC1.data",
			param : param
		}); 
		
		if( json && json.data ){
			if( json.data["resultMsg"] == "OK" || json.data["resultMsg"] == "SUCCESS" ){
				commonUtil.msg(getMsg(json.data["MSG_code"])); 
			}else{
				commonUtil.msg(getMsg(json.data["MSG_code"]));
			}
		}
	}
	
	function change(){
		var param = dataBind.paramData("searchArea");
		
		var POBPC1 = $.trim(param.get("POBPC1"));
		var USERID = $.trim(param.get("USERID"));
		var NEWPASSWD  = $.trim(param.get("NEWPASSWD"));
		var NEWPASSWD2 = $.trim(param.get("NEWPASSWD2"));
			
		if( POBPC1 == "" ){
			commonUtil.msg(getMsg("M0026")); 
			$("[name='POBPC1']").focus();
			return false;
			
		}else if( USERID == "" ){
			commonUtil.msg(getMsg("M0009")); 
			$("[name='USERID']").focus();
			return false;
			
		}else if ( NEWPASSWD == "" ){
			commonUtil.msg(getMsg("M0010")); 
			$("[name='NEWPASSWD']").focus();
			inputReset();
			return false;
			
		}else if ( NEWPASSWD2 == "" ) {
			commonUtil.msg(getMsg("M0010")); 
			$("[name='NEWPASSWD2']").focus();
			inputReset();
			return false;
		}
		
		if( NEWPASSWD.search(/\s/) != -1 ){
			commonUtil.msg(getMsg("M0025"));
			inputReset();
			return false;
		}
		
		if( NEWPASSWD != NEWPASSWD2 ){
			commonUtil.msg(getMsg("M0019"));
			inputReset();
			return false;
		}
		
		if( USERID == NEWPASSWD ){
			commonUtil.msg(getMsg("M0020"));
			inputReset();
			return false;
		}
		
		var newPassWD = String(NEWPASSWD);
		if( newPassWD.length < 8 || newPassWD.length >= 15 ){
			commonUtil.msg(getMsg("M0021"));
			inputReset();
			return false;
		}
		
		
		if( /(\w)\1\1\1/.test(NEWPASSWD) || isContinuedValue(NEWPASSWD) ){
			commonUtil.msg(getMsg("M0023"));
			inputReset();
			return false;
		}
		
		var rsaPublicKeyModulus = document.getElementById("rsaPublicKeyModulus").value;
		var rsaPublicKeyExponent = document.getElementById("rsaPublicKeyExponent").value;
		
		var encUserid   = fnRsaEnc(USERID, rsaPublicKeyModulus, rsaPublicKeyExponent);
		var encPassword = fnRsaEnc(NEWPASSWD, rsaPublicKeyModulus, rsaPublicKeyExponent);
		var encPassword2 = fnRsaEnc(NEWPASSWD2, rsaPublicKeyModulus, rsaPublicKeyExponent);
		
		var paramv = new DataMap();
		paramv.put("USERID"    , encUserid);
		paramv.put("NEWPASSWD" , encPassword);
		paramv.put("NEWPASSWD2", encPassword2);
		paramv.put("POBPC1"    , POBPC1);
		
		var json = netUtil.sendData({
			url : "/wms/json/savepasswordUSRPW.data",
			param : paramv
		});
		
		if(json && json.data){
			var data = json.data;
			commonUtil.msg(getMsg(data.resultMsg));
			inputReset();
			
			if(data.flag == "OK"){
				page.linkPopClose();
				
			}
		}else{
			commonUtil.msg(getMsg(data.resultMsg));
			inputReset();
		}
	}
	
	// 값 존재 여부 체크
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
	
	function isContinuedValue(value) {
		var intCnt1 = 0;
		var intCnt2 = 0;
		var intCnt3 = 0;
		var temp0 = "";
		var temp1 = "";
		var temp2 = "";
		
		for( var i = 0; i < value.length-2; i++ ){
			temp0 = value.charAt(i);
			temp1 = value.charAt(i + 1);
			temp2 = value.charAt(i + 2);
			
			if( temp0.charCodeAt(0) - temp1.charCodeAt(0) == 1
				&& temp1.charCodeAt(0) - temp2.charCodeAt(0) == 1 ){
				intCnt1 = intCnt1 + 1;
				}
			
			if( temp0.charCodeAt(0) - temp1.charCodeAt(0) == -1
				&& temp1.charCodeAt(0) - temp2.charCodeAt(0) == -1 ){
				intCnt2 = intCnt2 + 1;
			}
			
			if( temp0 == temp1 && temp0 == temp2 ){
				intCnt3 = intCnt3 + 1;
			}
			
		}
		return ( intCnt1 > 0 || intCnt2 > 0 || intCnt3 > 0 );
	}
	
	function inputReset(){
		$("input[id=NEWPASSWD]").val("");
		$("input[id=NEWPASSWD2]").val("");
	}
	
	function fnRsaEnc(value, rsaPublicKeyModulus, rsaPpublicKeyExponent) {

		var rsa = new RSAKey();
		rsa.setPublic(rsaPublicKeyModulus, rsaPpublicKeyExponent);
		var encValue = rsa.encrypt(value); 
		return encValue;

	}
	
</script>
</head>
<body>
<div class="changePwBg">
	<div class="outerwrap">
		<div class="passwrap" id="searchArea">
			<input type="hidden" id="WAREKY" name="WAREKY"/>
			<input type="hidden" id="LANGKY" name="LANGKY"/>
			<input type="hidden" id="rsaPublicKeyModulus" value="${publicKeyModulus}">
			<input type="hidden" id="rsaPublicKeyExponent" value="${publicKeyExponent}">
	
			<div class="change">
				<h1 style="color :#7fc241;" >Password Change</h1>
				
				<div class="logo"><img src="/common<%=theme%>/images/login/logo.png" alt="" /></div>
				
				<div class="radioDiv">
					핸드폰<input type="radio" name="radioSelect" class="mobileNum" value="V">&nbsp;&nbsp;&nbsp;&nbsp;
					메일<input type="radio" name="radioSelect" class="mailAdd" value="V">
				</div>
				
				<div class="id">
					<input type="text"     id="USERID"     name="USERID"     placeholder="ID"               validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" maxlength="80"/>
				</div>
				
				<div class="check">
					<div class="checkNum">
						<input type="text" id="POBPC1"     name="POBPC1"    placeholder="인증번호"           validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" maxlength="6"/>
						<button type="button" onclick="checkNumber()">인증번호요청</button>
					</div>
				</div>
				
				<div class="pw">
					<input type="password" id="NEWPASSWD"  name="NEWPASSWD"  placeholder="New Password"     validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" maxlength="80"/>
				</div>
				<div class="pw">
					<input type="password" id="NEWPASSWD2" name="NEWPASSWD2" placeholder="Confirm Password" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" maxlength="80"/>
				</div>
				<div class="btn">
					<input type="submit" value="Change" onclick="change()"/>
				</div>
				<div class="bottomText">
					[비밀번호 규칙]<br />
					1. 비밀번호는 8자 이상, 15자 이하입니다.<br />
					2. 숫자와 영문자, 특수기호를 1글자 이상 섞어야 하며 공백은 불가합니다.<br />
					3. 비밀번호에 사용자ID, 이름, 전화번호가 포함될 수 없습니다.<br />
					4. 동일 숫자/문자가 3자 이상 연속으로 사용될 수 없습니다.<br />
					5. 이전에 사용했던 비밀번호는 향후 3회까지 사용할 수 없습니다.<br />
					
				
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>