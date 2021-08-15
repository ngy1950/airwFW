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
			module : "MobileInventory",
			command : "MSD01",
			gridMobileType : true
	    });
		
		$("#PHYIKY").focus();
		
		$("#PHYIKY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#GTINCD").keyup(function(e){if(e.keyCode == 13)barcodeChk();});
		
// 		//검색값 클릭시 초기화
		$("#PHYIKY").click(function(){$(this).select()}); 
		$("#GTINCD").click(function(){$(this).select()}); 
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#PHYIKY";

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
			

			$("#TOTAL1").val("");
			$("#TOTAL2").val("");
			$("#WORKSUM1").val("");
			$("#WORKSUM2").val("");
			$("#GTINCD").val("");

			$("#PHYIKY").select();
		}
	}
	
	//바코드 검색시 체크박스
	function barcodeChk(){
		var grid = gridList.getGridData("gridList");
		var count = 0;
		if(grid.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		for (var i=0; i<grid.length; i++){
			var gridMap = grid[i].map;
			var gtincd = (gridList.getColData("gridList", grid[i].get("GRowNum"), "GTINCD"))
			var eancod = (gridList.getColData("gridList", grid[i].get("GRowNum"), "EANCOD"))
			
			if($("#GTINCD").val() == gtincd || $("#GTINCD").val() == eancod){
				if(gridList.getGridBox("gridList").selectRow.get(i) == 'true'){
					commonUtil.msgBox("* 이미 실사하였습니다. *");
					$("#GTINCD").val("");
					$("#GTINCD").focus();
					return;
				}else{
					gridList.setRowCheck("gridList", grid[i].get("GRowNum"), true);
					gridList.setColFocus("gridList", grid[i].get("GRowNum"));
					count++;
				}
			}
		}
		
		if (count == 0) {
			commonUtil.msgBox("* 바코드 재고가 없습니다. *");
			$("#GTINCD").val("");
			$("#GTINCD").focus();
		}
		$("#GTINCD").val("");
		$("#GTINCD").focus();
	}
	
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getSelectData("gridList");


			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}	        
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("JOBTYP", "520");			
			
			netUtil.send({
				url : "/mobile/mobileInventory/json/saveMSD01.data",
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
			$("#GTINCD").select();
			calTotal();
			
		}
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
		}else if(gridId == "LayerGridList"){
			calTotal();
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
		
		$("#TOTAL1").val(list.length);
		$("#TOTAL2").val(list2.length); 
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
	}
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>재고실사</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_RELNUM">실사번호<span class="make">*</span></th>
								<td><input type="text" id="PHYIKY" name="PHYIKY" class="input input-width"></td>
							</tr>
							<tr>
								<th CL="STD_BACODE">바코드<span class="make"></span></th>
								<td><input type="text" id="GTINCD" name="GTINCD" class="input input-width"/></td>
							</tr>
							<tr>
								<th CL="STD_SELALL">선택/총건수<span class="make"></span></th>
								<td>
									<input type="text" id="TOTAL1" name="TOTAL1" class="input1 input-width" readonly/>
									<input type="text" id="TOTAL2" name="TOTAL2" class="input1 input-width" readonly/>
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
									<td GH="40" GCol="rownum"></td>                           
									<td GH="40" GCol="rowCheck"></td>
									<td GH="300 STD_DESC01" GCol="text,DESC01" </td>  <!-- 제품명 -->  
									<td GH="80 STD_BACODE" GCol="text,TRNUID" </td>  <!-- 바코드  -->  
									<td GH="80 STD_QTSIWH" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 재고수량 -->
									<td GH="80 STD_QTYWRK" GCol="input,QTYWRK" GF="N 13,1"></td>  <!-- 작업수량 -->
									<td GH="40 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40 STD_REMQTY" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                    
									<td GH="70 STD_OLDSKU" GCol="text,OLDSKU" ></td> <!-- 품목 -->
									<td GH="200 STD_KEY" GCol="text,KEY" GF="S 20"></td>  <!-- KEY -->
									<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" </td>  <!-- 로케이션 -->  
									<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" </td>  <!-- 제품코드 -->  
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