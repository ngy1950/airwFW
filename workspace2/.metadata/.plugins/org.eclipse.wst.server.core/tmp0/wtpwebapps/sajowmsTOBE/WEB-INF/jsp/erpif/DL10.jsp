<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL10</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	
	var SVBELNS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL10",
			pkcol : "OWNRKY",
			menuId : "DL10"
	    });
		
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
		//I.OTRQDT 하루 더하기 
		inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["I.OTRQDT"].valueChange();

		//콤보박스 리드온리
		gridList.setReadOnly("gridList", true, ["DIRDVY", "DIRSUP"]);

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
			save();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL10");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL10");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			if (SVBELNS != "") {
				param.put('SVBELNS',SVBELNS);
			}
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			SVBELNS = '';
		}
	}

	//저장
	function save() {
		
        var head = gridList.getSelectData("gridList") //체크된것중에 수정된 row 만
        
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
        
		for(var i=0; i<head.length; i++){
		var docuty = head[i].get("DOCUTY");
		if(docuty.trim() == '266' || docuty.trim() == '267'){			
			alert("이고주문 거점 변경 불가");
			return;
		}
	}

       var param = new DataMap();
		param.put("head",head);
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

		netUtil.send({
			url : "/outbound/json/saveDL10.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}

	//저장완료 콜백
	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELNS = json.data;
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
		
//		if ($("#WARECOMBO").val() == ''){
//			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
//			return;
//		}
		
//		if ($("#OTRQDT").val() == ''){
//			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
//			return;
//		}
		
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
		
//		if ($("#WARECOMBO").val() == ''){
//			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
//			return;
//		}
		
//		if ($("#OTRQDT").val() == ''){
//			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
//			return;
//		}

		gridList.checkAll("gridList",true);
		
//		var list = gridList.getGridData("gridList");
//		for(var i=0; i<list.length; i++){	
//			alert(i);
//			gridList.getGridBox('gridList').setColValue(i+1,'rowCheck', true);
//		}		
//		gridList.checkAll("gridList",true);
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
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
            param.put("CMCDKY","PTNG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU02"){
            param.put("CMCDKY","ASKU02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
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
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridList" && dataCount > 0){

			var headGridBox = gridList.getGridBox('gridList');
			var headList = headGridBox.getDataAll();
			for(var i=0; i<headList.length; i++){			
				if(gridList.getColData("gridList", headList[i].get("GRowNum"), "DOCUTY") == '266' || gridList.getColData("gridList", headList[i].get("GRowNum"), "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridList", headList[i].get("GRowNum"), true, ["WAREKY"]);
				}
			}
			
			//DO마감하지 않았을 경우 행 수정 불가 (ITEM)	
		}else if(gridId == "gridItemList" && dataCount > 0){

			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
			for(var i=0; i<itemList.length; i++){
				//DO마감하지 않았을 경우 행 수정 불가 (ITEM)
				
				if(gridList.getColData("gridItemList", i, "C00102") == 'N'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["QTYORG","BOXQTY","REMQTY"]);
				}
				
				if(gridList.getColData("gridItemList", i, "DOCUTY") == '266' || gridList.getColData("gridItemList", i, "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY"]);
				}
			}
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
						<dl>  <!--출고일자-->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고요청일-->  
							<dt CL="IFT_OTRQDT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문/출고형태-->  
							<dt CL="IFT_ORDTYP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/> 
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
						<dl>  <!--납품처코드-->  
							<dt CL="IFT_PTNRTO"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품처명-->  
							<dt CL="IFT_PTNRTONM"></dt> 
							<dd> 
								<input type="text" class="input" name="W.NAME01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처코드-->  
							<dt CL="IFT_PTNROD"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처명-->  
							<dt CL="IFT_PTNRODNM"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.NAME01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--요구사업장-->  
							<dt CL="IFT_WARESRC"></dt> 
							<dd> 
								<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--요구사업장명-->  
							<dt CL="IFT_WARESRN"></dt> 
							<dd> 
								<input type="text" class="input" name="BZ.NAME01" UIInput="SR"/> 
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
						<dl>  <!--원주문수량-->  
							<dt CL="IFT_QTYORG"></dt> 
							<dd> 
								<input type="text" class="input" name="I.QTYORG" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--권역사업장-->  
							<dt CL="STD_WEGWRK"></dt> 
							<dd> 
								<input type="text" class="input" name="B.NAME03" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
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
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="warechk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="IFT_WAREKY" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<select name="WARECOMBO" id="WARECOMBO"  class="input" Combo="SajoCommon,SEARCH_WAREKY_COMCOMBO" ComboCodeView="true"><option></option></select>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="otrqchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="IFT_OTRQDT" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>													
							<input type="text" id="OTRQDT" name="OTRQDT"  UIInput="I" UIFormat="C N" class="input"/>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 일괄적용 -->
							<input type="button" CB="SetAll SAVE BTN_ALL" /> 
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="SetChk SAVE BTN_PART" />
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rowCheck"></td>
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="130 IFT_WAREKY" GCol="select,WAREKY"><!--WMS거점(출고사업장)-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    							</td>
				    						<td GH="80 원주문거점" GCol="text,WAREKY2" GF="S 10">원주문거점</td>	<!--원주문거점-->
				    						<td GH="80 IFT_WARESRC" GCol="text,WARESR" GF="S 10">요구사업장</td>	<!--요구사업장--> 
				    						<td GH="80 IFT_WARESRNM" GCol="text,WARESRNM" GF="S 10">요구사업장명</td>	<!--요구사업장-->
				    						<td GH="80 IFT_OTRQDT" GCol="input,OTRQDT" GF="C 8">출고요청일</td>	<!--출고요청일-->
				    						<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	<!--출고유형-->
				    						<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	<!--문서타입명-->
				    						<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
				    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
				    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->				    						
				    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
				    						</td>
				    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
													<select class="input" commonCombo="PGRC03"></select>
				    						</td>
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
				    						<td GH="80 IFT_BOXQTYORG" GCol="text,BOXQTY" GF="N 13,1">원주문수량(BOX)</td>	<!--원주문수량(BOX)-->
				    						<td GH="80 IFT_BOXQTYREQ" GCol="text,BXIQTY" GF="N 13,1">납품요청수량(BOX)</td>	<!--납품요청수량(BOX)-->
				    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>	<!--권역코드-->
				    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td>	<!--권역명-->
				    						<td GH="80 STD_WEGWRK" GCol="text,NAME03B" GF="S 80">권역사업장</td>	<!--권역사업장-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="delete"></button>
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