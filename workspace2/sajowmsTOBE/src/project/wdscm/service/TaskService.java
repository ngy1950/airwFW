package project.wdscm.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;

@Service
public class TaskService extends BaseService {
	
	static final Logger log = LogManager.getLogger(TaskService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePT01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.setModuleCommand("Task", "PT01_HEAD");
				DataMap head = commonDao.getMap(map);
				map.clonSessionData(head);
				
				String tasoty = head.getString("TASOTY");
				String taskty = head.getString("TASKTY");
				String taskky = commonDao.getDocNum(tasoty);
				
				head.put("TASKKY", taskky);
				head.setModuleCommand("Task", "TASDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					String locasr = row.getString("LOCASR");
					//float qttaor = Float.parseFloat(row.getString("QTTAOR"));
					//float qtcomp = Float.parseFloat(row.getString("QTCOMP"));
					
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("TASKKY", taskky);
					row.put("TASKIT", inum);
					row.put("TASKTY", taskty);
					row.put("LOCATG", locasr);
					row.put("LOCAAC", locasr);
					
					row.setModuleCommand("Task", "TASDI");
					
					commonDao.insert(row);
				}
				
				//TASK_TO_STK
				DataMap stkMap = new DataMap();
				
				map.clonSessionData(stkMap);
				stkMap.put("TASKKY", taskky);
				stkMap.setModuleCommand("Task", "TASK_TO_STK");
				
				List<DataMap> stkList = commonDao.getList(stkMap);
				
				int stkListSize = stkList.size();
				if(stkListSize > 0){
					for(int i = 0; i < stkListSize; i++){
						DataMap stkRow = stkList.get(i).getMap("map");
						map.clonSessionData(stkRow);
						
						float qttaor = Float.parseFloat(stkRow.getString("QTTAOR")); 
						float qtcomp = Float.parseFloat(stkRow.getString("QTCOMP")); 
						
						stkRow.put("QTSIWH", qtcomp);
						stkRow.put("QTSALO", 0);
						stkRow.put("QTSPMO", 0);
						stkRow.put("QTSPMI", 0);
						stkRow.put("QTSBLK", 0);
							
						stkRow.setModuleCommand("Task", "STKKY");
						commonDao.insert(stkRow);
						
						stkRow.put("QTYDIF", qtcomp);
						stkRow.setModuleCommand("Task", "TASK_TO_RCV");
						
						commonDao.update(stkRow);
					}
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePT02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		String tkflky = map.getString("TKFLKY");
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.setModuleCommand("Task", "PT01_HEAD");
				DataMap head = commonDao.getMap(map);
				map.clonSessionData(head);
				
				head.setModuleCommand("Task", "RECDR_RECRKY");
				
				String recrky = (String) commonDao.getObject(head);
				String wareky = head.getString("WAREKY");
				
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.put("RECRKY", recrky);
					row.put("WAREKY", wareky);
					row.put("QTCOMP", 0);
					row.setModuleCommand("Task", "RECDR");
					
					commonDao.insert(row);
				}
				
				head.put("RECRKY", recrky);
				head.put("DOCTXT", "");
				head.put("TKFLKY", tkflky);
				head.setModuleCommand("Task", "PRCS_GRP_PUTWAY");
				
				DataMap resultMap = commonDao.getMap(head);
				
				String returnTaskky = "";
				if(resultMap != null){
					returnTaskky = resultMap.getString("TASKKY");
				}
				rsMap.put("RESULT", "S");
				rsMap.put("TASKKY", returnTaskky);
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePT02Comp(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				String taskky = "";
				
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.setModuleCommand("Task", "PRCS_IN_STKKY");
					
					DataMap resultData = commonDao.getMap(row);
					taskky = resultData.getString("TASKKY");
				}
				
				rsMap.put("RESULT", "S");
				rsMap.put("TASKKY", taskky);
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap deletePT02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		int count = 0;
		
		try {
			if(listSize > 0){
				String taskky = "";
				
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					taskky = row.getString("TASKKY");
					
					row.setModuleCommand("Task", "PRCS_IN_PUTWAY_CLS");
					
					count += commonDao.getCount(row);
				}
				
				if(count > 0){
					rsMap.put("RESULT", "S");
					rsMap.put("TASKKY", taskky);
				}else{
					rsMap.put("RESULT", "F2");
				}
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	

}