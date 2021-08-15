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
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "UI01_UserDialog",
			pkcol : "USERID",
			editable : true,
		    menuId : "UI01_UserDialog"
		});
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		
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
// 				commonUtil.msgBox("SYSTEM_SAVEOK");
				this.close();
			}
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
		}
	}
	
	
	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getGridData("gridList");
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			param.put("USERID",$('#USERID').val());
			
			netUtil.send({
				url : "/system/json/saveUI01_UserDialog.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
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
					<input type="button" CB="Cancel CANCEL BTN_CANCEL" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_USERID"></dt><!-- 사용자 ID -->
						<dd>
							<input type="text" class="input" name="USERID" id="USERID" IAname="Search" maxlength="10" readonly="true" />
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><label CL="STD_LIST"></label></a></li>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
			    						<td GH="150 STD_UROLKY" GCol="text,UROLKY" GF="S 10"></td>	<!--사용자 권한키-->
			    						<td GH="150 STD_SHORTX" GCol="text,SHORTX" GF="S 180"></td>	<!--설명-->
			    						<td GH="80 STD_SELECT" GCol="check,CHK"></td>	<!--선택-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
				
			</div>
	   </div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>