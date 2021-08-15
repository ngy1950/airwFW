<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>작업최적화 내역</title>
<%@ include file="/common/include/popHead.jsp" %>
<style type="text/css">
.bgX{background: #efefef !important;}
.bgSA{background: #ff5a5a !important;}
.bgA{background: #ffb123 !important;}
.bgB{background: #f3f318 !important;}
.bgC{background: #19fd19 !important;}
.bgD{background: #38c8ff !important;}
.bgN{background: #fff !important;}
</style>
<script type="text/javascript">
	var data = new DataMap();
	var popNm = "MP11_CONFIRM";
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			colorType : true,
			firstRowFocusType: false
		});
		
		init();
		
		searchList();
	});
	
	function init(){
		headData = new DataMap();
		
		data = page.getLinkPopData();
		
		var head = data.get("head");
		dataBind.dataNameBind(head, "searchArea");
		
		$("[name=FRDATE]").val(formatDate(head.get("FRDATE")));
		$("[name=TODATE]").val(formatDate(head.get("TODATE")));
		
		var arr = ["WARENM","FRDATE","TODATE","AREANM","ZONENM"];
		var $obj = $("#searchArea table tr td input");
		$obj.each(function(){
			var key = $(this).attr("name");
			var idx = arr.indexOf(key);
			if(idx > -1){
				$(this).attr("disabled",true);
			}
		});
		
		gridList.appendCols("gridList", ["LOTA06"]);
		
		var schTyp = head.get("SCHTYP");
		var schlab = "";
		switch (schTyp) {
		case "01":
			schlab = uiList.getLabel("STD_SHPCNT");
			break;
		case "02":
			schlab = uiList.getLabel("STD_SHPQTY");
			break;
		default:
			break;
		}
		
		gridList.setHeadText("gridList","ORDCNT",schlab);
	}

    //공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Send"){
            sendPickLocPage();
        }else if(btnName == "Close"){
        	fn_close();
        }
    }
	
	function searchList(){
		$("#contentLoading").show();
		setTimeout(function(){
			gridList.resetGrid("gridList");
			
			var list = data.get("result");
			list.sort(function(a,b){
				return a.get("LOCAKY") < b.get("LOCAKY") ? -1 : a.get("LOCAKY") > b.get("LOCAKY") ? 1 : 0;
			});
			gridList.setGridData("gridList",list);
			gridList.reloadView("gridList");
			
			$(".record").html(gridList.getGridDataCount("gridList") + " Record");
			
			$("#contentLoading").hide();
		}, 100);
	}
	
	function sendPickLocPage(){
		var isClose = false;
		var $obj = opener.parent.parent.nav.$("#multiList li");
		$obj.each(function(){
			if($(this).text().indexOf("MP01") > -1){
				isClose = true;
			}
		});
		if(isClose){
			opener.parent.parent.nav.closeWindow("MP01");
		}
		var head = data.get("head");
		var list = gridList.getGridData("gridList",true);
		
		var param = new DataMap();
		param.put("head",head);
		param.put("list",list);
		
		opener.page.linkPageOpen("MP01",param);
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
	
	function formatDate(d){ 
		var yy = d.substr(0,4);
		var mm = d.substr(4,2); 
		var dd = d.substr(6,2);
		
		return [yy, mm, dd].join('-');
	}
	
	function fn_close(){
		this.close();
	}
	
	function gridListColBgColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "CLSRAK"){
				return "bg"+colValue;
			}
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Send ALLOCATE BTN_PICMAP"></button>
		<button CB="Close CLOSE BTN_CLOSE"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:160px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_TSKRSH'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50"/>
									<col/>
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<input type="hidden" name="WAREKY">
											<input type="text" name="WARENM" style="width: 258px;">
										</td>
									</tr>
									<tr>	
										<th CL="STD_SRHDAT"></th>
										<td>
											<input typ="text" name="FRDATE" style="width: 120px;padding-left: 5px;"> ~ <input typ="text" name="TODATE" style="width: 120px;padding-left: 5px;"> 
										</td>
									</tr>
									<tr>
										<th CL="STD_AREAKY"></th>
										<td>
											<input type="hidden" name="AREAKY"/>
											<input type="text" name="AREANM" style="width: 258px;"/>
										</td>
									</tr>
									<tr>	
										<th CL="STD_ZONEKY"></th>
										<td>
											<input type="hidden" name="ZONEKY"/>
											<input type="text" name="ZONENM" style="width: 258px;"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottomT" style="top: 180px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_TSKRSI"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="120" />
											<col width="250" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_NUMBER" rowspan="2"></th>
												<th CL="STD_MIN_RACK" colspan="6"></th>
												<th CL="STD_MAX_RACK"></th>
											</tr>
											<tr>
												<th CL="STD_LOCAKY"></th>
												<th CL="STD_SKUKEY"></th>
												<th CL="STD_DESC01"></th>
												<th CL="STD_LOTA06"></th>
												<th CL="STD_SHPCNT"></th>
												<th CL="STD_CLSENG"></th>
												<th CL="STD_LOCAKY"></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,LT06NM,center"></td>
												<td GCol="text,ORDCNT" GF="N 20,4"></td>
												<td GCol="text,CLSRAK,center"></td>
												<td GCol="text,LOCATG"></td>
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