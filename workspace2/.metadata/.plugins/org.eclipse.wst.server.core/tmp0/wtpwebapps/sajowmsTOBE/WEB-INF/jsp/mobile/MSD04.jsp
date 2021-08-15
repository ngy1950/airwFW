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
			command : "MSD04",
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
			// 검색조건 선택후 블러처리
			$("#BARCODE").focus();
			$("#BARCODE").select();

		}
	}	


</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>바코드별 기준정보</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_BARCOD">바코드<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width" validate="required(STD_BARCOD)"/></td>
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
									<td GH="40 STD_QTDUOM" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="100 STD_PLTBOX" GCol="text,PLTBOX" GF="N 13,1"></td>  <!-- PLT별BOX적재수량 -->
									<td GH="100 STD_QTYSTD" GCol="text,QTYSTD" GF="N 13,1"></td>  <!-- 팔렛트 적재수량 -->
									<td GH="160 STD_EANCOD" GCol="text,EANCOD" ></td>  <!-- BARCODE(88코드) -->
									<td GH="140 STD_GTINCD" GCol="text,GTINCD" </td>  <!-- BOXBARCODE -->  
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