<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL22</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "Report",
		command : "RL22",
		pkcol : "SHPOKY",
	    menuId : "RL22"
    });

	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();
});


function searchList(){
	if(validate.check("searchArea")){
		gridList.resetGrid("gridList");
		var param = inputList.setRangeParam("searchArea");

		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
}

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
	}else if(btnName == "Print"){
		print();
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "RL22");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "RL22");
	}
}
function linkPopCloseEvent(data){//팝업 종료 
	if(data.get("TYPE") == "GET"){ 
		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
		sajoUtil.setLayout(data); //팝업 데이터 적용
	}
}

//ezgen 구현
function print(){

		var grid = gridList.getGridData("gridList", true);//모든 데이터 
		var fromOtrqdt = inputList.rangeMap["map"]["IFWMS113.OTRQDT"].$from.val();
		var toOtrqdt = inputList.rangeMap["map"]["IFWMS113.OTRQDT"].$to.val();
		fromOtrqdt = fromOtrqdt.replace(/\./g,"");
		toOtrqdt = toOtrqdt.replace(/\./g,"");
		//데이터가 없을 경우 
		if(grid.length == 0){
			commonUtil.msgBox("VALID_M0005");
			return;
		}
				
		var where = " AND IFWMS113.OWNRKY = '" + $("#OWNRKY").val() + "'";

// 		if(fromOtrqdt != null || fromOtrqdt != ""){
// 			where += " AND I.OTRQDT BETWEEN '" + fromOtrqdt + "'";
// 		}
// 		if(toOtrqdt != null || toOtrqdt != ""){
// 			where += " AND I.OTRQDT "+lt+" '" + toOtrqdt + "'";
// 		}
		
		var option = "";
		if(fromOtrqdt!=null && fromOtrqdt != ""){
			if(toOtrqdt != null && toOtrqdt != ""){
				option =" AND IFWMS113.OTRQDT BETWEEN '"+fromOtrqdt+"' AND '"+toOtrqdt+"'";
			}else{
				option =" AND IFWMS113.OTRQDT = '"+fromOtrqdt+"'";
			}
		}else {
			if(toOtrqdt != null && toOtrqdt != ""){
				option =" AND IFWMS113.OTRQDT = '"+toOtrqdt+"'";
			}else{
				commonUtil.msgBox("* 출고요청일자로 조회하시기 바랍니다. *");
				return;
			}
		}
		
		var langKy = "KO";
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
			map.put("i_option",option);
		
		WriteEZgenElement("/ezgen/undeliver_list2.ezg" , where , " " , "KO", map , width , heigth );

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
       //거래처코드
 	} else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNRTO"){
        param.put("OWNRKY","<%=ownrky %>");	 
      //주문량조정사유
	} else if(searchCode == "SHRSNCD"){
		param.put("DOCUTY","399");
		param.put("DOCCAT","300");
        param.put("OWNRKY","<%=ownrky %>");	  
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "IFWMS113.WAREKY"){
    	param.put("CMCDKY","WAREKY");
	}
	return param;
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" /></div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Print PRINT_OUT STD_PRINT" />
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
							</dd>
						</dl>
						<dl>  <!--거점-->  
							<dt CL="STD_WAREKY"></dt> 
							<dd> 
								<input type="text" class="input"id="WAREKY"  name="IFWMS113.WAREKY" UIInput="SR,SHCMCDV" value="<%=wareky%>"/> 
							</dd> 
						</dl> 
						<dl>  <!--작업유형-->  
							<dt CL="STD_TASCAT"></dt> 
							<dd> 
								<input type="text" class="input" name="IFWMS113.DOCUTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문일자-->  
							<dt CL="STD_ORDDT"></dt> 
							<dd> 
								<input type="text" class="input" name="IFWMS113.ORDDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고요청일자-->  
							<dt CL="STD_RQSHPD"></dt> 
							<dd> 
								<input type="text" class="input" id="OTRQDT" name="IFWMS113.OTRQDT" UIInput="B" UIFormat="C N"/><!--  validate="required" --> 
							</dd> 
						</dl> 
						<dl>  <!--배송일자-->  
							<dt CL="STD_CARDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="IFT.DATRCV" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--검수번호-->  
							<dt CL="STD_CHKSEQ"></dt> 
							<dd> 
								<input type="text" class="input" name="SUBSTR(IFWMS113.CHKSEQ,-5)" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--D/O번호-->  
							<dt CL="STD_DO_NO"></dt> 
							<dd> 
								<input type="text" class="input" name="IFWMS113.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="IFWMS113.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--거래처코드-->  
							<dt CL="STD_CUSTNM"></dt> 
							<dd> 
								<input type="text" class="input" name="IFWMS113.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문량조정사유-->  
							<dt CL="STD_ODRSNADJ"></dt>
							<dd> 
								<input type="text" class="input" name="IFWMS113.C00103" UIInput="SR,SHRSNCD"/> 
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
						<li><a href="#tab1-1"><span>일반</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="80 ITF_DIRSUP" GCol="text,ORDTYP" GF="S 7">주문구분</td>    <!-- 주문구분 -->
				    						<td GH="80 STD_ORDDT" GCol="text,ORDDAT" GF="S 10">주문일자</td>    <!-- 주문일자 -->
				    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>   <!-- 거점 -->
				    						<td GH="80 STD_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>   <!-- 검수번호 -->
				    						<td GH="80 STD_ORDSEQ2" GCol="text,ORDSEQ" GF="S 6">주문마감차수</td>   <!-- 주문마감차수 -->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>   <!-- S/O 번호 -->
				    						<td GH="80 STD_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>    <!-- 출고유형 -->
				    						<td GH="80 STD_DOCUTYNM" GCol="text,DOSHORTX" GF="S 180">문서타입명</td>    <!-- 문서타입명 -->
				    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="S 10">출고요청일</td> <!-- 출고요청일 -->
				    						<td GH="80 STD_CARDAT" GCol="text,DATRCV" GF="D 10">배송일자</td>   <!-- 배송일자 -->
				    						<td GH="100 STD_PTNRTO" GCol="text,PTNRTO" GF="S 20">거래처/요청거점</td>    <!-- 거래처/요청거점 -->
				    						<td GH="80 STD_PTRNKYNM" GCol="text,BZ1NAME01" GF="S 180">거래처명</td> <!-- 거래처명 -->
				    						<td GH="80 STD_WARESR" GCol="text,WARESR" GF="S 10">요청거점</td>   <!-- 요청거점 -->
				    						<td GH="80 STD_IFPGRC04N" GCol="text,BZ2NAME01" GF="S 180">요청사업장명</td>    <!-- 요청사업장명 -->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>   <!-- 제품코드 -->
				    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,3">순중량</td>   <!-- 순중량 -->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>    <!-- 제품명 -->
				    						<td GH="80 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,0">입수</td> <!-- 입수 -->
				    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 13,0">원주문수량</td>   <!-- 원주문수량 -->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출고수량</td> <!-- 출고수량 -->
				    						<td GH="80 STD_QTUSHP" GCol="text,QTYERR" GF="N 13,0">미출수량</td> <!-- 미출수량 -->
				    						<td GH="80 STD_QTEWGT" GCol="text,QTEWGT" GF="N 20,2">미출중량</td> <!-- 미출중량 -->
				    						<td GH="80 STD_SELAMT" GCol="text,SELAMT" GF="N 20,0">미출금액</td> <!-- 미출금액 -->
				    						<td GH="80 IFT_DIRDVY" GCol="text,DIRDVY" GF="S 5">배송구분</td>    <!-- 배송구분 -->
				    						<td GH="80 STD_CD1CDESC1" GCol="text,CD1CDESC1" GF="S 180">직송구분명</td>  <!-- 직송구분명 -->
				    						<td GH="80 IFT_DIRSUP" GCol="text,DIRSUP" GF="S 5">주문구분</td>    <!-- 주문구분 -->
				    						<td GH="80 STD_CD2CDESC1" GCol="text,CD2CDESC1" GF="S 180">직납구분명</td>  <!-- 직납구분명 -->
				    						<td GH="80 IFT_C00103" GCol="text,C00103" GF="S 100">사유코드</td>  <!-- 사유코드 -->
				    						<td GH="80 STD_RSNCDNM" GCol="text,RSSHORTX" GF="S 180">사유코드명</td> <!-- 사유코드명 -->
				    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 180">영업사원명</td>    <!-- 영업사원명 -->
				    						<td GH="100 IFT_SALTEL" GCol="text,SALTEL" GF="S 180">영업사원 전화번호</td>    <!-- 영업사원 전화번호 -->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>    <!-- 수정일자 -->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>    <!-- 수정시간 -->
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
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>