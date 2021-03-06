<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangOutbound", 
			command : "OY02_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OY02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangOutbound",
	    	colorType : true ,
			command : "OY02_ITEM",
		    menuId : "OY02"
	    });
		
		inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["I.OTRQDT"].valueChange();
		gridList.setReadOnly("gridHeadList", true, ["WARESR", "DOCUTY", "ORDTYP", "DIRDVY", "DIRSUP", "NAME03B", "C00102"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});
	
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SaveAll"){
			saveAll();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY02");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OY02");
		}
	}
	
	//조회
	function searchList(){
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		var param = inputList.setRangeDataParam("searchArea");

		if($("#CHKMAK").prop("checked") == true) param.put("CHKMAK", "V");
		$('#btnSave').show();
		$('#btnSaveAll').show();

		gridList.gridList({
	    	id : "gridHeadList",
	    	param : param
	    });
	}


	//저장
	function saveData() {
		
		if (gridList.validationCheck("gridHeadList", "select")) {

			//아이템은 내부에서 재조회 
			var param = inputList.setRangeDataParam("searchArea");
			var head = gridList.getSelectData("gridHeadList", true);
			param.put("head",head);

			if (head.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			//item 저장불가 조건 체크
			if($("#ORDSEQ").val() == "" || $("#ORDSEQ").val() == " "){
				commonUtil.msgBox("VALID_ORDSEQ");//주문마감차수를 입력해주세요
				return;
			}

			param.put("ORDSEQ", $("#ORDSEQ").val());
			
			netUtil.send({
				url : "/OyangOutbound/json/acceptShpOrder.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}



	//저장(전체)
	function saveAll() {
		gridList.checkAll("gridHeadList",true);
		saveData();
	}
	

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			commonUtil.msgBox("VALID_M0009",[json.data.RTNMSG]);
			if(json.data.RESULT == "Y" && json.data.COMCNT > 0 ){
				$('#btnSave').hide();
				$('#btnSaveAll').hide();
			
				//재조회
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				var param = inputList.setRangeDataParam("searchArea");
				param.put("SVBELNS", json.data.SVBELNS);

				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
				

			}
		}
	}
	
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}

	
	//저장 후 조회 
	function searchListSaveAfter(svbeln){
		var param = inputList.setRangeParam("searchArea");
		param.put("SVBELN",svbeln);
		
		//아이템 재조회
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHWAHMA"){
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("OWNRKY",$("#OWNRKY").val());
            param.put("PTNRTY","0007");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("OWNRKY",$("#OWNRKY").val());
            param.put("PTNRTY","0001");
        }else if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY",$("#OWNRKY").val());
        }
		
        
    	return param;
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
					<input type="button" id="btnSave" CB="Save SAVE BTN_ACCEPT" />
					<input type="button" id="btnSaveAll" CB="SaveAll SAVE BTN_ACCEPTA" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--양산제품만조회-->  
						<dt CL="STD_VIEWYANG"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" />
						</dd> 
					</dl>
					<dl>  <!--거점-->  
						<dt CL="STD_WAREKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WAREKY" UIInput="SR,SHWAHMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문일자-->  
						<dt CL="STD_CTODDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품요청일 -->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 차수 -->
						<span CL="STD_ORDSEQ2" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="ORDSEQ" id="ORDSEQ"  class="input" commonCombo="N00105N" ComboCodeView="true"><option></option></select>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>  
										<td GH="40" GCol="rowCheck"></td>  
			    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 IFT_WARESRC" GCol="select,WARESR">	<!--요구사업장-->
			    							<select class="input" commonCombo="PTNG06"><option></option></select>
			    						</td>
			    						<td GH="80 IFT_DOCUTY" GCol="select,DOCUTY">	<!--출고유형-->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 IFT_ORDTYP" GCol="select,ORDTYP">	<!--주문/출고형태-->
			    							<select class="input" commonCombo="PGRC03"></select>
										</td>
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_VDATU" GCol="text,OTRQDT" GF="D 8">납품요청일 </td>	<!--납품요청일 -->
			    						<td GH="80 STD_N00105" GCol="text,N00105" GF="N 13,0">주문차수</td>	<!--주문차수-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
			    						<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP">	<!--주문구분-->
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
			    						<td GH="80 권역사업장" GCol="select,NAME03B">	<!--권역사업장-->
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>
			    						<td GH="50 STD_RQARRT" GCol="text,ERPCTM" GF="T 6">	<!--지시시간--></td>
			    						<td GH="80 IFT_C00102" GCol="select,C00102"><!--승인여부-->
			    							<select class="input" commonCombo="C00102"></select>
			    						</td>	
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
			    						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="80 IFT_WAREKY" GCol="select,WAREKY">	<!--WMS거점(출고사업장)-->
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="80 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td>	<!--누적주문수량-->
			    						<td GH="80 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td>	<!--가용재고-->
			    						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
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
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
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