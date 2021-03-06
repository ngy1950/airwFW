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
	    	module : "Board",
			command : "BD10",
			pkcol : "CMCDKY",
			itemGrid : "gridList2",
			itemSearch : true,
			menuId : "BD10"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Board",
			command : "BD10",
			menuId : "BD10"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	function searchList(){
		gridList.resetGrid("gridList");
		$("#SCWRITER").val(""); // 작성자
		$("#SCWRDATE").val(""); // 작성일자
		$("#SCTITLE").val(""); // 제목
		$("#SCCONTENT").val(""); // 내용
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("BOARDNO","NOTI");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
		}
	}

	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var list = gridList.getModifyData("gridList", "A")

			var param = dataBind.paramData("searchArea");
			param.put("list",list);
	
			if(list.length == 0){ // 글쓰기 수정한 경우
				
				if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
					return;
		        }
				// 글쓰기 수정한 경우 제목, 내용, 작성자 파라미터 셋팅
				param.put("GRowState", "U");
				param.put("OWNRKY",$("#OWNRKY").val()); // 작성자
				param.put("TEXTNO", $("#SCTEXTNO").val()); // 글번호
				param.put("WRITER",$("#SCWRITER").val()); // 작성자 
				param.put("WRDATE",$("#SCWRDATE").val()); // 작성일자 
				param.put("TITLE",$("#SCTITLE").val());  // 제목
				param.put("CONTENT",$("#SCCONTENT").val()); // 내용
				
			} else{
				
				//item 저장불가 조건 체크
				for(var i=0; i<list.length; i++){
					var itemMap = list[i].map;
					
					// 새글쓰기한 경우 제목, 내용, 작성자 파라미터 셋팅
					if(itemMap.GRowState == "C"){
						
						param.put("OWNRKY",$("#OWNRKY").val()); // 작성자 
						param.put("WRITER",$("#SCWRITER").val()); // 작성자 
						param.put("WRDATE",$("#SCWRDATE").val()); // 작성일자 
						param.put("TITLE",$("#SCTITLE").val());  // 제목
						param.put("CONTENT",$("#SCCONTENT").val()); // 내용
					}
				}
			}

			netUtil.send({
				url : "/board/json/saveBD10.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "NewWrite"){
			newWriteData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "BD10");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "BD10");
		}
	}
	
	function newWriteData() {
		
		$("#SCWRITER").val("<%=username%>"); // 작성자에 세션 id 셋팅 
		$("#SCWRDATE").val(""); // 작성일자
		$("#SCTITLE").val(""); // 제목
		$("#SCCONTENT").val(""); // 내용
		
		gridList.setAddRow("gridList", null); // gridList에 줄 추가
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridList"){
			var param = gridList.getRowData(gridId, rowNum);
			param.put("BOARDNO","NOTI");
			param.put("CONTENT", "");

			var json = netUtil.sendData({
				module : "Board",
				command : "BD10",
				bindId : "titem",
				sendType : "list",
				bindType : "field",
				param : param
			});
			
			var list = json.data[0];				

			dataBind.dataNameBind(list, "titem");	

			
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
    
    function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
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
					<input type="button" CB="NewWrite SEARCH BTN_NEWWRITE" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			
			<div class="search_inner">
				<div class="search_wrap ">
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 제목 + 내용 -->
					<dl>
						<dt CL="제목 + 내용"></dt>
						<dd>
							<input type="text" class="input" id="CONTENT" name="CONTENT"  />
						</dd>
					</dl>
					
					<!-- 작성자 -->
					<dl>
						<dt CL="STD_WRITER"></dt>
						<dd>
							<input type="text" class="input" id="WRITER" name="WRITER" UIInput="SR" />
						</dd>
					</dl>
					
					<!-- 작성일자 -->
					<dl>
						<dt CL="STD_WRDATE"></dt>
						<dd>
							<input type="text" class="input" id="WRDATE" name="WRDATE" UIInput="SR" UIFormat="C" PGroup="G1,G2"/>
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
											<td GH="80 STD_TITLE" GCol="text,TITLE" GF="S">제목</td>
											<td GH="80 STD_WRDATE" GCol="text,WRDATE" GF="D 8">작성일자</td>
											<td GH="80 STD_WRTIME" GCol="text,WRTIME" GF="T 8">작성시간</td>
											<td GH="80 STD_WRITER" GCol="text,WRITER" GF="S 60">작성자</td>
											<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S">화주</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<!-- <button type='button' GBtn="add"></button> -->
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 570px);"> <!-- 상세내역 크기 넓게 요청.. calc(100% - 570px) - > calc(100%) -->
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>상세내역</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1" >
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
		                        <tbody id="gridList2">   
		                        	<tr>
		                                <th CL="STD_GENERAL" colspan="4" style="text-align: center; background: white;"></th>
		                            </tr>       
		                            <tr>
		                                <th CL="STD_WRITER"></th>
		                                <td>
		                                    <input type="hidden" class="input" id="SCTEXTNO" name="TEXTNO" disabled="disabled" readonly="readonly" />
		                                    <input type="text" class="input" id="SCWRITER" name="WRITER" disabled="disabled" readonly="readonly" />
		                                </td>
		                                <th CL="STD_WRDATE"></th>
		                                <td>
		                                    <input type="text" class="input" id="SCWRDATE" UIFormat="C" name="WRDATE"  disabled="disabled" readonly="readonly" />
		                                </td>
		                            </tr>   
		                            <tr>    
		                                <th CL="STD_TITLE"></th>
		                                <td colspan="3">
		                                    <input type="text" class="input" id="SCTITLE" name="TITLE" style="width: 100%;" />
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                                <th CL="STD_CONTENT"  style="text-align: center; background: white;"></th>
		                                 <td colspan="6">
		                                    <textarea id="SCCONTENT" name="CONTENT" style="width: 100%;" rows="30" ></textarea>
		                                </td>
		                            </tr>  
		                        </tbody>
		                    </table>
		                    <div>
		                    </div>
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