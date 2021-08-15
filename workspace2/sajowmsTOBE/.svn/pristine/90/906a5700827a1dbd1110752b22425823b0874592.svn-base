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
			module : "MobileOutbound",
			command : "MDL11",
			gridMobileType : true
	    });

		$("#SSORNU").focus();

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
			
			$("#SSORNU").val("");
			$("#LOCATG").val("");
			$("#TRNUTG").val("");
			$("#BARCODE").focus();
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
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

		    var param = new DataMap();

			var gridDataBox = gridList.getGridBox("gridList");
			var data = gridDataBox.getDataAll();
			param.put("data", data);
	        
			netUtil.send({  
				url : "/mobile/mobileOutbound/json/saveMDL11.data", 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	//합계 계산
	function calTotal(){
		var worksum1 = 0;
		var worksum2 = 0;
		var list = gridList.getGridData("gridList");
		
		//선택 합계
		for(var i=0; i<list.length; i++){
			var gridMap = list[i].map;
			worksum1 = worksum1+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "QTTAOR"));
			worksum2 = worksum2+(Number)(gridList.getColData("gridList", list[i].get("GRowNum"), "QTCOMP"));
		}
		
		$("#WORKSUM1").val(worksum1);
		$("#WORKSUM2").val(worksum2);

		if($("#WORKSUM1").val() == $("#WORKSUM2").val()){
			//완료수량이 모두 찍히면  피킹완료 프로시저를 직동한다 
			saveData();
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();   
        //로케이션
        if(searchCode == "SHLOCMA" && $inputObj.name == "LOCATG"){
            param.put("CMCDKY","WAREKY");
         	param.put("WAREKY", $("#WAREKY").val());
        	param.put("OWNRKY", $("#OWNRKY").val());
        }
        
    	return param;
    }
	
	function scanSku(){
		//완료수량이 모두 찍히면  피킹완료 프로시저를 직동한다 gridListEventColValueChange에서
		var gridId = 'gridList';
		var barcode = $("#BARCODE").val();


		var gridDataBox = gridList.getGridBox(gridId);
		var gridListData = gridDataBox.getDataAll();
	      
		for(var i=0; i<gridListData.length; i++){
			var rowNum = gridListData[i].get("GRowNum");
			if(barcode == gridList.getColData(gridId, rowNum, "EANCOD") || barcode == gridList.getColData(gridId, rowNum, "GTINCD")){
				var qtcomp = Number(gridList.getColData(gridId, rowNum, "QTCOMP"));
				var qttaor = Number(gridList.getColData(gridId, rowNum, "QTTAOR"));
				qtcomp+=1;

				gridListEventColValueChange(gridId, rowNum, "QTCOMP", qtcomp);
			}
		}
		
		
	}

	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(colName == "QTCOMP"){ //완료수량 변경시

			var qttaor = Number(gridList.getColData(gridId, rowNum, "QTTAOR"));
			if(colValue > qttaor){
				commonUtil.msgBox("지시수량 보다 완료수량이 많을 수 없습니다."); 
				gridList.setColValue(gridId, rowNum, "QTCOMP", qttaor);

				calTotal();
				return;
			}else{
				gridList.setColValue(gridId, rowNum, "QTCOMP", colValue);
			}
			
			calTotal();
			
		}
	}
</script>

</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_order">
		<%@ include file="/mobile/include/mtop.jsp" %>
		<div class="m_menutitle"><span>피킹완료</span></div>
		<div class="mobile-data-top">
			<div class="mobile-data-box">
				<div class="content_layout_wrap" id="searchArea">
					<table>
						<tbody>
							<tr>
								<th CL="STD_ASNDKY">ASN입고번호<span class="make">*</span></th>
								<td><input type="text" id="ASNDKY" name="ASNDKY" class="input input-width"></td>
<!-- 								<td><input type="text" id="TASKKY" name="TASKKY" class="input input-width" validate="required(STD_TASNUM)"></td> -->
							</tr>
							<tr>
								<th CL="STD_GTINCD">거래처명<span class="make">*</span></th>
								<td><input type="text" id="BARCODE" name="BARCODE" class="input input-width"></td>
<!-- 								<td><input type="text" id="TASKKY" name="TASKKY" class="input input-width" validate="required(STD_TASNUM)"></td> -->
							</tr>
							<tr>
								<th CL="STD_WRKSUM">선택/총작업<span class="make"></span></th>
								<td>
									<input type="text" id="WORKSUM1" name="WORKSUM1" class="input1 input-width" readonly/>
									<input type="text" id="WORKSUM2" name="WORKSUM2" class="input1 input-width" readonly/>
								</td>
							</tr>
							<tr>
								<th CL="STD_TOLOC">From지번<span class="make"></span></th>
								<td>
									<input type="text" id="LOCASR" name="LOCASR" class="input input-width" readonly/>
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
									<td GH="160" GCol="text,DESC01"></td>  <!--제품명 -->
									<td GH="40" GCol="text,PLTQTY" GF="N 13,1" ></td>  <!--팔렛수량-->
									<td GH="40" GCol="text,BOXQTY" GF="N 13,1"></td>  <!--박스수량-->
									<td GH="40" GCol="text,REMQTY" GF="N 13,1"></td>  <!--잔량-->
									<td GH="60" GCol="text,LOTA11" GF="C"></td>  <!--제조일자-->
									<td GH="60" GCol="text,LOTA13" GF="C"></td>  <!--유통기한-->
									<td GH="80" GCol="text,SKUKEY" GF="S 20"></td>  <!--제품코드 -->
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
				<!-- 버튼 1개 시에는 id="long" 2개일떄는 half 3개일때  threeP-->
				<label id="long" onClick="window.location.reload()">초기화</label>
				<!-- <label id="half" onClick="saveData()">저장</label> -->
			</div>
		</div>
	</div>

</body>
</html>