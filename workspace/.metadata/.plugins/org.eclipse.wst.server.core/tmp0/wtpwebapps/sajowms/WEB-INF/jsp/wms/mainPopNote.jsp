<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig,com.common.bean.DataMap,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	String code = "";
	if(request.getAttribute("code") != null){
		code = sFilter.getXSSFilter(request.getAttribute("code").toString());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Summer Note</title>
<!-- include libraries(jQuery, bootstrap) -->
<link href="/summernote/css/bootstrap.css" rel="stylesheet">
<script src="/summernote/js/jquery3.2.1.js"></script>
<script src="/summernote/js/bootstrap.js"></script>

<!-- include summernote css/js -->
<link href="/summernote/summernote.css" rel="stylesheet">
<script src="/summernote/summernote.js"></script>

<!-- include summernote-ko-KR -->
<script src="/summernote/lang/summernote-ko-KR.js"></script>

<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<style>
	.note-editor.note-frame .note-editing-area .note-editable[contenteditable="false"]{background-color: #fff;}
	.note-btn .btn .btn-default .btn-sm .dropdown-toggle{height: 26px !important; padding: 3px 10px !important;}
</style>
</head>
<script>
	var height = 0;
	var width = 0;
	$(document).ready(function() {
		var code = "<%=code%>";
		
		height = $(document).height();
		width  = $(document).width();
		
		summernoteLoad(code);
		
		$(".dropdown-toggle").eq(0).attr("style","height:26px;padding:3px 10px;");
		$(".dropdown-toggle").eq(1).attr("style","height:26px;padding:3px 10px;");
		$(".dropdown-toggle").eq(3).attr("style","height:26px;padding:3px 10px;");
		$(".dropdown-toggle").eq(4).attr("style","height:26px;padding:3px 10px;");
		$(".dropdown-toggle").eq(5).attr("style","height:26px;padding:3px 10px;");
		
		$('div.note-editor').css('border', 'none');
		$('div.note-statusbar').remove();
	});
	
	var $contentLoading;
	// 로딩 열기
	function loadingOpen() {
	    
	}

	// 로딩 닫기
	function loadingClose() {
	    
	}
	
	function summernoteLoad(code){
		if(code == "NotFound"){
			commonUtil.msg("잘못된 접근 방식 입니다.");
			window.parent.closeNotisInf();
		}else{
			var content = getNoteData(code);
			$('#summernote').summernote({
				toolbar: [],
				height : height + 5,
	  			callbacks: {
					onInit: function(e) {
						$("#summernote").summernote("fullscreen.toggle");
					}
				}
	  		});
			setNoteText(content);
			$('#summernote').next().find(".note-editable").attr({"contenteditable": false,"style":"height :" + (height) + "px;"});
		}
	}
	
	function getNoteData(code){
		var data = "";
		
		var param = new DataMap();
		param.put("NTISEQ",code);
		
		var json = netUtil.sendData({
			module : "Wms",
			command : "MAINPOPUP",
			sendType : "map",
			param : param
		});
		
		if(json && json.data){
			data = json.data["CONTNT"];
			data = commonUtil.replaceAll(data, "&lt;", "<");
			data = commonUtil.replaceAll(data, "&gt;", ">");
		}
		
		return data;
	}
	
	function setNoteText(content){
		var markupStr = content;
		$('#summernote').summernote('code', markupStr);
	}
</script>
<body>
	<div id="summernote"></div>
</body>
</html>