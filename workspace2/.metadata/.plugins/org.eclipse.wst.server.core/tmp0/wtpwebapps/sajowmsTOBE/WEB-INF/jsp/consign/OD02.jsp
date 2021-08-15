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
			command : "OD02_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OD02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "ConsignOutbound",
	    	colorType : true ,
			command : "OD02_ITEM",
		    menuId : "OD02"
	    });

		gridList.setReadOnly("gridItemList", true, ["LOTA05","LOTA06"]);

		// 대림 이고 전용 콤보로 세팅 

		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY2").val('2500');	 
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
			sajoUtil.openSaveVariantPop("searchArea", "OD02");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OD02");
		}
	}
	
	
	//조회
	function searchList(){

		$('#btnSave').show();
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
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


	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		if (gridList.validationCheck("gridHeadList", "data") && gridList.validationCheck("gridItemList", "data") ) {

			var param = inputList.setRangeDataParam("searchArea");
			var head = gridList.getSelectData("gridHeadList");
			var item = gridList.getGridBox("gridItemList").getDataAll();
			param.put("head",head);
			param.put("item",item);

			if (head.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			var dupMap = new DataMap();
			for(var i=0; i<head.length; i++){
				var headMap = head[i].map;
				
				//ORDDAT 와 현재 날짜가 30일 이상 차이나면 저장 불가
				var sysdate = new Date(); 
				var docdat = strToDate(headMap.DOCDAT);
				if(Math.abs((docdat-sysdate)/1000/60/60/24) > 30){
					commonUtil.msgBox("DAERIM_DATECHK");
					return;
				}
				
				if(Number(headMap.DOCDAT) < Number(headMap.DOCDATMV)){
					commonUtil.msgBox("IN_DATECHK");//확정일자는 이고 출고일보다 이전일 수 없습니다.
					return;
				}
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}

			netUtil.send({
				url : "/ConsignOutbound/json/saveOD02.data",
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
				$('#btnSave').hide();

				searchListSaveAfter(json.data.SHPOKYS);
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
			
			if(rowData.map.RECVKY && rowData.map.RECVKY != '' && rowData.map.RECVKY != ' '){ //입고문서번호가 생성된 경우 
				//아이템 재조회
				netUtil.send({
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
			    	module : "ConsignOutbound", 
					command : "OD02_ITEM2",
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
	function searchListSaveAfter(shpokys){
		var param = inputList.setRangeParam("searchArea");
		param.put("SHPOKYS",shpokys);
		
		// 재조회
		netUtil.send({
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
	    	module : "ConsignOutbound", 
			command : "OD02_HEAD2",
			bindId : "gridHeadList" //그리드ID
		});
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCUTY", "121");
		}
		
		return param;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHWAHMA"){
            param.put("NOBIND","Y");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "V.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY",$("#WARESR").val());
        	
        }else if(searchCode == "SCLOCMA_RS"){
            param.put("WAREKY",$("#WAREKY2").val());
			//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RECV");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    	 	
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "STOR");
    		rangeArr.push(rangeDataMap); 

            param.put("AREATY", returnSingleRangeDataArr(rangeArr));
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
					<dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO"></select> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="IFT_SHPOKYMV"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서일자-->  
						<dt CL="IFT_DOCDATMV"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--From 거점-->  
						<dt CL="STD_WAREFR"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.WARESR" UIInput="SR,SHWAHMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.DESC01" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck"></td>     
			    						<td GH="50 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="70 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 120">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="70 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td>	<!--입고유형명-->
			    						<td GH="55 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="70 STD_DOCDAT" GCol="input,DOCDAT" GF="D 8"  validate="required">문서일자</td>	<!--문서일자-->
			    						<td GH="55 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="70 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="55 IFT_WARERQ" GCol="text,DPTNKY" GF="S 10">작업거점</td>	<!--작업거점-->
			    						<td GH="80 IFT_WARERQNM" GCol="text,DPTNKYNM" GF="S 100">출고거점명</td>	<!--출고거점명-->
			    						<td GH="30 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 100">출고일자</td>	<!--출고일자-->
			    						<td GH="80 도착일자" GCol="text,CARDAT" GF="D 100">도착일자</td>	<!--도착일자-->
			    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 100">차량번호</td>	<!--차량번호-->
			    						<td GH="100 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 STD_CASTDT" GCol="text,CASTDT" GF="D 100">차량출발일자</td>	<!--차량출발일자-->
			    						<td GH="80 STD_PERHNO" GCol="text,PERHNO" GF="S 100">기사핸드폰</td>	<!--기사핸드폰-->
			    						<td GH="60 STD_CASTIM" GCol="text,CASTIM" GF="T 100">출발시간</td>	<!--출발시간-->
			    						<td GH="80 재배차 차량번호" GCol="text,RECNUM" GF="S 100">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="80 STD_CASTYN" GCol="text,CASTYN" GF="S 1">차량출발여부</td>	<!--차량출발여부-->
			    						<td GH="80 IFT_SHPOKYMV" GCol="text,SHPOKYMV" GF="S 100">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 IFT_DOCDATMV" GCol="text,DOCDATMV" GF="D 100">출고문서일자</td>	<!--출고문서일자-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
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
			    						<td GH="50 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="50 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="60 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="50 STD_LOCAKY" GCol="input,LOCAKY,SCLOCMA_RS" GF="S 20" validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="50 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="80 STD_ORDQTY" GCol="text,ORDQTY" GF="N 17,0">지시수량</td>	<!--지시수량-->
			    						<!-- <td GH="80 STD_QTYTRF" GCol="text,QTYTRF" GF="N 17,0"></td>	 -->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="60 STD_PBOXQTY" GCol="text,PBOXQTY" GF="N 17,1">P박스수량</td>	<!--P박스수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="60 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
			    						<td GH="60 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="60 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0">유통잔여(%)</td>	<!--유통잔여(%)-->
			    						<td GH="80 STD_LOTA05" GCol="select,LOTA05">	<!--포장구분-->
			    							<select class="input" commonCombo="LOTA05"></select>
			    						</td>
			    						<td GH="80 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
			    							<select class="input" commonCombo="LOTA06"></select>
			    						</td>
			    						<td GH="80 STD_LOTA11" GCol="input,LOTA11" GF="C">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA13" GCol="input,LOTA13" GF="C" validate="required">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 30">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="80 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="80 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="80 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="80 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="100 STD_SBKTXT" GCol="input,SBKTXT" GF="S 150">비고</td>	<!--비고-->
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