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
			command : "MSD03",
			gridMobileType : true
	    });
		
		$("#BARCODE").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#BARCODE").focus();
		
		//검색값 클릭시 초기화
		$("#BARCODE").click(function(){$(this).select()}); 
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#BARCODE";

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
			
			$("#WORKSUM2").val("");
			// 검색조건 선택후 블러처리
			$("#BARCODE").focus();
			$("#BARCODE").select();

		}
	}	

	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
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
	} 
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>위치별 재고현황</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_BARCOD">바코드<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width"/></td>
							</tr>
<!-- 							<tr> -->
<!-- 								<th CL="STD_QTSDIF">가용재고<span class="make"></span></th> -->
<!-- 								<td><input type="text" id="WORKSUM2" name="WORKSUM2" class="input input-width" readonly/></td> -->
<!-- 							</tr> -->
							<tr>
								<th CL="STD_AVISTC">가용재고<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input input-width" readonly/>
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
									<td GH="300 STD_DESC01" GCol="text,DESC01" </td>  <!-- 제품명 -->  
									<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" </td>  <!-- 로케이션 -->  
									<td GH="80 STD_BACODE" GCol="text,TRNUID" </td>  <!-- 바코드  -->  
									<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D"></td> <!-- 유통기한 -->
									<td GH="80 STD_STATIT" GCol="text,LOTA06" </td>  <!-- 상태 -->  
									<td GH="60 STD_QTYIN" GCol="text,QTYIN" GF="N 13,1"></td>  <!-- 재고 -->
									<td GH="60 STD_QTAVAL" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 가용 -->
									<td GH="40 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="60 STD_PLTQTY" GCol="text,PLTQTY" GF="N 13,1"></td>  <!-- 팔렛트수량 -->
									<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="60 STD_REMQTY" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->
									<td GH="80 STD_QTSALO" GCol="text,QTSALO" GF="N 13,1"></td>  <!-- 할당 -->
									<td GH="60 STD_STSPMI" GCol="text,STSPMI" GF="N 13,1"></td>  <!-- 입고중 -->
									<td GH="60 STD_STSPMO" GCol="text,STSPMO" GF="N 13,1"></td>  <!-- 출고중 -->
									<td GH="60 STD_HOLD" GCol="text,QTSBLK" GF="N 13,1"></td>  <!-- 보류 -->
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
				<label id="half" onClick="searchList()">검색</label>
				<label id="half" onClick="window.location.reload()">초기화</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
</body>
</html>