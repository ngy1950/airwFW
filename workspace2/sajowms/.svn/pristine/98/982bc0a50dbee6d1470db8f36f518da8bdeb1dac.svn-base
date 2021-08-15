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
			command : "SKUMA",
			pkcol : "COMPKY,SKUKEY",
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
		if(gridList.validationCheck("gridList", "select")){
			var list = gridList.getSelectData("gridList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
	        if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
	            return;
	        }

			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/system/json/saveSK01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "ES"){
				commonUtil.msgBox("[{0}] 이미 존재하는 품번입니다.",json.data["SKUKEY"]);
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
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
            newData.put("OWNRKY","<%=compky%>");
            newData.put("WAREKY","<%=wareky%>");
            newData.put("GRSWGT",0);
            newData.put("NETWGT",0);
            newData.put("LENGTH",0);
            newData.put("WIDTHW",0);
            newData.put("HEIGHT",0);
            newData.put("CUBICM",0);
            newData.put("DUOMKY",'EA');
            
            return newData;
    	}
    }
    

    //change Event
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
        if(colName == "ZONEKY"){ 
            if(colValue != ""){
                var param = new DataMap();
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
							<input type="text" class="input" name="WAREKY"  value="<%=wareky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input type="text" class="input" name="SKUKEY"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<input type="text" class="input" name="OWNRKY"  UIFormat="U"/>
						</dd>
					</dl>
					<dl>
						<dt CL="삭제여부"></dt><!-- -->
                        <dd>
							<input type="checkbox" class="input" name="DELMAK" value="V" />
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
								<li><button class="btn btn_smaller"><span>축소</span></button></li>
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
											<td GH="100 STD_WAREKY"      GCol="text,WAREKY"></td>
											<td GH="100 STD_OWNRKY"      GCol="text,OWNRKY"></td>
											<td GH="100 STD_SKUKEY"      GCol="add,SKUKEY" GF="U 20"  validate="required"></td>
											<td GH="100 STD_AREAKY"      GCol="input,AREAKY"></td>
											<td GH="100 STD_ZONEKY"      GCol="input,ZONEKY"></td>
											<td GH="100 STD_DESC01"      GCol="input,DESC01"></td>
<!-- 											<td GH="100 STD_ASKL01"      GCol="text,ASKL01"></td> -->
<!-- 											<td GH="100 STD_ASKL02"      GCol="text,ASKL02"></td> -->
<!-- 											<td GH="100 STD_ASKL03"      GCol="text,ASKL03"></td> -->
<!--                                             <td GH="100 STD_ASKL04"      GCol="text,ASKL04"></td> -->
<!-- 											<td GH="100 STD_ASKL05"      GCol="text,ASKL05"></td> -->
<!-- 											<td GH="100 STD_EANCOD"      GCol="text,EANCOD"></td> -->
<!-- 											<td GH="100 STD_GTINCD"      GCol="text,GTINCD"></td> -->
<!-- 											<td GH="100 STD_ABCANV"      GCol="text,ABCANV"></td> -->
											<td GH="100 STD_GRSWGT"      GCol="input,GRSWGT"         GF="N 20,3"></td>
											<td GH="100 STD_NETWGT"      GCol="input,NETWGT"         GF="N 20,3"></td>
											<td GH="100 STD_LENGTH"      GCol="input,LENGTH"         GF="N 20,3"></td>
											<td GH="100 STD_WIDTHW"      GCol="input,WIDTHW"         GF="N 20,3"></td>
											<td GH="100 STD_HEIGHT"      GCol="input,HEIGHT"         GF="N 20,3"></td>
											<td GH="100 STD_CUBICM"      GCol="input,CUBICM"         GF="N 20,3"></td>
											<td GH="100 STD_DUOMKY"      GCol="text,DUOMKY"></td>
											<td GH="100 STD_LOTL01"      GCol="input,LOTL01"></td>
											<td GH="100 STD_LOTL02"      GCol="input,LOTL02"></td>
											<td GH="100 STD_LOTL03"      GCol="input,LOTL03"></td>
											<td GH="100 STD_LOTL04"      GCol="input,LOTL04"></td>
											<td GH="100 STD_LOTL05"      GCol="input,LOTL05"></td>
											<td GH="100 STD_DELMAK"      GCol="check,DELMAK"></td>
											<td GH="100 STD_LMODAT"      GCol="text,LMODAT"         GF="D"></td>
											<td GH="100 STD_LMOTIM"      GCol="text,LMOTIM"		    GF="T"></td>
											<td GH="100 STD_LMOUSR"      GCol="text,LMOUSR"></td>
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
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="total"></button>
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