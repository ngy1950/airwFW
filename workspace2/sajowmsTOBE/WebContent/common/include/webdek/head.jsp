<%@ page import="project.common.bean.*,project.common.util.*,java.util.*"%>
<%
	DataMap paramDataMap = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	if(paramDataMap == null){
		paramDataMap = new DataMap(request);
	}
	String menuId = paramDataMap.getString(CommonConfig.MENU_ID_KEY);

	String userid = (String)request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	String username = (String)request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY); 
	
	String wareky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY);
	
	
	String warekynm = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY);
	String compky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
	String deptid = (String)request.getSession().getAttribute(CommonConfig.SES_DEPT_ID_KEY);
	String menukey = (String)request.getSession().getAttribute(CommonConfig.SES_MENU_GROUP_KEY);
	String langky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
	
	DataMap userInfo = (DataMap)request.getSession().getAttribute(CommonConfig.SES_USER_INFO_KEY);
	
	ArrayList usrloList = (ArrayList)request.getAttribute(CommonConfig.SES_USER_LAYOUT_LIST_KEY);
	ArrayList usrphList = (ArrayList)request.getAttribute(CommonConfig.SES_USER_SEARCHPARAM_LIST_KEY);
	ArrayList usrpiList = (ArrayList)request.getAttribute(CommonConfig.SES_USER_SEARCHPARAM_DEFAULT_KEY);
	
	String theme =(String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY);
	
	String ownrky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_OWNER_KEY);
	String urolky = (String)request.getSession().getAttribute(CommonConfig.SESSION_KEY_OWNER_MANAGE);
	
	//운영/개발구분 2021.05.10 cmu
	String divReal = (String)request.getSession().getAttribute(CommonConfig.DIV_REAL_TEST);
	
	Map headRow;
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/layout_green.css"/>
<!-- link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/layout.css"/-->
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/content_ui.css">
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/multiple-select.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.custom.js"></script>
<%
	if(langky != null && (langky.equals("CN") || langky.equals("ZH"))){
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-zh-CN.js"></script>
<%
	}else if(langky != null && langky.equals("EN")){
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-en-GB.js"></script>
<%
	}else{
%>
<script type="text/javascript" src="/common/js/datepicker/jquery.ui.datepicker-ko.js"></script>
<%
	}
%>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>
<script type="text/javascript" src="/common/js/jquery.form.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/jquery.mousewheel.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.monthpicker.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.timepicker.js"></script>
<script type="text/javascript" src="/common/js/multiple-select.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/big.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common<%=theme%>/js/theme.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/dataRequest.js"></script>
<script type="text/javascript" src="/common/js/grid.js?v=1.1"></script>
<script type="text/javascript" src="/common/js/layoutSave.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script> 
<script type="text/javascript" src="/common/js/sajoUtil.js?v=<%=System.currentTimeMillis()%>"></script>

<script>

var hdUrolky = "<%=urolky %>";

<%
	if(usrloList != null && usrloList.size() > 0){
		for(int i=0;i<usrloList.size();i++){
			headRow = (Map)usrloList.get(i);
%>
	gridList.gridLayOutMap.put('<%=headRow.get("COMPID")%> <%=headRow.get("LYOTID")%>','<%=headRow.get("LAYDAT")%>');
<%
		}
	}
%>

<%
	if(usrphList != null && usrphList.size() > 0){
		for(int i=0;i<usrphList.size();i++){
			headRow = (Map)usrphList.get(i);
%>
	
	inputList.addUserParamList('<%=headRow.get("PARMKY")%>','<%=headRow.get("SHORTX")%>');
<%
		}
	}
%>

<%
	if(usrpiList != null && usrpiList.size() > 0){
		for(int i=0;i<usrpiList.size();i++){
			headRow = (Map)usrpiList.get(i);
%>
	inputList.addUserParamMap('<%=headRow.get("CTRLID")%>','<%=headRow.get("CTRVAL")%>');
<%
	}
}
%>


