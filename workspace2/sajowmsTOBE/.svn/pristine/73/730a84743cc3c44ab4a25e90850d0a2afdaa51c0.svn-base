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
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.FileUtil;
import project.common.util.SqlUtil;

@Service
public class SystemService extends BaseService {
	
	static final Logger log = LogManager.getLogger(SystemService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
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
					//sb = String.join(",", list);
					
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
	
	
	//UI01 사용자 저장
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUI01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");

			//INSERT
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("System", "UI01");
				
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
					
				//UPDATE
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
	
	
	//USRMA, UI02 사용자 저장
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUI02(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");

			//INSERT
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				map.clonSessionData(row);
				row.setModuleCommand("System", "UI02");
				
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
					
				//UPDATE
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
	
	//UI01_UserDialog 연결:사용자 팝업
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUI01_UserDialog(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> list = map.getList("list");

			map.setModuleCommand("System", "UI01_UserDialog");
				
			commonDao.delete(map);
			count++;
			
			for(int  i = 0; i < list.size(); i++){
				DataMap row = list.get(i).getMap("map");
				
				String chk = row.getString("CHK");
				
				row.put("USERID",map.getString("USERID"));
				
				map.clonSessionData(row);
				row.setModuleCommand("System", "UI01_UserDialog");
				
				if(chk.equals("V")){
					
					commonDao.insert(row);
					count++;
				}
			}
			
		} catch (Exception e) {
			throw new Exception("에러가 발생 했습니다. 관리자에게 문의 바랍니다.");
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
		
	}
	
	//UI01_LAYOUTDLG 레이아웃복사 팝업
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUI01_LAYOUTDLG(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			map.setModuleCommand("System", "UI01_LAYOUTDLG");
			List<DataMap> list = commonDao.getList(map);
			
			commonDao.delete(map);
			
			commonDao.insert(map);
			count++;
			
			if(list.size() == 0){		
				String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "SYSTEM_M0096",new String[]{""});
				throw new Exception("*"+ msg + "*");
				
			}
			
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		
		return rsMap;
	}
	
	// [UR01] 생성
	@Transactional(rollbackFor = Exception.class)
	public DataMap createUR01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;

		try {
			//유효성체크
			map.setModuleCommand("System", "UR01_Create");
			int chk = commonDao.getMap(map).getInt("CHK"); //중복체크
			//resultChk = (int)commonDao.insert(map);
			if(chk > 0 ){
				String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
				throw new Exception("* 동일한 라벨이 존재 합니다. *");
			}else{
				resultChk = (int)commonDao.insert(map);
			}

			if(resultChk >= 1){
				rsMap.put("RESULT", "OK");
			}
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}
	
	// [UR01] 삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteUR01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		//List<DataMap> list = map.getList("list");
		DataMap row = new DataMap();
		row.put("UROLKY",map.getString("MENUGID"));

		try {
			//유효성체크
			row.setModuleCommand("System", "UR01_Programs_ALL");
			commonDao.delete(row);
			
			row.setModuleCommand("System", "UR01_Connectivity_ALL");
			commonDao.delete(row);
			
			row.setModuleCommand("System", "UR01_CONNOWN_ALL");
			commonDao.delete(row);
			
			row.setModuleCommand("System", "UR01_ALL2");
			commonDao.delete(row);
			
			row.setModuleCommand("System", "UR01_ALL");
			commonDao.delete(row);
			
			
			rsMap.put("RESULT", "OK");

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}
	
	// [UR01] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> list1 = map.getList("list1");
		int resultChk = 0;

		try {
			DataMap row = list1.get(0).getMap("map");
			map.clonSessionData(row);
			String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
			if(rowState.equals("U")){
				row.setModuleCommand("System", "UR01_display1");
				resultChk = (int)commonDao.update(row);
			}
			if(resultChk >= 1){
				rsMap.put("RESULT", "OK");
			}
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}
	
	// [UR01] SAVE2
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01_2(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> list2 = map.getList("list2");
		int resultChk = 0;

		try {
			if(list2.size() > 0){
				for(int  i = 0; i < list2.size(); i++){
					DataMap row = list2.get(i).getMap("map");
					map.clonSessionData(row);
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					
					if(rowState.equals("C")){
						//유효성체크
						row.setModuleCommand("System", "UR01_SAVE2");
						int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
						if(chk > 0 ){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 동일한 라벨이 존재 합니다. *");
						}else{
							resultChk = (int)commonDao.insert(row);
						}
					}else if(rowState.equals("D")){
						row.setModuleCommand("System", "UR01_SAVE2");
						resultChk = (int)commonDao.delete(row);
					}
				}
				if(resultChk >= 1){
					rsMap.put("RESULT", "OK2");
				}
			}


		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}
	
	//UR01_CONNOWN popup1
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01_popup1(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		DataMap gridData = map.getMap("gridData");
		
		try {
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);

					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					//insert "C"

					if(rowState.equals("C")){

						//유효성체크
						row.setModuleCommand("System", "UR01_CONNOWN");
						int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
						if(chk > 0 ){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 동일한 라벨이 존재 합니다. *");
						}else{
							resultChk = (int)commonDao.insert(row);
						}
					}else if(rowState.equals("U")){
						row.setModuleCommand("System", "UR01_CONNOWN");
						
							resultChk = (int)commonDao.update(row);
						
					}else if(rowState.equals("D")){
						row.setModuleCommand("System", "UR01_CONNOWN");
						
							resultChk = (int)commonDao.delete(row);
					}
					
				}
				
				if(resultChk >= 1){
					rsMap.put("RESULT", "OK");
				}
			}
			if(gridData.size() > 0){
				DataMap row = gridData;
				map.clonSessionData(row);

				row.setModuleCommand("System", "UR01_display1");
				commonDao.update(row);
			}
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	//UR01_Connectivity
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01_popup2(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		DataMap gridData = map.getMap("gridData");
		
		
		try {
			if(list.size() > 0){
				DataMap row = new DataMap();
				for(int  i = 0; i < list.size(); i++){
					row = list.get(i).getMap("map");
					map.clonSessionData(row);

					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					//insert "C"

					if(rowState.equals("C")){

						//유효성체크
						row.setModuleCommand("System", "UR01_Connectivity");
						int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
						if(chk > 0 ){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 동일한 라벨이 존재 합니다. *");
						}else{
							resultChk = (int)commonDao.insert(row);
						}
						
					}else if(rowState.equals("U")){
						row.setModuleCommand("System", "UR01_Connectivity");
						resultChk = (int)commonDao.update(row);
						
					}else if(rowState.equals("D")){
						row.setModuleCommand("System", "UR01_Connectivity");
						resultChk = (int)commonDao.delete(row);
					}

				}
				
				if(resultChk >= 1){
					rsMap.put("RESULT", "OK");
				}
			}
			if(gridData.size() > 0){
				DataMap row = gridData;
				map.clonSessionData(row);

				row.setModuleCommand("System", "UR01_display1");
				commonDao.update(row);
			}
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}


	//UR01_Programs
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUR01_popup3(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		List<DataMap> conn = map.getList("conn");
		DataMap gridData = map.getMap("gridData");
		
		try {
			if(list.size() == 0){
			map.setModuleCommand("System", "UR01_Programs");
			list = commonDao.getList(map);
				if(list.size() == 0){
					rsMap.put("RESULT", "listNull");
					return rsMap;
				}
			}
			
			map.setModuleCommand("System", "UR01_Programs_ALL");
			commonDao.delete(map);
			
			
			for (int i=0; i<list.size();i++){
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				if(rowState.equals("D")){
					continue;
				}else {
					//유효성체크
					row.setModuleCommand("System", "UR01_Programs");
					int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
					if(chk > 0 ){
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
						throw new Exception("* 동일한 라벨이 존재 합니다. *");
					}else{
					
					for(int i2=0;i2<conn.size();i2++){
						DataMap row2 = conn.get(i2).getMap("map");
						map.clonSessionData(row2);
						String rowState2 = row2.getString(CommonConfig.GRID_ROW_STATE_ATT);
						if(rowState2.equals("D")){
							continue;
						}else{
							//row2.put("SES_USER_ID", map.getString("SES_USER_ID"));
							row2.put("PROGID",row.getString("PROGID"));
  							row2.setModuleCommand("System", "UR01_Programs");
							resultChk = (int)commonDao.insert(row2);
							}
						}
					}
				}	
			}
			if(resultChk >= 1){
				if("search".equals(map.getString("TYPE"))){
					rsMap.put("RESULT", "Search");
				}else {
 					rsMap.put("RESULT", "SAVEOK");
				}
			}else {
				rsMap.put("RESULT", "progFalse");
			}
			if(gridData.size() > 0){
				DataMap row = gridData;
				map.clonSessionData(row);

				row.setModuleCommand("System", "UR01_display1");
				commonDao.update(row);
			}
			

		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	//UR01_Connectivity
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUM02(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		
		try {
			if(list.size() > 0){
				DataMap row = new DataMap();
				for(int  i = 0; i < list.size(); i++){
					row = list.get(i).getMap("map");
					map.clonSessionData(row);

					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					//insert "C"

					if(rowState.equals("C")){

						//유효성체크
						row.setModuleCommand("System", "MSTMENUFL");
						int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
						if(chk > 0 ){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 동일한 라벨이 존재 합니다. *");
						}else{
							row.setModuleCommand("Common", "MSTMENUFL");
							resultChk = (int)commonDao.insert(row);
						}
						
					}else if(rowState.equals("D")){ 
						row.setModuleCommand("Common", "MSTMENUFL");
						resultChk = (int)commonDao.delete(row);
					}

				}
				
				if(resultChk >= 1){
					rsMap.put("RESULT", "OK");
				}
			}

		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}

	
	//[공통] 레이아웃 저장
	@Transactional(rollbackFor = Exception.class)
	public String saveVariant(DataMap map) throws Exception {
		DataMap rtnMap = new DataMap();
		DataMap rowMap = new DataMap();
		int i = 1;
		Iterator<String> keys;
		
		//기존데이터 삭제 
		map.clonSessionData(rowMap);
		rowMap.put("PROGID", map.getString("PROGID"));
		rowMap.put("PARMKY", map.getString("PARMKY"));
		rowMap.setModuleCommand("System", "USRPL");
		commonDao.delete(rowMap);
		
		//기본 값 설정시 다른 기본값 초기화 
		if(null != map.getString("DEFCHK") && "V".equals(map.getString("DEFCHK"))){
			map.setModuleCommand("System", "VARRAINT_DEF");
			commonDao.update(map);
		}
		
		//데이터 분리 
		if(map.containsKey(CommonConfig.VARIANT_RANGE_PARAM)){
			DataMap rangeData = map.getMap(CommonConfig.VARIANT_RANGE_PARAM);
	
			//레인지 처리 
			keys = rangeData.keySet().iterator();
			while (keys.hasNext()){
				String key = keys.next();
				rowMap = new DataMap();
				map.clonSessionData(rowMap);
				//기본 테이블에 필요한 정보 세팅 
				rowMap.put("PARMKY", map.getString("PARMKY"));
				rowMap.put("PROGID", map.getString("PROGID"));
				rowMap.put("ITEMNO", i);
				rowMap.put("DEFCHK", map.getString("DEFCHK"));
				rowMap.put("SHORTX", map.getString("SHORTX"));
				
				if(key.indexOf("_"+CommonConfig.RANGE_TYPE_SINGLE) != -1){ //Single
					rowMap.put("CTRLID", key.replace("_"+CommonConfig.RANGE_TYPE_SINGLE, ""));
					rowMap.put("CTRLTY", "SR");
					rowMap.put("CTRVAL", rangeData.getString(key));
				}else if(key.indexOf("_"+CommonConfig.RANGE_TYPE_RANGE) != -1){ //Range
					rowMap.put("CTRLID", key.replace("_"+CommonConfig.RANGE_TYPE_RANGE, ""));
					rowMap.put("CTRLTY", "R");
					rowMap.put("CTRVAL", rangeData.getString(key));
				}
				
				rowMap.setModuleCommand("System", "VARIANT");
				commonDao.insert(rowMap);
				i++;
			}
		}
		
		

		if(map.containsKey("SEARCH")){
			DataMap searchData = map.getMap("SEARCH");

			//화주먼저 세팅 콤보 체인지를 위함
			if(searchData.containsKey("OWNRKY") || searchData.containsKey("OWNRKY2")){
				rowMap = new DataMap();
				map.clonSessionData(rowMap);
				//기본 테이블에 필요한 정보 세팅 
				rowMap.put("PARMKY", map.getString("PARMKY"));
				rowMap.put("PROGID", map.getString("PROGID"));
				rowMap.put("ITEMNO", i);
				if(null != searchData.getString("OWNRKY")){
					rowMap.put("CTRLID", "OWNRKY");
					rowMap.put("CTRVAL", searchData.getString("OWNRKY"));
				}else{
					rowMap.put("CTRLID", "OWNRKY2");
					rowMap.put("CTRVAL", searchData.getString("OWNRKY2"));
				}
				rowMap.put("CTRLTY", "C");
				rowMap.put("DEFCHK", map.getString("DEFCHK"));
				rowMap.put("SHORTX", map.getString("SHORTX"));
				
				rowMap.setModuleCommand("System", "VARIANT");
				commonDao.insert(rowMap);
				i++;

				if(null != searchData.getString("OWNRKY")){
					searchData.remove("OWNRKY");
				}else{
					searchData.remove("OWNRKY2");
				}
			}
			
			
			keys = searchData.keySet().iterator();
			while (keys.hasNext()){
				String key = keys.next();
				rowMap = new DataMap();
				map.clonSessionData(rowMap);
				//기본 테이블에 필요한 정보 세팅 
				rowMap.put("PARMKY", map.getString("PARMKY"));
				rowMap.put("PROGID", map.getString("PROGID"));
				rowMap.put("ITEMNO", i);
				rowMap.put("CTRLID", key);
				rowMap.put("CTRLTY", "C");
				rowMap.put("DEFCHK", map.getString("DEFCHK"));
				rowMap.put("SHORTX", map.getString("SHORTX"));
				
				rowMap.put("CTRVAL", searchData.getString(key));
				rowMap.setModuleCommand("System", "VARIANT");
				commonDao.insert(rowMap);
				i++;
				
			}
		}

		return "S";
	}
	
	//[공통] 레이아웃 삭제
	@Transactional(rollbackFor = Exception.class)
	public String deleteVariant(DataMap map) throws Exception {
		DataMap rtnMap = new DataMap();
		DataMap rowMap = new DataMap();
		int i = 1;
		Iterator<String> keys;
		
		//데이터 삭제 
		map.clonSessionData(rowMap);
		rowMap.put("PROGID", map.getString("PROGID"));
		rowMap.put("PARMKY", map.getString("PARMKY"));
		rowMap.setModuleCommand("System", "USRPL");
		commonDao.delete(rowMap);

		return "S";
	}
	
	//[공통] 레이아웃  조회
	@Transactional(rollbackFor = Exception.class)
	public DataMap getVariant(DataMap map) throws Exception {
		DataMap rtnMap = new DataMap();

		map.setModuleCommand("System", "VARIANT_ITEM");
		List<DataMap> list = commonDao.getList(map);
		
		rtnMap.put("list", list);
		return rtnMap;
	}
	
	//[공통] 레이아웃  조회
	@Transactional(rollbackFor = Exception.class)
	public DataMap getDefVariant(DataMap map) throws Exception {
		DataMap rtnMap = new DataMap();

		map.setModuleCommand("System", "VARIANT_DEF_ITEM");
		List<DataMap> list = commonDao.getList(map);
		
		rtnMap.put("list", list);
		return rtnMap;
	}

	
	//UM01 세이브
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveUM01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		String menuky = list.get(0).getMap("map").getString("MENUKY");
		
		try {
			
			map.put("MENUGID", menuky);
			
			DataMap validMap = new DataMap();
			//validation 체크 메뉴아이디 중복을 체크한다.
			for(DataMap data : list){
				DataMap row = data.getMap("map");
				map.clonSessionData(row);
				
				if(!validMap.containsKey(row.getString("MENUID"))){
					validMap.put(row.getString("MENUID"), row.getString("MENUID"));
				}else{
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",new String[]{"* 중복된 메뉴키 입니다 : "+ row.getString("MENUID") +" *"}));
				}
			}
			
			
			
			//기존 데이터 삭제 
			map.setModuleCommand("System", "MSTMENUGLALL");
			commonDao.delete(map);
			
			int depth = 10;
			//그리드를 순번을 재설정하며 저장한다.
			for(DataMap data : list){
				DataMap row = data.getMap("map");
				map.clonSessionData(row);

				String gRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				if("D".equals(gRowState)) continue; // 삭제로우 거르기
				
				row.put("COMPID", "SAJO");
				row.put("MENUGID", row.getString("MENUKY"));
				row.put("SORTORDER", depth);
				depth+=10;

				row.setModuleCommand("System", "MSTMENUGL");
				commonDao.insert(row);
			}

		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}

	
	//[공통] 레이아웃 저장
	@Transactional(rollbackFor = Exception.class)
	public String saveLayOut(DataMap map) throws Exception {
	
		DataMap rtnMap = new DataMap();
		//기본 값 설정시 다른 기본값 초기화 
		if(null != map.getString("DEFCHK") && "V".equals(map.getString("DEFCHK"))){
			map.put("COLGID", "DEFAULT");
		}
		map.put("COMPID", map.getString("GRIDID"));
		map.put("LYOTID", map.getString("COLGID"));
		
		//중복체크 
		map.setModuleCommand("Common", "USRLO");
		if(commonDao.getMap(map).getInt("CNT") > 0){
			//UPDATE
			map.setModuleCommand("Common", "SYSGRIDCOL");
			commonDao.update(map);
		}else{
			//INSERT
			map.setModuleCommand("Common", "SYSGRIDCOL");
			commonDao.insert(map);
		}

		return "S";
	}
	
	//[공통] 레이아웃 삭제
	@Transactional(rollbackFor = Exception.class)
	public String deleteLayout(DataMap map) throws Exception {
		
		//데이터 삭제 
		map.setModuleCommand("Common", "USRLO");
		commonDao.delete(map);

		return "S";
	}
}