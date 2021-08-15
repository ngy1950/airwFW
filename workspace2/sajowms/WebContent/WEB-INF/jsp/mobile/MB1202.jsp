<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>행낭 바코드 출력</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1202",
			gridMobileType : true
	    });
		
		searchList();
		
	});
	/*  user 내가속한영업소 가져오기 */
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
		window.GCLABCELL_BRIDGE.printHnbarcode(json);
	}
	
</script>
</head>
<body >	
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
							<th CL="STD_TEMPER_CNDT"></th>
							<td class="ms-wrap">
								<select class="input" name="GOAL_TEMPER_CD" Combo="MB1000,GOALTEMPERCOMBO" >
									<option value="" CL="STD_ALL"></option>
								</select><!-- 온도조건 -->
							</td>
						</tr>
						<tr>
							<th CL="STD_PUCH_CD"></th>
							<td>
								<input type="text" class="input" name="PUCH_CD" IAname="Search" style="width:calc(100% - 60px;)"/><!-- 행낭ID -->
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 455px);">
<!-- 				<ul class="tab tab_style02"> -->
<!-- 					<li class="selected"><a href="#tab1-1"><span>행낭 바코드</span></a></li> -->
<!-- 				</ul> -->
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 43px);">
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
										<td GH="90" GCol="rownum">1</td>
										<td GH="90" GCol="rowCheck"></td>
										<td GH="260 STD_PUCH_CD" 		GCol="text,PUCH_CD"></td><!-- 행낭ID -->
										<td GH="160 사용처" 		    GCol="text,USE_PL"></td><!-- 행낭ID -->
										<td GH="350 STD_TEMPER_CNDT" 	GCol="text,OD_TYP_NM"></td><!-- 온도조건 -->
										<td GH="200 STD_BIZOFFICE" 		GCol="text,BZO_NM"></td><!-- 영업소 -->
                                        <td GH="200 STD_CREID"      GCol="text,PRINTNM"></td><!-- 등록자 -->
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
				<button onclick="printList()"><span>출력</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>