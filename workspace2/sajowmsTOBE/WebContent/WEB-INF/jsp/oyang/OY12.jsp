<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY11</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangReport",
	    	pkcol : "MANDT, SEQNO",
			command : "OY12_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OY12"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangReport",
	    	pkcol : "MANDT, SEQNO",
			command : "OY12_ITEM",
		    menuId : "OY12"
	    });	
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridHeadList",true,["OWNRKY","DOCUTY","DIRDVY","DIRSUP"])
		gridList.setReadOnly("gridItemList",true,["WAREKY"])
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});


	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			//param.put("OWNRKY",$("#OWNRKY").val());
			
			//라디오 버튼 값
			if ($('#OPTION').val() == 1 ) {
				param.put("OPTYPE","01");
			}else if ($('#OPTION').val() == 2 ){
				param.put("OPTYPE","02");
			}
			
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
			//param.put("OWNRKY",$("#OWNRKY").val());
			

			
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

		return param;
	}

	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "DEL"){
				commonUtil.msgBox("SYSTEM_DELETEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){  //거래명세표 
			
			if($('#OPTION').val() == "1"){//거래명세표(매출처_A4)
				check = "1";
			}else if($('#OPTION').val() == "2"){//거래명세표(납품처_A4)
				check = "2";
			}
		
			saveData(); 
		}else if(btnName == "Print2"){  //거래명세표(해표ASN)
			Print2(); 
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY12");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "OY12");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OyangReport/json/saveOY12.data",
				param : param,
				successFunction : "returnSAVE"
			});
		}
	}
	function returnSAVE(json, status) {
		
		var count = 0;
 
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";  
			
			for(var i =0;i < head.length ; i++){
				if(wherestr == ""){
					wherestr = wherestr+" AND I.SVBELN IN (";
				}else{
					wherestr = wherestr+",";
				}
				
				wherestr += "'" + head[i].get("SVBELN") + "'";
			}
			wherestr += ")";
					
			wherestr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	
			wherestr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	
			wherestr += getMultiRangeDataSQLEzgen('IT.TEXT02', 'I.TEXT02');	
			wherestr += getMultiRangeDataSQLEzgen('IT.OTRQDT', 'I.OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('IT.PTNROD', 'I.PTNROD');	
			wherestr += getMultiRangeDataSQLEzgen('IT.PTNRTO', 'I.PTNRTO');	
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');	
			
			 wherestr += "AND I.WAREKY = '"+$("#WAREKY").val()+"'";
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
				map.put("i_option",$("#WAREKY").val());
			var width = 595;
			var height = 890;
			
			if( check == "1" ){//거래명세표(매출처_A4)
			WriteEZgenElement("/ezgen/shpdri_sale_list_A4_oy.ezg" , wherestr , " " , langKy, map , width , height );
		 	}else if( check == "2" ){ //거래명세표(납품처_A4)
				WriteEZgenElement("/ezgen/shpdri_deli_list_A4_oy.ezg" , wherestr , "" , langKy, map , width , height );
 			}
				
		searchList();
		}
 	}
	
	function Print2(){  /* 거래처/제품 피킹(낱개박스추가) */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0; i < head.length; i++){
				var headMap = head[i].map;
				
 				if(headMap.ASNDKY.trim() == "" || headMap.ASNDKY.trim() == null ){
					commonUtil.msgBox("* ASN번호가 없는 데이터는 거래명세표를 출력할 수 없습니다. *");
					return;
				} 
				if(headMap.ASNCHK.trim() == "" || headMap.ASNCHK.trim() == null || headMap.ASNCHK.trim() == "N" ){
					commonUtil.msgBox("* 뽑으려는 ASN번호 정보 입력 후 거래명세표 출력해주세요. *");
					return;
				}
			}
			
			var wherestr = "";  
			
			for(var i =0;i < head.length ; i++){
				if(wherestr == ""){
					wherestr = wherestr+" AND AH.ASNDKY IN (";
				}else{
					wherestr = wherestr+",";
				}
				
				wherestr += "'" + head[i].get("ASNDKY") + "'";
			}
			wherestr += ")";   


	
			var langKy = "KO";
			var width = 840;
			var heigth = 620;
			var map = new DataMap();

			WriteEZgenElement("/ezgen/purdidoc_list.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
		


	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
		
	  	//주문구분
	    if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
	    //배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");  
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
	    //납품처코드 
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");      
	    
		} return param;
	}	
	
	function gridListEventColBtnClick(gridId, rowNum, colName) {
		var asndky = gridList.getColData(gridId, rowNum, "ASNDKY");
		if(colName == "BTN_ASNINST"){
			if(asndky.trim() == "" || asndky.trim() == null){
				commonUtil.msgBox(" ASN 문서번호가 없습니다. ");		
			} else {
				var data = gridList.getRowData("gridHeadList", rowNum);
				var option = "height=530,width=800,resizable=yes,help=no,status=no";
				page.linkPopOpen("/wms/oyang/pop/OY12_asnList.page", data, option);
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
					<input type="button" CB="Print PRINT_OUT STD_DOCPRT" /> <!-- 거래명세표 print4-->
					<input type="button" CB="Print2 PRINT_OUT STD_DOCPRTASN" /> <!-- 거래명세표(해표ASN) print5-->
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
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--납품요청일-->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV""/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--거래명세표출력번호-->  
						<dt CL="STD_DOCSEQ" style = 'width:120px;'></dt> 
						<dd> 
							<input type="text" class="input" name="IT.TEXT02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문차수-->  
						<dt CL="STD_N00105"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.N00105" UIInput="SR"/> 
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
					<span CL="STD_DOCSEQOP" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
					<select name="OPTION" id="OPTION" class="input" commonCombo="OPTION2" ComboCodeView="true"></select>
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
			    						<td GH="120 STD_DOCSEQ" GCol="text,TEXT02" GF="S 20">거래명세표출력번호</td>	<!--거래명세표출력번호-->
			    						<td GH="150 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
											<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="110 IFT_DOCUTY" GCol="select,DOCUTY">	<!--출고유형-->
    										<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
    									</td>
			    						<td GH="70 STD_VDATU" GCol="text,OTRQDT" GF="D 8">납품요청일</td>	<!--납품요청일-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
			    						<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> <!--주문구분-->
										</td>
			    						<td GH="250 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="90 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="130 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="90 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="130 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_ASNDKY" GCol="text,ASNDKY" GF="S 50">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="100 STD_ASNCHK" GCol="text,ASNCHK" GF="S 50">ASN정보입력여부</td>	<!--ASN정보입력여부-->
			    						<td GH="100 STD_ASNINST" Gcol="btn,BTN_ASNINST" GB="USERCOPY SAVE STD_ASNINST"></td>
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
										<td GH="40" GCol="rowCheck" ></td> 
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="160 IFT_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO">  <!--WMS거점(출고사업장)-->
											<option></option>
											</select>
										</td>
			    						<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="250 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td>	<!--규격-->
			    						<td GH="100 STD_NETWGT" GCol="text,NETWGT" GF="S 200">순중량</td>	<!--순중량-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="70 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
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