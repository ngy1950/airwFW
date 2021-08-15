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
			command : "MGR07",
			gridMobileType : true
	    });
		
		$("#SKUKEY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#SKUKEY").focus();
		//입고문서번호
		
		$("#SKUKEY").keyup(function(e){if(e.keyCode == 13)$("#LOCATG").select();});
		
// 		//검색값 클릭시 초기화
		$("#SKUKEY").click(function(){$(this).select()});
		$("#LOCATG").click(function(){$(this).select()});
		$("#SKULOC").click(function(){$(this).select()});
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#SKUKEY";

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

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			
			$("#LOCATG").val("");
			$("#SKULOC").val("");
			$("#WORKSUM1").val("");
			$("#WORKSUM2").val("");

			$("#SKUKEY").select();
		}
	}
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getSelectData("gridList");
	        var locatrg = $("#LOCATG").val();
	        var trnutg = $("#SKULOC").val();

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
				}else if((Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTYWRK")) > (Number)(gridList.getColData("gridList", data[i].get("GRowNum"), "QTSIWH"))){
					commonUtil.msgBox("VALID_M0923");
					gridList.setColFocus("gridList", data[i].get("GRowNum"), "QTYWRK");
					return;
				}else if (gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA11").trim() == "" || gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA11").trim() == null){
					commonUtil.msgBox("* 제조일자를 입력해주세요 *");
					return;
				}else if (gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA13").trim() == "" || gridList.getColData("gridList", data[i].get("GRowNum"), "LOTA13").trim() == null){
					commonUtil.msgBox("VALID_M0324");
					return;
				}
				
			}
			
			if(locatrg.trim() == ""){
				commonUtil.msgBox("VALID_M0404");
				$("#LOCATG").focus();
				return;
			}
			
			if(locatrg.trim() != trnutg.trim()){
				commonUtil.msgBox("P존지번과 TO지번이 불일치합니다.\n 계속 진행하겠습니까?");
				//return;
			}
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
			
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCATG", locatrg);
// 			param.put("TRNUID", $("#TRNUTG").val());
			param.put("TRNUID",data[0].map.TRNUID);
			param.put("JOBTYP", "310");			
			
			netUtil.send({
				url : "/mobile/MobileInbound/json/saveMGR07.data",
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
			$("#LOCATG").select();
			$("#SKULOC").val(gridList.getColData(gridId, 0, "SKULOC"));
		}
	}
	
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
			$("#LOCATG").select();
			$("#SKULOC").val(gridList.getColData(gridId, rowNum, "SKULOC"));
		}
	}
	//전체 체크박스 이벤트 후 
	function  gridListEventRowCheckAll(gridId, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}
	
	function gridListEventRowClick(gridId, rowNum, colName){
		calTotal();
		
		if(colName != "LOTA11" && colName != "LOTA12" && colName != "LOTA13" && colName != "QTYWRK"){
			$("#LOCATG").select();
			$("#SKULOC").val(gridList.getColData(gridId, rowNum, "SKULOC"));
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
	
	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>적치(잔량)</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_SKUKEY">제품코드<span class="make"></span>*</th>
								<td><input type="text" id="SKUKEY" name="SKUKEY" class="input input-width" validate="required(STD_SKUKEY)"></td>
							</tr>
							<tr>
								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" readonly/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/>
								</td>
							</tr>
							<tr>
								<th CL="STD_TOLOC">To지번<span class="make"></span></th>
								<td>
									<input type="text" id="LOCATG" name="LOCATG" class="input input-width"/>
								</td>
							</tr>
							<tr>
								<th CL="STD_PTRUNG">P존지번<span class="make"></span></th>
								<td>
									<input type="text" id="SKULOC" name="SKULOC" class="input input-width"/>
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
									<td GH="300" GCol="text,DESC01"></td>  <!-- 제품명 --> 
									<td GH="80" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 재고수량 -->
									<td GH="80" GCol="input,QTYWRK" GF="N 13,1" validate="required"></td>  <!-- 작업수량 -->
									<td GH="40" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="80" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->  
									<td GH="100" GCol="text,LOCAKY"></td>  <!-- 로케이션 --> 
									<td GH="120" GCol="text,DPUTZO"></td>  <!-- 적치구역  -->
									<td GH="100" GCol="input,LOTA11" GF="C"></td> <!-- 제조일자 --> 
									<td GH="100" GCol="input,LOTA12" GF="C"></td> <!-- 입고일자 -->	
									<td GH="100" GCol="input,LOTA13" GF="C"></td> <!-- 유통기한 -->		
									<td GH="100" GCol="text,SKUKEY"></td>  <!-- 품목 -->		
									<!-- 									<td GH="80" GCol="text,KEY" GF="S 20"></td>  KEY    -->					
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