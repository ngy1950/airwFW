<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
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
	    	module : "ConsignOutbound", 
			command : "OD06_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OD06"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "ConsignOutbound",
	    	colorType : true ,
			command : "OD06_ITEM",
		    menuId : "OD06"
	    });

		gridList.setReadOnly("gridItemList", true, ["LOTA05","LOTA06","RSNADJ"]);

		// 대림 이고 전용 콤보로 세팅 

		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY2").val('2500');	 
		$("#OWNRKY2").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY", '2500');
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WAREKY2").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WAREKY2").append(optionHtml);
			
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '2261');
			});
			
			if(cnt.length == 0){
				$("#WAREKY2 option:eq(0)").prop("selected",true); 
			}else{
				$("#WAREKY2").val('2261');	
			}
			
		});

		$("#OWNRKY2").trigger('change');
		
		$("#OWNRKYORG").val("<%=ownrky%>")
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			create();
		}else if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OD06");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OD06");
		}
	}
	
	
	//조회
	function searchList(){

		$('#btnSave').show();
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}


	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		if (gridList.validationCheck("gridHeadList", "data") && gridList.validationCheck("gridItemList", "data") ) {

			var param = inputList.setRangeDataParam("searchArea");
			var head = gridList.getGridBox("gridHeadList").getDataAll();
			var item = gridList.getSelectData("gridItemList");
			param.put("head",head);
			param.put("item",item);

			if (item.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(Number(itemMap.QTADJU) < 1){
					commonUtil.msgBox("VALID_M0952"); //수량이 0 입니다.
					return;
				}
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}

			netUtil.send({
				url : "/ConsignOutbound/json/saveOD06.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != "F"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				$('#btnSave').hide();

				searchListSaveAfter(json.data.SADJKY);
			}else{
				commonUtil.msgBox("VALID_M0009");
			}
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			if(rowData.map.SADJKY && rowData.map.SADJKY != '' && rowData.map.SADJKY != ' '){ //입고문서번호가 생성된 경우 
				//아이템 재조회
				netUtil.send({
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
			    	module : "ConsignOutbound", 
					command : "OD06_ITEM2",
					bindId : "gridItemList" //그리드ID
				});
			}else{
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}

	
	//저장 후 조회 
	function searchListSaveAfter(sadjky){
		var param = inputList.setRangeParam("searchArea");
		param.put("SADJKY",sadjky);
		
		// 재조회
		netUtil.send({
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
	    	module : "ConsignOutbound", 
			command : "OD06_HEAD2",
			bindId : "gridHeadList" //그리드ID
		});
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCUTY", "121");
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "410");
			
		}
		
		return param;
	}

	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(gridId == "gridItemList"){
			if(colName == "QTADJU" || colName == "BOXQTY" || colName == "REMQTY"|| colName == "PLTQTY" ){ //수량변경시연결된 수량 변경
				var qtadju = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				//var grswgtcnt = gridList.getColData(gridId, rowNum, "GRSWGTCNT");
				
				
				if(gridList.getColData(gridId, rowNum, "SKUKEY") == "" ||gridList.getColData(gridId, rowNum, "SKUKEY") == " " ){
					commonUtil.msgBox("VALID_M0958"); //품번 입력 후 수량을 입력하실 수 있습니다.
			    	gridList.setColValue(gridId, rowNum, "QTADJU", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
					return;
				}
				
				if( colName == "QTADJU" ) {
				 	qtadju = colValue;
				 	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qtadju)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				 	//grswgt = qtadju * grswgtcnt;
				 	
				 	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					//gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
					
				}else if( colName == "BOXQTY" ){ 
					boxqty = colValue;
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	qtadju = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				 	//grswgt = qtadju * grswgtcnt;
				 	
					gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					//gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}else if( colName == "REMQTY" ){
					qtadju = gridList.getColData(gridId, rowNum, "QTADJU");
					boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
					remqty = colValue;	
					
					
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					qtadju = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
					//grswgt = qtadju * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
					gridList.setColValue(gridId, rowNum, "QTADJU", qtadju); 	
					//gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}
				  
				  if( colName == "PLTQTY" ){ //팔레트 수량 번경시
				  	qtyorg = gridList.getColData(gridId, rowNum, "QTYORG");
				  	qtshpo = gridList.getColData(gridId, rowNum, "QTADJU");
				  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	pltqty = gridList.getColData(gridId, rowNum, "PLTQTY");
				  	pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
					  	
				  	qtshpoqty = (Number)(pltqty)*(Number)(pliqty); // 새로 입력한 plt수량
				  	qtshpo = qtshpoqty;
				  	boxqty = floatingFloor(((Number)(pltqty) * (Number)(pliqty)) / (Number)(bxiqty), 1);
				  	//grswgt = (Number)(pltqty) * (Number)(pliqty) * grswgtcnt;

				  	if( Number(qtshpoqty) > Number(qtyorg)){
				  		alert("* 팔렛트 수량이 원주문수량보다 큽니다 . *");
				  		resetQty(gridId, rowNum);
						return false;
				  	}else{
				  		gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
						gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
						gridList.setColValue(gridId, rowNum, "QTADJU", qtshpo);
						//gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  	}
				}
				
				if(Number(gridList.getColData(gridId, rowNum, "QTADJU")) > Number(gridList.getColData(gridId, rowNum, "QTYUOM"))){

					commonUtil.msgBox("VALID_OD03QTY");//원입고 수량을 초과할 수 없습니다.
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);	
					gridList.setColValue(gridId, rowNum, "QTADJU", 0); 	
					gridList.setColValue(gridId, rowNum, "GRSWGT", 0);
					
				}
			} //수량변경 끝
		}
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
            param.put("CMCDKY","ASKU02");
        	
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
            param.put("CMCDKY","SKUG05");
        	
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY2").val());
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
					<input type="button" id="btnSave" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY2"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" disabled></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY2" class="input" ComboCodeView="true" disabled="disabled"></select>
						</dd>
					</dl>
					<dl> <!--입고처-->  
						<dt CL="HP_STCDINNM"></dt>
						<dd>
							<select name="OWNRKYORG" id="OWNRKYORG" class="input" Combo="ConsignOutbound,COMBO_OWNRKY_OD"  ComboCodeView="true" ></select>
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
					<dl>  <!--세트여부-->  
						<dt CL="STD_ASKU02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV"/> 
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
				<!-- 	<dl>  PBOX 관리여부 미사용으로 삭제   
						<dt CL="STD_PBXCHK"></dt> 
						<dd> 
							<input type="text" class="input" name="s.trnuid" UIInput="SR"/> 
						</dd> 
					</dl>  -->
					<dl>  <!--유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--입고일자-->  
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td> 
			    						<td GH="50 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="50 STD_ADJUTY" GCol="text,ADJUTY" GF="S 4">조정문서 유형</td>	<!--조정문서 유형-->
			    						<td GH="200 STD_ADJSTX" GCol="text,ADJDSC" GF="S 90">조정타입설명</td>	<!--조정타입설명-->
			    						<td GH="50 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="60 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="50 STD_ADJUCA" GCol="text,ADJUCA" GF="S 4">조정 카테고리</td>	<!--조정 카테고리-->
			    						<td GH="60 STD_ADJUCANM" GCol="text,ADJUCANM" GF="S 20">조정카테고리명</td>	<!--조정카테고리명-->
			    						<td GH="50 STD_USRID1" GCol="text,USRID1" GF="S 20">배송지우편번호</td>	<!--배송지우편번호-->
			    						<td GH="50 STD_UNAME1" GCol="text,UNAME1" GF="S 20">배송지주소</td>	<!--배송지주소-->
			    						<td GH="50 STD_DEPTID1" GCol="text,DEPTID1" GF="S 20">배송고객명</td>	<!--배송고객명-->
			    						<td GH="50 STD_DNAME1" GCol="text,DNAME1" GF="S 20">배송지전화번호</td>	<!--배송지전화번호-->
			    						<td GH="88 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="88 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="88 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="88 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="88 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="88 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="88 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="88 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
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
			    						<td GH="70 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="80 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td>	<!--팔렛타입-->
			    						<td GH="40 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="240 STD_AREAKY" GCol="text,AREAKY" GF="S 60">동</td>	<!--동-->
			    						<td GH="70 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="240 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="200 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="30 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_QTSIWH" GCol="text,QTSIWH" GF="S 20">재고수량</td>	<!--재고수량-->
			    						<td GH="80 STD_USEQTY" GCol="text,USEQTY" GF="S 20">가용수량</td>	<!--가용수량-->
			    						<td GH="80 STD_QTSBLK" GCol="text,QTSBLK" GF="S 20">보류수량</td>	<!--보류수량-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 60">대분류</td>	<!--대분류-->
			    						<td GH="30 STD_BOXQTY" GCol="input,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="30 STD_BXIQTY" GCol="text,BXIQTY" GF="S 20" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="30 STD_REMQTY" GCol="text,REMQTY" GF="S 20">잔량</td>	<!--잔량-->
			    						<td GH="70 STD_PLTQTY" GCol="input,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="30 STD_PLIQTY" GCol="text,PLIQTY" GF="S 20" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="40 STD_RSNADJ" GCol="select,RSNADJ"><!--조정사유코드--> 
			    							<select  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
			    						</td>	
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="80 STD_QTYBUY" GCol="input,QTADJU" GF="N 20,0">매입수량</td>	<!--매입수량-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="80 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td>	<!--벤더명-->
			    						<td GH="50 STD_LOTA05" GCol="select,LOTA05">	<!--포장구분-->
												<select class="input" commonCombo="LOTA05"></select>
			    						</td>
			    						<td GH="50 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
												<select class="input" commonCombo="LOTA06"></select>
										</td>
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 8">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 8">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 8">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="160 STD_ADJRSN" GCol="text,ADJRSN" GF="S 255">조정상세사유</td>	<!--조정상세사유-->
			    						<td GH="160 STD_SBKTXT" GCol="text,SBKTXT" GF="S 75">비고</td>	<!--비고-->
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