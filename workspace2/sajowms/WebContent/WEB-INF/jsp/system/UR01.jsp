<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<style type="text/css">

.notTree span[treeicon="true"]{
    opacity : 0;
}
</style>
<script type="text/javascript">
searchFlg = false;
    $(document).ready(function(){
        gridList.setGrid({
            id : "gridList",
			module : "System",
			command : "UR01",
			pkcol : "MENUKY,MENUID",
            editable : true,
            emptyMsgType : false,
            selectRowDeleteType : true,
            colorType : true
        });
        
        uiList.setActive("Copy", false);
        uiList.setActive("Save", false);
        uiList.setActive("Delete", false);
        
        
    });
    
    // 공통버튼
    function commonBtnClick(btnName){
        if(btnName == "Create"){
            createData();
        }else if(btnName == "Search"){
            searchList();
        }else if(btnName == "Save"){
            saveData();
        }else if(btnName == "Copy"){
            copyData();
        }else if(btnName == "Delete"){
            deleteData();
        }
    }
    
    
    //조회
    function searchList(){
        if(validate.check("searchArea")){
            var param = inputList.setRangeParam("searchArea");
            param.put("SEARCH_TYPE", "SEARCH");
            searchListReal(param);
            
            gridList.setDefaultRowState("gridList", configData.GRID_ROW_STATE_START);
            uiList.setActive("Copy", true);
            uiList.setActive("Save", true);
            uiList.setActive("Delete", true);
            uiList.setActive("Create", true);
        }
    }
    
    //그리드 조회
    function searchListReal(param){
        gridList.gridList({
            id : "gridList",
            param : param
        });
        searchFlg = true;
    }

    /*그리드 데이터 바인드 후 적용*/
