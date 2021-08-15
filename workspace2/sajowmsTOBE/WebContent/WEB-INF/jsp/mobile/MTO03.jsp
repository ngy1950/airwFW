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
			command : "MTO03",
			gridMobileType : true
	    });
		
		$("#PACKID").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#PACKID").focus();
		
// 		//검색값 클릭시 초기화
		$("#PACKID").click(function(){$(this).select()});
		$("#BOX").click(function(){$(this).select()}); 
		$("#REQ").click(function(){$(this).select()}); 
		$("#LOCATG").click(function(){$(this).select()});
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#PACKID";

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

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			//초기화
			$("#QTY").val("");
			$("#BOX").val("");
			$("#REQ").val("");
			$("#DESC01").val("");
			$("#LOTA11").val("");
			$("#LOTA13").val("");
			$("#LOCATG").val("SETLOC");
			
			$("#PACKID").select();
		}
		
	}
	
 	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
	        var data = gridList.getSelectData("gridList");
	        var locatrg = $("#LOCATG").val();
	        var qtyTotal = $("#QTY").val();
	        var packid = $("#PACKID").val();
	        
	        //세트조립 화면에서 skukey 가져오기
// 			var hrowNum = gridList.getFocusRowNum("gridList");
// 			var skukey = gridList.getColData("gridList", hrowNum, "SKUKEY");
// 			$("#SKUKEY").val(skukey);
	        
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
				}
			}

			if(locatrg.trim() == ""){
				commonUtil.msgBox("VALID_M0404");
				$("#LOCATG").focus();
				return;
			}
			
			// #QTY 총 갯수 (작업수량)0을 입력할수 없습니다.
			if(qtyTotal.trim() == 0){
				commonUtil.msgBox("작업수량에 0을 입력할 수 없습니다.");
				$("#LOCATG").focus();
				return;
			}
      		
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
			
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCATG", locatrg);
			param.put("JOBTYP", "401");
			param.put("PACKID", packid);
			param.put("INOQTY", qtyTotal);
				
			netUtil.send({
				url : "/mobile/mobileOutbound/json/saveMTO03.data",
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
			
			var GList = gridList.getGridBox('gridList').getDataAll();
			$("#DESC01").val(GList[0].get("PACKNM"));
			$("#LOTA11").val(dateParser(GList[0].get("LOTA11"),'SD'));
			$("#LOTA13").val(dateParser(GList[0].get("LOTA13"),'SD'));
			
			$("#LOCATG").select();
		}

	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
			boxTotal();
			var GList = gridList.getGridBox('gridList').getDataAll();
			$("#DESC01").val(GList[0].get("PACKNM"));
			$("#LOTA11").val(dateParser(GList[0].get("LOTA11"),'SD'));
			$("#LOTA13").val(dateParser(GList[0].get("LOTA13"),'SD'));
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
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list2[i].get("GRowNum"), "QTSIWH"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
	} 
	
	// 박스 입력 , 총 QTY 박스 BOX 낱 REQ
	function boxTotal(){
		//실행할 내용
		var item = gridList.getSelectData("gridList");
		var box = $("#BOX").val();
		var req = $("#REQ").val();
		var qty = 0;
		var pakqtd =0;
		
		var uomqty = 0; //단위수량
		var useqty = 0; //가용수량
		var lakqty = 0; //부족수량  = 가용수량  - 단위수량 * 총  
		
		for(var i=0; i<item.length; i++){
			var gridMap = item[i].map;
			pakqtd = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "PAKQTD"));
			qty = ((Number)(box)*(Number)(pakqtd))+(Number)(req); 
			
			uomqty = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "UOMQTY"));
			useqty = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "USEQTY"));
			lakqty = (Number)(useqty) - ((Number)(uomqty)*(Number)(qty));
			if(lakqty > 0 ){ //부족수량이 0보다 크면 0으로 
				lakqty = 0;
			}
			gridList.setColValue("gridList", item[i].get("GRowNum"), "LAKQTY", lakqty );
		}
		
		$("#QTY").val(qty);
	}
	
	// 낱개입력 
	function reqTotal(){
		//실행할 내용
		var item = gridList.getSelectData("gridList");
		var box = $("#BOX").val();
		var req = $("#REQ").val();
		var qty = $("#QTY").val();
		
		var uomqty = 0; //단위수량
		var useqty = 0; //가용수량
		var lakqty = 0; //부족수량
		var total = 0;
		
		for(var i=0; i<item.length; i++){
			var gridMap = item[i].map;
			pakqtd = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "PAKQTD"));
			qty = ((Number)(box)*(Number)(pakqtd)); 
			total = (Number)(qty)+(Number)(req);
			
			uomqty = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "UOMQTY"));
			useqty = (Number)(gridList.getColData("gridList", item[i].get("GRowNum"), "USEQTY"));
			lakqty = (Number)(useqty) - ((Number)(uomqty)*(Number)(total));
			if(lakqty > 0 ){
				lakqty = 0;
			}
			gridList.setColValue("gridList", item[i].get("GRowNum"), "LAKQTY", lakqty );
		}
		
		$("#QTY").val(total);
	}
		
		
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>세트조립</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_SET_CD">세트코드<span class="make">*</span></th>
								<td><input type="text" id="PACKID" name="PACKID" class="input input-width" validate="required(STD_SET_CD)"/></td>
							</tr>
							<tr>
								<th CL="STD_SETNAME">세트품명<span class="make"></span></th>
								<td><input type="text" id="DESC01" name="DESC01" class="input input-width" readonly/></td>
							</tr>
							<tr>
								<th CL="STD_LOTA1113">제조/유통<span class="make"></span></th>
								<td>
									<input type="text" id="LOTA11" name="LOTA11" UIFormat="C" class="input1 input-width">
									<input type="text" id="LOTA13" name="LOTA13" UIFormat="C" class="input1 input-width"/>
								</td>
							</tr>
							<tr>
								<th CL="STD_QTBREQ">총/박/낱<span class="make"></span></th>
								<td>
									<input type="text" id="QTY" name="QTY" class="input input-width"style="width:33.3333%;float:left;" readonly/> 
									<input type="text" id="BOX" name="BOX" onchange="boxTotal()" class="input input-width" style="width:33.3333%;float:left;"/>
									<input type="text" id="REQ" name="REQ" onchange="reqTotal()"class="input input-width" style="width:33.3333%;float:left;"/>
