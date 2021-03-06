<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var today = new Date();
	var day = today.getDate();
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
			command : "IP14_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			pkcol : "PHYIKY",
		    menuId : "IP14"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "IP14_ITEM",
		    menuId : "IP14"
	    });
		/*  
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY"]);
		gridList.setReadOnly("gridItemList", true, ["RSNADJ","LOTA02" , "LOTA05", "LOTA06"]);
		 */
		
		inputList.rangeMap["map"]["IFWMS113.DOCDAT"].$from.val(dateParser(null, "S", 0, 0, (day*-1)+1));	// 시작날짜, 종료날짜 1~10일 셋팅 
		inputList.rangeMap["map"]["IFWMS113.DOCDAT"].$to.val(dateParser(null, "S", 0, 0, (day*-1)+9));		
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){

 		 	if(day < 8 || day > 10){
				alert("IP14는 매월 8~10에만 사용 가능합니다.");
				return;
			}  
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("PHSCTY","551");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
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
			param.put("DOCUTY", "136");
			param.put("OWNRKY", $("#OWNRKY").val());
		}
		/* if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO" || comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "551");
			param.put("OWNRKY", $("#OWNRKY").val());
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			param.put("CMCDKY", "LOTA06");	
		} */
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Shipment"){
			saveData();
		}else if(btnName == "Shipment_ALL"){
			gridList.checkAll("gridHeadList",true);
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "IP14");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "IP14");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //요청사업장
        if(searchCode == "SHCMCDV" && $inputObj.name == "IFWMS113.DNAME1"){
        	param.put("CMCDKY","PTNG05"); 
        //납품처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //매출처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        //제품용도
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IFWMS113.SKUG05"){
            param.put("CMCDKY","SKUG05");
        //로케이션	
        }else if(searchCode == "SHLOCMA"){
			param.put("WAREKY",$("#WAREKY").val());
		}
    	return param;
    }
	
	
	function saveData(){
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(head.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if((Number)(itemMap.QTYRCV) != 0){
					if(itemMap.LOTA13 == ""){
						commonUtil.msgBox("VALID_M0324");
						return; 
					}
				}
			}

			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("INDDCL", "V");
			param.put("CREUSR", "<%=userid%>");
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/inventory/json/saveIP14.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}// end saveData()
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				gridList.setColValue("gridHeadList", 0, "PHYIKY", json.data["PHYIKY"]);
				uiList.setActive("Save",false);
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
				var param = inputList.setRangeDataParam("searchArea");
				param.put("PHSCTY","551");
				param.put("RECVKYS",json.data["RECVKYS"]);
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
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
					<input type="button" CB="Shipment_ALL SAVE 기타출고(전체)" />
					<input type="button" CB="Shipment SAVE 기타출고" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="scRcptty" id="RCPTTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO" ComboCodeView="true"></select> 
						</dd> 
					</dl> 
					
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--확정일자-->  
						<dt CL="STD_CONDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DOCDAT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DNAME1" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--요청사업장명-->  
						<dt CL="STD_IFPGRC04N"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--납품처명-->  
						<dt CL="IFT_PTNRTONM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DPTNKYNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--매출처명-->  
						<dt CL="STD_PTNRODNM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNRODNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--고객명-->  
						<dt CL="STD_CUNAME"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--반품지 주소-->  
						<dt CL="STD_CUADDR"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DNAME4" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--규격-->  
						<dt CL="STD_DESC02"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC02" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--인쇄여부-->  
						<dt CL="STD_PRINTCHK"></dt> 
						<dd> 
							<select name="scPrintchk" id="PRINTCHK" class="input" commonCombo="POCLOS"></select> 
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
					<li><a href="#tab1-1"><span>일반</span></a></li><br>
					>> GR47 확정 일자 1~9일 상시반품 오더 폐기출고 프로그램
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
								        <td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_CONDAT" GCol="text,DOCDAT" GF="D 8">확정일자</td>	<!--확정일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="90 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="100 IFT_PTNRTONM" GCol="text,DPTNKYNM" GF="S 100">납품처명</td>	<!--납품처명-->
			    						<td GH="50 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="50 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 100">매출처명</td>	<!--매출처명-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 30">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_CTNAME" GCol="text,UNAME1" GF="S 20">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_WARESR" GCol="text,DNAME1" GF="S 20">요구사업장</td>	<!--요구사업장-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,UNAME2" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 IFT_SALENM" GCol="text,UNAME3" GF="S 20">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,UNAME4" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_CUADDR" GCol="text,DNAME4" GF="S 20">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 200">비고</td>	<!--비고-->
			    						<td GH="50 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="50 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td>	<!--입고유형명-->
			    						<td GH="50 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="50 STD_RCUNAME2" GCol="text,CUNAME" GF="S 100">요구사업장명</td>	<!--요구사업장명-->
			    						<td GH="50 STD_CUADDR" GCol="text,CUADDR" GF="S 100">반품지 주소</td>	<!--반품지 주소-->
			    						<td GH="50 STD_PRTYN" GCol="text,PRINTCHK" GF="S 100">인쇄여부</td>	<!--인쇄여부-->
			    						<td GH="70 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_DPHONE" GCol="text,DPHONE" GF="S 17">기사연락처</td>	<!--기사연락처-->
			    						<td GH="80 STD_ERDAT" GCol="text,ERDAT" GF="D 17">지시일자</td>	<!--지시일자-->
			    						<td GH="80 STD_RECALLDAT" GCol="text,RECALLDAT" GF="D 17">회수일자</td>	<!--회수일자-->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 3">제품용도</td>	<!--제품용도-->
			    						<td GH="50 STD_WMSCREDAT" GCol="text,WMSCREDAT" GF="S 100">WMS생성일자</td>	<!--WMS생성일자-->
			    						<td GH="50 STD_WMSCRETIM" GCol="text,WMSCRETIM" GF="S 100">WMS생성시간</td>	<!--WMS생성시간-->
			    						<!-- <td GH="50 STD_DLVDAT" GCol="text,ORDDAT" GF="S 100">납품요청일</td>	납품요청일 -->
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="80 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="80 STD_RECRSNCD" GCol="text,RSNCOD" GF="S 4">출고반품입고사유</td>	<!--출고반품입고사유-->
			    						<td GH="50 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="60 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="90 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="80 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="80 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="80 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="100 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="50 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="50 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="50 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="50 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="50 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="50 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="50 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="50 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="50 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="50 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="50 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="50 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="50 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="50 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="50 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="50 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="50 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="50 STD_ORDQTY" GCol="text,ORDQTY" GF="N 17,0">지시수량</td>	<!--지시수량-->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
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