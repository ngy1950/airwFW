<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<script type="text/javascript">

var input = '';
var mode = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileInbound",
			command : "MGR05",
			gridMobileType : true
	    });
		//레이어 팝업
		gridList.setGrid({
	    	id : "LayerGridList",
			module : "MobileInbound",
			command : "MGR05_POP",
			gridMobileType : true
	    });

		$("#RECVKY").focus();
		$("#RECVKY").keyup(function(e){if(e.keyCode == 13)searchList();});
		//팝업창 타스키 검색
		$("#BARCODE_POP").keyup(function(e){if(e.keyCode == 13)POP_searchList();});
		
		//검색값 클릭시 초기화
 		$("#RECVKY").click(function(){$(this).select()}) 
 		$("#BARCODE_POP").click(function(){$(this).select()}) 


		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#RECVKY";

		$('#searchArea input').focus(function(){
			input = this;
			if(mode != 'key'){
				$(this).attr("inputmode","none")
			}
			if($(this).hasClass("calendarInput") == false && $(this).prop("readonly") == false && $(this).prop("type") != "button" && mode != 'key'){
				$('#keyboardBtn').fadeIn("fast");
			}
			mode = 'none'

		});
		$('#searchArea input').blur(function(){
			var input = this;
			$('#keyboardBtn').fadeOut("fast");
		});
		
		$('#keyboardBtn').click(function(){
			mode = 'key';
			$('#keyboardBtn').fadeOut("fast");
			$(input).attr("inputmode","text");
			$(input).focus();
		});

	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var recvky = $("#RECVKY").val();
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("RECVKY",recvky);
			
			if (recvky.trim() == ""){
				commonUtil.msgBox(" 문서번호를 입력해주세요."); 
				$("#RECVKY").val("");
				$("#RECVKY").focus();
				return 
			}
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			
			// 검색조건 선택후 블러처리
			$("#RECVKY").focus();
			$("#RECVKY").select();
			
