<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%><%@ page import="project.common.bean.*,project.common.util.*,java.util.*"%>

<%
    DataMap paramDataMap = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    if(paramDataMap == null){
        paramDataMap = new DataMap(request);
    }
    
    String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>공지사항</title>
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript">

$(document).ready(function(){   
    <%
    if(compky != null){
	    if(compky.equals("GCCL")){
    %>
	        $("body").css({backgroundColor:"#d5ecec"});
    <%
        }else{
    %>
	        $("body").css({backgroundColor:"#f7f4be"});
    <%
        }
	}
    %>
});

function linkPage(){

    page.linkPopOpen("http://172.20.2.153:8080/gcim/index.page", null,"height=1080,width=1920,resizeble=no");
    window.close();
}

</script>
<style type="text/css">
html,body{width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden;}
* {box-sizing:border-box;}
.show{margin-top: 70px;}
img{width: 100px;     vertical-align: middle; margin-left: -30px;}
.title {text-align: center;}
.deploy_time{
margin-top: 40px;}
.deploy_time h2{ width: 330px; margin: 20px auto; font-size: 16px; margin-top: 15px;}
.deploy_time h3{ width: 330px; margin: 10px auto; font-size: 16px; font-weight: normal;padding-left: 25px;}
.show>h2{  margin: 30px auto; font-size: 16px; text-align: center;     line-height: 25px;}
</style>
</head>
<body>
	<div class="show">
       
	   <h1 class="title"><img src="/common/theme/webdek/images/stop_img2.png" /> 공 지 사 항 </h1>
	   <div class="deploy_time">
	       <h2>1. (운영서버) 소스 반영시간 작업 금지</h2>
	       <h3> - 오전 8:00 ~ 8:30</h3>
           <h2>2. (운영서버) 테스트 금지</h2>
           <h3> - 테스트는 개발서버에서 진행</h3>
           <h3> - 개발서버  <br><a href="#" onclick="linkPage()">http://172.20.2.153:8080/gcim/index.page</a></h3>
	   </div>
	   
	   <h2>* 시스템 관리자 연락처 <br> 정보운영팀 현재영 과장  010 – 4741 - 4756</h2>
	</div>
</body>
</html>