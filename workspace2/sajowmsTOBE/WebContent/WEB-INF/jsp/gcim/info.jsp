<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%-- <%@ include file="/common/include/webdek/head.jsp" %> --%>
<%@ include file="/fusioncharts/include/fusioncharts.jsp" %> 
<script type="text/javascript">
	var buttomAutoResize = false;
	$(document).ready(function(){
		/* 멀티라인 */
		
		
		$("#chartContainer").insertFusionCharts({
			  type: "msline",
			  width: "100%",
			  height: "100%",
			  dataFormat: "json",
			  dataSource: {
			    chart: {
// 			      caption: "Reach of Social Media Platforms amoung youth",
// 			      yaxisname: "% of youth on this platform",
// 			      subcaption: "2012-2016",
			      showhovereffect: "1",
			      numbersuffix: "K",
			      drawcrossline: "1",
			      plottooltext: "$label : $seriesName <b>$datavalue</b> ",
			      theme: "fusion",
			    },
			    categories: [
			      {
			        category: [
			                   { label: "2019-04" }, 
			                   { label: "2019-05" }, 
			                   { label: "2019-06" }, 
			                   { label: "2019-07" }, 
			                   { label: "2019-08" }, 
			                   { label: "2019-09" }, 
			                   { label: "2019-10" },
			                   { label: "2019-11" },
			                   { label: "2019-12" },
			                   { label: "2020-01" }, 
			                   { label: "2020-02" }, 
			                   { label: "2020-03" }, 
			                  ]
			      }
			    ],
			    dataset: [
			      {
			        seriesname: "실적",
			        data: [
                            { value: "63" },
                            { value: "69" },
                            { value: "65" },
                            { value: "70" },
                            { value: "71" },
                            { value: "65" },
                            { value: "73" },
                            { value: "96" },
                            { value: "84" },
                            { value: "85" },
                            { value: "86" },
                            { value: "94" }
				         ]
				  },
			      {
			        seriesname: "계획",
			        data: [
                            { value: "60" },
                            { value: "57" },
                            { value: "51" },
                            { value: "56" },
                            { value: "54" },
                            { value: "55" },
                            { value: "54" },
                            { value: "69" },
                            { value: "65" },
                            { value: "66" },
                            { value: "63" },
                            { value: "67" }
			              ]
			      }
			    ]
			  }
			});
		/* 멀티라인 */
	});
// 	window.onload = function () {

// 	var options = {
// 		animationEnabled: true,
// 		theme: "light2",
// 		axisX:{
// 			valueFormatString: "MMM YY",
// 	        interval:1,
// 	        intervalType: "month"
// 		},
// 		axisY: {
// 			suffix: "K",
// 			minimum: 30
// 		},
// 		toolTip:{
// 			shared:true
// 		},  
// 		legend:{
// 			cursor:"pointer",
// 			verticalAlign: "bottom",
// 			horizontalAlign: "left",
// 			dockInsidePlotArea: true,
// 			itemclick: toogleDataSeries
// 		},
// 		data: [{
// 			type: "line",
// 			showInLegend: true,
// 			name: "실적",
// 			markerType: "square",
// 			xValueFormatString: "DD MMM, YYYY",
// 			color: "#F08080",
// 			yValueFormatString: "#,##0K",
// 			dataPoints: [
// 				{ x: new Date(2019, 4, 1), y: 63 },
// 				{ x: new Date(2019, 5, 1), y: 69 },
// 				{ x: new Date(2019, 6, 1), y: 65 },
// 				{ x: new Date(2019, 7, 1), y: 70 },
// 				{ x: new Date(2019, 8, 1), y: 71 },
// 				{ x: new Date(2019, 9, 1), y: 65 },
// 				{ x: new Date(2019, 10, 1), y: 73 },
// 				{ x: new Date(2019, 11, 1), y: 96 },
// 				{ x: new Date(2019, 12, 1), y: 84 },
// 				{ x: new Date(2020, 1, 1), y: 85 },
// 				{ x: new Date(2020, 2, 1), y: 86 },
// 				{ x: new Date(2020, 3, 1), y: 94 },
// 			]
// 		},
// 		{
// 			type: "line",
// 			showInLegend: true,
// 			name: "계획",
// 			lineDashType: "dash",
// 			yValueFormatString: "#,##0K",
// 			dataPoints: [
// 				{ x: new Date(2019, 4, 1), y: 60 },
// 				{ x: new Date(2019, 5, 1), y: 57 },
// 				{ x: new Date(2019, 6, 1), y: 51 },
// 				{ x: new Date(2019, 7, 1), y: 56 },
// 				{ x: new Date(2019, 8, 1), y: 54 },
// 				{ x: new Date(2019, 9, 1), y: 55 },
// 				{ x: new Date(2019, 10, 1), y: 54 },
// 				{ x: new Date(2019, 11, 1), y: 69 },
// 				{ x: new Date(2019, 12, 1), y: 65 },
// 				{ x: new Date(2020, 1, 1), y: 66 },
// 				{ x: new Date(2020, 2, 1), y: 63 },
// 				{ x: new Date(2020, 3, 1), y: 67 },
// 			]
// 		}]
// 	};
// 	$("#chartContainer").CanvasJSChart(options);

