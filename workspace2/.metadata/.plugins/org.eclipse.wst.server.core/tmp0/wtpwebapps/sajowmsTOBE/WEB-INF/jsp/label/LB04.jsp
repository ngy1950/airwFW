
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LB04</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "LabelPrint",
			command : "LB04",
			menuId : "LB04"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
				param.put("NORMAL","Y");
				param.put("NORMAL","N");

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
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	
		
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
			}
		}
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
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "LB04");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "LB04");
 		}
	}
	
	
	//ezgen 업체 바코드 인쇄 
 	function print(){

		if(gridList.validationCheck("gridList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = "" ;
			// 반복문을 돌리며 특정검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = "AND OWNRKY = '" + head[i].get("OWNRKY") + "' AND PTNRKY IN (";
					where = "AND A.OWNRKY = '" + head[i].get("OWNRKY") + "'AND B.WAREKY = '" + head[i].get("WAREKY")+ "' AND A.SKUKEY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("SKUKEY") + "'";
			}
			where += ")";
			
 			//이지젠 호출부(신버전)
 			var langKy = "KO";
 			var map = new DataMap();
 			var width = 640;
 			var height = 320;
 			WriteEZgenElement("/ezgen/boxbcd.ezg" , where , "" , langKy, map , width , height );	
 			
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
					<input type="button" CB="Print PRINT_OUT BTN_PRINT" />
				</div>
			</div>
			<div class="search_inner"> <!-- LB04 박스 바코드 라벨 --> 
				<div class="search_wrap" > 
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="SKUKEY" id="SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="DESC01" id="DESC01" UIInput="SR" />
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
										<td GH="40" GCol="rowCheck" ></td>
										<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
										<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td> <!--제품명-->
										<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td> <!--규격-->
										<td GH="80 STD_VENDKY" GCol="text,VENDKY" GF="S 30">거래처</td> <!--거래처-->
										<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위-->
										<td GH="120 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td> <!--BARCODE(88코드)-->
										<td GH="120 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td> <!--BOX BARCODE-->
										<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td> <!--세트여부-->
										<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td> <!--피킹그룹-->
										<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td> <!--제품구분-->
										<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td> <!--상온구분-->
										<td GH="80 STD_ASKL01" GCol="text,ASKL01" GF="S 40">포장단위명</td> <!--포장단위명-->
										<td GH="80 STD_ASKL02" GCol="text,ASKL02" GF="S 40">판매구분명</td> <!--판매구분명-->
										<td GH="80 STD_ASKL03" GCol="text,ASKL03" GF="S 40">포장구분명</td> <!--포장구분명-->
										<td GH="80 STD_ASKL04" GCol="text,ASKL04" GF="S 40">상온구분명</td> <!--상온구분명-->
										<td GH="80 STD_ASKL05" GCol="text,ASKL05" GF="S 40">재질명</td> <!--재질명-->
										<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td> <!--대분류-->
										<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td> <!--중분류-->
										<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td> <!--소분류-->
										<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td> <!--세분류-->
										<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td> <!--제품용도-->
										<td GH="80 STD_SKUL01" GCol="text,SKUL01" GF="S 40">품목유형 그룹1 명칭</td> <!--품목유형 그룹1 명칭-->
										<td GH="80 STD_SKUL02" GCol="text,SKUL02" GF="S 40">품목유형 그룹2 명칭</td> <!--품목유형 그룹2 명칭-->
										<td GH="80 STD_SKUL03" GCol="text,SKUL03" GF="S 40">품목유형 그룹3 명칭</td> <!--품목유형 그룹3 명칭-->
										<td GH="80 STD_SKUL04" GCol="text,SKUL04" GF="S 40">품목유형 그룹4 명칭</td> <!--품목유형 그룹4 명칭-->
										<td GH="80 STD_SKUL05" GCol="text,SKUL05" GF="S 40">제품용도코드명</td> <!--제품용도코드명-->
										<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td> <!--포장중량-->
										<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td> <!--순중량-->
										<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="N 3,0">중량단위</td> <!--중량단위-->
										<td GH="80 STD_WEIGHT" GCol="text,WEIGHT" GF="N 20,3">중량</td> <!--중량-->
										<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 20,3">포장가로</td> <!--포장가로-->
										<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 20,3">포장세로</td> <!--포장세로-->
										<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 20,3">포장높이</td> <!--포장높이-->
										<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 20,3">CBM</td> <!--CBM-->
										<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="N 20,3">CAPA</td> <!--CAPA-->
										<td GH="80 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td> <!--단위-->
										<td GH="80 STD_QTYBOX" GCol="text,QTDUOM" GF="N 10,1">수량(BOX)</td> <!--수량(BOX)-->
										<td GH="80 STD_ABCANV" GCol="text,ABCANV" GF="S 4">ABC</td> <!--ABC-->
										<td GH="80 STD_OUTDMT" GCol="text,OUTDMT" GF="N 5,0">유통기한(일수)</td> <!--유통기한(일수)-->
										<td GH="80 STD_RIMDMT" GCol="text,RIMDMT" GF="N 5,0">팔렛트가로수량</td> <!--팔렛트가로수량-->
										<td GH="80 STD_INNDPT" GCol="text,INNDPT" GF="N 5,0">팔렛트세로수량</td> <!--팔렛트세로수량-->
										<td GH="80 STD_SECTWD" GCol="text,SECTWD" GF="N 5,0">팔레트높이수량</td> <!--팔레트높이수량-->
										<td GH="80 STD_BATMNG" GCol="text,BATMNG" GF="S 10">세트여부</td> <!--세트여부-->
										<td GH="80 STD_DESC03" GCol="text,DESC03" GF="S 120">신코드</td> <!--신코드-->
										<td GH="80 STD_QTYMON" GCol="text,QTYMON" GF="N 10,0">1회최대주문량</td> <!--1회최대주문량-->
										<td GH="80 STD_QTYSTD" GCol="text,QTYSTD" GF="N 10,0">팔렛트 적재수량</td> <!--팔렛트 적재수량-->
										<td GH="80 STD_BUFMNG" GCol="text,BUFMNG" GF="S 3">제품상태(정상,발주금지,OUT예정 등등)</td> <!--제품상태(정상,발주금지,OUT예정 등등)-->
										<td GH="80 STD_WARAPP" GCol="text,WARAPP" GF="N 18,0">경고임박일수</td> <!--경고임박일수-->
										<td GH="80 STD_OBPROT" GCol="text,OBPROT" GF="S 1">출고 불허</td> <!--출고 불허-->
										<td GH="80 STD_UOMDTA" GCol="text,UOMDTA" GF="S 10">입고단위</td> <!--입고단위-->
										<td GH="80 STD_LOCARV" GCol="text,LOCARV" GF="S 20">기본 입고로케이션</td> <!--기본 입고로케이션-->
										<td GH="80 STD_PASTKY" GCol="text,PASTKY" GF="S 20">적치전략키</td> <!--적치전략키-->
										<td GH="80 STD_DPUTZO" GCol="text,DPUTZO" GF="S 10">기본 적치구역</td> <!--기본 적치구역-->
										<td GH="80 STD_DPUTLO" GCol="text,DPUTLO" GF="S 20">기본 적치로케이션</td> <!--기본 적치로케이션-->
										<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td> <!--할당전략키-->
										<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
										<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
										<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td> <!--생성자-->
										<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td> <!--생성자명-->
										<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td> <!--수정일자-->
										<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td> <!--수정시간-->
										<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td> <!--수정자-->
										<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td> <!--수정자명-->
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