<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "OyangReport",
			command : "OY12_ANS",
			pkcol : "USERID",
			editable : true,
		    menuId : "OY12_asnList"
		});
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if (btnName == "Search") {
			searchList()
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if (json.data.RESULT == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			/* gridList.gridList({
				id : "gridList", 
				param : param
			}); */
			netUtil.send({
				url : "/OyangReport/json/displayOY12_ASN.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
		}
	}
	
	
	function saveData(){
		if(gridList.validationCheck("gridList", "All")){
			var list = gridList.getGridData("gridList");
			
			for(var i=0; i < list.length; i++){
				var listMap = list[i].map;
				
 				if(listMap.USRID2.trim() == "" || listMap.USRID2.trim() == null ){
 					commonUtil.msgBox("* 센터입고일자를 입력해주세요 *");
					return;
 				} else if(listMap.UNAME2.trim() == "" || listMap.UNAME2.trim() == null ){
 					commonUtil.msgBox("* 출발시간을 입력해주세요 *");
					return;
 				} else if(listMap.DEPTID2.trim() == "" || listMap.DEPTID2.trim() == null ){
 					commonUtil.msgBox("* 도착예정시간을 입력해주세요 *");
					return;
 				} else if(listMap.USRID1.trim() == "" || listMap.USRID1.trim() == null ){
 					commonUtil.msgBox("* 차량기사명을 입력해주세요 *");
					return;
 				} else if(listMap.UNAME1.trim() == "" || listMap.UNAME1.trim() == null ){
 					commonUtil.msgBox("* 차량기사 전화번호를 입력해주세요 *");
					return;
 				} else if(listMap.DNAME1.trim() == "" || listMap.DNAME1.trim() == null ){
 					commonUtil.msgBox("* 출고여부를 입력해주세요 *");
					return;
 				}
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/OyangReport/json/saveOY12_ASN.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
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
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
 					<dl>
						<dt CL="STD_ASNDKY"></dt>
						<dd>
							<input type="text" class="input" name="ASNDKY" id="ASNDKY" IAname="Search" maxlength="10" /><!-- readonly="true" -->
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
					<li><a href="#tab1-1"><label CL="STD_LIST"></label></a></li>
				</ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>   
			    						<td GH="80 STD_ASNDKY" GCol="text,ASNDKY" GF="S 40">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="80 거래처코드" GCol="text,PTNRTO" GF="S 10">거래처코드</td>	<!--거래처코드-->
			    						<td GH="150 거래처명" GCol="text,NAME01" GF="S 50">거래처명</td>	<!--거래처명-->
			    						<td GH="80 센터입고일자" GCol="input,USRID2" GF="C 30">센터입고일자</td>	<!--센터입고일자-->
			    						<td GH="80 출고여부" GCol="input,DNAME1" GF="S 20">출고여부</td>	<!--출고여부-->
			    						<td GH="80 출발시간" GCol="input,UNAME2" GF="T 20">출발시간</td>	<!--출발시간-->
			    						<td GH="80 도착예정시간" GCol="input,DEPTID2" GF="T 30">도착예정시간</td>	<!--도착예정시간-->
			    						<td GH="80 차량번호" GCol="input,DEPTID1" GF="S 50">차량번호</td>	<!--차량번호-->
			    						<td GH="80 차량기사명" GCol="input,USRID1" GF="S 30">차량기사명</td>	<!--차량기사명-->
			    						<td GH="80 기사전화번호" GCol="input,UNAME1" GF="S 30">기사전화번호</td>	<!--기사전화번호-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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