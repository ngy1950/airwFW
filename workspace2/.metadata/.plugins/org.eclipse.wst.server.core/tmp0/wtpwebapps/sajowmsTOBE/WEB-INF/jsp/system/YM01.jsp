<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YM01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "SajoSystem",
			command : "JMSGM",
		    menuId : "YM01"
// 			pkcol : "LANGKY,MESGGR,MESGKY"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("MESSAGETYPE","WMS");
		return newData;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/wms/system/json/saveYM01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}
	
	function reloadMessage(){
		var param = new DataMap();
		netUtil.send({
			url : "/common/message/json/reload.data",
			param : param
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			reloadMessage();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "YM01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "YM01");
 		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	      var param = new DataMap();
	      
	      if(searchCode == "SHMSGKY"){
	          param.put("LANGKY","KO");
	     }
	   return param;
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Reload RESET BTN_REFMSG" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_LANGKY"></dt>
						<dd>
							<input type="text" name="LANGCODE" UIInput="S,SHLBLLK" value="<%=langky%>"  />
							<input type="hidden" name="MESSAGETYPE" value="WMS">
	 					</dd>
					</dl>
					<dl>
						<dt CL="STD_MESGGR"></dt>
						<dd>
							<input type="text" class="input" name="MESSAGEGID" UIInput="SR,SHMSGGR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MESGKY"></dt>
						<dd>
							<input type="text" class="input" name="MESSAGEID" UIInput="SR,SHMSGKY"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MESGTX"></dt>
						<dd>
							<input type="text" class="input" name="MESSAGE" UIInput="SR"/>
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="60 STD_LANGKY" GCol="input,LANGCODE" GF="S 3"  validate="required">언어</td>	<!--언어-->
			    						<td GH="100 STD_MESSAGETYPE" GCol="text,MESSAGETYPE" GF="S 3"  validate="required">언어</td>	<!--언어-->
			    						<td GH="90 STD_MESGGR" GCol="input,MESSAGEGID" GF="S 10" validate="required">메시지 그룹</td>	<!--메시지 그룹-->
			    						<td GH="90 STD_MESGKY" GCol="input,MESSAGEID" GF="S 20" validate="required">메시지 키</td>	<!--메시지 키-->
			    						<td GH="350 STD_MESGTX" GCol="input,MESSAGE" GF="S 1000" validate="required">라벨 설명</td>	<!--라벨 설명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
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