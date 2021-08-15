<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html> 
<head>
<link rel="stylesheet" type="text/css" href="../../css/common.css"/>
<title>파일 및 다양한 폼 데이터를 업로드하는 예제입니다.</title>
</head>

<body> 
	<div class="content_title_area">
	<div class="content_title">샘플 설명</div>
	<div class="content_desc">파일 및 다양한 폼 데이터를 업로드하는 예제입니다.</div>
	<div class="content_title">샘플 경로</div>
	<div class="content_desc">NamoCrossUploaderJaSamples/Upload/VariousFormUpload</div>
	</div><br />
	
	<div class="form_area">
		<form action="UploadProcess.jsp" method="post" enctype="multipart/form-data">
	    	<table class="form_table"> 
	        	<!-- 제목 -->
	            <tr>
	              <td>제목</td>
	              <td><input type="text" name="textTitle"></td>
	            </tr>
	
	            <!-- 게시판 선택 -->
	            <tr>
	              <td>게시판 선택</td>
	              <td>
	                <input type="radio" name="radioCate" value="일반 게시판" checked="checked">일반 게시판
	                <input type="radio" name="radioCate" value="동영상 게시판">동영상 게시판
	              </td>
	            </tr>
	
	            <!-- 관심 분야 -->
	            <tr>
	              <td>관심 분야</td> 
	              <td>
	              	<table class="form_table"> 
	                	<tr>
	                    	<td><input type="checkbox" name="checkInter" value="도서">도서</td>
				            <td><input type="checkbox" name="checkInter" value="컴퓨터">컴퓨터</td>
	                    	<td><input type="checkbox" name="checkInter" value="재테크">재테크</td>
	                  	</tr>
	                  	<tr>
	                    	<td><input type="checkbox" name="checkInter" value="여행">여행</td>
			            	<td><input type="checkbox" name="checkInter" value="건강">건강</td>
				            <td><input type="checkbox" name="checkInter" value="자동차">자동차</td>
	                 	</tr>
	            	</table>
	            </td>
	          </tr>
	
	            <!-- 메모 -->
				<tr>
	            	<td>메모</td>
	              	<td><textarea name="memoTextarea" cols="45" rows="5" style="width:100%;"></textarea></td>
	            </tr>
	           
	            <!-- 첨부 파일 -->
	            <tr>
	            	<td>파일1</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
				<tr>
	              	<td>파일2</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
				<tr>
	              	<td>파일3</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
	   		</table>
	
	        <input type="submit" value="전송">  
		</form> 
	</div>
</body>

</html>