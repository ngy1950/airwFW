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
			command : "MDL11",
			gridMobileType : true
	    });
		
		$("#SSORNU").keyup(function(e){if(e.keyCode == 13)scanSsornu();});
		$("#SSORNU").focus();

		$("#LOCAKY").keyup(function(e){if(e.keyCode == 13)searchList();});
		//검색값 클릭시 초기화
		$("#TASKKY").click(function(){$(this).select()}) 
		$("#LOCAKY").click(function(){$(this).select()}) 
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#SSORNU";

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
	

	function scanSsornu(){
		$("#LOCAKY").focus();
		$("#LOCAKY").select();
	}

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
// 			$("#SSORNU").val("");
			//$("#LOCAKY").val("");
			$("#WORKSUM1").val("");
			$("#WORKSUM2").val("");
// 			$("#LOCAKY").focus();

			$("#SSORNU").select();
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){		
		if (json && json.data) {
			if (json.data == "S") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			//calTotal();
			scanLoc();
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();

			var data = gridList.getSelectData("gridList");
			param.put("data", data);

			netUtil.send({  
				url : "/mobile/mobileOutbound/json/saveMDL11.data", 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
// 	//합계 계산
// 	function calTotal(gridId, rowNum){
// 		var worksum1 = 0;
// 		var worksum2 = 0;
// 		var gridId = "gridList";
// 		var headGridBox = gridList.getGridBox(gridId);
// 		var data = headGridBox.getRowData(rowNum).map;

// 		worksum1 = worksum1+(Number)(gridList.getColData("gridList", data.GRowNum, "BOXWRK"));
// 		worksum2 = worksum2+(Number)(gridList.getColData("gridList", data.GRowNum, "BOXQTY"));
		
// 		$("#WORKSUM1").val(worksum1);
// 		$("#WORKSUM1").attr("GIRDROW", rowNum);
// 		$("#WORKSUM2").val(worksum2);

// 	}
	
	//합계 계산
	function calTotal(){
		var worksum1 = 0;
		var worksum2 = 0;
		var list = gridList.getSelectData("gridList");
		var list2 = gridList.getGridData("gridList");
		
		//선택 합계
		for(var i=0; i<list.length; i++){
			var gridMap = list[i].map;
			worksum1 = worksum1+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "BOXWRK"));
		}
		
		//총 합계
		for(var i=0; i<list2.length; i++){
			var gridMap = list2[i].map;
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list2[i].get("GRowNum"), "BOXQTY"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();   
        //로케이션
        if(searchCode == "SHLOCMA" && $inputObj.name == "LOCATG"){
            param.put("CMCDKY","WAREKY");
         	param.put("WAREKY", $("#WAREKY").val());
        	param.put("OWNRKY", $("#OWNRKY").val());
        }
        
    	return param;
    }
	
	function scanLoc(){
		//완료수량이 모두 찍히면  피킹완료 프로시저를 직동한다 gridListEventColValueChange에서
		var gridId = 'gridList';
		var barcode = $("#LOCAKY").val();


		var gridDataBox = gridList.getGridBox(gridId);
		var gridListData = gridDataBox.getDataAll();
	      
		for(var i=0; i<gridListData.length; i++){
			var rowNum = gridListData[i].get("GRowNum");
			gridList.setRowCheck(gridId, rowNum, true);
			gridListEventRowCheck(gridId, rowNum, true);
		}
		
		
	}

	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(colName == "QTYWRK"){ //완료수량 변경시

			var qttaor = Number(gridList.getColData(gridId, rowNum, "QTCOMP"));
			if(colValue > qttaor){
				
			}else{
				gridList.setColValue(gridId, rowNum, "QTCOMP", colValue);
			}
			
			//calTotal();
			
		}else if(colName == "BOXWRK"){ //박스수량 변경시
			
		}
	}
		
	function gridListEventRowClick(gridId, rowNum, btnName){

		calTotal(gridId, rowNum);
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}
	//전체 체크박스 이벤트 후 
	function  gridListEventRowCheckAll(gridId, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}
	
	//값 변경시
	function setValue(){
		var rowNum = $("#WORKSUM1").attr("GIRDROW");
		var boxqty = $("#WORKSUM1").val();	
		var boxqty2 = $("#WORKSUM2").val();
		
		if(boxqty > boxqty2){
			commonUtil.msgBox("작업수량은 원주문수량보다 클 수 없습니다.");
			$("#WORKSUM1").val(boxqty2);
		}

	  	gridList.setColValue("gridList", rowNum, "BOXWRK", boxqty);
		gridListEventColValueChange("gridList", rowNum, "BOXWRK", boxqty);
	}
	

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		var qtywrk =  Number(gridList.getColData(gridId, rowNum, "QTYWRK"));	
		var remqty =  Number(gridList.getColData(gridId, rowNum, "REMQTY"));		
		var boxwrk =  Number(gridList.getColData(gridId, rowNum, "BOXWRK"));
		var qtcomp =  Number(gridList.getColData(gridId, rowNum, "QTCOMP"));
		var pliqty =  Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
		var bxiqty =  Number(gridList.getColData(gridId, rowNum, "BXIQTY"));		
		var pliqty =  Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
		
		if(colName == "BOXWRK"){
			//박스수량 + 잔량으로 재게산
			var totQty = boxwrk*bxiqty+remqty; 
			
		  	remqty = (Number)(totQty)%(Number)(bxiqty);
		  	pltqty = floatingFloor((Number)(totQty)/(Number)(pliqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXWRK", boxwrk);
			gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
			gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
			gridList.setColValue(gridId, rowNum, "QTYWRK", totQty);
			
		}else if(colName == "REMQTY"){
			//잔량은 1box이상 입력할 수 있으니 더해서 다시 계산한다
			var totQty = remqty+qtywrk; 

			boxwrk = floatingFloor((Number)(totQty)/(Number)(bxiqty), 0);
		  	remqty = (Number)(totQty)%(Number)(bxiqty);
		  	pltqty = floatingFloor((Number)(totQty)/(Number)(pliqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXWRK", boxwrk);
			gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
			gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
			gridList.setColValue(gridId, rowNum, "QTYWRK", totQty);
			
		}else if(colName == "QTYWRK"){

			boxwrk = floatingFloor((Number)(qtywrk)/(Number)(bxiqty), 0);
		  	remqty = (Number)(qtywrk)%(Number)(bxiqty);
		  	pltqty = floatingFloor((Number)(qtywrk)/(Number)(pliqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXWRK", boxwrk);
			gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
			gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
			gridList.setColValue(gridId, rowNum, "QTYWRK", qtywrk);
		}
		
		qtywrk =  Number(gridList.getColData(gridId, rowNum, "QTYWRK"));	
		//validation
		if(qtcomp < qtywrk){
			commonUtil.msgBox("작업수량은 원주문수량보다 클 수 없습니다.");
			gridList.setColValue(gridId, rowNum, "QTYWRK", 0);
			gridList.setColValue(gridId, rowNum, "REMQTY", 0);
			gridList.setColValue(gridId, rowNum, "BOXWRK", 0);
			return;
		}
	}
	
	
	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>피킹완료</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_SSORNU">적치지시번호<span class="make">*</span></th>
								<td><input type="text" id="SSORNU" name="SSORNU" class="input input-width" validate="required(STD_SSORNU)" onclick="$(this).select();"> </td>
<!-- 								<td><input type="text" id="TASKKY" name="TASKKY" class="input input-width" validate="required(STD_TASNUM)"></td> -->
							</tr>
							<tr>
								<th CL="STD_LOCAKY">로케이션<span class="make"></span></th>
								<td><input type="text" id="LOCAKY" name="LOCAKY" class="input input-width" validate="required(STD_LOCAKY)"></td>
							</tr> 
							<tr>
								<th CL="STD_WRKSUMBOX">선택/총작업<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" onchange="setValue()"/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/>
								</td>
							</tr>
							<!-- <tr>
								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" readonly/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/>
								</td>
							</tr> -->
							<!-- <tr>
								<th CL="STD_TOLOC">From지번<span class="make"></span></th>
								<td>
									<input type="text" id="LOCASR" name="LOCASR" class="input input-width" readonly/>
								</td>
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
							<tbody id="gridList">
								<tr CGRow="true">
									<td GH="40" GCol="rownum">1</td>
									<td GH="40" GCol="rowCheck"></td>
									<td GH="80" GCol="text,TASSTATDO"></td>  <!--작업여부-->
									<td GH="60" GCol="text,GUBUN"></td>  <!--구분-->
									<td GH="80" GCol="text,LOCAKY"></td>  <!--FROM로케이션-->
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--제품코드 -->
									<td GH="300" GCol="text,DESC01"></td>  <!--제품명 -->
									<td GH="80" GCol="input,BOXWRK" GF="N 13,1" validate="required"></td>  <!--작업수량(박스)-->
			    					<td GH="60" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
									<td GH="80" GCol="text,QTCOMP" GF="N 13,1" validate="required"></td>  <!--완료수량(EA)-->
									<td GH="80" GCol="input,QTYWRK" GF="N 13,1" validate="required"></td>  <!--작업수량-->
									<td GH="90" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--팔레트수량-->
									<td GH="80" GCol="text,PLTQTY" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="80" GCol="text,BXIQTY" GF="N 13,1" ></td>  <!-- 박스입수-->
									<td GH="90" GCol="text,PLIQTY" GF="N 13,1" ></td>  <!-- 팔레트입수-->
									<td GH="100" GCol="text,DTREMRAT" GF="S"></td>  <!--유통기한 잔여(%)-->
									<td GH="60 구코드" GCol="text,DESC03" GF="S"></td>  <!--구코드-->
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
				<label id="threeP" onClick="saveData()">저장</label> 
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
</body>
</html>