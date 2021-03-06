<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LB01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var popupchk = false;
var data;
	$(document).ready(function(){	
		$("#POPOWNRKY").val("<%=ownrky%>");
		searchwareky("<%=ownrky%>");
		$("#POPWAREKY").val("<%=wareky%>");
	
		$("#searchArea [name=SKUKEY]").on("change",function(){
			skuchange($(this).val());
		});
		
		$("#searchArea [name=RCVTQTY],[name=QTDUOM],[name=QTDBOX],[name=QTDREM]").on("change",function(){
			qtychange();
		});
		
		$("#searchArea [name=QTDPRT]").on("change",function(){
			qtdprt();
		});
		
		$("#searchArea [name=LOTA03]").on("change",function(){
			changelota03($(this).val());
		});
		
		$("#searchArea [name=LOTA13]").on("change",function(){
			changelota13();
		});
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		if(window.opener && window.opener.page && page && page.getLinkPopData()){
			popupchk = true;	
			data = page.getLinkPopData();
			searchwareky(data.get("OWNRKY"));
			
			postMain();
		}else{
			searchwareky($('#POPOWNRKY').val());	
		}

		if($("#POPWAREKY").val().trim() == ""){
			searchwareky($("#POPOWNRKY").val());
		}
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});
	
	//콤보박스안에 필요한 값만 부르기
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#POPWAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#POPWAREKY").append(optionHtml);
		
		if(popupchk){
			$('#POPWAREKY').val(data.get("WAREKY"));	
		}
		
	}
	
	function postMain(){
		popupchk = true;
		$('#POPOWNRKY').val(data.get("OWNRKY"));

		$('#SKUKEY').val(data.get("SKUKEY"));
		skuchange(data.get("SKUKEY"));
		
		$('#RCVTQTY').val(data.get("QTYRCV")); //RCVTQTY 입고총수량, QTYRCV 입고수량
		
		var lota11 = data.get("LOTA11");
		var lota13 = data.get("LOTA13"); 
		lota11 = lota11.substring(0,4) + '.' + lota11.substring(4,6) + '.' + lota11.substring(6,8);
		lota13 = lota13.substring(0,4) + '.' + lota13.substring(4,6) + '.' + lota13.substring(6,8);
		$('#LOTA13').val(lota13);
		$('#LOTA11').val(lota11);
		$('#LOTA03').val(data.get("LOTA03"));
		$('#SEBELN').val(data.get("SEBELN"));
		$('#SEBELP').val(data.get("SEBELP"));
		
		//잔량 추가 2021.05.17
		$('#QTDREM').val(data.get("QTDREM"));
		
		qtychange();
		qtdprt(); //총수량
		
	}
	
	function changelota13(){
		var lota13 =  $('#LOTA13').val().replace(/-/g,""); //유통기한
		var outdmt =  Number($('#OUTDMT').val()); //유통기한 id
		var lota11 = dateParser(lota13, 'S', 0, 0, -(outdmt)); //제조일자
		
		lota11 = lota11.substring(0,4) + '.' + lota11.substring(4,6) + '.' + lota11.substring(6,8)
		$('#LOTA11').val(lota11);
	}
	
	function changelota03(prntky){
		var param = new DataMap();
		param.put("PTNRKY",prntky);
		param.put("OWNRKY","<%=ownrky%>");
	
		var json = netUtil.sendData({
			module : "LabelPrint",
			command : "LOTA03INFO",
			sendType : "map",
			param : param
		});
		
		if(json.data == null){
			//잘못된 업체코드입니다.
			commonUtil.msgBox("VALID_M0555"); 
			return;
		}
	}
	
	//총수량
	function qtdprt(){
		var qtduom =  Number($('#QTDUOM').val().replace(/,/g,""));
		var qtdprt =  Number($('#QTDPRT').val().replace(/,/g,""));
		var qtdbox = parseInt(qtdprt / qtduom); //박스 = 총수량 /입수
		var qtdrem = qtdprt % qtduom; // 잔량  = 총수량 % 입수 
		
		$('#QTDBOX').val(qtdbox);
		$('#QTDREM').val(qtdrem);
	}
	
	function qtychange(){
		var qtrcal = Number($('#RCVTQTY').val().replace(/,/g,"")); //입고총수량
		var qtduom =  Number($('#QTDUOM').val().replace(/,/g,"")); //입수
		var qtdbox =  Number($('#QTDBOX').val().replace(/,/g,"")); //박스
		var qtdrem =  Number($('#QTDREM').val().replace(/,/g,"")); //잔량
		
		var qtdprt = 0;
		//총수량  = 입수 * 박스 + 잔량
		qtdprt = qtduom * qtdbox + qtdrem;
		
		$('#QTDPRT').val(qtdprt);
		
		var one = 0;
		if(qtrcal % qtdprt > 0){
	    	one = 1;
		}
		$('#PRINTCNT').val( parseInt((qtrcal / qtdprt)) + one); //인쇄수량 (입고총수량 /총수량) + one
	}
	
	function skuchange(skukey){
		var param = new DataMap();
			param.put("SKUKEY",skukey);
			param.put("WAREKY",$('#POPWAREKY').val());
			param.put("OWNRKY",$('#POPOWNRKY').val());
		
		var json = netUtil.sendData({
			module : "LabelPrint",
			command : "LB01",
			sendType : "map",
			param : param
		});
		
		if(json.data == null){
			$('#SKUKEY').val("");
			$('#DESC01').val("");
			$('#DESC02').val("");
			$('#QTDUOM').val("");
			$('#QTDBOX').val("");
			$('#QTDREM').val("");
			$('#QTDPRT').val("");
			$('#OUTDMT').val("");
			return;
			
		}else{
			$('#SKUKEY').val("");
			$('#DESC01').val("");
			$('#DESC02').val("");
			$('#QTDUOM').val("");
			$('#QTDBOX').val("");
			$('#QTDREM').val("");
			$('#QTDPRT').val("");
			$('#OUTDMT').val("");
			
			var printcnt = $('#PRINTCNT').val();
			$('#SKUKEY').val(json.data["SKUKEY"]);
			$('#QTDUOM').val(json.data["QTDUOM"]);
			$('#QTDBOX').val(json.data["QTDBOX"]);
			$('#QTDREM').val(json.data["QTDREM"]);
			$('#DESC01').val(json.data["DESC01"]);
			$('#DESC02').val(json.data["DESC02"]);
			$('#OUTDMT').val(json.data["OUTDMT"]);
			$('#QTDPRT').val(json.data["QTDPRT"]);
			
			var qtrcal = Number($('#RCVTQTY').val().replace(/,/g,"")); 
			var qtduom = Number($('#QTDUOM').val());
			var qtdbox = Number($('#QTDBOX').val());
			var qtdrem = Number($('#QTDREM').val());
			
			var qtdprt = 0;
			//총수량  = 입수 * 박스 + 잔량
			qtdprt = qtduom * qtdbox + qtdrem;
			
 			$('#QTDPRT').val(qtdprt);
			
			var one = 0;
			if(qtrcal % qtdprt > 0){
		    	one = 1;
			}
			
			var prtcnt = parseInt((qtrcal / qtdprt)) + one;
			
			if(prtcnt == 0){
				prtcnt = 1;
			}
			
			$('#PRINTCNT').val(prtcnt);
		}
	}

	function commonBtnClick(btnName){
		if(btnName.indexOf("Print") != -1){
			print(btnName.replace("print"),"");

 		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "LB01");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "LB01");
		}
	}	
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	function print(check){
		if(!validate.check("searchArea")){
			return false;
		}
		var param = inputList.setRangeDataParam("searchArea");
		
		var json = netUtil.sendData({
			url : "/labelPrint/json/printLB01.data",
			param : param,
		});
		
		//* 인쇄수량은 필수입니다
		if($('#PRINTCNT').val() == "" || $('#PRINTCNT').val() == 0){
			commonUtil.msgBox("VALID_M0552");
			return;
		}
		//* 유통기한은 필수 입력입니다.
		if($('#LOTA13').val() == ""){
			commonUtil.msgBox("VALID_M0324");
			return;
		}
		
		if ( json && json.data ){
			var ownrky = $('#POPOWNRKY').val();
			
			var where = " AND REFDKY = '" + json.data["REFDKY"] + "'";
			
			var url = "/ezgen/" 
			if(ownrky == '2200'){
				url += "drbarcodel3.ezg";
			}else if(ownrky == '2100' || ownrky == '2500'){
				url += "barcodel.ezg";
			}else{
				url += "barcodel2.ezg";
			}
			
			var width = 1100;
			var height = 620;
			
			var langKy = "KO";
			var map = new DataMap();
			WriteEZgenElement(url , where , "" , langKy, map , width , height );
		}
		
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	  	//제품코드
	    if(searchCode == "SHSKUMABAR"){
	    	param.put("WAREKY","<%=wareky %>");
	    	param.put("OWNRKY","<%=ownrky %>");     
		} return param;
	}
	
	//서치헬프 리턴값 셋팅
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		
		if( searchCode == 'SHSKUMABAR'){
			skuchange(rowData.get("SKUKEY"));
		}if(searchCode == 'SHBZPTN_LB'){
			$('#LOTA03').val(rowData.get("PTNRKY")); 
		}
	}

	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 화주선택 후 거점으로 자동선택
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner" style="padding: 5px 30px 55px;">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Print PRINT_OUT BTN_PRINT" />
				</div>
			</div>
			<div class="search_inner"> <!-- LB01 팔레트 바코드 라벨 --> 
				<div class="search_wrap" style="height: auto;"> 
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="POPOWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="POPWAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PRTCNT"></dt> <!-- 인쇄수량 -->
						<dd>
							<input type="text" class="number" name="PRINTCNT" id="PRINTCNT" UIFormat="N" value="1" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PRTQTY"></dt> <!-- 입고총수량 -->
						<dd>
							<input type="text" class="input" id="RCVTQTY" name="RCVTQTY" UIFormat="N" value="0"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="SKUKEY" id="SKUKEY" UIInput="S,SHSKUMABAR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="DESC01" id="DESC01" disabled="disabled"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC02"></dt> <!-- 규격 -->
						<dd>
							<input type="text" class="input" name="DESC02" id="DESC02" disabled="disabled"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DPTNKY"></dt> <!-- 업체코드 -->
						<dd>
							<input type="text" class="input" name="LOTA03" id="LOTA03" UIInput="S,SHBZPTN_LB"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELN"></dt> <!-- 구매오더 NO -->
						<dd>
							<input type="text" class="input" name="SEBELN" id="SEBELN"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SEBELP"></dt> <!-- 구매오더 Item -->
						<dd>
							<input type="text" class="input" name="SEBELP" id="SEBELP"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA13"></dt> <!-- 유통기한 -->
						<dd>
							<input type="text" class="input" name="LOTA13" id="LOTA13" UIFormat="C"/>
							<input type="hidden" name="OUTDMT" id="OUTDMT" value="" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA11"></dt> <!-- 제조일자 -->
						<dd>
							<input type="text" class="input" name="LOTA11" id="LOTA11" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_QTDUOM"></dt> <!-- 입수 -->
						<dd>
							<input type="text" class="input" name="QTDUOM" id="QTDUOM" UIFormat="N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PRTBOX"></dt> <!-- 박스 -->
						<dd>
							<input type="text" class="input" name="QTDBOX" id="QTDBOX" UIFormat="N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PRTREM"></dt> <!-- 잔량 -->
						<dd>
							<input type="text" class="input" name="QTDREM" id="QTDREM" UIFormat="N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_QTDPRT"></dt> <!-- 총수량 -->
						<dd>
							<input type="text" class="input" name="QTDPRT" id="QTDPRT" UIFormat="N"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab on">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>