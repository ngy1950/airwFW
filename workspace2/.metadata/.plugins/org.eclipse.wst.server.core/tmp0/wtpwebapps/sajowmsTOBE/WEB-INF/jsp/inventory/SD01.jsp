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
			module : "InventoryReport",
			command : "SD01_1",
		    colorType : true ,
		    menuId : "SD01"
	    });

		gridList.setGrid({
	    	id : "gridList2",
			module : "InventoryReport",
			command : "SD01_2",
		    colorType : true ,
		    menuId : "SD01"
	    });
		
		//로케이션별
		gridList.setGrid({
	    	id : "gridList3",
			module : "InventoryReport",
			command : "SD01_3",
		    colorType : true ,
		    menuId : "SD01"
	    });

		gridList.setGrid({
	    	id : "gridList4",
			module : "InventoryReport",
			command : "SD01_4",
		    colorType : true ,
		    menuId : "SD01"
	    });

		gridList.setGrid({
	    	id : "gridList5",
			module : "InventoryReport",
			command : "SD01_5",
		    colorType : true ,
		    menuId : "SD01"
	    });

		gridList.setGrid({
	    	id : "gridList6",
			module : "InventoryReport",
			command : "SD01_6",
		    colorType : true ,
		    menuId : "SD01"
	    });

		gridList.setGrid({
	    	id : "gridList7",
			module : "InventoryReport",
			command : "SD01_7",
		    colorType : true ,
		    menuId : "SD01"
	    });
		

/* 		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력 
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHPLOC");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "SYSLOC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);	
		rangeArr.push(rangeDataMap2);		
		//setSingleRangeData('S.LOCAKY', rangeArr); */

		// 대림 이고 전용 콤보로 세팅 
		//$("#OWNRKY2").val('2500');	 
		$("#OWNRKY2").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY",$(this).val());
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WAREKY2").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WAREKY2").append(optionHtml);
			
			
/* 			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '2261');
			}); */
			
