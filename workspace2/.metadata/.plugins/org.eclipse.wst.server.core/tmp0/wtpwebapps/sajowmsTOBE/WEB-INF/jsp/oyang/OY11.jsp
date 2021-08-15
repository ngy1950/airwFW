<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY11</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangReport",
	    	pkcol : "MANDT, SEQNO",
			command : "OY11_HEAD", //OY08과 같은 쿼리
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OY11"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangReport",
	    	pkcol : "MANDT, SEQNO",
			command : "OY11_ITEM" ,
		    menuId : "OY11"
	    });	
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridHeadList",true,["OWNRKY","DOCUTY","DIRDVY","DIRSUP"])
		gridList.setReadOnly("gridItemList",true,["WAREKY"])
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});


	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("OWNRKY",$("#OWNRKY").val());
			
			//라디오 버튼 값
			if ($('#Op01').prop("checked") == true ) {
				param.put("OPTYPE","01");
			}else if ($('#Op02').prop("checked") == true ){
				param.put("OPTYPE","02");
			}
			
			netUtil.send({
				url : "/OyangReport/json/displayOY11.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			param.put("OWNRKY",$("#OWNRKY").val());
			
			//라디오 버튼 값
			if ($('#Op01').prop("checked") == true ) {
				param.put("OPTYPE","01");
			}else if ($('#Op02').prop("checked") == true ){
				param.put("OPTYPE","02");
			}
			
			netUtil.send({
				url : "/OyangReport/json/displayOY11Item.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();

		return param;
	}

	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "DEL"){
				commonUtil.msgBox("SYSTEM_DELETEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "OPEN_BARCODE_POPUP"){  //바코드생성
			OPEN_BARCODE_POPUP(); 
		}else if(btnName == "Print"){  //거래처/제품 피킹
			Print(); 
		}else if(btnName == "Print2"){  //거래처/제품 피킹(낱개박스추가)
			Print2(); 
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY11");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "OY11");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OyangReport/json/saveOY11.data",
				param : param,
				successFunction : "returnSAVE"
			});
		}
	}
	function returnSAVE(json, status) {
		
		var count = 0;
 
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = " AND SVBELN = '"+ json.data.C00110 +"'";
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 925;
			var height = 815;
			
			if( check == "1" ){//바코드
			WriteEZgenElement("/ezgen/barcode_ys_box.ezg" , wherestr , " " , langKy, map , width , height );
		 	}else if( check == "2" ){ //거래처/제품피킹
				WriteEZgenElement("/ezgen/bzptn_picking_sale_list_oy.ezg" , wherestr , "" , langKy, map , width , height );
 			}
				
		searchList();
		}
 	}
	
	
	function OPEN_BARCODE_POPUP(){
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//차번호가 없을 경우
			for(var i=0; i < head.length; i++){
				var headMap = head[i].map;
				if(headMap.CARNUM.trim() == "" || headMap.CARNUM.trim() == null ){
					commonUtil.msgBox("SYSTEM_M1000");//* 차량번호(코스)가 없는 데이터가 있습니다. *
					return;
				}
			}
			
			
			if ($('#Op01').prop("checked") == true ) { //미발행
				check = "1";
				saveData();
			}else if ($('#Op02').prop("checked") == true ){ //발행
			
				var wherestr = "";    
				for(var i =0;i < head.length ; i++){
					if(wherestr == ""){
						wherestr = wherestr+" AND SEQNO IN (";
					}else{
						wherestr = wherestr+",";
					}
					wherestr += "'" + head[i].get("TEXT03") + "'";
				}
				wherestr += ")";
					
				var langKy = "KO";
				var width = 925;
				var heigth = 815;
				var map = new DataMap();
	
				WriteEZgenElement("/ezgen/barcode_ys_box.ezg" , wherestr , " " , langKy, map , width , heigth );
			}
		}
	}
		
	function Print(){  /* 거래처/제품 피킹 */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
/* 			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			} */
			//차번호가 없을 경우
			for(var i=0; i < head.length; i++){
				var headMap = head[i].map;
				if(headMap.CARNUM.trim() == "" || headMap.CARNUM.trim() == null ){
					commonUtil.msgBox("SYSTEM_M1000");//* 차량번호(코스)가 없는 데이터가 있습니다. *
					return;
				}
			}
			
			var wherestr = " ";
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'C.CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'I.OTRQDT');
			
			//var orderbystr = "AND 1=1";
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();

			WriteEZgenElement("/ezgen/bzptn_picking_sale_list_oy.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
	
	function Print2(){  /* 거래처/제품 피킹(낱개박스추가) */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//차번호가 없을 경우
			for(var i=0; i < head.length; i++){
				var headMap = head[i].map;
				if(headMap.CARNUM.trim() == "" || headMap.CARNUM.trim() == null ){
					commonUtil.msgBox("SYSTEM_M1000");//* 차량번호(코스)가 없는 데이터가 있습니다. *
					return;
				}
			}
			
			var wherestr = "";    
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'C.CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'I.OTRQDT');

	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option","AND 1=1");

			WriteEZgenElement("/ezgen/OY11_picking_list.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
		


	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

		//차량번호
		if(searchCode == "SHCARMA2" && $inputObj.name == "C.CARNUM"){
	        param.put("WAREKY","<%=wareky %>");
	    //납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");	
		//화주
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
	        param.put("CMCDKY","WAREKY");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		} return param;
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
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="OPEN_BARCODE_POPUP PRINT_OUT STD_BARPRINT" /> <!-- 바코드 출력 -->
					<input type="button" CB="Print PRINT_OUT BTN_PTNRSKUPIC" /> <!-- 거래처/제품 피킹 -->
					<input type="button" CB="Print2 PRINT_OUT BTN_PTNRSKUPICsw_BOX" /> <!-- 거래처/제품 피킹(낱개박스추가) -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select><!-- validate="required" -->
						</dd>
					</dl>
					<dl>  <!--납품요청일-->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--거점-->  
						<dt CL="STD_WAREKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WAREKY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>
						<dt CL="STD_BCDYN"></dt><!-- 바코드발행여부 -->
						<dd style="width:300px">
							<input type="radio" name="OPTYPE" id="Op01" value="Op01" checked /><label for="Op01">미발행</label>
		        			<input type="radio" name="OPTYPE" id="Op02" value="Op02" /><label for="Op02">발행</label>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li style = 'margin-left:10px;'><p>※ OY11 Header 리스트의 차량번호 : 양산 기준</p> <p>※ 바코드 출력 라벨지의 차량번호 : 출고 플랜트 기준</p></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td> 
										<td GH="40 STD_NUMBER" GCol="rownum">	</td>
										<td GH="130 key" GCol="text,KEY" GF="S 30">key</td> <!--key-->
										<td GH="90 STD_BCDYN" GCol="text,QTSCHK" GF="S 60">바코드발행여부</td>	<!--바코드발행여부-->
										<td GH="150 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
											<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>	
										<td GH="60 IFT_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
										<td GH="70 STD_CARNAME" GCol="text,CARNUMNM" GF="S 20">차량명</td> <!--차량명-->
										<td GH="70 STD_BACODE_NO" GCol="text,TEXT03" GF="S 20">바코드번호</td>	<!--바코드번호-->
										<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
										<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
										<td GH="70 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
										<td GH="160 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> <!--매출처명-->
										<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
										<td GH="250 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
    									<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
    									<td GH="110 IFT_DOCUTY" GCol="select,DOCUTY">	<!--출고유형-->
    										<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
    									</td>
    									<td GH="90 STD_VDATU" GCol="text,OTRQDT" GF="D 8">납품요청일 </td> <!--납품요청일 -->
    									<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
    									<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> <!--주문구분-->
										</td>
    									<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
    									<td GH="80 STD_N00105" GCol="text,N00105" GF="S 20">주문차수</td> <!--주문차수-->
    									<td GH="85 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 20">주문아이템번호</td> <!-- 주문아이템번호 -->
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
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td> 
										<td GH="100 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td> <!--주문번호아이템-->
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="100 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20">피킹출력번호</td> <!--피킹출력번호-->
										<td GH="160 IFT_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO">
											<option></option>
											</select> <!--WMS거점(출고사업장)-->
										</td> <!--WMS거점(출고사업장)-->
										<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="75 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
										<td GH="75 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td> <!--누적주문수량-->
										<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td> <!--출하수량-->
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
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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