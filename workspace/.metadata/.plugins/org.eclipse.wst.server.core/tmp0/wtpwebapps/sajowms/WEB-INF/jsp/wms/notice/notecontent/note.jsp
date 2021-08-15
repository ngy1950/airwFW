<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig,com.common.bean.DataMap,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	String referer = request.getHeader("referer");

	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	String code = "";
	if(request.getAttribute("code") != null){
		code = sFilter.getXSSFilter(request.getAttribute("code").toString());
	}
	
	String type = "";
	if(request.getAttribute("type") != null){
		type = sFilter.getXSSFilter(request.getAttribute("type").toString());
	}
	
	String noticePage = "";
	if(request.getAttribute("page") != null){
		noticePage = sFilter.getXSSFilter(request.getAttribute("page").toString());
	}
	
	String boardType = "";
	if(request.getAttribute("boardType") != null){
		boardType = sFilter.getXSSFilter(request.getAttribute("boardType").toString());
	}
%>
<%if(referer == null){%>
<script>
	this.location.href = "/wms/notice/notecontent/notAuthAccess.page";
</script>
<%}else{%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Summer Note</title>
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
	var type = "<%=type%>";
	var code = "<%=code%>";
	
	var height = 0;
	var width = 0;
	$(document).ready(function() {
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
		var toolbar = [
						  ['style', ['style']],
			              ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
			              ['fontsize', ['fontsize']],
			              ['color', ['color']],
			              ['para', ['ul', 'ol', 'paragraph', 'height']],
			              ['table', ['table']],
			              ['insert', ['link', 'hr']] 
			              /* ['insert', ['link', 'picture', 'hr']] */
		              ];
		
		switch (type) {
		case "edit":
			$('#summernote').summernote({
	  			placeholder: '내용을 입력해 주세요.',
	  			toolbar : toolbar,
	  			height : height,
	  			fontNames : [ '맑은고딕', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
	  			lang : 'ko-KR', 
	  			callbacks: {
					onInit: function(e) {
						$("#summernote").summernote("fullscreen.toggle");
						$('#summernote').summernote('code', '');
					},
					onImageUpload: function(files, editor, welEditable) {
			            for (var i = files.length - 1; i >= 0; i--) {
			            	sendFile(files[i], this);
			            }
			        }
				}
	  		});
			break;
		case "modify":
			var content = getNoteData(code);
			$('#summernote').summernote({
	  			placeholder: '내용을 입력해 주세요.',
	  			fontNames : [ '맑은고딕', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
	  			toolbar : toolbar,
	  			height : height,
	  			callbacks: {
					onInit: function(e) {
						$("#summernote").summernote("fullscreen.toggle");
					},
					onImageUpload: function(files, editor, welEditable) {
			            for (var i = files.length - 1; i >= 0; i--) {
			            	sendFile(files[i], this);
			            }
			        }
				}
	  		});
			setNoteText(content);
			break;
		case "detail":	
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
			break;
		default:
			break;
		}
	}
	
	function sendFile(file, el) {
		var form_data = new FormData();
      	form_data.append('file', file);
      	$.ajax({
        	data: form_data,
        	type: "POST",
        	url: "/common/image/fileUp/image.data",
        	cache: false,
        	contentType: false,
        	enctype: 'multipart/form-data',
        	processData: false,
        	success: function(resultData) {
        		resultData = commonUtil.getAjaxUploadFileList(resultData);
        		if(resultData.length > 0){
	        		for(var i = 0; i < resultData.length; i++){
	        			var param = new DataMap();
						param.put("UUID",resultData[i]);
						var json = netUtil.sendData({
							module : "Common",
							command : "FWCMFL0010",
							sendType : "map",
							param : param
						});
						
						if(json && json.data){
		          			$(el).summernote('editor.insertImage', json.data["RPATH"]+"/"+json.data["FNAME"]);
						}
	        		}
        		}
        	}
      	});
    }
	
	function getNoteData(code){
		var data = "";
		
		var param = new DataMap();
		param.put("NTISEQ",code);
		param.put("NTITYP","<%=boardType%>");
		
		var command = "<%=noticePage%>";
		
		var json = netUtil.sendData({
			module : "Notice",
			command : command,
			sendType : "map",
			param : param
		});
		
		if(json && json.data){
			data = json.data["CONTNT"];
		}
		
		return data;
	}
	
	function getNoteText(){
		var markupStr = $('#summernote').summernote('code');
		return markupStr;
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
<%}%>