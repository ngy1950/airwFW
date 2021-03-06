<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.*,com.common.util.*,com.common.bean.CommonConfig,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
    XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	String langky = sFilter.getXSSFilter((String) request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY));
	String theme  = sFilter.getXSSFilter((String) request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Password Change</title>
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/common.css">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/content_body.css">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/content_ui.css">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/theme.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<%
	if(langky != null && (langky.equals("CN") || langky.equals("ZH"))){
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-zh-CN.js"></script>
<%
	}else{
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-ko.js"></script>
<%
	}
%>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>
<script type="text/javascript" src="/common/js/jquery.form.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/big.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/layoutSave.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">

	//?????? ??????
	function loadingOpen() {
	
		var loader = $('<div class="contentLoading"></div>').appendTo('body');
	
		loader.stop().animate({
			top : '0px'
		}, 30, function() {
		});
	}
	
	// ?????? ??????
	function loadingClose() {
	
		var loader = $('.contentLoading');
	
		loader.stop().animate({
			top : '100%'
		}, 30, function() {
			loader.remove();
		});
	}
    
    var labelObj = new Object();
	
	CommonMessage = function() {
		this.message = new DataMap();
	};
	
	CommonMessage.prototype = {
		getMessage : function(key) {
			var mtxt = this.message.get(key);
			if(mtxt){
				commonLabel.labelHistory.push(key+" "+mtxt.split(configData.DATA_COL_SEPARATOR)[1]);
				return mtxt.split(configData.DATA_COL_SEPARATOR)[1];
			}else{
				return key;
			}
		},
		toString : function() {
			return "CommonMessage";
		}
	};
	
	var commonMessage = new CommonMessage();
	
	function getLabel(key, type){
		if(!type){
			type = 1;
		}
		return commonLabel.getLabel(key, type);
	}
	function getMessage(key){
		return commonMessage.getMessage(key);
	}

	window.resizeTo('400','300');
	
	var langky;
	
	$(document).ready(function(){
		try{
		    topLabelFrame = window;
		}catch(e){
			;
		}
		uiList.UICheck();
		inputList.setInput();
		inputList.setCombo();
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		langky = data.get("LANGKY");
	});

	
	
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}
	}
	
	////
 	function check(param){
		// 1. ?????? ???????????? ????????? ???????????? ????????????.
		if(param.get("PASSWD1") != param.get("PASSWD2")){
			commonUtil.msgBox("?????? ???????????? ????????? ???????????? ????????????.");
			return false;
		}
		
		// 2. ID??? ??????????????? ?????? ??? ????????????
		if(param.get("USERID") == param.get("PASSWD1")){
			commonUtil.msgBox("ID??? ??????????????? ?????? ??? ????????????");
			return false;
		}  
		
		// 3. ????????? ??????
		if(String(param.get("PASSWD1")).length <6 || String(param.get("PASSWD1")).length >= 20 ){
			commonUtil.msgBox("??????????????? 6?????? ?????? 20?????? ????????? ???????????????");
			return false;
		}
		
		// 4. ????????? ?????? ?????? ??????	
		var alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		var num = "1234567890";
		var len = String(param.get("PASSWD1")).length;
		var ch,flag1,flag2;
		flag1=flag2=false;
		//??????????????? ????????? ????????? ?????????,????????? ???????????? ???????????? ??????, true.
		for(i = 0 ; i < len ; i++ ){        
		    ch=String(param.get("PASSWD1")).charAt(i);        
		    if(alpha.indexOf(ch) >= 0){ 
		        flag1 = true;
		    } else if(num.indexOf(ch) >= 0){
		        flag2 = true;
		    }
		}
		//???????????? ????????? ???????????? ??????
		if(!(flag1 && flag2)){ 
			commonUtil.msgBox("??????????????? ???????????? ?????? ??? ????????? ???????????????");
			return false;
		}
		
		return true;
	}
	
	function saveData(){
		if(validate.check("searchArea")){
			var param = dataBind.paramData("searchArea");
			if(!check(param)) {
				return;
			}
			
			var json = netUtil.sendData({
		    	url : "/wms/json/password.data",
		    	param : param
		    });
			
			if(json && json.data){
				if(json.data == "F"){
					commonUtil.msg("????????? ?????? ??????????????? ?????? ?????? ????????????.");
				}else{
					this.close();
				}
			}
		}		
	}
	
	CommonLabel = function() {
		this.labelHistory = new Array();
		this.label = new DataMap();
	};

	CommonLabel.prototype = {
		getLabel : function(key, type) {
			if(this.label.containsKey(key)){
				var ltxt = this.label.get(key);
				this.labelHistory.push(key+" "+ltxt.split(configData.DATA_COL_SEPARATOR)[type]);
				return ltxt.split(configData.DATA_COL_SEPARATOR)[type];
			}else{
				return key;
			}
		},
		resetHistory : function(){
			this.labelHistory = new Array();
		},
		showHistory : function() {
			var data = this.labelHistory.join("\n");
			if (window.clipboardData) { // Internet Explorer
		        window.clipboardData.setData("Text", data);
		    } else {  
		    	var temp = prompt("Ctrl+C??? ?????? ??????????????? ???????????????", data);
		    }
		},
		toString : function() {
			return "CommonLabel";
		}
	};
</script>
</head>
<body>
<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<div class="searchInnerContainer">
		<div class="btn login">
			<button style="margin-top: 8px; width: 98px" onclick="saveData();">??????</button>
		</div>
		<div class="searchInBox">
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>?????????ID</th>
						<td>
							<input type="text" name="USERID" class="normalInput" validate="required"/>
						</td>
					</tr>
					<tr>
						<th>??????????????????</th>
						<td>
							<input type="password" name="PASSWD" class="normalInput" validate="required"/>
						</td>
					</tr>
					<tr>
						<th>??????????????????</th>
						<td>
							<input type="password" name="PASSWD1" class="normalInput" validate="required"/>
						</td>
					</tr>
					<tr>
						<th>??????????????????</th>
						<td>
							<input type="password" name="PASSWD2" class="normalInput" validate="required"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->
</body>
</html>