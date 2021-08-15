package test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class SearchParser {

	public SearchParser() {
		try {
			makeSearchTable();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	//파일 리드 
	public String importGrid(String filePath) throws Exception{
		//그리드 내용이 들어있는 텍스트 파일을 읽어온다.
		StringBuffer gridStr = new StringBuffer();
		String result = "";
		BufferedReader br = new BufferedReader(new FileReader(filePath));
		
		while(true) {
			String line = br.readLine();
			gridStr.append(line);
			if (line==null){
				result = gridStr.toString();
				break;
			}
		}
		br.close();
		
		return result;
	}

	//레인지 컬럼 파싱
	public Map parseRange(String gridText) {
		Map rangeMap = new HashMap();
		String dataArr[] = gridText.split("</C>");
		String keyArr[];
		String keyArr2[];
		String valArr[];
		String valArr2[];
		String key, value;
		
		for(int i=0; i < dataArr.length; i++){
			keyArr =  dataArr[i].split("V=\"");
			
			if(keyArr.length > 1) {
				keyArr2 = keyArr[1].split("\">");
				
				if(keyArr2.length > 1) { //key 분리
					key = keyArr2[0];
					value = keyArr2[1];
					//  System.out.println(key+"//"+value);
					rangeMap.put(key, value);
				}
			}else {
			}
		}
		return rangeMap;
	}
	


	//구 서치 > 신서치 파싱
	public String parseSearch(String gridText, Map rangeMap) {
		StringBuffer sb = new StringBuffer();
		StringBuffer excelSb = new StringBuffer();
		String dataArr[] = gridText.split("</TR>");
		String dataArr2[] = gridText.split("</TR>");
		String tdText;
		
		String labelArr[];
		String labelArr2[];
		String labelArr3[];
		String label;
		String lablgr, lablky,labTxt="";
		
		String searchArr[];
		String searchArr2[];
		String idArr[];
		String widthArr[];
		String id, width;

		//특수문자 재거
		String match = "[^\uAC00-\uD7A3xfea-z0-9A-Z\\s]";
		
		//TR재거
		for(int i=0; i<dataArr.length-1; i++) {
			sb = new StringBuffer();
			lablgr = "";
			lablky="";
			dataArr2  = dataArr[i].split("<TR>");
			tdText = dataArr2[1].replaceAll("<TD>",""); //TD재거
			tdText = tdText.replaceAll("</TD>",""); //TD재거
			
			labelArr = tdText.split("<L"); //라벨분리
			//라벨은 무조건 있다고 가정
			label = labelArr[1].split("</L>")[0];
			
			//language 포함시에는 라벨을 검색 
			if(label.contains("language")) {
				//반드시 있다고 가정
				labelArr2 = label.split("<%=");
				
				if(labelArr2.length > 1) {
					labelArr3 = labelArr2[1].split(",");
					lablgr = labelArr3[1].replaceAll(match, "").trim();
					
					if("ITF".equals(lablgr) ||"EZG_BAR".equals(lablgr) ||"EZG".equals(lablgr) ||"CAR".equals(lablgr) ||"STD".equals(lablgr)
							||"GR41".equals(lablgr) ||"WOS".equals(lablgr) ||"EZG_PHY".equals(lablgr) ||"EZG_TSO".equals(lablgr) ||"SHTIT".equals(lablgr)
							||"RL31".equals(lablgr) ||"TAB".equals(lablgr) ||"TAXYN".equals(lablgr) ||"HHTGRD".equals(lablgr) ||"EZG_ASN".equals(lablgr)
							||"DR".equals(lablgr) ||"MENU".equals(lablgr) ||"STCD".equals(lablgr) ||"EZG_MOV".equals(lablgr) ||"EZG_MOVE".equals(lablgr)
							||"EZG_PIK".equals(lablgr) ||"RL25".equals(lablgr) ||"BTN".equals(lablgr) ||"EZG_ARN".equals(lablgr) ||"EZG_SHP".equals(lablgr)
							||"EZG_SHPBJ".equals(lablgr) ||"EZG_TPK".equals(lablgr) ||"IFT".equals(lablgr) ||"RL23".equals(lablgr) ||"RPT".equals(lablgr) ||"EZG_PUT".equals(lablgr)
							||"EZG_SAR".equals(lablgr) ||"BUYCOST".equals(lablgr) ||"__MENU".equals(lablgr) ||"HHTSTD".equals(lablgr) ||"EZG_DST".equals(lablgr) ||"EZG_REC".equals(lablgr)
							||"EZG_REP".equals(lablgr) ||"HP".equals(lablgr)) { //라벨 유효성 체크 존재하는 모든 라벨 대분류 추가 
						
						lablky = labelArr3[2].split("%")[0].replaceAll(match, "").trim();
						label = lablgr+"_"+lablky;
						
						labTxt = getLabelData(lablgr, lablky);
					}else {
						label = label.split("\">")[1];
						label = label.split("</")[0];
						labTxt = label;
					}
				}else {			//language 미포함시에는 라벨 검색안함
					label = label.split("\">")[1];
					label = label.split("</")[0];
					labTxt = label;
				}
			}else {			//language 미포함시에는 라벨 검색안함
				label = label.split("\">")[1];
				label = label.split("</")[0];
				labTxt = label;
			}
			
			//라벨값 저장
			
			//폼제작 
			if(tdText.contains("<C")) { //콤보
				searchArr = tdText.split("<C");
				searchArr = searchArr[1].split("/>");
				
				idArr = searchArr[0].split("id=");
				if(idArr.length > 1) {
					id = idArr[1].split("\"")[1].replaceAll(match, "").trim();
					widthArr = searchArr[0].split("width=");
					width = widthArr[1].split("\"")[1].replaceAll(match, "").trim(); 
					
					sb.append("<dl>  <!--").append(labTxt).append("-->  \n");
					
					if("".equals(lablgr) && "".equals(lablky)) {
						sb.append("	<dt CL=\"").append(labTxt).append("\"></dt> \n");
					}else {
						sb.append("	<dt CL=\"").append(lablgr).append("_").append(lablky).append("\"></dt> \n");
					}
					
					sb.append("	<dd> \n");
					sb.append("		<select name=\"").append(id).append("\" id=\"").append(id.toUpperCase()).append("\" class=\"input\" Combo=\"\"></select> \n");
					sb.append("	</dd> \n");
					sb.append("</dl> ");
					
					//엑셀용
					excelSb.append(labTxt).append("	").append(id).append("	").append("문자").append("	 	 	 	 	 	 	").append(id).append(" \n");
				}
				
			}else if(tdText.contains("<R")) { //레인지
				searchArr = tdText.split("<R");
				searchArr = searchArr[1].split("/>");
				
				idArr = searchArr[0].split("id=");
				if(idArr.length > 1) {
					id = idArr[1].split("\"")[1].trim();
					widthArr = searchArr[0].split("width=");
					width = widthArr[1].split("\"")[1].replaceAll(match, "").trim();
					
					
					sb.append("<dl>  <!--").append(labTxt).append("-->  \n");
					
					if("".equals(lablgr) && "".equals(lablky)) {
						sb.append("	<dt CL=\"").append(labTxt).append("\"></dt> \n");
					}else {
						sb.append("	<dt CL=\"").append(lablgr).append("_").append(lablky).append("\"></dt> \n");
					}
					
					sb.append("	<dd> \n");
					//레인지를 기반으로 연결된 name가져오기
					if(tdText.contains("editForm=\"4")) { //달력인 경우
						sb.append("		<input type=\"text\" class=\"input\" name=\"").append(rangeMap.get(id)).append("\" UIInput=\"B\" UIFormat=\"C N\"/> \n");

						//엑셀용
						excelSb.append(labTxt).append("	").append(rangeMap.get(id)).append("	").append("날짜").append("	 	 	 	 	 	 	").append(rangeMap.get(id)).append(" \n");
					}else {
						sb.append("		<input type=\"text\" class=\"input\" name=\"").append(rangeMap.get(id)).append("\" UIInput=\"SR\"/> \n");

						//엑셀용
						excelSb.append(labTxt).append("	").append(rangeMap.get(id)).append("	").append("문자").append("	 	 	 	 	 	 	").append(rangeMap.get(id)).append(" \n");
					}
					
					sb.append("	</dd> \n");
					sb.append("</dl> ");
				}
				
				
			}else if(tdText.contains("<CB")){ //체크박스
				searchArr = tdText.split("<CB");
				searchArr = searchArr[1].split("/>");

				
				idArr = searchArr[0].split("id=");
				if(idArr.length > 1) {
					id = idArr[1].split("\"")[1].replaceAll(match, "").trim();
					widthArr = searchArr[0].split("width=");
					width = widthArr[1].split("\"")[1].replaceAll(match, "").trim();
					
					
					sb.append("<dl>  <!--").append(labTxt).append("-->  \n");
					
					if("".equals(lablgr) && "".equals(lablky)) {
						sb.append("	<dt CL=\"").append(labTxt).append("\"></dt> \n");

						//엑셀용
						excelSb.append(labTxt).append("	").append(id.toUpperCase()).append("	").append("체크박스").append("	 	 	 	 	 	 	").append(id.toUpperCase()).append(" \n");
					}else {
						sb.append("	<dt CL=\"").append(lablgr).append("_").append(lablky).append("\"></dt> \n");

						//엑셀용
						excelSb.append(lablgr).append("	").append(id.toUpperCase()).append("	").append("체크박스").append("	 	 	 	 	 	 	").append(id.toUpperCase()).append(" \n");
					}
					
					sb.append("	<dd> \n");
					sb.append("		<input type=\"checkbox\" class=\"input\" name=\"").append(id.toUpperCase()).append("\"/>  \n");
					sb.append("	</dd> \n");
					sb.append("</dl> ");
				}
				
			}else if(tdText.contains("<E")){ //싱글에디터
				//박스가 여러개인지 확인
				String editArr[] = tdText.split("<E");
				String editArr2[];
				String editArr3[];

				sb.append("<dl>  <!--").append(labTxt).append("-->  \n");
				
				if("".equals(lablgr) && "".equals(lablky)) {
					sb.append("	<dt CL=\"").append(labTxt).append("\"></dt> \n");
				}else {
					sb.append("	<dt CL=\"").append(lablgr).append("_").append(lablky).append("\"></dt> \n");
				}

				sb.append("	<dd> \n");
				for(int j=1; j<editArr.length; j++) {
					editArr2 = editArr[j].split("/>");
					idArr = editArr2[0].split("id=");
					
					if(idArr.length > 1) {
						id = idArr[1].split("\"")[1].replaceAll(match, "").trim();
						widthArr = editArr2[0].split("width=");
						width = widthArr[1].split("\"")[1].replaceAll(match, "").trim();
						
						sb.append("		<input type=\"text\" class=\"input\" name=\"").append(id.toUpperCase()).append("\" UIInput=\"I\"/> \n");
					}
					
				}	
				
				sb.append("	</dd> \n");
				sb.append("</dl> ");
			}
			
			//  System.out.println(sb.toString());
		}
		
		

		//  System.out.println(excelSb.toString());
		return sb.toString();
	}
	

	//서치
	public void  makeSearchTable() throws Exception{
		String searchText = importGrid("C:/test/convertSearch.txt");
		String rangeText = importGrid("C:/test/convertRange.txt");
		Map rangeMap = parseRange(rangeText);
		parseSearch(searchText, rangeMap);
		
	}
	

	
	//라벨 데이터 디비에서 가져오기
	public String getLabelData(String lablgr, String lablky) {
		StringBuffer gridStr = new StringBuffer();
		String lbtxt ="";
		
		Connection conn = null; 
		PreparedStatement psmt = null;
		ResultSet rs = null; 
		StringBuffer resultStr = new StringBuffer();
		
		try {

			//db
			try {
				Class.forName("oracle.jdbc.OracleDriver");
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn = DriverManager.getConnection("jdbc:oracle:thin:@10.11.1.42:1521:SAJOWMS", "SAJOWMS","SAJOWMS");
			//  System.out.println("JDBC 연결 성공");

			StringBuffer sb = new StringBuffer();
			sb.append("SELECT LBLTXL FROM JLBLM WHERE LABLGR = '").append(lablgr).append("' AND LABLKY ='").append(lablky).append("'");
			//  System.out.println(sb.toString());
			psmt = conn.prepareStatement(sb.toString());
			rs = psmt.executeQuery();
			while(rs.next()) {
				lbtxt = rs.getString("LBLTXL");
			}
			
				
			//  System.out.println(resultStr.toString());
		} catch (SQLException e) {	
			//  System.out.println("실패 -- getAllStudent" + e);
		} finally { 
			if(rs!=null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
			}
			
			if(psmt!=null) {
				try {
					psmt.close();
				} catch (SQLException e) {
				}
			}
			
			if(conn!=null) {
				try {
					conn.close();
				} catch (SQLException e) {
				}
			}
		}
		
		return lbtxt;
	}
}
