<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL22POP</title>
<%@ include file="/common/include/popHead.jsp" %>
<style>
.gridIcon-center{text-align: center;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script type="text/javascript">
	var data;
	var popNm = "IP02_PHYDI";
	var g_grid_id = "";
	var g_row_num = 0;
	
	$(document).ready(function(){
		init();
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "IP02_PHYDI_POP",
			colorType : true
	    });
		
		searchList();
	});
	
	function init(){
		data = page.getLinkPopData();
		
		var skukey = data.get("SKUKEY");
		var desc01 = data.get("DESC01");
		
		data.put("SKUINF",skukey + " / " + desc01);
		
		dataBind.dataNameBind(data, "searchArea");
	}

    //공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Close"){
        	closeData();
        }
    }
    
	//헤더 조회
	function searchList(){
		gridList.gridList({
	    	id : "gridList",
	    	param : data
	    }); 
	}
	
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeDataParam("searchArea");
        if(gridId == "gridList"){
            param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridList");
        }
        return param;
        
    }
	
	function closeData(){
		this.close();
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "DELMAK"){
				if(colValue == "V"){
					return "d";
				}else{
					return "y";
				}
			}
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Close CLOSE BTN_CLOSE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:130px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_PHYINF'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col/>
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<input type="text" id="WARENM" name="WARENM" disabled="disabled"/>
										</td>
										<th CL="STD_PHYIKY"></th>
										<td>
											<input type="text" name="PHYIKY" disabled="disabled"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SKUKEY" disabled="disabled"/>
										</td>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="DESC01" disabled="disabled" style="width: 100%;"/>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="LOCAKY" disabled="disabled" />
										</td>
										<th CL="STD_LOTA06"></th>
										<td>
											<input type="text" name="LT06NM" disabled="disabled" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
	         </div>

			<div class="bottomSect bottomT" style="top: 145px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_PHYLST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="80 STD_LSTCMP"  GCol="icon,DELMAK" GB="n"></td>
												<td GH="100 STD_PHYPHC" GCol="text,HHTTID,center"></td>
												<td GH="100 STD_PHYDAT" GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_PHYTIM" GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_PHYUSR" GCol="text,CREUSR,center"></td>
												<td GH="100 STD_PHYUNM" GCol="text,CREUNM,center"></td>
												<td GH="100 STD_PHIQTY" GCol="text,QTSPHY" GF="N 20,3"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>