
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AS09</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "AdvancedShipmentNotice",
			command : "AS09_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "AS09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "AdvancedShipmentNotice",
			command : "AS09_ITEM",
			totalView : true
	    });
		
				
		//날짜 수정 
		inputList.rangeMap["map"]["AI.LRCPTD"].$to.val(dateParser(null, "SD", 0, 0, 0));   //toval
		inputList.rangeMap["map"]["AI.LRCPTD"].$from.val(dateParser(null, "SD", 0, 0, -7)); //fromval
		//ReadOnly 설정(그리드 전체 권한 막기)
		gridList.setReadOnly("gridHeadList",true,["DEPTID2","DNAME1"])
		gridList.setReadOnly("gridItemList",true,["LOTA05","LOTA06"])
		
	});
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Printcont"){  //거래명세표출력	
			printcont(); 
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "AS09");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "AS09");
		
		}else if(btnName == "Barprint"){  //바코드출력
			barprint();
			
// 			var rowlist = gridList.getSelectRowNumList("gridItemList");
// 			var rowNum = rowlist[0];
// 			var data = gridList.getRowData("gridItemList", rowNum);
// 			var option = "height=280,width=1280,resizable=yes";
			
// 			page.linkPopOpen("/wms/label/LB01.page", data, option);
		}
	}
	
	
	function printcont() {
		var ownrky = $('#OWNRKY').val();
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("list",head);
		
			var where = " AND AH.ASNDKY IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("ASNDKY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
			}
			
			where += ")";

			var langKy = "KO";
			var width = 840;
			var height = 600;
			var map = new DataMap();
// 				map.put("i_option",$('#OPTION').val());
			if(ownrky == 'SAJOHP'){
				WriteEZgenElement("/ezgen/purdidoc_list.ezg" , where , "" , langKy, map , width , height );
		 	}else if(ownrky == 'SAJODR'){
				WriteEZgenElement("/ezgen/purdidoc_list_h.ezg" , where , "" , langKy, map , width , height );
			}
		}
	}
	
	function barprint(json, status){
		var ownrky = $('#OWNRKY').val();
		
		if(!validate.check("searchArea")){
			return false;
		}	
		
		var param = inputList.setRangeDataParam("searchArea");
		param.put("REFDKY",json.data["REFDKY"]);
		
		var json = netUtil.sendData({
			url : "/labelPrint/json/printAS09.data",
			param : param,
		});
		
		if(json && json.data){
			
			var where = " AND REFDKY = '" + json.data["REFDKY"] + "'";
			
			var langKy = "KO";
			var width = 1100;
			var height = 620;
			var map = new DataMap();
							
			if(ownrky == 'SAJOHP'){
				WriteEZgenElement("/ezgen/barcodel3.ezg" , where , "" , langKy, map , width , height ); //제조일자 인쇄
				
		 	}else if(ownrky == 'SAJODR'){
				WriteEZgenElement("/ezgen/drbarcodel3.ezg" , where , "" , langKy, map , width , height ); //제조일자 인쇄
			}
		
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
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
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

	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
			}
		}
	}
	 
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 화주선택 후 거점으로 자동선택
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "050");
			param.put("DOCUTY", "051");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	//rowCheck 클릭시 이벤트 
