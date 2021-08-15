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
			command : "MDL08",
			gridMobileType : true
	    });
		
		$("#CARDAT").keyup(function(e){if(e.keyCode == 13)searchList();}); 
		
// 		//가상키보드 제어 //제어 필요 없는 화면
// 		$('input').attr("inputmode","none");
// 		input = "#CARDAT";

// 		$('#searchArea input').focus(function(){
// 			input = this;
// 			if(mode != 'key'){
// 				$(this).attr("inputmode","none")
// 			}
// 			if($(this).hasClass("calendarInput") == false && $(this).prop("readonly") == false && $(this).prop("type") != "button" && mode != 'key'){
// 				$('#keyboardBtn').fadeIn("fast");
// 			}
// 			mode = 'none'

// 		});
// 		$('#searchArea input').blur(function(){
// 			var input = this;
// 			$('#keyboardBtn').fadeOut("fast");
// 		});
		
// 		$('#keyboardBtn').click(function(){
// 			mode = 'key';
// 			$('#keyboardBtn').fadeOut("fast");
// 			$(input).attr("inputmode","text");
// 			$(input).focus();
// 		});
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
			$("#TRNUTG").val("");
		}
	}
	
	//차량출발
	function Cargo(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getSelectData("gridList");
	       // var locatrg = $("#LOCATG").val();
	       var carnum = $("#CARNUM").val();
	       var shipsq = $("#SHIPSQ").val();
	      	 
			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			

			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("JOBTYP", "291");
			//param.put("LOTA10",dateParser("S", 0, 0, 0));  //  NVL('NaN0NaN0NaN', ' ')
			param.put("LOTA10",dateParser(null, "S", 0, 0, 0)); // NVL('20210402', ' ')
			
			netUtil.send({
				url : "/mobile/mobileOutbound/json/saveMDL08.data",
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
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList" && isCheck == true){
			calTotal();
		}
	}
	//로우클릭시
	function gridListEventRowClick(gridId, rowNum, colName){	
		if(gridId == "gridList"){
			$("#CARNUM").val(gridList.getColData("gridList", rowNum, "CARNUM")); 
			$("#SHIPSQ").val(gridList.getColData("gridList", rowNum, "SHIPSQ")); 
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
		
		//$("#WORKSUM1").val(worksum1);
		//$("#WORKSUM2").val(worksum2);
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>차량출발</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_CARDAT">배송일자<span class="make"></span></th>
								<td>
									<input type="text" id="CARDAT" name="CARDAT" class="input input-width" UIFormat="C N" validate="required(STD_CARDAT)"/>
								</td>
							</tr>
							<tr>
								<th CL="STD_CARNUM">차량번호<span class="make"></span></th>
								<td><input type="text" id=CARNUM name="CARNUM" class="input input-width" readonly/></td> 
							</tr>
							<tr>
								<th CL="STD_SHIPSQ">배송차수<span class="make"></span></th>
								<td>
									<input type="text" id="SHIPSQ" name="SHIPSQ" class="input input-width" readonly/>
<!-- 									<input type="button" class="input1"  CB="Search SEARCH BTN_SEARCH"/> -->
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
									<td GH="80" GCol="text,CASTYN" GF="S 20"></td>  <!-- 차량출발여부 -->
									<td GH="80" GCol="text,CASTDT" GF="D"></td>  <!-- 차량출발일자 -->
									<td GH="80" GCol="text,SHIPSQ" GF="S 20"></td>  <!-- 배송차수 -->
									<td GH="90" GCol="text,CARNUM" GF="S 20"></td>  <!-- 차량번호 -->
									<td GH="90" GCol="text,CARNUMNM" GF="S 20"></td>  <!-- 차량정보 -->
									<td GH="60" GCol="text,CARTYP" GF="N 13,1"></td>  <!-- 차량톤수-->
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
<!-- 								<div class="workBox">작업<input type="text" id="WORKSUM1" name="WORKSUM1" readonly>/<input type="text" id="WORKSUM2" name="WORKSUM2" readonly></div> -->
<!-- 							</li> -->

<!-- 							<li> -->
<!-- 								<div>To지번<input type="text" id="LOCATG" name="LOCATG"></div> -->
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
<!-- 	<div id="keyboardBtn" style="display:none;" >키보드열기</div> -->
</body>
</html>