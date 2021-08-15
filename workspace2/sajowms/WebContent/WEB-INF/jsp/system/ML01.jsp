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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "System",
			command : "LOCMA",
			pkcol : "COMPKY,WAREKY,LOCAKY"
	    });
	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
		}
	}

	function saveData(){
		if(gridList.validationCheck("gridList", "data")){
	        
	        var json = gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A",
		    });
	        console.log(json.data);
	        if(json && json.data){
	        	if(json.data > 0){
	        		searchList();
	        	}
	        }
		}
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "Common,CMCDV_COMBO"){
			var cmcdky = "";
			
			var comboName = $comboObj[0].name;
			switch (comboName) {
			case "LOCATY":
				cmcdky = "LOCATY";
				break;
			case "TASKTY":
				cmcdky = "LOTA01";
				break;
			default:
				break;
			}	
			param.put("CMCDKY", cmcdky);
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            newData.put("WAREKY","<%=wareky%>");
            newData.put("LENGTH",0);
            newData.put("WIDTHW",0);
            newData.put("HEIGHT",0);
            newData.put("CUBICM",0);
            newData.put("MAXCPC",0);
            newData.put("MAXQTY",0);
            newData.put("MAXWGT",0);
            newData.put("MAXLDR",0);
            newData.put("MAXSEC",0);
            //newData.put("MIXSKU",0);
            newData.put("QTYCHK",0);
            return newData;
    	}
    }

    //change Event
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
        if(colName == "ZONEKY"){ 
            if(colValue != ""){
                var param = new DataMap();
                param.put("WAREKY","<%=wareky%>");
                param.put(colName,colValue);
                
                var json = netUtil.sendData({
                    module : "System",
                    command : "ZONMA",
                    param : param,
                    sendType: "list"
                });
                
                if(json && json.data.length > 0){
                    gridList.setColValue(gridId, rowNum, "AREAKY", json.data[0].AREAKY);
                }else{
    				commonUtil.msgBox("VALID_remote",colValue);
                    gridList.setColValue(gridId, rowNum, colName, "");
                    gridList.setColValue(gridId, rowNum, "AREAKY", "");
                }
            }
        }else if(colName == "AREAKY"){
            if(colValue != ""){
                var param = new DataMap();
                param.put("WAREKY","<%=wareky%>");
                param.put(colName,colValue);
                
                var json = netUtil.sendData({
                    module : "System",
                    command : "AREMA",
                    param : param,
                    sendType: "list"
                });
                
                if(!(json && json.data.length > 0)){
    				commonUtil.msgBox("VALID_remote",colValue);
                    gridList.setColValue(gridId, rowNum, colName, "");
                    gridList.setColValue(gridId, rowNum, "ZONEKY", "");
                }else{
                    gridList.setColValue(gridId, rowNum, "ZONEKY", "");
                }
            }else{
                gridList.setColValue(gridId, rowNum, "ZONEKY", "");
            }
        }
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
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
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
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="text" class="input" name="WAREKY" value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOCAKY"></dt>
						<dd>
							<input type="text" class="input" name="LOCAKY"  UIFormat="U"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="100 STD_COMPANY"     GCol="text,COMPKY" GF="U 4"></td>
											<td GH="100"     GCol="text,WAREKY"				GF="U 4"></td>
											<td GH="100"     GCol="input,AREAKY"></td>
                                            <td GH="100"     GCol="input,ZONEKY"></td>
											<td GH="100"     GCol="add,LOCAKY" 				GF="S 20"	validate="required"></td>
											<td GH="100"     GCol="select,LOCATY">
												<select Combo="Common,CMCDV_COMBO" name="LOCATY" ComboCodeView="false">
													<option value="" CL="STD_SELECT"></option>
												</select>
											</td>
											<td GH="100"     GCol="input,SHORTX"></td>
                                            <td GH="100"     GCol="select,TASKTY">
                                            	<select Combo="Common,CMCDV_COMBO" name="TASKTY" ComboCodeView="false">
                                            		<option value="" CL="STD_SELECT"></option>
                                            	</select>
                                            </td>
                                            <td GH="100"     GCol="input,TKZONE"></td>
                                            <td GH="100"     GCol="input,FACLTY"></td>
											<td GH="100"     GCol="input,ARLVLL"></td>
                                            <td GH="100"     GCol="input,INDCPC"></td>
                                            <td GH="100"     GCol="input,INDTUT"></td>
											<td GH="100"     GCol="input,IBROUT"></td>
                                            <td GH="100"     GCol="input,OBROUT"></td>
                                            <td GH="100"     GCol="input,RPROUT"></td>
											<td GH="100"     GCol="input,STATUS"></td>
                                            <td GH="100"     GCol="input,ABCANV"></td>
                                            <td GH="100"     GCol="input,LENGTH" 			GF="N 20"></td>
											<td GH="100"     GCol="input,WIDTHW" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,HEIGHT" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,CUBICM" 			GF="N 20"></td>
											<td GH="100"     GCol="input,MAXCPC" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,MAXQTY" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,MAXWGT" 			GF="N 20"></td>
											<td GH="100"     GCol="input,MAXLDR" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,MAXSEC" 			GF="N 20"></td>
                                            <td GH="100"     GCol="input,MIXSKU"></td>
											<td GH="100"     GCol="input,MIXLOT"></td>
                                            <td GH="100"     GCol="input,RPNCAT"></td>
                                            <td GH="100"     GCol="input,INDQTC"></td>
											<td GH="100"     GCol="input,QTYCHK"            GF="N 20"></td>
                                            <td GH="100"     GCol="input,NEDSID"></td>
                                            <td GH="100"     GCol="input,INDUPA"></td>
											<td GH="100"     GCol="input,INDUPK"></td>
                                            <td GH="100"     GCol="input,AUTLOC"></td>
                                            <td GH="100"     GCol="text,CREDAT" 			GF="D"></td>
											<td GH="100"     GCol="text,CRETIM" 			GF="T"></td>
                                            <td GH="100"     GCol="text,CREUSR"></td>
                                            <td GH="100"     GCol="text,LMODAT" 			GF="D"></td>
											<td GH="100"     GCol="text,LMOTIM" 			GF="T"></td>
                                            <td GH="100"     GCol="text,LMOUSR"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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