$(document).ready(function(){
	if($("#topFrame",window.top.document).length >= 1){
		var wh = $(window.top).height();
		var ww = $(window.top).width();
		
		var bgDiv = "<div class='bgDiv' style='height:"+wh+"px;width:"+ww+"px;position:fixed; z-index:-1;background-size: cover; background-color:#A2CBA1;'></div>";
// 		var bgDiv = "<div class='bgDiv' style='height:"+wh+"px;width:"+ww+"px;position:fixed; z-index:-1;background:url(/common/theme/webdek/images/web_bg.png) repeat center center; background-size: cover;'></div>";
		
		var ph = $(window).height();
		var pw = $(window).width();
		$('body').append(bgDiv);
		$(".bgDiv").css({top : -120 + "px", left : pw - ww + "px"});
	}else{
		<%
	if(compky != null){
		if(compky.equals("GCCL")){
		%>
		$("body").css({backgroundColor:"#d5ecec"});
		<%
			}else{
		%>
		$("body").css({backgroundColor:"#b0dfff"});
		<%
			}
	}
		%>
	}
});

$(window).resize(function(){
	if($(".bgDiv").length >= 1){
		var wh = $(window.top).height();
		var ww = $(window.top).width();
		var ph = $(window).height();
		var pw = $(window).width();
//			2021.06.02 화면 전체 펼치기 버튼 수정 
//  		$(".bgDiv").css({top : -120 + "px", left : pw - ww + "px", width: ww+"px", height:wh+"px"}); 
		$(".bgDiv").css({ left : pw - ww + "px", width: ww+"px", height:wh+"px"});
	}
});



/***********************************************************************************************************************************************************************/
// 2020.10.11 CMU 공통 스크립트 추가 
// 
/***********************************************************************************************************************************************************************/

var pageLinkDataMap;

//공통 화주 - 거점 컨트롤 
$(window).load(function(){
	 
	var ownrky = '<%=ownrky %>';
	var wareky = '<%=wareky %>';
	//페이지 링크로 OWNRKY를 가져올 경우
	if(pageLinkDataMap && pageLinkDataMap.get("OWNRKY") && pageLinkDataMap.get("OWNRKY") != null && pageLinkDataMap.get("OWNRKY") != "")
		ownrky = pageLinkDataMap.get("OWNRKY");

	//페이지 링크로 WAREKY를 가져올 경우
	if(pageLinkDataMap && pageLinkDataMap.get("WAREKY") && pageLinkDataMap.get("WAREKY") != null && pageLinkDataMap.get("WAREKY") != "")
		wareky = pageLinkDataMap.get("WAREKY");

	if($("#OWNRKY")){ // OWNRKY가 존재할 시
		var inputText = ""+$('#OWNRKY').prop('type');
		if(inputText.indexOf('select') == -1) return;  //#OWNRKY 타입이 select combo 가 아니라면 미작동 
		$("#OWNRKY").val(ownrky);
	}
	
	if($("#WAREKY")){ // WAREKY가 존재할 시 
		var inputText = ""+$('#WAREKY').prop('type');
	
		if(inputText.indexOf('select') == -1) return;  //#WAREKY 타입이 select combo 가 아니라면 미작동 
		
		if($("#OWNRKY")){ // OWNRKY 콤보 존재 
			$("#OWNRKY").on("change",function(){
				var param = new DataMap();
				param.put("OWNRKY",$(this).val());
				
				var json = netUtil.sendData({
					module : "SajoCommon",
					command : "WAREKY_COMCOMBO",
					sendType : "list",
					param : param
				}); 
				
				$("#WAREKY").find("[UIOption]").remove();
				
				var optionHtml = inputList.selectHtml(json.data, false);
				$("#WAREKY").append(optionHtml);
				
				var cnt = json.data.filter(function(element,index,array){
					return (element.VALUE_COL == wareky);
				});
				
				if(cnt.length == 0){
					$("#WAREKY option:eq(0)").prop("selected",true); 
				}else{
					$("#WAREKY").val(wareky);	
				}
				
			});
			
			$("#OWNRKY").trigger('change');
		}else{ // OWNRKY 미존재 시 세션값을 가져온다.
			var param = new DataMap();
			param.put("OWNRKY",ownrky);
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKY_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WAREKY").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, false);
			$("#WAREKY").append(optionHtml);
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == wareky);
			});
			
			if(cnt.length == 0){
				$("#WAREKY option:eq(0)").prop("selected",true); 
			}else{
				$("#WAREKY").val(wareky);	
			}
		}
	}
});

