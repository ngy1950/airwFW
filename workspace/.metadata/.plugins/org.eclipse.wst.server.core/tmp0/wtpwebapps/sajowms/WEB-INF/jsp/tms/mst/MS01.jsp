<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://openapi.map.naver.com/openapi/v2/maps.js?clientId=OUm_ZFDvz2sWswi9UP4t"></script>
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	//var init = "Y";
	var chkMATRX = "";

	$(document).ready(function(){
		//searcMap("37.510933","127.123925");
		//$('.fullSizer').eq(0).click();
		
		chkMATRX = "";
		
		gridList.setGrid({
    		id : "gridList",
			editable : true,
			pkcol : "SHPTOP",
			module : "TmsAdmin",
			command : "CUTMT",
			/* validation : "SHPTOP" */
    	});
	});
	
	function searchList(){
		//$('.fullSizer').eq(0).click();
		chkMATRX = "";
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function saveData(){
		var param = dataBind.paramData("searchArea");

/* 		if(chkMATRX == "U"){
			var param = new DataMap();
			param.put("STOPTP",colValue);
			var json = netUtil.sendData({
				module : "TmsAdmin",
				command : "SHTOTYval",
				sendType : "map",
				param : param
			});
			if(json.data["CNT"] > 0) {
				var param = new DataMap();
				param.put("STOPTP",colValue);
				var json = netUtil.sendData({
					module : "TmsAdmin",
					command : "SHTOTYnm",
					sendType : "map",
					param : param
				});
				if(json && json.data){
					gridList.setColValue("gridList", rowNum, "SHTOGB", json.data["CDESC1"]); 
				} 
				checkValidationType = true;
			} else if (json.data["CNT"] < 1) {
				commonUtil.msgBox("MASTER_M0044", colValue);
				gridList.setColValue("gridList", rowNum, "SHTOTY", ""); 					
				gridList.setColValue("gridList", rowNum, "SHTOGB", ""); 
				checkValidationType = false;
			}				
		}else  */
		
		if(gridList.validationCheck("gridList")){
			var json = gridList.gridSave({
		    	id : "gridList",
		    	param : param
		    });

			if(json && json.data){
					searchList();
			}	
		}			
	}
	
	function gridListEventRowAddBefore(gridId, rowNum, beforeData){

	      var newData = new DataMap();

          newData.put("SHTOGB", " ");
	      newData.put("SOSTOP", " ");
	      newData.put("SHPLAT", "0");
	      newData.put("SHPLON", "0");
	  	  newData.put("PSTLZ", "0");	      

	      return newData;
	}  
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "ADDR01" ){
			var addr = gridList.getColData(gridId, rowNum, "ADDR01");
			if(addr != null || addr != "" || aadr != " "){
				searchAddr(addr,rowNum)	
			}			
		}	

		if(gridId == "gridList" && colName == "SHTOTY"){  //???????????????
			if(colValue != ""){
				var param = new DataMap();
				param.put("STOPTP",colValue);
				var json = netUtil.sendData({
					module : "TmsAdmin",
					command : "SHTOTYval",
					sendType : "map",
					param : param
				});
				if(json.data["CNT"] > 0) {
					var param = new DataMap();
					param.put("STOPTP",colValue);
					var json = netUtil.sendData({
						module : "TmsAdmin",
						command : "SHTOTYnm",
						sendType : "map",
						param : param
					});
					if(json && json.data){
						gridList.setColValue("gridList", rowNum, "SHTOGB", json.data["CDESC1"]); 
					} 
					checkValidationType = true;
				} else if (json.data["CNT"] < 1) {
					commonUtil.msgBox("MASTER_M0044", colValue);
					gridList.setColValue("gridList", rowNum, "SHTOTY", ""); 					
					gridList.setColValue("gridList", rowNum, "SHTOGB", ""); 
					checkValidationType = false;
				}			
			}else if(colValue==""){
				gridList.setColValue("gridList", rowNum, "SHTOGB", "");
				checkValidationType = true;
			}
		}else if(gridId == "gridList" && colName == "PSTLZ"){  //????????????
			if(colValue != ""){
				var param = new DataMap();
				param.put("PSTLZ",colValue);
				var json = netUtil.sendData({
					module : "TmsAdmin",
					command : "PSTLZ_CNT",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] > 0) {
					checkValidationType = true;
					
					var json = netUtil.sendData({
						module : "TmsAdmin",
						command : "PSTLZ_ADDR",
						sendType : "map",
						param : param
					});
					
					gridList.setColValue("gridList", rowNum, "ADDR01", json.data["ADDR01"]);
					gridList.setColValue("gridList", rowNum, "SHPLAT", json.data["SHPLAT"]);
					gridList.setColValue("gridList", rowNum, "SHPLON", json.data["SHPLON"]);
					gridList.setColValue("gridList", rowNum, "ETC020", "Y");
					
		        	//alert("????????? ????????? ???????????? ???????????????(1?????????)");
/* 	            	gridList.setColValue("gridList", rowNum, "SHPLAT", json.SHPLAT);
	            	gridList.setColValue("gridList", rowNum, "SHPLON", json.SHPLON);

					var param = new DataMap();
					param.put("SHPTOP",shptop);
					param.put("PSTLZ", pstlz);
					param.put("SHPLAT", json.SHPLAT);
					param.put("SHPLON", json.SHPLON);

					loadingOpen();
						
	  				//?????? Matrx??? ???????????? ????????? ??????
	  				param.put("TSHPTO",shptop);
	  				var json = netUtil.sendData({
	  					module : "TmsAdmin",
	  					command : "DEL_SHPTOP",
	  					sendType : "map",
	  					param : param
	  				});

	       			//?????????Matrx ?????? ??? XY???????????? call
					var json = netUtil.sendData({
						url : "/tms/dsp/json/saveMS01Load.data",
						param : param
					});        
	       			
					loadingClose();
		          					 */
					
					/* ????????? api ?????? */
					
					//searchAddr(json.data["ADDR01"],rowNum);
				}else {
					commonUtil.msgBox("TMS_T0009", colValue);		
					checkValidationType = false;
				}			
			}			
		}
	}	
	
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		if(searchCode == "SHCMCDV"){
			var param = inputList.setRangeParam("searchArea");
			
	        if($inputObj.name != null){
	           if($inputObj.name == "CUTYCP"){       //????????????
	               param.put("CMCDKY", "CUTYCP");    
	           }else if($inputObj.name == "SHTOTY"){  //???????????????
	               param.put("CMCDKY", "STOPTP");
	           }            
	        }else{
	             if($inputObj.attr("name") == "SHTOTY"){  //???????????????
	                param.put("CMCDKY", "STOPTP");   
	             }else if($inputObj.attr("name") == "CUTYCD"){ //????????????
	            	 param.put("CMCDKY", "CUTYCP");   
	             }
	        }

			return param;
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "A7"){
			A7();
		}
	}
	
	//??????
	function A7(){
		alert("saveMS01Load call");
		var param = new DataMap();
		//?????????Matrx ?????? ??? XY???????????? call
		var json = netUtil.sendData({
			url : "/tms/dsp/json/saveMS01Load.data",
			param : param
		});
	}		
	
	
	
	function searchAddr(addr,rowNum){
		var param = new DataMap();
		var shptop = gridList.getColData("gridList", rowNum, "SHPTOP");
		var oldLat = gridList.getColData("gridList", rowNum, "SHPLAT");
		var oldLon = gridList.getColData("gridList", rowNum, "SHPLON");
		var pstlz = gridList.getColData("gridList", rowNum, "PSTLZ");

		param.put("addr",addr);
		
		var json = netUtil.sendData({
			id : "gridList",
			url : "/geocoding/input/json/naverMap.data",
			sendType : "map",		
		    param : param
		});

		if(json.SHPLAT == null && json.SHPLON == null){		
			commonUtil.msgBox("TMS_T0008");
			setColFocus("gridList", rowNum, "ADDR01");
			gridList.setColValue("gridList", rowNum, "SHPLAT", "0");
        	gridList.setColValue("gridList", rowNum, "SHPLON", "0");
			
		}else{
			var Lat = json.SHPLAT;
            var Lng = json.SHPLON;
            
            loadingOpen();
            
            if (oldLat != json.SHPLAT && oldLon != json.SHPLON){
            	if (confirm('???????????? ?????? ???????????????????(1?????????)')) {
                	gridList.setColValue("gridList", rowNum, "SHPLAT", json.SHPLAT);
                	gridList.setColValue("gridList", rowNum, "SHPLON", json.SHPLON);

					var param = new DataMap();
					param.put("SHPTOP",shptop);
					param.put("PSTLZ", pstlz);
					param.put("SHPLAT", json.SHPLAT);
					param.put("SHPLON", json.SHPLON);

					loadingOpen();
 					
      				//?????? Matrx??? ???????????? ????????? ??????
      				param.put("TSHPTO",shptop);
      				var json = netUtil.sendData({
      					module : "TmsAdmin",
      					command : "DEL_SHPTOP",
      					sendType : "map",
      					param : param
      				});
   
           			//?????????Matrx ?????? ??? XY???????????? call
					var json = netUtil.sendData({
						url : "/tms/dsp/json/saveMS01Load.data",
						param : param
					});        
           			
					loadingClose();
                	/* ?????? hide
                	$('.fullSizer').eq(0).click();                	
                 	$('.shplat').val(json.SHPLAT); //??????
        			$('.shplon').val(json.SHPLON); //??????
                	searcMap(Lat,Lng); //?????? 
                	*/
                }            	
            }
		}
	}

	function searcMap (Lat,Lng) {
	    $("#naverMap").html();
	    $("#naverMap").html("");
	    var oPoint = new nhn.api.map.LatLng(Lat,Lng);
	    nhn.api.map.setDefaultPoint('LatLng');

	    oMap = new nhn.api.map.Map('naverMap', {
	        point : oPoint,
	        zoom : 10, // - ?????? ??? ????????? 10?????? ??????.
	        enableWheelZoom : true,
	        enableDragPan : true,
	        enableDblClickZoom : false,
	        mapMode : 0,
	        activateTrafficMap : false,
	        activateBicycleMap : false,
	        minMaxLevel : [ 1, 14 ],
	        size : new nhn.api.map.Size(1150, 300)
	    });
	    
	    var mapZoom = new nhn.api.map.ZoomControl(); // - ??? ????????? ??????
	    mapZoom.setPosition({left:10, top:10}); // - ??? ????????? ?????? ??????.
	    

	    //?????? ??????  ?????? ??????
        var oSize = new nhn.api.map.Size(28, 37);
	    var oOffset = new nhn.api.map.Size(14, 37);
	    var oIcon = new nhn.api.map.Icon('http://static.naver.com/maps2/icons/pin_spot2.png', oSize, oOffset);
	    var oMarker = new nhn.api.map.Marker(oIcon, { title : '?????? : ' + oPoint.toString() });
	    oMarker.setPoint(oPoint);
	    oMap.addOverlay(oMarker);

/* 	    
	    //?????? ??? ??????, ?????? ??????
        var markerCount = 0;
        var oSize = new nhn.api.map.Size(28, 37);
        var oOffset = new nhn.api.map.Size(14, 37);
        var oIcon = new nhn.api.map.Icon('http://static.naver.com/maps2/icons/pin_spot2.png', oSize, oOffset);
        var mapInfoTestWindow = new nhn.api.map.InfoWindow(); // - info window ??????
        var oLabel = new nhn.api.map.MarkerLabel();           // - ?????? ?????? ??????.
	    var oMarker = new nhn.api.map.Marker(oIcon, { title : '?????? : ' + oPoint.toString() });
	    oMarker.setPoint(oPoint);
	    oMap.addOverlay(oMarker);        
        mapInfoTestWindow.setVisible(false);                  // - infowindow ?????? ?????? ??????.
        oMap.addOverlay(mapInfoTestWindow);                   // - ????????? ??????.     
        oMap.addOverlay(oLabel);                              // - ?????? ?????? ????????? ??????.

        mapInfoTestWindow.attach('changeVisible', function(oCustomEvent) {
        	if (oCustomEvent.visible) { oLabel.setVisible(false); }
        });
      

        oMap.attach('mouseenter', function(oCustomEvent) {
	        var oTarget = oCustomEvent.target;
	        if (oTarget instanceof nhn.api.map.Marker) { // ???????????? ????????? ???????????????
	         var oMarker = oTarget;
	         oLabel.setVisible(true, oMarker);           // - ?????? ????????? ???????????? ?????? ????????? title??? ????????????.
	        }
        });

        oMap.attach('mouseleave', function(oCustomEvent) {
	        var oTarget = oCustomEvent.target;            
	        if (oTarget instanceof nhn.api.map.Marker) { oLabel.setVisible(false); } // ??????????????? ????????? ????????????
        });

        oMap.attach('click', function(oCustomEvent) {
	        var oPoint = oCustomEvent.point;
	        var oTarget = oCustomEvent.target;
	        mapInfoTestWindow.setVisible(false);
	        if (oTarget instanceof nhn.api.map.Marker) {          // ?????? ????????????
		        if (oCustomEvent.clickCoveredMarker) { return; }  // ?????? ?????? ???????????????
		        mapInfoTestWindow.setContent('<DIV style="border-top:1px solid; border-bottom:2px groove black; border-left:1px solid; border-right:2px groove black;margin-bottom:1px;color:black;background-color:white; width:auto; height:auto;">'+
		        '<span style="color: #000000 !important;display: inline-block;font-size: 12px !important;font-weight: bold !important;letter-spacing: -1px !important;white-space: nowrap !important; padding: 2px 2px 2px 2px !important">' + 
		        '??????(Y,X) <br /> ' + oTarget.getPoint() +'<span></div>');
		        mapInfoTestWindow.setPoint(oTarget.getPoint());
		        mapInfoTestWindow.setVisible(true);
		        mapInfoTestWindow.setPosition({right : 15, top : 30});
		        mapInfoTestWindow.autoPosition();
		        return;
	        }
	        var oMarker = new nhn.api.map.Marker(oIcon, { title : '?????? : ' + oPoint.toString() });
	        oMarker.setPoint(oPoint);
	        oMap.clearOverlay(); //?????? ?????????
	        oMap.addOverlay(oMarker);
	
	        var Lat,Lng;
	        Lat = oPoint.getLat(); Lng = oPoint.getLng();
	        $('.Lat').val(Lat);  
	        $('.Lng').val(Lng); 
        });	   
*/  

	}
    /* 	?????? hide
	function gridListEventInputColFocus(gridId, rowNum, colName){ 
		if(init == "Y"){
			if(colName == "ADDR01" ){
				init = "N"
				$('.fullSizer').eq(0).click();
			}
		}
	}
	 */
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE">
		</button>
		<button CB="A7 A7 BTN_EXECUTE">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
	
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">????????????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_COMPKY">Company Code</th>
						<td>
							<input type="text" name="COMPKY" value="<%=compky%>"  readonly="readonly" style="width:110px" />  <!-- UIInput="S,SHCOMMA"   -->
						</td>
					</tr>
