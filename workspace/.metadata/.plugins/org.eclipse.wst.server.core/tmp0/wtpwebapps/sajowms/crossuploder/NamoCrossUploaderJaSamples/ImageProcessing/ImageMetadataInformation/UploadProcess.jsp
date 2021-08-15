<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.namo.crossuploader.*"%>
<%@page import="com.namo.image.*"%>
<%@page import="com.drew.imaging.ImageMetadataReader"%>
<%@page import="com.drew.imaging.ImageProcessingException"%>
<%@page import="com.drew.imaging.jpeg.JpegMetadataReader"%>
<%@page import="com.drew.imaging.jpeg.JpegProcessingException"%>
<%@page import="com.drew.imaging.jpeg.JpegSegmentReader"%>
<%@page import="com.drew.lang.ByteArrayReader"%>
<%@page import="com.drew.metadata.Metadata"%>
<%@page import="com.drew.metadata.exif.ExifReader"%>
<%@page import="com.drew.metadata.iptc.IptcReader"%>
<%@page import="com.drew.metadata.Directory"%>
<%@page import="com.drew.metadata.Tag"%>
<%@page import="java.io.*"%>

<%
	PrintWriter writer = response.getWriter(); 
	FileUpload fileUpload = new FileUpload(request, response); 
	
	// 업로드 정보를 화면에 출력하기 위한 HTML 코드입니다. 신경쓰지 않으셔도 됩니다. 
	printHtmlHeader(writer); 
	
	try { 
		// autoMakeDirs를 true로 설정하면 파일 저장 및 이동시 파일생성에 필요한 상위 디렉토리를 모두 생성합니다.
		fileUpload.setAutoMakeDirs(true);

		// 파일을 저장할 경로를 설정합니다.
		String saveDirPath = request.getRealPath("/");
		saveDirPath += ("UploadDir" + File.separator);
		
		// saveDirPath에 지정한 경로로 파일 업로드를 시작합니다. 
		fileUpload.startUpload(saveDirPath); 	

		// 업로드 경로를 지정하지 않을 경우, 시스템의 임시 디렉토리로 파일 업로드를 시작합니다. 	
		// fileUpload.startUpload(); 

		// 입력한 name을 키로 갖는 마지막 FileItem 객체를 리턴합니다.
		// "files"는 UploadForm.jsp에서 입력한 값입니다. <input type="file" name="files"> 
		FileItem fileItem = fileUpload.getFileItem("files");

		if(fileItem != null) { 
			// saveDirPath 경로에 원본 파일명으로 저장(이동)합니다. 동일한 파일명이 존재할 경우 다른 이름으로 저장됩니다.
			fileItem.save(saveDirPath); 	
			
			// 다른 유형의 저장(이동) 함수들
			// save(); 
			// save(String saveDirPath, boolean overwrite);
			// saveAs(String saveDirPath, String fileName); 
			// saveAs(String saveDirPath, String fileName, boolean overwrite); 
						
			// FileItem 객체로 아래와 같은 정보를 가져올 수 있습니다. 
			String name = fileItem.getName();
			String fileName = fileItem.getFileName(); 
			String lastSavedDirPath = fileItem.getLastSavedDirPath(); 
			String lastSavedFilePath = fileItem.getLastSavedFilePath(); 
			String lastSavedFileName = fileItem.getLastSavedFileName(); 
			long fileSize = fileItem.getFileSize();
			String fileNameWithoutFileExt = fileItem.getFileNameWithoutFileExt(); 
			String fileExtension = fileItem.getFileExtension(); 
			String contentType = fileItem.getContentType(); 
			boolean saved = fileItem.isSaved();
			boolean emptyFie = fileItem.isEmptyFile(); 
			
			// 업로드 정보 출력
			printFileUploadResult(fileItem, writer); 
			
			// 이미지 객체 생성
			ImageTool image = ImageTool.getImage(fileItem);
			// 다른 유형의 Image 객체를 가져오는 함수들
			// getImage(File sourceFile);
			// getImage(String sourceFilePath);
			
			// image가 null이면, 지원되지 않는 이미지 포맷이거나 파일을 찾을 수 없는 경우입니다. 
			if(image != null) { 
				// 기본적인 이미지 파일의 정보를 가져옵니다.
				String imageFormatName = image.getFormatName();  
				int imageWidth = image.getWidth(); 
				int imageHeight = image.getHeight(); 
		
				// 기본적인 이미지 정보 출력 
				printBasicImageInfo(image, writer); 
				
				/**
				* 이미지 메타데이터 정보를 가져옵니다.
				*/
				// JPG 포맷일 경우
				if(imageFormatName.toUpperCase().compareTo("JPG") == 0 || imageFormatName.toUpperCase().compareTo("JPEG") == 0) {
			        try {
			        	// FileItem 객체에서 File 객체를 가져와 readMetadata()의 파라미터로 넘겨줍니다. 
			            Metadata metadata = JpegMetadataReader.readMetadata(fileItem.getFile());
			        	// Image Metadata 정보 출력
			            printImageTags(metadata, writer);
			        } 
			        catch (JpegProcessingException ex) {
			            printMetadataExceptionMessage(ex.getMessage(), writer); 
			        } 
			        catch (IOException ex) {
			            printMetadataExceptionMessage(ex.getMessage(), writer); 
			        }
				}
			}
			else { 
				printBasicImageInfo(null, writer); 
			}
		}
	}
	catch(CrossUploaderException ex) { 
		printExceptionMessage(ex.getMessage(), writer); ; 
	}
	catch(Exception ex) { 
		printExceptionMessage(ex.getMessage(), writer); 
		//  업로드 외 로직에서 예외 발생시 업로드 중인 모든 파일을 삭제합니다. 
		fileUpload.deleteUploadedFiles(); 
	}
	finally { 
		// 파일 업로드 객체에서 사용한 자원을 해제합니다. 
		fileUpload.clear(); 
		
		// 업로드 정보를 화면에 출력하기 위한 HTML 코드입니다. 신경쓰지 않으셔도 됩니다.  
		printHtmlFooter(writer); 
	}