//Date function 확장 
Date.prototype.yyyymmdd = function() {
	var mm = this.getMonth() + 1; // getMonth() is zero-based
	var dd = this.getDate();
	return [this.getFullYear(),	(mm>9 ? '' : '0') + mm, (dd>9 ? '' : '0') + dd].join('');
};

//Date function 확장2
Date.prototype.yyyymmdd2 = function() {
	var mm = this.getMonth() + 1; // getMonth() is zero-based
	var dd = this.getDate();
	return [this.getFullYear(),	(mm>9 ? '' : '0') + mm, (dd>9 ? '' : '0') + dd].join('.');
};

//소숫점 절삭 추가 val = 계산값    type = ceil, floor, round  digit = 소숫점,  
var floating = function(val, type, digit){
	digit = (!digit) ? 0 : digit;
	var digitCal = Number(Math.pow(10, digit));
	if(digit > 0 ){
		return Math[type]((Number(val)*digitCal).toFixed(digit))/digitCal;	
	}else{
		return Math[type]((Number)(val));
	}
}

//소숫점 절삭 추가 val = 계산값    digit = 소숫점 sajo에선 floor만 쓰므로 floor만 사용하는 버전  
var floatingFloor = function(val, digit){
	return floating(val, "floor", digit);
}

//싱글 range데이터 뽑아오기
function getSingleRangeData(rangeNm){
	var list = new Array();
	var rangeInput = inputList.rangeMap.map[rangeNm];
	
	for(var i=0; i< rangeInput.singleData.length; i++){
		list.push(rangeInput.singleData[i].map.DATA);
	}
	return list;
}

//멀티 range데이터 뽑아오기
function getMultiRangeData(rangeNm){
	var map = new DataMap();
	var multiMap = new DataMap();
	var singleList = new Array();
	var multiList = new Array();
	var rangeInput = inputList.rangeMap.map[rangeNm];
	
	for(var i=0; i< rangeInput.singleData.length; i++){
		singleList.push(rangeInput.singleData[i].map.DATA);
	}
	map.put("singleList",singleList);
	
	for(var i=0; i< rangeInput.rangeData.length; i++){
		multiMap.put("FROM",rangeInput.rangeData[i].map.FROM)
		multiMap.put("TO",rangeInput.rangeData[i].map.TO)
		multiList.push(multiMap);
	}
	map.put("multiList",multiList);
	
	return map;
}

function strToDate(str){
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    return new Date(y, m-1, d);
}

//날짜 파싱 ('yyyymmdd', type(D(Date), S(String)), chnage Y, change M, change D)
function dateParser(str, type, cy, cm, cd) {
	var date;
	
	if(str){
		date = strToDate(str);
	}else{
		date = new Date();
	}

    cy = cy ? cy : 0;
    cm = cm ? cm : 0;
    cd = cd ? cd : 0;
    type = type ? type : 'S';
    
    //년월일 변경 있으면 적용
    //년
    if(cy != 0) date = new Date(date.setFullYear(date.getFullYear() + cy));
    
    //월
    if(cm != 0) date = new Date(date.setMonth(date.getMonth() + cm));

    //일
	if(cd != 0) date = new Date(date.setDate(date.getDate() + cd));
    
    if(type ==  'S'){ //일반 날짜 YYYYMMDD
    	return date.yyyymmdd();
    }else if(type ==  'SD'){//캘린더 날짜 YYYY.MM.DD
    	return date.yyyymmdd2();
    }else if(type ==  'D'){//데이트
    	date;
    }
    
    return date;
}

