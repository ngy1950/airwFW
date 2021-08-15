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
public class InventoryService extends BaseService {
	
	static final Logger log = LogManager.getLogger(InventoryService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String tasoty = head.getString("TASOTY");
				String taskky = commonDao.getDocNum(tasoty);
				
				head.put("TASKKY", taskky);
				head.setModuleCommand("Task", "TASDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					String taskty = row.getString("TASKTY");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTTAOR")); // 작업수량
					map.clonSessionData(row);
					
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("TASKKY", taskky);
					row.put("TASKIT", inum);
					row.put("TASKTY", taskty);
					row.put("LOCAAC", row.getString("LOCATG"));
					row.put("QTCOMP", qty);
					
					row.setModuleCommand("Task", "TASDI");
					commonDao.insert(row);
					
					//재고조정
					row.setModuleCommand("Inventory", "STKKY_LOT_CHK");
					DataMap lotChk = commonDao.getMap(row);
					String stknum = "";
					Integer plsqty = 0;
					if(lotChk != null){
						stknum = lotChk.getString("STOKKY");
						plsqty = lotChk.getInt("QTSIWH");
					}

					// 재고 -
					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);

					// 재고 + 
					if(stknum.equals("")){
						row.put("QTSIWH", qty);
						row.put("QTSALO", 0);
						row.put("LOCAKY", row.getString("LOCATG"));
						row.setModuleCommand("Task", "STKKY");
						commonDao.insert(row);
					}else{
						row.put("STKNUM", stknum);
						row.put("QTSALO", -qty);
						row.setModuleCommand("Task", "STKKY_QTY");
						commonDao.update(row);
						
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
	public DataMap saveSJ04(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String adjuky = head.getString("ADJUTY");
				String sadjky = commonDao.getDocNum(adjuky);
				
				head.put("SADJKY", sadjky);
				head.setModuleCommand("Inventory", "ADJDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTADJU")); // 작업수량
					map.clonSessionData(row);
					
					// 기존재고 - //
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("QTADJU", -qty);
					
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);
					// 기존재고 - //
					
					// 재고조정 //
					itemCount += 10;
					snum = String.valueOf(itemCount);
					inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("LOTA01", row.getString("ALOTA01"));
					row.put("LOTA02", row.getString("ALOTA02"));
					row.put("LOTA03", row.getString("ALOTA03"));
					row.put("LOTA04", row.getString("ALOTA04"));
					row.put("LOTA05", row.getString("ALOTA05"));
					row.put("QTADJU", qty);

					// new lot
					String lotnum = row.getString("LOTNUM");
					row.setModuleCommand("Inventory", "LOTNUM_SET");
					String alotnum = (String) commonDao.getObject(row);
					
					row.put("LOCATG", row.getString("LOCAKY"));
					row.put("LOTNUM", alotnum);
					row.setModuleCommand("Inventory", "STKKY_LOT_CHK");
					DataMap lotChk = commonDao.getMap(row);
					String stknum = "";
					Integer plsqty = 0;
					String stokky = row.getString("STOKKY");
					if(lotChk != null){
						stknum = lotChk.getString("STOKKY");
						plsqty = lotChk.getInt("QTSIWH");
					}else{
						//새 재고키
						stokky = commonDao.getDocNum("999");
					}

					row.put("STOKKY", stokky);
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					// 재고 + 
					if(stknum.equals("")){
						row.put("QTSIWH", qty);
						row.put("QTSALO", 0);
						row.setModuleCommand("Inventory", "STKKY_AJ");
						commonDao.insert(row);
					}else{
						row.put("STKNUM", stknum);
						row.put("QTSALO", -qty);
						row.setModuleCommand("Task", "STKKY_QTY");
						commonDao.update(row);
					}
					// 재고조정 //
					
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
	public DataMap saveSJ05(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String adjuky = head.getString("ADJUTY");
				String sadjky = commonDao.getDocNum(adjuky);
				
				head.put("SADJKY", sadjky);
				head.setModuleCommand("Inventory", "ADJDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTADJU")); // 작업수량
					map.clonSessionData(row);
					
					// 재고조정 //
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("QTADJU", qty);
					
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", -qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);
					// 기존재고 - //
					
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
}