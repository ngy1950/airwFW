<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<html> 
<head>
<link rel="stylesheet" type="text/css" href="../../css/common.css"/>
<title>EUC-KR �� Ư�� �� �������� ȯ�濡�� ���ε��ϴ� �����Դϴ�.</title>
</head>

<body> 
	<div class="content_title_area">
	<div class="content_title">���� ����</div>
	<div class="content_desc">EUC-KR �� Ư�� �� �������� ȯ�濡�� ���ε��ϴ� �����Դϴ�.<br />
		NamoCrossUploader Server Java Edition�� �⺻������ �ٱ���(UTF-8) ������� �����մϴ�.<br />
		�ش� ������ EUC-KR ������� �ۼ��Ǿ� �ֽ��ϴ�.
	</div>
	<div class="content_title">���� ���</div>
	<div class="content_desc">NamoCrossUploaderJaSamples/Upload/SettingCharset</div>
	</div><br />
	
	<div class="form_area">
		<form action="UploadProcess.jsp" method="post" enctype="multipart/form-data">
	    	<table class="form_table"> 
	        	<!-- ���� -->
	            <tr>
	              <td>����</td>
	              <td><input type="text" name="textTitle"></td>
	            </tr>
	
	            <!-- �Խ��� ���� -->
	            <tr>
	              <td>�Խ��� ����</td>
	              <td>
	                <input type="radio" name="radioCate" value="�Ϲ� �Խ���" checked="checked">�Ϲ� �Խ���
	                <input type="radio" name="radioCate" value="������ �Խ���">������ �Խ���
	              </td>
	            </tr>
	
	            <!-- ���� �о� -->
	            <tr>
	              <td>���� �о�</td> 
	              <td>
	              	<table class="form_table"> 
	                	<tr>
	                    	<td><input type="checkbox" name="checkInter" value="����">����</td>
				            <td><input type="checkbox" name="checkInter" value="��ǻ��">��ǻ��</td>
	                    	<td><input type="checkbox" name="checkInter" value="����ũ">����ũ</td>
	                  	</tr>
	                  	<tr>
	                    	<td><input type="checkbox" name="checkInter" value="����">����</td>
			            	<td><input type="checkbox" name="checkInter" value="�ǰ�">�ǰ�</td>
				            <td><input type="checkbox" name="checkInter" value="�ڵ���">�ڵ���</td>
	                 	</tr>
	            	</table>
	            </td>
	          </tr>
	
	            <!-- �޸� -->
				<tr>
	            	<td>�޸�</td>
	              	<td><textarea name="memoTextarea" cols="45" rows="5" style="width:100%;"></textarea></td>
	            </tr>
	           
	            <!-- ÷�� ���� -->
	            <tr>
	            	<td>����1</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
				<tr>
	              	<td>����2</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
				<tr>
	              	<td>����3</td>
	              	<td><input type="file" name="files"></td>
	            </tr>
	   		</table>
	
	        <input type="submit" value="����">  
		</form> 
	</div>
</body>

</html>