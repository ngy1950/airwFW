<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL21</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList1",
		module : "Report",
		command : "RL21_1",
		pkcol : "SHPOKY",
	    menuId : "RL21"
    });
	gridList.setGrid({
    	id : "gridList2",
		module : "Report",
		command : "RL21_2",
		pkcol : "SHPOKY",
	    menuId : "RL21"
    });
	gridList.setGrid({
    	id : "gridList3",
		module : "Report",
		command : "RL21_3",
		pkcol : "SHPOKY",
	    menuId : "RL21"
    });
	
	inputList.rangeMap["map"]["CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
	inputList.rangeMap.get("CARDAT").setMultiData(true);
	
	//배열선언
	var rangeArr = new Array();
	//배열내 들어갈 데이터 맵 선언
	var rangeDataMap = new DataMap();
	// 필수값 입력 
	rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,">="); // =  != > < 표시
	rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dateParser(null, "S", 0, 0, 1));
	//배열에 맵 탑제 
	rangeArr.push(rangeDataMap);
	setSingleRangeData('CARDAT', rangeArr);
	
	//ReadOnly 설정
	gridList.setReadOnly("gridList1",true,["SHPMTY","PGRC02","PGRC03","FORKYN","PGRC04","SKUG05","DCNDTN"])
	gridList.setReadOnly("gridList2",true,["SHPMTY","PGRC02","PGRC03","FORKYN","CARGBN","SKUG05","DCNDTN"])
	gridList.setReadOnly("gridList3",true,["SHPMTY","PGRC02","PGRC03","FORKYN","SKUG05","DCNDTN"])
	
	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();
});

/* 
 * 그리드별 검색 제외 조건
 * 그리드1            
 * --LOTA11 ,제조일자
 * --LOTA12 ,입고일자
 * --LOTA13 ,유통기한
 * --PG04NM ,요구사업장명
 * 그리드 2
 * --SVBELN2 ,S/O 번호
 * --DOCDAT ,문서일자
 * --SKUKEY ,제품코드
 * --DESC01 ,제품명
 * --LOTA11 ,제조일자
 * --LOTA12 ,입고일자
 * --LOTA13 ,유통기한
 * 그리드 3
 * --DOCDAT 문서일자
 */

function searchList(){
	$('#atab1-1').trigger("click");
}

function gridListEventDataBindEnd(gridId, dataCount){
	if(dataCount > 0){
		gridList.getGridBox(gridId).viewTotal(true);
	}
}

function display1(){
	if(validate.check("searchArea")){
 		gridList.resetGrid("gridList1");
 		gridList.resetGrid("gridList2");
 		gridList.resetGrid("gridList3");
		var param = inputList.setRangeMultiParam("searchArea");

		netUtil.send({
			url : "/Report/json/displayRL21_1.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridList1" //그리드ID
		});
	}
}
function display2(){
	if(validate.check("searchArea")){
 		gridList.resetGrid("gridList1");
 		gridList.resetGrid("gridList2");
 		gridList.resetGrid("gridList3");
		var param = inputList.setRangeMultiParam("searchArea");

		netUtil.send({
			url : "/Report/json/displayRL21_2.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridList2" //그리드ID
		});
	}
}
function display3(){
	if(validate.check("searchArea")){
 		gridList.resetGrid("gridList1");
 		gridList.resetGrid("gridList2");
 		gridList.resetGrid("gridList3");
		var param = inputList.setRangeMultiParam("searchArea");

		netUtil.send({
			url : "/Report/json/displayRL21_3.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridList3" //그리드ID
		});
	}
}

// function gridListEventDataBindEnd(gridId, dataCount){
// 	if(gridId == "gridList1" &&  dataCount > 0){
// 		gridList.getGridBox(gridId).viewTotal(true);
// 	}
// }


function gridListEventRowAddBefore(gridId, rowNum){
	var newData = new DataMap();
	newData.put("LANGCODE","<%=langky%>");
	newData.put("LABELTYPE","WMS");
	return newData;
}

//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
function comboEventDataBindeBefore(comboAtt, $comboObj){
	var param = new DataMap();
	if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
		param.put("UROLKY", "<%=urolky%>");
		
		return param;
	}
	return param;
}

