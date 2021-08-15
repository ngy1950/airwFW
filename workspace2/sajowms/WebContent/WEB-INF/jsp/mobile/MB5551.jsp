<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>배송보고</title>
<style type="text/css">
#dlvReport {
	display:none;
}
#dlvlist {
	display:display;
}
.btn_reload{
	background: url(/common/theme/webdek/images/refresh.png) no-repeat;
    background-size: 42px auto;
    width:7em;
    height:15em;
}
#gridList >tr > td > button{
    font-size: 1em;
    width: 23%;
    height: 100%;
    color: #fff;
}
#gridList >tr > td  button { /* :first-of-type { */
    background-color: #3c3c3f;;
    float: left;
    margin-left:12px;
}

/* { */
/*     background-color: #41a11c; */
/*     float: left; */
/*     margin-left:10px; */
/* } */
#gridList >tr > td  button:last-of-type, #gridList >tr > td  button:nth-child(2) {
    background-color: #41a11c;
    float: left;
    margin-left:12px;
}
.btn_display_row{
	display:none;
}
.btn_display_view{
	display:display;
}
.scanflag{
	color: red;
    font-weight: bold;
}
</style>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">
	
	var JOB_CD,ACT_DT;
	
	$(document).ready(function(){
		
		gridList.setGrid({
	    	id : "gridList",
			module : "MB1000",
			command : "MB5551",
			gridMobileType : true
	    });
		
		gridList.setGrid({
	    	id : "gridList1",
			module : "MB1000",
			command : "MB5551",
			gridMobileType : true
	    });
		
		$("button.btn_reload").on("click",function(){
			console.log("재조회");
			searchList();
		});
		
		$("#SCAN_NO").keydown(function(key) {
			if (key.keyCode == 13) {
				var scan_no = $("#SCAN_NO").val();
				var temp = $("#gridList1 > tr > td:contains('"+scan_no+"')");
				if($(temp).length > 0){
					var scanflag = $(temp).parent().find("[name=scan_check]");
					$(scanflag).text("V");
					$("#SCAN_NO").val("");
					var offset = $(scanflag).parent();
// 					console.log(offset.top);
					$(".scroll").animate({scrollTop : offset[0].offsetTop}, 400);
				}else{
					commonUtil.msgBox("스캔한 데이타가 대상에 존재하지 않습니다.");
					return;
				}
			}
		});
		
		$("input[name='ACT_DT']").on("change",function(){
			searchList();
		})
		
		searchList();
	});
	
	/* 조회 */
	function searchList(){
		if(validate.check("searchArea")){
			
			/* 테이블 초기화 */
			$("#gridList").empty();
			
			var param = inputList.setRangeParam("searchArea");
			param.put("USERID", "<%=userid%>");
			
			ACT_DT = param.get("ACT_DT");;
			
			var json = netUtil.sendData({
				module : "MB1000",
				command : "MB5551",
				sendType : "list",
				param : param
			});
			
			if(json && json.data){
				if(json.data.length == 0){
					commonUtil.msgBox("SYSTEM_DATAEMPTY");
					return;
				}
				
				$("#tab1-1 > div.btn_lit.tableUtil > span > span").text(json.data.length);
				var data;
				var str="";
				for(var i=0; i<json.data.length; i++){
					data = json.data[i];
// 					console.log(data);
					str+="<tr CGRow='true' rowNum='"+i+"' onClick='gridListEventRowClick(\""+i+"\",\""+data+"\")'>";
					str+="<td align='center'>"+(i+1)+"</td>";
					str+="<td style='white-space:pre-line;'>"+data.AREA_NM+"<br>"+data.JOB_ADDR+"</td>";
					str+="<td align='center'>"+data.PUP_CNT+"</td>";
					str+="<td align='center'>"+data.DVP_CNT+"</td>";
					str+="</tr>";
					str+="<tr CGRow='true' id='btn_"+i+"' class='btn_display_row'>";
					str+="<td align='center' colspan='4'>";
					str+="<button onclick=\"SAReport('A','"+data.AREA_CD+"')\"><span>도착</span></button>";
					str+="<button onclick=\"SAReport('S','"+data.AREA_CD+"')\"><span>출발</span></button>";
					str+="<button onclick=\"JobReport('PUP','"+data.AREA_CD+"')\"><span>인수</span></button>";
					str+="<button onclick=\"JobReport('DVP','"+data.AREA_CD+"')\"><span>인계</span></button>";
					str+="</td>";
					str+="</tr>";
				}
				$("#gridList").html(str);
			}
		}
	}
	
	/* 저장 */
	function saveData(){
		var gridList = $("#gridList1");
		var gridListCnt = gridList.find("tr").length;
		var checkData = gridList.find("tr > td[name='scan_check']:contains('V')");
		
		if(checkData.length ==0){
			commonUtil.msgBox("스캔 처리 된 대상이 존재하지 않습니다.");
			return;
		}else if(gridListCnt != checkData.length){
			if(!commonUtil.msgConfirm("대상 갯수와 스캔 체크 된 데이타의 갯수가 일치 하지 않습니다.\n체크 된 데이타만 저장 처리 하시겠습니까?")){
				return false;
			}
		}
		
		var param = new DataMap();		
		var list = new Array();
		for(var i=0; i<checkData.length; i++){
			var data = new DataMap();
			data.put("USERID", "<%=userid%>");
			data.put("JOB_CD",JOB_CD);
			data.put("ACT_DT",ACT_DT);
			data.put("AREA_CD",$(checkData[i].parentNode).data("area_cd"));
			data.put("JOB_NO",$(checkData[i].parentNode).data("job_no"));
// 			console.log(data);
			list.push(data);
// 			console.log(list);
		}
		
		param.put("list",list);
		
		netUtil.send({
			url : "/GCLC/Mobile/json/saveMB5551.data",
			param : param,
			successFunction : "saveDataCallBack"
		}); 
		
	}
	
	/* 저장 콜백 */
	function saveDataCallBack (json, returnParam) {
		if( !json.data.cono && json.data ){
			commonUtil.msgBox("SYSTEM_SAVEOK");
	        searchList();
	        backList();
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
	}	
	
	/* 클릭 이벤트 */
	function gridListEventRowClick(rowNum,data){
		if($('#btn_'+rowNum).is('.btn_display_row')){
			$('#btn_'+rowNum).removeClass('btn_display_row');

			var cnt = parseInt($("#tab1-1 > div.btn_lit.tableUtil > span > span").text());
			if(rowNum == (cnt - 1)){
				var scanflag = $("#gridList > tr[rowNum='"+rowNum+"']");
				var offset = $(scanflag).offset();
					$(".scroll").animate({scrollTop : $("#gridList")[0].scrollHeight+50}, 400);
			}
		}else{
			$('#btn_'+rowNum).addClass("btn_display_row");
		}
	}
	
	function backList(){
		$("#dlvReport").fadeOut();
		$("#dlvList").fadeIn();
	}
	
	//인수인계 대상 리스트 조회
	function JobReport(jobCd,AreaCd){
		$("#gridList1").empty();
		
		JOB_CD = jobCd;
		var txt = (jobCd=="PUP")?"인수":"인계";
		var param = new DataMap();
		param.put("USERID", "<%=userid%>");
		param.put("JOB_CD",jobCd);
		param.put("AREA_CD",AreaCd);
		param.put("ACT_DT",ACT_DT);
		
		var json = netUtil.sendData({
			   module : "MB1000",
			   command : "MB5551_JOB",
			   sendType : "list",
			   param : param
		});
		
		if(json && json.data){
			if(json.data.length == 0){
				commonUtil.msgBox("BL_LIST_DATAEMPTY",[]);
				return;
			}
			$("#tab2-1 > div.btn_lit.tableUtil > span > span").text(json.data.length);
			var data;
			var str="";
			var i = 0
			
			for(var i=0; i<json.data.length; i++){
				data = json.data[i];
				if(i==0){
					$("#area_nm").text(data.AREA_NM);
					$("#area_addr").text(data.JOB_ADDR);
				}
// 				console.log(data);
				str+="<tr CGRow='true' rowNum='"+i+"' data-area_cd=\""+data.AREA_CD+"\" data-job_no=\""+data.JOB_NO+"\" >";
				str+="<td align='center'>"+(i+1)+"</td>";
				str+="<td style='white-space:pre-line;'>"+data.JOB_GUBN+"<br>"+data.JOB_NO+"</td>";
				str+="<td align='center'>"+data.PUCH_CNT+"</td>";
				str+="<td align='center'>"+data.WBL_NO+"</td>";
				str+="<td align='center' name='scan_check' class='scanflag'> </td>";
				str+="</tr>";
				
			}
			
			var span_temp = $("span[name='jobtitle']");
			for(var j=0;j<span_temp.length;j++){
				var temp = $(span_temp)[j];
				var text = temp.innerText;
				text = text.replace("{0}",txt);
				text = text.replace("인수",txt);
				text = text.replace("인계",txt);
				$(temp).html(text);
			}
			$("#gridList1").html(str);
			$("#dlvReport").fadeIn();
			$("#dlvList").fadeOut();
		}
		
	}
</script>
</head>
<body >	
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner" id="dlvList">
			<div class="content_serch" id="searchArea">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:40%" />
							<col style="width:60%" />
						</colgroup>
						<tr>
							<th CL="실행일자"></th>
							<td class="ms-wrap">
								<input type="text" class="input" name="ACT_DT" UIFormat="C N" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% -125px);">
				<ul class="tab tab_style02">
					<li class="selected"><a href="#tab1-1"><span>배송보고</span></a></li>
					<li class="btn_zoom_wrap">
					<ul>
						<li><button class="btn_reload" title="재조회"><span> </span></button></li>
					</ul>
				</li>
				</ul>
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 175px);">
                        <div class="table_thead tableHeader">
                            <table>
                                <colgroup>
                                    <col width="10%">
                                    <col width="60%">
                                    <col width="15%">
                                    <col width="15%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2">번호</th>
                                        <th rowspan="2">작업지정보</th>
                                        <th colspan="2">수량<br>(운송장/행낭)</th>
                                    </tr>
                                    <tr>
                                        <th>인수</th>
                                        <th>인계</th>
                                    </tr>
                                </thead> 
                            </table>
                        </div>
						<div class="scroll" style="height: 1300px;"> <!-- "height:calc(100% - 110px);"> -->
							<table class="table_c">
							<colgroup>
									<col width="10%">
									<col width="60%">
									<col width="15%">
									<col width="15%">
								</colgroup>
								<tbody id="gridList">
									
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<div class="btn_out_wrap">

						</div>
						<span class='txt_total' >총 <span GInfoArea='true'></span> 건</span>
					</div>
				</div>
				<div class="table_box" id="tab1-2" style="display:none;">
					<div class="inner_search_wrap">
					</div>
				</div>
			</div>			
			<!-- 하단 버튼 시작 -->
