<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<!-- <script language="JavaScript" src="/common/js/head-w.js"> </script> -->
<script type="text/javascript">
//TABLE : TW_WM_WC_BOXID_RCV
//출고 BOX START 실적
	$(document).ready(function(){
		setTopSize(120);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "Erpif",
			command : "IFBR02",
			autoCopyRowType : false
		});

		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml)
	}
    
    function day(day){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		return String(yyyy) + String(mm) + String(dd);
	}
	
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
				param.put("SES_ENV", "<%=usradm%>");
			var json = netUtil.sendData({
				module : "Erpif",
				command : "IFBR02",
				sendType : "count",
				param : param
			}); 
			
			if( json && json.data ){
				var cnt = json.data;
				if( cnt > configData.IF_MAX_ROW_COUNT ){ //10000건
					alert(configData.IF_MAX_ROW_COUNT+ "건을 넘을 수 없습니다. 조회 조건을 더 설정하고 조회하세요."); 
					return;
					
				}else if( cnt == 0 ){
					commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY);
					return;
				}
			}else{
				commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY);
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
			var name = $(paramName).attr("name");
			if(name == "SHPDGR"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}if(name == "SYSCOD"){
				param.put("CODE","IFSSTS");
			}
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
						<div class="section type1" >
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
											<th CL="STD_RQSHPD"></th>
											<td>
												<input type="text" name="RQSHPD" UIFormat="C N" validate="required" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SHPDGR"></th>
											<td>
												<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)">
													<option value="">선택</option>
												</select>
											</td>
											
											<th CL="STD_SVBELN"></th>
											<td>
												<input type="text" name="A.SVBELN" UIInput="SR" />
											</td>
											
											<th CL="STD_SHCARN"></th>
											<td>
												<input type="text" name="A.SHCARN" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="반품구분코드"></th>
											<td>
												<select id="ASNTYP" name="ASNTYP"  UISave="false" ComboCodeView=false style="width:160px" >
													<option value="" selected>전체</option>
													<option value="0">배송</option>
													<option value="1">반품입고</option>
													<option value="2">교환입고</option>
												</select>
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
												<td GH="100 화주"    GCol="text,OWNRKY"></td>
												<td GH="100 주문번호"    GCol="text,SVBELN"></td>
												<td GH="100 주문상세번호"    GCol="text,SHDTLN"></td>
												<td GH="100 주문순서"    GCol="text,SPOSNR"></td>
												<td GH="100 배송ID"    GCol="text,SHCARN"></td>
												<td GH="100 배송일자"    GCol="text,RQSHPD" GF="D"></td>
												<td GH="100 차수"    GCol="text,SHPDGR"></td>
												<td GH="100 수불센터코드"    GCol="text,LOTA01"></td>
												<td GH="100 바코드(BOX25)"    GCol="text,BOXCOD"></td>
												<td GH="100 쇼핑몰"    GCol="text,SHOPID"></td>
												<td GH="100 가상점포"    GCol="text,VTRCOD"></td>
												<td GH="100 출하유형"    GCol="text,SHPMTY"></td>
												<td GH="100 출하유형상세"    GCol="text,SHPTYP"></td>
												<td GH="100 반품구분코드"    GCol="text,ASNTYP"></td>
												<td GH="100 사전예약여부"    GCol="text,PRERES"></td>
												<td GH="100 배송메세지"    GCol="text,SHPTXT"></td>
												<td GH="100 고객명(주문자)"    GCol="text,CRYPTO_OUSRNM"></td>
												<td GH="100 고객명(수취인)"    GCol="text,CRYPTO_SUSRNM"></td>
												
												<td GH="100 사은품구분"    GCol="text,GIFTTP"></td>
												<td GH="100 상품구분"    GCol="text,LOTA06"></td>
												<td GH="100 상품번호"    GCol="text,SKUKEY"></td>
												<td GH="100 상품명"    GCol="text,DESC01"></td>
												<td GH="100 주문수량"    GCol="text,ORDQTY" GF="N"></td>
												<td GH="100 판매단위"    GCol="text,OUOMKY"></td>
												<td GH="100 주문일자"    GCol="text,ORDDAT" GF="D"></td>
												<td GH="100 주문시간"    GCol="text,ORDTIM" GF="T"></td>
												<td GH="100 판매가"    GCol="text,OUCOST" GF="N"></td>
												<td GH="100 주문번호(원주문)"    GCol="text,ORGNKY"></td>
												<td GH="100 주문상세번호(원주문 )"    GCol="text,ORGNSQ"></td>
												<td GH="100 주문순번(원주문)"    GCol="text,ORGNIT"></td>
												<td GH="100 배송ID(원주문)"    GCol="text,ORGCAR"></td>
												<td GH="100 클레임사유"    GCol="text,RTNCOD"></td>
												<td GH="100 클레임명"    GCol="text,RTNTXT"></td>
												<td GH="100 생성일시"    GCol="text,FST_REG_DTTM" ></td>
												<td GH="100 생성자ID"    GCol="text,FST_REG_USER_ID"></td>
												<td GH="100 수정일시"    GCol="text,LAST_MOD_DTTM" ></td>
												<td GH="100 수정자ID"    GCol="text,LAST_MOD_USER_ID"></td>
												<td GH="100 처리상태"    GCol="text,EAI_TRNS_CD"></td>
												<td GH="100 EAI전송ID"    GCol="text,EAI_TRNS_ID"></td>
												<td GH="100 EAI전송일시"    GCol="text,EAI_TRNS_DTTM" ></td>
												<td GH="100 처리메세지"    GCol="text,ERRTXT"></td>
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
									<button type="button" GBtn="total"></button>
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