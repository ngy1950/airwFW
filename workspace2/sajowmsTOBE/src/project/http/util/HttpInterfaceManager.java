package project.http.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.sql.SQLException;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.InputStreamRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.util.HttpURLConnection;
import org.apache.http.client.methods.HttpPost;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.sun.xml.bind.marshaller.NamespacePrefixMapper;

import project.http.config.InterfaceConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.wms.service.DaerimOutboundService; 

@Service
public class HttpInterfaceManager  extends BaseService{

	static final Logger log = LogManager.getLogger(HttpInterfaceManager.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	/**
	 * HTTP 송수신 모듈 - CMU
	 * @param sendXml
	 * @param DataMap paramMap, String module, String xmlURL, String nameSpace, String httpURL, String sendInterface, String sbSystem, String QOS, String contentType
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	public Document sendXml(DataMap paramMap, String module, String xmlURL, String httpURL, String sendInterface, String sbSystem, String QOS, String contentType,String paramXml) throws SQLException, Exception{

		//1. 연결 인터페이스 정보 상세 정보는 호출부에서 DataMap에 세팅한다. ------------------------------------------------//
		
		// 전송할 XML String데이터생성 
		StringBuffer sPayloadXML = new StringBuffer();

		sPayloadXML.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		sPayloadXML.append("<ns0:"+module+" xmlns:ns0=\""+xmlURL+"\">");
		
		
		//파라미터 리스트를 저장한다. 
		if(null == paramXml || "".equals(paramXml)){ //파라미터 XML String이 넘어오지 않을 경우
			Iterator<String> keys = paramMap.keySet().iterator();
			while (keys.hasNext()){
				String key = keys.next();
				sPayloadXML.append("   <"+key+">" + paramMap.get(key) + "</"+key+">");
			} 			
		}else{
			sPayloadXML.append(paramXml);
		}
		
		
		sPayloadXML.append("</ns0:"+module+">");
		
		
		
		
		log.debug(sPayloadXML.toString());
		
		try {
				//2. 인터페이스 HTTP 연결 URL 설정--------------------------------------//
				//String sIEURL = "http://" + sHost + "/" + InterfaceConfig.PO_URL_ADAPTER;
				String sIEURL = httpURL;
				sIEURL += "?interfaceNamespace="+xmlURL;
				sIEURL += "&interface="+sendInterface;
				sIEURL += "&senderService="+sbSystem;
				sIEURL += "&qos="+QOS;
				
				//3. HTTP 연결 설정 --------------------------------------------------//
				//create PostMethod object
				log.debug(sIEURL);
				PostMethod oPost = new PostMethod(sIEURL);//전송 URL 셋팅 
				//----------------------- 접근 권한 설정 -------------------------------//
				
				String sAuthInfo = InterfaceConfig.PO_USER_ID + ":" + InterfaceConfig.PO_USER_PWD;
				byte[] encodeByte = org.apache.commons.codec.binary.Base64.encodeBase64(sAuthInfo.getBytes("utf-8"));
				String sAuthEncoding = new String(encodeByte);
				oPost.setRequestHeader("Authorization", "Basic " + sAuthEncoding);
				//----------------------- 접근 권한 설정 -------------------------------//
				
				//전송 Data 설정
				InputStream inputStream = new ByteArrayInputStream(sPayloadXML.toString().getBytes("utf-8"));
				oPost.setRequestBody(inputStream);
				//oPost.setRequestHeader("Content-Type",InterfaceConfig.PO_CONTENT_TYPE);
				oPost.setRequestHeader("Content-Type",contentType);
				HttpClient oHttpClient = new HttpClient();
				

				log.debug(sIEURL);
				HttpPost httpPost = null;
				httpPost = new HttpPost(sIEURL); //전송 URL셋팅
				
				
				//---------------------- HTTP 전송 및 결과 확인 ---------------------------//
				String sResponse = "";
				try{
					int iHTTPResult = oHttpClient.executeMethod(oPost);
					
					if(iHTTPResult != HttpURLConnection.HTTP_OK && iHTTPResult != HttpURLConnection.HTTP_ACCEPTED){
						throw new Exception(commonService.getMessageParam("KO", "VALID_M0009",new String[]{" ["+iHTTPResult+" ERROR] "+sIEURL + " " + sResponse}));
					}

					sResponse = oPost.getResponseBodyAsString();
				}catch(Exception e){
					e.printStackTrace();
					log.debug("Exception="+e.toString());
				}finally{
					oPost.releaseConnection();
				}
				

				
				// 인코딩 깨지는놈 있으면 돌려볼것
				//String[] ary = {"euc-kr","utf-8","iso-8859-1","ksc5601","x-windows-949"};
                //
				//for( int i =0 ; i < ary.length; i++){
                //
				//	for(int j=0; j < ary.length ; j++){
                //
				//		if( i != j){
				//			log.debug( ary[i]+"=>"+ ary[j]+ " \r\n ==> " +new String(sResponse.getBytes(ary[i]),ary[j]));
                //
				//		}
                //
				//	}
				//}

				//POP만 인코딩이 달라서 강제 보정
				if("MT_PP0100_WMS".equals(module)){
					sResponse = new String(sResponse.getBytes("iso-8859-1"),"utf-8");
				}
				
				log.debug(sResponse);
				
				//성공플래그 리턴
				Document document = parseXML(sResponse); 
				return document;
				
		}catch(Exception e){
			throw new Exception(commonService.getMessageParam("KO", "VALID_M0009",new String[]{e.getMessage()}));
		}finally{

		}
	}

	
	//XML을 파싱한다.
	public static Document parseXML(String xml) throws Exception{
        DocumentBuilderFactory objDocumentBuilderFactory = null;
        DocumentBuilder objDocumentBuilder = null;
        Document doc = null;
        try{
            objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
            objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();
            doc = objDocumentBuilder.parse(new InputSource(new StringReader(xml)));
        }catch(Exception ex){
            throw ex;
        }
        return doc;
	}
}
