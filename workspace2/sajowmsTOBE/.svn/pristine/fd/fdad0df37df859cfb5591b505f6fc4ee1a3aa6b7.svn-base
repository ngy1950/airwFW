package ezgen;

import java.io.*;
import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import java.util.Enumeration;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ApplicationObjectSupport;

import project.common.util.ComU;

import elsoft.eftpmanager.*;

//주의 eftpmanager.java 이름을 다른이름.java로 변경사용시 public class 다른이름 extends HttpServlet
public class eftpmanager extends HttpServlet
{
	private static Logger log = Logger.getLogger(eftpmanager.class);
	
	///Encoding을 위한 멤버 --------------------------------------------------------------------------
	public final static int IN_NONE = 0;
	public final static int IN_ENG_TO_KOR = 1;
	public final static int IN_KOR_TO_ENG = 2; //보통 DB NLS가 영문일때
	
	public final static int OUT_NONE = 0;
	public final static int OUT_TO_KOR = 1;
	public final static int OUT_ENG_TO_KOR = 2;	//보통 DB NLS가 영문일때
	
	static final String m_stEncoding = "KSC5601"; //Unicode를 Encoding 문자(KSC5601,MS949,...)로 변환합니다.
	static final int m_nInEncoding = IN_NONE;			//Input String 변환형식.
	static final int m_nOutEncoding = OUT_NONE;		//Output Stringf 변환 형식.
	
	static String m_root_path = "";
	
	//EftpFileMng 생성 합니다.(필수 사항) -----------------------------------------------------------
	private EftpFileMng m_eftpmng = new EftpFileMng();
	
	//HttpServlet 기본 함수로 Servlet POST 요청시 호출되는 함수입니다. ------------------------------
	public void doPost(HttpServletRequest request, HttpServletResponse response)
        	throws ServletException, IOException
	{
		response.setContentType("text/html;charset=euc-kr");
		
		m_eftpmng.doPost(request,response);	//EftpFileMng를 실행합니다.
	}
	
	//HttpServlet 기본 함수로 Servlet GET 요청시 호출되는 함수입니다. -------------------------------
	public void doGet(HttpServletRequest request, HttpServletResponse response)
        	throws ServletException, IOException
	{
		response.setContentType("text/html;charset=euc-kr");

		//m_eftpmng.getStatus(request,response);	//EftpFileMng의 현재 정보를 보여줍니다.
	}
	
	//Servlet 초기화시 호출되는 함수입니다. ---------------------------------------------------------
	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);
		
		if(m_root_path.equals("")){
			try {
				String rootPath = this.getClass().getClassLoader().getResource("path.properties").getPath();
				rootPath = rootPath.substring(0, rootPath.indexOf("WEB-INF"));
				
				m_root_path = rootPath+"common/include/ocx/";
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("프린트 경로를  가져오는데 실패하였습니다.");
			}
		}
		
		
		m_eftpmng.UseEncoding(m_nInEncoding,m_nOutEncoding,m_stEncoding);				//Encoding 문자를 사용할 경우 지정합니다.
		
		//m_eftpmng.setMaxThreads(int nMaxThreads,int nTimeOut);								//File Pool nMaxThreads:동시 접속 사용자 수, nTimeOut:제한시간(단위:초)
		
		//m_eftpmng.RootPathAndSeparator("<FullPath>","<DirectorySeparator>");	//<FullPath>는 마지막 디렉터리 구분자를 포함합니다.
		m_eftpmng.RootPathAndSeparator(m_root_path,"/");	
	}
	
	//Servlet 종료시 호출되는 함수로 작업 중인 모든 작업을 취소 합니다. -----------------------------
 	public void destroy()
	{
		super.destroy();
	}
	
}