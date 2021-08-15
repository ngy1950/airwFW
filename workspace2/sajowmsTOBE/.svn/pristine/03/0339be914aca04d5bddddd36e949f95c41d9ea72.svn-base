<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL50</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var module = 'Report';
	var command = 'RL41';
	var gridId = 'gridList';
	var param = null;

	$(document).ready(
			function() {

				gridList.setGrid({
					id : gridId,
					module : module,
					command : command,
				    menuId : "RL41"
				});

				uiList.setActive("Reload", false);

				// 콤보박스 리드온리
				gridList.setReadOnly("gridList", true, [ "CARGBN", "PGRC02",
						"PGRC03", "PTNG06", "SKUG05", "DOCUTY_COMCOMBO" ]);
				
				//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
				setVarriantDef();
			});

	function linkPopCloseEvent(data) { //팝업 종료 
		if (data.get("TYPE") == "GET") {
			sajoUtil.setVariant("searchArea", data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	

	// 버튼 클릭
	function commonBtnClick(btnName) {
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "RL41");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "RL41");
		} else if (btnName == "Search") {
			search();
		} else if (btnName == "Reload") {
			reload();
		}
	}// end commonBtnClick()	

	// 서치헬프 parameter 셋팅
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj) {
		param = new DataMap();

		var ownrky = $('#OWNRKY').val();
		var wareky = $('#WAREKY').val();

		var name = $inputObj.name;

		if (searchCode == 'SHDOCTM') { // 출고유형
			param.put('DOCCAT', '200');
		} else if (searchCode == 'SHSKUMA') { // 제품코드
			param.put('OWNRKY', ownrky);
			param.put('WAREKY', wareky);
		} else if (searchCode == 'SHBZPTN') { // 업체코드
			param.put('OWNRKY', ownrky);
			param.put('PTNRTY', '0007');
		} else if (searchCode == 'SHCMCDV') {
			if (name == 'PGRC03') { // 주무 구분
				param.put('CMCDKY', name);
			} else if (name == 'PGRC02') { // 배송구분
				param.put('CMCDKY', name);
			} else if (name == 'PGRC04') { // 권역사업장
				param.put('CMCDKY', name);
			} else if (name == 'PGRC05') { // 요구 사업장
				param.put('CMCDKY', name);
			} else if (name == 'SKUG05') { // 제품용도
				param.put('CMCDKY', name);
			}
		}

		return param;
	} // end searchHelpEventOpenBefore()

	// search(조회)
	function search() {
		// param = inputList.getRangeParam('searchArea');
		// console.log(param);
		param = inputList.setRangeParam('searchArea');
		// console.log(param)

		gridList.gridList({
			id : gridId,
			param : param
		});

	} // end search()

	// grid 조회 시 data 적용이 완료된 후
	function gridListEventDataBindEnd(gridId, dataLength, excelLoadType) {
		if (gridId == 'gridList') {
			var list = gridList.getGridData(gridId);
			if (list.length > 0)
				uiList.setActive("Reload", true);
		}
	} // end gridListEventDataBindEnd()

	// reload(재조회)
	function reload() {
		gridList.resetGrid(gridId);
		search();
	} // end reload()
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
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" /> <input
							type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> <input
							type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner" id="searchArea">
					<div class="search_wrap ">
						<!-- 화주 -->
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY" class="input"
									Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"
									validate="required"></select>
							</dd>
						</dl>
						<!-- 거점 -->
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input"
									validate="required"></select>
							</dd>
						</dl>
						<dl>
							<!-- 배송일자 -->
							<dt CL="STD_CARDAT"></dt>
							<dd>
								<input type="text" class="input" name="DOCDAT" UIInput="B"
									UIFormat="C N" />
							</dd>
						</dl>
						<dl>
							<!-- 배송차수 -->
							<dt CL="STD_SHIPSQ"></dt>
							<dd>
								<input type="text" class="input" name="SEQ" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 출고문서번호 -->
							<dt CL="STD_SHPOKY"></dt>
							<dd>
								<input type="text" class="input" name="SHPOKY" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- S/O번호-->
							<dt CL="STD_SVBELN"></dt>
							<dd>
								<input type="text" class="input" name="SVBELN" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 출고유형 -->
							<dt CL="STD_SHPMTY"></dt>
							<dd>
								<input type="text" class="input" name="SHPMTY"
									UIInput="SR,SHDOCTM" />
							</dd>
						</dl>
						<dl>
							<!-- 문서일자 -->
							<dt CL="STD_DOCDAT"></dt>
							<dd>
								<input type="text" class="input" name="DOCDAT" UIInput="B"
									UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<!-- 제품코드 -->
							<dt CL="STD_SKUKEY"></dt>
							<dd>
								<input type="text" class="input" name="SKUKEY"
									UIInput="SR,SHSKUMA" />
							</dd>
						</dl>
						<dl>
							<!-- 제품명 -->
							<dt CL="STD_DESC01"></dt>
							<dd>
								<input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/>
							</dd>
						</dl>
						<dl>
							<!-- 업체코드 -->
							<dt CL="STD_DPTNKY"></dt>
							<dd>
								<input type="text" class="input" name="DPTNKY"
									UIInput="SR,SHBZPTN" />
							</dd>
						</dl>
						<dl>
							<!-- 업체명 -->
							<dt CL="STD_DPTNKYNM"></dt>
							<dd>
								<input type="text" class="input" name="DPTNKYNM" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 차량번호 -->
							<dt CL="STD_CARNUM"></dt>
							<dd>
								<input type="text" class="input" name="CARNUM" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 차량구분 -->
							<dt CL="STD_CARGBN"></dt>
							<dd>
								<select name="CARGBN" id="CARGBN" class="input"
									CommonCombo="CARGBN">
									<option value="" selected></option>
								</select>
							</dd>
						</dl>
						<dl>
							<!-- 주문구분 -->
							<dt CL="IFT_DIRSUP"></dt>
							<dd>
								<input type="text" class="input" name="PGRC03"
									UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<!-- 배송구문 -->
							<dt CL="IFT_DIRDVY"></dt>
							<dd>
								<input type="text" class="input" name="PGRC02"
									UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<!--권역사업장-->
							<dt CL="STD_WEGWRK"></dt>
							<dd>
								<input type="text" class="input" name="NAME03"
									UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<!--권역사업장명-->
							<dt CL="STD_WEGWRKNM"></dt>
							<dd>
								<input type="text" class="input" name="NAME03NM" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 제조일자 -->
							<dt CL="STD_LOTA11"></dt>
							<dd>
								<input type="text" class="input" name="LOTA11" UIInput="B"
									UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<!-- 입고일자 -->
							<dt CL="STD_LOTA12"></dt>
							<dd>
								<input type="text" class="input" name="LOTA12" UIInput="B"
									UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<!-- 유통기한 -->
							<dt CL="STD_LOTA13"></dt>
							<dd>
								<input type="text" class="input" name="LOTA13" UIInput="B"
									UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<!-- 요구사업장 -->
							<dt CL="IFT_WARESRC"></dt>
							<dd>
								<input type="text" class="input" name="PGRC04"
									UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<!-- 요구사업장명 -->
							<dt CL="IFT_WARESRN"></dt>
							<dd>
								<input type="text" class="input" name="PG04NM" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 제품용도 -->
							<dt CL="STD_SKUG05"></dt>
							<dd>
								<input type="text" class="input" name="SKUG05"
									UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<!-- 영업사원명 -->
							<dt CL="STD_UNAME4"></dt>
							<dd>
								<input type="text" class="input" name="UNAME4" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<!-- 영업사원연락처 -->
							<dt CL="STD_DNAME4"></dt>
							<dd>
								<input type="text" class="input" name="DNAME4" UIInput="SR" />
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
											<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>
											<!-- 화주 -->
											<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>
											<!-- 거점 -->
											<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10"></td>
											<!-- 문서일자 -->
											<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10"></td>
											<!-- 배송일자 -->
											<td GH="80 STD_CARINFO" GCol="text,CARINFO" GF="S 20"></td>
											<!-- 차량정보 -->
											<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20"></td>
											<!-- 차량번호 -->
											<td GH="80 STD_ACUDAT" GCol="text,ACUDAT" GF="S 20"></td>
											<!-- 운임정산일자 -->
											<td GH="80 STD_RECNUM" GCol="text,RECNUM" GF="S 20"></td>
											<!-- 재배차 차량번호 -->
											<td GH="80 STD_CARINFO2" GCol="text,CARINFO2" GF="S 20"></td>
											<!-- 재배차 차량정보 -->
											<td GH="80 STD_CARSEQ" GCol="text,CARSEQ" GF="S 20"></td>
											<!-- 차량차수 -->
											<td GH="80 STD_CARGBN" GCol="select,CARGBN">
												<!-- 차량 구분 --> <select id="input" CommonCombo="CARGBN"></select>
											</td>
											<td GH="80 STD_CARTYP" GCol="text,CARTYP" GF="S 20"></td>
											<!-- 차량 톤수 -->
											<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0"></td>
											<!-- 배송차수 -->
											<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">
												<!-- 출고유형 --> <select class="input"
												Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
											</td>
											<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 220"></td>
											<!-- S/O번호 -->
											<td GH="80 STD_PTNL10B" GCol="text,DESC03" GF="S 20"></td>
											<!-- 구코드 -->
											<td GH="80 STD_NEWKEY" GCol="text,SKUKEY" GF="S 20"></td>
											<!-- 신코드 -->
											<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="S 20"></td>
											<!-- 순중량 -->
											<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 220"></td>
											<!-- 제품명 -->
											<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 220"></td>
											<!-- 규격 -->
											<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 20"></td>
											<!-- 단위 -->
											<td GH="80 STD_QTSHPO1" GCol="text,QTSHPO" GF="N 80,0"></td>
											<!-- 지시수량(낱개) -->
											<td GH="80 STD_BOXQTY1" GCol="text,BOXQTY1" GF="N 80,1"></td>
											<!-- 지시수량(BOX) -->
											<td GH="80 STD_QTYORG2" GCol="text,QTYORG" GF="N 80,0"></td>
											<!-- 실입고수량(낱개) -->
											<td GH="80 STD_BOXQTY2" GCol="text,BOXQTY2" GF="N 80,1"></td>
											<!-- 실입고수량(BOX) -->
											<td GH="80 STD_QTJCMP3" GCol="text,QTJCMP" GF="N 80,0"></td>
											<!-- 피킹완료수량(낱개) -->
											<td GH="80 STD_BOXQTY3" GCol="text,BOXQTY3" GF="N 80,1"></td>
											<!-- 피킹완료수량(BOX) -->
											<td GH="80 STD_PLTQTYP" GCol="text,PLTQTY3" GF="N 80,2">피킹완료수량(PLT)</td>
											<!--피킹완료수량(PLT)-->
											<td GH="80 STD_QTCAR" GCol="text,QTCAR" GF="N 80,0"></td>
											<!-- 배차수량(낱개) -->
											<td GH="80 STD_BOXQTY7" GCol="text,BOXQTY7" GF="N 80,1"></td>
											<!-- 배차수량(BOx) -->
											<td GH="80 STD_PLTQTY7" GCol="text,PLTQTY7" GF="N 80,2">배차수량(PLT)</td>
											<!--배차수량(PLT)-->
											<td GH="80 STD_QTSHPD4" GCol="text,QTSHPD" GF="N 80,0"></td>
											<!-- 출고수량(BOX) -->
											<td GH="80 STD_BOXQTY4" GCol="text,BOXQTY4" GF="N 80,1"></td>
											<!-- 출고수량(낱개) -->
											<td GH="80 STD_QTYREF5" GCol="text,QTYREF" GF="N 80,0"></td>
											<!-- 취소수량(낱개) -->
											<td GH="80 STD_BOXQTY5" GCol="text,BOXQTY5" GF="N 80,1"></td>
											<!-- 취소수량(BOX) -->
											<td GH="80 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0"></td>
											<!-- 최종수량(낱개) -->
											<td GH="80 STD_QTYCAL2" GCol="text,QTYCAL2" GF="N 80,0">최종수량(잔여)</td>
											<!--최종수량(잔여)-->
											<td GH="80 STD_BOXQTY6" GCol="text,BOXQTY6" GF="N 80,1"></td>
											<!-- 최종수량(BOX) -->
											<td GH="80 STD_PLTQTY6" GCol="text,PLTQTY6" GF="N 80,2"></td>
											<!-- 최종수량(PLT) -->
											<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 80"></td>
											<!-- 비고 -->
											<td GH="80 STD_IFPGRC02" GCol="select,PGRC02">
												<!-- 배송구분 --> <select id="input" CommonCombo="PGRC02"></select>
											</td>
											<td GH="80 STD_PGRC03" GCol="select,PGRC03">
												<!-- 주문구분 --> <select id="input" CommonCombo="PGRC03"></select>
											</td>
											<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 80"></td>
											<!-- 배송지우편번호 -->
											<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 80"></td>
											<!--배송지주소-->
											<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10"></td>
											<!-- 권역코드 -->
											<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80"></td>
											<!-- 권역명 -->
											<td GH="80 STD_WEGWRK" GCol="text,NAME03" GF="S 80">권역사업장</td>
											<!--권역사업장-->
											<td GH="80 STD_WEGWRKNM" GCol="text,NAME03NM" GF="S 80">권역사업장명</td>
											<!--권역사업장명-->
											<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 80"></td>
											<!-- 배송고객명 -->
											<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 80"></td>
											<!-- 배송지전화번호 -->
											<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80"></td>
											<!-- 박스입수 -->
											<td GH="80 STD_DPTNKYCD" GCol="text,DPTNKY" GF="S 80">매출처코드</td>
											<!--매출처코드-->
											<td GH="80 STD_PTRCNM" GCol="text,DPTNKYNM" GF="S 80">매출처명</td>
											<!--매출처명-->
											<td GH="80 STD_PTRCVRCD" GCol="text,PTRCVR" GF="S 80">납품처코드</td>
											<!--납품처코드-->
											<td GH="80 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 80">납품처명</td>
											<!--납품처명-->
											<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10"></td>
											<!-- 출고문서번호 -->
											<td GH="80 STD_FORKYN" GCol="text,FORKYN" GF="S 10"></td>
											<!-- 지게차사용여부 -->
											<td GH="80 STD_PTNG07B" GCol="text,PTNG07" GF="S 10"></td>
											<!-- 최대진입가능차량 -->
											<td GH="120 STD_PGRC04" GCol="select,PGRC04">
												<!-- 주문부서 --> <select class="input" CommonCombo="PTNG06"></select>
											</td>
											<td GH="80 STD_SKUG05" GCol="select,SKUG05">
												<!-- 제품용도 --> <select class="input" CommonCombo="SKUG05"></select>
											</td>
											<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 10"></td>
											<!-- 영업사원명 -->
											<td GH="90 STD_DNAME4" GCol="text,DNAME4" GF="S 15"></td>
											<!-- 영업사원연락처 -->
											<td GH="50 STD_RQARRT" GCol="text,RQARRT" GF="T 6"></td>
											<!-- 지시시간 -->
											<td GH="100 STD_SETNM" GCol="text,SETNM" GF="S 100">택배상품명</td>
											<!--택배상품명-->
											<td GH="100 STD_SENDERNM" GCol="text,UNAME2" GF="S 100">사판(보내는사람)</td>
											<!--사판(보내는사람)-->
											<td GH="100 STD_PAYMENT001" GCol="text,PRC001" GF="S 100">지입료</td>
											<!--지입료-->
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