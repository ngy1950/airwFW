<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<script type="text/javascript">
/* 모바일 토탈피킹검수 화면 */

var input = '';
var mode = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileOutbound",
			command : "MDL07",
			gridMobileType : true
	    });
		
		//레이어 팝업
		gridList.setGrid({
	    	id : "LayerGridList",
			module : "MobileOutbound",
			command : "MDL07POP",
			gridMobileType : true
	    });
		
		$("#STKNUM").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#STKNUM").focus();
		
		//팝업창 거래처명 검색
		$("#PTNRKYNM").keyup(function(e){if(e.keyCode == 13)pop_searchList();});
		
		
		//검색값 클릭시 초기화
		$("#STKNUM").click(function(){$(this).select()}) 
		$("#PTNRKYNM").click(function(){$(this).select()}) 
		$("#TRNUTG").click(function(){$(this).select()}) 

		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#STKNUM";

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
			param.put("STKNUM",$("#STKNUM").val());

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			$("#PTNRKYNM").val(""); 
			$("#TRNUTG").val("");

			$("#STKNUM").select();
		}
	}
	
	//팝업창 서치리스트 조회
	function pop_searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("PTNRKYNM",$("#PTNRKYNM").val());

			gridList.gridList({
		    	id : "LayerGridList",
		    	param : param
		    });

			$("#PTNRKYNM").select();
			
		}
	}
 
	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			calTotal();
			var GList = gridList.getGridBox('gridList').getDataAll();
			$("#STKNUM").val(GList[0].get("STKNUM"));
		//팝업레이어
		}else if(gridId == "LayerGridList" && dataCount > 0){
			calTotal();
			var GList = gridList.getGridBox('LayerGridList').getDataAll();
			$("#PTNRKYNM").val(GList[0].get("PTNRKYNM"));
			
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
		$(".layer_popup .label-btn").show();
		$(".layer_popup").animate({height:"100%"},400);
		$("#PTNRKYNM").focus();
		
	}
	//레이어 팝업 닫기
	function LayerPopClose() {		
		$(".layer_popup").animate({height:"0%"},200,function(){$(".layer_popup .label-btn").hide()});
	} 
	
	
	//레이어팝업
	function pop_saveData(){
		if(gridList.validationCheck("LayerGridList", "all")){

		    var param = new DataMap();
	        var data = gridList.getSelectData("LayerGridList");
	        var locatrg = $("#LOCATG").val();
	        
	        //세트해체 화면에서 stokky 가져오기
			var hrowNum = gridList.getFocusRowNum("gridList");
			var svbeln = gridList.getColData("gridList", hrowNum, "SVBELN");
			$("#SVBELN").val(svbeln);

			if(data.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//유효성검사
			for(var i=0; i<data.length; i++){
				var gridMap = data[i].map;

				if((Number)(gridList.getColData("LayerGridList", data[i].get("GRowNum"), "QTYWRK")) < 1){
					commonUtil.msgBox("VALID_M0952");
					gridList.setColFocus("LayerGridList", data[i].get("GRowNum"), "QTYWRK");
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
			param.put("JOBTYP", "207");
			/* MDL07 토탈피킹검수 화면에서 넘어온 SVBELN 셋팅 */
			param.put("SVBELN", svbeln); 
			
			netUtil.send({
				url : "/mobile/mobileOutbound/json/MDL07POP.data",
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
	
	//그리드 컬럼 변경 이벤트
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

	
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>토탈피킹검수</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_STKNUMTX">총괄문서<span class="make">*</span></th> 
								<td><input type="text" id="STKNUM" name="STKNUM" class="input input-width" validate="required(STD_STKNUMTX)"/></td>
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
									<td GH="80" GCol="text,LOCADK" GF="S 20"></td>  <!--Dock 로케이션 -->
									<td GH="200" GCol="text,PTNRKYNM"></td>  <!-- 거래처명-->
									<td GH="100" GCol="text,SVBELN"></td>  <!--S/O번호 -->
									<td GH="80" GCol="text,QTSHPO" GF="N 13,1"></td>  <!--지시수량 -->
									<td GH="80" GCol="text,QTJCMP" GF="N 13,1"></td>  <!--완료수량-->
									<td GH="80" GCol="text,QTSHPD" GF="N 13,1"></td>  <!--출고수량-->
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
				<label id="threeP" onClick="LayerPop()">주문선택</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
	<!-- LayerPop popup -->
	<div class="layer_popup" id="LayerPop" >
		<div class="mobile_order">
			<div class="layer_title"><span>토탈피킹검수  팝업</span></div>
			<div class="mobile-data-top">
				<div class="mobile-data-box">
					<div class="content_layout_wrap" id="searchArea">
						<table>
							<tbody>
								<tr>
									<th>거래처명<span class="make"></span></th>
									<td><input type="text" id="PTNRKYNM" name="PTNRKYNM" class="input input-width" value=""/></td>
								</tr>
								<tr>
									<th>분배위치<span class="make"></span></th>
									<td><input type="text" id="TRNUTG" name="TRNUTG" class="input input-width" value="" /></td>
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
										<td GH="80" GCol="text,CONFRM" GF="S 20"></td>  <!-- 검  -->
										<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--제품코드 -->
										<td GH="300" GCol="text,DESC01" GF="S 20"></td>  <!--제품명 -->
										<td GH="80" GCol="text,QTSHPO" GF="N 13,1"></td>  <!--지시수량  -->
										<td GH="80" GCol="text,QTJCMP" GF="N 13,1"></td>  <!--완료수량-->
										<td GH="80" GCol="input,QTYWRK" GF="N 13,1"></td>  <!--작업수량-->
										<td GH="40" GCol="text,QTDUOM" GF="N 13,1"></td>  <!--입수 -->
										<td GH="80" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스수량 -->
										<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량-->
										
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