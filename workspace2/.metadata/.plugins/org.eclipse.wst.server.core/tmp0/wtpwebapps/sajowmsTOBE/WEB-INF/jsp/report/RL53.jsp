<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL53</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var module = 'Report';
var command = 'RL53';
var gridId = 'gridList';
var param = null;

	$(document).ready(function() {
		
		gridList.setGrid({
	    	id : gridId,
	    	module : module,
			command : command,
		    menuId : "RL53"
	    });
		
		uiList.setActive("Reload", false);
		

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	function linkPopCloseEvent(data) { //팝업 종료 
		if(data.get("TYPE") == "GET") { 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	
	
	// 버튼 클릭
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "RL53");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "RL53");
		} else if(btnName == "Search") {
			search();
		} else if(btnName == "Reload") {
			reload();
		}
	}// end commonBtnClick()
	
	// search(조회)
	function search() {
		if(validate.check('searchArea')) {
			param = inputList.setRangeParam('searchArea');
			gridList.gridList({
				id : gridId,
				param : param
			});				
		}

		uiList.setActive("Reload", true);
	} // end search()
	
	// 재조회
	function reload() {
		gridList.resetGrid(gridId);
		search();
	} // end reload()
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
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Reload RESET STD_REFLBL" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input">
								<option value="" ></option>
							</select>
						</dd>
					</dl>
		
					<dl>  <!-- 기준일자 -->  
						<dt CL="STD_STDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="stddat" UIInput="B" UIFormat="C N" validate="required"/> 
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
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>리스트</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_STDDAT" GCol="text,STDDAT" GF="S 10">기준일자</td>	<!--기준일자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WARENM" GF="S 10">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_ALLCNT" GCol="text,ALLCNT" GF="N 20,0">전체(제품별)</td>	<!--전체(제품별)-->
			    						<td GH="80 STD_SAMDAY" GCol="text,SHPQTY" GF="N 20,0">당일출고</td>	<!--당일출고-->
			    						<td GH="80 STD_SAMAFT" GCol="text,SHPQTY2" GF="N 20,0">당일이후출고</td>	<!--당일이후출고-->
			    						<td GH="80 STD_SHPPER" GCol="text,SHPPER" GF="S 20">당일출고율</td>	<!--당일출고율-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>    
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