<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY17</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var searchParamBak; 
	var headrow = -1;
	var rangeParam;
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangReport",
			command : "OY17_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "N00105",
		    menuId : "OY17"
		});
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangReport",
			command : "OY17_ITEM",
 			emptyMsgType : false,
 			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "N00105",
		    menuId : "OY17"
	    });
		
		gridList.setReadOnly("gridItemList", true, ["DOCUTY","DIRDVY","DIRSUP","C00102"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "200");
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>")
			return param;
		}
		return param;
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
        //거래처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "B.PTNRKY"){
        	param.put("PTNRTY","0002");
            param.put("OWNRKY","<%=ownrky %>");
        }
    	return param;
	}
	
	
	function searchList(){
		
		if(validate.check("searchArea")){
			headrow = -1;
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			rangeParam = inputList.setRangeDataParam("searchArea");
			
			//라디오 버튼 값
			if ($('#Op1').prop("checked") == true ){
				rangeParam.put("PTNRTY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				rangeParam.put("PTNRTY","0007");
			}
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeParam
		    });
			
		}
		
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			headrow = rowNum;
			var rowData = gridList.getRowData(gridId, rowNum);
			rangeParam = inputList.setRangeParam("searchArea");
			rangeParam.putAll(rowData);
			
			if ($('#Op1').prop("checked") == true ){
				rangeParam.put("PTNRTY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				rangeParam.put("PTNRTY","0007");
			}

			netUtil.send({
				url : "/OyangReport/json/displayOY17.data",
				param : rangeParam,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			}); 
		    	
		}
	}
	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();

		}else if(btnName == "Print"){

			if( $('#Op1').prop("checked") == true ){ 
				check = "3";
			}else if( $('#Op2').prop("checked") == true ){
				check = "4";
			}
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "OY17");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "OY17");
 		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var tempItem = gridList.getSelectTempData("gridHeadList");
			
			rangeParam.put("headlist",headlist);
			rangeParam.put("list",list);
			rangeParam.put("tempItem",tempItem);
			rangeParam.put("itemquery","OY17_ITEM");
			rangeParam.put("menuId","DL00");
			rangeParam.put("OWNRKY",$('#OWNRKY').val());
			rangeParam.put("WAREKY",$('#WAREKY').val());
			rangeParam.put("PTNRKY",$('#PTNRKY').val());
			rangeParam.put("USERID","<%=userid%>");
			
			if ($('#Op1').prop("checked") == true ){
				rangeParam.put("PTNRKY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				rangeParam.put("PTNRKY","0007");
			}
			
			netUtil.send({
				url : "/OyangReport/json/saveOY17.data",
				param : rangeParam,
				successFunction : "returnSAVE"
			});
		}
	}
		
	
	//ezgen 
	function returnSAVE(json, status) {
		var ownrky = $('#OWNRKY').val();
		
// 		if(gridList.validationCheck("gridItemList", "select")){ //체크된 ROW가 있는지 확인
// 		var item = gridList.getSelectData("gridItemList", true);

// 		//체크가 없을 경우 
// 		if(item.length == 0){
// 			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
// 			return;
// 		}
		
		var wherestr = ""; 
		
		if( $('#Op1').prop("checked") == true ){
			wherestr = wherestr+" AND I.PTNROD IN (";
			wherestr += json.data["PTNRKYS"];
			wherestr += ")";	
					
		}else if( $('#Op2').prop("checked") == true ){
			wherestr = wherestr+" AND I.PTNRTO IN (";
			wherestr += json.data["PTNRKYS"];
			wherestr += ")";
		}
		
		//검색조건 검색 구분 
		var orderbystr = " ";
		
		orderbystr += "AND I.WAREKY = '" + $('#WAREKY').val() + "'";
		orderbystr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	//검색조건 - 출고유형 
		orderbystr += getMultiRangeDataSQLEzgen('IT.OTRQDT', 'I.OTRQDT');	//검색조건 - 납품요청일 	
		orderbystr += getMultiRangeDataSQLEzgen('IT.TEXT02', 'I.TEXT02');	//검색조건 - 거래명세표 출력번호 
		orderbystr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	//검색조건 - 주문구분
		
		if ($('#Op1').prop("checked") == true ) {
			orderbystr += getMultiRangeDataSQLEzgen('B.PTNRKY', 'I.PTNROD');	
		} else if ($('#Op2').prop("checked") == true ) {
			orderbystr += getMultiRangeDataSQLEzgen('B.PTNRKY', 'I.PTNRTO');	
		} 
		orderbystr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	//검색조건 - 배송구분
		orderbystr += getMultiRangeDataSQLEzgen('C.CARNUM', 'C.CARNUM');	//검색조건 - 차량번호 
			orderbystr += getMultiRangeDataSQLEzgen('IT.N00105', 'N00105');	//검색조건 - 주문차수
			
			//IT.OTRQDT', 'I.OTRQDT');	//검색조건 - 출고요청일 	
			//IT.TEXT02', 'I.TEXT02');	//검색조건 - 거래명세표 출력번호 
			//IT.DIRSUP', 'I.DIRSUP');	//검색조건 - 주문구분
			//C.CARNUM', 'C.CARNUM');	//검색조건 - 차량번호			

		//이지젠 호출부(신버전)
		var langKy = "KO";
		var width = 600;
		var height = 900;
		var map = new DataMap();
		map.put("i_option",'\'<%=wareky %>\'');
		map.put("i_orderby",orderbystr);
				
		if( check == "3" ){ 
			//거래명세표(매출처_A4)
			WriteEZgenElement("/ezgen/shpdri_sale_list_A4_integrated_oy.ezg" , wherestr , "" , langKy, map , width , height );
			
		}else if( check == "4" ){
			//거래명세표(납품처_A4)
			WriteEZgenElement("/ezgen/shpdri_deli_list_A4_integrated_oy.ezg" , wherestr , "" , langKy, map , width , height );
		}
		gridListEventItemGridSearch("gridHeadList", headrow , "gridItemList");
//  		}	
	}
	
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["REUSLT"] == "1"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
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
	
