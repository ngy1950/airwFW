<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL41</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundReport",
	    	pkcol : "TASKKY",
			command : "DL41_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DL41"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundReport",
	    	pkcol : "TASKKY",
			command : "DL41_ITEM",
		    menuId : "DL41"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		gridList.setReadOnly("gridItemList", true, ["RSNCOD"]);
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "FPC");
		rangeArr.push(rangeDataMap); 
		
		setSingleRangeData('TH.STATDO', rangeArr); 
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "210");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "208");
		rangeArr.push(rangeDataMap);
		
		setSingleRangeData('TH.TASOTY', rangeArr); 


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
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			
			//라디오 버튼 값
			if ($('#GRPRL1').prop("checked") == true ) {
				param.put("GRPRL","ERPSO");
			}else if ($('#GRPRL3').prop("checked") == true ){
				param.put("GRPRL","MOVE");
			}else if ($('#GRPRL4').prop("checked") == true ){
				param.put("GRPRL","RTNPUR");
			};

			/* netUtil.send({
				url : "/OutBoundReport/json/displayDL41.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			}); */
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
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("docuty", "210");
			param.put("OWNRKY", "<%=ownrky%>");
		}
		return param;
	}
		
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "PRINT_OUT"){
			printOut();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL41");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL41");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//ezgen 구현
	function printOut(){
		var wherestr = " AND H.TASKKY IN (";

		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			//구버전 FOR문으로 TASKKY 불러오는 부분 구현 아래는 구버전 소스 
//			var wherestr = " AND H.TASKKY IN (";
//			for(var i=1; i<=tasdh.RowCount; i++){
//				if((tasdh.GetCellValue(i,1) == "V" || tasdh.GetCellValue(i,1) == "1")){
//					if(wherestr.length > 18) wherestr += ",";
//					wherestr = wherestr + "'" + tasdh.GetCellValueById(tasdh.GetRowId(i), "taskky") + "'";
//					count++;
//				}
//			}
			var where = "";
			//반복문을 돌리며 특정 검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = where+" AND H.TASKKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("TASKKY") + "'";
			}
			where += ")";
			
			
			
			//아래의 구버전 소스를 신버전 소스로 변경(EZGEN IORDERBY 문자열을 생성한다) 			
			var orderby = " ORDER BY ";
//			if(WiseView.GetControlById("prt_ord_locaky").value == "1")
//				orderby += "LOCASR";
//			else if(WiseView.GetControlById("prt_ord_skukey").value == "1")
//				orderby += "DESC01,LOCASR";
//			else if(WiseView.GetControlById("prt_ord_taskit").value == "1")
//				orderby += "TASKIT";
			
			//신버전 코드 
			//라디오 버튼 값
			if ($('#PRT_ORD_LOCAKY').prop("checked") == true ) {
				orderby += "LOCASR";
			}else if ($('#PRT_ORD_SKUKEY').prop("checked") == true ){
				orderby += "DESC01,LOCASR";
			}else if ($('#PRT_ORD_TASKIT').prop("checked") == true ){
				orderby += "TASKIT";
			};
			
			//이지젠 호출부 (구버전)