<%-- 					<tr>
						<th CL="STD_WAREKY">Center Code</th>
						<td>
							<input type="text" name="WAREKY" UIInput="R,SHWAHMA"  value="<%=wareky%>"/>
						</td>
					</tr> --%>
					<tr>
						<th CL="STD_SRESWK">?????????</th>
						<td>
							<input type="text" name="SHPTOP" UIInput="R,SHPTOP" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHTOTY">???????????????</th>
						<td>
							<input type="text" name="SHTOTY" UIInput="R,SHCMCDV" />
						</td>
					</tr>			
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>?????????1</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="50" />
											<col width="150" /> 
											<col width="150" /> 
											<col width="150" /> 
											<col width="150" />
											<col width="100" />
											<col width="280" />
											<col width="90" />
											<col width="90" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_SRESWK'> ????????? </th>
												<th CL='STD_SHIPNM'> ???????????? </th>
												<th CL='STD_SHTOTY'> ???????????????</th>
												<th CL='STD_SHTOGB'> ?????????????????? </th>
												<th CL='STD_CPSTLZ'> ???????????? </th>
												<th CL='STD_ADDR01'> ?????? </th>
												<th CL='STD_SHPLAT'> ?????? </th>
												<th CL='STD_SHPLON'> ?????? </th>
												<th >????????????      </th>
												<th >?????????        </th>
												<th >?????????        </th>
												<th >????????????      </th>
												<th >??????          </th>
												<th >??????          </th>
												<th >??????2         </th>
												<th >????????????1     </th>
												<th >????????????2     </th>
												<th >????????????      </th>
												<th >?????????1       </th>
												<th >?????????????????????</th>
												<th >???????????????    </th>
												<th >??????          </th>
												<th >??????          </th>
												<th >????????????      </th>
												<th >?????????        </th>
												<th >????????????      </th>
												<th >????????????      </th>
												<th >????????????1     </th>
												<th >????????????2     </th>
												<th >????????????3     </th>
												<th >????????????      </th>
												<th >BP????????????    </th>
												<th >????????????      </th>
												<th >E-Mail        </th>
												<th >??????          </th>											
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="50" />
											<col width="150" /> 
											<col width="150" /> 
											<col width="150" /> 
											<col width="150" />
											<col width="100" />
											<col width="280" />
											<col width="90" />
											<col width="90" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />											
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="input,SHPTOP" validate="required" >?????????</td>																							
												<td GCol="input,SHIPNM">????????????</td>												
												<td GCol="input,SHTOTY,SHCMCDV" name="SHTOTY" >???????????????</td>
												<td GCol="text,SHTOGB" >??????????????????</td>
												<td GCol="input,PSTLZ,SHPZIP" name="PSTLZ" >????????????</td>
												<td GCol="text,ADDR01" >??????</td>
												<td GCol="text,SHPLAT" GF="N 10,7">??????</td>
												<td GCol="text,SHPLON" GF="N 10,7">??????</td>
												<td GCol="select,SOSTOP">
													<select CommonCombo="SHTOGB" name="SOSTOP" disabled="disabled">????????????</select>													
												</td>												
												<td GCol="text,VKBUR">?????????</td>
												<td GCol="select,VKBUTX">
													<select CommonCombo="VKBUTX" name="VKBUTX" disabled="disabled">?????????</select>													
												</td>										
												<td GCol="text,CUTYCD">????????????</td>
												<td GCol="text,PLTTIM">??????</td>
												<td GCol="select,WAREKY">
													<select CommonCombo="NATNKY" name="WAREKY" disabled="disabled">??????</select>
												</td>												
												<td GCol="text,ADDR02">??????2</td>
												<td GCol="text,TELN01">????????????1</td>
												<td GCol="text,TELN02">????????????2</td>
												<td GCol="select,MOVLVL">
													<select CommonCombo="MOVLVP" name="MOVLVL" disabled="disabled">????????????</select>
												</td>
												<td GCol="text,DISTRICT">?????????</td>
												<td GCol="text,stcd2">?????????????????????</td>
												<td GCol="text,fityp">???????????????</td>
												<td GCol="text,J_1KFTBUS">??????</td>
												<td GCol="text,J_1KFTIND">??????</td>
												<td GCol="text,GFORM">????????????</td>
												<td GCol="text,WAERS">?????????</td>
												<td GCol="text,INCO1">????????????</td>
												<td GCol="text,TAXKD">????????????</td>
												<td GCol="text,PERNR1">????????????1</td>
												<td GCol="text,PERNR2">????????????2</td>
												<td GCol="text,PERNR3">????????????3</td>
												<td GCol="text,LIFNR">????????????</td>
												<td GCol="text,KUNN2">????????????</td>
												<td GCol="text,VTWEG">????????????</td>
												<td GCol="text,SMTP_ADDR">E-Mail</td>
												<td GCol="text,EXTENSION1">??????</td>																																				
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<!-- <button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea"><p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 20160411?????? hide 		        
			<div class="bottomSect bottom" style="top: 320px">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-2" CL="STD_ITEM"><span>?????????</span></a></li>
					</ul>
					<div id="tabs1-1">
					
						<label for="point">?????????</label><input class="Lat" type="text"><input class="Lng" type="text">
			            <label for="addr">????????????</label><input class="addr" type="text"><button type="button" class="btn_find" title="????????????" onclick="searchList(); return false;"><span>??????</span></button>
			            <label for="point">?????????</label><input class="shplat" type="text"> <input class="shplon" type="text">
			            
						<center><div id = "naverMap" style="border:1px solid #000; width:790px; height:290px; margin:2px; text-align:center;"></div></center>
					</div>
				</div>
			</div>
		    -->
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>