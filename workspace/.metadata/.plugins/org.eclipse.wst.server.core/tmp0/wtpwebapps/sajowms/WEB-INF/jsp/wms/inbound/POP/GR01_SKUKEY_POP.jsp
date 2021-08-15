<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>입고상품 조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<script language="JavaScript" src="/common/js/head-h.js"> </script>
<script type="text/javascript">
	window.resizeTo('1200','800');
	var lindData;
	
	$(window).resize(function(){
		var $wrap = $(".imgWrap");
		var $obj = $wrap.find("img");
		
		var w = $wrap.width();
		var h = $wrap.height();
		resizeImage(w,h,$obj);
	});
	
	$(document).ready(function(){
		setTopSize(80);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR01_SKUKEY_POP",
			autoCopyRowType : false
		});
		
		
		
		lindData = page.getLinkPopData();
		dataBind.dataNameBind(lindData, "searchArea");
		searchList();
	});

	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//헤더 조회
	function searchList(){
		gridList.gridList({
			id : "gridList",
			param : lindData
		}); 
		
	}
	
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			rowData.put("searchCode", "SHLOTL04");
			rowData.put("rowNum", lindData.get("rowNum"));
			page.linkPopClose(rowData);
		}
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridList"){
			var lotl10 = gridList.getColData(gridId, rowNum, "LOTL10")
			getSkuImage($("#LOTL10img"),lotl10);
		}
	}
	
	function getSkuImage($obj,imageParam){
		var w = $(".imgWrap").width();
		var h = $(".imgWrap").height();
		
		if(imageParam.indexOf(".") > -1){
			$obj.attr({"src":"/common/image/view.data?fileName="+imageParam+"&&type=1"});
			$obj.load(function(){
				$(this).css({"width":"100%","height":"auto"});
				resizeImage(w,h,$(this));
			});
		}else{
			$obj.attr({"src":"/common/image/view.data?fileName="+imageParam+"&&type=2"});
			$obj.load(function(){
				$(this).css({"width":"100%","height":"auto"});
				resizeImage(w,h,$(this));
			});
		}
	}
	
	function resizeImage(w,h,$obj){
		var resizeWidth  = 0;
		var resizeHeight = 0;
		
		var imgW = $obj.width();
		var imgH = $obj.height();
		if(imgW > w || imgH > h){
			if(imgW > imgH){
				resizeWidth = w;
				resizeHeight = Math.round((imgH * resizeWidth) / imgW);
			}else{
				resizeHeight = h;
				resizeWidth = Math.round((imgW * resizeHeight) / imgH);
			}
		}else{
			resizeWidth = imgW;
			resizeHeight = imgH;
		}
		
		var src = $obj.attr("src");
		if(src == "/common/images/no_image.png"){
			$obj.css({"width":512,"height":512});
		}else{
			$obj.css({"width":resizeWidth,"height":resizeHeight});
		}
	}
	
	function failImageLoad($img){
		if($img.src.search("no_image") > -1){
			return;
		}
		
		$img.src = "/common/images/no_image.png";
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="foldSect" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="EANCOD" readonly />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect2 top" style="top: 85px; left: 16px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                  GCol="rownum">1</td>
												<td GH="100 STD_LOTL04,3"    GCol="text,LO04NM"></td>
												<td GH="80 STD_SKUCLSNM"     GCol="text,SCLSNM"></td>
												<td GH="130 STD_SKUKEY"      GCol="text,SKUKEY"></td>
												<td GH="240 STD_DESC01"      GCol="text,DESC01"></td>
												<td GH="100 STD_FIXLOC"      GCol="text,LOCAKY"></td>
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
<!-- 									<button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="bottomSect2 bottom" style="top: 85px; right: 16px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="imgWrap">
								<img id="LOTL10img" alt="상품 이미지" src="" onerror="failImageLoad(this);">
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