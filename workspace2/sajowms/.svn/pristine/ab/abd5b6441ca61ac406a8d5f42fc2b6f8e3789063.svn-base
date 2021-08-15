<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>이관승인</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB1504",
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
	
	/* 이관 승인 */
	function transferAdms(){
		
		if(commonUtil.msgConfirm("BL_DO_QUESTION",uiList.getLabel("STD_ADMS"))){ //승인하시겠습니까?
			
			var list = gridList.getSelectData("gridList", true);
		
			var param = new DataMap();
            param.put("list", list);
            param.put("USERID","<%=userid%>");
            
			netUtil.send({
	            url : "/GCLC/Mobile/json/transferAdmission.data",
	            param : param,
	            successFunction : "saveDataCallBack"
	        });
		}
	}

	/* 성공 시 콜백함수 */
    function saveDataCallBack (json, returnParam) {
        if(json && json.data){
            commonUtil.msgBox("SYSTEM_SAVEOK"); //"저장 완료되었습니다."
            searchList();
        }else{
            commonUtil.msgBox("EXECUTE_ERROR"); //"실패하였습니다."
        }
    }
	
    /* 이관 거절 */
	function transferReject() {
		
		if(commonUtil.msgConfirm("BL_DO_QUESTION","거절")){ //승인하시겠습니까?
			
			var list = gridList.getSelectData("gridList", true);
		
			var param = new DataMap();
            param.put("list", list);
            param.put("USERID","<%=userid%>");
            
			netUtil.send({
	            url : "/GCLC/Mobile/json/transferReject.data",
	            param : param,
	            successFunction : "saveDataRejectCallBack"
	        });
		}
	}
	
	/* 성공 시 콜백함수 */
    function saveDataRejectCallBack (json, returnParam) {
        if(json && json.data){
            commonUtil.msgBox("SYSTEM_SAVEOK"); //"저장 완료되었습니다."
            searchList();
        }else{
            commonUtil.msgBox("EXECUTE_ERROR"); //"실패하였습니다."
        }
    }
	
</script>
</head>
<body >
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:200px">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:40%" />
							<col style="width:60%" />
						</colgroup>
						<tr>
							<th CL="BL_TRNS_APLY_DT"></th><!-- 이관신청일자 -->
							<td>
								<input type="text"  class="input" name="TRNS_APLY_DT" UIFormat="C N" />
							</td>
						</tr>
						<tr>
							<th CL="STD_ADMS_YN"></th><!-- 승인여부 -->
							<td>
								<select name="TRNS_ADMS_YN" id="TRNS_ADMS_YN" class="input" commonCombo="STATE_YN" ComboCodeView="false" >
								  <option value="" CL="STD_SEL"></option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height:calc(100% - 395px);">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span CL="BL_TRS_ST"></span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
						<div class="scroll" style="height:calc(100% - 110px);">
							<table class="table_c">								
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="80" GCol="rownum">1</td>
										<td GH="80" GCol="rowCheck"></td>
										<td GH="200 STD_ADMS_YN" 		GCol="text,TRNS_ADMS_YN"></td><!-- 승인여부 -->
										<td GH="300 이관신청자" 		GCol="text,TRNS_APLY_MNG_NM"></td><!-- 이관대상자명 -->
										<td GH="300 BL_TRNS_TGP_NM" 	GCol="text,TRNS_TGP_NM"></td><!-- 이관대상자명 -->
										<td GH="500 픽업/고정" 		    GCol="text,PUP_NM"></td><!-- 픽업지명 -->
										<td GH="500" 		            GCol="text,DVP_NM"></td><!-- 배송지명 -->
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
				<button class="btn_first" onclick="searchList()"><span CL="BTN_SEARCH"></span></button>
				<button class="btn_second" onclick="transferReject()"><span CL="이관거절"></span></button>
				<button class="btn_third" onclick="transferAdms()"><span CL="BL_TRNS_ADMS"></span></button>
				
			</div>
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
	</div>
	
</body>
</html>