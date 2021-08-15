<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>이관신청</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
		
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1502",
			gridMobileType : true
	    });
		
		searchList();
		
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			
			var param = inputList.setRangeParam("searchArea");
			param.put("USERID","<%=userid%>");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	/* 이관 신청 */
    function transApply(){
		
    	var smId = $('select[name="SM_ID"]').val();
    	if(smId == ""){ //이관대상자 미 선택시
    		commonUtil.msgConfirm("BL_VALID_SELECT",uiList.getLabel("BL_TRNS_TGP"))//이관대상자를 선택해주세요
    	}else{
	        if(commonUtil.msgConfirm("BL_DO_QUESTION",uiList.getLabel("STD_APLY"))){ //신청하시겠습니까?
	            
	            var list = gridList.getSelectData("gridList", true);
	        
	            var param = new DataMap();
	            param.put("USERID","<%=userid%>");
	            param.put("list", list);
	            param.put("smId",smId);
	            netUtil.send({
	                url : "/GCLC/Mobile/json/transferApply.data",
	                param : param,
	                successFunction : "saveDataCallBack"
	            });
	        }
    		
    	}
    	
    	
    }

    /* 성공 시 콜백함수 */
    function saveDataCallBack (json, returnParam) {
        if(json && json.data){
            commonUtil.msgBox("BL_DO_SUCCESS",uiList.getLabel("STD_APLY_CMPLET")); //"신청완료되었습니다."
            searchList();
        }else{
            commonUtil.msgBox("EXECUTE_ERROR"); //"실패하였습니다."
        }
    }
    
    function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
    	
		if(comboAtt == "MB1000,MB1502_COMBO" ){
			param.put("USERID", "<%=userid%>");
		}
		
		return param;
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
							<th CL="BL_TRNS_APLY_DT"></th>
							<td>
								<input type="text"  class="input" name="ACT_DT" UIFormat="C N"/>
							</td>
						</tr>
						<tr>
							<th CL="BL_TRNS_TGP"></th>
							<td>
								<select class="input" name="SM_ID" Combo="MB1000,MB1502_COMBO" ComboType="S" >
									<option value="" CL="STD_SEL"></option>
								</select>
							</td>
						</tr> 
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 395px);">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>이관신청</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">						
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="80" GCol="rownum">1</td>
										<td GH="80" GCol="rowCheck"></td>
										<td GH="500 픽업/고정" 		   GCol="text,PUP_NM"></td><!-- 픽업지/고정방문지 -->
										<td GH="500 STD_DVP_NM" 	   GCol="text,DVP_NM"></td><!-- 도착지 -->
										<td GH="300 STD_TM_INFO" 	   GCol="text,TIM"></td><!-- 시간 -->
										<td GH="200 STD_ALCTCR_NO"     GCol="text,TONO"></td><!-- 배차번호 -->
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
				<button onclick="searchList()"><span CL="BTN_SEARCH"></span></button>
				<button onclick="transApply()"><span CL="BTN_TRNS_APLY"></span></button>
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>