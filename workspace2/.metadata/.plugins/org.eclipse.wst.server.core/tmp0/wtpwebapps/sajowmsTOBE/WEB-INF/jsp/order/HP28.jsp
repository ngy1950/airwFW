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
			command : "HP28"
			//pkcol : "COMPKY,PTNRKY,PTNRTY"
	    });
		

		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, -2));
		inputList.rangeMap["map"]["SR.CARDAT"].valueChange();
 
		inputList.rangeMap["map"]["SR.CARDAT"].$to.val(dateParser(null, "SD", 0, 0, 0));
		inputList.rangeMap["map"]["SR.CARDAT"].valueChange();
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var group = $('input[name="SRCGUB"]:checked').attr('id');
			param.put("SRCGUB", group);

			
			netUtil.send({
				url : "/Report/json/displayHP28.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
			
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "HP28");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "HP28");
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
            param.put("OWNRKY","<%=ownrky %>");
        }
        
    	return param;
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
					<dl>  <!--문서일자-->  
						<dt CL="검색년월"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--영업(D/O) -->
						<dt CL="검색구분"></dt>
						<dd>
							<input type="radio" class="input" id="T"  name="SRCGUB" checked /> 톤
							<input type="radio" class="input" id="B"   name="SRCGUB" /> 박스
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
			    						<td GH="50 년/월" GCol="text,YYYYMM" GF="S 20">년/월</td>	<!--년/월-->
			    						<td GH="70 일반" GCol="text,QTY01" GF="N 20,2">일반</td>	<!--일반-->
			    						<td GH="70 일반직송" GCol="text,QTY02" GF="N 20,2">일반직송</td>	<!--일반직송-->
			    						<td GH="70 위탁점" GCol="text,QTY03" GF="N 20,2">위탁점</td>	<!--위탁점-->
			    						<td GH="70 위탁점직송" GCol="text,QTY04" GF="N 20,2">위탁점직송</td>	<!--위탁점직송-->
			    						<td GH="70 할증" GCol="text,QTY05" GF="N 20,2">할증</td>	<!--할증-->
			    						<td GH="70 할증직송" GCol="text,QTY06" GF="N 20,2">할증직송</td>	<!--할증직송-->
			    						<td GH="70 무상" GCol="text,QTY07" GF="N 20,2">무상</td>	<!--무상-->
			    						<td GH="70 무상직송" GCol="text,QTY08" GF="N 20,2">무상직송</td>	<!--무상직송-->
			    						<td GH="60 공장직송" GCol="text,QTY17" GF="N 20,2">공장직송</td>	<!--공장직송-->
			    						<td GH="60 사판" GCol="text,QTY18" GF="N 20,2">사판</td>	<!--사판-->
			    						<td GH="60 수출" GCol="text,QTY19" GF="N 20,2">수출</td>	<!--수출-->
			    						<td GH="60 이고" GCol="text,QTY09" GF="N 20,2">이고</td>	<!--이고-->
			    						<td GH="60 반품이고" GCol="text,QTY10" GF="N 20,2">반품이고</td>	<!--반품이고-->
			    						<td GH="60 매출처반품" GCol="text,QTY11" GF="N 20,2">매출처반품</td>	<!--매출처반품-->
			    						<td GH="60 위탁점반품" GCol="text,QTY12" GF="N 20,2">위탁점반품</td>	<!--위탁점반품-->
			    						<td GH="60 기타" GCol="text,QTY13" GF="N 20,2">기타</td>	<!--기타-->
			    						<td GH="60 일반합계" GCol="text,QTY14" GF="N 20,2">일반합계</td>	<!--일반합계-->
			    						<td GH="60 직송합계" GCol="text,QTY15" GF="N 20,2">직송합계</td>	<!--직송합계-->
			    						<td GH="60 전체합계" GCol="text,QTY16" GF="N 20,2">전체합계</td>	<!--전체합계-->
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