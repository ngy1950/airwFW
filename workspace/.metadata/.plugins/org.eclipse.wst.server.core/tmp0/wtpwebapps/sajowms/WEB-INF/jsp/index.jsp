<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<title>index</title>
<script>
try{
    if(commonUtil.isMobile()){
        this.location.href = "/mobile/index/index.page";
    }else{
        this.location.href = "/wms/index/index.page";    
    }   
}catch(e){
    this.location.href = "/wms/index/index.page"; 
}
</script>
</head>
<body>
</body>
</html>
