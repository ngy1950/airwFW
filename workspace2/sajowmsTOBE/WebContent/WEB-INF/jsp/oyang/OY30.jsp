<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangOutbound",
			command : "OY30_HEAD",
			itemGrid : "gridItemList",
			itemSearch : false,
		    menuId : "OY30"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangOutbound",
			command : "OY30_ITEM",
			emptyMsgType : false,
		    menuId : "OY30"
	    });

		gridList.setReadOnly("gridHeadList", true, ["WARESR", "WARETG", "DOCUTY"]);
		gridList.setReadOnly("gridItemList", true, ["WARETG", "DOCUTY"]);
		
		$("#OWNRKY2").val('<%=ownrky %>');
		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY2").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY",$(this).val());
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WARETG").find("[UIOption]").remove();
			$("#WARESR").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WARETG").append(optionHtml);
			$("#WARESR").append(optionHtml);
			
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '<%=wareky %>');
			});
			
			if(cnt.length == 0){
				$("#WARETG option:eq(0)").prop("selected",true); 
				$("#WARESR option:eq(0)").prop("selected",true); 
			}else{
				$("#WARETG").val('<%=wareky %>');	
				$("#WARESR").val('<%=wareky %>');	
			}
			
		});

		$("#OWNRKY2").trigger('change');
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//버튼 작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY30");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OY30");
		}
	}

	//조회
	function searchList(){
		
		if(validate.check("searchArea")){
			$('#btnSave').show();
			
			if($('#WARETG').val() == $('#WARESR').val()){	//출고거점과 입고거점이 동일합니다.
				commonUtil.msgBox("VALID_M0941");
				return;
			}
			
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
		}
	}
	
	//이고 수정(이고출고 오더 ) 생성
	function saveData(){
		if (gridList.validationCheck("gridHeadList", "select") && gridList.validationCheck("gridItemList", "select")) {
			var param = inputList.setRangeParam("searchArea");
			var head = getfocusGridDataList("gridHeadList");
			var item = gridList.getSelectData("gridItemList");
			param.put("head",head);
			param.put("item",item);
			
			if(head.length < 1 || item.length < 1){ //선택된 데이터가 없습니다.
				commonUtil.msgBox("OUT_M0103"); 
				return;
			}

			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
			
				//수량체크
				if(Number(itemMap.QTYREQ) == Number(itemMap.QTYORG) ){
					commonUtil.msgBox("VALID_M0949"); // 수정수량과 최대수량이 같을 수 없습니다.
					//포커스
					gridList.setColFocus("gridItemList", item[i].get("GRowNum"), "QTYORG")
					return;
				}
			
				//이고수량보다 많은지 체크
				if(Number(itemMap.QTYREQ) < Number(itemMap.QTYORG) ){
					commonUtil.msgBox("IN_M0084"); // 전송수량이 입고수량보다 많을 수 없습니다.
					//포커스
					gridList.setColFocus("gridItemList", item[i].get("GRowNum"), "QTYORG")
					return;
				}
			
				//수량체크 마이너스 수량
				if(Number(itemMap.QTYORG) <= 0 ){
					commonUtil.msgBox("IN_M0048"); // 수량은 0보다 커야 합니다.
					//포커스
					gridList.setColFocus("gridItemList", item[i].get("GRowNum"), "QTYORG")
					return;
				}
			
				//수량체크 마이너스 수량
				if(Number(itemMap.QTYORG) <= 0 ){
					commonUtil.msgBox("IN_M0048"); // 수량은 0보다 커야 합니다.
					//포커스
					gridList.setColFocus("gridItemList", item[i].get("GRowNum"), "QTYORG")
					return;
				}
			}
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
		 	netUtil.send({
				url : "/OyangOutbound/json/saveOY30.data",
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
				searchListSaveAfter(json.data);
			}else{
				commonUtil.msgBox("VALID_M0009");
			}
		}
	}
	
	//저장 후 조회 
	function searchListSaveAfter(svbeln){
		var param = inputList.setRangeParam("searchArea");
		param.put("SVBELN",svbeln);
		
		//헤더 재조회 
		netUtil.send({
	    	module : "OyangOutbound",
			command : "OY30_HEAD2",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridHeadList" //그리드ID
		});
		
		//아이템 재조회 
		netUtil.send({
	    	module : "OyangOutbound",
			command : "OY30_ITEM2",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList" //그리드ID
		});
	}
	
	
	//아이템 조회
	function gridListEventItemGridSearch(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			//저장후 재조회처리를 위한 분기
			if(rowData.map.RECVKY.trim() != ''){
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}else{
				netUtil.send({
			    	module : "OyangOutbound",
					command : "OY30_ITEM2",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList" //그리드ID
				});
			}
		}
	}
	

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTYORG"){  
				if(Number(colValue) > gridList.getColData("gridItemList", rowNum, "QTYREQ")){//수량변경시 최대수량을 초과하는지 체크
					commonUtil.msgBox("VALID_M0328"); //최대수량을 초과할 수 없습니다.
					gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColFocus(gridId, rowNum, "QTYORG");
					return;
				}
			 }
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount > 0){
			//재조회시 자동 bind를 막기 위함
			if(" " != gridList.getColData("gridHeadList", 0, "RECVKY")){
				gridList.resetGrid("gridItemList");
				gridListEventItemGridSearch(gridId, 0)
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCUTY", "121");
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
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" id="btnSearch"  CB="Search SEARCH BTN_SEARCH" />
					<input type="button" id="btnSave" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			
			
			<div class="search_inner">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY2"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO" ComboCodeView="true"></select>
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="ORDDAT" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>
						<dt CL="STD_WAREKY2"></dt>
						<dd>
							<select name="WARETG" id="WARETG" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_WARESR2"></dt>
						<dd>
							<select name="WARESR" id="WARESR" class="input" ComboCodeView="true"></select>
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
			    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="150 STD_WARESRREV" GCol="select,WARESR"  validate="required"> <!--출고지시거점-->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
										</td>	
			    						<td GH="150 STD_WARETG" GCol="select,WARETG"  validate="required"><!--도착거점-->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="120 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>	
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_OTRQDT" GCol="input,OTRQDT" GF="D 8"  validate="required">출고요청일</td>	<!--출고요청일-->
			    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
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
										<td GH="40" GCol="rowCheck"></td> 
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="80 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="80 STD_DPTNKY" GCol="select,WARETG">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select> <!--업체코드-->
			    						</td>
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 6">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 0">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 20">동</td>	<!--동-->
			    						<td GH="80 STD_LOTNUM" GCol="input,LOTNUM" GF="S 20">Lot number</td>	<!--Lot number-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_MAXQTY" GCol="text,QTYREQ" GF="S 20">최대수량</td>	<!--최대수량-->
			    						<td GH="80 STD_QTYRCV" GCol="input,QTYORG" GF="S 20">입고수량</td>	<!--입고수량-->
			    						<td GH="80 STD_QTYUOM" GCol="text,QTYUOM" GF="S 20">Quantity by unit of measure</td>	<!--Quantity by unit of measure-->
			    						<td GH="80 STD_QTYSTD" GCol="text,QTYSTD" GF="S 20">팔렛트 적재수량</td>	<!--팔렛트 적재수량-->
			    						<td GH="80 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">	<!--소분류-->
											<select class="input" commonCombo="SKUG03"></select>
										</td>
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