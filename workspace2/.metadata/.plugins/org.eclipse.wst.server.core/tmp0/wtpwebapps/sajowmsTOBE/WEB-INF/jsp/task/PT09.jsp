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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "PT09",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "TASKKY",
			menuId : "PT09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "SajoInbound",
			command : "PT09_ITEM",
			tempHead : "gridHeadList",
			useTemp : true,
// 			totalView : true,
			tempKey : "TASKKY",
			menuId : "PT09"
	    });
		
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력 
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "310");
		var rangeDataMap2 = new DataMap();
		// 필수값 입력 
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "311");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
		rangeArr.push(rangeDataMap2);
		setSingleRangeData('TASDH.TASOTY', rangeArr);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			afsaveSearch = false;
			subsavekey ="SELECT ' ' AS ROWSEQ,' ' AS ROWCK,' ' AS TASKKY,' ' AS TASKIT,0 AS QTCOMP,' ' AS LOCAAC,' ' AS SECTAC,' ' AS PAIDAC,' ' AS TRNUAC,' ' AS RSNCOD,' ' AS TASRSN,' ' AS ATRUTY FROM DUAL ";
			rangeparam = inputList.setRangeDataParam("searchArea");
			rangeparam.put("SUBSAVEKEY",subsavekey);
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			rangeparam.putAll(param);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : rangeparam
		    });
		}
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "PRINT"){
			print();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "PT09");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "PT09");
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
	 
    function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();

		if(searchCode == "SHVPTASO_I"){
			param.put("WAREKY",$("#WAREKY").val());
			param.put("TASKTY","PT");
		}else if(searchCode == "SHSKUMA"){
			param.put("NOBIND","N");
			param.put("WAREKY",$("#WAREKY").val());
			param.put("OWNRKY",$("#OWNRKY").val());
		}else if(searchCode == "SHVRECDH2"){
			param.put("NOBIND","N");
			param.put("WAREKY",$("#WAREKY").val());
		}else if(searchCode == "SHLOCMA"){
			param.put("WAREKY",$("#WAREKY").val());
		}

		return param;
	}
    
    function print(){
		var head = gridList.getSelectData("gridHeadList", true);
		var count = 0;
		//체크가 없을 경우 
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var where = "";
		//반복문을 돌리며 특정 검색조건을 생성한다.
		for(var i =0;i < head.length ; i++){
			if(where == ""){
				where = where+" AND H.TASKKY IN (";
			}else{
				where = where+",";
			}
			
			where += "'" + head[i].get("TASKKY") + "'";
			count++;
		}
		where += ")";
					
		//이지젠 호출부(신버전)
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
		WriteEZgenElement("/ezgen/putaway_list.ezg" , where , " " , "KO", map , width , heigth );
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
					<input type="button" CB="PRINT PRINT_OUT BTN_PAPRINT" /> 
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASOTY"" UIInput="SR" readonly="readonly"/>
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASKKY"" UIInput="SR,SHVPTASO_I"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.STATDO" UIInput="SR" /> 
						</dd> 
					</dl> 
					<dl>  <!--입고문서번호-->  
						<dt CL="STD_RECVKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.RECVKY" UIInput="SR,SHVRECDH2"/> 
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_TASKKY" GCol="text,TASKKY" GF="S 20">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="120 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="120 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 90">문서유형명</td>	<!--문서유형명-->
			    						<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="120 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="120 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->
			    						<td GH="120 STD_TASSTX" GCol="text,ADJDSC" GF="S 90">작업타입설명</td>	<!--작업타입설명-->
			    						<td GH="120 STD_DOCTXT" GCol="text,DOCTXT" GF="S 200">비고</td>	<!--비고-->
			    						<td GH="120 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
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
			    						<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_TASKIT" GCol="text,TASKIT" GF="S 10">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="120 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
			    						
			    						<td GH="120 STD_RSNCOD"  GCol="select,RSNCOD"> <!--출고반품입고사유-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option value=" "></option>
											</select>
										</td>
			    						<td GH="120 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="120 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="120 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량--> 
			    						<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="120 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="120 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="120 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="120 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="120 STD_LOCAAC" GCol="input,LOCAAC,SHLOCMA" validate="required">실로케이션</td>	<!--실로케이션--> 
			    						<td GH="120 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="120 STD_ASNDIT" GCol="text,ASNDIT" GF="S 6">ASN It.</td>	<!--ASN It.-->
			    						<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td>	<!--중분류-->
			    						<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td>	<!--소분류-->
			    						<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td>	<!--세분류-->
			    						<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!--포장가로-->
			    						<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">포장세로</td>	<!--포장세로-->
			    						<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!--포장높이-->
			    						<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!--CBM-->
			    						<td GH="120 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td>	<!--CAPA-->
			    						<td GH="120 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="120 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="120 STD_LOTA05" GCol="select,LOTA05">
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td><!--포장구분-->
										<td GH="120 STD_LOTA06" GCol="select,LOTA06">
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td>	<!--재고유형-->
			    						<td GH="120 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="120 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="120 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="120 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="120 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="120 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량--> 
			    						<td GH="120 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,3">순중량</td>	<!--순중량-->
			    						<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,3">포장중량</td>	<!--포장중량-->							
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total" id="total"></button>
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