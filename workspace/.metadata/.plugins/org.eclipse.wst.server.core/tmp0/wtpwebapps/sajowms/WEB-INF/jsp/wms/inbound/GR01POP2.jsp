<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL04POP</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">

	window.resizeTo('710','600');
	var tmpnum = " ";
	var skukey = " ";
	var count = 0;
	
	$(document).ready(function(){
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		
		var param = new DataMap();
		param.put("SKUKEY", data.map.SKUKEY );
		param.put("ASNDKY", data.map.ASNDKY);
		param.put("ASNDIT", data.map.ASNDIT);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR01POP2NEW"
		});
		
		var json = netUtil.sendData({
			module : "WmsInbound",
			command : "GR01POP2EXIST",
			sendType : "map",
			param : param
		});
		
		if(json && json.data){
			if(json.data["CNT"] >= 1){
				cmd = "GR01POP2";
				searchList();
			} 
			
			else if (json.data["CNT"] < 1){
				cmd = "GR01POP2NEW" ; 
				searchList();
				//creatList();
			}
		}
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param ,
	    	command : cmd
	    }); 
	} 
	
	function creatList(){
		var param = inputList.setRangeParam("searchArea");
		
		tmpnum = $("[name=TMPNUM]").parent().find(".searchInput").val();
		skukey = $("[name=SKUKEY]").parent().find(".searchInput").val();
			
	    var newData = new DataMap();
	    newData.put("FAILIT"," ");
		newData.put("ITNAME"," ");
		newData.put("REMARK"," "); 
		newData.put("QCUSER"," "); 
		                     
		gridList.setAddRow("gridList", newData);
		newData.clear();
	}
	
	function gridListEventDataViewEnd(gridId, dataLength){
		if(gridId == "gridList"){
			tmpnum = gridList.getColData("gridList",0,"TMPNUM");
			var param = inputList.setRangeParam("searchArea");
			param.put("TMPNUM",tmpnum);
			dataBind.dataNameBind(param, "searchArea");
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var param = inputList.setRangeParam("searchArea");
		tmpnum = param.get("TMPNUM");
		asndky = param.get("ASNDKY");
		asndit = param.get("ASNDIT");
		skukey = param.get("SKUKEY");
		
		var newData = new DataMap();
		newData.put("RECVKY"," ");
		newData.put("RECVIT"," ");
		newData.put("ASNDKY",asndky); 
		newData.put("ASNDIT",asndit);  
		newData.put("TMPNUM",tmpnum);
		newData.put("SKUKEY",skukey);
			
		return newData;
	}  
	
	function fn_closing(){
		this.close();
	}
	
	function fn_reflect(){
		var cnt = gridList.getModifyRowCount("gridList");
		if(cnt < 1){
			commonUtil.msgBox("MASTER_M0545");
			return;
		}
		
		var list = gridList.getGridData("gridList");
		var param = inputList.setRangeParam("searchArea");
		
		param.put("list",list); 
			
		var json = netUtil.sendData({
			url : "/wms/inbound/json/SaveGR01POP2.data",
			param : param
		});
		
		if(json && json.data){
			cmd = "GR01POP2";
			searchList();
			//page.linkPopClose();
			
		}else{
			commonUtil.msgBox("VALID_M0000");
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Reflect"){
			fn_reflect();
		}else if(btnName == "Check"){
			fn_closing();
		}else if(btnName == "Search"){
			searchList();
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode=="SHQCITEM"){
			var param = new DataMap();
			param.put("KINDQC", "REC");
			return param;
		}else if (searchCode=="SHFAILIT"){
			var qcitem =  gridList.getColData("gridList",0,"QCITEM").trim();
			if(qcitem == ""){
				alert("검사항목코드를 먼저 입력하세요.");
				return;
			}else {
				var param = new DataMap();
				param.put("QCITEM",qcitem);
				return param;
			}
			
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Reflect REFLECT BTN_REFLECT">
		</button>
		<button CB="Search SEARCH BTN_CLEAR">  <!-- 초기화  -->
		</button>
		<button CB="Check CHECK BTN_CLOSE">
		</button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs"><span>리스트</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div id="searchArea">
								<input type="hidden" name="OWNRKY" /><input type="hidden" name="TMPNUM" /><input type="hidden" name="ASNDKY" /><input type="hidden" name="ASNDIT" /><input type="hidden" name="QCTYPE" /></br> 
								제품 :  <input type="text" name="SKUKEY" readonly="readonly" style="width:100px"/> <input type="text" name="DESC01" readonly="readonly" style="width:250px"/>
							</div>
							
							<div class="table type2" style="top:50px">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="150" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_NUMBER"></th>
												<th CL="STD_QCITEM"></th>
												<th CL="STD_FAILIT"></th>
												<th CL="STD_ITNAME"></th>
												<th CL="STD_REMARK"></th>
												<th CL="STD_QCUSER"></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="150" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
											    <td GCol="input,QCITEM,SHQCITEM" validate="required"></td>
											    <td GCol="input,FAILIT,SHFAILIT" validate="required"></td>
												<td GCol="text,ITNAME" ></td>
												<td GCol="input,REMARK"></td>
												<td GCol="input,QCUSER" validate="required"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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
		<!-- //contentContainer -->
	    
	    </div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>