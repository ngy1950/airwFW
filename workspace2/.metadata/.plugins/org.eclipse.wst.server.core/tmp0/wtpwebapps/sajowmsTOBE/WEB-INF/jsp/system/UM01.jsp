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
			tree : "IMGLEVEL,MENUNAME,PMENUID,MENUID,SORTORDER",
			pkcol : "MENUKY,MENUID",
			command : "UM01",
			autoCopyRowType : false,
		    menuId : "UM01"
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
		

		if (gridList.validationCheck("gridList", "All")) {
			var list = gridList.getGridBox("gridList").getDataAll();
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
	        if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
	            return;
	        }

			for(var i=0; i<list.length; i++){
				var itemMap = list[i].map;

				if(itemMap.MENUID == "" || itemMap.MENUID == " "){
					//메뉴아이디는 필수 입력입니다.
					commonUtil.msgBox("메뉴아이디는 필수 입력입니다.");
					return; 
				}
			}
	
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/system/json/saveUM01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "UM01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "UM01");
 		}else if(btnName == "AddFolder"){
 			//폴더추가 
 			addFolder();
 		}
	}
	
	function addFolder(){

		var row = gridList.getGridData("gridList")[0];
		row.put("MENUKY", " ");
		row.put("MENULABEL", " ");
		row.put("MENUID", " ");
		row.put("MENUNAME", " ");
		row.put("URI", " ");
		row.put("PMENUID", " ");
		row.put("SORTORDER", 0);
		row.put("LEVEL", 0);
		row.put("DELETEYN", "N");
		row.put("IMGLEVEL", 0);
		
		gridList.setAddRow("gridList",row);
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "MENUID"){
			var param = new DataMap();
			param.put("PMENUID", colValue);
			var json = netUtil.sendData({
				module : "Master",
				command : "GET_MENU",
				sendType : "list",
				param : param
			}); 
			
			//메뉴id가 있을경우 
			if(json && json.data && json.data.length > 0 ){

				gridList.setColValue(gridId, rowNum, "MENUID", json.data[0].MENUID);
				gridList.setColValue(gridId, rowNum, "MENUNAME", json.data[0].MENUNAME);
				gridList.setColValue(gridId, rowNum, "URI", json.data[0].URI);
				gridList.setColValue(gridId, rowNum, "MENULABEL", json.data[0].MENUNAME);
				
				
			}else{

				gridList.setColValue(gridId, rowNum, "MENUID", ' ');
				gridList.setColValue(gridId, rowNum, "MENUNAME", ' ');
				gridList.setColValue(gridId, rowNum, "URI", ' ');
				gridList.setColValue(gridId, rowNum, "MENULABEL", ' ');
			}
			
		}
	}


	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    	sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}
    }
	 
	function gridListEventRowAddBefore(gridId, rowNum, beforeData){
		alert('test');
		
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
					<!-- <input type="button" CB="AddFolder SAVE BTN_ADDFOLDER" /> -->
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_MENUKY"></dt> <!--메뉴키 -->
						<dd>
							<input type="text" class="input" name="MENUGID" UIInput="S,SHMNUDF" validate="required(STD_MENUKY)"/> 
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
								<li><button class="btn btn_smaller"><span>축소</span></button></li>
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
											<td GH="300 STD_MENUTX" GCol="tree"></td>
				    						<td GH="80 STD_MENUKY" GCol="text,MENUKY,SHMENU">메뉴KEY</td>	<!--KEY-->
											<td GH="200 STD_TREE" GCol="text,MENULABEL" GF="S">TREE</td>	<!--TREE-->
				    						<td GH="80 STD_MENUID" GCol="input,MENUID,SHMENU" validate="required">메뉴ID</td>	<!--메뉴ID-->
				    						<td GH="120 STD_MENUNAME" GCol="input,MENUNAME" GF="S">메뉴명</td>	<!--메뉴명-->
				    						<td GH="200 STD_URL" GCol="input,URI" GF="S">URL</td>	<!--URL-->
				    						<td GH="200 STD_AMNUID" GCol="input,PMENUID" GF="S 120">상위메뉴ID</td>	<!--상위메뉴-->
				    						<td GH="60 STD_SORTORDER" GCol="input,SORTORDER" GF="N">순번</td>	<!--순번-->
				    						<td GH="40 STD_LEVEL" GCol="text,LEVEL" GF="N">레벨</td>	<!--레벨-->
				    						<td GH="100 STD_UDELYN"   GCol="select,DELETEYN">
												<select class="input" Combo="OyangOutbound,COMBO_USEYN">
												</select>
											</td><!--사용여부-->
				    						<td GH="40 STD_GLEVEL" GCol="text,IMGLEVEL" GF="N">그리드레벨</td>	<!--그리드레벨-->
				    						
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
							<button type='button' GBtn="copy"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="copy"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="up"></button>
							<button type='button' GBtn="down"></button>
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