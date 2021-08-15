<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>권한 메뉴ID 생성</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
// 	$(document).ready(function(){
// // 		});
// 	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			create();
		}
	}
	
	function create(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			 
			netUtil.send({
				url : "/system/json/createUR01.data",
				param : param,
				successFunction : "saveDataCallBack"
			});
		}
	}
	
	//저장콜백
	function saveDataCallBack (json, returnParam){
		if(json && json.data){
			if(json.data["saveCk"] == false){
				commonUtil.msgBox(json.data["ERROR_MSG"], json.data["COL_VALUE"]);
			}else {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				closePop();
			}
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
	}
	
	function closePop(){
		var param = inputList.setRangeParam("searchArea");
		param.put("CLOSE_TYPE","CREATE");
		page.linkPopClose(param);
	}
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<div class="content_wrap" style="min-width:auto;overflow:hidden;">
	<div class="content_inner">
<%-- 		<%@ include file="/common/include/webdek/title.jsp" %> --%>
		<div class="title-box">
			<h2 class="title">권한 메뉴ID 생성</h2>
		</div>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Create ADD BTN_NEW" />
				</div>
			</div>
            <div class="search_inner">
                <table class="find_idpw" id="detail">
                    <colgroup>
                        <col style="wdith: 30%">
                        <col style="width: 70%">
                    </colgroup>
                    <tr>
                        <th CL="STD_COMPID"></th> <!-- 회사  ID -->
                        <td>
                            <input type="text" class="input" name="COMPID" maxlength="10" readonly="true" value="<%= compky%>"/>
                        </td>
                    </tr> 
                    <tr>
                        <th CL="STD_MENUCOMCOD"></th> <!-- 메뉴권한코드 -->
                        <td>
                            <input type="text" class="input" name="MENUGID" maxlength="35" validate="required"/>
                        </td>
                    </tr>
                </table>
            </div>
		</div>
	</div>
</div>
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>