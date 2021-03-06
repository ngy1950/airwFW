<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR09</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Daerim",
			command : "DR09_HEAD", 
			pkcol : "MANDT, SEQNO",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DR09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Daerim",
			command : "DR09_ITEM" ,
		    menuId : "DR09"
	    });
		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "DOCUTY", "DIRDVY", "DIRSUP", "PTNG08"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>")
			
			if($('#CHKMAK').prop("checked") == false){
				param.put("CHKMAK","");
			}else if($('#CHKMAK').prop("checked") == true){
				param.put("CHKMAK","1");
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
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
	        param.put("DOCCAT", "300");
	        param.put("DOCUTY", "399");
	        param.put("DIFLOC", "1");
	        param.put("OWNRKY", $("#OWNRKY").val());
			}
		return param;
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		} else if(btnName == "rowcheck"){
			rowcheck();
		} else if (btnName == "Print") {		/* 거래명세표 */
			
			if($('#CHKMAK').prop("checked") == false){
				$('#CHKMAK').val("")
			}else if($('#CHKMAK').prop("checked") == true){
				$('#CHKMAK').val("1")
			}
			
			var option = $('#OPTION').val();
			var chkmak = $('#CHKMAK').val();
			
			if(option == "1"){//거래명세표(매출처_A4)
				if(chkmak == "1"){
					commonUtil.msgBox("A4용지는 상온,냉장/냉동 구분을 할 수 없습니다");
					return;
				}
				check = "4";
			}else if(option == "2"){//거래명세표(매출처_3P)
				if(chkmak == "1"){
					check = "10";
				}else{
					check = "5";
				}
			}else if(option == "3"){//거래명세표(납품처_A4)
				if(chkmak == "1"){
					commonUtil.msgBox("* A4용지는 상온,냉장/냉동 구분을 할 수 없습니다 *");
					return;
				}
				check = "6";
			}else if(option == "4"){//거래명세표(납품처_3P)
				if(chkmak == "1"){
					check = "11";
				}else{
					check = "7";
				}
			}	
			
			saveData();
		}else if (btnName == "Print2") {	/* 뉴코아 */
			check = "8";	
			saveData();
		}else if (btnName == "Print3") {	/* 거래명세표(온라인몰A4)  */
			check = "12";
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR09");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR09");
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
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/Daerim/json/saveDR09.data",
				param : param,
				successFunction : "returnSAVE"
			});
		}
	}
	
	function returnSAVE(){
		var count = 0;
		var ownrky = $('#OWNRKY').val();
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var wherestr2 = "";
			
			
			for(var i =0;i < head.length ; i++){
				if(wherestr == ""){
					wherestr += "AND I.OWNRKY = '"+ownrky+"'";
					wherestr = wherestr+"AND I.SVBELN IN (";
				}else{
					wherestr = wherestr+",";
				}
				
				wherestr += "'" + head[i].get("SVBELN") + "'";
			}
			wherestr += ")";
					
			
					
			wherestr2 += getMultiRangeDataSQLEzgen('B2.NAME03', 'B2.NAME03');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.TEXT02', 'I.TEXT02');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.ORDDAT', 'I.ORDDAT');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.OTRQDT', 'I.OTRQDT');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.PTNROD', 'I.PTNROD');	
			wherestr2 += getMultiRangeDataSQLEzgen('IT.PTNRTO', 'I.PTNRTO');	
			wherestr2 += getMultiRangeDataSQLEzgen('B2.PTNG08', 'B2.PTNG08');	
			wherestr2 += getMultiRangeDataSQLEzgen('B.PTNG01', 'B.PTNG01');	
			wherestr2 += getMultiRangeDataSQLEzgen('B.PTNG02', 'B.PTNG02');	
			wherestr2 += getMultiRangeDataSQLEzgen('B.PTNG03', 'B.PTNG03');	
			wherestr2 += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');	
			wherestr2 += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PK.PICGRP');	
					
			var langKy = "KO";
			var width = 595;
			var heigth = 880;
			var map = new DataMap();
				map.put("i_option","'"+"<%=wareky %>"+"'");
				map.put("i_orderby",wherestr2);
				
			if( check == "4" ){ //거래명세표(매출처_A4)
				WriteEZgenElement("/ezgen/shpdri_sale_list_A4.ezg" , wherestr , " " , langKy, map , width , heigth );
			}else if( check == "5" ){ //거래명세표(매출처_3P)
				WriteEZgenElement("/ezgen/shpdri_sale_list_3P.ezg" , wherestr , " " , langKy, map , width , heigth );	
			}else if( check == "6" ){ //거래명세표(납품처_A4)
				WriteEZgenElement("/ezgen/shpdri_deli_list_A4.ezg" , wherestr , " " , langKy, map , width , heigth );
			}else if( check == "7" ){ //거래명세표(납품처_3P)
				WriteEZgenElement("/ezgen/shpdri_deli_list_3P.ezg" , wherestr , " " , langKy, map , width , heigth );	
			}else if( check == "8" ){ //뉴코아 
				WriteEZgenElement("/ezgen/newcore_list2_change.ezg" , wherestr , " " , langKy, map , 840 , 600 );	
			}else if( check == "10" ){ //상온구분 거래명세표(매출처_3P)
				WriteEZgenElement("/ezgen/shpdri_sale_list_3P_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
			}else if( check == "11" ){ //상온구분 거래명세표(납품처_3P)
				WriteEZgenElement("/ezgen/shpdri_deli_list_3P_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
			}else if( check == "12" ){ //거래명세표(온라인몰)
				WriteEZgenElement("/ezgen/shpdri_onlinemall_list_a4.ezg" , wherestr , " " , langKy, map , width , heigth );	
			}
			searchList()
		}
	}
	
	function rowcheck(){
		var from = ($("#rowcheck_from").val());
		var to = ($("#rowcheck_to").val());
		var gridId = "gridHeadList";
		
		var item = gridList.getGridData(gridId);
		if(item.length == 0 && item.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		if($.trim(from) == ""){
			commonUtil.msgBox("시작 번호를 입력해주세요");
			return;
		}else if($.trim(to) == ""){
			commonUtil.msgBox("끝 번호를 입력해주세요");
			return;
		}
		
		for(var i= (Number)(from)-1; i < (Number)(to); i++){
			gridList.setRowCheck(gridId, i, true);	
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

		//출고거점
		if(searchCode == "SHCMCDV" && $inputObj.name == "B2.NAME03"){
	        param.put("CMCDKY","WAREKY");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
	    //차량번호
		}else if(searchCode == "SHCARMA2" && $inputObj.name == "C.CARNUM"){
	        param.put("WAREKY","<%=wareky %>");	
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//유통경로1
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG01"){
	        param.put("CMCDKY","PTNG01");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로2
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG02"){
	        param.put("CMCDKY","PTNG02");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로3
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG03"){
	        param.put("CMCDKY","PTNG03");
	    	param.put("OWNRKY","<%=ownrky %>");	
	    //피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		} return param;
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
					<input type="button" CB="Print PRINT_OUT STD_DOCPRT" />	<!-- 거래명세표 -->
					<input type="button" CB="Print2 PRINT_OUT NEWCORE" />	<!-- 뉴코아 -->
					<input type="button" CB="Print3 PRINT_OUT STD_DOCA4" />	<!-- 거래명세표(온라인몰A4) -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>  <!--냉장/냉동 구분-->  
						<dt CL="STD_DEFSORT"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" />
						</dd> 
					</dl> 
					<dl>  <!--출고거점-->  
						<dt CL="STD_NAME03B"></dt> 
						<dd> 
							<input type="text" class="input" name="B2.NAME03" UIInput="SR,SHCMCDV" value="<%=wareky%>"/>
						</dd> 
					</dl>  
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="STD_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--거래명세표출력번호-->  
						<dt CL="STD_DOCSEQ"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.TEXT02" UIInput="SR"/> 
						</dd> 
					</dl>  
					<dl>  <!--매출처코드-->  
						<dt CL="STD_DPTNKYCD"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNROD" UIInput="SR,SHBZPTN"/>
						</dd> 
					</dl>
					<dl>  <!--납품처코드-->  
						<dt CL="STD_PTRCVRCD"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNRTO" UIInput="SR,SHBZPTN"/>
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_VEHINO"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2" /> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="B2.PTNG08" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG01" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG02" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG03" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_ASKU03"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV" /> 
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
						<select name="OPTION" id="OPTION" class="input" commonCombo="OPTION1" ComboCodeView="true"></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;" id="rowcheck1">                                                                                                           
						<span CL="row선택" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE; font-weight: bold;" ></span>                                                                  
						<input type="text" class="input" id="rowcheck_from" name="rowcheck_from" style="width: 50px;">
						~ 
						<input type="text" class="input" id="rowcheck_to" name="rowcheck_to" style="width: 50px;">	       
					</li>                                                                                                                                                   
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;" id="rowcheck2"> <!-- 부분적용 -->                                                                                             
						<input type="button" CB="rowcheck SAVE BTN_PART" />                                                                                                   
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="130 STD_DOCSEQ" GCol="text,TEXT02" GF="S 20">거래명세표출력번호</td> <!--거래명세표출력번호-->
										<td GH="130 IFT_OWNRKY" GCol="select,OWNRKY">
											<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>	<!--화주-->
										</td> 
										<td GH="120 IFT_DOCUTY" GCol="select,DOCUTY">
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	 <!--출고유형-->
										</td>
										<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
										<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
										<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
										<td GH="100 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
										<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
										<td GH="100 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> <!--매출처명-->
										<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select>	<!--배송구분-->
										</td>
										<td GH="140 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PTNG03"></select>  <!--주문구분-->
										</td>
										<td GH="180 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td> <!--배송지 주소-->
										<td GH="100 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="130 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
										<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td> <!--영업사원명-->
										<td GH="120 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
										<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td> <!--비고-->
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="120 STD_PTNG08" GCol="select,PTNG08">
											<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
										</td> 
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<!-- <button type='button' GBtn="total"></button> -->
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="200 IFT_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>	<!--WMS거점(출고사업장)-->
										</td>
										<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="70 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td> <!--규격-->
										<td GH="60 STD_NETWGT" GCol="text,NETWGT" GF="S 200">순중량</td> <!--순중량-->
										<td GH="60 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
										<td GH="70 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td> <!--요청수량-->
										<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
										<td GH="80 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td> <!--누적주문수량-->
										<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
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