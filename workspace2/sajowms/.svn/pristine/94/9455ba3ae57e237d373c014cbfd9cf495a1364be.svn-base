<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>개인별실적</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
	#gridList td { font-size: 3.0em; }
</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			gridMobileType : true
	    });
		
		gridList.setGrid({
	    	id : "gridList1",
			module : "MB1000",
			gridMobileType : true
	    });
		
		
		searchList();
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			
			var param = inputList.setRangeParam("searchArea");
			var command = "MB8001";
			var gridid = "gridList";
			param.put("USERID", "<%=userid%>");
			
			if ( param.map.WORG_GB == "01" ){
				$("#grid1").show();
				$("#grid2").hide();
			}else{
				command = "MB8001D";
				gridid = "gridList1"
				$("#grid2").show();
				$("#grid1").hide();
			}
			
			gridList.gridList({
		    	id :gridid,
		    	command : command,
		    	param : param
		    });
		}
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		
		var param = new DataMap();
		if (comboAtt[1] == "BLCDCOMBO"){
			param.put("GLB_CD", "WORK_GB");
		} 
		return param;
	}
	
	function gridListEventDataViewEnd(gridId, dataLength){
		$("#tab1-1 > div.btn_lit.tableUtil > span > span").text(dataLength - 1);
	}
</script>
</head>
<body>	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:40%" />
							<col style="width:60%" />
						</colgroup>
						<tr>
							<th CL="STD_DT"></th>
							<td>
								<input type="text" class="input" id="REQ_DAT" name="REQ_DAT" UIInput="SB" UIFormat="C N" validate="required" style="width: 75%;" />
							</td>
						</tr>
						<tr>
							<th>실적조건</th>
							<td>
								<select class="input" name="WORG_GB" Combo="BLCOMMON,BLCDCOMBO" >
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="grid1" class="content_layout tabs" style="height: calc(100% - 430px);">
				<div class="table_box section" id="tab1-1" style="height: 100%;">
					<div class="table_list01" style="height: calc(100% - 65px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="100 번호"   GCol="text,SEQ,center">1</td>
										<td GH="500 거래처"   		GCol="text,CLNT_NM" style="text-align: center;"></td><!-- 제목 -->
										<td GH="200 검체수"   		GCol="text,SPCM_QY" GF="N"></td><!-- 제목 -->
										<td GH="200 스캔수"   		GCol="text,SCANCNT" GF="N"></td><!-- 제목 -->
										<td GH="200 SLD수"    		GCol="text,SLD_QY"  GF="N"></td><!-- 제목 -->
										<td GH="200 출력수"   		GCol="text,PRTCNT"  GF="N"></td><!-- 제목 -->
										<td GH="300 IF의뢰건수"   	GCol="text,IFRCNT"  GF="N"></td><!-- 제목 -->
										<td GH="300 수기의뢰건수"   GCol="text,SUGCNT"  GF="N"></td><!-- 제목 -->
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
			
			<div id="grid2" class="content_layout tabs" style="height: calc(100% - 430px);">
				<div class="table_box section" id="tab1-1" style="height: 100%;">
					<div class="table_list01" style="height: calc(100% - 65px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">
<!-- 										<td GH="100"   GCol="rownum">1</td> -->
										<td GH="100 번호"   GCol="seq">1</td>
										<td GH="200 사업부"	   			GCol="text,BIZ_GB_CD" style="text-align: center;"></td><!-- 제목 -->
										<td GH="500 배송처"   			GCol="text,PD_NM" ></td><!-- 제목 -->
										<td GH="200 집하운송장"   		GCol="text,P_CNT" GF="N"></td><!-- 제목 -->
										<td GH="200 배송운송장"    		GCol="text,D_CNT" GF="N"></td><!-- 제목 --> 
										<td GH="200 총계" 	    		GCol="text,T_CNT" GF="N"></td><!-- 제목 -->
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
				<button class="btn_full" onclick="searchList()"><span>조회</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>