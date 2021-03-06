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
var reparam = new DataMap();
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	itemGrid : "gridItemList",
	    	itemSearch : true,
	    	module : "taskOrder",
			command : "MV09_HEAD",
		    menuId : "MV09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "MV09_ITEM2",
		    menuId : "MV09"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["RSNCOD","LOTA06","LOTA05"]);	
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			reparam = new DataMap();
			
 			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}// end searchList()
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){

		var param = gridList.getRowData(gridId, rowNum);
		
		param.put("OWNRKY",$('#OWNRKY').val());
		param.put("USERID", "<%=userid%>");
		gridList.gridList({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "MV09_ITEM2",
	    	param : param
	    });
	}// end gridListEventItemGridSearch()
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		param.put("OWNRKY", $("#OWNRKY").val());
		
		// 조사타입 및 조정사유코드 공통코드
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			param.put("CMCDKY", "LOTA06");	
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", $("#TASOTY").val());

		}
		return param;
	}// end comboEventDataBindeBefore()
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHLOCMA"){
        	param.put("WAREKY",$("#WAREKY").val());
        // 벤더
        }else if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
            
        }
        
    	return param;
    }
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print1"){
			 printEZGenDR16("/ezgen/move_list.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "MV09");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "MV09");
		}
	}// end commonBtnClick()
	
	function printEZGenDR16(url){
	    	
	    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
			var headList = gridList.getSelectData("gridHeadList");
	    	
			if(headList.length < 1){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
		
			var wherestr = ""; 
			var count = 0;
			var taskky;
			for(var i=0; i<headList.length; i++){
				taskky = gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "TASKKY");
				
				if(taskky == "" || taskky == " "){
					commonUtil.msgBox("재고 이동 지시서 생성후에 출력 가능합니다.");
					return;
				}
				
				if(wherestr == ""){
					wherestr = " AND H.TASKKY IN ("; 
				}else{
					wherestr += ",";
				}
				wherestr += "'"+taskky+"'";
			}
			wherestr+=") ";

			//이지젠 호출부(신버전)
			var width = 840;
			var heigth = 920;
			var map = new DataMap();
			map.put("i_option", '\'<%=wareky %>\'');
			WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다

	}// end printEZGenDR16(url){
	
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
					<input type="button" CB="Print1 PRINT BTN_PRINT17" />
					<!-- <input type="button" CB="Print2 PRINT BTN_PRINT28" /> -->
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
					
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASOTY" UIInput="SR" value="320" readonly="readonly"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<!-- <input type="text" class="input" name="TASDH.TASKKY" UIInput="SR,SHVPTASO"/> --> 
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/>
						</dd> 
					</dl> 
					
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					
<!--				 조회할때 존을 사용하는 테이블이 없음.. 구버전에서도 존 넣고 검색하면 에러 남
					 <dl>  존  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl>  -->
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCASR"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCASR" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--To 로케이션-->  
						<dt CL="STD_LOCATG"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCATG" UIInput="SR,SHLOCMA"/> 
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
					
					<dl>  <!--생성자명-->  
						<dt CL="STD_CUSRNM"></dt> 
						<dd> 
							<input type="text" class="input" name="UM.NMLAST" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--입고일자 -->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--벤더-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고유형-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/> 
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
								        <td GH="120 STD_TASKKY" GCol="text,TASKKY" GF="S 30">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 90">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="200 STD_TASSTX" GCol="text,ADJDSC" GF="S 90">작업타입설명</td>	<!--작업타입설명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 17,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 17,0">완료수량</td>	<!--완료수량-->
			    						<td GH="200 STD_DOCTXT" GCol="text,DOCTXT" GF="S 200">비고</td>	<!--비고-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
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
								<tbody id="gridItemList">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="50 STD_TASKIT" GCol="text,TASKIT" GF="N 6,0">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 17,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 17,0">완료수량</td>	<!--완료수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="200 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="60 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="160 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="80 STD_TRNUTG" GCol="text,TRNUTG" GF="S 20">To 팔렛트ID</td>	<!--To 팔렛트ID-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="80 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="80 STD_LOTA04" GCol="text,LOTA04" GF="S 20">LOTA04</td>	<!--LOTA04-->
			    						<td GH="160 STD_LOTA05" GCol="select,LOTA05">	<!--포장구분-->
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>	
			    						<td GH="130 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>	
			    						</td>	<!--재고유형-->
			    						<td GH="80 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="80 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
			    						<td GH="80 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
			    						<td GH="80 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td>	<!--LOTA14-->
			    						<td GH="80 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td>	<!--LOTA15-->
			    						<td GH="80 STD_LOTA16" GCol="text,LOTA16" GF="S 11">LOTA16</td>	<!--LOTA16-->
			    						<td GH="80 STD_LOTA17" GCol="text,LOTA17" GF="S 11">LOTA17</td>	<!--LOTA17-->
			    						<td GH="80 STD_LOTA18" GCol="text,LOTA18" GF="S 11">LOTA18</td>	<!--LOTA18-->
			    						<td GH="80 STD_LOTA19" GCol="text,LOTA19" GF="S 11">LOTA19</td>	<!--LOTA19-->
			    						<td GH="80 STD_LOTA20" GCol="text,LOTA20" GF="S 11">LOTA20</td>	<!--LOTA20-->
			    						<td GH="130 STD_RSNCOD" GCol="select,RSNCOD">
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
			    						</td>	<!--사유코드-->
			    						<td GH="50 STD_TASRSN" GCol="text,TASRSN" GF="S 50">상세사유</td>	<!--상세사유-->
			    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 17,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 17,0">유통잔여(%)</td>	<!--유통잔여(%)-->
			    						<td GH="88 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="88 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="88 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="88 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="88 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="88 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="88 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="88 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="160 STD_SBKTXT" GCol="text,SBKTXT" GF="S 75">비고</td>	<!--비고-->
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