<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PUSH현황</title>
<style type="text/css">
td[gcolname="PUSH_TYP_CD"] > select{
    font-size: 1em;
}
select.none_arrow { 
-webkit-appearance:none; /* 화살표 없애기 for chrome*/
 -moz-appearance:none; /* 화살표 없애기 for firefox*/ 
 appearance:none /* 화살표 없애기 공통*/ 
 }
select.none_arrow::-ms-expand{ display:none /* 화살표 없애기 for IE10, 11*/ }
#detail > tr > td{
    font-size: 1em;
} 
.btn_reload{
    background: url(/common/theme/webdek/images/refresh.png) no-repeat;
    background-size: 42px auto;
    width:7em;
    height:15em;
}
</style>
<%@ include file="/common/include/mobile/head.jsp" %>
<script type="text/javascript">

    $(document).ready(function(){
        gridList.setGrid({
            id : "gridList",
            module : "MB1000",
            command : "MB9202",
            bindArea : "detail_gridList",
            gridMobileType : true
        });
        
       
        $(".detailGrid").fadeOut();
        searchList();
        
    });
    
    /* 조회 */
    function searchList(){
        if(validate.check("searchArea")){
            var param = inputList.setRangeParam("searchArea");
            param.put("USERID","<%=userid%>");
            
            gridList.gridList({
                id : "gridList",
                param : param
            });
        }
    }
     
    function comboEventDataBindeBefore(comboAtt,paramName){
        
        var param = new DataMap();
        if (comboAtt[1] == "BLCDCOMBO"){
            param.put("GLB_CD", "PUSH_TYP_CD");
        } 
        return param;
    }
    
    
    /* 클릭 이벤트 */
    function gridListEventRowClick(rowNum,data){
    	if(rowNum == "gridList"){
	    	$(".orgGrid").fadeOut();
	    	$(".detailGrid").fadeIn();
    		
    	}
    }
    
    function backList(){
    	$(".orgGrid").fadeIn();
        $(".detailGrid").fadeOut();
    }
    
    
</script>
</head>
<body > 
    <!-- content 시작 -->
    <div class="content_wrap">
        <div class="content_inner orgGrid">
            <div class="content_serch" id="searchArea" style="height:200px">
                <div class="search_inner">
                    <table class="search_wrap ">
                        <colgroup>
                            <col style="width:40%" />
                            <col style="width:60%" />
                        </colgroup>
                        <tr>
                            <th CL="STD_PUSH_TYP_CD"></th><!-- 이관유형 -->
                            <td>
                                <select name="PUSH_TYP_CD" class="input" Combo="BLCOMMON,BLCDCOMBO"><option value="" CL="STD_ALL"></option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th CL="STD_SND_DT"></th><!-- 전송일자 -->
                            <td>
                               <input type="text" class="input" name="SUBSTR(SND_DTTM,1,8)" UIInput="B" UIFormat="C M1"/>
                            </td>
                        </tr>  
                    </table>
                </div>
            </div>
            <div class="content_layout tabs" style="height: calc(100% - 250px);">
                <ul class="tab tab_style02">
                    <li class="selected"><a href="#tab1-1"><span>PUSH현황</span></a></li>
                    <li class="btn_zoom_wrap">
	                    <ul>
	                        <li><button class="btn_reload" onclick="searchList()" style="margin-top: 10px;"></button></li>
	                    </ul>
	                </li>
                </ul>
                <div class="table_box section" id="tab1-1" style="height: calc(100% - 30px);">
                    <div class="table_list01 "  style="height: calc(100% - 175px);">
                        <div class="scroll" style="height:calc(100% - 110px);">
                            <table class="table_c">                             
                                <tbody id="gridList">
                                    <tr CGRow="true">
	                                    <td GH="40"     GCol="rownum">1</td>
	                                    <td GH="120"    GCol="select,PUSH_TYP_CD">
	                                        <select Combo="BLCOMMON,BLCDCOMBO" ComboCodeView="false" disabled="disabled"><option value=""></option></select>
	                                    </td>
	                                    <td GH="150"    GCol="text,SND_DTTM" GF="DT" style="white-space: pre-line;"></td>
	                                    <td GH="100"    GCol="text,SND_USER_ID"></td>
