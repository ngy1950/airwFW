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
var tabgbn = 1,searchchk = true;
var rangeparam;
	$(document).ready(function(){
		
		gridList.setGrid({
	    	id : "gridItemList1",
	    	module : "SajoInbound",
			command : "GR21_TAB1_ITEM",
			totalView : true,
			menuId : "GR21"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList2",
	    	module : "SajoInbound2",
			command : "GR21_TAB2_ITEM",
			menuId : "GR21"
			
	    });
		
		$('[name = CHKMAK]').on('click', function() {
			if(!triggerchk){
				triggerchk = true;
				return;
			}
			
		    var valueCheck = $('[name = CHKMAK]:checked').val();
		    searchchk = false;
		    if(valueCheck == "Op1"){
		    	tabgbn = 1;
		    	$("#atab2-1").trigger("click");
		    }else if(valueCheck == "Op2"){
		    	tabgbn = 2;
		    	$("#atab2-2").trigger("click");
		    }
		});

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			rangeparam = inputList.setRangeDataParam("searchArea");
			rangeparam.put("GBN",tabgbn);
		
			netUtil.send({
				url : "/SajoInbound/json/displayGR21Item.data",
				param : rangeparam,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList"+tabgbn //그리드ID
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridHeadList" && dataCount == 0){

		}else if(gridId == "gridHeadList" && dataCount > 0){
			if(!gridList.gridMap.get("gridHeadList").totalView){
				$('#total').trigger("click");	
			}
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridItemList1"){
			var poclos = gridList.getColData(gridId, rowNum, "POCLOS");
			if(poclos == "V"){
				gridList.setRowReadOnly(gridId, rowNum, true);
				return true;
			}
		}
		return false;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
			
			if(name == "POCLOS"){
				param.put("CMCDKY", "POCLOS");
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList1", "select")){
			if(tabgbn == "2"){
				commonUtil.msgBox("이고 오더는 P/O마감할 수 없습니다.");
				return;
			}
			
			
			var list = gridList.getSelectData("gridItemList1", true);
			
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
	
			var param = new DataMap();
			param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/SajoInbound/json/saveGR21.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR21");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR21");
		}
	}
	
	var triggerchk = true;
	function moveTab(obj){
			
    	if(obj.attr('href') == '#tab2-1'){
    		tabgbn = 1;
    		if(searchchk){
    			$("#Op"+tabgbn).attr('checked', true);
    		}	
    	}else if(obj.attr('href') == '#tab2-2'){
    		tabgbn = 2;
    		if(searchchk){
    			$("#Op"+tabgbn).attr('checked', true);
    		}	
    	}
    	
    	if(searchchk){
			triggerchk = false;
			if(tabgbn == 1){
				$("#Op2").attr('checked', false);
				$("#Op1").attr('checked', true);
				$("#Op1").trigger("click");
			}else{
				$("#Op1").attr('checked', false);
				$("#Op2").attr('checked', true);
				$("#Op2").trigger("click");
			}
		}else{
			if(tabgbn == 1){
				$("#Op2").attr('checked', false);
				$("#Op1").attr('checked', true);
			}else{
				$("#Op1").attr('checked', false);
				$("#Op2").attr('checked', true);
			}
		}
    	
    	if(searchchk){
			searchList();
		}else{
			searchchk = true;
		}
		
    	
	}
	
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_POCLOS" />
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl> 
					
						<dt CL="오더 검색조건"></dt><!-- 구분자 -->
						<dd style="width:300px">
							<input type="radio" name="CHKMAK" id="Op1" value="Op1" checked /><label for="Op1">구매오더</label>
		        			<input type="radio" name="CHKMAK" id="Op2" value="Op2" /><label for="Op2">이고오더</label>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_POCLOS"></dt>
						<dd>
							<select name="POCLOS" class="input" Combo="SajoCommon,CMCDV_COMBO"></select>
						</dd>
					</dl>
					
					<dl>  <!--구매오더 No-->  
						<dt CL="STD_SEBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.SEBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품요청일-->  
						<dt CL="STD_EINDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.DLVDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--P/O 생성일자-->  
						<dt CL="STD_BUYCDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.BUYCDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--P/O 변경일자-->  
						<dt CL="STD_BUYLMO"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.BUYLMO" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.SKUKEY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.PTNRKY" UIInput="SR"/> 
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
					<li><a href="#tab2-1" onclick="moveTab($(this));"><span id="atab2-1">구매오더 item 리스트</span></a></li>
					<li><a href="#tab2-2" onclick="moveTab($(this));"><span id="atab2-2">이고오더 item 리스트</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList1">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="120 STD_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">발주 Seq</td>	<!--발주 Seq-->
			    						<td GH="120 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 20">B/L NO</td>	<!--B/L NO-->
			    						<td GH="120 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 20">B/L Item NO</td>	<!--B/L Item NO-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="120 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="120 STD_POIQTY" GCol="text,POIQTY" GF="N 17,0">P/O수량</td>	<!--P/O수량-->
			    						<td GH="120 STD_QTYASN" GCol="text,QTYASN" GF="N 17,0">ASN수량</td>	<!--ASN수량-->
			    						<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="120 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
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
			    						<td GH="120 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="120 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	<!--Client-->
			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="120 STD_SBKTXT" GCol="text,SBKTXT" GF="S 100">비고</td>	<!--비고-->
<!-- 			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	생성일자 -->
<!-- 			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	생성시간 -->
			    						<td GH="120 STD_EINDT" GCol="text,LRCPTD" GF="D 8">납품요청일</td>	<!--납품요청일-->
			    						<td GH="120 STD_POCLOS" GCol="text,POCLOS" GF="S 100">P/O마감여부</td>	<!--P/O마감여부-->		
			    						<td GH="120 STD_DPTNKY" GCol="text,DPTNKY" GF="S">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S">업체코드명</td>	<!--업체코드명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->							
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
				
				
				<div class="table_box section" id="tab2-2" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList2">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
<!-- 			    						<td GH="40" GCol="rowCheck"></td> -->
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="120 STD_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">발주 Seq</td>	<!--발주 Seq-->
<!-- 			    						<td GH="120 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 20">B/L NO</td>	B/L NO -->
<!-- 			    						<td GH="120 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 20">B/L Item NO</td>	B/L Item NO -->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
<!-- 			    						<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	단위 -->
<!-- 			    						<td GH="120 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	단위 -->
			    						<td GH="120 STD_POIQTY" GCol="text,POIQTY" GF="N 17,0">P/O수량</td>	<!--P/O수량-->
<!-- 			    						<td GH="120 STD_QTYASN" GCol="text,QTYASN" GF="N 17,0">ASN수량</td>	ASN수량 -->
			    						<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="120 이고입고중" GCol="text,QTYIGO" GF="N 17,0">이고입고중</td>	<!--이고입고중-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="120 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
<!-- 			    						<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	포장중량 -->
<!-- 			    						<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	순중량 -->
<!-- 			    						<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	중량단위 -->
<!-- 			    						<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	포장가로 -->
<!-- 			    						<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	포장세로 -->
<!-- 			    						<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	포장높이 -->
<!-- 			    						<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	CBM -->
<!-- 			    						<td GH="120 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	CAPA -->
<!-- 			    						<td GH="120 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	Client -->
<!-- 			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	구매오더 No -->
			    						<td GH="120 STD_SBKTXT" GCol="text,SBKTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_EINDT" GCol="text,LRCPTD" GF="D 8">납품요청일</td>	<!--납품요청일-->
			    						<td GH="120 STD_POCLOS" GCol="text,POCLOS" GF="S 100">P/O마감여부</td>	<!--P/O마감여부-->			
			    						<td GH="120 STD_DPTNKY" GCol="text,DPTNKY" GF="S">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S">업체코드명</td>	<!--업체코드명-->
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