// 	function gridListEventRowClick(gridId, rowNum, colName){
// 		if(gridId == "gridHeadList" && colName != "rowCheck"){
// 			gridListEventItemGridSearch("gridHeadList",rowNum,"gridItemList");
// 		}
// 	}
	
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
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print PRINT_OUT BTN_PRINT_A4" />
				</div>
			</div>
			<div class="search_inner"> <!-- 거래명세표발행(통합) -->
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl> <!--거점-->
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!-- 거래처 구분 -->  
						<dt CL="STD_BZGBN"></dt> 
						<dd style="width:300px">
							<input type="radio" name="OPTION" id="Op1" value="Op1" checked/><label for="Op1">매출처</label>
		        			<input type="radio" name="OPTION" id="Op2" value="Op2"/><label for="Op2">납품처</label>
						</dd>
					</dl> 
					<dl>  <!-- 출고유형 -->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" id="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 납품요청일 -->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" id="IT.OTRQDT" UIInput="B" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 차량번호 -->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" id="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 거래처코드 -->  
						<dt CL="STD_PTNRKY_1"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNRKY" id="B.PTNRKY" UIInput="SR,SHBZPTN"/>  
						</dd> 
					</dl> 
					<dl>  <!-- 거래명세표출력번호 -->  
						<dt CL="STD_DOCSEQ"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.TEXT02" id="IT.TEXT02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 주문구분 -->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" id="IT.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 배송구분 -->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY"  id="IT.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 주문차수 -->  
						<dt CL="STD_N00105"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.N00105" id="IT.N00105" UIInput="SR"/>  
						</dd> 
					</dl> 
				</div> 
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">	
				<div class="content_layout tabs content_left" style="width: 430px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
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
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="80 STD_N00105" GCol="text,N00105" GF="N 13">주문차수</td> <!--주문차수-->
          									<td GH="80 STD_CLNT" GCol="text,NUM01" GF="N 4">거래처</td> <!--거래처-->
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 430px);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>상세내역</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList">
										<tr CGRow="true">
											<td GH="40" GCol="rowCheck"></td>
											<td GH="100 STD_DOCSEQ" GCol="text,TEXT02" GF="S 20">거래명세표출력번호</td> <!--거래명세표출력번호-->
											<td GH="100 IFT_DOCUTY" GCol="select,DOCUTY">	<!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
				    						</td>
				    						
											<td GH="80 STD_VDATU" GCol="text,OTRQDT" GF="D 8">납품요청일 </td> <!--납품요청일 -->
											<td GH="80 STD_N00105" GCol="text,N00105" GF="N 13">주문차수</td> <!--주문차수-->
											<td GH="80 STD_PTNRKY" GCol="text,PTNRKY" GF="S 20">업체코드</td> <!--업체코드-->
											<td GH="120 STD_PTNRNM" GCol="text,PTNRNM" GF="S 20">거래처명</td> <!--거래처명-->
											<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
											<td GH="80 STD_DESC01_C" GCol="text,CARNUMNM" GF="S 20">차량등번</td> <!--차량등번-->
											<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"><option></option></select>
				    						</td>
											
											<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"><option></option></select>
				    						</td>
											
											<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td> <!--비고-->
											<td GH="80 IFT_C00102" GCol="select,C00102">	<!--승인여부-->
												<select class="input" commonCombo="C00102"><option></option></select> 
											</td>	
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
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