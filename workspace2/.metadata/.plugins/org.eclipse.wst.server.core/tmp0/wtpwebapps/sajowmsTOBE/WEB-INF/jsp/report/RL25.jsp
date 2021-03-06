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
			command : "RL25",
		    menuId : "RL25"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
	
			netUtil.send({
				url : "/Report/json/displayRL25.data",
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
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RL25");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "RL25");
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
			            
						<dl>  <!--재고유형-->  
							<dt CL="STD_LOTA06"></dt> 
							<dd> 
								<select name="LOTA06" id="LOTA06" class="input" CommonCombo="LOTA06">
									<option value="">[0] 전체</option>
								</select> 
							</dd> 
						</dl> 
						
						<dl>  <!--입고/배송일자-->  
							<dt CL="입고/배송일자"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.DOCDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--입고유형-->  
							<dt CL="입고유형"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.RCPTTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--출고유형-->  
							<dt CL="STD_SHPMTY"></dt> 
							<dd> 
								<input type="text" class="input" name="DH.SHPMTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--요청사업장-->  
							<dt CL="STD_IFPGRC04"></dt> 
							<dd> 
								<input type="text" class="input" name="I3.WARESR" UIInput="SR,SHWARESRC"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--주문구분-->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="I3.DIRSUP" UIInput="SR,VSHDIRSUP"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--배송구분-->  
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="I3.DIRDVY" UIInput="SR,VSHDIRDVY"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--제품코드-->  
							<dt CL="제품코드"></dt> 
							<dd> 
								<input type="text" class="input" name="DI.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--제품명-->  
							<dt CL="제품명"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						
						<dl>  <!--제품용도-->  
							<dt CL="STD_SKUG05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUG05" UIInput="SR,SHCMCDV"/> 
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
				    						<td GH="50 입고/배송일자" GCol="text,DOCDAT" GF="D 20">입고/배송일자</td>	<!--입고/배송일자-->
				    						<td GH="70 작업일자" GCol="text,ARCPTD" GF="D 20">작업일자</td>	<!--작업일자-->
				    						<td GH="70 RL25_RCPTTY" GCol="text,RCPTTY" GF="S 20">입출고유형</td>	<!--입출고유형-->
				    						<td GH="90 RL25_SHORTX" GCol="text,SHORTX" GF="S 20">유형명</td>	<!--유형명-->
				    						<td GH="70 RL25_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="90 RL25_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
				    						<td GH="60 STD_QTDUOM" GCol="text,QTDUOM" GF="N 5,0">입수</td>	<!--입수-->
				    						<td GH="70 STD_DIRDVY" GCol="text,DIRDVY" GF="S 10">배송구분</td>	<!--배송구분-->
				    						<td GH="60 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,2">포장중량</td>	<!--포장중량-->
				    						<td GH="60 RL25_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="60 RL25_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="70 RL25_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="90 RL25_CDESC1" GCol="text,CDESC1" GF="S 20">재고유형명</td>	<!--재고유형명-->
				    						<td GH="80 STD_SKUG05" GCol="text,CDESC2" GF="S 20">제품용도</td>	<!--제품용도-->
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