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
			command : "MGR01MAIN",
			gridMobileType : true
	    });
		
		$("#ASNDKY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#ASNDKY").focus();
		
		$("#TOTRUNG").keyup(function(e){if(e.keyCode == 13)$("#LOCATG").focus();});
		
		//검색값 클릭시 
		$("#ASNDKY").click(function(){$(this).select()}) 
		$("#TOTRUNG").click(function(){$(this).select()}) 
		$("#LOCATG").click(function(){$(this).select()}) 
		

		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#ASNDKY";

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
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("SVBELN",$("#SVBELN").val());

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			 
			$("#LOCATG").val("RCVLOC");
			$("#TRNUTG").val("");
			$("#TOTRUNG").val("");
			$("#WORKSUM1").val("");
			$("#WORKSUM2").val("");
			$("#ASNDKY").select(); 
		
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getSelectData("gridList");
	        var locatrg = $("#LOCATG").val();
	        var proddt = $("#DOCDAT").val();
	        proddt = proddt.replace(/\./g,"");

			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;

				if((Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("VALID_M0952");
					gridList.setColFocus("gridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}else if((Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYWRK")) > (Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYASN"))){
					commonUtil.msgBox("VALID_M0923");
					gridList.setColFocus("gridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}else if (gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA11").trim() == "" || gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA11").trim() == null){
					commonUtil.msgBox("* 제조일자를 입력해주세요 *");
					return;
				}else if (gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA13").trim() == "" || gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA13").trim() == null){
					commonUtil.msgBox("VALID_M0324");
					return;
				}else if(gridList.getColData("gridList", data[i].get("GRowNum"), "STATIT").trim() == "V"){
					commonUtil.msgBox("입고완료된 문서입니다.");
					return;
				} 
			}
			
			if($("#LOCATG").val().trim() == ""){
				commonUtil.msgBox("To지번을 입력해주세요.");
				$("#LOCATG").select();
				return;
			}
			
			if( !commonUtil.msgConfirm("SYSTEM_SAVECF") ){ // 저장하시겠습니까?
				return;
			}

			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCATG", locatrg);
			param.put("PRODDT", proddt);
			param.put("JOBTYP", "101");			
			
			netUtil.send({
				url : "/mobile/MobileInbound/json/saveMGR01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//전체 체크박스 이벤트 후 
	function  gridListEventRowCheckAll(gridId, isCheck){
		if(gridId == "gridList"){
			calTotal();
		}
	}
	
	//To지번 추천 버튼 
	function check(){
		var param = new DataMap();
		var data = gridList.getSelectData("gridList");
		
		if(data.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		// To바코드 필수 입력
		if($("#TOTRUNG").val().trim() == ""){
			commonUtil.msgBox("To바코드를 입력해주세요.");
			$("#TOTRUNG").focus();
			return;
		}

		param.put("OWNRKY", "<%=ownrky%>");
		param.put("WAREKY", "<%=wareky%>");
		param.put("TRNUID",$("#TOTRUNG").val());
		
		var json = netUtil.sendData({
			module : "MobileInbound",
			command : "MGR06_LOKA",
			sendType : "map",
			param : param
		});
		
		//조회한 쿼리에서 LOCAKY 가져오기
 		if(json.data.LOCAKY != ""){
			$('#LOCATG').val(json.data.LOCAKY);
			//return;
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
			calTotal();
			gridList.checkAll("gridList", true);
			$("#TOTRUNG").focus(); 
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
			//$("#LOCATG").val(gridList.getColData(gridId, rowNum, "LOCAKY"));
		}
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
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list2[i].get("GRowNum"), "QTYASN"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
	}
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>ASN입고</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_ASNDKY">ASN입고번호<span class="make">*</span></th>
								<td><input type="text" id="ASNDKY" name="ASNDKY" class="input input-width" validate="required(STD_ASNDKY)"></td>
							</tr>
							<tr>
								<th CL="STD_PTNRNM">거래처명<span class="make">*</span></th>
								<td><input type="text" id="TRNUTG" name="TRNUTG" class="input input-width" readonly="readonly"></td>
							</tr>
							<tr>
								<th CL="STD_LOTA12">입고일자<span class="make">*</span></th>
								<td><input type="text" id="DOCDAT" name="DOCDAT" class="input input-width" UIFormat="C N" validate="required(STD_LOTA12)"></td>
							</tr>
							<tr>
								<th CL="STD_TOTRUNG">To바코드<span class="make"></span></th>
								<td>
									<input type="text" id="TOTRUNG" name="TOTRUNG" class="input input-width" />
								</td>
							</tr>
							<tr>
								<th CL="STD_TOLOC">To지번<span class="make">*</span></th>
								<td>
									<input type="button" class="input1 btn_Search" value="추천" onClick="check()" style="background-color:#fff;"/>
									<input type="text" id="LOCATG" name="LOCATG" class="input1 input-width" />
								</td>
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
									<td GH="80" GCol="input,SKUKEY" GF="S 20"></td>
									<td GH="80" GCol="text,STATIT" GF="S 20"></td>
									<td GH="250" GCol="text,DESC01" GF="S 20"></td>
									<td GH="80" GCol="text,QTYASN" GF="N 13,1"></td>
									<td GH="90" GCol="input,QTYWRK" GF="N 13,1"></td>  <!--제조일자-->
									<td GH="90" GCol="input,QTDUOM" GF="N 13,1"></td>  <!--제조일자-->
									<td GH="70" GCol="input,QTYSTD" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="70" GCol="input,PLTQTY" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="70" GCol="input,BOXQTY" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="70" GCol="input,REMQTY" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="90" GCol="text,LOTA11" GF="C"></td>  	   <!--제조일자-->
									<td GH="90" GCol="text,LOTA13" GF="C"></td>  	   <!--박스수량-->
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