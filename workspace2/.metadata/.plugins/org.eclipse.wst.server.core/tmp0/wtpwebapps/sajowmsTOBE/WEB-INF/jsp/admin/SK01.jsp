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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Master",
			command : "SK01",
			menuId : "SK01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
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

	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
	        if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
	            return;
	        }

			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/master/json/saveSK01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "SK01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SK01");
 		}
	}

    
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		if(searchCode == "SHCMCDV"){
			var name = $inputObj.name;
			param.put("CMCDKY",name);
		} if(searchCode == "SHVRCVLO1"){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        }
		return param;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var len = gridList.getColData(gridId, rowNum, "LENGTH");
		var wid = gridList.getColData(gridId, rowNum, "WIDTHW");
		var hie = gridList.getColData(gridId, rowNum, "HEIGHT");
		
		if($.trim(len) == "") len = 0;
		if($.trim(wid) == "") wid = 0
		if($.trim(hie) == "") hie = 0
		
		if(len == 0 || wid == 0 || hie ==0){
			gridList.setColValue(gridId, rowNum, "CUBICM", 0);
		}else{
			gridList.setColValue(gridId, rowNum, "CUBICM",parseFloat((len*wid*hie).toFixed(3)));
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
	<div class="content_inner contentH_inner">
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
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="A.SKUKEY" UIInput="SR,SHSKUMABAR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--구제품코드-->  
						<dt CL="STD_BESKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="DESC03" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--대분류-->  
						<dt CL="STD_SKUG01"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--중분류-->  
						<dt CL="STD_SKUG02"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--소분류-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--세분류-->  
						<dt CL="STD_SKUG04"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG04" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--적치전략키-->  
						<dt CL="STD_PASTKY"></dt> 
						<dd> 
							<input type="text" class="input" name="PASTKY" UIInput="SR,SHPASTH"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--할당전략키-->  
						<dt CL="STD_ALSTKY"></dt> 
						<dd> 
							<input type="text" class="input" name="ALSTKY" UIInput="SR,SHALSTH"/> 
						</dd> 
					</dl> 
					
					
					<dl>  <!--할당전략키-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl> 
					
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<li><button class="btn btn_smaller"><span>축소</span></button></li>
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
											<td GH="40" GCol="rownum">1</td>
											<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="40 STD_DELMAK" GCol="check,DELMAK">삭제</td>	<!--삭제-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
				    						<td GH="200 STD_DESC02" GCol="input,DESC02" GF="S 120">규격</td>	<!--규격-->
				    						<td GH="200 STD_VENDKY" GCol="text,VENDKY" GF="S 30">거래처</td>	<!--거래처-->
				    						
				    						<td GH="200 STD_ASKU01"   GCol="select,ASKU01">
												<select commonCombo="ASKU01"><option></option></select>
											</td><!--포장단위-->
				    						
				    						<td GH="200 STD_ASKU02"   GCol="select,ASKU02">
												<select commonCombo="ASKU02"><option></option></select>
											</td><!--세트여부-->
				    						
				    						<td GH="200 STD_ASKU03"   GCol="select,ASKU03">
												<select commonCombo="ASKU03"><option></option></select>
											</td><!--피킹그룹-->
				    						
				    						<td GH="200 STD_ASKU04"   GCol="select,ASKU04">
												<select commonCombo="ASKU04"><option></option></select>
											</td><!--제품구분-->
				    						
				    						<td GH="200 STD_ASKU05"   GCol="select,ASKU05">
												<select commonCombo="ASKU05"><option></option></select>
											</td><!--상온구분-->
											
				    						<td GH="100 STD_ASKL01" GCol="input,ASKL01" GF="S 40">포장단위명</td>	<!--포장단위명-->
				    						<td GH="100 STD_ASKL02" GCol="input,ASKL02" GF="S 40">판매구분명</td>	<!--판매구분명-->
				    						<td GH="100 STD_ASKL03" GCol="input,ASKL03" GF="S 40">포장구분명</td>	<!--포장구분명-->
				    						<td GH="100 STD_ASKL04" GCol="input,ASKL04" GF="S 40">상온구분명</td>	<!--상온구분명-->
				    						<td GH="100 STD_ASKL05" GCol="input,ASKL05" GF="S 40">재질명</td>	<!--재질명-->
				    						<td GH="120 STD_EANCOD" GCol="input,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
				    						<td GH="120 STD_GTINCD" GCol="input,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
				    						<td GH="120 STD_LOTL01" GCol="input,LOTL01" GF="S 18">가상바코드</td>	<!--가상바코드-->
				    						
				    						<td GH="200 STD_SKUG01"   GCol="select,SKUG01">
												<select commonCombo="SKUG01"><option></option></select>
											</td><!--대분류-->
				    						
				    						<td GH="200 STD_SKUG02"   GCol="select,SKUG02">
												<select commonCombo="SKUG02"><option></option></select>
											</td><!--중분류-->
				    						
				    						<td GH="200 STD_SKUG03"   GCol="select,SKUG03">
												<select commonCombo="SKUG03"><option></option></select>
											</td><!--소분류-->
				    						
				    						<td GH="200 STD_SKUG04"   GCol="select,SKUG04">
												<select commonCombo="SKUG04"><option></option></select>
											</td><!--세분류-->
				    						
				    						<td GH="200 STD_SKUG05"   GCol="select,SKUG05">
												<select commonCombo="SKUG05"><option></option></select>
											</td><!--제품용도-->
				    						
				    						<td GH="100 STD_SKUL01" GCol="input,SKUL01" GF="S 40">품목유형 그룹1 명칭</td>	<!--품목유형 그룹1 명칭-->
				    						<td GH="100 STD_SKUL02" GCol="input,SKUL02" GF="S 40">품목유형 그룹2 명칭</td>	<!--품목유형 그룹2 명칭-->
				    						<td GH="100 STD_SKUL03" GCol="input,SKUL03" GF="S 40">품목유형 그룹3 명칭</td>	<!--품목유형 그룹3 명칭-->
				    						<td GH="100 STD_SKUL04" GCol="input,SKUL04" GF="S 40">품목유형 그룹4 명칭</td>	<!--품목유형 그룹4 명칭-->
				    						<td GH="100 STD_SKUL05" GCol="input,SKUL05" GF="S 40">제품용도코드명</td>	<!--제품용도코드명-->
				    						<td GH="100 STD_GRSWGT" GCol="input,GRSWGT" GF="N 20,3">포장중량</td>	<!--포장중량-->
				    						<td GH="100 STD_NETWGT" GCol="input,NETWGT" GF="N 20,3">순중량</td>	<!--순중량-->
				    						
				    						<td GH="200 STD_WGTUNT"   GCol="select,WGTUNT">
												<select commonCombo="ASKU01"><option></option></select>
											</td><!--중량단위-->
											
				    						<td GH="100 STD_WEIGHT" GCol="input,WEIGHT" GF="N 20,3">중량</td>	<!--중량-->
				    						<td GH="100 STD_LENGTH" GCol="input,LENGTH" GF="N 20,3">포장가로</td>	<!--포장가로-->
				    						<td GH="100 STD_WIDTHW" GCol="input,WIDTHW" GF="N 20,3">포장세로</td>	<!--포장세로-->
				    						<td GH="100 STD_HEIGHT" GCol="input,HEIGHT" GF="N 20,3">포장높이</td>	<!--포장높이-->
				    						<td GH="100 STD_CUBICM" GCol="text,CUBICM" GF="N 20,3">CBM</td>	<!--CBM-->
				    						<td GH="100 STD_CAPACT" GCol="input,CAPACT" GF="N 20,3">CAPA</td>	<!--CAPA-->
				    						<td GH="100 STD_DUOMKY" GCol="input,DUOMKY" GF="S 10">단위</td>	<!--단위-->
				    						<td GH="100 STD_QTYBOX" GCol="input,QTDUOM" GF="N 10,1">수량(BOX)</td>	<!--수량(BOX)-->
				    						<td GH="100 STD_ABCANV" GCol="input,ABCANV" GF="S 4">ABC</td>	<!--ABC-->
				    						<td GH="100 STD_OUTDMT" GCol="input,OUTDMT" GF="N 5,0">유통기한(일수)</td>	<!--유통기한(일수)-->
				    						
				    						<td GH="200 STD_DLGORT"   GCol="select,DLGORT">
												<select commonCombo="DLGORT"><option></option></select>
											</td><!--P-BOX 관리여부-->
											
				    						<td GH="100 STD_BATMNG" GCol="input,BATMNG" GF="S 10">세트여부</td>	<!--세트여부-->
				    						<td GH="100 STD_DESC03W" GCol="input,DESC03" GF="S 80">신제품코드</td>	<!--신제품코드-->
				    						<td GH="200 STD_DESC04" GCol="input,DESC04" GF="S 120">품목메모</td>	<!--품목메모-->
				    						<td GH="100 STD_QTYMON" GCol="input,QTYMON" GF="N 10,0">1회최대주문량</td>	<!--1회최대주문량-->
				    						
				    						
				    						
				    						<td GH="100 팔레트 가로수량" GCol="text,WIDQTY" GF="N 6,0">팔레트 가로수량</td>	<!--팔레트 가로수량-->
				    						<td GH="100 팔레트 세로수량" GCol="text,LENQTY" GF="N 6,0">팔레트 세로수량</td>	<!--팔레트 세로수량-->
				    						<td GH="100 팔레트 추가수량" GCol="text,ADDQTY" GF="N 6,0">팔레트 추가수량</td>	<!--팔레트 추가수량-->
				    						<td GH="100 팔레트 높이수량" GCol="text,HEIQTY" GF="N 6,0">팔레트 높이수량</td>	<!--팔레트 높이수량-->
				    						<td GH="100 STD_QTYSTD" GCol="input,QTYSTD" GF="N 10,0">팔렛트 적재수량</td>	<!--팔렛트 적재수량-->
				    						<td GH="100 STD_BUFMNG" GCol="input,BUFMNG" GF="S 3">제품상태(정상,발주금지,OUT예정 등등)</td>	<!--제품상태(정상,발주금지,OUT예정 등등)-->
				    						<td GH="100 STD_WARAPP" GCol="input,WARAPP" GF="N 18,0">경고임박일수</td>	<!--경고임박일수-->
				    						<td GH="100 STD_OBPROT" GCol="check,OBPROT" GF="S 1">출고 불허</td>	<!--출고 불허-->
				    						<td GH="100 STD_SAFQTY" GCol="input,SLCPDI" GF="N 6,0">안전재고수량</td>	<!--안전재고수량-->
				    						<td GH="100 STD_UOMDTA" GCol="input,UOMDTA" GF="S 10">입고단위</td>	<!--입고단위-->
				    						<td GH="100 STD_LOCARV" GCol="input,LOCARV,SHVRCVLO1" GF="S 20">기본 입고로케이션</td>	<!--기본 입고로케이션-->
				    						<td GH="100 STD_PASTKY" GCol="input,PASTKY" GF="S 20">적치전략키</td>	<!--적치전략키-->
				    						<td GH="100 STD_DPUTZO" GCol="input,DPUTZO" GF="S 10">기본 적치구역</td>	<!--기본 적치구역-->
				    						<td GH="100 STD_DPUTLO" GCol="input,DPUTLO" GF="S 20">기본 적치로케이션</td>	<!--기본 적치로케이션-->
				    						<td GH="100 STD_ALSTKY" GCol="input,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
				    						<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="100 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	<!--생성자명-->
				    						<td GH="100 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="100 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="100 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
				    						<td GH="100 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	<!--수정자명-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
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