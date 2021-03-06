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
var connown ;
var connectivity ;
var programs ;
searchFlg = false;
    $(document).ready(function(){
        gridList.setGrid({
            id : "gridList1",
			module : "System",
			command : "UR01_display1",
			pkcol : "MENUKY,MENUID",
            editable : true,
            emptyMsgType : false,
            selectRowDeleteType : true,
            colorType : true,
		    menuId : "UR01"
        });
        gridList.setGrid({
            id : "gridList2",
			module : "System",
			command : "UR01_display2",
			pkcol : "USERID" ,
            editable : true,
            emptyMsgType : false,
            selectRowDeleteType : true,
            colorType : true ,
		    menuId : "UR01"
        });
               
        uiList.setActive("Copy", false);
        uiList.setActive("Save", false);
        uiList.setActive("Delete", false);
        
      //화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
        setVarriantDef();
        
    });
    
    // 공통버튼
    function commonBtnClick(btnName){
        if(btnName == "Create"){
            createData();
        }else if(btnName == "Search"){
        	$('#atab1-1').trigger("click");
        }else if(btnName == "Save"){
            saveData();
        }
//         else if(btnName == "Copy"){
//             copyData();
//         }
        else if(btnName == "Delete"){
            deleteData();
        }else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "UR01");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "UR01");
		}
	}
    
	function searchList(){
		$('#atab1-1').trigger("click");
	}
    
    //조회
    function display1(){
        if(validate.check("searchArea")){
            var param = inputList.setRangeParam("searchArea");
            param.put("SEARCH_TYPE", "SEARCH");
            searchListReal(param);
            
            gridList.setDefaultRowState("gridList1", configData.GRID_ROW_STATE_START);
            uiList.setActive("Copy", true);
            uiList.setActive("Save", true);
            uiList.setActive("Delete", true);
            uiList.setActive("Create", true);
        }
    }
    
    //그리드 조회
    function searchListReal(param){
    	gridList.resetGrid("gridList1");
		gridList.resetGrid("gridList2");
		
        gridList.gridList({
            id : "gridList1",
            param : param
        });

        searchFlg = true;
    }

    /*그리드 데이터 바인드 후 적용*/
     function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
    	if(dataLength > 0){
    		var param = new DataMap();
    		param.put("UROLKY",$('#MENUGID').val());

    		
    		var json2 = netUtil.sendData({
    			module : "System",
    			command : "UR01_Connectivity",
    			sendType : "list",
    			param : param
    		});
    		connectivity = json2.data;

    	}
    } 
    
    function display2(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList1");
			gridList.resetGrid("gridList2");
			var param = inputList.setRangeMultiParam("searchArea");
			
			gridList.gridList({
	            id : "gridList2",
	            param : param
	        }); 

		}
	}
    
    //저장
    function saveData(){
         if((gridList.getModifyRowCount("gridList1") == 0 && programs == 0 && connectivity == 0) && gridList.getModifyRowCount("gridList2") == 0){
            commonUtil.msgBox("SYSTEM_SAVEEMPTY");
            //변경된 데이터가 없습니다.
            return false;
        }
        
         var param = inputList.setRangeDataParam("searchArea");
        
         if (gridList.getModifyRowCount("gridList2") != 0 ) {
        	 
         	param.put("list2", gridList.getModifyData("gridList2", "A"));
         	
             netUtil.send({
                 url : "/system/json/saveUR01_2.data",
                 param : param,
                 async : true,
                 successFunction : "saveDataCallBack"
             });
         }else if (gridList.getModifyRowCount("gridList1") != 0 || connown != 0 || programs != 0 || connectivity != 0) {
        	 
        	 
        	param.put("list1", gridList.getGridData("gridList1"));
        	param.put("connown",connown);
        	param.put("connectivity",connectivity);
        	param.put("programs",programs);
        	
    		if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
    			// 저장하시겠습니까?
    			return;
    		}
        	
        	netUtil.send({
                url : "/system/json/saveUR01.data",
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
            }else if (json.data.RESULT == "OK") {
            	commonUtil.msgBox("SYSTEM_SAVEOK");
                searchList();
			}else if (json.data.RESULT == "OK2") {
            	commonUtil.msgBox("SYSTEM_SAVEOK");
            	display2();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
        }else{
            commonUtil.msgBox("EXECUTE_ERROR");
        }
    }

    //생성
    function createData(){
//      if(gridList.getSelectData("gridList1"))
        
        page.linkPopOpen("./UR01_POP.page", null, "height=250,width=480,resizable=yes");
    }
    
//     //메뉴복사
//     function copyData(){
//         if(gridList.getGridAvailData("gridList1").length > 0){
//             if(!commonUtil.msgConfirm("CM_M0002")){
//                 return;
//             }
//         }
//         page.linkPopOpen("./UR01_COPY_POP.page", null, "height=500,width=550,resizable=yes");
//     }

    //popup close event
    function linkPopCloseEvent(data){
        if(data){
            if(data.get("CLOSE_TYPE") == "CREATE"){
                data.put("MENUGROUPID_SNAME",data.get("MENUGNAME"));
	            dataBind.dataNameBind(data.map,"searchArea");
				
	            searchList()
	            
	            uiList.setActive("Copy", true);
	            uiList.setActive("Save", true);
	            uiList.setActive("Delete", true);
	            uiList.setActive("Create", false);
            
            }else if(data.get("TYPE") == "GET"){ 
        		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    		}
        }
    }

    //삭제
    function deleteData(){

        if(!commonUtil.msgConfirm("SYSTEM_DELCONFIRM",uiList.getLabel("STD_DELETE"))){ //삭제하시겠습니까?
            return;
        }
        
        var param = inputList.setRangeParam("searchArea");
        
        netUtil.send({
            url : "/system/json/deleteUR01.data",
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
        newData.put("UROLKY",$("input[name='MENUGID']").val());
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
    //서치헬프 리턴
    function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
        if(searchCode == "MSTMENUG"){
            dataBind.dataNameBind(rowData,"searchArea"); 
            searchList();
        } else if (searchCode == "SHUSRMA") {
        	var gridId = "gridList2";
        	var rowNum = gridList.getFocusRowNum(gridId);
        	gridList.setColValue(gridId, rowNum, "NMLAST", rowData.get("NMLAST"));
        	gridList.setColValue(gridId, rowNum, "NMFIRS", rowData.get("NMFIRS"));
        }
    }

/*     function  gridListRowBgColorChange(gridId, rowNum, colName, colValue) {
       	if(gridList.getColData(gridId,rowNum,"URI") != ""){
               return "notTree";
       	}
    } */
    
/*     function gridListRowTextColorChange(gridId, rowNum){
        if(gridList.getColData(gridId,rowNum,"DELETEYN") == "Y"){
            return "gridColorTextGray";
        }
    } */
    
	function gridListEventColBtnClick(gridId, rowNum, colName) {
    	var SelectData = gridList.getSelectData("gridList1",true);
    	if(colName == "BTN_CONNOWN" || colName == "BTN_CONNECTIVITY" || colName == "BTN_PROGRAMS"){
	    	if(SelectData.length > 0){
	    		commonUtil.msgBox("* 변경한 내용을 저장 후에 버튼을 클릭 해주세요. *");
	    	}else {
				if(colName == "BTN_CONNOWN"){
					var data = gridList.getRowData("gridList1", rowNum);
					var option = "height=620,width=540,resizable=yes";
					page.linkPopOpen("/wms/system/pop/UR01_CONNOWN.page", data, option);
				}else if(colName == "BTN_CONNECTIVITY"){	
					var data = gridList.getRowData("gridList1", rowNum);
					var option = "height=620,width=540,resizable=yes";
					page.linkPopOpen("/wms/system/pop/UR01_Connectivity.page", data, option);
				}else if(colName == "BTN_PROGRAMS"){	
					var data = new DataMap();
						data.put("gridData",gridList.getRowData("gridList1", rowNum));
						data.put("connectivity",connectivity);
					var option = "height=620,width=540,resizable=yes";
					page.linkPopOpen("/wms/system/pop/UR01_Programs.page", data, option);
				}
	    	}
    	}
	}
    function data2(data){
    	connectivity = data;
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
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
                </div>
                <div class="fl_r">
                    <input type="button" CB="Create ADD BTN_NEW" /><!-- 생성 -->
                    <input type="button" CB="Search SEARCH BTN_SEARCH" /><!-- 조회 -->
                    <!-- <input type="button" CB="Copy COPY_GRID BTN_MENU_COPY" />메뉴복사 -->
                    <input type="button" CB="Save SAVE BTN_SAVE" /><!-- 저장 -->
                    <input type="button" CB="Delete DELETE 권한삭제" /><!-- 삭제 -->
                </div>
            </div>
            <div class="search_inner">
                <div class="search_wrap">
                    <dl>
                        <dt CL="STD_COMPID"></dt><!-- COMPKY -->
                        <dd>
                            <input type="text" class="input" name="COMPID" maxlength="10" readonly="true" value="<%= compky%>"/>
                        </dd>
                    </dl>
                    <dl>
                        <dt CL="STD_MENUCOMCOD"></dt><!-- 메뉴권한코드 -->
                        <dd>
                            <input type="text" class="input" name="MENUGID" id="MENUGID" maxlength="35" UIInput="S,SHROLDF" validate="required"/>
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
	                <li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>일반</span></a></li>
	                <li><a href="#tab1-2" onclick="display2()"><span>연결:사용자</span></a></li>
	                <li class="btn_zoom_wrap">
	                    <ul>
	                        <li><button class="btn btn_bigger"><span>확대</span></button></li>
	                    </ul>
	                </li>
	            </ul>
	            <div class="table_box section" id="tab1-1"> <!-- 일반 -->
	                <div class="table_list01">
	                    <div class="scroll">
	                        <table class="table_c">
	                            <tbody id="gridList1">
	                                <tr CGRow="true">
	                                    <td GH="40" GCol="rownum">1</td>
	                                    <td GH="40" GCol="rowCheck"></td>
	                                    <td GH="100 STD_UROLKY"     GCol="text,UROLKY" GF="s 20"></td><!-- 사용자권한 키 -->
	                                    <td GH="200 STD_SHORTX"    GCol="input,SHORTX" GF="s 60"></td><!-- 설명 -->
	                                    <td GH="100 STD_CONNOWN"     GCol="btn,BTN_CONNOWN" GB="connown SAVE STD_CONNOWN"></td><!-- 접속 화주 -->
	                                    <td GH="100 STD_CONNECTIVITY"   GCol="btn,BTN_CONNECTIVITY" GB="connectivity SAVE STD_CONNECTIVITY" ></td><!-- 접속 창고 -->
	                                    <td GH="100 STD_PROGRAMS"        GCol="btn,BTN_PROGRAMS" GB="programs SAVE STD_PROGRAMS" ></td><!-- 프로그램 -->
	                                    <td GH="100 STD_CREATIONDATETIME"    GCol="text,CREDAT" GF="D 8"></td><!-- 생성일시 -->
	                                    <td GH="100 STD_CREUSR"  GCol="text,CREUSR" GF="S 20"></td><!-- 생성자 -->
	                                    <td GH="100 STD_LASTMODIFIEDDATETIME"  GCol="text,LMODAT" GF="D 8"></td><!-- 수정일시 -->
	                                    <td GH="100 STD_LMOUSR"  GCol="text,LMOUSR" GF="S 20"></td><!-- 수정자 --> <!-- ROLDF -->
	                                </tr>
	                            </tbody>
	                        </table>
	                    </div>
	                </div>
	                <div class="btn_lit tableUtil">
	                    <button type='button' GBtn="find"></button>
	                    <button type='button' GBtn="sortReset"></button>
	                    <!-- <button type='button' GBtn="add"></button> -->
	                    <!-- <button type='button' GBtn="copy"></button> -->
	                    <!-- <button type='button' GBtn="delete"></button> -->
	                    <button type='button' GBtn="layout"></button>
	                    <button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button> 
<!-- 	                    <button type='button' GBtn="excelUpload"></button> -->
<!-- 	                    <button type='button' GBtn="up"></button> -->
<!-- 	                    <button type='button' GBtn="down"></button> -->
	                    <span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
	                </div>
	            </div>
	            <div class="table_box section" id="tab1-2"> <!-- 연결:사용자 -->
	                <div class="table_list01">
	                    <div class="scroll">
	                        <table class="table_c">
	                            <tbody id="gridList2">
	                                <tr CGRow="true">
	                                    <td GH="40" GCol="rownum">1</td>
	                                    <td GH="40" GCol="rowCheck"></td>
	                                    <td GH="100 STD_UROLKY"     GCol="text,UROLKY" GF="U"></td><!-- 사용자권한 키 -->
	                                    <td GH="100 STD_USERID"    GCol="input,USERID,SHUSRMA"></td><!-- 사용자ID -->
	                                    <td GH="100 STD_NMLAST"     GCol="text,NMLAST" id="NMLAST" GF="U 10"  ></td><!-- 이름 -->
	                                    <td GH="200 STD_NMFIRS"   GCol="text,NMFIRS" id="NMFIRS" GF="S 50" readonly ></td><!-- 관련업무 -->
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
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button> 
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