<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>미처리 사유 조회 </title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1802",
			gridMobileType : true
	    });
	});
	
	/* 조회 */
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
		var list = gridList.getSelectData("gridList");
		
		if(list.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY"); // 선택된 데이터가 없습니다.
			return;
		}
		
		if(gridList.validationCheck("gridList", "select")){
			var param = new DataMap();
			param.put("list", list);

			netUtil.send({
				url : "/GCLC/Mobile/json/saveMB1801.data",
				param : param,
				successFunction : "saveDataCallBack"
			}); 
		}
	}
	
	function saveDataCallBack(json, returnParam){
		if( json && json.data ){
			commonUtil.msgBox("SYSTEM_SAVEOK");
			searchList();
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
	}
	
	function comboEventDataBindeBefore(comboAtt,paramName){
		
		var param = new DataMap();
		if (comboAtt[1] == "BLCDCOMBO"){
			param.put("GLB_CD", "UNPR_RESN_CD");
		} 
		return param;
	}
	
	function clean(){
		gridList.resetGrid("gridList");
		$("input[name='UNPR_RESN_CD']").val("");
		$("input[name='REG_DT']").val("");
	}
</script>
</head>
<body >
	<div class="content_top" > 
		<div class="title_wrap">
			<span class="title"></span>
		</div> 
	</div> 
	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:100px">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:30%" />
							<col style="width:70%" />
						</colgroup>
						<tr>
							<th CL="STD_UNPR_GB"></th><!-- 미처리구분 -->
							<td>
								<select class="input" name="UNPR_RESN_CD" Combo="BLCOMMON,BLCDCOMBO" ComboCodeView="false"><option value="">전체</option></select>
							</td>
						</tr>
						<tr>
							<th CL="STD_REG_DT"></th><!-- 등록일자 -->
							<td>
								<input type="text" class="input" name="REG_DT" UIFormat="C N" /><!-- 행낭ID -->
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height:80%;">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span CL="STD_UNPR_RESN_RECH"></span></a></li>
				</ul> 	
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 70px);">
							<table class="table_c">
								<colgroup>
									<col style="width:10%"/>
									<col style="width:15%"/>
									<col style="width:15%"/>
									<col style="width:15%"/>
									<col style="width:15%"/>
									<col style="width:15%"/>
									<col style="width:15%"/>
								</colgroup>
								<tbody id="gridList">
									<tr CGRow="true"> 
										<td GH="70" GCol="rownum">1</td>
										<td GH="220 STD_SONO"      GCol="text,SONO"></td><!-- 주문번호 -->
										<td GH="120 STD_PUP"       GCol="text,PUP_NM"></td><!-- 픽업지 -->
										<td GH="120 STD_DVP"       GCol="text,DVP_NM"></td><!-- 배송지 -->
										<td GH="120 STD_UNPR_GB"   GCol="text,UNPR_RESN_NM"></td>
										<td GH="200 STD_UNPR_CNTS" GCol="text,UNPR_RESN_CNTS"></td>
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
				<button onclick="clean()"><span>초기화</span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>