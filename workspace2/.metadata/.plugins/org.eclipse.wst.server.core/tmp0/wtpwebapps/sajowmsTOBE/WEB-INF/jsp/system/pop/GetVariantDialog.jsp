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
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "VARIANT",
		    menuId : "GetVariantDialog"
		});

		pageData = page.getLinkPopData();
		if(pageData){
			dataBind.dataNameBind(pageData, "searchArea");	
		}
		
		searchList();
		gridList.setReadOnly("gridList", true, ["DEFCHK"]);
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "DELETE"){
			deleteVariant();
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
			param.put("USERID", "<%=userid%>");
			param.put("PROGID", pageData.get("PROGID"));
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
		}
	}
	

	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var param = new DataMap();
			param.put("TYPE", "GET");
			param.put("PARMKY", gridList.getColData(gridId, rowNum, "PARMKY"));
			param.put("USERID", gridList.getColData(gridId, rowNum, "USERID"));
			param.put("PROGID", gridList.getColData(gridId, rowNum, "PROGID"));
			page.linkPopClose(param);
		}
	}
	
	function deleteVariant(){
		var list = gridList.getSelectData("gridList", true);
		
		if(list.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		sajoUtil.deleteVariant(list[0].map);
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

		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><label CL="STD_LIST"></label></a></li>
					<div>                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; margin-left: 10px"> <!-- 세트 -->
							<input type="button" CB="DELETE DELETE BTN_DELETE" />
						</li>                                        
					</div>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
										<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td>
			    						<td GH="160 STD_USERID" GCol="text,USERID" GF="S 20">사용자ID</td>	<!--사용자ID-->
			    						<td GH="160 STD_PARMKY" GCol="text,PARMKY" GF="S 20" >파라메타키</td>	<!--파라메타키-->
			    						<td GH="160 STD_PROGID" GCol="text,PROGID" GF="S 20">프로그램ID</td>	<!--프로그램ID-->
				    					<td GH="100 STD_DEFAULT" GCol="check,DEFCHK">삭제</td>	<!--기본 여부-->
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