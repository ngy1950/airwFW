<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>WMS</title>
<link rel="stylesheet" href="/common/theme/dongwon/css/red.css">
<link rel="stylesheet" href="/common/theme/dongwon/css/dongwon.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
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
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
</head>
<body>
	<div class="bg-gradient"></div>
	<div class="bg-gradient"></div>
	<div class="show">
		<h1>
			<img src="/common/theme/dongwon/images/logo.png">
			<img src="../images/dongwon-loex.png" alt="동원로엑스">
			<span>e-Cold</span>
		</h1>
		<div class="signin" id="searchArea">
		    <h2>LOG IN</h2>
		    <input type="text" id="USERID" name="USERID" validate="required" value="DEV" />
		    <input type="password" id="PASSWD" name="PASSWD" validate="required" value="1" />
      	<select class="" name="">
      	  <option value="">오창물류센터</option>
          <option value="">오창물류센터</option>
      	</select>
        <select class="" name="">
      	  <option value="">[KO]korea</option>
          <option value="">[EN]english</option>
      	</select>
		    <input type="button" name="SignIn" value="Sign In" onclick="login()">
		    <div class="selectWrap">
		    	<button onclick="linkEZ()">EZPlatform download</button>
		    	<button onclick="changePassword()">Change password</button>
		    </div>
		</div>
	</div>
</body>
</html>