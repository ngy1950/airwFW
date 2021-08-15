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
	    	module : "System",
			command : "YD01",
			pkcol : "COMPKY,DDICKY",
		    menuId : "YD01"
	    });
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

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "YD01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "YD01");
 		}
	}
	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            newData.put("DBLENG",0);
            newData.put("DBDECP",0);
            newData.put("OUTLEN",0);
            
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
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="COMPKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DDICKY"></dt>
						<dd>
							<input type="text" class="input" name="DDICKY"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DATFTY"></dt>
						<dd>
							<input type="text" class="input" name="DATFTY"  UIFormat="U"/>
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
											<td GH="100 STD_COMPANY"     GCol="text,COMPKY" GF="U 10"></td>
											<td GH="120 STD_DDICKY"  GCol="input,DDICKY"           GF="U 20"     validate="required" ></td>
											<td GH="120 STD_DATFTY"  GCol="input,DATFTY"           GF="U 4"></td>
											<td GH="350 STD_SHORTX"  GCol="input,SHORTX"           GF="S 180"></td>
											<td GH="120 STD_DBFILD"  GCol="input,DBFILD"           GF="S 20"></td>
											<td GH="120 STD_PDATTY"  GCol="input,PDATTY"           GF="S 4"></td>
											<td GH="120 STD_OBJETY"  GCol="input,OBJETY"           GF="S 4"></td>
											<td GH="120 STD_DBLENG"  GCol="input,DBLENG"           GF="N"></td>
											<td GH="120 STD_DBDECP"  GCol="input,DBDECP"           GF="N"></td>
											<td GH="120 STD_OUTLEN"  GCol="input,OUTLEN"           GF="N"></td>
											<td GH="120 STD_SHLPKY"  GCol="input,SHLPKY"           GF="S 20"></td>
											<td GH="120 STD_FLDALN"  GCol="input,FLDALN"           GF="S 4"></td>
											<td GH="120 STD_LABLGR"  GCol="input,LABLGR"           GF="S 10"></td>
											<td GH="120 STD_LABLKY"  GCol="input,LABLKY"           GF="S 20"></td>
									   	 	<td GH="120 STD_LBTXTY"  GCol="input,LBTXTY"           GF="S 4"></td>
<!-- 											<td GH="120 STD_UCASOL"  GCol="check,UCASOL"></td> -->
											<td GH="120 STD_CREDAT"  GCol="text,CREDAT"            GF="D"></td>
											<td GH="120 STD_CRETIM"  GCol="text,CRETIM"            GF="T"></td>
											<td GH="120 STD_CREUSR"  GCol="text,CREUSR" ></td>
											<td GH="120 STD_LMODAT"  GCol="text,LMODAT"            GF="D"></td>
											<td GH="120 STD_LMOTIM"  GCol="text,LMOTIM"            GF="T"></td>
											<td GH="120 STD_LMOUSR"  GCol="text,LMOUSR"></td>
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
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
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