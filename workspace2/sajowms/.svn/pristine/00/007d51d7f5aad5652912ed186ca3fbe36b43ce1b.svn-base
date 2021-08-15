<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UI01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<style type="text/css">
#detail input{width:100%; height: 100%;}
</style>
<script type="text/javascript">
	var flag = "";
	function searchList() {
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
	
			var json = netUtil.sendData({
				module : "System",
				command : "NUMOBJval",
				sendType : "map",
				param : param
			});
			if (json.data["CNT"] > 0) {
				flag = "U";
			
				var json = netUtil.sendData({
					module : "System",
					command : "NR01",
					sendType : "map",
					param : param
				});
// 				searchOpen(false);
		        dataBind.dataNameBind(json.data, "detail");
			} else {
				flag = "I";
				commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY);	
// 				searchOpen(true);
			}
		}
	}
	
	function saveData() {
		if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {
			return;
		}
		var list = dataBind.paramData("detail");
		//alert(list);
		var param = new DataMap();
	
		param.put("list", list);
		param.put("flag", flag);
	
		var json = netUtil.sendData({
			url : "/admin/json/NR01.data",
			param : param
		});
	
		if (json && json.data) {
			searchList();
		}
	}
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			test3();
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
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
<!-- 					<input type="button" CB="Save SAVE BTN_SAVE" /> -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="CMCDKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_NUMOBJ"></dt>
						<dd>
							<input type="text" class="input" name="NUMOBJ"  UIFormat="U" validate="required"/>
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
					<div class="inner_search_wrap" id="detail" style="width: 900px">
						<table class="detail_table">
							<colgroup>
								<col width="30%" />
								<col width="70%" />
							</colgroup>
							<tbody>
								<tr>
									<th CL="STD_SHORTX">설명</th>
									<td>
										<input type="text" name="SHORTX" />
									</td>
								</tr>
								<tr>
									<th CL="STD_NUMBFR">From 번호</th>
									<td>
										<input type="text" name="NUMBFR" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th CL="STD_NUMBTO">To 번호</th>
									<td>
										<input type="text" name="NUMBTO" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th CL="STD_NUMBCR">현재 번호</th>
									<td>
										<input type="text" name="NUMBST" GF="N 10">
									</td>
								</tr>
								<tr>
									<th CL="STD_CREDAT">생성일시</th>
									<td>
										<input type="text" name="CREDAT" readonly="readonly"/> 
									</td>
								</tr>
								<tr>
									<th CL="STD_CREUSR">생성자</th>
									<td>
										<input type="text" name="CREUSR" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th CL="STD_LMODAT">수정일시</th>
									<td>
										<input type="text" name="LMODAT" readonly="readonly"/> 
									</td>
								</tr>
								<tr>
									<th CL="STD_LMOUSR">수정자</th>
									<td>
										<input type="text" name="LMOUSR" readonly="readonly" />
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
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>