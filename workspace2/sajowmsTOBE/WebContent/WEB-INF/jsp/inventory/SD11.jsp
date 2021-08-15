
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var targetGrid = "gridList2";
var param;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	itemGrid : "gridList2",
	    	itemSearch : true,
	    	module : "InventoryReport",
			command : "SD01_1",
		    menuId : "SD11"
	    });
		// 창고별
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "InventoryReport",
			command : "SD01_2",
		    menuId : "SD11"
	    });
		// 로케이션별
		gridList.setGrid({
	    	id : "gridList3",
	    	module : "InventoryReport",
			command : "SD01_3",
			colorType : true ,
		    menuId : "SD11"
	    });
		// 팔렛별
		gridList.setGrid({
	    	id : "gridList4",
	    	module : "InventoryReport",
			command : "SD01_4",
		    menuId : "SD11"
	    });
		// 콤보박스 리드온리	
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList1");
			gridList.resetGrid("gridList2");
			param = inputList.setRangeDataParam("searchArea");
			
			// 재고현황 헤더 조회
 			gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
		}
	}// end searchList()
 	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){

 		param = gridList.getRowData(gridId, rowNum);
		
		param.put("OWNRKY",$('#OWNRKY').val());
		param.put("USERID", "<%=userid%>");
	 	gridList.gridList({
	    	id : targetGrid,
	    	param : param
	    });
	}// end gridListEventItemGridSearch()
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		param.put("OWNRKY", $("#OWNRKY").val());
		
		// 조사타입 및 조정사유코드 공통코드
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			param.put("CMCDKY", "LOTA06");	
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");	
			param.put("DOCUTY", $("#TASOTY").val());

		}
		return param;
	}// end comboEventDataBindeBefore()
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHLOCMA"){
        	param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
            param.put("CMCDKY","SKUG01");
            param.put("USARG5"," ");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
        	param.put("CMCDKY","SKUG02");
        	
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
        	param.put("CMCDKY","SKUG03");
        	
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
        	param.put("CMCDKY","SKUG05");
        	
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
        	param.put("CMCDKY","ASKU02");
        	
        }else if(searchCode == "SHLOTA03CM"){		// 벤더
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
        }
           
        
    	return param;
    }
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridList3"){
			//return gridList.getColData(gridId, rowNum, "FLAGYN");
			if(gridList.getColData(gridId, rowNum, "FLAGYN") == "FFD8D8"){
				return configData.GRID_COLOR_TEXT_RED_CLASS;	
			}else if(gridList.getColData(gridId, rowNum, "FLAGYN") == "FAF4C0"){
				return configData.GRID_COLOR_TEXT_YELLOW_CLASS;	
			}else if(gridList.getColData(gridId, rowNum, "FLAGYN") == "D9E5FF"){
				return configData.GRID_COLOR_TEXT_GREEN_CLASS;	
			}
		}
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print1"){
			printEZGenDR16("/ezgen/sku_stock.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SD11");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SD11");
		}
	}// end commonBtnClick()
	
	function printEZGenDR16(url){
    	
		var headList = gridList.getSelectData("gridList1");
    	
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
	
		if(!commonUtil.msgConfirm("장표를 출력하시겠습니까?")){
            return;
        }
		
		var wherestr = "("; 
		var skukey;
		var glota06;
		for(var i=0; i<headList.length; i++){
			skukey = gridList.getColData("gridList1", headList[i].get("GRowNum"), "SKUKEY");
			glota06 = gridList.getColData("gridList1", headList[i].get("GRowNum"), "GLOTA06");
			
			wherestr += " (S.SKUKEY = '" + skukey + "' AND S.LOTA06 = '" + glota06 + "') OR";
		}
		wherestr = wherestr.substr(0,wherestr.length-2) + ") "; // OR 절삭 

		//이지젠 호출부(신버전)
		var width = 870;
		var heigth = 600;
		var map = new DataMap();
		map.put("i_option", 'S.WAREKY= \'<%=wareky %>\'');
		WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다

	} // end printEZGenDR16
	

	//텝이동시 작동
    function moveTab(obj){
    	var tabNm = obj.attr('href');
    	var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
    	targetGrid = gridId;	
    			
		if(validate.check("searchArea")){
			gridList.resetGrid(gridId);

			gridList.gridList({
		    	id : gridId,
		    	param : param // param - 헤더그리드에서 현재 선택 된 데이터를 전역변수로 갖고 있음 
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print1 PRINT_OUT BTN_PRINT" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--대분류-->  
						<dt CL="STD_SKUG01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--중분류-->  
						<dt CL="STD_SKUG02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--소분류-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품구분-->  
						<dt CL="STD_ASKU04"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU04" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--팔렛트ID-->  
						<dt CL="STD_TRNUID"></dt> 
						<dd> 
							<input type="text" class="input" name="S.TRNUID" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고수량-->  
						<dt CL="STD_QTSIWH"></dt> 
						<dd> 
							<input type="text" class="input" name="S.QTSIWH" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--P박스 관리여부-->  
						<dt CL="STD_PBXCHK"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
						
					<dl>  <!--입고일자 -->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
						
					<dl>  <!--벤더-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>  
						
					<dl>  <!--포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl> 
						
					<dl>  <!--재고유형-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/> 
						</dd> 
					</dl> 
					
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<li style="font-size: 13px;">
						<ul>
							≫ 1.가용수량 : 재고수량  - (할당수량 or 이동중수량 +보류수량) / 2.보류수량 : WMS 보류한 수량  / 3.할당수량: 할당 처리한 수량
						</ul>
						<ul>
							≫ 4.이동중 수량 : (적치지시,기타출고,추가출고) 등과 같이 할당을 하지 않고 작업중인 수량")
						</ul> 
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
										<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="88 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
			    						<td GH="88 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
			    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
			    						<td GH="88 IFT_BOXQTY2" GCol="text,BOXQTY2" GF="N 11,1">가용수량(BOX)</td>	<!--가용수량(BOX)-->
			    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
			    						<td GH="88 IFT_BOXQTY3" GCol="text,BOXQTY3" GF="N 11,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
			    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
			    						<td GH="88 IFT_BOXQTY4" GCol="text,BOXQTY4" GF="N 11,1">할당수량(BOX)</td>	<!--할당수량(BOX)-->
			    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
			    						<td GH="88 IFT_BOXQTY5" GCol="text,BOXQTY5" GF="N 11,1">이동중수량(BOX)</td>	<!--이동중수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY6" GCol="text,BOXQTY6" GF="N 11,1">--</td>	<!------>
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
			    						<td GH="88 IFT_PLTQTY1" GCol="text,PLTQTY1" GF="N 11,2">재고수량(PLT)</td>	<!--재고수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY2" GCol="text,PLTQTY2" GF="N 11,2">가용수량(PLT)</td>	<!--가용수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY3" GCol="text,PLTQTY3" GF="N 11,2">보류수량(PLT)</td>	<!--보류수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY4" GCol="text,PLTQTY4" GF="N 11,2">할당수량(PLT)</td>	<!--할당수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY5" GCol="text,PLTQTY5" GF="N 11,2">이동중수량(PLT)</td>	<!--이동중수량(PLT)-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>     
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab2-2" onclick="moveTab($(this));"><span id="atab2-2">창고별</span></a></li>
					<li><a href="#tab2-3" onclick="moveTab($(this));"><span id="atab2-3">로케이션별</span></a></li>
					<li><a href="#tab2-4" onclick="moveTab($(this));"><span id="atab2-4">팔렛별</span></a></li>
				</ul>
				<div class="table_box section" id="tab2-2" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList2">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="90 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="90 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="160 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
			    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
			    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
			    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
			    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
			    						<td GH="88 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY2" GCol="text,BOXQTY2" GF="N 11,1">가용수량(BOX)</td>	<!--가용수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY3" GCol="text,BOXQTY3" GF="N 11,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY4" GCol="text,BOXQTY4" GF="N 11,1">할당수량(BOX)</td>	<!--할당수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY5" GCol="text,BOXQTY5" GF="N 11,1">이동중수량(BOX)</td>	<!--이동중수량(BOX)-->
			    						<td GH="88 IFT_PLTQTY1" GCol="text,PLTQTY1" GF="N 11,2">재고수량(PLT)</td>	<!--재고수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY2" GCol="text,PLTQTY2" GF="N 11,2">가용수량(PLT)</td>	<!--가용수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY3" GCol="text,PLTQTY3" GF="N 11,2">보류수량(PLT)</td>	<!--보류수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY4" GCol="text,PLTQTY4" GF="N 11,2">할당수량(PLT)</td>	<!--할당수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY5" GCol="text,PLTQTY5" GF="N 11,2">이동중수량(PLT)</td>	<!--이동중수량(PLT)-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="88 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>     
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab2-3" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList3">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="90 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="90 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="50 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="200 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="30 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
			    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
			    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
			    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
			    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="88 STD_REMQTY" GCol="text,REMQTY" GF="N 11,0">잔량</td>	<!--잔량-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 10">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 10">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 10">유통기한</td>	<!--유통기한-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 250">비고</td>	<!--비고-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
			    						<td GH="88 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY2" GCol="text,BOXQTY2" GF="N 11,1">가용수량(BOX)</td>	<!--가용수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY3" GCol="text,BOXQTY3" GF="N 11,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY4" GCol="text,BOXQTY4" GF="N 11,1">할당수량(BOX)</td>	<!--할당수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY5" GCol="text,BOXQTY5" GF="N 11,1">이동중수량(BOX)</td>	<!--이동중수량(BOX)-->
			    						<td GH="88 IFT_PLTQTY1" GCol="text,PLTQTY1" GF="N 11,2">재고수량(PLT)</td>	<!--재고수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY2" GCol="text,PLTQTY2" GF="N 11,2">가용수량(PLT)</td>	<!--가용수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY3" GCol="text,PLTQTY3" GF="N 11,2">보류수량(PLT)</td>	<!--보류수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY4" GCol="text,PLTQTY4" GF="N 11,2">할당수량(PLT)</td>	<!--할당수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY5" GCol="text,PLTQTY5" GF="N 11,2">이동중수량(PLT)</td>	<!--이동중수량(PLT)-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="88 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>     
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab2-4" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList4">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="90 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="90 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="50 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
			    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
			    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
			    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
			    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
			    						<td GH="88 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY2" GCol="text,BOXQTY2" GF="N 11,1">가용수량(BOX)</td>	<!--가용수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY3" GCol="text,BOXQTY3" GF="N 11,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY4" GCol="text,BOXQTY4" GF="N 11,1">할당수량(BOX)</td>	<!--할당수량(BOX)-->
			    						<td GH="88 IFT_BOXQTY5" GCol="text,BOXQTY5" GF="N 11,1">이동중수량(BOX)</td>	<!--이동중수량(BOX)-->
			    						<td GH="88 IFT_PLTQTY1" GCol="text,PLTQTY1" GF="N 11,2">재고수량(PLT)</td>	<!--재고수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY2" GCol="text,PLTQTY2" GF="N 11,2">가용수량(PLT)</td>	<!--가용수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY3" GCol="text,PLTQTY3" GF="N 11,2">보류수량(PLT)</td>	<!--보류수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY4" GCol="text,PLTQTY4" GF="N 11,2">할당수량(PLT)</td>	<!--할당수량(PLT)-->
			    						<td GH="88 IFT_PLTQTY5" GCol="text,PLTQTY5" GF="N 11,2">이동중수량(PLT)</td>	<!--이동중수량(PLT)-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="88 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>  
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