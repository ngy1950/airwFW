<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL05</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var selectIdx = "0";
	var selectGrid = "gridList1";
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL05_01",
		    menuId : "RL05"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Report",
			command : "RL05_02",
		    menuId : "RL05"
	    });
		
		gridList.setReadOnly("gridList1", true, ["WAREKY" , "OWNRKY", "C00102", "CARTYP", "CARGBN", "CARTMP", "CARTYP"]);
		gridList.setReadOnly("gridList2", true, ["WAREKY" , "OWNRKY", "C00102", "CARTYP", "CARGBN", "CARTMP", "CARTYP"]);
		
		//aria-selected="true"
		//body > div.content_wrap > div > div.search_next_wrap.searchRow2 > div > ul > li.ui-state-default.ui-corner-top.ui-tabs-active.ui-state-active
		var tabs = $("#tabs > li.ui-corner-top");
		tabs.click(function(event){
			var idx = tabs.index(this);
			selectIdx = idx;
			searchList();
		});
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			
			//aria-selected="true"
			switch (selectIdx){
				case 0:
					selectGrid = "gridList1";
					break;
				case 1:
					selectGrid = "gridList2";
					break;
			}
			gridList.resetGrid(selectGrid);
			gridList.gridList({
		    	id : selectGrid,
		    	param : param
		    });
			 
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if (btnName == "Print") {		/* 상차리스트인쇄 */
			Print();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL05");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL05");
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
	
	function Print(){  /* 거래처별피킹호차 */
		
		if(gridList.validationCheck("gridList1", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridList1", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var count = 0;
			var wherestr = "";   
			var orddat = "";
			var carnum = "";
			var option = "";
			var orderbystr = "";
			//var c00102 = $("#C00102 option:selected").val();
			var rangeOrddat = inputList.getRangeData("VW.ORDDAT", configData.INPUT_RANGE_TYPE_RANGE);
			var minOrddat = rangeOrddat[0].get("FROM");
			
			wherestr = wherestr+" AND VW.CARNUM IN (";
			for(var i =0;i < head.length ; i++){
				if(carnum.length > 2){ 
					carnum += ",";
				}
				carnum += "'" + head[i].get("CARNUM") + "'";
				count++;
			}
			wherestr = wherestr + carnum ;
			wherestr += ")";
			
			//var orddat = $("#orddat").val();
			wherestr +=" AND VW.ORDDAT = '"+minOrddat+"' ";
			
			
			var c00102 = $("#C00102 option:selected").val();
			if(c00102 == "ALL"){
				wherestr += " AND 1=1 ";
				orderbystr = "'ALL'";
			}else if(c00102 == "B"){
				wherestr += " AND VW.C00102 = 'X' ";
				orderbystr = "'접수'";
			}else if(c00102 == "C"){
			    wherestr += " AND VW.C00102 = 'N' ";
				orderbystr = "'확정'";
			}else if(c00102 == "D"){
			    wherestr += " AND VW.C00102 = 'Y' AND VW.QTSHPD = 0 ";
				orderbystr = "'출고지시'";
			}else if(c00102 == "E"){
			    wherestr += " AND VW.C00102 = 'Y' AND VW.QTSHPD > 0 ";
				orderbystr = "'출고완료'";
			}
			var wareky = <%=wareky %>;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);
			if(count > 0){
				WriteEZgenElement("/ezgen/upload_car_dr.ezg" , wherestr , " " , langKy, map , width , heigth );
			}
		}
	}
	
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
        }
        
    	return param;
    }
	
	//로우 더블클릭
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridList1"){
			
			//var data = gridList.getRowData(selectGrid, rowNum);
			//var data = inputList.setRangeParam("searchArea");
			var data = new DataMap();
			
			var ownrky = gridList.getColData(selectGrid, rowNum, "OWNRKY");
			var wareky = gridList.getColData(selectGrid, rowNum, "WAREKY");
			var orddat = gridList.getColData(selectGrid, rowNum, "ORDDAT");
			var carnum = gridList.getColData(selectGrid, rowNum, "CARNUM");
			var desc01 = gridList.getColData(selectGrid, rowNum, "DESC01");
			var c00102 = $("#C00102 option:selected").val();
			
			data.put("OWNRKY",ownrky);
			data.put("WAREKY",wareky);
			data.put("ORDDAT",orddat);
			data.put("CARNUM",carnum);
			data.put("C00102",c00102);
			
			var option = "height=800,width=1000,resizable=yes,help=no,status=no,scroll=no";
			page.linkPopOpen("/wms/report/pop/DRcar.page", data, option);
			
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print PRINT_OUT BTN_LDPRINT" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
		            <dl>
		              <dt CL="STD_OWNRKY"></dt>
		              <dd>
		                <select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            <dl>
		              <dt CL="STD_WAREKY"></dt>
		              <dd>
		                <select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" id="ORDDAT" name="VW.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송코스-->  
						<dt CL="STD_DRCARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="VW.CARNUM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송코스명-->  
						<dt CL="STD_DRCARNAME"></dt> 
						<dd> 
							<input type="text" class="input" name="VW.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고지시여부-->  
						<dt CL="출고지시여부"></dt> 
						<dd> 
							<select name="C00102" id="C00102" class="input" CommonCombo="C00102_DR"></select> 
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
				<ul class="tab tab_style02" id="tabs">
					<li><a href="#tab1-1"><span>일자별</span></a></li>
					<li><a href="#tab1-2"><span>합계</span></a></li>
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
								<tbody id="gridList1">
									<tr CGRow="true">     
										<td GH="40" GCol="rowCheck"></td>                    
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 key" GCol="text,KEY" GF="S 20">key</td>	<!--key-->
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 20">출고일자</td>	<!--출고일자-->
										<td GH="80 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
											<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
										</td>
			    						<td GH="80 STD_WAREKY" GCol="select,WAREKY"><!--거점-->
											<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false"></select>
			    						</td>	
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td>	<!--배송코스-->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!--차량 톤수-->
			    							<select class="input" commonCombo="CARTYP"></select>
										</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN"><!--차량 구분-->
			    							<select class="input" commonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP" >	<!--차량 온도-->
											<select class="input" commonCombo="CARTMP"></select>
										</td>
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0">총수량</td>	<!--총수량-->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량 -->
			    						<td GH="90 총중량(kg)" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 차이중량(kg)" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList2">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 STD_OWNRKY" GCol="select,OWNRKY"><!--화주-->
											<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
										</td>
			    						<td GH="80 STD_WAREKY" GCol="select,WAREKY"><!--거점-->
											<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false"></select>
			    						</td>	
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20">배송코스</td>	<!--배송코스-->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td>	<!--기사명-->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!--차량 톤수-->
			    							<select class="input" commonCombo="CARTYP"></select>
										</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN"><!--차량 구분-->
			    							<select class="input" commonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP" >	<!--차량 온도-->
											<select class="input" commonCombo="CARTMP"></select>
										</td>
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0">총수량</td>	<!--총수량-->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량 -->
			    						<td GH="90 총중량(kg)" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 차이중량(kg)" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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