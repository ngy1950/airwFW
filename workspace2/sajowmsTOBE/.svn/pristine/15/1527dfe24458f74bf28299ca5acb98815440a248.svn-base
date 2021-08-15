<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UR01_CONNOWN</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
var gridData;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "UR01_CONNOWN",
			pkcol : "UROLKY, OWNRKY",
			editable : true,
		    menuId : "UR01_CONNOWN"
		});
		
		gridData = page.getLinkPopData();
		dataBind.dataNameBind(gridData, "searchArea");
		
		searchList();
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if (btnName == "Cancel") {
			this.close();
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if (json.data.RESULT == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList", 
				param : param ,
				sendType : "list"
			});
		}
	}
	
	//조회 후 데이터 넘기기 
	function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
    	if(dataLength > 0){
    		var list = gridList.getGridData("gridList");
    		var rtnList = new Array();
    		for(var i=0; i < list.length; i++){
    			rtnList.push(list[i].map);
    		} 
    		window.opener.data1(rtnList);
    		  		
    	}
    } 

	
	function saveData() {
		if (gridList.validationCheck("gridList", "All")) {
			var list = gridList.getModifyList("gridList", "A");
			if (list.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			for(var i=0; i<list.length; i++){
				var ownseq = list[i].map.OWNSEQ;
				if( ownseq == null || ownseq == ""){
					commonUtil.msgBox(" 정렬순서를 입력해주세요.");
					gridList.setColFocus("gridList", list[i].get("GRowNum"), "OWNSEQ");
					return;
				}
			}

 			var param = new DataMap();
			param.put("list", list);
			param.put("gridData",gridData.map);

			netUtil.send({
				url : "/system/json/saveUR01_popup1.data",
				param : param,
				successFunction : "successSaveCallBack"
			}); 
		}
		
	}
	
    //add Before
    function gridListEventRowAddBefore(gridId, rowNum, beforeData){

        var newData = new DataMap();

        newData.put("UROLKY",$("input[name='UROLKY']").val());
        return newData;
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
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<input type="button" CB="Cancel CANCEL BTN_CANCEL" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_UROLKY"></dt><!-- 사용자권한 키 -->
						<dd>
							<input type="text" class="input" name="UROLKY" id="UROLKY" IAname="Search" maxlength="10" readonly="true" />
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
			    						<td GH="100 STD_UROLKY" GCol="text,UROLKY" GF="S 10"></td>	<!--사용자 권한키-->
			    						<td GH="100 STD_OWNRKY" GCol="add,OWNRKY,SHOWNER" GF="S 10" validate="required"></td>	<!--화주SHOWNER-->
			    						<td GH="100 STD_OWNSEQ" GCol="input,OWNSEQ" GF="N 10" value="0" validate="required"></td>	<!--정렬순서-->
			    						<td GH="80 STD_MAINCK" GCol="check,MAINCK,radio" ></td>	<!--선택-->
			    						<td GH="80 STD_SHORTX" GCol="input,SHORTX" GF="S 180" validate="required"></td>	<!--설명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
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