<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TO40</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "taskOrder",
			command : "TO40_HEAD", 
			pkcol : "TASKKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "TO40"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "TO40_ITEM" ,
			pkcol : "TASKKY",
		    menuId : "TO40"
	    });
		gridList.setReadOnly("gridItemList", true, ["RSNCOD","LOTA05","LOTA06"]);
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "331");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "332");
		rangeArr.push(rangeDataMap); 
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "333");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "334");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "335");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "380");
		rangeArr.push(rangeDataMap);  
		
		setSingleRangeData('TASDH.TASOTY', rangeArr); 
		
		//배열선언
		var rangeArr2 = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap2 = new DataMap();
		// 필수값 입력
		rangeDataMap2.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		//배열에 맵 탑제 
		rangeArr2.push(rangeDataMap2);
	 	
		rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		rangeArr2.push(rangeDataMap2); 
		
		rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "FPC");
		rangeArr2.push(rangeDataMap2); 
		
		setSingleRangeData('TASDH.STATDO', rangeArr2); 

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>")

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);	
			
			//var param = inputList.setRangeDataParam("searchArea");
			var head = gridList.getGridData("gridHeadList");
			var param = new DataMap();
			param.put("head",head);
			
			
			netUtil.send({
				url : "/taskOrder/json/displayTO40Item.data",
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
		
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if (btnName == "Print") {		/* 거래명세표 */
			Print()
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TO40");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "TO40");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
		
	function Print(){
		var count = 0;
		var ownrky = $('#OWNRKY').val();
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";  
			
			for(var i =0;i < head.length ; i++){
				if(wherestr == ""){
					wherestr = wherestr+" AND H.TASKKY IN (";
				}else{
					wherestr = wherestr+",";
				}
				
				wherestr += "'" + head[i].get("TASKKY") + "'";
			}
			wherestr += ")";
					
			var langKy = "KO";
			var width = 840;
			var heigth = 540;
			var map = new DataMap();
			
			WriteEZgenElement("/ezgen/task_picking_list.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	    
		//작업타입
		if(searchCode == "SHDOCTM" && $inputObj.name == "TASDH.TASOTY"){
	    	param.put("DOCCAT","300");
		//제품코드
		}else if(searchCode == "SHSKUMA"){
			 param.put("WAREKY",$("#WAREKY").val());
		     param.put("OWNRKY",$("#OWNRKY").val());
		}return param;
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
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" /></div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print PRINT_OUT STD_PRINT_PICK" />	<!-- 피킹리스트 인쇄 -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASOTY" UIInput="SR,SHDOCTM" readonly /> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.STATDO" UIInput="SR,SHVSTATDO" readonly /> 
						</dd> 
					</dl> 
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.DESC01" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10"></td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>	<!--거점-->
			    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100"></td>	<!--거점명-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0"></td>	<!--작업타입-->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100"></td>	<!--작업타입명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8"></td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0"></td>	<!--문서유형-->
			    						<td GH="100 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100"></td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4"></td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100"></td>	<!--문서상태명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8"></td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8"></td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60"></td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60"></td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60"></td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60"></td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60"></td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60"></td>	<!--수정자명-->
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_TASKTY" GCol="text,TASKTY" GF="S 3"></td>	<!--작업타입-->
			    						<td GH="120 STD_RSNCOD" GCol="select,RSNCOD">	<!--사유코드-->
			    							<select class="input" Combo="taskOrder,COMBO_RSNCOD_ETC"></select>
		                                </td>
			    						<td GH="160 STD_TASRSN" GCol="text,TASRSN" GF="S 127"></td>	<!--상세사유-->
			    						<td GH="88 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0"></td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0"></td>	<!--완료수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>	<!--화주-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60"></td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60"></td>	<!--규격-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20"></td>	<!--로케이션-->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10"></td>	<!--단위구성-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3"></td>	<!--단위-->
			    						<td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11"></td>	<!--기본UPM-->
			    						<td GH="80 STD_LOCATG" GCol="text,LOCATG" GF="S 20"></td>	<!--To 로케이션-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10"></td>	<!--대분류-->
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11"></td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11"></td>	<!--순중량-->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3"></td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11"></td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11"></td>	<!--가로길이-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11"></td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11"></td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11"></td>	<!--CAPA-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20"></td>	<!--벤더-->
			    						<td GH="80 STD_LOTA03NM" GCol="text,LOTA03NM">	<!--벤더명-->
			    						<td GH="100 STD_LOTA05" GCol="select,LOTA05">	<!--포장구분-->
			    							<select class="input" CommonCombo="LOTA05"></select>
										</td>
			    						<td GH="100 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
			    							<select class="input" CommonCombo="LOTA06"></select>
										</td>
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14"></td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14"></td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14"></td>	<!--유통기한-->
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10"></td>	<!--동-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" ></td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" ></td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1"></td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2"></td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0"></td>	<!--잔량-->
			    						<td GH="80 STD_QTYFCN" GCol="text,GTYFCN" GF="N 17,0"></td>	<!--취소수량-->
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