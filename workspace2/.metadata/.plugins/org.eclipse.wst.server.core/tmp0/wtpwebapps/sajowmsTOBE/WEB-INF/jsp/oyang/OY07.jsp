<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){

		gridList.setGrid({
	    	id : "gridList1",
			module : "OyangOutbound",
			command : "OY07",
		    colorType : true ,
		    menuId : "OY07"
	    });

		gridList.setGrid({
	    	id : "gridList2",
			module : "OyangOutbound",
			command : "OY07_02",
		    colorType : true ,
		    menuId : "OY07"
	    });
		
		//로케이션별
		gridList.setGrid({
	    	id : "gridList3",
			module : "OyangOutbound",
			command : "OY07_03",
		    colorType : true ,
		    menuId : "OY07"
	    });
		gridList.setReadOnly("gridList1", true, ["SKUG03"]);
		gridList.setReadOnly("gridList2", true, ["SKUG03"]);
		gridList.setReadOnly("gridList3", true, ["SKUG03"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			$('#atab1-1').trigger("click");
			gridList.resetGrid("gridList1");
			gridList.resetGrid("gridList2");
			gridList.resetGrid("gridList3");
			searchList("gridList1");
		}else if (btnName == "Sync") {
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY07");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OY07");
		} 
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//조회
	function searchList(gridId, param){
		if(!param){ 
			param = inputList.setRangeParam("searchArea");
		}
		
		if(gridId == 'gridList1' || gridId == 'gridList2'){
			//STDDAT from 값 
			if(inputList.rangeMap.map['STDDAT'].singleData[0] == null){ //기준일자가 렌지일떄
				var stddat = inputList.rangeMap.map['STDDAT'].rangeData[0].map.FROM;
			}else{ //기준일자가 싱글데이터일때
				var stddat = inputList.rangeMap.map['STDDAT'].singleData[0].map.DATA;
			}
			param.put("STDDAT",stddat);
		}
		
		param.put("GRIDID",gridId);

		if($("#CHKMAK").prop("checked") == true) param.put("CHKMAK", "V");
// 		gridList.gridList({
// 			id : gridId,
// 		   	param : param
// 		});
		netUtil.send({
			url : "/OyangOutbound/json/displayOY07.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : gridId //그리드ID
		});
	}


	//저장
	function saveData() {
		var param = inputList.setRangeParam("searchArea");
		netUtil.send({
			url : "/OyangOutbound/json/saveOY06.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			commonUtil.msgBox("SYSTEM_SAVEOK");
			$('#atab1-1').trigger("click");
			searchList("gridList1");
		}
	}

	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}
		
		return param;
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList1"){
			param = inputList.setRangeParam("searchArea");
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, "SKUKEY"));
			searchList("gridList2", param);
			$("#atab1-2").trigger('click');
		}else if(gridId == "gridList2"){
			param = inputList.setRangeParam("searchArea");
			param.put("STDDAT", gridList.getColData(gridId, rowNum, "VMONTH"));
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, "SKUKEY"));
			searchList("gridList3", param);
			$("#atab1-3").trigger('click');
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHAREMA" && $inputObj.name == "S.AREAKY"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHZONMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("USARG1",$('#OWNRKY').val());
        } 
        
    	return param;
    }
	
    //텝이동시 작동
    function moveTab(obj){
    	//var tabNm = obj.attr('href');
    	//var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
    	//
		//if(validate.check("searchArea")){
		//	gridList.resetGrid(gridId);
		//	var param = inputList.setRangeParam("searchArea");
        //
		//	gridList.gridList({
		//    	id : gridId,
		//    	param : param
		//    });
		//}
	}
    
	// grid row background color 변경.
	function  gridListRowBgColorChange(gridId, rowNum, rowData) {
		var gid = gridList.getColData(gridId, rowNum, "GID");
		if(gid == "0000011" || gid ==  "001111"|| gid ==  "001111"){
			return configData.GRID_COLOR_BG_YELLOW_CLASS2;
		}
	} // end gridListColBgColorChange()

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
						<input type="button" CB="Sync SAVE STD_SYNC2" /> 
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
								<select name="WAREKY" id="WAREKY"  class="input"  ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--입/출고실적만 조회 -->  
							<dt CL="STD_INOUTSC"></dt> 
							<dd> 
								<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" checked/>
							</dd> 
						</dl>
						<dl>  <!--기준일자-->  
							<dt CL="STD_STDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="STDDAT" id="STDDAT" UIInput="B" UIFormat="C N" validate="required(STD_STDDAT)"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분-->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류-->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV"/> 
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
						<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1">전체</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">월별</span></a></li>
						<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">일별</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">                                     
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_RATENM" GCol="select,SKUG03">
												<select class="input" commonCombo="SKUG03"><option></option></select>
											</td>	<!--등급명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_BXIQTY" GCol="text,QTDUOM" GF="N 20,0">박스입수</td>	<!--박스입수-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_LOQTY2" GCol="text,ADJQTY" GF="N 20,0">기타수량</td>	<!--기타수량-->
				    						<td GH="80 STD_DAYQTY" GCol="text,STKQTY" GF="N 20,0">당일재고</td>	<!--당일재고-->
				    						<td GH="80 STD_DAYQTY_BOX" GCol="text,STKBOX" GF="N 20,1">당일재고(BOX)</td>	<!--당일재고(BOX)-->
				    						<td GH="80 STD_DAYQTY_REM" GCol="text,STKREM" GF="N 20,0">당일재고(REM)</td>	<!--당일재고(REM)-->
				    						<td GH="80 STD_QTSIWH_SD01" GCol="text,QTSIWH" GF="N 20,0">현재고(SD01)</td>	<!--현재고(SD01)-->
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
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">                   
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_MONTH" GCol="text,VMONTH" GF="S 20">월</td>	<!--월-->
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_RATENM" GCol="select,SKUG03">
												<select class="input" commonCombo="SKUG03"><option></option></select>
											</td>	<!--등급명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_LOQTY2" GCol="text,ADJQTY" GF="N 20,0">기타수량</td>	<!--기타수량-->
    										<td GH="80 STD_DAYQTY" GCol="text,STKQTY" GF="N 20,0">당일재고</td>	<!--당일재고-->
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
				    						<td GH="80 STD_DAY" GCol="text,VDAY" GF="S 20">일</td>	<!--일-->
				    						<td GH="80 ITF_WAREKY" GCol="text,WAREKY" GF="S 20">거점코드</td>	<!--거점코드-->
				    						<td GH="120 STD_WANAME" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
				    						<td GH="80 STD_RATENM" GCol="select,SKUG03">
												<select class="input" commonCombo="SKUG03"><option></option></select>
											</td>	<!--등급명-->
				    						<td GH="80 STD_BXIQTY" GCol="text,QTDUOM" GF="N 20,0">박스입수</td>	<!--박스입수-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="180 STD_DESC01" GCol="text,DESC01" GF="S 30">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 20">규격</td>	<!--규격-->
				    						<td GH="80 STD_STDQTY" GCol="text,STDQTY" GF="N 20,0">전일재고</td>	<!--전일재고-->
				    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 20,0">입고수량</td>	<!--입고수량-->
				    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 20,0">출고수량</td>	<!--출고수량-->
				    						<td GH="80 STD_LOQTY2" GCol="text,ADJQTY" GF="N 20,0">기타수량</td>	<!--기타수량-->
				    						<td GH="80 STD_DAYQTY" GCol="text,STKQTY" GF="N 20,0">당일재고</td>	<!--당일재고-->
				    						<td GH="80 STD_DAYQTY_BOX" GCol="text,STKBOX" GF="N 20,1">당일재고(BOX)</td>	<!--당일재고(BOX)-->
				    						<td GH="80 STD_DAYQTY_REM" GCol="text,STKREM" GF="N 20,0">당일재고(REM)</td>	<!--당일재고(REM)-->
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