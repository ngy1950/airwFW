<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Master",
			command : "MZ01",
			pkcol : "WAREKY,ZONEKY",
			menuId : "MZ01"
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

	function saveData(){
		if(gridList.validationCheck("gridList", "data")){
			var item = gridList.getModifyData("gridList", "A");
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_SAVEEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("item",item);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveMZ01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"]) > 1){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "MZ01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "MZ01");
 		}

	}
	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("WAREKY","<%=wareky%>");
            
            return newData;
    	}
    }
    
    function gridListEventRowRemove(gridId, rowNum){
    	var param = new DataMap();
			param.put("WAREKY",gridList.getColData(gridId, rowNum, "WAREKY"));
			param.put("ZONEKY",gridList.getColData(gridId, rowNum, "ZONEKY"));
		var json = netUtil.sendData({
			module : "Master",
			command : "MZ01_DEL",
			sendType : "map",
			param : param
		});
		
		if(parseInt(json.data["CHK"]) > 0){
			commonUtil.msgBox("VALID_MZ0101",gridList.getColData(gridId, rowNum, "ZONEKY"));
			return false;
		}
    }

    //change Event
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "ZONEKY" && $.trim(colValue) != ""){
			var param = new DataMap();
				param.put("WAREKY",gridList.getColData(gridId, rowNum, "WAREKY"));
				param.put("ZONEKY",colValue);
			var json = netUtil.sendData({
				module : "Master",
				command : "MZ01",
				sendType : "map",
				param : param
			});
			
			if(parseInt(json.data["CHK"]) > 0){
				commonUtil.msgBox("COMMON_M0006",uiList.getLabel("STD_ZONEKY"));
				gridList.setColValue(gridId, rowNum, colName, "" );
			}
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY"  class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_AREAKY"></dt>
						<dd>
							<input type="text" class="input" name="AREAKY"  UIInput="SR,SHAREMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ZONEKY"></dt>
						<dd>
							<input type="text" class="input" name="ZONEKY"  UIInput="SR,SHZONMA"/>
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
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="70 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="80 STD_ZONEKY" GCol="input,ZONEKY,SHZONMA" GF="S 10" validate="required">존</td>	<!--존-->
				    						<td GH="200 STD_AREATY"   GCol="select,ZONETY" validate="required">
												<select commonCombo="ZONETY"><option></option></select>
											</td><!--구역타입-->
				    						<td GH="300 STD_SHORTX" GCol="input,SHORTX" GF="S 60">설명</td>	<!--설명-->
				    						<td GH="70 STD_AREAKY" GCol="input,AREAKY,SHAREMA" GF="S 10" validate="required">동</td>	<!--동-->
				    						<td GH="32 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
				    						<td GH="30 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	<!--생성자명-->
				    						<td GH="32 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
				    						<td GH="30 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
				    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	<!--수정자명-->
				    						<td GH="70 STD_ZGRPOKY" GCol="input,GRPOKY" GF="S 10">실사구역지정</td>	<!--실사구역지정-->
				    						<td GH="200 STD_ZCHKSTG"   GCol="select,CHKSTG" >
												<select commonCombo="OUTBYN"><option></option></select>
											</td><!--재고이동체크-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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