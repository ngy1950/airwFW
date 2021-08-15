package test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//0:column, 1:s_label↓m_label↓l_label, 2:maskType, 3:Precision, 4:Scale, 5:widht, 6:pk, 7:editable
//<C V="xtims"       M="header.xtims"	     >xtims↑<%=getLabelLongText(language, "STD", "RQARRT")%>↑5↑6↑0↑60↑F↑F</C>
//컬럼명 : column : xtims
//라벨 : label : <%=getLabelLongText(language, "STD", "RQARRT")%>
//에디트유형 : masktype : 5
//0	General
//1	Number
//2	Numeric Character
//3	Character
//4	Date
//5	Time
//6	Possible Entry
//7	Combobox
//8	CheckBox
//9	Currency
//10	Picture
//11	UpperCharacter
//12	Numeric Character (RightAlign)
//13	ThreeStatusCheckBox
//14	Numeric Character+Possible Entry
//15	UpperCase+AlphaNumeric+PossibleEntry
//16	UpperCase+PossibleEntry
//17	Button
//18	Value Combo
//19	Number( ‘-‘ enable)
//20	Character(RightAlign)
//데이터 길이 : precision : 6
//데이터 소수점길이 : scale : 0  
//화면에 기본 보이는 길이 : width : 60  -2(완전숨김) -1 (레아아웃숨김)
//pk여부 : pk : F
//수정가능여부 : editable : F
public class GridParser {

