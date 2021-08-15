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
			command : "MB9010",
			gridMobileType : true
	    });
		searchList();
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			param.put("FORMAT","YYYYMMDD"); // SYSDATE
			
			var resultJson = netUtil.sendData({
				module : "BLCOMMON",
				command : "GETDATETIME",
				param : param,
				sendType : "map"
			 });
			
			param.put("TO_DTTM", resultJson.data.DATIM);
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	/* Row 클릭 이벤트 */
	function gridListEventRowClick(gridId, rowNum, colName) {
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = new DataMap();
			param.put("NOTI_SEQ_NO", rowData.map.NOTI_SEQ_NO);
			param.put("SRCH_CNT", rowData.map.SRCH_CNT);
		
			var resultJson = netUtil.sendData({ // 조회수 update
				module : "MB1000",
				command : "MB9010",
				param : param,
				sendType : "update"
			 });
			
			if(resultJson.data){
				this.location.href = "/mobile/MB9012.page?seq="+rowData.map.NOTI_SEQ_NO;	
			}
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
										<td GH="40"    GCol="rownum">1</td>
										<td GH="150"   GCol="text,TITLE"></td><!-- 제목 -->
										<td GH="80"    GCol="text,DRAW_PR_NM"></td><!-- 작성자명 -->
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
</body>
</html>