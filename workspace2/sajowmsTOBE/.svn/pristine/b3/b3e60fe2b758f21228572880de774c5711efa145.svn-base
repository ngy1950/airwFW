<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UI01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "SajoSystem",
			command : "UM01",
			pkcol : "COMPKY,MENUID",
		    menuId : "YP01"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
		searchList();
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "YP01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "YP01");
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

	function saveData(){
		if(gridList.validationCheck("gridList", "data")){
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
	        
	        gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A",
		    });
	        
			searchList();
			
		}
	}

	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList"){
			var newData = new DataMap();
			newData.put("COMPID","<%=compky%>");
			return newData;
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        // 거래처담당자 주소검색
        if (searchCode == "SHIMGPTH") {
            param.put("gridId","gridList");
            param.put("rowNum",rowNum);
            
            page.linkPopOpen("/system/pop/YP01_ICON_POP.page", param);
            
        	return false;
        }
    }
	
	function linkPopCloseEvent(data){
		if(data != null && data != undefined){
			var popNm = data.get("popNm")==undefined?"":data.get("popNm");
			if(popNm == "YP01_ICON_POP"){
				var gridId = data.get("gridId");
				var rowNum = data.get("rowNum");
				var returnData = data.get("data");
				
				var path = returnData.get("PATH");
				
				gridList.setColValue(gridId, rowNum, "IMGPTH", path);
			}
		} else if(data.get("TYPE") == "GET"){ 
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<input type="hidden" class="input" name="CMCDKY" value="<%=compky%>"/>
					<dl>
						<dt CL="STD_MENUID"></dt>
						<dd>
							<input type="text" class="input" name="MENUID"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MENUTX"></dt>
						<dd>
							<input type="text" class="input" name="MENUNAME"/>
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
										<td GH="40"				GCol="rownum">1</td>
										<td GH="100 STD_MENUID" GCol="add,MENUID" validate="required"></td> <!-- 메뉴 -->
										<td GH="180 STD_MENUTX"	GCol="input,MENUNAME"></td> <!--메뉴명 -->
										<td GH="180 STD_PGPATH"	GCol="input,URI"></td> <!--프로그램 경로 -->
										<td GH="220 STD_ICPATH"	GCol="input,IMGPTH,SHIMGPTH"></td> <!-- 아이콘 경로 서치헬프 -->
										<td GH="80 STD_CREUSR"	GCol="text,CREATEUSER"></td> <!--생성자 -->
										<td GH="80 STD_CREDAT"	GCol="text,CREATEDATE" GF="D"></td> <!--생성일자 -->
										<td GH="80 STD_LMOUSR"	GCol="text,UPDATEUSER"></td> <!--수정자 -->
										<td GH="80 STD_LMODAT"	GCol="text,UPDATEDATE" GF="D"></td> <!--수정일자 -->
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