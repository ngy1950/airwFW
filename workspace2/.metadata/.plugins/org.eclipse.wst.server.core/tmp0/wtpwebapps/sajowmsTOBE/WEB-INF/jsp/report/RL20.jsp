<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL20</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Report", 
			command : "RL20_HEADER",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "RL20"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Report",
			command : "RL20_ITEM",
		    colorType : true ,
		    menuId : "RL20"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		 
		
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
// 		$("input[name=SR.cardat]").datepicker("setDate","+1D");
// 		var obj = $("input[name='SR.cardat']");
		
// 		var date = new Date();
// 		date.setDate(date.getDate()+2);
// 		//$('input[name=SR.cardat]').datepicker( "option", "minDate",date);
		
		//콤보박스 리드온리
		/* gridList.setReadOnly("gridHeadList", true, ["WAREKY" , "OWNRKY", "C00103", "DOCUTY", "STATUS", "WARESR", "PTNG06"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY" , "QTYREQ", "C00103"]); */
	});
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL20");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL20");
 		}

	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
         
		if(searchCode == "SHDOCTM" && $inputObj.name == "SH.SHPMTY"){
        	param.put("DOCCAT","200");
        }else if(searchCode == "SHVSTATDO" && $inputObj.name == "SH.STATDO"){
     		//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    	 	
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PAL");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PAP");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "FAL");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "A&P");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PPP");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "FPC");
    		rangeArr.push(rangeDataMap); 
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "P&P");
    		rangeArr.push(rangeDataMap); 
            param.put("CMCDVL", returnSingleRangeDataArr(rangeArr));
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
        	param.put("PTNRTY","PTNL05");
        	<%-- param.put("CT","<%=werks%>"); --%>
        }else if(searchCode == "SHSKUMA" && $inputObj.name == "SI.SKUKEY"){
        	param.put("WAREKY","<%=wareky%>");
        	param.put("OWNRKY","<%=ownrky%>");
        	param.put("SKUG01","002");
        }
        
    	return param;
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
						<input type="button" CB="Search SEARCH STD_SEARCH" /> <input
							type="button" CB="Save SAVE BTN_SAVE" /> <input type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl><!--거점-->
			              <dt CL="STD_WAREKY"></dt>
			              <dd>
			                <select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="true"></select>
			              </dd>
			            </dl>
						<dl>  <!--출고유형-->  
							<dt CL="STD_SHPMTY"></dt> 
							<dd> 
								<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="SI.SHPOKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--문서일자-->  
							<dt CL="STD_DOCDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--문서상태-->  
							<dt CL="STD_STATDO"></dt> 
							<dd> 
								<input type="text" class="input" name="SH.STATDO" UIInput="SR,SHVSTATDO"/> 
							</dd> 
						</dl> 
						<dl>  <!--업체코드-->  
							<dt CL="STD_DPTNKY"></dt> 
							<dd> 
								<input type="text" class="input" name="SH.DPTNKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SI.SKUKEY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송일자-->  
							<dt CL="STD_CARDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C" /> 
							</dd> 
						</dl> 
						<dl>  <!--배송차수-->  
							<dt CL="STD_SHIPSQ"></dt> 
							<dd> 
								<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="SR.CARNUM" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--S/O 번호-->  
							<dt CL="STD_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="SI.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--토탈계획번호-->  
							<dt CL="STD_STKNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="SI.STKNUM" UIInput="SR"/> 
							</dd> 
						</dl> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
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
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="50 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
			    						<td GH="85 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
			    						<td GH="50 STD_DOCSEQ" GCol="text,DOCSEQ" GF="S 12">거래명세표출력번호</td>	<!--거래명세표출력번호-->
			    						<td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="50 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_ALCCFM" GCol="text,DRELIN" GF="S 1">주문수량전송여부</td>	<!--주문수량전송여부-->
			    						<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="50 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="50 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="50 STD_DEDAT" GCol="text,OPURKY" GF="D 8">도착일자</td>	<!--도착일자-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="70 STD_SHIPTO" GCol="text,DPTNKY" GF="S 10">거래처/요청거점</td>	<!--거래처/요청거점-->
			    						<td GH="80 STD_SHIPTONM" GCol="text,DPTNKYNM" GF="S 30">납품처명</td>	<!--납품처명-->
			    						<td GH="50 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_STKNUM" GCol="text,STKNUM" GF="S 0">토탈계획번호</td>	<!--토탈계획번호-->
			    						<td GH="80 STD_PGRC01" GCol="text,PGRC01" GF="S 20">권역</td>	<!--권역-->
			    						<td GH="80 STD_PGRC03" GCol="text,PGRC03" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 20">주문부서</td>	<!--주문부서-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td>	<!--수정자명-->
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
					<li><a href="#tab1-1" ><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						<input type="checkbox" id="warechk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_WAREKY" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="WARECOMBO" id="WARECOMBO"  class="input" Combo="SajoCommon,SEARCH_WAREKY_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 사유코드 -->
						<input type="checkbox" id="rsnchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_C00103" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RSNCOMBO" id="RSNCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX">
						<input type="checkbox" id="qtychk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;">수량적용</span>
						<input type="text" id="INPUTQTY" name="INPUTQTY"  UIInput="I"  class="input"/>
					</li>
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> <!-- 일괄적용 -->
						<input type="button" CB="SetAll SAVE BTN_ALL" /> 
					</li>
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
						<input type="button" CB="SetChk SAVE BTN_PART" />
					</li>
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
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="N 6,0">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_STATIT" GCol="text,STATITNM" GF="S 20">상태</td>	<!--상태-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="70 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="70 STD_QTUALO" GCol="text,QTALLM" GF="N 20,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="70 STD_PKCMPL" GCol="text,QTJCMP" GF="N 20,0">피킹완료수량</td>	<!--피킹완료수량-->
			    						<td GH="70 STD_SHCMPL" GCol="text,QTSHPD" GF="N 20,0">출고확정수량</td>	<!--출고확정수량-->
			    						<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 20">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="S 20">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="S 20">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="S 20">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="S 20">총CBM</td>	<!--총CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="S 20">CAPA</td>	<!--CAPA-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td>	<!--재배차 여부-->
			    						<td GH="50 STD_QTYFCNM" GCol="text,QTYREF" GF="N 17,0">배송회수처리수량</td>	<!--배송회수처리수량-->
			    						<td GH="50 STD_QTYFCN" GCol="text,QTSHPC" GF="N 17,0">취소수량</td>	<!--취소수량-->
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
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>