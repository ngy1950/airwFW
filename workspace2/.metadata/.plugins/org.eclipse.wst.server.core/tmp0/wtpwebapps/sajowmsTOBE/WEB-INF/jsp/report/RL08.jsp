<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL08</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var selectIdx = "0";
	var selectGrid = "gridList1";

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL08_01",
		    menuId : "RL08"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Report",
			command : "RL08_02",
		    menuId : "RL08"
	    });
		
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
			
			/*
			if(WiseView.GetControlById("io1floor1").value == true){
				setXmlParam(cmd, "HANDINC", "TRUE");
			}else{
				setXmlParam(cmd, "HANDINC", "FALSE");
			}
			*/
			if ($('#INCLUS').prop("checked") == true ) {
				param.put("includeYN","Y");
			}else if ($('#NOTINC').prop("checked") == true ){
				param.put("includeYN","N");
			}
			
			switch (selectIdx){
				case 0:
					selectGrid = "gridList1";
					break;
				case 1:
					selectGrid = "gridList2";
					break;
			}
			gridList.resetGrid(selectGrid);
			gridList.gridList({
		    	id : selectGrid,
		    	param : param
		    });
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL08");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL08");
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
        if(searchCode == "SHSKUMA" && $inputObj.name == "SM.SKUKEY"){
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
							<input type="text" class="input" name="ZN.AREAKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="ZN.ZONEKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>
						<dt CL="STD_1FLOOR"></dt><!-- DAS파일 생성 양식 -->
						<dd style="width:300px">
							<input type="radio" name="includeYN" id="INCLUS" checked /><label for="INCLUS">포함</label>
		        			<input type="radio" name="includeYN" id="NOTINC" /><label for="NOTINC">미포함</label>
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li><a href="#tab1-1"><span>빈로케이션</span></a></li>
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
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_AREAKYNM" GCol="text,AREAKYNM" GF="S 100">동명</td>	<!--동명-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="80 STD_STKLOC" GCol="text,STKLOC" GF="N 17,0">재고로케이션수</td>	<!--재고로케이션수-->
			    						<td GH="80 STD_LOCCNT" GCol="text,LOCCNT" GF="N 17,0">전체로케이션수</td>	<!--전체로케이션수-->
			    						<td GH="80 STD_EMPLOC" GCol="text,EMPLOC" GF="N 17,0">빈로케이션수</td>	<!--빈로케이션수-->
			    						<td GH="80 STD_PERCNT" GCol="text,PERCNT" GF="S 100">PERCNT</td>	<!--PERCNT-->
			    						<td GH="80 STD_SKUCNT" GCol="text,SKUCNT" GF="N 17,0">품목수</td>	<!--품목수-->
			    						<td GH="80 STD_STKCNT" GCol="text,STKCNT" GF="N 17,0">재고수</td>	<!--재고수-->
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
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 10">로케이션</td>	<!--로케이션-->
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