<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL04</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL04",
		    menuId : "RL04"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});

	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL04");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL04");
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
    
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // skuma 화주 세팅
        if(searchCode == "SHSKUMA" && $inputObj.name == "A.SKUKEY"){
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHAREMA" && $inputObj.name == "WT.AREAKY"){
        	param.put("WAREKY","<%=wareky %>");
        }else if(searchCode == "SHZONMA" && $inputObj.name == "WT.ZONEKY"){
        	param.put("WAREKY","<%=wareky %>");
        }else if(searchCode == "SHLOCMA" && $inputObj.name == "SR,SHLOCMA"){
        	param.put("WAREKY","<%=wareky %>");
        }
    	return param;
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
					<!--  <input type="button" CB="Save SAVE BTN_SAVE" />-->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
		            <dl>
		              <dt CL="STD_OWNRKY"></dt>
		              <dd>
		                <select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            <dl>
		              <dt CL="STD_WAREKY"></dt>
		              <dd>
		                <select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.ZONEKY" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--생성일자-->  
						<dt CL="STD_CREDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.CREDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--입고문서번호-->  
						<dt CL="STD_RECVKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.RECVKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--조정문서번호-->  
						<dt CL="STD_SADJKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.SADJKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--재고조사번호-->  
						<dt CL="STD_PHYIKY"></dt> 
						<dd> 
							<input type="text" class="input" name="WT.PHYIKY" UIInput="SR"/> 
						</dd> 
					</dl> 
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02" id="tabs">
					<li><a href="#tab1-1"><span>연/월별</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_TRNHKY" GCol="text,TRNHKY" GF="S 10">물동 이력 키</td>	<!--물동 이력 키-->
			    						<td GH="80 STD_ITEMNO" GCol="text,ITEMNO" GF="S 6">LineNo.</td>	<!--LineNo.-->
			    						<td GH="80 STD_TRNHTY" GCol="text,TRNHTY" GF="S 4">물동타입</td>	<!--물동타입-->
			    						<td GH="80 STD_TASKTY" GCol="text,TASKTY" GF="S 4">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 4">화주</td>	<!--화주-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 180">규격</td>	<!--규격-->
			    						<td GH="80 STD_QTPROC" GCol="text,QTPROC" GF="N 17,0">처리수량</td>	<!--처리수량-->
			    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="80 STD_PURCKY" GCol="text,PURCKY" GF="S 10">구매오더 번호</td>	<!--구매오더 번호-->
			    						<td GH="80 STD_PURCIT" GCol="text,PURCIT" GF="S 10">구매오더 아이템번호</td>	<!--구매오더 아이템번호-->
			    						<td GH="80 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="80 STD_ASNDIT" GCol="text,ASNDIT" GF="S 10">ASN It.</td>	<!--ASN It.-->
			    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="80 STD_RECVIT" GCol="text,RECVIT" GF="S 10">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 10">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_GRPOKY" GCol="text,GRPOKY" GF="S 10">제품별피킹번호</td>	<!--제품별피킹번호-->
			    						<td GH="80 STD_GRPOIT" GCol="text,GRPOIT" GF="S 10">제품별피킹Item</td>	<!--제품별피킹Item-->
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_TASKIT" GCol="text,TASKIT" GF="S 10">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="80 STD_SADJIT" GCol="text,SADJIT" GF="S 20">조정 Item</td>	<!--조정 Item-->
			    						<td GH="80 STD_PHYIKY" GCol="text,PHYIKY" GF="S 20">재고조사번호</td>	<!--재고조사번호-->
			    						<td GH="80 STD_PHYIIT" GCol="text,PHYIIT" GF="S 20">재고조사item</td>	<!--재고조사item-->
			    						<td GH="80 STD_SMANDT" GCol="text,SMANDT" GF="S 20">Client</td>	<!--Client-->
			    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="80 STD_SEBELP" GCol="text,SEBELP" GF="S 20">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="80 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 10">B/L NO</td>	<!--B/L NO-->
			    						<td GH="80 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 10">B/L Item NO</td>	<!--B/L Item NO-->
			    						<td GH="80 STD_STRAID" GCol="text,STRAID" GF="S 10">SCM주문번호</td>	<!--SCM주문번호-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 20">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_STKNUM" GCol="text,STKNUM" GF="S 10">토탈계획번호</td>	<!--토탈계획번호-->
			    						<td GH="80 STD_STPNUM" GCol="text,STPNUM" GF="S 10">예약 It</td>	<!--예약 It-->
			    						<td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td>	<!--출발지-->
			    						<td GH="80 STD_SLGORT" GCol="text,SLGORT" GF="S 10">영업 부문</td>	<!--영업 부문-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 100">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 100">수정자명</td>	<!--수정자명-->
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