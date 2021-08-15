<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ManualAllocate</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var popupchk = false;
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "OutBoundReport",
			command : "ManualAllocate",
		    menuId : "ManualAllocate"
		});
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		$("#OWNRKY").val(data.map.OWNRKY);	// data bind 가 안됨...
		$("#WAREKY").val(data.map.WAREKY);
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if(btnName == "Cancel"){
			this.close();
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			var rtnData = new DataMap();
			rtnData.put("TYPE", "MANALO");
			rtnData.put("TASKKY", json);
			page.linkPopClose(rtnData);
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
		}
	}
	

	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		var item = gridList.getGridData("gridList");
		var param = inputList.setRangeDataParam("searchArea");
		param.put("item",item);

		if (item.length == 0) {
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		//item 저장불가 조건 체크
		if(Number($("#QTALOC").val()) > Number($("#QTSHPO").val())){
			commonUtil.msgBox("지시 수량보다 할당 수량이 많습니다.");
			return;
		}
		
		netUtil.send({
			url : "/outbound/json/saveDL30POP.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	

	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(colName == "QTSALO"){ //할당수량

			var item = gridList.getGridData("gridList");
			var alocCnt = 0;
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				alocCnt+=Number(itemMap.QTSALO);
			}
			
			$("#QTALOC").val(alocCnt);
			$("#QTUALO").val(Number($("#QTSHPO").val())-alocCnt);
		}
	}
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Save SAVE BTN_REFLECT" /> 
					<input type="button" CB="Cancel CANCEL BTN_CANCEL" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap" style="height: auto"> 
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<input type="text" id="OWNRKY" name="OWNRKY" class="input" ComboCodeView="true" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="text" id="WAREKY" name="WAREKY" class="input" ComboCodeView="true" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt>
						<dd>
							<input type="text" class="input" id="SHPOKY" name="SHPOKY" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOIT"></dt>
						<dd>
							<input type="text" class="input" id="SHPOIT" name="SHPOIT" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" id="SKUKEY" name="SKUKEY" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input type="text" class="input" id="DESC01" name="DESC01" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_QTSHPO"></dt>
						<dd>
							<input type="text" class="input" id="QTSHPO" name="QTSHPO" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_QTALOC"></dt>
						<dd>
							<input type="text" class="input" id="QTALOC" name="QTALOC" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_QTUALO"></dt>
						<dd>
							<input type="text" class="input" id="QTUALO" name="QTUALO" readonly/>
						</dd>
					</dl>
					
	
<!-- 					<dl>
						&nbsp;&nbsp;지시수량 / 할당수량 / 미할당수량 :
						<input type="text" class="input" id="QTSHPO" name="DESC01"  readonly/>
					</dl> -->
				</div>
				<div class="btn_tab on">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><label CL="STD_LIST"></label></a></li>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="70 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_QTSIWH" GCol="text,QTSIWH" GF="N 17,0">재고수량</td>	<!--재고수량-->
			    						<td GH="80 STD_QTSALO" GCol="input,QTSALO" GF="N 17,0">할당수량</td>	<!--할당수량-->
			    						<td GH="80 STD_MEASKY" GCol="text,MEASKY" GF="S 20">단위구성</td>	<!--단위구성-->
			    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="80 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="S 20">유통잔여(%)</td>	<!--유통잔여(%)-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
				
			</div>
	   </div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>