//focus잡힌 그리드 데이터 list로 반환
function getfocusGridDataList(gridId){

	//현제 포커스로우 가져오기
	var headGridBox = gridList.getGridBox(gridId);
	//현재 view중인 rownum 가져오기 조회 초기에는 -1이 들어있다.
	var headRownum = (gridList.getSearchRowNum(gridId) < 0) ? 0 : gridList.getSearchRowNum(gridId);
	//list 타입으로 넣어야만하므로 list에 밀어넣는다
	var list = new Array();
	list.push(headGridBox.getRowData(headRownum));
	
	return list;
}

//그리드 중복 row체크  (조회된 그리드 리스트에서 지정한 컬럼이 중복된 row를 찾는다.) chkOption (A 모든 데이터, S 체크한 데이터, M 수정데이터, SM 체크한ROW중 수정된 데이터만)
function checkGridColValueDuple(gridId, colArr, chkOption){

	var tmpRowNum;
	var chkRowCount = 0;//자기자신 제외 
	var map = new DataMap();
	var colStr = '';
	var list = gridList.getGridBox(gridId).getDataAll();
	var modify = gridList.getGridBox(gridId).modifyRow.map;
	var select = gridList.getGridBox(gridId).selectRow.map;
	
	chkOption = !chkOption ? 'A' : chkOption;
	
	//데이터가 많으면 오래걸리니 로딩 추가
	commonUtil.displayLoading(true);
	
	//그리드 리스트의 길이만큼 반복문을 돌린다.
	for(var i=0; i<list.length; i++){
		chkRowCount = 0;

		//i번쨰 리스트에 배열에 지정한 컬럼들을 값을 맵에 셋팅한다.  
		for(var j=0; j<colArr.length; j++){
			
			//메시지로 보여줄 값 세팅
			if(i==0) colStr =colStr+colArr[j]+",";
			
			map.put(colArr[j], gridList.getColData(gridId, list[i].get("GRowNum"), colArr[j]));
		}
		
		//삭제인 데이터를 거른다.
		if(list[i].get("GRowState") == configData.GRID_ROW_STATE_DELETE) continue;
		
		//수정일 경우 수정된 row가 아니면 continue
		if(chkOption == 'M' && !modify[list[i].get("GRowNum")]) continue;
		
		//선택된 데이터가 아니면 continue
		if(chkOption == 'S' && !select[list[i].get("GRowNum")]) continue;

		//선택 + 수정된 데이터가 아니면 continue
		if(chkOption == 'SM' && (!select[list[i].get("GRowNum")] && !modify[list[i].get("GRowNum")])) continue;

		//i행째 리스트의 데이터와 전체 리스트의 데이터를 비교한다.
		for(var j=0; j<list.length; j++){
			chkColCount = 0;

			//삭제인 데이터를 거른다.
			if(list[j].get("GRowState") == configData.GRID_ROW_STATE_DELETE) continue;
			
			//수정일 경우 수정된 row가 아니면 continue
			if(chkOption == 'M' && !modify[list[j].get("GRowNum")]) continue;
			
			//선택된 데이터가 아니면 continue
			if(chkOption == 'S' && !select[list[j].get("GRowNum")]) continue;

			//선택 + 수정된 데이터가 아니면 continue
			if(chkOption == 'SM' && (!select[list[j].get("GRowNum")] && !modify[list[j].get("GRowNum")])) continue;
			
			//데이터의 중복을 확인한다. 
			for(var k=0; k<colArr.length; k++){
				
				//일치여부 체크 
				if(gridList.getColData(gridId, list[j].get("GRowNum"), colArr[k]) == map.get(colArr[k]))
					chkColCount++;
			}
			
			//배열에 모든 컬럼이 중복되었을 경우 
			if(chkColCount >= colArr.length){
				chkRowCount++;
			}

			//중복 validation 처리
			if(chkRowCount > 1){
				commonUtil.msgBox("VALID_DUPLEMULIT",colStr);
				setTimeout(function(){
					gridList.setColFocus(gridId, list[j].get("GRowNum"), colArr[0]);
					}, 100);

				//데이터가 많으면 오래걸리니 로딩 추가
				commonUtil.displayLoading(false);
				return false;
			}
		}
		
	}

	//데이터가 많으면 오래걸리니 로딩 추가
	commonUtil.displayLoading(false);
	
	return true;
}


