<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>운행일지 등록</title>
<%@ include file="/common/include/mobile/head.jsp" %>
<style type="text/css">
 .input{width: 100%}
</style>
<script type="text/javascript">

	$(document).ready(function(){
		
	});
	
	/* 현황 */
	function searchList(){
		this.location.href = "/mobile/MB9021.page?dt="+$('#OPRAT_DT').val().replace(/\./gi,'');
		
	}
	
	/* 저장 */
	function saveData(){
		var param = inputList.setRangeParam("inputInfoArea");
		param.put("OPRAT_DT",$('#OPRAT_DT').val().replace(/\./gi,''));
		/* param.put("OPRAT_DSTC",$('#OPRAT_DSTC').val().replace(/,/g,''));
		param.put("OILING_QY",$('#OILING_QY').val().replace(/,/g,''));
		param.put("OILING_AMT",$('#OILING_AMT').val().replace(/,/g,''));
		param.put("HPSS_AMT",$('#HPSS_AMT').val().replace(/,/g,''));
		*/
		
		if( !commonUtil.msgConfirm("SYSTEM_SAVECF") ){	
			return;
		}
		
		var json = netUtil.sendData({
			module : "MB1000",
			command : "MB9020",
			param : param,
			sendType : "update"
		 });
		
		if(json.data){
			commonUtil.msgBox("SYSTEM_SAVEOK");
			this.location.reload();
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
		
		
	}
	
	

</script>
</head>
<body >
	<!-- content 시작 -->
	<div class="content_wrap">
		<div class="content_inner">
			<div class="content_serch" id="searchArea" style="height:100px">
					<div class="search_inner">
						<table class="search_wrap ">
							<colgroup>
								<col style="width:30%" />
								<col style="width:70%" />
							</colgroup>
							<tr>
								<th CL="STD_DT"></th>
								<td>
									<input type="text" class="input" id="OPRAT_DT" name="OPRAT_DT" UIInput="SB" UIFormat="C N" validate="required" style="width: 75%;" />
								</td>
							</tr>
						</table>
					</div>
				</div>
			<div class="content_layout tabs" style="height:80%;">
				<div class="table_box section" id="tab1-1" style="height: 100%;">
					<div class="table_list01" style="height: calc(100% - 130px);">
						<div class="scroll" style="height: calc(100% - 5px);">
							<div class="table_inner_wrap" style="width: 100%;height:100%;">
								<div class="inner_search_wrap table_box" id="inputInfoArea" style="height:50%;">
									<table class="detail_table" id="areaData" style="height:100%;">
										<colgroup>
											<col width="30%" />
											<col width="70%" />
										</colgroup>
										<tbody>			
											<tr height="3%">
												<th CL="BL_OPRAT_DSTC_KM"></th>
												<td>
													<input type="text" class="input" id="OPRAT_DSTC" name="OPRAT_DSTC" UIFormat="N 6" style="height:100%; font-size:1.5em" />
												</td>
											</tr>
											<tr height="3%">
												<th CL="BL_OILING_QY_L"></th>
												<td>
													<input type="text" class="input" id="OILING_QY" name="OILING_QY" UIFormat="N 15" style="height:100%; font-size:1.5em" />	
												</td>
											</tr>
											<tr height="3%">
												<th CL="BL_OILING_AMT"></th>
												<td>
													<input type="text" class="input" id="OILING_AMT" name="OILING_AMT" UIFormat="N 15" style="width:99%; height:100%; font-size:1.5em" />
												</td>
											</tr>
											<tr height="3%">
												<th CL="BL_HPSS_AMT"></th>
												<td>
													<input type="text" class="input" name="HPSS_AMT" id="HPSS_AMT" UIFormat="N 15" style="height:100%; font-size:1.5em" />
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="foot_btn">
				<button onclick="searchList()"><span>현황</span></button>
				<button onclick="saveData()"><span>저장</span></button>
			</div>
		</div>
		<!-- content 끝 -->
	</div>
</body>
</html>