	public GridParser() {
		try {
			makeGridTable();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

	public void ExcelParser() {
		try {
			makeExcel();
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
	
	//구 그리드 > 신그리드 파싱
	public String parseRow(String gridText) {

		StringBuffer resultStrBuf = new StringBuffer(); //리턴 Str을 담을 StringBuffer 생성

		String[] colOptions = gridText.split("↑");
		//String colNm = colOptions[0].split(">")[1]; // 컬럼 이름(sql 알리아스)
		String[] colNmArr = colOptions[0].split("V="); 
		String colNm = "";// 컬럼 이`름(sql 알리아스)
		
		if(colNmArr.length > 1) {
			colNm = colNmArr[1];
			colNm = colNm.split("\"")[1];
		}else {
			colNm = colOptions[0].split(">")[1];
		}
		
		
		String label = colOptions[1]; //라벨
		String type = colOptions[2]; //타입
		String dataLength = colOptions[3]; //데이터 최대 길이 
		String scale = colOptions[4]; // 소숫점
		String width = colOptions[5]; // 가로  (-1(레이아웃숨김) -2(미표시))
		String isPk = colOptions[6]; // 피케이여부
		String editable = colOptions[7]; // disable여부
		
		//타입 데이터 분리 
		String dataType = "S";
		if("0".equals(type) || "3".equals(type)) { //문자
			dataType = "S";
		}else if("1".equals(type) || "2".equals(type)) { //숫자
			dataType = "N";
		}else if("4".equals(type)) {
			dataType = "D";
		}else if("5".equals(type)) {
			dataType = "T";
		}

		//특수문자 재거
        String match = "[^\uAC00-\uD7A3xfea-z0-9A-Z\\s]";
		colNm = colNm.replaceAll(match, "");
		
		//인풋 <> 텍스트 결정
		String gColType = "text";
		editable = editable.split("<")[0];
		editable = editable.replaceAll(match, "");
		if(editable.equals("F")) gColType = "input";
		
		//소숫점 표현 여부 숫자일 경우만 들어가게 변경
		if(!"N".equals(dataType)) {
			scale = ""; 
		}else {
			scale = ","+scale;
		}
		
		if(!"-2".equals(width)) { //-2 사이즈는 그리드에 출력하지 않는다.

			//라벨키를 여러개 넣은경우 체크 
			String[] lbChkArr = label.split("↓");
			if(lbChkArr.length > 1) {
				label = lbChkArr[0];
			}

			//라벨 데이터 분리
			String[] labArr = label.split(",");
			String lablgr = "";
			String lablky =	"";
			String labTxt = ""; //디비에서 읽어올 라벨 값
			
			if(labArr.length > 1) { //라벨을 하드코딩하지 않은 경우
				lablgr = labArr[1].replaceAll(match, "").trim();
				
				if("ITF".equals(lablgr) ||"EZG_BAR".equals(lablgr) ||"EZG".equals(lablgr) ||"CAR".equals(lablgr) ||"STD".equals(lablgr)
						||"GR41".equals(lablgr) ||"WOS".equals(lablgr) ||"EZG_PHY".equals(lablgr) ||"EZG_TSO".equals(lablgr) ||"SHTIT".equals(lablgr)
						||"RL31".equals(lablgr) ||"TAB".equals(lablgr) ||"TAXYN".equals(lablgr) ||"HHTGRD".equals(lablgr) ||"EZG_ASN".equals(lablgr)
						||"DR".equals(lablgr) ||"MENU".equals(lablgr) ||"STCD".equals(lablgr) ||"EZG_MOV".equals(lablgr) ||"EZG_MOVE".equals(lablgr)
						||"EZG_PIK".equals(lablgr) ||"RL25".equals(lablgr) ||"BTN".equals(lablgr) ||"EZG_ARN".equals(lablgr) ||"EZG_SHP".equals(lablgr)
						||"EZG_SHPBJ".equals(lablgr) ||"EZG_TPK".equals(lablgr) ||"IFT".equals(lablgr) ||"RL23".equals(lablgr) ||"RPT".equals(lablgr) ||"EZG_PUT".equals(lablgr)
						||"EZG_SAR".equals(lablgr) ||"BUYCOST".equals(lablgr) ||"__MENU".equals(lablgr) ||"HHTSTD".equals(lablgr) ||"EZG_DST".equals(lablgr) ||"EZG_REC".equals(lablgr)
						||"EZG_REP".equals(lablgr) ||"HP".equals(lablgr)) { //라벨 유효성 체크 존재하는 모든 라벨 대분류 추가 
					lablky = labArr[2].replaceAll(match, "").trim();
					label = lablgr+"_"+lablky;
					
					labTxt = getLabelData(lablgr, lablky);
				}else {
					labTxt = label;
				}
			}else {
				labTxt = label;
			}
			
			if("-1".equals(width)) width = "80"; //-1에 경우 보이긴 해야되서 80사이즈 고정
			
			resultStrBuf.append("<td GH=\"").append(width).append(" ").append(label).append("\" GCol=\"").append(gColType).append(",").append(colNm.toUpperCase().trim());
			resultStrBuf.append("\" GF=\"").append(dataType).append(" ").append(dataLength).append(scale).append("\">").append(labTxt).append("</td>");
			resultStrBuf.append("	<!--").append(labTxt).append("-->");
		}
		
		return resultStrBuf.toString();
	}

	//그리드 출력
	public void  makeGridTable() throws Exception{
		String gridText = importGrid("C:/test/convert.txt");
		String gDataArr[] = gridText.split("<C");
		String rowText ="";
		
		StringBuffer resultStr = new StringBuffer();
		
		resultStr.append("<div>                                              \n");
		resultStr.append("	<div class=\"section type1\">                                   \n");
		resultStr.append("		<div class=\"table type2\">                                 \n");
		resultStr.append("			<div class=\"tableBody\">                               \n");
		resultStr.append("				<table>                                             \n");
		resultStr.append("					<tbody id=\"gridList\">                    \n");
		resultStr.append("						<tr CGRow=\"true\">                         \n");
		resultStr.append("    						<td GH=\"40 STD_NUMBER\"           GCol=\"rownum\">1</td>   \n");
		
		for(int i = 1; i < gDataArr.length; i++){
			rowText = parseRow(gDataArr[i]);
			if(!"".equals(rowText.trim())) {
				resultStr.append("    						").append(rowText).append("\n");
			}
		}
		resultStr.append("						</tr>							             \n");
		resultStr.append("					</tbody>                                         \n");
		resultStr.append("				</table>                                             \n");
		resultStr.append("			</div>                                                   \n");
		resultStr.append("		</div>                                                       \n");
		resultStr.append("		<div class=\"tableUtil\">                                    \n");
		resultStr.append("			<div class=\"leftArea\">                                 \n");
		resultStr.append("				<button type=\"button\" GBtn=\"find\"></button>      \n");
		resultStr.append("				<button type=\"button\" GBtn=\"sortReset\"></button> \n");
		resultStr.append("				<button type=\"button\" GBtn=\"layout\"></button>    \n");
		resultStr.append("				<button type=\"button\" GBtn=\"total\"></button>     \n");
		resultStr.append("				<button type=\"button\" GBtn=\"excel\"></button>     \n");
		resultStr.append("				<button type=\"button\" GBtn=\"excelAll\"></button>  \n");
		resultStr.append("			</div>                                                   \n");
		resultStr.append("			<div class=\"rightArea\">                                \n");
		resultStr.append("				<p class=\"record\" GInfoArea=\"true\"></p>          \n");
		resultStr.append("			</div>                                                   \n");
		resultStr.append("		</div>                                                       \n");
		resultStr.append("	</div>                                                           \n");
		resultStr.append("</div>				                                             \n");
		
		//  System.out.println(resultStr.toString());
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
	
	
	
	
	
	//문서작업용
	public void  makeExcel() throws Exception{
		String gridText = importGrid("C:/test/convert.txt");
		String gDataArr[] = gridText.split("<C");
		String rowText ="";
		
		StringBuffer resultStr = new StringBuffer();
		
		for(int i = 1; i < gDataArr.length; i++){
			rowText = parseRowExcel(gDataArr[i]);
			if(!"".equals(rowText.trim())) {
				resultStr.append(rowText).append("\n");
			}
		}
		
		//  System.out.println(resultStr.toString());
	}
	

	//구 그리드 > 신그리드 파싱
	public String parseRowExcel(String gridText) {

		StringBuffer resultStrBuf = new StringBuffer(); //리턴 Str을 담을 StringBuffer 생성

		String[] colOptions = gridText.split("↑");
		//String colNm = colOptions[0].split(">")[1]; // 컬럼 이름(sql 알리아스)
		String[] colNmArr = colOptions[0].split("V="); 
		String colNm = "";// 컬럼 이름(sql 알리아스)
		
		if(colNmArr.length > 1) {
			colNm = colNmArr[1];
			colNm = colNm.split("\"")[1];
		}else {
			colNm = colOptions[0].split(">")[1];
		}
		
		String label = colOptions[1]; //라벨
		String type = colOptions[2]; //타입
		String dataLength = colOptions[3]; //데이터 최대 길이 
		String scale = colOptions[4]; // 소숫점
		String width = colOptions[5]; // 가로  (-1(레이아웃숨김) -2(미표시))
		String isPk = colOptions[6]; // 피케이여부
		String editable = colOptions[7]; // disable여부
		
		//타입 데이터 분리 
		String dataType = "문자";
		String colType = "텍스트";
		if("0".equals(type) || "3".equals(type)) { //문자
			dataType = "문자";
		}else if("1".equals(type) || "2".equals(type)) { //숫자
			dataType = "숫자";
		}else if("4".equals(type)) {
			dataType = "날짜";
		}else if("5".equals(type)) {
			dataType = "시간";
		}else if("7".equals(type)) {
			dataType = "문자";
			colType = "콤보박스";
		}else if("8".equals(type)) {
			dataType = "문자";
			colType = "체크박스";
			
		}else if("6".equals(type)) {
			dataType = "문자";
			colType = "서치헬프";
			
		}

		//특수문자 재거
        String match = "[^\uAC00-\uD7A3xfea-z0-9A-Z\\s]";
		colNm = colNm.replaceAll(match, "");
		//인풋 <> 텍스트 결정
		String gColType = " ";
		editable = editable.split("<")[0];
		editable = editable.replaceAll(match, "");
		if(editable.equals("F")) gColType = "●";
		
		//소숫점 표현 여부 숫자일 경우만 들어가게 변경
		if(!"N".equals(dataType)) {
			scale = ""; 
		}else {
			scale = ","+scale;
		}
		
		if(!"-2".equals(width)) { //-2 사이즈는 그리드에 출력하지 않는다.

			//라벨키를 여러개 넣은경우 체크 
			String[] lbChkArr = label.split("↓");
			if(lbChkArr.length > 1) {
				label = lbChkArr[0];
			}
			
			//라벨 데이터 분리
			String[] labArr = label.split(",");
			String lablgr = "";
			String lablky =	"";
			String labTxt = ""; //디비에서 읽어올 라벨 값
			
			if(labArr.length > 1) { //라벨을 하드코딩하지 않은 경우
				lablgr = labArr[1].replaceAll(match, "").trim();
				
				if("ITF".equals(lablgr) ||"EZG_BAR".equals(lablgr) ||"EZG".equals(lablgr) ||"CAR".equals(lablgr) ||"STD".equals(lablgr)
						||"GR41".equals(lablgr) ||"WOS".equals(lablgr) ||"EZG_PHY".equals(lablgr) ||"EZG_TSO".equals(lablgr) ||"SHTIT".equals(lablgr)
						||"RL31".equals(lablgr) ||"TAB".equals(lablgr) ||"TAXYN".equals(lablgr) ||"HHTGRD".equals(lablgr) ||"EZG_ASN".equals(lablgr)
						||"DR".equals(lablgr) ||"MENU".equals(lablgr) ||"STCD".equals(lablgr) ||"EZG_MOV".equals(lablgr) ||"EZG_MOVE".equals(lablgr)
						||"EZG_PIK".equals(lablgr) ||"RL25".equals(lablgr) ||"BTN".equals(lablgr) ||"EZG_ARN".equals(lablgr) ||"EZG_SHP".equals(lablgr)
						||"EZG_SHPBJ".equals(lablgr) ||"EZG_TPK".equals(lablgr) ||"IFT".equals(lablgr) ||"RL23".equals(lablgr) ||"RPT".equals(lablgr) ||"EZG_PUT".equals(lablgr)
						||"EZG_SAR".equals(lablgr) ||"BUYCOST".equals(lablgr) ||"__MENU".equals(lablgr) ||"HHTSTD".equals(lablgr) ||"EZG_DST".equals(lablgr) ||"EZG_REC".equals(lablgr)
						||"EZG_REP".equals(lablgr) ||"HP".equals(lablgr)) { //라벨 유효성 체크 존재하는 모든 라벨 대분류 추가 
					lablky = labArr[2].replaceAll(match, "").trim();
					label = lablgr+"_"+lablky;
					
					labTxt = getLabelData(lablgr, lablky);
				}else {
					labTxt = label;
				}
			}else {
				labTxt = label;
			}
			
			if("-1".equals(width)) width = "80"; //-1에 경우 보이긴 해야되서 80사이즈 고정
			
			resultStrBuf.append(labTxt).append("	").append(colNm.toUpperCase().trim()).append("	").append(dataType).append("	");
			resultStrBuf.append(colType).append("	").append(dataLength).append("	").append("	").append(gColType).append("	");
			
		}
		
		return resultStrBuf.toString();
	}
	
}
