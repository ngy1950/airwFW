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
	var searchParamBak; 
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "DaerimOutbound",
			command : "DR16_HEADER",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DR16"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "DaerimOutbound",
			command : "DR16_ITEM",
			emptyMsgType : false,
		    menuId : "DR16"
	    });

		gridList.setReadOnly("gridHeadList", true, ["PTNG08"]);
		gridList.setReadOnly("gridItemList", true, ["DOCUTY", "PTNG08", "DIRDVY", "DIRSUP", "C00102"]);
	
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//버튼 작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Grouping"){
			groupingData();
		}else if(btnName == "DelGroup"){
			deleteGrouping();
		}else if(btnName == "PrtTotal"){
			printEZGenDR16("/ezgen/picking_total_deli_list.ezg");
		}else if(btnName == "PrtPtnrSku"){
			printEZGenDR16("/ezgen/bzptn_picking_ptnrto_list.ezg");
		}else if(btnName == "PtrSkuPtnr"){
			printEZGenDR16("/ezgen/product_picking_ptnrto_list.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR16");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DR16");
		}
	}

	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeParam("searchArea");

			//헤더 검색에 검색한 파라미터 저장
			searchParamBak = param;
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
		}
	}

	//아이템 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			//아이템 검색에 사용한 파라미터 저장(아이템 조회할대 검색조건 변경시 사용)
			searchParamBak = param;
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	//그룹핑
	function groupingData(){
		if(gridList.validationCheck("gridHeadList", "data")){
			
	        if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
	   	   //현제 포커스로우 가져오기
			var head = gridList.getSelectData("gridHeadList");
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = searchParamBak;
			param.put("head",head);
			
		 	netUtil.send({
				url : "/daerimOutbound/json/groupingDR16.data",
				param : param,
				successFunction : "successSaveCallBack"
			}); 
			
		}
	}
	
	//그룹핑삭제
	function deleteGrouping(){
		if(gridList.validationCheck("gridHeadList", "data")){
			
	        if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
	   	   //선택된 데이터 가져오기
			var head = gridList.getSelectData("gridHeadList");
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//그룹핑 번호가 있는지 체크 
			var text03Cnt = 0;
			for(var i=0; i<head.length; i++){
				var text03 = gridList.getColData("gridHeadList", head[i].get("GRowNum"), "TEXT03");
				if(text03.trim() != '') text03Cnt++;
			}
			
			if(text03Cnt < 1 ){
				commonUtil.msgBox("VALID_NOTGROUP"); //그룹핑 번호가 없습니다.
				return;
			}
			
			var param = searchParamBak;
			param.put("head",head);
			
		 	netUtil.send({
				url : "/daerimOutbound/json/deleteGrouping.data",
				param : param,
				successFunction : "successSaveCallBack"
			}); 
		}
	}
	
	//모든 버튼이 동일한 동작을 함 , 이지젠 호출 함수 공통화
	function printEZGenDR16(url){

		//for문을 돌며 TEXT03 KEY를 꺼낸다.
		var headList = gridList.getSelectData("gridHeadList");
		
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var wherestr = "";   
		var text03 = "";
		var text03Cnt = 0;
		for(var i=0; i<headList.length; i++){
			text03 = gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "TEXT03");
			
			if(wherestr == ""){
				wherestr = " AND TEXT03 IN ("; 
			}else{
				wherestr += ",";
			}
			wherestr += "'"+text03+"'";
			
			if(text03.trim() != '') text03Cnt++;
		}
		wherestr+=") ";

		//text03이 없을경우
		if(text03Cnt < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//신버전
		var orderbystr = " ";
		orderbystr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'DOCUTY');	
		orderbystr += getMultiRangeDataSQLEzgen('BZ.NAME03', 'NAME03');		
		orderbystr += getMultiRangeDataSQLEzgen('IT.ORDDAT', 'ORDDAT');		
		orderbystr += getMultiRangeDataSQLEzgen('IT.OTRQDT', 'OTRQDT');	
		orderbystr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'DIRSUP');
		orderbystr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'DIRDVY');
		orderbystr += getMultiRangeDataSQLEzgen('BZ.PTNG01', 'PTNG01');
		orderbystr += getMultiRangeDataSQLEzgen('BZ.PTNG02', 'PTNG02');
		orderbystr += getMultiRangeDataSQLEzgen('BZ.PTNG03', 'PTNG03');
		orderbystr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
		orderbystr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
		orderbystr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');

		//이지젠 호출부(신버전)
		var width = 600;
		var heigth = 920;
		var map = new DataMap();
		map.put("i_option", '\'<%=wareky %>\'');
		WriteEZgenElement(url , wherestr , orderbystr , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다
		searchList();
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
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "200");
		}
	}

	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ.NAME03"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name ==  "BZ.PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name ==  "BZ.PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name ==  "BZ.PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA" && $inputObj.name ==  "C.CARNUM"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name ==  "PK.PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }
        
    	return param;
    }
	
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
					<input type="button" CB="Grouping SAVE BTN_GROUPING" />
					<input type="button" CB="DelGroup SAVE BTN_DELGROUP" />
					<input type="button" CB="PrtTotal PRINT_OUT BTN_PRTTOTAL" />
					<input type="button" CB="PrtPtnrSku PRINT_OUT BTN_PTNRSKUPIC" />
					<input type="button" CB="PtrSkuPtnr PRINT_OUT BTN_SKUPTNRPIC" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl> <!--화주-->  
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
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고거점-->  
						<dt CL="STD_NAME03B"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.NAME03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고일자-->  
						<dt CL="IFT_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.PTNG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.PTNG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.PTNG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_PICGRP"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
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
											<td GH="120 STD_PTNG08" GCol="select,PTNG08">	<!--마감구분-->
												<select class="input" commonCombo="PTNG08"></select>
											</td>
				    						<td GH="80 거래처" GCol="text,NUM01" GF="N 4,0">거래처</td>	<!--거래처-->
				    						<td GH="70 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20">피킹출력번호</td>	<!--피킹출력번호-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="total"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
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
											<td GH="40" GCol="rownum">1</td>
											<td GH="70 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20">피킹출력번호</td>	<!--피킹출력번호-->
				    						<td GH="80 IFT_DOCUTY" GCol="select,DOCUTY">	<!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
				    						</td>
				    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
				    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
				    						<td GH="80 STD_PTNG08" GCol="select,PTNG08"><!--마감구분-->
												<select class="input" commonCombo="PTNG08"></select>
				    						</td>	
				    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="80 STD_DESC01_C" GCol="text,DESC01" GF="S 20"></td>	<!---->
				    						<td GH="80 STD_PTNRTO" GCol="text,PTNRTO" GF="S 20">거래처/요청거점</td>	<!--거래처/요청거점-->
				    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
				    						</td>	
				    						<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
				    						</td>	
				    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td>	<!--비고-->
				    						<td GH="80 IFT_C00102" GCol="select,C00102">	<!--승인여부-->
												<select class="input" commonCombo="C00102"></select>
											</td>							
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
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