
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
			module : "DaerimOutbound",
			command : "DR05",
		    colorType : true  ,
		    menuId : "DR05"
	    });

		gridList.setGrid({
	    	id : "gridList2",
			module : "DaerimOutbound",
			command : "DR05_02",
		    colorType : true  ,
		    menuId : "DR05"
	    });
		
		//로케이션별
		gridList.setGrid({
	    	id : "gridList3",
			module : "DaerimOutbound",
			command : "DR05_03",
		    colorType : true  ,
		    menuId : "DR05"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList("gridList1");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR05");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DR05");
		} 
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//조회
	function searchList(gridId, param){
		if(!param){ 
			param = inputList.setRangeParam("searchArea");
		}
		gridList.gridList({
			id : gridId,
		   	param : param
		});
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
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList1"){
			param = inputList.setRangeParam("searchArea");
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, "SKUKEY"));
			searchList("gridList2", param);
			$("#atab1-2").trigger('click');
		}else if(gridId == "gridList2"){
			param = inputList.setRangeParam("searchArea");
			param.put("STDDAT", gridList.getColData(gridId, rowNum, "VMONTH"));
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, "SKUKEY"));
			searchList("gridList3", param);
			$("#atab1-3").trigger('click');
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
     	if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("USARG1",$('#OWNRKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("USARG1",$('#OWNRKY').val());
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY","<%=wareky %>");
     		//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    	 	
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
            param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        }
        
        
    	return param;
    }
	
    //텝이동시 작동
    function moveTab(obj){
    	//var tabNm = obj.attr('href');
    	//var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
    	//
		//if(validate.check("searchArea")){
		//	gridList.resetGrid(gridId);
		//	var param = inputList.setRangeParam("searchArea");
        //
		//	gridList.gridList({
		//    	id : gridId,
		//    	param : param
		//    });
		//}
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
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY"  class="input"  ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--기준일자-->  
							<dt CL="STD_STDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="STDDAT" UIFormat="C N" validate="required(STD_STDDAT)"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분-->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류-->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--피킹그룹-->  
							<dt CL="STD_PICGRP"></dt> 
							<dd> 
								<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="SW.LOCARV" UIInput="SR,SHLOCMA"/> 
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
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">월별</span></a></li>
						<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">일별</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">               
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_DAYQTY" GCol="text,STKQTY" GF="N 20,0">당일재고</td>	<!--당일재고-->
				    						<td GH="85 STD_QTYRCV2D" GCol="text,QTYRCV2" GF="N 20,0">익일입고(D+1)</td>	<!--익일입고(D+1)-->
				    						<td GH="85 STD_QTSHPD2D" GCol="text,QTSHPD2" GF="N 20,0">익일출고(D+1)</td>	<!--익일출고(D+1)-->
				    						<td GH="85 STD_STKQTY2D" GCol="text,STKQTY2" GF="N 20,0">익일재고(D+1)</td>	<!--익일재고(D+1)-->
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
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_MONTH" GCol="text,VMONTH" GF="S 20">월</td>	<!--월-->
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_NOWQTY" GCol="text,STKQTY" GF="N 20,0">현재재고</td>	<!--현재재고-->
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
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_DAY" GCol="text,VDAY" GF="S 20">일</td>	<!--일-->
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_NOWQTY" GCol="text,STKQTY" GF="N 20,0">현재재고</td>	<!--현재재고-->
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