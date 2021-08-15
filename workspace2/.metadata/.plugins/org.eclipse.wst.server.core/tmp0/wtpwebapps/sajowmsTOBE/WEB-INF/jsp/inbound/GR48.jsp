<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR48</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "GoodReceipt",
			command : "GR42_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "GR48"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "GoodReceipt",
			command : "GR42_ITEM",
			totalView : true,
			menuId : "GR48"
	    });
		
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridItemList",true,["RSNCOD","LOTA05","LOTA06"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
		
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 인쇄 옵션
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}else if(name == "OPTION"){
				param.put("CMCDKY", "OPTION");	
			}
			
		}else if(comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");			
			return param;
			
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY","<%=ownrky%>");
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "131");
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
	 		sajoUtil.openSaveVariantPop("searchArea", "GR48");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR48");
 		}
	}
		
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}else if(gridId == "gridItemList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
	
	//출고반품명세서 인쇄
	function print(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("list",head);
			
			var json = netUtil.sendData({
				url : "/GoodReceipt/json/printGR42.data",
				param : param,
			});
			
			var ifflg = "Y"; //구버전에 입력되어있으나 이지젠에 주석처리 되어있음!
			
			var where = " AND IF.SVBELN IN (";
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("KEY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
				ifflg = head[i].get("SHPOKYMV");
			}
			
			where += ")";
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 840;
			var height = 600;
				map.put("i_option",$('#OPTION').val());
				map.put("i_ifflg", ifflg);
			WriteEZgenElement("/ezgen/return_shpdri_list.ezg" , where , "" , langKy, map , width , height, ifflg);
			}
		}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

	    //납품처코드
		if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNRTO"){
			param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0007");
		//매출처코드
		} else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNROD"){
			param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0001");
		//제품코드
        }else if(searchCode == "SHSKUMA" && $inputObj.name == "IFWMS113.SKUKEY"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //문서유형
        }else if(searchCode == "SHDOCTM" && $inputObj.name == "IFWMS113.DOCUTY"){
			param.put("DOCCAT","100");
		}
		return param;
		
	}
	
	
	//서치헬프 리턴값 셋팅
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == 'SHSKUMA'){
			$('#DESC01').val(rowData.get('DESC01')); 
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
					<input type="button" CB="Print PRINT_OUT BTN_REPRINT" />
				</div>
			</div>
			<div class="search_inner" id="searchArea"> <!-- GR48  반품입고 조회 -->
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RCPTTY"></dt> <!-- 입고유형 -->
						<dd>
							<input type="text" class="input" id="RCPTTY" name="IFWMS113.DOCUTY" UIInput="SR,SHDOCTM"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.SVBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_OTRQDT2"></dt> <!-- 출고반품입고일자 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.OTRQDT" UIInput="B" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNRTO"></dt> <!-- 납품처코드 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.PTNRTO" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNRTONM"></dt> <!-- 납품처명 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.DPTNKYNM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNROD"></dt> <!-- 매출처코드 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.PTNROD" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNRODNM"></dt> <!-- 매출처명 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.PTNRODNM" id="PTNRODNM" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CUNAME"></dt> <!-- 고객명 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CUADDR"></dt> <!-- 반품지 주소 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.CUADDR" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.DESC01" id="DESC01" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC02"></dt> <!-- 규격 -->
						<dd>
							<input type="text" class="input" name="IFWMS113.DESC02" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PRINTCHK"></dt> <!-- 인쇄여부 -->
						<dd>
							<select name="PRINTCHK" id="PRINTCHK" class="input" commonCombo="POCLOS" >
							</select>
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
					<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
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
								<tbody id="gridHeadList"> <!-- GR48  반품입고 조회 Head --> 
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td>  
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td> <!--입고문서번호-->
										<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td> <!--입고유형-->
										<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
										<td GH="120 STD_CONDAT" GCol="text,DOCDAT" GF="D 8">확정일자</td> <!--확정일자-->
										<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
										<td GH="120 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 10">납품처코드</td> <!--납품처코드-->
										<td GH="120 IFT_PTNRTONM" GCol="text,DPTNKYNM" GF="S 100">납품처명</td> <!--납품처명-->
										<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td> <!--매출처코드-->
										<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 100">매출처명</td> <!--매출처명-->
										<td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 30">S/O 번호</td> <!--S/O 번호-->
										<td GH="120 IFT_CTNAME" GCol="text,UNAME1" GF="S 20">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="120 IFT_WARESR" GCol="text,DNAME1" GF="S 20">요구사업장</td> <!--요구사업장-->
										<td GH="120 IFT_CTTEL1" GCol="text,UNAME2" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
										<td GH="120 IFT_SALENM" GCol="text,UNAME3" GF="S 20">영업사원명</td> <!--영업사원명-->
										<td GH="120 IFT_SALTEL" GCol="text,UNAME4" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
										<td GH="120 IFT_CUADDR" GCol="text,DNAME4" GF="S 20">배송지 주소</td> <!--배송지 주소-->
										<td GH="120 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td> <!--비고-->
										<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
										<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td> <!--입고유형명-->
										<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td> <!--문서유형명-->
<!-- 										<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> 생성일자 -->
<!-- 										<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> 생성시간 -->
<!-- 										<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> 생성자 -->
<!-- 										<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td> 생성자명 -->
										<td GH="120 STD_RCUNAME2" GCol="text,CUNAME" GF="S 100">요구사업장명</td> <!--요구사업장명-->
<!-- 										<td GH="50 STD_CUADDR" GCol="text,CUADDR" GF="S 100">반품지 주소</td> 반품지 주소 -->
										<td GH="120 STD_PRTYN" GCol="text,PRINTCHK" GF="S 100">인쇄여부</td> <!--인쇄여부-->
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
								<tbody id="gridItemList"> <!-- GR48  반품입고 조회 Item -->
									<tr CGRow="true">
										<td GH="40 STD_ROWCK" GCol="rowCheck,radio" ></td>  
										<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td> <!--입고문서아이템-->
										<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="120 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td> <!--로케이션-->
										<td GH="120 STD_TRNUID" GCol="text,TRNUID" GF="S 30">팔렛트ID</td> <!--팔렛트ID-->
										<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td> <!--단위-->
										
										<td GH="120 STD_RECRSNCD"  GCol="select,RSNCOD"> <!--출고반품입고사유-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select>
										</td>										
										
										<td GH="120 STD_LOTA05"  GCol="select,LOTA05"> <!--포장구분-->
											<select class="input" CommonCombo="LOTA05">
											</select>
										</td>
																				
										<td GH="120 STD_LOTA06"  GCol="select,LOTA06"> <!--재고유형-->
											<select class="input" CommonCombo="LOTA06">
											</select>
										</td>
										
										<td GH="120 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td> <!--제조일자-->
										<td GH="120 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
										<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td> <!--참조문서번호-->
										<td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td> <!--참조문서Item번호-->
										<td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td> <!--입출고 구분자-->
										<td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td> <!--참조문서일자-->
										<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td> <!--제품명-->
										<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td> <!--규격-->
										<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위-->
										<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td> <!--세트여부-->
										<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td> <!--피킹그룹-->
										<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td> <!--제품구분-->
										<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td> <!--상온구분-->
										<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td> <!--대분류-->
										<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td> <!--중분류-->
										<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td> <!--소분류-->
										<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td> <!--세분류-->
										<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td> <!--제품용도-->
										<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td> <!--포장중량-->
										<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td> <!--순중량-->
										<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> <!--중량단위-->
										<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td> <!--포장가로-->
										<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td> <!--포장세로-->
										<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td> <!--포장높이-->
										<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td> <!--CBM-->
										<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td> <!--구매오더 No-->
										<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td> <!--구매오더 Item-->
<!-- 										<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> 생성일자 -->
<!-- 										<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> 생성시간 -->
<!-- 										<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> 생성자 -->
<!-- 										<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td> 생성자명 -->
										<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td> <!--입고수량-->
										<td GH="120 STD_ORDQTY" GCol="text,ORDQTY" GF="N 17,0">지시수량</td> <!--지시수량-->
										<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="120 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="120 STD_ORDQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="120 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
 										<td GH="120 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>  <!--유통기한(일수)-->
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