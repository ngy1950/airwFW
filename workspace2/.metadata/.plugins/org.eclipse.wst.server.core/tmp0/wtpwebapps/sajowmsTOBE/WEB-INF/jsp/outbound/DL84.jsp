<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL00</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "ORDER_NOT_CLOSED_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "DL84"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "ORDER_NOT_CLOSED_ITEM",
			emptyMsgType : false,
			menuId : "DL84"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		gridList.setReadOnly("gridHeadList", true, ["WARESR","DOCUTY","ORDTYP","PTNG08","DIRDVY","DIRSUP"]);
		searchwareky($('#OWNRKY').val());

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#WAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			param.put("SVBELN",rowData.map.SVBELN);
			
/* 			netUtil.send({
				url : "/OutBoundReport/json/displayDL84.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			}); */
			
			
 			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    }); 
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "200");
		}else if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			} else if(name == "C00102"){
				param.put("CMCDKY", "C00102");	
			} else if(name == "CASTYN"){
				param.put("CMCDKY", "ALLYN");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL84");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL84");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_ORDTYP"></dt> <!-- 주문/출고형태 -->
						<dd>
							<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_ORDDAT"></dt> <!-- 출고일자 -->
						<dd>
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C N"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_CTODDT"></dt> <!-- 주문일자 -->
						<dd>
							<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/>
						</dd>
					</dl>			
					<dl>
						<dt CL="STD_SHPMTY"></dt> <!-- 출고유형 -->
						<dd>
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR, SHDOCTMIF"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="IFT_OTRQDT"></dt> <!-- 출고요청일 -->
						<dd>
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_PTNRTO"></dt> <!-- 납품처코드 -->
						<dd>
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR, SHBZPTN"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="IFT_PTNROD"></dt> <!-- 매출처코드 -->
						<dd>
							<input type="text" class="input" name="I.PTNROD" UIInput="SR, SHBZPTN"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="IFT_WARESRC"></dt> <!-- 요구사업장 -->
						<dd>
							<input type="text" class="input" name="I.WARESR" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="IFT_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_SKUG05"></dt> <!-- 제품용도 -->
						<dd>
							<input type="text" class="input" name="SM2.SKUG05" UIInput="SR,SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="IFT_DIRSUP"></dt> <!-- 주문구분 -->
						<dd>
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMDCDV"/>
						</dd>
					</dl>																				
					<dl>
						<dt CL="IFT_DIRDVY"></dt> <!-- 배송구분 -->
						<dd>
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_QTYREQBOX"></dt> <!-- 요청수량(BOX) -->
						<dd>
							<input type="text" class="input" name="I.QTYORG / QTDUOM"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_QTYREQEA"></dt> <!-- 요청수량(낱개) -->
						<dd>
							<input type="text" class="input" name="I.QTYORG"/>
						</dd>
					</dl>		

					<dl>
						<dt CL="STD_PTNG08"></dt> <!-- 마감구분 -->
						<dd>
							<input type="text" class="input" name="B2.PTNG08" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_ASKU05"></dt> <!-- 상온구분 -->
						<dd>
							<input type="text" class="input" name="SM2.ASKU05" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_PTNG01"></dt> <!-- 유통경로1 -->
						<dd>
							<input type="text" class="input" name="B2.PTNG01" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_PTNG02"></dt> <!-- 유통경로2 -->
						<dd>
							<input type="text" class="input" name="B2.PTNG02" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_PTNG03"></dt> <!-- 유통경로3 -->
						<dd>
							<input type="text" class="input" name="B2.PTNG03" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_SKUG02"></dt> <!-- 중분류 -->
						<dd>
							<input type="text" class="input" name="I.SKUG02" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
					<dl>
						<dt CL="STD_SKUG03"></dt> <!-- 소분류 -->
						<dd>
							<input type="text" class="input" name="I.SKUG03" UIInput="SR, SHCMDCDV"/>
						</dd>
					</dl>											
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="130 IFT_WARESRC" GCol="select,WARESR">				<!--요구사업장-->
			    							<select class="input" commonCombo="PTNG06"></select>
			    						</td>	
			    						<td GH="130 IFT_DOCUTY" GCol="select,DOCUTY">
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO">
												<option></option>
											</select>	
			    						</td>	<!--출고유형-->
			    						<td GH="130 IFT_ORDTYP" GCol="select,ORDTYP">
			    							<select class="input" commonCombo="PGRC03"></select>
			    						</td>	<!--주문/출고형태-->
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
			    						<td GH="130 STD_PTNG08" GCol="select,PTNG08"">
			    							<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
			    						</td>	<!--마감구분-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY">					<!--배송구분-->
			    							<select class="input" commonCombo="PGRC02"></select>
			    						</td>	
			    						<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP"> 					<!--주문구분-->
			    							<select class="input" commonCombo="PGRC03"></select>
			    						</td>	
			    						<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
			    						<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
			    						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 IFT_BOXQTYORG" GCol="text,BOXQTY" GF="N 13,1">원주문수량(BOX)</td>	<!--원주문수량(BOX)-->
			    						<td GH="80 IFT_BOXQTYREQ" GCol="text,BXIQTY" GF="N 13,1">납품요청수량(BOX)</td>	<!--납품요청수량(BOX)-->
			    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>	<!--권역코드-->
			    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td>	<!--권역명-->
			    						<td GH="80 권역사업장" GCol="text,NAME03B" GF="S 80">권역사업장</td>	<!--권역사업장-->
			    						<td GH="50 STD_RQARRT" GCol="text,ERPCTM" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="80 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td>	<!--승인여부-->
			    						<td GH="50 STD_ERDAT" GCol="text,CREDAT" GF="D 10">지시일자</td>	<!--지시일자-->
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
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
    						<td GH="20 S" GCol="text,ROWCK" GF="S 1">S</td>	<!--S-->
    						<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
    						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
    						<td GH="80 IFT_WAREKY" GCol="text,WAREKY" GF="S 10">WMS거점(출고사업장)</td>	<!--WMS거점(출고사업장)-->
    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">원주문수량</td>	<!--원주문수량-->
    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
    						<td GH="80 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td>	<!--누적주문수량-->
    						<td GH="80 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td>	<!--가용재고-->
    						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS작업수량</td>	<!--WMS작업수량-->
    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
    						<td GH="100 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
    						<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="D 8">LMODAT</td>	<!--LMODAT-->
    						<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="T 6">LMOTIM</td>	<!--LMOTIM-->
    						<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
    						<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
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