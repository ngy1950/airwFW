<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HP22</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Report",
			command : "HP22"
			//pkcol : "COMPKY,PTNRKY,PTNRTY"
	    });

	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			
			netUtil.send({
				url : "/Report/json/displayHP22.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
			
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "HP22");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "HP22");
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

	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            
            return newData;
    	}
    }
    
    
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // skuma 화주 세팅
        if(searchCode == "SHSKUMA" && $inputObj.name == "A.SKUKEY"){
            param.put("OWNRKY","<%=ownrky %>");
        }
        
    	return param;
    }
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
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
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--문서일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARDAT" UIInput="D" UIFormat="C N"  validate="required"/> 
						</dd> 
					</dl> 
					
		            <dl>  <!--차량번호-->  
		              <dt CL="STD_CARNUM"></dt>
		              <dd> 
		                <input type="text" class="input" name="CARNUM" UIInput="SR,SHCARMA2"/> 
		              </dd> 
		            </dl>
		            <dl>  <!--차량 구분-->  
		              <dt CL="STD_CARGBN"></dt> 
		              <dd> 
		                  <select name="CARGBN" id="CARGBN" class="input" comboType="MS" CommonCombo="CARGBN"></select> 
		              </dd> 
		            </dl> 
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
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
								<tbody id="gridList">
									<tr CGRow="true">                                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 ITF_DELVDT" GCol="text,DELVDT" GF="D 20">주문일자</td>	<!--주문일자-->
			    						<td GH="80 ITF_SLIPNO" GCol="text,SLIPNO" GF="S 20">주문번호</td>	<!--주문번호-->
			    						<td GH="80 IFT_DELVGUBUN" GCol="text,DELVGUBUN" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="100 STD_CARGBN" GCol="text,CARGBN" GF="S 20">차량구분</td>	<!--차량구분-->
			    						<td GH="80 HP_CARID1" GCol="text,CARID1" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="80 HP_SALECD2" GCol="text,SALECD" GF="S 20">거래처코드</td>	<!--거래처코드-->
			    						<td GH="120 HP_SALNM2" GCol="text,SALNM" GF="S 20">거래처명</td>	<!--거래처명-->
			    						<td GH="60 HP_TRANSBOX" GCol="text,TRANSBOX" GF="N 20,0">수량</td>	<!--수량-->
			    						<td GH="80 HP_TRANSGUB" GCol="text,TRANSGUB" GF="S 20">주문구분코드</td>	<!--주문구분코드-->
			    						<td GH="80 HP_GUBNAME" GCol="text,GUBNAME" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="80 HP_TRANSSTS" GCol="text,TRANSSTS" GF="S 20">주문상태코드</td>	<!--주문상태코드-->
			    						<td GH="80 HP_STSNAME" GCol="text,STSNAME" GF="S 20">주문상태</td>	<!--주문상태-->
			    						<td GH="100 HP_TRANSPRETIME" GCol="text,TRANSPRETIME" GF="S 20">예정시간</td>	<!--예정시간-->
			    						<td GH="100 HP_TRANSAFTTIME" GCol="text,TRANSAFTTIME" GF="S 20">출발시간</td>	<!--출발시간-->
			    						<td GH="100 HP_TRANSSTRTIME" GCol="text,TRANSSTRTIME" GF="S 20">도착시간</td>	<!--도착시간-->
			    						<td GH="100 HP_PRESMSYN" GCol="text,PRESMSYN" GF="S 20">예정SMS</td>	<!--예정SMS-->
			    						<td GH="100 HP_AFTSMSYN" GCol="text,AFTSMSYN" GF="S 20">출발SMS</td>	<!--출발SMS-->
			    						<td GH="100 HP_STSSMSYN" GCol="text,STSSMSYN" GF="S 20">도착SMS</td>	<!--도착SMS-->
			    						<td GH="250 HP_RMK" GCol="text,RMK" GF="S 50">비고</td>	<!--비고-->
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
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
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