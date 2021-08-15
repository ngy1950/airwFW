<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SU01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var module = 'Report';
var command = 'SU01';
var gridId = 'gridList';
var param = null;

	$(document).ready(function() {
		
		gridList.setGrid({
	    	id : gridId,
	    	module : module,
			command : command,
		    menuId : "SU01"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function linkPopCloseEvent(data) { //팝업 종료 
		if(data.get("TYPE") == "GET") { 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	
	
	// 버튼 클릭
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "SU01");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "SU01");
		} else if(btnName == "Search") {
			search();
		} else if(btnName == "Excute") {
			excute();
		}
	}// end commonBtnClick()
	
	// 서치헬프 parameter 셋팅
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj)  {
		param = new DataMap();
		
		if(searchCode == 'SHSKUMA') { // 제품코드
			param.put('OWNRKY', $('#OWNRKY').val());
			param.put('WAREKY', $('#WAREKY').val());
		} 
		
		return param;
	} // end searchHelpEventOpenBefore()
	
	// search(조회)
	function search() {
		if(validate.check('searchArea')) {
			param = inputList.setRangeParam('searchArea');
			gridList.gridList({
				id : gridId,
				param : param
			});				
		}
		
	} // end search()
	
	// 실행
	function excute() {
		var startDate = $($('#DOCDAT').siblings().filter('input').get()[0]).val();
		var endDate = $($('#DOCDAT').siblings().filter('input').get()[1]).val();
		
		if(!startDate || !endDate) {
			commonUtil.msgBox('VALID_DATE');
			return;
		}
		
		param = new DataMap();
		param.put('FROM', startDate);
		param.put('TO', endDate);
		param.put('WAREKY', $('#WAREKY').val());
		
		netUtil.send({
			url : '/Report/json/excuteSU01.data',
			param : param,
			successFunction : 'successExcuteCallBack'
		});
		
	} // end excute()
	
	// 실행버튼 실행시 콜백함수
	function successExcuteCallBack(json) {
		console.log(json);
		if(json && json.data) {
			if(json.data.RESULT) {
				switch(json.data.C) {
					case 'S':
						commonUtil.msgBox(json.data.M);
						break;
					case 'E':
						commonUtil.msgBox(json.data.M);
						// throw new Error(json.data.E);
						console.error(json.data.E);
						break;
				}
			}
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
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Excute EXCUTE BTN_EXECUTE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>	
				
					<dl>  <!-- 문서일자 -->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" id="DOCDAT" class="input" name="U.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 제품코드 -->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="U.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
										
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>리스트</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="60 STD_DOCDAT" GCol="text,DOCDAT" GF="S 10">문서일자</td>	<!-- 문서일자 -->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!-- 거점 -->
			    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!-- 화주 -->
			    						<td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 10">제품코드</td>	<!-- 제품코드 -->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 10">제품명</td>	<!-- 제품명 -->
			    						<td GH="80 STD_QTINIT" GCol="text,QTINIT" GF="N 11,0">기초재고</td>	<!--기초재고-->
			    						<td GH="80 STD_QTTWA" GCol="text,GRQTYT" GF="N 11,0">총수량[PLUS]</td>	<!--총수량[PLUS]-->
			    						<td GH="80 HHTSTD_2116000M1SUB01" GCol="text,GRQT01" GF="N 11,0">ASN입고</td>	<!--ASN입고-->
			    						<td GH="80 STD_ASNFR" GCol="text,GRQT02" GF="N 11,0">ASN선입고</td>	<!--ASN선입고-->
			    						<td GH="80 HHTSTD_2116000M1SUB02" GCol="text,GRQT03" GF="N 11,0">구매입고</td>	<!--구매입고-->
			    						<td GH="80 STD_PUFIRE" GCol="text,GRQT04" GF="N 11,0">구매선입입고</td>	<!--구매선입입고-->
			    						<td GH="80 HHTSTD_2116000M1SUB03" GCol="text,GRQT05" GF="N 11,0">이고입고</td>	<!--이고입고-->
			    						<td GH="80 STD_REGOO" GCol="text,GRQT06" GF="N 11,0">이고반품입고</td>	<!--이고반품입고-->
			    						<td GH="80 STD_HIGPR" GCol="text,GRQT07" GF="N 11,0">이고선입고</td>	<!--이고선입고-->
			    						<td GH="80 HHTSTD_2116000M1SUB00" GCol="text,GRQT08" GF="N 11,0">생산입고</td>	<!--생산입고-->
			    						<td GH="90 STD_RORGO" GCol="text,GRQT09" GF="N 11,0">매출처반품입고</td>	<!--매출처반품입고-->
			    						<td GH="90 STD_STRER" GCol="text,GRQT10" GF="N 11,0">위탁점반품입고</td>	<!--위탁점반품입고-->
			    						<td GH="90 STD_RETGD" GCol="text,GRQT11" GF="N 11,0">회송반품(일반)</td>	<!--회송반품(일반)-->
			    						<td GH="90 STD_RETAR" GCol="text,GRQT12" GF="N 11,0">회송반품(위탁)</td>	<!--회송반품(위탁)-->
			    						<td GH="80 STD_AIWRE" GCol="text,GRQT13" GF="N 11,0">상시반품</td>	<!--상시반품-->
			    						<td GH="80 STD_SWPRR" GCol="text,GRQT14" GF="N 11,0">사판반품입고</td>	<!--사판반품입고-->
			    						<td GH="80 HHTSTD_21160N1TITLE" GCol="text,GRQT15" GF="N 11,0">세트조립</td>	<!--세트조립-->
			    						<td GH="80 HHTSTD_1H79000M3SUB04" GCol="text,GRQT16" GF="N 11,0">세트해체</td>	<!--세트해체-->
			    						<td GH="80 MENU_CGITEM" GCol="text,GRQT17" GF="N 11,0">재고속성변경</td>	<!--재고속성변경-->
			    						<td GH="80 STD_DELVA" GCol="text,GRQT18" GF="N 11,0">배송량조정</td>	<!--배송량조정-->
			    						<td GH="80 STD_MTOM" GCol="text,GRQT19" GF="N 11,0">M to M</td>	<!--M to M-->
			    						<td GH="120 STD_UIPSYS" GCol="text,GRQT20" GF="N 11,0">[SYS]미확정재고처리</td>	<!--[SYS]미확정재고처리-->
			    						<td GH="80 STD_REASR" GCol="text,GRQT21" GF="N 11,0">실재고반영</td>	<!--실재고반영-->
			    						<td GH="80 MENU_INV_ADJD" GCol="text,GRQT22" GF="N 11,0">재고조정</td>	<!--재고조정-->
			    						<td GH="80 STD_ICWMS" GCol="text,GRQT23" GF="N 11,0">WMS재고실사</td>	<!--WMS재고실사-->
			    						<td GH="100 STD_GRQT24" GCol="text,GRQT24" GF="N 11,0">할증반품입고(83)</td>	<!--할증반품입고(83)-->
			    						<td GH="100 STD_SILRE" GCol="text,GRQT25" GF="N 11,0">무성반품입고(85)</td>	<!--무성반품입고(85)-->
			    						<td GH="80 STD_GRQT26" GCol="text,GRQT26" GF="N 11,0">GRQT26</td>	<!--GRQT26-->
			    						<td GH="80 STD_GRQT27" GCol="text,GRQT27" GF="N 11,0">GRQT27</td>	<!--GRQT27-->
			    						<td GH="80 STD_GRQT28" GCol="text,GRQT28" GF="N 11,0">GRQT28</td>	<!--GRQT28-->
			    						<td GH="80 STD_GRQT29" GCol="text,GRQT29" GF="N 11,0">GRQT29</td>	<!--GRQT29-->
			    						<td GH="80 STD_GRQT30" GCol="text,GRQT30" GF="N 11,0">GRQT30</td>	<!--GRQT30-->
			    						<td GH="100 STD_TQTMI" GCol="text,GIQTYT" GF="N 11,0">총수량[MINUS]</td>	<!--총수량[MINUS]-->
			    						<td GH="80 STD_GENDE" GCol="text,GIQT01" GF="N 11,0">일반출고</td>	<!--일반출고-->
			    						<td GH="80 STD_OUTCS" GCol="text,GIQT02" GF="N 11,0">위탁점출고</td>	<!--위탁점출고-->
			    						<td GH="80 STD_EXTSH" GCol="text,GIQT03" GF="N 11,0">할증출고</td>	<!--할증출고-->
			    						<td GH="80 STD_FRESH" GCol="text,GIQT04" GF="N 11,0">무상출고</td>	<!--무상출고-->
			    						<td GH="80 STD_204" GCol="text,GIQT05" GF="N 11,0">수출출고</td>	<!--수출출고-->
			    						<td GH="80 STD_ISSPE" GCol="text,GIQT06" GF="N 11,0">사판출고</td>	<!--사판출고-->
			    						<td GH="80 STD_DELIVE" GCol="text,GIQT07" GF="N 11,0">이고출고</td>	<!--이고출고-->
			    						<td GH="80 STD_GOGRD" GCol="text,GIQT08" GF="N 11,0">이고반품출고</td>	<!--이고반품출고-->
			    						<td GH="80 STD_PREDE" GCol="text,GIQT09" GF="N 11,0">매입반품출고</td>	<!--매입반품출고-->
			    						<td GH="80 HHTSTD_21160N1TITLE" GCol="text,GIQT10" GF="N 11,0">세트조립</td>	<!--세트조립-->
			    						<td GH="80 HHTSTD_1H79000M3SUB04" GCol="text,GIQT11" GF="N 11,0">세트해체</td>	<!--세트해체-->
			    						<td GH="80 MENU_CGITEM" GCol="text,GIQT12" GF="N 11,0">재고속성변경</td>	<!--재고속성변경-->
			    						<td GH="80 STD_DELVA" GCol="text,GIQT13" GF="N 11,0">배송량조정</td>	<!--배송량조정-->
			    						<td GH="80 STD_MTOM" GCol="text,GIQT14" GF="N 11,0">M to M</td>	<!--M to M-->
			    						<td GH="80 HHTSTD_22560I1TITLE" GCol="text,GIQT15" GF="N 11,0">기타출고</td>	<!--기타출고-->
			    						<td GH="120 STD_UIPSYS" GCol="text,GIQT16" GF="N 11,0">[SYS]미확정재고처리</td>	<!--[SYS]미확정재고처리-->
			    						<td GH="80 STD_CANCLE" GCol="text,GIQT17" GF="N 11,0">입고취소</td>	<!--입고취소-->
			    						<td GH="80 STD_REASR" GCol="text,GIQT18" GF="N 11,0">실재고반영</td>	<!--실재고반영-->
			    						<td GH="80 MENU_INV_ADJD" GCol="text,GIQT19" GF="N 11,0">재고조정</td>	<!--재고조정-->
			    						<td GH="80 STD_ICWMS" GCol="text,GIQT20" GF="N 11,0">WMS재고실사</td>	<!--WMS재고실사-->
			    						<td GH="80 GIQT21" GCol="text,GIQT21" GF="N 11,0">GIQT21</td>	<!--GIQT21-->
			    						<td GH="80 GIQT22" GCol="text,GIQT22" GF="N 11,0">GIQT22</td>	<!--GIQT22-->
			    						<td GH="80 GIQT23" GCol="text,GIQT23" GF="N 11,0">GIQT23</td>	<!--GIQT23-->
			    						<td GH="80 GIQT24" GCol="text,GIQT24" GF="N 11,0">GIQT24</td>	<!--GIQT24-->
			    						<td GH="80 GIQT25" GCol="text,GIQT25" GF="N 11,0">GIQT25</td>	<!--GIQT25-->
			    						<td GH="80 GIQT26" GCol="text,GIQT26" GF="N 11,0">GIQT26</td>	<!--GIQT26-->
			    						<td GH="80 GIQT27" GCol="text,GIQT27" GF="N 11,0">GIQT27</td>	<!--GIQT27-->
			    						<td GH="80 GIQT28" GCol="text,GIQT28" GF="N 11,0">GIQT28</td>	<!--GIQT28-->
			    						<td GH="80 GIQT29" GCol="text,GIQT29" GF="N 11,0">GIQT29</td>	<!--GIQT29-->
			    						<td GH="80 GIQT30" GCol="text,GIQT30" GF="N 11,0">GIQT30</td>	<!--GIQT30-->
			    						<td GH="80 STD_QTRESU" GCol="text,QTCOMP" GF="N 11,0">결과수량</td>	<!--결과수량-->
			    						<td GH="80 TEMP01" GCol="text,TEMP01" GF="S 10">TEMP01</td>	<!--TEMP01-->
			    						<td GH="80 TEMP02" GCol="text,TEMP02" GF="S 10">TEMP02</td>	<!--TEMP02-->
			    						<td GH="80 TEMP03" GCol="text,TEMP03" GF="S 10">TEMP03</td>	<!--TEMP03-->
			    						<td GH="80 TEMP04" GCol="text,TEMP04" GF="S 10">TEMP04</td>	<!--TEMP04-->
			    						<td GH="80 TEMP05" GCol="text,TEMP05" GF="N 11,0">TEMP05</td>	<!--TEMP05-->
			    						<td GH="80 SUBLSQ" GCol="text,SUBLSQ" GF="S 10">SUBLSQ</td>	<!--SUBLSQ-->
			    						<td GH="50 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!-- 생성일자 -->
			    						<td GH="50 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!-- 생성시간 -->
			    						<td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!-- 생성자 -->
			    						<td GH="50 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!-- 생성자명 -->
			    						<td GH="50 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!-- 수정일자 -->
			    						<td GH="50 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!-- 수정시간 -->
			    						<td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!-- 수정자 -->
			    						<td GH="50 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td>	<!-- 수정자명 -->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>   
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>   
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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