<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "InventoryReport",
			command : "SD04" ,
		    menuId : "SD04"
	    });
		inputList.setMultiComboSelectAll($("#CARGBN"), false);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SD04");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SD04");
		} 
	}

	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("TYPE","SEARCH");
			
			
			netUtil.send({
				url : "/Report/json/displaySD04.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}
		
		return param;
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHSHPMA" && $inputObj.name == "S.SHSHPMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
        }
        
    	return param;
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
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
							</dd>
						</dl>
						
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
				
						<dl>  <!--출발권역-->  
							<dt CL="STD_DEPARTURE"></dt> 
							<dd> 
								<input type="text" class="input" id="DEPART" name="B.DEPART" UIInput="SR,SHSHPMA"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--배송일자-->  
							<dt CL="STD_CARDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="B.CARDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="B.CARNUM" UIInput="SR"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--차량 구분-->  
							<dt CL="STD_CARGBN"></dt> 
							<dd> 
								<select name="CARGBN" id="CARGBN" class="input" comboType="MS" CommonCombo="CARGBN"></select> 
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
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="70 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_DEPARTURE" GCol="text,DEPART" GF="S 10">출발권역</td>	<!--출발권역-->
				    						<td GH="90 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
				    						<td GH="90 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="110 STD_PERHNO" GCol="text,PERHNO" GF="S 20">기사핸드폰</td>	<!--기사핸드폰-->
				    						<td GH="110 STD_REPHNO" GCol="text,REPHNO" GF="S 20">기사핸드폰(재배차)</td>	<!--기사핸드폰(재배차)-->
				    						<td GH="90 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
				    						<td GH="90 STD_QTRECN" GCol="text,QTRECN" GF="N 10,0">재배차수량</td>	<!--재배차수량-->
				    						<td GH="90 STD_DPTCNT" GCol="text,CNT" GF="N 5,0">거래처수</td>	<!--거래처수-->
				    						<td GH="90 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
				    						<td GH="90 STD_RETUYN" GCol="text,RETUYN" GF="S 1">회송여부</td>	<!--회송여부-->
				    						<td GH="150 STD_CARNUMNM" GCol="text,CARNUMNM" GF="S 40">차량정보</td>	<!--차량정보-->
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