function commonBtnClick(btnName){
	if(btnName == "Search"){
		searchList();
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "RL21");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "RL21");
	}
}
function linkPopCloseEvent(data){//팝업 종료 
	if(data.get("TYPE") == "GET"){ 
		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
		sajoUtil.setLayout(data); //팝업 데이터 적용
	}
}

//서치헬프 기본값 세팅
function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
    var param = new DataMap();

	 //출고유형
	if(searchCode == "SHDOCTM" ){/* && $inputObj.name == "CF.CARNUM" */
        param.put("DOCCAT","200");	
      //제품코드
	} else if(searchCode == "SHSKUMA"){
        param.put("WAREKY","<%=wareky %>");
        param.put("OWNRKY","<%=ownrky %>");
      //업체코드
	} else if(searchCode == "SHBZPTN" && $inputObj.name == "DPTNKY"){
		param.put("PTNRTY","0007");
        param.put("OWNRKY","<%=ownrky %>");	
      //주문구분
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "PGRC03"){
		param.put("CMCDKY","PGRC03");
        param.put("OWNRKY","<%=ownrky %>");	
      //배송구분
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "PGRC02"){
        param.put("CMCDKY","PGRC02");
    	param.put("OWNRKY","<%=ownrky %>");   
      //요구사업장
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "PGRC04"){
        param.put("CMCDKY","PTNG05");
    	param.put("OWNRKY","<%=ownrky %>");   
      //제품용도
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
        param.put("CMCDKY","SKUG05");
    	param.put("OWNRKY","<%=ownrky %>");   
      //권역사업장
	} else if(searchCode == "SHWAHMA"){
    	param.put("NOBIND","Y");   
	} return param;
}

</script>
</head>
<body>
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl> <!-- 화주 -->
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl> <!-- 거점 -->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ></select>
							</dd>
						</dl>
