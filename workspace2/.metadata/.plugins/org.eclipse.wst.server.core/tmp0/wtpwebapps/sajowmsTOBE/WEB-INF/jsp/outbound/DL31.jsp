<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL31</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL31",
			pkcol : "OWNRKY,WAREKY,SKUKEY",
		    menuId : "DL31"
	    });
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridList",true,["LOTA05","LOTA06"]);
		
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());

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

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL31");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL31");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}

	//저장
	function saveData() {
		
        var head = gridList.getSelectData("gridList") //체크된것중에 수정된 row 만
        
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

		netUtil.send({
			url : "/outbound/json/saveDL31.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}

	//저장완료 콜백
	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if (json.data == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	//체크적용
	function setChk(){
		//인풋값 가져오기
		var warechk = $('#warechk').prop("checked");
		var otrqchk = $("#otrqchk").prop("checked");

		if(!warechk && !otrqchk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
				
		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
//		var list = gridList.getGridData("gridList");
		var list = gridList.getSelectData("gridList");
		var cnt = 0;
        
		for(var i=0; i<list.length; i++){		
			var docuty = gridList.getColData("gridList", i, "DOCUTY");
			//이고출고 거점수정 불가
			if(docuty == '266' || docuty == '267'){
				if (cnt == 0){
					commonUtil.msgBox("이고주문 거점 변경 불가");
//					return;
				}
				cnt++;
			}else{
				//창고값 변경 변경 체크했을 경우에만
				if(warechk) gridList.setColValue("gridList", list[i].get("GRowNum"), "WAREKY", $("#WARECOMBO").val());
				if(otrqchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "OTRQDT", $("#OTRQDT").val());
			}
		}
	}

	//일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	function setAll(){
		//인풋값 가져오기
		
		if(!warechk && !otrqchk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		gridList.checkAll("gridList",true);
		
		setChk();
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("DASTYP",$('#DASTYP').val());
		newData.put("CELTYP","01");//01 기본
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		} else if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
//			param.put("DOCUTY", "131");
		}
		
		return param;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //제품코드
        if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        //출고유형  
        }else if(searchCode == "SHDOCTM" && $inputObj.name == "SHPMTY"){
           		param.put("DOCCAT","200");
        //거래처 
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "TS.DPTNKY"){
        	param.put("PTNRTY","0001");
        	param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){ 
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
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
        	param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
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
						<input type="button" CB="Save SAVE BTN_SAVE" /> 
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
						<dl>  <!--출고유형-->  
							<dt CL="STD_SHPMTY"></dt> 
							<dd> 
								<input type="text" class="input" name="SHPMTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SHPOKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--문서일자-->  
							<dt CL="STD_DOCDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="TS.DOCDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--거래처-->  
							<dt CL="STD_KUNNR"></dt> 
							<dd> 
								<input type="text" class="input" name="TS.DPTNKY" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--거래처명-->  
							<dt CL="STD_KUNNRNM"></dt> 
							<dd> 
								<input type="text" class="input" name="B.NAME01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--동-->  
							<dt CL="STD_AREAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
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
						<dl>  <!--S/O 번호-->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="TS.SVBELN" UIInput="SR"/> 
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
						<li><a href="#tab1-1"><span>일반</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
										    <td GH="40" GCol="rowCheck"></td>
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 20">거점</td>	<!--거점-->
				    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="50 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
				    						<td GH="80 STD_QTSIWH" GCol="text,QTSIWH" GF="N 17,0">재고수량</td>	<!--재고수량-->
				    						<td GH="80 STD_QTSALO" GCol="input,QTSALO" GF="N 17,0">할당수량</td>	<!--할당수량-->
				    						<td GH="80 STD_MEASKY" GCol="text,MEASKY" GF="S 20">단위구성</td>	<!--단위구성-->
				    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
				    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
				    						<td GH="120 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
				    						<td GH="140 STD_LOTA06" GCol="select,LOTA06"> <!--재고유형-->
								        	  <select class="input" CommonCombo="LOTA06"><option></option></select>
								            </td> 
								            <td GH="140 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
								        	  <select class="input" CommonCombo="LOTA05"><option></option></select>
								            </td> 
				    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
				    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
				    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
				    						<td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 100">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="100 STD_SHPOKY" GCol="text,SHPOKY" GF="S 100">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="100 STD_SHPOIT" GCol="text,SHPOIT" GF="S 100">출고문서아이템</td>	<!--출고문서아이템-->
				    						<td GH="100 STD_KUNNR" GCol="text,DPTNKY" GF="S 100">거래처</td>	<!--거래처-->
				    						<td GH="100 STD_KUNNRNM" GCol="text,DPTNKYNM" GF="S 100">거래처명</td>	<!--거래처명-->
				    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 100,0">지시수량</td>	<!--지시수량-->
				    						<td GH="80 STD_AVISTC" GCol="text,QTTAOR" GF="N 100,0">가용재고</td>	<!--가용재고-->
				    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 100">문서일자</td>	<!--문서일자-->
				    						<td GH="80 STD_SHPMTY" GCol="text,SHPMTY" GF="S 100">출고유형</td>	<!--출고유형-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type="button" GBtn="total"></button>  
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