%>

<%!
	private void printImageTags(Metadata metadata, PrintWriter writer)
	{
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=5><b>이미지 메타데이터 정보</b></td><tr>"; 

	    for (Directory directory : metadata.getDirectories()) {
	        for (Tag tag : directory.getTags()) {
	            //System.out.println(tag);
	    		html += "<tr>";
	    		html += "<td><b>DirectoryName: </b></td><td>" + tag.getDirectoryName()+ "</td>";
	    		html += "<td><b>TagName: </b></td><td>" + tag.getTagName()+ "</td>";
	    		html += "<td><b>Description: </b></td><td>" + tag.getDescription()+ "</td>";
	    		html += "<td><b>TagType: </b></td><td>" + tag.getTagType()+ "</td>";
	    		html += "<td><b>TagTypeHex: </b></td><td>" + tag.getTagTypeHex()+ "</td>";
	    		html += "</tr>"; 
	        }
	        for (String error : directory.getErrors())
	            System.err.println("ERROR: " + error);
	    }
		html += "</tbody></table></div>";
   		writer.println(html); 
	}

	public void printBasicImageInfo(ImageTool image, PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>기본적인 이미지 정보</b></td><tr>"; 
		if(image != null) { 
			html += "<tr><td>Image Format Name</td><td>" + image.getFormatName() + "</td></tr>"; 
			html += "<tr><td>Image Width</td><td>" + image.getWidth() + "</td></tr>"; 
			html += "<tr><td>Image Height</td><td>" + image.getHeight() + "</td></tr>"; 
		}
		else {
			html += "<tr><td colspan=2>지원되지 않는 이미지 포맷이거나 파일을 찾을 수 없습니다. </td></tr>"; 
		}
		html += "</tbody></table></div>";
		
		writer.println(html); 
	}

	public void printFileUploadResult(FileItem fileItem, PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>파일 업로드 정보</b></td><tr>"; 
		html += "<tr><td>Name</td><td>" + fileItem.getName() + "</td></tr>"; 
		html += "<tr><td>File Name</td><td>" + fileItem.getFileName() + "</td></tr>"; 
		html += "<tr><td>Last Saved Directory Path</td><td>" + fileItem.getLastSavedDirPath() + "</td></tr>"; 
		html += "<tr><td>Last Saved File Path</td><td>" + fileItem.getLastSavedFilePath() + "</td></tr>"; 
		html += "<tr><td>Last Saved File Name</td><td>" + fileItem.getLastSavedFileName() + "</td></tr>"; 
		html += "<tr><td>File Size</td><td>" + fileItem.getFileSize() + "</td></tr>";
		html += "<tr><td>File Name without File Ext</td><td>" + fileItem.getFileNameWithoutFileExt() + "</td></tr>"; 
		html += "<tr><td>File Extension</td><td>" + fileItem.getFileExtension() + "</td></tr>"; 
		html += "<tr><td>Content Type</td><td>" + fileItem.getContentType() + "</td></tr>"; 
		html += "<tr><td>Saved</td><td>" + fileItem.isSaved() + "</td></tr>"; 
		html += "<tr><td>Is EmptyFile</td><td>" + fileItem.isEmptyFile() + "</td></tr>"; 
		html += "</tbody></table></div>";
		
		writer.println(html); 
	}
	
	public void printExceptionMessage(String message, PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>예외가 발생했습니다.</b></td><tr>"; 
		html += "<tr><td>예외 메시지: </td><td>" + message + "</td></tr>"; 
		html += "</tbody></table></div>";
	
		writer.println(html); 
	}
	
	public void printMetadataExceptionMessage(String message, PrintWriter writer) { 
		String html = "<div class='form_area'><table class='form_table'><tbody>"; 
		html += "<tr><td class='form_table_title' colspan=2><b>이미지 메타정보를 가져오는 중 예외가 발생했습니다.</b></td><tr>"; 
		html += "<tr><td>예외 메시지: </td><td>" + message + "</td></tr>"; 
		html += "</tbody></table></div>";
	
		writer.println(html); 
	}
	
	public void printHtmlHeader(PrintWriter writer) { 
		String html = "<html><head>"; 
		html += "<meta http-equiv='content-type' content='text/html; charset=utf-8'>";
		html += "<link rel='stylesheet' type='text/css' href='../../css/common.css'/>"; 
		html += "<title>파일 업로드 정보입니다</title></head>";
		html += "<body>";
	
		writer.println(html); 
		writer.flush();	
	}
	public void printHtmlFooter(PrintWriter writer) { 
		writer.println("</body></html>"); 
		writer.flush();	
	}%>