<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL00</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "CAR_STATUS_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true ,
		    menuId : "DL80"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "CAR_STATUS_ITEM",
			emptyMsgType : false ,
		    menuId : "DL80"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
		//R.CARDAT 하루 더하기 
		inputList.rangeMap["map"]["R.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));

		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력 
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "266");
		var rangeDataMap2 = new DataMap();
		// 필수값 입력 
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "267");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);	
		rangeArr.push(rangeDataMap2);	
		setSingleRangeData('H.SHPMTY', rangeArr);	

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
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY",$("#OWNRKY").val());
			param.put("WAREKY",$("#WAREKY").val());

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
			param.putAll(rowData);
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
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
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}

	function saveData(){
		if(gridList.validationCheck("gridHeadList", "modify")){
			
			//선택된 행의 데이터
			var head = gridList.getSelectData("gridHeadList");
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//저장시 벨리데이션 확인
			for(var i=0 ; i<head.length;i++){
				var row = head[i];
				if($.trim(row.get["CARDAT"])=="" && row.get["CASTYN"] == "Y"){
					commonUtil.msgBox("* 출발일자는 필수 입니다. *"); // << text 가 아닌 메세지 생성후 메세지 키값으로 등록
					
					return;
				}
			}
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/outbound/json/saveDL80.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
 	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
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
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL80");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL80");
		}
	}
	
	  //서치헬프 기본값 세팅
	  function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	        var param = new DataMap();
	        
	        if(searchCode == "SHBZPTN" && $inputObj.name == "H.DPTNKY"){
	            param.put("PTNRTY","0002");
	            param.put("OWNRKY","<%=ownrky %>");
	         //출고유형
	        }else  if(searchCode == "SHDOCTM" && $inputObj.name == "H.SHPMTY"){
	                param.put("DOCCAT","200");
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
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
					<dl> <!-- 거래처 -->
						<dt CL="STD_KUNAG"></dt>
						<dd>
							<input type="text" class="input" name="H.DPTNKY" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>					
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 			
					<dl> <!-- 제품명 -->
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input type="text" class="input" name="I.DESC01" UIInput="SR"/>
						</dd>
					</dl>
					<dl>  <!--출고유형-->  
						<dt CL="STD_SHPMTY"></dt> 
						<dd> 
							<input type="text" class="input" name="H.SHPMTY" UIInput="SR,SHDOCTM" readonly/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="R.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl> <!-- 문서일자 -->
						<dt CL="STD_DOCDAT"></dt>
						<dd>
							<input type="text" class="input" name="H.DOCDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>					
					<dl> <!-- 배송일자 -->
						<dt CL="STD_CARDAT"></dt>
						<dd>
							<input type="text" class="input" name="R.CARDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>					
					<dl> <!-- 배송차수 -->
						<dt CL="STD_SHIPSQ"></dt>
						<dd>
							<input type="text" class="input" name="R.SHIPSQ" UIInput="SR"/>
						</dd>
					</dl>					
					<dl> <!-- 차량번호 -->
						<dt CL="IFT_CARNUM"></dt>
						<dd>
							<input type="text" class="input" name="R.CARNUM" UIInput="SR"/>
						</dd>
					</dl>					
					<dl> <!-- 기사명 -->
						<dt CL="STD_DRIVER"></dt>
						<dd>
							<input type="text" class="input" name="C.DRIVER" UIInput="SR"/>
						</dd>
					</dl>					
					<dl> <!-- 차량출발여부 -->
						<dt CL="STD_CASTYN"></dt>
						<dd>
							<select name="CASTYN" class="input" Combo="SajoCommon,CMCDV_COMBO"></select>
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
										<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 100">화주</td>	<!--화주-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 100">거점</td>	<!--거점-->
			    						<td GH="100 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="100 STD_CARDAT" GCol="text,CARDAT" GF="D 100">배송일자</td>	<!--배송일자-->
			    						<td GH="100 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 100">차량번호</td>	<!--차량번호-->
			    						<td GH="100 STD_CARNUMNM" GCol="text,CARNUMNM" GF="S 100">차량정보</td>	<!--차량정보-->
			    						<td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 100">기사명</td>	<!--기사명-->
			    						<td GH="80 STD_PERHNO" GCol="input,PERHNO" GF="S 100">기사핸드폰</td>	<!--기사핸드폰-->
			    						<td GH="80 STD_CARTYP" GCol="text,CARTYP" GF="S 100">차량 톤수</td>	<!--차량 톤수-->			    						
										<!-- 화면 그리드 서치 헬프및 그리드 확인 -->
			    						<td GH="200 STD_CASTYN"   GCol="select,CASTYN">
											<select commonCombo="OUTBYN"><option></option></select>
										</td><!--차량출발여부-->
			    						<td GH="80 STD_CASTDT" GCol="input,CASTDT" GF="C 100">차량출발일자</td>	<!--차량출발일자-->
			    						<td GH="80 STD_CASTIM" GCol="input,CASTIM" GF="T 100">출발시간</td>	<!--출발시간-->
			    						<td GH="80 STD_RECNUM" GCol="input,RECNUM" GF="S 100">재배차 차량번호</td>	<!--재배차 차량번호-->						
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 100">화주</td>	<!--화주-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 100">거점</td>	<!--거점-->
			    						<td GH="100 STD_DEPART" GCol="text,DEPART" GF="S 100">출발지권역코드</td>	<!--출발지권역코드-->
			    						<td GH="100 STD_CARDAT" GCol="text,CARDAT" GF="S 100">배송일자</td>	<!--배송일자-->
			    						<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 100">차량번호</td>	<!--차량번호-->
			    						<td GH="100 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="100 STD_KUNAG" GCol="text,DPTNKY" GF="S 100">거래처</td>	<!--거래처-->
			    						<td GH="100 STD_KUNAGNM" GCol="text,DPTNKYNM" GF="S 100">판매처명</td>	<!--판매처명-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 100">제품코드</td>	<!--제품코드-->
			    						<td GH="100 STD_DESC01" GCol="text,DESC01" GF="S 100">제품명</td>	<!--제품명-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 100">규격</td>	<!--규격-->
			    						<td GH="100 STD_UOMKEY" GCol="text,UOMKEY" GF="S 100">단위</td>	<!--단위-->
			    						<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td>	<!--재고수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
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