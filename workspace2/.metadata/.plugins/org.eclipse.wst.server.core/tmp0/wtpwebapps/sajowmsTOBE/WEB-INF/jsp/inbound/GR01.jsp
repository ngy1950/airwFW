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
var afsaveSearch = false,rangeparam;
var savekey = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR00",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "ASNDKY",
			menuId : "GR01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "SajoInbound",
			command : "GR00_ITEM",
			tempHead : "gridHeadList",
			useTemp : true,
			totalView : true,
			tempKey : "ASNDKY",
			menuId : "GR01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			afsaveSearch = false;
			rangeparam = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			rangeparam.putAll(param);
			
			if(savekey == ''){
				gridList.gridList({
			    	id : "gridItemList",
			    	param : rangeparam
			    });
			}else{
				gridList.gridList({
			    	id : "gridItemList",
			    	module : "SajoInbound",
			    	command : "GR00_ITEM_SAVE",
			    	param : rangeparam
			    });
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridHeadList" && dataCount > 0){
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
			}
		}else if(gridId == "gridItemList" && dataCount > 0){
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
				for(var i =0;i<dataCount;i++){
					if(gridList.getColData(gridId, i, "STATIT") == "ARV"){
						gridList.setRowReadOnly(gridId, i, true, null);
					}	
					
				}
				
			}
			if(!gridList.gridMap.get("gridItemList").totalView){
				$('#total').trigger("click");	
			}
		}
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "102");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "LOTA01");
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
			for(var i=0;i<headlist.length;i++){
				var head = headlist[i];
				var docdat = head.get("DOCDAT");
				var yy = docdat.substr(0,4);
				var mm = docdat.substr(4,2);
			    var dd = docdat.substr(6,2);
			    var sysdate = new Date(); 
			 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
			    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
					alert("확정일자는 ±10일로 지정하셔야 합니다.") ;
					gridList.setRowFocus("gridHeadList", i, true);
					return;
				}	
			}
			
			for(var i=0; i < list.length; i++){
				var row = list[i];
				var qtyrcv = row.get("QTYRCV");
				var lota13 = row.get("LOTA13");
				
				if(qtyrcv != 0 ){
					if(lota13 == ""){
						alert(getMessage("VALID","M0324"));
						return;
					}
				}
			}
			
			var keys = Object.keys(tempItem.map);
			
			for(var i=0; i<keys.length; i++){
				var templist = tempItem.get(keys[i]);
				var head = headlist.filter(function (e) {
				    return e.get("KEY") == keys[i];
				});
				
				if(head.length == 0){
					continue;
				}
				
				for(var j=0; j<templist.length; j++){
					var row = templist[j];
					var qtyrcv = row.get("QTYRCV");
					var lota13 = row.get("LOTA13");
					
					if(qtyrcv != 0 ){
						if(lota13 == ""){
							commonUtil.msgBox("VALID_M0324");
							return;
						}
					}
				}
			}
			
	
			var param = new DataMap();
			rangeparam.put("headlist",headlist);
			rangeparam.put("list",list);
			rangeparam.put("tempItem",tempItem);
			rangeparam.put("itemquery","GR00_ITEM");
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/inbound/json/saveReceive.data",
				param : rangeparam,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				afsaveSearch = true;
				savekey =json.data["SAVEKEY"];
				rangeparam.put("SAVEKEY",savekey);
				
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : rangeparam
			    });
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			savekey = '';
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR01");
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();

		if(searchCode == "SHLOCMA"){

			param.put("WAREKY",$("#WAREKY").val());
			param.put("CMCDKY","WAREKY"); 
		}

		return param;
	}
	
	function linkPopCloseEvent(data){  
	    if(data.get("TYPE") == "GET"){ 
	    	sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
	    }else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
// 	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
// 		if(gridId == "gridItemList"){
// 			var statit = gridList.getColData(gridId, rowNum, "STATIT");
// 			if(statit == "ARV"){
				
// 				return true;
// 			}
// 		}
// 		return false;
// 	}
	

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
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner">
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO"></select> 
						</dd> 
					</dl> 
					<dl>  <!--ASN 문서번호-->  
						<dt CL="STD_ASNDKY"></dt> 
						<dd> 
							<input type="text" class="input" name="AH.ASNDKY" UIInput="SR,SHASN"/> 
						</dd> 
					</dl> 
					<dl>  <!--ASN 생성일-->  
						<dt CL="STD_ASNDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="AH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd>  
					</dl> 
					<dl>  <!--구매오더 No-->  
						<dt CL="STD_SEBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="AI.REFDKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="AI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd>  
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="AI.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--규격-->  
						<dt CL="STD_DESC02"></dt> 
						<dd> 
							<input type="text" class="input" name="AI.DESC02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="AH.DPTNKY" UIInput="SR,SHZPTN"/> 
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
										<td GH="40"              GCol="rownum">1</td>
										<td GH="40"              GCol="rowCheck"></td>
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="120 STD_CONDAT" GCol="input,DOCDAT" GF="C">확정일자</td>	<!--확정일자-->
			    						<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="120 STD_DPTNKY" GCol="text,DPTNKY" GF="S 10">업체코드</td>	<!--업체코드-->
			    						<td GH="120 구매요청일" GCol="text,ARCPTD" GF="D 8">구매요청일</td>	<!--구매요청일-->
			    						<td GH="120 센터입고시간" GCol="text,DEPTID2" GF="T 6">센터입고시간</td>	<!--센터입고시간-->
			    						<td GH="120 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="120 STD_AUSRID1" GCol="text,USRID1" GF="S 20">차량기사명</td>	<!--차량기사명-->
			    						<td GH="120 STD_AUNAME1" GCol="text,UNAME1" GF="S 20">기사전화번호</td>	<!--기사전화번호-->
			    						<td GH="120 STD_ADEPTID1" GCol="text,DEPTID1" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="120 STD_ADNAME1" GCol="text,DNAME1" GF="S 20">출고여부</td>	<!--출고여부-->
			    						<td GH="120 센터입고일자" GCol="text,USRID2" GF="D 8">센터입고일자</td>	<!--센터입고일자-->
			    						<td GH="120 STD_AUNAME2" GCol="text,UNAME2" GF="T 6">출발시간</td>	<!--출발시간-->
			    						<td GH="120 STD_ADNAME2" GCol="text,DNAME2" GF="S 20">업무 부서명</td>	<!--업무 부서명-->
			    						<td GH="120 STD_AUSRID3" GCol="input,USRID3" GF="S 20">현장담당자</td>	<!--현장담당자-->
			    						<td GH="120 STD_AUNAME3" GCol="text,UNAME3" GF="S 20">현장담당자명</td>	<!--현장담당자명-->
			    						<td GH="120 STD_ADEPTID3" GCol="text,DEPTID3" GF="S 20">현장담당 부서</td>	<!--현장담당 부서-->
			    						<td GH="120 STD_ADNAME3" GCol="text,DNAME3" GF="S 20">현장담당 부서명</td>	<!--현장담당 부서명-->
			    						<td GH="120 STD_AUSRID4" GCol="input,USRID4" GF="S 20">현장책임</td>	<!--현장책임-->
			    						<td GH="120 STD_AUNAME4" GCol="text,UNAME4" GF="S 20">현장책임명</td>	<!--현장책임명-->
			    						<td GH="120 STD_ADEPTID4" GCol="input,DEPTID4" GF="S 50">선입고정보</td>	<!--선입고정보-->
			    						<td GH="120 STD_ADNAME4" GCol="text,DNAME4" GF="S 20">현장책임 부서명</td>	<!--현장책임 부서명-->
			    						<td GH="120 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td>	<!--입고유형명-->
			    						<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="120 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 100">업체명</td>	<!--업체명-->
<!-- 			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	생성일자 -->
<!-- 			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	생성시간 -->
<!-- 			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	생성자 -->
<!-- 			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	생성자명 -->
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
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
										<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
<!-- 			    						<td GH="120 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	로케이션 -->
			    						<td GH="100 STD_LOCAKY" GCol="text,LOCAKY" validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="120 STD_TRNUID" GCol="input,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="130 STD_LOTA05" GCol="select,LOTA05">
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td><!--포장구분-->
										<td GH="130 STD_LOTA06" GCol="select,LOTA06">
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td>	<!--재고유형-->
			    						<td GH="120 STD_LOTA11" GCol="input,LOTA11" GF="C" validate="required">제조일자</td>	<!--제조일자-->
			    						<td GH="120 STD_LOTA13" GCol="input,LOTA13" GF="C" validate="required">유통기한</td>	<!--유통기한-->
			    						<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
<!-- 			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	생성일자 -->
<!-- 			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	생성시간 -->
<!-- 			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	생성자 -->
<!-- 			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	생성자명 -->
			    						<td GH="120 STD_QTYRCV" GCol="input,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="120 STD_QTYASN" GCol="text,QTYASN" GF="N 17,0">ASN수량</td>	<!--ASN수량-->
			    						<td GH="120 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="120 STD_PBOXQTY" GCol="text,PBOXQTY" GF="N 17,1">P박스수량</td>	<!--P박스수량-->
			    						<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="120 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="120 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="120 STD_EINDT" GCol="text,LRCPTD" GF="D 8">납품요청일</td>	<!--납품요청일-->
			    						<td GH="120 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
			    						<td GH="120 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="120 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
			    						<td GH="250 STD_SBKTXT" GCol="input,SBKTXT" GF="S 100">비고</td>	<!--비고-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total" id="total"></button>
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