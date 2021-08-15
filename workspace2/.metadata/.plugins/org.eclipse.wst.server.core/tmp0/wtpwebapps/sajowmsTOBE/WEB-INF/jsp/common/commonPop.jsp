<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,project.common.bean.DataMap,java.util.*"%>
<%
	DataMap param = (DataMap)request.getAttribute("param");
	DataMap head = (DataMap)request.getAttribute("head");
	List itemList = (List)request.getAttribute("itemList");
	
	String returnParam = null;
	String returnText = "";
	DataMap row;
	for(int i=0;i<itemList.size();i++){
		row = (DataMap)itemList.get(i);
		if(row.getString("RETURNCOL").equals("V")){
			returnParam = row.getString("CPOPITEMID");
			//continue;
		}
		if(row.getString("RETURNCOL").equals("T")){
			returnText = row.getString("CPOPITEMID");
			//continue;
		}
	}
	
	String title = head.getString("CPOPNAME");
	if(title == null || title.equals("")){
		title = "조회결과";
	}
	
	if(head.getInt("SIZEW") == 0){
		head.put("SIZEW",520);
		head.put("SIZEH",700);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=title%></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
	configData.MENU_ID = '<%=param.getString("COMMPOPID")%>';
	window.resizeTo('<%=head.getString("SIZEW")%>','<%=head.getString("SIZEH")%>');
	$(document).ready(function(){

		var searchParam = window.opener.page.getSearchParam();
		var openerParam = opener.dataBind.paramData("searchArea");
		var noBind = (searchParam && searchParam.map && searchParam.map.NOBIND) ? "Y" : "N";

		//2021.01.07 cmu : 그리드에 searchHelp일 경우 그리드와 서치에어리어의 명칭이 중복되면 서치에어리어의 값을 서치헬프에 강제 대입 하므로 grid에서 열지 않았을 경우에만  searchArea값을 바인딩한다. 
		if(noBind != "Y"){ //2020.02.09 cmu 서치에어리어 데이터를 바인드하지 말아야 할 경우 값을 넘긴다.
			if(!window.opener.page.searchOpenGridId || window.opener.page.searchOpenGridId == ""){
				if(openerParam){
					dataBind.dataNameBind(openerParam, "searchArea");
					for(var prop in openerParam.map){
						if(inputList.rangeMap.containsKey(prop)){
							inputList.setRangeData(prop, configData.INPUT_RANGE_RANGE_FROM, openerParam.get(prop));
						}else if(prop.indexOf(".")){
							var tmpProp = prop.substring(prop.indexOf(".")+1);
							if(inputList.rangeMap.containsKey(tmpProp)){
								inputList.setRangeData(tmpProp, configData.INPUT_RANGE_RANGE_FROM, openerParam.get(prop));
							}				
						}
					}
				}
				
				for(var prop in opener.inputList.rangeMap.map){			
					if(inputList.rangeMap.containsKey(prop)){
						var tmpObj = opener.inputList.rangeMap.get(prop);
						var inputObj = inputList.rangeMap.get(prop);
						inputObj.singleData = tmpObj.singleData;
						inputObj.rangeData = tmpObj.rangeData;				
						inputObj.setMultiData();
					}else if(prop.indexOf(".")){
						var tmpProp = prop.substring(prop.indexOf(".")+1);
						if(inputList.rangeMap.containsKey(tmpProp)){
							var tmpObj = opener.inputList.rangeMap.get(prop);
							var inputObj = inputList.rangeMap.get(tmpProp);
							inputObj.singleData = tmpObj.singleData;
							inputObj.rangeData = tmpObj.rangeData;				
							inputObj.setMultiData();
						}				
					}
				}
			} 
		}
		
		if(searchParam){			
			//2021.01.07 cmu 해당 작업은 for문에서 사용 searchParam은 page.js searchHelpEventOpenBefore 함수에서 세팅 된 값만 보내므로 아래 로직과 중복됨
			//input 리스트 가져오는 로직은 위에 for문존재
			//dataBind.dataNameBind(searchParam, "searchArea");
			for(var prop in searchParam.map){
				if(inputList.rangeMap.containsKey(prop)){
					var obj = searchParam.get(prop);
					if(typeof obj == "string"){
						var inputObj = inputList.rangeMap.get(prop);
						inputObj.searchType = "from";
						inputObj.$from.val(obj);
						inputObj.valueChange();
					}else if(obj && obj.length > 0){
						if(typeof obj[0] == "string"){
							var sList = new Array();
							for(var i=0;i<obj.length;i++){
								var tmpMap = new DataMap();
								tmpMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
								tmpMap.put(configData.INPUT_RANGE_OPERATOR, "E");
								tmpMap.put(configData.INPUT_RANGE_SINGLE_DATA, obj[i]);
								sList.push(tmpMap);
							}
							inputList.setRangeData(prop, configData.INPUT_RANGE_TYPE_SINGLE, sList);
						}else{
							var sList = new Array();
							var rList = new Array();
							var tmpMap;
							for(var i=0;i<obj.length;i++){
								tmpMap = obj[i];
								if(tmpMap.containsKey(configData.INPUT_RANGE_SINGLE_DATA)){
									if(!tmpMap.containsKey(configData.INPUT_RANGE_LOGICAL)){
										tmpMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
									}
									if(!tmpMap.containsKey(configData.INPUT_RANGE_OPERATOR)){
										tmpMap.put(configData.INPUT_RANGE_OPERATOR, "E");
									}
									sList.push(tmpMap);
								}else{
									if(!tmpMap.containsKey(configData.INPUT_RANGE_OPERATOR)){
										tmpMap.put(configData.INPUT_RANGE_OPERATOR, "E");
									}
									rList.push(tmpMap);
								}
							}
							if(sList.length > 0){
								inputList.setRangeData(prop, configData.INPUT_RANGE_TYPE_SINGLE, sList);
							}
							if(rList.length > 0){
								inputList.setRangeData(prop, configData.INPUT_RANGE_TYPE_RANGE, rList);
							}
						}						
					}
				}
			}
		}
		
		gridList.setGrid({
	    	id : "gridList",
	    	editable : true,
	    	//module : "Common",
			//command : "SEARCH",
			url : "/common/search/json/data.data",
			menuId : "<%=param.getString("COMMPOPID")%>"
			//url : "/common/json/searchSql.data"
	    });	
		
		<%
			if("V".equals(head.getString("EXETYPE")) ){
		%>
			searchList();
		<%
			}
		%>
		 
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			var inputParam = dataBind.paramData("searchArea");
			param.put(configData.INPUT_SEARCH_PARAM_KET, inputParam);	
			param.put("COMMPOPID","<%=param.getString("COMMPOPID")%>");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
		
		//showSearch();
	}
	
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		try{
			window.opener.searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData);
		}catch(e){
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId != "gridList"){
			return;
		}
		var rowData = gridList.getRowData(gridId, rowNum);
	<%
		if(param.containsKey("multyType")){
	%>
		var dataList = new Array();
		dataList.push(rowData.get("<%=returnParam%>"));
		
		var rowList = new Array();
		rowList.push(rowData);
		
		var returnData = window.opener.page.returnSearchHelp(dataList, "", configData.MENU_ID, true, rowList);
		searchHelpEventCloseAfter(configData.MENU_ID, true, returnData, rowList);
	<%
		}else{
	%>
		var returnData = window.opener.page.returnSearchHelp(rowData.get("<%=returnParam%>"), rowData.get("<%=returnText%>"), configData.MENU_ID, false, rowData);
		searchHelpEventCloseAfter(configData.MENU_ID, false, returnData, rowData);
	<%
		}
	%>
		this.close();
	}
	
	function multiSelect(){
		var selectData = gridList.getSelectData("gridList");
		var rowData;
		var dataList = new Array();
		for(var i=0;i<selectData.length;i++){
			rowData = selectData[i];
			dataList.push(rowData.get("<%=returnParam%>"));
		}
		var returnData = window.opener.page.returnSearchHelp(dataList, "", configData.MENU_ID, true, selectData);
		searchHelpEventCloseAfter(configData.MENU_ID, true, returnData, selectData);
		this.close();
	}
	
 	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
