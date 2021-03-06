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
	    	id : "gridList1",
			module : "Report",
			command : "HP26_1",
		    colorType : true 
	    });

		gridList.setGrid({
	    	id : "gridList2",
			module : "Report",
			command : "HP262",
		    colorType : true 
	    });
		
		//로케이션별
		gridList.setGrid({
	    	id : "gridList3",
			module : "Report",
			command : "HP26_3",
		    colorType : true 
	    });

		gridList.setGrid({
	    	id : "gridList4",
			module : "Report",
			command : "HP26_4",
		    colorType : true 
	    });

	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "HP26");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "HP26");
		} 
	}
	
	//조회
	function searchList(){
		$('#atab1-1').trigger("click");
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
       	if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SMA.SKUG03"){
            param.put("CMCDKY","SKUG03");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "Z1T.CLASS1||Z1T.CLASS2||Z1T.CLASS3||Z1T.CLASS4"){
            param.put("CMCDKY","SKUG04");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "Z1T.USE_TYPE"){
            param.put("CMCDKY","SKUG05");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SMA.ASKU02"){
            param.put("CMCDKY","ASKU02");
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
			
			param.put("TABNUM", tabNm.charAt(tabNm.length-1));

			netUtil.send({
				url : "/Report/json/displayHP26.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : gridId //그리드ID
			});
		}
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
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SKY.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl>
						<dl>  <!--제품명-->  
							<dt CL="STD_DESC01"></dt> 
							<dd> 
								<input type="text" class="input" name="SKY.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류(레거시)-->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="SMA.SKUG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--세분류(레거시)-->  
							<dt CL="STD_SKUG04"></dt> 
							<dd> 
								<input type="text" class="input" name="Z1T.CLASS1||Z1T.CLASS2||Z1T.CLASS3||Z1T.CLASS4" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품용도(레거시)-->  
							<dt CL="STD_SKUG05"></dt> 
							<dd> 
								<input type="text" class="input" name="Z1T.USE_TYPE" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--세트여부(WMS)-->  
							<dt CL="STD_ASKU02"></dt> 
							<dd> 
								<input type="text" class="input" name="SMA.ASKU02" UIInput="SR,SHCMCDV"/> 
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
						<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1">전체</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">정상(BOX)</span></a></li>
						<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">반품</span></a></li>
						<li><a href="#tab1-4" onclick="moveTab($(this));"><span id="atab1-4">대기</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">                 
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 제품코드" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="50 제품명" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 정상(평택+칠서+인천+양지)" GCol="text,QTSI790" GF="N 20,0">정상(평택+칠서+인천+양지)</td>	<!--정상(평택+칠서+인천+양지)-->
				    						<td GH="50 평택센터" GCol="text,QTSS70" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="50 평택(정상)" GCol="text,QTSI70" GF="N 20,0">평택(정상)</td>	<!--평택(정상)-->
				    						<td GH="50 평택(반품)" GCol="text,BANP70" GF="N 20,0">평택(반품)</td>	<!--평택(반품)-->
				    						<td GH="50 평택(대기)" GCol="text,QTSL70" GF="N 20,0">평택(대기)</td>	<!--평택(대기)-->
				    						<td GH="50 칠서센터" GCol="text,QTSS76" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="50 칠서(정상)" GCol="text,QTSI76" GF="N 20,0">칠서(정상)</td>	<!--칠서(정상)-->
				    						<td GH="50 칠서(반품)" GCol="text,BANP76" GF="N 20,0">칠서(반품)</td>	<!--칠서(반품)-->
				    						<td GH="50 칠서(대기)" GCol="text,QTSL76" GF="N 20,0">칠서(대기)</td>	<!--칠서(대기)-->
				    						<td GH="50 양지(정상)" GCol="text,QTSI79" GF="N 20,0">양지(정상)</td>	<!--양지(정상)-->
				    						<td GH="50 양지(반품)" GCol="text,BANP79" GF="N 20,0">양지(반품)</td>	<!--양지(반품)-->
				    						<td GH="50 양지(대기)" GCol="text,QTSL79" GF="N 20,0">양지(대기)</td>	<!--양지(대기)-->
				    						<td GH="50 물류팀" GCol="text,QTSI810" GF="N 20,0">물류팀</td>	<!--물류팀-->
				    						<td GH="50 물류팀(반품)" GCol="text,BANP810" GF="N 20,0">물류팀(반품)</td>	<!--물류팀(반품)-->
				    						<td GH="50 물류팀(대기)" GCol="text,QTSL810" GF="N 20,0">물류팀(대기)</td>	<!--물류팀(대기)-->
				    						<td GH="50 인천공장" GCol="text,QTSI101" GF="N 20,0">인천공장</td>	<!--인천공장-->
				    						<td GH="50 인천(반품)" GCol="text,BANP101" GF="N 20,0">인천(반품)</td>	<!--인천(반품)-->
				    						<td GH="50 인천(대기)" GCol="text,QTSL101" GF="N 20,0">인천(대기)</td>	<!--인천(대기)-->
				    						<td GH="50 영천공장" GCol="text,QTSI107" GF="N 20,0">영천공장</td>	<!--영천공장-->
				    						<td GH="50 영천(반품)" GCol="text,BANP107" GF="N 20,0">영천(반품)</td>	<!--영천(반품)-->
				    						<td GH="50 영천(대기)" GCol="text,QTSL107" GF="N 20,0">영천(대기)</td>	<!--영천(대기)-->
				    						<td GH="50 인천(정상)" GCol="text,QTSI81F" GF="N 20,0">인천(정상)</td>	<!--인천(정상)-->
				    						<td GH="50 인천(반품)" GCol="text,BANP81F" GF="N 20,0">인천(반품)</td>	<!--인천(반품)-->
				    						<td GH="50 인천(대기)" GCol="text,QTSL81F" GF="N 20,0">인천(대기)</td>	<!--인천(대기)-->
				    						<td GH="50 영천지원창고" GCol="text,QTSI87F" GF="N 20,0">영천지원창고</td>	<!--영천지원창고-->
				    						<td GH="50 영천지원(반품)" GCol="text,BANP87F" GF="N 20,0">영천지원(반품)</td>	<!--영천지원(반품)-->
				    						<td GH="50 영천지원(대기)" GCol="text,QTSL87F" GF="N 20,0">영천지원(대기)</td>	<!--영천지원(대기)-->
				    						<td GH="50 광주하치장" GCol="text,QTSI780" GF="N 20,0">광주하치장</td>	<!--광주하치장-->
				    						<td GH="50 광주(반품)" GCol="text,BANP780" GF="N 20,0">광주(반품)</td>	<!--광주(반품)-->
				    						<td GH="50 광주(대기)" GCol="text,QTSL780" GF="N 20,0">광주(대기)</td>	<!--광주(대기)-->
				    						<td GH="50 영천센터" GCol="text,QTSI730" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="50 영천센터(반품)" GCol="text,BANP730" GF="N 20,0">영천센터(반품)</td>	<!--영천센터(반품)-->
				    						<td GH="50 영천센터(대기)" GCol="text,QTSL730" GF="N 20,0">영천센터(대기)</td>	<!--영천센터(대기)-->
				    						<td GH="50 마케팅팀창고" GCol="text,QTSI800" GF="N 20,0">마케팅팀창고</td>	<!--마케팅팀창고-->
				    						<td GH="50 마케팅팀(반품)" GCol="text,BANP800" GF="N 20,0">마케팅팀(반품)</td>	<!--마케팅팀(반품)-->
				    						<td GH="50 마케팅팀(대기)" GCol="text,QTSL800" GF="N 20,0">마케팅팀(대기)</td>	<!--마케팅팀(대기)-->
				    						<td GH="50 칠서공장" GCol="text,QTSI102" GF="N 20,0">칠서공장</td>	<!--칠서공장-->
				    						<td GH="50 칠서공장(반품)" GCol="text,BANP102" GF="N 20,0">칠서공장(반품)</td>	<!--칠서공장(반품)-->
				    						<td GH="50 칠서공장(대기)" GCol="text,QTSL102" GF="N 20,0">칠서공장(대기)</td>	<!--칠서공장(대기)-->
				    						<td GH="50 본사물류" GCol="text,QTSI000" GF="N 20,0">본사물류</td>	<!--본사물류-->
				    						<td GH="50 본사물류(반품)" GCol="text,BANP000" GF="N 20,0">본사물류(반품)</td>	<!--본사물류(반품)-->
				    						<td GH="50 본사물류(대기)" GCol="text,QTSL000" GF="N 20,0">본사물류(대기)</td>	<!--본사물류(대기)-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">                 
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 제품코드" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="50 제품명" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 평택센터" GCol="text,QTSI70" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="50 칠서센터" GCol="text,QTSI76" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="50 인천센터" GCol="text,QTSI81F" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="50 양지센터" GCol="text,QTSI79" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="50 물류팀창고" GCol="text,QTSI810" GF="N 20,0">물류팀창고</td>	<!--물류팀창고-->
				    						<td GH="50 인천공장" GCol="text,QTSI101" GF="N 20,0">인천공장</td>	<!--인천공장-->
				    						<td GH="50 영천공장" GCol="text,QTSI107" GF="N 20,0">영천공장</td>	<!--영천공장-->
				    						<td GH="50 영천지원창고" GCol="text,QTSI87F" GF="N 20,0">영천지원창고</td>	<!--영천지원창고-->
				    						<td GH="50 광주하치장" GCol="text,QTSI780" GF="N 20,0">광주하치장</td>	<!--광주하치장-->
				    						<td GH="50 영천센터" GCol="text,QTSI730" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="50 마케팅팀창고" GCol="text,QTSI800" GF="N 20,0">마케팅팀창고</td>	<!--마케팅팀창고-->
				    						<td GH="50 칠서공장" GCol="text,QTSI102" GF="N 20,0">칠서공장</td>	<!--칠서공장-->
				    						<td GH="50 본사물류" GCol="text,QTSI000" GF="N 20,0">본사물류</td>	<!--본사물류-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-3">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList3">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 제품코드" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="50 제품명" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 평택센터" GCol="text,BANP70" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="50 칠서센터" GCol="text,BANP76" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="50 인천센터" GCol="text,BANP81F" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="50 양지센터" GCol="text,BANP79" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="50 물류팀창고" GCol="text,BANP810" GF="N 20,0">물류팀창고</td>	<!--물류팀창고-->
				    						<td GH="50 인천공장" GCol="text,BANP101" GF="N 20,0">인천공장</td>	<!--인천공장-->
				    						<td GH="50 영천공장" GCol="text,BANP107" GF="N 20,0">영천공장</td>	<!--영천공장-->
				    						<td GH="50 영천지원창고" GCol="text,BANP87F" GF="N 20,0">영천지원창고</td>	<!--영천지원창고-->
				    						<td GH="50 광주하치장" GCol="text,BANP780" GF="N 20,0">광주하치장</td>	<!--광주하치장-->
				    						<td GH="50 영천센터" GCol="text,BANP730" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="50 마케팅팀창고" GCol="text,BANP800" GF="N 20,0">마케팅팀창고</td>	<!--마케팅팀창고-->
				    						<td GH="50 칠서공장" GCol="text,BANP102" GF="N 20,0">칠서공장</td>	<!--칠서공장-->
				    						<td GH="50 본사물류" GCol="text,BANP000" GF="N 20,0">본사물류</td>	<!--본사물류-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-4">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList4">
										<tr CGRow="true">                
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 제품코드" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="50 제품명" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 평택센터" GCol="text,QTSL70" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="50 칠서센터" GCol="text,QTSL76" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="50 인천센터" GCol="text,QTSL81F" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="50 양지센터" GCol="text,QTSL79" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="50 물류팀창고" GCol="text,QTSL810" GF="N 20,0">물류팀창고</td>	<!--물류팀창고-->
				    						<td GH="50 인천공장" GCol="text,QTSL101" GF="N 20,0">인천공장</td>	<!--인천공장-->
				    						<td GH="50 영천공장" GCol="text,QTSL107" GF="N 20,0">영천공장</td>	<!--영천공장-->
				    						<td GH="50 영천지원창고" GCol="text,QTSL87F" GF="N 20,0">영천지원창고</td>	<!--영천지원창고-->
				    						<td GH="50 광주하치장" GCol="text,QTSL780" GF="N 20,0">광주하치장</td>	<!--광주하치장-->
				    						<td GH="50 영천센터" GCol="text,QTSL730" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="50 마케팅팀창고" GCol="text,QTSL800" GF="N 20,0">마케팅팀창고</td>	<!--마케팅팀창고-->
				    						<td GH="50 칠서공장" GCol="text,QTSL102" GF="N 20,0">칠서공장</td>	<!--칠서공장-->
				    						<td GH="50 본사물류" GCol="text,QTSL000" GF="N 20,0">본사물류</td>	<!--본사물류-->
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