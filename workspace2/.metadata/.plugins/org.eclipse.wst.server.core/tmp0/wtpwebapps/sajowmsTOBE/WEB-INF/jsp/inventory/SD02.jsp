<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "InventoryReport",
			command : "SD02",
		    colorType : true ,
		    menuId : "SD02"
	    });
		
		gridList.setReadOnly("gridList", true, ["LOTA06"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SD02");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SD02");
		} 
	}

	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("TYPE","SEARCH");
			
 			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}
		return param;
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHAREMA" && $inputObj.name == "S.AREAKY"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHZONMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
            param.put("CMCDKY","SKUG01");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU04"){
            param.put("CMCDKY","ASKU04");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "M.SKUG05"){
            param.put("CMCDKY","SKUG05");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
            param.put("CMCDKY","SKUG02");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
            param.put("CMCDKY","SKUG03");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG04"){
            param.put("CMCDKY","SKUG04");
        }else if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
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
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
							</dd>
						</dl>
						
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--동-->  
							<dt CL="STD_AREAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--존-->  
							<dt CL="STD_ZONEKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--재고키-->  
							<dt CL="STD_STOKKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.STOKKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품명-->  
							<dt CL="STD_DESC01"></dt> 
							<dd> 
								<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--대분류-->  
							<dt CL="STD_SKUG01"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUG01" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--팔렛트ID-->  
							<dt CL="STD_TRNUID"></dt> 
							<dd> 
								<input type="text" class="input" name="S.TRNUID" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--재고수량-->  
							<dt CL="STD_QTSIWH"></dt> 
							<dd> 
								<input type="text" class="input" name="S.QTSIWH" UIInput="SR"/> 
							</dd> 
						</dl> 	
						
						<dl>  <!--유통기한-->  
							<dt CL="STD_LOTA13"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA13" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl>  
						
						<dl>  <!--입고일자 -->  
							<dt CL="STD_LOTA12"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA12" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl>  
						
						<dl>  <!--벤더-->  
							<dt CL="STD_LOTA03"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM"/> 
							</dd> 
						</dl>  
						
						<dl>  <!--포장구분-->  
							<dt CL="STD_LOTA05"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--재고유형-->  
							<dt CL="STD_LOTA06"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--입고문서번호-->  
							<dt CL="STD_RECVKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.RECVKY" UIInput="SR,SHRECDH"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SHPOKY" UIInput="SR,SHSHPDH"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--작업지시번호-->  
							<dt CL="STD_TASKKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.TASKKY" UIInput="SR,SHVPTASO"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--조정문서번호-->  
							<dt CL="STD_SADJKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SADJKY" UIInput="SR,SHADJDH"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--재고조사번호-->  
							<dt CL="STD_PHYIKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.PHYIKY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--구매오더 No-->  
							<dt CL="STD_SEBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SEBELN" UIInput="SR,SHPO103"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--S/O 번호-->  
							<dt CL="STD_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SVBELN" UIInput="SR"/> 
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
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
				    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="70 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="70 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->		
				    						<td GH="60 STD_DESC02" GCol="text,DESC02" GF="S 1800">규격</td>	<!--규격-->
				    						<td GH="100 STD_LOTA06" GCol="select,LOTA06">
												<select class="input" commonCombo="LOTA06">
													<option></option>
												</select>
				    						</td>	<!--재고유형-->
				    						<td GH="70 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="88 STD_QTDUOM" GCol="text,QTDUOM" GF="N 11,0">입수</td>	<!--입수-->
				    						<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
				    						<td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
				    						<td GH="70 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
				    						<td GH="70 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
				    						<td GH="70 STD_QTSPMI" GCol="text,QTSPMI" GF="N 11,0">입고중</td>	<!--입고중-->
				    						<td GH="70 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
				    						<td GH="70 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
				    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
				    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
				    						<td GH="80 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
				    						<td GH="80 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
				    						<td GH="50 STD_SECTID" GCol="text,SECTID" GF="S 4">SectionID</td>	<!--SectionID-->
				    						<td GH="70 STD_QTYUOM" GCol="text,QTYUOM" GF="N 11,0">Quantity by unit of measure</td>	<!--Quantity by unit of measure-->
				    						<td GH="70 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td>	<!--팔렛타입-->
				    						<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
				    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
				    						<td GH="66 STD_QTPUOM" GCol="text,QTPUOM" GF="N 11,0">Units per measure</td>	<!--Units per measure-->
				    						<td GH="50 STD_DUOMKY" GCol="text,DUOMKY" GF="S 3">단위</td>	<!--단위-->
				    						<td GH="80 STD_TKFLKY" GCol="text,TKFLKY" GF="S 10">작업흐름 키</td>	<!--작업흐름 키-->
				    						<td GH="50 STD_STEPNO" GCol="text,STEPNO" GF="S 3">단계 번호</td>	<!--단계 번호-->
				    						<td GH="50 STD_LSTTFL" GCol="text,LSTTFL" GF="S 1">작업흐름 최종 스텝</td>	<!--작업흐름 최종 스텝-->
				    						<td GH="80 STD_SRCSKY" GCol="text,SRCSKY" GF="S 10">Src.재고키</td>	<!--Src.재고키-->
				    						<td GH="50 STD_UOMDOC" GCol="text,UOMDOC" GF="S 4">참조문서 단위</td>	<!--참조문서 단위-->
				    						<td GH="88 STD_CNTBSK" GCol="text,CNTBSK" GF="N 11,0">Count of branch stock key</td>	<!--Count of branch stock key-->
				    						<td GH="50 STD_NUPDPS" GCol="text,NUPDPS" GF="S 1">Not update to parent stock key</td>	<!--Not update to parent stock key-->
				    						<td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
				    						<td GH="90 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
				    						<td GH="80 STD_PURCKY" GCol="text,PURCKY" GF="S 10">구매오더 번호</td>	<!--구매오더 번호-->
				    						<td GH="50 STD_PURCIT" GCol="text,PURCIT" GF="S 6">구매오더 아이템번호</td>	<!--구매오더 아이템번호-->
				    						<td GH="50 STD_ASNDIT" GCol="text,ASNDIT" GF="S 6">ASN It.</td>	<!--ASN It.-->
				    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
				    						<td GH="50 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
				    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="50 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
				    						<td GH="80 STD_GRPOKY" GCol="text,GRPOKY" GF="S 10">제품별피킹번호</td>	<!--제품별피킹번호-->
				    						<td GH="50 STD_GRPOIT" GCol="text,GRPOIT" GF="S 6">제품별피킹Item</td>	<!--제품별피킹Item-->
				    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
				    						<td GH="50 STD_TASKIT" GCol="text,TASKIT" GF="S 6">작업오더아이템</td>	<!--작업오더아이템-->
				    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
				    						<td GH="50 STD_SADJIT" GCol="text,SADJIT" GF="S 6">조정 Item</td>	<!--조정 Item-->
				    						<td GH="80 STD_SDIFKY" GCol="text,SDIFKY" GF="S 10">작업자별피킹번호</td>	<!--작업자별피킹번호-->
				    						<td GH="50 STD_SDIFIT" GCol="text,SDIFIT" GF="S 6">작업자별피킹아이템</td>	<!--작업자별피킹아이템-->
				    						<td GH="80 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>	<!--재고조사번호-->
				    						<td GH="80 STD_PHYIIT" GCol="text,PHYIIT" GF="S 6">재고조사item</td>	<!--재고조사item-->
				    						<td GH="80 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
				    						<td GH="80 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
				    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
				    						<td GH="80 STD_LOTA04" GCol="text,LOTA04" GF="S 20">LOTA04</td>	<!--LOTA04-->
				    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
				    						<td GH="80 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
				    						<td GH="80 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
				    						<td GH="80 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
				    						<td GH="80 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
				    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
				    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
				    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
				    						<td GH="80 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td>	<!--LOTA14-->
				    						<td GH="80 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td>	<!--LOTA15-->
				    						<td GH="88 STD_LOTA16" GCol="text,LOTA16" GF="S 11">LOTA16</td>	<!--LOTA16-->
				    						<td GH="88 STD_LOTA17" GCol="text,LOTA17" GF="S 11">LOTA17</td>	<!--LOTA17-->
				    						<td GH="88 STD_LOTA18" GCol="text,LOTA18" GF="S 11">LOTA18</td>	<!--LOTA18-->
				    						<td GH="88 STD_LOTA19" GCol="text,LOTA19" GF="S 11">LOTA19</td>	<!--LOTA19-->
				    						<td GH="88 STD_LOTA20" GCol="text,LOTA20" GF="S 11">LOTA20</td>	<!--LOTA20-->
				    						<td GH="80 STD_AWMSNO" GCol="text,AWMSNO" GF="S 10">SEQ(상단시스템)</td>	<!--SEQ(상단시스템)-->
				    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
				    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
				    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
				    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
				    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
				    						<td GH="80 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td>	<!--중분류-->
				    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td>	<!--소분류-->
				    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td>	<!--세분류-->
				    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
				    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="N 11,0">포장중량</td>	<!--포장중량-->
				    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="N 11,0">순중량</td>	<!--순중량-->
				    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
				    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="N 11,0">포장가로</td>	<!--포장가로-->
				    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="N 11,0">포장세로</td>	<!--포장세로-->
				    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="N 11,0">포장높이</td>	<!--포장높이-->
				    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="N 11,0">CBM</td>	<!--CBM-->
				    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="N 11,0">CAPA</td>	<!--CAPA-->
				    						<td GH="80 STD_TKZONE" GCol="text,TKZONE" GF="S 10">작업구역</td>	<!--작업구역-->
				    						<td GH="50 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	<!--Client-->
				    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 15">구매오더 No</td>	<!--구매오더 No-->
				    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
				    						<td GH="80 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 20">B/L NO</td>	<!--B/L NO-->
				    						<td GH="80 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 20">B/L Item NO</td>	<!--B/L Item NO-->
				    						<td GH="160 STD_STRAID" GCol="text,STRAID" GF="S 20">SCM주문번호</td>	<!--SCM주문번호-->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
				    						<td GH="80 STD_STKNUM" GCol="text,STKNUM" GF="S 10">토탈계획번호</td>	<!--토탈계획번호-->
				    						<td GH="50 STD_STPNUM" GCol="text,STPNUM" GF="S 6">예약 It</td>	<!--예약 It-->
				    						<td GH="80 STD_TRAPLA" GCol="text,SWERKS" GF="S 10">이고지</td>	<!--이고지-->
				    						<td GH="80 STD_SLGORT" GCol="text,SLGORT" GF="S 10">영업 부문</td>	<!--영업 부문-->
				    						<td GH="64 STD_SDATBG" GCol="text,SDATBG" GF="D 8">출고계획일시</td>	<!--출고계획일시-->
				    						<td GH="80 STD_STDLNR" GCol="text,STDLNR" GF="S 20">작업장</td>	<!--작업장-->
				    						<td GH="80 STD_SSORNU" GCol="text,SSORNU" GF="S 10">차량별피킹번호</td>	<!--차량별피킹번호-->
				    						<td GH="50 STD_SSORIT" GCol="text,SSORIT" GF="S 6">차량별아이템피킹번호</td>	<!--차량별아이템피킹번호-->
				    						<td GH="80 STD_SMBLNR" GCol="text,SMBLNR" GF="S 10">Mat.Doc.No.</td>	<!--Mat.Doc.No.-->
				    						<td GH="50 STD_SZEILE" GCol="text,SZEILE" GF="S 6">Mat.Doc.it.</td>	<!--Mat.Doc.it.-->
				    						<td GH="50 STD_SAPSTS" GCol="text,SAPSTS" GF="S 4">상단시스템 Mvt</td>	<!--상단시스템 Mvt-->
				    						<td GH="64 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
				    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="50 STD_SMJAHR" GCol="text,SMJAHR" GF="N 10,0">M/D 년도</td>	<!--M/D 년도-->
				    						<td GH="50 STD_SXBLNR" GCol="text,SXBLNR" GF="N 16,0">인터페이스번호</td>	<!--인터페이스번호-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
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