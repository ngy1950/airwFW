<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UI01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "UI01",
			pkcol : "USERID",
		    menuId : "UI01"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
						
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
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList"){
			var newData = new DataMap();
			newData.put("COMPKY","<%=compky%>");
 			//newData.put("RECNTF",0);
 			//newData.put("PGSIZE",0);
 			//newData.put("FTSIZE",0);
 			newData.put("NATNKY","KR");
 			newData.put("LANGKY","KO");
			newData.put("DATEFM",'01');
			newData.put("DATEDL",10);
			newData.put("DECPFM",'01');
			newData.put("CURRFM",20);			
			return newData;
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridList"){
			var rowState = gridList.getRowState(gridId, rowNum);
			if(rowState === configData.GRID_ROW_STATE_INSERT){
				gridList.setRowReadOnly(gridId, rowNum, false, ["USERID"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["USERID"]);
			}
		}
		return false;
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "USERID" && $.trim(colValue) != ""){
				var isDulication = false;
				
				var param = gridList.getRowData(gridId, rowNum);
				var json = netUtil.sendData({
					module : "System",
					command : "USER_DUPLICATION",
					param : param,
					sendType : "map"
				});
				if(json && json.data){
					if(json.data["CNT"] > 0){
						isDulication = true;
						commonUtil.msgBox("SYSTEM_ISUSEUSRID",colValue);
					}else{
						var duplicationUserIdCheck = gridList.getGridBox(gridId).duplicationCheck(rowNum, colName, colValue);
						if(!duplicationUserIdCheck){
							isDulication = true;
							commonUtil.msgBox("SYSTEM_DUPUSRID",colValue);
						}
					}
				}
				
				if(isDulication){
					gridList.setColValue(gridId, rowNum, colName, "");
				}
			}else if(colName == "LLOGWH" && $.trim(colValue) != ""){
				var param = new DataMap();
				param.put("WAREKY",colValue);
				param.put("COMPKY",gridList.getColData(gridId, rowNum, "COMPKY"));
				var json = netUtil.sendData({
					module : "System",
					command : "WAHMA_CHECK",
					param : param,
					sendType : "map"
				});
				if(json && json.data){
					if(json.data["CNT"] == 0){
						commonUtil.msgBox("SYSTEM_M0009",colValue);
						gridList.setColValue(gridId, rowNum, colName, "");
					}
				}
			}
		}
	}
		
	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/system/json/saveUI01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"] ) > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}
	
	function reloadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if (btnName == "Reload") {
			reloadLabel();
			
		//공통팝업 예시
		}else if(btnName == "SaveVa"){
			var data = new DataMap();
			var option = "height=200,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/SaveVariantDialog.page", data, option);
			
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "UI01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "UI01");
 		}
	}
	
	
	function gridListEventColBtnClick(gridId, rowNum, colName) {
		if(colName == "BTN_ASSIGNTOUSER"){
			var data = gridList.getRowData("gridList", rowNum);
			var option = "height=620,width=540,resizable=yes";
			page.linkPopOpen("/wms/system/pop/UI01_UserDialog.page", data, option);
			
		}else if(colName == "BTN_USERCOPY"){			
			var data = new DataMap();
			var data = gridList.getRowData("gridList", rowNum);
			var option = "height=150,width=470,resizable=yes";
			page.linkPopOpen("/wms/system/pop/UI01_UserLayoutCopyDialog.page", data, option);
			
		}
	
	}
	
	//팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    	sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
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
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH STD_SEARCH" /> 
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<input type="button" CB="Reload RESET STD_REFLBL" />
<!-- 					<input type="button" CB="SaveVa POPUP BTN_SAVEVARIANT" /> -->
				</div>
			</div>
			<div class="search_inner"> <!-- UI01 사용자 -->
				<div class="search_wrap ">
					<dl>  <!--사용자 ID-->  
						<dt CL="STD_USERID"></dt> 
						<dd> 
							<input type="text" class="input" name="USERID" UIInput="SR,SHUSRMA"/>
						</dd> 
					</dl> 
					<dl>  <!--이름-->  
						<dt CL="STD_NMLAST"></dt> 
						<dd> 
							<input type="text" class="input" name="NMLAST" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--관련업무-->  
						<dt CL="STD_NMFIRS"></dt> 
						<dd> 
							<input type="text" class="input" name="NMFIRS" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--메뉴키-->  
						<dt CL="STD_MENUKY"></dt> 
						<dd> 
							<input type="text" class="input" name="MENUKY" UIInput="SR,SHMNUDF"/> 
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER" GCol="rownum">1</td> 
										<td GH="80 STD_USERID" GCol="input,USERID,SHUSRMA" validate="required"></td> <!--사용자 ID-->
										<td GH="150 STD_PASSWD" GCol="input,PASSWD" validate="required"></td> <!--비밀번호-->
										<td GH="100 STD_NMLAST" GCol="input,NMLAST" validate="required"></td> <!--이름-->
										<td GH="100 STD_NMFIRS" GCol="input,NMFIRS" GF="S 40"></td>	<!--관련업무-->
										<td GH="100 STD_DEPART" GCol="input,DEPART" GF="S 20"></td>	<!--출발지권역코드-->
										<td GH="50 STD_DELMAK" GCol="check,DELMAK">삭제</td> <!--삭제-->
										
			    						<td GH="100 STD_ASSIGNTOUSER" Gcol="btn,BTN_ASSIGNTOUSER" GB="USERCOPY SAVE STD_ASSIGNTOUSER"></td>
			    						<td GH="120 BTN_LAYOUTCOPY" Gcol="btn,BTN_USERCOPY" GB="USERCOPY SAVE BTN_LAYOUTCOPY"></td>
			    						
										<td GH="80 STD_MENUKY" GCol="input,MENUKY,SHMNUDF" GF="S 10"></td>	<!--메뉴키-->
			    						<td GH="80 STD_PDAMKY" GCol="input,PDAMKY,SHROLDF" GF="S 10"></td>	<!-- PDA권한-->
			    						<td GH="100 STD_ADDR01" GCol="input,ADDR01" GF="S 180"></td> <!--주소-->
			    						<td GH="50 STD_ADDR02" GCol="input,ADDR02" GF="S 180"></td> <!--납품주소-->
			    						<td GH="50 STD_ADDR03" GCol="input,ADDR03" GF="S 180"></td> <!--주소3-->
			    						<td GH="100 STD_TELN01" GCol="input,TELN01" GF="S 20"></td>	<!--전화번호1-->
			    						<td GH="100 STD_TELN02" GCol="input,TELN02" GF="S 20"></td>	<!--전화번호2-->
			    						<td GH="120 STD_FAXTL1" GCol="input,FAXTL1" GF="S 20"></td>	<!--팩스번호-->
			    						<td GH="100 STD_TELN03" GCol="input,TELN03" GF="S 20"></td>	<!--거래서 담당전번-->
			    						<td GH="80 STD_TLEXT1" GCol="input,TLEXT1" GF="S 10"></td>	<!--전화번호1 : Ex-->
			    						<td GH="100 STD_EMAIL1" GCol="input,EMAIL1" GF="S 120"></td> <!--이메일-->
			    						<td GH="100 STD_EMAIL2" GCol="input,EMAIL2" GF="S 120"></td> <!--이메일2-->
			    						<td GH="80 STD_POBOX1" GCol="input,POBOX1" GF="S 10"></td>	<!--P.O.Box1-->
			    						<td GH="80 STD_POBPC1" GCol="input,POBPC1" GF="S 10"></td>	<!--POBox우편번호-->
			    						<td GH="50 STD_CITY01" GCol="input,CITY01" GF="S 40"></td> <!--도시-->
			    						<td GH="50 STD_REGN01" GCol="input,REGN01" GF="S 40"></td> <!--관할거점-->
			    						<td GH="50 STD_POSTCD" GCol="input,POSTCD" GF="S 30"></td>	<!--우편번호-->
			    						<td GH="80 STD_COMPKY" GCol="input,COMPKY,SHCOMMA" GF="S 20"></td>	<!--회사-->
			    						
			    						<td GH="120 STD_UROLKY"  GCol="select,UROLKY"> <!--사용자 권한키 -->
											<select class="input" CommonCombo="USERTY">
											</select>
										</td>
			    						
			    						<td GH="80 STD_NATNKY"  GCol="select,NATNKY"> <!--국가키 -->
											<select class="input" CommonCombo="NATNKY">
											</select>
										</td>
										
										<td GH="80 STD_LANGKY"  GCol="select,LANGKY"> <!--언어 -->
											<select class="input" CommonCombo="LANGKY">
											</select>
										</td>
			    						
			    						<td GH="80 STD_EMPLID" GCol="text,EMPLID" GF="S 30"></td>	<!--사원번호-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30"></td>	<!--생성자명-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30"></td>	<!--수정자명-->
			    						
			    						<td GH="80 STD_DATEFM"  GCol="select,DATEFM"> <!--일자포멧 -->
											<select class="input" CommonCombo="DATEFM">
											</select>
										</td>
			    						
			    						<td GH="80 STD_DATEDL"  GCol="select,DATEDL"> <!--일자 구분자 -->
											<select class="input" CommonCombo="DATEDL">
											</select>
										</td>
										
										<td GH="80 STD_CURRFM"  GCol="select,CURRFM"> <!--화폐 유형 -->
											<select class="input" CommonCombo="CURRFM">
											</select>
										</td>
										
			    						<td GH="80 STD_DECPFM"  GCol="select,DECPFM"> <!--소수점표시방법 -->
											<select class="input" CommonCombo="DECPFM">
											</select>
										</td>
										
			    						<td GH="80 STD_LASTLOGINDATETIME" GCol="text,LLOGID" GF="S 10"></td>	<!--최종로그인 일자-->
			    						<td GH="80 STD_LLOGIT" GCol="text,LLOGIT" GF="S 10"></td>	<!--최종로그인 시간--> 
			    						<td GH="80 STD_LASTLOGOUTDATETIME" GCol="text,LLOGOD" GF="S 10"></td>	<!--최종아웃 일자-->
			    						<td GH="80 STD_LLOGOT" GCol="text,LLOGOT" GF="S 10"></td>	<!--최종아웃 시간-->
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
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button> 
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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