<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YP02</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "YP02",
			pkcol : "LOG_ID",
		    menuId : "YP02"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "YP02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "YP02");
 		}
	}

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
			}
		}
	}


	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList"){
			var newData = new DataMap();
			newData.put("COMPID","<%=compky%>");
			return newData;
		}
	}
	
	//팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    	sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_OWNRKY)"></select>
						</dd>
					</dl>
					<dl>  <!-- 프로그램ID 검색 -->  
						<dt CL="SHTIT_SHPROGM"></dt> 
						<dd> 
							<input type="text" class="input" name="LOGPGM" UIInput="S,SHPROGM"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 사용자ID -->  
						<dt CL="STD_USERID"></dt> 
						<dd> 
							<input type="text" class="input" name="LOGUSER" UIInput="S,SHUSRMA"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 기준일자 -->  
						<dt CL="STD_STDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="LOGDATE" UIInput="B" UIFormat="C N"/> 
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="100 ITF_SEQNO" GCol="text,LOGID" GF="N 30">시퀀스번호</td>	<!--시퀀스번호-->
			    						<td GH="100 STD_LOGDATE" GCol="text,LOGDATE" GF="D 8">접근일자</td>	<!--접근일자-->
			    						<td GH="100 STD_LOGTIME" GCol="text,LOGTIME" GF="T 6">접근시간</td>	<!--접근시간-->
			    						<td GH="100 STD_LOGUSER" GCol="text,LOGUSER" GF="S 20">접근 계정</td>	<!--접근 계정-->
			    						<td GH="100 STD_LOGGUBUN" GCol="text,LOGGUBUN" GF="S 20">프로그램액션</td>	<!--프로그램액션-->
			    						<td GH="100 STD_LOGCMP" GCol="text,LOGCMP" GF="S 20">접근회사</td>	<!--접근회사-->
			    						<td GH="100 STD_LOGDD" GCol="text,LOGDD" GF="S 20">시스템</td>	<!--시스템-->
			    						<td GH="220 STD_LOGPGM" GCol="text,LOGPGM" GF="S 20">프로그램T코드</td>	<!--프로그램T코드-->
			    						<td GH="80 STD_LOGMEMO" GCol="text,LOGMEMO" GF="S 200">비고</td>	<!--비고-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
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