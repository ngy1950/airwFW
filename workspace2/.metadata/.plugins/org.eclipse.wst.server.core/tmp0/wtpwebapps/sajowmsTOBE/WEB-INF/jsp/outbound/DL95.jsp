<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL95</title>
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
	    	module : "Outbound", 
			command : "DL95_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true,
		    menuId : "DL95"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Outbound",
			command : "DL95_ITEM",
			pkcol : "OWNRKY,WAREKY,SVBELN",
			emptyMsgType : false,
		    menuId : "DL95"
	    });
		 
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());

		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
		gridList.setReadOnly("gridItemList", true, ["DIRDVY","DIRSUP","C00103","WARESR"]);
		
/* 		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "00");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		setSingleRangeData('LOTA06', rangeArr);
		
		//배열선언
		var rangeArr2 = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap3 = new DataMap();
		// 필수값 입력
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		rangeDataMap3.put(configData.INPUT_RANGE_LOGICAL,"AND");
		//배열에 맵 탑제 
		rangeArr2.push(rangeDataMap3);
		
		rangeDataMap3 = new DataMap();
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		rangeDataMap3.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr2.push(rangeDataMap3); 
		
		setSingleRangeData('LOCAKY', rangeArr2); */
		//출고가능수량 안쓰임
		
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
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		} else if (btnName == "Reload") {
			reloadLabel();
		}else if (btnName == "Applynumber") {
			Applynumber();
		} else if (btnName == "Apply") {
			Apply();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL95");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL95");
		}
	}
	
	//조회
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("LOGIN_WAREKY","<%=wareky%>");
			netUtil.send({
				url : "/outbound/json/displayHeadDL95.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
		}
	}
	
	//저장
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var item = gridList.getSelectData("gridItemList");
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var head = gridList.getSelectData("gridHeadList", true); 
			
			for(var i=0; i < item.length; i++){
				var itemMap = item[i].map;
					
					if(Number(itemMap.QTYORG) != Number(itemMap.QTYREQ)){
				 		if(itemMap.C00103.trim() == "" || itemMap.C00103.trim() == "N" ){
							commonUtil.msgBox("DAERIM_C00102NVL");//* 수량변경시 사유코드는 필수 입력 입니다. *
							return;
						}
					}	
					if(Number(itemMap.WMSMGT) > 0){
						commonUtil.msgBox("DAERIM_WMSMGTNVL");//* 출고작업중인 주문 아이템은 변경할 수 없습니다. *
						return;
					}	
					if(Number(itemMap.QTSHPD) > 0){
						commonUtil.msgBox("DAERIM_QTSHPDNVL");//* 부분출고완료된 주문 아이템 변경은 S/O마감을 통해서만 가능합니다. *
						return;
					}	
			}

			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);

			netUtil.send({
				url : "/outbound/json/saveDL95.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put("LOGIN_WAREKY","<%=wareky%>");
			param.putAll(rowData);
			netUtil.send({
				url : "/outbound/json/displayItemDL95.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});

//			gridList.gridList({
//		    	id : "gridItemList",
//		    	param : param
//		    });
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridItemList" && dataCount > 0){
			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			gridList.getGridBox(gridId).viewTotal(true);
			
			for(var i=0; i<itemList.length; i++){
								
				//출고작업지시하지 않았을 경우,// 출고(할당 이후) 작업 했을 시(wmsmgt,qtshpd > 0) 수정 불가
				if(gridList.getColData("gridItemList", i, "C00102") != 'Y' || Number(gridList.getColData("gridItemList", i, "WMSMGT")) > 0 || Number(gridList.getColData("gridItemList", i, "QTSHPD")) > 0){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["rowCheck","QTYREQ","BOXQTY", "REMQTY"]); 
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["QTYREQ","BOXQTY", "REMQTY"]); 
				}
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
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTYREQ" || colName == "BOXQTY" || colName == "REMQTY" ){
					var qtyreq = 0;
					var boxqty = 0;
					var remqty = 0;
					var pltqty = 0;
					var grswgt = 0;
					var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
					var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
					var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
					var remqtyChk = 0;
				  if( colName == "QTYREQ" ) { 
					qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtyreq)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtyreq)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  					  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				  }
				  if( colName == "REMQTY" ){//잔량변경시
				  	qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));					  	
				  	
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq); 
				  }	
				  
				  var tmpqtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  var tmpqtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
				  if( Number(tmpqtyorg)!= Number(tmpqtyreq) ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["C00103"]);
				  	//item.lockCellById(rowId, "C00103", false);
				  }else {
					gridList.setRowReadOnly(gridId, rowNum, true, ["C00103"]);
				  	//item.lockCellById(rowId, "C00103", true);
				  }
				  
				}
			} else if( colName == "C00103" ){
				var c00103 = Number(gridList.getColData(gridId, rowNum, "C00103"));
				if(Number(c00103) < 900){
					alert('사용할 수 없는 사유코드 입니다.');
					gridList.setColValue(gridId, rowNum, "C00103", " ");
				}
			} 
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			//var colArr = gridList.gridMap.map.gridItemList.cols; //해당그리드의 컬럼 전체 가져오기
			//if(colArr.indexOf(colName)){
			// 가용재고보다 주문수량이 많을 시 글자색 변경
			if(Number(gridList.getColData("gridHeadList", rowNum, "BOXQTY3")) < 0 ||  Number(gridList.getColData("gridHeadList", rowNum, "QTSIWH3")) < 0){
				return "red";
			}else{ 
				return "black";
			}
			//}
		}
	}
	
	function Applynumber(){
		/* saveToGridCopy("ifwms113GridItem","ALLNUMBER","QTYREQ",true);
   		changeNumber(); */
   		
   		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
		var itemList = gridList.getSelectData("gridItemList");
   		
		for(var i=0; i<itemList.length; i++){

			gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#ALLNUMBER").val());
			//사유코드 gridChange이벤트를 강제발생시킨다.
			gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#ALLNUMBER").val());

		}
	}
	function Apply(){

		var itemList = gridList.getSelectData("gridItemList");
   		
   		var itemList = gridList.getSelectData("gridItemList");

		for(var i=0; i<itemList.length; i++){

			gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#ALLRSNADJ").val());
			//사유코드 gridChange이벤트를 강제발생시킨다.
			gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#ALLRSNADJ").val());

		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){		
		if (json && json.data) {
			if (json.data["RESULT"] == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
      //요청사업장
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.DOCUTY"){
            param.put("CMCDKY","PTNG05");
        //납품처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //매출처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        //주문구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
        //배송구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
        //차량번호
        }else if(searchCode == "SHCARMA2"){
        	param.put("WAREKY","<%=wareky%>");
            param.put("OWNRKY","<%=ownrky%>");
            param.put("NOBIND", "Y");
        //상온구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
        //마감구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
            param.put("CMCDKY","PTNG08");
        //피킹그룹
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("USARG1",$("#OWNRKY").val());
        //로케이션
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
              var rangeArr = new Array();
              var rangeDataMap = new DataMap();
              rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
              rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
              rangeArr.push(rangeDataMap);
              
              rangeDataMap = new DataMap();
              rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
              rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
              rangeArr.push(rangeDataMap); 

            param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        //유통경로1
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("USARG1",$("#OWNRKY").val())
        //유통경로2
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("USARG1",$("#OWNRKY").val())
        //유통경로3
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("USARG1",$("#OWNRKY").val())
        //소분류
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("USARG1",$("#OWNRKY").val())
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
						<!-- <input type="button" CB="Save SAVE BTN_SAVE" />  -->
						<input type="button" CB="Reload RESET STD_REFLBL" />
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
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl>  
						<dl>  <!--출고일자 -->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--S/O 번호 -->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고유형 -->  
							<dt CL="IFT_DOCUTY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고요청일 -->  
							<dt CL="IFT_OTRQDT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--피킹그룹 -->  
							<dt CL="STD_PICGRP"></dt> 
							<dd> 
								<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl>
						<dl>  <!--차량번호 -->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품처코드 -->  
							<dt CL="IFT_PTNRTO"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처코드 -->  
							<dt CL="IFT_PTNROD"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl> <!--  재고유형   -->
							<dt CL="STD_LOTA06"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06" value="00" /> 
							</dd> 
						</dl>
			            <dl>  <!--주문/출고형태 -->  
							<dt CL="IFT_ORDTYP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문구분 -->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송구분 -->  
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분 -->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--마감구분 -->  
							<dt CL="STD_PTNG08"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.PTNG08" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션 -->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="W.LOCARV" UIInput="SR,SHLOCMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--유통경로1 -->  
							<dt CL="STD_PTNG01"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.PTNG01" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--유통경로2 -->  
							<dt CL="STD_PTNG02"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.PTNG02" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--유통경로3 -->  
							<dt CL="STD_PTNG03"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.PTNG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류 -->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
 						<dl>  <!-- 포장구분   -->
							<dt CL="STD_LOTA05"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05"/> 
							</dd> 
						</dl> 
						<dl>  <!--요청사업장 -->  
							<dt CL="STD_IFPGRC04"></dt> 
							<dd> 
								<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<!-- <dl>  로케이션  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="LOCAKY" UIInput="SR" readonly/> 
							</dd> 
						</dl> -->
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>품목리스트</span></a></li><br>
					>> 배송구분, 출고예정일은 전체 S/O에 반영됩니다. 타 센터에 확인 후 처리바랍니다.
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="150 STD_WAREKY" GCol="select,WAREKY">
			    						<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select></td>	<!--거점-->
			    						<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="70 STD_NETWGTKg" GCol="text,NETWGT" GF="N 80,3"></td>	<!---->
			    						<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="70 주문내역(BOX)" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td>	<!--주문내역(BOX)-->
			    						<td GH="70 주문내역(EA)" GCol="text,QTSIWH1" GF="N 80,0">주문내역(EA)</td>	<!--주문내역(EA)-->
			    						<td GH="70 출고완료(BOX)" GCol="text,BOXQTY6" GF="N 80,1">출고완료(BOX)</td>	<!--출고완료(BOX)-->
			    						<td GH="70 출고완료(EA)" GCol="text,QTSIWH6" GF="N 80,0">출고완료(EA)</td>	<!--출고완료(EA)-->
			    						<td GH="70 출고가능재고(BOX)" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고(BOX)</td>	<!--출고가능재고(BOX)-->
			    						<td GH="70 출고가능재고(EA)" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고(EA)</td>	<!--출고가능재고(EA)-->
			    						<td GH="70 부족수량(BOX)" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td>	<!--부족수량(BOX)-->
			    						<td GH="70 부족수량(EA)" GCol="text,QTSIWH3" GF="N 80,0">부족수량(EA)</td>	<!--부족수량(EA)-->
			    						<td GH="70 입고예정(BOX)" GCol="text,BOXQTY4" GF="N 80,1">입고예정(BOX)</td>	<!--입고예정(BOX)-->
			    						<td GH="70 입고예정(EA)" GCol="text,QTSIWH4" GF="N 80,0">입고예정(EA)</td>	<!--입고예정(EA)-->
			    						<td GH="70 이고예정(BOX)" GCol="text,BOXQTY5" GF="N 80,1">이고예정(BOX)</td>	<!--이고예정(BOX)-->
			    						<td GH="70 이고예정(EA)" GCol="text,QTSIWH5" GF="N 80,0">이고예정(EA)</td>	<!--이고예정(EA)-->
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
					<li><a href="#tab1-1" ><span>오더리스트(Item)</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 수량적용 -->
						<span CL="STD_QTYCON" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="text" id="ALLNUMBER" name="ALLNUMBER"  UIInput="I"  class="input"/>
						<input type="button" CB="Applynumber APPLYNUMBER BTN_REFLECT" />
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 사유코드 -->
                  		<span CL="IFT_C00103" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
                  		<select name="ALLRSNADJ" id="ALLRSNADJ"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
                  		<input type="button" CB="Apply APPLY BTN_REFLECT" />
               		</li>
               		<li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 저장 -->
						<input type="button" CB="Save SAVE BTN_SAVE" />
					</li>
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="70 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="70 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
			    						<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="50 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="50 IFT_QTYREQ" GCol="input,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="50 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS작업수량</td>	<!--WMS작업수량-->
			    						<td GH="50 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
			    						<td GH="70 STD_PTNG08" GCol="text,PTNG08" GF="S 20">마감구분</td>	<!--마감구분-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="130 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="70 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="130 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
			    						</td>			    			
			    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="70 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td>	<!--가용재고-->
			    						<td GH="70 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td>	<!--누적주문수량-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="80 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td>	<!--승인여부-->
			    						<td GH="80 IFT_C00103" GCol="select,C00103"><!--사유코드-->
												<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
			    						</td>
			    						<td GH="80 STD_LMOUSR" GCol="text,USRID2" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
			    						<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="200 STD_IFPGRC04" GCol="select,WARESR">
								        	<select class="input" CommonCombo="PTNG06"><option></option>	<!--요청사업장--> </select>
								        </td> 
			    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
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