// 	function gridListEventRowCheck(gridId, rowNum, checkType){
// 		if(checkType){
// 			$('#selsku').val(gridList.getColData(gridId, rowNum, "SKUKEY"));
// 			$('#selcnt').val(gridList.getColData(gridId, rowNum, "QTYRCV"));
// 		}else{
// 			$('#selsku').val("");
// 			$('#selcnt').val("");
// 		}
// 	}
	
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		//제품코드
        if(searchCode == "SHSKUMA" && $inputObj.name == "AI.SKUKEY"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
	    //업체코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "AH.DPTNKY"){
        	param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0002");			
		//ASN문서번호
		}else if(searchCode == "SHASN" && $inputObj.name == "AH.ASNDKY"){
			param.put("CMCDKY","WAREKY");
			param.put("OWNRKY","<%=ownrky %>");
		}
		return param;
	}
	
	//서치헬프 리턴값 셋팅 , ASN문서번호 리턴값
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if(searchCode == 'SHASN'){
			$('#ASNDKY').val(rowData.get("ASNDKY")); 
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
	<div class="content_inner" style="padding: 5px 30px 55px;">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Printcont PRINT_OUT STD_PRINTCONT" />
					<input type="button" CB="Barprint PRINT_OUT STD_BARPRINT" />
				</div>
			</div>
			<div class="search_inner"> <!-- AS09  입고예정 정보 조회 --> 
				<div class="search_wrap"> 
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
							<input type="hidden" value="051" name="ASNTTY"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELN"></dt> <!-- 구매오더 No -->
						<dd>
							<input type="text" class="input" name="AI.REFDKY" id="REFDKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ORDDAT"></dt> <!-- 출고일자 -->
						<dd>
							<input type="text" class="input" name="IFW.ORDDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_EINDT"></dt> <!-- 납품요청일 --> 
						<dd>
							<input type="text" class="input" name="AI.LRCPTD" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ASNDKY"></dt> <!-- ASN 문서번호 -->
						<dd>
							<input type="text" class="input" name="AH.ASNDKY" id="ASNDKY" UIInput="SR,SHASN"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ASNDAT"></dt> <!-- ASN 생성일 -->
						<dd>
							<input type="text" class="input" name="AH.DOCDAT" UIInput="R" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STATDO"></dt> <!-- 문서상태 -->
						<dd>
							<input type="text" class="input" name="AH.STATDO" UIInput="SR,SHVSTATDO"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="AI.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="AI.DESC01" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC02"></dt> <!-- 규격 -->
						<dd>
							<input type="text" class="input" name="AI.DESC02" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTNRKY"></dt> <!-- 업체코드 -->
						<dd>
							<input type="text" class="input" name="AH.DPTNKY" UIInput="SR,SHBZPTN"/>
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
<!-- 					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> -->
<!-- 						<span CL="STD_DOCSEQOP" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span> -->
<!-- 						<select name="OPTION" id="OPTION" class="input" commonCombo="OPTION2" ComboCodeView="true"></select> -->
<!-- 					</li> -->
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
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck" ></td>
			    						<td GH="100 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_ASNTTY" GCol="text,ASNTTY" GF="S 4">ASN 타입</td>	<!--ASN 타입-->
			    						<td GH="100 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="100 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="100 STD_DPTNKY" GCol="text,DPTNKY" GF="S 10">업체코드</td>	<!--업체코드-->
			    						<td GH="100 STD_PRCPTD2" GCol="text,PRCPTD" GF="D 8">센터입고일자</td>	<!--센터입고일자-->
			    						
			    						<td GH="80 STD_DEPTIDT" GCol="select,DEPTID2"><!--센터입고시간-->
											<select class="input" Combo="AdvancedShipmentNotice,COMBO_OUTTIM"><option></option></select>
			    						</td>
			    						
			    						<td GH="100 STD_SEBELN" GCol="text,EBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="100 STD_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="100 STD_DRIVER" GCol="text,USRID1" GF="S 20">기사명</td>	<!--기사명-->
			    						<td GH="100 STD_DPHONE" GCol="text,UNAME1" GF="S 20">기사연락처</td>	<!--기사연락처-->
			    						<td GH="100 STD_VEHINO" GCol="text,DEPTID1" GF="S 20">차량번호</td>	<!--차량번호-->
			    						
			    						<td GH="80 STD_ISSHIP" GCol="select,DNAME1"><!--출고여부-->
											<select class="input" commonCombo="OUTBYN"><option></option></select>
			    						</td>
			    						
			    						<td GH="100 STD_WADAT" GCol="text,USRID2" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="100 STD_CRETIM2" GCol="text,UNAME2" GF="T 6">업무 부서명</td>	<!--업무 부서명-->
			    						
<!-- 			    						<td GH="80 STD_DNAME2" GCol="text,DEPTID2" GF="S 20">업무 부서명</td>	업무 부서명 -->
			    						<td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="100 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="100 STD_ASNTTYNM" GCol="text,ASNTTYNM" GF="S 100">ASN 타입명</td>	<!--ASN 타입명-->
			    						<td GH="100 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="100 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 100">업체명</td>	<!--업체명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td>	<!--수정자명-->
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
			    						<td GH="40" GCol="rowCheck" ></td>
			    						<td GH="100 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="100 STD_ASNDIT" GCol="text,ASNDIT" GF="S 6">ASN It.</td>	<!--ASN It.-->
			    						<td GH="100 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="100 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="50 STD_QTPUOM" GCol="text,QTPUOM" GF="N 17,0">Units per measure</td>	<!--Units per measure-->
			    						<td GH="50 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="50 STD_PBOXQTY" GCol="text,PBOXQTY" GF="N 17,1">P박스수량</td>	<!--P박스수량-->
			    						<td GH="50 STD_BUYCOST" GCol="text,BUYCOST" GF="N 17,0">매입단가</td>	<!--매입단가-->
			    						<td GH="50 STD_BUYAMT" GCol="text,BUYAMT" GF="N 17,0">매입금액</td>	<!--매입금액-->
			    						<td GH="50 STD_VATAMT" GCol="text,VATAMT" GF="N 17,0">부가세</td>	<!--부가세-->
			    						<td GH="120 STD_POIQTY" GCol="text,POIQTY" GF="N 17,0">P/O수량</td>	<!--P/O수량-->
			    						<td GH="120 STD_QTYASN" GCol="text,QTYASN" GF="N 17,0">ASN수량</td>	<!--ASN수량-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="50 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 20">LOTA04</td>	<!--LOTA04-->
			    						
			    						<td GH="80 STD_LOTA05" GCol="select,LOTA05"><!--포장구분-->
											<select class="input" commonCombo="LOTA05"><option></option></select>
			    						</td>
			    						
			    						<td GH="80 STD_LOTA06" GCol="select,LOTA06"><!--재고유형-->
											<select class="input" commonCombo="LOTA06"><option></option></select>
			    						</td>
			    						
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_EINDT" GCol="text,LRCPTD" GF="D 8">납품요청일</td>	<!--납품요청일-->
			    						<td GH="50 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="100 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="100 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="80 grswgtcnt" GCol="text,GRSWGTCNT" GF="N 17,0">grswgtcnt</td>	<!--grswgtcnt-->
			    						<td GH="80 netwgtcnt" GCol="text,NETWGTCNT" GF="N 17,0">netwgtcnt</td>	<!--netwgtcnt-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="50 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	<!--Client-->
			    						<td GH="50 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="100 STD_SBKTXT" GCol="text,SBKTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td>	<!--수정자명-->
			    						<td GH="80 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
			    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
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