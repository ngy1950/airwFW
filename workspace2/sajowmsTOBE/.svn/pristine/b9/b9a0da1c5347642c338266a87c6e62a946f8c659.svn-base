<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="/mobile/include/mobile_head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "MobileInventory",
			command : "MSD00",
			gridMobileType : true
	    });
		
		$("#BARCODE").keyup(function(e){if(e.keyCode == 13)searchList();});

		//총 건수 위치 고정
		$(function(){	
			$('.mobile-data-box').scroll(function() {
			    $(this).find('.tableUtil').css('right', -($(this).scrollLeft()));
			});
		})
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
			
		}
	}
	function saveData(){
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

	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		 if(colName == "QTYWRK"){ //수량변경시연결된 수량 변경
			var boxqty = 0;
			var bxiqty = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
			boxqty = floatingFloor((Number)(qtyreq)/(Number)(bxiqty), 0);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);

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
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);
	}
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>재고이동</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th>바코드<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width" value="" ></td>
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
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--품목    -->
									<td GH="160" GCol="text,DESC01"></td>  <!--제품명   -->
									<td GH="80" GCol="text,LOCAKY"></td>  <!--지번    -->
									<td GH="80" GCol="text,TRNUID"></td>  <!--바코드   -->
									<td GH="40" GCol="text,QTSIWH" GF="N 13,1"></td>  <!--재고    -->
									<td GH="40" GCol="input,QTYWRK" GF="N 13,1"></td>  <!--작업    -->
									<td GH="40" GCol="text,QTDUOM" GF="N 13,1"></td>  <!--입수    -->
									<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스    -->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량    -->
									<td GH="60" GCol="text,LOTA11" GF="D"></td>  <!--제조일자  -->
									<td GH="60" GCol="text,LOTA13" GF="D"></td>  <!--유통기한  -->
									
								</tr>
							</tbody>
						</table>
					</div>
					<div class="tableUtil">
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
				
				<div class="moblie-data-infobox">
					<div class= detail-info>
						<ul>
							<li class="left">
								<div class="workBox">작업<input type="text" id="WORKSUM1" name="WORKSUM1">/<input type="text" id="WORKSUM2" name="WORKSUM2"></div>
							</li>

							<li>
								<div>To지번<input type="text" id="LOCATG" name="LOCATG"></div>
							</li>
							<li>
								<div>To바코드<input type="text" id="TRNUTG" name="TRNUTG"></div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="label-btn">
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half -->
				<label id="half" onClick="window.location.reload()">초기화</label>
				<label id="half" onClick="saveData()">저장</label>
			</div>
		</div>
	</div>

</body>
</html>