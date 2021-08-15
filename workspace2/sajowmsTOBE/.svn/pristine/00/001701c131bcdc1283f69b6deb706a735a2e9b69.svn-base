<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL51</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "OutBoundReport",
			command : "DL99_HEAD",
			pkcol : "OWNRKY,WAREKY,SVBELN",
			itemGrid : "gridItemList",
			colorType : true,
			itemSearch : true,
			menuId : "DL55"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "OutBoundReport",
			command : "DL99_ITEM",
			menuId : "DL55"
	    });
	    
		gridList.setReadOnly("gridItemList", true, ["WARESR","DIRDVY","DIRSUP","WAREKY"]);
		
	  	//OTRQDT 날짜 수정
		//inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));   //fromval

		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dateParser(null, "S", 0, 0, 1));
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		setSingleRangeData("I.OTRQDT", rangeArr);
 		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr.push(rangeDataMap); 
		/*		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVFAC");
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr.push(rangeDataMap); 
		 */		
		setSingleRangeData('S.LOCAKY', rangeArr); 

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
		
			if($('#CHKMAK').prop("checked") == false){
				param.put("CHKMAK","");
			}else if($('#CHKMAK').prop("checked") == true){
				param.put("CHKMAK","1");
			}
			
			if($('#OWNRKY').val() == '2200' || $('#OWNRKY').val() == '2500'){
				netUtil.send({
					url : "/OutBoundReport/json/displayDL55.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
				});
			} else {
				commonUtil.msgBox("STD_DR001");
				return;
			}
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
						
			netUtil.send({
				url : "/OutBoundReport/json/displayDL55Item.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
		else if(gridId == "gridItemList" && dataCount > 0){

			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
			for(var i=0; i<itemList.length; i++){
								
				//출고작업지시하지 않았을 경우 행 수정 불가 (ITEM)
				if(gridList.getColData("gridItemList", i, "C00102") != 'Y'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]); 
				}i.SVBELN 
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
	        param.put("DOCCAT", "300");
	        param.put("DOCUTY", "399");
	        param.put("DIFLOC", "1");
	        param.put("OWNRKY", $("#OWNRKY").val());
			}
		return param;
	}

	
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL55");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL55");
		}
		
	}


	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	    
		//요청사업장
		if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
	    	param.put("CMCDKY","PTNG05");
			param.put("OWNRKY","<%=ownrky %>");
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
		//세트여부
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
	        param.put("CMCDKY","ASKU02");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//중분류
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
	        param.put("CMCDKY","SKUG02");
	   		param.put("OWNRKY","<%=ownrky %>");
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){
		    param.put("WAREKY","<%=wareky %>");	
	    } return param;
	}	   
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			var target_col = ["OWNRKY","WAREKY","SKUKEY","DESC01","BXIQTY","BOXQTY1","QTSIWH1","BOXQTY2","QTSIWH2","BOXQTY3","BOXQTY3","QTSIWH3",
			                  "QTSIWH4","BOXQTY4","QTSIWH5","BOXQTY5","QTSIWH6","BOXQTY6","QTSIWH7","BOXQTY7","OTRQDT","QTYPRE" ];
			
			for(var i=0; i<target_col.length; i++){
				if( colName == target_col[i] ){
					var boxqty3 = gridList.getColData(gridId, rowNum, "BOXQTY3");
					var qtsiwh3 = gridList.getColData(gridId, rowNum, "QTSIWH3");
					if(Number(boxqty3) < 0 || Number(qtsiwh3) < 0){
						return configData.GRID_COLOR_TEXT_RED_CLASS;	
					}
				}
			}
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
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">	
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!--화주-->
						<dd>
							<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!--거점-->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ALSUSH"></dt><!--전체제품조회 -->
						<dd>
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" />
						</dd>
					</dl>	
					<dl>  <!--주문/출고형태-->  
						<dt CL="IFT_ORDTYP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDTYP" UIInput="SR"  /> 
						</dd> 
					</dl> 
					
					<dl>  <!--출고일자-->  
						<dt CL="IFT_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--S/O 번호-->  
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
					
					<dl>  <!--주문일자-->  
						<dt CL="STD_CTODDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WARESR" UIInput="SR,SHWAHMA" UiRange="2"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--세트여부-->  
						<dt CL="STD_ASKU02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--요청수량-->  
						<dt CL="IFT_QTYORG"></dt> 
						<dd> 
							<input type="text" class="input" name="I.QTYORG" UIInput="SR" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR" /> 
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
							<input type="text" class="input" name="S.SKUG03" UIInput="SR,SHCMCDV" /> 
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
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" value="00"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" value="RCVLOC" readonly="readonly"/> 
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
									<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
									<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
		    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
		    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
		    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
		    						<td GH="80 STD_DESC04" GCol="text,DESC04" GF="S 200">품목메모</td>	<!--품목메모-->
		    						<td GH="120 선입고수량(BOX)" GCol="text,QTYPRE" GF="N 80,1">선입고수량(BOX)</td>	<!--선입고수량(BOX)-->
		    						<td GH="120 유통선입고수량(낱개)" GCol="text,QTYPRE2" GF="N 80,1">유통선입고수량(낱개)</td>	<!--유통선입고수량(낱개)-->
		    						<td GH="120 유통선입고수량(BOX)" GCol="text,BOXPRE2" GF="N 80,1">유통선입고수량(BOX)</td>	<!--유통선입고수량(BOX)-->
		    						<td GH="120 평택물류(BOX)" GCol="text,BOXWH1" GF="N 80,1">평택물류(BOX)</td>	<!--평택물류(BOX)-->
		    						<td GH="120 평택물류(낱개)" GCol="text,QTYWH1" GF="N 80,1">평택물류(낱개)</td>	<!--평택물류(낱개)-->
		    						<td GH="120 칠서물류(BOX)" GCol="text,BOXWH2" GF="N 80,1">칠서물류(BOX)</td>	<!--칠서물류(BOX)-->
		    						<td GH="120 칠서물류(낱개)" GCol="text,QTYWH2" GF="N 80,1">칠서물류(낱개)</td>	<!--칠서물류(낱개)-->
		    						<td GH="120 인천물류(BOX)" GCol="text,BOXWH3" GF="N 80,1">인천물류(BOX)</td>	<!--인천물류(BOX)-->
		    						<td GH="120 인천물류(낱개)" GCol="text,QTYWH3" GF="N 80,1">인천물류(낱개)</td>	<!--인천물류(낱개)-->
		    						<td GH="120 양지물류(BOX)" GCol="text,BOXWH4" GF="N 80,1">양지물류(BOX)</td>	<!--양지물류(BOX)-->
		    						<td GH="120 양지물류(낱개)" GCol="text,QTYWH4" GF="N 80,1">양지물류(낱개)</td>	<!--양지물류(낱개)-->
		    						<td GH="120 백암물류(BOX)" GCol="text,BOXWH4_1" GF="N 80,1">백암물류(BOX)</td>	<!--백암물류(BOX)-->
		    						<td GH="120 백암물류(낱개)" GCol="text,QTYWH4_1" GF="N 80,1">백암물류(낱개)</td>	<!--백암물류(낱개)-->
		    						<td GH="120 미확정수량(BOX)" GCol="text,BOXWH4_2" GF="N 80,1">미확정수량(BOX)</td>	<!--미확정수량(BOX)-->
		    						<td GH="120 미확정수량(낱개)" GCol="text,QTYWH4_2" GF="N 80,1">미확정수량(낱개)</td>	<!--미확정수량(낱개)-->
		    						<td GH="120 영천물류(BOX)" GCol="text,BOXWH5" GF="N 80,1">영천물류(BOX)</td>	<!--영천물류(BOX)-->
		    						<td GH="120 영천물류(낱개)" GCol="text,QTYWH5" GF="N 80,1">영천물류(낱개)</td>	<!--영천물류(낱개)-->
		    						<td GH="120 대기재고(BOX)" GCol="text,BOXS30" GF="N 80,1">대기재고(BOX)</td>	<!--대기재고(BOX)-->
		    						<td GH="120 대기재고(낱개)" GCol="text,QTYS30" GF="N 80,1">대기재고(낱개)</td>	<!--대기재고(낱개)-->
		    						<td GH="120 주문수량+미확정수량(box)" GCol="text,BOXORD" GF="N 80,1">주문수량+미확정수량(box)</td>	<!--주문수량+미확정수량(box)-->
		    						<td GH="120 주문수량+미확정수량(낱개)" GCol="text,QTYORD" GF="N 80,1">주문수량+미확정수량(낱개)</td>	<!--주문수량+미확정수량(낱개)-->
		    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td>	<!--박스입수-->
		    						<td GH="80 STD_BOXQTYR1" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td>	<!--주문내역(BOX)-->
		    						<td GH="80 STD_QTSIWHR1" GCol="text,QTSIWH1" GF="N 80,0">주문내역(낱개)</td>	<!--주문내역(낱개)-->
		    						<td GH="80 STD_BOXQTYR2" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고수량(BOX)</td>	<!--출고가능재고수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR2" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고수량(낱개)</td>	<!--출고가능재고수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td>	<!--부족수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR3" GCol="text,QTSIWH3" GF="N 80,0">부족수량(낱개)</td>	<!--부족수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR4" GCol="text,BOXQTY4" GF="N 80,1">입고예정수량(BOX)</td>	<!--입고예정수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR4" GCol="text,QTSIWH4" GF="N 80,0">입고예정수량(낱개)</td>	<!--입고예정수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR5" GCol="text,BOXQTY5" GF="N 80,1">이고입고예정수량(BOX)</td>	<!--이고입고예정수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR5" GCol="text,QTSIWH5" GF="N 80,0">이고입고예정수량(낱개)</td>	<!--이고입고예정수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR6" GCol="text,BOXQTY6" GF="N 80,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR6" GCol="text,QTSIWH6" GF="N 80,0">보류수량(낱개)</td>	<!--보류수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR7" GCol="text,BOXQTY7" GF="N 80,1">미적치수량(BOX)</td>	<!--미적치수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR7" GCol="text,QTSIWH7" GF="N 80,0">미적치수량(낱개)</td>	<!--미적치수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR8" GCol="text,BOXQTY8" GF="N 80,1">발주수량(BOX)</td>	<!--발주수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR8" GCol="text,QTSIWH8" GF="N 80,0">발주수량(낱개)</td>	<!--발주수량(낱개)-->
		    						<td GH="80 생산입고예정량(BOX)" GCol="text,BOXQTY9" GF="N 80,1">생산입고예정량(BOX)</td>	<!--생산입고예정량(BOX)-->
		    						<td GH="80 생산입고예정량(EA)" GCol="text,QTSIWH9" GF="N 80,0">생산입고예정량(EA)</td>	<!--생산입고예정량(EA)-->
		    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 80" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
		    						<td GH="80 STD_PLTBOX" GCol="text,PLTBOX" GF="N 80,0">PLT별BOX적재수량</td>	<!--PLT별BOX적재수량-->
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
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 IFT_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select>
			    						</td>	<!--WMS거점(출고사업장)-->
			    						<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 10">요청사업장</td>	<!--요청사업장-->
			    						<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	<!--출고유형-->
			    						<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_DIRDVY" GCol="text,DIRDVY" GF="S 5">배송구분</td>	<!--배송구분-->
			    						<td GH="80 IFT_DIRSUP" GCol="text,DIRSUP" GF="S 5">주문구분</td>	<!--주문구분-->
			    						<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
			    						<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
			    						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
			    						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
			    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
			    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="80 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td>	<!--승인여부-->
			    						<td GH="80 IFT_C00103" GCol="text,C00103" GF="S 100">사유코드</td>	<!--사유코드-->
			    						<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td>	<!--LMODAT-->
			    						<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td>	<!--LMOTIM-->
			    						<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
			    						<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
			    						<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
			    						<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	<!--ERR TEXT-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="80 STD_PLTBOX" GCol="text,PLTBOX" GF="N 17,0">PLT별BOX적재수량</td>	<!--PLT별BOX적재수량-->
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
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>