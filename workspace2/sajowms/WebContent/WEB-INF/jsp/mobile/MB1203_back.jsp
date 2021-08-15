<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>포장 바코드 출력</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1203",
			gridMobileType : true
	    });
		
		searchList();
		
	});
	
	/* 조회 */
	function searchList(){
	
		gridList.gridList({
	    	id : "gridList",
	    	param : null
	    });
		
	}
	
	/* 출력 */
	function printList(){
		var selectData = gridList.getSelectData("gridList");
		var json = "";
		for ( var i=0; i<selectData.length; i++ ){
			
			if ( i == 0 )
				json += "[";
			
			json += selectData[i].jsonString();
			
			if ( i != (selectData.length - 1 ) )
				json +=",";
			
			if ( i == (selectData.length - 1 ) )
				json +="]";
			
		}
		window.GCLABCELL_BRIDGE.printPgbarcode(json);
	}
	
</script>
</head>
<body >
	 
	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			 
			<div class="content_layout tabs" style="height: calc(100% - 161px);">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>포장 바코드</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 70px);">
							<table class="table_c">
								<colgroup>
									<col style="width:10%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:15%" />
								</colgroup>								
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="120 STD_RCV_DEPT" 	GCol="text,CD_NM"></td><!-- 수신부서 -->
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
				<!-- <button onclick="searchList()"><span>조회</span></button> -->
				<button onclick="printList()" class="btn_full"><span>출력</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>