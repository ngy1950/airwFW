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
			command : "MDL12",
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
			
			$("#PLBQTY").val(gridList.getColData("gridList", 0, "PLBQTY"));
			
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
		<div class="m_menutitle"><span>재고보충관리</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_SKUKEY">제품코드<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width" ></td>
							</tr>
							<tr>
								<th CL="STD_PLBQTY">팔렛당박스수량<span class="make">*</span></th>
								<td><input type="text" id="PLBQTY" name="PLBQTY" class="input input-width"  readonly="readonly"></td>
							</tr>
							<tr>
								<th CL="STD_TASKDT">작업지시일<span class="make"></span></th>
								<td><input type="text" id="DOCDAT" name="DOCDAT" class="input input-width" UIFormat="C N" validate="STD_TASKDT"></td>
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
		    						<td GH="110 STD_CARDAT" GCol="text,CARDAT" GF="D 90">배송일자</td>	<!--배송일자-->
		    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
		    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
		    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
		    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
		    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
		    						<td GH="160 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
		    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
		    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
		    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
		    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
		    						<!-- <td GH="80 STD_PLBQTY" GCol="text,PLBQTY" GF="N 17,0">팔렛당박스수량</td> -->	<!--팔렛당박스수량-->
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