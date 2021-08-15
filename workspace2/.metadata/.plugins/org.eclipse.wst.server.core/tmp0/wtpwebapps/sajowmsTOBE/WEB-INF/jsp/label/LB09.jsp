
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LB09</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "LabelPrint",
			command : "LB09",
			menuId : "LB09"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();		
		
		$("#WAREKY").val("<%=wareky%>");
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });				
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
 		newData.put("OWNER","OWNRKY");		
		gridList.setColFocus(gridId, rowNum, "WAREKY");		
		return newData;
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 화주선택 후 거점으로 자동선택
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if(comboAtt == "SajoCommon,WAREKY_COMCOMBO"){
			param.put("OWNRKY","<%=ownrky%>");
		}
		return param;
	}
	
	
	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	 
		
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "LB09");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "LB09");
 		}
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //제품코드
        if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
    	return param;
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
	<div class="content_inner" style="padding: 5px 30px 55px;">
		<%@ include file="/common/include/webdek/title.jsp" %>
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
			<div class="search_inner"> <!-- LB09 팔레트 바코드 출력이력 --> 
				<div class="search_wrap" > 
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false" validate="required(STD_WAREKY)">
							</select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_REFDKY"></dt> <!-- 참조문서번호 -->
						<dd>
							<input type="text" class="input" name="BARCD.REFDKY" id="REFDKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_BARCOD"></dt> <!-- 바코드 -->
						<dd>
							<input type="text" class="input" name="BARCD.BARCOD" id="BARCOD" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="BARCD.SKUKEY" id="SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="BARCD.DESC01" id="DESC01" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CREDAT"></dt> <!-- 출력일자 -->
						<dd>
							<input type="text" class="input" name="BARCD.CREDAT" id="CREDAT" UIInput="R" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CREUSR"></dt> <!-- 생성자 -->
						<dd>
							<input type="text" class="input" name="BARCD.CREUSR" id="CREUSR" UIInput="SR" />
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
					<li><a href="#tab1-1" ><span>일반</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true"> 
									<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
									<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="N 0,0">참조문서번호</td> <!--참조문서번호-->
									<td GH="120 STD_FS_SKU_HDR1_1" GCol="text,BARCOD" GF="S 20">바코드</td> <!--바코드-->
									<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
									<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 50">제품코드</td> <!--제품코드-->
									<td GH="100 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
									<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td> <!--규격-->
									<td GH="80 STD_PRTDAT" GCol="text,PRTDAT" GF="S 40">인쇄일자</td> <!--인쇄일자-->
									<td GH="50 STD_QTDUOM" GCol="text,QTDUOM" GF="N 15,0">입수</td> <!--입수-->
									<td GH="80 STD_QTYBOX" GCol="text,QTDBOX" GF="N 15,1">수량(BOX)</td> <!--수량(BOX)-->
									<td GH="80 STD_REMQTY" GCol="text,QTDREM" GF="N 15,0">잔량</td> <!--잔량-->
									<td GH="80 STD_QTDPRT" GCol="text,QTDPRT" GF="N 15,0">총수량</td> <!--총수량-->
									<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td> <!--포장구분-->
									<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 10">제조일자</td> <!--제조일자-->
									<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 10">유통기한</td> <!--유통기한-->
									<td GH="80 STD_DPTNKY" GCol="text,LOTA03" GF="S 20">업체코드</td> <!--업체코드-->
									<td GH="100 STD_DPTNKYNM" GCol="text,LOTA03NM" GF="S 180">업체명</td> <!--업체명-->
									<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
									<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td> <!--생성시간-->
									<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
									<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td> <!--생성자명-->
									<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td> <!--수정일자-->
									<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td> <!--수정시간-->
									<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td> <!--수정자-->
									<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td> <!--수정자명-->
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
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>