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
import project.common.service.CommonService;

@Service
public class InboundService extends BaseService {
	
	static final Logger log = LogManager.getLogger(InboundService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	public CommonService commonService;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveAS01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		String iasnky = "";
		try {
			String asntty = "";
			if(map.containsKey("ASNTTY")){
				asntty = map.getString("ASNTTY");
			}
			
			String lota01 = "";
			if(map.containsKey("LOTA01")){
				lota01 = map.getString("LOTA01");
			}
			
			List<DataMap> list = map.getList("list");
			
			int listSize = list.size();
			if(listSize > 0){
				map.setModuleCommand("Inbound", "AS01_IASNKY");
				iasnky = (String) commonDao.getObj(map);
				
				for(int  i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);
					
					row.put("IASNKY", iasnky);
					if(!"".equals(asntty)){
						row.put("ASNTTY", asntty);
					}
					
					row.setModuleCommand("Common", "COMMON_SKUMA");
					DataMap skumaMap = commonDao.getMap(row);
					String ownrky = skumaMap.getString("OWNRKY");
					String desc01 = skumaMap.getString("DESC01");
					
					row.put("OWNRKY", ownrky);
					row.put("DESC01", desc01);
					
					String ptnrky = "";
					String name01 = "";
					
					if("003".equals(asntty)){
						String lotnum = row.getString("AWMSNO").trim();
						if(!"".equals(lotnum)){
							row.setModuleCommand("Inbound", "LOT_BZPTN");
							row.put("LOTNUM", lotnum);
							DataMap bzptnMap = commonDao.getMap(row);
							
							if(bzptnMap != null){
								ptnrky = bzptnMap.getString("PTNRKY");
								name01 = bzptnMap.getString("PTNRNM");
								
								String lota02 = bzptnMap.getString("LOTA02");
								String lota03 = bzptnMap.getString("LOTA03");
								
								row.put("LOTA02", lota02);
								row.put("LOTA03", lota03);
								row.put("AWMSNO", lotnum);
							}
						}else{
							ptnrky = row.getString("PTNRKY");
							
							row.setModuleCommand("Common", "COMMON_BZPTN");
							DataMap bzptnMap = commonDao.getMap(row);
							if(bzptnMap != null){
								name01 = bzptnMap.getString("NAME01");
							}
						}
						
						String rptnky = "";
						String rptnnm = "";
						
						String shpoky = row.getString("SVBELN").trim();
						if(!"".equals(shpoky)){
							row.put("SHPOKY", shpoky);
							row.setModuleCommand("Inbound", "SHPDH_BZPTN");
							DataMap bzptnMap = commonDao.getMap(row);
							if(bzptnMap != null){
								rptnky = bzptnMap.getString("PTNRKY");
								rptnnm = bzptnMap.getString("PTNRNM");
							}
						}else{
							DataMap bzptnMap = new DataMap();
							map.clonSessionData(bzptnMap);
							
							rptnky = row.getString("RPTNKY");
							
							bzptnMap.put("PTNRKY",rptnky);
							bzptnMap.setModuleCommand("Common", "COMMON_BZPTN");
							
							bzptnMap = commonDao.getMap(bzptnMap);
							if(bzptnMap != null){
								rptnnm = bzptnMap.getString("NAME01");
							}
						}
						
						row.put("RPTNKY", rptnky);
						row.put("RPTNNM", rptnnm);
					}else{
						ptnrky = row.getString("PTNRKY");
						
						row.setModuleCommand("Common", "COMMON_BZPTN");
						DataMap bzptnMap = commonDao.getMap(row);
						if(bzptnMap != null){
							name01 = bzptnMap.getString("NAME01");
						}
					}
					
					if(!"".equals(lota01)){
						row.put("LOTA01", lota01);
					}
					
					row.put("PTNRNM", name01);
					row.put("LOTA04", ptnrky);
					row.put("LOTA05", name01);
					
					row.setModuleCommand("Inbound", "AS01");
					
					commonDao.insert(row);
					
					count++;
				}
				
				DataMap asnHeadMap = new DataMap();
				asnHeadMap.put("IASNKY", iasnky);
				asnHeadMap.put("ASNTTY", asntty);
				map.clonSessionData(asnHeadMap);
				asnHeadMap.setModuleCommand("Inbound", "IFASN_HEAD");
				
				List<DataMap> asnHeadList = commonDao.getList(asnHeadMap);
				int asnHeadListSize = asnHeadList.size();
				if(asnHeadListSize > 0){
					for(int i = 0; i < asnHeadListSize; i++){
						DataMap headRow = asnHeadList.get(i).getMap("map");
						map.clonSessionData(headRow);
						
						String asndky = commonDao.getDocNum(headRow.getString("ASNTTY"));
						
						headRow.put("ASNDKY", asndky);
						
						headRow.setModuleCommand("Inbound", "ASNDH");
						
						commonDao.insert(headRow);
						
						headRow.setModuleCommand("Inbound", "IFASN_ITEM");
						List<DataMap> asnItemList = commonDao.getList(headRow);
						int asnItemListSize = asnItemList.size();
						if(asnItemListSize > 0){
							for(int j = 0; j < asnItemListSize; j++){
								DataMap itemRow = asnItemList.get(j).getMap("map");
								map.clonSessionData(itemRow);
								itemRow.put("ASNDKY", asndky);
								itemRow.setModuleCommand("Inbound", "ASNDI");
								
								commonDao.insert(itemRow);
							}
						}else{
							throw new SQLException("등록할 입고 예정정보(ITEM)이 없습니다.");
						}
					}
				}
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("CNT", count);
		rsMap.put("IASNKY", iasnky);
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveAS05(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		try {
			int headSize = head.size();
			if(headSize > 0){
				for(int i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String asndky = headRow.getString("ASNDKY");
					
					headRow.setModuleCommand("Inbound", "AS02_SAVE_CHECK");
					int saveCheckCount = commonDao.getCount(headRow);
					if(saveCheckCount > 0){
						rsMap.put("RESULT", "F1");
						rsMap.put("ASNDKY", asndky);
						return rsMap;
					}
				}	
				
				for(int i = 0; i < headSize; i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String asndky = headRow.getString("ASNDKY");
					
					if(item.size() > 0 && asndky.equals(item.get(0).getMap("map").getString("ASNDKY"))){
						for(int j = 0; j < item.size(); j++){
							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.setModuleCommand("Inbound", "AS02_ITEM");
							
							commonDao.update(itemRow);
						}
						
						headRow.setModuleCommand("Inbound", "AS02_ITEM");
						int count = commonDao.getCount(headRow);
						if(count == 0){
							headRow.setModuleCommand("Inbound", "AS02_HEAD");
							commonDao.update(headRow);
						}
					}else{
						headRow.setModuleCommand("Inbound", "AS02_HEAD");
						commonDao.update(headRow);
						
						headRow.setModuleCommand("Inbound", "AS02_ITEM");
						commonDao.update(headRow);
					}
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		try {
			if(head.size() > 0){
				for(int  i = 0; i < head.size(); i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String recvky = "";
					String wareky = headRow.getString("WAREKY");
					String ownrky = headRow.getString("OWNRKY");
					String asndky = headRow.getString("ASNDKY");
					String asntty = headRow.getString("ASNTTY");
					String rcptty = headRow.getString("RCPTTY");
					String lota04 = headRow.getString("DPTNKY");
					String lota05 = headRow.getString("DNAME1");
					String docdat = headRow.getString("DOCDAT");
					String usrid1 = headRow.getString("SEBELN");
					String usrid2 = headRow.getString("SVBELN");
					String uname1 = headRow.getString("SZMBLNO");
					
					String recdhSaveType = "C";
					
					headRow.setModuleCommand("Inbound", "RECDH_ASN");
					DataMap rcvHeadMap = commonDao.getMap(headRow);
					recvky = (rcvHeadMap == null)?"":rcvHeadMap.getString("RECVKY");
					if("".equals(recvky.trim())){
						recvky = commonDao.getDocNum(rcptty);
					}else{
						recdhSaveType = "U";
					}
					
					headRow.put("RECVKY", recvky);
					headRow.put("USRID1", usrid1);
					headRow.put("USRID2", usrid2);
					headRow.put("UNAME1", uname1);
					headRow.setModuleCommand("Inbound", "RECDI_MAXRIT");
					
					int itemCount = commonDao.getCount(headRow);
					List<DataMap> temp = new ArrayList<DataMap>();
					
					if(item.size() > 0 && asndky.equals(item.get(0).getMap("map").getString("REFDKY"))){
						for(int j = 0; j < item.size(); j++){
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Inbound", "GR01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					if(temp.size() > 0){
						for (int j = 0; j < temp.size(); j++) {
							DataMap itemRow = temp.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.put("RECVKY", recvky);
							itemRow.put("WAREKY", wareky);
							itemRow.put("OWNRKY", ownrky);
							
							String recdiSaveType = "C";
							String inum = "";
							
							itemRow.setModuleCommand("Inbound", "RECDI_ASN");
							DataMap rcvItemMap = commonDao.getMap(itemRow);
							String rcvItemRecvit = (rcvItemMap==null)?"":rcvItemMap.getString("RECVIT");
							if("".equals(rcvItemRecvit.trim())){
								itemCount += 10;
								String snum = String.valueOf(itemCount);
								inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
							}else{
								recdiSaveType = "U";
								inum = rcvItemRecvit;
							}
							
							//float qtyorg = Float.parseFloat(itemRow.getString("QTYORG"));
							//float qtyrcv = Float.parseFloat(itemRow.getString("QTYRCV"));
							
							itemRow.put("RECVIT", inum);
							itemRow.put("REFCAT", asntty);
							itemRow.put("REFDAT", docdat);
							itemRow.put("STATIT", "FPC");
							itemRow.put("LOTA04", lota04);
							itemRow.put("LOTA05", lota05);
							itemRow.setModuleCommand("Inbound", "RECDI");
							
							switch (recdiSaveType) {
							case "C":
								commonDao.insert(itemRow);
								break;
							case "U":
								itemRow.setModuleCommand("Inbound", "RECDI_QTYRCV");
								commonDao.update(itemRow);
								break;
							default:
								break;
							}
						}
					}
					
					headRow.setModuleCommand("Inbound", "RECDH_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					
					headRow.put("STATDO", statdo);
					headRow.setModuleCommand("Inbound", "RECDH");
					
					switch (recdhSaveType) {
					case "C":
						commonDao.insert(headRow);
						break;
					case "U":
						commonDao.update(headRow);
						break;
					default:
						break;
					}
					
					DataMap asnMap = new DataMap();
					map.clonSessionData(asnMap);
					asnMap.put("ASNDKY", asndky);
					asnMap.put("RECVKY", recvky);
					asnMap.setModuleCommand("Inbound", "ASNDI_STATUS");
					
					List<DataMap> asnList = commonDao.getList(asnMap);
					int asnListSize = asnList.size();
					if(asnListSize > 0){
						for(int j = 0; j < asnListSize; j++){
							DataMap row = asnList.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.setModuleCommand("Inbound", "ASNDI_STATUS");
							
							commonDao.update(row);
						}
					}
					
					headRow.setModuleCommand("Inbound", "ASNDH_STATUS");
					
					commonDao.update(headRow);
				}
				
				rsMap.put("RESULT", "S");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR04(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		int count = 0;
		
		try {
			int headSize = head.size();
			if(headSize > 0){
				for(int i = 0; i < headSize; i++){
					count = 0;
					
					int itemCount = 0;
					
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String recvky = "";
					String wareky = headRow.getString("WAREKY");
					String asndky = headRow.getString("ASNDKY");
					String asntty = headRow.getString("ASNTTY");
					String rcptty = headRow.getString("RCPTTY");
					String docdat = headRow.getString("DOCDAT");
					String usrid1 = headRow.getString("SEBELN");
					
					String recdhSaveType = "C";
					
					headRow.setModuleCommand("Inbound", "RECDH_ASN");
					DataMap rcvHeadMap = commonDao.getMap(headRow);
					recvky = (rcvHeadMap == null)?"":rcvHeadMap.getString("RECVKY");
					if("".equals(recvky.trim())){
						recvky = commonDao.getDocNum(rcptty);
					}else{
						recdhSaveType = "U";
					}
					
					headRow.put("RECVKY", recvky);
					headRow.put("USRID1", usrid1);
					headRow.put("USRID3", asndky);
					
					List<DataMap> temp = new ArrayList<DataMap>();
					
					if(item.size() > 0 && asndky.equals(item.get(0).getMap("map").getString("REFDKY"))){
						for(int j = 0; j < item.size(); j++){
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Inbound", "GR01_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					int tempSize = temp.size();
					if(tempSize > 0){
						for(int j = 0; j < tempSize; j++){
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);
							
							String inum = "";
							String recdiSaveType = "C";
							
							row.put("WAREKY", wareky);
							row.put("RECVKY", recvky);
							
							row.setModuleCommand("Inbound", "RECDI_ASN");
							DataMap rcvItemMap = commonDao.getMap(row);
							String rcvItemRecvit = (rcvItemMap==null)?"":rcvItemMap.getString("RECVIT");
							if("".equals(rcvItemRecvit.trim())){
								itemCount += 10;
								String snum = String.valueOf(itemCount);
								inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
							}else{
								recdiSaveType = "U";
								itemCount = Integer.parseInt(rcvItemRecvit) + 10;
								String snum = String.valueOf(itemCount);
								inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
							}
							
							float qtyrcv = Float.parseFloat(row.getString("QTYRCV")); 
							if(qtyrcv > 0){
								String lotnum = row.getString("LOTNUM").trim();
								if(!"".equals(lotnum)){
									row.setModuleCommand("Inbound", "LOT_BZPTN");
									
									DataMap lotMap = commonDao.getMap(row);
									if(lotMap != null){
										String sebeln = lotMap.getString("SEBELN");
										String sebelp = lotMap.getString("SEBELP");
										
										row.put("SEBELN", sebeln);
										row.put("SEBELP", sebelp);
									}
								}
								
								row.put("REFCAT", asntty);
								row.put("REFDAT", docdat);
								row.put("RECVIT", inum);
								row.put("STATIT", "NEW");
								row.setModuleCommand("Inbound", "RECDI");
								
								commonDao.insert(row);
								
								if("U".equals(recdiSaveType)){
									row.setModuleCommand("Inbound", "PRCS_RTN_IN_STKKY");
									commonDao.getMap(row);
								}
								
								count++;
							}
						}
					}
					
					if(count > 0 && "C".equals(recdhSaveType)){
						headRow.put("STATDO", "NEW");
						headRow.setModuleCommand("Inbound", "RECDH");
						
						commonDao.insert(headRow);
						
						headRow.setModuleCommand("Inbound", "PRCS_RTN_GRP_STKKY");
						commonDao.getMap(headRow);
					}
				}
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR09(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		
		try {
			if(head.size() > 0){
				for(int  i = 0; i < head.size(); i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String recvky = headRow.getString("RECVKY");
					
					headRow.setModuleCommand("Inbound", "GR09_TASK_CHECK");
					DataMap taskCheckMap = commonDao.getMap(headRow);
					float qtyTsk = Float.parseFloat(taskCheckMap.getString("QTYTSK"));
					if(qtyTsk > 0){
						rsMap.put("RESULT", "F1");
						rsMap.put("RECVKY", recvky);
						return rsMap;
					}
				}
				
				for(int  i = 0; i < head.size(); i++){
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);
					
					String recvky = headRow.getString("RECVKY");
					String asndky = headRow.getString("ASNDKY");
					
					List<DataMap> temp = new ArrayList<DataMap>();
					
					if(item.size() > 0 && recvky.equals(item.get(0).getMap("map").getString("RECVKY"))){
						for(int j = 0; j < item.size(); j++){
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					}else{
						headRow.setModuleCommand("Inbound", "GR09_ITEM");
						temp = commonDao.getList(headRow);
					}
					
					if(temp.size() > 0){
						for (int j = 0; j < temp.size(); j++) {
							DataMap itemRow = temp.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							float qtyorg = Float.parseFloat(itemRow.getString("QTYORG"));
							float qtyrcv = Float.parseFloat(itemRow.getString("QTYRCV"));
							if(qtyrcv < 0){
								qtyrcv = 0;
							}
							if(qtyorg < qtyrcv){
								qtyrcv = qtyorg;
							}
							
							float qtydif = qtyorg - qtyrcv;
							
							itemRow.put("QTYRCV", qtyrcv);
							itemRow.setModuleCommand("Inbound", "GR09_RECDI");
							if(qtydif == 0){
								commonDao.delete(itemRow);
							}else{
								commonDao.update(itemRow);
							}
							
							itemRow.setModuleCommand("Inbound", "GR09_ASNDI");
							DataMap asnMap = commonDao.getMap(itemRow);
							float asnQty    = Float.parseFloat(asnMap.getString("QTYASN"));
							float asnQtyRcv = Float.parseFloat(asnMap.getString("QTYRCV"));
							float asnQtyDif = asnQtyRcv - qtyrcv;
							if((asnQty - asnQtyDif) == 0){
								itemRow.put("STATIT", "NEW");
							}else{
								itemRow.put("STATIT", "PPC");
							}
							itemRow.put("QTYRCV", asnQtyDif);
							itemRow.setModuleCommand("Inbound", "ASNDI_STATUS");
							
							commonDao.update(itemRow);
						}
					}
					
					headRow.setModuleCommand("Inbound", "GR09_RECDI");
					int asndiCount = commonDao.getCount(headRow);
					if(asndiCount == 0){
						headRow.setModuleCommand("Inbound", "GR09_RECDH");
						commonDao.delete(headRow);
					}
					
					DataMap asnMap = new DataMap();
					map.clonSessionData(asnMap);
					asnMap.put("ASNDKY", asndky);
					asnMap.put("RECVKY", recvky);
					asnMap.setModuleCommand("Inbound", "ASNDI_STATUS");
					
					List<DataMap> asnList = commonDao.getList(asnMap);
					int asnListSize = asnList.size();
					if(asnListSize > 0){
						for(int j = 0; j < asnListSize; j++){
							DataMap row = asnList.get(j).getMap("map");
							map.clonSessionData(row);
							
							row.setModuleCommand("Inbound", "ASNDI_STATUS");
							
							commonDao.update(row);
						}
					}
					
					headRow.setModuleCommand("Inbound", "ASNDH_STATUS");
					String statdo = (String) commonDao.getObject(headRow);
					headRow.put("STATDO", statdo);
					
					commonDao.update(headRow);
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F2");
			}	
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR60(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		DataMap tempMap =  map.getMap("temp");

		for(int  i = 0; i < head.size(); i++){
			DataMap headRow = head.get(i).getMap("map");
			map.clonSessionData(headRow);

			List<DataMap> tempList = (List<DataMap>) tempMap.get(headRow.getString("RECVKY"));
			
			if(tempList == null || tempList.size() < 1 ) tempList = item;
			
			for (int j = 0; j < tempList.size(); j++) {
				DataMap itemRow = tempList.get(j).getMap("map");
				map.clonSessionData(itemRow);

				itemRow.setModuleCommand("Inbound", "VALID_GR60");
				
				List validList = commonDao.getList(itemRow);

				if(validList != null || validList.size() > 0 ) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0326",new String[]{})); //제고병합이 필요합니다 


				itemRow.setModuleCommand("Inbound", "GR60_FLAG");
				commonDao.update(itemRow);
				
			}

			headRow.setModuleCommand("Inbound", "VALID_GR60");
			
			DataMap validMap = commonDao.getMap(headRow);
			if(validMap!= null && "OK".equals(validMap.getString("RESULTMSG"))){
				//최종 취소 업데이트
				headRow.setModuleCommand("Inbound", "GR60_DELETE");
				commonDao.update(headRow);
			}
		}

		rsMap.put("RESULT", "Y");
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR60_2(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		DataMap tempMap = new DataMap();
		String recvky = "";
		
		if(!map.getMap("temp").isEmpty()){
			tempMap = map.getMap("temp");
		}
		
		if(!map.getList("item").isEmpty()){
			itemlist = map.getList("item");
			recvky = itemlist.get(0).getMap("map").getString("RECVKY");
		}

		for(int  i = 0; i < head.size(); i++){
			DataMap headRow = head.get(i).getMap("map");
			map.clonSessionData(headRow);
			List<DataMap> tempList = new ArrayList();
			
			
			if(recvky.equals(headRow.getString("RECVKY"))){
				tempList = itemlist;
			}else if(tempMap.containsKey(headRow.getString("RECVKY")) ){
				tempList = tempMap.getList(headRow.getString("RECVKY"));
			}
			
//			if(!tempMap.isEmpty()){
//				tempList = (List<DataMap>) tempMap.get(headRow.getString("RECVKY"));
//			}
			
			if(tempList == null || tempList.size() < 1 ){
				if(item.size() > 0 && headRow.getString("RECVKY").equals(((DataMap)item.get(0).get("map")).getString("RECVKY"))){
					tempList = item;
				}else{
					DataMap trgMap = (DataMap)map.clone();
					trgMap.putAll(headRow);
					trgMap.setModuleCommand("SajoInbound", "GR60_ITEM");
					tempList = commonDao.getList(trgMap);
				}
			}
			
			for (int j = 0; j < tempList.size(); j++) {
				DataMap itemRow = tempList.get(j).getMap("map");
				map.clonSessionData(itemRow);
				
				//저장불가 조건체크
				if("".equals(itemRow.getString("RSNCOD")) || " ".equals(itemRow.getString("RSNCOD"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_C00102NVL",new String[]{})); //사유코드 입력

				itemRow.setModuleCommand("SajoInbound", "VALID_GR60");
				
				List validList = commonDao.getList(itemRow);

				if((validList != null || validList.size() > 0) && ((DataMap)validList.get(0)).getInt("V_REVCAL") > 0) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0326",new String[]{})); //제고병합이 필요합니다 


				itemRow.setModuleCommand("SajoInbound", "GR60_FLAG");
				commonDao.update(itemRow);
				
			}

			headRow.setModuleCommand("SajoInbound", "VALID_GR60");
			
			DataMap validMap = commonDao.getMap(headRow);
			if(validMap!= null && "OK".equals(validMap.getString("RESULTMSG"))){
				//최종 취소 업데이트
				headRow.setModuleCommand("SajoInbound", "GR60_DELETE");
				commonDao.update(headRow);
			}
		}

		rsMap.put("RESULT", "Y");
		return rsMap;
	}
}