//텍스트 파일 다운로드  
function textFileDownload(fileName, data, formNm){
	
	formNm = (!formNm) ? 'textFileForm' : formNm;

	jQuery("#"+formNm).remove();
	// 비동기 전달을 위해 전달에 필요한 파라메터에 각 값들은 jsonString형태로 전송한다.
	var formHtml = "<form action='/common/fileDown/textFile/textFileDown.data' method='post' id='"+formNm+"'>"
				 + "<input type='text' name='fileName' value=\""+fileName+"\" />"
				 + "<input type='text' name='data' value=\""+data+"\" />"
				 + "</form>";
	jQuery(formHtml).hide().appendTo('body');
	jQuery("#"+formNm).submit();	
}


//텍스트 파일 다운로드  팝업형
function textFileDownloadPop(fileName, data, formNm){

	formNm = (!formNm) ? 'textFileForm' : formNm;

	jQuery("#"+formNm).remove();
	// 비동기 전달을 위해 전달에 필요한 파라메터에 각 값들은 jsonString형태로 전송한다.
	var formHtml = "<form action='/common/fileDown/textFile/textFileDown.data' method='post' id='"+formNm+"'>"
				 + "<input type='text' name='fileName' value=\""+fileName+"\" />"
				 //+ "<input type='text' name='data' value=\""+data+"\" />"
				 + "<textarea name='data'>"+data+"</textarea>"
				 + "</form>";
	jQuery(formHtml).hide().appendTo('body');

	$('#'+formNm).attr("target", formNm+"Pop");
    window.open("", formNm+"Pop", "height=500, width=900, menubar=no, scrollbars=yes, resizable=no, toolbar=no, status=no, left=50, top=50");
    $('#'+formNm).submit();    

	//jQuery("#textFileForm").submit();	
}

//서치헬프에 값 넣기(Single Range전용)
function setSingleRangeData(rangeNm, dataArr){
	var operMap = new DataMap();
	operMap.put("=","E");
	operMap.put("!=","N");
	operMap.put("<","LT");
	operMap.put(">","GT");
	operMap.put("<=","LE");
	operMap.put(">=","GE");
	

	var $rangeObj = inputList.rangeMap.get(rangeNm);
	
	if($rangeObj){
		inputList.rangeMap.map[rangeNm].singleData = new Array();
		for(var i=0; i < dataArr.length; i++){
			var dataMap = dataArr[i];
			var rangeDataMap = new DataMap();
			
			//넘어온 값 세팅
			rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dataMap.get(configData.INPUT_RANGE_SINGLE_DATA));
			rangeDataMap.put(configData.INPUT_RANGE_OPERATOR, operMap.get(dataMap.get(configData.INPUT_RANGE_OPERATOR)));
			var logical = (!dataMap.get(configData.INPUT_RANGE_LOGICAL)) ? "OR" : dataMap.get(configData.INPUT_RANGE_LOGICAL);
			rangeDataMap.put(configData.INPUT_RANGE_LOGICAL, logical);
	
			//값이 여러개면 or and 등 조건 추가
			if(dataArr.length > 1){
				rangeDataMap.put(configData.GRID_ROW_NUM, i);
				rangeDataMap.put(configData.GRID_ROW_STATE_ATT, "C");//고정?
			}
			
			inputList.rangeMap.map[rangeNm].singleData.push(rangeDataMap);
		}
		//적용(보이는부분)
		inputList.rangeMap.get(rangeNm).setMultiData(false);
	}
}


//레인지 데이터를  생성하여 Array(Map)으로 반환
function returnSingleRangeDataArr(dataArr){
	var operMap = new DataMap();
	var rtnArr = new Array();
	operMap.put("=","E");
	operMap.put("!=","N");
	operMap.put("<","LT");
	operMap.put(">","GT");
	operMap.put("<=","LE");
	operMap.put(">=","GE");
	
	for(var i=0; i < dataArr.length; i++){
		var dataMap = dataArr[i];
		var rangeDataMap = new DataMap();
		
		//넘어온 값 세팅
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dataMap.get(configData.INPUT_RANGE_SINGLE_DATA));
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR, operMap.get(dataMap.get(configData.INPUT_RANGE_OPERATOR)));
		var logical = (!dataMap.get(configData.INPUT_RANGE_LOGICAL)) ? "OR" : dataMap.get(configData.INPUT_RANGE_LOGICAL);
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL, logical);

		//값이 여러개면 or and 등 조건 추가
		if(dataArr.length > 1){
			rangeDataMap.put(configData.GRID_ROW_NUM, i);
			rangeDataMap.put(configData.GRID_ROW_STATE_ATT, "C");//고정?
		}
		
		rtnArr.push(rangeDataMap);
	}
	//적용(보이는부분)
	return rtnArr;
}



