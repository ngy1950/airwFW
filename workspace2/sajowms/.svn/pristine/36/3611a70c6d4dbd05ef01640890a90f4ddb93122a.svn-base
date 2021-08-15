package project.wdscm.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;


import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jdk.nashorn.internal.ir.RuntimeNode.Request;
import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;

import java.net.URL;

@Service
public class AdminService extends BaseService {
	
	static final Logger log = LogManager.getLogger(AdminService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(rollbackFor = Exception.class)
	public DataMap createYH01(DataMap map) throws SQLException {
		boolean saveCk = false;
		DataMap rsMap = new DataMap();
		int validCnt;
		
		try {
			map.setModuleCommand("System", "YH01_VALID_POPID");
			validCnt = commonDao.getMap(map).getInt("CNT");
			
			if(validCnt > 0){
				rsMap.put("saveCk", saveCk);
				rsMap.put("COL_VALUE", map.getString("COMMPOPID"));
				rsMap.put("ERROR_MSG", "VALID_duplication");
				return rsMap;
			}else {
				map.clonSessionData(map);
				map.setModuleCommand("System", "YH01HEAD");
				commonDao.insert(map);
			}
			
				
			saveCk = true;
			
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
			// TODO: handle exception
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveYH01(DataMap map) throws SQLException {
		List<DataMap> list = (List<DataMap>) map.getList("list");
		DataMap headMap = map.getMap("headMap");
		DataMap rsMap = new DataMap(), row;
		boolean modFlg = new Boolean(map.getString("modipyflg"));
		boolean saveCk = false;
		
		try {
			if(modFlg == true){
				map.clonSessionData(headMap);
				headMap.setModuleCommand("System", "YH01HEAD");
				commonDao.update(headMap);
				
			}
			
			if(list.size() > 0){
				for (int i = 0; i < list.size(); i++) {
					row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.setModuleCommand("System", "YH01ITEM");
					
					if(row.getString("GRowState").equals("D")){
						commonDao.delete(row);
					}
				}
				
				for (int i = 0; i < list.size(); i++) {
					row = list.get(i).getMap("map");
					map.clonSessionData(row);

					row.setModuleCommand("System", "YH01ITEM");
					
					if(row.getString("GRowState").equals("C")){
						row.put("COMMPOPID", headMap.getString("COMMPOPID"));
						commonDao.insert(row);
						
					}else if(row.getString("GRowState").equals("U")){
						commonDao.update(row);
					}
				}
			}
			saveCk = true;
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
			// TODO: handle exception
		}
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(rollbackFor = Exception.class)
	public DataMap createUR01(DataMap map) throws SQLException {
		boolean saveCk = false;
		DataMap rsMap = new DataMap();
		int menuidCnt, CompidCnt;
		
		
		try {
			map.setModuleCommand("System", "UR01_VALID_POPID");
			menuidCnt = commonDao.getMap(map).getInt("MENUGID_CNT");
			CompidCnt = commonDao.getMap(map).getInt("COMPID_CNT");
			
			if(CompidCnt == 0){
				rsMap.put("saveCk", saveCk);
				rsMap.put("COL_VALUE", map.getString("COMPID"));
				rsMap.put("ERROR_MSG", "VALID_remote");
				return rsMap;
				
			}
			
			if(menuidCnt > 0){
				rsMap.put("saveCk", saveCk);
				rsMap.put("ERROR_MSG", "VALID_duplication");
				return rsMap;
			}
			
			map.clonSessionData(map);
			map.setModuleCommand("System", "UR01HEAD");
			commonDao.insert(map);
			
			saveCk = true;
			
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
			// TODO: handle exception
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01(DataMap map) throws SQLException {
		List<DataMap> list = (List<DataMap>) map.getList("list");
		DataMap headMap = map.getMap("head");
		DataMap rsMap = new DataMap(), row, valiMap;
		boolean saveCk = false;
		int MGCNT = 0;
		 
		try {
			headMap.setModuleCommand("System", "UR01_MENUIDG_VALID");
			MGCNT = commonDao.getMap(headMap).getInt("CNT");
			
			if(MGCNT == 0){
				rsMap.put("saveCk", saveCk);
				rsMap.put("COL_VALUE", headMap.getString("MENUGID"));
				rsMap.put("ERROR_MSG", "VALID_remote");
				return rsMap;
			}

			headMap.setModuleCommand("System", "UR01ITEM");
			commonDao.delete(headMap);
			
			for (int i = 0; i < list.size(); i++) {
				row = list.get(i).getMap("map");
				row.put("COMPID", headMap.getString("COMPID"));
				row.put("MENUGID", headMap.getString("MENUGID"));
				map.clonSessionData(row);

				if(row.getString("GRowState").equals("C")
			    || row.getString("GRowState").equals("U")){
					
					row.setModuleCommand("System", "UR01_MENUID_VALID");
					valiMap = commonDao.getMap(row);

					row.setModuleCommand("System", "UM01");
					if(valiMap.getInt("CNT") == 0){
						commonDao.insert(row);
					}else if(!(valiMap.getString("URI").equals(row.getString("URI")) &&
							   valiMap.getString("MENUNAME").equals(row.getString("MENUNAME")))
					){
						commonDao.update(row);
					}
				}
				
				
				row.setModuleCommand("System", "UR01ITEM");
				commonDao.insert(row);
			}
			saveCk = true;
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
			// TODO: handle exception
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteUR01(DataMap map) throws SQLException {
		DataMap headMap = map.getMap("head");
		DataMap rsMap = new DataMap(), row, valiMap;
		boolean saveCk = false;
		int MGCNT = 0;
		 
		try {
			headMap.setModuleCommand("System", "UR01_MENUIDG_VALID");
			MGCNT = commonDao.getMap(headMap).getInt("CNT");
			
			if(MGCNT == 0){
				rsMap.put("saveCk", saveCk);
				rsMap.put("COL_VALUE", headMap.getString("MENUGID"));
				rsMap.put("ERROR_MSG", "VALID_remote");
				return rsMap;
			}

			headMap.setModuleCommand("System", "UR01ITEM");
			commonDao.delete(headMap);
			
			headMap.setModuleCommand("System", "UR01HEAD");
			commonDao.delete(headMap);
			
			saveCk = true;
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
			// TODO: handle exception
		}
	}
	

	@Transactional
	public int saveNR01(DataMap map) throws SQLException {
		int count = 0;

		DataMap list = map.getMap("list").getMap("map");
		if(map.get("flag").equals("U")){
			list.setModuleCommand("System", "NR01UP");
		}else{
			list.setModuleCommand("System", "NR01I");
		}
		
		count += commonDao.update(list);

		return count;
	}
}