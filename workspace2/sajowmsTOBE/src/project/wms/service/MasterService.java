package project.wms.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.SqlUtil;

@Service
public class MasterService extends BaseService {
	
	static final Logger log = LogManager.getLogger(MasterService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMW01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");
			
			//INSERT 구현 
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "MW01");
				
				if(rowState.equals("C")){
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0101",new String[]{row.getString("WAREKY")});
						throw new Exception("*"+ msg + "*");

					}else{
						map.clonSessionData(row);
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					count++;
				}
			}
			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	/**[MO01] 화주 저장 2020-12-27 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMO01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> headlist = map.getList("head");
			DataMap head = headlist.get(0).getMap("map");
			List<DataMap> list = map.getList("item");
			
			String hState = head.getString(CommonConfig.GRID_ROW_STATE_ATT);
			
			map.clonSessionData(head);
			head.setModuleCommand("Master", "MO01");
			switch (hState) {
				case "U":
					commonDao.update(head);
					count++;
					break;
				case "C":
					int chk = commonDao.getMap(head).getInt("CHK");
					
					if(chk > 0 ){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_MO0101",new String[]{""}));
					}else{
						commonDao.insert(head);
						count++;
					}
					
					break;	
				default:
					break;
			}
			
			
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					DataMap row = list.get(i).getMap("map");
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					map.clonSessionData(row);
					row.setModuleCommand("Master", "MO01_ITEM");
					
					if(rowState.equals("D")){
						commonDao.delete(row);
						count++;
					}
				}
				
				for(int  i = 0; i < list.size(); i++){
					DataMap row = list.get(i).getMap("map");
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					map.clonSessionData(row);
					row.setModuleCommand("Master", "MO01_ITEM");
					
					if(rowState.equals("C")){
						
						int chk = commonDao.getMap(row).getInt("CHK");
								//.getInt("CHK");
						if(chk > 0 ){
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0101",new String[]{row.getString("WAREKY")}));

						}else{
							commonDao.insert(row);
							count++;
						}
						
					}else if(rowState.equals("U")){
						commonDao.update(row);
						
						count++;
					}
				}
			}
			
		} catch (Exception e) {
			throw new Exception("에러가 발생 했습니다. 관리자에게 문의 바랍니다.");
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	/**
	 * [MA01] 영역  저장 2020-12-27 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMA01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("item");
			
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "MA01");
				
				if(rowState.equals("D")){
					commonDao.delete(row);
					count++;
				}
			}
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "MA01");
				
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_MO0101",new String[]{row.getString("AREAKY")}));

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception("에러가 발생 했습니다. 관리자에게 문의 바랍니다.");
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	/**
	 * [MZ01] 구역 저장 2020-12-27 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMZ01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("item");
			
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "MZ01");
				
				if(rowState.equals("D")){
					commonDao.delete(row);
					count++;
				}
			}
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "MZ01");
				
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_MZ0102",new String[]{row.getString("AREAKY")}));

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception("에러가 발생 했습니다. 관리자에게 문의 바랍니다.");
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	/**
	 * [SK01] SKU 2020-12-29 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSK01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");
			StringBuffer sb = new StringBuffer();
			
			DataMap param = new DataMap();
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
					
					if(sb.toString().equals("")){
						param.put("WAREKY", row.getString("WAREKY"));
						param.put("OWNRKY", row.getString("OWNRKY"));
					}
					
					sb.append(" UNION ALL \n");
					sb.append("SELECT ").append("2").append(" AS ROWTYP, ");
					sb.append("       '").append(row.getString("WAREKY")).append("' AS WAREKY, ");
					sb.append("       '").append(row.getString("OWNRKY")).append("' AS OWNRKY, ");
					sb.append("       '").append(row.getString("SKUKEY")).append("' AS SKUKEY, ");

					sb.append("       '").append(row.getString("SKUG01")).append("' AS SKUG01, ");
					sb.append("       '").append(row.getString("MEASKY")).append("' AS MEASKY, ");
					sb.append("       '").append(row.getString("DUOMKY")).append("' AS DUOMKY, ");
					sb.append("       '").append(row.getString("LOCARV")).append("' AS LOCARV, ");
					sb.append("       '").append(row.getString("PASTKY")).append("' AS PASTKY, ");
					sb.append("       '").append(row.getString("ALSTKY")).append("' AS ALSTKY, ");
					sb.append("       '").append(row.getString("UOMDTA")).append("' AS UOMDTA, ");
					sb.append("       '").append(row.getString("DPUTLO")).append("' AS DPUTLO  ");
					sb.append("  FROM DUAL \n");
			}
			
			param.put("appendQuery", sb.toString());
			map.clonSessionData(param);
			param.setModuleCommand("Master", "SK01_VALID");
			List<DataMap> reslist = commonDao.getList(param);
			
			if(reslist != null && reslist.size() > 0){
				DataMap val = reslist.get(0);
				String[] msgArgs = val.getString("RESULTMSG").split("/");
				
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), msgArgs[0] , msgArgs[1].split(",")  ));
				
			}
			
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				
				
				if(rowState.equals("U")){
					row.setModuleCommand("Master", "SKUMA");
					commonDao.update(row);
					row.setModuleCommand("Master", "SKUWC");
					commonDao.update(row);
					
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception("에러가 발생 했습니다. 관리자에게 문의 바랍니다.");
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	/**
	 * [SK01] SKU 2020-12-29 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSK03(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");
			
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					DataMap row = list.get(i).getMap("map");
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					map.clonSessionData(row);
					row.setModuleCommand("Master", "SK03");
					
					if(rowState.equals("D")){
						commonDao.delete(row);
						count++;
					}
				}
				
				for(int  i = 0; i < list.size(); i++){
					DataMap row = list.get(i).getMap("map");
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					map.clonSessionData(row);
					row.setModuleCommand("Master", "SK03");
					
					if(rowState.equals("C")){
						
						int chk = commonDao.getMap(row).getInt("CHK");
								//.getInt("CHK");
						if(chk > 0 ){
							throw new Exception("*"+commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_SK030001",new String[]{row.getString("SKUKEY"),row.getString("OWNRKY")}) + "*");

						}else{
							commonDao.insert(row);
							count++;
						}
						
					}else if(rowState.equals("U")){
						commonDao.update(row);
						
						count++;
					}
				}
			}
			
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	/**
	 * [TC] 차량관리 2020-12-27 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTC01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");
			
			
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TC01");
				
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{row.getString("OWNRKY"),row.getString("WAREKY"),row.getString("CARNUM")});
						throw new Exception("*"+ msg + "*");

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	/**
	 * [TC] 차량관리 2020-12-27 Ahn JinSeok
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTP01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> list = map.getList("list");
			
			for(int  i = 0; i < head.size(); i++){
				DataMap row = head.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TP01");
				
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
					if(chk > 0 ){
						String msg = "";
						throw new Exception("*"+ msg + "*");

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TP01_ITEM");
				
				if(rowState.equals("D")){
					
					commonDao.delete(row);
					count++;
				}
			}
			
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TP01_ITEM");
				
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						String msg = "";
						throw new Exception("*"+ msg + "*");

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTS01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> list = map.getList("list");
			
			for(int  i = 0; i < head.size(); i++){
				DataMap row = head.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TS01");
				rsMap.put("SSORKY", row.getString("SSORKY"));
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
					if(chk > 0 ){
						String msg = "";
						throw new Exception("*"+ msg + "*");

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					
					count++;
				}
			}
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "TS01_ITEM");
				
				if(rowState.equals("C")){
					commonDao.insert(row);
					count++;
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSM01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> list = map.getList("list");
			
			for(int  i = 0; i < head.size(); i++){
				DataMap row = head.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "SM01");
				if(rowState.equals("C")){
					
					int chk = commonDao.getMap(row).getInt("CHK");
					if(chk > 0 ){
						String msg = "";
						throw new Exception("*"+ msg + "*");

					}else{
						commonDao.insert(row);
						count++;
					}
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					count++;
				}
			}
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "SM01_ITEM");
				
				if(rowState.equals("C")){
					commonDao.insert(row);
					count++;
					
				}else if(rowState.equals("U")){
					commonDao.update(row);
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveBD01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("Master", "BD01_VALID");
				
				String valid = commonDao.getMap(row).getString("RETURN");
				
				
				if ("N".equals(valid)) {
					String msg = "입력한 데이터를 확인하세요";
					throw new Exception("*"+ msg + "*");
				}else if("E".equals(valid)) {
//					ds.setStatus(DataStructure.TRANSACTION_FAIL);
//					ds.setMsgParameter(1, "입력한 데이터가 공란이거나 시작일자는 종료일자보다 작아야합니다.");
//					ds.setMsgCode("VALID", "M0009");
					String msg = "입력한 데이터가 공란이거나 시작일자는 종료일자보다 작아야합니다.";
					throw new Exception("*"+ msg + "*");
				}else if(!"Y".equals(valid)) {
					String msg = "에러가 발생 했습니다. 관리자에게 문의 바랍니다.";
					throw new Exception("*"+ msg + "*");
				}
				
				row.setModuleCommand("Master", "BD01");
				
				if(rowState.equals("C")){
					commonDao.insert(row);
					count++;
				}else if(rowState.equals("U")){
					commonDao.update(row);
					count++;
				}else if(rowState.equals("D")){
					commonDao.delete(row);
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTC02(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("KEY");
		}
		
		int count = 0;
		String recvky = "";
		try {
			
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				map.clonSessionData(head);
				
				if(head.equals("D")){
					
				}else{
					List<DataMap> list = new ArrayList<DataMap>();
					
					if(key.equals(head.getString("KEY"))){
						list = itemlist;
					}else if(itemTemp.containsKey(head.getString("KEY")) ){
						list = itemTemp.getList(head.getString("KEY"));
					}
					
					
					
					for(int j=0;j<list.size();j++){
						DataMap row = list.get(j).getMap("map");
						map.clonSessionData(row);
						
						
						count++;
						
					}
				}
				
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		rsMap.put("SAVEKEY", keys);
		
		return rsMap;
	}
	
	  // [TC05] item 조회
	  @Transactional(rollbackFor = Exception.class)
	  public List displayTC05_ITEM(DataMap map) throws SQLException {
	  
	    SqlUtil sqlUtil = new SqlUtil();

	    List keyList1 = new ArrayList<>();
	    keyList1.add("C.CARNUM");
	    keyList1.add("CF.PTNRKY");
	    DataMap changeMap = new DataMap();
	    changeMap.put("C.CARNUM", "CF.CARNUM");
	   
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList1, changeMap));
		
	    map.setModuleCommand("Master", "TC05_ITEM");
	    List<DataMap> list = commonDao.getList(map);
	    
	    return list;

	  }
	  
		@Transactional(rollbackFor = Exception.class)
		public DataMap saveTC05(DataMap map) throws Exception {
			DataMap rsMap = new DataMap();
			int resultChk = 0;
			String key = "";
			List<DataMap> hlist = map.getList("headlist");
			List<DataMap> ilist = map.getList("list");
//			DataMap itemTemp = map.getMap("tempItem");
			if(!map.getList("list").isEmpty()){
				ilist = map.getList("list");
				key = ilist.get(0).getMap("map").getString("KEY");
			}
			
			try {
				if(hlist.size() > 0){
					for(int  i = 0; i < hlist.size(); i++){
						//그리드 로우의 값을 한줄씩 불러온다.
						DataMap head = hlist.get(i).getMap("map");
						//세션의 값을 로우에 세팅한다.
						map.clonSessionData(head);

						List<DataMap> list = new ArrayList<DataMap>();
						
						if(key.equals(head.getString("KEY"))){
							list = ilist;
//						}else if(itemTemp.containsKey(head.getString("KEY")) ){
//							list = itemTemp.getList(head.getString("KEY"));
						}
						
						for(int j=0;j<list.size();j++){
							DataMap row = list.get(j).getMap("map");
							map.clonSessionData(row);
							String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
							//insert "C"
							if(rowState.equals("C")){
	
								//유효성체크
								row.setModuleCommand("Master", "TC05");
								int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
								if(chk > 0 ){
									String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
									throw new Exception("* 동일한 라벨이 존재 합니다. *");
								}else{
									resultChk = (int)commonDao.insert(row);
								}
							}else if(rowState.equals("U")){
								row.setModuleCommand("Master", "TC05");
								
								resultChk = (int)commonDao.update(row);
								
							}else if(rowState.equals("D")){
								row.setModuleCommand("Master", "TC05");
								
									resultChk = (int)commonDao.delete(row);
							}
						}
					}
					
					if(resultChk == 1){
						rsMap.put("RESULT", "OK");
					}
				}
			} catch (Exception e) {
				throw new Exception( ComU.getLastMsg(e.getMessage()) );
			}
			return rsMap;
		}
		
		  // [TC06] item 조회
		  @Transactional(rollbackFor = Exception.class)
		  public List displayTC06_ITEM(DataMap map) throws SQLException {
		  
		    SqlUtil sqlUtil = new SqlUtil();

		    List keyList1 = new ArrayList<>();
		    keyList1.add("C.CARNUM");
		    keyList1.add("CS.REGNKY");
		    DataMap changeMap = new DataMap();
		    changeMap.put("C.CARNUM", "CS.CARNUM");
		   
			map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList1, changeMap));
			
		    map.setModuleCommand("Master", "TC06_ITEM");
		    List<DataMap> list = commonDao.getList(map);
		    
		    return list;

		  }
		  
			@Transactional(rollbackFor = Exception.class)
			public DataMap saveTC06(DataMap map) throws Exception {
				DataMap rsMap = new DataMap();
				int resultChk = 0;
				String key = "";
				List<DataMap> hlist = map.getList("headlist");
				List<DataMap> ilist = map.getList("list");
//				DataMap itemTemp = map.getMap("tempItem");
				if(!map.getList("list").isEmpty()){
					ilist = map.getList("list");
					key = ilist.get(0).getMap("map").getString("KEY");
				}
				
				try {
					if(hlist.size() > 0){
						for(int  i = 0; i < hlist.size(); i++){
							//그리드 로우의 값을 한줄씩 불러온다.
							DataMap head = hlist.get(i).getMap("map");
							//세션의 값을 로우에 세팅한다.
							map.clonSessionData(head);

							List<DataMap> list = new ArrayList<DataMap>();
							
							if(key.equals(head.getString("KEY"))){
								list = ilist;
//							}else if(itemTemp.containsKey(head.getString("KEY")) ){
//								list = itemTemp.getList(head.getString("KEY"));
							}
							
							for(int j=0;j<list.size();j++){
								DataMap row = list.get(j).getMap("map");
								map.clonSessionData(row);
								String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
								//insert "C"
								if(rowState.equals("C")){
		
									//유효성체크
									row.setModuleCommand("Master", "TC06");
									int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
									if(chk > 0 ){
										String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
										throw new Exception("* 동일한 라벨이 존재 합니다. *");
									}else{
										resultChk = (int)commonDao.insert(row);
									}
								}else if(rowState.equals("U")){
									row.setModuleCommand("Master", "TC06");
									
									resultChk = (int)commonDao.update(row);
									
								}else if(rowState.equals("D")){
									row.setModuleCommand("Master", "TC06");
									
										resultChk = (int)commonDao.delete(row);
								}
							}
						}
						
						if(resultChk == 1){
							rsMap.put("RESULT", "OK");
						}
					}
				} catch (Exception e) {
					throw new Exception( ComU.getLastMsg(e.getMessage()) );
				}
				return rsMap;
			}
			
			@Transactional(rollbackFor = Exception.class)
			public DataMap saveML01(DataMap map) throws Exception {
				DataMap rsMap = new DataMap();
				int resultChk = 0;
				List<DataMap> list = map.getList("list");

				
				try {
					if(list.size() > 0){
						for(int i=0;i<list.size();i++){
							DataMap row = list.get(i).getMap("map");
							map.clonSessionData(row);
							String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
							//insert "C"
							if(rowState.equals("C")){
								row.setModuleCommand("Master", "ML01");
								resultChk = (int)commonDao.insert(row);
							}else if(rowState.equals("U")){
								//유효성체크
//								row.setModuleCommand("Master", "ML01_JONETY");
//								DataMap chk = commonDao.getMap(row); //중복체크
////								if(chk.size() == 0 ){
////									//{0}거점과 {1}적치구역으로 조회된 창고가 존재하지 않습니다.
////									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "MASTER_M0559",new String[]{row.getString("WAREKY"),row.getString("ZONEKY")}));
////								}else{
									row.setModuleCommand("Master", "ML01_STKKY");
									commonDao.update(row);
									row.setModuleCommand("Master", "ML01");
									resultChk = (int)commonDao.update(row);
//								}
//							}else if(rowState.equals("D")){
//								row.setModuleCommand("Master", "ML01");
//								resultChk = (int)commonDao.delete(row);
							}
						}
							
						if(resultChk == 1){
							rsMap.put("RESULT", "OK");
						}
					}
				} catch (Exception e) {
					throw new Exception( ComU.getLastMsg(e.getMessage()) );
				}
				return rsMap;
			}
			
			@Transactional(rollbackFor = Exception.class)
			public DataMap saveBZ01(DataMap map) throws Exception {
				DataMap rsMap = new DataMap();
				int resultChk = 0;
				List<DataMap> list = map.getList("list");

				
				try {
					if(list.size() > 0){
						for(int i=0;i<list.size();i++){
							DataMap row = list.get(i).getMap("map");
							map.clonSessionData(row);
							String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
							//insert "C"
							if(rowState.equals("C")){
								//유효성체크
								row.setModuleCommand("Master", "BZ01");
								int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
								if(chk > 0 ){
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "MASTER_M0089",new String[]{row.getString("PTNRTY")+""}));
								}else{
									resultChk = (int)commonDao.insert(row);
								}
							}else if(rowState.equals("U")){
									row.setModuleCommand("Master", "BZ01");
									resultChk = (int)commonDao.update(row);
							}else if(rowState.equals("D")){
								row.setModuleCommand("Master", "BZ01");
								resultChk = (int)commonDao.delete(row);
							}
						}
							
						if(resultChk == 1){
							rsMap.put("RESULT", "OK");
						}
					}
				} catch (Exception e) {
					throw new Exception( ComU.getLastMsg(e.getMessage()) );
				}
				return rsMap;
			}
			

			@Transactional(rollbackFor = Exception.class)
			public DataMap saveTR01(DataMap map) throws Exception {
				DataMap rsMap = new DataMap();
				int resultChk = 0;
				List<DataMap> list = map.getList("list");

				
				try {
					if(list.size() > 0){
						for(int i=0;i<list.size();i++){
							DataMap row = list.get(i).getMap("map");
							map.clonSessionData(row);
							row.put("OWNRKY", map.getString("OWNRKY"));
							row.put("WAREKY", map.getString("WAREKY"));
							
							String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
							//insert "C"
							if(rowState.equals("C")){

								row.setModuleCommand("Master", "TR01_SEQ");
								row.put("SEQCUS", commonDao.getMap(row).getString("SEQNO")); //중복체크
								//유효성체크
								row.setModuleCommand("Master", "TR01");
								int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
								if(chk > 0 ){
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "MASTER_M0089",new String[]{row.getString("PTNRTY")+""}));
								}else{
									resultChk = (int)commonDao.insert(row);
								}
							}else if(rowState.equals("U")){
									row.setModuleCommand("Master", "TR01");
									resultChk = (int)commonDao.update(row);
							}else if(rowState.equals("D")){
								row.setModuleCommand("Master", "TR01");
								resultChk = (int)commonDao.delete(row);
							}
						}
							
						if(resultChk == 1){
							rsMap.put("RESULT", "OK");
						}
					}
				} catch (Exception e) {
					throw new Exception( ComU.getLastMsg(e.getMessage()) );
				}
				return rsMap;
			}
}