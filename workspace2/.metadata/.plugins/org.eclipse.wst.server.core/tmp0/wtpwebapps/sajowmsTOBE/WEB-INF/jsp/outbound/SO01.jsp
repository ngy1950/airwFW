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
			module : "Outbound",
			command : "SO01"
	    });
	});

	function saveData(){
		if(gridList.validationCheck("gridList", "modifiy")){
			var list = gridList.getModifyList("gridList", "A");
			var param = new DataMap();
			param.put("list",list);
			netUtil.send({
				url : "/outbound/json/saveSO01.data",
				param : param,
				successFunction : "successSaveCallBack"
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

	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
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
	<div class="content_inner" style="padding: 5px 30px 55px;">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner"></div>
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
										<td GH="40"              GCol="rownum">1</td>
										<td GH="40"              GCol="rowCheck"></td>
										<td GH="140 STD_SEBELN"  GCol="input,SVBELN"></td>
										<td GH="140 STD_SEBELP"  GCol="input,SPOSNR"></td>
										<td GH="140 STD_SHPMTY"  GCol="input,SHPMTY"></td>
										<td GH="140 STD_RQSHPD"  GCol="input,RQSHPD" GF="C"></td>
										<td GH="140 STD_EXPTNK"  GCol="input,PTNRKY"></td>
										<td GH="140 STD_PGRC04"  GCol="input,PTRCVR"></td>
										<td GH="140 STD_SKUKEY"  GCol="input,SKUKEY"></td>
										<td GH="140 STD_DESC01"  GCol="input,DESC01"></td>
										<td GH="140 STD_QTYORD"  GCol="input,QTYORD" GF="N 20"></td>
										<td GH="140 STD_UOMKEY"  GCol="input,UOMKEY"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>
						<button type="button" GBtn="sortReset"></button>
						<button type="button" GBtn="add"></button>
						<button type="button" GBtn="copy"></button>
						<button type="button" GBtn="delete"></button>
						<button type="button" GBtn="total"></button>
						<button type="button" GBtn="layout"></button>
						<button type="button" GBtn="excel"></button>
						<button type="button" GBtn="excelUpload"></button>
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