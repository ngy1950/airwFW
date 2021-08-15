<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		$(".btn_ghost").on("click",function(){
			$(".deemLayer3").show();
			$(".left_wrap").show();
		});
		
		$(".deemLayer3").on("click",function(){
			$(this).hide();
			$(".left_wrap").hide();
		});
		
		$(".setting span").on("click",function(){
			if($(".deem_setting").hasClass("on")){
				$(".deem_setting").addClass("off");
				$(".deem_setting").removeClass("on");
				$(".deemLayer4").removeClass("on");
				$(".deemLayer4").addClass("off");
				$(".deemLayer5").removeClass("on");
				$(".deemLayer5").addClass("off");
			}else{
				$(".deem_setting").addClass("on");
				$(".deem_setting").removeClass("off");
				$(".deemLayer4").removeClass("off");
				$(".deemLayer4").addClass("on");
				$(".deemLayer5").removeClass("off");
				$(".deemLayer5").addClass("on");
			}
			
		});
		
		$menuSearch = jQuery("#menuSearch");
		$dep01 = $(".lnb_dep01 > li");
		$dep02 = $(".lnb_dep02 > li");
		$dep03 = $(".lnb_dep03 > li");
		//menuSearch("SAMPLE");
		
		//$menuList.find("[AMNUID=root]").addClass("open");
		
		$dep01.on("click",function(e){
			if($dep02.children(".lnb_dep03").hasClass("open")){
				$(this).toggleClass("dep01_focus");
				$(this).children(".lnb_dep02").toggleClass("open");
				$(this).children(".lnb_dep02").children("li").toggleClass("open");
			}else{
				$(this).toggleClass("dep01_focus");
				$(this).children(".lnb_dep02").toggleClass("open");
				$(this).children(".lnb_dep02").children("li").addClass("dep02_focus_off").toggleClass("open");
			}
		});
		
		$dep02.on("click",function(e){
			e.stopPropagation();
			$(this).toggleClass("on");
			$(this).children(".lnb_dep03").toggleClass("open");
			$(this).children(".lnb_dep03").children("li").addClass("open");
			if($(this).hasClass("dep02_focus_off")){
				$(this).toggleClass("dep02_focus_on");
			}
		});
		
		$dep03.on("click",function(e){
			e.stopPropagation();
		});
		
	});
	

</script>
	<div class="deemLayer3" style="display:none">
	</div>
	<div class="deemLayer4 off">
	</div>
	
	<!-- 메뉴 시작 -->
	<div class="left_wrap" style="display:none">
		<div class="tab_wrap">
			<h1 class="left-top-logo">
				<a href="#"><img class="left-top-webdek" src="/common/theme/webdek/mobile_img/logo_w.png" /></a>
			</h1> 
			 <div class="tab_container">
				 <div id="tab1" class="tab_content">	
					<div class="lnb_wrap">
						<ul class="lnb_dep01" id="menuList" style="display:block">
							<li>
								<a href="#none">1 레벨 메뉴</a>
								<ul class="lnb_dep02">
									<li>
										<a href="#none">2 레벨 메뉴</a>
										<ul class="lnb_dep03">
											<li><a href="#none">3 레벨 메뉴</a></li>
										</ul>
									</li>
								</ul>
							</li>
						</ul>
					</div>
				 </div>
			 </div>
		</div>
	</div>
	<!-- 메뉴 끝 -->