<!-- 			<div class="foot_btn"> -->
<!-- 				<button onclick="searchList()"><span>조회</span></button> -->
<!-- 				<button onclick="saveData()"><span>저장</span></button> -->
<!-- 			</div> -->
			<!-- 하단 버튼 끝 -->
		</div>
		<!-- content 끝 -->
		<div class="content_inner" id="dlvReport">
			<div class="content_serch" id="searchArea">
				<div class="search_inner">
					<table class="search_wrap ">
						<colgroup>
							<col style="width:20%" />
							<col style="width:80%" />
						</colgroup>
						<tr>
							<td colspan="2" id="area_nm" style='white-space:pre-line;font-size:3em'>
								
							</td>
						</tr>
						<tr>
							<td colspan="2" id="area_addr" style='white-space:pre-line;font-size:3em'>
								
							</td>
						</tr>
						<tr>
							<th>스캔</th>
							<td>
								<input type="text" autocomplete="off" class="input" id="SCAN_NO" name="SCAN_NO" IAname="Search" style="width:calc(100% - 60px;)"  placeholder="스캔하세요"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="foot_btn">
								<button onclick="backList()"><span name="jobtitle">{0}서명</span></button>
								<button onclick="backList()"><span>특이사항</span></button>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="content_layout tabs" style="height: calc(100% - 675px);">
				<ul class="tab tab_style02">
						<li class="selected"><a href="#tab2-1"><span name="jobtitle">{0}</span></a></li>
