<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL07</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var selectIdx = 0;
	var selectGrid = "gridList1";
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL07_01",
		    menuId : "RL07"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Report",
			command : "RL07_02",
		    menuId : "RL07"
	    });
		
		gridList.setGrid({
	    	id : "gridList3",
	    	module : "Report",
			command : "RL07_03",
		    menuId : "RL07"
	    });
		
		//aria-selected="true"
		//body > div.content_wrap > div > div.search_next_wrap.searchRow2 > div > ul > li.ui-state-default.ui-corner-top.ui-tabs-active.ui-state-active
		var tabs = $("#tabs > li.ui-corner-top");
		tabs.click(function(event){
			var idx = tabs.index(this);
			selectIdx = idx;
			searchList();
		});
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var goUrl = "";
			
			//aria-selected="true"
			switch (selectIdx){
				case 0:
					selectGrid = "gridList1";
					goUrl = "/Report/json/RL07_01.data";
					break;
				case 1:
					selectGrid = "gridList2";
					goUrl = "/Report/json/RL07_02.data";
					break;
				case 2:
					selectGrid = "gridList3";
					goUrl = "/Report/json/RL07_03.data";
					break;
			}
			
			netUtil.send({
				url : goUrl,
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : selectGrid //그리드ID
			});
			 
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL07");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL07");
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
					<dl>  <!--생성일자-->  
						<dt CL="STD_CREDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="RI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="RI.DESC01" UIInput="SR"/> 
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
					<li><a href="#tab1-1"><span>입고</span></a></li>
					<li><a href="#tab1-2"><span>출고</span></a></li>
					<li><a href="#tab1-3"><span>재고</span></a></li>
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
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="80 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_RCPTTY" GCol="text,SHORTX" GF="S 20">입고유형</td>	<!--입고유형-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 80">업체명</td>	<!--업체명-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 80">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 80">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 80">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 80">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="80 STD_SEBELP" GCol="text,SEBELP" GF="S 80">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="80 STD_QTYRCV" GCol="text,QTYRCV" GF="N 80,0">입고수량</td>	<!--입고수량-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 80">단위</td>	<!--단위-->
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
				
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList2">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 10">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_SHPMTY" GCol="text,SHPMTY" GF="S 10">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHORTX" GF="S 10">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_SHPOIT" GCol="text,DPTNKYNM" GF="S 20">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 10">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 80">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 10">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 10,0">지시수량</td>	<!--지시수량-->
			    						<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 10,0">할당수량</td>	<!--할당수량-->
			    						<td GH="80 STD_QTJCMP" GCol="text,QTJCMP" GF="N 10,0">완료수량</td>	<!--완료수량-->
			    						<td GH="80 STD_QTSHPD" GCol="text,QTSHPD" GF="N 10,0">출고수량</td>	<!--출고수량-->
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
				
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList3">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 20">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="80 STD_SADJIT" GCol="text,SADJIT" GF="S 20">조정 Item</td>	<!--조정 Item-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 20">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,NAME01" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_ADJUTY" GCol="text,ADJUTY" GF="S 20">조정문서 유형</td>	<!--조정문서 유형-->
			    						<td GH="80 STD_ADJUTYNM" GCol="text,SHORTX" GF="S 20">유형명</td>	<!--유형명-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 20">단위</td>	<!--단위-->
			    						<td GH="80 STD_QTADJU" GCol="text,QTADJU" GF="N 20,0">조정수량</td>	<!--조정수량-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
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