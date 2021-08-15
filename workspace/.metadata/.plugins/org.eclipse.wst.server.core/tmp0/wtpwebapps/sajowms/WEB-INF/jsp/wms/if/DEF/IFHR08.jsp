<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
//TABLE : TE_WM_EH_SKUMA_RCV
//본부수신 상품마스터
	$(document).ready(function(){
		setTopSize(100);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "Erpif",
			command : "IFHR08",
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
				command : "IFHR08",
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
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_IFDATE"></th>
											<td>
												<input type="text" name="IFDATE" UIFormat="C N" validate="required" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="A.SKUKEY" UIInput="SR" />
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
												<td GH="100 화주"       GCol="text,OWNRKY"></td>
												<td GH="100 수불센터코드"  GCol="text,LOTA01"></td>
												<td GH="100 상품코드"     GCol="text,SKUKEY"></td>
												<td GH="100 상품명"       GCol="text,DESC01"></td>
												<td GH="100 단축상품명"    GCol="text,DESC02"></td>
												<td GH="100 사업부구분"    GCol="text,PTNRTY"></td>
												<td GH="100 대분류"       GCol="text,ASKL01"></td>
												<td GH="100 중분류"       GCol="text,ASKL02"></td>
												<td GH="100 소분류"       GCol="text,ASKL03"></td>
												<td GH="100 세분류"       GCol="text,ASKL04"></td>
												<td GH="100 이미지경로1"    GCol="text,SKUIMG"></td>
												<td GH="100 이미지경로2"    GCol="text,INDIMG"></td>
												<td GH="100 협력사코드"     GCol="text,DPTNKY"></td>
												<td GH="100 온도구분"       GCol="text,TEMPCD"></td>
												<td GH="100 상품바코드"      GCol="text,EANCOD"></td>
												<td GH="100 기본단위"       GCol="text,UOMDIN"></td>
												<td GH="100 발주단위"       GCol="text,UINMIN"></td>
												<td GH="100 출하단위"       GCol="text,UOMDOU"></td>
												<td GH="100 박스당 수량"     GCol="text,BOXQTY"></td>
												<td GH="100 케이스당 수량"    GCol="text,INPQTY"></td>
												<td GH="100 낱개 가로"       GCol="text,WIDTHW"></td>
												<td GH="100 낱개 세로"       GCol="text,LENGTH"></td>
												<td GH="100 낱개 높이"       GCol="text,HEIGHT"></td>
												<td GH="100 낱개 중량"       GCol="text,WEIGHT"></td>
												<td GH="100 박스 가로"       GCol="text,BOXWID"></td>
												<td GH="100 박스 세로"       GCol="text,BOXLEN"></td>
												<td GH="100 박스 높이"       GCol="text,BOXHGT"></td>
												<td GH="100 박스 중량"       GCol="text,BOXWGT"></td>
												<td GH="100 이너팩 가로"      GCol="text,INPWID"></td>
												<td GH="100 이너팩 세로"      GCol="text,INPLEN"></td>
												<td GH="100 이너팩 높이"      GCol="text,INPHGT"></td>
												<td GH="100 이너팩 중량"      GCol="text,INPWGT"></td>
												<td GH="100 팔렛트 가로"      GCol="text,PALWID"></td>
												<td GH="100 팔렛트 세로"      GCol="text,PALLEN"></td>
												<td GH="100 팔렛트 높이"      GCol="text,PALHGT"></td>
												<td GH="100 팔렛트 중량"      GCol="text,PALWGT"></td>
												<td GH="100 유통기한관리여부"  GCol="text,LOTL01"></td>
												<td GH="100 유통기한월수"    GCol="text,DUEMON"></td>
												<td GH="100 유통기한일수"     GCol="text,DUEDAY"></td>
												<td GH="100 입고기준관리여부"  GCol="text,LOTL02"></td>
												<td GH="100 입고기준월수"     GCol="text,RCVMON"></td>
												<td GH="100 입고기준일수"     GCol="text,RCVDAY"></td>
												<td GH="100 임박기준관리여부"  GCol="text,LOTL08"></td>
												<td GH="100 임박기준월수"     GCol="text,IMMMON"></td>
												<td GH="100 임박기준일수"     GCol="text,IMMDAY"></td>
												<td GH="100 원가"           GCol="text,SKCOST"></td>
												<td GH="100 위해상품여부"     GCol="text,HARMYN"></td>
												<td GH="100 상품상태코드"     GCol="text,ITMSTS"></td>
												<td GH="100 상품상태적용일자"   GCol="text,STSDAT"></td>
												<td GH="100 구상품상태코드"    GCol="text,ITMOLD"></td>
												<td GH="100 팩상품 여부"      GCol="text,PACKYN"></td>
												<td GH="100 생성일시"        GCol="text,FST_REG_DTTM"></td>
												<td GH="100 생성자ID"       GCol="text,FST_REG_USER_ID"></td>
												<td GH="100 수정일시"        GCol="text,LAST_MOD_DTTM"></td>
												<td GH="100 수정자ID"       GCol="text,LAST_MOD_USER_ID"></td>
												<td GH="100 처리상태"        GCol="text,EAI_PROC_CD"></td>
												<td GH="100 EAI처리ID"     GCol="text,EAI_PROC_ID"></td>
												<td GH="100 EAI처리일시"    GCol="text,EAI_PROC_DTTM"></td>
												<td GH="100 일련번호"        GCol="text,EAI_PROC_SEQNO"></td>
												<td GH="100 처리메세지"       GCol="text,ERRTXT"></td>
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