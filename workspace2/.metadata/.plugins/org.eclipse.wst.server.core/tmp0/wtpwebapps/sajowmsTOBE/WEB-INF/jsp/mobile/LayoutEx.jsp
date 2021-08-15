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
			module : "MobileInbound",
			command : "MGR03",
			gridMobileType : true
	    });
		
		$("#TASKKY").keyup(function(e){if(e.keyCode == 13)searchList();});

	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("TASKKY",$("#TASKKY").val());

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
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
			param.put("JOBTYP", "121");
			
			
			netUtil.send({
				url : "/mobile/MobileInbound/json/saveMGR03.data",
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
			$("#WARESR1").val(GList[0].get("WARESR1"));
			
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridList"){
			calTotal();
		}
	}

	
	function LayerPop() {
		$("#LayerPop").show()
	}

	function LayerPopClose() {		
		$("#LayerPop").hide();
	}
</script>

</head>
<body>

<!-- LayerPop popup -->
<div class="layer_popup" id="LayerPop" style="position: fixed;left: 0;top: 0;width: 100%;height:100%;background: #f0f0f0;display:none;"><!-- 팝업 위치는 알아서 변경해주세요 -->
	<div class="mobile_order">
		<div class="m_menutitle"><span>레이어 팝업</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th>문서번호<span class="make"></span></th>
								<td><input type="text" id="TASKKY" name="TASKKY" class="input input-width"></td>
							</tr>
							<tr>
								<th>출발지<span class="make"></span></th>
								<td><input type="text" id="WARESR1" name="WARESR1" class="input input-width" readonly/></td>
							</tr>
							<tr>
								<th>입고일자<span class="make"></span></th>
								<td><input type="text" id="DOCDAT"  name="DOCDAT" class="input input-width" UIFormat="C Y" ></td>
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
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!-- 제품코드 -->
									<td GH="200" GCol="text,DESC01" </td>  <!-- 제품명 -->  
									<td GH="40" GCol="text,QTSIWH" GF="N 13,1"></td>  <!-- 재고수량 -->
									<td GH="40" GCol="input,QTYWRK" GF="N 13,1"></td>  <!-- 작업수량 -->
									<td GH="40" GCol="text,QTDUOM" GF="N 13,1"></td>  <!-- 입수 -->
									<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!-- 박스수량 -->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!-- 잔량 -->                   
									<td GH="80" GCol="text,KEY" GF="S 20"></td> <!-- 키 -->
									<td GH="80" GCol="text,STATIT"</td>  <!-- 상태 -->
									<td GH="80" GCol="text,DPUTZO" </td>  <!-- 기본 적치구역 -->
                  					<td GH="80" GCol="text,TRNUID"</td> <!-- 팔렛트ID -->
									<td GH="70" GCol="text,LOTA11" GF="D"></td> <!-- 제조일자 -->
									<td GH="70" GCol="text,LOTA13" GF="D"></td> <!-- 유통기한 -->
									
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
								<div class="workBox">작업<input type="text" id="WORKSUM1" name="WORKSUM1" readonly>/<input type="text" id="WORKSUM2" name="WORKSUM2" readonly></div>
							</li>

							<li>
								<div>To지번<input type="text" id="LOCATG" name="LOCATG"></div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="label-btn">
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half -->
				<label id="long" onClick="LayerPopClose()">닫기</label>
			</div>
		</div>
	</div>
</div>
<!-- searchinput popup -->

</body>
</html>