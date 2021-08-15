function alertMessage() {

	var alert = $('.alertMessage')
		, closer = alert.find('.closer');

	alert.fadeIn(150);

	closer.on({
		click : function() {
			alert.fadeOut(150);
		}
	});
}


var $contentLoading;
// 로딩 열기
function loadingOpen() {
	if($contentLoading.length == 0){
		$contentLoading = $('<div class="contentLoading"></div>');
		jQuery('body').append($contentLoading);
	}

	$contentLoading.show();
}

// 로딩 닫기
function loadingClose() {
	$contentLoading.hide();
}

configData.MENU_ID;
if(commonUtil.checkFn("top.getMenuId")){
	configData.MENU_ID = top.getMenuId();
}else if(commonUtil.checkFn("getMenuId")){
	configData.MENU_ID = getMenuId();
}

commonUtil.consoleMsg(configData.MENU_ID);


var $searchArea;
$(document).ready(function(){
	$(document.body).hide();	

	$contentLoading = jQuery("#contentLoading");
	
	page.loadComponent();

	$searchArea = jQuery("#"+configData.SEARCH_AREA_ID);
	
	$(document.body).show();
});

(function() {
	$(function() {
		$('.tabs').tabs({
			activate: function( event, ui ) {
				/*
				if (Browser.ie){
					$(event.target).find('.table.type2').find('.tableBody').trigger("scroll");
				}
				*/				
			}
		});
	});
})();


//2021.03.23 CMU 사조공통추가

//소숫점 절삭 추가 val = 계산값    type = ceil, floor, round  digit = 소숫점,  
var floating = function(val, type, digit){
	digit = (!digit) ? 0 : digit;
	var digitCal = Number(Math.pow(10, digit));
	return Math[type]((Number(val)*digitCal).toFixed(digit))/digitCal;
}

//소숫점 절삭 추가 val = 계산값    digit = 소숫점 sajo에선 floor만 쓰므로 floor만 사용하는 버전  
var floatingFloor = function(val, digit){
	return floating(val, "floor", digit);
}