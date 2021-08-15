package project.wdscm.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.util.ComU;
import project.common.util.FileUtil;

@Service
public class SystemService extends BaseService {
	
	static final Logger log = LogManager.getLogger(SystemService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveTF01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					String gRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					String tkflky = gRowState.equals("C")?(String) commonDao.getObj("TF01_TKFLKY", row):row.getString("TKFLKY");  
					
					row.setModuleCommand("System", "TAFLH");
					
					switch (gRowState) {
					case "C":
						row.put("TKFLKY", tkflky);
						
						commonDao.insert(row);
						break;
					case "U":
						commonDao.update(row);
						break;
					case "D":
						commonDao.delete(row);
						break;
					default:
						break;
					}
					
					for(int j = 0; j < 4; j++){
						String stepno = "0" + String.valueOf(j+1);
						String taskty = row.getString("STEP" + stepno);
						
						row.put("STEPNO", stepno);
						row.put("TASKTY", taskty);
						row.setModuleCommand("System", "TAFLI");
						
						switch (gRowState) {
						case "C":
							commonDao.insert(row);
							break;
						case "U":
							commonDao.update(row);
							break;
						case "D":
							commonDao.delete(row);
							break;
						default:
							break;
						}
					}
				}
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveAL01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					String gRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					String alstky = gRowState.equals("C")?(String) commonDao.getObj("AL01_ALSTKY", row):row.getString("ALSTKY");
					
					switch (gRowState) {
					case "C":
						row.put("STEPNO", "001");
						row.put("ALSTKY", alstky);
						
						row.setModuleCommand("System", "ALSTH");
						commonDao.insert(row);
						
						row.setModuleCommand("System", "ALSTI");
						commonDao.insert(row);
						break;
					case "U":
						row.setModuleCommand("System", "ALSTH");
						commonDao.update(row);
						
						row.setModuleCommand("System", "ALSTI");
						commonDao.update(row);
						break;
					case "D":
						row.setModuleCommand("System", "ALSTH");
						commonDao.delete(row);
						
						row.setModuleCommand("System", "ALSTI");
						commonDao.delete(row);
						break;
					default:
						break;
					}
					
