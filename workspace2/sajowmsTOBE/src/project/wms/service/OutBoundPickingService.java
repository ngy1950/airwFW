package project.wms.service;

import java.math.BigDecimal;
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
import project.common.util.StringUtil;

@Service("OutBoundPickingService")
public class OutBoundPickingService extends BaseService {
	
	static final Logger log = LogManager.getLogger(OutBoundPickingService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	

			
	//DL42
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDL42(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
			
		try {
			
			//헤드 아이템 데이터 가져오
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null;
			DataMap updatePoitMap = null;
			String grprl = map.getString("GRPRL");
			DataMap dMap = new DataMap();
			
			
			for(DataMap tasdh : headList){
				int grpoit = 0;
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				tasdh.put("GRPRL", grprl);
				

				String grpoky = "";
				if(tasdh.getString("GRPOKY").trim().isEmpty() ||tasdh.getString("GRPOKY").trim().equals("")){
					// 피킹그룹키
					map.setModuleCommand("OutBoundPicking", "DL42_GRPOKY");
					grpoky = commonDao.getMap(map).getString("GROUPKY");
				}else {
					grpoky = tasdh.getString("GRPOKY");
				}
				
				
				
				//아이템 조회  구버전 /신버전 큰 차이
				dMap = (DataMap)map.clone();
				dMap.putAll(tasdh);
				dMap.setModuleCommand("OutBoundPicking", "DL42_ITEM");
				itemList = commonDao.getList(dMap);
				
				for(DataMap tasdi : itemList){
					tasdi.put("GRPRL", grprl);
					tasdi.setModuleCommand("OutBoundPicking", "DL42_PICKINGLIST");
					updateList = commonDao.getList(tasdi);
					tasdi.setModuleCommand("OutBoundPicking", "DL42_GRPOIT");
					updatePoitMap = commonDao.getMap(tasdi);

					if(updateList.size() < 1){
					//에러 메시지 출력 구현
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
						throw new Exception("* 피킹 그룹핑 처리할 데이터가 없습니다. *");
					}

					//GRPOIT 값 가져오기 
					if(updatePoitMap.getString("GRPOIT").equals("FAIL")){
						grpoit += 10;						
					}else {
						if(tasdi.getString("GRPOIT").trim().isEmpty() || tasdi.getString("GRPOIT").trim().equals(""))
							grpoit = Integer.parseInt(updatePoitMap.getString("GRPOIT"))+10;
						else
							grpoit = Integer.parseInt(tasdi.getString("GRPOIT"));
					}	

					for(DataMap updateTasdi : updateList){
						updateTasdi.put("GRPOIT",(StringUtil.leftPad(String.valueOf(grpoit), "0", 6)));						
						updateTasdi.put("GRPOKY",grpoky);
						updateTasdi.setModuleCommand("OutBoundPicking", "DL42_GROUPING");
						//commonDao.update(updateTasdi);
						resultChk = (int)commonDao.update(updateTasdi);
						
					}
					if(resultChk > 0){
						rsMap.put("RESULT", "OK");
					}
				}
				
			}
		}
	 catch (Exception e) {
		 throw new Exception( ComU.getLastMsg(e.getMessage()) );
	}
		return rsMap;
	}
	
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap delGroupDL42(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {
			// 피킹그룹키
			String grpoky = "";	
			
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null; 
			List<DataMap> updategrpoit = null;
			DataMap dMap = new DataMap();
			
			for(DataMap tasdh : headList){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				if(tasdh.getString("GRPOKY").equals(" ")){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
					throw new Exception("* 그룹핑 번호가 없습니다. *");
				}
				
				
				//아이템 조회  구버전 /신버전 큰 차이
				dMap = (DataMap)map.clone();
				dMap.putAll(tasdh);
				dMap.setModuleCommand("OutBoundPicking", "DL42_ITEM");
				itemList = commonDao.getList(dMap);

				for (DataMap tasdi:itemList) {
					if(tasdi.getString("STATIT").equals("FPC")){
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
						throw new Exception("* 이미 피킹완료된 데이터입니다. *");
					}else if(tasdi.getString("GRPOKY").trim().equals("") || tasdi.getString("GRPOKY").isEmpty()){
						continue;}
					tasdi.setModuleCommand("OutBoundPicking", "DL42_DELGROUP");
					resultChk = (int)commonDao.update(tasdi);
				}
				if(resultChk > 0){
					rsMap.put("RESULT", "DEL");
				}
					
			}
		}catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
			
	
	public DataMap saveDL42(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		DataMap dMap = new DataMap();
		
		try {
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			DataMap itemTemp = map.getMap("tempItem");
			for(DataMap tasdh : headList ){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				if(tasdh.getString("GRPOKY").equals(" ")){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
					throw new Exception("* 그룹핑 번호가 없습니다. *");
				}

				List tempList = new ArrayList();
				tempList = itemTemp.getList(tasdh.getString("SEARCHKEY"));
				
				if (tempList != null){
					for(int i=0;i<tempList.size();i++){
						DataMap tasdi = ((DataMap) tempList.get(i)).getMap("map");
						if(tasdi.getString("STATIT").equals("FPC")){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 이미 피킹완료된 데이터입니다. *");
						}else if(tasdh.getString("SEARCHKEY").equals(tasdi.getString("SEARCHKEY"))){
							//DAS 기반데이터 생성 프로시저 콜 
							tasdi.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP");
							map.clonSessionData(tasdi);
							tasdi.put("WRKFLG", "SKU");
							
							commonDao.update(tasdi); //실행버튼
	
							if(resultChk == 0){
								rsMap.put("RESULT", "OK");
							}
						}
					}
				} else { //템프값이 없을때
					//아이템 조회 
					//아이템 조회  구버전 /신버전 큰 차이
					dMap = (DataMap)map.clone();
					dMap.putAll(tasdh);
					dMap.setModuleCommand("OutBoundPicking", "DL42_ITEM");
					itemList = commonDao.getList(dMap);
					
					for(DataMap tasdi : itemList){
						if(tasdi.getString("STATIT").equals("FPC")){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 이미 피킹완료된 데이터입니다. *"); //SYSTEM_SAVEPP
						}else if(tasdh.getString("SEARCHKEY").equals(tasdi.getString("SEARCHKEY"))){
							//DAS 기반데이터 생성 프로시저 콜  
							tasdi.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP");
							map.clonSessionData(tasdi);
							tasdi.put("WRKFLG", "SKU");
							
							commonDao.update(tasdi);  //실행버튼

							if(resultChk == 0){
								rsMap.put("RESULT", "OK");
							}
						}
					}
				}
			}			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}		
			

	//DL43 피킹리스트그룹핑
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDL43(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
			
		try {			
			//헤드 아이템 데이터 가져오기
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null;
			DataMap updatePoitMap = null;
			DataMap paramMap = (DataMap)map.clone();
			
			if(headList.size() < 1){
				rsMap.put("RESULT", "Em");
			}
			
			String sdifky = "";
			for(DataMap tasdh : headList){
				int sdifit = 0;
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				if(tasdh.getString("SDIFKY").trim().isEmpty() ||tasdh.getString("SDIFKY").trim().equals("")){
					// 피킹그룹키
					map.setModuleCommand("OutBoundPicking", "DL43_SDIFKY");
					sdifky = commonDao.getMap(map).getString("GROUPKY");
				}else {
					sdifky = tasdh.getString("SDIFKY");
				}
				
				//아이템 조회  구버전 /신버전 큰 차이 
				paramMap.putAll(tasdh);
				paramMap.setModuleCommand("OutBoundPicking", "DL43_ITEM");
				itemList = commonDao.getList(paramMap);

				//update
				for(DataMap tasdi : itemList){
					paramMap.putAll(tasdi);
					paramMap.setModuleCommand("OutBoundPicking", "DL43_PICKINGLIST");
					updateList = commonDao.getList(paramMap);
					tasdi.setModuleCommand("OutBoundPicking", "DL43_SDIFIT");
					updatePoitMap = commonDao.getMap(tasdi);
					
					if(updateList.size() < 1){
					//에러 메시지 출력 구현
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 그룹핑 되어있습니다."});
						throw new Exception("*"+ msg + "*");
					}
					
					//sdifit 값 가져오기 
					if(updatePoitMap.getString("SDIFIT").equals("FAIL")){
						sdifit += 10;						
					}else {
						if(tasdi.getString("SDIFIT").trim().isEmpty() || tasdi.getString("SDIFIT").trim().equals(""))
							sdifit = Integer.parseInt(updatePoitMap.getString("SDIFIT"))+10;
						else
							sdifit = Integer.parseInt(tasdi.getString("SDIFIT"));
					}	
					
					for(DataMap updateTasdi : updateList){
						updateTasdi.put("SDIFIT",(StringUtil.leftPad(String.valueOf(sdifit), "0", 6)));						
						updateTasdi.put("SDIFKY",sdifky);
						updateTasdi.setModuleCommand("OutBoundPicking", "DL43_GROUPING");
						resultChk = (int)commonDao.update(updateTasdi);
						
					}
					if(resultChk > 0){
						rsMap.put("RESULT", "OK");
					}
				}
			}
		}catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
	}
		return rsMap;
	}

	
//	
//	@Transactional(rollbackFor = Exception.class)
//	public DataMap groupingDL43(DataMap map) throws Exception {
//		DataMap rsMap = new DataMap();
//		int resultChk = 0;
//			
//		try {
//			//헤드 아이템 데이터 가져오
//			List<DataMap> headList = map.getList("head"); 
//			List<DataMap> itemList = map.getList("item");
//			List<DataMap> updateList = null;
//			DataMap updatePoitMap = null;
//			
//			//SDIFKY 작업자별피킹번호  SDIFIT 작업자별피킹아이템
//			for(DataMap tasdh : headList){
//				int sdifit = 0;
//				///그리드에서 보낸 맵은 반드시 getMap("map")할것
//				tasdh = tasdh.getMap("map");
//				String sdifky = "";
//				if(tasdh.getString("SDIFKY").trim().isEmpty() ||tasdh.getString("SDIFKY").trim().equals("")){
//					// 피킹그룹키
//					map.setModuleCommand("OutBoundPicking", "DL43_SDIFKY");
//					sdifky = commonDao.getMap(map).getString("GROUPKY");
//				}else {
//					sdifky = tasdh.getString("SDIFKY"); //작업자별 피킹번호
//				}
//				
//				//아이템 조회  구버전 /신버전 큰 차이 
//				tasdh.setModuleCommand("OutBoundPicking", "DL43_ITEM");
//				itemList = commonDao.getList(tasdh);
//				
//				//update
//				for(DataMap tasdi : itemList){
//					tasdi.setModuleCommand("OutBoundPicking", "DL43_PICKINGLIST");
//					updateList = commonDao.getList(tasdi);
//					tasdi.setModuleCommand("OutBoundPicking", "DL43_SDIFIT"); //작업자별피킹아이템
//					updatePoitMap = commonDao.getMap(tasdi);
//					
//					if(updateList.size() < 1){
//						//에러 메시지 출력 구현
//						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 그룹핑 되어있습니다."});
//						throw new Exception("*"+ msg + "*");
//					}
//
//					//SDIFIT 값 가져오기 
//					if(updatePoitMap.getString("SDIFIT").equals("FAIL")){
//						sdifit += 10;						
//					}else {
//						if(tasdi.getString("SDIFIT").trim().isEmpty() || tasdi.getString("SDIFIT").trim().equals(""))
//							sdifit = Integer.parseInt(updatePoitMap.getString("SDIFIT"))+10;
//						else
//							sdifit = Integer.parseInt(tasdi.getString("SDIFIT"));
//					}	
//
//					for(DataMap updateTasdi : updateList){
//						updateTasdi.put("SDIFIT",(StringUtil.leftPad(String.valueOf(sdifit), "0", 6)));						
//						updateTasdi.put("SDIFKY",sdifky);
//						updateTasdi.setModuleCommand("OutBoundPicking", "DL43_GROUPING");
//						//commonDao.update(updateTasdi);
//						resultChk = (int)commonDao.update(updateTasdi);
//						
//					}
//					if(resultChk > 0){
//						rsMap.put("RESULT", "OK");
//					}
//				}
//				
//			}
//		} catch (Exception e) {
//			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
//	}
//		return rsMap;
//	}
//	
//	
	
	//DL43 그룹핑삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap delGroupDL43(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {
			// 피킹그룹키
			String sdifky = "";	
			
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null; 
			List<DataMap> updatesdifit = null;
			
			for(DataMap tasdh : headList){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				//아이템 조회  구버전 /신버전 큰 차이 
				tasdh.setModuleCommand("OutBoundPicking", "DL43_ITEM");
				itemList = commonDao.getList(tasdh);
				
				if(headList.size() < 1){
					//에러 메시지 출력 구현
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"그룹핑 번호가 없습니다."});
					throw new Exception("*"+ msg + "*");
				}

				for (DataMap tasdi:itemList) {
					if(tasdi.getString("SDIFKY").trim().equals("") || tasdi.getString("SDIFKY").isEmpty()){
						continue;}
					tasdi.setModuleCommand("OutBoundPicking", "DL43_DELGROUP");
					resultChk = (int)commonDao.update(tasdi);
				}
				if(resultChk > 0){
					rsMap.put("RESULT", "DEL");
				}
			}
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	//DL43 save 피킹완료
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL43(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		try {
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			for(DataMap tasdh : headList ){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				//아이템 조회  구버전 /신버전 큰 차이 
				tasdh.setModuleCommand("OutBoundPicking", "DL43_ITEM");
				itemList = commonDao.getList(tasdh);
				for(DataMap tasdi : itemList){
				
					if(tasdi.getString("STATIT").equals("FPC")){ // 구버전 NEW로 표기되있음 
						
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 피킹완료된 데이터입니다."});
						throw new Exception("*"+ msg + "*");

					}else if(tasdh.getString("SEARCHKEY").equals(tasdi.getString("SEARCHKEY"))){
					
						//DAS 기반데이터 생성 프로시저 콜 
						tasdi.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP");
						map.clonSessionData(tasdi);
						tasdi.put("WRKFLG", "WRK");
						
						commonDao.update(tasdi); //실행버튼
								
						if(resultChk == 0){
							rsMap.put("RESULT", "OK");
						}
					}
				}
			}			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}	
	
	//DL43 save 피킹완료
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL43New(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		try {
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			for(DataMap tasdh : headList ){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				//아이템 조회  구버전 /신버전 큰 차이 
				tasdh.setModuleCommand("OutBoundPicking", "DL43_ITEM_SAVE");
				itemList = commonDao.getList(tasdh);
				for(DataMap tasdi : itemList){
				
					if(tasdi.getString("STATIT").equals("FPC")){ // 구버전 NEW로 표기되있음 
						
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 피킹완료된 데이터입니다."});
						throw new Exception("*"+ msg + "*");

					}else if(tasdh.getString("SEARCHKEY").equals(tasdi.getString("SEARCHKEY"))){
					
						//DAS 기반데이터 생성 프로시저 콜 
						tasdi.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP");
						map.clonSessionData(tasdi);
						tasdi.put("WRKFLG", "WRK");
						
						commonDao.update(tasdi); //실행버튼
								
						if(resultChk == 0){
							rsMap.put("RESULT", "OK");
						}
					}
				}
			}			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}			
	
	//DL44 그룹핑 NEW
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDL44New(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {					
			//헤드 아이템 데이터 가져오기
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null;
			DataMap updatePoitMap = null;
			DataMap paramMap = (DataMap)map.clone();
			StringBuffer headData = new StringBuffer();
			
			if(headList.size() < 1){
				rsMap.put("RESULT", "Em");
			}

			for(DataMap tasdh : headList){
				int ssorit = 0;
				String ssornu = "";
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");

				if(tasdh.getString("SSORNU").trim().isEmpty() ||tasdh.getString("SSORNU").trim().equals("")){
					// 피킹그룹키
					map.setModuleCommand("OutBoundPicking", "DL44_SSORNU");
					ssornu = commonDao.getMap(map).getString("GROUPKY");
				}else {
					ssornu = tasdh.getString("SSORNU");
				}

				tasdh.setModuleCommand("OutBoundPicking", "DL44_PICKINGLIST_NEW");
				itemList = commonDao.getList(tasdh);
				
				for(DataMap updateTasdi : itemList){
					
					if(null == updateTasdi.getString("SSORIT") || " ".equals(updateTasdi.getString("SSORIT"))){
						ssorit += 10;	
					}else{
						ssorit = updateTasdi.getInt("SSORIT");

						//VALID 
						updateTasdi.setModuleCommand("OutBoundPicking", "DL44_PICKINGLIST_VALID_NEW");
						DataMap itemValid = commonDao.getMap(updateTasdi);
						if(null != itemValid && itemValid.getInt("CNT") > 0 )
					        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 그룹핑 되어있습니다."}));   
					}
					
					updateTasdi.put("SSORIT",(StringUtil.leftPad(String.valueOf(ssorit), "0", 6)));						
					updateTasdi.put("SSORNU",ssornu);
					updateTasdi.setModuleCommand("OutBoundPicking", "DL44_GROUPING_NEW");
					resultChk = (int)commonDao.update(updateTasdi);
					
				}
				if(resultChk > 0){
					rsMap.put("RESULT", "OK");
				}
			}
			
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );	
		}
		return rsMap;
		
	}
	
	
	//DL44 그룹핑
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDL44(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
			
		try {			
			//헤드 아이템 데이터 가져오기
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null;
			DataMap updatePoitMap = null;
			DataMap paramMap = (DataMap)map.clone();
			
			if(headList.size() < 1){
				rsMap.put("RESULT", "Em");
			}
		
			for(DataMap tasdh : headList){
				int ssorit = 0;
				String ssornu = "";
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
								
				if(tasdh.getString("SSORNU").trim().isEmpty() ||tasdh.getString("SSORNU").trim().equals("")){
					// 피킹그룹키
					map.setModuleCommand("OutBoundPicking", "DL44_SSORNU");
					ssornu = commonDao.getMap(map).getString("GROUPKY");
				}else {
					ssornu = tasdh.getString("SSORNU");
				}
				
				//아이템 조회  구버전 /신버전 큰 차이 
				paramMap.putAll(tasdh);
				paramMap.setModuleCommand("OutBoundPicking", "DL44_ITEM");
				itemList = commonDao.getList(paramMap);

				//update
				for(DataMap tasdi : itemList){
					paramMap.putAll(tasdi);
					paramMap.setModuleCommand("OutBoundPicking", "DL44_PICKINGLIST");
					updateList = commonDao.getList(paramMap);
					tasdi.setModuleCommand("OutBoundPicking", "DL44_SSORIT");
					updatePoitMap = commonDao.getMap(tasdi);
					
					if(updateList.size() < 1){
					//에러 메시지 출력 구현
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 그룹핑 되어있습니다."});
						throw new Exception("*"+ msg + "*");
					}
					
					//ssorit 값 가져오기 
					if(updatePoitMap.getString("SSORIT").equals("FAIL")){
						ssorit += 10;						
					}else {
						if(tasdi.getString("SSORIT").trim().isEmpty() || tasdi.getString("SSORIT").trim().equals(""))
							ssorit = Integer.parseInt(updatePoitMap.getString("SSORIT"))+10;
						else
							ssorit = Integer.parseInt(tasdi.getString("SSORIT"));
					}	
					
					for(DataMap updateTasdi : updateList){
						updateTasdi.put("SSORIT",(StringUtil.leftPad(String.valueOf(ssorit), "0", 6)));						
						updateTasdi.put("SSORNU",ssornu);
						updateTasdi.setModuleCommand("OutBoundPicking", "DL44_GROUPING");
						resultChk = (int)commonDao.update(updateTasdi);
						
					}
					if(resultChk > 0){
						rsMap.put("RESULT", "OK");
					}
				}
			}
		}catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
	}
		return rsMap;
	}

