<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL51</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundReport",
			command : "DL51_HEAD",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true,
		    menuId : "DL51"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundReport",
			command : "DL51_ITEM",
			totalView : true,
		    menuId : "DL51"
	    });
		
		if(<%=ownrky %> == '2100' || <%=ownrky %> == '2500' ) {
			//$('#prt2100').css("display","inline");
			$('#prt2200').hide();
			$('#prt2300').hide();
			$('#prt2200').click(function(){
				commonUtil.msgBox("* 로그인 화주 2200에서 프린트 가능합니다 *");
			})
			$('#prt2300').click(function(){
				commonUtil.msgBox("* 로그인 화주 2300에서 프린트 가능합니다 *");
			})
		} else if(<%=ownrky %> == '2200' ) {
			$('#prt2100').hide();
			//$('#prt2200').css("display","inline");
			$('#prt2300').hide();
		} else if(<%=ownrky %> == '2300' ) {
			$('#prt2100').hide();
			$('#prt2200').hide();
			//$('#prt2300').css("display","inline");
		}
		
		
		
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		
		gridList.setReadOnly("gridHeadList", true, ["PRITYN"]);
		
		setVarriantDef();
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			
			
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출 DNAME3
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			//출력 체크 되어있으면 redColor
			if(Number(gridList.getColData("gridHeadList", rowNum, "PRITYN")) != '' ){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
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
	
	
	function commonBtnClick(btnName){
		var SearchOwnrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
		}/* else if(btnName.indexOf("Print") != -1){
			print(btnName.replace("Print",""));
		} */else if(btnName == "Save"){
			/* saveData(); */
			param.put("SCCHECK",check);
		}else if(btnName == "PRINT"){
			if(SearchOwnrky != '2100' && SearchOwnrky != '2500' ) {
				commonUtil.msgBox("* 화주 2500에서만 프린트 가능합니다  *");
				return;
			}
			check = "1";
			saveData();
		}else if(btnName == "PRINT3"){
			if(SearchOwnrky != '2100' && SearchOwnrky != '2500' ) {
				commonUtil.msgBox("*  화주 2500에서만 프린트 가능합니다  *");
				return;
			}
			check = "3";//2
			saveData();
		}else if(btnName == "PRINT4"){
			if(SearchOwnrky != '2100' && SearchOwnrky != '2500' ) {
				commonUtil.msgBox("* 화주 2500에서만 프린트 가능합니다  *");
				return;
			}
			check = "4";//3
			saveData();
		}else if(btnName == "PRINT5"){
			if(SearchOwnrky != '2200') {
				commonUtil.msgBox("* 화주 2200에서만 프린트 가능합니다  *");
				return;
			}
			check = "5";
			saveData();
		}else if(btnName == "PRINT6"){
			if(SearchOwnrky != '2200') {
				commonUtil.msgBox("* 화주 2200에서만 프린트 가능합니다  *");
				return;
			}
			check = "6";
			saveData();
		}else if(btnName == "PRINT7"){
			if(SearchOwnrky != '2300') {
				commonUtil.msgBox("* 화주 2300에서만 프린트 가능합니다  *");
				return;
			}
			check = "7";
			saveData();
		}else if(btnName == "PRINT8"){
			if(SearchOwnrky != '2100' && SearchOwnrky != '2500' ) {
				commonUtil.msgBox("*  화주 2500에서만 프린트 가능합니다  *");
				return;
			}
			check = "8";//9
			saveData();
		}else if(btnName == "PRINT10"){
			check = "10";
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL51");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL51");
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
			
			//영업를 프린트할때 
			if(check == '5'){
				for(var i =0;i < head.length ; i++){
					var shpmty = head[i].get("SHPMTY")
					if(shpmty != '211' && shpmty != '212' && shpmty != '213' && shpmty != '214' && shpmty != '215' && shpmty != '216'){
						commonUtil.msgBox("* 영업출고된 데이터가 아닙니다. *");
						return;
					}
				}
			}
			
			
			//이고를 프린트할때 
			if(check == '4' || check == '6'|| check == '7'){
				for(var i =0;i < head.length ; i++){
					var shpmty = head[i].get("SHPMTY")
					if(shpmty != '266' && shpmty != '267'){
						commonUtil.msgBox("* 이고출고된 데이터가 아닙니다. *");
						return;
					}
				}
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundReport/json/saveDL51.data",
				param : param,
				successFunction : "returnSAVE"
			});
		}
	}
	
	function returnSAVE(){
			
			/* 프린트 */
	 	if(check == "1")  /*출고명세서 인쇄 */
	 	{
	
			if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
				var head = gridList.getSelectData("gridHeadList", true);
				//체크가 없을 경우 
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where = "";
				//반복문을 돌리며 특정 검색조건을 생성한다.
				for(var i =0;i < head.length ; i++){
					
					if(where == ""){
						where = where+" AND (SH.SHPOKY||NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + head[i].get("KEY") + "'";
				}
				where += ")";
				
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
					map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list.ezg" , where , " " , langKy, map , width , heigth );
				searchList();

			}
	 	} else if(check == "3") /* 인쇄(속도개선) */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + head[i].get("SHPOKY") + "'";
				}
				where1 += ")";
						
				var where2 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (SH.SHPOKY||NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + head[i].get("KEY") + "'";
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
	 	} else if(check == "4") /* 인쇄(이고출고)  */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + head[i].get("SHPOKY") + "'";
				}
				where1 += ")";
						
				var where2 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + head[i].get("KEY").substr(10) + "'";
				}
				where2 += ")";
				
				var where = where1 + where2;
				var langKy = "KO";
				var width = 840;
				var heigth = 625;
				var map = new DataMap();
					map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_list6.ezg" , where , " " , langKy, map , width , heigth );
				searchList();

			}
	 	} else if(check == "5") /* 대림(영업출고) */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where = "";
				for(var i =0;i < head.length ; i++){
					
					if(where == ""){
						where = where+" AND SH.SHPOKY IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + head[i].get("SHPOKY") + "'";
				}
				where += ") AND SR.DOCSEQ != ' ' ";
						
				var langKy = "KO";
				var width = 595;
				var heigth = 885;
				var map = new DataMap();
					//map.put("OPTION",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_sale_list_A4_busan.ezg" , where , " " , langKy, map , width , heigth );
				searchList();

			}
	 	} else if(check == "6") /* 대림(이고출고) */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where = "";
				for(var i =0;i < head.length ; i++){
					
					if(where == ""){
						where = where+" AND SH.SHPOKY IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + head[i].get("SHPOKY") + "'";
				}
				where += ") AND SR.DOCSEQ != ' ' ";
						
				var langKy = "KO";
				var width = 595;
				var heigth = 885;
				var map = new DataMap();
					//map.put("OPTION",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_sale_list_A4_busan2.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
				
			}
	 	} else if(check == "7") /* 오양(이고출고)*/
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where = "";
				for(var i =0;i < head.length ; i++){
					
					if(where == ""){
						where = where+" AND SH.SHPOKY IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + head[i].get("SHPOKY") + "'";
				}
				where += ") AND SR.DOCSEQ != ' ' ";
						
				var langKy = "KO";
				var width = 595;
				var heigth = 885;
				var map = new DataMap();
					//map.put("OPTION",$('#OPTION').val());
				WriteEZgenElement("/ezgen/shpdri_yigo_list_A4_oy.ezg" , where , " " , langKy, map , width , heigth );
				searchList();
				
			}
	 	} else if(check == "8") /* 인쇄(운반비) */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + head[i].get("SHPOKY") + "'";
				}
				where1 += ") ";
						
				var where2 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + head[i].get("KEY").substr(10) + "'";
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
	 	} else if(check == "10") /* 인쇄(납품처) */
	 	{
			if(gridList.validationCheck("gridHeadList", "select")){
				var head = gridList.getSelectData("gridHeadList", true);
				if(head.length == 0){
					commonUtil.msgBox("SYSTEM_ROWSEMPTY");
					return;
				}
				
				var where1 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where1 == ""){
						where1 = where1+" AND SH.SHPOKY IN (";
					}else{
						where1 = where1+",";
					}
					
					where1 += "'" + head[i].get("SHPOKY") + "'";
				}
				where1 += ") ";
						
				var where2 = "";
				for(var i =0;i < head.length ; i++){
					
					if(where2 == ""){
						where2 = where2+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
					}else{
						where2 = where2+",";
					}
					
					where2 += "'" + head[i].get("KEY").substr(10) + "'";
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
	 	}
	}
	
	 function gridListEventColBtnClick(gridId, rowNum, colName) { 
		var filedn = gridList.getColData(gridId, rowNum, "FILEDN");
		if(colName == "BTN_FILEDN"){
			if(filedn.trim() == "" || filedn.trim() == null){
				commonUtil.msgBox("STD_NOFILEDW");
				//다운로드받을 파일이 없습니다. 			
			} else {
				var svbeln = gridList.getColData(gridId, rowNum, "SVBELN");
				<%if("REAL".equals(divReal)){  //운영 %>
					window.open('http://order.sajo.co.kr/comm/excelDownloadFile.do?realFilename=' + svbeln + '&filename=' + svbeln, '', '');
				<%}else{%>
					window.open('http://testord.sajo.co.kr/comm/excelDownloadFile.do?realFilename=' + svbeln + '&filename=' + svbeln, '', '');
				<%}%>
			}
		}
	}
	 
	function gridListButtonDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var filedn = gridList.getColData(gridId, rowNum, "FILEDN");
			if(filedn.trim() == "" || filedn.trim() == null){
				return true; 			
			}			
		}
		return false;
	}
	

		//서치헬프 기본값 세팅
		function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		    var param = new DataMap();

		    //작업타입
			if(searchCode == "SHDOCTM" && $inputObj.name == "SH.SHPMTY"){
				param.put("DOCCAT","200");
			//업체코드
			}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
		        param.put("PTNRTY","0007");
		        param.put("OWNRKY","<%=ownrky %>");
		    //거래처 : 입고
			}else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.PTRCVR"){
		        param.put("PTNRTY","0001");
		        param.put("OWNRKY","<%=ownrky %>");
		    //제품코드
			} else if(searchCode == "SHSKUMA" && $inputObj.name == "SI.SKUKEY"){
		        param.put("WAREKY","<%=wareky %>");
		        param.put("OWNRKY","<%=ownrky %>");
		    //차량번호
			} else if(searchCode == "SHCARMA2" && $inputObj.name == "SR.CARNUM"){
		        param.put("WAREKY","<%=wareky %>");
		        param.put("OWNRKY","<%=ownrky %>");
			//하차조건
			} else if(searchCode == "SHCMCDV" && $inputObj.name == "SR.DCNDTN"){
				param.put("CMCDKY","DCNDTN");
		    	param.put("OWNRKY","<%=ownrky %>");
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
					
					<%-- <%if("2100".equals(OWNRKY) || "2500".equals(OWNRKY)){ //사통합 수정 %> --%>
					<span id="prt2100">
			    <!--	<input type="button" CB="PRINT PRINT_OUT BTN_SHPRINT" />  출고명세서 인쇄 -->
			    	<input type="button" CB="PRINT3 PRINT_OUT BTN_SPDPRT" /> <!-- 인쇄(속도개선) -->
			    	<input type="button" CB="PRINT4 PRINT_OUT BTN_YIGOSHIP" /> <!-- 인쇄(이고출고) -->
			    	<input type="button" CB="PRINT8 PRINT_OUT BTN_DRVPRT" /> <!-- 인쇄(운반비) -->
			    	</span>
			    	<%-- <% }%> --%>
			    	
			    	<%-- <%if("2200".equals(OWNRKY)){%> --%>
			    	<span id="prt2200">
			    	<input type="button" CB="PRINT5 PRINT_OUT BTN_DRYOUP" /> <!-- 대림(영업출고) -->
			    	<input type="button" CB="PRINT6 PRINT_OUT BTN_DRYIGO" /> <!-- 대림(이고출고) -->  
			    	</span>
			    	<%-- <% }%> --%>
			    	
			    	<%-- <%if("2300".equals(OWNRKY)){%> --%>
			    	<span id="prt2300">
			    	<input type="button" CB="PRINT7 PRINT_OUT BTN_OYYIGO" /> <!-- 오양(이고출고) -->
			    	</span>
			    	<%-- <% }%> --%>
					
					<input type="button" CB="PRINT10 PRINT_OUT BTN_DELIPRT" /> <!-- 인쇄(납품처) -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!--화주-->
						<dd>
							<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!--거점-->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARDAT"></dt> <!--배송일자-->
						<dd>
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHIPSQ"></dt> <!--배송차수-->
						<dd>
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DOCDAT"></dt> <!--문서일자-->
						<dd>
							<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C N" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPMTY"></dt> <!--출고유형-->
						<dd>
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTM" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!--S/O 번호-->
						<dd>
							<input type="text" class="input" name="SI.SVBELN" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt> <!--출고문서번호-->
						<dd>
							<input type="text" class="input" name="SH.SHPOKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STATDO"></dt> <!--문서상태-->
						<dd>
							<input type="text" class="input" name="SH.STATDO" UIInput="SR,SHVSTATDO" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DPTNKY"></dt> <!--업체코드-->
						<dd>
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DPTNKYNM"></dt> <!--업체명-->
						<dd>
							<input type="text" class="input" name="( DECODE( SH.SHPMTY, '266',  (select NAME01 From wahma WHERE WAREKY = SH.WAREKY ) ,  '270',  RBP.NAME01, BP.NAME01) )" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTRCVR"></dt> <!--거래처 : 입고-->
						<dd>
							<input type="text" class="input" name="SH.PTRCVR" UIInput="SR,SHBZPTN" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!--제품코드-->
						<dd>
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DOCSEQ"></dt> <!--거래명세표출력번호-->
						<dd>
							<input type="text" class="input" name="SR.DOCSEQ" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARNUM"></dt> <!--차량번호-->
						<dd>
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR,SHCARMA2" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_RECNUM"></dt> <!--재배차 차량번호-->
						<dd>
							<input type="text" class="input" name="SR.RECNUM" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARNBR"></dt> <!--배차번호-->
						<dd>
							<input type="text" class="input" name="SR.CARNBR" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DCNDTN"></dt> <!--하차조건-->
						<dd>
							<input type="text" class="input" name="SR.DCNDTN" UIInput="SR,SHCMCDV" />
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
								<tbody id="gridHeadList">
									<tr CGRow="true">
									<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
									<td GH="40" GCol="rowCheck"></td>
									<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
									<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td> <!--거점명-->
									<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td> <!--출고문서번호-->
									<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
									<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td> <!--배송차수-->
									<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td> <!--배송일자-->
									<td GH="120 STD_PRITYN" GCol="check,PRITYN" readonly>출고명세서출력상태</td> <!--출고명세서출력상태-->
									<td GH="120 STD_DOCSEQ" GCol="text,DOCSEQ" GF="S 12">거래명세표출력번호</td> <!--거래명세표출력번호-->
									<td GH="100 STD_CARINFO2" GCol="text,RECNUM" GF="S 20">재배차차량정보</td> <!--재배차차량정보-->
									<td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td> <!--출고유형-->
									<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td> <!--문서타입명-->
									<td GH="50 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
									<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td> <!--문서상태명-->
									<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
									<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td> <!--문서유형명-->
									<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td> <!--문서일자-->
									<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> 
									<td GH="80 STD_INDDCL" GCol="text,INDDCL" GF="S 1">송장발행</td> 
									<td GH="50 STD_ALCCFM" GCol="text,DRELIN" GF="S 1">주문수량전송여부</td> 
									<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td> 
									<td GH="100 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td> 
									<td GH="100 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td> 
									<td GH="100 STD_DEDAT" GCol="text,OPURKY" GF="D 8">도착일자</td> 
									<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td> 
									<td GH="100 STD_SOLDTO" GCol="text,DPTNKY" GF="S 10">매출처/요청거점</td> 
									<td GH="100 STD_SOLDTONM" GCol="text,DPTNKYNM" GF="S 30">매출처명/거점명</td> 
									<td GH="70 STD_SHIPTO" GCol="text,PTRCVR" GF="S 10">거래처/요청거점</td> 
									<td GH="100 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 30">납품처명</td> 
									<td GH="90 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> 
									<td GH="90 STD_STKNUM" GCol="text,STKNUM" GF="S 20">토탈계획번호</td> 
									<td GH="80 STD_PGRC01" GCol="text,PGRC01" GF="S 20">권역</td> 
									<td GH="80 STD_PGRC03" GCol="text,PGRC03" GF="S 20">주문구분</td> 
									<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 20">주문부서</td> 
									<td GH="70 RPT_BOXQTY2" GCol="text,BOXQTY2" GF="N 20,1">피킹완료박스수량</td> 
									<td GH="70 RPT_BOXQTY3" GCol="text,BOXQTY3" GF="N 20,1">출고확정박스수량</td> 
									<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> 
									<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> 
									<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> 
									<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td> 
									<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td> 
									<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td> 
									<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td> 
									<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td> 
									<td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 20">영업사원명</td> 
									<td GH="80 STD_DNAME4" GCol="text,DNAME4" GF="S 20">영업사원연락처</td> 
									<td GH="200 STD_UNAME1" GCol="text,UNAME1" GF="S 20">배송지주소</td> 
									<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 20">배송고객명</td> 
									<td GH="120 STD_DNAME1" GCol="text,DNAME1" GF="S 20">배송지전화번호</td>  
									<td GH="80 STD_FILEDN" GCol="btn,BTN_FILEDN" GB="Filedn SAVE BTN_DOWNLD"></td> 
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
										<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td> <!--출고문서번호-->
										<td GH="90 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6,0">출고문서아이템</td> <!--출고문서아이템-->
										<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td> <!--할당전략키-->
										<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td> <!--상태-->
										<td GH="80 STD_STATIT" GCol="text,STATITNM" GF="S 20">상태</td> 
										<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> 
										<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td> 
										<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td> 
										<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> 
										<td GH="85 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td> 
										<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td> 
										<td GH="70 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>
										<td GH="70 STD_QTUALO" GCol="text,QTUALO" GF="N 20,0">미할당수량</td> 
										<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td> 
										<td GH="100 RPT_BOXQTY3" GCol="text,BOXQTY2" GF="N 20,1">출고확정박스수량</td> 
										<td GH="100 STD_PKCMPL" GCol="text,QTJCMP" GF="N 20,0">피킹완료수량</td> 
										<td GH="100 RPT_BOXQTY2" GCol="text,BOXQTY3" GF="N 20,1">피킹완료박스수량</td> 
										<td GH="100 STD_SHCMPL" GCol="text,QTSHPD" GF="N 20,0">출고확정수량</td> 
										<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td> 
										<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td> 
										<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> 
										<td GH="60 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td> 
										<td GH="50 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td> 
										<td GH="60 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> 
										<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 20">포장가로</td> 
										<td GH="60 STD_WIDTHW" GCol="text,WIDTHW" GF="S 20">포장세로</td> 
										<td GH="60 STD_HEIGHT" GCol="text,HEIGHT" GF="S 20">포장높이</td> 
										<td GH="60 STD_CUBICM" GCol="text,CUBICM" GF="S 20">CBM</td> 
										<td GH="60 STD_CUBICT" GCol="text,CUBICT" GF="S 20">총CBM</td> 
										<td GH="60 STD_CAPACT" GCol="text,CAPACT" GF="S 20">CAPA</td> 
										<td GH="120 STD_REMAKS" GCol="text,NAME01" GF="S 180">비고</td> 
										<td GH="80 STD_STARCA" GCol="text,TEXT02" GF="S 180">배차메모</td> 
										<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td> 
										<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td> 
										<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td> 
										<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20" style="text-align:right;">배송차수</td> 
										<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td> 
										<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td> 
										<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td> 
										<td GH="50 STD_QTYFCNM" GCol="text,QTYREF" GF="N 17,0">배송회수처리수량</td> 
										<td GH="50 STD_QTYFCN" GCol="text,QTSHPC" GF="N 17,0">취소수량</td> 
										<td GH="80 STD_DCNDTN" GCol="text,DCNDTN" GF="S 180">하차조건</td> 
										<td GH="80 STD_CARNBR" GCol="text,CARNBR" GF="S 180">배차번호</td> 
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