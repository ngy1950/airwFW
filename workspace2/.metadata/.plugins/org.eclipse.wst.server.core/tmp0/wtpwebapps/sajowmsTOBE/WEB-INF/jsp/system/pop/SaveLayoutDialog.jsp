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
	var pageData; 
	var groupdata;
	$(document).ready(function(){
		
// 		gridList.setGrid({
// 			id : "gridList",
// 			module : "System",
// 			command : "SaveVariantDialog",
// 			//pkcol : "USERID",
// 			editable : true
// 		});
		
		pageData = page.getLinkPopData();
		if(pageData){
			dataBind.dataNameBind(pageData, "searchArea");	
			groupdata = pageData.get("GROUPDATA"); 
		}
		
		//searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}
	}
	
	//저장
	function saveData(){
		if(validate.check("searchArea")){
			var param = pageData;
			if($('#DEFAULT').prop("checked") == false){
				param.put("DEFCHK"," ");
			}else if($('#DEFAULT').prop("checked") == true){
				param.put("DEFCHK","V"); 
			}
			param.put("GROUPDATA", groupdata);
			param.put("COLGID", $("#COLGID").val());
			
			sajoUtil.saveLayout(param);
		}
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
<!-- 					<input type="button" CB="Cancel CANCEL BTN_CANCEL" /> -->
				</div>
			</div>
			<div class="search_inner" >
				<div class="search_wrap" style="height: auto;">
					<dl>
						<dt CL="STD_PROGID"></dt><!-- 프로그램 ID -->
						<dd>
							<input type="text" class="input" name="PROGID" id="PROGID" IAname="Search" maxlength="10" readonly="true"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_USERID"></dt><!-- 사용자 ID -->
						<dd>
							<input type="text" class="input" name="USERID" id="USERID" IAname="Search" maxlength="10" readonly="true" value="<%=userid%>"/>
						</dd>
					</dl>
					 <dl> 
						<dt CL="STD_DEFAULT"></dt><!--  기본-->
						<dd>
							<input type="checkbox" class="input" name="DEFAULT" id="DEFAULT" style="margin:0;"/>
						</dd>
					</dl>
					<dl> 
						<dt CL="STD_SHORTX"></dt> <!-- 설명 -->
						<dd>
							<input type="text" class="input" id ="COLGID" name="COLGID" style="width:300px;"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab on">
<!-- 					<input type="button" class="btn_more" value="more" onclick="searchMore()"/> -->
				</div>
			</div>
	   </div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>