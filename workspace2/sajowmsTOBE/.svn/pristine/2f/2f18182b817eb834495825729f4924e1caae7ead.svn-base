<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mobile</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style>
	
.cmm-layer-popup{display:none;position:fixed;left:0;top:0;width:100%;height:100%;}
.cmm-layer-popup.active{display:block;z-index: 0;}
.cmm-layer-popup .loading{width:100%;height:100%;text-align:center;background:rgba(0, 0, 0, 0.7);}
.cmm-layer-popup .loading:before{display:block;content:'';position:absolute;left:50%;top:50%;margin:-200px 0 0 -75px;width:150px;height:150px;border-radius:50%;background:url(/common/images/icon-loading.gif) no-repeat left top;background-size:100% 100%;}
.cmm-layer-popup .loading .content{position:absolute;left:0;top:50%;padding:0;width:100%;color:#fff;font-size:22px;letter-spacing:10px;text-align:center;background:none;}

.cmm-layer-popup .content{position:relative;padding:20px 30px 30px 30px;background:#fff;}
.cmm-layer-popup .top-box{position:relative;padding:15px 30px;color:#fff;font-size:18px;background:#0593e7;}
.cmm-layer-popup .btn-close{position:absolute;right:0;top:0;margin-left:0;padding:0;width:50px;min-width:50px;height:100%;text-indent:-9999px;border:none;background:url(/common/images/btn-close.png) no-repeat center;}
.cmm-layer-popup .btn-dim{position:absolute;left:0;top:0;margin-left:0;width:100%;height:100%;text-indent:-99999px;background:rgba(0, 0, 0, 0.7);border:none;}


.cmm-layer-popup .page{position:absolute;left:50%;top:50%;margin-left:-420px;width:840px;border-radius:10px;overflow:hidden;transform:translateY(-50%);-webkit-transform:translateY(-50%);z-index:1;}

.cmm-layer-popup .alert{position:absolute;left:50%;top:50%;margin-left:-250px;width:500px;border-radius:10px;overflow:hidden;transform:translateY(-50%);-webkit-transform:translateY(-50%);z-index:1;}
.cmm-layer-popup .alert .content{padding-top:50px;padding-left:160px;}
.cmm-layer-popup .alert .content:before{display:block;content:'';position:absolute;left:30px;top:30px;width:100px;height:100px;border-radius:50%;background:#ddd;}
.cmm-layer-popup .alert .content:after{display:block;content:'';position:absolute;left:80px;top:58px;width:4px;height:28px;border-radius:2px;background:#fff;}
.cmm-layer-popup .alert .content .tit:before{display:block;content:'';position:absolute;left:80px;top:95px;width:4px;height:4px;border-radius:2px;background:#fff;}
.cmm-layer-popup .alert .content .tit{margin-bottom:20px;color:#222;font-size:20px;}
.cmm-layer-popup .alert .content .txt{margin-bottom:20px;line-height:24px;color:#888;font-size:16px;}

.cmm-layer-popup .delete{position:absolute;left:50%;top:50%;margin-left:-250px;width:500px;border-radius:10px;overflow:hidden;transform:translateY(-50%);-webkit-transform:translateY(-50%);z-index:1;}
.cmm-layer-popup .delete .content{padding-top:35px;padding-left:160px;}
.cmm-layer-popup .delete .content:before{display:block;content:'';position:absolute;left:30px;top:25px;width:100px;height:100px;border-radius:50%;background:#ddd;}
.cmm-layer-popup .delete .content:after{display:block;content:'?';position:absolute;left:35px;top:30px;width:100px;line-height:100px;color:#fff;font-size:60px;text-align:center;}
.cmm-layer-popup .delete .content .tit{margin-bottom:20px;color:#222;font-size:20px;}
.cmm-layer-popup .delete .content .btn-box{display:block;padding-top:20px;text-align:right;border-top:solid 1px #ddd;}

</style>
<script type="text/javascript" src="/common/js/bl.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function GcimAlert (subTitle, message, title, callbackFunction) {
		var alertId = "alert";
		if(!bl.isNull($("#" + alertId).attr("id"))) {
			return false;
		}
		
		if(bl.isNull(title)) title = "알림";
		if(bl.isNull(subTitle)) subTitle = "&nbsp;";
		if(bl.isNull(message)) message = "&nbsp;";
		
		var div_popup = $("<div/>").addClass("cmm-layer-popup").attr("id",alertId).addClass("active");
		var div_alert = $("<div/>").addClass("alert");
		var div_topBox = $("<div/>").addClass("top-box");
		var btn_close = $("<button/>").attr("type","button").addClass("btn-close").html("close");
		// 상단 x버튼 클릭 이벤트
		btn_close.click(function () {
			div_popup.removeClass("active");
			$("#warp").attr("area-hidden","false");
			div_popup.remove();
			if(callbackFunction && {}.toString.call(callbackFunction) === '[object Function]') {
				return callbackFunction();
			}
		});
		var btn_dim = $("<button/>").attr("type","button").addClass("btn-dim").html("close");
		// 외부 영역 클릭 이벤트
		btn_dim.click(function () {
			$(".btn-close").click();
		});
		
		div_topBox.append($("<h2/>").addClass("tit").html(title))
				  .append(btn_close);
		var div_content = $("<div>").addClass("content");
		div_content.append($("<p/>").addClass("tit").html(subTitle))
				   .append($("<p/>").addClass("txt").html(message));
		
		$(div_alert).append(div_topBox);
		$(div_alert).append(div_content);
		$(div_popup).append(div_alert);
		$(div_popup).append(btn_dim);
		
		$(".content_wrap").attr("area-hidden","true");
		$(document.body).append(div_popup);
	}
	
	function GcimConfirm(message, buttons, title) {
		var confirmObj = "confirmGcim";
		if(!bl.isNull($("#" + confirmObj).attr("id"))) {
			return false;
		}
		
		if(bl.isNull(title)) title = "확인";
		if(bl.isNull(message)) message = "&nbsp;";
		if(bl.isNull(buttons)) buttons = [{"btn_class":"btn-save","btn_text":"확인","btn_function" : function () {return true;}}
									 , {"btn_class":"btn-cancel","btn_text":"취소","btn_function" : function () {return false;}}];
				
		var div_popup = $("<div/>").addClass("cmm-layer-popup").attr("id",confirmObj).addClass("active");
		var div_delete = $("<div/>").addClass("delete");
		var div_topBox = $("<div/>").addClass("top-box")
						.append($("<h2/>").addClass("tit").html(title))
						.append($("<button/>").attr("type","button").addClass("btn-close").html("&nbsp;"));
		var div_content = $("<div>").addClass("content").append($("<p/>").addClass("tit").html(message));
		var div_btnBox = $("<div/>").addClass("btn-box");
		
		for(var i = 0 ; i < buttons.length; i++) {
			btn_class = (bl.isNull(buttons[i].btn_class))?"btn_cancel":buttons[i].btn_class;
			btn_text = buttons[i].btn_text; (bl.isNull(buttons[i].btn_text))?(i==0)?"확인":"취소":buttons[i].btn_text;
	
			btn = $("<button/>").attr("type","button").addClass(btn_class).html(btn_text).attr("data-btn-idx",i);
			btn.on("click",function (){
				//console.log("================ " + $(this).html() + "/" + "class : " + $(this).attr("class") + "/data-button-idx : " + $(this).attr("data-btn-idx"));
				div_popup.removeClass("active");
				$("#warp").attr("area-hidden","false");
				div_popup.remove();
				btn_function = buttons[$(this).attr("data-btn-idx")].btn_function;
				if(btn_function && {}.toString.call(btn_function) === '[object Function]') {
					return btn_function();
				}
			});
			div_btnBox.append($(btn));
		}

		var btn_dim = $("<button/>").attr("type","button").addClass("btn-dim").html("&nbsp;");
		$(div_delete).append(div_topBox);
		$(div_content).append(div_btnBox);
		$(div_delete).append(div_content);
		$(div_popup).append(div_delete);
		$(div_popup).append(btn_dim);
		
		$("#warp").attr("area-hidden","true");
		$(document.body).append(div_popup);
	}
	
	function confirmTest() {
		GcimConfirm("확인?"
		,[{btn_class:"btn-delete", btn_text:"확인" , btn_function : function () {
			alert("confirm true");
		}}
		,{btn_class:"btn-cancel", btn_text:"취소" , btn_function : function () {
			alert("confirm false");
		}}]
		,"확인")
	}
</script>
</head>
<body>
<%@ include file="/common/include/mobile/top.jsp" %>	
	<!-- top 시작 -->
	<div class="content_top" >
		<h1 class="btn_ghost">
			<a href="#none"><span>ghost</span></a>
		</h1>
		<div class="title_wrap">
			<span class="title">수탁</span>
		</div>
		<div class="setting">
			<a href="#none"><span></span></a>
		</div>
	</div>
	<!-- top 끝 -->
	
	<!-- setting 시작 -->
	<div class="deem_setting off">
		<div class="top">
			<div class="left"></div>
			<div class="right">
				<div class="first"></div>
				<div class="second"></div>
			</div>
		</div>
		<div class="bot">
			<h2><span>관리자</span> 님</h2>
			<h3><span class="icon"></span><span>2020-04-17 오전 10:20</span></h3>
			<button><span>로그아웃</span></button>
		</div>
	</div>
	<!-- setting 끝 -->
	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:100px">
				<div class="search_inner">
					
				</div>
			</div>
			<div class="content_layout tabs" style="height:80%;">

			</div>			
			<!-- 하단 버튼 시작 -->
			<div class="foot_btn">
				<button onclick="GcimAlert('test','hello','ALERT',null);"><span>ALERT</span></button>
				<button onClick="confirmTest()"><span>CONFIRM</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
</body>
</html>