<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<script type="text/javascript">
/* 출고문서번호  */
var shpoky;
var shpoit;
var skukey;
var taskit;
var qtable;

var input = '';
var mode = '';


/* 모바일 할당조회완료 화면 */

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileOutbound",
			command : "MDL02",
			gridMobileType : true
	 	});
	
		gridList.setGrid({
	    	id : "LayerGridList",
			module : "MobileOutbound",
			command : "MDL02POP_CHECK",
			gridMobileType : true
		});
		
		$("#SHPOKY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#SHPOKY").focus();
// 		//검색값 클릭시 초기화
		$("#SHPOKY").click(function(){$(this).select()}); 
		$("#POP_BARCODE").click(function(){$(this).select()}); 
		
		/* 팝업 */
		$("#POP_DESC01").keyup(function(e){if(e.keyCode == 13)pop_searchList();});
		$("#POP_SHPOKY").keyup(function(e){if(e.keyCode == 13)pop_searchList();});
		$("#POP_LOCAKY").keyup(function(e){if(e.keyCode == 13)searchBarcode();});
		$("#POP_BARCODE").keyup(function(e){if(e.keyCode == 13)searchBarcode();});

		//총 건수 위치 고정
		$(function(){	
			$('.mobile-data-box').scroll(function() {
			    $(this).find('.tableUtil').css('right', -($(this).scrollLeft()));
			});
		})
		
		//가상키보드 제어
		$('input').attr("inputmode","none");

		$('.content_layout_wrap input').focus(function(){
			input = this;
			if(mode != 'key'){
				$(this).attr("inputmode","none")
			}
			if($(this).hasClass("calendarInput") == false && $(this).prop("readonly") == false && $(this).prop("type") != "button" && mode != 'key'){
				$('#keyboardBtn').fadeIn("fast");
			}
			mode = 'none'

		});
		$('.content_layout_wrap input').blur(function(){
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
	
	/* 팝업 바코드 조회 */
	function searchBarcode(){
		if(validate.check("searchArea2")){
			var param = inputList.setRangeParam("searchArea2");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("SKUKEY", skukey);
			
			var pop_trnuid = $("#POP_BARCODE").val();
			
			/* PT바코드 입력 필수 */
			if(pop_trnuid == ""){
				commonUtil.msgBox("PT바코드를 입력해주세요.");
				return;
			}
			
			/* 바코드 스캔시 stkky 조회 */
			netUtil.send({
	    		module : "MobileOutbound",
				command : "MDL02POP",
				bindType : "grid",
				sendType : "list",
				bindId : "LayerGridList",
		    	param : param
			});
			// 검색조건 선택후 블러처리
			$("#POP_BARCODE").select();
			
			
		}
	}
	
	/* 팝업 조회 */
	function pop_searchList(){
		if(validate.check("searchArea2")){
			var param = inputList.setRangeParam("searchArea2");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("SHPOIT",shpoit);			
			
			/* 할당이 있는지 phydh 조회 */
			gridList.gridList({
		    	id : "LayerGridList",
		    	param : param
		    });
		}
	}
	
	/* 할당조회완료 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			

			$("#PTNRKYNM").val("");
			$("#POP_DESC01").val("");
			$("#POP_SHPOKY").val("");
			$("#POP_LOCAKY").val("");
			$("#POP_BARCODE").val("");
			$("#SHPOKY").select();
			
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){		
		if (json && json.data) {
			if (json.data == "S") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				pop_searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "LayerGridList" && dataCount > 0){
			calTotal();
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "LayerGridList"){
			calTotal();
		}
	}
	//전체 체크박스 이벤트 후 
	function  gridListEventRowCheckAll(gridId, isCheck){	
		if(gridId == "LayerGridList"){
			calTotal();
		}
	}

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		 if(colName == "QTYWRK"){ //수량변경시연결된 수량 변경
			var boxqty = 0;
			var bxiqty = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
			var qtywrk = Number(gridList.getColData(gridId, rowNum, "QTYWRK"));
			boxqty = floatingFloor((Number)(qtywrk)/(Number)(bxiqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);

		  	//수량 CHECK
		  	if(Number(colValue) > Number(gridList.getColData(gridId, rowNum, "QTALOC"))){
		  		commonUtil.msgBox("VALID_M0923");
				gridList.setColValue(gridId, rowNum, "QTYWRK", 0);
				gridList.setColFocus(gridId, rowNum, "QTYWRK");
		  	}
		  	
		  	calTotal();
		 }
	}
	
	//작업수량계산 계산
	function calTotal(){
		var data = gridList.getSelectData("LayerGridList");
		var qtywrk = 0;
		
		for(var i=0; i<data.length; i++){
			var gridMap = data[i].map;
			
			qtywrk += (Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTYWRK"));
		}
		$("#POP_QTTAOR").val(qtywrk);
	} 
	
	//팝업창 저장
	function POP_saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
	        var data = gridList.getSelectData("LayerGridList");

			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			/* 작업수량이 할당가능수량보다 많을경우 */
			if((Number)($("#POP_QTABLE").val()) < (Number)($("#POP_QTTAOR").val())){
				commonUtil.msgBox("작업 수량이 할당가능수량을 초과하였습니다.");
				return;
			}

			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;

				if((Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("VALID_M0952");
					gridList.setColFocus("gridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}
			}
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("TRNUTG", $("#TRNUTG").val());
			param.put("JOBTYP", "210");
			
			/* MDL02 할당조회/완료 화면에서 넘어온 SHPOKY, SHPOIT, TASKIT 셋팅 */
			param.put("SHPOKY", shpoky);
			param.put("SHPOIT", shpoit);
			param.put("TASKIT", taskit);
			param.put("SKUKEY", skukey);
			
			netUtil.send({
				url : "/mobile/mobileOutbound/json/MDL02POP.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//팝업창 삭제
	function POP_deleteData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
	        var data = gridList.getSelectData("LayerGridList");

			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;

				if(gridMap.TASKKY.trim() == ""){
					commonUtil.msgBox("작업오더가 존재하지 않습니다.");
					return;
				}
				
				if((Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("VALID_M0952");
					gridList.setColFocus("gridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}
			}
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("TRNUTG", $("#TRNUTG").val());
			param.put("JOBTYP", "210D");
			
			/* MDL02 할당조회/완료 화면에서 넘어온 SHPOKY, SHPOIT, TASKIT 셋팅 */
			param.put("SHPOKY", shpoky);
			param.put("SHPOIT", shpoit);
			param.put("TASKIT", taskit);
			param.put("SKUKEY", skukey);
			
			netUtil.send({
				url : "/mobile/mobileOutbound/json/MDL02POP_Delete.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//레이어 팝업 열기
	function LayerPop() {
		  var hrowNum = gridList.getFocusRowNum("gridList");
		  var desc01 = gridList.getColData("gridList", hrowNum, "DESC01");
		  skukey = gridList.getColData("gridList", hrowNum, "SKUKEY");
		  shpoky = gridList.getColData("gridList", hrowNum, "SHPOKY");
		  shpoit = gridList.getColData("gridList", hrowNum, "SHPOIT");
	  	  taskit = gridList.getColData("gridList", hrowNum, "TASKIT");
	      qtable = gridList.getColData("gridList", hrowNum, "QTABLE");	// 할당 가능수량 
			
	      $("#POP_DESC01").val(desc01);
		  $("#POP_SHPOKY").val(shpoky);
		  $("#POP_QTABLE").val(qtable);
			
	      $(".layer_popup .label-btn").show();
	      $(".layer_popup").animate({height:"100%"},400);
	      
	      $("#POP_BARCODE").focus();
	 }
	
	//레이어 팝업 닫기
	function LayerPopClose() {      
	     $(".layer_popup").animate({height:"0%"},400,function(){$(".layer_popup .label-btn").hide()});
	}
/* 	
	//레이어 팝업 열기
	function LayerPop() {
		var hrowNum = gridList.getFocusRowNum("gridList");
		var desc01 = gridList.getColData("gridList", hrowNum, "DESC01");
		skukey = gridList.getColData("gridList", hrowNum, "SKUKEY");
		shpoky = gridList.getColData("gridList", hrowNum, "SHPOKY");
		shpoit = gridList.getColData("gridList", hrowNum, "SHPOIT");
		taskit = gridList.getColData("gridList", hrowNum, "TASKIT");
		qtable = gridList.getColData("gridList", hrowNum, "QTABLE");	// 할당 가능수량 
		
		$("#POP_DESC01").val(desc01);
		$("#POP_SHPOKY").val(shpoky);
		$("#POP_QTABLE").val(qtable);
		$("#LayerPop").show();
		pop_searchList();
	}
	
	//레이어 팝업 닫기
	function LayerPopClose() {		
		$("#LayerPop").hide();
	}
	 */
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>할당조회/완료</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th>출하문서<span class="make">*</span></th>
								<td><input type="text" id="SHPOKY" name="SHPOKY" class="input input-width" validate="required(STD_SHPOKY_NO)" ></td>
							</tr>
							<tr>
								<th>출고처<span class="make"></span></th>
								<td><input type="text" id="PTNRKYNM" name="PTNRKYNM" class="input input-width" value="" readonly="readonly"></td>
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
									<td GH="300" GCol="text,DESC01"></td>  <!--제품명   -->
									<td GH="40" GCol="text,QTSHPO" GF="N 13,1"></td>  <!--재고    -->
									<td GH="40" GCol="text,QTALOC" GF="N 13,1"></td>  <!--입수    -->
									<td GH="40" GCol="input,QTJCMP" GF="N 13,1"></td>  <!--박스    -->
									<td GH="40" GCol="text,QTABLE" GF="N 13,1"></td>  <!--박스    -->
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--품목    -->
									
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
				<label id="threeP" onClick="LayerPop()">품목선택</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>


<!-- LayerPop popup -->
<div class="layer_popup" id="LayerPop" >
	<div class="mobile_order">
		<div class="layer_title"><span>할당조회/완료 팝업</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea2">
					<table>
						<tbody>
							<tr>
								<th>제품코드/PT바코드<span class="make">*</span></th>
								<td><input type="text" id="POP_BARCODE" name="BARCODE" class="input input-width" validate="required(제품코드/PT바코드)" ></td>
							</tr>
							<tr>
								<th>제품명<span class="make"></span></th>
								<td><input type="text" id="POP_DESC01" name="DESC01" class="input input-width" value="" readonly="readonly"></td>
							</tr>
							<tr>
								<th>출고문서<span class="make"></span></th>
								<td><input type="text" id="POP_SHPOKY" name="SHPOKY" class="input input-width" value="" readonly="readonly"></td>
							</tr>
							<tr>
								<th>할당 가능수량/작업수량<span class="make"></span></th>
								<td>
									<input type="text" id="POP_QTABLE" name="QTABLE" class="input1 input-width" readonly/> 
									<input type="text" id="POP_QTTAOR" name="QTTAOR" class="input1 input-width" readonly/>
								</td>
							</tr>
<!-- 							<tr>
								<th>제품코드<span class="make">*</span></th>
								<td><input type="text" id="POP_SKUKEY" name="SKUKEY" class="input input-width" value="" ></td>
							</tr>
							<tr>
								<th>PT바코드<span class="make">*</span></th>
								<td><input type="text" id="POP_BARCODE" name="BARCODE" class="input input-width" value="" ></td>
							</tr> -->
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
									<td GH="80" GCol="text,LOCAKY"></td>  <!--로케이션  -->
									<td GH="80" GCol="text,TRNUID"></td>  <!--팔렛트ID-->
									<td GH="50" GCol="text,QTALOC" GF="N 13,1"></td>  <!--할당수량-->
									<td GH="50" GCol="input,QTYWRK" GF="N 13,1"></td>  <!--작업수량-->
									<td GH="50" GCol="text,QTDUOM" GF="N 13,1"></td>  <!--입수-->
									<td GH="50" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스수량 -->
									<td GH="50" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량-->
									<td GH="70" GCol="input,LOTA13" GF="C"></td>  <!--유통기한-->
									<td GH="110" GCol="text,KEY"></td>  <!-- KEY-->	
									<!-- <td GH="40" check="ALOCHK"></td>       -->
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
				<label id="quarter" onClick="pop_searchList()">검색</label>
				<label id="quarter" onClick="POP_saveData()">저장</label>
				<label id="quarter" onClick="POP_deleteData()">삭제</label>
				<label id="quarter" onClick="LayerPopClose()">닫기</label>
			</div>
		</div>
	</div>
</div>
<!-- searchinput popup -->


</body>
</html>