<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR45</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "GoodReceipt",
			command : "GR45_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "GR45"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "GoodReceipt",
			command : "GR45_ITEM",
			totalView : true,
			menuId : "GR45"
	    });
				
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridItemList",true,["LOTA05","LOTA06"])
		//검색조건 입고유형 셀렉트
		inputList.setMultiComboSelectAll($("#RCPTTY"), true);

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
			//조회 시 바코드출력 초기화
			$('#selsku').val("");
			$('#selcnt').val("");
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
	
	//그리드 조회 후 
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
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
			
		}else if(comboAtt == "GoodReceipt,COMBO_RCPTTY"){
			param.put("DOCCAT", "100");
			param.put("PROGID", "GR45");
			return param;
		}
		return param;
	}
	
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	var colchangeArray = ["QTYRCV" , "BOXQTY" , "REMQTY"];
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colchangeArray.indexOf(colName) != -1){
				var qtyrcv = 0;
				var qtduom = 0;
				var boxqty = 0;
				var remqty = 0;
				
				var qtyrcv = Number(gridList.getColData(gridId, rowNum, "QTYRCV"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				var remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				
				var remqtyChk = 0;
				if( colName == "QTYRCV" ) {
					qtyrcv = colValue;
					qtyrcv = Number(gridList.getColData(gridId, rowNum, "QTYRCV"));
					qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
					boxqty = floatingFloor((Number)(qtyrcv)/(Number)(qtduom), 1);
					remqty = (Number)(qtyrcv)%(Number)(qtduom);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty  );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty  );
				}
			}
		}
	}
	
	//rowCheck 클릭시 이벤트 
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(checkType){
			$('#selsku').val(gridList.getColData(gridId, rowNum, "SKUKEY"));
			$('#selcnt').val(gridList.getColData(gridId, rowNum, "QTYRCV"));
		}else{
			$('#selsku').val("");
			$('#selcnt').val("");
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
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			savaDate();
		}else if(btnName == "Rcvprint"){
			Rcvprint();
			
		}else if(btnName == "Barprint"){
			
			if($.trim($('#selsku').val())==""){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var rowlist = gridList.getSelectRowNumList("gridItemList");
			var rowNum = rowlist[0];
			var data = gridList.getRowData("gridItemList", rowNum);
			var option = "height=280,width=1280,resizable=yes";
			
			page.linkPopOpen("/wms/label/LB01.page", data, option);
		
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR45");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR45");
 		}
				   
	}
	
	//ezgen 입고리스트 인쇄
	function Rcvprint(){
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
				
			var where = "";
			//반복문을 돌리며 특정 검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = where+" AND RECVKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("RECVKY") + "'";
			}
			where += ")";
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 840;
			var height = 600;
			WriteEZgenElement("/ezgen/receiving_list.ezg" , where , "" , langKy, map , width , height );
					
		}
	}
	
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		//제품코드
        if(searchCode == "SHSKUMA" && $inputObj.name == "S.SKUKEY"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
		//입고문서번호 
		}else if(searchCode == "SHRECDH" && $inputObj.name == "S.RECVKY"){
	    	param.put("CMCDKY","WAREKY");
	    	//param.put("DOCCAT","100");
	    //업체코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "RH.DPTNKY"){
        	param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0002");
		//벤더
		}else if(searchCode == "SHLOTA03CM" && $inputObj.name == "LOTA03"){
			param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0001");
			return param;
		//제품용도
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
			param.put("CMCDKY","SKUG05");
			
		//ASN문서번호
		}else if(searchCode == "SHASN" && $inputObj.name == "S.REFDKY"){
			param.put("WAREKY","<%=wareky %>");
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
					<input type="button" CB="Rcvprint PRINT_OUT BTN_RCVPRINT" />
				</div>
			</div>
			<div class="search_inner" id="searchArea"> <!-- GR45  회송반품 조회 -->
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY" class="input" validate="required(STD_OWNRKY)" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RCPTTY"></dt><!-- 입고유형 -->
						<dd>
							<select name="RH.RCPTTY" id="RCPTTY" class="input" comboType="MS" Combo="GoodReceipt,COMBO_RCPTTY" validate="required(STD_RCPTTY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ARCPTD"></dt> <!-- 입고일자 -->
						<dd>
							<input type="text" class="input" name="RH.DOCDAT" UIInput="R" UIFormat="C N" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ASNDKY"></dt> <!-- ASN문서번호 -->
						<dd>
							<input type="text" class="input" name="S.REFDKY" id="ASNDKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RECVKY"></dt> <!-- 입고문서번호 -->
						<dd>
							<input type="text" class="input" name="S.RECVKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELN"></dt><!-- 구매오더 no -->
						<dd>
							<input type="text" class="input" name="S.SEBELN" UIInput="SR,SHPO103"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt><!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTNRKY"></dt><!-- 엄체코드 -->
						<dd>
							<input type="text" class="input" name="RH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd>
					</dl>
					<dl>
						<dt CL="STD_REFDKY"></dt> <!-- 참조문서번호 -->
						<dd>
							<input type="text" class="input" name="S.REFDKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA13"></dt> <!-- 유통기한 -->
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA12"></dt> <!-- 입고일자 -->
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA03"></dt> <!-- 벤더 -->
						<dd>
							<input type="text" class="input" name="LOTA03" id="LOTA03" UIInput="SR,SHLOTA03CM"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA05"></dt> <!-- 포장구분 -->
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA06"></dt> <!-- 재고유형 -->
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUG05"></dt> <!-- 제품용도 -->
						<dd>
							<input type="text" class="input" name="S.SKUG05" UIInput="SR,SHCMCDV"/>
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList"> <!-- GR45  회송반품 조회 Head --> 
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td>  
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td> <!--입고문서번호-->
										<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td> <!--입고유형-->
										<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
										<td GH="120 STD_CONDAT" GCol="text,DOCDAT" GF="D 8">확정일자</td> <!--확정일자-->
										<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
										<td GH="120 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td> <!--업체코드-->
										<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주 -->
										<td GH="120 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td> <!--ASN 문서번호 -->
										<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td> <!--구매오더 No -->
										<td GH="120 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td> <!--출고문서번호 -->
										<td GH="120 STD_AUSRID1" GCol="text,USRID1" GF="S 20">차량기사명</td> <!--차량기사명-->
										<td GH="120 STD_AUNAME1" GCol="text,UNAME1" GF="S 20">기사전화번호</td> <!--기사전화번호-->
										<td GH="120 STD_ADEPTID1" GCol="text,DEPTID1" GF="S 20">차량번호</td> <!--차량번호-->
										<td GH="120 IFT_WARESR" GCol="text,DNAME1" GF="S 20">요구사업장</td> <!--요구사업장-->
										<td GH="120 STD_AUSRID2" GCol="text,USRID2" GF="D 20">출발일자</td> <!--출발일자-->
										<td GH="120 STD_AUNAME2" GCol="text,UNAME2" GF="T 20">출발시간</td> <!--출발시간-->
										<td GH="120 STD_ADEPTID2" GCol="text,DEPTID2" GF="S 20">업무 부서</td> <!--업무 부서-->
										<td GH="120 STD_ADNAME2" GCol="text,DNAME2" GF="S 20">업무 부서명</td> <!--업무 부서명-->
										<td GH="120 STD_AUSRID3" GCol="text,USRID3" GF="S 20">현장담당자</td> <!--현장담당자-->
										<td GH="120 STD_AUNAME3" GCol="text,UNAME3" GF="S 20">현장담당자명</td> <!--현장담당자명-->
										<td GH="120 STD_ADEPTID3" GCol="text,DEPTID3" GF="S 20">현장담당 부서</td> <!--현장담당 부서-->
										<td GH="120 STD_ADNAME3" GCol="text,DNAME3" GF="S 20">현장담당 부서명</td> <!--현장담당 부서명-->
										<td GH="120 STD_AUSRID4" GCol="text,USRID4" GF="S 20">현장책임</td> <!--현장책임-->
										<td GH="120 STD_AUNAME4" GCol="text,UNAME4" GF="S 20">현장책임명</td> <!--현장책임명-->
										<td GH="120 STD_ADEPTID4" GCol="text,DEPTID4" GF="S 50">선입고정보</td> <!--선입고정보-->
										<td GH="120 STD_ADNAME4" GCol="text,DNAME4" GF="S 20">현장책임 부서명</td> <!--현장책임 부서명-->
										<td GH="120 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td> <!--비고-->
										<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
										<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td> <!--입고유형명-->
										<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td> <!--문서유형명-->
										<td GH="120 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 100">업체명</td> <!--업체명-->
										<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자 -->
										<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> <!--생성시간 -->
										<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자 -->
										<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td> <!--생성자명 -->
										<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 100">참조문서번호</td> <!--참조문서번호 -->
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
					<li><a href="#tab1-1" ><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">  <!-- 구버전에서 바코드 버튼 사용불가 -->
						<span CL="STD_SELSKU" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="text" id="selsku" name="selsku" UIInput="I" class="input" readonly/> <!--제품코드 SKUKEY-->  
						<input type="text" id="selcnt" name="selcnt" UIInput="I" class="input" readonly/> <!--P/O수량 POIQTY--> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 바코드 출력 -->
						<input type="button" CB="Barprint PRINT_OUT STD_BARPRINT" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="STD_BARCODEINFO" style="PADDING-LEFT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList"> <!-- GR45  회송반품 조회 Item --> 
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td> 
										<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td> <!--입고문서아이템-->
										<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="120 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td> <!--로케이션-->
<!-- 										<td GH="100 STD_TRNUID" GCol="text,TRNUID" GF="S 30">팔렛트ID</td> 팔렛트ID -->
										<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td> <!--단위-->
										<td GH="120 STD_RECRSNCD" GCol="text,RSNCOD" GF="S 4">출고반품입고사유</td> <!--출고반품입고사유-->
										
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
										<td GH="120 STD_PBOXQTY" GCol="input,PBOXQTY" GF="N 17,1">P박스수량</td><!-- P박스수량 -->
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
										<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> <!--중량단위-->
										<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td> <!--포장가로-->
										<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td> <!--포장세로-->
										<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td> <!--포장높이-->
										<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td> <!--CBM-->
										<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td> <!--포장중량-->
										<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td> <!--순중량-->
										<td GH="120 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td> <!-- Client -->
										<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td> <!--구매오더 No-->
										<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td> <!--구매오더 Item-->
										<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td> <!--입고수량-->
										<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="120 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="120 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
										<td GH="120 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td> <!--유통잔여(DAY)-->	
										<td GH="120 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td> <!--유통잔여(DAY)-->	
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