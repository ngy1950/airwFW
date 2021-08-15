<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
	#gridList td { font-size: 3.0em; }
</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB9011",
			gridMobileType : true
	    });
		searchList();
	});
	
	/* 조회 */
	function searchList(){
			
		var param = new DataMap();
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	function gridListEventRowClick(gridId, rowNum, colName){
		if(colName == "CPH"){
			var cph = gridList.getColData(gridId,rowNum,"X_CPH");
			window.GCLABCELL_BRIDGE.phoneCall(cph);
		}
	}
	
	
</script>
</head>
<body >
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_layout tabs" style="height: calc(100% - 16px);">
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 65px);">
						<div class="scroll" style="height:calc(100% - 70px);">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="80"    GCol="rownum">1</td>
										<td GH="200 기사구분"   GCol="text,CD_NM"></td>
										<td GH="200"   GCol="text,DRIVR_NM"></td>
										<td GH="300"   GCol="text,CPH"></td>
										<td GH="500"   GCol="text,EMAIL"></td>
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
		</div>
	</div>
	<!-- content 끝 -->
	<div id="tel" onClick="#" style="display:hidden"></div>
</body>
</html>