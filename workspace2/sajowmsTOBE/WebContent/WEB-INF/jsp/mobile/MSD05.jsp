<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<script type="text/javascript">
/* 모바일 할당조회완료 화면 */
var input = '';
var mode = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileOutbound",
			command : "MSD05",
			gridMobileType : true
	    });
		
		$("#SKUKEY").keyup(function(e){if(e.keyCode == 13)searchList();});
		$("#SKUKEY").focus();
		
		//검색값 클릭시 초기화
		$("#SKUKEY").click(function(){$(this).select()}); 
		
		//총 건수 위치 고정
		$(function(){	
			$('.mobile-data-box').scroll(function() {
			    $(this).find('.tableUtil').css('right', -($(this).scrollLeft()));
			});
		})
		
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
			
			$("#DESC01").val("");
			$("#PLTBOX").val("");
			$("#WORKSUM2").val("");
			// 검색조건 선택후 블러처리
			$("#SKUKEY").focus();
			$("#SKUKEY").select();
		}
	}
 
	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			var list= gridList.getGridData("gridList");
			var desc01 = list[0].map.DESC01;
			var pltbox = list[0].map.PLTBOX;
			
			// 검색조건 품목명, 팔렛당박스 수 셋팅
			$("#DESC01").val(desc01);
			$("#PLTBOX").val(pltbox);
			
			calTotal();
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}


	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		 if(colName == "QTYWRK"){ //수량변경시연결된 수량 변경
			var boxqty = 0;
			var bxiqty = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
			var qtywrk = Number(gridList.getColData(gridId, rowNum, "QTYWRK"));
			boxqty = floatingFloor((Number)(qtywrk)/(Number)(bxiqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);

		  	//수량 CHECK
		  	if(Number(colValue) > Number(gridList.getColData(gridId, rowNum, "QTSIWH"))){
		  		commonUtil.msgBox("VALID_M0923");
				gridList.setColValue(gridId, rowNum, "QTYWRK", 0);
				gridList.setColFocus(gridId, rowNum, "QTYWRK");
		  	}
		  	calTotal();
		 }else if( colName == "LOTA11" ){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota11 = gridList.getColData(gridId, rowNum, "LOTA11");
				var lota13 = dateParser(lota11 , 'S', 0 , 0 , Number(outdmt)) ;
				gridList.setColValue(gridId, rowNum, "LOTA13", lota13);
	    		
			} else if( colName == "LOTA13" ){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt)) ;
				gridList.setColValue(gridId, rowNum, "LOTA11", lota11);
				
			}
		 
	}

	//합계 계산
	function calTotal(){
		var worksum2 = 0;
		var list= gridList.getGridData("gridList");
		
		//선택 합계
		for(var i=0; i<list.length; i++){
			var gridMap = list[i].map;
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "QTYIN"));
		}
		
		$("#WORKSUM2").val(worksum2);
	} 
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>품목별 재고현황</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th>품목코드<span class="make">*</span></th>
								<td><input type="text" id="SKUKEY" name="SKUKEY" class="input input-width" validate="required(STD_GOODS_CD)" ></td>
							</tr>
							<tr>
								<th>품목명<span class="make"></span></th>
								<td><input type="text" id="DESC01" name="DESC01" class="input input-width" readonly="readonly" ></td>
							</tr>
							<tr>
								<th>팔렛당박스 수<span class="make"></span></th>
								<td><input type="text" id="PLTBOX" name="PLTBOX" class="input input-width" readonly="readonly" ></td>
							</tr>
<!-- 							<tr> -->
<!-- 								<th>피킹지번<span class="make"></span></th> -->
<!-- 								<td><input type="text" id="PLOCAKY" name="PLOCAKY" class="input input-width" readonly="readonly" ></td> -->
<!-- 							</tr> -->
							<tr>
								<th>가용재고<span class="make"></span></th>
								<td><input type="text" id="WORKSUM2" name="WORKSUM2" class="input input-width" readonly="readonly" ></td>
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
									<td GH="90" GCol="text,LOCAKY" GF="S 20"></td>  <!-- 지번-->
									<td GH="90" GCol="text,LOCASR_L7141" GF="S 20"></td>  <!-- 지번-->
									<td GH="90" GCol="text,LOTA13" GF="C"></td>  <!--유통기한-->
									<td GH="70" GCol="text,LOTA06"></td>  <!--상태-->
									<td GH="60" GCol="text,QTYIN" GF="N 13,1"></td>  <!--재고-->
									<td GH="60" GCol="text,QTSIWH" GF="N 13,1"></td>  <!--가용-->
									<td GH="60" GCol="text,PLTQTY" GF="N 13,1"></td>  <!--팔렛-->
									<td GH="60" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스-->
									<td GH="60" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량-->
									<td GH="60" GCol="text,QTSALO" GF="N 13,1"></td>  <!--할당-->
									<td GH="60" GCol="text,STSPMI" GF="N 13,1"></td>  <!--입고중-->
									<td GH="60" GCol="text,STSPMO" GF="N 13,1"></td>  <!--출고중-->
									<td GH="60" GCol="text,QTSBLK" GF="N 13,1"></td>  <!--보류-->
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
<!-- 								<div class="workBox">가용재고<input type="text" id="WORKSUM2" name="WORKSUM2"></div> -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</div> -->
<!-- 				</div> -->
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