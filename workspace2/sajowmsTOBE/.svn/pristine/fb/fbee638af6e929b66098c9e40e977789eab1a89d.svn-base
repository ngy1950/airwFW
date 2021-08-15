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
			pkcol : "COMPKY,WAREKY,LOCAKY",
			menuId : "ML01"
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
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY"  class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false"></select>
						</dd>
					</dl>
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업구역-->  
						<dt CL="STD_TKZONE"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--지정품목-->  
						<dt CL="STD_LOCSKU"></dt> 
						<dd> 
							<input type="text" class="input" name="null" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션유형-->  
						<dt CL="STD_LOCATY"></dt> 
						<dd> 
							<select name="scLOCATY" id="SCLOCATY" class="input" Combo=""></select> 
						</dd> 
					</dl> 
					<dl>  <!--상태-->  
						<dt CL="STD_STATUS"></dt> 
						<dd> 
							<select name="scSTATUS" id="SCSTATUS" class="input" Combo=""></select> 
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
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="160 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="50 STD_LOCATY" GCol="input,LOCATY" GF="S 4">로케이션유형</td>	<!--로케이션유형-->
				    						<td GH="80 STD_AREAKY" GCol="input,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="200 STD_SHORTX" GCol="input,SHORTX" GF="S 60">설명</td>	<!--설명-->
				    						<td GH="80 STD_ZONEKY" GCol="input,ZONEKY" GF="S 10">존</td>	<!--존-->
				    						<td GH="80 STD_TKZONE" GCol="input,TKZONE" GF="S 10">작업구역</td>	<!--작업구역-->
				    						<td GH="50 STD_FACLTY" GCol="input,FACLTY" GF="S 10">동-층</td>	<!--동-층-->
				    						<td GH="50 STD_INDCPC" GCol="input,INDCPC" GF="S 1">Capa체크</td>	<!--Capa체크-->
				    						<td GH="50 STD_OBROUT" GCol="input,OBROUT" GF="S 20">출고순서</td>	<!--출고순서-->
				    						<td GH="50 STD_STATUS" GCol="input,STATUS" GF="S 4">상태</td>	<!--상태-->
				    						<td GH="88 STD_LENGTH" GCol="input,LENGTH" GF="N 20,0">포장가로</td>	<!--포장가로-->
				    						<td GH="88 STD_WIDTHW" GCol="input,WIDTHW" GF="N 20,0">포장세로</td>	<!--포장세로-->
				    						<td GH="88 STD_HEIGHT" GCol="input,HEIGHT" GF="N 20,0">포장높이</td>	<!--포장높이-->
				    						<td GH="88 STD_CUBICM" GCol="input,CUBICM" GF="N 20,0">CBM</td>	<!--CBM-->
				    						<td GH="88 STD_MAXCPC" GCol="input,MAXCPC" GF="N 20,0">Capa. (Max)</td>	<!--Capa. (Max)-->
				    						<td GH="80 STD_LOCSID" GCol="input,NEDSID" GF="S 20">로케이션담당자</td>	<!--로케이션담당자-->
				    						<td GH="50 STD_INDUPA" GCol="input,INDUPA" GF="S 1">입고가능</td>	<!--입고가능-->
				    						<td GH="50 STD_INDUPK" GCol="input,INDUPK" GF="S 1">피킹가능</td>	<!--피킹가능-->
				    						<td GH="80 IFT_TEXT01" GCol="input,TEXT01" GF="S 250">비고</td>	<!--비고-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	<!--생성자명-->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
				    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	<!--수정자명-->
				    						<td GH="80 STD_LOCSKU" GCol="input,LOCSKU" GF="S 20">지정품목</td>	<!--지정품목-->
				    						<td GH="80 STD_LOCSKUNM" GCol="text,LOCSKUNM" GF="S 120">지정품목명</td>	<!--지정품목명-->
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