					rsMap.put("RESULT", "S");
				}
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSK01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					String gRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					row.put("MEASKY",row.getString("SKUKEY"));
					
					switch (gRowState) {
					case "C":
						
						row.setModuleCommand("System", "SKUMA_VALI");
						DataMap tempMap = commonDao.getMap(row);
						if(tempMap.getInt("CNT") > 0){
							rsMap.put("RESULT", "ES");
							rsMap.put("SKUKEY", row.getString("SKUKEY"));
							return rsMap;
						}
						
						row.setModuleCommand("System", "SKUMA");
						commonDao.insert(row);
						row.setModuleCommand("System", "SKUWC");
						commonDao.insert(row);
						row.setModuleCommand("System", "MEASH");
						commonDao.insert(row);
						row.put("UOMKEY",row.getString("DUOMKY"));
						row.put("ITEMNO","10");
						row.put("QTPUOM",1);
						row.put("INDDFU","V");
						row.setModuleCommand("System", "MEASI");
						commonDao.insert(row);
						break;
					case "U":
						row.setModuleCommand("System", "SKUMA");
						commonDao.update(row);
						row.setModuleCommand("System", "SKUWC");
						commonDao.update(row);
						break;
					default:
						break;
					}
					
					
					rsMap.put("RESULT", "S");
				}
			}else{
				rsMap.put("RESULT", "F");
			}
			
			
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveAC01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.setModuleCommand("System", "MSTAP");
					
					String gRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					switch (gRowState) {
					case "C":
						String aplcod = UUID.randomUUID().toString();
						row.put("APLCOD", aplcod);
						
						commonDao.insert(row);
						break;
					case "D":
						commonDao.delete(row);
						break;
					default:
						break;
					}
					
					rsMap.put("RESULT", "S");
				}
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap authMemberShip(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		String aplcod = map.getString("APLCOD");
		
		try {
			if(!"".equals(aplcod)){
				DataMap data = new DataMap();
				data.put("APLCOD", aplcod);
				data.setModuleCommand("System", "AC01");
				
				data = commonDao.getMap(data);
				
				if(data != null){
					String compyn = data.getString("COMPYN");
					if("Y".equals(compyn)){
						rsMap.put("RESULT", "C");
					}else{
						DataMap check = new DataMap();
						check.put("APLCOD", aplcod);
						check.setModuleCommand("System", "AC01_APLCOD");
						
						int checkCount = commonDao.getCount(check);
						if(checkCount > 0){
							rsMap.put("CONDAT", "Y");
						}else{
							rsMap.put("CONDAT", "N");
						}
						rsMap.put("RESULT", "S");
						rsMap.put("DATA", data);
						
						HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
						HttpSession session = request.getSession();
						session.setAttribute(CommonConfig.MEMBERSHIP_APPLY_CODE, aplcod);
					}
				}
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteAllMemberShip(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		String aplcod = map.getString("APLCOD");
		
		try {
			if(!"".equals(aplcod)){
				DataMap data = new DataMap();
				data.put("APLCOD", aplcod);
				data.setModuleCommand("System", "AC01_COMPKY");
				
				data = commonDao.getMap(data);
				String compky = data.getString("COMPID");
				
				if(!"".equals(compky)){
					data.put("COMPID", compky);
					data.put("TYPE", "ALL");
					data.setModuleCommand("System", "MEMBERSHIP_INIT");
					
					commonDao.getMap(data);
					
					rsMap.put("RESULT", "S");
				}
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDefaultInfo(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			if(map != null){
				map.setModuleCommand("System", "MEMBERSHIP_DEDAULT");
				commonDao.insert(map);
				
				String compky = map.getString("COMPKY");
				String wareky = map.getString("COMPKY");
				String ownrky = map.getString("COMPKY");
				String name01 = map.getString("COMPNM");
				String llogwh = map.getString("COMPKY");
				String name02 = map.getString("MNGRNM");
				String teln01 = map.getString("TELNUM");
				String userid = map.getString("USERID");
				String passwd = map.getString("PASSWD");
				
				DataMap data = new DataMap();
				data.put("COMPKY", compky);
				data.put("WAREKY", wareky);
				data.put("NAME01", name01);
				data.put("NAME02", name02);
				data.put("TELN01", teln01);
				data.put("USERID", userid);
				data.put("PASSWD", passwd);
				data.put(CommonConfig.SES_USER_COMPANY_KEY, compky);
				data.put(CommonConfig.SES_USER_ID_KEY, userid);
				data.setModuleCommand("System", "SYSTEM_WAHMA");
				
				//1.창고 저장
				commonDao.insert(data);
				
				//2.User 저장
				data.put("LLOGWH", llogwh);
				data.setModuleCommand("System", "SYSTEM_USRMA");
				commonDao.insert(data);
				
				//3.OWNER 저장
				data.put("OWNRKY", ownrky);
				data.setModuleCommand("System", "SYSTEM_OWNER");
				commonDao.insert(data);
				
				//4.OWNWC 저장
				data.setModuleCommand("System", "SYSTEM_OWNWC");
				commonDao.insert(data);
				
				//5.AREMA 저장
				data.setModuleCommand("System", "SYSTEM_AREMA");
				commonDao.insert(data);
				
				//6.ZONMA 저장
				data.setModuleCommand("System", "SYSTEM_ZONMA");
				commonDao.insert(data);
				
				//7.LOCMA 저장
				data.setModuleCommand("System", "SYSTEM_LOCMA");
				commonDao.insert(data);
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDefaultInfoPrcs(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			if(map != null){
				map.setModuleCommand("System", "MEMBERSHIP_PRCS_GRP_SAVE_DEFAULT");
				commonDao.getMap(map);
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> selectOptionSetData(DataMap map) throws SQLException {
		map.setModuleCommand("System", "MEMBERSHIP_OPTION_SET_HEAD");
		List<DataMap> head = commonDao.getList(map);
		if(head.size() > 0){
			for(int i = 0; i < head.size(); i++){
				DataMap headRow = head.get(i).getMap("map");
				
				headRow.setModuleCommand("System", "MEMBERSHIP_OPTION_SET_ITEM");
				List<DataMap> item = commonDao.getList(headRow);
				if(item.size() > 0){
					headRow.put("item", item);
				}
			}
		}
			
		return head;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOptionSetData(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			if(map != null){
				String tkflky = "";
				String alstky = "";
				String compky = map.getString("COMPKY");
				String userid = map.getString("USERID");
				
				DataMap initMap = new DataMap();
				initMap.put("COMPID", compky);
				initMap.put("TYPE", "OPTION");
				initMap.setModuleCommand("System", "MEMBERSHIP_INIT");
				
				commonDao.getMap(initMap);
				
				DataMap defaultData = new DataMap();
				defaultData.put("COMPKY", compky);
				defaultData.put("MENUGID", "ADMIN");
				defaultData.setModuleCommand("System", "SYSTEM_MENU");
				
				commonDao.insert(defaultData);
				
				defaultData.put("MENUGID", "USER");
				commonDao.insert(defaultData);
				
				DataMap data =  map.getMap("data");
				Iterator it = data.keySet().iterator();
				while(it.hasNext()){
					String key = (String) it.next();
					String value = data.getString(key);
					
					if(!"".equals(value.trim())){
						if(value.indexOf(",") > -1){
							String[] arr = value.split(",");
							for(int i = 0; i < arr.length; i++){
								String[] str = arr[i].split("_");
								String opgkey = str[0];
								String optkey = str[1];
								
								DataMap param = new DataMap();
								param.put("OPGKEY",opgkey);
								param.put("OPTKEY",optkey);
								param.setModuleCommand("System", "MEMBERSHIP_OPTION_MENU");
								
								List<DataMap> list = commonDao.getList(param);
								if(list.size() > 0){
									for(int j = 0; j < list.size(); j++){
										DataMap row = list.get(j).getMap("map");
										
										row.put("COMPKY", compky);
										row.put("USREID", userid);
										
										String menuid = row.getString("MENUID");
										String mnusrt = row.getString("MNUSRT");
										String pmnuid = row.getString("PMNUID");
										String docuty = row.getString("DOCUTY");
										String docgrp = row.getString("DOCGRP");
										
										if(!"".equals(docuty.trim())){
											row.setModuleCommand("System", "MEMBERSHIP_OPTION_DOCRL");
											commonDao.insert(row);
										}
										
										if("PT".equals(docgrp) && !"".equals(docuty.trim())){
											row.setModuleCommand("System", "MEMBERSHIP_OPTION_TKFLKY");
											tkflky = (String) commonDao.getObject(row);
										}
										
										if("AL".equals(docgrp) && !"".equals(docuty.trim())){
											row.setModuleCommand("System", "MEMBERSHIP_OPTION_ALSTKY");
											alstky = (String) commonDao.getObject(row);
										}
										
										DataMap menu = new DataMap();
										menu.put("COMPID", compky);
										menu.put("MENUGID", "ADMIN");
										menu.put("MENUID", menuid);
										menu.put("SORTORDER", mnusrt);
										menu.put("PMENUID", pmnuid);
										menu.setModuleCommand("System", "SYSTEM_USER_MENU");
										
										commonDao.insert(menu);
										
										menu.put("MENUGID", "USER");
										
										commonDao.insert(menu);
									}
								}
							}
						}else{
							String[] str = value.split("_");
							String opgkey = str[0];
							String optkey = str[1];
							
							DataMap param = new DataMap();
							param.put("OPGKEY",opgkey);
							param.put("OPTKEY",optkey);
							param.setModuleCommand("System", "MEMBERSHIP_OPTION_MENU");
							
							List<DataMap> list = commonDao.getList(param);
							if(list.size() > 0){
								for(int i = 0; i < list.size(); i++){
									DataMap row = list.get(i).getMap("map");
									
									row.put("COMPKY", compky);
									row.put("USREID", userid);
									
									String menuid = row.getString("MENUID");
									String mnusrt = row.getString("MNUSRT");
									String pmnuid = row.getString("PMNUID");
									String docuty = row.getString("DOCUTY");
									String docgrp = row.getString("DOCGRP");
									
									if(!"".equals(docuty.trim())){
										row.setModuleCommand("System", "MEMBERSHIP_OPTION_DOCRL");
										commonDao.insert(row);
									}
									
									if("PT".equals(docgrp) && !"".equals(docuty.trim())){
										row.setModuleCommand("System", "MEMBERSHIP_OPTION_TKFLKY");
										tkflky = (String) commonDao.getObject(row);
									}
									
									if("AL".equals(docgrp) && !"".equals(docuty.trim())){
										row.setModuleCommand("System", "MEMBERSHIP_OPTION_ALSTKY");
										alstky = (String) commonDao.getObject(row);
									}
									
									DataMap menu = new DataMap();
									menu.put("COMPID", compky);
									menu.put("MENUGID", "ADMIN");
									menu.put("MENUID", menuid);
									menu.put("SORTORDER", mnusrt);
									menu.put("PMENUID", pmnuid);
									menu.setModuleCommand("System", "SYSTEM_USER_MENU");
									
									commonDao.insert(menu);
									
									menu.put("MENUGID", "USER");
									
									commonDao.insert(menu);
								}
							}
						}
					}
				}
				
				DataMap comp = new DataMap();
				comp.put("COMPKY", compky);
				comp.put("TKFLKY", tkflky);
				comp.put("ALSTKY", alstky);
				comp.setModuleCommand("System", "MEMBERSHIP_MSTCOMP_TK");
				
				commonDao.update(comp);
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOptionSetDatapPrsc(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			if(map != null){
				String compky = map.getString("COMPKY");
				String userid = map.getString("USERID");
				
				List<String> list = new ArrayList<String>();
				DataMap data =  map.getMap("data");
				Iterator it = data.keySet().iterator();
				while(it.hasNext()){
					String key = (String) it.next();
					String value = data.getString(key);
					list.add(value);
				}
				
				String sb = ""; 
				if(list.size() > 0){
					sb = String.join(",", list);
					
					DataMap param = new DataMap();
					param.put("COMPKY", compky);
					param.put("USERID", userid);
					param.put("KEYPRM", sb);
					param.setModuleCommand("System", "MEMBERSHIP_PRCS_GRP_SAVE_OPTION");
					
					commonDao.getMap(param);
					
					rsMap.put("RESULT", "S");
				}else{
					rsMap.put("RESULT", "F");
				}
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> selectPriceData(DataMap map) throws SQLException {
		map.setModuleCommand("System", "MEMBERSHIP_PRICE");
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePriceData(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			if(map != null){
				map.setModuleCommand("System", "MEMBERSHIP_PRICE");
				commonDao.update(map);
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap selectResultData(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("System", "MEMBERSHIP_RESULT01");
		DataMap result1 = commonDao.getMap(map);
		
		map.setModuleCommand("System", "MEMBERSHIP_RESULT02");
		DataMap result2 = commonDao.getMap(map);
		
		map.setModuleCommand("System", "MEMBERSHIP_RESULT03");
		List<DataMap> result3 = commonDao.getList(map);
		
		map.setModuleCommand("System", "MEMBERSHIP_RESULT04");
		DataMap result4 = commonDao.getMap(map);
		
		rsMap.put("R01", result1);
		rsMap.put("R02", result2);
		rsMap.put("R03", result3);
		rsMap.put("R04", result4);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveResultData(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			if(map != null){
				map.setModuleCommand("System", "MEMBERSHIP_REUSLT");
				commonDao.update(map);
				
				HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
				
				String aplcod = "";
				if(request.getSession().getAttribute(CommonConfig.MEMBERSHIP_APPLY_CODE) != null){
					aplcod = request.getSession().getAttribute(CommonConfig.MEMBERSHIP_APPLY_CODE).toString();
				}
				
				map.put("APLCOD", aplcod);
				map.setModuleCommand("System", "MSTAP_REUSLT");
				commonDao.update(map);
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> selectIconList(DataMap map) throws Exception {
		String iconFoderPath = "common/theme/webdek/images/menuIcon";
		
		List<DataMap> result = new ArrayList<DataMap>();
		try {
			String path = this.getClass().getClassLoader().getResource("/").getPath();
			path = path.substring(0, path.indexOf("WEB-INF"));
			
			FileUtil fileUtil = new FileUtil();
			String[] fileList = fileUtil.getFileList(path + iconFoderPath);
			if(fileList.length > 0){
				for(int i = 0; i < fileList.length; i++){
					String file = fileList[i];
					if(file.indexOf(".") > -1){
						String fileName = file.substring(0,file.lastIndexOf("."));
						String ext = file.substring(file.lastIndexOf(".") + 1).toLowerCase();
						if("png".equals(ext) || "jpg".equals(ext) || "jpeg".equals(ext)){
							DataMap row = new DataMap();
							row.put("NAME", fileName);
							row.put("EXT", ext);
							row.put("ICON", "/" + iconFoderPath + "/" + file);
							row.put("PATH", "/" + iconFoderPath + "/" + file);
							
							result.add(row);
						}
					}
				}
			}
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return result;
	}
}