//			if("2114" == WiseView.GetControlByID("scWareky").value || "2254" == WiseView.GetControlByID("scWareky").value) {//사통합 수정
//				ezgenPrint("order_picking_list_inchun.ezg", "PICK_LIST", wherestr, orderby, "");
//			}
//			else {
//				ezgenPrint("order_picking_list.ezg", "PICK_LIST", wherestr, orderby, "");
//			}
			
			//이지젠 호출부(신버전)
			var width = 840;
			var heigth = 600;
			var map = new DataMap();
			map.put("i_option",$('#OPTION').val());
			if($('#WAREKY').val() == '2114' || $('#WAREKY').val() == '2254') {
				WriteEZgenElement("/ezgen/order_picking_list_inchun.ezg" , where , orderby , "KO", map , width , "635" ); // 구버전 ezgenPrint와 같다 
			}else{
				WriteEZgenElement("/ezgen/order_picking_list.ezg" , where , orderby , "KO", map , width , heigth );
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

	    //작업타입
		if(searchCode == "SHDOCTM" && $inputObj.name == "TASDH.TASOTY"){
			param.put("DOCCAT","300");
		//동
		} else if(searchCode == "SHAREMA" && $inputObj.name == "S.AREAKY"){
			param.put("WAREKY","<%=wareky %>");
		}
		return param;
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
					<input type="button" CB="PRINT_OUT PRINT_OUT BTN_PKPRINT" />
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_GROUP"></dt><!-- 그룹 -->
						<dd style="width:300px">
							<input type="radio" name="GRPRL" id="GRPRL1" checked /><label for="GRPRL1">영업(D/O)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL3" /><label for="GRPRL3">이고(Move)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL4" /><label for="GRPRL4">매입반품(P/R)</label>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKDT"></dt> <!-- 작업지시일자 -->
						<dd>
							<input type="text" class="input" name="TH.DOCDAT" UIInput="B" UIFormat="C N" />
						</dd>
					</dl>
										<dl>
						<dt CL="STD_CARDAT"></dt> <!-- 배송일자 -->
						<dd>
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHIPSQ"></dt> <!-- 배송차수 -->
						<dd>
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARNUM"></dt> <!-- 차량번호 -->
						<dd>
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASOTY"></dt> <!-- 작업타입 -->
						<dd>
							<input type="text" class="input" name="TH.TASOTY" UIInput="SR,SHDOCTM" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_AREAKY"></dt> <!-- 동 -->
						<dd>
							<input type="text" class="input" name="TI.AREAKY" UIInput="SR,SHAREMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKKY"></dt> <!-- 작업지시번호 -->
						<dd>
							<input type="text" class="input" name="TH.TASKKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STATDO"></dt> <!-- 문서상태 -->
						<dd>
							<input type="text" class="input" name="TH.STATDO" UIInput="SR,SHVSTATDO" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt> <!-- 출고문서번호 -->
						<dd>
							<input type="text" class="input" name="TI.SHPOKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="TI.SVBELN" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STKNUM"></dt> <!-- 토탈계획번호 -->
						<dd>
							<input type="text" class="input" name="TI.STKNUM" UIInput="SR" />
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_PRINTOPT" style="PADDING: 0 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						
						<input type="radio" CL="STD_LOCAORD" name="PRT_ORD" id="PRT_ORD_LOCAKY" checked /><label for="PRT_ORD_LOCAKY" style="margin-right:5px; margin-left:-23px">로케이션순 </label>
		        		<input type="radio" CL="STD_SKUORD" name="PRT_ORD" id="PRT_ORD_SKUKEY" /><label for="PRT_ORD_SKUKEY" style="margin-right:5px; margin-left:-23px">제품명순 </label>
		        		<input type="radio" CL="STD_ITEMORD" name="PRT_ORD" id="PRT_ORD_TASKIT" /><label for="PRT_ORD_TASKIT" style="margin-right:5px; margin-left:-23px">아이템번호순 </label>

					</li>
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
										<td GH="40" GCol="rowCheck" ></td>  
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
								        <td GH="120 STD_TASKKY" GCol="text,TASKKY" GF="S 10,0">작업지시번호</td> <!--작업지시번호-->
								        <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td> <!--작업타입-->
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td> <!--문서유형-->
								        <td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 90">문서유형명</td> <!--문서유형명-->
								        <td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
								        <td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
								        <td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
								        <td GH="80 STD_WARETG" GCol="text,WARETG" GF="S 4">도착거점</td> <!--도착거점-->
								        <td GH="100 STD_TASSTX" GCol="text,ADJDSC" GF="S 90">작업타입설명</td> <!--작업타입설명-->
								        <td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td> <!--문서상태명-->
								        <td GH="120 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10,0">출고문서번호</td> <!--출고문서번호-->
								        <td GH="80 STD_SHPMTY" GCol="text,SHPMTY" GF="S 10">출고유형</td> <!--출고유형-->
								        <td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
								        <td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td> <!--동-->
								        <td GH="120 STD_SHSTATDONM" GCol="text,SHSTATDONM" GF="S 10">출고문서상태명</td> <!--출고문서상태명-->
								        <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td> <!--생성자-->
								        <td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
								        <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td> <!--수정일자-->
								        <td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td> <!--수정시간-->
								        <td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td> <!--수정자-->
								        <td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td> <!--수정자명-->
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
										<td GH="120 STD_TASKKY" GCol="text,TASKKY" GF="S 10,0">작업지시번호</td> <!--작업지시번호-->
							            <td GH="120 STD_TASKIT" GCol="text,TASKIT" GF="S 6,0">작업오더아이템</td> <!--작업오더아이템-->
							            <td GH="80 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td> <!--작업타입-->
							            
							            <td GH="140 STD_RSNCOD" GCol="select,RSNCOD">
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><!--사유코드--></select>
										</td>
							          
							            <td GH="80 STD_TASRSN" GCol="text,TASRSN" GF="S 255">상세사유</td> <!--상세사유-->
							            <td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td> <!--상태-->
							            <td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
							            <td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
							            <td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
							            <td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
							            <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
							            <td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
							            <td GH="120 STD_ACTCDT" GCol="text,ACTCDT" GF="D 8">실제완료날짜</td> <!--실제완료날짜-->
							            <td GH="120 STD_ACTCTI" GCol="text,ACTCTI" GF="T 6">실제완료시간</td> <!--실제완료시간-->
							            <td GH="80 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td> <!--로케이션-->
							            <td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td> <!--단위구성-->
							            <td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td> <!--단위-->
							            <td GH="100 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td> <!--To 로케이션-->
							            <td GH="100 STD_LOCAAC2" GCol="text,LOCAAC" GF="S 20">실지번</td> <!--실지번-->
							            <td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td> <!--참조문서번호-->
							            <td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td> <!--참조문서Item번호-->
							            <td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td> <!--입출고 구분자-->
							            <td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="S 8">참조문서일자</td> <!--참조문서일자-->
							            <td GH="120 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td> <!--출고문서번호-->
							            <td GH="120 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td> <!--출고문서아이템-->
							            <td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위-->
							            <td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td> <!--대분류-->
							            <td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td> <!--포장중량-->
							            <td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td> <!--순중량-->
							            <td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> <!--중량단위-->
							            <td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td> <!--포장가로-->
							            <td GH="80 STD_VRTCAL" GCol="text,WIDTHW" GF="S 11">포장세로</td> <!--포장세로-->
							            <td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td> <!--포장높이-->
							            <td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td> <!--CBM-->
							            <td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td> <!--CAPA-->
							            <td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td> <!--동-->
							            <td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
							            <td GH="120 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td> <!--주문번호(D/O) item-->
							            <td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td> <!--출발지-->
							            <td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td> <!--상태명-->
							            <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
							            <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td> <!--생성시간-->
							            <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td> <!--생성자-->
							            <td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
							            <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td> <!--수정일자-->
							            <td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td> <!--수정시간-->
							            <td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td> <!--수정자-->
							            <td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td> <!--수정자명-->
							            <td GH="80 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td> <!--도착권역-->
							            <td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td> <!--배송일자-->
							            <td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td> <!--차량번호-->
							            <td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td> <!--배송차수-->
							            <td GH="80 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td> <!--배송순서-->
							            <td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td> <!--기사명-->
							            <td GH="80 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td> <!--재배차 여부-->	
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