/* 			if(cnt.length == 0){
				$("#WAREKY2 option:eq(0)").prop("selected",true); 
			}else{
				$("#WAREKY2").val('2261');	
			} */
			
		});

		$("#OWNRKY2").val('<%=ownrky %>');
		$("#OWNRKY2").trigger('change');
		$("#WAREKY2").val('<%=wareky %>');
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SD01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SD01");
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
	

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "SKUKEY"){
			
			var param = new DataMap();
			param.put("OWNRKY", "2200");
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "SKUMA_GETDESC",
				sendType : "list",
				param : param
			}); 
			
			//sku가 있을 경우 
			if(json && json.data && json.data.length > 0 ){
				gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
			}else{
				gridList.setColValue(gridId, rowNum, "SKUKEY", "");
			}
		}
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridList3" || gridId == "gridList5"){
			//return gridList.getColData(gridId, rowNum, "FLAGYN");
			if(gridList.getColData(gridId, rowNum, "FLAGYN") == "FFD8D8"){
				return configData.GRID_COLOR_BG_BRIGHT_RED_CLASS;	
			}else if(gridList.getColData(gridId, rowNum, "FLAGYN") == "FAF4C0"){
				return configData.GRID_COLOR_BG_BGBRIGHT_YELLOW_CLASS;	
			}else if(gridList.getColData(gridId, rowNum, "FLAGYN") == "D9E5FF"){
				return configData.GRID_COLOR_BG_NAVY2_CLASS;	
			}else if(gridList.getColData(gridId, rowNum, "FLAGYN") == "1FF1001"){
				return configData.GRID_COLOR_BG_NAVY3_CLASS;	
			}else{
				return configData.GRID_COLOR_BG_WHITE_CLASS;
			}		
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHAREMA" && $inputObj.name == "S.AREAKY"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHZONMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
            param.put("CMCDKY","SKUG01");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU04"){
            param.put("CMCDKY","ASKU04");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "M.SKUG05"){
            param.put("CMCDKY","SKUG05");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
            param.put("CMCDKY","SKUG02");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
            param.put("CMCDKY","SKUG03");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG04"){
            param.put("CMCDKY","SKUG04");
        }else if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
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
			
			// 출고로케이션 미포함 체크여부
			if( $("#CHKMAK").is(":checked") ){
				param.put("CHKMAK","true");
			}

			gridList.gridList({
		    	id : gridId,
		    	param : param
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
								<select name="OWNRKY" id="OWNRKY2"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY2" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="출고로케이션  미포함"></dt><!--S/O번호-->
							<dd>
									<input type="checkbox" class="input" id="CHKMAK" name="CHKMAK"/> <!-- IBATIS ISEQUAL 구분자  -->
							</dd>
						</dl>
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--존-->  
							<dt CL="STD_ZONEKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--구제품코드-->  
							<dt CL="구제품코드"></dt> 
							<dd> 
								<input type="text" class="input" name="M.DESC03" UIInput="SR"/> 
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
						<dl>  <!--제품구분-->  
							<dt CL="STD_ASKU04"></dt> 
							<dd> 
								<input type="text" class="input" name="S.ASKU04" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품용도-->  
							<dt CL="STD_SKUG05"></dt> 
							<dd> 
								<input type="text" class="input" name="M.SKUG05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--동-->  
							<dt CL="STD_AREAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
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
						<dl>  <!--세분류-->  
							<dt CL="STD_SKUG04"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUG04" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
<!-- 						<dl>  P박스 관리여부	구버전에서 사용하지 않음  
							<dt CL="STD_PBXCHK"></dt> 
							<dd> 
								<input type="text" class="input" name="null" UIInput="SR"/> 
							</dd> 
						</dl>   --> 

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
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1">제품별</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">창고별</span></a></li>
						<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">로케이션별</span></a></li>
						<li><a href="#tab1-4" onclick="moveTab($(this));"><span id="atab1-4">팔렛별</span></a></li>
						<li><a href="#tab1-5" onclick="moveTab($(this));"><span id="atab1-5">유통기한별</span></a></li>
						<li><a href="#tab1-6" onclick="moveTab($(this));"><span id="atab1-6">장기재고</span></a></li>
						<li><a href="#tab1-7" onclick="moveTab($(this));"><span id="atab1-7">유통기한별 장기재고</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="88 피킹로케이션" GCol="text,LOCSKU" GF="S 20">피킹로케이션</td>	<!--피킹로케이션-->
				    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="60 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="60 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
				    						<td GH="70 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="70 IFT_BOXQTY1" GCol="text,BOXQTY1" GF="N 11,1">재고수량(BOX)</td>	<!--재고수량(BOX)-->
				    						<td GH="70 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
				    						<td GH="70 IFT_BOXQTY2" GCol="text,BOXQTY2" GF="N 11,1">가용수량(BOX)</td>	<!--가용수량(BOX)-->
				    						<td GH="70 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
				    						<td GH="70 IFT_BOXQTY3" GCol="text,BOXQTY3" GF="N 11,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
				    						<td GH="70 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
				    						<td GH="70 IFT_BOXQTY4" GCol="text,BOXQTY4" GF="N 11,1">할당수량(BOX)</td>	<!--할당수량(BOX)-->
				    						<td GH="70 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
				    						<td GH="70 IFT_BOXQTY5" GCol="text,BOXQTY5" GF="N 11,1">이동중수량(BOX)</td>	<!--이동중수량(BOX)-->
				    						<td GH="88 IFT_BOXQTY6" GCol="text,BOXQTY6" GF="N 11,1">--</td>	<!------>
				    						<td GH="88 STD_ASNBOX" GCol="text,ASNQTY" GF="N 11,0">ANS박스수량 </td>	<!--ANS박스수량 -->
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
				    						<!-- <td GH="88 STD_SHPLOC" GCol="text,SHPLOC" GF="N 11,0"></td>	 -->
				    						<td GH="50 주문가능수량(PLT)" GCol="text,SALEPLT" GF="N 17,2">주문가능수량(PLT)</td>	<!--주문가능수량(PLT)-->
				    						<td GH="50 주문가능수량(BOX)" GCol="text,SALEBOX" GF="N 17,1">주문가능수량(BOX)</td>	<!--주문가능수량(BOX)-->
				    						<td GH="50 주문가능수량(EA)" GCol="text,SALEQTY" GF="N 17,0">주문가능수량(EA)</td>	<!--주문가능수량(EA)-->
				    						<td GH="50 안전재고수량" GCol="text,SLCPDI" GF="N 17,0">안전재고수량</td>	<!--안전재고수량-->
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
		    								<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="70 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="70 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="70 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
				    						<td GH="70 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
				    						<td GH="70 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
				    						<td GH="70 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
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
				    						<td GH="88 STD_SHPLOC" GCol="text,SHPLOC" GF="N 11,0"></td>	<!---->
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
				    						<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="90 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="60 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="70 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
				    						<td GH="30 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
				    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
				    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
				    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
				    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
				    						<td GH="88 STD_REMQTY" GCol="text,REMQTY" GF="N 11,0">잔량</td>	<!--잔량-->
				    						<td GH="80 STD_LOTNUM" GCol="text,LOTNUM" GF="S 20">Lot number</td>	<!--Lot number-->
				    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
				    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
				    						<td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="80 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
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
				    						<td GH="88 STD_SHPLOC" GCol="text,SHPLOC" GF="N 11,0"></td>	<!---->
				    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
				    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
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
				    						<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="50 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="50 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
				    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="160 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
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
					<div class="table_box section" id="tab1-5">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList5">
										<tr CGRow="true">   
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 10">유통기한</td>	<!--유통기한-->
				    						<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="70 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="50 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="55 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="30 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
				    						<td GH="30 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
				    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="88 STD_USEQTY" GCol="text,USEQTY" GF="N 11,0">가용수량</td>	<!--가용수량-->
				    						<td GH="88 STD_QTSBLK" GCol="text,QTSBLK" GF="N 11,0">보류수량</td>	<!--보류수량-->
				    						<td GH="88 STD_QTSALO" GCol="text,QTSALO" GF="N 11,0">할당수량</td>	<!--할당수량-->
				    						<td GH="88 STD_QTSPMO" GCol="text,QTSPMO" GF="N 11,0">이동중</td>	<!--이동중-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="88 STD_REMQTY" GCol="text,REMQTY" GF="N 11,0">잔량</td>	<!--잔량-->
				    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
				    						<td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 250">비고</td>	<!--비고-->
				    						<td GH="80 STD_asku04" GCol="text,ASKU04" GF="S 10"></td>	<!---->
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
					<div class="table_box section" id="tab1-6">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList6">
										<tr CGRow="true">
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="70 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="30 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
				    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
				    						<td GH="88 STD_QTSIWH03" GCol="text,QTSIWH03" GF="N 11,1">3개월미만</td>	<!--3개월미만-->
				    						<td GH="88 STD_QTSIWH06" GCol="text,QTSIWH06" GF="N 11,1">6개월미만</td>	<!--6개월미만-->
				    						<td GH="88 STD_QTSIWH12" GCol="text,QTSIWH12" GF="N 11,1">1년미만</td>	<!--1년미만-->
				    						<td GH="88 STD_QTSIWH13" GCol="text,QTSIWH13" GF="N 11,1">1년이상</td>	<!--1년이상-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
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
					<div class="table_box section" id="tab1-7">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList7">
										<tr CGRow="true">
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 구제품코드" GCol="text,DESC03" GF="S 20">구제품코드</td>	<!--구제품코드-->
				    						<td GH="70 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="30 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
				    						<td GH="88 STD_QTSIWH" GCol="text,QTSIWH" GF="N 11,0">재고수량</td>	<!--재고수량-->
				    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>	<!--제품구분-->
				    						<td GH="88 80%이상" GCol="text,QTYSK80" GF="N 11,0">80%이상</td>	<!--80%이상-->
				    						<td GH="88 80%미만" GCol="text,QTYSK70" GF="N 11,0">80%미만</td>	<!--80%미만-->
				    						<td GH="88 70%미만" GCol="text,QTYSK60" GF="N 11,0">70%미만</td>	<!--70%미만-->
				    						<td GH="88 60%미만 " GCol="text,QTYSK50" GF="N 11,0">60%미만 </td>	<!--60%미만 -->
				    						<td GH="88 유통기한초과" GCol="text,QTYSK40" GF="N 11,0">유통기한초과</td>	<!--유통기한초과-->
				    						<td GH="88 계산불가" GCol="text,QTYSK30" GF="N 11,0">계산불가</td>	<!--계산불가-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>	<!--제품용도-->
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