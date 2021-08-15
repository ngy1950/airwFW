<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<style>


</style>
<script type="text/javascript">
/* 모바일 할당조회완료 화면 */

var input = '';
var mode = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileOutbound",
			command : "MDL01",
			gridMobileType : true
	    });
		
		//문서번호
		$("#TASKKY").keyup(function(e){if(e.keyCode == 13)searchList();});
// 		$("#TASKKY").focus();
		//배송일자
		$("#CARDAT").keyup(function(e){if(e.keyCode == 13)searchList();});
		//제품코드
		$("#SKUKEY").keyup(function(e){if(e.keyCode == 13)searchList();});
// 		$("#SKUKEY").focus();
		
		//검색값 클릭시 초기화
		$("#TASKKY").click(function(){$(this).select()});
// 		$("#SKUKEY").click(function(){$(this).select()});

		//총 건수 위치 고정
		$(function(){	
			$('.mobile-data-box').scroll(function() {
			    $(this).find('.tableUtil').css('right', -($(this).scrollLeft()));
			});
		})
		
		//가상키보드 제어
		$('input').attr("inputmode","none");
		input = "#TASKKY";

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
			$("#LOTA13").val("");
			$("#QTSIWH").val("");
			
 			if(param.map.TASKKY != null && param.map.SKUKEY == null){
 				$("#TASKKY").select();
 			}else if(param.map.SKUKEY != null){
 				$("#SKUKEY").select();
 			}
			
		}
	}
<%-- 	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();
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
			param.put("TRNUTG", $("#TRNUTG").val());
			param.put("JOBTYP", "320");
			
			netUtil.send({
				url : "/mobile/mobileInventory/json/saveMSD00.data",
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
 --%>
 
	//그리드 바인드 후
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridList" && dataCount > 0){
			calTotal();
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}
/* 
    //생성
    function popOpen(){
//      if(gridList.getSelectData("gridList1"))
       // var data = getfocusGridDataList("gridList");
        
        page.linkPopOpen("/mobile/MDL02POP.page", null, "height=500,width=600,resizeble=yes");
    } 
*/    
/* 
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
*/
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>재고보충완료확인</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_RECRKY">문서번호<span class="make">*</span></th>
								<td><input type="text" id="TASKKY" name="TASKKY" class="input input-width" ></td>
							</tr>
<!-- 							<tr> -->
<!-- 								<th CL="STD_CARDAT">배송일자<span class="make">*</span></th> -->
<!-- 								<td> -->
<!-- 									<input type="text" id="CARDAT"  name="CARDAT" class="input input-width" UIFormat="C N" > -->
<!-- 									<input type="button" class="input1 btn_Search" value="검색" onclick="searchList();" style="background-color:#fff;"/> -->
<!-- 								</td> -->
<!-- 							</tr> -->
							<tr>
								<th CL="STD_SKUKEY">제품코드<span class="make"></span></th>
								<td><input type="text" id="SKUKEY" name="SKUKEY" class="input input-width" ></td>
							</tr>
							<tr>
								<th CL="STD_CARDAT">배송일자<span class="make"></span></th>
								<td><input type="text" id="CARDAT" name="CARDAT" class="input input-width" UIFormat="C"></td>
							</tr>
							<tr>
								<th CL="STD_DESC01">품목명<span class="make"></span></th>
								<td><input type="text" id="DESC01" name="DESC01" class="input input-width" readonly="readonly"></td>
							</tr>
							<tr>
								<th CL="STD_LOTA13">유통기한<span class="make"></span></th>
								<td><input type="text" id="LOTA13" name="LOTA13" class="input input-width" readonly="readonly"></td>
							</tr>
							<tr>
								<th CL="STD_QTSIWH">보충수량<span class="make"></span></th>
								<td><input type="text" id="QTSIWH" name="QTSIWH" class="input input-width" readonly="readonly"></td>
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
									<td GH="300" GCol="text,DESC01"></td>  <!--제품명   -->
									<td GH="80" GCol="text,QTSHPO" GF="N 13,1"></td>  <!--지시수량  -->
									<td GH="80" GCol="text,QTJCMP" GF="N 13,1"></td>  <!--완료수량   -->
									<td GH="100" GCol="text,LOTA13" GF="D 14"></td>  <!--유통기한   -->
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--품목    -->
									<!-- <td GH="40" GCol="text,QTALOC" GF="N 13,1"></td>  할당수량    -->
									<!-- <td GH="40" GCol="text,QTSIWH" GF="N 13,1"></td>  보충수량   -->
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
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half -->
				<label id="half" onClick="searchList()">검색</label>
				<label id="half" onClick="window.location.reload()">초기화</label>
			</div>
		</div>
	</div>
	<div id="keyboardBtn">키보드열기</div>
</body>
</html>