<!-- 	                                    <td GH="100"    GCol="text,SND_YN"></td> -->
<!-- 	                                    <td GH="220"    GCol="text,RMK_CNTS" GF="S 1000"></td> -->
<!-- 	                                    <td GH="220"    GCol="text,CCNNC_ADDR_CNTS"></td> -->
	                                    <td GH="120"    GCol="text,MSG_CNTS"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="btn_lit tableUtil">
                        <div class="btn_out_wrap">

                        </div>
                        <span class='txt_total orgGrid' >총 <span GInfoArea='true'>4</span> 건</span>
                    </div>
                </div><!-- table_box section END -->
                
            </div><!-- content_layout tabs END-->
            <!-- 하단 버튼 시작 -->
           <!--  <div class="foot_btn">
                <button onclick="searchList()" class="btn_full orgGrid"><span>조회</span></button>
            </div> -->
            <!-- 하단 버튼 끝 -->
        </div>
        <!-- content 끝 -->
        
        <div class="content_inner detailGrid" id= "detail_gridList">
            <div class="content_layout tabs" style="height: calc(100% - 170px);">
                <ul class="tab tab_style02">
                    <li class="selected"><a href="#tab1-2"><span>PUSH상세</span></a></li>
                </ul>
                <div class="table_box section" id="tab1-2" style="height: calc(100% - 30px);">
                    <div class="table_list01"  style="height: calc(100% - 175px);">
                        <div class="scroll" style="height:calc(100% - 110px);">
                            <table class="table_c">                             
                               <!--  <tbody id="gridList">
                                    <tr CGRow="true">
                                        <td GH="150"    GCol="text,SND_DTTM" GF="DT"></td>
                                        <td GH="100"    GCol="text,SND_USER_ID"></td>
                                        <td GH="100"    GCol="text,SND_YN"></td>
                                        <td GH="220"    GCol="text,RMK_CNTS" GF="S 1000"></td>
                                        <td GH="220"    GCol="text,CCNNC_ADDR_CNTS"></td>
                                        <td GH="100"    GCol="text,MSG_CNTS"></td>
                                    </tr>
                                </tbody> -->
                                <colgroup>
                                    <col style="width:35%" />
                                    <col style="width:65%" />
                                </colgroup>
                                <tbody id="detail">
                                <tr>
                                    <th CL="STD_PUSH_TYP_CD"></th>
                                    <td>
                                       <select class="input" name="PUSH_TYP_CD"  Combo="BLCOMMON,BLCDCOMBO" ComboCodeView="false" disabled="disabled" style="width:100%">
                                            <option value="" CL="STD_ALL"></option>
                                       </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th CL="STD_SND_DTTM"></th>
                                    <td>
                                        <input class="input" name="SND_DTTM" UIFormat="DT" readonly="readonly" style="width:100%"/>
                                    </td>
                                </tr>
                                <tr>
                                   <th CL="STD_SND_USER_ID"></th>
                                    <td>
                                        <input class="input" name="SND_USER_ID" readonly="readonly" style="width:100%"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="2" CL="STD_MSG_CNTS"></th>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                       <input type="text" class="input" name="MSG_CNTS" readonly="readonly" style="width:100%" />
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="2" CL="STD_CCNNC_ADDR_CNTS"></th>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                       <input type="text" class="input" name="CCNNC_ADDR_CNTS" readonly="readonly" style="width:100%"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="2" CL="STD_RMK_CNTS"></th>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                       <input type="text" class="input" name="RMK_CNTS" readonly="readonly" style="width:100%"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="btn_lit tableUtil">
                        <div class="btn_out_wrap">

                        </div>
                        <span class='txt_total orgGrid' >총 <span GInfoArea='true'>4</span> 건</span>
                    </div>
                </div><!-- table_box section END -->
                
            </div><!-- content_layout tabs END-->
            <!-- 하단 버튼 시작 -->
             <div class="foot_btn">
                <button onclick="backList()" class="btn_full detailGrid"><span>뒤로</span></button>
            </div>
            <!-- 하단 버튼 끝 -->
            
            
        </div>
        <!-- content 끝 -->
        
        
        
        
        
        
        
    </div>
    
</body>
</html>