`<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Outbound",
			command : "DL93",
		    menuId : "DL93"
	    });
		
		$("#ORDDAT").val(dateParser(null, "SD", 0, 0, 0));
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "000");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "004");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		rangeArr.push(rangeDataMap2);		
		setSingleRangeData('I.DIRSUP', rangeArr);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL93");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL93");
		}
	}
	
	//조회
	function searchList(){
		//textFileDownload('DR13', 'TEST1');
		
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
			param.put("WAREKY","<%=wareky%>");
			var cmd = "DL93";
			
			if ($('#OPTYPE04').prop("checked") == true ){
				cmd = "DL93_2";
			}else if ($('#OPTYPE05').prop("checked") == true ){
				cmd = "DL93_3";
			}else if ($('#OPTYPE06').prop("checked") == true ){
				cmd = "DL93_4";
			}
			 

			netUtil.send({
				module : "Outbound",
				command : cmd,
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
			
			//gridList.gridList({
		    //	id : "gridList",
		    //	param : param
		    //});
		}
	}

	//저장
	function saveData() {

		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("WAREKY","<%=wareky%>");
			
			if ($('#OPTYPE03').prop("checked") == true ) {
				param.put("OPTYPE","03");
			}else if ($('#OPTYPE04').prop("checked") == true ){
				param.put("OPTYPE","04");
			}else if ($('#OPTYPE05').prop("checked") == true ){
				param.put("OPTYPE","05");
			}else if ($('#OPTYPE06').prop("checked") == true ){
				param.put("OPTYPE","06");
			}
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/outbound/json/createDasFileDL93.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	//저장완료 콜백
	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if (json.data && json.data.RESULT == "S") {
				//commonUtil.msgBox("SYSTEM_SAVEOK");
				//searchList();
				
				var key = json.data.KEY; 
				for(var i=0; i< key.length; i++){

					if(json.data[key[i]].dasListCnt < 1){
						commonUtil.msgBox("SYS_FILEDOWN",[key[i]]); // {0} 파일 생성에 실패하였습니다.
					}else{
						//파일 다운로드 콜
						textFileDownloadPop(json.data[key[i]].fileName, json.data[key[i]].fileText, key[i]);
					}
				}
				
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "PTNRKY"){
				//업체코드에 따라 업체명 자동 입력
				var param = new DataMap();
				param.put("OWNRKY", "2200");
				param.put("PTNRTY", "0007");
				param.put("PTNRKY", colValue);
				param.put("ORDDAT", $("#ORDDAT").val());

				var json = netUtil.sendData({
					module : "SajoCommon",
					command : "BZPTN_DATA",
					param : param,
				});
				
				//가져온 업체 데이터가 있다면 적용
				if(json.data && json.data.length > 0){
				  	gridList.setColValue(gridId, rowNum, "PTNRNM", json.data[0].PTNRNM);
				}else{//업체코드가 유효하지 않다면 경고 메시지 후 ptnrky 초기화
					commonUtil.msgBox("INV_M0064");
				  	gridList.setColValue(gridId, rowNum, "PTNRKY", "");
				}
			}
		}
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("DASTYP",$('#DASTYP').val());
		newData.put("CELTYP","01");//01 기본
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}
		
		return param;
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHBZPTN"){
            param.put("OWNRKY","2200");
            param.put("PTNRTY","0007");
        }
    	return param;
    }
	
	//서치헬프 리턴 
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		console.log(searchCode + '/'+ multyType + '/' + selectData + "/" + rowData);
	}
	
	function returnSearchHelp(dataList, t, menuId, t2, rowList){
		console.log(dataList + '/'+ t + '/' + menuId + "/" + t2 +"/"+rowList);
		
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "WARESR"){
            param.put("CMCDKY","WARESR");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU02"){
            param.put("CMCDKY","ASKU02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY","<%=wareky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }
        
    	return param;
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
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Save SAVE STD_DASFILETYP" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--출고일자-->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="ORDDAT" id="ORDDAT" UIFormat="C"  validate="required(IFT_ORDDAT)" /> 
							</dd> 
						</dl> 
						<dl>  <!--마감구분-->  
							<dt CL="STD_PTNG08"></dt> 
							<dd> 
								<input type="text" class="input" name="B2.PTNG08" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문구분-->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" /> 
							</dd> 
						</dl> 
						<dl>
							<dt CL="STD_GROUP"></dt><!-- DAS파일 생성 양식 -->
							<dd style="width:400px">
								<input type="radio" name="OPTYPE" id="OPTYPE03" chec1ked /><label for="OPTYPE03">안성센터</label>
			        			<input type="radio" name="OPTYPE" id="OPTYPE04" /><label for="OPTYPE04">칠곡센터</label>
								<input type="radio" name="OPTYPE" id="OPTYPE05" /><label for="OPTYPE05">오포센터</label>
			        			<input type="radio" name="OPTYPE" id="OPTYPE06" /><label for="OPTYPE06">광주센터 </label>
							</dd>
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
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
				    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
				    						<td GH="120 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 180">납품처코드</td>	<!--납품처코드-->
				    						<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 180">납품처명</td>	<!--납품처명-->
				    						<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 180">매출처코드</td>	<!--매출처코드-->
				    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 180">매출처명</td>	<!--매출처명-->
				    						<td GH="65 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="80 STD_CARNAME" GCol="text,CARNM" GF="S 17">차량명</td>	<!--차량명-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>