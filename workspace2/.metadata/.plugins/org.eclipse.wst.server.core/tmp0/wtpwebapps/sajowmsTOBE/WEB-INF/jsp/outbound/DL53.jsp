<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YL01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
			module : "Outbound",
			command : "DL53_GRID1",
			pkcol : "OWNRKY",
		    menuId : "DL53"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
			module : "Outbound",
			command : "DL53_GRID2",
			pkcol : "OWNRKY",
		    menuId : "DL53"
	    });
		
		//OTRQDT 하루 더하기 
		$("#RECDAT").val(dateParser(null, "SD", 0, 0, 1));
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridList1", true, ["CARTYP","CARGBN","CARTMP","PTNG07","FORKYN"]);
		gridList.setReadOnly("gridList2", true, ["CARTYP","CARGBN","CARTMP","PTNG07","FORKYN"]);
		searchwareky($('#OWNRKY').val());
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});


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
		$('#atab1-1').trigger("click");
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
	//텝이동시 작동
    function moveTab(obj){
    	var tabNm = obj.attr('href');
    	var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
    	
		if(validate.check("searchArea")){
			gridList.resetGrid(gridId);
			var param = inputList.setRangeParam("searchArea");
			
			if(param.map.RECDAT == "" || param.map.RECDAT == " " || param.map.RECDAT == undefined){
				commonUtil.msgBox("재배차 배송일자를 입력해주세요.");
				return;
			}

			gridList.gridList({
		    	id : gridId,
		    	param : param
		    });
		}
	}
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print1"){
			 printEZGenDR16("/ezgen/upload_car.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL53");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL53");
		}
	}
	
	function printEZGenDR16(url){
    	
    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
		var headList = gridList.getSelectData("gridList1");
    	
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
	
		var count = 0;
		var wherestr = " AND SH.OWNRKY = " + "'" + $("#OWNRKY").val()+"'"+
      				   " AND SH.WAREKY = " + "'" + $("#WAREKY").val()+"'"+
        			   " AND SR.RECDAT IN ("; 		
		var recdat = "";
		
		for(var i=0; i<headList.length; i++){		
			if(recdat != gridList.getColData("gridList1", headList[i].get("GRowNum"), "RECDAT")){
				if(recdat.length > 8){
					wherestr += ",";
				}
				recdat = gridList.getColData("gridList1", headList[i].get("GRowNum"), "RECDAT");
			}
		}
		wherestr = wherestr + "'" + recdat + "'";
		wherestr+=") ";

		wherestr+= " AND SR.RECNUM IN (";
		var recnum = "";
		
		for(var i=0; i<headList.length; i++){		
			if(recnum != gridList.getColData("gridList1", headList[i].get("GRowNum"), "RECNUM")){
				if(recnum.length > 1){
					wherestr += ",";
				}
				recnum = gridList.getColData("gridList1", headList[i].get("GRowNum"), "RECNUM");
				wherestr = wherestr + "'" + recnum + "'";
			}
		}
		wherestr+=") ";
		
		//이지젠 호출부(신버전)
		var width = 845;
		var heigth = 630;
		var map = new DataMap();
		map.put("i_option", '\'<%=wareky %>\'');
		WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다

	}// end printEZGenDR16(url){
		
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
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Print1 PRINT BTN_LDPRINT" />
					<!-- <input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Reload RESET STD_REFLBL" /> -->
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
					<dl>  <!--재배차 배송일자-->  
						<dt CL="STD_RECDAT"></dt> 
						<dd> 
							<input type="text" class="input" id="RECDAT" name="RECDAT" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					<dl>  <!--재배차 차량번호-->  
						<dt CL="STD_RECNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.RECNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업일자-->  
						<dt CL="STD_DOCDAT4"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_DPTNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체명-->  
						<dt CL="STD_DPTNKYNM"></dt> 
						<dd> 
							<input type="text" class="input" name="DECODE(BZ1.NAME01, NULL, BZ2.NAME01, BZ1.NAME01)" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMA"/> 
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
					<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1">일반</span></a></li>
					<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">item 리스트</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_RECDAT" GCol="text,RECDAT" GF="D 20">재배차 배송일자</td>	<!--재배차 배송일자-->
			    						<td GH="100 STD_RECNUM" GCol="text,RECNUM" GF="S 20">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">
			    							<select class="input" CommonCombo="CARTYP"></select>	<!--BATCH NO-->
			    						</td>	<!--차량 톤수-->
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN">
			    							<select class="input" CommonCombo="CARGBN"></select>	<!--BATCH NO-->
			    						</td>	<!--차량 구분-->
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP">
			    							<select class="input" CommonCombo="CARTMP"></select>	<!--BATCH NO-->
			    						</td>	<!--차량 온도-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_NAME01" GCol="text,NAME01" GF="S 30">업체명</td>	<!--업체명-->
			    						<td GH="100 STD_PTNG07B" GCol="select,PTNG07">
			    							<select class="input" CommonCombo="CARTYP"></select>	<!--BATCH NO-->
			    						</td>	<!--최대진입가능차량-->
			    						<td GH="100 STD_FORKYN" GCol="select,FORKYN">
			    							<select class="input" CommonCombo="POSBYNR"></select>	<!--BATCH NO-->
			    						</td>	<!--지게차사용여부-->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 20">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="70 STD_QTJCMP" GCol="text,QTJCMP" GF="N 20,0">낱개수량</td>	<!--팔레트수량-->
			    						<td GH="60 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="70 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="60 STD_GROSSWEIGHT" GCol="text,QTJWGT" GF="N 20,2">총중량</td>	<!--총중량-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
<!-- 						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button> -->
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList2">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_RECDAT" GCol="text,RECDAT" GF="D 20">재배차 배송일자</td>	<!--재배차 배송일자-->
			    						<td GH="55 STD_RECNUM" GCol="text,RECNUM" GF="S 20">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="90 STD_CARTYP" GCol="text,CARTYP" GF="S 20">차량 톤수</td>	<!--차량 톤수-->
			    						<td GH="90 STD_CARGBN" GCol="text,CARGBN" GF="S 20">차량 구분</td>	<!--차량 구분-->
			    						<td GH="90 STD_CARTMP" GCol="text,CARTMP" GF="S 20">차량 온도</td>	<!--차량 온도-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_NAME01" GCol="text,NAME01" GF="S 30">업체명</td>	<!--업체명-->
			    						<td GH="100 STD_PTNG07B" GCol="text,PTNG07" GF="S 20">최대진입가능차량</td>	<!--최대진입가능차량-->
			    						<td GH="100 STD_FORKYN" GCol="text,FORKYN" GF="S 20">지게차사용여부</td>	<!--지게차사용여부-->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 20">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="140 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
			    						<%-- <td GH="60 <%=getLabelLongText(language, "EZG_DST", "ORDNOT")%>" GCol="text,QTJCMP" GF="N 20,0"><%=getLabelLongText(language, "EZG_DST", "ORDNOT")%></td>	<!--<%=getLabelLongText(language, "EZG_DST", "ORDNOT")%>--> --%>
			    						<td GH="60 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="70 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="60 STD_GROSSWEIGHT" GCol="text,QTJWGT" GF="N 20,2">총중량</td>	<!--총중량-->
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
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>