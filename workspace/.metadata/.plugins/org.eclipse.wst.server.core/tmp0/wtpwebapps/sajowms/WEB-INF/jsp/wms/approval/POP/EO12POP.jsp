<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>폐기취소결재</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	window.resizeTo('980','740');
	var linkData = new DataMap();
	
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsApproval",
			command : "APPOPH",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsApproval",
			command : "APPOPI",
			autoCopyRowType : false,
			headGrid : "gridHeadList"
		});
		
		linkData = page.getLinkPopData();
		searchList(page.getLinkPopData());
		
	});

	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "SaveApproval"){ //승인
			saveData(btnName);
			
		}else if(btnName == "SaveRejected"){ //부결
			saveData(btnName);
		}
	}
	
	//헤더 조회
	function searchList(data){
		if( linkData.get("PROGID") == "AP11" ){
			//버튼권한 체크
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "BTNCHECK",
				sendType : "map",
				param : data
			});
		
			if( json && json.data ){
				if( json.data.VALID == 'N' ){
					uiList.setActive("SaveApproval", false);
					uiList.setActive("SaveRejected", false);
					
				}else if( json.data.VALID == 'Y' ){
					uiList.setActive("SaveApproval", true);
					uiList.setActive("SaveRejected", true);
					
				}
			}
			
		}else if( linkData.get("PROGID") == "AP12" ){
			uiList.setActive("SaveApproval", false);
			uiList.setActive("SaveRejected", false);
			$("input[name=requestText]").attr("readonly", true);
		}
		
		
		gridList.gridList({
			id : "gridHeadList",
			param : data
		}); 
		
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			command : "APPOPI",
			param : rowData
		});
		
	}
	
	// 승인 및 부결 저장
	// ap11 화면에서만 버튼 활성화
	function saveData(btnName){
		var text = $("input[name=requestText]").val();
// 		if( $.trim(text) == "" || text == " "){
// 			commonUtil.msgBox("AP_M0012"); //결재의견을 작성해주세요.
// 			return false;
// 		}
		
		var head = gridList.getSelectData("gridHeadList", "A");
		if( head.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return false;
		}
		
		var param = new DataMap();
		param.put("head", head);
		param.put("btnName", btnName);
		param.put("APRTXT", text);
		
		netUtil.send({
			url : "/wms/approval/json/saveAPPOP.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if( json.data > 0 ){
				commonUtil.msgBox("MASTER_M0815", json.data); //{0}건이 저장되었습니다.
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				page.linkPopClose();
				
			}else if( json.data <= 0 ){
				commonUtil.msgBox("VALID_M0002"); //저장이 실패하였습니다.
			}
		}
		
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="SaveApproval SAVE BTN_APPROVAL"></button>
		<button CB="SaveRejected DELETE BTN_REJECTED"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
	
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_APLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							
							<div class="reflect">
								결제의견
								<input type="text" name="requestText" UIFormat="S 30" style="width: 395px;" />
							</div>
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="text,NAME01"></td>
												<td GH="100 STD_APSTUS"    GCol="text,CDESC1"></td>
												<td GH="100 STD_CLNDAT"    GCol="text,DOCDAT"  GF="D"></td>
												<td GH="100 STD_SADJKY,3"  GCol="text,APRKEY"></td>
												<td GH="100 STD_REQDAT"    GCol="text,REQDAT"  GF="D"></td>
												<td GH="100 STD_REQTIM"    GCol="text,REQTIM"  GF="T"></td>
												<td GH="100 STD_REQUSR"    GCol="text,REQUSR"></td>
												<td GH="100 STD_RUSRNM"    GCol="text,RUSRNM"></td>
												<td GH="100 STD_APRTXT"    GCol="text,APRTXT"></td>
												<td GH="100 STD_APRDAT"    GCol="text,APRDAT"  GF="D"></td>
												<td GH="100 STD_APRTIM"    GCol="text,APRTIM"  GF="T"></td>
												<td GH="100 STD_APRUSR"    GCol="text,APRUSR"></td>
												<td GH="100 STD_AUSRNM"    GCol="text,AUSRNM"></td>
												
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="sortReset"></button> -->
<!-- 									<button type="button" GBtn="layout"></button> -->
<!-- 									<button type="button" GBtn="excel"></button> -->
<!-- 									<button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DETAIL"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="120 STD_SKUKEY"    GCol="text,SKUKEY"></td>
												<td GH="170 STD_DESC01"    GCol="text,DESC01"></td>
												<td GH="100 STD_PRCQTY"    GCol="text,PRCQTY"  GF="N"></td>
												<td GH="100 STD_UOMKEY"    GCol="text,PRCUOM"></td>
												<td GH="100 STD_TOTALQ"    GCol="text,QTADJU"  GF="N"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="sortReset"></button> -->
<!-- 									<button type="button" GBtn="layout"></button> -->
<!-- 									<button type="button" GBtn="excel"></button> -->
<!-- 									<button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>