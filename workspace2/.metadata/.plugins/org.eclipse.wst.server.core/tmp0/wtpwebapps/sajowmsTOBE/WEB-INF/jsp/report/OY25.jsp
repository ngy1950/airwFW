<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY25</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
			module : "OyangReport",
			command : "OY25_1",
			pkcol : "OWNRKY",
		    menuId : "OY25"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "OyangReport",
			command : "OY25_2",
			pkcol : "OWNRKY",
		    menuId : "OY25"
	    });
		gridList.setGrid({
	    	id : "gridList3",
			module : "OyangReport",
			command : "OY25_3",
			pkcol : "OWNRKY",
		    menuId : "OY25"
	    });
		gridList.setGrid({
	    	id : "gridList4",
			module : "OyangReport",
			command : "OY25_4",
			pkcol : "OWNRKY",
		    menuId : "OY25"
	    });
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridList1", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
		gridList.setReadOnly("gridList2", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
		gridList.setReadOnly("gridList3", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
		gridList.setReadOnly("gridList4", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList1"){
			var data = new DataMap();
			var ownrky = gridList.getColData(gridId, rowNum, "OWNRKY");
			var wareky = gridList.getColData(gridId, rowNum, "WAREKY");
			var otrqdt = gridList.getColData(gridId, rowNum, "OTRQDT");
			var carnum = gridList.getColData(gridId, rowNum, "CARNUM");
			var desc01 = gridList.getColData(gridId, rowNum, "DESC01");
			var ptnrto = gridList.getColData(gridId, rowNum, "PTNRTO");
			var c00102 = $("#C00102 option:selected").val();
			
			data.put("OWNRKY",ownrky);
			data.put("WAREKY",wareky);
			data.put("OTRQDT",otrqdt);
			data.put("CARNUM",carnum);
			data.put("DESC01",desc01);
			data.put("C00102",c00102);
			data.put("PTNRTO",ptnrto);
			
			var option = "height=800,width=1000,resizable=yes";
			page.linkPopOpen("/wms/report/pop/OYcarList_YS.page", data, option);
			
		}else if(gridId == "gridList2"){
			var data = new DataMap();
			var ownrky = gridList.getColData(gridId, rowNum, "OWNRKY");
			var wareky = gridList.getColData(gridId, rowNum, "WAREKY");
			var otrqdt = gridList.getColData(gridId, rowNum, "OTRQDT");
			var carnum = gridList.getColData(gridId, rowNum, "CARNUM");
			var desc01 = gridList.getColData(gridId, rowNum, "DESC01");
			var ptnrto = gridList.getColData(gridId, rowNum, "PTNRTO");
			var c00102 = $("#C00102 option:selected").val();
			
			data.put("OWNRKY",ownrky);
			data.put("WAREKY",wareky);
			data.put("OTRQDT",otrqdt);
			data.put("CARNUM",carnum);
			data.put("DESC01",desc01);
			data.put("C00102",c00102);
			data.put("PTNRTO",ptnrto);
			
			var option = "height=800,width=1000,resizable=yes";
			page.linkPopOpen("/wms/report/pop/OYcarList_YS_SUM.page", data, option);
			
		}
	}
	
	function searchList(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("WAREKY",$('#WAREKY').val());
			
			netUtil.send({
				url : "/OyangReport/json/displayOY25.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList1" //그리드ID
			});
			
		}
	}
	function display2(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			netUtil.send({
				url : "/OyangReport/json/display2OY25.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList2" //그리드ID
			});
		}
	}
	function display3(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			netUtil.send({
				url : "/OyangReport/json/display3OY25.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList3" //그리드ID
			});
		}
	}
	function display4(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			netUtil.send({
				url : "/OyangReport/json/display4OY25.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList4" //그리드ID
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
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
			
		}else if(comboAtt == "OyangReport,COMBO_C00102_OY"){
			param.put("CMCDKY", "C00102_DR"); 
			//제품코드
        }
		return param;
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "OY25");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "OY25");
 		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	
		//차량번호
        if(searchCode == "SHCARMA2"){
            param.put("OWNRKY","<%=ownrky %>");
        //거점
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
        	param.put("CMCDKY","WAREKY");
        //상온구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }
		return param;
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
								<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required"></select>
							</dd>
						</dl>
						<dl> <!--거점-->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<input type="text" name="I.WAREKY" id="WAREKY" class="input" UIInput="SR,SHCMCDV"/>
							</dd>
						</dl> 
						<dl> <!--납품요청일-->
							<dt CL="STD_DLVDAT"></dt>
							<dd>
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N" validate="required"/>
							</dd>
						</dl>
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="CM.CARNUM" UIInput="SR,SHCARMA2"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송코스명-->  
							<dt CL="STD_DRCARNAME"></dt> 
							<dd> 
								<input type="text" class="input" name="CM.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분-->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV" /> 
							</dd> 
						</dl> 
						<dl>  <!--출고지시여부 // 콤보 내용 없음 구버전 C00102_OY -->  
							<dt CL="STD_C00102"></dt> 
							<dd> 
								<select name="C00102" id="C00102" class="input" Combo="OyangReport,COMBO_C00102_OY"></select>
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
						<li><a href="#tab1-1" onclick="searchList()"><span>일자별</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>합계</span></a></li>
						<li><a href="#tab1-3" onclick="display3()"><span>일자/거래처별</span></a></li>
						<li><a href="#tab1-4" onclick="display4()"><span>일자/거래처별 합계</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<li>
									<button class="btn btn_bigger">
										<span>확대</span>
									</button>
								</li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="120 key" GCol="text,KEY" GF="S 20">key</td>	<!--key-->
											<td GH="100 STD_DLVDAT" GCol="text,OTRQDT" GF="D 20">납품요청일</td>	<!--납품요청일-->
											
											<td GH="120 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select> 
				    						</td>
											<td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
											<td GH="150 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td><!--배송코스-->
											<td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
											
											<td GH="100 STD_CARTYP" GCol="select,CARTYP"> <!--차량톤수-->
												<select class="input" commonCombo="CARTYP"></select> 
				    						</td>
											<td GH="100 STD_CARGBN" GCol="select,CARGBN"> <!--차량구분-->
												<select class="input" commonCombo="CARGBN"></select> 
											</td>	
											<td GH="100 STD_CARTMP" GCol="select,CARTMP"> <!--차량온도-->
												<select class="input" commonCombo="CARTMP"></select> 
											</td>	
											
											<td GH="80 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20">총수량</td>	<!--총수량-->
											<td GH="80 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
											<td GH="80 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20">낱개수량</td>	<!--낱개수량-->
											<td GH="80 STD_TOTWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td><!--총중량(kg)-->
											<td GH="80 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="120 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select> 
				    						</td>
				    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="150 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td><!--배송코스-->
				    						<td GH="100 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
				    						<td GH="100 STD_CARTYP" GCol="select,CARTYP"> <!--차량톤수-->
												<select class="input" commonCombo="CARTYP"></select> 
				    						</td>
											<td GH="100 STD_CARGBN" GCol="select,CARGBN"> <!--차량구분-->
												<select class="input" commonCombo="CARGBN"></select> 
											</td>	
											<td GH="100 STD_CARTMP" GCol="select,CARTMP"> <!--차량온도-->
												<select class="input" commonCombo="CARTMP"></select> 
											</td>
				    						<td GH="80 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20">총수량</td>	<!--총수량-->
				    						<td GH="80 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
				    						<td GH="80 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20">낱개수량</td>	<!--낱개수량-->
				    						<td GH="80 STD_TOTWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td><!--총중량(kg)-->
											<td GH="80 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
					<div class="table_box section" id="tab1-3">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList3">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="120 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select> 
				    						</td>
				    						<td GH="100 STD_DLVDAT" GCol="text,OTRQDT" GF="D 20">납품요청일</td>	<!--납품요청일-->
				    						<td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
											<td GH="150 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td><!--배송코스-->
											<td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
											<td GH="100 STD_CARTYP" GCol="select,CARTYP"> <!--차량톤수-->
												<select class="input" commonCombo="CARTYP"></select> 
				    						</td>
											<td GH="100 STD_CARGBN" GCol="select,CARGBN"> <!--차량구분-->
												<select class="input" commonCombo="CARGBN"></select> 
											</td>	
											<td GH="100 STD_CARTMP" GCol="select,CARTMP"> <!--차량온도-->
												<select class="input" commonCombo="CARTMP"></select> 
											</td>
				    						<td GH="90 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="90 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
				    						<td GH="90 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="90 STD_SHIPTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20">총수량</td>	<!--총수량-->
				    						<td GH="80 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
				    						<td GH="80 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
				    						<td GH="80 STD_TOTWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td><!--총중량(kg)-->
											<td GH="80 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
					<div class="table_box section" id="tab1-4">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList4">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="120 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select> 
				    						</td>
				    						<td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
											<td GH="150 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td><!--배송코스-->
											<td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
											<td GH="100 STD_CARTYP" GCol="select,CARTYP"> <!--차량톤수-->
												<select class="input" commonCombo="CARTYP"></select> 
				    						</td>
											<td GH="100 STD_CARGBN" GCol="select,CARGBN"> <!--차량구분-->
												<select class="input" commonCombo="CARGBN"></select> 
											</td>	
											<td GH="100 STD_CARTMP" GCol="select,CARTMP"> <!--차량온도-->
												<select class="input" commonCombo="CARTMP"></select> 
											</td>
				    						<td GH="90 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="90 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
				    						<td GH="90 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="90 STD_SHIPTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20">총수량</td>	<!--총수량-->
				    						<td GH="80 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
				    						<td GH="80 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
				    						<td GH="80 STD_TOTWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td><!--총중량(kg)-->
											<td GH="80 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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