<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL33</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList",
		module : "OutBoundReport",
		command : "DL33",
		pkcol : "OWNRKY, SKUKEY",
		totalShow : true,
		menuId : "DL33"
    });
	
	//OTRQDT 하루 더하기 
	inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));   //toval

	//배열선언
	var rangeArr = new Array();
	//배열내 들어갈 데이터 맵 선언
	var rangeDataMap = new DataMap();
	// 필수값 입력
	rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
	rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
	//배열에 맵 탑제 
	rangeArr.push(rangeDataMap);
	
	setSingleRangeData('S.LOCAKY', rangeArr);

	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();
});

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
		gridList.resetGrid("gridList");
		var param = inputList.setRangeParam("searchArea");
	
		if($('#CHKMAK').prop("checked") == false){
			param.put("CHKMAK","");
		}else if($('#CHKMAK').prop("checked") == true){
			param.put("CHKMAK","on");
		}

		netUtil.send({
			url : "/OutBoundReport/json/displayDL33.data",
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
		sajoUtil.openSaveVariantPop("searchArea", "DL33");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "DL33");
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

    //로케이션
	if(searchCode == "SHLOCMA"){
	          param.put("WAREKY","<%=wareky %>");
	//제품코드
	} else if(searchCode == "SHSKUMA" && $inputObj.name == "I.SKUKEY"){
        param.put("WAREKY","<%=wareky %>");
        param.put("OWNRKY","<%=ownrky %>");
    //소분류
	} else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
        param.put("CMCDKY","SKUG03");
        param.put("OWNRKY","<%=ownrky %>");
    //중분류
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
        param.put("CMCDKY","SKUG02");
   		param.put("OWNRKY","<%=ownrky %>");
   	//요청사업장
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
        param.put("CMCDKY","PTNG05");
    	param.put("OWNRKY","<%=ownrky %>");
  	//제품용도
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
        param.put("CMCDKY","SKUG05");
    	param.put("OWNRKY","<%=ownrky %>");
    //주문구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
        param.put("CMCDKY","PGRC03");
    	param.put("OWNRKY","<%=ownrky %>");
    //배송구분
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
        param.put("CMCDKY","PGRC02");
    	param.put("OWNRKY","<%=ownrky %>");
    //거래처 그룹1
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ.PTNG01"){
        param.put("CMCDKY","PTNG01");
    	param.put("OWNRKY","<%=ownrky %>");
    //거래처 그룹2
	}else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ.PTNG02"){
        param.put("CMCDKY","PTNG02");
    	param.put("OWNRKY","<%=ownrky %>");
    //납품처코드
	}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
        param.put("PTNRTY","0007");
        param.put("OWNRKY","<%=ownrky %>");
    //매출처코드
	}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
        param.put("PTNRTY","0001");
        param.put("OWNRKY","<%=ownrky %>");
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
							<dt CL="STD_ALSUSH"></dt><!--전체제품조회 -->
							<!-- 구버전 VALUE : 전체제품조회 -->
							<dd>
								<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" checked />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_ORDTYP"></dt><!--주문/출고형태-->
							<dd>
								<input type="text" class="input" name="I.ORDTYP" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_ORDDAT"></dt><!--출고일자-->
							<dd>
								<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_OTRQDT"></dt><!--출고요청일-->
							<dd>
								<input type="text" class="input" name="I.OTRQDT"  UIInput="B" UIFormat="C" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_SVBELN"></dt><!--S/O번호-->
							<dd>
								<input type="text" class="input" name="I.SVBELN" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_DOCUTY"></dt><!--출고유형-->
							<dd>
								<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_IFPGRC04"></dt><!--요청사업장-->
							<dd>
								<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_IFPGRC04N"></dt><!--요청사업장명 WARESRNM-->
							<dd>
								<input type="text" class="input" name="NVL(TRIM(WH.NAME01),BZ.NAME01)" UIInput="SR" />
							</dd>
						</dl>
						<dl>
							<dt CL="ITF_PTNRTO"></dt><!--납품처코드-->
							<dd>
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_PTNROD"></dt><!--매출처코드-->
							<dd>
								<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_SKUKEY"></dt><!--제품코드-->
							<dd>
								<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUG05"></dt><!--제품용도-->
							<dd>
								<input type="text" class="input" name="S.SKUG05" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_DIRSUP"></dt><!--주문구분-->
							<dd>
								<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DIRDVY"></dt><!--배송구분-->
							<dd>
								<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="IFT_QTYORG"></dt><!--원주문수량-->
							<dd>
								<input type="text" class="input" name="I.QTYORG" UIInput="SR" UIFormat="N 15" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_PTNG01_G1"></dt><!--거래처 그룹1-->
							<dd>
								<input type="text" class="input" name="BZ.PTNG01" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_PTNG01_G2"></dt><!--거래처 그룹2-->
							<dd>
								<input type="text" class="input" name="BZ.PTNG02" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUG02"></dt><!--중분류-->
							<dd>
								<input type="text" class="input" name="S.SKUG02" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUG03"></dt><!--소분류-->
							<dd>
								<input type="text" class="input" name="S.SKUG03" UIInput="SR,SHCMCDV" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_LOTA05"></dt><!--포장구분-->
							<dd>
								<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_LOTA06"></dt><!--재고유형-->
							<dd>
								<input type="text" class="input" name="S.LOTA06" id="S.LOTA06" UIInput="SR,SHLOTA06" value="00" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_LOCAKY"></dt><!--로케이션-->
							<dd>
								<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" />
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
											<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
									        <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
									        <td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
									        <td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
									        <td GH="120 STD_QTYPREB" GCol="text,QTYPRE" GF="N 80,1">선입고수량(BOX)</td> <!--선입고수량(BOX)-->
									        <td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!--박스입수-->
									        <td GH="100 STD_BOXQTYR1" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td> <!--주문내역(BOX)-->
									        <td GH="100 STD_QTSIWHR1" GCol="text,QTSIWH1" GF="N 80,0">주문내역(낱개)</td> <!--주문내역(낱개)-->
									        <td GH="150 STD_BOXQTYR2" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고수량(BOX)</td> <!--출고가능재고수량(BOX)-->
									        <td GH="150 STD_QTSIWHR2" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고수량(낱개)</td> <!--출고가능재고수량(낱개)-->
									        <td GH="150 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td> <!--부족수량(BOX)-->
									        <td GH="150 STD_QTSIWHR3" GCol="text,QTSIWH3" GF="N 80,0">부족수량(낱개)</td> <!--부족수량(낱개)-->
									        <td GH="150 STD_BOXQTYR4" GCol="text,BOXQTY4" GF="N 80,1">입고예정수량(BOX)</td> <!--입고예정수량(BOX)-->
									        <td GH="150 STD_QTSIWHR4" GCol="text,QTSIWH4" GF="N 80,0">입고예정수량(낱개)</td> <!--입고예정수량(낱개)-->
									        <td GH="150 STD_BOXQTYR5" GCol="text,BOXQTY5" GF="N 80,1">이고입고예정수량(BOX)</td> <!--이고입고예정수량(BOX)-->
									        <td GH="150 STD_QTSIWHR5" GCol="text,QTSIWH5" GF="N 80,0">이고입고예정수량(낱개)</td> <!--이고입고예정수량(낱개)-->
									        <td GH="100 STD_BOXQTYR6" GCol="text,BOXQTY6" GF="N 80,1">보류수량(BOX)</td> <!--보류수량(BOX)-->
									        <td GH="100 STD_QTSIWHR6" GCol="text,QTSIWH6" GF="N 80,0">보류수량(낱개)</td> <!--보류수량(낱개)-->
									        <td GH="100 STD_BOXQTYR7" GCol="text,BOXQTY7" GF="N 80,1">미적치수량(BOX)</td> <!--미적치수량(BOX)-->
									        <td GH="100 STD_QTSIWHR7" GCol="text,QTSIWH7" GF="N 80,0">미적치수량(낱개)</td> <!--미적치수량(낱개)-->
									        <td GH="100 STD_BOXQTYR8" GCol="text,BOXQTY8" GF="N 80,1">발주수량(BOX)</td> <!--발주수량(BOX)-->
									        <td GH="100 STD_QTSIWHR8" GCol="text,QTSIWH8" GF="N 80,0">발주수량(낱개)</td> <!--발주수량(낱개)-->
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