//     function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
//     	if(dataLength > 0){
//     	}
//     }
    
    //저장
    function saveData(){
        if( gridList.getModifyRowCount("gridList") == 0){
            commonUtil.msgBox("SYSTEM_SAVEEMPTY");
            //변경된 데이터가 없습니다.
            return false;
        }
        
        var param = new DataMap();
        param.put("list", gridList.getGridAvailData("gridList"));
        param.put("head", inputList.setRangeParam("searchArea"));
        
        if(gridList.validationCheck("gridList","modify")){
            netUtil.send({
                url : "/admin/json/saveUR01.data",
                param : param,
                async : true,
                successFunction : "saveDataCallBack"
            });
        }
    }
    
    //저장콜백
    function saveDataCallBack (json, returnParam){
        if(json && json.data){
            if(json.data["saveCk"] == false){
                commonUtil.msgBox(json.data["ERROR_MSG"], json.data["COL_VALUE"]);
            }else {
                commonUtil.msgBox("SYSTEM_SAVEOK");
                gridList.resetGrid("gridList");
                searchList();
            }
        }else{
            commonUtil.msgBox("EXECUTE_ERROR");
        }
    }

    //생성
    function createData(){
//      if(gridList.getSelectData("gridList"))
        
        page.linkPopOpen("./UR01_POP.page", null, "height=250,width=480,resizeble=yes");
    }
    
    //메뉴복사
    function copyData(){
        if(gridList.getGridAvailData("gridList").length > 0){
            if(!commonUtil.msgConfirm("CM_M0002")){
                return;
            }
        }
        page.linkPopOpen("./UR01_COPY_POP.page", null, "height=500,width=550,resizeble=yes");
    }

    //popup close event
    function linkPopCloseEvent(data){
        if(data){
            if(data.get("CLOSE_TYPE") == "CREATE"){
                data.put("MENUGROUPID_SNAME",data.get("MENUGNAME"));
	            dataBind.dataNameBind(data.map,"searchArea");
	
	            uiList.setActive("Copy", true);
	            uiList.setActive("Save", true);
	            uiList.setActive("Delete", true);
	            uiList.setActive("Create", false);
            
            }else if(data.get("CLOSE_TYPE") == "COPY"){
                data.put("SEARCH_TYPE", "COPY");
                data.put("COPY_MENU_ID", $("input[name='MENUGROUPID']").val());
                gridList.setDefaultRowState("gridList", configData.GRID_ROW_STATE_INSERT);
                searchListReal(data);
            }
        }
    }

    //삭제
    function deleteData(){

        if(!commonUtil.msgConfirm("SYSTEM_DELCONFIRM",uiList.getLabel("STD_DELETE"))){ //삭제하시겠습니까?
            return;
        }
        
        var param = new DataMap();
        param.put("head", inputList.setRangeParam("searchArea"));
        
        netUtil.send({
            url : "/admin/json/deleteUR01.data",
            param : param,
            async : true,
            successFunction : "saveDataCallBack"
        });
    }
    
    //change Event
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
        
        if(colName == "MENUID"){
            var param = new DataMap();
            param.put("COMPID","<%= compky%>");
            param.put("MENUID",colValue);
            param.put("MENUGID",gridList.getColData(gridId, rowNum, "MENUGID"));
            
            var json = netUtil.sendData({
                module : "System",
                command : "UR01_MENUID_VALID2",
                param : param,
                sendType: "map"
            });
            
            if(json && json.data.CNT > 0){
                gridList.setColValue(gridId, rowNum, colName, "", true);
                gridList.setColValue(gridId, rowNum, "MENUNAME", "", true);
                gridList.setColValue(gridId, rowNum, "URI", "", true);
                commonUtil.msgBox("BM_VALID_DUPL_ROW", colValue);
                return;
            }
        }
        
        if(colName == "MENUID" || colName == "PMENUID"){ 
            
            var param = new DataMap();
            param.put("COMPID","<%= compky%>");
            param.put("MENUID",colValue);
            
            if(colValue != ""){
                if(colValue != "root"){
                    var json = netUtil.sendData({
                        module : "System",
                        command : "UR01_MENUID_VALID",
                        param : param,
                        sendType: "map"
                    });
                    
                    if(json && json.data.CNT > 0){
                        if(colName == "MENUID"){
                        gridList.setColValue(gridId, rowNum, "MENUNAME", json.data["MENUNAME"], true);
                        gridList.setColValue(gridId, rowNum, "URI", json.data["URI"], true);
                        }
                    }else {
                        if(colName == "MENUID"){
                            gridList.setColValue(gridId, rowNum, "MENUNAME", "", true);
                            gridList.setColValue(gridId, rowNum, "URI", "", true);
                        }else{
                            gridList.setColValue(gridId, rowNum, colName, "", true);
                            commonUtil.msgBox("VALID_remote", colValue);
                        }
                    }
                }
            }else {
                if(colName == "MENUID"){
                    gridList.setColValue(gridId, rowNum, "MENUNAME", "", true);
                    gridList.setColValue(gridId, rowNum, "URI", "", true);
                }
            }
        }
    }
    
    //add Before
    function gridListEventRowAddBefore(gridId, rowNum, beforeData){
        if(searchFlg == false){
            alert("조회 후 진행 해 주세요.");
            return false;
        }
        var newData = new DataMap();
        newData.put("MENUGID", $("input[name='MENUGID']").val());
        newData.put("COMPID", $("input[name='COMPID']").val());
        return newData;
    }

    // 그리드 팝업 호출 
    function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();

        // 거래처담당자 주소검색
        if (searchCode == "MSTMENUG") {
        	param.put("COMPID",$("input[name='COMPID']").val());
            return param;
            
        }
    }
    function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
        if(searchCode == "MSTMENUG"){
            dataBind.dataNameBind(rowData,"searchArea"); 
            searchList();
        }
    }

    function  gridListRowBgColorChange(gridId, rowNum, colName, colValue) {
       	if(gridList.getColData(gridId,rowNum,"URI") != ""){
               return "notTree";
       	}
    }
    
    function gridListRowTextColorChange(gridId, rowNum){
        if(gridList.getColData(gridId,rowNum,"DELETEYN") == "Y"){
            return "gridColorTextGray";
        }
    }
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
    <div class="content_inner">
        <%@ include file="/common/include/webdek/title.jsp" %>
        <div class="content_serch" id="searchArea">
            <div class="btn_wrap">
                <div class="fl_l">
                </div>
                <div class="fl_r">
                    <input type="button" CB="Create ADD BTN_NEW" /><!-- 생성 -->
                    <input type="button" CB="Search SEARCH BTN_SEARCH" /><!-- 조회 -->
                    <input type="button" CB="Copy COPY_GRID BTN_MENU_COPY" /><!-- 메뉴복사 -->
                    <input type="button" CB="Save SAVE BTN_SAVE" /><!-- 저장 -->
                    <input type="button" CB="Delete DELETE 권한삭제" /><!-- 삭제 -->
                </div>
            </div>
            <div class="search_inner">
                <div class="search_wrap">
                    <dl>
                        <dt CL="STD_COMPID"></dt><!-- COMPKY -->
                        <dd>
                            <input type="text" class="input" name="COMPID" maxlength="10" value="<%= compky%>" readonly="true"/>
                        </dd>
                    </dl>
                    <dl>
                        <dt CL="STD_MENUCOMCOD"></dt><!-- 메뉴권한코드 -->
                        <dd>
                            <input type="text" class="input" name="MENUGID" maxlength="35" UIInput="S,MSTMENUG" validate="required"/>
                        </dd>
                    </dl>
                </div>
                <div class="btn_tab">
                    <input type="button" class="btn_more" value="more" onclick="searchMore()"/>
                </div>
            </div>
        </div>
        <div class="search_next_wrap">
	        <div class="content_layout tabs">       
	            <ul class="tab tab_style02">
	                <li><a href="#tab1-1"><span>일반</span></a></li>
	                <li class="btn_zoom_wrap">
	                    <ul>
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
	                                    <td GH="100 STD_COMPID"     GCol="text,COMPID" GF="U"></td><!-- 메뉴 그룹ID -->
	                                    <td GH="100 STD_MENUGID"    GCol="text,MENUGID"></td><!-- 메뉴 그룹ID -->
	                                    <td GH="100 STD_MENUID"     GCol="input,MENUID,MENUID,true" GF="U 10" validate="required"></td><!-- 메뉴ID -->
	                                    <td GH="200 STD_MENUNAME"   GCol="input,MENUNAME" GF="S 50" ></td><!-- 메뉴명 -->
	                                    <td GH="200 STD_URL"        GCol="input,URI" GF="S 200"></td><!-- URL -->
	                                    <td GH="100 STD_PMENUID"    GCol="input,PMENUID" GF="S 10" validate="required"></td><!-- 상위메뉴ID -->
	                                    <td GH="100 STD_SORTORDER"  GCol="input,SORTORDER" validate="required"></td><!-- 순번 -->
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
	                    <button type='button' GBtn="layout"></button>
	                    <button type='button' GBtn="excel"></button>
<!-- 	                    <button type='button' GBtn="excelUpload"></button> -->
<!-- 	                    <button type='button' GBtn="up"></button> -->
<!-- 	                    <button type='button' GBtn="down"></button> -->
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