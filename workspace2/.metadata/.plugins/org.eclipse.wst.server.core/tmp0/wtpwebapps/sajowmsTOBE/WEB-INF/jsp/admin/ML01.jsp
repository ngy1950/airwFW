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
	    	module : "Master",
			command : "ML01",
			pkcol : "COMPKY,WAREKY,LOCAKY,AREAKY,ZONEKY",
			menuId : "ML01"
	    });
		gridList.setReadOnly("gridList", true, ["LOCAKY"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

		$("#WAREKY").val(<%=wareky%>);
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
		if(gridList.validationCheck("gridList", "All")){
			var list = gridList.getModifyList("gridList","A");
			
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			for(var i=0;i < list.length;i++){
				var listMap = list[i].map;
				if(listMap.GRowState != "D"){
					if(listMap.LOCAKY == null || listMap.LOCAKY == ''){
						commonUtil.msgBox("COMMON_M0009",uiList.getLabel("STD_LOCAKY"));
						setColFocus("gridList", list[i].get("GRowNum"), "LOCAKY");
						return;
					}
					if(listMap.AREAKY == null || listMap.AREAKY == ''){
						commonUtil.msgBox("COMMON_M0009",uiList.getLabel("STD_AREAKY"));
						setColFocus("gridList", list[i].get("GRowNum"), "AREAKY");
						return;
					}
					
					if(listMap.ZONEKY == null || listMap.ZONEKY == ''){
						commonUtil.msgBox("COMMON_M0009",uiList.getLabel("STD_ZONEKY"));
						setColFocus("gridList", list[i].get("GRowNum"), "ZONEKY");
						return;
					}
				}
			}

				
			var param = inputList.setRangeDataParam("searchArea");
				param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveML01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
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
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "ML01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "ML01");
 		}
	}
	

    function gridListEventRowAddAfter(gridId, rowNum) {
    	if(gridId == 'gridList'){
    		gridList.setReadOnly("gridList", false, ["LOCAKY"]);

            
            gridList.setColValue("gridList", rowNum, "COMPKY", "<%=compky%>");
  		  	gridList.setColValue("gridList", rowNum, "WAREKY", "<%=wareky%>");
  		  	gridList.setColValue("gridList", rowNum, "LENGTH", 0);
  		  	gridList.setColValue("gridList", rowNum, "WIDTHW", 0);
  		  	gridList.setColValue("gridList", rowNum, "HEIGHT", 0);
  		  	gridList.setColValue("gridList", rowNum, "CUBICM", 0);
  		  	gridList.setColValue("gridList", rowNum, "MAXCPC", 0);
  		  	gridList.setColValue("gridList", rowNum, "MAXQTY", 0);
  		  	gridList.setColValue("gridList", rowNum, "MAXWGT", 0);
  		  	gridList.setColValue("gridList", rowNum, "MAXLDR", 0);
  		  	gridList.setColValue("gridList", rowNum, "QTYCHK", 0);
  		  	gridList.setColValue("gridList", rowNum, "INDCPC", "V");
  		  	gridList.setColValue("gridList", rowNum, "LOCATY", "20");
  		  	gridList.setColValue("gridList", rowNum, "STATUS", "00");

    	}
    }

    //change Event
    function gridListEventColValueChange(gridId, rowNum, colName, colValue){
        if(colName == "LOCAKY"){
            if(colValue != ""){
                var param = inputList.setRangeParam("searchArea");
                param.put("WAREKY","<%=wareky%>");
                param.put(colName,colValue);
                
                var json = netUtil.sendData({
                    module : "Master",
                    command : "ML01_LOCAKY",
                    param : param,
                    sendType: "list"
                });
                
                if(json.data[0].CHK > 0){
    				commonUtil.msgBox(" * 로케이션이 이미 존재합니다. * ");
    				
    				gridList.setColValue(gridId, rowNum, colName, "");
                }
            }else{
                gridList.setColValue(gridId, rowNum, colName, "");
            }
        }else if(colName == "ZONEKY"){
            if(colValue != ""){
                var param = inputList.setRangeParam("searchArea");
                param.put("WAREKY","<%=wareky%>");
                param.put("AREAKY",gridList.getColData(gridId, rowNum, "AREAKY"))
                param.put(colName,colValue);
                
                var json = netUtil.sendData({
                    module : "Master",
                    command : "ML01_JONETY",
                    param : param,
                    sendType: "list"
                });
                
                if(!(json && json.data.length > 0)){
                	var wareky =gridList.getColData(gridId, rowNum, "WAREKY"); 
                	var zongky =gridList.getColData(gridId, rowNum, "ZONEKY"); 
    				commonUtil.msgBox("MASTER_M0559",[wareky,zongky]);
    				
//     				gridList.setColValue(gridId, rowNum, "AREAKY", "");
    				gridList.setColValue(gridId, rowNum, colName, "");
                }
            }else{
                gridList.setColValue(gridId, rowNum, colName, "");
            }
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
	 
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        //동
        if(searchCode == "SHAREMA"){
            param.put("WAREKY", $("#WAREKY").val());
        //존
        }else if(searchCode == "SHZONMA"){
        	param.put("WAREKY", $("#WAREKY").val());
        //로케이션
        }else if(searchCode == "SHLOCMA"){
            param.put("CMCDKY","WAREKY");
         	param.put("WAREKY", $("#WAREKY").val());
        	param.put("OWNRKY", $("#OWNRKY").val());
                
     		//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
        	param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        }else if(searchCode == "SHSKUMA"){
        	param.put("OWNRKY","<%=ownrky %>");
        	param.put("WAREKY", $("#WAREKY").val());
        }else if(searchCode == "SHSKUMA_L"){
        	param.put("OWNRKY","<%=ownrky %>");
        	param.put("WAREKY", $("#WAREKY").val());
	    }
    	return param;
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
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY"  class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false"></select>
						</dd>
					</dl>
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="A.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="A.ZONEKY" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업구역-->  
						<dt CL="STD_TKZONE"></dt> 
						<dd> 
							<input type="text" class="input" name="A.TKZONE" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="A.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--지정품목-->  
						<dt CL="STD_LOCSKU"></dt> 
						<dd> 
							<input type="text" class="input" name="A.LOCSKU" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>    
						<dt CL="STD_LOCATY"></dt> 
						<dd> 
							<select name="LOCATY" id="LOCATY" class="input" CommonCombo="LOCATY">
								<option value="">ALL</option>
							</select> 
						</dd> 
					</dl> 
					<dl>    
						<dt CL="STD_STATUS"></dt> 
						<dd> 
							<select name="STATUS" id="STATUS" class="input" CommonCombo="STATUS">
								<option value="">ALL</option>
							</select> 
						</dd> 
					</dl>
					<dl>
						<dt CL="STD_INDUPA"></dt>
						<dd>
							<input type="checkbox" class="input" name="INDUPA" id="INDUPA" style="margin-top: 0px;" value="V" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_INDUPK"></dt>
						<dd>
							<input type="checkbox" class="input" name="INDUPK" id="INDUPK" style="margin-top: 0px;" value="V"/>
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
				    						<td GH="160 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20">로케이션</td>	<!--로케이션-->
				    						<td GH="130 STD_LOCATY" GCol="select,LOCATY">
									        	<select class="input" CommonCombo="LOCATY"></select>
									        </td> <!--로케이션유형-->
				    						<td GH="100 STD_AREAKY" GCol="input,AREAKY,SHAREMA" GF="S 10">동</td>	<!--동-->
				    						<td GH="200 STD_SHORTX" GCol="input,SHORTX" GF="S 60">설명</td>	<!--설명-->
				    						<td GH="100 STD_ZONEKY" GCol="input,ZONEKY,SHZONMA" GF="S 10">존</td>	<!--존-->
				    						<td GH="100 STD_TKZONE" GCol="input,TKZONE,SHZONMA" GF="S 10">작업구역</td>	<!--작업구역-->
				    						<td GH="100 STD_FACLTY" GCol="input,FACLTY" GF="S 10">동-층</td>	<!--동-층-->
				    						<td GH="100 STD_INDCPC" GCol="check,INDCPC" >Capa체크</td>	<!--Capa체크-->
				    						<td GH="100 STD_OBROUT" GCol="input,OBROUT" GF="S 20">출고순서</td>	<!--출고순서-->
											<td GH="130 STD_STATUS" GCol="select,STATUS">
									        	<select class="input" CommonCombo="STATUS"></select>
									        </td><!--상태-->
				    						<td GH="100 STD_LENGTH" GCol="input,LENGTH" GF="N 20,0">포장가로</td>	<!--포장가로-->
				    						<td GH="100 STD_WIDTHW" GCol="input,WIDTHW" GF="N 20,0">포장세로</td>	<!--포장세로-->
				    						<td GH="100 STD_HEIGHT" GCol="input,HEIGHT" GF="N 20,0">포장높이</td>	<!--포장높이-->
				    						<td GH="100 STD_CUBICM" GCol="input,CUBICM" GF="N 20,0">CBM</td>	<!--CBM-->
				    						<td GH="100 STD_MAXCPC" GCol="input,MAXCPC" GF="N 20,0">Capa. (Max)</td>	<!--Capa. (Max)-->
				    						<td GH="100 STD_LOCSID" GCol="input,NEDSID" GF="S 20">로케이션담당자</td>	<!--로케이션담당자-->
				    						<td GH="100 STD_INDUPA" GCol="check,INDUPA" >입고가능</td>	<!--입고가능-->
				    						<td GH="100 STD_INDUPK" GCol="check,INDUPK" >피킹가능</td>	<!--피킹가능-->
				    						<td GH="100 IFT_TEXT01" GCol="input,TEXT01" GF="S 250">비고</td>	<!--비고-->
				    						<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="100 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	<!--생성자명-->
				    						<td GH="100 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="100 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="100 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
				    						<td GH="100 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	<!--수정자명-->
				    						<td GH="100 STD_LOCSKU" GCol="input,LOCSKU,SHSKUMA_L" GF="S 20">지정품목</td>	<!--지정품목-->
				    						<td GH="100 STD_LOCSKUNM" GCol="text,LOCSKUNM" GF="S 120">지정품목명</td>	<!--지정품목명-->
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
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
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