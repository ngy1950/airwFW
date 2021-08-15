<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function() { 
		gridList.setGrid({
			id : "gridList",
			editable : false,
			//pkcol : "USERID",
			module : "System",
			command : "WRK_HIST",
            autoCopyRowType : false
		});
	}); 

	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}
	}
	function searchList() {
		//var param = dataBind.paramData("searchArea");
	
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
		$('.tabs').tabs("option","active",0);
	}

	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
    function comboEventDataBindeBefore(comboAtt){
        if(comboAtt == "WmsCommon,OWNERCOMBO"){
            var param = new DataMap();
            param.put("USERID", "<%=userid%>");
            param.put("LANGKY", "<%=langky%>");
            param.put("OWNRKY", "<%=ownrky%>");
            return param;
        }
    }
	
</script>
</head>
<body>
	<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
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
				<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
	                        <th CL="STD_WAREKY"></th>
	                        <td>
	                            <input type="text" name="WAREKY" value="<%=wareky%>" UISave="false" readonly="readonly"/>
	                        </td>
	                    </tr>
	                    <!-- 
	                    <tr>
	                        <th CL="STD_OWNRKY"></th>
	                        <td>
	                            <select Combo="WmsCommon,OWNERCOMBO" name="OWNRKY" UISave="false"  disabled="disabled"></select>
	                        </td>
                    	</tr>
                    	 -->
                    	<tr>
							<th CL="STD_TASDAT"></th>
							<td >
								<input type="text" name="CREDAT"  UIFormat="C N" UISave="false"  validate="required(STD_TASDAT)" />
							</td>
						</tr>
						<tr>
	                        <th CL="STD_USERID"></th>
	                        <td>
	                            <input type="text" name="CREUSR" validate="required(STD_USERID)" UIInput="S,SHUSRMA" />
	                        </td>
	                    </tr>
						<tr>
	                        <th CL="STD_USERNM"></th>
	                        <td>
	                            <input type="text" name="CUSRNM" />
	                        </td>
	                    </tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- //searchPop -->

	<!-- content -->
	<div class="content">
		<div class="innerContainer">

			<!-- contentContainer -->
			<div class="contentContainer">

				<div class="bottomSect type1">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
													<td GH="100 STD_WAREKY"    GCol="text,WAREKY"></td>
													<td GH="100 STD_TRNHTY"    GCol="text,TRNHTY"></td>
													<td GH="100 STD_TASOTY"    GCol="text,TASKTY"></td> 
													<td GH="100 STD_TASUSR"   GCol="text,CREUSR"></td>
                                                	<td GH="100 STD_TASUSM"   GCol="text,CUSRNM"></td>
													<td GH="100 STD_STOKKY"    GCol="text,STOKKY"></td>
													<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"></td>
													<td GH="100 STD_SKUKEY"      GCol="text,SKUKEY"></td>
													<td GH="100 STD_DESC01"      GCol="text,DESC01"></td>
													<td GH="100 STD_DESC02"      GCol="text,DESC02"></td>
													<td GH="100 STD_DESC03"      GCol="text,DESC03"></td>
													<td GH="100 STD_QTTAOR"    GCol="text,QTPROC" GF="N"></td>
													<td GH="100 STD_TASDAT"     GCol="text,CREDAT" GF="D"></td>
													<td GH="100 STD_TASTIM"     GCol="text,CRETIM" GF="T"></td>
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
                                    <!-- <button type="button" GBtn="total"></button> -->
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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