// 	function toogleDataSeries(e){
// 		if (typeof(e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
// 			e.dataSeries.visible = false;
// 		} else{
// 			e.dataSeries.visible = true;
// 		}
// 		e.chart.render();
// 	}

// 	}
</script>
</head>
<body style="min-width:652px;">
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content-vertical-wrap">
			<div class="content-horizontal-wrap h-wrap-min" style="height:345px">	
				<div class="content_layout tabs content_left" style="height:345px;min-width:263px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>공지사항</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01" style="height: calc(100% - 10px);)">
							<div class="scroll" style="height: 100%;">
								<table class="table_c" style="width:100%">
									<colgroup>
										<col style="width: 10%"/>
										<col style="width: 60%" />
										<col style="width: 30%" />
									</colgroup>
									<thead>
										<tr>
											<th>No</th>
											<th>제목</th>
											<th>등록일</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td style="text-align:center">1</td>
											<td>공지사항1</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">2</td>
											<td>공지사항2</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">3</td>
											<td>공지사항3</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">4</td>
											<td>공지사항4</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">5</td>
											<td>공지사항5</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">6</td>
											<td>공지사항6</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">7</td>
											<td>공지사항7</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">8</td>
											<td>공지사항8</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">9</td>
											<td>공지사항9</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
										<tr>
											<td style="text-align:center">10</td>
											<td>공지사항10</td>
											<td style="text-align:center">2020.04.06</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<!-- <button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="excelUpload"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span> -->
						</div>
					</div>
				</div>
				
				<div class="content_layout tabs content_right" style="height:345px;min-width:263px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>게시판</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01" style="height: calc(100% - 10px);)">
							<div class="scroll" style="height: 100%;">
								<table class="table_c" style="width:100%">
									<colgroup>
										<col style="width: 10%"/>
										<col style="width: 60%" />
										<col style="width: 30%" />
									</colgroup>
									<thead>
										<tr>
											<th>No</th>
											<th>제목</th>
											<th>등록자</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td style="text-align:center">1</td>
											<td>게시글1</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">2</td>
											<td>게시글2</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">3</td>
											<td>게시글3</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">4</td>
											<td>게시글4</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">5</td>
											<td>게시글5</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">6</td>
											<td>게시글6</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">7</td>
											<td>게시글7</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">8</td>
											<td>게시글8</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">9</td>
											<td>게시글9</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
										<tr>
											<td style="text-align:center">10</td>
											<td>게시글10</td>
											<td style="text-align:center">GC녹십자</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<!-- <button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="excelUpload"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span> -->
						</div>
					</div>
				</div>
			</div>
			
			<div class="content_layout tabs" style="height:calc(100% - 365px);width:100%; margin-top: 20px;">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>매출 실적 Trend</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div id="chartContainer" class="content_layout_audit line_graph" style="height: calc(100% - 27px);width: calc(100% - 22px);">
						<!-- 그래프 -->
						<script src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
					</div>
					<div class="btn_lit tableUtil">
						<!-- <button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="copy"></button>
						<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="excelUpload"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span> -->
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