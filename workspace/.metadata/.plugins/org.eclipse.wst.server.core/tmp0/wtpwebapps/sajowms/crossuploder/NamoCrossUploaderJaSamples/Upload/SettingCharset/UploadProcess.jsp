<%@page language="java" contentType="text/html; charset=EUC-KR"%>
<%@page import="com.namo.crossuploader.*"%>
<%@page import="java.io.*"%>

<%
	PrintWriter writer = response.getWriter(); 
	//FileUpload fileUpload = new FileUpload(request, response); 
	FileUpload fileUpload = new FileUpload(request, response, "EUC-KR"); 
	
	// ���ε� ������ ȭ�鿡 ����ϱ� ���� HTML �ڵ��Դϴ�. �Ű澲�� �����ŵ� �˴ϴ�. 
	printHtmlHeader(writer); 
	
	try { 
		// autoMakeDirs�� true�� �����ϸ� ���� ���� �� �̵��� ���ϻ����� �ʿ��� ���� ���丮�� ��� �����մϴ�.
		fileUpload.setAutoMakeDirs(true);

		// ������ ������ ��θ� �����մϴ�.
		String saveDirPath = request.getRealPath("/");
		saveDirPath += ("UploadDir" + File.separator);
		
		// saveDirPath�� ������ ��η� ���� ���ε带 �����մϴ�. 
		fileUpload.startUpload(saveDirPath); 	

		// ���ε� ��θ� �������� ���� ���, �ý����� �ӽ� ���丮�� ���� ���ε带 �����մϴ�. 	
		// fileUpload.startUpload(); 
		
		/**
		* �� ������ ���ε� ó��
		*/
		// �̸� (text)
		String textTitle = fileUpload.getFormItem("textTitle");
		// �Խ��� ���� (radiobox)
		String radioCate = fileUpload.getFormItem("radioCate");
		// ���� �о� (checkbox)
		String[] checkInter = fileUpload.getFormItems("checkInter");
		// �޸� (textarea)
		String memoTextarea = fileUpload.getFormItem("memoTextarea");
		
		printFormUploadResult(textTitle, radioCate, checkInter, memoTextarea, writer); 

		/**
		* ���� ������ ���ε� ó��
		*/
		// �Է��� name�� Ű�� ���� FileItem[] ��ü�� �����մϴ�.  
		// "files"�� UploadForm.jsp���� �Է��� ���Դϴ�. <input type="file" name="files"> 
		FileItem[] fileItems = fileUpload.getFileItems("files");
		if(fileItems != null) { 
			for(int i=0; i<fileItems.length; i++) {
				// saveDirPath ��ο� ���� ���ϸ����� ����(�̵�)�մϴ�. ������ ���ϸ��� ������ ��� �ٸ� �̸����� ����˴ϴ�.
				fileItems[i].save(saveDirPath); 	
				
				// �ٸ� ������ ����(�̵�) �Լ���
				// save(); 
				// save(String saveDirPath, boolean overwrite);
				// saveAs(String saveDirPath, String fileName); 
				// saveAs(String saveDirPath, String fileName, boolean overwrite); 
				
				// FileItem ��ü�� �Ʒ��� ���� ������ ������ �� �ֽ��ϴ�. 
				String name = fileItems[i].getName();
				String fileName = fileItems[i].getFileName(); 
				String lastSavedDirPath = fileItems[i].getLastSavedDirPath(); 
				String lastSavedFilePath = fileItems[i].getLastSavedFilePath(); 
				String lastSavedFileName = fileItems[i].getLastSavedFileName(); 
				long fileSize = fileItems[i].getFileSize(); 
				String fileNameWithoutFileExt = fileItems[i].getFileNameWithoutFileExt(); 
				String fileExtension = fileItems[i].getFileExtension(); 
				String contentType = fileItems[i].getContentType(); 
				boolean saved = fileItems[i].isSaved();
				boolean emptyFie = fileItems[i].isEmptyFile(); 
			}
			// ���ε� ���� ���
			printFileUploadResult(fileItems, writer); 	
		}
	}
	catch(CrossUploaderException ex) { 
		printExceptionMessage(ex.getMessage(), writer); 
	}
	catch(Exception ex) { 
		printExceptionMessage(ex.getMessage(), writer); 
		//  ���ε� �� �������� ���� �߻��� ���ε� ���� ��� ������ �����մϴ�. 
		fileUpload.deleteUploadedFiles(); 
	}
	finally { 
		// ���� ���ε� ��ü���� ����� �ڿ��� �����մϴ�. 
		fileUpload.clear(); 
		
		// ���ε� ������ ȭ�鿡 ����ϱ� ���� HTML �ڵ��Դϴ�. �Ű澲�� �����ŵ� �˴ϴ�.  
		printHtmlFooter(writer); 
	}
