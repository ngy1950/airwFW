<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL22</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Report",
			command : "RL09",
		    menuId : "RL09"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
	
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Move"){
			move();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RL09");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "RL09");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	
		 //출고유형
		if(searchCode == "SHDOCTM" ){/* && $inputObj.name == "CF.CARNUM" */
	        param.put("DOCCAT","200");	
	      //제품코드
		} else if(searchCode == "SHSKUMA"){
	        param.put("WAREKY","<%=wareky %>");
	        param.put("OWNRKY","<%=ownrky %>");
	       //거래처코드
	 	} else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNRTO"){
	        param.put("OWNRKY","<%=ownrky %>");	 
	      //주문량조정사유
		} else if(searchCode == "SHRSNCD"){
			param.put("DOCUTY","399");
			param.put("DOCCAT","300");
	        param.put("OWNRKY","<%=ownrky %>");
	      // To 로케이션
		} else if(searchCode == "SHLOCMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
            param.put("CMCDKY","SKUG01");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU04"){
            param.put("CMCDKY","ASKU04");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "M.SKUG05"){
            param.put("CMCDKY","SKUG05");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
            param.put("CMCDKY","SKUG02");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
            param.put("CMCDKY","SKUG03");
            
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG04"){
            param.put("CMCDKY","SKUG04");
        }else  if(searchCode == "SHAREMA"){
            param.put("WAREKY",$('#WAREKY').val());
            
        }else if(searchCode == "SHZONMA"){
            param.put("WAREKY",$('#WAREKY').val());
            
        }else if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
        }
		 
		 return param;
	}

	function move(){
		
		if(gridList.validationCheck("gridList", "select")){
			var item = gridList.getSelectData("gridList", true);
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.LOCATG.trim() == ""){
					commonUtil.msgBox("To 로케이션을 입력해주세요");
					return;
				}
			}

			var param = inputList.setRangeParam("searchArea");
			param.put("list",item);
			param.put("CREUSR", "<%=userid%>");
			
			netUtil.send({
				url : "/Report/json/moveRL09.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}// end saveData()
	

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(colName == "QTTAOR" ){
			var avialQty =  Number(gridList.getColData(gridId, rowNum, "AVAILABLEQTY"));
			if(Number(colValue) > avialQty){
				commonUtil.msgBox("VALID_RL09QTY",[avialQty+"/"+colValue]);
				gridList.setColFocus(gridId, rowNum, colName);
				gridList.setColValue(gridId, rowNum, colName, avialQty);
				return;
			}
			if(Number(colValue) < 1){
				commonUtil.msgBox("TASK_M0019",[colValue]);
				gridList.setColFocus(gridId, rowNum, colName);
				gridList.setColValue(gridId, rowNum, colName, 0);
				return;
			}
			
		}
	}

	//저장 후 재조회 
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data.RESULT != ""){
				commonUtil.msgBox("재고 변경이 성공하였습니다. 조정문서번호 : " + json.data.RESULT);
				searchList();				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" /></div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" />
						<input type="button" CB="Move SAVE BTN_TASOTY320" />  
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
							</dd>
						</dl>
						<!-- 거점 -->
			            <dl>
			              <dt CL="STD_WAREKY"></dt>
			              <dd>
			                <select name="WAREKY" id="WAREKY" class="input" name="IFWMS113.WAREKY" ComboCodeView="true"></select>
			              </dd>
			            </dl>
						<dl>  <!--S/O 번호-->  
							<dt CL="STD_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SHPOKY" UIInput="SR,SHSHPDH"/> 
							</dd> 
						</dl> 
						<dl>  <!--동-->  
							<dt CL="STD_AREAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--존-->  
							<dt CL="STD_ZONEKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품명-->  
							<dt CL="STD_DESC01"></dt> 
							<dd> 
								<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--대분류-->  
							<dt CL="STD_SKUG01"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SKUG01" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--생성일자-->  
							<dt CL="STD_CREDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="S.CREDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--생성자-->  
							<dt CL="STD_CREUSR"></dt> 
							<dd> 
								<input type="text" class="input" name="S.CREUSR" UIInput="SR,SHUSRMA"/> 
							</dd> 
						</dl>   
						<dl>  <!--유통기한-->  
							<dt CL="STD_LOTA13"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--입고일자-->  
							<dt CL="STD_LOTA12"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
						<dl>  <!--벤더-->  
							<dt CL="STD_LOTA03"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
						</dl> 
						<dl>  <!--포장구분-->  
							<dt CL="STD_LOTA05"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
							</dd> 
						</dl> 
						<dl>  <!--재고유형-->  
							<dt CL="STD_LOTA06"></dt> 
							<dd> 
								<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/> 
							</dd> 
						</dl> 
						<dl>  <!--입고문서번호-->  
							<dt CL="STD_RECVKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.RECVKY" UIInput="SR,SHRECDH"/> 
							</dd> 
						</dl> 
						<dl>  <!--작업지시번호-->  
							<dt CL="STD_TASKKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.TASKKY" UIInput="SR,SHVPTASO"/> 
							</dd> 
						</dl> 
						<dl>  <!--조정문서번호-->  
							<dt CL="STD_SADJKY"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SADJKY" UIInput="SR,SHADJDH"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량별피킹번호-->  
							<dt CL="STD_SSORNU"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SSORNU" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--구매오더 No-->  
							<dt CL="STD_SEBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="S.SEBELN" UIInput="SR,SHPO103"/> 
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
											<td GH="40" GCol="rowCheck"></td>
											<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
											<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
											<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
											<td GH="80 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
											<td GH="70 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td>	<!--재고수량-->
											<td GH="70 STD_QTSAVLB" GCol="text,AVAILABLEQTYUOM" GF="N 20,0">가용수량</td>	<!--가용수량-->
				    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 20">재고키</td>	<!--재고키-->
				    						<td GH="50 STD_TRUNTY" GCol="text,TRUNTY" GF="S 3">팔렛타입</td>	<!--팔렛타입-->
				    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
				    						<td GH="70 STD_QTTAOR" GCol="input,QTTAOR" GF="S 20">작업수량</td>	<!--작업수량-->
				    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="S 20" validate="required">To 로케이션</td>	<!--To 로케이션-->
				    						<td GH="70 STD_QTSALO" GCol="text,QTSALO" GF="N 20,0">할당수량</td>	<!--할당수량-->
											<td GH="70 STD_QTSPMO" GCol="text,QTSPMO" GF="N 20,0">이동중</td>	<!--이동중-->
				    						<td GH="70 STD_QTSPMI" GCol="text,QTSPMI" GF="N 20,0">입고중</td>	<!--입고중-->
				    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
				    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
				    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
				    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
				    						<td GH="50 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
				    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="50 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템--
				    						<td GH="90 STD_TASKKY" GCol="text,TASKKY" GF="N 10,0">작업지시번호</td>	<!--작업지시번호-->
				    						<td GH="90 STD_TASKIT" GCol="text,TASKIT" GF="N 6,0">작업오더아이템</td>	<!--작업오더아이템-->
				    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
				    						<td GH="50 STD_SADJIT" GCol="text,SADJIT" GF="S 6">조정 Item</td>	<!--조정 Item-->
				    						<td GH="80 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>	<!--재고조사번호-->
				    						<td GH="50 STD_PHYIIT" GCol="text,PHYIIT" GF="S 6">재고조사item</td>	<!--재고조사item-->
				    						<td GH="70 STD_QTSBLK" GCol="text,QTSBLK" GF="N 20,0">보류수량</td>	<!--보류수량-->
				    						<td GH="70 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->	
				    						<td GH="50 STD_RSNCOD" GCol="text,RSNCOD" GF="S 4">사유코드</td>	<!--사유코드-->
				    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="80 STD_LOCAKY" GCol="text,LOCAKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="64 STD_ACTCDT" GCol="text,ACTCDT" GF="D 8">실제완료날짜</td>	<!--실제완료날짜-->
				    						<td GH="50 STD_ACTCTI" GCol="text,ACTCTI" GF="T 6">실제완료시간</td>	<!--실제완료시간-->
				    						<td GH="80 STD_QTYUOM" GCol="text,QTYUOM" GF="N 20,0">Quantity by unit of measure</td>	<!--Quantity by unit of measure-->
				    						<!-- <td GH="80 STD_LOCAKYNM" GCol="text,LOCAKYNM" GF="S 100"></td>	 -->
				    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
				    						<td GH="80 STD_LOCASRL7141" GCol="text,LOCAPK" GF="S 20"></td>	<!---->
				    						<td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
				    						<td GH="64 STD_REFDAT" GCol="text,REFDAT" GF="S 8">참조문서일자</td>	<!--참조문서일자-->
				    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
				    						<td GH="160 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,3">포장중량</td>	<!--포장중량-->
				    						<td GH="160 STD_NETWGT" GCol="text,NETWGT" GF="N 20,3">순중량</td>	<!--순중량-->
				    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
				    						<td GH="160 STD_LENGTH" GCol="text,LENGTH" GF="N 20,3">포장가로</td>	<!--포장가로-->
				    						<td GH="160 STD_WIDTHW" GCol="text,WIDTHW" GF="N 20,3">포장세로</td>	<!--포장세로-->
				    						<td GH="160 STD_HEIGHT" GCol="text,HEIGHT" GF="N 20,3">포장높이</td>	<!--포장높이-->
				    						<td GH="160 STD_CUBICM" GCol="text,CUBICM" GF="N 20,3">CBM</td>	<!--CBM-->
				    						<td GH="160 STD_CAPACT" GCol="text,CAPACT" GF="N 20,3">CAPA</td>	<!--CAPA-->
				    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
				    						<td GH="50 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	<!--Client-->
				    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 40">구매오더 No</td>	<!--구매오더 No-->
				    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
				    						<td GH="80 STD_SSORNU" GCol="text,SSORNU" GF="S 10">차량별피킹번호</td>	<!--차량별피킹번호-->
				    						<td GH="50 STD_SSORIT" GCol="text,SSORIT" GF="S 6">차량별아이템피킹번호</td>	<!--차량별아이템피킹번호-->
				    						<td GH="100 STD_SXBLNR" GCol="text,SXBLNR" GF="S 16">인터페이스번호</td>	<!--인터페이스번호-->
				    						<td GH="88 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
				    						<td GH="88 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
				    						<td GH="88 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
				    						<td GH="88 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
				    						<td GH="88 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
				    						<td GH="88 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
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