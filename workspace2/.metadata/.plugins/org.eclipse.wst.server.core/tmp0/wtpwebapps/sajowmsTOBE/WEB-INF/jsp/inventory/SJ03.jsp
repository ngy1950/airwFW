<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SJ03</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList", 
	    	module : "InventorySetBom",
			command : "SJ01",
			itemGrid : "gridItemList",
			itemSearch : true,
			pkcol : "PHYIKY",
		    menuId : "SJ03"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "InventoryAdjustment",
			command : "SJ04",
		    menuId : "SJ03"
	    });
		
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["LOTA05","LOTA06"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = inputList.setRangeDataParam("searchArea");
			var rowData = gridList.getRowData(gridId, rowNum);
			param.putAll(rowData);
			
			
			if(rowData.map.SADJKY && rowData.map.SADJKY != '' && rowData.map.SADJKY != ' '){ // 조정문서번호가 생성된 경우 
				//아이템 재조회
				reSearchList(rowData.map.SADJKY);
			
			}else{
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}
		}
	}
	
	//버튼 동작
	function commonBtnClick(btnName){
		var ownrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "RsnadjChk"){
		 	setChk("RSNADJ");
		 	
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "SJ03");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SJ03");
 		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			uiList.setActive("Save",true);
			
			var param = inputList.setRangeDataParam("searchArea"); 
			param.put("ADJUCA", "400"); //조정 카테고리
			param.put("ADJUTY", "430"); //조정문서 유형
			param.put("CREUSR", "<%=userid%>");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
			$("#RSNADJCOMBO").val("선택");
		}
	}
	
	function reSearchList(json){
		if(validate.check("searchArea")){
			var reparam = new DataMap();
			reparam.put("SADJKY",json.data["SADJKY"]);
			
			netUtil.send({
	    		module : "InventoryAdjustment",
				command : "ADJDH",
				bindType : "grid",
				sendType : "list",
				bindId : "gridItemList",
		    	param : reparam
			});	
			
			$("#RSNADJCOMBO").val("선택");
		}
	}

	//저장 
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")&& gridList.validationCheck("gridItemList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			var head = headlist[0];
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			var docdat = head.get("DOCDAT");
			var yy = docdat.substr(0,4);
			var mm = docdat.substr(4,2);
		    var dd = docdat.substr(6,2);
		    var sysdate = new Date(); 
		 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
		    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
				alert("확정일자는 ±10일로 지정하셔야 합니다.") ;
				return;
			}
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.RSNADJ == "" || itemMap.RSNADJ == " "){
					commonUtil.msgBox("조정사유코드를 입력해주세요.");
					return
				}
			}
	
			var param = inputList.setRangeDataParam("searchArea");
			var item = gridList.getSelectData("gridItemList", true);
			param.put("SES_USER_ID",gridList.getColData("gridHeadList", 0, "CREUSR")); //생성자
			param.put("OWNRKY", gridList.getColData("gridHeadList", 0, "OWNRKY")); //화주
			param.put("WAREKY", gridList.getColData("gridHeadList", 0, "WAREKY")); //거점
			param.put("DOCTXT", gridList.getColData("gridHeadList", 0, "DOCTXT")); //비고
			param.put("ADJUTY", gridList.getColData("gridHeadList", 0, "ADJUTY")); //조정문서 유형
			param.put("DOCDAT", gridList.getColData("gridHeadList", 0, "DOCDAT")); //문서날짜
			
			
			
			
			
			
			param.put("item",item);	
			param.put("PROGID", configData.MENU_ID);
			
			netUtil.send({
				url : "/inventoryAdjustment/json/saveSJ04.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				uiList.setActive("Save",false);
				reSearchList(json);
				gridList.setColValue("gridHeadList", 0, "SADJKY", json.data["SADJKY"]);
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
			}else if(json.data == "F"){
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
		}else if(gridId == "gridItemList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId == "gridItemList"){
// 			if(colName == "TGSKUKEY"){ //치환제품 -제품코드 변경시
// 				var param = new DataMap();
// 				param.put("OWNRKY", $("#OWNRKY").val());
// 				param.put("WAREKY", $("#WAREKY").val());
// 				param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
				
// 				var json = netUtil.sendData({
// 					module : "SajoCommon",
// 					command : "INVENTORY_SKUMA_GETINFO_MTOM",
// 					sendType : "list",
// 					param : param
// 				}); 
				
// 				//sku가 있을 경우 
// 				if(json && json.data && json.data.length > 0 ){
// 					var jsonMap = json.data[0];
// 					for(prop in jsonMap)  {
// 						gridList.setColValue(gridId, rowNum, prop, json.data[0][prop]);
// 					}
// 				}else{
// 					gridList.setColValue(gridId, rowNum, "SKUKEY", ""); //제품코드
// 					gridList.setColValue(gridId, rowNum, "DESC01", ""); //제품명
// 				}
			
// 			}else if(colName == "TGLOCAKY"){ //TO로케이션 변경시
// 				param.put("WAREKY", $("#WAREKY").val());
// 				param.put("LOCAKY", gridList.getColData(gridId, rowNum, colName));
				
// 				var json = netUtil.sendData({
// 					module : "SajoCommon",
// 					command : "INVENTORY_LOCMA_GETINFO",
// 					sendType : "list",
// 					param : param
// 				}); 
// 			}
		}
	} // end gridListEventColValueChange
    
    
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "430");
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "430");
		}
		return param;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //로케이션
        if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){
        	param.put("CMCDKY","WAREKY");
        //재고유형    
        }else  if(searchCode == "SHCMCDV" && $inputObj.name == "S.LOTA06" ){ 
        	param.put("CMCDKY","LOTA06");
        	
        //그리드 TO로케이션 검색
        }else if(searchCode == "SHLOCMA"){
        	param.put("WAREKY",$("#WAREKY").val());
        //그리드 치환제품
        }else if(searchCode == "SHSKUMA"){
        	param.put("OWNRKY",$("#OWNRKY").val());
        	param.put("WAREKY",$("#WAREKY").val());
        }
        return param; 
    }
	
    
    function setChk(type){
    	//부분적용 사유코드  가져오기
		var rsnadj = $('#RSNADJCOMBO').val();
	
		if(rsnadj == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		// 그리드에서 선택 된 값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);
		for(var i=0; i<selectDataList.length; i++){
			if (type == "RSNADJ"){
				gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅	
			}
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
					<input type="button" CB="Search ADD BTN_CREATE" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>  
						<dt CL="STD_AREAKY"></dt> <!--동-->  
						<dd> 
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  
						<dt CL="STD_ZONEKY"></dt> <!--존-->  
						<dd> 
							<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					<dl>   
						<dt CL="STD_LOCAKY"></dt> <!--로케이션--> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>   
						<dt CL="STD_SKUKEY"></dt> <!--제품코드--> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  
						<dt CL="STD_DESC01"></dt>  <!--제품명--> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  
						<dt CL="STD_TRNUID"></dt> <!--팔렛트ID-->  
						<dd> 
							<input type="text" class="input" name="S.TRNUID" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>
						<dt CL="STD_LOTA13"></dt> <!-- 유통기한 -->
						<dd>
							<input type="text" class="input" name="S.LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA12"></dt> <!-- 입고일자 -->
						<dd>
							<input type="text" class="input" name="S.LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA03"></dt> <!-- 벤더 -->
						<dd>
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA05"></dt> <!-- 포장구분 -->
						<dd>
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA06"></dt> <!-- 재고유형 -->
						<dd>
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHCMCDV" />
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
			    						<td GH="120 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td> <!--조정문서번호-->
								        <td GH="50 STD_ADJUTY" GCol="text,ADJUTY" GF="S 4">조정문서 유형</td> <!--조정문서 유형-->
								        <td GH="120 STD_ADJSTX" GCol="text,ADJSTX" GF="S 90">조정타입설명</td> <!--조정타입설명-->
								        <td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_DOCDAT" GCol="input,DOCDAT" GF="C">문서일자</td> <!--문서일자-->
								        <td GH="50 STD_DOCCAT" GCol="input,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
								        <td GH="50 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td> <!--비고-->
								        <td GH="88 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
								        <td GH="88 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td> <!--생성시간-->
								        <td GH="88 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td> <!--생성자-->
								        <td GH="88 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
								        <td GH="60 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td> <!--문서유형명-->
								        <td GH="50 STD_ADJUCA" GCol="text,ADJUCA" GF="S 4">조정 카테고리</td> <!--조정 카테고리-->
								        <td GH="88 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td> <!--수정일자-->
								        <td GH="88 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td> <!--수정시간-->
								        <td GH="88 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td> <!--수정자-->
								        <td GH="88 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td> <!--수정자명-->
 								        <td GH="60 STD_ADJUCANM" GCol="text,ADJUCANM" GF="S 20">조정카테고리명</td> 
<!--								        <td GH="50 STD_USRID1" GCol="text,USRID1" GF="S 20">배송지우편번호</td> 배송지우편번호
								        <td GH="50 STD_UNAME1" GCol="text,UNAME1" GF="S 20">배송지주소</td> 배송지주소
								        <td GH="50 STD_DEPTID1" GCol="text,DEPTID1" GF="S 20">배송고객명</td> 배송고객명
								        <td GH="50 STD_DNAME1" GCol="text,DNAME1" GF="S 20">배송지전화번호</td> 배송지전화번호
								        <td GH="50 STD_USRID2" GCol="text,USRID2" GF="S 20">업무담당자</td> 업무담당자
								        <td GH="50 STD_UNAME2" GCol="text,UNAME2" GF="S 20">업무담당자명</td> 업무담당자명
								        <td GH="50 STD_DEPTID2" GCol="text,DEPTID2" GF="S 20">업무 부서</td> 업무 부서
								        <td GH="50 STD_DNAME2" GCol="text,DNAME2" GF="S 20">업무 부서명</td> 업무 부서명
								        <td GH="50 STD_USRID3" GCol="input,USRID3" GF="S 20">현장담당</td> 현장담당
								        <td GH="50 STD_UNAME3" GCol="text,UNAME3" GF="S 20">현장담당자명</td> 현장담당자명
								        <td GH="50 STD_DEPTID3" GCol="text,DEPTID3" GF="S 20">현장담당 부서</td> 현장담당 부서
								        <td GH="50 STD_DNAME3" GCol="text,DNAME3" GF="S 20">현장담당 부서명</td> 현장담당 부서명
								        <td GH="50 STD_USRID4" GCol="input,USRID4" GF="S 20">현장책임</td> 현장책임
								        <td GH="50 STD_UNAME4" GCol="text,UNAME4" GF="S 20">영업사원명</td> 영업사원명
								        <td GH="50 STD_DEPTID4" GCol="text,DEPTID4" GF="S 20">현장책임 부서</td> 현장책임 부서
								        <td GH="50 STD_DNAME4" GCol="text,DNAME4" GF="S 20">영업사원연락처</td> 영업사원연락처 -->
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
					<li><a href="#tab2-1" id="atab1"><span>조정가능 목록</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<!-- 조정사유코드 반영 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">                                                                                                           
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>                                                                  
						<select name="RSNADJCOMBO" id="RSNADJCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true">
							<option>선택</option>
						</select>       
					</li>                                                                                                                                                   
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->                                                                                             
						<input type="button" CB="RsnadjChk SAVE BTN_PART" />                                                                                                   
					</li> 
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>      
										<td GH="40" GCol="rowCheck"></td>
										<td GH="60 STD_AREAKY" GCol="text,AREAKY" GF="S 60">동</td> <!--동-->
										<td GH="70 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td> <!--로케이션-->
								        <td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
								        <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
										<td GH="30 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td> <!--단위-->
										<td GH="80 STD_CHNSKUKEY" GCol="input,TGSKUKEY,SHSKUMA" GF="S 20">치환제품</td><!--치환제품--> 
										<td GH="60 STD_USEQTY" GCol="text,USEQTY" GF="N 20,0">가용수량</td> <!--가용수량--> 
										<td GH="60 STD_QTADJU" GCol="input,QTADJU" GF="N 20,0">조정수량</td> <!--조정수량-->
										<td GH="80 STD_LOCATG" GCol="input,TGLOCAKY,SHLOCMA" GF="S 20">TO로케이션</td> <!--TO로케이션-->
										<td GH="80 STD_TRNUID" GCol="text,TGTRNUID" GF="S 20">팔렛트ID</td> <!--팔렛트ID-->
										 <td GH="140 STD_RSNADJ" GCol="select,RSNADJ"> <!--조정사유코드-->
								        	<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
								        </td> 
								        <td GH="80 STD_ADJRSN" GCol="input,ADJRSN" GF="S 255">조정상세사유</td> <!--조정상세사유-->
								        <td GH="80 STD_LOTA11" GCol="input,LOTA11" GF="C 8">제조일자</td> <!--제조일자-->
								        <td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="C 8">입고일자</td> <!--입고일자-->
								        <td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="C 8">유통기한</td> <!--유통기한-->
								        <td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td> <!--벤더-->
										<td GH="120 STD_LOTA06" GCol="select,LOTA06"> <!--재고유형-->
								        	<select class="input" CommonCombo="LOTA06"><option></option></select>
								        </td> 
								        <td GH="130 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
								        	<select class="input" CommonCombo="LOTA05"><option></option></select>
								        </td> 
										<td GH="80 STD_SBKTXT" GCol="input,SBKTXT" GF="S 75">비고</td> <!--비고-->
			    						<td GH="100 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td> <!--재고키-->
								        <td GH="60 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td> <!--팔렛타입-->
								        <td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
								        <td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
								        <td GH="60 STD_REMQTY" GCol="text,REMQTY" GF="N 20,0">잔량</td> <!--잔량-->
								        <td GH="80 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td> <!--재고수량-->
								        <td GH="80 STD_QTSBLK" GCol="text,QTSBLK" GF="N 20,0">보류수량</td> <!--보류수량-->
								        <td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 60">대분류</td> <!--대분류-->
								        <td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td> <!--박스수량-->
								        <td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
								        <td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td> <!--팔레트수량-->
								        <td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
								        <td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위    -->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<!-- <button type='button' GBtn="add" id="itemGridAdd"></button>
						<button type='button' GBtn="delete" id="itemGridDelete"></button> -->
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