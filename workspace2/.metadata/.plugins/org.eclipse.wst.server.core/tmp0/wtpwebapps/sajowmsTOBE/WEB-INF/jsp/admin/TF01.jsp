<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var itemnamelist = ["AREAKY","ZONEKY","LOCAKY","TKZONE","LOTA03","LOTA05","LOTA06","SKUKEY","STKQTY","LOTA13THISYEAR","LOTA13LASTMONTH","RNGVOP1","LOTA12THISYEAR","LOTA12LASTMONTH","RNGVOP2","LOTA11THISYEAR","LOTA11LASTMONTH","RNGVOP3"];
var headnamelist = ["OWNRKY", "WAREKY", "LOTRKY", "SHORTX"];

var rangelist = ["LOTA03", "LOTA05", "LOTA06","AREAKY", "ZONEKY", "LOCAKY", "TKZONE", "STKQTY", "SKUKEY"];

var reseth = new DataMap();
var reseti = new DataMap();
	$(document).ready(function(){
		resetinput();

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function resetinput(){
		for(var i=0;i<itemnamelist.length;i++){
			reseti.put(itemnamelist[i],"");
		}
		for(var i=0;i<headnamelist.length;i++){
			reseth.put(headnamelist[i],"");
		}
		
		inputList.setInput("tab2-1");
	}

	function searchList(){
		if(validate.check("searchArea")){
			dataBind.dataNameBind(reseth, "thead");
			dataBind.dataNameBind(reseti, "titem");
			
			var param = inputList.setRangeParam("searchArea");
			
			var json = netUtil.sendData({
				module : "Master",
				command : "TF01",
				bindId : "thead",
				sendType : "map",
				bindType : "field",
				param : param
			});
			
			var json2 = netUtil.sendData({
				module : "Master",
				command : "TF01_ITEM",
				bindId : "titem",
				sendType : "list",
				bindType : "field",
				param : param
			});
			
			var list = json2.data;				
			var tabs2_data = new DataMap();
			
			$.each(list, function(i, obj) {
				var name = obj.DBFILD.toUpperCase();
				var rngvop = obj.RNGVOP;
				
				tabs2_data.put(name, obj.RNGVMI);
			});
			
			$.each(rangelist, function(num, data) {
				var rangeList = new Array();
				var rngvop = "";
				$.each(list, function(i, obj) {
					if (obj.DBFILD.toUpperCase() == data) {
						var mangeMap = new DataMap();
						rngvop = obj.RNGVOP;
						if (rngvop == "BW") {
							mangeMap.put("OPER", "E");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("FROM", obj.RNGVMI);
							mangeMap.put("TO", obj.RNGVMX);
						}else if (rngvop == "NB") {
							mangeMap.put("OPER", "N");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("FROM", obj.RNGVMI);
							mangeMap.put("TO", obj.RNGVMX);	
						}else if (rngvop == "EQ") {
							mangeMap.put("OPER", "E");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "NE") {
							mangeMap.put("OPER", "N");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "LT") {
							mangeMap.put("OPER", "LT");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "GT") {
							mangeMap.put("OPER", "GT");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "LE") {
							mangeMap.put("OPER", "LE");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "GE") {
							mangeMap.put("OPER", "GE");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}else if (rngvop == "GP") {
							mangeMap.put("OPER", "GP");
							mangeMap.put("LOGICAL",obj.LOGICAL);
							mangeMap.put("DATA", obj.RNGVMI);
						}
						rangeList.push(mangeMap);
					}
				});
				if (rngvop == "BW" ||  rngvop == "NB") {
					inputList.setRangeData(data,
							configData.INPUT_RANGE_TYPE_RANGE, rangeList);
				} else {
					inputList.setRangeData(data,
							configData.INPUT_RANGE_TYPE_SINGLE, rangeList);
				}
			});
			
			dataBind.dataNameBind(json.data, "thead");
			dataBind.dataNameBind(tabs2_data, "titem");
		}
		
		
		
	}

	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	function saveData(){
		if(gridList.validationCheck("gridList", "data") 
	    && gridList.validationCheck("gridItemList", "data")){
			
	        if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
	        
	        if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
	        
	        gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A",
		    	msgType : false
		    });
	        
	        gridList.gridSave({
		    	id : "gridItemList",
		    	modifyType : "A",
		    	msgType : false
		    });

	        gridList.resetGrid("gridItemList");
			searchList();
			
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TF01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TF01");
 		}

	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }


    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridItemList'){
    		var hrowNum = gridList.getFocusRowNum("gridList");
    		var cmcdky = gridList.getColData("gridList", hrowNum, "CMCDKY");
    		
            var newData = new DataMap();
            newData.put("CMCDKY",cmcdky);
            
            return newData;
    	}
    }
    
    function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList" ){
        	var cnlcfm = gridList.getColData("gridItemList", rowNum, "CMCDKY");
			
			if(cnlcfm == 'MESGGR' ){
				return true;
			}
        }
    }
    
  //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTRKY"></dt>
						<dd>
							<input type="text" class="input" name="LOTRKY" UIInput="S,SHRLRRH" validate="required(STD_LOTRKY)"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
        	<div class="content_layout tabs top_layout" style="height: 150px;">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div id="tab1-1" class="inner_tablebox_wrap">
	                <div class="table_box section">
		                <div class="inner_search_wrap">
		                    <table class="detail_table" id="thead">
		                        <colgroup>
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                        </colgroup> 
		                        <tbody>         
		                            <tr>
		                                <th CL="STD_OWNRKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="OWNRKY" disabled="disabled"/>
		                                </td>
		                                <th CL="STD_WAREKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="WAREKY" disabled="disabled" />
		                                </td>
		                            </tr>   
		                            <tr>    
		                                <th CL="STD_LOTRKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="LOTRKY" disabled="disabled"/>
		                                </td>
		                                <th CL="STD_SHORTX"></th>
		                                <td>
		                                    <input type="text" class="input" name="SHORTX" />
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
		            </div>
				</div>
			</div>
			
			
			<div class="content_layout tabs bottom_layout" style="height: calc(100% - 170px);">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_box section">
		                <div class="inner_search_wrap">
		                    <table class="detail_table" id="titem">
		                        <colgroup>
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                            <col width="5%" />
		                            <col width="15%" />
		                            
		                        </colgroup>  
		                        <tbody>   
		                        	<tr>
		                                <th CL="STD_POSINFO" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr>       
		                            <tr>
		                                <th CL="STD_AREAKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="AREAKY" UIInput="SR"/>
		                                </td>
		                                <th CL="STD_ZONEKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="ZONEKY" UIInput="SR" />
		                                </td>
		                            </tr>   
		                            <tr>    
		                                <th CL="STD_LOCAKY"></th>
		                                <td>
		                                    <input type="text" class="input" name="LOCAKY" UIInput="SR"/>
		                                </td>
		                                <th CL="STD_TKZONE"></th>
		                                <td>
		                                    <select name="TKZONE" id="TKZONE"  class="input" CommonCombo="TKZONE" ComboCodeView="true">
		                                    	<option value=""></option>
		                                    </select>
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                                <th CL="STD_LOTINFO" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr>  
		                             <tr>    
		                                <th CL="STD_LOTA03"></th>
		                                <td>
		                                    <input type="text" class="input" name="LOTA03" UIInput="SR"/>
		                                </td>
		                                <th CL="STD_LOTA05"></th>
		                                <td>
		                                    <input type="text" class="input" name="LOTA05" UIInput="SR" />
		                                </td>
		                            </tr>
		                            <tr>    
		                                <th CL="STD_LOTA06"></th>
		                                <td colspan="3">
		                                    <input type="text" class="input" name="LOTA06" UIInput="SR"  />
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                                <th CL="STD_SKUINFO" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr>  
		                            <tr>    
		                                <th CL="STD_SKUKEY"></th>
		                                <td colspan="3">
		                                    <input type="text" class="input" name="SKUKEY" UIInput="SR"/>
		                                </td>
		                               
		                            </tr>
		                            
		                            
		                            <tr>
		                                <th CL="TAB_QTYINFO" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr>  
		                            <tr>    
		                                <th CL="STD_STKQTY"></th>
		                                <td colspan="3">
		                                    <select name="STKQTY" id="STKQTY"  class="input" CommonCombo="STKQTY" ComboCodeView="true">
		                                    	<option value=""></option>
		                                    </select>
		                                </td>
		                            </tr>
		                            
		                             <tr>
		                                <th CL="날짜정보" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr> 
		                            <tr>    
		                                <th CL="STD_LOTA13"></th>
		                                <td colspan='3'>
		                                	 <table class="detail_table" style="width: 100%;">
						                        <colgroup>
						                            <col width="10%" />
						                            <col width="8%" />
						                            
						                            <col width="10%" />
						                            <col width="27%" />
						                            
						                            <col width="26.5%" />
						                            <col width="20%" />
						                            
						                        </colgroup>  
						                        <tbody>
						                         	<tr>
						                                <th CL="STD_TSYEAR"></th>
						                                <td style="text-align: center;">
						                                    <input type="checkbox" class="input" name="LOTA13THISYEAR" disabled="disabled"/>
						                                </td>
						                                <th CL="STD_WHNDAY"></th>
						                                <td>
						                                    <input type="text" class="input" name="LOTA13LASTMONTH" disabled="disabled" /> %
						                                </td>
						                                <td>
						                                    <select name="RNGVOP1" id="RNGVOP1"  class="input" CommonCombo="RNGVOP" ComboCodeView="true"></select>
						                                </td>
						                            </tr>
						                         </tbody>
											</table>
		                                </td>
		                            </tr>
		                            <tr>    
		                                <th CL="STD_LOTA12"></th>
		                                <td colspan='3'>
		                                	 <table class="detail_table" style="width: 100%;">
						                        <colgroup>
						                            <col width="10%" />
						                            <col width="8%" />
						                            
						                            <col width="10%" />
						                            <col width="27%" />
						                            
						                            <col width="26.5%" />
						                            <col width="20%" />
						                            
						                        </colgroup>  
						                        <tbody>
						                         	<tr>
						                                <th CL="STD_TSYEAR"></th>
						                                <td style="text-align: center;">
						                                    <input type="checkbox" class="input" name="LOTA12THISYEAR" disabled="disabled"/>
						                                </td>
						                                <th CL="STD_WHNDAY"></th>
						                                <td>
						                                    <input type="text" class="input" name="LOTA12LASTMONTH" disabled="disabled" /> 개월
						                                </td>
						                                <td>
						                                    <select name="RNGVOP2" id="RNGVOP2"  class="input" CommonCombo="RNGVOP" ComboCodeView="true"></select>
						                                </td>
						                            </tr>
						                         </tbody>
											</table>
		                                </td>
		                            </tr>
		                            <tr>    
		                                <th CL="STD_LOTA13"></th>
		                                <td colspan='3'>
		                                	 <table class="detail_table" style="width: 100%;">
						                        <colgroup>
						                            <col width="10%" />
						                            <col width="8%" />
						                            
						                            <col width="10%" />
						                            <col width="27%" />
						                            
						                            <col width="26.5%" />
						                            <col width="20%" />
						                            
						                        </colgroup>  
						                        <tbody>
						                         	<tr>
						                                <th CL="STD_TSYEAR"></th>
						                                <td style="text-align: center;">
						                                    <input type="checkbox" class="input" name="LOTA11THISYEAR" disabled="disabled"/>
						                                </td>
						                                <th CL="STD_WHNDAY"></th>
						                                <td>
						                                    <input type="text" class="input" name="LOTA11LASTMONTH" disabled="disabled" /> 개월
						                                </td>
						                                <td>
						                                    <select name="RNGVOP3" id="RNGVOP3"  class="input" CommonCombo="RNGVOP" ComboCodeView="true"></select>
						                                </td>
						                            </tr>
						                         </tbody>
											</table>
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
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>