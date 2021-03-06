<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL98</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
			module : "OyangOutbound",
			command : "OY16_1",
			pkcol : "OWNRKY",
			colorType : true ,
		    menuId : "OY16"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "OyangOutbound",
			command : "OY16_2",
			pkcol : "OWNRKY",
			colorType : true ,
		    menuId : "OY16"
	    });
		gridList.setGrid({
	    	id : "gridList3",
			module : "OyangOutbound",
			command : "OY16_3",
			pkcol : "OWNRKY",
			colorType : true ,
		    menuId : "OY16"
	    });
		gridList.setGrid({
	    	id : "gridList4",
			module : "OyangOutbound",
			command : "OY16_4",
			pkcol : "OWNRKY",
			colorType : true ,
		    menuId : "OY16"
	    });
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dateParser(null, "S", 0, 0, 1));
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		setSingleRangeData("OTRQDT", rangeArr);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function searchList(){
		$('#atab1-1').trigger("click");
	}
	
	function display1(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
		}
	}
	function display2(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
			    	id : "gridList2",
			    	param : param
			    });
		}
	}
	function display3(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList3",
		    	param : param
		    });
		}
	}
	function display4(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList4",
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
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reloadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
// 		}else if(btnName == "Save"){
// 			saveData();
// 		}else if(btnName == "Reload"){
// 			reloadLabel();
			
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY16");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "OY16");
		}
	}
	
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	
		//차량번호
		if(searchCode == "SHCARMA2" && $inputObj.name == "CF.CARNUM"){
	        param.put("WAREKY","<%=wareky %>");	 
		} return param;
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){	
		if(gridList.getColData(gridId, rowNum, "FLAGYN") == "FFD8D8"){
			return configData.GRID_COLOR_BG_BRIGHT_RED_CLASS;
		}else{
			return configData.GRID_COLOR_BG_WHITE_CLASS;	
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
<!-- 						<input type="button" CB="Save SAVE BTN_SAVE" /> -->
<!-- 						<input type="button" CB="Reload RESET STD_REFLBL" /> -->
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
							<dt CL="STD_DLVDAT"></dt><!--납품요청일-->
							<dd>
								<input type="text" class="input" name="OTRQDT" UIInput="B" UIFormat="C N" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_CARNUM"></dt><!--차량번호-->
							<dd>
								<input type="text" class="input" name="CF.CARNUM" UIInput="SR,SHCARMA2" />
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
						<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>2시</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>4시반특정</span></a></li>
						<li><a href="#tab1-3" onclick="display3()"><span>수출</span></a></li>
						<li><a href="#tab1-4" onclick="display4()"><span>냉동</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_DRCARNUM" GCol="text,CARNUM" GF="S 10"></td>	<!--배송코스-->
				    						<td GH="80 STD_PTNRKY1" GCol="text,PTNRTO" GF="S 10"></td>	<!--부서코드-->
				    						<td GH="120 STD_PTNRNM" GCol="text,PTNRTONM" GF="S 10"></td>	<!--거래처명-->
				    						<td GH="80 STD_G1_NUM01_BOXS" GCol="text,NUM01_BOXS" GF="N 80,0">오륙도맛바(BOX)</td>	<!--오륙도맛바(BOX)-->
				    						<td GH="80 STD_G1_NUM01_REMS" GCol="text,NUM01_REMS" GF="N 80,0">오륙도맛바(낱개)</td>	<!--오륙도맛바(낱개)-->
				    						<td GH="80 STD_G1_NUM02_BOXS" GCol="text,NUM02_BOXS" GF="N 80,0">오륙도플러냉장(BOX)</td>	<!--오륙도플러냉장(BOX)-->
				    						<td GH="80 STD_G1_NUM02_REMS" GCol="text,NUM02_REMS" GF="N 80,0">오륙도플러냉장(낱개)</td>	<!--오륙도플러냉장(낱개)-->
				    						<td GH="80 STD_G1_NUM03_BOXS" GCol="text,NUM03_BOXS" GF="N 80,0">미니오륙도바(BOX)</td>	<!--미니오륙도바(BOX)-->
				    						<td GH="80 STD_G1_NUM03_REMS" GCol="text,NUM03_REMS" GF="N 80,0">미니오륙도바(낱개)</td>	<!--미니오륙도바(낱개)-->
				    						<td GH="80 STD_G1_NUM04_BOXS" GCol="text,NUM04_BOXS" GF="N 80,0">오륙도오치즈핫바１２５０G(BOX)</td>	<!--오륙도오치즈핫바１２５０G(BOX)-->
				    						<td GH="80 STD_G1_NUM04_REMS" GCol="text,NUM04_REMS" GF="N 80,0">오륙도오치즈핫바１２５０G(낱개)</td>	<!--오륙도오치즈핫바１２５０G(낱개)-->
				    						<td GH="80 STD_G1_NUM05_BOXS" GCol="text,NUM05_BOXS" GF="N 80,0">매운맛왕꼬치 100g(BOX)</td>	<!--매운맛왕꼬치 100g(BOX)-->
				    						<td GH="80 STD_G1_NUM05_REMS" GCol="text,NUM05_REMS" GF="N 80,0">매운맛왕꼬치 100g(낱개)</td>	<!--매운맛왕꼬치 100g(낱개)-->
				    						<td GH="80 STD_G1_NUM06_BOXS" GCol="text,NUM06_BOXS" GF="N 80,0">냉동）오치즈핫바１２５０G(BOX)</td>	<!--냉동）오치즈핫바１２５０G(BOX)-->
				    						<td GH="80 STD_G1_NUM06_REMS" GCol="text,NUM06_REMS" GF="N 80,0">냉동）오치즈핫바１２５０G(낱개)</td>	<!--냉동）오치즈핫바１２５０G(낱개)-->
				    						<td GH="80 STD_G1_NUM07_BOXS" GCol="text,NUM07_BOXS" GF="N 80,0">청춘오징어핫바４００G(BOX)</td>	<!--청춘오징어핫바４００G(BOX)-->
				    						<td GH="80 STD_G1_NUM07_REMS" GCol="text,NUM07_REMS" GF="N 80,0">청춘오징어핫바４００G(낱개)</td>	<!--청춘오징어핫바４００G(낱개)-->
				    						<td GH="80 STD_G1_NUM08_BOXS" GCol="text,NUM08_BOXS" GF="N 80,0">치즈킹 9kg(30g*300ea)(BOX)</td>	<!--치즈킹 9kg(30g*300ea)(BOX)-->
				    						<td GH="80 STD_G1_NUM08_REMS" GCol="text,NUM08_REMS" GF="N 80,0">치즈킹 9kg(30g*300ea)(낱개)</td>	<!--치즈킹 9kg(30g*300ea)(낱개)-->
				    						<td GH="80 STD_G1_NUM09_BOXS" GCol="text,NUM09_BOXS" GF="N 80,0">반찬소시지500G(BOX)</td>	<!--반찬소시지500G(BOX)-->
				    						<td GH="80 STD_G1_NUM09_REMS" GCol="text,NUM09_REMS" GF="N 80,0">반찬소시지500G(낱개)</td>	<!--반찬소시지500G(낱개)-->
				    						<td GH="80 STD_G1_NUM10_BOXS" GCol="text,NUM10_BOXS" GF="N 80,0">반찬소시지1000G(BOX)</td>	<!--반찬소시지1000G(BOX)-->
				    						<td GH="80 STD_G1_NUM10_REMS" GCol="text,NUM10_REMS" GF="N 80,0">반찬소시지1000G(낱개)</td>	<!--반찬소시지1000G(낱개)-->
				    						<td GH="80 STD_G1_NUM11_BOXS" GCol="text,NUM11_BOXS" GF="N 80,0">꼬마장사38G(BOX)</td>	<!--꼬마장사38G(BOX)-->
				    						<td GH="80 STD_G1_NUM11_REMS" GCol="text,NUM11_REMS" GF="N 80,0">꼬마장사38G(낱개)</td>	<!--꼬마장사38G(낱개)-->
				    						<td GH="80 STD_G1_NUM12_BOXS" GCol="text,NUM12_BOXS" GF="N 80,0">꼬마장사65G(BOX)</td>	<!--꼬마장사65G(BOX)-->
				    						<td GH="80 STD_G1_NUM12_REMS" GCol="text,NUM12_REMS" GF="N 80,0">꼬마장사65G(낱개)</td>	<!--꼬마장사65G(낱개)-->
				    						<td GH="80 STD_G1_NUM13_BOXS" GCol="text,NUM13_BOXS" GF="N 80,0">꼬마장사２５０G(BOX)</td>	<!--꼬마장사２５０G(BOX)-->
				    						<td GH="80 STD_G1_NUM13_REMS" GCol="text,NUM13_REMS" GF="N 80,0">꼬마장사２５０G(낱개)</td>	<!--꼬마장사２５０G(낱개)-->
				    						<td GH="80 STD_G1_NUM14_BOXS" GCol="text,NUM14_BOXS" GF="N 80,0">꼬마장사10G(BOX)</td>	<!--꼬마장사10G(BOX)-->
				    						<td GH="80 STD_G1_NUM14_REMS" GCol="text,NUM14_REMS" GF="N 80,0">꼬마장사10G(낱개)</td>	<!--꼬마장사10G(낱개)-->
				    						<td GH="80 STD_G1_NUM15_BOXS" GCol="text,NUM15_BOXS" GF="N 80,0">꼬마장사20G(BOX)</td>	<!--꼬마장사20G(BOX)-->
				    						<td GH="80 STD_G1_NUM15_REMS" GCol="text,NUM15_REMS" GF="N 80,0">꼬마장사20G(낱개)</td>	<!--꼬마장사20G(낱개)-->
				    						<td GH="80 STD_G1_NUM16_BOXS" GCol="text,NUM16_BOXS" GF="N 80,0">코가큰피노키오65G(BOX)</td>	<!--코가큰피노키오65G(BOX)-->
				    						<td GH="80 STD_G1_NUM16_REMS" GCol="text,NUM16_REMS" GF="N 80,0">코가큰피노키오65G(낱개)</td>	<!--코가큰피노키오65G(낱개)-->
				    						<td GH="80 STD_G1_NUM17_BOXS" GCol="text,NUM17_BOXS" GF="N 80,0">코가큰피노키오10G(BOX)</td>	<!--코가큰피노키오10G(BOX)-->
				    						<td GH="80 STD_G1_NUM17_REMS" GCol="text,NUM17_REMS" GF="N 80,0">코가큰피노키오10G(낱개)</td>	<!--코가큰피노키오10G(낱개)-->
				    						<td GH="80 STD_G1_NUM18_BOXS" GCol="text,NUM18_BOXS" GF="N 80,0">연태정헌１０G꼬마(BOX)</td>	<!--연태정헌１０G꼬마(BOX)-->
				    						<td GH="80 STD_G1_NUM18_REMS" GCol="text,NUM18_REMS" GF="N 80,0">연태정헌１０G꼬마(낱개)</td>	<!--연태정헌１０G꼬마(낱개)-->
				    						<td GH="80 STD_G1_NUM19_BOXS" GCol="text,NUM19_BOXS" GF="N 80,0">치즈킹꼬마장사(BOX)</td>	<!--치즈킹꼬마장사(BOX)-->
				    						<td GH="80 STD_G1_NUM19_REMS" GCol="text,NUM19_REMS" GF="N 80,0">치즈킹꼬마장사(낱개)</td>	<!--치즈킹꼬마장사(낱개)-->
				    						<td GH="80 STD_G1_NUM20_BOXS" GCol="text,NUM20_BOXS" GF="N 80,0">닭가슴살꼬마장사６５G(BOX)</td>	<!--닭가슴살꼬마장사６５G(BOX)-->
				    						<td GH="80 STD_G1_NUM20_REMS" GCol="text,NUM20_REMS" GF="N 80,0">닭가슴살꼬마장사６５G(낱개)</td>	<!--닭가슴살꼬마장사６５G(낱개)-->
				    						<td GH="80 STD_G1_NUM21_BOXS" GCol="text,NUM21_BOXS" GF="N 80,0">피자맛왕꼬치 100g (BOX)</td>	<!--피자맛왕꼬치 100g (BOX)-->
				    						<td GH="80 STD_G1_NUM21_REMS" GCol="text,NUM21_REMS" GF="N 80,0">피자맛왕꼬치 100g (낱개)</td>	<!--피자맛왕꼬치 100g (낱개)-->
				    						<td GH="80 STD_G1_NUM22_BOXS" GCol="text,NUM22_BOXS" GF="N 80,0">이츠웰 반찬소시지 1,000g (BOX)</td>	<!--이츠웰 반찬소시지 1,000g (BOX)-->
				    						<td GH="80 STD_G1_NUM22_REMS" GCol="text,NUM22_REMS" GF="N 80,0">이츠웰 반찬소시지 1,000g (낱개)</td>	<!--이츠웰 반찬소시지 1,000g (낱개)-->
				    						<td GH="80 STD_G1_NUM23_BOXS" GCol="text,NUM23_BOXS" GF="N 80,0">NNNNNN</td>	<!--NNNNNN-->
				    						<td GH="80 STD_G1_NUM23_REMS" GCol="text,NUM23_REMS" GF="N 80,0">NNNNNN</td>	<!--NNNNNN-->
				    						<td GH="80 STD_G1_NUM24_BOXS" GCol="text,NUM24_BOXS" GF="N 80,0">장푸드옛날소시지５００G(BOX)</td>	<!--장푸드옛날소시지５００G(BOX)-->
				    						<td GH="80 STD_G1_NUM24_REMS" GCol="text,NUM24_REMS" GF="N 80,0">장푸드옛날소시지５００G(낱개)</td>	<!--장푸드옛날소시지５００G(낱개)-->
				    						<td GH="80 STD_G1_NUM25_BOXS" GCol="text,NUM25_BOXS" GF="N 80,0">장푸드옛날소시지１０００G(BOX)</td>	<!--장푸드옛날소시지１０００G(BOX)-->
				    						<td GH="80 STD_G1_NUM25_REMS" GCol="text,NUM25_REMS" GF="N 80,0">장푸드옛날소시지１０００G(낱개)</td>	<!--장푸드옛날소시지１０００G(낱개)-->
				    						<td GH="80 STD_G1_NUM26_BOXS" GCol="text,NUM26_BOXS" GF="N 80,0">뿌까마또르플러스９０(BOX)</td>	<!--뿌까마또르플러스９０(BOX)-->
				    						<td GH="80 STD_G1_NUM26_REMS" GCol="text,NUM26_REMS" GF="N 80,0">뿌까마또르플러스９０(낱개)</td>	<!--뿌까마또르플러스９０(낱개)-->
				    						<td GH="80 STD_G1_NUM27_BOXS" GCol="text,NUM27_BOXS" GF="N 80,0">뿌까마또르플러스１０５０G(BOX)</td>	<!--뿌까마또르플러스１０５０G(BOX)-->
				    						<td GH="80 STD_G1_NUM27_REMS" GCol="text,NUM27_REMS" GF="N 80,0">뿌까마또르플러스１０５０G(낱개)</td>	<!--뿌까마또르플러스１０５０G(낱개)-->
				    						<td GH="80 STD_G1_NUM28_BOXS" GCol="text,NUM28_BOXS" GF="N 80,0">뿌까마또르담백한맛(BOX)</td>	<!--뿌까마또르담백한맛(BOX)-->
				    						<td GH="80 STD_G1_NUM28_REMS" GCol="text,NUM28_REMS" GF="N 80,0">뿌까마또르담백한맛(낱개)</td>	<!--뿌까마또르담백한맛(낱개)-->
				    						<td GH="80 STD_G1_NUM29_BOXS" GCol="text,NUM29_BOXS" GF="N 80,0">청정원크랩봉７５G(BOX)</td>	<!--청정원크랩봉７５G(BOX)-->
				    						<td GH="80 STD_G1_NUM29_REMS" GCol="text,NUM29_REMS" GF="N 80,0">청정원크랩봉７５G(낱개)</td>	<!--청정원크랩봉７５G(낱개)-->
				    						<td GH="80 STD_G1_NUM30_BOXS" GCol="text,NUM30_BOXS" GF="N 80,0">청정원크랩봉４８０G(BOX)</td>	<!--청정원크랩봉４８０G(BOX)-->
				    						<td GH="80 STD_G1_NUM30_REMS" GCol="text,NUM30_REMS" GF="N 80,0">청정원크랩봉４８０G(낱개)</td>	<!--청정원크랩봉４８０G(낱개)-->
				    						<td GH="80 STD_G1_NUM31_BOXS" GCol="text,NUM31_BOXS" GF="N 80,0">청정원크랩봉６７５G(BOX)</td>	<!--청정원크랩봉６７５G(BOX)-->
				    						<td GH="80 STD_G1_NUM31_REMS" GCol="text,NUM31_REMS" GF="N 80,0">청정원크랩봉６７５G(낱개)</td>	<!--청정원크랩봉６７５G(낱개)-->
				    						<td GH="80 STD_G1_NUM32_BOXS" GCol="text,NUM32_BOXS" GF="N 80,0">크렙봉１．５KG(BOX)</td>	<!--크렙봉１．５KG(BOX)-->
				    						<td GH="80 STD_G1_NUM32_REMS" GCol="text,NUM32_REMS" GF="N 80,0">크렙봉１．５KG(낱개)</td>	<!--크렙봉１．５KG(낱개)-->
				    						<td GH="80 STD_G1_NUM33_BOXS" GCol="text,NUM33_BOXS" GF="N 80,0">쉐프큐 사각 2500g (BOX)</td>	<!--쉐프큐 사각 2500g (BOX)-->
				    						<td GH="80 STD_G1_NUM33_REMS" GCol="text,NUM33_REMS" GF="N 80,0">쉐프큐 사각 2500g (낱개)</td>	<!--쉐프큐 사각 2500g (낱개)-->
				    						<td GH="80 STD_G1_NUM34_BOXS" GCol="text,NUM34_BOXS" GF="N 80,0">청정원밥맛소시지야채맛(BOX)</td>	<!--청정원밥맛소시지야채맛(BOX)-->
				    						<td GH="80 STD_G1_NUM34_REMS" GCol="text,NUM34_REMS" GF="N 80,0">청정원밥맛소시지야채맛(낱개)</td>	<!--청정원밥맛소시지야채맛(낱개)-->
				    						<td GH="80 STD_G1_NUM35_BOXS" GCol="text,NUM35_BOXS" GF="N 80,0">청정원２５０옛날소시지(BOX)</td>	<!--청정원２５０옛날소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM35_REMS" GCol="text,NUM35_REMS" GF="N 80,0">청정원２５０옛날소시지(낱개)</td>	<!--청정원２５０옛날소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM36_BOXS" GCol="text,NUM36_BOXS" GF="N 80,0">청정원５００옛날소시지(BOX)</td>	<!--청정원５００옛날소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM36_REMS" GCol="text,NUM36_REMS" GF="N 80,0">청정원５００옛날소시지(낱개)</td>	<!--청정원５００옛날소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM37_BOXS" GCol="text,NUM37_BOXS" GF="N 80,0">청정원１０００옛날소시지(BOX)</td>	<!--청정원１０００옛날소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM37_REMS" GCol="text,NUM37_REMS" GF="N 80,0">청정원１０００옛날소시지(낱개)</td>	<!--청정원１０００옛날소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM38_BOXS" GCol="text,NUM38_BOXS" GF="N 80,0">RRP청정원옛날소시지１KG(BOX)</td>	<!--RRP청정원옛날소시지１KG(BOX)-->
				    						<td GH="80 STD_G1_NUM38_REMS" GCol="text,NUM38_REMS" GF="N 80,0">RRP청정원옛날소시지１KG(낱개)</td>	<!--RRP청정원옛날소시지１KG(낱개)-->
				    						<td GH="80 STD_G1_NUM39_BOXS" GCol="text,NUM39_BOXS" GF="N 80,0">베스트코옛날소시지１KG(BOX)</td>	<!--베스트코옛날소시지１KG(BOX)-->
				    						<td GH="80 STD_G1_NUM39_REMS" GCol="text,NUM39_REMS" GF="N 80,0">베스트코옛날소시지１KG(낱개)</td>	<!--베스트코옛날소시지１KG(낱개)-->
				    						<td GH="80 STD_G1_NUM40_BOXS" GCol="text,NUM40_BOXS" GF="N 80,0">골목대장짱（아씨）272g(BOX)</td>	<!--골목대장짱（아씨）272g(BOX)-->
				    						<td GH="80 STD_G1_NUM40_REMS" GCol="text,NUM40_REMS" GF="N 80,0">골목대장짱（아씨）272g(낱개)</td>	<!--골목대장짱（아씨）272g(낱개)-->
				    						<td GH="80 STD_G1_NUM41_BOXS" GCol="text,NUM41_BOXS" GF="N 80,0">내친구짱（아씨）320g(BOX)</td>	<!--내친구짱（아씨）320g(BOX)-->
				    						<td GH="80 STD_G1_NUM41_REMS" GCol="text,NUM41_REMS" GF="N 80,0">내친구짱（아씨）320g(낱개)</td>	<!--내친구짱（아씨）320g(낱개)-->
				    						<td GH="80 STD_G1_NUM42_BOXS" GCol="text,NUM42_BOXS" GF="N 80,0">내친구짱빅（아씨）350g(BOX)</td>	<!--내친구짱빅（아씨）350g(BOX)-->
				    						<td GH="80 STD_G1_NUM42_REMS" GCol="text,NUM42_REMS" GF="N 80,0">내친구짱빅（아씨）350g(낱개)</td>	<!--내친구짱빅（아씨）350g(낱개)-->
				    						<td GH="80 STD_G1_NUM43_BOXS" GCol="text,NUM43_BOXS" GF="N 80,0">스틱맨（아씨）140G(BOX)</td>	<!--스틱맨（아씨）140G(BOX)-->
				    						<td GH="80 STD_G1_NUM43_REMS" GCol="text,NUM43_REMS" GF="N 80,0">스틱맨（아씨）140G(낱개)</td>	<!--스틱맨（아씨）140G(낱개)-->
				    						<td GH="80 STD_G1_NUM44_BOXS" GCol="text,NUM44_BOXS" GF="N 80,0">스틱맨（아씨）350G(BOX)</td>	<!--스틱맨（아씨）350G(BOX)-->
				    						<td GH="80 STD_G1_NUM44_REMS" GCol="text,NUM44_REMS" GF="N 80,0">스틱맨（아씨）350G(낱개)</td>	<!--스틱맨（아씨）350G(낱개)-->
				    						<td GH="80 STD_G1_NUM45_BOXS" GCol="text,NUM45_BOXS" GF="N 80,0">스틱맨（아씨）700G(BOX)</td>	<!--스틱맨（아씨）700G(BOX)-->
				    						<td GH="80 STD_G1_NUM45_REMS" GCol="text,NUM45_REMS" GF="N 80,0">스틱맨（아씨）700G(낱개)</td>	<!--스틱맨（아씨）700G(낱개)-->
				    						<td GH="80 STD_G1_NUM46_BOXS" GCol="text,NUM46_BOXS" GF="N 80,0">우리아이착한소시지(BOX)</td>	<!--우리아이착한소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM46_REMS" GCol="text,NUM46_REMS" GF="N 80,0">우리아이착한소시지(낱개)</td>	<!--우리아이착한소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM47_BOXS" GCol="text,NUM47_BOXS" GF="N 80,0">초록마을새우맛통통(BOX)</td>	<!--초록마을새우맛통통(BOX)-->
				    						<td GH="80 STD_G1_NUM47_REMS" GCol="text,NUM47_REMS" GF="N 80,0">초록마을새우맛통통(낱개)</td>	<!--초록마을새우맛통통(낱개)-->
				    						<td GH="80 STD_G1_NUM48_BOXS" GCol="text,NUM48_BOXS" GF="N 80,0">치즈맛통통(BOX)</td>	<!--치즈맛통통(BOX)-->
				    						<td GH="80 STD_G1_NUM48_REMS" GCol="text,NUM48_REMS" GF="N 80,0">치즈맛통통(낱개)</td>	<!--치즈맛통통(낱개)-->
				    						<td GH="80 STD_G1_NUM49_BOXS" GCol="text,NUM49_BOXS" GF="N 80,0">치즈소시지(BOX)</td>	<!--치즈소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM49_REMS" GCol="text,NUM49_REMS" GF="N 80,0">치즈소시지(낱개)</td>	<!--치즈소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM50_BOXS" GCol="text,NUM50_BOXS" GF="N 80,0">불고기맛후랑크(BOX)</td>	<!--불고기맛후랑크(BOX)-->
				    						<td GH="80 STD_G1_NUM50_REMS" GCol="text,NUM50_REMS" GF="N 80,0">불고기맛후랑크(낱개)</td>	<!--불고기맛후랑크(낱개)-->
				    						<td GH="80 STD_G1_NUM51_BOXS" GCol="text,NUM51_BOXS" GF="N 80,0">스타트스모크햄(BOX)</td>	<!--스타트스모크햄(BOX)-->
				    						<td GH="80 STD_G1_NUM51_REMS" GCol="text,NUM51_REMS" GF="N 80,0">스타트스모크햄(낱개)</td>	<!--스타트스모크햄(낱개)-->
				    						<td GH="80 STD_G1_NUM52_BOXS" GCol="text,NUM52_BOXS" GF="N 80,0">미스켄터키후랑크(BOX)</td>	<!--미스켄터키후랑크(BOX)-->
				    						<td GH="80 STD_G1_NUM52_REMS" GCol="text,NUM52_REMS" GF="N 80,0">미스켄터키후랑크(낱개)</td>	<!--미스켄터키후랑크(낱개)-->
				    						<td GH="80 STD_G1_NUM53_BOXS" GCol="text,NUM53_BOXS" GF="N 80,0">오양숯불갈비맛소시지(BOX)</td>	<!--오양숯불갈비맛소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM53_REMS" GCol="text,NUM53_REMS" GF="N 80,0">오양숯불갈비맛소시지(낱개)</td>	<!--오양숯불갈비맛소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM54_BOXS" GCol="text,NUM54_BOXS" GF="N 80,0">오양청양고추소시지(BOX)</td>	<!--오양청양고추소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM54_REMS" GCol="text,NUM54_REMS" GF="N 80,0">오양청양고추소시지(낱개)</td>	<!--오양청양고추소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM55_BOXS" GCol="text,NUM55_BOXS" GF="N 80,0">오양옥수수콘소시지(BOX)</td>	<!--오양옥수수콘소시지(BOX)-->
				    						<td GH="80 STD_G1_NUM55_REMS" GCol="text,NUM55_REMS" GF="N 80,0">오양옥수수콘소시지(낱개)</td>	<!--오양옥수수콘소시지(낱개)-->
				    						<td GH="80 STD_G1_NUM56_BOXS" GCol="text,NUM56_BOXS" GF="N 80,0">톡소시지70G(BOX)</td>	<!--톡소시지70G(BOX)-->
				    						<td GH="80 STD_G1_NUM56_REMS" GCol="text,NUM56_REMS" GF="N 80,0">톡소시지70G(낱개)</td>	<!--톡소시지70G(낱개)-->
				    						<td GH="80 STD_G1_NUM57_BOXS" GCol="text,NUM57_BOXS" GF="N 80,0">야채H（４０개）150G(BOX)</td>	<!--야채H（４０개）150G(BOX)-->
				    						<td GH="80 STD_G1_NUM57_REMS" GCol="text,NUM57_REMS" GF="N 80,0">야채H（４０개）150G(낱개)</td>	<!--야채H（４０개）150G(낱개)-->
				    						<td GH="80 STD_G1_NUM58_BOXS" GCol="text,NUM58_BOXS" GF="N 80,0">오양불고기햄(BOX)</td>	<!--오양불고기햄(BOX)-->
				    						<td GH="80 STD_G1_NUM58_REMS" GCol="text,NUM58_REMS" GF="N 80,0">오양불고기햄(낱개)</td>	<!--오양불고기햄(낱개)-->
				    						<td GH="80 STD_G1_NUM59_BOXS" GCol="text,NUM59_BOXS" GF="N 80,0">불갈비맛햄６５G(BOX)</td>	<!--불갈비맛햄６５G(BOX)-->
				    						<td GH="80 STD_G1_NUM59_REMS" GCol="text,NUM59_REMS" GF="N 80,0">불갈비맛햄６５G(낱개)</td>	<!--불갈비맛햄６５G(낱개)-->
				    						<td GH="80 STD_G1_NUM60_BOXS" GCol="text,NUM60_BOXS" GF="N 80,0">불고기왕꼬치후랑크(BOX)</td>	<!--불고기왕꼬치후랑크(BOX)-->
				    						<td GH="80 STD_G1_NUM60_REMS" GCol="text,NUM60_REMS" GF="N 80,0">불고기왕꼬치후랑크(낱개)</td>	<!--불고기왕꼬치후랑크(낱개)-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_DRCARNUM" GCol="text,CARNUM" GF="S 10"></td>	<!--배송코스-->
				    						<td GH="80 STD_PTNRKY1" GCol="text,PTNRTO" GF="S 10"></td>	<!--부서코드-->
				    						<td GH="120 STD_PTNRNM" GCol="text,PTNRTONM" GF="S 10"></td>	<!--거래처명-->
				    						<td GH="80 STD_G2_NUM01_BOXS" GCol="text,NUM01_BOXS" GF="N 80,0">즉석스모크햄(BOX)</td>	<!--즉석스모크햄(BOX)-->
				    						<td GH="80 STD_G2_NUM01_REMS" GCol="text,NUM01_REMS" GF="N 80,0">즉석스모크햄(낱개)</td>	<!--즉석스모크햄(낱개)-->
				    						<td GH="80 STD_G2_NUM02_BOXS" GCol="text,NUM02_BOXS" GF="N 80,0">빅켄터키S(35)(BOX)</td>	<!--빅켄터키S(35)(BOX)-->
				    						<td GH="80 STD_G2_NUM02_REMS" GCol="text,NUM02_REMS" GF="N 80,0">빅켄터키S(35)(낱개)</td>	<!--빅켄터키S(35)(낱개)-->
				    						<td GH="80 STD_G2_NUM03_BOXS" GCol="text,NUM03_BOXS" GF="N 80,0">불고기왕꼬치후랑크(BOX)</td>	<!--불고기왕꼬치후랑크(BOX)-->
				    						<td GH="80 STD_G2_NUM03_REMS" GCol="text,NUM03_REMS" GF="N 80,0">불고기왕꼬치후랑크(낱개)</td>	<!--불고기왕꼬치후랑크(낱개)-->
				    						<td GH="80 STD_G2_NUM04_BOXS" GCol="text,NUM04_BOXS" GF="N 80,0">켄터키후랑크(베스트코)1000g (BOX)</td>	<!--켄터키후랑크(베스트코)1000g (BOX)-->
				    						<td GH="80 STD_G2_NUM04_REMS" GCol="text,NUM04_REMS" GF="N 80,0">켄터키후랑크(베스트코)1000g (낱개)</td>	<!--켄터키후랑크(베스트코)1000g (낱개)-->
				    						<td GH="80 STD_G2_NUM05_BOXS" GCol="text,NUM05_BOXS" GF="N 80,0">쉐프큐 켄터키후랑크 1000g (BOX)</td>	<!--쉐프큐 켄터키후랑크 1000g (BOX)-->
				    						<td GH="80 STD_G2_NUM05_REMS" GCol="text,NUM05_REMS" GF="N 80,0">쉐프큐 켄터키후랑크 1000g (낱개)</td>	<!--쉐프큐 켄터키후랑크 1000g (낱개)-->
				    						<td GH="80 STD_G2_NUM06_BOXS" GCol="text,NUM06_BOXS" GF="N 80,0">쉐프큐 스모크햄 1000g (BOX)</td>	<!--쉐프큐 스모크햄 1000g (BOX)-->
				    						<td GH="80 STD_G2_NUM06_REMS" GCol="text,NUM06_REMS" GF="N 80,0">쉐프큐 스모크햄 1000g (낱개)</td>	<!--쉐프큐 스모크햄 1000g (낱개)-->
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
					<div class="table_box section" id="tab1-3">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList3">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_DRCARNUM" GCol="text,CARNUM" GF="S 10"></td>	<!--배송코스-->
				    						<td GH="80 STD_PTNRKY1" GCol="text,PTNRTO" GF="S 10"></td>	<!--부서코드-->
				    						<td GH="120 STD_PTNRNM" GCol="text,PTNRTONM" GF="S 10"></td>	<!--거래처명-->
				    						<td GH="80 STD_G3_NUM01_BOXS" GCol="text,NUM01_BOXS" GF="N 80,0">30입꼬마８０G중국수출(BOX)</td>	<!--30입꼬마８０G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM01_REMS" GCol="text,NUM01_REMS" GF="N 80,0">30입꼬마８０G중국수출(낱개)</td>	<!--30입꼬마８０G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM02_BOXS" GCol="text,NUM02_BOXS" GF="N 80,0">30입꼬마１００중국수출(BOX)</td>	<!--30입꼬마１００중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM02_REMS" GCol="text,NUM02_REMS" GF="N 80,0">30입꼬마１００중국수출(낱개)</td>	<!--30입꼬마１００중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM03_BOXS" GCol="text,NUM03_BOXS" GF="N 80,0">꼬마장사１０G중국수출(BOX)</td>	<!--꼬마장사１０G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM03_REMS" GCol="text,NUM03_REMS" GF="N 80,0">꼬마장사１０G중국수출(낱개)</td>	<!--꼬마장사１０G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM04_BOXS" GCol="text,NUM04_BOXS" GF="N 80,0">꼬마장사２０G중국수출(BOX)</td>	<!--꼬마장사２０G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM04_REMS" GCol="text,NUM04_REMS" GF="N 80,0">꼬마장사２０G중국수출(낱개)</td>	<!--꼬마장사２０G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM05_BOXS" GCol="text,NUM05_BOXS" GF="N 80,0">꼬마장사３８G중국수출(BOX)</td>	<!--꼬마장사３８G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM05_REMS" GCol="text,NUM05_REMS" GF="N 80,0">꼬마장사３８G중국수출(낱개)</td>	<!--꼬마장사３８G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM06_BOXS" GCol="text,NUM06_BOXS" GF="N 80,0">꼬마장사６５G중국수출(BOX)</td>	<!--꼬마장사６５G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM06_REMS" GCol="text,NUM06_REMS" GF="N 80,0">꼬마장사６５G중국수출(낱개)</td>	<!--꼬마장사６５G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM07_BOXS" GCol="text,NUM07_BOXS" GF="N 80,0">꼬마장사114G중국수출(BOX)</td>	<!--꼬마장사114G중국수출(BOX)-->
				    						<td GH="80 STD_G3_NUM07_REMS" GCol="text,NUM07_REMS" GF="N 80,0">꼬마장사114G중국수출(낱개)</td>	<!--꼬마장사114G중국수출(낱개)-->
				    						<td GH="80 STD_G3_NUM08_BOXS" GCol="text,NUM08_BOXS" GF="N 80,0">오리지널１０G꼬마장사(BOX)</td>	<!--오리지널１０G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM08_REMS" GCol="text,NUM08_REMS" GF="N 80,0">오리지널１０G꼬마장사(낱개)</td>	<!--오리지널１０G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM09_BOXS" GCol="text,NUM09_BOXS" GF="N 80,0">오리지널２０G꼬마장사(BOX)</td>	<!--오리지널２０G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM09_REMS" GCol="text,NUM09_REMS" GF="N 80,0">오리지널２０G꼬마장사(낱개)</td>	<!--오리지널２０G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM10_BOXS" GCol="text,NUM10_BOXS" GF="N 80,0">오리지널３８G꼬마장사(BOX)</td>	<!--오리지널３８G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM10_REMS" GCol="text,NUM10_REMS" GF="N 80,0">오리지널３８G꼬마장사(낱개)</td>	<!--오리지널３８G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM11_BOXS" GCol="text,NUM11_BOXS" GF="N 80,0">오리지널８０G꼬마장사(BOX)</td>	<!--오리지널８０G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM11_REMS" GCol="text,NUM11_REMS" GF="N 80,0">오리지널８０G꼬마장사(낱개)</td>	<!--오리지널８０G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM12_BOXS" GCol="text,NUM12_BOXS" GF="N 80,0">오리지널１００G꼬마장사(BOX)</td>	<!--오리지널１００G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM12_REMS" GCol="text,NUM12_REMS" GF="N 80,0">오리지널１００G꼬마장사(낱개)</td>	<!--오리지널１００G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM13_BOXS" GCol="text,NUM13_BOXS" GF="N 80,0">오리지널１１４G꼬마장사(BOX)</td>	<!--오리지널１１４G꼬마장사(BOX)-->
				    						<td GH="80 STD_G3_NUM13_REMS" GCol="text,NUM13_REMS" GF="N 80,0">오리지널１１４G꼬마장사(낱개)</td>	<!--오리지널１１４G꼬마장사(낱개)-->
				    						<td GH="80 STD_G3_NUM14_BOXS" GCol="text,NUM14_BOXS" GF="N 80,0">영양통통새우소시지９０G(BOX)</td>	<!--영양통통새우소시지９０G(BOX)-->
				    						<td GH="80 STD_G3_NUM14_REMS" GCol="text,NUM14_REMS" GF="N 80,0">영양통통새우소시지９０G(낱개)</td>	<!--영양통통새우소시지９０G(낱개)-->
				    						<td GH="80 STD_G3_NUM15_BOXS" GCol="text,NUM15_BOXS" GF="N 80,0">영양통통새우소시지１０５G(BOX)</td>	<!--영양통통새우소시지１０５G(BOX)-->
				    						<td GH="80 STD_G3_NUM15_REMS" GCol="text,NUM15_REMS" GF="N 80,0">영양통통새우소시지１０５G(낱개)</td>	<!--영양통통새우소시지１０５G(낱개)-->
				    						<td GH="80 STD_G3_NUM16_BOXS" GCol="text,NUM16_BOXS" GF="N 80,0">20입영양통통새우３００G(BOX)</td>	<!--20입영양통통새우３００G(BOX)-->
				    						<td GH="80 STD_G3_NUM16_REMS" GCol="text,NUM16_REMS" GF="N 80,0">20입영양통통새우３００G(낱개)</td>	<!--20입영양통통새우３００G(낱개)-->
				    						<td GH="80 STD_G3_NUM17_BOXS" GCol="text,NUM17_BOXS" GF="N 80,0">20G영양새우소시지１０００G(BOX)</td>	<!--20G영양새우소시지１０００G(BOX)-->
				    						<td GH="80 STD_G3_NUM17_REMS" GCol="text,NUM17_REMS" GF="N 80,0">20G영양새우소시지１０００G(낱개)</td>	<!--20G영양새우소시지１０００G(낱개)-->
				    						<td GH="80 STD_G3_NUM18_BOXS" GCol="text,NUM18_BOXS" GF="N 80,0">10G영양알찬소시지(BOX)</td>	<!--10G영양알찬소시지(BOX)-->
				    						<td GH="80 STD_G3_NUM18_REMS" GCol="text,NUM18_REMS" GF="N 80,0">10G영양알찬소시지(낱개)</td>	<!--10G영양알찬소시지(낱개)-->
				    						<td GH="80 STD_G3_NUM19_BOXS" GCol="text,NUM19_BOXS" GF="N 80,0">영양통통알찬소시지９０G(BOX)</td>	<!--영양통통알찬소시지９０G(BOX)-->
				    						<td GH="80 STD_G3_NUM19_REMS" GCol="text,NUM19_REMS" GF="N 80,0">영양통통알찬소시지９０G(낱개)</td>	<!--영양통통알찬소시지９０G(낱개)-->
				    						<td GH="80 STD_G3_NUM20_BOXS" GCol="text,NUM20_BOXS" GF="N 80,0">영양통통알찬소시지３００G(BOX)</td>	<!--영양통통알찬소시지３００G(BOX)-->
				    						<td GH="80 STD_G3_NUM20_REMS" GCol="text,NUM20_REMS" GF="N 80,0">영양통통알찬소시지３００G(낱개)</td>	<!--영양통통알찬소시지３００G(낱개)-->
				    						<td GH="80 STD_G3_NUM21_BOXS" GCol="text,NUM21_BOXS" GF="N 80,0">20G영양알찬소시지１０００G(BOX)</td>	<!--20G영양알찬소시지１０００G(BOX)-->
				    						<td GH="80 STD_G3_NUM21_REMS" GCol="text,NUM21_REMS" GF="N 80,0">20G영양알찬소시지１０００G(낱개)</td>	<!--20G영양알찬소시지１０００G(낱개)-->
				    						<td GH="80 STD_G3_NUM22_BOXS" GCol="text,NUM22_BOXS" GF="N 80,0">꼬마새우맛10G(BOX)</td>	<!--꼬마새우맛10G(BOX)-->
				    						<td GH="80 STD_G3_NUM22_REMS" GCol="text,NUM22_REMS" GF="N 80,0">꼬마새우맛10G(낱개)</td>	<!--꼬마새우맛10G(낱개)-->
				    						<td GH="80 STD_G3_NUM23_BOXS" GCol="text,NUM23_BOXS" GF="N 80,0">꼬마새우맛20G(BOX)</td>	<!--꼬마새우맛20G(BOX)-->
				    						<td GH="80 STD_G3_NUM23_REMS" GCol="text,NUM23_REMS" GF="N 80,0">꼬마새우맛20G(낱개)</td>	<!--꼬마새우맛20G(낱개)-->
				    						<td GH="80 STD_G3_NUM24_BOXS" GCol="text,NUM24_BOXS" GF="N 80,0">30꼬마새우맛８０G(BOX)</td>	<!--30꼬마새우맛８０G(BOX)-->
				    						<td GH="80 STD_G3_NUM24_REMS" GCol="text,NUM24_REMS" GF="N 80,0">30꼬마새우맛８０G(낱개)</td>	<!--30꼬마새우맛８０G(낱개)-->
				    						<td GH="80 STD_G3_NUM25_BOXS" GCol="text,NUM25_BOXS" GF="N 80,0">３０꼬마새우맛１００G(BOX)</td>	<!--３０꼬마새우맛１００G(BOX)-->
				    						<td GH="80 STD_G3_NUM25_REMS" GCol="text,NUM25_REMS" GF="N 80,0">３０꼬마새우맛１００G(낱개)</td>	<!--３０꼬마새우맛１００G(낱개)-->
				    						<td GH="80 STD_G3_NUM26_BOXS" GCol="text,NUM26_BOXS" GF="N 80,0">80G새우맛（돈지무）꼬마(BOX)</td>	<!--80G새우맛（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM26_REMS" GCol="text,NUM26_REMS" GF="N 80,0">80G새우맛（돈지무）꼬마(낱개)</td>	<!--80G새우맛（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM27_BOXS" GCol="text,NUM27_BOXS" GF="N 80,0">100G새우맛（돈지무）꼬마(BOX)</td>	<!--100G새우맛（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM27_REMS" GCol="text,NUM27_REMS" GF="N 80,0">100G새우맛（돈지무）꼬마(낱개)</td>	<!--100G새우맛（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM28_BOXS" GCol="text,NUM28_BOXS" GF="N 80,0">꼬마게맛20G(BOX)</td>	<!--꼬마게맛20G(BOX)-->
				    						<td GH="80 STD_G3_NUM28_REMS" GCol="text,NUM28_REMS" GF="N 80,0">꼬마게맛20G(낱개)</td>	<!--꼬마게맛20G(낱개)-->
				    						<td GH="80 STD_G3_NUM29_BOXS" GCol="text,NUM29_BOXS" GF="N 80,0">３０꼬마게맛８０G(BOX)</td>	<!--３０꼬마게맛８０G(BOX)-->
				    						<td GH="80 STD_G3_NUM29_REMS" GCol="text,NUM29_REMS" GF="N 80,0">３０꼬마게맛８０G(낱개)</td>	<!--３０꼬마게맛８０G(낱개)-->
				    						<td GH="80 STD_G3_NUM30_BOXS" GCol="text,NUM30_BOXS" GF="N 80,0">３０꼬마게맛１００G(BOX)</td>	<!--３０꼬마게맛１００G(BOX)-->
				    						<td GH="80 STD_G3_NUM30_REMS" GCol="text,NUM30_REMS" GF="N 80,0">３０꼬마게맛１００G(낱개)</td>	<!--３０꼬마게맛１００G(낱개)-->
				    						<td GH="80 STD_G3_NUM31_BOXS" GCol="text,NUM31_BOXS" GF="N 80,0">80G게맛（돈지무）꼬마장(BOX)</td>	<!--80G게맛（돈지무）꼬마장(BOX)-->
				    						<td GH="80 STD_G3_NUM31_REMS" GCol="text,NUM31_REMS" GF="N 80,0">80G게맛（돈지무）꼬마장(낱개)</td>	<!--80G게맛（돈지무）꼬마장(낱개)-->
				    						<td GH="80 STD_G3_NUM32_BOXS" GCol="text,NUM32_BOXS" GF="N 80,0">100G게맛（돈지무）꼬마(BOX)</td>	<!--100G게맛（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM32_REMS" GCol="text,NUM32_REMS" GF="N 80,0">100G게맛（돈지무）꼬마(낱개)</td>	<!--100G게맛（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM33_BOXS" GCol="text,NUM33_BOXS" GF="N 80,0">꼬마１０옥수수맛(BOX)</td>	<!--꼬마１０옥수수맛(BOX)-->
				    						<td GH="80 STD_G3_NUM33_REMS" GCol="text,NUM33_REMS" GF="N 80,0">꼬마１０옥수수맛(낱개)</td>	<!--꼬마１０옥수수맛(낱개)-->
				    						<td GH="80 STD_G3_NUM34_BOXS" GCol="text,NUM34_BOXS" GF="N 80,0">꼬마２０옥수수맛(BOX)</td>	<!--꼬마２０옥수수맛(BOX)-->
				    						<td GH="80 STD_G3_NUM34_REMS" GCol="text,NUM34_REMS" GF="N 80,0">꼬마２０옥수수맛(낱개)</td>	<!--꼬마２０옥수수맛(낱개)-->
				    						<td GH="80 STD_G3_NUM35_BOXS" GCol="text,NUM35_BOXS" GF="N 80,0">30꼬마옥수수８０G(BOX)</td>	<!--30꼬마옥수수８０G(BOX)-->
				    						<td GH="80 STD_G3_NUM35_REMS" GCol="text,NUM35_REMS" GF="N 80,0">30꼬마옥수수８０G(낱개)</td>	<!--30꼬마옥수수８０G(낱개)-->
				    						<td GH="80 STD_G3_NUM36_BOXS" GCol="text,NUM36_BOXS" GF="N 80,0">３０꼬마옥수수１００G(BOX)</td>	<!--３０꼬마옥수수１００G(BOX)-->
				    						<td GH="80 STD_G3_NUM36_REMS" GCol="text,NUM36_REMS" GF="N 80,0">３０꼬마옥수수１００G(낱개)</td>	<!--３０꼬마옥수수１００G(낱개)-->
				    						<td GH="80 STD_G3_NUM37_BOXS" GCol="text,NUM37_BOXS" GF="N 80,0">20G옥수수（돈지무）꼬마(BOX)</td>	<!--20G옥수수（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM37_REMS" GCol="text,NUM37_REMS" GF="N 80,0">20G옥수수（돈지무）꼬마(낱개)</td>	<!--20G옥수수（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM38_BOXS" GCol="text,NUM38_BOXS" GF="N 80,0">80G옥수수（돈지무）꼬마(BOX)</td>	<!--80G옥수수（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM38_REMS" GCol="text,NUM38_REMS" GF="N 80,0">80G옥수수（돈지무）꼬마(낱개)</td>	<!--80G옥수수（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM39_BOXS" GCol="text,NUM39_BOXS" GF="N 80,0">100G옥수수（돈지무）꼬마(BOX)</td>	<!--100G옥수수（돈지무）꼬마(BOX)-->
				    						<td GH="80 STD_G3_NUM39_REMS" GCol="text,NUM39_REMS" GF="N 80,0">100G옥수수（돈지무）꼬마(낱개)</td>	<!--100G옥수수（돈지무）꼬마(낱개)-->
				    						<td GH="80 STD_G3_NUM40_BOXS" GCol="text,NUM40_BOXS" GF="N 80,0">미국수출꼬마장사９０G(BOX)</td>	<!--미국수출꼬마장사９０G(BOX)-->
				    						<td GH="80 STD_G3_NUM40_REMS" GCol="text,NUM40_REMS" GF="N 80,0">미국수출꼬마장사９０G(낱개)</td>	<!--미국수출꼬마장사９０G(낱개)-->
				    						<td GH="80 STD_G3_NUM41_BOXS" GCol="text,NUM41_BOXS" GF="N 80,0">미국수출용꼬마장사３６０G(BOX)</td>	<!--미국수출용꼬마장사３６０G(BOX)-->
				    						<td GH="80 STD_G3_NUM41_REMS" GCol="text,NUM41_REMS" GF="N 80,0">미국수출용꼬마장사３６０G(낱개)</td>	<!--미국수출용꼬마장사３６０G(낱개)-->
				    						<td GH="80 STD_G3_NUM42_BOXS" GCol="text,NUM42_BOXS" GF="N 80,0">중국수출）뿌까마또르１０５G(BOX)</td>	<!--중국수출）뿌까마또르１０５G(BOX)-->
				    						<td GH="80 STD_G3_NUM42_REMS" GCol="text,NUM42_REMS" GF="N 80,0">중국수출）뿌까마또르１０５G(낱개)</td>	<!--중국수출）뿌까마또르１０５G(낱개)-->
				    						<td GH="80 STD_G3_NUM43_BOXS" GCol="text,NUM43_BOXS" GF="N 80,0">포도미노）뿌까플러스１０５(BOX)</td>	<!--포도미노）뿌까플러스１０５(BOX)-->
				    						<td GH="80 STD_G3_NUM43_REMS" GCol="text,NUM43_REMS" GF="N 80,0">포도미노）뿌까플러스１０５(낱개)</td>	<!--포도미노）뿌까플러스１０５(낱개)-->
				    						<td GH="80 STD_G3_NUM44_BOXS" GCol="text,NUM44_BOXS" GF="N 80,0">수출디즈니）뿌까플러스１２０(BOX)</td>	<!--수출디즈니）뿌까플러스１２０(BOX)-->
				    						<td GH="80 STD_G3_NUM44_REMS" GCol="text,NUM44_REMS" GF="N 80,0">수출디즈니）뿌까플러스１２０(낱개)</td>	<!--수출디즈니）뿌까플러스１２０(낱개)-->
				    						<td GH="80 STD_G3_NUM45_BOXS" GCol="text,NUM45_BOXS" GF="N 80,0">라이펀）뿌까플러스１０５０G(BOX)</td>	<!--라이펀）뿌까플러스１０５０G(BOX)-->
				    						<td GH="80 STD_G3_NUM45_REMS" GCol="text,NUM45_REMS" GF="N 80,0">라이펀）뿌까플러스１０５０G(낱개)</td>	<!--라이펀）뿌까플러스１０５０G(낱개)-->
				    						<td GH="80 STD_G3_NUM46_BOXS" GCol="text,NUM46_BOXS" GF="N 80,0">수출）포도미노뿌까플１０５０(BOX)</td>	<!--수출）포도미노뿌까플１０５０(BOX)-->
				    						<td GH="80 STD_G3_NUM46_REMS" GCol="text,NUM46_REMS" GF="N 80,0">수출）포도미노뿌까플１０５０(낱개)</td>	<!--수출）포도미노뿌까플１０５０(낱개)-->
				    						<td GH="80 STD_G3_NUM47_BOXS" GCol="text,NUM47_BOXS" GF="N 80,0">6)라이펀뿌까플러스１０５０G(BOX)</td>	<!--6)라이펀뿌까플러스１０５０G(BOX)-->
				    						<td GH="80 STD_G3_NUM47_REMS" GCol="text,NUM47_REMS" GF="N 80,0">6)라이펀뿌까플러스１０５０G(낱개)</td>	<!--6)라이펀뿌까플러스１０５０G(낱개)-->
				    						<td GH="80 STD_G3_NUM48_BOXS" GCol="text,NUM48_BOXS" GF="N 80,0">중문뿌까플러스１０５０(BOX)</td>	<!--중문뿌까플러스１０５０(BOX)-->
				    						<td GH="80 STD_G3_NUM48_REMS" GCol="text,NUM48_REMS" GF="N 80,0">중문뿌까플러스１０５０(낱개)</td>	<!--중문뿌까플러스１０５０(낱개)-->
				    						<td GH="80 STD_G3_NUM49_BOXS" GCol="text,NUM49_BOXS" GF="N 80,0">중국수출）뿌까마또르담백한맛(BOX)</td>	<!--중국수출）뿌까마또르담백한맛(BOX)-->
				    						<td GH="80 STD_G3_NUM49_REMS" GCol="text,NUM49_REMS" GF="N 80,0">중국수출）뿌까마또르담백한맛(낱개)</td>	<!--중국수출）뿌까마또르담백한맛(낱개)-->
				    						<td GH="80 STD_G3_NUM50_BOXS" GCol="text,NUM50_BOXS" GF="N 80,0">포도미노）크랩봉１０５G(BOX)</td>	<!--포도미노）크랩봉１０５G(BOX)-->
				    						<td GH="80 STD_G3_NUM50_REMS" GCol="text,NUM50_REMS" GF="N 80,0">포도미노）크랩봉１０５G(낱개)</td>	<!--포도미노）크랩봉１０５G(낱개)-->
				    						<td GH="80 STD_G3_NUM51_BOXS" GCol="text,NUM51_BOXS" GF="N 80,0">수출디즈니）크랩봉１２０(BOX)</td>	<!--수출디즈니）크랩봉１２０(BOX)-->
				    						<td GH="80 STD_G3_NUM51_REMS" GCol="text,NUM51_REMS" GF="N 80,0">수출디즈니）크랩봉１２０(낱개)</td>	<!--수출디즈니）크랩봉１２０(낱개)-->
				    						<td GH="80 STD_G3_NUM52_BOXS" GCol="text,NUM52_BOXS" GF="N 80,0">포도미노１０５０크랩봉(BOX)</td>	<!--포도미노１０５０크랩봉(BOX)-->
				    						<td GH="80 STD_G3_NUM52_REMS" GCol="text,NUM52_REMS" GF="N 80,0">포도미노１０５０크랩봉(낱개)</td>	<!--포도미노１０５０크랩봉(낱개)-->
				    						<td GH="80 STD_G3_NUM53_BOXS" GCol="text,NUM53_BOXS" GF="N 80,0">6)라이펀크랩봉１０５０G(BOX)</td>	<!--6)라이펀크랩봉１０５０G(BOX)-->
				    						<td GH="80 STD_G3_NUM53_REMS" GCol="text,NUM53_REMS" GF="N 80,0">6)라이펀크랩봉１０５０G(낱개)</td>	<!--6)라이펀크랩봉１０５０G(낱개)-->
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
					<div class="table_box section" id="tab1-4">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList4">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_DRCARNUM" GCol="text,CARNUM" GF="S 10"></td>	<!--배송코스-->
				    						<td GH="80 STD_PTNRKY1" GCol="text,PTNRTO" GF="S 10"></td>	<!--부서코드-->
				    						<td GH="120 STD_PTNRNM" GCol="text,PTNRTONM" GF="S 10"></td>	<!--거래처명-->
				    						<td GH="80 STD_G4_NUM01_BOXS" GCol="text,NUM01_BOXS" GF="N 80,0">(냉동）상천２．５KG (BOX)</td>	<!--(냉동）상천２．５KG (BOX)-->
				    						<td GH="80 STD_G4_NUM01_REMS" GCol="text,NUM01_REMS" GF="N 80,0">(냉동）상천２．５KG (낱개)</td>	<!--(냉동）상천２．５KG (낱개)-->
				    						<td GH="80 STD_G4_NUM02_BOXS" GCol="text,NUM02_BOXS" GF="N 80,0">(냉동)미니잡채어묵 (BOX)</td>	<!--(냉동)미니잡채어묵 (BOX)-->
				    						<td GH="80 STD_G4_NUM02_REMS" GCol="text,NUM02_REMS" GF="N 80,0">(냉동)미니잡채어묵 (낱개)</td>	<!--(냉동)미니잡채어묵 (낱개)-->
				    						<td GH="80 STD_G4_NUM03_BOXS" GCol="text,NUM03_BOXS" GF="N 80,0">(냉동)손봉 (BOX)</td>	<!--(냉동)손봉 (BOX)-->
				    						<td GH="80 STD_G4_NUM03_REMS" GCol="text,NUM03_REMS" GF="N 80,0">(냉동)손봉 (낱개)</td>	<!--(냉동)손봉 (낱개)-->
				    						<td GH="80 STD_G4_NUM04_BOXS" GCol="text,NUM04_BOXS" GF="N 80,0">(냉동)상천 (BOX)</td>	<!--(냉동)상천 (BOX)-->
				    						<td GH="80 STD_G4_NUM04_REMS" GCol="text,NUM04_REMS" GF="N 80,0">(냉동)상천 (낱개)</td>	<!--(냉동)상천 (낱개)-->
				    						<td GH="80 STD_G4_NUM05_BOXS" GCol="text,NUM05_BOXS" GF="N 80,0">(냉동)오치즈핫바 (BOX)</td>	<!--(냉동)오치즈핫바 (BOX)-->
				    						<td GH="80 STD_G4_NUM05_REMS" GCol="text,NUM05_REMS" GF="N 80,0">(냉동)오치즈핫바 (낱개)</td>	<!--(냉동)오치즈핫바 (낱개)-->
				    						<td GH="80 STD_G4_NUM06_BOXS" GCol="text,NUM06_BOXS" GF="N 80,0">(냉동)잡채어묵 (BOX)</td>	<!--(냉동)잡채어묵 (BOX)-->
				    						<td GH="80 STD_G4_NUM06_REMS" GCol="text,NUM06_REMS" GF="N 80,0">(냉동)잡채어묵 (낱개)</td>	<!--(냉동)잡채어묵 (낱개)-->
				    						<td GH="80 STD_G4_NUM07_BOXS" GCol="text,NUM07_BOXS" GF="N 80,0">(냉동)정미수제비 (BOX)</td>	<!--(냉동)정미수제비 (BOX)-->
				    						<td GH="80 STD_G4_NUM07_REMS" GCol="text,NUM07_REMS" GF="N 80,0">(냉동)정미수제비 (낱개)</td>	<!--(냉동)정미수제비 (낱개)-->
				    						<td GH="80 STD_G4_NUM08_BOXS" GCol="text,NUM08_BOXS" GF="N 80,0">(냉동)정미사각 (BOX)</td>	<!--(냉동)정미사각 (BOX)-->
				    						<td GH="80 STD_G4_NUM08_REMS" GCol="text,NUM08_REMS" GF="N 80,0">(냉동)정미사각 (낱개)</td>	<!--(냉동)정미사각 (낱개)-->
				    						<td GH="80 STD_G4_NUM09_BOXS" GCol="text,NUM09_BOXS" GF="N 80,0">고봉민사각어묵 (BOX)</td>	<!--고봉민사각어묵 (BOX)-->
				    						<td GH="80 STD_G4_NUM09_REMS" GCol="text,NUM09_REMS" GF="N 80,0">고봉민사각어묵 (낱개)</td>	<!--고봉민사각어묵 (낱개)-->
				    						<td GH="80 STD_G4_NUM10_BOXS" GCol="text,NUM10_BOXS" GF="N 80,0">(냉동)잡채어묵 (BOX)</td>	<!--(냉동)잡채어묵 (BOX)-->
				    						<td GH="80 STD_G4_NUM10_REMS" GCol="text,NUM10_REMS" GF="N 80,0">(냉동)잡채어묵 (낱개)</td>	<!--(냉동)잡채어묵 (낱개)-->
				    						<td GH="80 STD_G4_NUM11_BOXS" GCol="text,NUM11_BOXS" GF="N 80,0">오양숯불갈비맛소시지 (BOX)</td>	<!--오양숯불갈비맛소시지 (BOX)-->
				    						<td GH="80 STD_G4_NUM11_REMS" GCol="text,NUM11_REMS" GF="N 80,0">오양숯불갈비맛소시지 (낱개)</td>	<!--오양숯불갈비맛소시지 (낱개)-->
				    						<td GH="80 STD_G4_NUM12_BOXS" GCol="text,NUM12_BOXS" GF="N 80,0">오양청양고추소시지 (BOX)</td>	<!--오양청양고추소시지 (BOX)-->
				    						<td GH="80 STD_G4_NUM12_REMS" GCol="text,NUM12_REMS" GF="N 80,0">오양청양고추소시지 (낱개)</td>	<!--오양청양고추소시지 (낱개)-->
				    						<td GH="80 STD_G4_NUM13_BOXS" GCol="text,NUM13_BOXS" GF="N 80,0">오양옥수수콘소시지 (BOX)</td>	<!--오양옥수수콘소시지 (BOX)-->
				    						<td GH="80 STD_G4_NUM13_REMS" GCol="text,NUM13_REMS" GF="N 80,0">오양옥수수콘소시지 (낱개)</td>	<!--오양옥수수콘소시지 (낱개)-->
				    						<td GH="80 STD_G4_NUM14_BOXS" GCol="text,NUM14_BOXS" GF="N 80,0">모듬꼬치어묵 500G (BOX)</td>	<!--모듬꼬치어묵 500G (BOX)-->
				    						<td GH="80 STD_G4_NUM14_REMS" GCol="text,NUM14_REMS" GF="N 80,0">모듬꼬치어묵 500G (낱개)</td>	<!--모듬꼬치어묵 500G (낱개)-->
				    						<td GH="80 STD_G4_NUM15_BOXS" GCol="text,NUM15_BOXS" GF="N 80,0">모둠꼬치어묵 700G (BOX)</td>	<!--모둠꼬치어묵 700G (BOX)-->
				    						<td GH="80 STD_G4_NUM15_REMS" GCol="text,NUM15_REMS" GF="N 80,0">모둠꼬치어묵 700G (낱개)</td>	<!--모둠꼬치어묵 700G (낱개)-->
				    						<td GH="80 STD_G4_NUM16_BOXS" GCol="text,NUM16_BOXS" GF="N 80,0">종합모듬꼬치어묵 1000g (BOX)</td>	<!--종합모듬꼬치어묵 1000g (BOX)-->
				    						<td GH="80 STD_G4_NUM16_REMS" GCol="text,NUM16_REMS" GF="N 80,0">종합모듬꼬치어묵 1000g (낱개)</td>	<!--종합모듬꼬치어묵 1000g (낱개)-->
				    						<td GH="80 STD_G4_NUM17_BOXS" GCol="text,NUM17_BOXS" GF="N 80,0">해물바 (BOX)</td>	<!--해물바 (BOX)-->
				    						<td GH="80 STD_G4_NUM17_REMS" GCol="text,NUM17_REMS" GF="N 80,0">해물바 (낱개)</td>	<!--해물바 (낱개)-->
				    						<td GH="80 STD_G4_NUM18_BOXS" GCol="text,NUM18_BOXS" GF="N 80,0">해물바 (BOX)</td>	<!--해물바 (BOX)-->
				    						<td GH="80 STD_G4_NUM18_REMS" GCol="text,NUM18_REMS" GF="N 80,0">해물바 (낱개)</td>	<!--해물바 (낱개)-->
				    						<td GH="80 STD_G4_NUM19_BOXS" GCol="text,NUM19_BOXS" GF="N 80,0">고추맛바 (BOX)</td>	<!--고추맛바 (BOX)-->
				    						<td GH="80 STD_G4_NUM19_REMS" GCol="text,NUM19_REMS" GF="N 80,0">고추맛바 (낱개)</td>	<!--고추맛바 (낱개)-->
				    						<td GH="80 STD_G4_NUM20_BOXS" GCol="text,NUM20_BOXS" GF="N 80,0">일반맛살 (BOX)</td>	<!--일반맛살 (BOX)-->
				    						<td GH="80 STD_G4_NUM20_REMS" GCol="text,NUM20_REMS" GF="N 80,0">일반맛살 (낱개)</td>	<!--일반맛살 (낱개)-->
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