<!-- 						<li class=""><a href="#tab1-2"><span>인계</span></a></li> -->
						<li class="btn_zoom_wrap">
						<ul>
							<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
							<li><button class="btn_reload" title="재조회"><span> </span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab2-1" style="height: calc(100% - 30px);">
					<div class="table_list01" style="height: calc(100% - 55px); overflow:initial;">
	                    <div class="table_thead tableHeader" style="overflow:initial;">
		                    <table>
	                            <colgroup>
	                                <col width="10%">
	                                <col width="45%">
	                                <col width="15%">
	                                <col width="15%">
	                                <col width="15%">
	                            </colgroup>
	                            <thead>
	                                <tr>
	                                    <th>번호</th>
	                                    <th>작업정보</th>
	                                    <th>행낭</th>
	                                    <th>운송장</th>
	                                    <th>스캔</th>
	                                </tr>
	                            </thead>    
	                        </table>
	                    </div>
						<div class="scroll" style="height:calc(100% - 100px);"> <!-- "height:calc(100% - 110px);"> -->
							<table class="table_c">
								<colgroup>
									<col width="10%">
									<col width="45%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
								</colgroup>
								<tbody id="gridList1">
									
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<div class="btn_out_wrap">
	
						</div>
						<span class='txt_total' >총 <span GInfoArea='true'></span> 건</span>
					</div>
				</div>	
			</div>
			<div class="foot_btn">
				<button onclick="saveData()"><span name="jobtitle">{0}완료</span></button>
				<button onclick="backList()"><span>목록보기</span></button>
			</div>
		</div>
	</div>
</body>
</html>