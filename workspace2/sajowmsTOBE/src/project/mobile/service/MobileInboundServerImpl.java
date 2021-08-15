package project.mobile.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.CommonLabel;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.service.SystemMagService;
import project.common.util.ComU;
import project.common.util.SqlUtil;

@Service("MobileInboundServerImp")
public class MobileInboundServerImpl extends BaseService {
	
	static final Logger log = LogManager.getLogger(MobileInboundServerImpl.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileService mobileServerImpl;
	
	//[MGR00] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR00(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("LANGKY", "KO");
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("RECVKY", taskky);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("PRODDT", map.getString("PRODDT"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "C2SAVE");
			
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	//[MGR03] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR03(DataMap map) throws Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("RECVKY", taskky);
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("LOTA01", row.getString("LOTA01"));
			row.put("LOTA02", row.getString("LOTA02"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA04", row.getString("LOTA04"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA07", row.getString("LOTA07"));
			row.put("LOTA08", row.getString("LOTA08"));
			row.put("LOTA09", row.getString("LOTA09"));
			row.put("LOTA10", row.getString("LOTA10"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("LOTA14", row.getString("LOTA14"));
			row.put("LOTA15", row.getString("LOTA15"));
			row.put("LOTA16", row.getString("LOTA16"));
			row.put("LOTA17", row.getString("LOTA17"));
			row.put("LOTA18", row.getString("LOTA18"));
			row.put("LOTA19", row.getString("LOTA19"));
			row.put("LOTA20", row.getString("LOTA20"));
			row.put("PTLT01", row.getString("LOTA01"));
			row.put("PTLT02", row.getString("LOTA02"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT04", row.getString("LOTA04"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT07", row.getString("LOTA07"));
			row.put("PTLT08", row.getString("LOTA08"));
			row.put("PTLT09", row.getString("LOTA09"));
			row.put("PTLT10", row.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PTLT14", row.getString("LOTA14"));
			row.put("PTLT15", row.getString("LOTA15"));
			row.put("PTLT16", row.getString("LOTA16"));
			row.put("PTLT17", row.getString("LOTA17"));
			row.put("PTLT18", row.getString("LOTA18"));
			row.put("PTLT19", row.getString("LOTA19"));
			row.put("PTLT20", row.getString("LOTA20"));
			row.put("PRODDT", map.getString("PRODDT"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("IFFLAG", "N");
			row.put("CHCKID", "D7SAVE");
			row.put("IFFLAG", "N");
			
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		if (map.getString("gridId").equals("LayerGridList")){
			result = "S_pop"; 
		} else {
			result = "S";
		}
		
		return result;
	}
	
	
	//[MGR04] SAVE 
	@Transactional(rollbackFor = Exception.class)
	
	public String saveMGR04(DataMap map) throws Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("RECVKY", taskky);
			row.put("REFDKY", row.getString("SVBELN"));
			row.put("REFDIT", row.getString("SVBELP"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("LOTA11", map.getString("LOTA11"));
			row.put("LOTA13", map.getString("LOTA13"));
			row.put("PRODDT", map.getString("PRODDT"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "C5SAVE");
			
			
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MGR05]pop  Search
	@Transactional(rollbackFor = Exception.class)
	public List searchMGR05_POP(DataMap map) throws Exception {

	map.setModuleCommand("MobileInbound", "MGR05_POP");
	List<DataMap> list = commonDao.getList(map);

	return list;
	}
		
	//[MGR05]pop  SAVE 
	@Transactional(rollbackFor = Exception.class)
	
	public String saveMGR05_POP(DataMap map) throws Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		//기존 그리드
		List<DataMap> grid = map.getList("grid");
		DataMap gridRow = grid.get(0).getMap("map");
		
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("LANGKY", "KO");
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("AREAKY", gridRow.getString("AREAKY")); //확인
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", gridRow.getString("LOCAKY"));//원그리드에서 가져온다.
			row.put("LOCATG", map.getString("LOCAKYPOP"));//팝업창 서치에서 가져온다.
			row.put("TRNUSR", row.getString("TRNUID"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("RECVKY", gridRow.getString("RECVKY")); 
			row.put("RECVIT", gridRow.getString("RECVIT")); 
			row.put("ASNDKY", gridRow.getString("ASNDKY")); 
			row.put("ASNDIT", gridRow.getString("ASNDIT")); 
			
			
			gridRow.setModuleCommand("MobileInbound", "MGR05_LOTA");
			List<DataMap> lotaList  = commonDao.getList(gridRow);
			if(lotaList.size() > 0 ){
				DataMap lotaMap = null;
				lotaMap = lotaList.get(0).getMap("map");
				map.putAll(lotaMap);
			}
			
			
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("LOTA01", map.getString("LOTA01"));
			row.put("LOTA02", map.getString("LOTA02"));
			row.put("LOTA03", map.getString("LOTA03"));
			row.put("LOTA04", map.getString("LOTA04"));
			row.put("LOTA05", map.getString("LOTA05"));
			row.put("LOTA06", map.getString("LOTA06"));
			row.put("LOTA07", map.getString("LOTA07"));
			row.put("LOTA08", map.getString("LOTA08"));
			row.put("LOTA09", map.getString("LOTA09"));
			row.put("LOTA10", map.getString("LOTA10"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", map.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("LOTA14", map.getString("LOTA14"));
			row.put("LOTA15", map.getString("LOTA15"));
			row.put("LOTA16", map.getString("LOTA16"));
			row.put("LOTA17", map.getString("LOTA17"));
			row.put("LOTA18", map.getString("LOTA18"));
			row.put("LOTA19", map.getString("LOTA19"));
			row.put("LOTA20", map.getString("LOTA20"));
			row.put("PTLT01", map.getString("LOTA01"));
			row.put("PTLT02", map.getString("LOTA02"));
			row.put("PTLT03", map.getString("LOTA03"));
			row.put("PTLT04", map.getString("LOTA04"));
			row.put("PTLT05", map.getString("LOTA05"));
			row.put("PTLT06", map.getString("LOTA06"));
			row.put("PTLT07", map.getString("LOTA07"));
			row.put("PTLT08", map.getString("LOTA08"));
			row.put("PTLT09", map.getString("LOTA09"));
			row.put("PTLT10", map.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", map.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PTLT14", map.getString("LOTA14"));
			row.put("PTLT15", map.getString("LOTA15"));
			row.put("PTLT16", map.getString("LOTA16"));
			row.put("PTLT17", map.getString("LOTA17"));
			row.put("PTLT18", map.getString("LOTA18"));
			row.put("PTLT19", map.getString("LOTA19"));
			row.put("PTLT20", map.getString("LOTA20"));
			row.put("INOQTY", row.getString("QTYWRK"));
			row.put("STOKKY", gridRow.getString("STOKKY")); 
			row.put("SEBELN", gridRow.getString("SEBELN")); 
			row.put("SEBELP", gridRow.getString("SEBELP")); 
			row.put("SVBELN", gridRow.getString("SVBELN")); 
			row.put("SPOSNR", row.getString("SPOSNR"));
			row.put("IFFLAG", "N"); //
			row.put("CHCKID", "B2SAVE");
			
//			if(row.getString("QTYWRK") > gridRow.getString("QTSIWH"))
			
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		result = "S"; 
		return result;
	}
	
	
	//[MGR06] SAVE 적치
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMGR06(DataMap map) throws SQLException,Exception {
		DataMap result = new DataMap();
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		result.put("RESULT", "F1"); 
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			String trnutg= row.getString("TRNUTG");
			String locatg= row.getString("LOCATG");
			
			row.put("LANGKY", "KO");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");

			if(!"".equals(map.getString("LOCATG").trim())&& !map.getString("LOCATG").equals(row.getString("LOCATG"))){
				locatg = map.getString("LOCATG");
			}
			
			row.put("LOCATG", locatg);
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("TRNUSR", row.getString("TRNUID"));
			row.put("TRNUTG", map.getString("TRNUID"));
			row.put("TRNUTG", trnutg);
			row.put("RECVKY", row.getString("RECVKY"));
			row.put("RECVIT", row.getString("RECVIT"));
			row.put("ASNDKY", row.getString("ASNDKY"));
			row.put("ASNDIT", row.getString("ASNDIT"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("SVBELN", row.getString("SVBELN"));
			row.put("SPOSNR", row.getString("SPOSNR"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("LOTA01", row.getString("LOTA01"));
			row.put("LOTA02", row.getString("LOTA02"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA04", row.getString("LOTA04"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA07", row.getString("LOTA07"));
			row.put("LOTA08", row.getString("LOTA08"));
			row.put("LOTA09", row.getString("LOTA09"));
			row.put("LOTA10", row.getString("LOTA10"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("LOTA14", row.getString("LOTA14"));
			row.put("LOTA15", row.getString("LOTA15"));
			row.put("PTLT01", row.getString("LOTA01"));
			row.put("PTLT02", row.getString("LOTA02"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT04", row.getString("LOTA04"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT07", row.getString("LOTA07"));
			row.put("PTLT08", row.getString("LOTA08"));
			row.put("PTLT09", row.getString("LOTA09"));
			row.put("PTLT10", row.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PTLT14", row.getString("LOTA14"));
			row.put("PTLT15", row.getString("LOTA15"));
			row.put("INOQTY", row.getString("QTYWRK"));	
			row.put("IFFLAG", "N");
			row.put("CHCKID", "B5SAVE");
			
			//TRNUTG To바코드 빈값으로 넘기면 가지고 있던 바코드로 넣어줄것 
			if(map.getString("TRNUTG").isEmpty() || "".equals( map.getString("TRNUTG").trim() )){
				row.put("TRNUTG", row.getString("TRNUSR"));
			}else{
				row.put("TRNUTG", row.getString("TRNUTG"));
			}
			
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			row.put("DOCUTY",map.getString("JOBTYP"));
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			logseq = mobileServerImpl.savePD99T(row);
		}
		result.put("RESULT", "S"); 
		return result;
	}
	
	//[MGR07] SAVE 적치잔량
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR07(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("LANGKY", "KO");
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("TRNUSR", map.getString("TRNUID"));
			row.put("TRNUTG", map.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("RECVKY", row.getString("RECVKY"));
			row.put("RECVIT", row.getString("RECVIT"));
			row.put("ASNDKY", row.getString("ASNDKY"));
			row.put("ASNDIT", row.getString("ASNDIT"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("SVBELN", row.getString("SVBELN"));
			row.put("SPOSNR", row.getString("SPOSNR"));
			row.put("TASKKY", taskky);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("LOTA01", row.getString("LOTA01"));
			row.put("LOTA02", row.getString("LOTA02"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA04", row.getString("LOTA04"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA07", row.getString("LOTA07"));
			row.put("LOTA08", row.getString("LOTA08"));
			row.put("LOTA09", row.getString("LOTA09"));
			row.put("LOTA10", row.getString("LOTA10"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("PTLT01", row.getString("LOTA01"));
			row.put("PTLT02", row.getString("LOTA02"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT04", row.getString("LOTA04"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT07", row.getString("LOTA07"));
			row.put("PTLT08", row.getString("LOTA08"));
			row.put("PTLT09", row.getString("LOTA09"));
			row.put("PTLT10", row.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "D2SAVE");
			
			
//			if(null != map.getString("TRNUTG") && !"".equals(map.getString("TRNUTG"))){
//				row.put("TRNUTG", map.getString("TRNUTG"));	
//			}else{
//				row.put("TRNUSR", row.getString("TRNUSR"));
//			}
		
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			row.put("DOCUTY",map.getString("JOBTYP"));
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MGR08] SAVE 적치완료
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR08(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String jobtyp = map.getString("JOBTYP");
		String wareky = map.getString("WAREKY");
		String locatg = map.getString("LOCATG");
		String trnutg = map.getString("TRNUTG");
		
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("WAREKY", wareky);
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", wareky);
			row.put("LOCASR", row.getString("LOCASR"));
			row.put("LOCATG", locatg);
			row.put("TRNUSR", row.getString("TRNUSR"));
			row.put("TRNUTG", trnutg);
			row.put("JOBTYP", jobtyp); 
			row.put("RECVKY", row.getString("RECVKY"));
			row.put("RECVIT", row.getString("RECVIT"));
			row.put("ASNDKY", row.getString("ASNDKY"));
			row.put("ASNDIT", row.getString("ASNDIT"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("SVBELN", row.getString("SVBELN"));
			row.put("SPOSNR", row.getString("SPOSNR"));
			row.put("TASKKY", row.getString("TASKKY"));
			row.put("TASKIT", row.getString("TASKIT"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("LOTA01", row.getString("LOTA01"));
			row.put("LOTA02", row.getString("LOTA02"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA04", row.getString("LOTA04"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA07", row.getString("LOTA07"));
			row.put("LOTA08", row.getString("LOTA08"));
			row.put("LOTA09", row.getString("LOTA09"));
			row.put("LOTA10", row.getString("LOTA10"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("LOTA14", row.getString("LOTA14"));
			row.put("LOTA15", row.getString("LOTA15"));
			row.put("LOTA16", row.getString("LOTA16"));
			row.put("LOTA17", row.getString("LOTA17"));
			row.put("LOTA18", row.getString("LOTA18"));
			row.put("LOTA19", row.getString("LOTA19"));
			row.put("LOTA20", row.getString("LOTA20"));
			row.put("PTLT01", row.getString("LOTA01"));
			row.put("PTLT02", row.getString("LOTA02"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT04", row.getString("LOTA04"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT07", row.getString("LOTA07"));
			row.put("PTLT08", row.getString("LOTA08"));
			row.put("PTLT09", row.getString("LOTA09"));
			row.put("PTLT10", row.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PTLT14", row.getString("LOTA14"));
			row.put("PTLT15", row.getString("LOTA15"));
			row.put("PTLT16", row.getString("LOTA16"));
			row.put("PTLT17", row.getString("LOTA17"));
			row.put("PTLT18", row.getString("LOTA18"));
			row.put("PTLT19", row.getString("LOTA19"));
			row.put("PTLT20", row.getString("LOTA20"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "D1SAVE");
			
//			if(null != map.getString("TRNUTG") && !"".equals(map.getString("TRNUTG"))){
//				row.put("TRNUTG", map.getString("TRNUTG"));	
//			}else{
//				row.put("TRNUSR", row.getString("TRNUSR"));
//			}

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MGR09] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR09(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("LANGKY", "KO");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("LOCATG", row.getString("LOCATG"));
			row.put("TRNUSR", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("RSNCOD", row.getString("RSNCOD"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			
			row.put("IFFLAG", "N");
			row.put("CHCKID", "C7SAVE");
		
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			row.put("LOCATG",map.getString("LOCATG"));
			row.put("DOCUTY",map.getString("JOBTYP"));
			row.put("WAREKY",map.getString("WAREKY"));
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MGR10] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR10(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("RECVKY", taskky);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("LOTA03", row.getString("LOTA03"));
			row.put("LOTA05", row.getString("LOTA05"));
			row.put("LOTA06", row.getString("LOTA06"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA12", row.getString("LOTA12"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PRODDT", map.getString("PRODDT"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "C3SAVE");
						
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}

	//[MGR02] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR02(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("PRODDT", row.getString("DOCDAT"));
			row.put("RECVKY", taskky);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("LOTA11", row.getString("LOTA11"));
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PRODDT", map.getString("PRODDT"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "A4SAVE");
						
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
//			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MGR01] SAVE 피킹완료
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR01(DataMap map) throws SQLException,Exception {
		String result = "F";
		String taskky = "";
		int logseq = 1;
		DataMap row;
		
		List<DataMap> list = map.getList("data");
		
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			if(row.getString("STATIT").equals("V")) continue;
			
			row.put("JOBTYP", map.getString("JOBTYP"));
			row.put("LANGKY", "KO");
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("TRUOKY", row.getString("UOMKEY"));
			row.put("RECVKY", taskky);
			row.put("REFDKY", row.getString("ASNDKY"));
			row.put("REFDIT", row.getString("ASNDIT"));
			row.put("REFCAT", row.getString("DOCCAT"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("PTLT01", row.getString("LOTA01"));
			row.put("PTLT02", row.getString("LOTA02"));
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT04", row.getString("LOTA04"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT07", row.getString("LOTA07"));
			row.put("PTLT08", row.getString("LOTA08"));
			row.put("PTLT09", row.getString("LOTA09"));
			row.put("PTLT10", row.getString("LOTA10"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			row.put("PTLT14", row.getString("LOTA14"));
			row.put("PTLT15", row.getString("LOTA15"));
			row.put("PTLT16", row.getString("LOTA16"));
			row.put("PTLT17", row.getString("LOTA17"));
			row.put("PTLT18", row.getString("LOTA18"));
			row.put("PTLT19", row.getString("LOTA19"));
			row.put("PTLT20", row.getString("LOTA20"));
			row.put("INOQTY", row.getString("QTYWRK"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "E2SAVE");
			
			//로케이션 체크  
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
/*	
	//[MGR01] SAVE 피킹완료 ??
	@Transactional(rollbackFor = Exception.class)
	public String saveMGR01(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
	
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			//DAS 기반데이터 생성 프로시저 콜 
			row.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP_NEW");
			map.clonSessionData(row);
			row.put("WRKFLG", "CAR");
			
			int resultChk = commonDao.update(row); //실행버튼
		
		}
		
		result = "S";
		return result;
	}*/
	
	//[MGR06] RangeSearchRS
	@Transactional(rollbackFor = Exception.class)
	public List displayMGR06(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
//		List<DataMap> gridList = map.getList("data");
		
		map.setModuleCommand("MobileInbound", "MGR06");
		List<DataMap> list = commonDao.getList(map);

//		for(DataMap data : gridList){
//			list.add(data.getMap("map"));
//		}
		
		return list;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap movingCheck(DataMap map) throws SQLException {
		StringBuffer sbChk = new StringBuffer();
 
		List<DataMap> itemList = map.getList("data");
		List<DataMap> resultList = new ArrayList();
		
		DataMap rsMap = new DataMap();
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		
		for(DataMap item : itemList){
			itemData = item.getMap("map");
			
			if(sbChk.length() > 0){
				sbChk.append(" UNION ALL \n");
			}
			sbChk.append("SELECT '").append(map.get("WAREKY")).append("' AS WAREKY,");
			sbChk.append(" '").append(map.get("LOCATG")).append("' AS LOCAKY ");
			sbChk.append(" FROM DUAL");		
		}// end for
		
		map.put("APPENDQUERY", sbChk);
		map.setModuleCommand("taskOrder", "MOVINGCHECK");
		resultList = commonDao.getList(map);
		
		if(resultList == null || resultList.size() == 0){
			rsMap.put("RESULT", "moving_Sucess");
			return rsMap;
		}
		rsMap.put("RESULT", resultList);
		return rsMap;
	}
}