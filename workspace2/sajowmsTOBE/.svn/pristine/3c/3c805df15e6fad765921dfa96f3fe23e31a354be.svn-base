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
import project.common.util.SqlUtil;

@Service("mobileInventoryService")
public class MobileInventoryService extends BaseService {
	
	static final Logger log = LogManager.getLogger(MobileInventoryService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileService mobileServerImpl;
	
	//[MSD00] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMSD00(DataMap map) throws SQLException,Exception {
		DataMap result = new DataMap();
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		result.put("RESULT",  "F");
		
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			String waretg = row.getString("WAREKY");
			String locatg = row.getString("LOCAKY");
			String trnutg = row.getString("TRNUID");

			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("LOGSEQ", logseq);
			
			row.put("WARETG", waretg);
			row.put("LOCATG", locatg);
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("RECVKY", row.getString("RECVKY"));
			row.put("RECVIT", row.getString("RECVIT"));
			row.put("ASNDKY", row.getString("ASNDKY"));
			row.put("ASNDIT", row.getString("ASNDIT"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("SMANDT", row.getString("SMANDT"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("SVBELN", row.getString("SVBELN"));
			row.put("SPOSNR", row.getString("SPOSNR"));
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
			
			if(!map.getString("WAREKY").trim().equals("") && !map.getString("WAREKY").equals(row.getString("WAREKY"))){
				waretg = map.getString("WAREKY");
			}
			if(!map.getString("LOCATG").trim().equals("") && !map.getString("LOCATG").equals(row.getString("LOCAKY"))){
				locatg = map.getString("LOCATG");
			}
			if(!map.getString("TRNUTG").trim().equals("") && !map.getString("TRNUTG").equals(row.getString("TRNUTG"))){
				trnutg = map.getString("TRNUTG");
			}
			
			row.put("LOCATG", locatg);
			row.put("TRNUTG", trnutg);
			row.put("IFFLAG", "N");
			row.put("CHCKID", "M1SAVE");

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result.put("RESULT",  "S");
		
		return result;
	}
	
	//[MSD06] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMSD06(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("JOBSTS", "E");
			row.put("TASKIT", row.getString("PHYIIT"));
			row.put("TASKKY", row.getString("PHYIKY"));
			row.put("JOBTYP", map.getString("JOBTYP"));
//			row.put("QTYPDA", row.getInt("QTYWRK"));
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", row.getString("LOCATG"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("LOCASR", row.getInt("LOCAKY"));
			row.put("TRNUTG", row.getInt("TRNUID"));
			 
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
			
			if(null != map.getString("TRNUTG") && !"".equals(map.getString("TRNUTG"))){
				row.put("TRNUTG", map.getString("TRNUTG"));	
			}else{
				row.put("TRNUSR", row.getString("TRNUSR"));
			}
			row.put("IFFLAG", "N");
			row.put("CHCKID", "O1SAVE");
			
			// PHYDI 존재여부 체크
			row.setModuleCommand("MobileInventory", "PHYDI_VALIDATION");
			DataMap check = commonDao.getMap(row);
			if(check.getInt("RESULT") < 1){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0042",new String[]{}));
			}

			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	
	//[MSD01] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMSD01(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			row.put("LANGKY", "KO");
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("LOGSEQ", logseq);
			row.put("AREAKY", row.get("AREAKY"));
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", row.getString("PHYIKY"));
			row.put("TASKIT", row.getString("PHYIIT"));
			row.put("OWNRKY", map.getString("OWNRKY")); 
			row.put("SKUKEY", row.getString("SKUKEY")); 
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
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "P1SAVE");
		
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MSD02] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMSD02(DataMap map) throws SQLException,Exception {
	
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
			row.put("AREAKY", row.get("AREAKY"));
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("LOCATG", row.getString("LOCAKY"));
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("TRAREA", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);//
			row.put("OWNRKY", map.getString("OWNRKY")); 
			row.put("SKUKEY", row.getString("SKUKEY")); 
			
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
			
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "P5SAVE");
						
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
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