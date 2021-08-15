<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL61</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	
	var SVBELNS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL61_HEAD",
			pkcol : "OWNRKY,WAREKY",
		    menuId : "DL61"
	    });
		
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		inputList.setInput("gridSearch");
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#WAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);

	}

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			save();
		} else if (btnName == "Reflect") {
			reflect();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL61");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL61");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			if (SVBELNS != "") {
				param.put('SVBELNS',SVBELNS);
			}
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			SVBELNS = '';
		}
	}

	//저장
	function save() {
		
        var head = gridList.getSelectData("gridList") //체크된것중에 수정된 row 만
        
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
        
		for(var i=0; i<head.length; i++){
			var shpoky = head[i].get("SHPOKY");
			var svbeln = head[i].get("SVBELN");
			alert(shpoky + " : " + svbeln);		
			if(shpoky != "" && svbeln != " "){
	   			alert("S/O번호 또는 출고문서번호만 입력하세요.");
	   			return;
	   		}
		}

       var param = new DataMap();
		param.put("head",head);
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

		netUtil.send({
			url : "/outbound/json/saveDL61.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	
	//저장
	function reflect() {
		
        var head = gridList.getSelectData("gridList") //체크된것중에 수정된 row 만
        
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
        
		for(var i=0; i<head.length; i++){
		   var gridId = "gridList";
		   var ownrky = $("#OWNRKY").val();
		   var wareky = $("#WAREKY").val();
		   var recnum = head[i].get("RECNUM");
		 
		   var param = new DataMap();
		   param.put("OWNRKY", ownrky);
		   param.put("WAREKY", wareky);
		   param.put("RECNUM", recnum);
		   		   
		   var json = netUtil.sendData({
				module : "Outbound",
				command : "DL60_CARMA_INFO",
				sendType : "map",
				param : param
			}); 
		   
		    alert(json.data.RCATYP);
//			gridList.setColValue(gridId, i+1, "RECNUM", json.data.RECNUM);
			gridList.setColValue(gridId,  i, "RCATYP", json.data.RCATYP);
			gridList.setColValue(gridId,  i, "RCAGBN", json.data.RCAGBN);
			gridList.setColValue(gridId,  i, "CARNUMNMRE", json.data.CARNUMNMRE);
			gridList.setColValue(gridId,  i, "DRIVER", json.data.DRIVER);
			gridList.setColValue(gridId,  i, "PERHNO", json.data.PERHNO);
			gridList.setColValue(gridId,  i, "RETRCP", json.data.RETRCP);

		}

	}

	//저장완료 콜백
	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELNS = json.data;
//				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	//체크적용
	function setChk(){
		//인풋값 가져오기
		var recnumchk = $('#recnumchk').prop("checked");
		var cargbnchk = $("#cargbnchk").prop("checked");
		var cartypchk = $("#cartypchk").prop("checked");
		var perhnochk = $("#perhnochk").prop("checked");
		var recdatchk = $("#recdatchk").prop("checked");
		
		if(!recnumchk && !cargbnchk && !cartypchk && !perhnochk && !recdatchk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
//		var list = gridList.getGridData("gridList");
		var list = gridList.getSelectData("gridList");
		var cnt = 0;
       
		for(var i=0; i<list.length; i++){		
//			var docuty = gridList.getColData("gridList", i, "DOCUTY");

			//창고값 변경 변경 체크했을 경우에만
//			if(recnumchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "WAREKY", $("#WARECOMBO").val());
			if(recnumchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "RECNUM", $("#RECNUM").val());
			if(cargbnchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "RCAGBN", $("#CARGBN").val());
			if(cartypchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "RCATYP", $("#CARTYP").val());
			if(perhnochk) gridList.setColValue("gridList", list[i].get("GRowNum"), "PERHNO", $("#PERHNO").val());
			if(recdatchk) gridList.setColValue("gridList", list[i].get("GRowNum"), "RECDAT", $("#RECDAT").val());

		}
	}

	//일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	function setAll(){
		//인풋값 가져오기

		gridList.checkAll("gridList",true);
		
//		var list = gridList.getGridData("gridList");
//		for(var i=0; i<list.length; i++){	
//			alert(i);
//			gridList.getGridBox('gridList').setColValue(i+1,'rowCheck', true);
//		}		
//		gridList.checkAll("gridList",true);
		setChk();
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("DASTYP",$('#DASTYP').val());
		newData.put("CELTYP","01");//01 기본
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		}
		
		return param;
	}
	  //서치헬프 기본값 세팅
	  function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	        var param = new DataMap();
	        
	        if(searchCode == "SHCARNUMIF"){
	            param.put("WAREKY",$('#WAREKY').val());
	            param.put("OWNRKY",$('#OWNRKY').val());
	        }
	      return param;
	    }
			
		//서치헬프 종료 이벤트
		 function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		  if( searchCode == 'SHSKUMAGD'){
		   var gridId = "gridItemList";
		   var rowNum = gridList.getFocusRowNum(gridId);
		   var head = gridList.getSelectData("gridHeadList");	   
		   var ownrky = head[0].get("OWNRKY");	  
		   var waresr = head[0].get("WARESR");
		   var warerq = $('#WARERQ').val();	   
		   var skukey = rowData.get("SKUKEY")
		   
		   var param = new DataMap();
		   param.put("OWNRKY", ownrky);
		   param.put("WAREKY", waresr);
		   param.put("WARERQ", warerq);
		   param.put("SKUKEY", skukey);
		   
		   var json = netUtil.sendData({
				module : "Outbound",
				command : "TM05_SKUKEY_SHELP",
				sendType : "map",
				param : param
			}); 
		
				gridList.setColValue(gridId, rowNum, "SKUKEY", json.data.SKUKEY);
				gridList.setColValue(gridId, rowNum, "DESC01", json.data.DESC01);
				gridList.setColValue(gridId, rowNum, "DESC02", json.data.DESC02);
				gridList.setColValue(gridId, rowNum, "DUOMKY", json.data.DUOMKY);
				gridList.setColValue(gridId, rowNum, "QTYORG", json.data.QTYORG);
				gridList.setColValue(gridId, rowNum, "TOQTSIWH", json.data.TOQTSIWH);
				gridList.setColValue(gridId, rowNum, "PLIQTY", json.data.PLIQTY);
				gridList.setColValue(gridId, rowNum, "PLTQTY", json.data.PLTQTY);
				gridList.setColValue(gridId, rowNum, "BXIQTY", json.data.BXIQTY);
				gridList.setColValue(gridId, rowNum, "BOXQTY", json.data.BOXQTY);
				gridList.setColValue(gridId, rowNum, "REMQTY", json.data.REMQTY);
		  } else if (searchCode == 'SHCARNUMIF'){
			   var gridId = "gridList"
			   var rowNum = gridList.getFocusRowNum(gridId);		  
			   var ownrky = rowData.get("OWNRKY");
			   var wareky = rowData.get("WAREKY");
			   var recnum = rowData.get("RECNUM");
			   
			   var param = new DataMap();
			   param.put("OWNRKY", ownrky);
			   param.put("WAREKY", wareky);
			   param.put("RECNUM", recnum);
			   		   
			   var json = netUtil.sendData({
					module : "Outbound",
					command : "DL60_CARMA_INFO",
					sendType : "map",
					param : param
				}); 
				gridList.setColValue(gridId, rowNum, "RECNUM", rowData.get("RECNUM"));
				gridList.setColValue(gridId, rowNum, "RCATYP", rowData.get("RECTYP"));
				gridList.setColValue(gridId, rowNum, "RCAGBN", rowData.get("RECGBN"));
				gridList.setColValue(gridId, rowNum, "CARNUMNMRE", json.data.CARNUMNMRE);
				gridList.setColValue(gridId, rowNum, "DRIVER", json.data.DRIVER);
				gridList.setColValue(gridId, rowNum, "PERHNO", json.data.PERHNO);
				gridList.setColValue(gridId, rowNum, "RETRCP", json.data.RETRCP);
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
						<input type="button" CB="Reflect REFLECT BTN_REFLECT" /> 
						<input type="button" CB="Save SAVE BTN_SAVE" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
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
					<ul class="tab tab_style02 tab_s" id="gridSearch">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 재배차 차량번호 -->
							<input type="checkbox" id="recnumchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_RECNUM" style="PADDING-RIGHT: 10PX; VERTICAL-ALIGN: MIDDLE;"></span>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="text" class="input" name="RECNUM" id="RECNUM" UIInput="S,SHCARNUMIF" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="cargbnchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_RECGBN" style="PADDING-RIGHT: 10PX; VERTICAL-ALIGN: MIDDLE;"></span>													
							<select name="CARGBN" id="CARGBN"  class="input" CommonCombo="CARGBN" ComboCodeView="true"><option></option></select>
						
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="cartypchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_RECTYP" style="PADDING-RIGHT: 10PX; VERTICAL-ALIGN: MIDDLE;"></span>													
							<select name="CARTYP" id="CARTYP"  class="input" CommonCombo="CARTYP" ComboCodeView="true"><option></option></select>
						
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="perhnochk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_PERHNO" style="PADDING-RIGHT: 10PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<input type="text" id="PERHNO" name="PERHNO"  UIInput="I"  class="input"/>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<input type="checkbox" id="recdatchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_RECDAT" style="PADDING-RIGHT: 10PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<input type="text" id="RECDAT" name="RECDAT"  UIInput="I"  UIFormat="C" class="input"/>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 일괄적용 -->
							<input type="button" CB="SetAll SAVE BTN_ALL" /> 
						</li>
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
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rowCheck"></td>
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="100 STD_SVBELN" GCol="input,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="100 STD_SHPOKY" GCol="input,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="150 STD_RECNUM" GCol="input,RECNUM,SHCARNUMIF" GF="S 50">재배차 차량번호</td>	<!--재배차 차량번호-->
				    						<td GH="150 STD_RECTYP" GCol="select,RCATYP"><!--재배차 차량톤수-->
												<select class="input" commonCombo="CARTYP"></select>
				    						</td>
				    						<td GH="150 STD_RECGBN" GCol="select,RCAGBN"><!--재배차 차량구분-->
													<select class="input" commonCombo="CARGBN"></select>
				    						</td>
				    						<td GH="150 STD_PERHNO" GCol="input,PERHNO" GF="S 20">기사핸드폰</td>	<!--기사핸드폰-->
				    						<td GH="80 STD_QTRECN" GCol="input,QTRECN" GF="N 10,0">재배차수량</td>	<!--재배차수량-->
				    						<td GH="100 STD_RECDAT" GCol="input,RECDAT" GF="C 8">재배차 배송일자</td>	<!--재배차 배송일자-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="delete"></button>
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