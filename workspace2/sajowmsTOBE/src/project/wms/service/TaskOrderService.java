package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.StringUtil;

@Service
public class TaskOrderService extends BaseService {
	
	static final Logger log = LogManager.getLogger(TaskOrderService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private TaskDataService taskService;

	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();

		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
			
		try {
			List<DataMap> result =  movingCheck(map);
			
			if(result == null || result.isEmpty()){
				rsMap.put("RESULT", "moving_Sucess");
			}else{
				rsMap.put("RESULT", result);
			}
			
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> movingCheck(DataMap map) throws SQLException {
		StringBuffer sbChk = new StringBuffer();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		List<DataMap> resultList = new ArrayList();
		
		DataMap headData = headList.get(0).getMap("map");
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		
		for(DataMap item : itemList){
			itemData = item.getMap("map");
			
			if(sbChk.length() > 0){
				sbChk.append(" UNION ALL \n");
			}
			sbChk.append("SELECT '").append(headData.get("WAREKY")).append("' AS WAREKY,");
			sbChk.append(" '").append(itemData.get("LOCATG")).append("' AS LOCAKY ");
			sbChk.append(" FROM DUAL");		
		}// end for
		
		map.put("APPENDQUERY", sbChk);
		map.setModuleCommand("taskOrder", "MOVINGCHECK");
		resultList = commonDao.getList(map);	
		
		if(resultList == null || resultList.size() == 0){
			return null;
		}
		return resultList;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTaskMV01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		try{
			rsMap = createTaskOrder2Step(map);
			
			if(rsMap.isEmpty() || rsMap == null){
				rsMap.put("RESULT", "F1");
				return rsMap;
			}
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap createTaskOrder2Step(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		List<DataMap> result = new ArrayList();
		
		DataMap headData = headList.get(0).getMap("map");
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		
		headData.put("DOCUTY", headData.get("TASOTY")); // 문서채번을 위한 작업타입 셋팅
		headData.put("CREUSR", map.get("CREUSR"));
		
		try{			
			headData.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			String docnum = commonDao.getMap(headData).getString("DOCNUM");
			
			headData.put("TASKKY", docnum); // head에 TASKKY  put
			
			int taskit = 0;
			String taskir = "0001";
			
			headData.setModuleCommand("taskOrder", "TASDH");
			commonDao.insert(headData);
			
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				itemData.put("CREUSR", map.get("CREUSR"));
				
				if(itemData.get("LOTA07").equals("21SV") && itemData.get("LOTA08").equals("OD")){	// 위탁물류는 이동 불가
					rsMap.put("RESULT", "F");	// 위탁물류는 이동불가 처리
					return rsMap;
				}
				
				taskit+=10;
				itemData.put("TASKKY", headData.get("TASKKY"));
				itemData.put("TASKIT", StringUtil.leftPad(""+ Integer.toString(taskit), "0", 6));
				itemData.put("QTYUOM", itemData.get("QTTAOR"));
				
				DataMap tasdrData  = new DataMap(); // 아이템을 담는다.
				
				tasdrData.put("TASKKY", itemData.get("TASKKY"));
				tasdrData.put("TASKIT", itemData.get("TASKIT"));
				tasdrData.put("TASKIR", taskir);
				tasdrData.put("STOKKY", itemData.get("STOKKY"));
				tasdrData.put("QTSTKM", itemData.get("QTTAOR"));
				tasdrData.put("QTSTKC", "0");
				tasdrData.put("CREUSR", map.get("CREUSR"));
				itemData.put("WAREKY", headData.get("WAREKY"));
				
				
				itemData.setModuleCommand("taskOrder", "VALIDAITON");
				DataMap validaiton = commonDao.getMap(itemData);
				
				// VALIDAITON 체크
				if(Integer.parseInt(validaiton.get("CK_STKKY").toString()) < 1){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0008",new String[]{})); 	//재고키가 존재하지 않을 경우
				}
				
				if(Integer.parseInt(validaiton.get("CK_LOMA").toString()) < 1){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0070",new String[]{})); 	//로케이션이 존재하지 않을 경우
				}
				
				if(Integer.parseInt(validaiton.get("CK_STKKY").toString()) < 1){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0002",new String[]{})); 	//실제 재고가 있는지 확인
				}
				
				/*if(Integer.parseInt(validaiton.get("CK_LOCMA").toString()) < 1){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0070",new String[]{})); 	//TO로케이션 VALDIATION 체크
				}*/
				
				itemData.setModuleCommand("taskOrder", "TASDI");
				commonDao.insert(itemData);
				
				tasdrData.setModuleCommand("taskOrder", "TASDR");
				commonDao.insert(tasdrData);
				
				rsMap.put("RESULT", "S");
				rsMap.put("TASKKY", docnum);
				
			}// end for
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap createTaskOrder1Step(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		List<DataMap> result = new ArrayList();
		
		DataMap headData = headList.get(0).getMap("map");
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		
		headData.put("DOCUTY", headData.get("TASOTY")); // 문서채번을 위한 작업타입 셋팅
		headData.put("CREUSR", map.get("CREUSR"));
		headData.put("QTTAOR", map.get("QTTAOR"));
		headData.put("QTCOMP", map.get("QTTAOR"));
		
		try{
			
			validateTaskOrderDocument(map);
			
			headData.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			String docnum = commonDao.getMap(headData).getString("DOCNUM");
			headData.put("TASKKY", docnum); // head에 TASKKY  put
			headData.put("CREUSR", map.get("CREUSR"));
			map.clonSessionData(headData);
				
			int taskit = 0;
			String taskir = "0001";
			
			headData.setModuleCommand("taskOrder", "TASDH");
			commonDao.insert(headData);
			
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				itemData.put("CREUSR", map.get("CREUSR"));
				
				itemData.put("TASKKY",docnum);
				if(itemData.getString("PTLT06") == null || itemData.getString("PTLT06").equals(" ")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{})); 	//재고속성이 없을 경우
				}
				
				taskit+=10;
				itemData.put("TASKIT", StringUtil.leftPad(""+ Integer.toString(taskit), "0", 6));
				itemData.put("QTYUOM", itemData.get("QTTAOR"));
				map.clonSessionData(itemData);	
				
				DataMap tasdrData  = new DataMap(); // 아이템을 담는다.
				tasdrData.put("TASKKY", docnum);
				tasdrData.put("TASKIT", itemData.get("TASKIT"));
				tasdrData.put("TASKIR", taskir);
				tasdrData.put("STOKKY", itemData.get("STOKKY"));
				tasdrData.put("QTSTKM", itemData.get("QTTAOR"));
				tasdrData.put("QTSTKC", 0);
				tasdrData.put("CREUSR", map.get("CREUSR"));
				map.clonSessionData(tasdrData);
				
				if(itemData.getString("CONFIRM").equals("V") || itemData.getString("CONFIRM").equals("1")){
					itemData.put("STATIT", "FPC");
					itemData.put("QTCOMP", itemData.get("QTTAOR"));
					itemData.put("LOCAAC", itemData.get("LOCATG"));
					itemData.put("SECTAC", itemData.get("SECTTG"));
					itemData.put("PAIDAC", itemData.get("PAIDTG"));
					itemData.put("TRNUAC", itemData.get("TRNUTG"));
					itemData.put("ATRUTY", itemData.get("TTRUTY"));
					itemData.put("AMEAKY", itemData.get("TMEAKY"));
					itemData.put("AUOMKY", itemData.get("TUOMKY"));
					itemData.put("QTAPUM", itemData.get("QTTPUM"));
					itemData.put("ADUOKY", itemData.get("TDUOKY"));
					itemData.put("QTADUM", itemData.get("QTTDUM"));
					itemData.put("SBKTXT", itemData.get("SBKTXT"));
					tasdrData.put("QTSTKC", tasdrData.get("QTSTKM"));
					
					// 수정날짜 셋팅
					Calendar cal = Calendar.getInstance();
					String date = getDate(cal.get(Calendar.YEAR)) +
							      getDate(cal.get(Calendar.MONTH) + 1) +
							      getDate(cal.get(Calendar.DAY_OF_MONTH));
					itemData.put("ACTCDT", date);
	
					date = getDate(cal.get(Calendar.HOUR_OF_DAY)) +
						   getDate(cal.get(Calendar.MINUTE)) +
						   getDate(cal.get(Calendar.SECOND));
					itemData.put("ACTCTI", date);
					
					itemData.setModuleCommand("taskOrder", "TASDI");
					commonDao.insert(itemData);
					
					tasdrData.setModuleCommand("taskOrder", "TASDR");
					commonDao.insert(tasdrData);
					
					rsMap.put("RESULT", "S");
					rsMap.put("TASKKY", docnum);
					
				}
			}
			
			
			
		} catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteMV07(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		try{
			rsMap = deleteTaskOrder(map);
			if(rsMap.isEmpty() || rsMap == null){
				rsMap.put("RESULT", "F1");
				return rsMap;
			}
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		
		return rsMap;
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteTaskOrder(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = new ArrayList();
		
		DataMap tempData = map.getMap("tempItem");
		DataMap headData = new DataMap();
		DataMap itemData = new DataMap(); 
		
		for(DataMap head : headList){
			headData = head.getMap("map");
			String itemTaskky = "";
			
			itemList = map.getList("item");
			if(itemList.size() > 0){
				itemTaskky = itemList.get(0).getMap("map").getString("TASKKY");
			}
			
			if( !headData.getString("TASKKY").equals(itemTaskky) ){
				//템프 사용
				itemList = tempData.getList(headData.getString("TASKKY"));
				
				// 템프에도 없을 경우 itemGrid 조회해서 데이터 가져옴
				if(itemList == null){
					headData.setModuleCommand("taskOrder", "MV07_ITEM");
					itemList = commonDao.getList(headData);
				}
			}

			for(DataMap item : itemList){
				itemData = item.getMap("map");
				
				if(headData.get("TASKKY").equals(itemData.get("TASKKY"))){
					// 1. TASDI 삭제 (TASDI 삭제시 TASDR도 트리거에서 삭제됨.)
					itemData.setModuleCommand("taskOrder", "MV07");
					commonDao.delete(itemData);
					
					itemData.setModuleCommand("taskOrder", "MV07");
					commonDao.update(itemData);
					
				}// end if
			}// end for
		}// end for
		rsMap.put("RESULT", "DELETE_S");
		return rsMap;
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV07(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		try{
			rsMap = confirmTaskOrder(map);
			
			if(rsMap.isEmpty() || rsMap == null){
				rsMap.put("RESULT", "F1");
				return rsMap;
			}
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap confirmTaskOrder(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
//		List<DataMap> itemList = map.getList("item");
		List<DataMap> tasdrList = new ArrayList();
		
		DataMap itemTemp = map.getMap("tempItem");
		DataMap headData = new DataMap();
		DataMap itemData = new DataMap();
		DataMap tasdrData = new DataMap();
		
		String taskky = "";
		String temp_validate = "";
		int sum_qtcomp =0;
		try{
			for(DataMap head : headList ){
				headData = head.getMap("map");
				taskky = headData.getString("TASKKY");
				
				if(headData.get("TASOTY").equals("380")){
					headData.setModuleCommand("SajoCommon", "GET_ZSTCLS3T");
					String docNum = commonDao.getMap(headData).getString("RESULTMSG");
					
					if(docNum.isEmpty() || docNum.equals("")){
						temp_validate = "문서일자를 잘못 입력하였습니다.";
					}else if(docNum.equals("Y")){
						temp_validate = "해당 문서일자는 회계 마감되었습니다.";
					}
					
					if(temp_validate.equals("")){
						rsMap.put("RESULT", "F1");
						return rsMap;
					}
				}// end if

				List<DataMap> itemList = map.getList("item"); 
				
				if(itemList.size() > 0){
					taskky = itemList.get(0).getMap("map").getString("TASKKY");
				}
				
				if( !headData.getString("PHYIKY").equals(taskky) ){
					//템프 사용
					DataMap dMap = (DataMap)map.clone();
					dMap.putAll(headData);
					dMap.setModuleCommand("taskOrder", "MV07_ITEM");
					itemList = commonDao.getList(dMap);
				}
				
				for(DataMap item : itemList){
					itemData = item.getMap("map");
					
					if(headData.get("TASKKY").equals(itemData.get("TASKKY"))){
						// 0. TASDI에 속한 TASDR 정보 조회
						DataMap sqlParams = new DataMap();
						sqlParams.put("TASKKY", itemData.get("TASKKY"));
						sqlParams.put("TASKIT", itemData.get("TASKIT"));
						sqlParams.put("TASKIR", "0001");
			
						sqlParams.setModuleCommand("taskOrder", "TASDR");
						tasdrList = commonDao.getList(sqlParams);
						
						// 1. TASDI 삭제 (TASDI 삭제시 TASDR도 트리거에서 삭제됨.)
						itemData.setModuleCommand("taskOrder", "MV07");
						commonDao.delete(itemData);
						
						// 2. TASDI, TASDR 셋팅
						String qttaor = itemData.get("QTTAOR").toString();
						String qtcomp = itemData.get("QTCOMP").toString();
						if(qttaor.compareTo(qtcomp) == 0){
							itemData.put("STATIT", "FPC");
						}else if(qttaor.compareTo(qtcomp) > 0){
							itemData.put("STATIT", "PPC");
						}
						
						if(headData.get("TASOTY").equals("331") && qttaor.compareTo(qtcomp) < 0){
							itemData.put("QTTAOR", itemData.get("QTCOMP"));
						}
						
						// 수정날짜 셋팅
						Calendar cal = Calendar.getInstance();
						String date = getDate(cal.get(Calendar.YEAR)) +
								      getDate(cal.get(Calendar.MONTH) + 1) +
								      getDate(cal.get(Calendar.DAY_OF_MONTH));
						itemData.put("ACTCDT", date);
		
						date = getDate(cal.get(Calendar.HOUR_OF_DAY)) +
							   getDate(cal.get(Calendar.MINUTE)) +
							   getDate(cal.get(Calendar.SECOND));
						itemData.put("ACTCTI", date);
						
						itemData.put("LOCAAC", itemData.get("LOCATG"));
						itemData.put("SECTAC", itemData.get("SECTTG"));
						itemData.put("PAIDAC", itemData.get("PAIDTG"));
						itemData.put("TRNUAC", itemData.get("TRNUTG"));
						itemData.put("ATRUTY", itemData.get("TTRUTY"));
						itemData.put("AMEAKY", itemData.get("TMEAKY"));
						itemData.put("AUOMKY", itemData.get("TUOMKY"));
						itemData.put("QTAPUM", itemData.get("QTTPUM"));
						itemData.put("ADUOKY", itemData.get("TDUOKY"));
						itemData.put("QTADUM", itemData.get("QTTDUM"));
						
						itemData.put("CREUSR", headData.get("CREUSR"));
						sum_qtcomp += itemData.getInt("QTCOMP");
		
						// 3. TASDI
						itemData.setModuleCommand("taskOrder", "TASDI");
						commonDao.insert(itemData);			
						
						// TASDR 생성
						for(DataMap tasdr : tasdrList){
							tasdrData = tasdr.getMap("map");
							
							tasdrData.put("QTSTKC", itemData.get("QTCOMP"));
							
							tasdrData.setModuleCommand("taskOrder", "TASDR");
							commonDao.insert(tasdrData);
						}
						
					}// end if
				}// end for
				
				headData.put("STATDO", itemData.get("STATIT"));
				headData.put("QTCOMP", sum_qtcomp);
				headData.put("QTTAOR", sum_qtcomp);
				
				headData.setModuleCommand("taskOrder", "TASDH");
				commonDao.update(headData);
			}// end for
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}

	// 날짜 자릿수르 맞춰주기 위한 함수. 1월 -> 01
	public String getDate(int date){
		if(date < 10){
			return "0" + String.valueOf(date);
		}
		
		return String.valueOf(date);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void validateTaskOrderDocument(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData = new DataMap();
		DataMap sqlParams = new DataMap();
		
		StringBuffer sb = new StringBuffer();
		String tasoty = headData.get("TASOTY").toString();
		
		try{
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				
				if(sb.length() > 0){
					sb.append(" UNION ALL \n");
				}
				
				sb.append("SELECT '").append(headData.get("DOCCAT")).append("' AS DOCCAT,");
			      sb.append(" '").append(headData.get("TASOTY")).append("' AS DOCUTY,");
			      sb.append(" '").append(headData.get("WAREKY")).append("' AS WAREKY,");
//			      sb.append(" '").append(tasdh.getWaretg()).append("' AS WARETG,");
//			      sb.append(" '").append(tasdh.getAreaky()).append("' AS AREAKY,");
//			      sb.append(" '").append(tasdh.getAreatg()).append("' AS AREATG,");
			      sb.append(" '").append(itemData.get("LOCASR")).append("' AS LOCASR,");
			      sb.append(" '").append(itemData.get("LOCATG")).append("' AS LOCATG,");
			      sb.append(" '").append(itemData.get("LOCAAC")).append("' AS LOCAAC,");
			      sb.append(" '").append(itemData.get("OWNRKY")).append("' AS OWNRKY,");
//			      sb.append(" '").append(tasdh.getDptnky()).append("' AS DPTNKY,");
			      sb.append(" '").append(itemData.get("SKUKEY")).append("' AS SKUKEY,");
			      sb.append(" '").append(itemData.get("SMEAKY")).append("' AS SMEAKY,");
			      sb.append(" '").append(itemData.get("TMEAKY")).append("' AS TMEAKY,");
			      sb.append(" '").append(itemData.get("AMEAKY")).append("' AS AMEAKY,");
			      sb.append(" '").append(itemData.get("SUOMKY")).append("' AS SUOMKY,");
			      sb.append(" '").append(itemData.get("TUOMKY")).append("' AS TUOMKY,");
			      sb.append(" '").append(itemData.get("AUOMKY")).append("' AS AUOMKY,");
			      sb.append("  ").append(itemData.get("QTTAOR")).append(" AS QTTAOR,");
			      sb.append("  ").append(itemData.get("AVAILABLEQTY")).append(" AS QTYMAX");
//			      sb.append(" '").append(tasdh.getUsrid1()).append("' AS USRID1,");
//			      sb.append(" '").append(tasdh.getUsrid2()).append("' AS USRID2,");
//			      sb.append(" '").append(tasdh.getUsrid3()).append("' AS USRID3,");
//			      sb.append(" '").append(tasdh.getUsrid4()).append("' AS USRID4");
			    sb.append(" FROM DUAL");
				
			    if(headData.get("DOCDAT").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0033",new String[]{}));
			    }
			    
			    if(headData.get("WAREKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0401",new String[]{}));
			    }
			    
			    if(itemData.get("LOCASR").toString().trim().isEmpty() || itemData.get("LOCATG").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0404",new String[]{}));
			    }
			    
			    if(itemData.get("SKUKEY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0406",new String[]{}));
			    }
			    
			    if(itemData.get("SMEAKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407",new String[]{}));
			    }
			    
			    if(itemData.get("SUOMKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420",new String[]{}));
			    }
			    
			    if(itemData.get("TMEAKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407",new String[]{}));
			    }
			    
			    if(itemData.get("TUOMKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420",new String[]{}));
			    }
			    
			    if(!headData.get("STATDO").equals("NEW") && itemData.get("AMEAKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407",new String[]{}));
			    }
			    
			    if(!headData.get("STATDO").equals("NEW") && itemData.get("AUOMKY").toString().trim().isEmpty()){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420",new String[]{}));
			    }
			    
			    // 작업수량
			    if(Integer.compare(itemData.getInt("QTTAOR"), 0) == 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0021",new String[]{}));
			    }
/*			    // 작업수량
			    if(itemData.get("QTTAOR").toString().compareTo("0") == 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0021",new String[]{}));
			    }*/
			    
			    if(Integer.compare(itemData.getInt("QTTAOR"), itemData.getInt("AVAILABLEQTY")) > 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0023",new String[]{}));
			    }	    
/*			    if(itemData.get("QTTAOR").toString().compareTo(itemData.get("AVAILABLEQTY").toString()) > 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0023",new String[]{}));
			    }*/
			        
			    if(Integer.compare(itemData.getInt("QTCOMP"), itemData.getInt("QTTAOR")) > 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0033",new String[]{}));
			    }
/*			    if(itemData.get("QTCOMP").toString().compareTo(itemData.get("QTTAOR").toString()) > 0){
			    	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0033",new String[]{}));
			    }*/
			    
			    String locasr = itemData.get("LOCASR").toString();
				String locatg = itemData.get("LOCATG").toString(); 
				boolean locatgError = false;
				String toloc = "";
				
				if(tasoty.equals("320")|| tasoty.equals("399")){
					if(locatg.equals("RTNLOC") || locatg.equals("SCRLOC") || locatg.equals("SETLOC")){
						toloc = "RTNLOC or SCRLOC or SETLOC";
					}
				}
				
				if(locatgError){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0934",new String[]{}));
				}
				
				if(headData.get("TASOTY").equals("331")){ // 추가출고일 경우에만 비교
					sqlParams.put("SHPOKY", itemData.get("SHPOKY"));
					sqlParams.put("SKUKEY", itemData.get("SKUKEY"));
					sqlParams.put("QTTAOR", itemData.get("QTTAOR"));
					
					sqlParams.setModuleCommand("taskOrder", "ADDSHIP_VALIDATE");
					String resultmsg = commonDao.getMap(sqlParams).getString("RESULTMSG");
					
					if(!resultmsg.equals("OK")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0011",new String[]{}));
					}
				}
			}// end for
			
/*			sqlParams.put("APPENDQUERY", sb.toString());
			sqlParams.setModuleCommand("taskOrder", "VALIDATE");
			DataMap validate =  commonDao.getMap(sqlParams);*/
			
			
			sqlParams.put("APPENDQUERY", sb.toString());
			sqlParams.setModuleCommand("taskOrder", "VALIDATE");
			List<DataMap> validList =  commonDao.getList(sqlParams);
			
			DataMap validate = new DataMap();
			for(DataMap valid : validList){
				validate = valid.getMap("map");
				
				if(!validate.get("RESULTMSG").equals("OK")){
					if(validate.get("RESULTMSG").toString().contains("WAREKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0201",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("LOCAKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0204",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("LOCATG")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0230",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("SKUKEY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0206",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("SMEAKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0207",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("SUOMKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0220",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("TMEAKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0207",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("TUOMKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0220",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("AMEAKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0207",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
					
					if(validate.get("RESULTMSG").toString().contains("AUOMKY")){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0220",new String[]{validate.get("RESULTMSG").toString().substring(7)}));
					}
				}// end if
			}// end for
			

		}catch (Exception e){
			throw new SQLException(e.getMessage());		
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayTO40(DataMap map) throws Exception {
				
		map.setModuleCommand("taskOrder", "TO40_HEAD");
		
		List<DataMap> list = commonDao.getList(map);
		
		return list ;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayTO40Item(DataMap map) throws Exception {
		
		List<DataMap> tasdhList = map.getList("head"); 
		StringBuffer sb = new StringBuffer();
		
		for(DataMap tasdh : tasdhList ){
			tasdh = tasdh.getMap("map");
			
		if(sb.length() > 0){
			sb.append(",");
		}
		sb.append("'").append(tasdh.getString("TASKKY")).append("'");
		}
		map.put("TASKKYS", sb.toString());
		
		map.setModuleCommand("taskOrder", "TO40_ITEM");
		
		List<DataMap> list = commonDao.getList(map);
		
		return list ;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV03(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
			
		try {
			List<DataMap> result =  movingCheck(map);
			
			if(result == null || result.isEmpty()){
				rsMap.put("RESULT", "moving_Sucess");
			}else{
				rsMap.put("RESULT", result);
			}
			
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTaskMV03(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		try{
			rsMap = createTaskOrder1Step(map);
			
			if(rsMap.isEmpty() || rsMap == null){
				rsMap.put("RESULT", "F1");
				return rsMap;
			}
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV05(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
			
		try {
			List<DataMap> result =  movingCheck(map);
			
			if(result == null || result.isEmpty()){
				rsMap.put("RESULT", "moving_Sucess");
			}else{
				rsMap.put("RESULT", result);
			}
			
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTaskMV05(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData = new DataMap();
		String taskky;
		try{
			validateTaskOrderDocument(map);
			
			headData.put("DOCUTY", headData.get("TASOTY"));
			headData.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			 taskky = commonDao.getMap(headData).getString("DOCNUM");

			headData.put("TASKKY", taskky);
			headData.put("CREUSR", map.get("CREUSR"));
			
			// INSERT TASDH
			headData.setModuleCommand("taskOrder", "TASDH");
			commonDao.insert(headData);
			
			int taskit = 0;
			String taskir = "0001";
			String lota03 = map.get("LOTA03").toString();
			String lota05 = map.get("LOTA05").toString();
			String lota06 = map.get("LOTA06").toString();
			String lota11 = map.get("LOTA11").toString();
			String lota12 = map.get("LOTA12").toString();
			String lota13 = map.get("LOTA13").toString();
			
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				
				itemData.put("TASKKY", taskky);
				taskit+=10;
				itemData.put("TASKIT", StringUtil.leftPad(""+ Integer.toString(taskit), "0", 6));
				itemData.put("QTYUOM", itemData.get("QTTAOR"));
				itemData.put("CREUSR", map.get("CREUSR"));
				
				itemData.put("PTLT01", " ");
				itemData.put("PTLT03", lota03.trim().isEmpty() ? " " : lota03);
				itemData.put("PTLT05", lota05.trim().isEmpty() ? " " : lota05);
				itemData.put("PTLT06", lota06.trim().isEmpty() ? " " : lota06);
				itemData.put("PTLT11", lota11.trim().isEmpty() ? " " : lota11);
				itemData.put("PTLT12", lota12.trim().isEmpty() ? " " : lota12);
				itemData.put("PTLT13", lota13.trim().isEmpty() ? " " : lota13);
				
				DataMap tasdrData = new DataMap();
				
				tasdrData.put("TASKKY", taskky);
				tasdrData.put("TASKIT", itemData.get("TASKIT"));
				tasdrData.put("TASKIR", taskir);
				tasdrData.put("STOKKY", itemData.get("STOKKY"));
				tasdrData.put("QTSTKM", itemData.get("QTTAOR"));
				tasdrData.put("QTSTKC", BigDecimal.ZERO);
				
				itemData.put("LOTA03", " ");
				itemData.put("LOTA05", " ");
				itemData.put("LOTA11", " ");
				itemData.put("LOTA12", " ");
				itemData.put("LOTA13", " ");
				itemData.put("TRNUSR", " ");
				itemData.put("TRNUTG", " ");
				itemData.put("TRNUAC", " ");
				itemData.put("PAIDAC", " ");
				itemData.put("PAIDTG", " ");
				
				// 수정날짜 셋팅
				Calendar cal = Calendar.getInstance();
				String actcdt = getDate(cal.get(Calendar.YEAR)) +
						        getDate(cal.get(Calendar.MONTH) + 1) +
   						        getDate(cal.get(Calendar.DAY_OF_MONTH));

				String actcti = getDate(cal.get(Calendar.HOUR_OF_DAY)) +
					            getDate(cal.get(Calendar.MINUTE)) +
					            getDate(cal.get(Calendar.SECOND));
				
				itemData.put("STATIT", "FPC");
				itemData.put("ACTCDT", actcdt);
				itemData.put("ACTCTI", actcti);
				itemData.put("QTCOMP", itemData.get("QTTAOR"));
				itemData.put("LOCAAC", itemData.get("LOCATG"));
				itemData.put("SECTAC", itemData.get("SECTTG"));
				itemData.put("ATRUTY", itemData.get("TTRUTY"));
				itemData.put("AMEAKY", itemData.get("TMEAKY"));
				itemData.put("AUOMKY", itemData.get("TUOMKY"));
				itemData.put("QTAPUM", itemData.get("QTTPUM"));
				itemData.put("ADUOKY", itemData.get("TDUOKY"));
				itemData.put("QTADUM", itemData.get("QTTDUM"));
				
				tasdrData.put("QTSTKC", tasdrData.get("QTSTKM"));
				tasdrData.put("CREUSR", map.get("CREUSR"));
				
				itemData.setModuleCommand("taskOrder", "TASDI");
				commonDao.insert(itemData);
				
				tasdrData.setModuleCommand("taskOrder", "TASDR");
				commonDao.insert(tasdrData);
				
			}// end for

		}catch(Exception e){
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		rsMap.put("TASKKY", taskky);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void chkOutboundOrd(DataMap map) throws SQLException {
		map.setModuleCommand("taskOrder", "MV06_CHKOUTBOUND");
		List<DataMap> chkList = commonDao.getList(map);
		
		try{
			//일괄 출고중 작동안하게 변경
			if(chkList != null && chkList.size() > 0){
				String prcyn = chkList.get(0).get("PRCYN").toString(); 
				if(prcyn.equals("Y")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "M0325",new String[]{}));
				}
			}
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV17(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
			
		try {
			List<DataMap> result =  movingCheck(map);
			
			if(result == null || result.isEmpty()){
				rsMap.put("RESULT", "moving_Sucess");
			}else{
				rsMap.put("RESULT", result);
			}
			
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTaskMV17(DataMap map) throws SQLException,Exception {
		DataMap headRow, itemRow = new DataMap(), rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		String taskky = "";
		
		int taskit = 10;
		DataMap row = new DataMap();
		headRow = headList.get(0).getMap("map");
		map.clonSessionData(headRow);
		
		chkOutboundOrd(map);
		validateTaskOrderDocument(map);
		
		//헤더 생성(TASDH)
		taskky = taskService.createTasdh(headRow);
		
		for(DataMap item : itemList){
			row = item.getMap("map");
			map.clonSessionData(row);
			
			//기반 데이터 세팅
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("TASKKY", taskky);
			row.put("TASKIT", taskit);
			row.put("STATIT","FPC");

			row.put("QTYUOM", row.get("QTTAOR"));
			row.put("QTCOMP", row.get("QTTAOR"));
			row.put("LOCAAC", row.get("LOCATG"));
			row.put("SECTAC", row.get("SECTTG"));
			row.put("PAIDAC", row.get("PAIDTG"));
			row.put("TRNUAC", row.get("TRNUTG"));
			row.put("ATRUTY", row.get("TTRUTY"));
			row.put("AMEAKY", row.get("TMEAKY"));
			row.put("AUOMKY", row.get("TUOMKY"));
			row.put("QTAPUM", row.get("QTTPUM"));
			row.put("ADUOKY", row.get("TDUOKY"));
			row.put("QTADUM", row.get("QTTDUM"));
			row.put("SBKTXT", row.get("SBKTXT")); 
			row.put("QTSTKM", row.get("QTTAOR"));
			row.put("QTSTKC", row.get("QTSTKM"));	
			row.put("TASKIR", "0001");
			row.put("AREAKY", "R");
			
			row.put("LOTA03", " ");
			row.put("LOTA05", " ");
			row.put("LOTA11", " ");
			row.put("LOTA12", " ");
			row.put("LOTA13", " ");
			
			row.put("TRNUSR", " ");
			row.put("TRNUTG", " ");
			row.put("TRNUAC", " ");
			row.put("PAIDAC", " ");
			row.put("PAIDSR", " ");
			row.put("PAIDTG", " ");
			
			//TASDI 생성 
			taskService.createTasdi(row);
			//TASDR 생성 
			taskit = taskService.createTasdr(row);
			
			//TASDI 생성
//			row.setModuleCommand("taskOrder", "TASDI");
//			commonDao.insert(row);
//			//TASDR 생성
//			row.setModuleCommand("taskOrder", "TASDR");
//			commonDao.insert(row);
			
		}
		
		
		rtnMap.put("RESULT", "S");
		rtnMap.put("TASKKY", taskky);
		
		return rtnMap;
	}
	
	// [MV06] 재고병합 - 일괄 출고중 작동 안하게 변경
	@Transactional(rollbackFor = Exception.class)
	public DataMap checkMV06(DataMap map) throws SQLException {
		DataMap result = new DataMap();
		
		List<DataMap> headList = map.getList("head");
		DataMap head = headList.get(0).getMap("map");
		String wareky = head.getString("WAREKY");
		result.put("WAREKY", wareky);
		
		map.clonSessionData(result);
		result.setModuleCommand("taskOrder", "MV06_CHECKOUT");
		
		List<DataMap> resultList =  commonDao.getList(result);
		
		// 일괄 출고 중 작동안하게 변경
		if(resultList != null && resultList.size() > 0) {
			if(resultList.get(0).get("PRCYN").equals("Y")) {
				map = new DataMap();
				map.put("RESULT", "M");
				map.put("M", "일괄 출고 중 작동안하게 변경");
			} else {
				map.put("resultList", resultList);
			}
		} else {
			map = new DataMap();
			map.put("RESULT", "M");
			map.put("M", "resultList SIZE 0");
		}
		
		return map;
	} // end checkMV06()
	
	// [MV06] 재고병합 RRRRRRR 로 SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap firstSaveMV06(DataMap map) throws SQLException {			
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;

		String taskky = null;
		
		String creusr = map.getString("CREUSR");
		String ownrky = map.getString("OWNRKY");
		String wareky = map.getString("WAREKY");
		
		// taskky 를 얻어오기 위하여 head에 있는 TASOTY 값 필요
		List<DataMap> headList = map.getList("head");
		DataMap head = headList.get(0).getMap("map"); // head는 0번 인덱스만 존재
		head.put("OWNRKY", ownrky);
		head.put("WAREKY", wareky);
		
		map.clonSessionData(head); // map에 있는 사용자 정보를 head에 삽입		
	
		// TASDH 필요값 셋팅
		head.put("CREUSR", creusr);
		head.put("LMOUSR", creusr);
		
		// 날짜는 TaskDataService 의 쿼리에서 SYSDATE 로 설정됨.
		taskky = taskService.createTasdh(head); // head의 트랜잭션은 여기서 실행 
	
		
		List<DataMap> itemList = map.getList("item");
		int taskit = 10; // 구버전 반복 시작과 동시에 숫자가 늘지만
		// createTasdr 트랜잭션을 실행해야 10이 늘음으로, 
		// default 10을 줌
		String emptyChar = " ";
		String taskir = "0001";
		String lota03 = map.getString("LOTA03");
		String lota05 = map.getString("LOTA05");
		String lota06 = map.getString("LOTA06");
		String lota11 = map.getString("LOTA11").replaceAll("//.", "");
		String lota12 = map.getString("LOTA12").replaceAll("//.", "");
		String lota13 = map.getString("LOTA13").replaceAll("//.", "");
		String locaac = map.getString("LOCAAC");
		int Qttaor = 0;
		String currentDate = new SimpleDateFormat("yyyy-mm-dd").format(new Date());
		String currentTime = new SimpleDateFormat("HH:mm:ss").format(new Date());
		
		for(DataMap listItem : itemList) {
			try {
				DataMap item = listItem.getMap("map");
				map.clonSessionData(item); // map에 있는 사용자 정보를 item에 삽입
				
				item.put("OWNRKY", ownrky);
				item.put("WAREKY", wareky);
				
				item.put("TASKKY", taskky);
				item.put("TASKIT", StringUtil.leftPad(Integer.toString(taskit), "0", 6));
				item.put("QTYUOM", item.getString("QTTAOR"));
				item.put("CREDAT", currentDate);
				item.put("CRETIM", currentTime);
				item.put("CREUSR", creusr);
				item.put("LMODAT", currentDate);
				item.put("LMOTIM", currentTime);
				item.put("LMOUSR", creusr);
				
				item.put("LOTA03", emptyChar);
				item.put("LOTA05", emptyChar);
				// item.put("Lota06".toUpperCase(), emptyChar);
				item.put("LOTA11", emptyChar);
				item.put("LOTA12", emptyChar);
				item.put("LOTA13", emptyChar);
				
				item.put("PTLT01", emptyChar);
				item.put("PTLT03", lota03.trim().isEmpty() ? " " : lota03);
				item.put("PTLT05", lota05.trim().isEmpty() ? " " : lota05);
				item.put("PTLT06", lota06.trim().isEmpty() ? " " : lota06);
				item.put("PTLT11", lota11.trim().isEmpty() ? " " : lota11);
				item.put("PTLT12", lota12.trim().isEmpty() ? " " : lota12);
				item.put("PTLT13", lota13.trim().isEmpty() ? " " : lota13);
				log.info("\t\t\t\t\t\t\t\t\t item : {}", item);
			
				
				DataMap tasdr = new DataMap();
				map.clonSessionData(tasdr);
				
				tasdr.put("OWNRKY", ownrky);
				tasdr.put("WAREKY", wareky);
				
				tasdr.put("TASKKY", taskky);
				tasdr.put("TASKIT", item.getString("TASKIT"));
				tasdr.put("TASKIR", taskir);
				tasdr.put("STOKKY", item.getString("STOKKY"));
				tasdr.put("QTSTKM", item.getString("QTTAOR"));
				tasdr.put("QTSTKC", BigDecimal.ZERO);
				tasdr.put("CREDAT", currentDate);
				tasdr.put("CRETIM", currentTime);
				tasdr.put("CREUSR", creusr);
				tasdr.put("LMODAT", currentDate);
				tasdr.put("LMOTIM", currentTime);
				tasdr.put("LMOUSR", creusr);
				
				item.put("STATIT", "FPC");
				item.put("ACTCDT", currentDate);
				item.put("ACTCTI", currentTime);
				item.put("QTCOMP", item.getString("QTTAOR"));
				item.put("LOCAAC", item.getString("LOCATG"));
			
				item.put("TRNUSR", emptyChar);
				item.put("TRNUTG", emptyChar);
				item.put("TRNUAC", emptyChar);
				item.put("PAIDAC", emptyChar);
				item.put("PAIDSR", emptyChar);
				item.put("PAIDTG", emptyChar);
				
				item.put("SECTAC", item.getString("SECTTG"));
				// item.put("Paidac".toUpperCase(), item.getString("Paidtg".toUpperCase()));
				item.put("ATRUTY", item.getString("TTRUTY"));
				item.put("AMEAKY", item.getString("TMEAKY"));
				item.put("AUOMKY", item.getString("TUOMKY"));
				item.put("QTAPUM", item.getString("QTTPUM"));
				item.put("ADUOKY", item.getString("TDUOKY"));
				item.put("QTADUM", item.getString("QTTDUM"));
				
				tasdr.put("QTSTKC", tasdr.getString("QTSTKM"));
				
				taskService.createTasdi(item); // taskh 트랜잭션
				taskit = taskService.createTasdr(tasdr); // taskr 트랜잭션
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		map.put("firstSaveHead", headList);
		map.put("firstSaveItem", itemList);
		
		
		return map;
	} // end firstSaveMV06();
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap findAvailableStockMergeMV06(DataMap map) throws SQLException {
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;
		
		String ownrky = map.getString("OWNRKY");
		String wareky = map.getString("WAREKY");
		String lota03 = map.getString("LOTA03");
		String lota05 = map.getString("LOTA05");
		String lota06 = map.getString("LOTA06");
		String lota11 = map.getString("LOTA11");
		String lota12 = map.getString("LOTA12");
		String lota13 = map.getString("LOTA13");

		DataMap sqlParam = new DataMap();
		sqlParam.put("OWNRKY", ownrky);
		sqlParam.put("WAREKY", wareky);
		sqlParam.put("LOTA03", lota03);
		sqlParam.put("LOTA05", lota05);
		sqlParam.put("LOTA06", lota06);
		sqlParam.put("LOTA11", lota11);
		sqlParam.put("LOTA12", lota12);
		sqlParam.put("LOTA13", lota13);
		
		
		
		List<DataMap> resultHeadList = map.getList("firstSaveHead");
		List<DataMap> resultItemList = map.getList("firstSaveItem");
		
		List<DataMap> tasdiReIList = null;
		sqlParam.put("LOCASR",resultItemList.get(0).getMap("map").getString("LOCASR"));
		
		map.clonSessionData(sqlParam);
		sqlParam.setModuleCommand("taskOrder", "MV06_FINDVAILABLESTOCKMERGE");

		tasdiReIList = commonDao.getList(sqlParam);	
		
		if(tasdiReIList == null || tasdiReIList.size() <= 0) {
			map = new DataMap();
			map.put("RESULT", "M");
			map.put("M", "tasdiReIList == null || tasdiReIList.size() <= 0");
		}  else {
			map.put("tasdiReIList", tasdiReIList);
			map.put("tasdiReHList", resultHeadList);
		}
		
		return map;
	} // end findAvailableStockMergeMV06()

	
	@Transactional(rollbackFor = Exception.class)
	public DataMap secondSaveMV06(DataMap map) throws SQLException {
		
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;

		String taskky = null;
		DataMap result = new DataMap();;
		
		String creusr = map.getString("CREUSR");
		String ownrky = map.getString("OWNRKY");
		String wareky = map.getString("WAREKY");
		
		// taskky 를 얻어오기 위하여 head에 있는 TASOTY 값 필요
		List<DataMap> headList = map.getList("tasdiReHList");
		DataMap head = headList.get(0).getMap("map"); // head는 0번 인덱스만 존재
		
		map.clonSessionData(head); // map에 있는 사용자 정보를 head에 삽입		
	
		head.put("OWNRKY", ownrky);
		head.put("WAREKY", wareky);
		
		// TASDH 필요값 셋팅
		head.put("CREUSR", creusr);
		head.put("LMOUSR", creusr);
		head.put("TASKKY", " ");
		// 날짜는 TaskDataService 의 쿼리에서 SYSDATE 로 설정됨.
		taskky = taskService.createTasdh(head); // head의 트랜잭션은 여기서 실행 
		
		List<DataMap> itemList = map.getList("tasdiReIList"); 
		int taskit = 10; // 구버전 반복 시작과 동시에 숫자가 늘지만
		// createTasdr 트랜잭션을 실행해야 10이 늘음으로, 
		// default 10을 줌
		String emptyChar = " ";
		String taskir = "0001";
		String lota03 = map.getString("LOTA03");
		String lota05 = map.getString("LOTA05");
		String lota06 = map.getString("LOTA06");
		String lota11 = map.getString("LOTA11");
		String lota12 = map.getString("LOTA12");
		String lota13 = map.getString("LOTA13");
		String locaac = map.getString("locaac".toUpperCase());
		int Qttaor = 0;
		String currentDate = new SimpleDateFormat("yyyy-mm-dd").format(new Date());
		String currentTime = new SimpleDateFormat("HH:mm:ss").format(new Date());
		
		
		for(DataMap listItem : itemList) {
			try {
				DataMap item = listItem.getMap("map");
				map.clonSessionData(item); // map에 있는 사용자 정보를 item에 삽입
				
				item.put("OWNRKY", ownrky);
				item.put("WAREKY", wareky);
	
				item.put("Taskky".toUpperCase(), taskky);
				item.put("Taskit".toUpperCase(), StringUtil.leftPad(Integer.toString(taskit), "0", 6));
				item.put("Qtyuom".toUpperCase(), item.getString("Qttaor".toUpperCase()));
				item.put("Credat".toUpperCase(), currentDate);
				item.put("Cretim".toUpperCase(), currentTime);
				item.put("Creusr".toUpperCase(), creusr);
				item.put("Lmodat".toUpperCase(), currentDate);
				item.put("Lmotim".toUpperCase(), currentTime);
				item.put("Lmousr".toUpperCase(), creusr);
				
				item.put("Ptlt03".toUpperCase(), lota03.trim().isEmpty() ? " " : lota03);
				item.put("Ptlt05".toUpperCase(), lota05.trim().isEmpty() ? " " : lota05);
				item.put("Ptlt06".toUpperCase(), lota06.trim().isEmpty() ? " " : lota06);
				item.put("Ptlt11".toUpperCase(), lota11.trim().isEmpty() ? " " : lota11);
				item.put("Ptlt12".toUpperCase(), lota12.trim().isEmpty() ? " " : lota12);
				item.put("Ptlt13".toUpperCase(), lota13.trim().isEmpty() ? " " : lota13);
				
				DataMap tasdr = new DataMap();
				map.clonSessionData(tasdr);
				
				tasdr.put("OWNRKY", ownrky);
				tasdr.put("WAREKY", wareky);
				
				tasdr.put("TASKKY".toUpperCase(), taskky);
				tasdr.put("TASKIT".toUpperCase(), item.getString("Taskit".toUpperCase()));
				tasdr.put("TASKIR".toUpperCase(), taskir);
				tasdr.put("STOKKY".toUpperCase(), item.getString("Stokky".toUpperCase()));
				tasdr.put("QTSTKM".toUpperCase(), item.getString("Qttaor".toUpperCase()));
				tasdr.put("QTSTKC".toUpperCase(), BigDecimal.ZERO);
				tasdr.put("CREDAT".toUpperCase(), currentDate);
				tasdr.put("CRETIM".toUpperCase(), currentTime);
				tasdr.put("CREUSR".toUpperCase(), creusr);
				tasdr.put("LMODAT".toUpperCase(), currentDate);
				tasdr.put("LMOTIM".toUpperCase(), currentTime);
				tasdr.put("LMOUSR".toUpperCase(), creusr);
				
				item.put("Statit".toUpperCase(), "FPC");
				item.put("Actcdt".toUpperCase(), currentDate);
				item.put("Actcti".toUpperCase(), currentTime);
				item.put("Qtcomp".toUpperCase(), item.getString("Qttaor".toUpperCase()));
				item.put("Locaac".toUpperCase(), locaac);
			
			
				Qttaor += item.getInt("QTTAOR");	
				
				
				head.put("QTTAOR".toUpperCase(), Qttaor);
				head.put("Qtcomp".toUpperCase(), Qttaor);
				
				item.put("Sectac".toUpperCase(), item.getString("Secttg".toUpperCase()));
				// item.put("Paidac".toUpperCase(), item.getString("Paidtg".toUpperCase()));
				item.put("ATRUTY".toUpperCase(), item.getString("Ttruty".toUpperCase()));
				item.put("AMEAKY".toUpperCase(), item.getString("Tmeaky".toUpperCase()));
				item.put("AUOMKY".toUpperCase(), item.getString("Tuomky".toUpperCase()));
				item.put("QTAPUM".toUpperCase(), item.getString("Qttpum".toUpperCase()));
				item.put("ADUOKY".toUpperCase(), item.getString("Tduoky".toUpperCase()));
				item.put("QTADUM".toUpperCase(), item.getString("Qttdum".toUpperCase()));
				
				
				tasdr.put("Qtstkc".toUpperCase(), tasdr.getString("Qtstkm".toUpperCase()));
			
				taskService.createTasdi(item); // taskh 트랜잭션
				taskit = taskService.createTasdr(tasdr); // taskr 트랜잭션
				
				result.put("RESULT", "S");
				result.put("TASKKY", taskky);
			} catch (Exception e) {
				result.put("RESULT", "F");
			}
		}
		
		return result;
	} // end secondSaveMV06()
	
	// [MV12] 제고이동 - 사용가능한 재고 항목 찾기 (CREATE2)
	@Transactional(rollbackFor = Exception.class)
	public DataMap findAvailableStockMV12(DataMap map) throws SQLException {

		List<DataMap> headList = map.getList("head");
		DataMap head  = headList.get(0).getMap("map");
		List<DataMap> itemList3 = map.getList("item3");
		
		List<DataMap> findAvailableStock = new ArrayList<DataMap>(); 
		
		DataMap avaliabStock = null;
		for(DataMap itemMap : itemList3) {
			
			DataMap item = itemMap.getMap("map");			
			item.put("OWNRKY", map.getString("OWNRKY"));
			item.put("WAREKY", map.getString("WAREKY"));
			item.put("PLTQTY", item.getString("PLTQTYOR"));
			item.put("BOXQTY", item.getString("BOXQTYOR"));
			item.put("LOTA06", item.getString("LOTA06"));
			item.put("LOTA05", item.getString("LOTA05"));
			item.put("TASRSN", item.getString("TASRSN"));
			item.put("STATDO", map.getString("STATDO"));
	        
			map.put("SQLPARAMS", item);
			
			avaliabStock = findAvailableStockItemMV12(map);
			if(avaliabStock != null) {
				if(avaliabStock.getString("RESULT") != null) {		
					String checkMsg = avaliabStock.getString("RESULT");
					
					if(!checkMsg.equals("")) return avaliabStock;
				}
				avaliabStock.put("CONFIRM", " ");
				avaliabStock.put("DOORKY", " ");
				findAvailableStock.add(avaliabStock);
		    }
		}
		
		map.put("FINDAVAILABLESTOCK", findAvailableStock);
		
		return map;
		
	} // end findAvailableStockMV12()
	
	// [MV12] 제고이동 - 사용가능한 재고 항목 찾기 (CREATE2)
	@Transactional(rollbackFor = Exception.class)
	private DataMap findAvailableStockItemMV12(DataMap map) throws SQLException {
		DataMap sqlParams = map.getMap("SQLPARAMS");
		
		map.getList("head");
		map.getList("item3");
		
		// 3개중 어느걸로 들어올지 알 수 없으니 전부 수량 체크
		String qttaor = (StringUtil.isEmpty(sqlParams.getString("QTTAOR")) == false) ? sqlParams.getString("QTTAOR") : "0"; // 49
		String boxQty = (StringUtil.isEmpty(sqlParams.getString("BOXQTY")) == false) ? sqlParams.getString("BOXQTY") : "0"; // 49.8
		String pltqty = (StringUtil.isEmpty(sqlParams.getString("PLTQTY")) == false) ? sqlParams.getString("PLTQTY") : "0"; // 0.83
		BigDecimal qty  = null;
		
		map.clonSessionData(sqlParams);
		sqlParams.setModuleCommand("taskOrder", "MV12_STOCKMV12");
		List<DataMap> avaliableList = commonDao.getList(sqlParams);
		
		if(avaliableList != null || avaliableList.size() > 0) {		
			// 필터링 1단계 체크 (팔레트)
			for(DataMap avaliable : avaliableList) {
				DataMap stock = avaliable.getMap("map");

		    	qty = ("0.000".equals(qttaor)) ? (("0.000".equals(boxQty)) ? new BigDecimal(pltqty).multiply(new BigDecimal(stock.getString("PLIQTY"))) : new BigDecimal(boxQty).multiply(new BigDecimal(stock.getString("QTTDUM"))))   : new BigDecimal(qttaor);
		    	if(!"1".equals(stock.getString("CONFIRM")) && new BigDecimal(stock.getString("PLTQTY")).compareTo(new BigDecimal("1")) == -1) {
		    		if(new BigDecimal(stock.getString("AVAILABLEQTY")).compareTo(qty) > -1) {
		    			return stock;
		    		}
		    	}
			}
						
			//필터링 2단계 체크 (P존)
			for(DataMap avaliable : avaliableList) {
				DataMap stock = avaliable.getMap("map");
				
				qty = ("0.000".equals(qttaor)) ? (("0.000".equals(boxQty)) ? new BigDecimal(pltqty).multiply(new BigDecimal((stock.getString("PLIQTY")))) : new BigDecimal(boxQty).multiply(new BigDecimal(stock.getString("QTTDUM"))))   : new BigDecimal(qttaor);
				if("1".equals(stock.getString("CONFIRM"))){ //P존
					if(new BigDecimal(stock.getString("AVAILABLEQTY")).compareTo(qty) > -1) {
						return stock;
					}
				}
			}
			
			//필터링 3단계 체크 수량만
			for(DataMap avaliable : avaliableList) {
				DataMap stock = avaliable.getMap("map");
				
				qty = ("0.000".equals(qttaor)) ? (("0.000".equals(boxQty)) ? new BigDecimal(pltqty).multiply(new BigDecimal((stock.getString("PLIQTY")))) : new BigDecimal(boxQty).multiply(new BigDecimal(stock.getString("QTTDUM"))))   : new BigDecimal(qttaor);
				if(new BigDecimal(stock.getString("AVAILABLEQTY")).compareTo(qty) > -1){
					return stock;
				}
			}
		} // end if

		//대상 찾지 못했을 시
		StringBuffer sb = new StringBuffer();	 
		sb.append("제품키  : ").append( sqlParams.getString("SKUKEY")).append(", 수량  : ").append(sqlParams.getString("QTTAOR"));
		sb.append(", TO로케이션 : ").append(sqlParams.getString("LOCATG")).append(", FROM 재고유형 : ").append(sqlParams.getString("LOTA06"));
		sb.append(" 조건에 맞는 재고가 없습니다.");
		map = new DataMap();
		map.put("RESULT", "M");
		map.put("M", sb.toString());
		
		return map;

	} // end findAvailableStockItemMV12()
	
	// [MV12] 제고이동 movingCheck (movingCheck)
	@Transactional(rollbackFor = Exception.class)
	public DataMap movingCheckMV12(DataMap map) throws SQLException {
		
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;
		
		StringBuffer sb = new StringBuffer();
		
		List<DataMap> itemList = map.getList("item4");
		
		for(DataMap item : itemList) {
			if(sb.length() > 0) sb.append(" UNION ALL \n");
			sb.append("SELECT '").append(map.getString("WAREKY")).append("' AS WAREKY,");
			sb.append(" '").append(item.getMap("map").getString("LOCATG")).append("' AS LOCAKY ");
			sb.append(" FROM DUAL");
		}
		
		DataMap appendQuery = new DataMap();
		appendQuery.put("APPENDQUERY", sb.toString());
		
		map.clonSessionData(appendQuery);
		appendQuery.setModuleCommand("taskOrder", "MV12_MOVING");
		List<DataMap> movingCheckList = commonDao.getList(appendQuery);
		
		map.put("MOVINGCHECKLIST", movingCheckList);
		
		return map;
	} // end movingCheckMV12()
	
	// [MV12] 제고이동 validateTaskOrderDocument
	@Transactional(rollbackFor = Exception.class)
	public DataMap validateMV12(DataMap map) throws SQLException {
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;
		
		DataMap appendQuery = new DataMap();
		DataMap sqlParams = null;
		StringBuffer sb = new StringBuffer();
		
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("FINDAVAILABLESTOCK");
		
		DataMap head = headList.get(0).getMap("map");
	
		String tasoty = head.getString("TASOTY");
		
		for(DataMap itemMap : itemList) {
			DataMap item = itemMap.getMap("map");
			
			if(sb.length() > 0) sb.append(" UNION ALL \n");
			sb.append("SELECT '").append(head.getString("DOCCAT")).append("' AS DOCCAT,");
		    sb.append(" '").append(head.getString("TASOTY")).append("' AS DOCUTY,");
		    sb.append(" '").append(head.getString("WAREKY")).append("' AS WAREKY,");
		    sb.append(" '").append(item.getString("LOCASR")).append("' AS LOCASR,");
		    sb.append(" '").append(item.getString("LOCATG")).append("' AS LOCATG,");
		    sb.append(" '").append(item.getString("OWNRKY")).append("' AS OWNRKY,");
		    sb.append(" '").append(item.getString("SKUKEY")).append("' AS SKUKEY,");
		    sb.append(" '").append(item.getString("SMEAKY")).append("' AS SMEAKY,");
		    sb.append(" '").append(item.getString("TMEAKY")).append("' AS TMEAKY,");
		    sb.append(" '").append(item.getString("SUOMKY")).append("' AS SUOMKY,");
		    sb.append(" '").append(item.getString("TUOMKY")).append("' AS TUOMKY,");
		    sb.append("  ").append(item.getString("QTTAOR")).append(" AS QTTAOR,");
		    sb.append(" '").append(item.getString("LOCASR")).append("' AS LOCAAC,");
		    sb.append("  ").append(item.getString("AVAILABLEQTY")).append(" AS QTYMAX,");
		    sb.append(" '").append(item.getString("SMEAKY")).append("' AS AMEAKY,");
		    sb.append(" '").append(item.getString("TUOMKY")).append("' AS AUOMKY");
		    sb.append(" FROM DUAL");
		    
			if(head.getString("DOCDAT").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "IN_M0033");
				return map;
			}
			
			if(head.getString("WAREKY").trim().isEmpty()){	
				map.put("RESULT", "M");
				map.put("M", "VALID_M0401");
				return map;
			}

			if(item.getString("LOCASR").trim().isEmpty() || item.getString("LOCATG").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0404");
				return map;
			}
			

			if(item.getString("SKUKEY").trim().isEmpty()){		
				map.put("RESULT", "M");
				map.put("M", "VALID_M0406");
				return map;
			}

			if(item.getString("SMEAKY").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0407");
				return map;
			}

			if(item.getString("SUOMKY").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0420");
				return map;
			}

			if(item.getString("TMEAKY").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0407");
				return map;
			}

			if(item.getString("TUOMKY").trim().isEmpty()){			
				map.put("RESULT", "M");
				map.put("M", "VALID_M0420");
				return map;
			}

			if(!item.getString("STATDO").equals("NEW") && item.getString("AMEAKY").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0407");
				return map;
			}

			if(!item.getString("STATDO").equals("NEW") && item.getString("AUOMKY").trim().isEmpty()){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0420");
				return map;
			}

			if(new BigDecimal(item.getString("QTTAOR")).compareTo(BigDecimal.ZERO) == 0){				
				map.put("RESULT", "M");
				map.put("M", "TASK_M0021");
				return map;
			}
			
			if(item.getString("QTTAOR").compareTo(item.getString("AVAILABLEQTY")) > 0){
				map.put("RESULT", "M");
				map.put("M", "TASK_M0023");
				return map;
			}
			
			if(item.getString("QTCOMP").compareTo(item.getString("QTTAOR")) > 0){				
				map.put("RESULT", "M");
				map.put("M", "TASK_M0033");
				return map;
			}
			
			String locasr = item.getString("LOCASR");
			String locatg = item.getString("LOCATG");
			boolean locatgError = false;
			String toloc = "";
			if(tasoty.equals("320") || tasoty.equals("399")){
				if(locatg.equals("RTNLOC") || locatg.equals("SCRLOC") || locatg.equals("SETLOC")){
					//locatgError = true;
					toloc = "RTNLOC or SCRLOC or SETLOC";
				}
			}
			
			if(locatgError){
				map.put("RESULT", "M");
				map.put("M", "VALID_M0934");
				return map;
			}
			
			if(head.getString("TASOTY").equals("331")){  // 추가출고일 경우에만 비교	
				sqlParams = new DataMap();
				sqlParams.put("SHPOKY", item.getString("SHPOKY"));
				sqlParams.put("SKUKEY", item.getString("SKUKEY"));
				sqlParams.put("QTTAOR", item.getString("QTTAOR"));
				
				map.clonSessionData(sqlParams);
				sqlParams.setModuleCommand("taskOrder", "MV12_ADDVALIDATION");
				
				DataMap valiAddShip =  commonDao.getMap(sqlParams);
				
				if(!valiAddShip.getString("RESULTMSG").equals("OK")) {	
					map.put("RESULT", "M");
					map.put("M", "VALID_M0011");
					return map;
				}

			}
			
		} // end for
		
		appendQuery.put("APPENDQUERY", sb.toString());
		map.clonSessionData(appendQuery);
		appendQuery.setModuleCommand("taskOrder", "MV12_VALIDATE");
		
		List<DataMap> valiList = commonDao.getList(appendQuery);
		if(valiList != null && valiList.size() > 0) {
			for(DataMap valiMap : valiList) {
				DataMap vali = valiMap.getMap("map");
				if(!vali.getString("RESULTMSG").equals("OK")) {
					
					if(vali.getString("RESULTMSG").contains("WAREKY")) {
						map.put("RESULT", "M");
						map.put("M", "VALID_M0201");
						return map;
					}
					
					
					if(vali.getString("RESULTMSG").contains("LOCAKY")){
						map.put("RESULT", "M");
						map.put("M", "VALID_M0204");
						return map;
					}
					
					if(vali.getString("RESULTMSG").contains("LOCATG")){						
						map.put("RESULT", "M");
						map.put("M", "VALID_M0230");
						return map;
					}
					

					if(vali.getString("RESULTMSG").contains("SKUKEY")){				
						map.put("RESULT", "M");
						map.put("M", "VALID_M0206");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("SMEAKY")){
						map.put("RESULT", "M");
						map.put("M", "VALID_M0207");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("SUOMKY")){
						map.put("RESULT", "M");
						map.put("M", "VALID_M0220");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("TMEAKY")){
						map.put("RESULT", "M");
						map.put("M", "VALID_M0207");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("TUOMKY")){					
						map.put("RESULT", "M");
						map.put("M", "VALID_M0220");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("AMEAKY")){
						map.put("RESULT", "M");
						map.put("M", "VALID_M0207");
						return map;
					}

					if(vali.getString("RESULTMSG").contains("AUOMKY")){					
						map.put("RESULT", "M");
						map.put("M", "VALID_M0220");
						return map;
					}
					
				} // end if
			} // end for
		} // end if

		map.put("VALIDATIONITEM", itemList);
		return map;
		
	} // end validateMV12()
	
	
	// [MV12] 제고이동 firstSave
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV12(DataMap map) throws SQLException {
		
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;
		
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("VALIDATIONITEM");
		
		DataMap head = headList.get(0).getMap("map");
		
		
		String date = new SimpleDateFormat("yyyy-mm-dd").format(new Date());
		String time = new SimpleDateFormat("HH:mm:ss").format(new Date());
		
		map.clonSessionData(head);
		head.put("CREDAT", date);
		head.put("CRETIM", time);
		head.put("SES_USER_ID", map.getString("SES_USER_ID"));

		String taskky = taskService.createTasdh(head); // head의 트랜잭션은 여기서 실행
		head.put("TASKKY", taskky);
		
		try {	
			int taskit = 10; // 구버전 반복 시작과 동시에 숫자가 늘지만
			// createTasdr 트랜잭션을 실행해야 10이 늘음으로, 
			// default 10을 줌
			String taskir = "0001";
			for(DataMap itemMap : itemList) {
				DataMap item = itemMap.getMap("map");
				
				if("21SV".equals(item.getString("LOTA07")) && "OD".equals(item.getString("LOTA08"))) {
					map.put("RESULT", "M");
					map.put("M", "VALID_M0009");
				}
				
				item.put("WAREKY", head.getString("WAREKY"));
				item.put("TASKKY", taskky);
				item.put("TASKIT", StringUtil.leftPad(Integer.toString(taskit), "0", 6));
				item.put("QTYUOM", item.getString("QTTAOR"));
				item.put("CREDAT", date);
				item.put("CRETIM", time);
				item.put("SES_USER_ID", map.getString("SES_USER_ID"));
				item.put("ACTCDT", "Y");
				
				DataMap tasdr = new DataMap();
				tasdr.put("TASKKY", taskky);
				tasdr.put("TASKIT", item.getString("TASKIT"));
				tasdr.put("TASKIR", taskir);
				tasdr.put("STOKKY", item.getString("STOKKY"));
				tasdr.put("QTSTKM", item.getString("QTTAOR"));
				tasdr.put("QTSTKC", BigDecimal.ZERO);

				tasdr.put("SES_USER_ID", map.getString("SES_USER_ID"));
				tasdr.put("LMODAT", map.getString(date));
				tasdr.put("LMOTIM", map.getString(time));
				
				taskService.createTasdi(item);
				taskService.createTasdr(tasdr);
		
			} // end for
		} catch(Exception e) {
			map.put("RESULT", "M");
			map.put("M", "VALID_M0009");
			return map;
		} // end try
		
		map.put("FIRSTSAVEHEAD", headList);
		map.put("FIRSTSAVEITEM", itemList);
		
		return map;
	} // end firstSaveMV12()
	
	// [MV12] 제고이동 
	@Transactional(rollbackFor = Exception.class)
	public DataMap confirmSaveMV12(DataMap map) throws SQLException {
		
		String checkMsg = map.getString("RESULT");
		
		if(!checkMsg.equals("")) return map;
		
		String date = new SimpleDateFormat("yyyy-mm-dd").format(new Date());
		String time = new SimpleDateFormat("HH:mm:ss").format(new Date());
		
		List<DataMap> headList = map.getList("FIRSTSAVEHEAD");
		List<DataMap> itemList = map.getList("FIRSTSAVEITEM");
		
		DataMap head = headList.get(0).getMap("map");
		
		DataMap sqlParams = new DataMap();
		map.clonSessionData(sqlParams);
		sqlParams.setModuleCommand("taskOrder", "MV12_HEADCONFIRM");
		sqlParams.put("OWNRKY", map.getString("OWNRKY"));
		sqlParams.put("WAREKY", map.getString("WAREKY"));
		sqlParams.put("TASKKY", head.getString("TASKKY"));
		
		//Header Item 가져옴
		List<DataMap> resultHeadList = commonDao.getList(sqlParams);
		
		if(resultHeadList == null || resultHeadList.size() <= 0) {
			map.put("RESULT", "M");
			map.put("M", "The size of the list is 0");
			return map;
		}
		
		StringBuffer sb = new StringBuffer();
		for(DataMap resultHeadMap : resultHeadList) {
			DataMap resultHead = resultHeadMap.getMap("map");
			if(sb.length() > 0) sb.append(",");
			sb.append("'").append(resultHead.getString("TASKKY")).append("'");
		}
		
		sqlParams.put("TASKKYS", sb.toString());
		sqlParams.setModuleCommand("taskOrder", "MV12_ITEMCONFIRM");
		List<DataMap> resultItemList = commonDao.getList(sqlParams);
		
		for(DataMap resultItemMap : resultItemList) {
			DataMap resultItem = resultItemMap.getMap("map");
			resultItem.put("ROWCK", "V");
		}
		
		//이동확정
		try {
			sqlParams = new DataMap();
			map.clonSessionData(sqlParams);
			sqlParams.setModuleCommand("taskOrder", "MV12_CONFIRMHEADVALIDATE");
			for(DataMap resultHeadMap : resultHeadList) {
				DataMap resultHead = resultHeadMap.getMap("map");
				
				if(resultHead.getString("TASOTY").equals("380")) {
					sqlParams.put("CARDAT", resultHead.getString("DOCDAT"));
					List<DataMap> validateList = commonDao.getList(sqlParams);
					String temp_validate = null;
					
					for(DataMap validateMap : validateList) {
						DataMap validate = validateMap.getMap("map");
						
						if(validate == null) {
							temp_validate = "문서일자를 잘못 입력하였습니다.";
						}
						else if (validate.getString("RESULTMSG").equals("Y")) {
							temp_validate = "해당 문서일자는 회계 마감되었습니다.";
						}
						
						if(!temp_validate.equals("")) {
							map.put("RESULT", "M");
							map.put("M", "OUT_M0161");
							map.put("MK", temp_validate);
							return map;
						}
					}
				} // end if
				
				
				for(DataMap resultItemMap : resultItemList) {
					DataMap resultItem = resultItemMap.getMap("map");
					if(resultHead.getString("TASKKY").equals(resultItem.getString("TASKKY")) && (resultItem.getString("ROWCK").equals("V") || resultItem.getString("ROWCK").equals("1"))) {
						// 0. TASDI에 속한 TASDR 정보 조회
						sqlParams = new DataMap();
						map.clonSessionData(sqlParams);
						sqlParams.setModuleCommand("taskOrder", "MV12_TASDR");
						sqlParams.put("TASKKY", resultItem.getString("TASKKY"));
						sqlParams.put("TASKIT", resultItem.getString("TASKIT"));
						sqlParams.put("TASKIR", "0001");						
						
						DataMap tasdr = commonDao.getMap(sqlParams);
						
						// 1. TASDI 삭제 (TASDI 삭제시 TASDR도 트리거에서 삭제됨.)
						map.clonSessionData(resultItem);
						resultItem.setModuleCommand("taskOrder", "MV12_DELETETASDI");
						commonDao.delete(resultItem);

						// 2. TASDI, TASDR 셋팅
						if(resultItem.getString("QTTAOR").compareTo(resultItem.getString("QTCOMP")) == 0)
							resultItem.put("STATIT", "FPC");
						else if(resultItem.getString("QTTAOR").compareTo(resultItem.getString("QTCOMP")) > 0)
							resultItem.put("STATIT", "PPC");
						
						if(resultHead.getString("TASOTY").equals("331") && resultItem.getString("QTTAOR").compareTo(resultItem.getString("QTCOMP")) < 0) {
							resultItem.put("QTTAOR", resultItem.getString("QTCOMP"));
						}
						
						resultItem.put("WAREKY", head.getString("WAREKY"));
						resultItem.put("ACTCDT", date);
						resultItem.put("ACTCTI", time);
						resultItem.put("LOCAAC", resultItem.getString("LOCATG"));
						resultItem.put("SECTAC", resultItem.getString("SECTTG"));
						resultItem.put("PAIDAC", resultItem.getString("PAIDTG"));
						resultItem.put("TRNUAC", resultItem.getString("TRNUTG"));
						resultItem.put("ATRUTY", resultItem.getString("TTRUTY"));
						resultItem.put("AMEAKY", resultItem.getString("TMEAKY"));
						resultItem.put("AUOMKY", resultItem.getString("TUOMKY"));
						resultItem.put("QTAPUM", resultItem.getString("QTTPUM"));
						resultItem.put("ADUOKY", resultItem.getString("TDUOKY"));
						resultItem.put("QTADUM", resultItem.getString("QTTDUM"));
						
						tasdr.put("QTSTKC", resultItem.getString("QTCOMP"));
						
						taskService.createTasdi(resultItem);
						taskService.createTasdr(tasdr);
					}
				} // end for
				
			} // end for
		} catch(Exception e) {
			map.put("RESULT", "M");
			map.put("M", e.getMessage());
			return map;
		}
		map.put("SAVESECCESSHEAD", resultHeadList);
		map.put("SAVESECCESSITEM", resultItemList);
		return map;
	} // end confirmSaveMV12()
}