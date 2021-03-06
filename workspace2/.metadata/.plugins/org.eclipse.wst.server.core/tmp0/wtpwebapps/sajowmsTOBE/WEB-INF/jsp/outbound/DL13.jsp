<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL13</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "OyangSales",
		command : "DL13",
		pkcol : "MANDT,SEQNO",
	    menuId : "DL13"
    });
	
	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();

});

function searchList(){
	if(validate.check("searchArea")){
		gridList.resetGrid("gridList");
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
}

function gridListEventRowAddBefore(gridId, rowNum){
	var newData = new DataMap();
	newData.put("LANGCODE","<%=langky%>");
	newData.put("LABELTYPE","WMS");
	return newData;
}

//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
function comboEventDataBindeBefore(comboAtt, $comboObj){
	var param = new DataMap();
	if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
		param.put("DOCCAT", "200");
	}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
		var name = $($comboObj).attr("name");
		var id = $($comboObj).attr("id");
		
		if(name == "LOTA01"){
			param.put("CMCDKY", "LOTA01");	
		} else if(name == "C00102"){
			param.put("CMCDKY", "C00102");	
		}
	}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
		param.put("UROLKY", "<%=urolky%>");
		
		return param;
	}
	return param;
}

function saveData(){
	if(gridList.validationCheck("gridList", "data")){
		var json = gridList.gridSave({
	    	id : "gridList",
	    	modifyType : 'A'
	    });
	
		if(json && json.data){
			if(json.data > 0){
				searchList();
			}
		}
	}
}



function successSaveCallBack(json, status){
	if(json && json.data){
		if(json.data == "OK"){
			commonUtil.msgBox("SYSTEM_SAVEOK");
			searchList();
		}
	}
}

function reloadLabel(){
	netUtil.send({
		url : "/common/label/json/reload.data"
	});
}

function commonBtnClick(btnName){
	if(btnName == "Search"){
		searchList();
	}else if(btnName == "Save"){
		saveData();
	}else if(btnName == "Reload"){
		reloadLabel();
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "DL13");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "DL13");
	}
}

function linkPopCloseEvent(data){//팝업 종료 
	if(data.get("TYPE") == "GET"){ 
		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
		sajoUtil.setLayout(data); //팝업 데이터 적용
	}
}

//서치헬프 기본값 세팅
function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
    var param = new DataMap();

    //소분류
	if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
	          param.put("CMCDKY","SKUG03");
	          param.put("OWNRKY","<%=ownrky %>");
	}
	return param;
}

</script>
</head>
<body>
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
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
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_FLADODR"></dt><!--첨부파일포함주문만 조회-->
							<!-- 구버전 VALUE : 첨부파일포함주문만 조회 -->
							<dd>
								<input type="checkbox" class="input" name="CHKMAK" checked/> <!-- IBATIS ISEQUAL 구분자  -->
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_SVBELN"></dt><!--S/O번호-->
							<dd>
								<input type="text" class="input" name="I.SVBELN" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_VDATU"></dt><!--납품요청일-->
							<dd>
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N" />
							</dd>
						</dl>
						<dl>
							<dt CL="ITF_PTNRTO"></dt><!--납품처코드-->
							<dd>
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_SKUKEY"></dt><!--제품코드-->
							<dd>
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUG03"></dt><!--소분류-->
							<dd>
								<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
											<td GH="40" GCol="rowCheck"></td>
								            <td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
								            <td GH="200 STD_SENDNM" GCol="text,SENDNM" GF="S 40">발송인</td> <!--발송인-->
								            <td GH="80 STD_SENDAD" GCol="text,SENDAD" GF="S 40">발송인주소</td> <!--발송인주소-->
								            <td GH="120 STD_SENDTL1" GCol="text,SENDTL1" GF="S 40">발송인전화번호(1)</td> <!--발송인전화번호(1)-->
								            <td GH="120 STD_SENDTL2" GCol="text,SENDTL2" GF="S 40">발송인전화번호(2)</td> <!--발송인전화번호(2)-->
								            <td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
								            <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
								            <td GH="200 STD_DESCBX" GCol="text,DESC02" GF="S 200">택배상품명(박스세트)</td> <!--택배상품명(박스세트)-->
								            <td GH="80 RL23_QTDUOM" GCol="text,QTDUOM" GF="N 20">박스입수</td> <!--박스입수-->
								            <td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13">납품요청수량</td> <!--납품요청수량-->
								            <td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 13,1">박스,ea</td> <!--박스수량-->
								            <td GH="80 STD_QTYPRE1" GCol="text,QTYPRE" GF="N 13">송장수량</td> <!--송장수량-->
								            <td GH="80 STD_CTNAME" GCol="text,CTNAME" GF="S 50">수령인</td> <!--수령인-->
								            <td GH="80 STD_CUNATN" GCol="text,CUNATN" GF="S 50">실제주문자</td> <!--실제주문자-->
								            <td GH="400 STD_CUADDR0" GCol="text,CUADDR" GF="S 60">수령인 주소</td> <!--수령인 주소-->
								            <td GH="120 STD_CTTEL1" GCol="text,CTTEL1" GF="S 20">수령인전화번호(1)</td> <!--수령인전화번호(1)-->
								            <td GH="120 STD_CTTEL2" GCol="text,CTTEL2" GF="S 20">수령인전화번호(2)</td> <!--수령인전화번호(2)-->
								            <td GH="80 STD_OTRQDT" GCol="text,OTRQDT" GF="D 20">출고요청일</td> <!--출고요청일-->
								            <td GH="80 ITF_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
								            <td GH="100 ITF_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
								            <td GH="80 STD_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td> <!--비고-->
								            <td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td> <!--영업사원명-->
								            <td GH="80 IFT_C00102" GCol="text,C00102" GF="S 10">승인여부</td> <!--승인여부-->
								            <td GH="200 STD_GUBUN" GCol="text,IFFLG" GF="S 10">구분</td> <!--구분-->
								            <td GH="80 STD_ERDAT" GCol="text,XDATS" GF="D 10">지시일자</td> <!--지시일자-->
								            <td GH="80 STD_RQARRT" GCol="text,XTIMS" GF="T 10">지시시간</td> <!--지시시간-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<!-- <button type='button' GBtn="add"></button>
							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>