<!-- 						<dl> 그룹 -->
<!-- 							<dt CL="STD_GROUP"></dt> -->
<!-- 							<dd style="width:300px"> -->
<!-- 								<input type="radio" name="OPTION" id="Op1" value="Op1" checked /><label for="Op1">일반</label> -->
<!-- 			        			<input type="radio" name="OPTION" id="Op2" value="Op2"/><label for="Op2">그룹</label> -->
<!-- 			        			<input type="radio" name="OPTION" id="Op3" value="Op3"/><label for="Op3">유통기한별</label> -->
<!-- 							</dd> -->
<!-- 						</dl> -->
						<dl>  <!-- 출고문서번호 -->
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="SHPOKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- S/O 번호 -->
							<dt CL="STD_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="SVBELN2" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 배송일자 -->
							<dt CL="STD_CARDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="CARDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 문서일자 -->
							<dt CL="STD_DOCDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="DOCDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 출고유형 -->
							<dt CL="STD_SHPMTY"></dt> 
							<dd> 
								<input type="text" class="input" name="SHPMTYK" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 배송차수 -->
							<dt CL="STD_SHIPSQ"></dt> 
							<dd> 
								<input type="text" class="input" name="SHIPSQ" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 제품코드 -->
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 제품명 -->
							<dt CL="STD_DESC01"></dt> 
							<dd> 
								<input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 업체코드 -->
							<dt CL="STD_DPTNKY"></dt> 
							<dd> 
								<input type="text" class="input" name="DPTNKY" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 업체명 -->
							<dt CL="STD_DPTNKYNM"></dt> 
							<dd> 
								<input type="text" class="input" name="DPTNKYNM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 차량번호 -->
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="CARINFO" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 재배차 차량번호 -->
							<dt CL="STD_RECNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="RECNUM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>   <!-- 배차번호 -->
							<dt CL="STD_CARNBR"></dt> 
							<dd> 
								<input type="text" class="input" name="CARNBR" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl> <!-- 하차조건 -->
							<dt CL="STD_DCNDTN"></dt> 
							<dd> 
								<input type="text" class="input" name="DCNDTN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 차량 구분 -->
							<dt CL="STD_CARGBN"></dt> 
							<dd> 
								<select name="CARGBN" id="CARGBN" class="input" CommonCombo="CARGBN"><option></option></select> 
							</dd> 
						</dl> 
						<dl>  <!-- 주문구분 -->
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="PGRC03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 배송구분 -->
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="PGRC02" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>   <!-- 권역사업장 -->
							<dt CL="STD_WEGWRK"></dt> 
							<dd> 
								<input type="text" class="input" name="NAME03" UIInput="SR,SHWAHMA"/> 
							</dd> 
						</dl> 
						<dl>   <!-- 권역사업장명 -->
							<dt CL="STD_WEGWRKNM"></dt> 
							<dd> 
								<input type="text" class="input" name="NAME03NM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 제조일자 -->
							<dt CL="STD_LOTA11"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA11" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 입고일자 -->
							<dt CL="STD_LOTA12"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA12" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 유통기한 -->
							<dt CL="STD_LOTA13"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA13" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 요구사업장 -->
							<dt CL="IFT_WARESRC"></dt> 
							<dd> 
								<input type="text" class="input" name="PGRC04" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 요구사업장명 -->
							<dt CL="IFT_WARESRN"></dt> 
							<dd> 
								<input type="text" class="input" name="PG04NM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 제품용도 -->
							<dt CL="STD_SKUG05"></dt> 
							<dd> 
								<input type="text" class="input" name="SKUG05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 영업사원명 -->
							<dt CL="STD_UNAME4"></dt> 
							<dd> 
								<input type="text" class="input" name="UNAME4" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!-- 영업사원연락처 -->
							<dt CL="STD_DNAME4"></dt> 
							<dd> 
								<input type="text" class="input" name="DNAME4" UIInput="SR"/> 
							</dd> 
						</dl> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>일반</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>그룹</span></a></li>
						<li><a href="#tab1-3" onclick="display3()"><span>유통기한별</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>  
											<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>   <!-- 출고문서번호 -->
				    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>   <!-- 배송일자 -->
				    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td> <!-- 배송차수 -->
				    						<td GH="80 STD_CARINFO" GCol="text,CARINFO" GF="S 20">차량정보</td> <!-- 차량정보 -->
				    						<td GH="100 STD_CARINFO2" GCol="text,CARINFO2" GF="S 20">재배차차량정보</td> <!-- 재배차차량정보 -->
				    						<td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 80">매출처코드</td> <!-- 매출처코드 -->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN2" GF="S 220">S/O 번호</td> <!-- S/O 번호 -->
				    						<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	<!--출고유형-->
											</td>
				    						<td GH="80 STD_PTNL10B" GCol="text,DESC03" GF="S 20">구코드</td>    <!-- 구코드 -->
				    						<td GH="80 STD_NEWKEY" GCol="text,SKUKEY" GF="S 20">신코드</td> <!-- 신코드 -->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 220">제품명</td>    <!-- 제품명 -->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 220">규격</td>  <!-- 규격 -->
				    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 20">단위</td>   <!-- 단위 -->
				    						<td GH="80 STD_QTSHPO1" GCol="text,QTSHPO" GF="N 80,0">지시수량(낱개)</td>  <!-- 지시수량(낱개) -->
				    						<td GH="80 STD_BOXQTY1" GCol="text,BOXQTY1" GF="N 80,1">지시수량(BOX)</td>  <!-- 지시수량(BOX) -->
				    						<td GH="80 STD_QTYORG2" GCol="text,QTYORG" GF="N 80,1">실입고수량(낱개)</td>    <!-- 실입고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY2" GCol="text,BOXQTY2" GF="N 80,1">실입고수량(BOX)</td>    <!-- 실입고수량(BOX) -->
				    						<td GH="80 STD_QTJCMP3" GCol="text,QTJCMP" GF="N 80,0">피킹완료수량(낱개)</td>  <!-- 피킹완료수량(낱개) -->
				    						<td GH="80 STD_BOXQTY3" GCol="text,BOXQTY3" GF="N 80,1">피킹완료수량(BOX)</td>  <!-- 피킹완료수량(BOX) -->
				    						<td GH="80 STD_PLTQTYP" GCol="text,PLTQTY3" GF="N 80,2">피킹완료수량(PLT)</td>  <!-- 피킹완료수량(PLT) -->
				    						<td GH="80 STD_QTCAR" GCol="text,QTCAR" GF="N 80,0">배차수량(낱개)</td> <!-- 배차수량(낱개) -->
				    						<td GH="80 STD_BOXQTY7" GCol="text,BOXQTY7" GF="N 80,1">배차수량(BOX)</td>  <!-- 배차수량(BOX) -->
				    						<td GH="80 STD_PLTQTY7" GCol="text,PLTQTY7" GF="N 80,2">배차수량(PLT)</td>  <!-- 배차수량(PLT) -->
				    						<td GH="80 STD_QTSHPD4" GCol="text,QTSHPD" GF="N 80,0">출고수량(낱개)</td>  <!-- 출고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY4" GCol="text,BOXQTY4" GF="N 80,1">출고수량(BOX)</td>  <!-- 출고수량(BOX) -->
				    						<td GH="80 STD_QTYREF5" GCol="text,QTYREF" GF="N 80,0">취소수량(낱개)</td>  <!-- 취소수량(낱개) -->
				    						<td GH="80 STD_BOXQTY5" GCol="text,BOXQTY5" GF="N 80,1">취소수량(BOX)</td>  <!-- 취소수량(BOX) -->
				    						<td GH="80 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0">최종수량(낱개)</td>  <!-- 최종수량(낱개) -->
				    						<td GH="80 STD_QTYCAL2" GCol="text,QTYCAL2" GF="N 80,0">최종수량(잔여)</td> <!-- 최종수량(잔여) -->
				    						<td GH="80 STD_BOXQTY6" GCol="text,BOXQTY6" GF="N 80,1">최종수량(BOX)</td>  <!-- 최종수량(BOX) -->
				    						<td GH="80 STD_PLTQTY6" GCol="text,PLTQTY6" GF="N 80,2">최종수량(PLT)</td>  <!-- 최종수량(PLT) -->
				    						<td GH="80 STD_IFPGRC02" GCol="select,PGRC02">
				    							<select class="input" commonCombo="PGRC02"><option></option></select> <!--배송구분-->
				    						</td> 
				    						<td GH="80 STD_PGRC03" GCol="select,PGRC03">
				    							<select class="input" commonCombo="PGRC03"><option></option></select> <!--주문구분-->
				    						</td>
				    						<td GH="80 STD_PTRCNM" GCol="text,DPTNKYNM" GF="S 80">매출처명</td> <!-- 매출처명 -->
				    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 80">배송지우편번호</td> <!-- 배송지우편번호 -->
				    						<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 80">배송지주소</td> <!-- 배송지주소 -->
				    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 80">배송고객명</td>   <!-- 배송고객명 -->
				    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 80">배송지전화번호</td> <!-- 배송지전화번호 -->
				    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!-- 박스입수 -->
				    						<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 180">비고</td>  <!-- 비고 -->
				    						<td GH="100 STD_FORKYN" GCol="select,FORKYN">
				    							<select class="input" commonCombo="FORKDS"><option></option></select> <!-- 지게차사용여부 -->
											</td> 
				    						<td GH="100 STD_PTNG07B" GCol="text,PTNG07" GF="S 10">최대진입가능차량</td>  <!-- 최대진입가능차량 -->
				    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>   <!-- 권역코드 -->
				    						<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 10">영업사원명</td> <!-- 영업사원명 -->
				    						<td GH="90 STD_DNAME4" GCol="text,DNAME4" GF="S 15">영업사원연락처</td> <!-- 영업사원연락처 -->
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>   <!-- 화주 -->
				    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>   <!-- 거점 -->
				    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10">문서일자</td>   <!-- 문서일자 -->
				    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="S 20">순중량</td> <!-- 순중량 -->
				    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td> <!-- 권역명 -->
				    						<td GH="80 STD_WEGWRK" GCol="text,NAME03" GF="S 80">권역사업장</td> <!-- 권역사업장 -->
				    						<td GH="80 STD_WEGWRKNM" GCol="text,NAME03NM" GF="S 80">권역사업장명</td>   <!-- 권역사업장명 -->
				    						<td GH="80 STD_PGRC04" GCol="select,PGRC04">
				    							<select class="input" commonCombo="PTNG06"><option></option></select> <!--주문부서-->
				    						</td>
				    						<td GH="80 STD_SKUG05" GCol="select,SKUG05">
				    							<select class="input" commonCombo="SKUG05"><option></option></select> <!--제품용도-->
				    						</td>
				    						<td GH="80 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>    <!-- 지시시간 -->
				    						<td GH="100 STD_SETNM" GCol="text,SETNM" GF="S 100">택배상품명</td> <!-- 택배상품명 -->
				    						<td GH="100 STD_IFQTYORG" GCol="text,IFQTYORG" GF="N 50,0" style="text-align:right;">원주문수량(주문)</td> <!-- 원주문수량(주문) -->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 80">납품처코드</td> <!-- 납품처코드 -->
				    						<td GH="80 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 80">납품처명</td>   <!-- 납품처명 -->
				    						<td GH="100 STD_SENDERNAME" GCol="text,UNAME2" GF="S 100">사판(발송인명)</td>   <!-- 사판(발송인명) -->
				    						<td GH="100 STD_SENDERNB" GCol="text,CUTEL2" GF="S 100">사판(발송인번호)</td>   <!-- 사판(발송인번호) -->
				    						<td GH="100 STD_SENDERADR" GCol="text,SADDR2" GF="S 100">사판(발송인주소)</td>  <!-- 사판(발송인주소) -->
				    						<td GH="80 STD_STARCA" GCol="text,TEXT02" GF="S 180">배차메모</td>  <!-- 배차메모 -->
				    						<td GH="80 STD_DCNDTN" GCol="select,DCNDTN">
				    							<select class="input" commonCombo="DCNDTN"><option></option></select> <!--하차조건-->
				    						</td>
				    						<td GH="80 STD_CARNBR" GCol="text,CARNBR" GF="S 180">배차번호</td>  <!-- 배차번호 -->
				    						
