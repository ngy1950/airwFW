<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL52</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'DL52';
	var SHPOKYS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "INVOICE_ISSUE",
			pkcol : "OWNRKY",
			colorType : true,
		    menuId : "DL52"
	    });
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridList", true, ["DRELIN", "PRITYN"]);
		
		
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["SR.CARDAT"].valueChange();


		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridList"){
			//거래명세서 출력 체크 되어있으면 redColor
			if(Number(gridList.getColData("gridList", rowNum, "PRITYN")) != '' ){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 화주선택 후 거점으로 자동선택
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
		}
		return param;
	}
	
	
	//저장성공시 callback
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
	
		
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print1"){ //인쇄(속도개선) -구버전 PRINT3 check = "2";
			check = "1";
			saveData();
		}else if(btnName == "Print2"){ //인쇄(이고출고) -구버전 PRINT4 check = "3";
			check = "2";
			saveData();
		}else if(btnName == "Print3"){ //인쇄(통합전표) -구버전 PRINT5 check = "5";
			check = "3";
			saveData();
		}else if(btnName == "Print4"){ //인쇄(운반비) -구버전 PRINT9 check = "9";
			check = "4";
			saveData();  
		}else if(btnName == "Print5"){ //인쇄(납품처) -구버전 PRINT10 check = "10";
			check = "5";
			saveData();
		}else if(btnName == "Print6"){ //피킹리스트 인쇄 -구버전 PRINT11
			check = "6";
			saveData();
			
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DL52");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DL52");
 		}
	}


	function saveData(){
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/OutBoundReport/json/saveDL52.data",
				param : param,
				successFunction : "returnSAVE"
			});
		}
	}
	
	function returnSAVE(){
	//프린트
	 	if(check == "1"){ /*인쇄(속도개선) */
	 		
	 		if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				//체크가 없을 경우 
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + list[i].get("SHPOKY") + "'";
				}
				where1 += ")";
						
				var where2 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (SH.SHPOKY||NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + list[i].get("KEY") + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
					map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list4.ezg" , where , " " , langKy, map , width , heigth );
				
				searchList();
	 		}
	 	
	 	} else if(check == "2"){ /* 인쇄(이고출고)*/
	 	
			if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + list[i].get("SHPOKY") + "'";
				}
				where1 += ")";
						
				var where2 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + list[i].get("KEY").substr(10) + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list3_2.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
			}
			
	 	} else if(check == "3"){ /* 인쇄(통합전표) */ //사용하지 않는 컬럼존재 - 오류남 
	 	
			if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + list[i].get("SHPOKY") + "'";
				}
				where1 += ")";
						
				var where2 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + list[i].get("KEY").substr(10) + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;		
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list5_2.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
			}
	 
	 	} else if(check == "4"){ /* 인쇄(운반비) */
	 	
			if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + list[i].get("SHPOKY") + "'";
				}
				where1 += ") ";
						
				var where2 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + list[i].get("KEY").substr(10) + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list4_tcost.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
			}
	 	} else if(check == "5"){ /* 인쇄(납품처) */
	 	
			if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + list[i].get("SHPOKY") + "'";
				}
				where1 += ") ";
						
				var where2 = "";
				for(var i =0;i < list.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + list[i].get("KEY").substr(10) + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list7.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
			}
	 	
	 	} else if(check == "6"){ //피킹리스트 인쇄  
	 	
			if(gridList.validationCheck("gridList", "select")){
				var list = gridList.getSelectData("gridList", true);
				if(list.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var ownrky = $("#OWNRKY").val();
				var wareky = $("#WAREKY").val();
				
				var where = "";
				//반복문을 돌리며 특정 검색조건을 생성한다.
				for(var i =0;i < list.length ; i++){
					
					if(where == ""){
						where = where+" AND SH.SHPOKY IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + list[i].get("SHPOKY") + "'";
				
				}
				where += ")";
						
				var orderby = " ORDER BY LOCASR";
									
				var langKy = "KO";
				var map = new DataMap();
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				if(ownrky == "2100" || ownrky == "2500"){
					if(wareky == "2114" || wareky == "2254"){
						WriteEZgenElement("/ezgen/order_picking_list_urgent_inchun_dl32.ezg" , where , orderby , langKy, map , width , heigth );
					}else{
						WriteEZgenElement("/ezgen/order_picking_list_urgent.ezg" , where , orderby , langKy, map , width , heigth );
					}
				}else{
					//대림 피킹리스트
					WriteEZgenElement("/ezgen/order_picking_list_urgent.ezg" , where , orderby , langKy, map , width , heigth );
				}
				searchList();
			}
 		}
	 }
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //출고유형
        if(searchCode == "SHDOCTM" && $inputObj.name == "SH.SHPMTY"){
            param.put("DOCCAT","200");
        //매출처코드 
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
        	param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0007");  
		//납품처코드 
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.SHPMTY"){
        	param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0001");  
        //제품코드
        }else if(searchCode == "SHSKUMA" && $inputObj.name == "SI.SKUKEY"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //차량번호
        }else if(searchCode == "SHCARMA2" && $inputObj.name == "SR.CARNUM"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //하차조건
   		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SR.DCNDTN"){
        	param.put("CMCDKY","DCNDTN");
	    }
    	return param;
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
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Print1 PRINT_OUT BTN_SPDPRT" /> <!-- 인쇄(속도개선)-->
					<input type="button" CB="Print2 PRINT_OUT BTN_YIGOSHIP" /> <!-- 인쇄(이고출고)-->
					<input type="button" CB="Print3 PRINT_OUT BTN_INTEPRT" /> <!-- 인쇄(통합전표)-->
					<input type="button" CB="Print4 PRINT_OUT BTN_DRVPRT" /> <!-- 인쇄(운반비)-->
					<input type="button" CB="Print5 PRINT_OUT BTN_DELIPRT" /> <!-- 인쇄(납품처)-->
					<input type="button" CB="Print6 PRINT_OUT BTN_PKPRINT" /> <!-- 피킹리스트 인쇄-->
				</div>
			</div>
			<div class="search_inner">
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
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARDAT"></dt> <!-- 배송일자 -->
						<dd>
						    <input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHIPSQ"></dt> <!-- 배송차수 -->
						<dd>
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPMTY"></dt> <!-- 출고유형 -->
						<dd>
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTM"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt> <!-- 출고문서번호 -->
						<dd>
							<input type="text" class="input" name="SI.SHPOKY" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_DOCDAT"></dt> <!-- 문서일자 -->
						<dd>
						    <input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STATDO"></dt> <!-- 문서상태 -->
						<dd>
							<input type="text" class="input" name="SH.STATDO" UIInput="SR,SHVSTATDO"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_PTNROD"></dt> <!-- 매출처코드 -->
						<dd>
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_PTNRODNM"></dt> <!-- 매출처명 -->
						<dd>
							<input type="text" class="input" name="BP.NAME01" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_PTNRTO"></dt> <!-- 납품처코드 -->
						<dd>
							<input type="text" class="input" name="PTRCVR" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_PTNRTONM"></dt> <!-- 납품처명 -->
						<dd>
							<input type="text" class="input" name="BT.NAME01" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl>										
					<dl>
						<dt CL="STD_DOCSEQ"></dt> <!-- 거래명세표출력번호 -->
						<dd>
							<input type="text" class="input" name="SR.DOCSEQ" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_CARNUM"></dt> <!-- 차량번호 -->
						<dd>
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR,SHCARMA2"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_RECNUM"></dt> <!-- 재배차 차량번호 -->
						<dd>
							<input type="text" class="input" name="SR.RECNUM" UIInput="SR,SHCARMA2"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_CARNBR"></dt> <!-- 배차번호 -->
						<dd>
							<input type="text" class="input" name="SR.CARNBR" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_DCNDTN"></dt> <!-- 하차조건 -->
						<dd>
							<input type="text" class="input" name="SR.DCNDTN" UIInput="SR,SHCMCDV"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="SI.SVBELN" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="IFT_SOBELN"></dt> <!-- S/O 번호 --> 
						<dd>
							<input type="text" class="input" name="SUBSTR(SI.SVBELN,1,13)" UIInput="SR"/> <!-- SUBSTR(SI.SVBELN,1,13) -->
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
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
					<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>  
										<td GH="40" GCol="rowCheck"></td> 
			    						<td GH="100 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_RECNUM" GCol="text,RECNUM" GF="S 20">재배차차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
			    						<td GH="120 STD_DOCSEQ" GCol="text,DOCSEQ" GF="S 12">거래명세표출력번호</td>	<!--거래명세표출력번호-->
			    						<td GH="80 STD_CARINFO2" GCol="text,RECNUM2" GF="S 20">재배차차량정보</td>	<!--재배차차량정보-->
			    						<td GH="80 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_ALCCFM" GCol="check,DRELIN">주문수량전송여부</td>	<!--주문수량전송여부--> 
			    						<td GH="80 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="80 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="80 STD_DEDAT" GCol="text,OPURKY" GF="D 8">도착일자</td>	<!--도착일자-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="70 IFT_PTNROD" GCol="text,DPTNKY" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,DPTNKYNM" GF="S 30">매출처명</td>	<!--매출처명-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 30">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_SOBELN" GCol="text,SOBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_STKNUM" GCol="text,STKNUM" GF="S 20">토탈계획번호</td>	<!--토탈계획번호-->
			    						<td GH="80 STD_PGRC01" GCol="text,PGRC01" GF="S 20">권역</td>	<!--권역-->
			    						<td GH="80 STD_PGRC03" GCol="text,PGRC03" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 20">주문부서</td>	<!--주문부서-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td>	<!--수정자명-->
			    						<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 20">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 STD_DNAME4" GCol="text,DNAME4" GF="S 20">영업사원연락처</td>	<!--영업사원연락처-->
			    						<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 200">배송지주소</td>	<!--배송지주소-->
			    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 20">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 20">배송지전화번호</td>	<!--배송지전화번호-->
			    						<td GH="80 STD_PRITYN" GCol="check,PRITYN">출고명세서출력상태</td>	<!--출고명세서출력상태-->
			    						<td GH="80 STD_NAME01" GCol="text,NAME01" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 STD_DCNDTN" GCol="text,DCNDTN" GF="S 180">하차조건</td>	<!--하차조건-->
			    						<td GH="80 STD_CARNBR" GCol="text,CARNBR" GF="S 180">배차번호</td>	<!--배차번호-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
<!-- 						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button> -->
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