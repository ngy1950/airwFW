package project.http.config;

/**
 * 2020-12-30 Interface 상수  - CMU
 */
public class InterfaceConfig {
	//PO Interface
	public final static String PO_REAL_ADRESS= "http://spopap.sajo.co.kr:50500/";
	public final static String PO_TEST_ADRESS = "http://10.11.1.61:50300/";
	public final static String PO_URL_ADAPTER = "HttpAdapter/HttpMessageServlet";
	public final static String PO_USER_ID = "POAPPL_WMS";
	public final static String PO_USER_PWD = "Sajo2@16!";
	public final static String PO_CONTENT_TYPE = "text/xml;charset=utf-8";
	
	//SAP Interface
	public final static String SAP_REAL_BUSINESS_SYSTEM = "BS_WMS_P";
	public final static String SAP_TEST_BUSINESS_SYSTEM = "BS_WMS_D";
	public final static String SAP_SD_URL = "http://www.sajo.co.kr/SD/WMS";
	public final static String SAP_PP_URL = "http://www.sajo.co.kr/PP/WMS";
	
	//TOSS Interface
	public final static String TOSS_REAL_BUSINESS_SYSTEM = "BS_WMS_P";
	public final static String TOSS_TEST_BUSINESS_SYSTEM = "BS_WMS_D";
	public final static String TOSS_SD_URL = "http://www.sajo.co.kr/NS";
}