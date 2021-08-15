<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL45</title>
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
	var PROGID = 'DL45';
	var TASKKYS = '';
	
	var headrow = -1;
	var searchParam ;

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundPicking",
			command : "DL45_HEAD",
			pkcol : "OWNRKY,WAREKY,RECVKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true,
		    menuId : "DL45"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundPicking",
			command : "DL45_ITEM",
			colorType : true,
		    menuId : "DL45" 
	    });
		
		//검색조건 입고유형 셀렉트
		inputList.setMultiComboSelectAll($("#RCPTTY"), true);
		
		//콤보박스 리드온리 출력여부 
		gridList.setReadOnly("gridHeadList", true, ["DNAME3"]);
		
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		searchwareky($('#OWNRKY').val());
		
		//검색조건 입고유형 셀렉트
		inputList.setMultiComboSelectAll($("#RCPTTY"), true);


		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출 DNAME3
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			//출력 체크 되어있으면 redColor
			if(Number(gridList.getColData("gridHeadList", rowNum, "DNAME3")) != '' ){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}

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
			
			searchParam = param;
			headrow = -1 ;
			
			netUtil.send({
				url : "/OutBoundPicking/json/displayDL45.data", 
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
			
// 			gridList.gridList({
// 		    	id : "gridHeadList",
// 		    	param : param
// 		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);

			netUtil.send({
				url : "/OutBoundPicking/json/displayDL45Item.data", 
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
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
			param.put("DOCUTY", "102");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
			
		}else if(comboAtt == "OutBoundPicking,COMBO_RCPTTY"){
			param.put("DOCCAT", "100");
			param.put("PROGID", "DL45");
			return param;
		}
		return param;
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
			TASKKYS = '';
			searchList();
		}else if(btnName == "Confirm"){ //피킹완료
			confirmOrderTask(); 
		}else if(btnName == "Print"){ //피킹리스트 인쇄  PRINT
			check = "1";
			saveData(); 
		}else if(btnName == "Print1"){ //그룹피킹리스트 인쇄  PRINT_GR
			check = "2";
			saveData(); 
		}else if(btnName == "Print2"){ //차량별 검수인쇄  PRINT_GR2
			check = "3";
			saveData(); 
		
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DL45");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DL45");
 		}	
	}
	
	//피킹완료
	function confirmOrderTask(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			var item = gridList.getSelectData("gridItemList", true);
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
 			netUtil.send({
				url : "/OutBoundPicking/json/pickingDL45.data",
				param : param,
				successFunction : "successSaveCallBack"
 			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				TASKKYS = json.data["RESULT"];
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//출력상태 체크 
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
 				url : "/OutBoundPicking/json/printDL45.data", 
 				param : param,
 				successFunction : "returnSAVE"
 			});
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //입고유형
        if(searchCode == "SHDOCTM"){
            param.put("DOCCAT","100");  
        //제품코드
        }else if(searchCode == "SHSKUMA"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //업체코드
        }else if(searchCode == "SHBZPTN"){
        	param.put("CMCDKY","WAREKY");
            param.put("PTNRTY","0002");  
        //벤더
		}else if(searchCode == "SHLOTA03CM" && $inputObj.name == "S.LOTA03"){
			param.put("CMCDKY","WAREKY");
			param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0001");   
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
	
	
  //피킹리스트 인쇄 prt 		
	function returnSAVE(){
		//피킹리스트 인쇄
		if(check == "1"){
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
						where = where+" AND RH.RECVKY IN (";
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
				map.put("i_option",$('#OPTION').val());
				WriteEZgenElement("/ezgen/pre_picking_list.ezg" , where , "" , langKy, map , width , height );
				searchList();
			}
			
			//그룹피킹리스트 출력
		}else if(check == "2"){
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
						where = where+" AND B.RECVKY IN (";
					}else{
						where = where+",";
					}
					where += "'" + head[i].get("RECVKY") + "'";
				}
				where += ")";
				

				var option = "";
				
				option += getMultiRangeDataSQLEzgen('SHIPSQ', 'SR.SHIPSQ');
				option += getMultiRangeDataSQLEzgen('CARDAT', 'SR.CARDAT');
				
				if(option.length == 0){
					option = " ";
				}
				
				//이지젠 호출부(신버전)
				var langKy = "KO";
				var map = new DataMap();
				var width = 840;
				var height = 600;
				map.put("i_option",option);
				WriteEZgenElement("/ezgen/pre_picking_list_grp.ezg" , where , "" , langKy, map , width , height );
				searchList();
			}
			//차량별 검수 인쇄(그룹)
		}else if(check == "3"){
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
						where = where+" AND B.RECVKY IN (";
					}else{
						where = where+",";
					}
					where += "'" + head[i].get("RECVKY") + "'";
				}
				where += ")";
				

				var option = "";
				
				option += getMultiRangeDataSQLEzgen('SHIPSQ', 'SR.SHIPSQ');
				
				if(option.length == 0){
					option = " ";
				}
				
				//이지젠 호출부(신버전)
				var langKy = "KO";
				var map = new DataMap();
				var width = 840;
				var height = 600;
				map.put("i_option",option);
				WriteEZgenElement("/ezgen/pre_picking_list_grp2.ezg" , where , "" , langKy, map , width , height );
				searchList();
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
					<input type="button" CB="Confirm CONFIRM STD_PICKYN" /> <!-- 피킹완료-->
					<input type="button" CB="Print PRINT_OUT BTN_PKPRINT" /> <!-- 피킹리스트 인쇄-->
					<input type="button" CB="Print1 PRINT_OUT BTN_PKPRINT_GR" /> <!-- 그룹피킹리스트 출력-->
					<input type="button" CB="Print2 PRINT_OUT BTN_PKPRINT_GR2" /> <!-- 차량별 검수 인쇄(그룹)-->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_OWNRKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>  <!-- 배송일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="CARDAT" id="CARDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!-- 배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="SHIPSQ" id="SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RH.RCPTTY" id="RCPTTY" class="input" comboType="MS" Combo="OutBoundPicking,COMBO_RCPTTY"></select>
						</dd> 
					</dl> 
					<dl>  <!--입고일자-->  
						<dt CL="STD_ARCPTD"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!-- ASN 문서번호-->  
						<dt CL="STD_ASNDKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.REFDKY" UIInput="SR,SHASN"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 입고문서번호-->  
						<dt CL="STD_RECVKY"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.RECVKY" UIInput="SR,SHRECDH"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 구매오더 No-->  
						<dt CL="STD_SEBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SEBELN" UIInput="SR,SHPO103"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="CARNUM" UIInput="SR"/> 
						</dd> 
					</dl>
					<dl>  <!-- 유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!-- 입고일자-->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!-- 벤더-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>
					<dl>  <!-- 포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl>
					<dl>  <!-- 재고유형-->  
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
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호 </td> <!--입고문서번호-->
										<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
										<td GH="100 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
										<td GH="80 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td> <!--입고유형-->
										<td GH="80 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td> <!--입고유형명-->
										<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
										<td GH="120 STD_PRITYN2" GCol="check,DNAME3">출력상태</td>	<!--출력상태-->
										<td GH="100 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td> <!--문서상태명-->
										<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td> <!--문서일자-->
										<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
										<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td> <!--문서유형명-->
										<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td> <!--비고-->
										<td GH="50 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17">입고수량</td> <!--입고수량-->
										<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 17">작업수량</td> <!--작업수량-->
										<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 17">완료수량</td> <!--완료수량-->
										<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td> <!--구매오더 No-->
										<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
										<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> <!--생성시간-->
										<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
										<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td> <!--생성자명-->
										<td GH="50 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td> <!--수정일자-->
										<td GH="50 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td> <!--수정시간-->
										<td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td> <!--수정자-->
										<td GH="50 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td> <!--수정자명-->
										<td GH="80 completeCnt" GCol="text,COMPLETECNT" GF="N 17">completeCnt</td> <!--completeCnt-->
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
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
							        	<td GH="120 STD_TASKKY" GCol="text,TASKKY" GF="S 50">작업지시번호</td> <!--작업지시번호-->
										<td GH="160 STD_TASKIT" GCol="text,TASKIT" GF="S 50">작업오더아이템</td> <!--작업오더아이템-->
										<td GH="80 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
										<td GH="88 STD_DPTNKY" GCol="text,DPTNKY" GF="S 60"></td>	<!--업체코드-->
			    						<td GH="88 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 60"></td>	<!--업체명-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4"></td>	<!--상태-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20"></td>	<!--로케이션-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60"></td>	<!--제품명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0"></td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0"></td>	<!--완료수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>	<!--화주-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60"></td>	<!--규격-->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10"></td>	<!--단위구성-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3"></td>	<!--단위-->
			    						<td GH="160 STD_LOCATG" GCol="text,LOCATG" GF="S 20"></td>	<!--To 로케이션-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10"></td>	<!--출고문서번호-->
			    						<td GH="50 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6"></td>	<!--출고문서아이템-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20"></td>	<!--포장단위-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10"></td>	<!--대분류-->
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11"></td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11"></td>	<!--순중량-->
			    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3"></td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11"></td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11"></td>	<!--가로길이-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11"></td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11"></td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11"></td>	<!--CAPA-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10"></td>	<!--동-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!--S/O번호-->
			    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6"></td>	<!--주문번호(D/O)item-->
			    						<td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10"></td>	<!--출발지-->
			    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20"></td>	<!--상태명-->
			    						<td GH="88 STD_CREDAT" GCol="text,CREDAT" GF="D 8"></td>	<!--생성일자-->
			    						<td GH="88 STD_CRETIM" GCol="text,CRETIM" GF="T 8"></td>	<!--생성시간-->
			    						<td GH="88 STD_CREUSR" GCol="text,CREUSR" GF="S 60"></td>	<!--생성자-->
			    						<td GH="88 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60"></td>	<!--생성자명-->
			    						<td GH="88 STD_LMODAT" GCol="text,LMODAT" GF="D 60"></td>	<!--수정일자-->
			    						<td GH="88 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60"></td>	<!--수정시간-->
			    						<td GH="88 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60"></td>	<!--수정자-->
			    						<td GH="88 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60"></td>	<!--수정자명-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80"></td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60"></td>	<!--배송일자-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0"></td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0"></td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60"></td>	<!--기사명-->
			    						<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60"></td>	<!--재배차여부-->
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