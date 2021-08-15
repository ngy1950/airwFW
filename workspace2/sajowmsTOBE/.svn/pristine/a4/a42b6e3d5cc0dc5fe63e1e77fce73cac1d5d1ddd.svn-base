package project.common.view;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import project.common.bean.CommonConfig;

public class TextFileView extends AbstractView {
	
	@Override
	protected void renderMergedOutputModel(Map model,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		
		//텍스트 데이터를 가져온다.
		String str = model.get("data").toString();
		String fileName = model.get("fileName").toString();
		
		//파일 데이터 헤더 설정(다운로드 할 수있게)
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;fileName=\""+fileName+".txt\";");

		//파일 출력 선언 
		OutputStream out = null;
		try{
			out = response.getOutputStream();
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(out, "MS949"));
			writer.write(str.toCharArray());
			writer.flush();
		}catch (java.io.IOException ioe){
			ioe.printStackTrace();
		}finally{
			if (out != null)
				out.close();
		}
	}
}