	//DL44 그룹핑삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap delGroupDL44(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {
			// 피킹그룹키
			String ssornu = "";	
			
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null; 
			List<DataMap> updatessorit = null;
			
			for(DataMap tasdh : headList){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				//아이템 조회  구버전 /신버전 큰 차이 
				tasdh.setModuleCommand("OutBoundPicking", "DL44_ITEM");
				itemList = commonDao.getList(tasdh);

				for (DataMap tasdi:itemList) {
					//tasdi = tasdi.getMap("map");
					if(tasdi.getString("SSORNU").trim().equals("") || tasdi.getString("SSORNU").isEmpty()){
						continue;}
					tasdi.setModuleCommand("OutBoundPicking", "DL44_DELGROUP");
					resultChk = (int)commonDao.update(tasdi);
				}
				if(resultChk > 0){
					rsMap.put("RESULT", "DEL");
				}
					
			}
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}

	//DL44 그룹핑삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap delGroupDL44New(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {
			// 피킹그룹키
			String ssornu = "";	
			
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			List<DataMap> updateList = null; 
			List<DataMap> updatessorit = null;
			
			for(DataMap tasdh : headList){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");

				tasdh.setModuleCommand("OutBoundPicking", "DL44_DELGROUP_NEW");
				resultChk = (int)commonDao.update(tasdh);

				if(resultChk > 0){
					rsMap.put("RESULT", "DEL");
				}
					
			}
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	// DL44 프린트 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap printDL44(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0; 
		String ssornu = "";
		String taskky = "";
		List<DataMap> headList = map.getList("head"); 
		
		try {
			for(int i =0 ; i < headList.size() ;i++){
				DataMap row = headList.get(i).getMap("map");
				map.clonSessionData(row); //복제
				
				row.setModuleCommand("OutBoundPicking", "DNAME3_PRINT");
				commonDao.update(row);
				resultChk ++;
				
			}
			rsMap.put("CNT",resultChk);
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	// DL43 프린트 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap printDL43(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0; 
		String ssornu = "";
		String taskky = "";
		List<DataMap> headList = map.getList("head"); 
		
		try {
			for(int i =0 ; i < headList.size() ;i++){
				DataMap row = headList.get(i).getMap("map");
				map.clonSessionData(row); //복제
				
				row.setModuleCommand("OutBoundPicking", "DNAME3_DL43_PRINT");
				commonDao.update(row);
				resultChk ++;
				
			}
			rsMap.put("CNT",resultChk);
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
		
	
	//DL44 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL44(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		DataMap dMap = new DataMap();
		
		try {
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			for(DataMap tasdh : headList ){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				
				//아이템 조회  구버전 /신버전 큰 차이 
				dMap = (DataMap)map.clone();
				dMap.putAll(tasdh);
				dMap.setModuleCommand("OutBoundPicking", "DL44_ITEM");
				itemList = commonDao.getList(dMap);
				for(DataMap tasdi : itemList){

					if(tasdi.getString("STATIT").equals("FPC")){ // 구버전 NEW로 표기되있음 
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"이미 피킹완료된 데이터입니다."});
						throw new Exception("*"+ msg + "*");

					}else if(tasdh.getString("SEARCHKEY").equals(tasdi.getString("SEARCHKEY"))){
						
						//DAS 기반데이터 생성 프로시저 콜 
						tasdi.setModuleCommand("OutBoundPicking", "P_SAJO_PICKING_CMP_NEW");
						map.clonSessionData(tasdi);
						tasdi.put("WRKFLG", "CAR");
						
						commonDao.update(tasdi); //실행버튼
					
						if(resultChk == 0){
							rsMap.put("RESULT", "OK");
						}
					}
				}
			}			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}		
	
	
	// DL45 프린트 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap printDL45(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0; 
		String ssornu = "";
		String taskky = "";
		List<DataMap> headList = map.getList("head"); 
		
		try {
			for(int i =0 ; i < headList.size() ;i++){
				DataMap row = headList.get(i).getMap("map");
				map.clonSessionData(row); //복제
				
				row.setModuleCommand("OutBoundPicking", "DNAME3_PRINT2");
				commonDao.update(row);
				resultChk ++;
				
			}
			rsMap.put("CNT",resultChk);
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
		
		
	//DL45      헤더 - 입고문서번호 RECVKY // 아이템 -작업지시번호 TASKKY
		@Transactional(rollbackFor = Exception.class)
		public String pickingDL45(DataMap map) throws Exception {
			String result = "";
			try{     
					List<DataMap> head = map.getList("head");
					List<DataMap> item = map.getList("item");
					List<DataMap> itemList = null;
					DataMap searchMap = (DataMap)map.clone();
					StringBuffer strBuffer = new StringBuffer();
	      
					//그리드에서 넘어온 head List 처리
					for(int i=0;i<head.size();i++){
							DataMap row = head.get(i).getMap("map");        
							map.clonSessionData(row);
							
							//아이템 비교 후 현재 조회된 아이템이 아니거나 아이템리스트가 없을때 조회해온다.
							if(item != null && item.size() > 0 && row.getString("RECVKY").equals(((DataMap)item.get(0).get("map")).getString("RECVKY"))){
								itemList = item;
							}else{
								searchMap.putAll(row);
								searchMap.setModuleCommand("OutBoundPicking", "DL45_ITEM");
								itemList = commonDao.getList(searchMap);
							}
							
							//ITEM LOOP
							for(int j=0; j<itemList.size(); j++){
								DataMap itemRow = itemList.get(j).getMap("map");
								map.clonSessionData(itemRow);
								int qttaor = itemRow.getInt("QTTAOR");
								int qtcomp = itemRow.getInt("QTCOMP");
								
								if(j==0){
									strBuffer.append(" SELECT '").append(itemRow.getString("TASKKY")).append("' FROM DUAL ");	
								}else{
									strBuffer.append(" UNION ALL SELECT '").append(itemRow.getString("TASKKY")).append("' FROM DUAL ");
								}
								
								//피킹수량이 0인지 체크한다
								if(itemRow.getInt("QTTAOR") < 1) 
							        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005",new String[]{qtcomp+"", qttaor+""}));  
								
								//이미 컨펌되었는지 체크 
								if (!"00000000".equals(itemRow.getString("ACTCDT")) && !itemRow.getString("ACTCDT").isEmpty()) continue; 
									  //throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0009",new String[]{itemRow.getString("TASKKY"), itemRow.getString("TASKIT")}));  

								//SHPDH의 마감여부를 체크한다.
								itemRow.setModuleCommand("OutBoundPicking", "DL45_VALIDATE"); //OUTBOUND.CONFIRM.CHECK_ALLOCATION_CONFIRM
								DataMap validMap = commonDao.getMap(itemRow);
								if (!"".equals(validMap.getString("V"))) continue; 
								//	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0034",new String[]{itemRow.getString("TASKKY")}));  

						        //TASDR 가져온다 (삭제하기 전에 미리 끌어온다)
								itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDR");   
						        DataMap tasdrMap = commonDao.getMap(itemRow); 
						        tasdrMap.put("QTSTKC", itemRow.getInt("QTCOMP"));
						        tasdrMap.put("STOKKY", tasdrMap.getString("SRCSKY"));
								map.clonSessionData(tasdrMap);
								
								//TASDI를 삭제한다.
								itemRow.setModuleCommand("Outbound", "DL40_TASDI");
								commonDao.delete(itemRow);
								

								// "FPC" 작업수량 = 작업완료수량  
								// "PPC" 작업수량 > 작업완료수량
								// "OPC" 작업수량 < 작업완료수량
								if (qttaor == qtcomp){
								  itemRow.put("STATIT", "FPC");
								} if (qttaor > qtcomp){
								  itemRow.put("STATIT", "PPC");
								} if (qttaor < qtcomp){
								  itemRow.put("STATIT", "OPC");
								}

								//TASDI 재생성
								itemRow.setModuleCommand("Outbound", "TASDI");        
						        commonDao.insert(itemRow);
						        
						        //TASDR 피킹완료 업데이트 
								tasdrMap.setModuleCommand("Outbound", "TASDR");       
						        commonDao.update(tasdrMap);
							}
					}     
					result = strBuffer.toString();
			} catch (Exception e) {
				throw new Exception(e.getMessage());
			}
			return result;
		}
	 
	//선입고 피킹완료 처리전 유효성 체크
	 private void pickingforItem(DataMap map, DataMap head, List<DataMap> items) throws Exception{
	    int shipsqNum = 0;
	    int qtcompSum = 0;
	    String progid = map.get("PROGID")+"";
	    String taskky = (String)head.get("TASKKY"); //작업지시번호 
	    
	    for(int j=0;j<items.size();j++){
	      
	      DataMap itemRow = items.get(j).getMap("map");
	      map.clonSessionData(itemRow);
	            
	      String taskit = (String)itemRow.get("TASKIT"); //작업오더아이템
	      
	   // 2012.10.27 by GOKU - 오더컨펌이 되지 않은 Shipment의 피킹 완료는 할 수 없다.
	     // itemRow.setModuleCommand("OutBoundPicking", "DL45_PICK_ITEM"); //쿼리없음
	      DataMap pickItem = commonDao.getMap(itemRow);
	      
	      String wareky = (String)pickItem.get("WAREKY");
	      String locaac = (String)pickItem.get("LOCAAC");
	      String ameaky = (String)pickItem.get("AMEAKY");
	      String auomky = (String)pickItem.get("AUOMKY");
	      String doorky = (String)pickItem.get("DOORKY");
	      String locasr = (String)pickItem.get("LOCASR");
	      double qtyuom = Double.parseDouble((String)pickItem.get("QTYUOM"));
	      double qtcomp = Double.parseDouble((String)pickItem.get("QTCOMP"));
	      double qttaor = Double.parseDouble((String)pickItem.get("QTTAOR"));
	      String rsncod = (String)pickItem.get("RSNCOD");
	      
	      // 2012.09.10 by GOKU - 아이템별 피킹완료시에, 하나의 작업오더에 대해서 선택한 아이템들이 모두 제로피킹은 할 수 없다.
	      if (qtcomp == 0) {
	        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0032",new String[]{taskky}));                     
	      }
	      
	      // 이미 confirm 되었는지 검사
	      itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDI");
	      DataMap tasdi = commonDao.getMap(itemRow);
	      String actcdt = (String)tasdi.get("ACTCDT");
	      if (!"00000000".equals(actcdt) && !"".equals(actcdt)) {
	        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0009",new String[]{taskit}));                     
	      }
	            
	      if (qttaor < qtcomp) {
	        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005",new String[]{qtcomp+"", qttaor+""}));                                                       
	      } 
	      
	      //거점, 문서유형 , 거래처(헤더)의 필수 값 유효성 체크 
	      itemRow.setModuleCommand("OutBoundPicking", "DL45_VALIDATE"); //OUTBOUND.CONFIRM.CHECK_ALLOCATION_CONFIRM
		  DataMap validMap = commonDao.getMap(itemRow);
		  
		  if (!"".equals(validMap.getString("V"))) {
	        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0034",new String[]{taskky}));                                                       
	      } 
	      
		  
		  //TASDR
	      List<DataMap> tasdr = new ArrayList<DataMap>();
	      itemRow.setModuleCommand("OutBoundPicking", "DL45_ITEM_TASDR");
	    
	      tasdr = commonDao.getList(itemRow);  
	      
	      // TASDI 1건은 TASDR 1건만 허용한다.
	      for(int k=0;k<tasdr.size();k++){
	        DataMap tasdrRow = tasdr.get(k).getMap("map");
	       // System.out.println( "tasdrRow = " + tasdrRow);
	        tasdrRow.put("WAREKY", wareky);
	        tasdrRow.setModuleCommand("OutBoundPicking", "DL45_STKKY");
	        DataMap styyk = commonDao.getMap(tasdrRow);
	        //System.out.println( "styyk = " + styyk);
	        // 생성된 재고의 source stokky값을 넣어준다.
	        tasdr.get(k).put("STOKKY", (String)styyk.get("SRCSKY"));
	        tasdr.get(k).put("QTSTKC", (String)styyk.get("QTCOMP"));
	      }
	      
	      //TASDI를 삭제한다.
	      itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDI");       
	      commonDao.delete(itemRow);
	      
	      //TASDR를 생성한다.
	      int staues = 0;
		  // "FPC" 작업수량 = 작업완료수량  
	      // "PPC" 작업수량 > 작업완료수량
		  // "OPC" 작업수량 < 작업완료수량
	      if (staues == 0){
	        itemRow.put("STATIT", "FPC");
	      }else if (staues == 1){
	        itemRow.put("STATIT", "PPC");
	      }else if (staues == -1){
	        itemRow.put("STATIT", "OPC");
	      }
	      
	      itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDI");        
	      commonDao.insert(itemRow);
	      
	      
	      for(int k=0;k<tasdr.size();k++){
	        DataMap tasdrRow = tasdr.get(k).getMap("map");
	        map.clonSessionData(tasdrRow);
	        tasdrRow.setModuleCommand("Outbound", "TASDR");       
	        commonDao.update(tasdrRow);
	      }
	    }

	  }
	 
	 
	//[DL45] RangeSearchRS
	@Transactional(rollbackFor = Exception.class)
	public List displayDL45(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("OutBoundPicking", "DL45_HEAD");
		
		//RangeSearchRS
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("RH.RCPTTY");
//		keyList.add("CARNUM");
		keyList.add("RH.DOCDAT");
		keyList.add("S.REFDKY");
		keyList.add("RH.RECVKY");
		keyList.add("S.SEBELN");
		keyList.add("S.SKUKEY");
		keyList.add("S.DESC01");
		keyList.add("RH.DPTNKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		//RangeSearchRS
		List keyList2 = new ArrayList<>();
		keyList2.add("CARDAT");
		keyList2.add("CARNUM");
		keyList2.add("SHIPSQ");
		map.put("RANGERS_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		//LotAttributeSearch
		List keyList3 = new ArrayList<>();
		keyList3.add("S.LOTA13");
		keyList3.add("S.LOTA12");
		keyList3.add("S.LOTA03");
		keyList3.add("S.LOTA05");
		keyList3.add("S.LOTA06");
		
		map.put("RANGELOT_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));
					
		List<DataMap> list = commonDao.getList(map);
		return list;
	}

	//[DL45] RangeSearchRS
	@Transactional(rollbackFor = Exception.class)
	public List displayDL45Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("OutBoundPicking", "DL45_ITEM");

		//RangeSearchRS
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("RH.RCPTTY");
//		keyList.add("CARNUM");
		keyList.add("RH.DOCDAT");
		keyList.add("S.REFDKY");
		keyList.add("RH.RECVKY");
		keyList.add("S.SEBELN");
		keyList.add("S.SKUKEY");
		keyList.add("S.DESC01");
		keyList.add("RH.DPTNKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		//RangeSearchRS
		List keyList2 = new ArrayList<>();
		keyList2.add("CARDAT");
		keyList2.add("CARNUM");
		keyList2.add("SHIPSQ");
		map.put("RANGERS_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		//LotAttributeSearch
		List keyList3 = new ArrayList<>();
		keyList3.add("S.LOTA13");
		keyList3.add("S.LOTA12");
		keyList3.add("S.LOTA03");
		keyList3.add("S.LOTA05");
		keyList3.add("S.LOTA06");
		
		map.put("RANGELOT_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));
					
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	

}



