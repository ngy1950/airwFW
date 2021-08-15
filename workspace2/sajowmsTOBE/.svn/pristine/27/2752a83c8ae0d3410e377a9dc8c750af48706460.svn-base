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
			module : "MobileOutbound",
			command : "MTO04",
			gridMobileType : true
	    });
		
		//레이어 팝업
		gridList.setGrid({
	    	id : "LayerGridList",
			module : "MobileOutbound",
			command : "MTO04POP",
			gridMobileType : true
	    });
		
		//SKUKEY
		$("#BARCODE").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#BARCODE").focus();
		//팝업창 거래처명 검색
		$("#PACKID").keyup(function(e){if(e.keyCode == 13)pop_searchList();});
		
		$("#BARCODE").click(function(){$(this).select()}); 
		$("#PACKID").click(function(){$(this).select()}); 
		$("#BARCODE").click(function(){$(this).select()});
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#BARCODE";

		$('#searchArea input').focus(function(){
			input = this;
			if(mode != 'key'){
				$(this).attr("inputmode","none");
			}
			if($(this).hasClass("calendarInput") == false && $(this).prop("readonly") == false && $(this).prop("type") != "button" && mode != 'key'){
				$('#keyboardBtn').fadeIn("fast");
			}
			mode = 'none';

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
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("BARCODE",$("#BARCODE").val());

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			$("#BARCODE").val(""); 
			$("#WORKSUM1").val(""); 
			$("#WORKSUM2").val(""); 

			$("#BARCODE").select();

			
		}
	}
	
	//팝업창 서치리스트 조회
	function pop_searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("PACKID",$("#PACKID").val());
			param.put("STOKKY",$("#STOKKY").val());

			gridList.gridList({
		    	id : "LayerGridList",
		    	param : param
		    });
			
			//초기화
			$("#QTY").val("");
			$("#BOX").val("");
			$("#REQ").val("");
			$("#DESC01").val("");
			
			$("#PACKID").select();
		}
	}

	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			calTotal();
			var GList = gridList.getGridBox('gridList').getDataAll();
			//$("#BARCODE").val(GList[0].get("BARCODE"));
		//팝업레이어
		}else if(gridId == "LayerGridList" && dataCount > 0){
			calTotal();
			var GList = gridList.getGridBox('LayerGridList').getDataAll();
			$("#PACKID").val(GList[0].get("PACKID"));
			$("#DESC01").val(GList[0].get("PACKNM"));
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList" && isCheck == true){
			calTotal();
		}else if(gridId == "LayerGridList"){
			calTotal();
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
			worksum1 = worksum1+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "QTYWRK"));
		}
		
		//총 합계
		for(var i=0; i<list2.length; i++){
			var gridMap = list2[i].map;
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list2[i].get("GRowNum"), "QTSIWH"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
		
		
		//팝업창 합계 계산
		var worksum3 = 0;
		var worksum4 = 0;
		var pop_list = gridList.getSelectData("LayerGridList");
		var pop_list2 = gridList.getGridData("LayerGridList");
		
		//선택 합계
		for(var i=0; i<pop_list.length; i++){
			var gridMap = pop_list[i].map;
			worksum3 = worksum3+(Number)(gridList.getColData("LayerGridList", pop_list[i].get("GRowNum"), "QTYWRK"));
		}
		
		//총 합계
		for(var i=0; i<pop_list2.length; i++){
			var gridMap = pop_list2[i].map;
			worksum4 = worksum4+(Number)(gridList.getColData("LayerGridList", pop_list2[i].get("GRowNum"), "QTSIWH"));
		}
		$("#WORKSUM3").val(worksum3);
		$("#WORKSUM4").val(worksum4);
	}
	
	//레이어 팝업 열기
	function LayerPop() {
		var hrowNum = gridList.getFocusRowNum("gridList");
		var skukey = gridList.getColData("gridList", hrowNum, "SKUKEY");
		var stokky = gridList.getColData("gridList", hrowNum, "STOKKY");
		
		$("#PACKID").val(skukey);
		$("#STOKKY").val(stokky);
		$(".layer_popup .label-btn").show();
		$(".layer_popup").animate({height:"100%"},400);
		
		$("#PACKID").focus();
	}
	
	//레이어 팝업 닫기
	function LayerPopClose() {		
		$(".layer_popup").animate({height:"0%"},200,function(){$(".layer_popup .label-btn").hide()});
	} 
	
	
	function pop_saveData(){
		if(gridList.validationCheck("LayerGridList", "all")){

		    var param = new DataMap();
	        var data = gridList.getSelectData("LayerGridList");
	       
	        var locatrg = $("#LOCATG").val();
	        var qtyTotal = $("#QTY").val();
	        var qtyTotal2 = $("#QTY").val();
	        var packid = $("#PACKID").val();
 	       	
	        //세트해체 화면에서 stokky 가져오기
			var hrowNum = gridList.getFocusRowNum("gridList");
			var stokky = gridList.getColData("gridList", hrowNum, "STOKKY");
			$("#STOKKY").val(stokky);
	        
			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;
				//작업수량
				if((Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("* 작업수량이 0 입니다 *");
					gridList.setColFocus("LayerGridList", data[i].get("GRowNum"), "QTYWRK");
					return;
					
				// 재고수량QTSIWH이 총수량 QTY보다 많으면 안됨
				}else if( qtyTotal.trim()  <  (Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTSIWH")) ){
					commonUtil.msgBox(" 재고수량이 총수량을 넘을 수 없습니다. ");
					//gridList.setColFocus("LayerGridList", data[i].get("GRowNum"), "QTYWRK");
					return;
					
				}else if (gridList.getColData("LayerGridList", data[i].get("GRowNum"), "LOTA11").trim() == "" || gridList.getColData("LayerGridList", data[i].get("GRowNum"), "LOTA11").trim() == null){
					commonUtil.msgBox("* 제조일자를 입력해주세요 *");
					return;
				}else if (gridList.getColData("LayerGridList", data[i].get("GRowNum"), "LOTA13").trim() == "" || gridList.getColData("LayerGridList", data[i].get("GRowNum"), "LOTA13").trim() == null){
					commonUtil.msgBox("VALID_M0324");
					return;
				}
			}
			
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
							
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCATG", locatrg);
			param.put("JOBTYP", "402");
			param.put("PACKID", packid);
			param.put("INOQTY", qtyTotal);
			param.put("TRNQTY", qtyTotal2);
			param.put("STOKKY", stokky);
			
			netUtil.send({
				url : "/mobile/mobileOutbound/json/MTO04POP.data",
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
				//팝업 그리드 초기화
				LayerPopClose();	
				gridList.resetGrid("gridList");
				$("#BARCODE").val("");
				$("#WORKSUM1").val("");
				$("#WORKSUM2").val("");
				
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
		
	}
	
	//그리드 컬럼 변경 이벤트
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
	
	//onclick 박스 입력 , 총 QTY 박스 BOX 낱 REQ  세트해체  
	function boxTotal(){
		//실행할 내용
		var item = gridList.getGridData("LayerGridList");
		var box = $("#BOX").val();
		var req = $("#REQ").val();
		var qty = 0; // 총수량 = 입수 * 박스 
		var qtduom = 0; // 검색조건 입수
		var qtduom2 = 0; //그리드 입수 
		var remqty = 0; //잔량 
		
		var uomqty = 0; //단위수량
		var qtywrk = 0; //작업수량
		var boxqty = 0; //박스수량
		
		for(var i=0; i<item.length; i++){
			var gridMap = item[i].map;
			qtduom = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTDUOM"));
			//총 = 박스 * 입수 + 낱개
			qty = ((Number)(box)*(Number)(qtduom))+(Number)(req); 
			
			// 작업수량 / 입수 = 박스수량     QTYWRK 작업수량   QTDUOM 입수    BOXQTY 박스수량
			uomqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "UOMQTY"));
			qtywrk = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTYWRK"));
			boxqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "BOXQTY"));
			uomqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "UOMQTY"));
			qtduom2 = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTDUOM2")); 
			
			// 작업수량  = 총수량 * 단위수량 
			qtywrk = ((Number)(uomqty)*(Number)(qty)); 
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "QTYWRK", qtywrk ); //작업수량 
			// 박스수량  = 작업수량  / 입수 
			boxqty = floatingFloor((Number)(qtywrk)/(Number)(qtduom2), 0);
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "BOXQTY", boxqty ); //박스수량 
			
			// 잔량 
			remqty = (Number)(qtywrk)%(Number)(qtduom2);
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "REMQTY", remqty ); //잔량
			
		}
		
		$("#QTY").val(qty);
		
	}
	
	// 낱개입력 
	function reqTotal(){
		//실행할 내용
		var item = gridList.getGridData("LayerGridList");
		var box = $("#BOX").val();
		var req = $("#REQ").val();
		var qty = $("#QTY").val();
		
		var uomqty = 0; //단위수량
		var useqty = 0; //가용수량
		var qtduom = 0; // 검색조건 입수
		var qtduom2 = 0; //그리드 입수 
		var remqty = 0; //잔량 
		var total = 0;
		
		for(var i=0; i<item.length; i++){
			var gridMap = item[i].map;
			qtduom = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTDUOM"));
			qty = ((Number)(box)*(Number)(qtduom)); 
			total = (Number)(qty)+(Number)(req);
			
 			// 작업수량 / 입수 = 박스수량     QTYWRK 작업수량   QTDUOM 입수    BOXQTY 박스수량
			uomqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "UOMQTY"));
			qtywrk = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTYWRK"));
			boxqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "BOXQTY"));
			uomqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "UOMQTY"));
			qtduom2 = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "QTDUOM2")); 
			
			remqty = (Number)(gridList.getColData("LayerGridList", item[i].get("GRowNum"), "REMQTY"));
			
			// 작업수량  = 총수량 * 단위수량 
			qtywrk = ((Number)(uomqty)*(Number)(total)); 
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "QTYWRK", qtywrk ); //작업수량 
			// 박스수량  = 작업수량  / 그리드 입수 
			boxqty = floatingFloor((Number)(qtywrk)/(Number)(qtduom2), 0);
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "BOXQTY", boxqty ); //박스수량 
			
			// 잔량 
			remqty = (Number)(qtywrk)%(Number)(qtduom2);
			gridList.setColValue("LayerGridList", item[i].get("GRowNum"), "REMQTY", remqty ); //잔량
		}
		
		$("#QTY").val(total);
	}
	
	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>세트해체</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_BACODE">바코드<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width" validate="required(STD_BACODE)"/></td>
							</tr>
							<tr>
								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" readonly/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/>
								</td>
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
									<td GH="40" GCol="rowCheck"></td>
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--품목-->
									<td GH="300" GCol="text,DESC01" GF="S 20"></td>  <!--제품명-->
									<td GH="80" GCol="text,TRNUID"></td>  <!--팔렛트ID --> 
									<td GH="40" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 재고수량 -->
									<td GH="40" GCol="text,QTYWRK" GF="N 13,1"></td>  <!-- 작업수량 -->
									<td GH="40" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                   
									<td GH="70" GCol="text,LOTA13" GF="C"></td> <!-- 유통기한 -->	
								</tr>
							</tbody>
						</table>
					</div>
					<div class="tableUtil">
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
<!-- 				<div class="moblie-data-infobox"> -->
<!-- 					<div class= detail-info> -->
<!-- 						<ul> -->
<!-- 							<li class="left"> -->
<!-- 								<div class="workBox">작업<input type="text" id="WORKSUM1" name="WORKSUM1">/<input type="text" id="WORKSUM2" name="WORKSUM2"></div> -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</div> -->
<!-- 				</div> -->
			</div>
			<div class="label-btn">
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half 3개일떄 threeP 4개일때 quarter -->
				<label id="threeP" onClick="searchList()">검색</label>
				<label id="threeP" onClick="window.location.reload()">초기화</label>
				<label id="threeP" onClick="LayerPop()">해체</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
	<!-- LayerPop popup -->
	<div class="layer_popup" id="LayerPop" >
		<div class="mobile_order">
			<div class="layer_title"><span>세트해체  팝업</span></div>
			<div class="mobile-data-top">
				<div class="mobile-data-box">
					<div class="content_layout_wrap" id="searchArea">
						<table>
							<tbody>
								<tr>
									<th>세트코드<span class="make">*</span></th>
									<td><input type="text" id="PACKID" name="PACKID" class="input input-width" value=""/></td>
								</tr>
								<tr>
									<th>세트품명<span class="make"></span></th>
									<td><input type="text" id="DESC01" name="DESC01" class="input input-width" value="" readonly/></td>
								</tr>
								<tr>
									<th>제조/유통<span class="make"></span></th>
									<td>
										<input type="text" id="LOTA11" name="LOTA11" UIFormat="C" class="input1 input-width" readonly/>
										<input type="text" id="LOTA13" name="LOTA13" UIFormat="C" class="input1 input-width" readonly/>
									</td>
								</tr>
								<tr>
									<th>총/박/낱<span class="make"></span></th>
									<td>
										<input type="text" id="QTY" name="QTY" class="input2 input-width" readonly/> 
										<input type="text" id="BOX" name="BOX" onchange="boxTotal()" class="input2 input-width" />
										<input type="text" id="REQ" name="REQ" onchange="reqTotal()" class="input2 input-width" />
										<input type="text" id="BIN" name="BIN" class="input2 input-width" readonly/>
									</td>
								</tr>
								<tr>
								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th>
									<td>
										<input type="text" id="WORKSUM3" name="WORKSUM3" class="input1 input-width" readonly/>
										<input type="text" id="WORKSUM4" name="WORKSUM4" class="input1 input-width" readonly/>
									</td>
								</tr>
								<tr>
									<th CL="STD_TOLOC">To지번<span class="make"></span></th>
									<td>
										<input type="text" id="LOCATG" name="LOCATG" class="input input-width" value="SETLOC"/>
									</td>
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--제품코드 -->
										<td GH="300" GCol="text,DESC01" GF="S 20"></td>  <!--제품명 -->
										<td GH="40" GCol="text,UOMQTY" GF="N 13,1"></td>  <!--단위수량  -->
										<td GH="40" GCol="text,QTYWRK" GF="N 13,1"></td>  <!--작업수량-->  
										<td GH="40" GCol="text,QTDUOM2" GF="N 13,1"></td>  <!--입수 --> 
										<td GH="40" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 가용수량, 재고수량-->
										<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스수량 --> 
										<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량-->
										<td GH="70" GCol="input,LOTA11" GF="C"></td> <!-- 제조일자 -->
										<td GH="70" GCol="input,LOTA13" GF="C"></td> <!-- 유통기한 -->
									</tr>
								</tbody>
							</table>
						</div>
						<div class="tableUtil">
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
<!-- 					<div class="moblie-data-infobox"> -->
<!-- 						<div class= detail-info> -->
<!-- 							<ul> -->
<!-- 								<li class="left"> -->
<!-- 									<div class="workBox">작업<input type="text" id="WORKSUM3" name="WORKSUM3" readonly>/<input type="text" id="WORKSUM4" name="WORKSUM4" readonly></div> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<div>To바코드<input type="text" id="LOCATG" name="LOCATG" value="SETLOC"></div> -->
<!-- 								</li> -->
<!-- 							</ul> -->
<!-- 						</div> -->
<!-- 					</div> -->
				</div>
				<div class="label-btn">
					<!-- 버튼 1개 시에는 id="long" 2개일떄는 half 3개일떄 threeP 4개일때 quarter -->
					<label id="threeP" onClick="pop_searchList()">검색</label>
					<label id="threeP" onClick="pop_saveData()">저장</label>
					<label id="threeP" onClick="LayerPopClose()">닫기</label>
				</div>
			</div>
		</div>
	</div>
	<!-- searchinput popup -->
</body>
</html>