//멀티 range데이터 뽑아서 SQL로 만들기
function getMultiRangeDataSQL(rangeNm, aliasNm){
	var sqlStr = "";
	var rangeInput = inputList.rangeMap.map[rangeNm];

	var operMap = new DataMap();
	operMap.put("E", "=");
	operMap.put("N", "!=");
	operMap.put("LT", "<");
	operMap.put("GT", ">");
	operMap.put("LE", "<=");
	operMap.put("GE", ">=");
	
	aliasNm = (!aliasNm) ?  rangeNm : aliasNm;
	
	sqlStr += " AND ( "
	//싱글 레인지
	if(rangeInput.singleData.length > 0){
		for(var i=0; i< rangeInput.singleData.length; i++){
			
			if(i != 0) sqlStr += " "+rangeInput.singleData[i].map.LOGICAL+" ";
			
			if(rangeInput.singleData[i].map.DATA.indexOf("%") != -1){//like 사용시 
				if(rangeInput.singleData[i].map.OPER == 'N'){ //NOT LIKE
					sqlStr += " ( "+aliasNm + " NOT LIKE '" + rangeInput.singleData[i].map.DATA + "' ) ";
				}else{ //like

					sqlStr += " ( "+aliasNm + " LIKE '" + rangeInput.singleData[i].map.DATA + "' ) ";
				}
			}else{//like 미사용
				sqlStr += " ( "+aliasNm + " " + operMap.get(rangeInput.singleData[i].map.OPER) + " '" + rangeInput.singleData[i].map.DATA + "' ) ";
			}
		}
	}else if(rangeInput.rangeData.length > 0){ //멀티 레인지
		for(var i=0; i< rangeInput.rangeData.length; i++){

			if(i != 0) sqlStr += " AND ";
			
			//FROM TO 형태는 LIKE 사용 불가
			if(rangeInput.rangeData[i].map.OPER == 'N'){ //><
				//FROM 
				sqlStr += " ( "+aliasNm + " > '" + rangeInput.rangeData[i].map.FROM + "' AND ";
				//TO
				sqlStr += aliasNm + " < '" + rangeInput.rangeData[i].map.TO + "' )";
			}else{ // >= <=
				//FROM 
				sqlStr += " ( "+aliasNm + " >= '" + rangeInput.rangeData[i].map.FROM + "' AND ";
				//TO
				sqlStr += aliasNm + " <= '" + rangeInput.rangeData[i].map.TO + "' )";
			}
		}
		
	}else{
		return "";
	}

	sqlStr += " ) "
	
	return sqlStr;
}


