<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	function searchList() {
		if (validate.check("searchArea")) {
			var param = inputList.setRangeParam("searchArea");
			var numobj = param.get("NUMOBJ");
			var numChk = new DataMap();
			numChk.put("NUMOBJ", numobj);

			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "NUMOBJval",
				sendType : "map",
				param : param
			});
			if (json.data["CNT"] > 0) {
				flag = "U";
			
				netUtil.send({
					module : "WmsAdmin",
					command : "NR01",
					bindId : "tabs1-1",
					sendType : "map",
					bindType : "field",
					param : param
				});
				searchOpen(false);
			} else {
				flag = "I";
				searchOpen(false);
			}
		}

	}

	function saveData() {
		if (!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)) {
			return;
		}
		var list = dataBind.paramData("content");
		//alert(list);
		var param = new DataMap();

		param.put("list", list);
		param.put("flag", flag);

		var json = netUtil.sendData({
			url : "/wms/admin/json/NR01.data",
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
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY">
			</button>
			<button CB="Save SAVE STD_SAVE">
			</button>
		</div>
		<div class="util3">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
		</div>
	</div>
	<!-- searchPop -->
	<div class="searchPop" id="searchArea">
		<button type="button" class="closer">X</button>
		<div class="searchInnerContainer">
			<p class="util">
				<button CB="Search SEARCH BTN_DISPLAY"></button>
				<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
				<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
			</p>
		
			<div class="searchInBox">
				<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_NUMOBJ">채번 오브젝트</th>
							<td colspan="3"><input type="text" name="NUMOBJ"
								UIInput="S,SHNMOBJ" validate="required " /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- //searchPop -->

	<!-- content -->
	<div class="content" id="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
				<div class="bottomSect type1">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1" CL='STD_GENERAL'><span>일반</span></a></li>
						</ul>
						<div id="tabs1-1" class="tabs1-1">
						<div class="section type1">
							<!-- <div class="searchBox">
								<div class="searchInBox"> -->
									<table class="table type1">
										<colgroup>
											<col width="120" />
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th CL="STD_NUMOBJ">채번</th>
												<td><input type="text" name="NUMOBJ"
													UIInput="S,SHNMOBJ" readonly="readonly" /></td>
											</tr>
										</tbody>
									</table>
							<!-- 	</div>
								</div> -->
								<div class="searchInBox">
									<h2 class="tit" CL='STD_GENERAL'>일반</h2>
									<table class="table type1">
										<colgroup>
											<col width="100" />
											<col />
										</colgroup>
										<tbody id="gridList">
											<tr>
												<th CL="STD_SHORTX">설명</th>
												<td colspan="3"><input type="text" name="SHORTX" /></td>
											</tr>
											<tr>
												<th CL="STD_NUMBFR">From 번호</th>
												<td><input type="text" name="NUMBFR"
													readonly="readonly" /></td>
											</tr>
											<tr>
												<th CL="STD_NUMBTO">To 번호</th>
												<td><input type="text" name="NUMBTO"
													readonly="readonly" /></td>
											</tr>
											<tr>
												<th CL="STD_NUMBCR">현재 번호</th>
												<td><input type="text" name="NUMBST" GF="N 10">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="searchInBox">
									<h2 class="tit" CL='STD_SEARCH'>관리</h2> 
										<table class="table type1">
											<colgroup>
											<col width="100" />
											<col />
											</colgroup>
											<tbody>
												<tr>
													<th CL="STD_CREDAT">생성일자</th>
													<td><input type="text" name="CREDAT" GF="D" readonly="readonly" /> 
													<th CL="STD_CRETIM">생성시간</th>
													<td><input GCol="text,CRETIM" GF="T" readonly="readonly" /></td>
													<th CL="STD_CREUSR">생성자</th>
													<td><input type="text" name="CREUSR" readonly="readonly" /></td>
													<th CL="STD_CUSRNM">생성자명</th>
													<td><input type="text" name="CUSRNM" readonly="readonly" /></td>
												</tr>
												<tr>
													<th CL="STD_LMODAT">수정일자</th>
													<td><input type="text" name="LMODAT" GF="D" readonly="readonly" />
													<th CL="STD_LMOTIM">수정시간</th>
													<td><input type="text" name="LMOTIM" GF="T" readonly="readonly" /></td>
													<th CL="STD_LMOUSR">수정자</th>
													<td><input type="text" name="LMOUSR" readonly="readonly" /></td>
													<th CL="STD_LUSRNM">수정자명</th>
													<td><input type="text" name="LUSRNM" readonly="readonly" /></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>
			<!-- //contentContainer -->
		</div>
	</div>
	<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>