%>

<%!
	public void printFormUploadResult(String textTitle, String radioCate, String[] checkInter, String memoTextarea, 
			PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>�� ������ ���ε� ����</b></td><tr>"; 
		if(textTitle != null)
			html += "<tr><td>����</td><td>" + textTitle + "</td></tr>"; 
		if(radioCate != null)
			html += "<tr><td>�Խ��� ����</td><td>" + radioCate + "</td></tr>"; 
		if(checkInter != null) { 
			for(int i=0; i<checkInter.length; i++)
				html += "<tr><td>" + (i+1) + "��° ���� �о�</td><td>" + checkInter[i] + "</td></tr>"; 
		}
		if(memoTextarea != null) 
			html += "<tr><td>�޸�</td><td>" + memoTextarea + "</td></tr>"; 
			
		html += "</tbody></table></div>";

		writer.println(html); 
	}


	public void printFileUploadResult(FileItem[] fileItems, PrintWriter writer) { 
		if(fileItems == null)
			return; 
	
		String html = ""; 
		for(int i=0; i<fileItems.length; i++) { 
			html += "<div class='form_area'><table class='form_table'><tbody>"; 
			html += "<tr><td class='form_table_title' colspan=2><b>" + (i+1) + "��° ���� ���ε� ����</b></td><tr>"; 
			html += "<tr><td>Name</td><td>" + fileItems[i].getName() + "</td></tr>"; 
			html += "<tr><td>File Name</td><td>" + fileItems[i].getFileName() + "</td></tr>"; 
			html += "<tr><td>Last Saved Directory Path</td><td>" + fileItems[i].getLastSavedDirPath() + "</td></tr>"; 
			html += "<tr><td>Last Saved File Path</td><td>" + fileItems[i].getLastSavedFilePath() + "</td></tr>"; 
			html += "<tr><td>Last Saved File Name</td><td>" + fileItems[i].getLastSavedFileName() + "</td></tr>"; 
			html += "<tr><td>File Size</td><td>" + fileItems[i].getFileSize() + "</td></tr>";
			html += "<tr><td>File Name without File Ext</td><td>" + fileItems[i].getFileNameWithoutFileExt() + "</td></tr>"; 
			html += "<tr><td>File Extension</td><td>" + fileItems[i].getFileExtension() + "</td></tr>"; 
			html += "<tr><td>Content Type</td><td>" + fileItems[i].getContentType() + "</td></tr>"; 
			html += "<tr><td>Saved</td><td>" + fileItems[i].isSaved() + "</td></tr>"; 
			html += "<tr><td>Is EmptyFile</td><td>" + fileItems[i].isEmptyFile() + "</td></tr>"; 
			html += "</tbody></table></div>";
		} 
		writer.println(html); 
	}
	
	public void printExceptionMessage(String message, PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>���ܰ� �߻��߽��ϴ�.</b></td><tr>"; 
		html += "<tr><td>���� �޽���: </td><td>" + message + "</td></tr>"; 
		html += "</tbody></table></div>";
	
		writer.println(html); 
	}
	
	public void printHtmlHeader(PrintWriter writer) { 
		String html = "<html><head>"; 
		html += "<meta http-equiv='content-type' content='text/html; charset=utf-8'>";
		html += "<link rel='stylesheet' type='text/css' href='../../css/common.css'/>"; 
		html += "<title>���� ���ε� �����Դϴ�</title></head>";
		html += "<body>";
	
		writer.println(html); 
		writer.flush();	
	}
	public void printHtmlFooter(PrintWriter writer) { 
		writer.println("</body></html>"); 
		writer.flush();	
	}
%>