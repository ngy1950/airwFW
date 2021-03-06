<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR10</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "Daerim",
		command : "DR10",
		pkcol : "MANDT, SEQNO",
	    menuId : "DR10"
    });
	gridList.setReadOnly("gridList", true, ["WAREKY","WARESR","DOCUTY","PTNG08","DIRSUP","DIRDVY","SKUG03","PICGRP","C00103"]);
	
	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();

});

function searchList(){
	if(validate.check("searchArea")){
		gridList.resetGrid("gridList");
		var param = inputList.setRangeParam("searchArea");
		
		if(inputList.rangeMap.map['IT.WAREKY'].singleData && inputList.rangeMap.map['IT.WAREKY'].singleData.length > 0 ){
			param.put("WAREKY",inputList.rangeMap.map['IT.WAREKY'].singleData[0].map.DATA);
		}

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
	if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
        param.put("DOCCAT", "300");
        param.put("DOCUTY", "399");
        param.put("DIFLOC", "1");
        param.put("OWNRKY", $("#OWNRKY").val());
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
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "DR10");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "DR10");
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

	//마감구분
	if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG08"){
        param.put("CMCDKY","PTNG08");
    	param.put("OWNRKY","<%=ownrky %>");  
	//제품구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU04"){
        param.put("CMCDKY","ASKU04");
    	param.put("OWNRKY","<%=ownrky %>");  
	//상온구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
        param.put("CMCDKY","ASKU05");
    	param.put("OWNRKY","<%=ownrky %>");  
	//주문구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
        param.put("CMCDKY","PGRC03");
    	param.put("OWNRKY","<%=ownrky %>");  
	//로케이션
    } else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){
	    param.put("WAREKY","<%=wareky %>");	
	} return param;
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
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>  <!--거점-->  
						<dt CL="STD_WAREKY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.WAREKY" id="WAREKY"  UIInput="SR,SHWAHMA" value="<%=wareky%>"/>
						</dd> 
					</dl>  
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt>
						<dd> 
							<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="STD_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG08" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl>
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUKEY" UIInput="SR,SHSKUMA" /> 
						</dd> 
					</dl>
					<dl>  <!--제품구분-->  
						<dt CL="STD_SKUTYP"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU04" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl>
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SW.LOCARV" UIInput="SR,SHLOCMA"/> 
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
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rowCheck"></td>
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
											<td GH="200 STD_WAREKY" GCol="select,WAREKY">
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select> <!--거점-->
											</td>
											<td GH="130 STD_PTNG05" GCol="select,WARESR">
												<select class="input" commonCombo="PTNG06"><option></option></select> <!--지점사업장-->
											</td>
											<td GH="120 STD_DOCUTY" GCol="select,DOCUTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"> </select>	 <!--출고유형-->
											</td>
											<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 20">출고요청일</td> <!--출고요청일-->
											<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10">납품처코드</td> <!--납품처코드-->
											<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 150">납품처명</td> <!--납품처명-->
											<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td> <!--매출처코드-->
											<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 200">매출처명</td> <!--매출처명-->
											<td GH="100 STD_PTNG08" GCol="select,PTNG08">
												<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
											</td> 
											<td GH="100 STD_PGRC03" GCol="select,DIRSUP">
												<select class="input" commonCombo="PGRC03"></select>	<!--주문구분-->
											</td>
											<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">	<!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
			    							</td>
											<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
											<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
											<td GH="70 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td> <!--규격-->
											<td GH="150 STD_SKUG03" GCol="select,SKUG03">
												<select class="input" commonCombo="SKUG03"></select>	<!--소분류-->
											</td> 
											<td GH="120 STD_PICGRP" GCol="select,PICGRP">
												<select class="input" commonCombo="PICGRP"></select>	<!--피킹그룹-->
											</td>
											<td GH="80 STD_NETWGTKg" GCol="text,NETWGT" GF="S 10"></td> <!--순중량(kg)-->
											<td GH="70 STD_BXIQTY" GCol="text,QTDUOM" GF="N 100,0">박스입수</td> <!--박스입수-->
											<td GH="70 IFT_QTYORG" GCol="text,QTYORG" GF="N 100,0">요청수량</td> <!--요청수량-->
											<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 100,0">납품요청수량</td> <!--납품요청수량-->
											<td GH="70 미출수량" GCol="text,QTYREQ2" GF="N 100,0">미출수량</td> <!--미출수량-->
											<td GH="70 미출중량" GCol="text,QTYWGT2" GF="N 20,2">미출중량</td> <!--미출중량-->
											<td GH="200 미출사유" GCol="select,C00103">	
												<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>	<!--미출사유-->
											</td>
											<td GH="80 STD_LMOUSR" GCol="text,USRID2" GF="S 20">수정자</td> <!--수정자-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
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