<!-- 									<input type="text" id="BIN" name="BIN" class="input2 input-width" readonly/> -->
								</td>
							</tr>
<!-- 							<tr> -->
<!-- 								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th> -->
<!-- 								<td> -->
<!-- 									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" readonly/> -->
<!-- 									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/> -->
<!-- 								</td> -->
<!-- 							</tr> -->
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
							<tbody id="gridList">
								<tr CGRow="true">
									<td GH="40" GCol="rownum">1</td>
									<td GH="40" GCol="rowCheck"></td>
									<td GH="80" GCol="text,BARCOD"></td> <!--바코드   -->
									<td GH="300" GCol="text,DESC01" GF="S 20"></td>  <!--제품명-->
									<td GH="80" GCol="text,UOMQTY" GF="N 13,1"></td>  <!--단위수량-->
									<td GH="80" GCol="text,QTSIWH" GF="N 13,1"></td>  <!--재고수량-->
									<td GH="80" GCol="text,USEQTY" GF="N 13,1"></td>  <!--가용수량--> 
									<td GH="50" GCol="text,LAKQTY" GF="S 20"></td>  <!-- 부족 -->
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--품목-->
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
<!-- 							<li> -->
<!-- 								<div>To바코드<input type="text" id="LOCATG" name="LOCATG" value="SETLOC"></div> -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</div> -->
<!-- 				</div> -->
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