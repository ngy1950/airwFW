<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
	$(document).ready(function(){
		
		var data = page.getLinkPopData();

		$('#USERID2').val(data.get("USERID"));
		
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if (btnName == "Cancel") {
			this.close();
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"] ) > 0){
 				//commonUtil.msgBox("SYSTEM_M0096");
				this.close();
			}
		}
	}
	
	function saveData(){
			
		var param = dataBind.paramData("searchArea");
		
		if($.trim(param.get("USERID")) == "" ){ 
			//메세지     {0}사용자의 Layout이 존재하지 않습니다.
			commonUtil.msgBox("SYSTEM_M0095");
			return false;
		} 
			param.put("USERID2",$('#USERID2').val());
		
		netUtil.send({
			url : "/system/json/saveUI01_LAYOUTDLG.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	

	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        return param;
	}
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<input type="button" CB="Cancel CANCEL BTN_CANCEL" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
					<dt CL="STD_USERID"></dt> <!-- 사용자 ID -->
						<dd> 
							<input type="text" class="input" name="USERID" UIInput="S,SHUSRMA"/> 
							<input type="hidden" name="USERID2" id="USERID2" value="" />
						</dd> 
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>