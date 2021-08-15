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

@Service("mobileOutboundService")
public class MobileOutboundServerImpl extends BaseService {
	
	static final Logger log = LogManager.getLogger(MobileOutboundServerImpl.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileService mobileServerImpl;
	
	//[MSD00] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMSD00(DataMap map) throws SQLException,Exception {
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

			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCATG", map.getString("LOCATG"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			if(null != map.getString("TRNUTG") && !"".equals(map.getString("TRNUTG"))){
				row.put("TRNUTG", map.getString("TRNUTG"));	
			}else{
				row.put("TRNUSR", row.getString("TRNUSR"));
			}
			row.put("IFFLAG", "N");
			row.put("CHCKID", "M1SAVE");

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MDL02POP] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL02POP(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		taskky = list.get(0).getMap("map").getString("TASKKY").trim();
		
		/* 할당되어 있지 않다면 신규 taskky 생성 */
		if(taskky.equals("") ){
			map.put("DOCUTY" ,map.getString("JOBTYP"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			taskky = commonDao.getMap(map).getString("DOCNUM");	
			
			map.put("JOBTYP", "210C");
			
		}else{
			/* 할당되어 있다면 기존 taskky 사용 */
			map.put("JOBTYP", "210U");
		}

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("TASKKY", taskky);
			row.put("RECVKY", taskky);
			row.put("LOGSEQ", logseq);
			row.put("LOCATG", row.getString("LOCAKY"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("RECVIT", map.getString("TASKIT"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("WARETG", map.getString("WAREKY"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("SKUKEY", map.getString("SKUKEY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SHPOKY", map.getString("SHPOKY"));
			row.put("SHPOIT", map.getString("SHPOIT"));
					
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
			row.put("CHCKID", "F3SAVE");

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		
		return result;
	}
	
	//[MDL02POP] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String deleteMDL02POP(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		taskky = list.get(0).getMap("map").getString("TASKKY").trim();

		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("TASKKY", taskky);
			row.put("RECVKY", taskky);
			row.put("LOGSEQ", logseq);
			row.put("LOCATG", row.getString("LOCAKY"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("RECVIT", map.getString("TASKIT"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("WARETG", map.getString("WAREKY"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("SKUKEY", map.getString("SKUKEY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SHPOKY", map.getString("SHPOKY"));
			row.put("SHPOIT", map.getString("SHPOIT"));
			
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
			row.put("CHCKID", "F3SAVE");

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		
		return result;
	}
	
	//[MDL03] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL03(DataMap map) throws SQLException,Exception {
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
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", row.getString("LOCASR"));
			row.put("LOCATG", row.getString("LOCATG"));
			row.put("TRNUSR", row.getString("TRNUSR"));
			row.put("TRNUTG", row.getString("TRNUTG"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("RECVKY", row.getString("TASKKY")); 
			row.put("RECVIT", row.getString("TASKIT")); 
			row.put("ASNDKY", row.getString("SHPOKY")); 
			row.put("ASNDIT", row.getString("SHPOIT")); 
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
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "G1SAVE");
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MDL04] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL04(DataMap map) throws SQLException,Exception {	
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
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("LOCATG", row.getString("CARNUM"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", row.getString("GRPOKY")); 
			row.put("TASKIT", row.getString("GRPOIT")); 
			row.put("OWNRKY", map.getString("OWNRKY")); 
			row.put("LOTA13", row.getString("LOTA13"));
			row.put("SKUKEY", row.getString("SKUKEY")); 
			
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "G2SAVE");
					
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
    //[MDL06] SAVE 
    @Transactional(rollbackFor = Exception.class)
    public String saveMDL06(DataMap map) throws SQLException,Exception {
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
            row.put("INOQTY", row.getInt("QTYWRK"));
            row.put("LOGSEQ", logseq);
            row.put("JOBSTS", "E");
            row.put("IFFLAG", "N");
            row.put("CHCKID", "G4SAVE");
            row.put("IFFLAG", "N");
            row.put("TASKKY", row.getString("SSORNU")); 
			row.put("TASKIT", row.getString("SSORIT")); 
            
//          //로케이션 체크  
//          row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
//          DataMap validMap = commonDao.getMap(row);
//          if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
            
            logseq = mobileServerImpl.savePD99T(row);
        }
        
        result = "S"; 
        
        return result;
    }	
	
	//[MSD00] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMTO11(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("TRAREA", row.getString("TRNUTG"));
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("TRNUTG", row.get("TRNUTG"));
			row.put("TRAREA", row.get("TRNUTG"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "M1SAVE");
			
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

			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}

	
	//[MDL00] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL00(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
/*		map.put("DOCUTY" ,map.getString("JOBTYP"));
        map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
        taskky = commonDao.getMap(map).getString("DOCNUM");*/
        
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("IFFLAG", "N");
			row.put("CHCKID", "G5SAVE");
			row.put("TASKKY", map.getString("TASKKY"));			
			row.put("LOGSEQ", logseq);
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("WARETG", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("JOBTYP", map.getString("JOBTYP"));
			
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
			
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MDL05] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL05(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("LOCASR", row.getString("LOCAKY"));
			row.put("LOCATG", row.getString("CARNUM"));
			row.put("TASKKY", row.getString("SDIFKY"));
			row.put("TASKIT", row.getString("SDIFIT"));
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
			row.put("CHCKID", "G4SAVE");
			
			if(null != map.getString("TRNUTG") && !"".equals(map.getString("TRNUTG"))){
				row.put("TRNUTG", map.getString("TRNUTG"));	
			}else{
				row.put("TRNUSR", row.getString("TRNUSR"));
			}
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MDL07POP] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL07POP(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("SHPOKY", row.getString("SHPOKY"));
			row.put("SHPOIT", row.getString("SHPOIT"));
			row.put("SKUKEY", row.getString("SKUKEY"));
			row.put("STOKKY", row.getString("STOKKY"));
			row.put("SVBELN", row.getString("SVBELN"));
			row.put("SPOSNR", row.getString("SPOSNR"));
			row.put("INOQTY", row.getInt("QTYWRK"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "H6SAVE");
						
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S";
		
		return result;
	}
	
	
	//[MDL08] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL08(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("LANGKY", "KO");
			row.put("JOBSTS", "E");
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("LOGSEQ", logseq);
			row.put("WARETG", map.getString("WAREKY"));
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("LOTA01", row.getString("CARNUM")); //차량번호
			row.put("LOTA02", row.getString("SHIPSQ")); //출발정보
			row.put("LOTA03", row.getString("CARDAT")); //배송일자
			row.put("LOTA10", map.getString("LOTA10")); //SYSDATE
			row.put("INOQTY", 0);
			
			row.put("IFFLAG", "N");
			row.put("CHCKID", "K2SAVE");
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S";
		
		return result;
	}
	
	//[MDL09] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL09(DataMap map) throws SQLException,Exception {
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
			row.put("JOBSTS", "E");
			row.put("WARETG", map.getString("WAREKY"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("SHPOKY", row.getString("SHPOKY")); 
			row.put("SHPOIT", row.getString("SHPOIT")); 
			row.put("OWNRKY", map.getString("OWNRKY")); 
			row.put("SKUKEY", row.getString("SKUKEY")); 
			row.put("INOQTY", row.get("QTSHPD"));
			row.put("SVBELN", row.get("SVBELN"));
			row.put("SPOSNR", row.get("SPOSNR"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "K1SAVE");
		
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MTO02] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMTO02(DataMap map) throws SQLException,Exception {
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
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
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
			row.put("CHCKID", "I2SAVE");
		
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			row.put("LOCATG",map.getString("LOCATG"));
			row.put("DOCUTY",map.getString("JOBTYP"));
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			logseq = mobileServerImpl.savePD99T(row);
		}
		result = "S"; 
		return result;
	}
	

	//[MTO03] SAVE 검색조건 저장 for문 x
	@Transactional(rollbackFor = Exception.class)
	public String saveMTO03(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		DataMap hrow = new DataMap();
		
		List<DataMap> list = map.getList("data");
	
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");

		//아이템 저장 시작
		row = list.get(0).getMap("map");
		map.clonSessionData(row);
		
		row.put("LANGKY", "KO");
		row.put("WAREKY", map.getString("WAREKY"));
		row.put("OWNRKY", map.getString("OWNRKY"));
		row.put("LOGSEQ", logseq);
		row.put("JOBSTS", "E");
//		row.put("WARETG", map.getString("WAREKY"));
		row.put("JOBTYP", map.getString("JOBTYP")); 
		row.put("TASKKY", taskky);
		row.put("LOCASR", row.getString("LOCAKY"));
		row.put("LOCATG", "SETLOC"); //고정
		row.put("TRNUTG", row.getString("TRNUID")); //입력창 TO팔렛트 
		row.put("SKUKEY", row.getString("PACKID")); //skukey -> packid로 넘기기 
		row.put("STOKKY", row.getString("STOKKY"));
		row.put("INOQTY", map.getInt("INOQTY"));
		row.put("LOTA06", 00);
		row.put("LOTA11", row.getString("LOTA11"));
		row.put("LOTA13", row.getString("LOTA13"));
		row.put("PTLT06", 00);
		row.put("PTLT11", row.getString("LOTA11"));
		row.put("PTLT13", row.getString("LOTA13"));
		row.put("SVBELN", row.getString("SVBELN"));
		row.put("SPOSNR", row.getString("SPOSNR"));
		row.put("IFFLAG", "N");
		row.put("CHCKID", "N1SAVE");
		
		//로케이션 체크 
		row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
		row.put("DOCUTY",map.getString("JOBTYP"));
		DataMap validMap = commonDao.getMap(row);
		if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
		logseq = mobileServerImpl.savePD99T(row);
		
		result = "S"; 
		return result;
	}
	
	
	//[MTO04] pop SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMTO04POP(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap hrow = new DataMap();
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		DataMap row = list.get(0).getMap("map");
		
		map.put("DOCUTY" ,map.getString("JOBTYP"));
		map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
		taskky = commonDao.getMap(map).getString("DOCNUM");
		
		// 검색조건에 있는 아이템 저장
		 
		map.clonSessionData(hrow);
				
		hrow.put("LANGKY", "KO");
		hrow.put("WAREKY", map.getString("WAREKY"));
		hrow.put("OWNRKY", map.getString("OWNRKY"));
		hrow.put("LOGSEQ", logseq);
		hrow.put("JOBSTS", "E");
		hrow.put("JOBTYP", map.getString("JOBTYP")); 
		hrow.put("TASKKY", taskky);
		hrow.put("LOCASR", "SETLOC"); //고정
		hrow.put("LOCATG", "SETLOC"); //고정
		hrow.put("TRNUTG", row.getString("TRNUID"));
		hrow.put("SKUKEY", row.getString("PACKID"));
		hrow.put("STOKKY", map.getString("STOKKY"));
		hrow.put("INOQTY", map.getInt("INOQTY"));
		hrow.put("TRNQTY", map.getInt("TRNQTY"));
		hrow.put("LOTA06", 00);
		hrow.put("LOTA11", row.getString("LOTA11"));
		hrow.put("LOTA13", row.getString("LOTA13"));
		hrow.put("PTLT06", 00);
		hrow.put("PTLT11", row.getString("LOTA11"));
		hrow.put("PTLT13", row.getString("LOTA13"));
		hrow.put("SVBELN", row.getString("SVBELN"));
		hrow.put("SPOSNR", row.getString("SPOSNR"));
		hrow.put("IFFLAG", "N");
		hrow.put("CHCKID", "N3SAVE");
		
		logseq = mobileServerImpl.savePD99T(hrow);
		
		//그리드 아이템 저장 
		for(DataMap data : list){
			DataMap grow = data.getMap("map");
			map.clonSessionData(grow);
			
			grow.put("LANGKY", "KO");
			grow.put("WAREKY", map.getString("WAREKY"));
			grow.put("OWNRKY", map.getString("OWNRKY"));
			grow.put("LOGSEQ", logseq);
			grow.put("JOBSTS", "E");
			grow.put("JOBTYP", map.getString("JOBTYP")); 
			grow.put("TASKKY", taskky);
			grow.put("LOCASR", "SETLOC"); //고정
			grow.put("LOCATG", "SETLOC"); //고정
			grow.put("TRNUTG", grow.getString("TRNUID"));
			grow.put("SKUKEY", grow.getString("SKUKEY"));
			grow.put("STOKKY", map.getString("STOKKY"));
			grow.put("INOQTY", map.getInt("INOQTY"));
			grow.put("TRNQTY", map.getInt("TRNQTY"));
			grow.put("LOTA06", 00);
			grow.put("LOTA11", grow.getString("LOTA11"));
			grow.put("LOTA13", grow.getString("LOTA13"));
			grow.put("PTLT06", 00);
			grow.put("PTLT11", grow.getString("LOTA11"));
			grow.put("PTLT13", grow.getString("LOTA13"));
			grow.put("SVBELN", grow.getString("SVBELN"));
			grow.put("SPOSNR", grow.getString("SPOSNR"));
			grow.put("IFFLAG", "N");
			grow.put("CHCKID", "N3SAVE");
		
			//로케이션 체크 
			grow.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			grow.put("LOCATG",map.getString("LOCATG"));
			grow.put("DOCUTY",map.getString("JOBTYP"));
			DataMap validMap = commonDao.getMap(grow);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			logseq = mobileServerImpl.savePD99T(grow);
		}

		result = "S"; 
		
		return result;
	}
		
	//[MTO05] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveMTO05(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		String taskky = "";
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		
		map.put("DOCUTY" ,map.getString("JOBTYPDOC"));
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
			row.put("TRNUTG", row.getString("TRNUID"));
			row.put("TRAREA", map.getString("TRNUTG"));
			row.put("JOBTYP", map.getString("JOBTYP")); 
			row.put("TASKKY", taskky);
			row.put("ASNDKY", row.getString("ASNDKY"));
			row.put("ASNDIT", row.getString("ASNDIT"));
			row.put("REFDKY", row.getString("ASNDKY"));
			row.put("REFDIT", row.getString("ASNDIT"));
			row.put("REFCAT", row.getString("DOCCAT"));
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
			row.put("LOTA11", map.getString("LOTA11"));
			row.put("LOTA12", map.getString("LOTA12"));
			row.put("LOTA13", map.getString("LOTA13"));
			row.put("LOTA14", map.getString("LOTA14"));
			row.put("LOTA15", map.getString("LOTA15"));
			row.put("LOTA16", map.getString("LOTA16"));
			row.put("LOTA17", map.getString("LOTA17"));
			row.put("LOTA18", map.getString("LOTA18"));
			row.put("LOTA19", map.getString("LOTA19"));
			row.put("LOTA20", map.getString("LOTA20"));
			row.put("INOQTY", row.get("QTYWRK"));
			row.put("SMANDT", row.getString("SMANDT"));
			row.put("SEBELN", row.getString("SEBELN"));
			row.put("SEBELP", row.getString("SEBELP"));
			row.put("IFFLAG", "N");
			row.put("CHCKID", "I1SAVE");
			
			//로케이션 체크 
			row.setModuleCommand("MobileInventory", "MSD00_VALDATION");
			DataMap validMap = commonDao.getMap(row);
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
			
			logseq = mobileServerImpl.savePD99T(row);
		}
		
		result = "S"; 
		
		return result;
	}
	
	//[MDL11] SAVE 피킹완료
	@Transactional(rollbackFor = Exception.class)
	public String saveMDL11(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		
		int logseq = 1;
		
		List<DataMap> list = map.getList("data");
		

		//중복건이 들어올 수 있으므로 먼저 중복건을 모두 삭제한다.
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.setModuleCommand("MobileOutbound", "MDL11");
			commonDao.delete(row); 
		}
	
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);

			row.setModuleCommand("MobileOutbound", "MDL11");
			commonDao.insert(row); 
		}
		
		result = "S";
		return result;
	}
}