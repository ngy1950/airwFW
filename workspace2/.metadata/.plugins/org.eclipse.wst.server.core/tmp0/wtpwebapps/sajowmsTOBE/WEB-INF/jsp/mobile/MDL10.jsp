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
			command : "MDL10",
			gridMobileType : true
	    });
		
		$("#CARDAT").keyup(function(e){if(e.keyCode == 13)searchList();});
		
		$("#SKUKEY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#SKUKEY").focus();
		
		//검색값 클릭시 초기화
		$("#SKUKEY").click(function(){$(this).select()}); 
		
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
			param.put("DOCDAT",$("#DOCDAT").val());

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			

			$("#DESC01").val("");
			$("#WORKSUM1").val("");
			$("#WORKSUM2").val("");
			$("#WORKSUM3").val("");

			$("#SKUKEY").select();
			
			
		}
	}
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
		    var search = inputList.setRangeDataParam("searchArea");
	        var data = gridList.getSelectData("gridList");
	        var locatrg = $("#LOCATG").val();

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
				}
			}
			
			if(locatrg.trim() == ""){
				commonUtil.msgBox("VALID_M0404");
				$("#LOCATG").focus();
				return;
			}
	        
	        
			param.put("data", data);		
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCATG", locatrg);
			param.put("JOBTYP", "510");
			
			
			netUtil.send({
				url : "/mobile/MobileInbound/json/saveMDL10.data",
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
			$("#DESC01").val(GList[0].get("DESC01"));
			
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
		var worksum3 = 0;
		var list = gridList.getGridData("gridList");
		
		//전체 팔렛, 박스, 잔량 합계
		for(var i=0; i<list.length; i++){
			var gridMap = list[i].map;
			worksum1 = worksum1+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "PLTQTY"));
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "BOXQTY"));
			worksum3 = worksum3+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "REMQTY"));
		}
		

		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
		$("#WORKSUM3").val(worksum3);
	}
	
	
//   //더블클릭
//    function gridListEventRowDblclick(gridId, rowNum){

//     if(gridId == "gridList"){
    	
//         $("#SKUKEY").val(gridList.getColData("gridList", rowNum, "SKUKEY")); 
//         $("#DESC01").val(gridList.getColData("gridList", rowNum, "DESC01")); 
        
//       }
//    }
  
// 	//체크박스 이벤트 후 
// 	function gridListEventRowCheck(gridId, rowNum, isCheck){	
// 	    if(gridId == "gridList"){
	    	
// 	        $("#SKUKEY").val(gridList.getColData("gridList", rowNum, "SKUKEY")); 
// 	        $("#DESC01").val(gridList.getColData("gridList", rowNum, "DESC01")); 
	        
// 	      }
// 	}
	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>품목별 피킹검수</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th>배송일자<span class="make"></span></th>
								<td><input type="text" id="CARDAT"  name="CARDAT" class="input input-width" UIFormat="C Y" validate="required(배송일자)" ></td>
							</tr>
							<tr>
								<th>품목코드<span class="make"></span></th>
								<td><input type="text" id="SKUKEY" name="SKUKEY" class="input input-width" validate="required(품목코드)"></td>
							</tr>
							<tr>
								<th>품목명<span class="make"></span></th>
								<td><input type="text" id="DESC01" name="DESC01" class="input input-width" readonly/></td>
							</tr>
							<tr>
								<th CL="STD_WRKSUM">팔렛/박스/잔량<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input input-width" style="width:33.3333%;float:left;" readonly/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input input-width" style="width:33.3333%;float:left;" readonly/>
									<input type="text" id="WORKSUM3" name="WORKSUM3" class="input input-width" style="width:33.3333%;float:left;" readonly/>
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
									<td GH="100" GCol="text,CARNUM" GF="S 20"></td>    <!-- 차량 -->
									<td GH="50" GCol="text,PLTQTY" GF="N 13,1"></td>  <!-- 팔렛 -->
									<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                   
									
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
				<label id="half" onClick="searchList()">검색</label>
				<label id="half" onClick="window.location.reload()">초기화</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
</body>
</html>