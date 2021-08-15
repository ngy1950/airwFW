package project.wdscm.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun.xml.internal.messaging.saaj.packaging.mime.Header;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;

@Service
public class OutboundService extends BaseService {
	
	static final Logger log = LogManager.getLogger(OutboundService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSO01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		String ishpky = "";
		try {
			List<DataMap> list = map.getList("list");
			
			int listSize = list.size();
			if(listSize > 0){
				map.setModuleCommand("Outbound", "SO01_ISHPKY");
				ishpky = (String) commonDao.getObj(map);
				
				for(int  i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.put("ISHPKY", ishpky);
					
					row.setModuleCommand("Common", "COMMON_SKUMA");
					DataMap skumaMap = commonDao.getMap(row);
					String ownrky = skumaMap.getString("OWNRKY");
					String desc01 = skumaMap.getString("DESC01");
					
					row.put("OWNRKY", ownrky);
					row.put("DESC01", desc01);
					
					row.setModuleCommand("Common", "COMMON_BZPTN");
					DataMap bzptnMap = commonDao.getMap(row);
					String name01 = bzptnMap.getString("NAME01");
					
					row.put("PTNRNM", name01);
					
					String ptrcvr = row.getString("PTRCVR");
					if(!"".equals(ptrcvr.trim())){
						bzptnMap = new DataMap();
						map.clonSessionData(bzptnMap);
						bzptnMap.put("PTNRKY", ptrcvr);
						bzptnMap.setModuleCommand("Common", "COMMON_BZPTN");
						
						bzptnMap = commonDao.getMap(bzptnMap);
						name01 = bzptnMap.getString("NAME01");
						
						row.put("PTRCNM", name01);
					}
					
					row.setModuleCommand("Outbound", "SO01");
					
					commonDao.insert(row);
					
					count++;
				}
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("CNT", count);
		rsMap.put("ISHPKY", ishpky);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSO10(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> head = map.getList("head");
			
			int headSize = head.size();
			if(headSize > 0){
				for(int  i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String shpoky = commonDao.getDocNum(headRow.getString("SHPMTY"));
					
					headRow.put("SHPOKY", shpoky);
					headRow.put("STATDO", "NEW");
					headRow.setModuleCommand("Outbound", "SHPDH");
					
					commonDao.insert(headRow);
					
					int itemCount = 0;
					
					headRow.setModuleCommand("Outbound", "SO10_ITEM");
					List<DataMap> item = commonDao.getList(headRow);
					
					int itemSize = item.size();
					if(itemSize > 0){
						for(int j = 0; j < itemSize; j++){
							itemCount += 10;
							String snum = String.valueOf(itemCount);
							String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
							
							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.put("SHPOKY", shpoky);
							itemRow.put("SHPOIT", inum);
							itemRow.put("STATIT", "NEW");
							itemRow.setModuleCommand("Outbound", "SHPDI");
							
							commonDao.insert(itemRow);
						}
					}
					
					headRow.setModuleCommand("Outbound", "IFSHP_COMPLATE");
					
					commonDao.update(headRow);
					
					count++;
				}	
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> task = new ArrayList<DataMap>();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		int headSize = head.size();
		int itemSize = item.size(); 
		try {
			if(headSize > 0){
				for(int i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String wareky = headRow.getString("WAREKY");
					
					String shpoky = headRow.getString("SHPOKY");
					
					String tasoty = headRow.getString("TASOTY");
					String taskky = commonDao.getDocNum(tasoty);
					String taskty = headRow.getString("TASKTY");
					String locatg = headRow.getString("SYSLOC");
					
					List<DataMap> temp = new ArrayList<DataMap>();
					if(itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))){
						for(int j = 0; j < itemSize; j++){
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int taskItemCount = 0;
					int tempSize = temp.size();
					if(tempSize > 0){
						int itemCount = 0;
						
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.put("WAREKY", wareky);
							row.setModuleCommand("Outbound", "SH01_STOCKYN");
							String isStock = (String) commonDao.getObject(row);
							
							String shpoit = row.getString("SHPOIT");
							float qttaor = Float.parseFloat(row.getString("QTTAOR"));
							
							row.setModuleCommand("Task", "STKKY");
							List<DataMap> stkky = commonDao.getList(row);
							
							int stkkyCount = stkky.size();
							if("Y".equals(isStock) && stkkyCount > 0 && qttaor > 0){
								for(int k = 0; k < stkkyCount; k++){
									if(qttaor <= 0){
										break;
									}
									
									itemCount += 10;
									String snum = String.valueOf(itemCount);
									String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
									
									DataMap stkRow = stkky.get(k).getMap("map");
									map.clonSessionData(stkRow);
									
									String stokky = stkRow.getString("STOKKY");
									String locaky = stkRow.getString("LOCAKY");
									
									String duomky = stkRow.getString("DUOMKY");
									String smeaky = stkRow.getString("MEASKY");
									String suomky = stkRow.getString("UOMKEY");
									float qtpuom = Float.parseFloat(stkRow.getString("QTPUOM"));
									float qtduom = Float.parseFloat(stkRow.getString("QTDUOM"));
									float qtyuom = Float.parseFloat(stkRow.getString("QTYUOM"));
									
									float qtsiwh = Float.parseFloat(stkRow.getString("QTSIWH"));
									float savqty = 0F;
									if(qttaor > qtsiwh){
										savqty = qtsiwh;
										qttaor = qttaor - qtsiwh;
									}else if(qttaor < qtsiwh){
										savqty = qttaor;
										qttaor = 0;
									}else{
										savqty = qttaor;
										qttaor = 0;
									}
									
									stkRow.put("TASKKY", taskky);
									stkRow.put("TASKIT", inum);
									stkRow.put("TASKTY", taskty);
									stkRow.put("STATIT", "NEW");
									stkRow.put("STKNUM", stokky);
									stkRow.put("QTTAOR", savqty);
									stkRow.put("QTCOMP", 0);
									stkRow.put("LOCASR", locaky);
									stkRow.put("LOCATG", locatg);
									stkRow.put("SHPOKY", shpoky);
									stkRow.put("SHPOIT", shpoit);
									 
									
									stkRow.put("SMEAKY", smeaky);
									stkRow.put("SUOMKY", suomky);
									stkRow.put("QTYUOM", qtyuom);
									stkRow.put("QTSPUM", qtpuom);
									stkRow.put("SDUOKY", duomky);
									stkRow.put("QTSDUM", qtduom);
									
									stkRow.setModuleCommand("Task", "TASDI");
									
									commonDao.insert(stkRow);
								}
								
								taskItemCount++;
							}
						}
						
						if(taskItemCount > 0){
							headRow.put("TASKKY", taskky);
							headRow.setModuleCommand("Task", "TASDH");
							
							commonDao.insert(headRow);
							
							task.add(headRow);
						}
					}
				}
				
				int taskSize = task.size();
				if(taskSize > 0){
					for(int i = 0; i < taskSize; i++){
						DataMap headRow = task.get(i).getMap("map");
						map.clonSessionData(headRow);
						
						headRow.setModuleCommand("Task", "TASK_TO_STK");
						List<DataMap> taskItem = commonDao.getList(headRow);
						
						int taskItemSize = taskItem.size();
						if(taskItemSize > 0){
							for(int j = 0; j < taskItemSize; j++){
								DataMap itemRow = taskItem.get(j).getMap("map");
								map.clonSessionData(itemRow);
								
								float qttaor = Float.parseFloat(itemRow.getString("QTTAOR"));
								
								itemRow.put("QTSIWH", 0);
								itemRow.put("QTSALO", qttaor);
								itemRow.put("QTJCMP", 0);
								itemRow.put("QTSPMO", 0);
								itemRow.put("QTSPMI", 0);
								itemRow.put("QTSBLK", 0);
								itemRow.put("QTSHPD", 0);
								itemRow.setModuleCommand("Task", "STKKY");
								
								commonDao.insert(itemRow);
								
								itemRow.setModuleCommand("Task", "STKKY_QTY");
								commonDao.update(itemRow);
								
								itemRow.setModuleCommand("Outbound", "SH01_QTY");
								commonDao.update(itemRow);
								
								itemRow.setModuleCommand("Outbound", "SH01_STATIT");
								String statit = (String) commonDao.getObject(itemRow);
								itemRow.put("STATIT", statit);
								commonDao.update(itemRow);
							}
							
							headRow.setModuleCommand("Outbound", "SH01_STATDO");
							String statdo = (String) commonDao.getObject(headRow);
							headRow.put("STATDO", statdo);
							
							commonDao.update(headRow);
						}
					}
				}
			}else{
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		int resultCount = 0;
		
		String alstky = map.getString("ALSTKY");
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		int headSize = head.size();
		int itemSize = item.size();
		try {
			if(headSize > 0){
				map.setModuleCommand("Outbound", "SHPDR_GRPKEY");
				
				String grpkey = (String) commonDao.getObject(map);
				
				for(int i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String wareky = headRow.getString("WAREKY");
					String shpoky = headRow.getString("SHPOKY");
					String shpmty = headRow.getString("SHPMTY");
					String rqshpd = headRow.getString("RQSHPD");
					String docdat = headRow.getString("DOCCAT");
					String dptnky = headRow.getString("DPTNKY");
					String ptnrnm = headRow.getString("DPTNNM");
					String ptrcvr = headRow.getString("PTRCVR");
					String ptrcnm = headRow.getString("PTRCNM");
					String doccat = headRow.getString("DOCCAT");
					String tasoty = headRow.getString("TASOTY");
					String locaky = headRow.getString("SYSLOC");
					
					List<DataMap> temp = new ArrayList<DataMap>();
					if(itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))){
						for(int j = 0; j < itemSize; j++){
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int tempSize = temp.size();
					if(tempSize > 0){
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.put("GRPKEY", grpkey);
							row.put("WAREKY", wareky);
							row.put("SHPMTY", shpmty);
							row.put("RQSHPD", rqshpd);
							row.put("DOCCAT", docdat);
							row.put("DPTNKY", dptnky);
							row.put("DNAME1", ptnrnm);
							row.put("PTRCVR", ptrcvr);
							row.put("DNAME2", ptrcnm);
							row.put("DOCCAT", doccat);
							row.put("TASOTY", tasoty);
							row.put("LOCAKY", locaky);
							row.setModuleCommand("Outbound", "SHPDR");
							
							commonDao.insert(row);
						}
					}
				}
				
				map.put("ALSTKY", alstky);
				map.put("GRPKEY", grpkey);
				map.setModuleCommand("Outbound", "PRCS_GRP_ALLOCATION");
				
				resultCount = commonDao.getCount(map);
				if(resultCount > 0){
					rsMap.put("RESULT", "S");
				}else{
					rsMap.put("RESULT", "F1");
				}
			}else{
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH01Cancel(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			
			int headSize = head.size();
			int itemSize = item.size();
			if(headSize > 0){
				for(int  i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY"); 
					String taskty = headRow.getString("TASKTY"); 
					
					List<DataMap> temp = new ArrayList<DataMap>();
					
					if(itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))){
						for(int j = 0; j < itemSize; j ++){
							DataMap itemRow = item.get(j).getMap("map"); 
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int tempSize = temp.size();
					if(tempSize > 0){
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.put("WAREKY", wareky);
							row.put("TASKTY", taskty);
							row.setModuleCommand("Outbound", "SH01_TASK");
							
							List<DataMap> tskList = commonDao.getList(row);
							
							int tskSize = tskList.size();
							if(tskSize > 0){
								for(int k = 0; k < tskSize; k++){
									DataMap tskRow = tskList.get(k).getMap("map");
									map.clonSessionData(tskRow);
									
									float qttaor = Float.parseFloat(tskRow.getString("QTTAOR"));
									
									tskRow.put("STATIT", "CLS");
									tskRow.setModuleCommand("Outbound", "SH01_TASDI_STATUS");
									
									commonDao.update(tskRow);

									tskRow.setModuleCommand("Outbound", "SH01_STKKY_QTSIWH");
									
									commonDao.update(tskRow);
									
									tskRow.setModuleCommand("Outbound", "SH01_STKKY_ALOC");
									
									commonDao.delete(tskRow);
									
									tskRow.put("QTTAOR", (qttaor*-1));
									tskRow.setModuleCommand("Outbound", "SH01_QTY");
									
									commonDao.update(tskRow);
									
									tskRow.setModuleCommand("Outbound", "SH01_STATIT");
									String statit = (String) commonDao.getObject(tskRow);
									
									tskRow.put("STATIT", statit);
									
									tskRow.setModuleCommand("Outbound", "SH01_STATIT");
									
									commonDao.update(tskRow);
								}
							}
						}
					}
					
					headRow.setModuleCommand("Outbound", "SH01_TASK_CLS");
					String isCls = (String) commonDao.getObject(headRow);
					if("Y".equals(isCls)){
						headRow.put("STATDO", "CLS");
						headRow.setModuleCommand("Outbound", "SH01_TASDH_STATUS");
						
						commonDao.update(headRow);
					}
					
					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					
					headRow.put("STATDO", statdo);
					
					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					
					commonDao.update(headRow);
				}	
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePK01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			
			int headSize = head.size();
			int itemSize = item.size();
			if(headSize > 0){
				for(int  i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY"); 
					String taskty = headRow.getString("TASKTY");
					
					List<DataMap> temp = new ArrayList<DataMap>();
					if(itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))){
						for(int j = 0; j < itemSize; j ++){
							DataMap itemRow = item.get(j).getMap("map"); 
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Outbound", "PK01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int tempSize = temp.size();
					if(tempSize > 0){
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.put("WAREKY", wareky);
							
							float qttaor = Float.parseFloat(row.getString("QTTAOR"));
							float qtcomp = Float.parseFloat(row.getString("QTCOMP"));
							float qtydif = Float.parseFloat(row.getString("QTYDIF"));
							String locaky = row.getString("LOCAKY");
							String locasr = row.getString("LOCASR");
							String taskky = row.getString("TASKKY");
							String taskit = row.getString("TASKIT");
							String shpoit = row.getString("SHPOIT");
							String locatg = row.getString("LOCATG");
							
							if((qttaor - qtcomp) >= qtydif){
								if(!locaky.equals(locasr)){
									//로케이션 변경
									row.setModuleCommand("Outbound", "PK01_STK_CHECK");
									List<DataMap> locSkuChkList = commonDao.getList(row);
									if(locSkuChkList.size() > 0){
										float qtsiwh = Float.parseFloat(locSkuChkList.get(0).getMap("map").getString("QTSIWH"));
										if(qtsiwh > 0){
											row.setModuleCommand("Outbound", "PK01_TASK_TO_STK");
											List<DataMap> stkky = commonDao.getList(row);
											
											int stkkyCount = stkky.size();
											if(stkkyCount > 0 && qtydif > 0){
												row.setModuleCommand("Outbound", "TASDI_MAXRIT");
												
												int itemCount = commonDao.getCount(row);
												
												for(int k = 0; k < stkkyCount; k++){
													if(qttaor <= 0){
														break;
													}
													
													itemCount += 10;
													String snum = String.valueOf(itemCount);
													String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
													
													DataMap stkRow = stkky.get(k).getMap("map");
													map.clonSessionData(stkRow);
													
													String stokky = stkRow.getString("STOKKY");
													
													String duomky = stkRow.getString("DUOMKY");
													String smeaky = stkRow.getString("MEASKY");
													String suomky = stkRow.getString("UOMKEY");
													float qtpuom = Float.parseFloat(stkRow.getString("QTPUOM"));
													float qtduom = Float.parseFloat(stkRow.getString("QTDUOM"));
													float qtyuom = Float.parseFloat(stkRow.getString("QTYUOM"));
													
													float aqtsiwh = Float.parseFloat(stkRow.getString("QTSIWH"));
													float savqty = 0F;
													if(qtydif > aqtsiwh){
														savqty = aqtsiwh;
														qtydif = qttaor - aqtsiwh;
													}else if(qtydif < aqtsiwh){
														savqty = qtydif;
														qtydif = 0;
													}else{
														savqty = qttaor;
														qtydif = 0;
													}
													
													stkRow.put("TASKKY", taskky);
													stkRow.put("TASKIT", inum);
													stkRow.put("TASKTY", taskty);
													stkRow.put("STATIT", "FPC");
													stkRow.put("STKNUM", stokky);
													stkRow.put("QTTAOR", savqty);
													stkRow.put("QTCOMP", savqty);
													stkRow.put("LOCASR", locaky);
													stkRow.put("LOCATG", locatg);
													stkRow.put("SHPOKY", shpoky);
													stkRow.put("SHPOIT", shpoit);
													 
													
													stkRow.put("SMEAKY", smeaky);
													stkRow.put("SUOMKY", suomky);
													stkRow.put("QTYUOM", qtyuom);
													stkRow.put("QTSPUM", qtpuom);
													stkRow.put("SDUOKY", duomky);
													stkRow.put("QTSDUM", qtduom);
													
													stkRow.setModuleCommand("Task", "TASDI");
													
													commonDao.insert(stkRow);
													
													stkRow.put("QTSIWH", 0);
													stkRow.put("QTSALO", savqty);
													stkRow.put("QTJCMP", 0);
													stkRow.put("QTSPMO", 0);
													stkRow.put("QTSPMI", 0);
													stkRow.put("QTSBLK", 0);
													stkRow.put("QTSHPD", 0);
													stkRow.setModuleCommand("Task", "STKKY");
													
													commonDao.insert(stkRow);
													
													stkRow.setModuleCommand("Task", "STKKY_QTY");
													commonDao.update(stkRow);
													
													stkRow.put("QTYDIF", savqty);
													stkRow.setModuleCommand("Outbound", "PK01_SHPDI");
													commonDao.update(stkRow);
													
													stkRow.put("TASKIT", taskit);
													stkRow.setModuleCommand("Outbound", "PK01_TASK_QTTAOR");
													commonDao.update(stkRow);
												}
											}
										}
									}
								}else{
									String statit = "FPC";
									if((qttaor - qtcomp) - qtydif > 0){
										statit = "PPC";
									}
									
									row.put("STATIT", statit);
									row.setModuleCommand("Outbound", "PK01_TASK");
									
									commonDao.update(row);
									
									row.setModuleCommand("Outbound", "PK01_SHPDI");
									
									commonDao.update(row);
								}
							}
							
							row.setModuleCommand("Outbound", "PK01_SHPDI_STATUS");
							commonDao.update(row);
						}
						
						headRow.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
						List<DataMap> tskList = commonDao.getList(headRow);
						if(tskList.size() > 0){
							for(int j = 0; j < tskList.size(); j++){
								DataMap row = tskList.get(j).getMap("map");
								map.clonSessionData(row);
								
								row.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
								String statdo = (String) commonDao.getObject(row);
								row.put("STATDO", statdo);
								
								commonDao.update(row);
							}
						}
					}
					
					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					
					headRow.put("STATDO", statdo);
					
					commonDao.update(headRow);
				}	
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePK01Cancel(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			
			int headSize = head.size();
			int itemSize = item.size();
			if(headSize > 0){
				for(int  i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY"); 
					
					List<DataMap> temp = new ArrayList<DataMap>();
					if(itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))){
						for(int j = 0; j < itemSize; j ++){
							DataMap itemRow = item.get(j).getMap("map"); 
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Outbound", "PK01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int tempSize = temp.size();
					if(tempSize > 0){
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.put("WAREKY", wareky);
							
							float qttaor = Float.parseFloat(row.getString("QTTAOR"));
							float qtcomp = Float.parseFloat(row.getString("QTCOMP"));
							
							if(qtcomp > 0){
								row.put("QTYDIF",(qtcomp*-1));
								row.put("STATIT", "NEW");
								row.setModuleCommand("Outbound", "PK01_TASK");
								
								commonDao.update(row);
								
								row.setModuleCommand("Outbound", "PK01_SHPDI");
								
								commonDao.update(row);
							}
							
							row.setModuleCommand("Outbound", "PK01_SHPDI_STATUS");
							commonDao.update(row);
						}
						
						headRow.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
						List<DataMap> tskList = commonDao.getList(headRow);
						if(tskList.size() > 0){
							for(int j = 0; j < tskList.size(); j++){
								DataMap row = tskList.get(j).getMap("map");
								map.clonSessionData(row);
								
								row.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
								String statdo = (String) commonDao.getObject(row);
								row.put("STATDO", statdo);
								
								commonDao.update(row);
							}
						}
					}
					
					headRow.setModuleCommand("Outbound", "PK01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					
					headRow.put("STATDO", statdo);
					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					
					commonDao.update(headRow);
				}	
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH30(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			
			int headSize = head.size();
			if(headSize > 0){
				for(int  i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					headRow.setModuleCommand("Outbound", "SH30_TASK");
					List<DataMap> item = commonDao.getList(headRow);
					
					int itemSize = item.size();
					if(itemSize > 0){
						for(int j = 0; j < itemSize; j++){
							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.setModuleCommand("Outbound", "SH30_STKKY");
							commonDao.update(itemRow);
							
							itemRow.setModuleCommand("Outbound", "SH30_SHPDI");
							commonDao.update(itemRow);
						}
					}
					
					headRow.setModuleCommand("Outbound", "SH30_SHPDH_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					headRow.put("STATDO", statdo);
					
					headRow.setModuleCommand("Outbound", "SH30_SHPDH");
					commonDao.update(headRow);
				}	
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
}