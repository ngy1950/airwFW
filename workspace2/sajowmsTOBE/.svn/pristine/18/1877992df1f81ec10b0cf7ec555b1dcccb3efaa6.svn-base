<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ManualAllocate</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var popupchk = false;
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "OutBoundReport",
			command : "UnallocatedInfo",
		    menuId : "UnallocatedInfo"
		});
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		$("#OWNRKY").val(data.map.OWNRKY);	// data bind 가 안됨...
		$("#WAREKY").val(data.map.WAREKY);
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"] ) > 0){
	//				commonUtil.msgBox("SYSTEM_SAVEOK");
				this.close();
			}
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
		}
	}
	

	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div id="searchArea">
			<input type="hidden" id="OWNRKY" name="OWNRKY" class="input" ComboCodeView="true" readonly/>
			<input type="hidden" id="WAREKY" name="WAREKY" class="input" ComboCodeView="true" readonly/> 
			<input type="hidden" id="SHPOKY" name="SHPOKY" class="input" ComboCodeView="true" readonly/>
			<input type="hidden" id="SHPOIT" name="SHPOIT" class="input" ComboCodeView="true" readonly/>
			<input type="hidden" id="SKUKEY" name="SKUKEY" class="input" ComboCodeView="true" readonly/>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><label CL="STD_LIST"></label></a></li>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="160 STD_DESC01" GCol="text,DESC01" GF="S 180">제품명</td>	<!--제품명-->
			    						<!-- <td GH="80 STD_PTNRKY" GCol="text,PTNRKY" GF="S 20">업체코드</td>	업체코드
			    						<td GH="80 STD_PTNRNM" GCol="text,PTNRNM" GF="S 180">거래처명</td>	거래처명
			    						<td GH="80 STD_TELN01" GCol="text,TELN01" GF="S 100">전화번호1</td>	전화번호1
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	S/O 번호
			    						<td GH="80 STD_VGBEL" GCol="text,SVGBEL" GF="S 20">고객 P/O번호</td>	고객 P/O번호
			    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 17,0">지시수량</td>	지시수량
			    						<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 17,0">할당수량</td>	할당수량
			    						<td GH="80 STD_QTUALO" GCol="text,QTUALO" GF="N 17,0">미할당수량</td>	미할당수량
			    						<td GH="80 STD_CUSRID" GCol="text,CUSRID" GF="S 20">쇼핑몰 고객ID</td>	쇼핑몰 고객ID
			    						<td GH="80 STD_CUNAME" GCol="text,CUNAME" GF="S 150">고객명</td>	고객명
			    						<td GH="80 STD_CPSTLZ" GCol="text,CPSTLZ" GF="S 10">우편번호</td>	우편번호
			    						<td GH="80 STD_LAND1" GCol="text,LAND1" GF="S 3">국가 키 </td>	국가 키
			    						<td GH="80 STD_TELF1" GCol="text,TELF1" GF="S 50">전화번호1</td>	전화번호1
			    						<td GH="80 STD_TELE2" GCol="text,TELE2" GF="S 31">전화번호2</td>	전화번호2
			    						<td GH="80 STD_SMTPADDR" GCol="text,SMTPADDR" GF="S 723"></td>	
			    						<td GH="80 STD_KUKLA" GCol="text,KUKLA" GF="S 2">고객분류</td>	고객분류
			    						<td GH="80 STD_VTEXT" GCol="text,VTEXT" GF="S 1000">고객분류명</td>	고객분류명
			    						<td GH="80 STD_ADDR" GCol="text,ADDR" GF="S 360">주소</td>	주소
			    						<td GH="80 STD_CNAME" GCol="text,CNAME" GF="S 50">거래처 담당자명</td>	거래처 담당자명
			    						<td GH="80 STD_CPHON" GCol="text,CPHON" GF="S 20">거래처 담당자 전화번호</td>	거래처 담당자 전화번호
			    						<td GH="80 STD_BNAME" GCol="text,BNAME" GF="S 50">영업사원명</td>	영업사원명
			    						<td GH="80 STD_BPHON" GCol="text,BPHON" GF="S 20">영업사원 전화번호</td>	영업사원 전화번호 -->
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