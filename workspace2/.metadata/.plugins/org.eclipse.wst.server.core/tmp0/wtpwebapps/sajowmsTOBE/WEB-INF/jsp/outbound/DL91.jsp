<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL91</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	
	var SVBELNS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL91_ALL",
			pkcol : "OWNRKY,WAREKY",
			menuId : "DL91"
	    });
		
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
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
		
		//IF.CARDAT 하루 더하기 
		inputList.rangeMap["map"]["DH.RQSHPD"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["DH.RQSHPD"].valueChange();

		gridList.setReadOnly("gridList", true, ["DIRSUP"]);
	}

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL91");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL91");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			netUtil.send({
				url : "/outbound/json/displayDL91.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		}
		
		return param;
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        //납품처코드
    	if(searchCode == "SHBZPTN" && $inputObj.name == "DH.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //매출처코드
    	}else if(searchCode == "SHBZPTN" && $inputObj.name == "DH.PTRCVR"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
         //요청사업장
    	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC04"){
            param.put("CMCDKY","PTNG05");
        //주문구분
    	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC03"){
            param.put("CMCDKY","PGRC03");
        //배송구분
    	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC02"){
            param.put("CMCDKY","PGRC02");
        //세트여부
    	}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU02"){
            param.put("CMCDKY","ASKU02");
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.SHPOKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--S/O 번호-->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="DI.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고유형-->  
							<dt CL="IFT_DOCUTY"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문일자-->  
							<dt CL="STD_RQARRD"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.RQARRD" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고요청일-->  
							<dt CL="IFT_OTRQDT"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.RQSHPD" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송일자-->  
							<dt CL="STD_CARDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.RQSHPD" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송차수-->  
							<dt CL="STD_SHIPSQ"></dt> 
							<dd> 
								<input type="text" class="input" name="DR.SHIPSQ" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="DR.CARNUM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품처코드-->  
							<dt CL="IFT_PTNRTO"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.DPTNKY" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처코드-->  
							<dt CL="IFT_PTNROD"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.PTRCVR" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--요구사업장-->  
							<dt CL="IFT_WARESRC"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.PGRC04" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--요구사업장명-->  
							<dt CL="IFT_WARESRN"></dt> 
							<dd> 
								<input type="text" class="input" name="SA.NAME01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="DI.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품명-->  
							<dt CL="STD_DESC01"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문구분-->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.PGRC03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--오더구분-->  
							<dt CL="STD_SOGUBN"></dt> 
							<dd> 								
								<select name="SOGUBN" id="SOGUBN" class="input" CommonCombo="SOGUBN"></select>  
							</dd> 
						</dl> 
						<dl>  <!--배송구분-->  
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.PGRC02" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--권역사업장-->  
							<dt CL="STD_WEGWRK"></dt> 
							<dd> 
								<input type="text" class="input" name="BZ.NAME03" UIInput="SR,SHWAHMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--세트여부-->  
							<dt CL="STD_ASKU02"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU02" UIInput="SR,SHCMCDV" /> 
							</dd> 
						</dl> 
						<dl>  <!--영업사원명-->  
							<dt CL="STD_UNAME4"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.UNAME4" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--영업사원연락처-->  
							<dt CL="STD_DNAME4"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.DNAME4" UIInput="SR"/> 
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
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="120 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="120 STD_SHPOKY" GCol="text,SHPOKY" GF="S 40">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="50 STD_POSTCD" GCol="text,POSTCD" GF="S 30">우편번호  </td>	<!--우편번호  -->
				    						<td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="80 STD_PTRCNM" GCol="text,DPTNKYNM" GF="S 20">매출처명</td>	<!--매출처명-->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="80 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 IFT_WARESRC" GCol="text,PGRC04" GF="S 20">요구사업장</td>	<!--요구사업장-->
				    						<td GH="80 IFT_WARESRN" GCol="text,PGRC04NM" GF="S 20">요구사업장명</td>	<!--요구사업장명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 80,0">지시수량</td>	<!--지시수량-->
				    						<td GH="80 STD_BOXQTY1" GCol="text,BOXQTY1" GF="N 80,1">지시수량(BOX)</td>	<!--지시수량(BOX)-->
				    						<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 80,0">할당수량</td>	<!--할당수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 80,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_PLTQTY4" GCol="text,PLTHPD" GF="S 80">출고수량(PLT)</td>	<!--출고수량(PLT)-->
				    						<td GH="80 STD_ADJQTY" GCol="text,QTYREF" GF="N 80,0">조정수량</td>	<!--조정수량-->
				    						<td GH="80 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0">최종수량(낱개)</td>	<!--최종수량(낱개)-->
				    						<td GH="80 STD_BOXQTY6" GCol="text,BOXCAL" GF="S 80">최종수량(BOX)</td>	<!--최종수량(BOX)-->
				    						<td GH="80 STD_BOXQTY4" GCol="text,BOXQTY4" GF="N 80,1">출고수량(BOX)</td>	<!--출고수량(BOX)-->
				    						<td GH="75 STD_CARNUM" GCol="text,CARNUM" GF="S 50">차량번호</td>	<!--차량번호-->
				    						<td GH="75 STD_RECNUM" GCol="text,RECNUM" GF="S 50">재배차 차량번호</td>	<!--재배차 차량번호-->
				    						<td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 1000">비고</td>	<!--비고-->
				    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
			    							</td>
				    						<td GH="80 STD_ADDR01" GCol="text,ADDR01" GF="S 1000">주소</td>	<!--주소-->
				    						<td GH="80 STD_QTDUOM" GCol="text,QTDUOM" GF="N 80,0">입수</td>	<!--입수-->
				    						<td GH="80 IFT_SALEPR" GCol="text,PRC" GF="S 80,0">공급단가</td>	<!--공급단가-->
				    						<td GH="50 STD_S_CHECK" GCol="text,INDDCL" GF="S 1"></td>	<!---->
				    						<td GH="80 STD_SBWART" GCol="text,SBWART" GF="S 80">영업오더유형</td>	<!--영업오더유형-->
				    						<td GH="80 STD_RQARRD" GCol="text,RQARRD" GF="D 80">주문일자</td>	<!--주문일자-->
				    						<td GH="80 STD_RQSHPD" GCol="text,RQSHPD" GF="D 80">출고요청일자</td>	<!--출고요청일자-->
				    						<td GH="80 STD_CHKSEQ" GCol="text,NO" GF="S 80">검수번호</td>	<!--검수번호-->
				    						<td GH="80 STD_UNAME1" GCol="text,UNAME01" GF="S 1000">배송지주소</td>	<!--배송지주소-->
				    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
				    						<td GH="80 STD_BNAME" GCol="text,UNAME4" GF="S 80">영업사원명</td>	<!--영업사원명-->
				    						<td GH="80 STD_BPHON" GCol="text,DNAME4" GF="S 80">영업사원전화번호</td>	<!--영업사원전화번호-->
				    						<td GH="80 STD_ERDAT" GCol="text,LMODAT" GF="S 80">지시일자</td>	<!--지시일자-->
				    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 80">배송지우편번호</td>	<!--배송지우편번호-->
				    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 80">배송지전화번호</td>	<!--배송지전화번호-->
				    						<td GH="80 STD_PKZONE" GCol="text,LOCAKY" GF="S 80">피킹존</td>	<!--피킹존-->
				    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 80">88코드</td>	<!--88코드-->
				    						<td GH="80 STD_TC05NM" GCol="text,TC05NM" GF="S 80">고정배차차량번호</td>	<!--고정배차차량번호-->
				    						<td GH="80 STD_TMRKEY" GCol="text,REGNKY" GF="S 80">권역코드</td>	<!--권역코드-->
				    						<td GH="80 STD_WEGWRKNM" GCol="text,REGNNM" GF="S 80">권역사업장명</td>	<!--권역사업장명-->
				    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 80">배송차수</td>	<!--배송차수-->
				    						<td GH="80 STD_PTNL10B" GCol="text,DESC03" GF="S 80">구코드</td>	<!--구코드-->
				    						<td GH="80 STD_TOTWGT" GCol="text,TOTWGT" GF="S 80">총중량(KG)</td>	<!--총중량(KG)-->
				    						<td GH="80 STD_TC06NM" GCol="text,TC06NM" GF="S 80">권역배차차량번호</td>	<!--권역배차차량번호-->
				    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="S 80" style="text-align:right;">원주문수량</td>	<!--원주문수량-->
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