//멀티 range데이터 뽑아서 SQL로 만들기 Ezgen용
function getMultiRangeDataSQLEzgen(rangeNm, aliasNm){
	var sqlStr = "";
	var rangeInput = inputList.rangeMap.map[rangeNm];

	var operMap = new DataMap();
	operMap.put("E", "=");
//	operMap.put("LT", "<");
//	operMap.put("GT", ">");
//	operMap.put("LE", "<=");
//	operMap.put("GE", ">=");
	//operMap 강제수정 ezgen은 > < 태그 못보냄
	operMap.put("LT", "=");  
	operMap.put("GT", "=");  
	operMap.put("LE", "="); 
	operMap.put("GE", "="); 
	
	aliasNm = (!aliasNm) ?  rangeNm : aliasNm;
	
	if(!rangeInput) return;
	
	sqlStr += " AND ( "
	//싱글 레인지
	if(rangeInput.singleData.length > 0){
		for(var i=0; i< rangeInput.singleData.length; i++){
			
			if(i != 0) sqlStr += " "+rangeInput.singleData[i].map.LOGICAL+" ";
			
			if(rangeInput.singleData[i].map.DATA.indexOf("%") != -1){//like 사용시 
				if(rangeInput.singleData[i].map.OPER == 'N'){ //NOT LIKE
					sqlStr += " ( "+aliasNm + " NOT LIKE '" + rangeInput.singleData[i].map.DATA + "' ) ";
				}else{ //like

					sqlStr += " ( "+aliasNm + " LIKE '" + rangeInput.singleData[i].map.DATA + "' ) ";
				}
			}else{//like 미사용
				sqlStr += " ( "+aliasNm + " " + operMap.get(rangeInput.singleData[i].map.OPER) + " '" + rangeInput.singleData[i].map.DATA + "' ) ";
			}
		}
	}else if(rangeInput.rangeData.length > 0){ //멀티 레인지
		for(var i=0; i< rangeInput.rangeData.length; i++){

			if(i != 0) sqlStr += " AND ";
			
			//FROM TO 형태는 LIKE 사용 불가 ezgen용은 between 고정 
			sqlStr += " ( "+aliasNm + " BETWEEN '" + rangeInput.rangeData[i].map.FROM + "' AND ";
			//TO
			sqlStr += " '" + rangeInput.rangeData[i].map.TO + "' )";
		}
		
	}else{
		return "";
	}

	sqlStr += " ) "
	
	return sqlStr;
}

//특수문자 제거 
function regExp(str){  
	var reg = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
    return str.replace(reg, "");   
}

//replaceAll prototype 선언 replaceAll
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

//대문자 변환 싱글레인지 전용
function chageRangeValueSR($obj){
	var objNm = $obj.attr("name");

	var rangeInput = inputList.rangeMap.map[objNm];
	
	for(var i=0; i< rangeInput.singleData.length; i++){
		var data = rangeInput.singleData[i].map.DATA;
		rangeInput.singleData[i].map.DATA = data.toUpperCase();
	}
	inputList.rangeMap.map[objNm].valueChange();
}


function inputListEventRangeDataChange(objNm, singleData, rangeData){
	if(singleData.length > 0){
		var nonUpper = inputList.rangeMap.map[objNm].$obj.attr("nonUpper");
		var rangeInput = inputList.rangeMap.map[objNm];
		
		if(nonUpper && nonUpper == 'Y'){
			//upper없을때만 적용 
		}else{
			for(var i=0; i< rangeInput.singleData.length; i++){
	
				var data = rangeInput.singleData[i].map.DATA;
				rangeInput.singleData[i].map.DATA = data.toUpperCase();
			}
	
			if(rangeInput.singleData.length == 1){  
				inputList.rangeMap["map"][objNm].$from.val(rangeInput.singleData[0].map.DATA);
			}
			//inputList.rangeMap.map[objNm].valueChange();
		}
	}
}

function setVarriantDef(){
	var varriMap = new DataMap();
	varriMap.put("USERID", '<%=userid%>');
	varriMap.put("PROGID", '<%=menuId%>');
	varriMap.put("DEFCHK", 'V');
	sajoUtil.setDefVariant("searchArea" ,varriMap); //팝업 데이터 적용
	
}
  
function getRangeFrTo(objId){ 
	var rtnMap = new DataMap();
	var $obj = inputList.rangeMap.get(objId);
	if($obj && $obj.formatAtt &&  $obj.formatAtt.indexOf("C") != -1){  
		if($obj.singleData.length > 0 ){   
			rtnMap.put("FROM", $obj.singleData[0].map.DATA);
		}else if($obj.rangeData.length > 0 ){ 
			rtnMap.put("FROM", $obj.rangeData[0].map.FROM); 
			rtnMap.put("TO", $obj.rangeData[0].map.TO); 
		} 
	}
	return rtnMap;
}
/***********************************************************************************************************************************************************************/
</script>
<script type="text/javascript" src="/common<%=theme%>/js/head.js"></script>