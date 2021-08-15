<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var searchCnt = 0; 
	var dblIdx = -1;
	var sFlag = true;
	
	function reportPrint(){
		var prtCnt =  $('input[name=PRTCNT]').val();	// 인쇄수량
		var prtQty =  $('input[name=PRTQTY]').val();	// 입고총수량
		var skukey =  $('input[name=SKUKEY]').val();	// 품번
		var desc01 =  $('input[name=DESC01]').val();	// 품명
		var desc02 =  $('input[name=DESC02]').val();	// 모델
		var skug05 =  $('input[name=SKUG05]').val();	// 품명
	
		

		
		var json = saveData();
		
		if(json && json.data){
			var wherestr = " AND REFDKY = '" +json.data+ "'";
			//var wherestr = " AND REFDKY BETWEEN '" +json.data+ "' AND '" +json.data+ "'";
			
			/* if( $("input[name='BARSEC']:checked").val() == 'INDUPK'){ */
				WriteEZgenElement("/ezgen/barcodel.ezg", wherestr, "", "<%=langky%>" );
			<%-- } else {
				WriteEZgenElement("/ezgen/barcodem.ezg", wherestr, "", "<%=langky%>" );
			} --%>
		}
		
	}
	
	
	
	function saveData(){
		
		var wareky = "<%=wareky%>";
		var prtCnt =  $('input[name=PRTCNT]').val();	// 인쇄수량
		var prtQty =  $('input[name=PRTQTY]').val();	// 입고총수량
		var skukey =  $('input[name=SKUKEY]').val();	// 품번코드
		var desc01 =  $('input[name=DESC01]').val();	// 품번명1
		var desc02 =  $('input[name=DESC02]').val();	// 품번명2
		var qtduom =  $('input[name=QTDUOM]').val();	// 입수
		var qtdbox =  $('input[name=QTDBOX]').val();	// 박스
		var qtdrem =  $('input[name=QTDREM]').val();	// 잔량
		var qtdprt =  $('input[name=QTDPRT]').val();	// 총수량

		/* if( prtCnt == '' ){
			// 인쇄수량은 필수입력입니다.
			commonUtil.msgBox("VALID_M0552");
			return;
		}else if(prtQty == ''){
			// 발행수량은 0 보다 커야합니다.
			commonUtil.msgBox("VALID_M0553");
			return;
		} */
		if( skukey == '' ) {
			commonUtil.msgBox("VALID_M0551");
			return;
		} 
		if( skukey != '' ){
			var param = new DataMap();
			param.put("SKUKEY",skukey);
			var json = netUtil.sendData({
				module : "WmsLabel",
				command : "SKUKEYval",
				sendType : "map",
				param : param
			});
			if (json.data["CNT"] < 1) {
				commonUtil.msgBox("VALID_M0554");
				return;
			}
		}
		
		var param = new DataMap();
		param.put("WAREKY", wareky);
		param.put("PRTCNT", prtCnt);
		param.put("SKUKEY", skukey);
		param.put("DESC01", desc01);
		param.put("DESC02", desc02);
		param.put("QTDUOM", qtduom);
		param.put("QTDBOX", qtdbox);
		param.put("QTDREM", qtdrem);
		param.put("QTDPRT", qtdprt);
		
		var json = netUtil.sendData({
			url : "/wms/labal/json/saveLB01.data",
			param : param
		});
		
		return json;
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHWAHMA"){
			var param = new DataMap();
			param.put("COMPKY", "<%=compky%>");
			return param;
	    }else if(searchCode == "SHSKUMABAR"){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Print"){
			reportPrint();
		}
	}
	
	function getDesc01(){
		var skukey = $('input[name=SKUKEY]').val();	// 품번
		var param = new DataMap();
		var desc01 = "";
		var desc02 = "";
		var desc04 = "";
		var skug05 = "";
		var uomkey = "";
		
		param.put("OWNRKY","<%=ownrky%>");
		param.put("SKUKEY",skukey);
		
		var json = netUtil.sendData({
			module : "WmsLabel",
			command : "DESC01VALUE",
			sendType : "map",
			param : param
		});
		desc01 = json.data["DESC01"]; 
		desc02 = json.data["DESC02"]; 
		desc04 = json.data["DESC04"]; 
		skug05 = json.data["SKUG05"];
		uomkey = json.data["UOMKEY"]; 
		
		$('input[name=DESC01]').val(desc01);
		$('input[name=DESC02]').val(desc02);
		$('input[name=DESC04]').val(desc04);
		$('input[name=SKUG05]').val(skug05);
		$('input[name=UOMKEY]').val(uomkey);
		
		$('input[name=QTDUOM]').val(1);
		$('input[name=QTDBOX]').val(1);
		$('input[name=QTDREM]').val(0);
		$('input[name=QTDPRT]').val(1);
	}
	
	function chanagedQty(type){
		var qtipsu = (Number)($('input[name=QTDUOM]').val());
		var qtdbox = (Number)($('input[name=QTDBOX]').val());
		var qtdrem = (Number)($('input[name=QTDREM]').val());
		var qtdprt = (Number)($('input[name=QTDPRT]').val());
		
		if(type == "1" || type == "4"){
			qtybox = Math.floor(qtdprt / qtipsu);
			qtyrem = qtdprt % qtipsu;
			
			$('input[name=QTDBOX]').val(qtybox);
			$('input[name=QTDREM]').val(qtyrem);
		}else if(type == "2" || type == "3"){
			qtdprt = (qtipsu * qtdbox) + qtdrem;
			
			$('input[name=QTDPRT]').val(qtdprt);
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Print PRINT BTN_PRINT">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer" id="contentContainer">
			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_BARPRT'>바코드생성/인쇄</span></a></li>
					</ul>
										
					<div id="tabs1-1">
						<div class="section type1" style="overflow-y:scroll;">
							<!-- <div class="searchInBox">
								<h2 class="tit" CL="STD_PRTINF">인쇄정보</h2>
								<table class="table type1">
									<colgroup>
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_BARSEC">Barcode구분</th>
											<td>
												<input type="radio" name="BARSEC" value="INDUPK" checked />Barcode 130*90 
												<input type="radio" name="BARSEC" value="INDUPA" />Barcode 100*60
											</td>
										</tr>
										
										<tr>
											<th CL="STD_PRTCNT">인쇄수량</th>
											<td>
												<input type="text" name="PRTCNT" validate="required,M0434"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_PRTQTY">입고총수량</th>
											<td>
												<input type="text" name="PRTQTY" />
											</td>
										</tr>
									</tbody>
								</table>
							</div> -->
							
							<div class="searchInBox">
								<h2 class="tit" CL="STD_BARINF">바코드정보</h2>
								<table class="table type1">
									<colgroup>
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY">거점</th>
											<td>
												<input type="text" name="WAREKY" validate="required,M0434" readonly="readonly" value="<%=wareky%>"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUKEY">품번</th>
											<td>
												<input type="text" name="SKUKEY" UIInput="S,SHSKUMABAR" onchange="getDesc01()" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DESC01">품명</th>
											<td>
												<input type="text" name="DESC01" size="70" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DESC02">모델</th>
											<td>
												<input type="text" name="DESC02" size="70" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_DESC04">제조사</th>
											<td>
												<input type="text" name="DESC04" size="70" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SKUG05">규격</th>
											<td>
												<input type="text" name="SKUG05" size="70" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_IPSUUOM" >입수/단위</th>
											<td>
												<input type="text" name="QTDUOM" size="10" UIFormat="N 20,3" UIonchange="chanagedQty('1')" />&nbsp;<input type="text" name="UOMKEY" size="5" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<th CL="STD_BOX">박스</th>
											<td>
												<input type="text" name="QTDBOX" size="10" UIFormat="N 17" onchange="chanagedQty('2')" />
											</td>
										</tr>
										<tr>
											<th CL="STD_REMQTY">잔량</th>
											<td>
												<input type="text" name="QTDREM" size="10" UIFormat="N 20,3" onchange="chanagedQty('3')" />
											</td>
										</tr>
										<tr>
											<th CL="STD_TOTQTY">총수량</th>
											<td>
												<input type="text" name="QTDPRT" size="10" UIFormat="N 20,3" onchange="chanagedQty('4')" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
					
					</div>
				</div>				
			</div>
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>