<!-- 				    						<td GH="80 STD_QTYPRE1" GCol="text,SETNUM" GF="N 50,0">송장수량</td>    송장수량 -->
				    						<td GH="80 STD_ORDDT" GCol="text,ERPCDT" GF="D 50">주문일자</td>    <!-- 주문일자 -->
				    						<td GH="80 STD_ORDTIM" GCol="text,ERPCTM" GF="T 50">주문시간</td>   <!-- 주문시간 -->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div><!-- TAB1 -->
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>  
				    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>   <!-- 화주 -->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>   <!-- 거점 -->
				    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>   <!-- 배송일자 -->
				    						<td GH="80 STD_CARINFO" GCol="text,CARINFO" GF="S 20">차량정보</td> <!-- 차량정보 -->
				    						<td GH="80 STD_CARGBN" GCol="select,CARGBN">
				    							<select class="input" commonCombo="CARGBN"><option></option></select> <!--차량 구분-->
				    						</td>
				    						<td GH="100 STD_CARINFO2" GCol="text,CARINFO2" GF="S 20">재배차차량정보</td> <!-- 재배차차량정보 -->
				    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td> <!-- 배송차수 -->
				    						<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	<!--출고유형-->
											</td>
				    						<td GH="80 STD_QTSHPO1" GCol="text,QTSHPO" GF="N 80,0">지시수량(낱개)</td>  <!-- 지시수량(낱개) -->
				    						<td GH="80 STD_BOXQTY1" GCol="text,BOXQTY1" GF="N 80,1">지시수량(BOX)</td>  <!-- 지시수량(BOX) -->
				    						<td GH="80 STD_QTYORG2" GCol="text,QTYORG" GF="N 80,0">실입고수량(낱개)</td>    <!-- 실입고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY2" GCol="text,BOXQTY2" GF="N 80,1">실입고수량(BOX)</td>    <!-- 실입고수량(BOX) -->
				    						<td GH="80 STD_QTJCMP3" GCol="text,QTJCMP" GF="N 80,0">피킹완료수량(낱개)</td>  <!-- 피킹완료수량(낱개) -->
				    						<td GH="80 STD_BOXQTY3" GCol="text,BOXQTY3" GF="N 80,1">피킹완료수량(BOX)</td>  <!-- 피킹완료수량(BOX) -->
				    						<td GH="80 STD_PLTQTYP" GCol="text,PLTQTY3" GF="N 80,2">피킹완료수량(PLT)</td>  <!-- 피킹완료수량(PLT) -->
				    						<td GH="80 STD_QTCAR" GCol="text,QTCAR" GF="N 80,0">배차수량(낱개)</td> <!-- 배차수량(낱개) -->
				    						<td GH="80 STD_BOXQTY7" GCol="text,BOXQTY7" GF="N 80,1">배차수량(BOX)</td>  <!-- 배차수량(BOX) -->
				    						<td GH="80 STD_QTSHPD4" GCol="text,QTSHPD" GF="N 80,0">출고수량(낱개)</td>  <!-- 출고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY4" GCol="text,BOXQTY4" GF="N 80,1">출고수량(BOX)</td>  <!-- 출고수량(BOX) -->
				    						<td GH="80 STD_QTYREF5" GCol="text,QTYREF" GF="N 80,0">취소수량(낱개)</td>  <!-- 취소수량(낱개) -->
				    						<td GH="80 STD_BOXQTY5" GCol="text,BOXQTY5" GF="N 80,1">취소수량(BOX)</td>  <!-- 취소수량(BOX) -->
				    						<td GH="80 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0">최종수량(낱개)</td>  <!-- 최종수량(낱개) -->
				    						<td GH="80 STD_BOXQTY6" GCol="text,BOXQTY6" GF="N 80,1">최종수량(BOX)</td>  <!-- 최종수량(BOX) -->
				    						<td GH="80 STD_PLTQTY6" GCol="text,PLTQTY6" GF="N 80,2">최종수량(PLT)</td>  <!-- 최종수량(PLT) -->
				    						<td GH="80 STD_PLTQTY7" GCol="text,PLTQTY7" GF="N 80,2">배차수량(PLT)</td>  <!-- 배차수량(PLT) -->
				    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!-- 박스입수 -->
				    						<td GH="80 STD_IFPGRC02" GCol="select,PGRC02">
				    							<select class="input" commonCombo="PGRC02"><option></option></select> <!--배송구분-->
				    						</td> 
				    						<td GH="80 STD_PGRC03" GCol="select,PGRC03">
				    							<select class="input" commonCombo="PGRC03"><option></option></select> <!--주문구분-->
				    						</td>
				    						<td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 80">매출처코드</td> <!-- 매출처코드 -->
				    						<td GH="80 STD_PTRCNM" GCol="text,DPTNKYNM" GF="S 80">매출처명</td> <!-- 매출처명 -->
				    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 80">배송지우편번호</td> <!-- 배송지우편번호 -->
				    						<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 80">배송지주소</td> <!-- 배송지주소 -->
				    						<td GH="100 STD_FORKYN" GCol="text,FORKYN" GF="S 10">지게차사용여부</td> <!-- 지게차사용여부 -->
				    						<td GH="100 STD_PTNG07B" GCol="text,PTNG07" GF="S 10">최대진입가능차량</td>  <!-- 최대진입가능차량 -->
				    						<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 180">비고</td>  <!-- 비고 -->
				    						<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 10">영업사원명</td> <!-- 영업사원명 -->
				    						<td GH="80 STD_DNAME4" GCol="text,DNAME4" GF="S 15">영업사원연락처</td> <!-- 영업사원연락처 -->
				    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td>   <!-- 순중량 -->
				    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>   <!-- 권역코드 -->
				    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td> <!-- 권역명 -->
				    						<td GH="80 STD_WEGWRK" GCol="text,NAME03" GF="S 80">권역사업장</td> <!-- 권역사업장 -->
				    						<td GH="80 STD_WEGWRKNM" GCol="text,NAME03NM" GF="S 80">권역사업장명</td>   <!-- 권역사업장명 -->
				    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 80">배송고객명</td>   <!-- 배송고객명 -->
				    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 80">배송지전화번호</td> <!-- 배송지전화번호 -->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 80">납품처코드</td> <!-- 납품처코드 -->
				    						<td GH="80 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 80">납품처명</td>   <!-- 납품처명 -->
				    						<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 10">주문부서</td>  <!-- 주문부서 -->
				    						<td GH="80 STD_PGRC04" GCol="text,PG04NM" GF="S 10">주문부서</td>   <!-- 주문부서 -->
				    						<td GH="80 STD_SKUG05" GCol="select,SKUG05">
				    							<select class="input" commonCombo="SKUG05"><option></option></select> <!--제품용도-->
				    						</td>
				    						<td GH="80 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>    <!-- 지시시간 -->
				    						<td GH="100 STD_IFQTYORG" GCol="text,IFQTYORG" GF="N 50,0">원주문수량(주문)</td> <!-- 원주문수량(주문) -->
				    						<td GH="80 STD_STARCA" GCol="text,TEXT02" GF="S 180">배차메모</td>  <!-- 배차메모 -->
				    						<td GH="80 STD_DCNDTN" GCol="select,DCNDTN">
				    							<select class="input" commonCombo="DCNDTN"><option></option></select> <!--하차조건-->
				    						</td>
				    						<td GH="80 STD_CARNBR" GCol="text,CARNBR" GF="S 180">배차번호</td>  <!-- 배차번호 -->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div> <!-- TAB2 -->
					<div class="table_box section" id="tab1-3">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList3">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>   <!-- 배송일자 -->
				    						<td GH="80 STD_CARINFO" GCol="text,CARINFO" GF="S 20">차량정보</td> <!-- 차량정보 -->
				    						<td GH="80 STD_CARINFO2" GCol="text,CARINFO2" GF="S 20">재배차차량정보</td> <!-- 재배차차량정보 -->
				    						<td GH="100 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td> <!-- 배송차수 -->
				    						<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	<!--출고유형-->
											</td>
				    						<td GH="80 STD_PTNL10B" GCol="text,DESC03" GF="S 20">구코드</td>    <!-- 구코드 -->
				    						<td GH="80 STD_NEWKEY" GCol="text,SKUKEY" GF="S 20">신코드</td> <!-- 신코드 -->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 220">제품명</td>    <!-- 제품명 -->
				    						<td GH="80 STD_QTSHPO1" GCol="text,QTSHPO" GF="N 80,0">지시수량(낱개)</td>  <!-- 지시수량(낱개) -->
				    						<td GH="80 STD_BOXQTY1" GCol="text,BOXQTY1" GF="N 80,1">지시수량(BOX)</td>  <!-- 지시수량(BOX) -->
				    						<td GH="80 STD_QTYORG2" GCol="text,QTYORG" GF="N 80,0">실입고수량(낱개)</td>    <!-- 실입고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY2" GCol="text,BOXQTY2" GF="N 80,1">실입고수량(BOX)</td>    <!-- 실입고수량(BOX) -->
				    						<td GH="80 STD_QTJCMP3" GCol="text,QTJCMP" GF="N 80,0">피킹완료수량(낱개)</td>  <!-- 피킹완료수량(낱개) -->
				    						<td GH="80 STD_BOXQTY3" GCol="text,BOXQTY3" GF="N 80,1">피킹완료수량(BOX)</td>  <!-- 피킹완료수량(BOX) -->
				    						<td GH="80 STD_PLTQTYP" GCol="text,PLTQTY3" GF="N 80,2">피킹완료수량(PLT)</td>  <!-- 피킹완료수량(PLT) -->
				    						<td GH="80 STD_QTSHPD4" GCol="text,QTSHPD" GF="N 80,0">출고수량(낱개)</td>  <!-- 출고수량(낱개) -->
				    						<td GH="80 STD_BOXQTY4" GCol="text,BOXQTY4" GF="N 80,1">출고수량(BOX)</td>  <!-- 출고수량(BOX) -->
				    						<td GH="80 STD_QTYREF5" GCol="text,QTYREF" GF="N 80,0">취소수량(낱개)</td>  <!-- 취소수량(낱개) -->
				    						<td GH="80 STD_BOXQTY5" GCol="text,BOXQTY5" GF="N 80,1">취소수량(BOX)</td>  <!-- 취소수량(BOX) -->
				    						<td GH="80 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0">최종수량(낱개)</td>  <!-- 최종수량(낱개) -->
				    						<td GH="80 STD_BOXQTY6" GCol="text,BOXQTY6" GF="N 80,1">최종수량(BOX)</td>  <!-- 최종수량(BOX) -->
				    						<td GH="80 STD_PLTQTY6" GCol="text,PLTQTY6" GF="N 80,2">최종수량(PLT)</td>  <!-- 최종수량(PLT) -->
				    						<td GH="80 STD_QTCAR" GCol="text,QTCAR" GF="N 80,0">배차수량(낱개)</td> <!-- 배차수량(낱개) -->
				    						<td GH="80 STD_BOXQTY7" GCol="text,BOXQTY7" GF="N 80,1">배차수량(BOX)</td>  <!-- 배차수량(BOX) -->
				    						<td GH="80 STD_PLTQTY7" GCol="text,PLTQTY7" GF="N 80,2">배차수량(PLT)</td>  <!-- 배차수량(PLT) -->
				    						<td GH="80 STD_IFPGRC02" GCol="select,PGRC02">
				    							<select class="input" commonCombo="PGRC02"><option></option></select> <!--배송구분-->
				    						</td> 
				    						<td GH="80 STD_PGRC03" GCol="select,PGRC03">
				    							<select class="input" commonCombo="PGRC03"><option></option></select> <!--주문구분-->
				    						</td>
				    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 80">배송지우편번호</td> <!-- 배송지우편번호 -->
				    						<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 80">배송지주소</td> <!-- 배송지주소 -->
				    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>   <!-- 권역코드 -->
				    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td> <!-- 권역명 -->
				    						<td GH="80 STD_WEGWRK" GCol="text,NAME03" GF="S 80">권역사업장</td> <!-- 권역사업장 -->
				    						<td GH="80 STD_WEGWRKNM" GCol="text,NAME03NM" GF="S 80">권역사업장명</td>   <!-- 권역사업장명 -->
				    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 80">배송고객명</td>   <!-- 배송고객명 -->
				    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 80">배송지전화번호</td> <!-- 배송지전화번호 -->
				    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!-- 박스입수 -->
				    						<td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 80">매출처코드</td> <!-- 매출처코드 -->
				    						<td GH="80 STD_PTRCNM" GCol="text,DPTNKYNM" GF="S 80">매출처명</td> <!-- 매출처명 -->
				    						<td GH="100 STD_FORKYN" GCol="text,FORKYN" GF="S 10">지게차사용여부</td> <!-- 지게차사용여부 -->
				    						<td GH="100 STD_PTNG07B" GCol="text,PTNG07" GF="S 10">최대진입가능차량</td>  <!-- 최대진입가능차량 -->
				    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 10">제조일자</td>   <!-- 제조일자 -->
				    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 10">입고일자</td>   <!-- 입고일자 -->
				    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 10">유통기한</td>   <!-- 유통기한 -->
				    						<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 180">비고</td>  <!-- 비고 -->
				    						<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 10">영업사원명</td> <!-- 영업사원명 -->
				    						<td GH="80 STD_DNAME4" GCol="text,DNAME4" GF="S 15">영업사원연락처</td> <!-- 영업사원연락처 -->
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>   <!-- 화주 -->
				    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>   <!-- 거점 -->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN2" GF="S 220">S/O 번호</td> <!-- S/O 번호 -->
				    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="S 20,0">순중량</td>   <!-- 순중량 -->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 220">규격</td>  <!-- 규격 -->
				    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 20">단위</td>   <!-- 단위 -->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 80">납품처코드</td> <!-- 납품처코드 -->
				    						<td GH="80 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 80">납품처명</td>   <!-- 납품처명 -->
				    						<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 10">주문부서</td>   <!-- 주문부서 -->
				    						<td GH="80 STD_PGRC04" GCol="text,PG04NM" GF="S 10">주문부서</td>   <!-- 주문부서 -->
				    						<td GH="80 STD_SKUG05" GCol="select,SKUG05">
				    							<select class="input" commonCombo="SKUG05"><option></option></select> <!--제품용도-->
				    						</td>
				    						<td GH="80 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>    <!-- 지시시간 -->
				    						<td GH="100 STD_IFQTYORG" GCol="text,IFQTYORG" GF="N 50,0" style="text-align:right;">원주문수량(주문)</td> <!-- 원주문수량(주문) -->
				    						<td GH="80 STD_STARCA" GCol="text,TEXT02" GF="S 180">배차메모</td>  <!-- 배차메모 -->
				    						<td GH="80 STD_DCNDTN" GCol="select,DCNDTN">
				    							<select class="input" commonCombo="DCNDTN"><option></option></select> <!--하차조건-->
				    						</td>
				    						<td GH="80 STD_CARNBR" GCol="text,CARNBR" GF="S 180">배차번호</td>  <!-- 배차번호 -->
				    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>   <!-- 출고문서번호 -->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div> <!-- TAB3 -->
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>