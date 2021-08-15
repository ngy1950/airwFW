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
          module : "Demo",
         command : "BOARD",
         pkcol : "BODNUM",
         itemGrid : "gridItemList",
         itemSearch : true
       });
      
      gridList.setGrid({
          id : "gridItemList",
          module : "Demo",
         command : "BOARDITEM",
         pkcol : "BODNUM",
         emptyMsgType : false
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
	 		sajoUtil.openSaveVariantPop("searchArea", "HP01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "HP01");
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
                  <dt CL="STD_BOARDTITLEGH"></dt>
                  <dd>
                     <input type="text" class="input" name="TITLE" UIInput="S"/>
                  </dd>
               </dl>
               <dl>
                  <dt CL="STD_BOARDCONTENTGH"></dt>
                  <dd>
                     <input type="text" class="input" name="CONTENT" UIInput="SR"/>
                  </dd>
               </dl>
            </div>
            <div class="btn_tab">
               <input type="button" class="btn_more" value="more" onclick="searchMore()"/>
            </div>
         </div>
      </div>
        <div class="search_next_wrap">
         <div class="content-horizontal-wrap h-wrap-min">   
            <div class="content_layout tabs content_left" style="width: 550px;">
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
                                 <td GH="150" GCol="text,BODNUM"></td>
                                 <td GH="150" GCol="input,TITLE"></td>
                                 <td GH="150" GCol="input,USERNM"></td>
                                 <td GH="150" GCol="input,VIEWCOUNT"></td>
                                 <td GH="150" GCol="input,CREDATE"></td>
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
<!--                      <button type='button' GBtn="total"></button> -->
                     <button type='button' GBtn="layout"></button>
                     <button type='button' GBtn="excel"></button>
<!--                      <button type='button' GBtn="excelUpload"></button> -->
                     <span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
                  </div>
               </div>
            </div>
            <div class="content_layout tabs content_right" style="width : calc(100% - 570px);">
               <ul class="tab tab_style02">
                  <li><a href="#tab1-1"><span>상세내역</span></a></li>
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
                           <tbody id="gridItemList">
                              <tr CGRow="true">
                                 <td GH="40" GCol="rownum">1</td>
                                 <td GH="40" GCol="rowCheck"></td>
                                 <td GH="150" GCol="input,BODNUM"></td>
                                 <td GH="150" GCol="input,TITLE"></td>
                                 <td GH="150" GCol="input,USERNM"></td>
                                 <td GH="150" GCol="input,CONTENT"></td>
                                 <td GH="150" GCol="input,CREDATE"></td>                  
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
<!--                      <button type='button' GBtn="total"></button> -->
                     <button type='button' GBtn="layout"></button>
                     <button type='button' GBtn="excel"></button>
<!--                      <button type='button' GBtn="excelUpload"></button> -->
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