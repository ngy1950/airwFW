<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Search Help</title>
<%@ include file="/ahcs/include/head.jsp" %>
<script>
	var searchType; 
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			url : "/ahcs/json/TABLE_COLOBJ_LIST.data",
			bigdata : false,
			defaultRowStatus : configData.GRID_ROW_STATE_INSERT
	    });
	});
	
	function createList(){
		searchType = false;
		var param = inputList.setRangeParam("searchArea");
		if(!param.get("INQ_TAB_NM")){
			commonUtil.msgBox("VALID_required");
			return;
		}
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		$("input[name=INQ_PUP_ID]").attr("readonly","readonly");
	}
	
	function searchList(){
		searchType = true;
		var param = inputList.setRangeParam("searchArea");
		if(!param.get("INQ_PUP_ID")){
			commonUtil.msgBox("VALID_required");
			return;
		}
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		$("input[name=INQ_PUP_ID]").removeAttr("readonly");
	}
	
	function createData(){
		if(validate.check("searchArea") && gridList.validationCheck("gridList", "modify")){
			var head = inputList.setRangeParam("searchArea");
			var list = gridList.getGridAvailData("gridList");
			var param = new DataMap(); 				
			param.put("head", head);
			param.put("list", list);
			var json = netUtil.sendData({
		    	url : "/ahcs/json/SEARCH_COLOBJ_SAVE.data",
		    	param : param
		    });
			if(json.MSG && json.MSG != 'OK'){
				var msgList = json.MSG.split(" ");
				var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				commonUtil.msg(msgTxt);
			}else if(json.data){
				commonUtil.msgBox("MASTER_M0564");
			}

			//searchList();
		}
	}
	
	function saveData(){
		if(!searchType){
			createData();
			return;
		}
		if(validate.check("searchArea") && gridList.validationCheck("gridList", "modify")){
			var list = gridList;
			var param = inputList.setRangeParam("searchArea");
			param.put("list", list);
			var json = netUtil.sendData({
		    	url : "/common/json/SQL_COLOBJ_SAVE.data",
		    	param : param
		    });
			if(json.MSG && json.MSG != 'OK'){
				var msgList = json.MSG.split(" ");
				var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				commonUtil.msg(msgTxt);
			}else if(json.data){
				commonUtil.msgBox("MASTER_M0564");
			}

			commonUtil.popupOpen("/common/tool/pagecreate/grid.page");
		}
	}
