<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "DaerimDAS",
			command : "DR17",
		    menuId : "DR17"
	    });
		

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if (btnName == "Print") {
			print();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR17");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DR17");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");

			//라디오 버튼 값
			if ($('#GRPRL1').prop("checked") == true ) {
				param.put("DASTYP","01");
			}else if ($('#GRPRL2').prop("checked") == true ){
				param.put("DASTYP","02");
			}

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	//인쇄 차수별 소분류 리스트
	function print(){
		var headGridBox = gridList.getGridBox('gridList');
		var headList = headGridBox.getDataAll();

		if(headList.length < 1){ // 검색된 ROW 미존재 
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var wherestr = "" ;
		
		//검색조건 출고일자 
		if($("#ORDDAT").val() !=""){
			var orddat = ""+$("#ORDDAT").val()
			orddat = regExp(orddat);
			wherestr = "('"+orddat+"')";
			wherestr = " AND DP.ORDDAT IN " +wherestr;
		}else if(WiseView.GetControlByID("scOrddat").value == ""){
		  wherestr += " AND 1=1 ";
		}
		
		wherestr += getMultiRangeDataSQLEzgen('SM.SKUKEY', 'DP.SKUKEY');	//검색조건 제품코드 
		wherestr += getMultiRangeDataSQLEzgen('DK.CLPATH', 'DP.CLPATH');	//검색조건 통로

		//라디오 버튼 값
		if ($('#GRPRL1').prop("checked") == true ) {
			wherestr += " AND DP.DASTYP='01' ";
		}else if ($('#GRPRL2').prop("checked") == true ){
			wherestr += " AND DP.DASTYP='02' ";
		}
		
		var orderbystr = " AND 1=1 ";

		var map = new DataMap();
		var width = 600;
		var heigth = 920;
		map.put("i_option", '\'<%=wareky %>\'');

		WriteEZgenElement("/ezgen/das_picking_list.ezg" , wherestr , orderbystr , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다		
		
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
						<input type="button" CB="Print PRINT BTN_DR16PRT" /> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>  <!--출고일자-->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="ORDDAT" id="ORDDAT" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--통로-->  
							<dt CL="STD_CLPATH"></dt> 
							<dd> 
								<input type="text" class="input" name="DK.CLPATH" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUKEY" UIInput="SR"/> 
							</dd> 
						</dl> 
					<dl>
					<dt CL="STD_DASFILETYP"></dt><!-- DAS FILE 생성 양식 -->
						<dd style="width:300px">
							<input type="radio" name="GRPRL" id="GRPRL1" value="GRPRL1" checked /><label for="GRPRL1">(안산)메인DAS</label>
		        			<input type="radio" name="GRPRL" id="GRPRL2" value="GRPRL2" /><label for="GRPRL2">(안산)이마트</label>
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
				    						<td GH="80 STD_CLPATH" GCol="text,CLPATH" GF="S 8">통로</td>	<!--통로-->
				    						<td GH="80 STD_CELLNO" GCol="text,CELLNO" GF="S 8">셀번호</td>	<!--셀번호-->
				    						<td GH="120 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 180">납품처코드</td>	<!--납품처코드-->
				    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 60">제품코드</td>	<!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
				    						<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 180">납품처명</td>	<!--납품처명-->
				    						<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 180">매출처코드</td>	<!--매출처코드-->
				    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 180">매출처명</td>	<!--매출처명-->
				    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 10,0">납품요청수량</td>	<!--납품요청수량-->
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
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="delete"></button>
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