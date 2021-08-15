<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY24</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangReport", 
			command : "OY24_HEADER",
			itemGrid : "gridItemList",
			itemSearch : false,
			colorType : true,
		    menuId : "OY24"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangReport",
			command : "OY24_ITEM",
		    totalView : true,
		    menuId : "OY24"
	    });
		 
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
		gridList.setReadOnly("gridItemList", true, ["C00103", "DIRDVY", "DIRSUP", "WARESR"]);

// 		//로케이션 배열선언
// 		var rangeArr = new Array();
// 		//배열내 들어갈 데이터 맵 선언
// 		var rangeDataMap = new DataMap();
// 		// 필수값 입력
// 		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
// 		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
// 		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
// 		//배열에 맵 탑제 
// 		rangeArr.push(rangeDataMap);
	 	
// 		rangeDataMap = new DataMap();
// 		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
// 		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
// 		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
// 		rangeArr.push(rangeDataMap); 
		
// 		setSingleRangeData('S.LOCAKY', rangeArr); 
//		 안쓰여서 주석처리함

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "OY24");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "OY24");
 		}
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
		searchList();
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			
			netUtil.send({
				url : "/OyangReport/json/displayOY24.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			netUtil.send({
				url : "/OyangReport/json/displayOY24Item.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			//BOXQTY3 부족박스(box)< 0 , QTSIWH3 부족수량(EA) < 0
			if(Number(gridList.getColData("gridHeadList", rowNum, "BOXQTY3")) < 0 ||  Number(gridList.getColData("gridHeadList", rowNum, "QTSIWH3")) < 0 ){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "399");
			param.put("OWNRKY", $("#OWNRKY").val());
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		}
		return param;
	}
		
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHDOCTMIF" && $inputObj.name == "I.DOCUTY"){ 
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //상온구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        //차량번호
        }else if(searchCode == "SHCARMA2" && $inputObj.name == "C.CARNUM"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //요청사업장
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IFPGRC04"){
        	param.put("CMCDKY","PTNG05"); 
//         //로케이션
//         }else if(searchCode == "SHLOCMA"){
<%--             param.put("WAREKY","<%=wareky %>"); --%>
            
//      		// AREAKY 배열선언
//     		var rangeArr = new Array();
//     		//배열내 들어갈 데이터 맵 선언
//     		var rangeDataMap = new DataMap();
//     		// 필수값 입력
//     		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
//     		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
//     		//배열에 맵 탑제 
//     		rangeArr.push(rangeDataMap);
    	 	
//     		rangeDataMap = new DataMap();
//     		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
//     		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
//     		rangeArr.push(rangeDataMap);
    		
//             param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
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
						<input type="button" CB="Search SEARCH STD_SEARCH"/>
						<input type="button" CB="Reload RESET STD_REFLBL"/> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap">
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required"></select>
							</dd>
						</dl>
						<dl> <!--거점-->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true" validate="required"></select>
							</dd>
						</dl>						
						<dl>  <!--주문/출고형태-->  
							<dt CL="IFT_ORDTYP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--S/O번호-->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고유형-->  
							<dt CL="IFT_DOCUTY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품요청일-->  
							<dt CL="STD_VDATU"></dt> 
							<dd> 
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl> <!-- 요청사업장   -->
							<dt CL="STD_IFPGRC04"></dt> 
							<dd> 
								<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품처코드-->  
							<dt CL="IFT_PTNRTO"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처코드-->  
							<dt CL="IFT_PTNROD"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문구분-->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송구분-->  
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
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
<!-- 						<dl>  포장구분   -->
<!-- 							<dt CL="STD_LOTA05"></dt>  -->
<!-- 							<dd>  -->
<!-- 								<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/>  -->
<!-- 							</dd>  -->
<!-- 						</dl>  -->
<!-- 						<dl>  재고유형   -->
<!-- 							<dt CL="STD_LOTA06"></dt>  -->
<!-- 							<dd>  -->
<!-- 								<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" value="00"/>  -->
<!-- 							</dd>  -->
<!-- 						</dl>  -->
<!-- 						<dl>  로케이션   -->
<!-- 							<dt CL="STD_LOCAKY"></dt>  -->
<!-- 							<dd>  -->
<!-- 								<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" readonly/>  -->
<!-- 							</dd>  -->
<!-- 						</dl>   쿼리에 안쓰임 --> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>품목리스트</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>
										<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="100 STD_NETWGTKg" GCol="text,NETWGT" GF="N 80,3">순중량(kg)</td> <!--순중량(kg)-->
										<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="100 STD_BOXQTYR1" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td> <!--주문내역(BOX)-->
										<td GH="100 STD_ORDREA" GCol="text,QTSIWH1" GF="N 80,0">주문내역(EA)</td> <!--주문내역(EA)-->
										<td GH="100 STD_SHDBOX" GCol="text,BOXQTY6" GF="N 80,1">출고완료(BOX)</td> <!--출고완료(BOX)-->
										<td GH="100 STD_SHDEA" GCol="text,QTSIWH6" GF="N 80,0">출고완료(EA)</td> <!--출고완료(EA)-->
										<td GH="100 STD_BOXQTY2BOX" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고(BOX)</td> <!--출고가능재고(BOX)-->
										<td GH="100 STD_QTSIWH2EZ" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고(EA)</td> <!--출고가능재고(EA)-->
										<td GH="100 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td> <!--부족수량(BOX)-->
										<td GH="100 STD_QTSIWH3EA" GCol="text,QTSIWH3" GF="N 80,0">부족수량(EA)</td> <!--부족수량(EA)-->
										<td GH="100 STD_BOXQTY4BOX" GCol="text,BOXQTY4" GF="N 80,1">입고예정(BOX)</td> <!--입고예정(BOX)-->
										<td GH="100 STD_QTSIWH4EA" GCol="text,QTSIWH4" GF="N 80,0">입고예정(EA)</td> <!--입고예정(EA)-->
										<td GH="100 STD_BOXQTY5BOX" GCol="text,BOXQTY5" GF="N 80,1">이고예정(BOX)</td> <!--이고예정(BOX)-->
										<td GH="100 STD_QTSIWH5EA" GCol="text,QTSIWH5" GF="N 80,0">이고예정(EA)</td> <!--이고예정(EA)-->
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
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1" ><span>오더 리스트(Item)</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>  
										<td GH="120 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="100 STD_VDATU" GCol="text,OTRQDT" GF="D 8">납품요청일 </td> <!--납품요청일 -->
										<td GH="100 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="160 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="50 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td> <!--요청수량-->
										<td GH="50 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
										<td GH="50 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td> <!--WMS관리수량-->
										<td GH="50 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td> <!--출하수량-->
										<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
										<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
										<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
										<td GH="130 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> <!--매출처명-->
										
										<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
											<select class="input" commonCombo="PGRC02"><option></option></select> 
			    						</td>
										
										<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
											<select class="input" commonCombo="PGRC03"><option></option></select>
			    						</td>
			    						
										<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td> <!--주문아이템번호-->
										<td GH="50 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td> <!--가용재고-->
										<td GH="50 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td> <!--누적주문수량-->
										<td GH="50 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
										<td GH="50 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td> <!--승인여부-->
										
										<td GH="50 IFT_C00103" GCol="select,C00103"><!--사유코드-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
			    						</td>
			    						
										<td GH="50 STD_LMOUSR" GCol="text,USRID2" GF="S 20">수정자</td> <!--수정자-->
										<td GH="50 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td> <!--yyyymmddhhmmss(처리일자)-->
										<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td> <!--Default:N, 처리완료시:Y, 미사용:X-->
										<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td> <!--배송지 우편번호-->
										<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td> <!--배송지 주소-->
										<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
										
										<td GH="200 STD_IFPGRC04" GCol="select,WARESR">
			    							<select class="input" CommonCombo="PTNG05"></select> <!--요청사업장-->
			    						</td> 
										
										<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td> <!--영업사원명-->
										<td GH="100 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
										<td GH="50 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td> <!--비고-->
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
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>