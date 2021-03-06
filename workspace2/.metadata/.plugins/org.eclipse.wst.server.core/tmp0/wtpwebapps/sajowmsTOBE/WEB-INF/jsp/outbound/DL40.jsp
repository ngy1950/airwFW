<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL40</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'DL40';
 	var TASKKYS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL40_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
		    menuId : "DL40"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL40_ITEM",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			emptyMsgType : false,
		    tempKey : "SVBELN",
		    useTemp : true,
			tempHead : "gridHeadList",
		    menuId : "DL40"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());	
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		rangeArr.push(rangeDataMap2);		
		setSingleRangeData('TASDH.STATDO', rangeArr);
		
		//배열선언
		var rangeArr2 = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap3 = new DataMap();
		// 필수값 입력
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "210");
		var rangeDataMap4 = new DataMap();
		rangeDataMap4.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap4.put(configData.INPUT_RANGE_SINGLE_DATA, "208");
		//배열에 맵 탑제 
		rangeArr2.push(rangeDataMap3);		
		rangeArr2.push(rangeDataMap4);		
		setSingleRangeData('TASOTY', rangeArr2);


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
	
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('GRPRL', group)
			if (TASKKYS != "") {
				param.put('TASKKYS',TASKKYS);
			}
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put('PROGID',PROGID)			
//			param.put('TOTALPICKING',TOTALPICKING)
			param.putAll(rowData);
			if (TASKKYS != "") {
				param.put('TASKKYS',TASKKYS);
			} 			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
			
			TASKKYS = '';	
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "200");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			} else if(name == "C00102"){
				param.put("CMCDKY", "C00102");	
			} else if(name == "CASTYN"){
				param.put("CMCDKY", "ALLYN");	
			} else if(name == "ALSTKY"){
				param.put("CMCDKY", "ALSTKY");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
		}else if( comboAtt == "SajoCommon,ALSTKY_COMCOMBO" ){			
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "210");
//			param.put("DIFLOC", "V");
			param.put("OWNRKY", <%=ownrky%>);
		}
		
		return param;
	}
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "QTSHPO" || colName == "BOXQTY" || colName == "REMQTY"){
				var qtshpo = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				var remqtyChk = 0;
								
			  	if( colName == "QTSHPO" ) { 		  		
			  		boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtshpo)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtshpo)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					remqty = shpdi.GetCellValueById(rowId, "remqty");
				  	qtshpo = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
					  	
					//박스수량을 낱개수량으로 변경하여 계산한다.
				  	qtshpo = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  				  	
				  	//계산한 수량 세팅
				    gridList.setColValue(gridId, rowNum, "QTSHPO", qtshpo);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				    gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "REMQTY" ){ //잔량변경시
					qtshpo = Number(gridList.getColData(gridId, rowNum, "QTSHPO"));
			  		boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
						  
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtshpo = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  	
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTSHPO", qtshpo);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
			 }
		}
	}
	
	function confirmOrderTask(){    
	
      var head = gridList.getSelectData("gridHeadList");
      var item = gridList.getSelectData("gridItemList");
      //아이템 템프 가져오기
      var tempItem = gridList.getSelectTempData("gridHeadList");
      
	  if(head.length == 0){
	    commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	    return;
	  }
	  	
	  var param = new DataMap();
	  param.put("head",head);
	  param.put("item",item);
	  param.put("itemTemp",tempItem);
	
	  netUtil.send({
	    url : "/outbound/json/pickingDL40.data",
	    param : param,
	    successFunction : "successSaveCallBack"
	  });
	}
	  
	function confirmOrderTaskAll(){	
		if(confirm("피킹완료 하시겠습니까?")) {
			gridList.checkAll("gridHeadList",true);
			confirmOrderTask();
		}
	}	 

	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){
				//템프 초기화
				gridList.resetTempData("gridHeadList");
				
				commonUtil.msgBox("SYSTEM_SAVEOK");
				TASKKYS = json.data;
				searchList();
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reload(){
		gridList.resetGrid("gridItemList");
		searchList();
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Create"){
			CreateOrderDocData();
	    }else if(btnName == "confirmOrderTask"){
	        confirmOrderTask();
	    }else if(btnName == "confirmOrderTaskAll"){
	        confirmOrderTaskAll();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL40");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL40");
		}else if (btnName == "Print"){
			print();
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//ezgen 구현
	function print(){
		var wherestr = " AND TASKKY IN (";

		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			var count = 0;
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
 
			var where = "";
			//반복문을 돌리며 특정 검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				if(where == ""){
					where = where+" AND H.TASKKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("TASKKY") + "'";
				count++;
			}
			where += ")";
			
			if(count < 1 ){
				commonUtil.msgBox("SYSTEM_NOTPR");
				return;
			}
			
			//아래의 구버전 소스를 신버전 소스로 변경(EZGEN IORDERBY 문자열을 생성한다) 			
			var orderby = " ORDER BY ";
			
			//신버전 코드 
			//라디오 버튼 값
			if ($('#PRT_ORD_LOCAKY').prop("checked") == true ) {
				orderby += "LOCASR";
			}else if ($('#PRT_ORD_SKUKEY').prop("checked") == true ){
				orderby += "DESC01,LOCASR";
			}else if ($('#PRT_ORD_TASKIT').prop("checked") == true ){
				orderby += "TASKIT";
			};
			
			//이지젠 호출부(신버전)
			var width = 840;
			var heigth = 600;
			var map = new DataMap();
			WriteEZgenElement("/ezgen/order_picking_list.ezg" , where , orderby , "KO", map , width , heigth );
		}
	}

	   
    //데이터가 바인드된후 
    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
    	if(gridId=="gridHeadList"){
    		gridList.setReadOnly("gridHeadList", true, ["SHPMTY"]);
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
					<input type="button" CB="confirmOrderTask PICKED BTN_PICKED" />
					<input type="button" CB="confirmOrderTaskAll PICKYN_ALL STD_PICKYN_ALL" />
					<input type="button" CB="Print PRINT_OUT BTN_PKPRINT" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
					<dl>  <!--영업(D/O) -->
						<dt CL="STD_GROUP"></dt>
						<dd>
							<input type="radio" class="input" id="ERPSO"  name="GROUP" checked /> 영업
							<input type="radio" class="input" id="MOVE"   name="GROUP" /> 이고
							<input type="radio" class="input" id="PTNPUR" name="GROUP" /> 매입반품
						</dd>
					</dl>
					<dl>  <!--작업지시일자-->  
						<dt CL="STD_TASKDT"></dt> 
						<dd> 
							<input type="text" class="input" name="DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="CARDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl> 					
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASOTY" UIInput="SR" value="210" readonly/> 
						</dd> 
					</dl> 
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 										
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.STATDO" UIInput="SR,SHVSTATDO"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 

					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="CARNUM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SVBELN" UIInput="SR"/> 
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_PRINTOPT" style="PADDING: 0 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="radio" CL="STD_LOCAORD" name="PRT_ORD" id="PRT_ORD_LOCAKY" checked /><label for="PRT_ORD_LOCAKY" style="margin-right:5px; margin-left:-23px">로케이션순 </label>
		        		<input type="radio" CL="STD_SKUORD" name="PRT_ORD" id="PRT_ORD_SKUKEY" /><label for="PRT_ORD_SKUKEY" style="margin-right:5px; margin-left:-23px">제품명순 </label>
		        		<input type="radio" CL="STD_ITEMORD" name="PRT_ORD" id="PRT_ORD_TASKIT" /><label for="PRT_ORD_TASKIT" style="margin-right:5px; margin-left:-23px">아이템번호순 </label>
					</li>
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
									<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">	<!-- 출고유형 -->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 90">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10,0">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_SHSTATDONM" GCol="text,SHSTATDONM" GF="S 10">출고문서상태명</td>	<!--출고문서상태명-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 10">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 10">업체명</td>	<!--업체명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
			    						<td GH="80 STD_WARETG" GCol="text,WARETG" GF="S 4">도착거점</td>	<!--도착거점-->
			    						<td GH="200 STD_TASSTX" GCol="text,ADJDSC" GF="S 90">작업타입설명</td>	<!--작업타입설명-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_TASKKY" GCol="input,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="160 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->
			    						<td GH="50 STD_TASKIT" GCol="input,TASKIT" GF="N 6,0">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="140 STD_RSNCOD" GCol="select,RSNCOD">	<!--사유코드-->
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
			    								<option></option>
			    							</select>
		                                </td>
			    						<td GH="50 STD_TASRSN" GCol="input,TASRSN" GF="S 255">상세사유</td>	<!--상세사유-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="64 STD_ACTCDT" GCol="text,ACTCDT" GF="D 8">실제완료날짜</td>	<!--실제완료날짜-->
			    						<td GH="50 STD_ACTCTI" GCol="text,ACTCTI" GF="T 6">실제완료시간</td>	<!--실제완료시간-->
			    						<td GH="80 STD_LOCAAC" GCol="text,LOCAAC" GF="S 20">실로케이션</td>	<!--실로케이션-->
			    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td>	<!--출발지-->
			    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td>	<!--재배차 여부-->
			    						<td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="64 STD_REFDAT" GCol="text,REFDAT" GF="S 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">가로길이</td>	<!--가로길이-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td>	<!--CAPA-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
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
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>