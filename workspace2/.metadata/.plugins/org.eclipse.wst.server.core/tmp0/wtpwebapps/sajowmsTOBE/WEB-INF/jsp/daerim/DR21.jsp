<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY23</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "DaerimReport", 
			command : "DR21_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "DaerimReport",
			command : "DR21_ITEM",
		    colorType : true 
	    });

		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["WAREKY", "SKUG03"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY", "WARESR", "DOCUTY","PTNG08", "DIRSUP", "DIRDVY"]);
		
		$('td select.input').parent('td').css('padding','0');
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DR21");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DR21");
 		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
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
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "200");
			param.put("DOCUTY", "214");
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
	

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridItemList"){
			// 가용재고보다 주문수량이 많을 시 글자색 변경
			if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY",$("#OWNRKY").val());
        	
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHSKUMA2"){
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
            param.put("CMCDKY","USARG1");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){

     		//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
        	
            param.put("AREAKY",returnSingleRangeDataArr(rangeArr));
            param.put("WAREKY","<%=wareky %>");
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
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--거점-->  
							<dt CL="STD_WAREKY"></dt> 
							<dd> 
								<input type="text" class="input" name="IT.WAREKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고일자-->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고요청일-->  
							<dt CL="IFT_OTRQDT"></dt> 
							<dd> 
								<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--마감구분-->  
							<dt CL="STD_PTNG08"></dt> 
							<dd> 
								<input type="text" class="input" name="BZ2.PTNG08" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUKEY" UIInput="SR,SHSKUMA2"/> 
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
								<input type="text" class="input" name="SW.LOCARV" UIInput="SR"/> 
							</dd> 
						</dl> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">            
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="140 STD_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
										</td>	<!--거점-->
			    						<td GH="140 STD_SKUG03" GCol="select,SKUG03">
			    							<select class="input" CommonCombo="SKUG03"><option></option></select>
			    						</td>	<!--소분류-->
			    						<td GH="80 합계(EA)" GCol="text,TOT01" GF="N 80,0">합계(EA)</td>	<!--합계(EA)-->
			    						<td GH="80 합계(KG)" GCol="text,TOT02" GF="N 80,2">합계(KG)</td>	<!--합계(KG)-->
			    						<td GH="80 총 박스입수" GCol="text,TOT01_BOX" GF="N 80,0">총 박스입수</td>	<!--총 박스입수-->
			    						<td GH="80 안산물류(EA)" GCol="text,NUM01" GF="N 80,0">안산물류(EA)</td>	<!--안산물류(EA)-->
			    						<td GH="80 안산물류(KG)" GCol="text,NUM02" GF="N 80,2">안산물류(KG)</td>	<!--안산물류(KG)-->
			    						<td GH="80 안성물류(EA)" GCol="text,NUM03" GF="N 80,0">안성물류(EA)</td>	<!--안성물류(EA)-->
			    						<td GH="80 안성물류(KG)" GCol="text,NUM04" GF="N 80,2">안성물류(KG)</td>	<!--안성물류(KG)-->
			    						<td GH="80 김해물류(EA)" GCol="text,NUM05" GF="N 80,0">김해물류(EA)</td>	<!--김해물류(EA)-->
			    						<td GH="80 김해물류(KG)" GCol="text,NUM06" GF="N 80,2">김해물류(KG)</td>	<!--김해물류(KG)-->
			    						<td GH="80 칠곡물류(EA)" GCol="text,NUM07" GF="N 80,0">칠곡물류(EA)</td>	<!--칠곡물류(EA)-->
			    						<td GH="80 칠곡물류(KG)" GCol="text,NUM08" GF="N 80,2">칠곡물류(KG)</td>	<!--칠곡물류(KG)-->
			    						<td GH="80 광주물류(EA)" GCol="text,NUM09" GF="N 80,0">광주물류(EA)</td>	<!--광주물류(EA)-->
			    						<td GH="80 광주물류(KG)" GCol="text,NUM10" GF="N 80,2">광주물류(KG)</td>	<!--광주물류(KG)-->
			    						<td GH="80 오포물류(EA)" GCol="text,NUM11" GF="N 80,0">오포물류(EA)</td>	<!--오포물류(EA)-->
			    						<td GH="80 오포물류(KG)" GCol="text,NUM12" GF="N 80,2">오포물류(KG)</td>	<!--오포물류(KG)-->
			    						<td GH="80 부산물류(EA)" GCol="text,NUM13" GF="N 80,0">부산물류(EA)</td>	<!--부산물류(EA)-->
			    						<td GH="80 부산물류(KG)" GCol="text,NUM14" GF="N 80,2">부산물류(KG)</td>	<!--부산물류(KG)-->
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
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1" ><span>상세내역</span></a></li>
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
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
										</td>	<!--거점-->
			    						<td GH="80 STD_PTNG05" GCol="select,WARESR">
			    							<select class="input" commonCombo="PTNG06"></select>	<!--지점사업장-->
			    						</td>	<!--지점사업장-->
			    						<td GH="80 STD_DOCUTY" GCol="select,DOCUTY" >
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	<!--출고유형-->
			    						</td>	<!--출고유형-->
			    						<td GH="120 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 20">출고요청일</td>	<!--출고요청일-->
			    						<td GH="120 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 200">납품처명</td>	<!--납품처명-->
			    						<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 200">매출처명</td>	<!--매출처명-->
			    						<td GH="80 STD_PTNG08" GCol="select,PTNG08">
												<select class="input" commonCombo="PTNG08"></select>
										</td>	<!--마감구분-->
			    						<td GH="80 STD_PGRC03" GCol="select,DIRSUP">
												<select class="input" commonCombo="PGRC02"></select>
										</td>	<!--주문구분-->
			    						<td GH="80 STD_DIRDVY" GCol="select,DIRDVY" >
												<select class="input" commonCombo="PGRC03"></select>
										</td>	<!--배송구분-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 중량" GCol="text,NETWGT" GF="N 80,3">중량</td>	<!--중량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,QTDUOM" GF="N 100,0">박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_QTYSTD" GCol="text,QTYSTD" GF="N 80,0">팔렛트 적재수량</td>	<!--팔렛트 적재수량-->
			    						<td GH="80 주문수량" GCol="text,QTYREQ" GF="N 80,0">주문수량</td>	<!--주문수량-->				
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
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>