</script>
<style type="text/css">
 .content_wrap{background: none;}
</style>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
				<%
				String dfValue = null;
				for(int i=0;i<itemList.size();i++){
					row = (DataMap)itemList.get(i);
					if(row.getString("SEARCHTYPE").equals("HIDDEN")){
						if(!row.getString("SDEFAULT").equals(" ")){
							if(row.getString("SDEFAULT").equals("SES_USER_COMPANY")){
								dfValue = compky;
							}else{
								dfValue = row.getString("SDEFAULT");
							}							
							dfValue = "value='"+dfValue+"'";
						}else{
							dfValue = "";
						}
				%>
				<input type="hidden" name="<%=row.getString("CPOPITEMID")%>" <%=dfValue%>/>
				<%
					}
				}
				%>
				<%
					String fType;
					String readOnly;
					String required;
					String label;
					int searchCount = 0;
					for(int i=0;i<itemList.size();i++){
						row = (DataMap)itemList.get(i);
						
						if(row.getString("ITEMTYPE").equals("GRID") || row.getString("SEARCHTYPE").equals("") || row.getString("SEARCHTYPE").equals("HIDDEN")){
							continue;
						}
						
						searchCount++;

						if(!row.getString("SDEFAULT").equals(" ")){
							if(row.getString("SDEFAULT").equals("SES_USER_COMPANY")){
								dfValue = compky;
							}else{
								dfValue = row.getString("SDEFAULT");
							}							
							dfValue = "value='"+dfValue+"'";
						}else{
							dfValue = "";
						}
						
						if(row.getString("SFORMAT").equals("DATE")){
							fType = "UIFormat='C N'";
						}else if(row.getString("SFORMAT").equals("UPPER")){
							fType = "UIFormat='U'";
						}else{
							fType = "";
						}
						
						if(row.getString("SFORMAT").equals("READONLY")){
							readOnly = "readonly='readonly'";
						}else{
							readOnly = "";
						}
						
						if(row.getString("SREQUIRED").equals("V")){
							required = "validate='required'";
						}else{
							required = "";
						}
						
						if(row.getString("CPOPITLABEL").equals("")){
							label = row.getString("CPOPITNAME");
						}else{
							label = "STD_"+row.getString("CPOPITLABEL");
						}
				%>
					<dl>
						<%
						if(row.getString("CPOPITLABEL").equals("")){
						%>
						<dt><%=label%></dt>
						<%
						}else{
						%>
						<dt CL="<%=label%>"></dt>
						<%
							}
						%>
						
						<dd>
							<%
								if(row.getString("SEARCHTYPE").equals("CHECK")){
									if(row.getString("SFORMAT").equals("READONLY")){
										readOnly = "disabled='disabled'";
									}else{
										readOnly = "";
									}
							%>
								<input type="checkbox" name="<%=row.getString("CPOPITEMID")%>" value="V" <%=readOnly%>/>
							<%
								}else if(row.getString("SEARCHTYPE").equals("INPUT") || row.getString("SEARCHTYPE").equals("LIKE")){
							%>
								<input type="text" class="input" <%=dfValue%> name="<%=row.getString("CPOPITEMID")%>" <%=row.getString("SOPTION").equals("")?"":"UIInput='S,"+row.getString("SOPTION")+"'"%> <%=fType%> <%=readOnly%> <%=required%>/>
							<%
								}else if(row.getString("SEARCHTYPE").equals("MULTI")){
							%>
								<input type="text" class="input" <%=dfValue%> name="<%=row.getString("CPOPITEMID")%>" UIInput="SR<%=row.getString("SOPTION").equals("")?"":","+row.getString("SOPTION")%>" <%=fType%> <%=readOnly%> <%=required%>/>
							<%
								}else if(row.getString("SEARCHTYPE").equals("SELECT")){
							%>
								<select class="input" name="<%=row.getString("CPOPITEMID")%>" CommonCombo="<%=row.getString("SOPTION")%>">
									<option value=""></option>
								</select>
							<%
								}else if(row.getString("SEARCHTYPE").equals("COMBO")){
							%>
								<select class="input" name="<%=row.getString("CPOPITEMID")%>" Combo="<%=row.getString("SDEFAULT")%>" <%=required%>>
									<option value=""></option>
								</select>
							<%
								}
							%>
						</dd>
					</dl>
				<%
						}
				%>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
		<div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><%=title%></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
									<%
										if(param.containsKey("multyType")){
									%>
										<td GH="50" GCol="rowCheck"></td>
									<%
										}
									%>
										
									<%
										for(int i=0;i<itemList.size();i++){
											row = (DataMap)itemList.get(i);
											if(row.getString("ITEMTYPE").equals("SEARCH") || row.getInt("GWIDTH") == 0){
												continue;
											}
											if(row.getString("CPOPITLABEL").equals("")){
												label = "";
											}else{
												label = " STD_"+row.getString("CPOPITLABEL");
											}
									%>
										<td GH="<%=(row.getInt("GWIDTH") >= 70?row.getString("GWIDTH"):"70")+label%>" GCol="text,<%=row.getString("CPOPITEMID")%>"></td>
									<%
										}
									%>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<%
							if(param.containsKey("multyType")){
						%>
						<button type='button' GBtn="multiSelect" onClick="multiSelect()"><span></span></button>
						<%
							}
						%>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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