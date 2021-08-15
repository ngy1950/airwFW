<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL22</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Report",
			command : "RL27",
			colorType : true,
		    menuId : "RL27"
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
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RL27");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "RL27");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}

	// print(출력)
	function print() {
		var optionMap = new DataMap();	
		var wherestr = '';
		var orderbystr = '';
		var addr = '';
		var langKy = "KO";
		var width = 595;
		var heigth = 840;
		var option2 = $("#DATRCV").val();
		var option3 = $("#DATRCV").val();
		
		addr = 'shiplist_tk.ezg';
		
		wherestr = " AND IFT.OWNRKY = '"+ $("#OWNRKY").val() +"' AND IFT.WAREKY = '" + $("#WAREKY").value + "'";
		
		if(option2.substring(7, 9) == 'EQ') {
			option2 = option2.replaceAll("signIn|EQ|", "");
			option2 = option2.replaceAll("↑", ",");
			option2 = " AND IFT.OTRQDT IN (" + option2 +") ";
		} else if(option2.substring(7, 9) == 'BW') {
			option2 = option2.replaceAll("signIn|BW|", "");
			option2 = option2.replaceAll("|", " AND ");
			option2 = " AND IFT.OTRQDT BETWEEN " + option2 + " ";
		} else {
			option2 = " AND 1=1 ";
		}
		wherestr += option2;
		var option = " AND I.OWNRKY = '"+ $("#OWNRKY").val() +"' AND I.WAREKY = '" + $("#WAREKY").value + "'";
		
		if(option3.substring(7,9) == "EQ")
		{
			option3 = option3.replaceAll("signIn|EQ|", "");
			option3 = option3.replaceAll("↑", ",");
			option3 = " AND I.DATRCV IN (" + option3 +") ";
		}
		else if(option3.substring(7,9) == "BW")
		{
			option3 = option3.replaceAll("signIn|BW|", "");
			option3 = option3.replaceAll("|", " AND ");
			option3 = " AND I.DATRCV BETWEEN " + option3 + " ";
		}
		else
		{
			option3 = " AND 1=1 ";
		}
		option += option3;
		optionMap.put('option', option);
		
		WriteEZgenElement("/ezgen/" + addr, wherestr, orderbystr, langKy, optionMap , width , heigth ); // 프린트 공통 메소드
		// 1. ezgen/ 뒤의 주소를 해당 연결된 ezgen 주소로 변경
		// 2. wherestr => 쿼리 조합을 변경
		// 3. map은 option 쿼리 가 담겨 있음 map도 쿼리 조합
	} // end print()
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();	
	
		 //출고유형
		if(searchCode == "SHDOCTM" ){/* && $inputObj.name == "CF.CARNUM" */
	        param.put("DOCCAT","200");	
	      //제품코드
		} else if(searchCode == "SHSKUMA"){
	        param.put("WAREKY","<%=wareky %>");
	        param.put("OWNRKY","<%=ownrky %>");
	       //거래처코드
	 	} else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNRTO"){
	        param.put("OWNRKY","<%=ownrky %>");	 
	      //주문량조정사유
		} else if(searchCode == "SHRSNCD"){
			param.put("DOCUTY","399");
			param.put("DOCCAT","300");
	        param.put("OWNRKY","<%=ownrky %>");	  
		} return param;
	}
	
	function gridListRowBgColorChange(gridId, rowNum, rowData){
		if(gridId == "gridList"){			
			if(rowData.get("CHKSEQ") == "거래처계"){
				return configData.GRID_COLOR_BG_YELLOW_CLASS2;
			}
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" /></div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Print PRINT_OUT STD_PRINT" />
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
						
						<!-- 거점 -->
			            <dl>
			              <dt CL="STD_WAREKY"></dt>
			              <dd>
			                <select name="WAREKY" id="WAREKY" class="input" name="IFWMS113.WAREKY" ComboCodeView="true"></select>
			              </dd>
			            </dl>
			            
						<dl>  <!--출고일자-->  
							<dt CL="출고일자"></dt> 
							<dd> 
								<input type="text" class="input" id="DATRCV" name="IFT.DATRCV" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--주문구분-->  
							<dt CL="주문구분"></dt> 
							<dd> 
								<select name="ORDTYP" id="ORDTYP" class="input" CommonCombo="HPORDTYP">
									<option value=""></option>
								</select> 
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
						<li><a href="#tab1-1"><span>일반</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 7">화주</td>	<!--화주-->
				    						<td GH="40 STD_WAREKY" GCol="text,WAREKY" GF="S 7">거점</td>	<!--거점-->
				    						<td GH="70 STD_LSHPCD" GCol="text,DATRCV" GF="D 10">출고일자</td>	<!--출고일자-->
				    						<td GH="90 STD_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
				    						<td GH="80 STD_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">발주 Seq</td>	<!--발주 Seq-->
				    						<td GH="60 STD_IFPGRC03" GCol="text,ORDTYP" GF="S 40">주문구분</td>	<!--주문구분-->
				    						<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 40">요청사업장</td>	<!--요청사업장-->
				    						<td GH="80 STD_IFPGRC04N" GCol="text,NAME01" GF="S 180">요청사업장명</td>	<!--요청사업장명-->
				    						<td GH="80 STD_RELTCD" GCol="text,PTNRTO" GF="S 20">거래처코드</td>	<!--거래처코드-->
				    						<td GH="100 STD_PTNRTO" GCol="text,CTNAME" GF="S 20">거래처/요청거점</td>	<!--거래처/요청거점-->
				    						<td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
				    						<td GH="70 STD_NETWGT" GCol="text,NETWGT" GF="N 13,3">순중량</td>	<!--순중량-->
				    						<td GH="60 STD_QTYPLT" GCol="text,QTYPLT" GF="N 13,2">수량(PLT)</td>	<!--수량(PLT)-->
				    						<td GH="60 STD_QTYBOX" GCol="text,QTYBOX" GF="N 13,1">수량(BOX)</td>	<!--수량(BOX)-->
				    						<td GH="60 STD_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출고수량</td>	<!--출고수량-->
				    						<td GH="40 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	<!--단위-->
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