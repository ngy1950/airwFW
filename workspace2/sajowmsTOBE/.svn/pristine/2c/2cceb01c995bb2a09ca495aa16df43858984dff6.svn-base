package project.http.po;

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
import project.http.util.HttpInterfaceManager;
import project.wms.service.DaerimOutboundService; 

@Service
public class POInterfaceManager extends BaseService {

	static final Logger log = LogManager.getLogger(POInterfaceManager.class.getName());

	@Autowired
	private HttpInterfaceManager httpManager;

	@Autowired
	public CommonDAO commonDao;
	
	public String serverInfo(){

		//운영 or 개발 여부를 확인한다.
		String serverInfo = "";
		DataMap map = new DataMap();
		map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
		map.put("CMCDKY", "SERVINFO");
		try{
			serverInfo = ((DataMap)commonDao.getList(map).get(0)).getString("VALUE_COL");
		}catch(Exception e){
			log.error(e.getMessage());
		}
		return serverInfo;
	}
	
	/**
	 * SAP 모듈 SD0340(출고지시) 송수신 - CMU  
	 * @param sendXml
	 * @param String svbeln, String status(30: 지시, 35:지시 취소)
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	public String SAP_SD0340(String svbeln, String status) throws SQLException, Exception{
		DataMap paramMap = new DataMap();
		paramMap.put("SVBELN", svbeln);
		paramMap.put("STATUS", status);
		
		String httpURL, sbSystem;
		if("REAL".equals(serverInfo())){ //운영
			httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
			sbSystem = InterfaceConfig.SAP_REAL_BUSINESS_SYSTEM;
		}else{ // 개발
			httpURL = InterfaceConfig.PO_TEST_ADRESS+InterfaceConfig.PO_URL_ADAPTER;;	
			sbSystem = InterfaceConfig.SAP_TEST_BUSINESS_SYSTEM;
		}
		//httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
		//sbSystem = InterfaceConfig.SAP_REAL_BUSINESS_SYSTEM;
		
		//HTTP모듈 호출
		Document document = httpManager.sendXml(paramMap, "MT_SD0340_WMS", InterfaceConfig.SAP_SD_URL, httpURL, "SD0340_WMS_SO", sbSystem, "BE", InterfaceConfig.PO_CONTENT_TYPE, null);

		//성공여부  플래그 리턴
		NodeList nList = document.getElementsByTagName("RTNVAL");
		if(nList.getLength() < 1 || nList.item(0).getChildNodes().item(0) == null){
			return "N";
		}else{
			return document.getElementsByTagName("RTNVAL").item(0).getChildNodes().item(0).getNodeValue();	
		}
	}

	
	/**
	 * TOSS 모듈 NS0090(출고지시) 송수신 - CMU  
	 * @param sendXml
	 * @param String svbeln, String status(30: 지시, 35:지시 취소)
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	public String TOSS_NS0090(String svbeln, String flag, String status) throws SQLException, Exception{
		
		DataMap paramMap = new DataMap();
		paramMap.put("SVBELN", svbeln);
		paramMap.put("STATUS", status);
		paramMap.put("FLAG", flag);
		
		String httpURL, sbSystem;
		if("REAL".equals(serverInfo())){ //운영
			httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
			sbSystem = InterfaceConfig.TOSS_REAL_BUSINESS_SYSTEM;
		}else{ // 개발
			httpURL = InterfaceConfig.PO_TEST_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
			sbSystem = InterfaceConfig.TOSS_TEST_BUSINESS_SYSTEM;
		}
		//httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
		//sbSystem = InterfaceConfig.TOSS_REAL_BUSINESS_SYSTEM;
		
		//HTTP모듈 호출
		Document document =  httpManager.sendXml(paramMap, "MT_NS0090_WMS", InterfaceConfig.TOSS_SD_URL, httpURL, "NS0090_WMS_SO", sbSystem, "BE", InterfaceConfig.PO_CONTENT_TYPE, null);

		//성공여부  플래그 리턴
		NodeList nList = document.getElementsByTagName("RTNVAL");
		if(nList.getLength() < 1 || nList.item(0).getChildNodes().item(0) == null){
			return "N";
		}else{
			return document.getElementsByTagName("RTNVAL").item(0).getChildNodes().item(0).getNodeValue();	
		}
		
	}

	
	/**
	 * SAP - PP 모듈 PP0100(세트해체) 송수신 - CMU  
	 * @param sendXml
	 * @param String sadjky, String wareky,String skukey, String date(작업지시일 DOCDAT)
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	public DataMap SAP_PP0100(String sadjky, String wareky, String skukey, String date) throws SQLException, Exception{
		
		StringBuffer paramXMLStr = new StringBuffer();
		
		paramXMLStr.append("<MINKU>");
		paramXMLStr.append("   <SADJKY>").append(sadjky).append("</SADJKY>");
		paramXMLStr.append("   <WAREKY>").append(wareky).append("</WAREKY>");
		paramXMLStr.append("   <SKUKEY>").append(skukey).append("</SKUKEY>");
		paramXMLStr.append("   <DOCDAT>").append(date).append("</DOCDAT>");
		paramXMLStr.append("</MINKU>");
		
		String httpURL, sbSystem;
		//세트조립은 운영으로 고정(기존소스 따라감)개발로쏘면 에러남 이유는 불명 (실제 소스 코딩도 운영만 보게 되어있음)
		//httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
		//sbSystem = InterfaceConfig.TOSS_REAL_BUSINESS_SYSTEM;
		if("REAL".equals(serverInfo())){ //운영
			httpURL = InterfaceConfig.PO_REAL_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
			sbSystem = InterfaceConfig.TOSS_REAL_BUSINESS_SYSTEM;
		}
		else{ // 개발
			httpURL = InterfaceConfig.PO_TEST_ADRESS+InterfaceConfig.PO_URL_ADAPTER;	
			sbSystem = InterfaceConfig.TOSS_TEST_BUSINESS_SYSTEM;
		}
		
		//HTTP모듈 호출
		Document document =  httpManager.sendXml(null, "MT_PP0100_WMS", InterfaceConfig.SAP_PP_URL, httpURL, "PP0100_WMS_SO", sbSystem, "BE", InterfaceConfig.PO_CONTENT_TYPE, paramXMLStr.toString());
		DataMap rtnMap = new DataMap();
		rtnMap.put("SADJKY", document.getElementsByTagName("SADJKY").item(0).getChildNodes().item(0).getNodeValue());
		rtnMap.put("SDOCNO", document.getElementsByTagName("SDOCNO").item(0).getChildNodes().item(0).getNodeValue());
		rtnMap.put("RTNSTS", document.getElementsByTagName("RTNSTS").item(0).getChildNodes().item(0).getNodeValue());
		rtnMap.put("RTNMSG", document.getElementsByTagName("RTNMSG").item(0).getChildNodes().item(0).getNodeValue());
		return rtnMap;
	}
	
}
