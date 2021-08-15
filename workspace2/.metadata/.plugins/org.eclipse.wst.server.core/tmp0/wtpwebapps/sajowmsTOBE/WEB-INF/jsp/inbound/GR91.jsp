<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var headrow = -1 , chownrky = "" , num = 0;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR91",
			menuId : "GR91"
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["RSNCOD" , "LOTA05" , "LOTA06"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
		$("#OWNRKY").val("<%=ownrky%>");
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			chownrky = "";
			var param = inputList.setRangeDataParam("searchArea");

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}

	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if( comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put('OWNRKY', $('#OWNRKY').val());
			param.put('DOCCAT', '100');
			param.put('DOCUTY', '131');
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Barprint"){ 
			
			if($.trim($('#selsku').val())==""){
				alert("선택된 데이터가 없습니다."); // >>> 메세지 박스로 변경				
				return;
			}
			
			var rowlist = gridList.getSelectRowNumList("gridHeadList");
			var rowNum = rowlist[0];
			var data = gridList.getRowData("gridHeadList", rowNum);
			var option = "height=280,width=1280,resizable=yes";
			
			page.linkPopOpen("/wms/label/LB01.page", data, option);
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR91");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR91");
 		}

	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }

	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		if(searchCode == "SHWAHMA"){
			param.put("COMPKY",'SAJO');
		}else if(searchCode == "SHDOCTM" ){/* && $inputObj.name == "CF.CARNUM" */
	        param.put("DOCCAT","100");	
        }else if(searchCode == "SHSKUMA"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHBZPTN"){
    		param.put("CMCDKY","WAREKY");
        	param.put("PTNRTY","0002");
        }return param;
    
		
	}
	
	function print(){
		
		var where = "";
		
		where += " AND RH.OWNRKY = '" +$("#OWNRKY").val()+ "'";
		where += getMultiRangeDataSQLEzgen("RH.WAREKY", "RH.WAREKY");
		
		var option = getMultiRangeDataSQLEzgen("RH.DOCDAT", "RH.DOCDAT");
		
		if(option == ""){
			alert("입고일자를 조회하시기 바랍니다.");
			return;
		}
		
		
		var	url = "/ezgen/recdi_detail_list.ezg";
		var	width = 855;
		var	height = 620;

		
		var langKy = "KO";
		var map = new DataMap();
			map.put("i_option",option);
		WriteEZgenElement(url , where , "" , langKy, map , width , height );
	}
	
	
	//rowCheck 클릭시 이벤트 
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridHeadList"){
			if(checkType){
				$('#selsku').val(gridList.getColData(gridId, rowNum, "SKUKEY"));
				$('#selcnt').val(gridList.getColData(gridId, rowNum, "QTYRCV"));
			}else{
				$('#selsku').val("");
				$('#selcnt').val("");
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print PRINT_OUT BTN_RCVPRINT" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
							<input type="text" id="WAREKY"  name="RH.WAREKY" UIInput="SR,SHWAHMA" value="<%=wareky%>" />
						</dd>
					</dl>
					<dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.RCPTTY" UIInput="SR,SHDOCTM"/> 
						</dd> 
					</dl> 
					<dl>  <!--입고일자-->  
						<dt CL="STD_ARCPTD"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--전산확정일자-->  
						<dt CL="STD_WLOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!--ASN 문서번호-->  
						<dt CL="STD_ASNDKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.REFDKY" UIInput="SR,SHASN"/> 
						</dd> 
					</dl> 
					<dl>  <!--입고문서번호-->  
						<dt CL="STD_RECVKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.RECVKY" UIInput="SR,SHRECDH"/>
						</dd> 
					</dl> 
					<dl>  <!--구매오더 No-->  
						<dt CL="STD_SEBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SEBELN" UIInput="SR,SHPO103"/>
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
					<dl>  <!--업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업자-->  
						<dt CL="STD_CUSRNM"></dt> 
						<dd> 
							<input type="text" class="input" name="CU.NMLAST" UIInput="SR"/> 
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						<span CL="STD_SELSKU" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="text" id="selsku" name="selsku" UIInput="I" class="input"/> <!--제품코드 SKUKEY-->  
						<input type="text" id="selcnt" name="selcnt" UIInput="I" class="input"/> <!--P/O수량 POIQTY--> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 바코드 출력 -->
						<input type="button" CB="Barprint PRINT_OUT STD_BARPRINT" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="STD_BARCODEINFO" style="PADDING-LEFT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					</li>
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
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td> 
			    						<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td>	<!--입고유형명-->
			    						<td GH="120 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td>	<!--문서상태명-->
			    						<td GH="120 STD_CONDAT" GCol="text,DOCDAT" GF="D 8">확정일자</td>	<!--확정일자-->
			    						<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="120 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 100">업체명</td>	<!--업체명-->
			    						<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 기사명" GCol="text,USRID1" GF="S 20">기사명</td>	<!--기사명-->
			    						<td GH="120 휴대폰번호" GCol="text,UNAME1" GF="S 20">휴대폰번호</td>	<!--휴대폰번호-->
			    						<td GH="120 차량번호" GCol="text,DEPTID1" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="120 요구사업장" GCol="text,DNAME1" GF="S 20">요구사업장</td>	<!--요구사업장-->
			    						<td GH="120 출발일자" GCol="text,USRID2" GF="D 20">출발일자</td>	<!--출발일자-->
			    						<td GH="120 출발시간" GCol="text,UNAME2" GF="T 20">출발시간</td>	<!--출발시간-->
			    						<td GH="120 STD_ADEPTID4" GCol="text,DEPTID4" GF="S 50">선입고정보</td>	<!--선입고정보-->
			    						<td GH="120 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="120 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="120 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="120 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="120 STD_PBOXQTY" GCol="text,PBOXQTY" GF="N 17,1">P박스수량</td>	<!--P박스수량-->
			    						<td GH="120 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_RECRSNCD" GCol="select,RSNCOD">	<!-- 조정사유 코드 --> 
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
			    								<option value="" seleted></option>
			    							</select>
			    						</td>
			    						<td GH="120 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="120 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td>	<!--벤더명-->
			    						<td GH="130 STD_LOTA05" GCol="select,LOTA05">
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td> <!--포장구분-->
										<td GH="130 STD_LOTA06" GCol="select,LOTA06">
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td>	<!--재고유형-->
			    						<td GH="120 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자 -->
			    						<td GH="120 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="120 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 20">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="120 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="120 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="120 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="120 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="120 STD_WMSCREDAT" GCol="text,WLMODAT" GF="S 100">WMS생성일자</td>	<!--WMS생성일자-->
			    						<td GH="120 STD_WMSCRETIM" GCol="text,WLMOTIM" GF="S 100">WMS생성시간</td>	<!--WMS생성시간-->
			    						<td GH="120 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="120 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td>	<!--수정자명-->
			    						<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="120 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="120 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="120 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
			    						<td GH="120 STD_RECNUM" GCol="text,EDOCKY" GF="S 100">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="120 배차메모" GCol="text,TEXT02" GF="S 100">배차메모</td>	<!--배차메모-->
			    						<td GH="120 실물입고일자" GCol="text,WDOCDAT" GF="D 14">실물입고일자</td>	<!--실물입고일자-->
			    						<td GH="120 STD_WLOTA12" GCol="text,WLOTA12" GF="D 14">전산확정일자</td>	<!--전산확정일자-->			
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
						<button type='button' GBtn="add"></button>
                     	<button type='button' GBtn="delete"></button>
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