<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script>
	var gvFirst = true;
	$(document).ready(function(){
        var data = mobile.getLinkPopData();
        
		gridList.setGrid({
	    	id : "gridList",
			editable : false,
			module : "Mobile",
			command : "MIP02SEARCH",
			gridMobileType : true
	    });
		
		searchList();
	});
	
	// 조회 함수
	function searchList(){
        if(validate.check("searchArea")){
            var param =  dataBind.paramData("searchArea");
            gridList.gridList({
                id : "gridList",
                param : param
            });
        }
    }
	
	// 선택 함수
	function selectData(){	
		var rowNum = gridList.getSelectIndex("gridList");
		var rowData = gridList.getRowData("gridList", rowNum);
		mobile.linkPopClose(rowData);
	}
	
	// 입력버튼 포커스시 초기화
	function clearText(data){
		if(data!=null||data!=""){
	    	data.value="";
	    }      
	}
	
	// 콤보박스 사용시 
    function comboEventDataBindeBefore(comboAtt){

    }
    
	// 자동조회 할 경우 없을시 자동이동 처리
    function gridListEventDataBindEnd(gridId, dataLength){
        if( dataLength == 0 && gvFirst){
            //팝업 닫힘시
            mobile.linkPopClose(); 
        }
        gvFirst = false;
    }
</script>
</head>
<body>
	<div class="main_wrap">
	   <div class="tem4_content">
	      <div class="select_box">
				<table>
					<colgroup>
						<col  />
						<col width="100px" />
					</colgroup>
					<tbody  id="searchArea">
						<input type="hidden" name="WAREKY" value="<%=wareky%>"/>
						<input type="hidden" name="OWNRKY" value="<%=ownrky%>"/>
						<input type="hidden" name="PROGID" value="MIP02SEARCH"/>
						<tr>
							<td class="first">
								<select name="COLNAME" autocomplete="off">
									<option value="LOCAKY" CL="STD_LOCAKY"></option>
									<option value="CREDAT" CL="STD_CREDAT"></option>
								</select>
							</td>
							<td rowspan="2">
                                <button class="bt" onClick="searchList()"><span CL="BTN_DISPLAY"></span></button>
							</td>
						</tr>
						<tr>
							<td class="second">
								<input type="text" class="text" name="COLTEXT"  UIFormat="U" onkeypress="commonUtil.enterKeyCheck(event, 'searchList()')" onfocus="clearText(this)" autocomplete="off"  />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="tableWrap_search">
				<div class="tableHeader">
					<table style="width: 100%">
						<colgroup>
	                         <col width="100px"/>
	                         <col width="100px"/>
	                         <col width="100px"/>
						</colgroup>
						<thead>
							<tr>
								<th CL='STD_PHYIKY'></th>
								<th CL='STD_CREDAT'></th>
								<th CL='STD_PHSCTYNM'></th>
							</tr>
			
						</thead>
					</table>				
				</div>
				<div class="tableBody">
					<table style="width: 100%">
						<colgroup>
	                         <col width="100px"/>
	                         <col width="100px"/>
	                         <col width="100px"/>
						</colgroup>
						<tbody id="gridList">
							<tr CGRow="true">
								<td GCol="text,PHYIKY"></td>
								<td GCol="text,CREDAT" GF="D"></td>
								<td GCol="text,PHSCTYNM" ></td>
							</tr>
						</tbody>
			
					</table>
				</div>
			</div>
			
			<div class="bottom">
                <button class=" bottom_bt" onClick="selectData()"><span CL="BTN_CHOOSE"></span></button>
			</div>
		</div>	
	</div>
</body>