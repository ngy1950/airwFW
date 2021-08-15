<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
var data 
	$(document).ready(function(){
	    gridList.setGrid({
			id : "gridHeadList",
	        module : "Outbound", 
			command : "DL31Dialog2_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemSearch : true,
			menuId : "DL31Dialog2"
		});
	    
	    gridList.setGrid({
	        id : "gridItemList",
	        module : "Outbound",
			command : "DL31Dialog2_ITEM",
			pkcol : "OWNRKY,WAREKY",
			emptyMsgType : false,
			menuId : "DL31Dialog2"
	      });
	    
		data = page.getLinkPopData();
		

		
// 		$("#SCCARDAT").val(dateParser(null, "SD", 0, 0, 1));
// 		$("#OWNRKY").val(data.map.OWNRKY);
// 		$("#WAREKY").val(data.map.WAREKY);

 		searchList(data);

	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Search"){
		      searchList();
		}else if(btnName == "Save"){
			save();
		}else if (btnName == "Cancel") {
			this.close();
	    }else if(btnName == "SetAll"){
	        setAll();
	    }else if(btnName == "SetChk"){
	        setChk();
	    }
	}
	
	  //저장성공시 callback
	  function successSaveCallBack(json, status){
	    if (json && json.data) {
	      if (json.data == "OK") {
	        commonUtil.msgBox("SYSTEM_SAVEOK");
//	        searchList();
	      }else{
	        commonUtil.msgBox("SYSTEM_SAVE_ERROR");
	      }
	    }
	  }
	
	//조회
	function searchList(data){
//	    if(validate.check("searchArea")){
	        var param = inputList.setRangeDataParam("searchArea");
	        param.put("OWNRKY", data.get("OWNRKY"));
	        param.put("WAREKY", data.get("WAREKY"));
	        param.put("CARGBN", data.get("CARGBN"));
	        param.put("CARTMP", data.get("CARTMP"));
	        param.put("SHPOKY", data.get("SHPOKY"));
	        gridList.gridList({
	            id : "gridHeadList",
	            param : param
	          });
	        
	        gridList.gridList({
	            id : "gridItemList",
	            param : param
	          });
//	      }
	}	
	
	function saveData(){
		var item = gridList.getGridData("gridItemList");
	          
		if(item.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

			var param = new DataMap();
			param.put("item",item);
			
			netUtil.send({
				url : "/outbound/json/saveDL31Dialog2.data",
				param : param,
				successFunction : "successSaveCallBack"
			});

	}
	
	  //체크적용
	  function setChk(){
	    //인풋값 가져오기
	    var carnumchk = $('#carnumchk').prop("checked");
	    var shipsqchk = $('#shipsqchk').prop("checked");

	    if(!carnumchk && !shipsqchk){
	      commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
	      return;
	    }
	    //수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
	    var list = gridList.getGridData("gridItemList");
//	    var list = gridList.getSelectData("gridItemList");
	    for(var i=0; i<list.length; i++){   
	      if (list[i].get("SHIPSQ") == "0"){
		      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARNUM", $("#CARNUM_ALL").val()); 
		      if(shipsqchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARDAT", $("#CARDAT_ALL").val());  
	      }
	    
	    }
	  }

	  //일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	  function setAll(){
	    
	    var carnumchk = $('#carnumchk').prop("checked");
	    var shipsqchk = $('#shipsqchk').prop("checked");

	    if(!carnumchk && !shipsqchk){
	      commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
	      return;
	    }
	    
//	    gridList.checkAll("gridItemList",true);
//	    alert($("#CARDAT_ALL").val());
	    //수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
	    var list = gridList.getGridData("gridItemList");
//	    var list = gridList.getSelectData("gridItemList");
	    for(var i=0; i<list.length; i++){   
		      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARNUM", $("#CARNUM_ALL").val()); 
		      if(shipsqchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARDAT", $("#CARDAT_ALL").val());  
	    }
	  }	
	  //저장
	  function save(){
	        var head = gridList.getSelectData("gridHeadList");
	        var item = gridList.getGridData("gridItemList");
	          
	    if(item.length == 0){
	      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	      return;
	    }
	    
	    
	    for(var i=0; i<item.length; i++){   
	      
	      var shipsqChk = "";
	      
	      var ownrky = $("#OWNRKY").val();
	      
	      if(ownrky == "2100" || ownrky == "2500"){//사통합 수정
	        
	/*          for(var i=1; i<=carAlc.RowCount; i++){
	          var shipsq = gridList.getColData("gridItemList", i, "SHIPSQ");
	          var carnum = gridList.getColData("gridItemList", i, "CARNUM");
	          if (shipsqChk == "" && parseInt(shipsq) != 0){
	            shipsqChk = shipsq;
	          }
	          else if (shipsqChk != "" && parseInt(shipsqChk) != 0) {
	            if(gridList.getColData("gridItemList", i, "SHIPSQ") != 0 && shipsqChk != shipsq){
	              alert("1개의 차수만 저장가능합니다.");
	              return;
	            }
	          }
	        }
	 */     }   
	    }
	    var param = new DataMap();
	    param.put("head",head);
	    param.put("item",item);

	    netUtil.send({
	      url : "/outbound/json/saveDL34.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	  function gridListEventRowClick(gridId, rowNum, colName){	 
		    var shipsqchk = $('#shipsqchk').prop("checked");
		    
			var headGridId = "gridHeadList"; 
			//차량적용 이벤트 체크한게 있을떄만 작동
			var headList = gridList.getSelectData(headGridId);
			if(headList.length > 0 && (gridId == "gridItemList")){
				var head = gridList.getSelectData(headGridId);
				var headRow = head[0].get("GRowNum");
				var carnum = gridList.getColData(headGridId, headRow, "CARNUM");
				var cardat = $("#CARDAT_ALL").val().replaceAll(".","");

					gridList.setColValue(gridId, rowNum, "CARNUM", carnum);
					gridList.checkGridColor(gridId, rowNum, "CARNUM"); 

				if (shipsqchk){
					gridList.setColValue(gridId, rowNum, "CARDAT", cardat);
					gridList.checkGridColor(gridId, rowNum, "CARDAT"); 
				}
			}
	  }
	  
	  //더블클릭
	   function gridListEventRowDblclick(gridId, rowNum){
		  
	    if(gridId == "gridHeadList"){
	        $("#CARNUM_ALL").val(gridList.getColData("gridHeadList", rowNum, "CARNUM")); 
	          return;
	      } 
	  }
	  
		//체크박스 체크시
		function gridListEventRowCheck(gridId, rowNum, checkType){
			if((gridId == "gridHeadList") && checkType){
				$("#CARNUM_ALL").val(gridList.getColData("gridHeadList", rowNum, "CARNUM")); 
		          return;
			}	
		}
	  
	  
	  
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		  //출고유형
		   if(searchCode == "SHDOCTM" && $inputObj.name == "SHPMTY"){
		        param.put("DOCCAT","200");	   
		    }
		return param;
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
				</div>
				<div class="fl_r">
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<input type="button" CB="Cancel CANCEL BTN_CANCEL" />
				</div>
			</div>			
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">	
				<div class="content_layout tabs content_left" style="width: 430px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" id="aHeader1" onclick="moveTab($(this));"><span id="atab1-1">일반</span></a></li>
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
									<tbody id="gridHeadList">
										<tr CGRow="true">
											<td GH="40" GCol="rowCheck,radio"></td>
											<td GH="40" GCol="rownum">1</td>
											<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>  <!--차량번호-->
											<td GH="100 STD_CARNAME" GCol="text,DESC01" GF="S 30">차량명</td>  <!--차량명-->
											<td GH="75 STD_CARTYP" GCol="text,CARTYP" GF="S 10">차량 톤수</td>  <!--차량 톤수-->
											<td GH="100 STD_CARGBN" GCol="text,CARGBN" GF="S 10">차량 구분</td> <!--차량 구분-->
											<td GH="100 STD_CARTMP" GCol="text,CARTMP" GF="S 10">차량 온도</td> <!--차량 온도-->
											<td GH="72 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td> <!--박스수량-->
											<td GH="50 STD_RT1" GCol="text,RT1" GF="N 20,2">적재율1</td> <!--적재율1-->
											<td GH="85 STD_RT2" GCol="text,RT2" GF="N 20,2">적재율2</td> <!--적재율2-->
											<td GH="90 STD_GRSWGT1" GCol="text,GRSWGT1" GF="N 20,2">무게적재율1</td> <!--무게적재율1-->
											<td GH="50 STD_GRSWGT2" GCol="text,GRSWGT2" GF="N 20,2">무게적재율2</td> <!--무게적재율2-->
											<td GH="72 STD_PLTQTY" GCol="text,PTQTY" GF="N 20,2">팔레트수량</td> <!--팔레트수량-->
											<td GH="50 STD_DPTCNT" GCol="text,DPTCNT" GF="N 20,0">거래처수</td> <!--거래처수-->
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
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>					
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 430px);">
					<ul class="tab tab_style02">
			          <li><a href="#tab1-1" ><span>일반</span></a></li>
			          
			          <li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX">
			            <input type="checkbox" id="carnumchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
			            <span style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;">차량번호</span>
			            <input type="text"   id="CARNUM_ALL" name="CARNUM_ALL"  UIInput="I"  class="input" readonly/>
			            <input type="hidden" id="DESC01_ALL" name="DESC01_ALL"  UIInput="I"  class="input" readonly/>
			          </li>
			          <li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX">
			            <input type="checkbox" id="shipsqchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
			            <span style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;">배송일자</span>
			            <input type="text" class="input" name="CARDAT_ALL" id="CARDAT_ALL" UIFormat="C N"/>
			          </li>
			          <li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> <!-- 일괄적용 -->
			            <input type="button" CB="SetAll SAVE BTN_ALL" /> 
			          </li>
			          <li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
			            <input type="button" CB="SetChk SAVE BTN_PART" />
			          </li>
			          <li class="btn_zoom_wrap">
			            <ul>
			              <li><button class="btn btn_bigger"><span>확대</span></button></li>
			            </ul>
			          </li>
			        </ul>
					<div class="table_box section" id="tab2-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList">
										<tr CGRow="true">
										    <td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 10">출고문서아이템</td>	<!--출고문서아이템-->
				    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
				    						<td GH="80 STD_BIZPART" GCol="text,NAME01" GF="S 180">거래처</td>	<!--거래처-->
				    						<td GH="80 STD_DEPARTURE" GCol="text,DEPART" GF="S 10">출발권역</td>	<!--출발권역-->
				    						<td GH="80 STD_ARRIVA" GCol="text,ARRIVA" GF="S 10">도착권역</td>	<!--도착권역-->
				    						<td GH="80 STD_CARNUM" GCol="input,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
				    						<td GH="80 STD_CARNAME" GCol="text,DESC01" GF="S 20">차량명</td>	<!--차량명-->
				    						<td GH="50 STD_PGRC03" GCol="text,PGRC03" GF="S 10">주문구분</td>	<!--주문구분-->
				    						<td GH="85 STD_CARDAT" GCol="input,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
				    						<td GH="50 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td>	<!--포장중량-->
				    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
				    						<td GH="65 STD_ASKU05" GCol="text,ASKU05" GF="S 30">상온구분</td>	<!--상온구분-->
				    						<td GH="65 STD_D1T" GCol="text,D1T" GF="N 30,2">적재율(1.5T)</td>	<!--적재율(1.5T)-->
				    						<td GH="65 STD_D25T" GCol="text,D25T" GF="N 30,2">적재율(2.5T)</td>	<!--적재율(2.5T)-->
				    						<td GH="65 STD_D35T" GCol="text,D35T" GF="N 30,2">적재율(3.5T)</td>	<!--적재율(3.5T)-->
				    						<td GH="65 STD_D5T" GCol="text,D5T" GF="N 30,2">적재율(5T)</td>	<!--적재율(5T)-->
				    						<td GH="65 STD_D8T" GCol="text,D8T" GF="N 30,2">적재율(8T)</td>	<!--적재율(8T)-->
				    						<td GH="65 STD_D11T" GCol="text,D11T" GF="N 30,2">적재율(11T)</td>	<!--적재율(11T)-->
				    						<td GH="65 STD_D15T" GCol="text,D15T" GF="N 30,2">적재율(15T)</td>	<!--적재율(15T)-->
				    						<td GH="50 STD_PTNG07B" GCol="text,PTNG07" GF="S 20">최대진입가능차량</td>	<!--최대진입가능차량-->
				    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="200 STD_DESC01" GCol="text,SKUDESC" GF="S 120">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_USRID1" GCol="text,USRID1" GF="S 180">배송지우편번호</td>	<!--배송지우편번호-->
				    						<td GH="50 STD_UNAME1" GCol="text,UNAME1" GF="S 180">배송지주소</td>	<!--배송지주소-->
				    						<td GH="80 STD_CARNUM" GCol="text,OCARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="total"></button>
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