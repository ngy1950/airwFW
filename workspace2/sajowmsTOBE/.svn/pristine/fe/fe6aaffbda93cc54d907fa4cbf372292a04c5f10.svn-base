<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL00</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Report",
			command : "RL26",
		    menuId : "RL26"
	    });
		
		gridList.setReadOnly("gridList", true, ["SKUG05"]);
		searchwareky("<%=ownrky %>");
		
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
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
	
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RL26");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "RL26");
		}
	}
	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            
            return newData;
    	}
    }
    
    
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // skuma 화주 세팅
        if(searchCode == "SHSKUMA" && $inputObj.name == "A.SKUKEY"){
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV"){
			var name = $inputObj.name;
			var param = new DataMap();
				param.put("CMCDKY",name);
			return param;
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
					<!--  <input type="button" CB="Save SAVE BTN_SAVE" />-->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
		            <dl>
		              <dt CL="STD_WAREKY"></dt>
		              <dd>
		                <select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            
					<!-- 기준일자 -->
					<dl>
						<dt CL="STD_STDDAT"></dt>
						<dd>
							<select name="STDDAT" id="STDDAT" class="input" validate="required" UIInput="B" UIFormat="C N"></select>
						</dd>
					</dl>
		            
					<dl>  <!--제품코드-->  
						<dt CL="제품코드"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
				
					<dl>  <!--제품명-->  
						<dt CL="제품명"></dt> 
						<dd> 
							<input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품용도-->  
						<dt CL="제품용도"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고 유형-->  
						<dt CL="재고 유형"></dt> 
						<dd> 
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고 수량-->  
						<dt CL="재고 수량"></dt> 
						<dd> 
							<input type="text" class="input" name="QTSIWH" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--보류 수량-->  
						<dt CL="보류 수량"></dt> 
						<dd> 
							<input type="text" class="input" name="QTSBLK" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--중분류-->  
						<dt CL="STD_SKUG02"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG02" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--소분류-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUG03" UIInput="SR,SHCMCDV" /> 
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
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
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
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="70 STD_STDDAT" GCol="text,STDDAT" GF="D 8">기준일자</td>	<!--기준일자-->
			    						<td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="220 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="60 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="60 STD_LOTA07" GCol="text,LOTA08" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="40 STD_DUOMKY" GCol="text,DUOMKY" GF="S 20">단위</td>	<!--단위-->
			    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
			    						<td GH="60 IFT_PLTQTY1" GCol="text,PLTQTY1" GF="N 17,2">재고수량(PLT)</td>	<!--재고수량(PLT)-->
			    						<td GH="60 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
			    						<td GH="110 STD_SKUG05" GCol="select,SKUG05">
			    							<select class="input" commonCombo="SKUG05"></select>
			    						</td>	<!--제품용도-->
			    						<td GH="60 중량(KG)" GCol="text,DESC02" GF="S 20">중량(KG)</td>	<!--중량(KG)-->
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
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>