</script>
</head>
<body>
<%@ include file="/ahcs/include/top.jsp" %>
	<!-- ?????? ?????? -->
        <p class="btn_b">
            <a href="#" class="search" onclick="searchList()">??????</a>
            <a href="#" class="create" onclick="createList()">??????</a>
        </p>
        <dl class="dl_row n3" id="searchArea">
            <dt><span>????????????ID</span></dt>
            <dd>
            	<input name="INQ_PUP_ID" type="text" validate="required">
            </dd>
            <dt><span>??????????????????</span></dt>
            <dd>
            	<input name="INQ_TAB_NM" type="text" validate="required">
            </dd>
            <dt><span>??????????????????</span></dt>
            <dd>
            	<input name="INQ_ET_YN" type="checkbox" value="Y">
            </dd>
            <dt><span>???????????????</span></dt>
            <dd>
                <input name="INQ_PUP_NM" type="text" validate="required">
            </dd>
            <dt><span>??????????????????</span></dt>
            <dd>
                <input class="won" name="INQ_PUP_ARE_SIZE" type="text" validate="required" UIFormat="N 4">
            </dd>
            <dt><span>??????????????????</span></dt>
            <dd>
                <input class="won" name="INQ_PUP_HGT_SIZE" type="text" validate="required" UIFormat="N 3">
            </dd>
            <dt><span>?????????????????????</span></dt>
            <dd>
                <input name="BSC_INQ_TRMS_NM" type="text">
            </dd>            
        </dl>
        <div class="h4_wrap last">
            <div class="title">
                <h4>???????????? ??????</h4>
            </div>
            <div class="grid_scroll g1 section">
                <p class="btn_m tableUtil">
                    <span class="row_control">
                        <a href="#" class="add" GBtn="add">??????</a>
                        <a href="#" class="copy" GBtn="copy">??????</a>
                        <a href="#" class="del" GBtn="delete">??????</a>
                    </span>
                    <a href="#" class="on" onclick="saveData()">??????</a>
                </p>
                <div class="grid_head">
                    <table class="tableHeader">
                        <colgroup>
                            <col width="40" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
                        </colgroup>
                        <thead>
                            <tr>
                            	<th>??????</th>
								<th>????????????ID</th>
								<th>???????????????</th>
								<th>??????ID</th>
								<th>?????????</th>
								<th>?????????????????????</th>
								<th>???????????????</th>
								<th>???????????????</th>
								<th>????????????</th>
								<th>????????????</th>
								<th>??????????????????</th>
								<th>??????????????????</th>
								<th>??????????????????</th>
								<th>??????????????????</th>
								<th>??????????????????</th>
								<th>??????????????????</th>
								<th>???????????????</th>
								<th>?????????????????????</th>
								<th>?????????????????????</th>
								<th>?????????????????????</th>
								<th>??????????????????</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="grid_body list_20 tableBody">
                    <table>
                        <colgroup>
                            <col width="40" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
							<col width="100" />
                        </colgroup>
                        <tbody id="gridList">
                            <tr CGRow="true">
                                <td GCol="rownum">1</td>
								<td GCol="text,DIC_ID"></td>
								<td GCol="input,DIC_NM" validation="required"></td>
								<td GCol="input,LBL_ID" validation="required"></td>
								<td GCol="input,LBL_CN" validation="required"></td>
								<td GCol="text,DATA_TP_CD"></td>
								<td GCol="input,DATA_SIZE" GF="N" validation="required"></td>
								<td GCol="input,DCPT_SIZE" GF="N"></td>
								<td GCol="select,ALIGN_CD">
									<select>
										<option value="LEFT">LEFT</option>
										<option value="CENTER">CENTER</option>
										<option value="RIGHT">RIGHT</option>
									</select>
								</td>
								<td GCol="input,OUTP_SIZE" GF="N" validation="required min(50) max(300)"></td>
								<td GCol="select,INQ_ATCL_CD">
									<select>
										<option value=""></option>
										<option value="STRING">STRING</option>
										<option value="NUMBER">NUMBER</option>
										<option value="DATE">DATE</option>
										<option value="TIME">TIME</option>
										<option value="SELECT">SELECT</option>
										<option value="CHECK">CHECK</option>
									</select>
								</td>
								<td GCol="select,RNG_INQ_CD">
									<select>
										<option value=""></option>
										<option value="R">R</option>
										<option value="B">B</option>
									</select>
								</td>
								<td GCol="input,INQ_ATCL_CN"></td>
								<td GCol="input,INQ_ATCL_SQNM" GF="N"></td>
								<td GCol="check,ENT_IMPS_YN"></td>
								<td GCol="check,SRH_NSE_YN"></td>
								<td GCol="input,SRH_BAC_VAL"></td>
								<td GCol="select,GRID_ATCL_CD">
									<select>
										<option value="STRING">STRING</option>
										<option value="NUMBER">NUMBER</option>
										<option value="DATE">DATE</option>
										<option value="TIME">TIME</option>
										<option value="SELECT">SELECT</option>
										<option value="CHECK">CHECK</option>
									</select>
								</td>
								<td GCol="input,GRID_ATCL_CN"></td>
								<td GCol="input,GRID_ATCL_SQNM" GF="N"></td>
								<td GCol="check,RSLT_CLUM_YN"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="grid_control tableUtil">
                    <div class="left_wrap">??? ????????????<span GInfoArea="true">9,999,999</span></div>
                    <div class="right_wrap">
                        <div class="page_num"><span>9,999,999</span> / 9,999,999</div>
                        <div class="search_wrap">
                            <span class="search_box input_skipTitle">
                                <label for="grid_search">????????? ??????</label>
                                <input id="grid_search" name="" type="text"><a href="#" class="btn">??????</a>
                            </span>
                            <a class="prev" href="#">??????</a>
                            <a class="next" href="#">??????</a>
                        </div>
                        <div class="util">
                            <a class="btn1" href="#">????????????</a>
                            <a class="btn2 open_grid_pop_layout" href="#" GBtn="layout">??????</a>
                            <a class="btn3" href="#" GBtn="total">??????</a>
                            <a class="btn4" href="#" GBtn="excel">????????????</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!-- ?????? ??? -->
<%@ include file="/ahcs/include/bottom.jsp" %>
</body>
</html>