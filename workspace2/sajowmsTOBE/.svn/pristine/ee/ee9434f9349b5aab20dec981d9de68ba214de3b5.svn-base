	<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
	<script type="text/javascript">
		$(document).ready(function(){
		    
		    searchwareky('<%=ownrky %>');
		
			$("#WAREKY").val('<%=wareky %>').prop("selected", true);	
			drawMenu();
		});
	
		$(function(){	
			$('.submenu_all').click(function(){
				$('.mobile_submenu').animate({left:0},400);
				$('.mobile_submenu .back').css({'display': 'block', 'opacity': 0}).animate({'opacity': 0.6}, 300);
		    });
			$('.mobile_submenu_close').click(function(){
				$('.mobile_submenu').animate({left:'-100%'},400);
				$('.mobile_submenu .back').animate({'opacity': 0}, 300, function(){
					$(this).css({'display' : 'none'});
				});
			});
		});
		
		
		//로그아웃
		function logout(){
			location.href = "/mobile/json/logout.page";
		}
		
		//거점 콤보 
		function searchwareky(val){
			var param = new DataMap();
			param.put("OWNRKY",val);
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "LOGIN_WAREKY_COMCOMBO",
				sendType : "list",
				param : param
			});
			
			$("#WAREKY").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, false);
			$("#WAREKY").append(optionHtml);
		}

		
		//거점 체인지(세션변경)
		function warekyChange(){
			var param = new DataMap();
			param.put("WAREKY", $("#WAREKY").val());
		
			var json = netUtil.sendData({
				url : "/mobile/json/changeSession.data",
				param : param
			}); 

			if(json && json.data){
				location.reload();
			}
		}
		
		//메뉴 그리기
		function drawMenu(){
			var param = new DataMap();
			param.put("MENUKEY", "<%=menukey %>");

			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "MOBILE_MENU",
				sendType : "list",
				param : param
			});

			if(json && json.data){
				var list = json.data;
				
// 				var btnCtn = 2;
				var innerHTML = "";
				var innerMain = "";
				var subcnt = 0;
				for(var i=0; i<list.length; i++){
					var menuNm = list[i].MENUNAME;
					var menuLb = list[i].MENULABEL;
					
					if(list[i].LV == 1){//대메뉴
						if(i!=0){ //탭마감
							
							innerHTML+='	</ul>';
							innerHTML+='</li>';
							if(subcnt%2 == 1){
								innerMain+='<button style="background-color:rgb(255,255,255);"></button>';
								subcnt = 0;
							}
							innerMain+='</div>';
						}
					
						innerHTML+='<li class="msubmenu_nav2">';
						innerHTML+='	<a href="#"class="botton_lines click_nav">'+menuNm+'<span class="icons"></span></a>';
						innerHTML+='	<ul class="msubmenu_nav2_1">';
						
// 						innerMain+='<input type="checkbox" id="button'+btnCtn+'">';
// 						innerMain+='<label class="mainmeun" for="button'+btnCtn+'">'+menuNm+'<span></span></label>';
// 						innerMain+='<p class="mobile_meun_button mobile_meun_button'+btnCtn+'">';

						
						var dbtnCtn = parseInt(list[i].SORT.substr(0,1)) + 1;
						innerMain+='<input type="checkbox" id="button'+dbtnCtn+'">';
						innerMain+='<label class="mainmeun" for="button'+dbtnCtn+'">'+menuNm+'<span></span></label>';
						innerMain+='<div class="mobile_meun_button mobile_meun_button'+dbtnCtn+'">';
						
// 						btnCtn+=1;
					}else{
						var uri = list[i].URI;
						var img = "background:url("+list[i].IMGPTH+")no-repeat;";
						var dbtnCtn = parseInt(list[i].SORT.substr(0,1)) + 1;
						//소메뉴
						innerHTML+='<li><span class="icon" style="'+img+'">'
						innerHTML+='</span><a href="'+uri+'">'+menuNm+'</a></li>';
						
						innerMain+='<button onClick="location.href=\''+uri+'\'" ><span class="iconImg" style="'+img+'"></span><span class="lbNm">'+menuLb+'</span></button>';
// 						background:url(/mobile/images/mobile_ico/m-ico-201.png)no-repeat center;
						
						subcnt++;
						if(i+1 == list.length){
							if(subcnt%2 == 1){
								innerMain+='<button style="background-color:rgb(255,255,255);"></button>';
								subcnt = 0;
							}
							innerMain+='</div>';
						}
						
					}
					
				} 
				
				
			
				$("#menuDiv").html(innerHTML);
				
				if($("#mainMenu")){
					$("#mainMenu").html(innerMain);	
				}

				//이벤트 적용   //메뉴 화살표 아이콘 on off                                                               
			    $(".msubmenu_nav .click_nav").click(function(){
			        var submenu = $(this).next(".msubmenu_nav2_1");
			        var icon = $(this).children(".icons");

			        if( submenu.is(":visible") ){
			            submenu.slideUp();
			            icon.css({'transform':'rotate(90deg)'})

			        }else{
			            submenu.slideDown();
			            icon.css({'transform':'rotate(-90deg)'})
			        } 
			    });
			}
		}
		
		
		
		
	</script>
	
	<div class="mobile_submenu">
		<div class="back mobile_submenu_close"></div>
		<div class="contents" >
			<div class="contImgArea">
				<p class="imgArea">
					<span><a href="/mobile/main.page"><img src="/mobile/images/sajo-wms0.png" alt="logo" title="webdek" /></a></span>
					<span class="mobile_submenu_close"></span>
				</p>
				<p class="userStatus" id="logout">
					<span class="nameArea"><%=username %>님, 안녕하세요.</span>
				</p>
			</div>
			<div class="contWhare">
				<p id="ownrky"><span>[<%=ownrky %>]<%=ownrkynm %></span></p>
				<form>
					<select name="select" id="WAREKY" onchange="warekyChange()">
						<option value="거점">거점을 선택해주세요</option>
					</select>
				</form>
			</div>
			<div class="container">
				<!-- <p class="userStatus" id="login"><button onClick="location.href='/mobile/index.page'">로그인</button></p> -->
				<ul class="msubmenu_nav" id="menuDiv">
					<!-- <li class="msubmenu_nav2">
						<a href="#"class="botton_lines click_nav">grid<span class="icons"></span></a>
						<ul class="msubmenu_nav2_1">
							<li><span class="icon"></span><a href="/demo/mobile/gridSingle.page">메뉴1</a></li>
							<li><span class="icon"></span><a>메뉴2</a></li>
						</ul>
					</li>
					<li><a href="#"class="botton_lines click_nav">input<span class="icons"></span></a>
						<ul class="msubmenu_nav2_1">
							<li><span class="icon"></span><a href="/demo/mobile/input.page">메뉴1</a></li>
							<li><span class="icon"></span><a>메뉴2</a></li>
						</ul>
					</li> -->
				</ul>
				
				<div class="btnLog">
					<span><a href="/mobile/main.page"><img src="/sajo/images/sajo_wms02.png" alt="logo" title="webdek" /></a></span>
					<button onClick="logout()">로그아웃</button>
				</div>
			</div>
		</div>
	</div>