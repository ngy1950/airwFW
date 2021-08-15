<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
//TABLE : TE_WM_EH_BZPTN1_RCV
//본부수신 협력사
	$(document).ready(function(){
		setTopSize(100);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "Erpif",
			command : "IFHR03",
			autoCopyRowType : false
		});
		
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
			
			var json = netUtil.sendData({
				module : "Erpif",
				command : "IFHR03",
				sendType : "count",
				param : param
			}); 
			
			if( json && json.data ){
				var cnt = json.data;
				if( cnt > configData.IF_MAX_ROW_COUNT ){ //10000건
					alert(configData.IF_MAX_ROW_COUNT+ " 건을 넘을 수 없습니다. 조회 조건을 더 설정하고 조회하세요."); 
					return;
					
				}else if( cnt == 0 ){
					commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY); //검색한 데이터가 없습니다.
					return;
				}
			}else{
				commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY); //검색한 데이터가 없습니다.
				return;
			}
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("USRADM", "<%=usradm%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("USERID", "<%=userid%>");
			
		}else if( comboAtt == "Common,COMCOMBO" ){
// 			var name = $(paramName).attr("name");
			param.put("CODE","IFSSTS");
		}
		
		return param;
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
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
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_SYSCOD"></th>
											<td>
												<select id="SYSCOD" name="SYSCOD" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_IFDATE"></th>
											<td>
												<input type="text" name="IFDATE" UIFormat="C N" validate="required" />
											</td>
											<th CL="STD_DPTNKY"></th>
											<td>
												<input type="test" name="PTNRKY" UIInput="SR"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_DPTNKYNM"></th>
											<td>
												<input type="text" name="NAME01" UIInput="SR" />
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="100 화주"           GCol="text,OWNRKY"></td>
												<td GH="100 협력사코드"       GCol="text,PTNRKY"></td>
												<td GH="100 협력사명"        GCol="text,NAME01"></td>
												<td GH="100 사업자등록번호"    GCol="text,VATREG"></td>
												<td GH="100 우편번호"        GCol="text,POSTCD"></td>
												<td GH="100 시도명"         GCol="text,ADDR01"></td>
												<td GH="100 시군구명"        GCol="text,ADDR02"></td>
												<td GH="100 읍면동명"        GCol="text,ADDR03"></td>
												<td GH="100 상세주소"        GCol="text,ADDR04"></td>
												<td GH="100 대표자명"        GCol="text,MNGUSR"></td>
												<td GH="100 전화번호"        GCol="text,TELN01"></td>
												<td GH="100 팩스번호"        GCol="text,FAXTL1"></td>
												<td GH="100 업태명"          GCol="text,PTNG01"></td>
												<td GH="100 업종명"          GCol="text,PTNG02"></td>
												<td GH="100 거래상태적용일자"   GCol="text,APPDAT" GF="D"></td>
												<td GH="100 거래상태"        GCol="text,APPCOD"></td>
												<td GH="100 생성일시"        GCol="text,FST_REG_DTTM"></td>
												<td GH="100 생성자ID"        GCol="text,FST_REG_USER_ID"></td>
												<td GH="100 수정일시"        GCol="text,LAST_MOD_DTTM"></td>
												<td GH="100 수정자ID"        GCol="text,LAST_MOD_USER_ID"></td>
												<td GH="100 처리상태"        GCol="text,EAI_PROC_CD"></td>
												<td GH="100 EAI처리ID"     GCol="text,EAI_PROC_ID"></td>
												<td GH="100 EAI처리일시"    GCol="text,EAI_PROC_DTTM"></td>
												<td GH="100 일련번호"        GCol="text,EAI_PROC_SEQNO"></td>
												<td GH="100 처리메세지"      GCol="text,ERRTXT"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>

<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>