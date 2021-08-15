<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,com.common.bean.DataMap,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
    XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

    DataMap param = (DataMap)request.getAttribute("param");
    DataMap head = (DataMap)request.getAttribute("head");
    List itemList = (List)request.getAttribute("itemList");
    
    TreeMap search = new TreeMap();
    TreeMap grid = new TreeMap();
    
    String returnParam = null;
    DataMap row;
    for(int i=0;i<itemList.size();i++){
        row = (DataMap)itemList.get(i);
        if(row.getString("INDRVL").equals("V")){
            returnParam = sFilter.getXSSFilter(row.getString("DBFILD"));
        }
        if(row.getString("INDUSO").equals("V")){
            search.put(sFilter.getXSSFilter(row.getString("POSSOS")), new Integer(i));
        }
        if(row.getString("INDULS").equals("V")){
            grid.put(sFilter.getXSSFilter(row.getString("POSLIS")),  new Integer(i));
        }
    }
    
    String title = sFilter.getXSSFilter(head.getString("SHORTX"));
    String where = sFilter.getXSSFilter(head.getString("DWHERE"));
    String orderby = sFilter.getXSSFilter(head.getString("DORDER")).trim();
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=title%></title>
<%@ include file="/common/include/searchHead.jsp" %>

<script type="text/javascript">
	var maxSelectCount = 1000;
    configData.MENU_ID = '<%=sFilter.getXSSFilter(param.getString("SHLPKY"))%>';

    window.resizeTo('<%=sFilter.getXSSFilter(head.getString("WIDTHW"))%>','<%=sFilter.getXSSFilter(head.getString("HEIGHT"))%>');
    
    $(document).ready(function(){
        gridList.setGrid({
            id : "gridList",
            editable : true,
            //module : "Common",
            //command : "SEARCH",
            url : "/common/search/json/data.data"
            //url : "/common/json/searchSql.data"
        }); 
        
        <%
            if(head.containsKey("EXECTY") && "V".equals(head.getString("EXECTY")) ){
        %>
            searchList();
        <%
            }
        %>
        
    });
	
	function searchList(){
		if(validate.check("searchArea")){
			var dwhere = "<%=where%>";
			/*
			var param;			
			if($.trim(dwhere)){
				var areaParam = dataBind.paramDataKeys("searchArea");
				var inParam = commonUtil.stringInMap(dwhere, areaParam);
				var dataParam = dataBind.paramData("searchArea");
				param = inputList.setRangeParamAll("searchArea", null, inParam);
				var tmpWhere = param.get(configData.INPUT_RNAGE_SQL);
				dwhere = commonUtil.stringBindMap(dwhere, dataParam);
				if($.trim(tmpWhere)){
					tmpWhere = dwhere+" ( "+tmpWhere.substring(4)+" ) ";
				}else{
					tmpWhere = dwhere+" 1=1 ";
				}
				param.put(configData.INPUT_RNAGE_SQL, tmpWhere);
			}else{
				param = inputList.setRangeParamAll("searchArea");
			}
			*/
			
			var paramCnt = new DataMap();
			paramCnt.put("CMCDVL", "<%=sFilter.getXSSFilter(param.getString("SHLPKY"))%>");
			
			var json = netUtil.sendData({
                module : "System",
                command : "SEARCHHELPCNT",
                sendType : "map",
                param : paramCnt
            });
            
            if ( json.data["CNT"] != 0 ){
            	dwhere += " AND ROWNUM <= " + json.data["CNT"] + " ";
            }
			
			var param = inputList.setRangeDataParam("searchArea");
			var inputParam = dataBind.paramData("searchArea");
			param.put(configData.INPUT_SEARCH_PARAM_KET, inputParam);
			if($.trim(dwhere)){
				param.put("WHARE_SQL", dwhere);
			}
	
			param.put("SHLPKY","<%=sFilter.getXSSFilter(param.getString("SHLPKY"))%>");
			param.put("ORDER_SQL","<%=orderby%>");
			
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
        
        window.opener.page.returnSearchHelp(dataList);
        searchHelpEventCloseAfter(configData.MENU_ID, true, dataList, rowList);
    <%
        }else{
    %>
        window.opener.page.returnSearchHelp(rowData.get("<%=returnParam%>"));
        searchHelpEventCloseAfter(configData.MENU_ID, false, rowData.get("<%=returnParam%>"), rowData);
    <%
        }
    %>
        this.close();
    }
    
    function multiSelect(){
        var selectData = gridList.getSelectData("gridList");
        if(selectData.length > maxSelectCount){
        	commonUtil.msgBox("VALID_maxselect",[maxSelectCount]);
        	return;
        }
        var rowData;
        var dataList = new Array();
        for(var i=0;i<selectData.length;i++){
            rowData = selectData[i];
            dataList.push(rowData.get("<%=returnParam%>"));
        }
        window.opener.page.returnSearchHelp(dataList);
        searchHelpEventCloseAfter(configData.MENU_ID, true, dataList, selectData);
        this.close();
    }
    
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }
    }
    

    //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
    function comboEventDataBindeBefore(comboAtt,paramName){
        if ( comboAtt == "Common,COMCOMBO"){
			var param = new DataMap();
			var name =  $(paramName).attr('name');
			
			if ( name == "SKDGRP" ){
				param.put("CODE","SKDGRP");
				param.put("USARG1","V");
			}
			
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

<%
int indusoCnt = search.size();
int indusoHgt = 0;

if(indusoCnt == 1) {
	indusoHgt = 80;
} else if(indusoCnt > 1) {
	indusoHgt = ((23 * (indusoCnt - 1)) + 80);
} else {
	indusoHgt = 0;
}
String searchCnt = "height:" + indusoHgt + "px;";
String topHgt = "top:" + ( indusoHgt + 20 ) + "px;";
%>

<!-- content -->
<div class="content">
    <div class="innerContainer">
        <!-- contentContainer -->
        <div class="contentContainer">
            <div class="bottomSect top"  id="searchArea" style="<%=searchCnt%>">
                <div class="tabs">
                    <ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
                    <div id="tabs1-1">
                        <div class="section type1">
                            <table class="table type1">
	                            <colgroup>
				                    <col width="100" />
				                    <col />
				                </colgroup>
				                <tbody>
				                <%
				                    Iterator skey = search.keySet().iterator();
				                    String ltype = "1";
				                    String dfValue;
				                    String fType;
				                    while (skey.hasNext()) {
				                        String key = skey.next().toString();
				                        row = (DataMap)itemList.get(((Integer)search.get(key)).intValue());
				                        if(row.getString("LBTXTY").equals("M")){
				                            ltype = "2";
				                        }else if(row.getString("LBTXTY").equals("L")){
				                            ltype = "3";
				                        }else{
				                            ltype = "1";
				                        }
				                        
				                        if(!row.getString("DFVSOS").equals(" ")){
				                            dfValue = sFilter.getXSSFilter(row.getString("DFVSOS"));
				                        }else if(row.getString("DBFILD").equals("WAREKY")){
				                            dfValue = wareky;
				                        }else if(row.getString("DBFILD").equals("OWNRKY")){
				                            dfValue = ownrky;
				                        }else if(row.getString("DBFILD").equals("COMPKY")){
				                            dfValue = compky;
				                        }else if(row.getString("DBFILD").equals("LANGKY")){
				                        	dfValue = langky;
				                        }else{
				                            dfValue = "";
				                        }
				                        
				                        if(!dfValue.equals("")){
				                            dfValue = "value='"+dfValue+"'";
				                        }else{
				                            dfValue = "";
				                        }
				                        
				                        if( param.getString("SHLPKY").equals(row.getString("SHLPKY") )){
				                        	row.put("SHLPKY","");
				                        }
				                        
				                        if(row.getString("OBJETY").equals("DAT")){
				                            fType = "UIFormat='C N'";
				                        }else if(row.getString("UCASOL").equals("V")){
				                            fType = "UIFormat='U'";
				                        }else{
				                            fType = "";
				                        }
				                %>
				                    <tr>
				                        <th CL="<%=sFilter.getXSSFilter(row.getString("LABLGR"))+"_"+sFilter.getXSSFilter(row.getString("LABLKY"))+","+ltype%>"></th>
				                        <td>
				                            <%
				                                if(row.getString("OBJETY").equals("CHB")){
				                            %>
				                                <input type="checkbox" name="<%=sFilter.getXSSFilter(row.getString("DBFILD"))%>" value="V" <%=sFilter.getXSSFilter(row.getString("INDNED")).equals("V")?"disabled='disabled'":""%> <%=sFilter.getXSSFilter(row.getString("SHLPKY")).equals("EMPTY")?"CheckEmptyVal=' '":""%>/>
				                            <%
				                                }else if(row.getString("OBJETY").equals("CBO")){
				                            %>
				                                <select Combo="<%=sFilter.getXSSFilter(row.getString("SHLPKY"))%>" name="<%=sFilter.getXSSFilter(row.getString("DBFILD"))%>" <%=sFilter.getXSSFilter(row.getString("RQFLDS")).equals("V")?"validate='required'":""%> <%=sFilter.getXSSFilter(row.getString("INDNED")).equals("V")?"disabled='disabled'":""%>>
				                                </select>
				                            <%
				                                }else if(row.getString("OBJETY").equals("CBOA")){
				                            %>
				                                <select Combo="<%=sFilter.getXSSFilter(row.getString("SHLPKY"))%>" name="<%=sFilter.getXSSFilter(row.getString("DBFILD"))%>" <%=sFilter.getXSSFilter(row.getString("RQFLDS")).equals("V")?"validate='required'":""%> <%=sFilter.getXSSFilter(row.getString("INDNED")).equals("V")?"disabled='disabled'":""%>>
				                                   <option value="">전체</option>
				                                </select>
				                            <%
				                                }else if(row.getString("INDNED").equals("V")){
				                            %>
				                                <input type="text" <%=dfValue%> name="<%=sFilter.getXSSFilter(row.getString("DBFILD"))%>" <%=sFilter.getXSSFilter(row.getString("SHLPKY")).equals(" ")?"":"UIInput='S,"+sFilter.getXSSFilter(row.getString("SHLPKY"))+"'"%> <%=fType%> readonly='readonly' <%=sFilter.getXSSFilter(row.getString("RQFLDS")).equals("V")?"validate='required'":""%>/>
				                            <%
				                                }else{
				                            %>
				                                <input type="text" <%=dfValue%> name="<%=sFilter.getXSSFilter(row.getString("DBFILD"))%>" UIInput="R<%=sFilter.getXSSFilter(row.getString("SHLPKY")).equals(" ")?"":","+sFilter.getXSSFilter(row.getString("SHLPKY"))%>" <%=fType%> <%=sFilter.getXSSFilter(row.getString("RQFLDS")).equals("V")?"validate='required'":""%>/>
				                            <%
				                                }
				                            %>
				                        </td>
				                    </tr>
				                <%
				                        }
				                %>
				                 </tbody>
            				</table>
        				</div>
    				</div>
				</div>
			</div>
			              
			<div class="bottomSect bottom" style="<%=topHgt%>">                
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
                                    	<td GH="40"                 GCol="rownum"></td>
                                        <%
                                            if(param.containsKey("multyType")){
                                        %>
                                        <td GH="40"                 GCol="rowCheck"></td>
                                        <%
                                            }
                                            skey = grid.keySet().iterator();
                                            while (skey.hasNext()) {
                                                String key = skey.next().toString();
                                                 
                                                row = (DataMap)itemList.get(((Integer)grid.get(key)).intValue());
                                                
                                                String rowString = "";
                                                String gCol      = "";
                                                String outlen    = "";
                                                
                                                if( row.getInt("DBLENG") != row.getInt("OUTLEN") && row.getInt("OUTLEN") >= 70 ) {
                                                	outlen = row.getString("OUTLEN");
                                                } else {
                                                	outlen = "70";
                                                }
                                                rowString = outlen + " " + sFilter.getXSSFilter(row.getString("LABLGR"))+"_"+sFilter.getXSSFilter(row.getString("LABLKY"));
                                                gCol      = "text," + sFilter.getXSSFilter(row.getString("DBFILD"));
                                        %>
                                        <td GH="<%=rowString %>" GCol="<%=gCol %>"></td>
                                        <%
                                            }
                                        %>
                                        </tr>    
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="tableUtil">
                                <div class="leftArea">
                                    <%
                                        if(param.containsKey("multyType")){
                                    %>
                                        <button class="type8" type="button" title="select" onClick="multiSelect()"><img src="/common<%=theme%>/images/grid_icon_01.png" /></button>
                                        <span CL="BTN_CHOOSE" style="vertical-align:middle;padding-left:5px;padding-right:5px"></span>
                                    <%
                                        }
                                    %>
                                    <button type="button" GBtn="find"></button>
                                    <button type="button" GBtn="sortReset"></button>
                                    <button type="button" GBtn="layout"></button>
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
<!-- layerPop -->
<div class="layerPopup box_wrapper">
    <button type="button" class="closer">X</button>
    <div class="tabs" id="rangePopupTabs">
        <ul class="selection">
            <li><a href="#tab1"><img src="/common<%=theme%>/images/ico_t1.png" alt="" /> <span CL="BOTTOM_SINGLEVAL"></span></a></li>
            <li><a href="#tab2"><img src="/common<%=theme%>/images/ico_t2.png" alt="" /> <span CL="BOTTOM_RANGES"></span></a></li>
        </ul>
        <div id="tab1">
        <div class="table type2 section" >
            <div class="tableHeader tbl_space tbl_small">
                <table>
                    <colgroup>
                        <col width="40px" />
                        <col width="40px" />
                        <col width="250px" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th CL="BOTTOM_NUM">Num</th>
                            <th CL="BOTTOM_OPER">Oper</th>
                            <th CL="BOTTOM_SINGLE">Single</th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div class="tableBody tbl_small">
                <table>
                    <colgroup>
                        <col width="40px" />
                        <col width="40px" />
                        <col width="250px" />
                    </colgroup>
                    <tbody id="rangeSingleList">
                        <tr CGRow="true">
                            <td GCol="rownum">1</td>
                            <td GCol="select,OPER" class="ico">
                                <select>
                                    <option value="E">=</option>
                                    <option value="N">≠</option>
                                    <option value="LT">＜</option>
                                    <option value="GT">＞</option>
                                    <option value="LE">≤</option>
                                    <option value="GE">≥</option>
                                </select>
                            </td>
                            <td GCol="input,DATA">DATA</td>
                        </tr>                       
                    </tbody>
                </table>
            </div>
        </div>
            <div class="tableUtil btn_wrap">
                <div class="leftArea">
                    <button class="button type2" type="button" onClick="rangeObj.confirmRange()"><img src="/common<%=theme%>/images/ico_confirm.png" alt="" /> <span CL="BOTTOM_CONFIRM"></span></button>
                    <button class="button type2" type="button" onClick="rangeObj.clearRange('rangeSingleList')"><img src="/common<%=theme%>/images/ico_cancel.png" alt="" /> <span CL="BOTTOM_CLEAR"></span></button>
                </div>
                <div class="rightArea">
                </div>
            </div>
        </div>
        <div id="tab2">
        <div class="table type2 section">
            <div class="tableHeader tbl_space tbl_big">
                <table>
                    <colgroup>
                        <col width="41px" />
                        <col width="41px" />
                        <col width="158px"/>
                        <col width="174px"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th CL="BOTTOM_NUM">Num</th>
                            <th CL="BOTTOM_OPER">Oper</th>
                            <th CL="BOTTOM_FROM">From</th>
                            <th CL="BOTTOM_TO">To</th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div class="tableBody tbl_space tbl_big">
                <table>
                    <colgroup>
                        <col width="40px" />
                        <col width="40px" />
                        <col width="155px"/>
                        <col width="154px"/>
                    </colgroup>
                    <tbody id="rangeRangeList">
                        <tr CGRow="true">
                            <td GCol="rownum">1</td>
                            <td GCol="select,OPER" class="ico">
                                <select>
                                    <option value="E">=</option>
                                    <option value="N">≠</option>
                                </select>
                            </td>
                            <td GCol="input,FROM">FROM</td>
                            <td GCol="input,TO">TO</td>
                        </tr>                       
                    </tbody>
                </table>
            </div>
            
        </div>
            <div class="tableUtil btn_wrap">
                <div class="leftArea">
                    <button class="button type2" type="button" onClick="rangeObj.confirmRange()"><img src="/common<%=theme%>/images/ico_confirm.png" alt="" /> <span CL="BOTTOM_CONFIRM"></span></button>
                    <button class="button type2" type="button" onClick="rangeObj.clearRange('rangeRangeList')"><img src="/common<%=theme%>/images/ico_cancel.png" alt="" /> <span CL="BOTTOM_CLEAR"></span></button>
                </div>
                <div class="rightArea">
                </div>
            </div>
        </div>      
    </div>
</div>
<!-- //layerPop -->

<!-- layout Save -->
<div id="layoutSavePop" class="layoutSavePop box_wrap">
    <div>
        <div class="section left box_wrapper">
            <div class="table type3">
                <div class="tableHeader">
                    <table>
                        <colgroup>
                            <col width="200" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>&nbsp;&nbsp;Invisible</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="tableBody tbl_wrap">
                    <table>
                        <colgroup>
                            <col />
                        </colgroup>
                        <tbody id="invisibleList">
                            <tr CGRow="true">
                                <td GCol="text,COLTEXT" layoutColName="GRID_COL_COLNAME_*" layoutColWidth="GRID_COL_COLWIDTH_*"></td>
                            </tr>                           
                        </tbody>                 
                    </table>
                </div>
            </div>
        </div>
        <div class="btnGroup btn_wrap">
                <button type="button" onClick="layoutSave.moveLeftAll()" title="leftAll">
                    <img src="/common<%=theme%>/images/btn_first.png" />
                </button>
                </br>
                <button type="button" onClick="layoutSave.moveLeft()" title="left">
                    <img src="/common<%=theme%>/images/btn_prev.png" />
                </button>
                </br>
                <button type="button" onClick="layoutSave.moveRight()" title="right">
                    <img src="/common<%=theme%>/images/btn_next.png" />
                </button>
                </br>
                <button type="button" onClick="layoutSave.moveRightAll()" title="rightAll">
                    <img src="/common<%=theme%>/images/btn_last.png" />
                </button>
        </div>
        <div class="section right box_wrapper">
            <div class="table type3">
                <div class="tableHeader">
                    <table>
                        <colgroup>
                            <col width="200" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>&nbsp;&nbsp;Visible</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="tableBody tbl_wrap">
                    <table>
                        <colgroup>
                            <col width="200" />
                        </colgroup>
                        <tbody id="visibleList">
                            <tr CGRow="true">
                                <td GCol="text,COLTEXT" layoutColName="GRID_COL_COLNAME_*" layoutColWidth="GRID_COL_COLWIDTH_*"></td>
                            </tr>
                        </tbody>                 
                    </table>
                </div>
            </div>
        </div>
        </div>
    <div class="layoutSaveTableUtil box_wrap">
            <div class="leftArea" >
                <!-- button class="button type6" type="button" onClick="layoutSave.confirmLayout()" title="Confirm"><img src="/common<%=theme%>/images/ico_confirm.png" /> Confirm</button-->
                <button class="type6" type="button" onClick="layoutSaveClose()" title="Cancel"><img src="/common<%=theme%>/images/ico_cancel.png" /> Cancel</button>
                <button class="type6" type="button" onClick="layoutSave.saveLayout()" title="Save"><img src="/common<%=theme%>/images/ico_cancel.png" /> Save</button>
            </div>
            <div class="rightArea">
                <button class="button type4" type="button" GBtnFind="true" title="moveTop" onclick="layoutSave.moveTop()"><img src="/common<%=theme%>/images/btn_up_02.png" /></button>
                <button class="button type4" type="button" GBtnCheck="true" title="moveUp" onclick="layoutSave.moveUp()"><img src="/common<%=theme%>/images/btn_up.png" /></button>                                 
                <button class="button type4" type="button" GBtnDelete="true" title="moveDown" onclick="layoutSave.moveDown()"><img src="/common<%=theme%>/images/btn_down.png" /></button>
                <button class="button type4" type="button" GBtnAdd="true" title="moveBottom" onclick="layoutSave.moveBottom()"><img src="/common<%=theme%>/images/btn_down_02.png" /></button>
            </div>
        </div>
    </div>
<!-- layout Save -->
</div>
<div class="contentLoading" id="contentLoading"></div>
</body>
</html>