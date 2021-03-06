<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL12</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL12",
			pkcol : "MANDT,SEQNO",
			menuId : "DL12"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function searchList(){
		if(validate.check("searchArea")){
			
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}

	 	function saveData(){
	 		if(gridList.validationCheck("gridList", "data")){
	 			var json = gridList.gridSave({
	 		    	id : "gridList",
	 		    	modifyType : 'A'
	 		    });

	 			if(json && json.data){
	 				if(json.data > 0){
	 					searchList();
	 				}
	 			}
	 		}
	 	}

	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if (json.data.RESULT == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}

	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL12");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL12");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
</script>
</head>
<body>
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="IFT_SVBELN"></dt>
							<!--S/O 번호-->
							<dd>
							<input type="text" class="input" name="IF.SVBELN" UIInput="SR" validate="required(STD_SVBELN)"/>
							</dd>
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
											<td GH="40" GCol="rowCheck"></td>
											<td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 10">S/O 번호</td> <!--S/O 번호-->
											<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
											<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
											<td GH="150 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 10">거점명</td> <!--거점명-->
											<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 20">출고요청일</td> <!--출고요청일-->
											<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td> <!--매출처코드-->
											<td GH="150 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 10">매출처명</td> <!--매출처명-->
											<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10">납품처코드</td> <!--납품처코드-->
											<td GH="150 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 10">납품처명</td> <!--납품처명-->
											<td GH="200 IFT_CUADDR" GCol="text,CUADDR" GF="S 10">배송지 주소</td> <!--배송지 주소-->
											<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 10">거래처 담당자명</td> <!--거래처 담당자명-->
											<td GH="150 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 10">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
											<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 10">영업사원명</td> <!--영업사원명-->
											<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 10">영업사원 전화번호</td> <!--영업사원 전화번호-->
											<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 10">비고</td> <!--비고-->
											<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
											<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td> <!--제품명-->
											<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 20,0">납품요청수량</td> <!--납품요청수량-->
											<td GH="80 STD_TASSTATDO" GCol="text,XSTAT" GF="S 20">작업상태</td> <!--작업상태-->
											<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 20">출고문서번호</td> <!--출고문서번호-->
											<td GH="80 STD_WAREKY2" GCol="text,WAREKY2" GF="S 20">출고거점</td> <!--출고거점-->
											<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td> <!--배송차수-->
											<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
											<td GH="80 STD_RECNUM" GCol="text,RECNUM" GF="S 20">재배차 차량번호</td> <!--재배차 차량번호-->
											<td GH="80 STD_RELSTATUS" GCol="text,STATIT" GF="S 20">출고작업상태</td> <!--출고작업상태-->
											<td GH="80 STD_SHCMPL" GCol="text,QTSHPD" GF="N 80,1">출고확정수량</td> <!--출고확정수량-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>