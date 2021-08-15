<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.*,java.util.*"%>
<%
Object portalGb = request.getSession().getAttribute("PORTALGUBUN");
String portalUserGb = (portalGb == null?null:portalGb.toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
 <%@ include file="/common/include/webdek/head.jsp" %>
<%@ include file="/common/include/webdek/clinc.jsp" %>
<%--<%@ include file="/fusioncharts/include/fusioncharts.jsp" %>--%>
<!-- Add the slick-theme.css if you want default styling -->

<link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
<!-- Add the slick-theme.css if you want default styling -->
<link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

<script type="text/javascript">

var portalUserGuBun = '<%=portalUserGb%>'
	var buttomAutoResize = false;
	$(window).resize(function(){
	     var parentContainer = $('#chartContainer').height()-30;
	     $('.slick-slide').height(parentContainer);
	});
	$(document).ready(function(){


		gridList.setGrid({
			emptyMsgType : false,
			id : "gridLIst001",
			module : "CL6501",
			command : "CL6501_LIST01", // BL3302_MT

		})



    	var dataPostMap = new DataMap();
		var dataSet = new DataMap();
		cl.addMap(dataPostMap,'CL6501_CROCD','MAP',dataSet);
		cl.dataSendSet(dataPostMap);

		var json = netUtil.sendData({
			url:'/GCCL/CL/json/listUpdate.data',
			param:dataPostMap,
		});
		var dataMap = new DataMap()

		var croCd = (json['data']['CL6501_CROCD']).CRO_CD
		dataMap.put('CRO_CD',croCd)
		dataMap.put('PORTALGUBUN',portalUserGuBun)
		dataMap.put('PROJT_NM_LIST','전체')
		dataMap.put('MAIN_PAGE', 'MAIN')
		gridList.gridList({
			id : "gridLIst001",
			param : dataMap
		})

	    var portalMap = new DataMap();
		portalMap.put('PORTALGUBUN',portalUserGuBun);
        cl.addMap(dataPostMap,'CL6301_PROJECT','LIST',portalMap);

        var json = netUtil.sendData({
            url:'/GCCL/CL/json/listUpdate.data',
            param:dataPostMap,

        });
        var centerElement = $('.bxslider.center');
        centerElement.empty();
        var parentContainer = $('#chartContainer').height()-30;
        if(json['data']['CL6301_PROJECT']){
            if(json['data']['CL6301_PROJECT'].length>0){
                $.each(json['data']['CL6301_PROJECT'],function(k,v){
                    var dataPostMap = new DataMap(v);

                    var div = commonUtil.makeElement('div' , '<h2 style="font-size:25px;text-align:center !important;margin-top:40px;font-weight:bold;color:#5ea4ff">' + (dataPostMap.get('TEXT_COL')) + '</h2>' +
						'<h2 style="margin-top:10px;font-size:16px;text-align:center;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;width:100%;overflow:hidden;">' + (dataPostMap.get('PROTOCOL_INFO')||'') + '</h2>' +
						'<div style="text-align:center;position:absolute;bottom:0;left:0;width:calc(100% - 17px);padding:10px;font-size:15px;border-top:1px #edd solid;">' +
						'검사결과  (<span style="color: #f75f31;font-weight:bold;">'+(dataPostMap.get('RSLTCOUNT'))+'</span>) 건</div> ').appendTo(centerElement);
                    div.css({'border-radius':'10px','border':'2px #80beff solid','position':'relative','margin':'15px 10px 0 15px','height':parentContainer});
                });
            } else {
                var arr = [];
                $.each(arr,function(k,v){
                    var dataPostMap = new DataMap(v);

                    var div = commonUtil.makeElement('div','<h2 style="font-size:25px;text-align:center !important;margin-top:40px;font-weight:bold;color:#5ea4ff">'+(dataPostMap.get('TEXT_COL'))+'</h2>' +
						'<h2 style="margin-top:10px;font-size:16px;text-align:center !important;">'+(dataPostMap.get('PROTOCOL_INFO')||'')+'</h2>' +
						'<div style="text-align:center;position:absolute;bottom:0;left:0;width:calc(100% - 17px);padding:10px;font-size:15px;border-top:1px #edd solid;">' +
						'검사결과  (<span style="color: #f75f31;font-weight:bold;">0</span>) 건</div> ').appendTo(centerElement);
                    div.css({'border-radius':'10px','border':'2px #80beff solid','position':'relative','margin':'15px 10px 0 15px','height':parentContainer});
                });
			}
        }

        console.log(json);

        $('.center').slick({
            centerMode: false ,
			infinite: false,

            // centerPadding: '60px' ,
            slidesToShow: 5 ,
			slidesToScroll: 1,
            autoplay: true ,
            autoplaySpeed: 3000 ,
            responsive: [
                {
                    breakpoint: 768 ,
                    settings: {
                        arrows: true ,
                        centerMode: true ,
                        // centerPadding: '40px' ,
                        slidesToShow: 3
                    }
                } ,
                {
                    breakpoint: 480 ,
                    settings: {
                        arrows: true ,
                        centerMode: true ,
                        // centerPadding: '40px' ,
                        slidesToShow: 1
                    }
                }
            ]
        });
        setTimeout(function(){

            $('.slick-arrow').css({'width':'20px','height':'40px','z-index':'3'});

            $('.slick-next').css({'right':0, 'background':'url(/common/theme/webdek/images/arrow_blue_right.png) no-repeat center center / 100% auto'});
            $('.slick-prev').css({'left':0, 'background':'url(/common/theme/webdek/images/arrow_blue_left.png) no-repeat center center / 100% auto'});
			$('.slick-slide').css('outline','none');
            $('.slick-prev:before, .slick-next:before').css({'font-size':0,'content':'','opacity':0});
        });






		var dataPostMap = new DataMap();
		var dataSet = new DataMap();
		dataSet.put('CRO_CD',croCd)
		cl.addMap(dataPostMap,'CL6101_POPNOTI','LIST',dataSet);
		cl.dataSendSet(dataPostMap);

		var json = netUtil.sendData({
			url:'/GCCL/CL/json/listUpdate.data',
			param:dataPostMap,
		});




		for(var i = 0 ; i < (json['data']['CL6101_POPNOTI']).length ; i++){
			var dataView = new DataMap
			dataView.put('GB_NM',(json['data']['CL6101_POPNOTI'])[i].GB_NM)
			dataView.put('TITLE',(json['data']['CL6101_POPNOTI'])[i].TITLE)
			dataView.put('PROJT_NM',(json['data']['CL6101_POPNOTI'])[i].PROJT_NM)
			dataView.put('FILE_ID',(json['data']['CL6101_POPNOTI'])[i].FILE_ID )
			dataView.put('FILE_NAME',(json['data']['CL6101_POPNOTI'])[i].FILE_NAME )
			dataView.put('CNTS',(json['data']['CL6101_POPNOTI'])[i].CNTS )
			dataView.put('BRD_SN',(json['data']['CL6101_POPNOTI'])[i].BRD_SN )

			dataView.put('type','select')
			dataView.put('from','main')



			if(getCookie((json['data']['CL6101_POPNOTI'])[i].BRD_SN) !='false'){
				window.open("/GCCL/CL/CL60/CL6101_POP1.page?boardid="+(json['data']['CL6101_POPNOTI'])[i].BRD_SN ,dataView.toString(),"height=600,width=900,resizable=yesa")
			}
		}

		// page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yesa",'a');

		//window.name $.parseJSON

		/* page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yes",'b');
		page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yes",'c');
		page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yes");
		page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yes");
		page.linkPopOpen("/GCCL/CL/CL60/CL6501_POP01.page", dataView, "height=600,width=900,resizable=yes");
		 */
	});

	function attachedFile(gridId, rowNum, colName, colValue){
		var title = gridList.getColData(gridId, rowNum, 'TITLE')
		if(gridList.getColData(gridId, rowNum, 'FILE_ID')!=''){
			return title+" <img src='/common/theme/webdek/images/icon_attached.png' height='20px' width='auto'/>";

		}else{
			return title
		}
	}
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){

		var rowData = gridList.getRowData(gridId , rowNum)
		var $obj = commonUtil.getJObj($('body > div.content_top > ul.header_tab > li:nth-child(4) > a'));
		console.log($obj)

		$obj.parents("UL").find("a").removeClass("selected");
		$obj.addClass("selected");
		var param = new DataMap();
		param.put("PMENUID", 'CL65');
		var json = netUtil.sendData({
			url : "/portal/json/menuChange.data",
			param : param
		});
		if(json && json.data){
			window.top.reloadLeft();
		}
		page.linkPageOpen('CL6501', rowData ,true);
	}

	function getCookie(key) {
		var result = null;
		var cookie = document.cookie.split(';');
		cookie.some(function (item) {
			// 공백을 제거
			item = item.replace(' ', '');

			var dic = item.split('=');

			if (key === dic[0]) {
				result = dic[1];
				return true;    // break;
			}
		});
		return result;
	}





