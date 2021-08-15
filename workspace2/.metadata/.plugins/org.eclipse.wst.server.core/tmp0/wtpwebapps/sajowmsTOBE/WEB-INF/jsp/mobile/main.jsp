<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0" />
	<%@ include file="/mobile/include/mobile_head.jsp" %>
	<script type="text/javascript">
		$(function(){
			$("#all").click(function(){
				if ($("#all").prop("checked")){
					$("input[type=checkbox]").prop("checked",true);
				}else {
					$("input[type=checkbox]").prop("checked",false);
				}
			})
			
			$('.submenu_all').click(function(){
				$('.mobile_submenu').animate({left:0},400); 
			});
			$('.mobile_submenu_close').click(function(){
				$('.mobile_submenu').animate({left:'-100%'},400);
			});
		});
	</script>
</head>
<body>
	<%@ include file="/mobile/include/msubmenu.jsp" %>
	<div class="mobile_wrap">
		<div class="mbile_header">
			<button class="mobile-home submenu_all"><img src="/mobile/images/mobile-menu.png"></button>
			<input type="checkbox" id="all"><label for="all">전체메뉴</label>
		</div>
		<div class="mobile_menuinner">
			<div class="mobile_menubox mobile_menubox1">
				<input type="checkbox" id="button1" checked>
<!-- 				<label class="mainmeun" for="button1">빠른 서비스 <span></span></label>
				<p class="mobile_meun_button mobile_meun_button1">
<!-- 					<button onClick="location.href='/mobile/morder.page'">퀵서비스</button> -->
<!-- 					<button onClick="location.href='/mobile/morder_cargo.page'">화물운송</button> -->
<!-- 					<button onClick="location.href='/mobile/morder_cycle.page'">자전거</button> -->
<!-- 					<button onClick="location.href='/mobile/morder_subway.page'">지하철</button> -->
<!-- 				</p> -->
				<div id="mainMenu">
					<!-- <input type="checkbox" id="button2">
					<label class="mainmeun" for="button2">입고 <span></span></label>
					<p class="mobile_meun_button mobile_meun_button2">
						<button onClick="location.href='/mobile/MGR00.page'">생산입고</button>
						<button onClick="location.href='/mobile/MGR01.page'">ASN입고</button>
						<button onClick="location.href='/mobile/MGR02.page'">구매입고</button>
						<button onClick="location.href='/mobile/MGR03.page'">이고입고</button>
						<button onClick="location.href='/mobile/MGR04.page'">매출반품입고</button>
						<button onClick="location.href='/mobile/MGR05.page'">팔렛타이징</button>
						<button onClick="location.href='/mobile/MGR06.page'">적치</button>
						<button onClick="location.href='/mobile/MGR07.page'">적치(잔량)</button>
						<button onClick="location.href='/mobile/MGR08.page'">적치완료</button>
						<button onClick="location.href='/mobile/MGR09.page'">반품임시입고</button>
						<button onClick="location.href='/mobile/MGR10.page'">기타입고</button>
						<button style="background-color:rgb(255,255,255);"></button> 
					</p>
					<input type="checkbox" id="button3">
					<label class="mainmeun" for="button3">할당오더 <span></span></label>
					<p class="mobile_meun_button mobile_meun_button3">
						<button onClick="location.href='/mobile/MDL00.page'">재고보충완료</button>
						<button onClick="location.href='/mobile/MDL01.page'">재고보충완료확인</button>
						<button onClick="location.href='/mobile/MDL02.page'">할당조회/완료</button>
						<button onClick="location.href='/mobile/MDL03.page'">오더할당 피킹완료</button>
						<button onClick="location.href='/mobile/MDL04.page'">품목별 피킹완료</button>
						<button onClick="location.href='/mobile/MDL05.page'">담당별 피킹완료</button>
						<button onClick="location.href='/mobile/MDL06.page'">차량별 피킹완료</button>
						<button onClick="location.href='/mobile/MDL07.page'">토탈피킹검수</button>
						<button onClick="location.href='/mobile/MDL08.page'">차량출발</button>
						<button onClick="location.href='/mobile/MDL09.page'">회수단입력</button>
						<button onClick="location.href='/mobile/MDL10.page'">품목별 피킹검수</button>
						<button style="background-color:rgb(255,255,255);"></button>
					</p>
					<input type="checkbox" id="button4">
					<label class="mainmeun" for="button4">작업오더 <span></span></label>
					<p class="mobile_meun_button mobile_meun_button4">
						<button onClick="location.href='/mobile/MTO11.page'">작업오더 완료</button>
						<button onClick="location.href='/mobile/MTO02.page'">세트장이동</button>
						<button onClick="location.href='/mobile/MTO03.page'">세트조립</button>
						<button onClick="location.href='/mobile/MTO04.page'">세트해체</button>
					</p>
					<input type="checkbox" id="button5">
					<label class="mainmeun" for="button5">재고관리 <span></span></label>
					<p class="mobile_meun_button mobile_meun_button5">
						<button onClick="location.href='/mobile/MSD00.page'">재고이동</button>
						<button onClick="location.href='/mobile/MSD01.page'">재고실사</button>
						<button onClick="location.href='/mobile/MSD02.page'">수시조정</button>
						<button onClick="location.href='/mobile/MSD03.page'">위치별 재고현황</button>
						<button onClick="location.href='/mobile/MSD04.page'">바코드별 기준정보</button>
						<button onClick="location.href='/mobile/MSD05.page'">품목별 재고현황</button>
						<button onClick="location.href='/mobile/MSD06.page'">오프라인재고실사</button>
						<button style="background-color:rgb(255,255,255);"></button>
					</p> -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>