// 			$("#RECVKY").val("");
// 			$("#LOCATG").val("");
// 			$("#TRNUTG").val("");
// 			$("#RECVKY").focus();
		}
	}
	
	//팝업창 서치리스트 조회 
	function POP_searchList(){ 
		if(validate.check("searchArea")){ 
			var param = inputList.setRangeParam("searchArea"); 
			var data = gridList. getGridData("LayerGridList");
			var grid = gridList.getRowData("gridList", gridList.getFocusRowNum("gridList")); 
			param.put("OWNRKY", "<%=ownrky%>"); 
			param.put("WAREKY", "<%=wareky%>"); 
			param.put("BARCODE",$("#BARCODE_POP").val()); 
			param.put("SKUKEY",grid.map.SKUKEY);
			param.put("Data",data); 
			 
			var trnuidStr = "AND B.BARCOD IN ("; 
			for(var i = 0; i < data.length; i++ ){ 
				var trnuid = gridList.getColData("LayerGridList", data[i].get("GRowNum"), "TRNUID"); 
				if(trnuid == $("#BARCODE_POP").val()){ 
					commonUtil.msgBox(" 동일한 바코드가 존재합니다."); 
					$("#BARCODE_POP").select();
					return 
				} 
				if(i==0){ 
					trnuidStr+="'"+trnuid+"'"; 
				}else{ 
					trnuidStr+=",'"+trnuid+"'"; 
				} 
			} 
			 
			if(data.length < 1 ){ 
				trnuidStr+="'"+$("#BARCODE_POP").val()+"'"; 
			}else{ 
				trnuidStr+=",'"+$("#BARCODE_POP").val()+"'"; 
			} 
			 
			trnuidStr += ")"; 
			 
			param.put("TRNUIDS",trnuidStr); 
			gridList.resetGrid("LayerGridList");
			
			netUtil.send({ 
				url : "/mobile/MobileInbound/json/searchMGR05_POP.data", 
				param : param, 
				sendType : "list", 
				bindType : "grid",  //bindType grid 고정 
				bindId : "LayerGridList" //그리드ID 
			}); 
			
			// 검색조건 선택후 블러처리
			$("#BARCODE_POP").focus();
			$("#BARCODE_POP").select();
		} 
	}

	//To지번 추천
	function recommend(){
		var param = new DataMap();
		var data = gridList.getSelectData("gridList");
		
		if(data.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var focusData = gridList.getRowData("gridList", gridList.getFocusRowNum("gridList")); 
		
		param.put("OWNRKY", "<%=ownrky%>");
		param.put("WAREKY", "<%=wareky%>");
		param.put("SKUKEY",focusData.map.SKUKEY);
		param.put("LOCAKY","");

		var json = netUtil.sendData({
			module : "MobileInbound",
			command : "MGR06_LOKA",
			sendType : "map",
			param : param
		});
		
		//조회한 쿼리에서 LOCAKY 가져오기
 		if(json.data.LOCAKY != ""){
			$('#LOCATG_POP').val(json.data.LOCAKY);
			//return;
		}else{
			var locaky = gridList.getColData("gridList", data[0].get("GRowNum"), "LOCAKY");
			$('#LOCATG_POP').val(locaky);
		}
 		
	}

	
	//팝업창 저장
	function POP_saveData(){
		if(gridList.validationCheck("LayerGridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getGridData("LayerGridList");
	        
	        
	        var locatrg = $("#LOCATG_POP").val();
	        // 선택된 원 그리드
	        var grid = gridList.getSelectData("gridList");
/* 			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			} */
			
			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;

				if((Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("VALID_M0952");
					gridList.setColFocus("LayerGridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}else if((Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTYWRK")) > (Number)(grid[0].map.QTSIWH)){
					commonUtil.msgBox("VALID_M0923");
					gridList.setColFocus("LayerGridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}
				

				param.put("LOTA01", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA01"));
				param.put("LOTA02", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA02"));
				param.put("LOTA03", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA03"));
				param.put("LOTA04", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA04"));
				param.put("LOTA05", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA05"));
				param.put("LOTA06", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA06"));
				param.put("LOTA07", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA07"));
				param.put("LOTA08", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA08"));
				param.put("LOTA09", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA09"));
				param.put("LOTA10", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA10"));
				param.put("LOTA12", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA12"));
				param.put("LOTA14", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA14"));
				param.put("LOTA15", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA15"));
				param.put("LOTA16", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA16"));
				param.put("LOTA17", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA17"));
				param.put("LOTA18", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA18"));
				param.put("LOTA19", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA19"));
				param.put("LOTA20", gridList.getColData("gridList", grid[0].get("GRowNum"), "LOTA20"));
			}
			
			if(locatrg.trim() == ""){
				commonUtil.msgBox("VALID_M0404");
				$("#LOCATG_POP").focus();
				return;
			}
			
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCAKYPOP", locatrg);
			param.put("JOBTYP", "310");
			param.put("gridId","LayerGridList");
			param.put("grid",grid);
			
			
			netUtil.send({
				url : "/mobile/MobileInbound/json/saveMGR05_POP.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){		
		if (json && json.data) {
			if (json.data == "S") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("LayerGridList");
				$("#BARCODE_POP").val("")
				$("#LOCATG_POP").val("");
				$("#WORKSUM4").val("");
				$("#PLTQTY_POP").val("");
				$("#BOXQTY_POP").val("");
				$("#REMQTY_POP").val("");
				
				LayerPopClose();
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			$("#LOCATG_POP").val("");
			$("#WORKSUM4").val("");
			$("#PLTQTY_POP").val("");
			$("#BOXQTY_POP").val("");
			$("#REMQTY_POP").val("");
			gridList.resetGrid("LayerGridList");
			calTotal();
		}else if(gridId == "LayerGridList" && dataCount > 0){
			calTotal();
			$("#BARCODE_POP").val("");
		}
	}
	
	//합계 계산
	function calTotal(){
		var worksum1 = 0;
		var worksum2 = 0;
		var list = gridList.getSelectData("gridList");
		var list2 = gridList.getGridData("gridList");
		
		//선택 합계
		for(var i=0; i<list.length; i++){
			var gridMap = list[i].map;
			worksum1 = worksum1+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "QTYSTD"));
		}
		
		//총 합계
		for(var i=0; i<list2.length; i++){
			var gridMap = list2[i].map;
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list2[i].get("GRowNum"), "QTSIWH"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
		
		
		//팝업창 합계 계산
		var pop_list2 = gridList.getGridData("LayerGridList");
		var grid = gridList.getSelectData("gridList");
		
		// 값이 없는 경우
		if(grid == ""){
			return;
		}
		
		var qtywrk = 0;
		var boxqty = 0;
		var remqty = 0;
		var pltqty = 0;
 		var bxiqty = gridList.getColData("gridList", grid[0].get("GRowNum"), "QTDUOM"); // 박스 입수
		var ptystd = gridList.getColData("gridList", grid[0].get("GRowNum"), "QTYSTD"); // 팔레트 적재수량
		
		//총 작업 합계
		for(var i=0; i<pop_list2.length; i++){
			var gridMap = pop_list2[i].map;
// 			qtsiwh = qtsiwh+(Number)(gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "QTSIWH"));
// 			boxqty = boxqty+(Number)(gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "BOXQTY"));
// 			remqty = remqty+(Number)(gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "REMQTY"));
// 			qtywrk = gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "QTYWRK");
// 			pltqty = pltqty + parseInt((Number)(ptystd)/(Number)(qtywrk));
			qtywrk = qtywrk+(Number)(gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "QTYWRK")); //작업수량 
		}
		
		boxqty = parseInt((Number)(qtywrk)/(Number)(bxiqty));
		remqty = (Number)(qtywrk)%(Number)(bxiqty);
		if(remqty > 0){
			boxqty++;
		}
		pltqty = parseInt((Number)(qtywrk)/(Number)(ptystd));
		var pltqty_less = (Number)(qtywrk)%(Number)(ptystd);
		if(pltqty_less > 0){
			pltqty++;
		}
		
		
// 		gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "QTYWRK");
// 		pltqty = pltqty + parseInt((Number)(ptystd)/(Number)(qtywrk));
		
		$("#WORKSUM4").val(qtywrk);
		$("#PLTQTY_POP").val(pltqty);
		$("#BOXQTY_POP").val(boxqty);
		$("#REMQTY_POP").val(remqty);
	}
	
	//그리드 컬럼 변경 이벤트            
	// QTSIWH 재고수량 , QTYWRK 작업수량 , QTDUOM 입수, BOXQTY 박스수량, REMQTY 잔량
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "QTYWRK"){ //수량변경시연결된 작업수량 변경 
			var boxqty = 0;
			var remqty = 0;
			
			var bxiqty = Number(gridList.getColData(gridId, rowNum, "QTDUOM")); //입수
			var qtywrk = Number(gridList.getColData(gridId, rowNum, "QTYWRK")); //작업수량
			boxqty = parseInt((Number)(qtywrk)/(Number)(bxiqty)); // 박스 = 작업수량 / 입수 
			remqty = (Number)(qtywrk)%(Number)(bxiqty);
			
			if(remqty > 0){
				boxqty++;
			}
			
			gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
		 	gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				 	
		//수량 CHECK
		 	if(Number(colValue) > Number(gridList.getColData(gridId, rowNum, "QTSIWH"))){
			 	commonUtil.msgBox("VALID_M0923");
				gridList.setColValue(gridId, rowNum, "QTYWRK", 0);
				gridList.setColFocus(gridId, rowNum, "QTYWRK");
		 	}
		 	calTotal();
		 	
		// LOTA11 제조일자
		}else if( colName == "LOTA11" ){
			var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
			var lota11 = gridList.getColData(gridId, rowNum, "LOTA11");
			var lota13 = dateParser(lota11 , 'S', 0 , 0 , Number(outdmt)) ;
			gridList.setColValue(gridId, rowNum, "LOTA13", lota13);
	    	
		// LOTA13 유통기한 
		} else if( colName == "LOTA13" ){
			var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
			var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
			var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt)) ;
			gridList.setColValue(gridId, rowNum, "LOTA11", lota11);
		}
	}
	
	//레이어 팝업 열기
	function LayerPop() {
		var data = gridList.getSelectData("gridList");
		if(data.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}else if(data.length == 1) {
			//그리드에서 정보 가져오기
			var skukey = gridList.getColData("gridList", data[0].get("GRowNum"), "SKUKEY");
			var desc01 = gridList.getColData("gridList", data[0].get("GRowNum"), "DESC01");
			var qtsiwh = gridList.getColData("gridList", data[0].get("GRowNum"), "QTSIWH");
			var pltqty = gridList.getColData("gridList", data[0].get("GRowNum"), "PLTQTY");
			var boxqty = gridList.getColData("gridList", data[0].get("GRowNum"), "BOXQTY");
			var remqty = gridList.getColData("gridList", data[0].get("GRowNum"), "REMQTY");
			var trnuid = gridList.getColData("gridList", data[0].get("GRowNum"), "TRNUID");
			
			$("#BARCODE_POP").val("");
			$("#SKUKEY_POP").val(skukey);
			$("#DESC01_POP").val(desc01);
			$("#QTSIWH_POP").val(qtsiwh);
			$("#PLTQTY_POP").val(pltqty);
			$("#BOXQTY_POP").val(boxqty);
			$("#REMQTY_POP").val(remqty);
			$("#LOCATG_POP").val("RCVLOC");
			
			$(".layer_popup .label-btn").show();
			$(".layer_popup").animate({height:"100%"},500);

			$("#BARCODE_POP").focus();
			$("#BARCODE_POP").select();
			
		}else if(data.length > 1){
			commonUtil.msgBox("* 1개의 데이터만 선택해주세요. *");
			return;
		}
		
	}
	//레이어 팝업 닫기
	function LayerPopClose() {
		$(".layer_popup").animate({height:"0%"},500,function(){$(".layer_popup .label-btn").hide()});
	}

</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>팔렛타이징</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_DOCKEY">문서번호<span class="make">*</span></th>
								<td><input type="text" id="RECVKY" name="RECVKY" class="input input-width" validate="required(STD_DOCKEY)"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>		
		<div class="mobile-data-inner">
			<div class="mobile-data mobile-departure content_layout" >
				<div class="mobile-data-box section" style="height:calc(100vh - 200px);">
					<div class="scroll" style="width:100%;height: calc(100% - 30px);overflow:auto;white-space: nowrap;">
						<table>
							<tbody id="gridList">
								<tr CGRow="true">
									<td GH="40" GCol="rownum">1</td>                           
									<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td>
									<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" </td>  <!-- 제품코드 -->
									<td GH="80 STD_PREQTY" GCol="text,PREQTY" </td>  <!-- 선입고  -->
									<td GH="300 STD_DESC01" GCol="text,DESC01" </td>  <!-- 제품명 -->  
									<td GH="60 STD_QTSIWH" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 재고수량 -->
									<td GH="40 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="90 STD_QTYSTD" GCol="text,QTYSTD" GF="N 13,1"></td>  <!-- 팔렛트 적재수량 -->
									<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 13,1"></td>  <!-- 팔레트수량 -->
									<td GH="60 STD_BOXQTY" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40 STD_REMQTY" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                   
									<td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="D"></td> <!-- 제조일자 -->
									<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D"></td> <!-- 유통기한 -->
<!--  									<td GH="80 STD_KEY" GCol="text,KEY" GF="S 20"></td>  KEY  -->
								</tr>
							</tbody>
						</table>
					</div>
					<div class="tableUtil">
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
			</div>
			<div class="label-btn">
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half 3개일떄 threeP 4개일때 quarter -->
				<label id="threeP" onClick="searchList()">검색</label>
				<label id="threeP" onClick="window.location.reload()">초기화</label>
				<label id="threeP" onClick="LayerPop()">상세</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
	<!-- LayerPop popup -->
	<div class="layer_popup" id="LayerPop" >
		<div class="mobile_order">
			<div class="layer_title"><span>상세</span></div>
			<div class="mobile-data-top">
				<div class="mobile-data-box">
					<div class="content_layout_wrap" id="searchArea">
						<table>
							<tbody>
								<tr>
									<th CL="STD_BACODE">바코드<span class="make">*</span></th>
									<td><input type="text" id="BARCODE_POP" name="BARCODE" class="input input-width" validate="required(STD_BACODE)"></td>
								</tr>
								<tr>
									<th CL="STD_PLBXRQ">팔렛/박스/잔량<span class="make"></span></th>
									<td>
										<input type="text" id="PLTQTY_POP" name="PLTQTY" class="input input-width" style="width:33.3333%;float:left;" readonly>
										<input type="text" id="BOXQTY_POP" name="BOXQTY" class="input input-width" style="width:33.3333%;float:left;" readonly>
										<input type="text" id="REMQTY_POP" name="REMQTY" class="input input-width" style="width:33.3333%;float:left;" readonly>
									</td>
								</tr>
								<tr>
									<th CL="STD_QTSWRK">재고/작업수량<span class="make"></span></th>
									<td>
										<input type="text" id="QTSIWH_POP" name="QTSIWH_POP" class="input1 input-width" readonly>
										<input type="text" id="WORKSUM4" name="WORKSUM4" class="input1 input-width" readonly>
									</td>
								</tr>
								<tr>
									<th CL="STD_TOLOC">To지번<span class="make"></span></th>
									<td>
										<input type="button" class="input1 btn_Search" value="추천" onClick="recommend()" style="background-color:#fff;"/>
										<input type="text" id="LOCATG_POP" name="LOCATG" class="input1 input-width"/>
									</td>
								</tr>
								<tr>
									<th CL="STD_SKUKEY">제품코드<span class="make"></span></th>
									<td><input type="text" id="SKUKEY_POP" name="SKUKEY" class="input input-width" readonly></td>
								</tr>
								<tr>
									<th CL="STD_DESC01">제품명<span class="make"></span></th>
									<td><input type="text" id="DESC01_POP" name="DESC01" class="input input-width" readonly></td>
								</tr>

							</tbody>
						</table>
					</div>
				</div>
			</div>		
			<div class="mobile-data-inner">
				<div class="mobile-data mobile-departure content_layout" >
					<div class="mobile-data-box section" style="height:calc(100vh - 200px);">
						<div class="scroll" style="width:100%;height: calc(100% - 30px);overflow:auto;white-space: nowrap;">
							<table>
								<tbody id="LayerGridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>     
										<td GH="80 STD_PTBACODE" GCol="text,TRNUID" GF="S 20"></td> <!-- PT바코드 -->
<!-- 										<td GH="50 STD_QTSIWH" GCol="text,QTSIWH" GF="N 13,1"></td>  재고수량 -->
										<td GH="80 STD_QTYWRK" GCol="input,QTYWRK" GF="N 13,1"></td>  <!-- 작업수량 -->
										<td GH="40 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
										<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
										<td GH="40 STD_REMQTY" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                  
										<td GH="100 STD_LOTA11" GCol="input,LOTA11" GF="D"></td> <!-- 제조일자 -->
										<td GH="100 STD_LOTA13" GCol="input,LOTA13" GF="D"></td> <!-- 유통기한 -->
									</tr>
								</tbody>
							</table>
						</div>
						<div class="tableUtil">
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="label-btn">
					<!-- 버튼 1개 시에는 id="long" 2개일떄는 half 3개일떄 threeP 4개일때 quarter -->
					<label id="threeP" onClick="POP_searchList()">검색</label>
					<label id="threeP" onClick="POP_saveData()">저장</label>
					<label id="threeP" onClick="LayerPopClose()">닫기</label>
				</div>
			</div>
		</div>
	</div>
	<!-- searchinput popup -->
</body>
</html>