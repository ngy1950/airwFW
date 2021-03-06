<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL98</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "OutBoundReport",
		command : "DL98",
		pkcol : "SHPOKY",,
		menuId : "DL98"
    });
	
	
	//CARDAT 하루 더하기 
	inputList.rangeMap["map"]["DR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
	
	gridList.setReadOnly("gridList", true, ["DIRSUP"]);
	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();

});


function searchList(){
	if(validate.check("searchArea")){
		gridList.resetGrid("gridList");
		var param = inputList.setRangeParam("searchArea");

		//gridList.gridList 대체 
		netUtil.send({
			url : "/OutBoundReport/json/displayDL98.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridList" //그리드ID
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
		sajoUtil.openSaveVariantPop("searchArea", "DL98");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "DL98");
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
    

	//납품처코드
	if(searchCode == "SHBZPTN" && $inputObj.name == "DH.DPTNKY"){
        param.put("PTNRTY","0007");
        param.put("OWNRKY","<%=ownrky %>");
    //매출처코드
	}else if(searchCode == "SHBZPTN" && $inputObj.name == "DH.PTRCVR"){
        param.put("PTNRTY","0001");
        param.put("OWNRKY","<%=ownrky %>");	
	//요구사업장
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC04"){
    	param.put("CMCDKY","PTNG05");
		param.put("OWNRKY","<%=ownrky %>");
	//주문구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC03"){
        param.put("CMCDKY","PGRC03");
    	param.put("OWNRKY","<%=ownrky %>"); 
	//배송구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "DH.PGRC02"){
        param.put("CMCDKY","PGRC02");
    	param.put("OWNRKY","<%=ownrky %>");   
	//세트여부
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU02"){
        param.put("CMCDKY","ASKU02");
    	param.put("OWNRKY","<%=ownrky %>");   
    //권역사업장
	} else if(searchCode == "SHWAHMA"){
    	param.put("NOBIND","Y");  
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" /></div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Reload RESET STD_REFLBL" />
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
							<dt CL="STD_SHPOKY"></dt><!--출고문서번호-->
							<dd>
								<input type="text" class="input" name="DH.SHPOKY" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_RQARRD"></dt><!--주문일자-->
							<dd>
								<input type="text" class="input" name="DH.RQARRD" UIInput="B" UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_OTRQDT"></dt><!--출고요청일-->
							<dd>
								<input type="text" class="input" name="DH.RQSHPD" UIInput="B" UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_CARDAT"></dt><!--배송일자-->
							<dd>
								<input type="text" class="input" name="DR.CARDAT" UIInput="B" UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SOGUBN"></dt><!--오더구분-->
							<dd>
								<select name="SOGUBN" id="SOGUBN" class="input" CommonCombo="SOGUBN" ></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SVBELN"></dt><!--S/O번호-->
							<dd>
								<input type="text" class="input" name="DI.SVBELN" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DOCUTY"></dt><!--출고유형-->
							<dd>
								<input type="text" class="input" name="DH.DOCUTY" UIInput="SR,SHDOCTMIF" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SHIPSQ"></dt><!--배송차수-->
							<dd>
								<input type="text" class="input" name="DR.SHIPSQ" UIInput="SR"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_CARNUM"></dt><!--차량번호-->
							<dd>
								<input type="text" class="input" name="DR.CARNUM" UIInput="SR"/>
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_PTNRTO"></dt><!--납품처코드-->
							<dd>
								<input type="text" class="input" name="DH.DPTNKY" UIInput="SR,SHBZPTN"/>
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_PTNROD"></dt><!--매출처코드-->
							<dd>
								<input type="text" class="input" name="DH.PTRCVR" UIInput="SR,SHBZPTN"/>
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_WARESR"></dt><!--요구사업장-->
							<dd>
								<input type="text" class="input" name="DH.PGRC04" UIInput="SR,SHCMCDV"/>
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_WARESRNM"></dt><!--요구사업장명-->
							<dd>
								<input type="text" class="input" name="SA.NAME01" UIInput="SR"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUKEY"></dt><!--제품코드-->
							<dd>
								<input type="text" class="input" name="DI.SKUKEY" UIInput="SR,SHSKUMA"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DESC01"></dt><!--제품명-->
							<dd>
								<input type="text" class="input" name="SM.DESC01" UIInput="SR"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_PGRC03"></dt><!--주문구분-->
							<dd>
								<input type="text" class="input" name="DH.PGRC03" UIInput="SR,SHCMCDV"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DIRDVY"></dt><!--배송구분-->
							<dd>
								<input type="text" class="input" name="DH.PGRC02" UIInput="SR,SHCMCDV"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WEGWRK"></dt><!--권역사업장-->
							<dd>
								<input type="text" class="input" name="BZ.NAME03" UIInput="SR,SHWAHMA"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_ASKU02"></dt><!--세트여부-->
							<dd>
								<input type="text" class="input" name="SM.ASKU02" UIInput="SR,SHCMCDV"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_UNAME4"></dt><!--영업사원명-->
							<dd>
								<input type="text" class="input" name="DH.UNAME4" UIInput="SR"/>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DNAME4"></dt><!--영업사원연락처-->
							<dd>
								<input type="text" class="input" name="DH.DNAME4" UIInput="SR"/>
							</dd>
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
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
											<!-- <td GH="40" GCol="rowCheck"></td> -->
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
											<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
											<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
											<td GH="120 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
											<td GH="120 STD_SHPOKY" GCol="text,SHPOKY" GF="S 40">출고문서번호</td> <!--출고문서번호-->
											<td GH="80 STD_POSTCD" GCol="text,POSTCD" GF="S 30">우편번호  </td> <!--우편번호  -->
											<td GH="80 매출처코드" GCol="text,DPTNKY" GF="S 20">매출처코드</td> <!--매출처코드-->
											<td GH="100 매출처명" GCol="text,DPTNKYNM" GF="S 20">매출처명</td> <!--매출처명-->
											<td GH="80 납품처코드" GCol="text,PTRCVR" GF="S 20">납품처코드</td> <!--납품처코드-->
											<td GH="100 납품처명" GCol="text,PTRCVRNM" GF="S 20">납품처명</td> <!--납품처명-->
											<td GH="80 IFT_WARESRC" GCol="text,PGRC04" GF="S 20">요구사업장</td> <!--요구사업장-->
											<td GH="80 IFT_WARESRN" GCol="text,PGRC04NM" GF="S 20">요구사업장명</td> <!--요구사업장명-->
											<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
											<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
											<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 80,0">지시수량</td> <!--지시수량-->
											<!-- <td GH="80 지시수량(BOX)" GCol="text,BOXHPO" GF="N 80,1">지시수량(BOX)</td> 지시수량(BOX) -->
											<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 80,0">할당수량</td> <!--할당수량-->
											<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 80,0">출고수량</td> <!--출고수량-->
											<!-- <td GH="80 출고수량(PLT)" GCol="text,PLTHPD" GF="N 80,0">출고수량(PLT)</td> 출고수량(PLT) -->
											<td GH="80 STD_ADJQTY" GCol="text,QTYREF" GF="N 80,0">조정수량</td> <!--조정수량-->
											<td GH="85 STD_QTYCAL6" GCol="text,QTYCAL" GF="N 80,0">최종수량(낱개)</td> <!--최종수량(낱개)-->
											<!-- <td GH="80 최종수량(BOX)" GCol="text,BOXCAL" GF="N 80,1">최종수량(BOX)</td> 최종수량(BOX) -->
											<td GH="160 STD_CARNUM" GCol="text,CARNUM" GF="S 50">차량번호</td> <!--차량번호-->
											<td GH="75 STD_RECNUM" GCol="text,RECNUM" GF="S 50">재배차 차량번호</td> <!--재배차 차량번호-->
											<td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 1000">비고</td> <!--비고-->
											<td GH="100 IFT_DIRSUP" GCol="select,DIRSUP">
												<select class="input" CommonCombo="PGRC03"><!--주문구분-->
											</td>
											<td GH="200 STD_ADDR01" GCol="text,ADDR01" GF="S 1000">주소</td> <!--주소-->
											<td GH="50 STD_QTDUOM" GCol="text,QTDUOM" GF="N 80,0">입수</td> <!--입수-->
											<td GH="50 IFT_SALEPR" GCol="text,PRC" GF="S 80,0">공급단가</td> <!--공급단가-->
											<td GH="80 STD_SBWART" GCol="text,SBWART" GF="S 80">영업오더유형</td> <!--영업오더유형-->
											<td GH="80 STD_RQARRD" GCol="text,RQARRD" GF="D 80">주문일자</td> <!--주문일자-->
											<td GH="80 STD_RQSHPD" GCol="text,RQSHPD" GF="D 80">출고요청일자</td> <!--출고요청일자-->
											<td GH="80 STD_CHKSEQ" GCol="text,NO" GF="S 80">검수번호</td> <!--검수번호-->
											<td GH="200 STD_UNAME1" GCol="text,UNAME01" GF="S 1000">배송지주소</td> <!--배송지주소-->
											<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td> <!--배송일자-->
											<td GH="80 STD_BNAME" GCol="text,UNAME4" GF="S 80">영업사원명</td> <!--영업사원명-->
											<td GH="100 STD_BPHON" GCol="text,DNAME4" GF="S 80">영업사원전화번호</td> <!--영업사원전화번호-->
											<!-- <td GH="80 지시일자" GCol="text,LMODAT" GF="S 80">지시일자</td> 지시일자 -->
											<td GH="100 STD_USRID1" GCol="text,USRID1" GF="S 80">배송지우편번호</td> <!--배송지우편번호-->
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