</script>
</head>
<style>
	.slick-prev:before, .slick-next:before {font-size:0;content:'';opacity:0;}
</style>
<body style="min-width:1200px;">
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="search_next_wrap">
			<div class="content-vertical-wrap">

				<div class="content_layout tabs right-search" style="height:300px">
					<ul class="tab tab_style02">
						<li><a href="#tab1-2"><span>프로젝트 결과정보(대시보드)</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-2">
						<div id="chartContainer" class="content_layout_audit" style="height: calc(100% - 27px);width: calc(100% - 20px); margin: 0;">
							<div class="bxslider center" style="height:100%;">
							  <div><h2 style="font-size:25px">프로젝트 01</h2>
								  <div class="">
									  검사결과 ㅇ0101110
								  </div>
							  </div>
							  <div><h2 style="font-size:25px">프로젝트 02</h2>
								  <div class="">
									  검사결과 ㅇ0101110
								  </div>
							  </div>
							  <div><h2 style="font-size:25px">프로젝트 03</h2>
								  <div class="">
									  검사결과 ㅇ0101110
								  </div>
							  </div>
							  <div><h2 style="font-size:25px">프로젝트 04</h2>
								  <div class="">
									  검사결과 ㅇ0101110
								  </div>
							  </div>
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
				<div class="content-horizontal-wrap h-wrap-min" style="height:calc(100% - 320px);">

					<div class="content_layout tabs ">
						<ul class="tab tab_style02">
							<li><a href="#tab1-1"><span>게시판</span></a></li>
							<li class="btn_zoom_wrap">
								<ul>
									<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
									<li><button class="btn btn_bigger"><span>확대</span></button></li>
								</ul>
							</li>
						</ul>
						<div class="table_box section" id="tab1-1">
							<div class="table_list01">
								<div class="scroll"  >
									<table class="table_c"  >
										 <tbody id="gridLIst001">
											<tr CGRow="true">
												<td GH="40" GCol="rownum">1</td>
												<td GH="100 STD_GB" GCol="text,GB_TEXT" style="text-align: center;"></td>
												<td GH="800" GCol="fn,TITLE,attachedFile"></td>
												<td GH="200 STD_CREID" GCol="text,REG_NM"></td>
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
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>