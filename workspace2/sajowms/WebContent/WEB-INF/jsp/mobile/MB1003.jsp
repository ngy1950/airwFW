<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>방문순서 등록</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridList",
			module : "MB1000",
			command : "MB1003",
			gridMobileType : true
		});
		
		searchList();
		
		$("#tab1-1 > div.table_list01 > div.table_thead.tableHeader > table > thead > tr > th:nth-child(2)").html("고정방문<input type='checkbox' class='GEditBack' id='HeadVisit' onClick='headVisitClick()'>");
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("USERID", "<%=userid%>");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	/* 저장 */
	function saveData(){
		var list = gridList.getModifyList("gridList", "A");
		
		if(gridList.getModifyRowCount("gridList") == 0){
			commonUtil.msgBox(configData.MSG_SYSTEM_SAVEEMPTY); // 변경된 데이터가 없습니다.
			return;
		}
		
		if( !commonUtil.msgConfirm("SYSTEM_SAVECF") ){ // 저장하시겠습니까?
			return;
		}
		
		var param = new DataMap();
		param.put("list", list);
		
		netUtil.send({
			url : "/GCLC/Mobile/json/saveMB1003.data",
			param : param,
			successFunction : "saveDataCallBack"
		});
	}
	
	/* 저장 콜백 */
	function saveDataCallBack (json, returnParam) {
		if( !json.data.cono && json.data ){
			commonUtil.msgBox("SYSTEM_SAVEOK");
			gridList.resetGrid("gridList");
			searchList();
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
	}	
	
	function headVisitClick(){
		var list = gridList.getGridData("gridList");
		
		if(list.length > 0){
			gridList.dataCheckAll("gridList","FIX_VISIT_YN",$("#HeadVisit").is(":checked"));
		}
	}
</script>
</head>
<body >	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_layout tabs" style="height: calc(100% - 175px);">
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 45px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="100" 				GCol="rownum">1</td>
										<td GH="300 고정방문"		GCol="check,FIX_VISIT_YN"></td><!-- 방문여부 -->
										<td GH="500" 				GCol="text,CLNT_NM"></td>
										<td GH="200 이관여부"	    GCol="text,IG_TYPE"></td><!-- 영업소 -->
										<td GH="300 STD_MNG"		GCol="text,MNG_NM"></td><!-- 담당자 -->
										<td GH="350 STD_CTTPC"		GCol="text,TEL_NO"></td><!-- 연락처 -->
										<td GH="800"				GCol="text,IF_ADDR"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<div class="btn_out_wrap">

						</div>
						<span class='txt_total' >총 <span GInfoArea='true'>4</span> 건</span>
					</div>
				</div>
				<div class="table_box" id="tab1-2" style="display:none;">
					<div class="inner_search_wrap">
					</div>
				</div>
			</div>			
			<!-- 하단 버튼 시작 -->
			<div class="foot_btn">
				<button onclick="searchList()"><span>조회</span></button>
				<button onclick="saveData()"><span>저장</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>