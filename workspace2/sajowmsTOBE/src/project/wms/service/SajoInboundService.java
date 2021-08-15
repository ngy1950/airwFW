package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Collections;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun.xml.internal.messaging.saaj.packaging.mime.Header;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

@Service
public class SajoInboundService extends BaseService {
	
	static final Logger log = LogManager.getLogger(SajoInboundService.class.getName());

	private static final List List = null;
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private TaskDataService taskDataService;
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveReceive(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		DataMap dMap = new DataMap();
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("KEY");
		}
		
		int count = 0;
		String recvky = "";
		StringBuffer rtnRecvky = new StringBuffer();
		StringBuffer rtnShpoky = new StringBuffer();
		try {
			
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				map.clonSessionData(head);
				
				//  System.out.println(head);
				
				head.setModuleCommand("SajoInbound", "RECIVEKEY");
				recvky = commonDao.getMap(head).getString("KEY");
				head.put("RECVKY", recvky);
				
				head.setModuleCommand("SajoInbound", "RECDH");
				commonDao.insert(head);
				
				int recvit = 0;
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(key.equals(head.getString("KEY"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("KEY")) ){
					list = itemTemp.getList(head.getString("KEY"));
				}
				
				if(list.size() == 0){
					//dMap = 해드 + 검색조건
					head.put("menuId",map.getString("menuId"));
					dMap = (DataMap)map.clone();
					dMap.putAll(head);
					dMap.setModuleCommand("SajoInbound", itemquery);
					list = commonDao.getList(dMap);
					
				}
				
				for(int j=0;j<list.size();j++){
					DataMap row = list.get(j).getMap("map");
					map.clonSessionData(row);
					String rcptty = head.getString("RCPTTY");
					int qtyrcv = (row.getInt("QTYRCV"));
					if(!rcptty.equals("131") && !rcptty.equals("133") && !rcptty.equals("134") 
							&& !rcptty.equals("135") && !rcptty.equals("136") && !rcptty.equals("137") 
							&& !rcptty.equals("138") && !rcptty.equals("139") ){
						if(qtyrcv == 0){
							continue;
						}
					}
					
					if(rcptty.equals("131") || rcptty.equals("133") || rcptty.equals("134") 
							|| rcptty.equals("135") || rcptty.equals("136") || rcptty.equals("137") 
							|| rcptty.equals("138") || rcptty.equals("139") ){

						String rsncod = row.getString("RSNCOD");
						if(rsncod.trim().equals("") || rsncod.equals(" ")){
//							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0110",new String[]{row.getString("SVBELN")});
//							String msg = commonService.getMessageParam( map.getString("SES_LANGUAGE"), "IN_M0110" ,new String[]{} );
							String msg = commonService.getMessageParam("KO", "IN_M0110",new String[]{});
							throw new Exception("*"+ msg + "*");
						}
						
					}
					

					if(!head.getString("RCPTTY").equals("166"))
						row.put("LOTA03", head.getString("DPTNKY"));
					
					if(head.getString("SHPOKYMV").length() == 10 && (head.getString("SHPOKYMV").substring(0, 1).equals("2") && (head.getString("RCPTTY")).equals("121") || head.getString("RCPTTY").equals("122") || head.getString("RCPTTY").equals("123") ) ) {
						DataMap param = new DataMap();
						
						param.put("PERHNO", head.getString("PERHNO") );
						param.put("RECNUM", head.getString("RECNUM") );
						param.put("CASTDT", head.getString("CASTDT") );
						param.put("CASTIM", head.getString("CASTIM") );
						param.put("CARNUM", head.getString("CARNUM") );
						param.put("SHPOKY", head.getString("SHPOKYMV"));
						param.put("SHPOIT", row.getString("SHPOIT"));
						
						map.clonSessionData(param);
						
						param.setModuleCommand("SajoInbound", "CARINFO");
						
						commonDao.update(param);
						
//						super.nativeExecuteUpdate("SHPDR.CARINFO_UPDATE", params);
					}
					
					recvit += 10;
					String snum = String.valueOf(recvit);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("RECVKY", recvky);
					row.put("RECVIT", inum);
					
					
					
					row.setModuleCommand("SajoInbound", "RECDI");
					commonDao.insert(row);
					
					count++;
					
				}
				
				if("".equals(keys.toString())){
					keys.append("'").append(recvky).append("'");
				}else{
					keys.append(",'").append(recvky).append("'");
				}
				
				if("".equals(rtnRecvky.toString())){
					rtnRecvky.append("'").append(recvky).append("'");
				}else{
					rtnRecvky.append(",'").append(recvky).append("'");
				}
				
				if("".equals(rtnShpoky.toString())){
					rtnShpoky.append("'").append(head.getString("SHPOKYMV")).append("'");
				}else{
					rtnShpoky.append(",'").append(head.getString("SHPOKYMV")).append("'");
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		rsMap.put("SAVEKEY", keys);
		rsMap.put("SHPOKYS", rtnShpoky.toString());
		rsMap.put("RECVKYS", rtnRecvky.toString());
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayGR30(DataMap map) throws Exception {
		
		if (map.getString("RCPTTY").equals("121")) {
			map.setModuleCommand("SajoInbound", "GR30_HEADER_121");
		} else if (map.getString("RCPTTY").equals("122")) {
			map.setModuleCommand("SajoInbound", "GR30_HEADER_122");
		}else if (map.getString("RCPTTY").equals("123")) {
			map.setModuleCommand("SajoInbound", "GR30_HEADER_123");
		}
		

		List<DataMap> list = commonDao.getList(map);
		

		return list ;
	}

	@Transactional(rollbackFor = Exception.class)
	public List displayGR30Item(DataMap map) throws Exception {
		if (map.getString("RECVKY").equals(" ")) {
			if (map.getString("RCPTTY").equals("121")) {
				map.setModuleCommand("SajoInbound", "GR30_ITEM_121");
			} else if (map.getString("RCPTTY").equals("122")) {
				map.setModuleCommand("SajoInbound", "GR30_ITEM_122");
			}
		} else {
			map.setModuleCommand("SajoInbound", "GR30_AFTERITEM");
		}
		
		List<DataMap> list = commonDao.getList(map);
		
		return list ;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR30(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		//DataMap head = map.getMap("head");
		//DataMap item = map.getMap("item");
		List<DataMap> hlist = map.getList("headlist");
		List<DataMap> ilist = map.getList("list");
		DataMap itemTemp = map.getMap("tempItem");
		StringBuffer rtnString = new StringBuffer();
		StringBuffer rtnString2 = new StringBuffer();
		
		int count = 0;
		String recvky = "";
		try {
			
			for(int i=0;i<hlist.size();i++){
				DataMap row = hlist.get(i).getMap("map");   
				map.clonSessionData(row);
	
/*				item.putAll(row);
				item.setModuleCommand("SajoInbound", "GR30_VALI");
				commonDao.getMap(item);*/
	
	
				row.setModuleCommand("SajoInbound", "RECIVEKEY");
				
				recvky = commonDao.getMap(row).getString("KEY");
				row.put("RECVKY", recvky);
				
				
				int recvit = 0;
				
				
				if( row.getString("SHPOKYMV").length() == 10 && row.getString("SHPOKYMV").substring(0, 1).equals("2") 
						&& (row.getString("RCPTTY").equals("121") || row.getString("RCPTTY").equals("122") || row.getString("RCPTTY").equals("123") ) ) {
				       row.setModuleCommand("SajoInbound", "GR30");
				       commonDao.update(row);
				}
					
				row.setModuleCommand("SajoInbound", "RECDH");
				commonDao.insert(row);
				rsMap.putAll(row);

				
				List tempList = new ArrayList();
				tempList = itemTemp.getList(row.getString("SHPOKYMV"));  
				
				if(tempList != null){ // 템프가 있을 때
					 //그리드에서 넘어온 Item List 저장 
			        //Head만 저장시 헤더에서 넘어온 값으로 Item List 조회 후 저장 
					//템프 사용   
						
					for(int i2=0;i2<tempList.size();i2++){
						DataMap row2 = ((DataMap)tempList.get(i2)).getMap("map"); 
						map.clonSessionData(row2);
						
						//유통기한 없으면 에러메세지 출력
						if(row2.get("LOTA13").equals("") || row2.get("LOTA13").equals(" ")){
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0324",new String[]{}));
						}

						
						recvit += 10;
						String snum = String.valueOf(recvit);
						String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
						
						row2.put("RECVKY", recvky);
						row2.put("RECVIT", inum);
						row2.put("WAREKY", map.getString("WAREKY"));
						row2.put("OWNRKY", map.getString("OWNRKY"));
						
						row2.setModuleCommand("SajoInbound", "RECDI");
						commonDao.insert(row2);
						count++;
					}
				}else{ //템프에 데이터가 없을때
					
					if (ilist.size() == 0){ //리스트에 값이 안들어있으면 쿼리돌려서 가져온다
						if (map.getString("RCPTTY").equals("121")) {
								row.setModuleCommand("SajoInbound", "GR30_ITEM_121");
							} else if (map.getString("RCPTTY").equals("122")) {
								row.setModuleCommand("SajoInbound", "GR30_ITEM_122");
							}
						
						ilist = commonDao.getList(row);

					}
					String shpoky = (String)row.get("SHPOKYMV");
					
					String itemShpoky = "";
					if (ilist.size() > 0){  //if (item.size() > 0){ 
						itemShpoky = ilist.get(0).getMap("map").getString("SHPOKYMV"); 
				    } 
					
					if (shpoky.equals(itemShpoky)){ 
						for(int i2=0;i2<ilist.size();i2++){
							DataMap row2 = ilist.get(i2).getMap("map"); 
							map.clonSessionData(row2);
							
							//유통기한 없으면 에러메세지 출력
							if(row2.get("LOTA13").equals("") || row2.get("LOTA13").equals(" ")){
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0324",new String[]{}));
							}
							
							recvit += 10;
							String snum = String.valueOf(recvit);
							String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
							
							row2.put("RECVKY", recvky);
							row2.put("RECVIT", inum);
							row2.put("WAREKY", map.getString("WAREKY"));
							row2.put("OWNRKY", map.getString("OWNRKY"));
							
							row2.setModuleCommand("SajoInbound", "RECDI");
							commonDao.insert(row2);
							count++;
						}
					}
				}
				
				if("".equals(rtnString.toString())){
					rtnString.append("'").append(row.getString("SHPOKYMV")).append("'");
				}else{
					rtnString.append(",'").append(row.getString("SHPOKYMV")).append("'");
				}
				if("".equals(rtnString2.toString())){
					rtnString2.append("'").append(recvky).append("'");
				}else{
					rtnString2.append(",'").append(recvky).append("'");
				}
				
				rsMap.put("RECVKY", rtnString2.toString());
				rsMap.put("CNT", count);
				rsMap.put("RESULT", "Y");
				rsMap.put("SHPOKY", rtnString.toString());
			}
			
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
		return rsMap;
	}
	
	private void createShipmentOrderDocumentforItem(DataMap map, DataMap row, java.util.List<DataMap> itemByHead) {
		// TODO Auto-generated method stub
		
	}

	private void createShipmentOrderDocumentforItem(DataMap map, DataMap row, DataMap item) {
		// TODO Auto-generated method stub
		
	}

	// [GR30] 저장 후 헤드 조회
	@Transactional(rollbackFor = Exception.class)
	public List returnGR30(DataMap map) throws Exception {
		
		if (map.getString("RCPTTY").equals("121")) {
			map.setModuleCommand("SajoInbound", "GR30_AFTERHEAD_121");
		} else if (map.getString("RCPTTY").equals("122")) {
			map.setModuleCommand("SajoInbound", "GR30_AFTERHEAD_121");
		}

		List<DataMap> list = commonDao.getList(map);
		
		return list ;
	}
	// [GR30] 저장 후 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List returnGR30Item(DataMap map) throws Exception {
		
		map.setModuleCommand("SajoInbound", "GR30_AFTERITEM");

		List<DataMap> list = commonDao.getList(map);
		
		return list ;
	}
	

	/**GR20 PO마감 헤더 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public List displayGR20(DataMap map) throws Exception {
		
		String GBN = map.getString("GBN");
		map.setModuleCommand("SajoInbound", "GR20_TAB"+GBN);
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList = new ArrayList<>();
		
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.SEBELN");
		keyList.add("IF.DLVDAT");
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.PTNRKY");
		keyList.add("IF.BUYCDT");
		keyList.add("IF.BUYLMO");
		
		String sql = sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList);
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		keyList2.add("IF.WAREKY");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.SEBELN");
		keyList2.add("IF.DLVDAT");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.PTNRKY");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("IF.SEBELN", "IF.SVBELN");
		changeMap2.put("IF.DLVDAT", "IF.OTRQDT");
		changeMap2.put("IF.PTNRKY", "IF.WAREKY");
		
		String sql2 = sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2);
		
		if(GBN.equals("1")){
			map.put("RANGE_SQL", sql);
		}else if(GBN.equals("2")){
			map.put("RANGE_SQL2", sql2);
		}
		
		//  System.out.println(map.toString());

		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	/**GR20 PO마감 아이템 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public List displayGR20Item(DataMap map) throws Exception {
		
		String GBN = map.getString("GBN");
		map.setModuleCommand("SajoInbound", "GR20_TAB"+GBN+"_ITEM");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList = new ArrayList<>();
		
		keyList.add("IF.OWNRKY");
		keyList.add("IF.WAREKY");
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.SEBELN");
		keyList.add("IF.DLVDAT");
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.PTNRKY");
		keyList.add("IF.BUYCDT");
		keyList.add("IF.BUYLMO");
		
		String sql = sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList);
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		keyList2.add("IF.WAREKY");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.SEBELN");
		keyList2.add("IF.DLVDAT");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.PTNRKY");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("IF.WAREKY", "IF.WARETG");
		changeMap2.put("IF.SEBELN", "IF.SVBELN");
		changeMap2.put("IF.DLVDAT", "IF.OTRQDT");
		changeMap2.put("IF.PTNRKY", "IF.WAREKY");
		
		String sql2 = sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2);
		
		
		if(GBN.equals("1")){
			map.put("RANGE_SQL", sql);
		}else if(GBN.equals("2")){
			map.put("RANGE_SQL2", sql2);
		}
		
		//  System.out.println(map.toString());

		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR20(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> hlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String rsebeln = "";
		DataMap itemTemp = map.getMap("tempItem");
		StringBuffer keys = new StringBuffer();
		
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			rsebeln = itemlist.get(0).getMap("map").getString("SEBELN");
		}
		
		try {
			int cnt = 0;
			for(int i=0;i<hlist.size();i++){
				DataMap head = hlist.get(i).getMap("map");   
				
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(rsebeln.equals(head.getString("SEBELN"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("SEBELN")) ){
					list = itemTemp.getList(head.getString("SEBELN"));
				}
				
				if(list.size() == 0){
					head.setModuleCommand("SajoInbound", "GR20_TAB1_ITEM");
					list = commonDao.getList(head);
				}
				
				for(int j=0;j<list.size();j++){
					DataMap row = list.get(j).getMap("map");
					map.clonSessionData(row);
					
					row.setModuleCommand("SajoInbound", "POCLOSING_VALIDATE");
					
					DataMap validMsg = commonDao.getMap(row);
					
					if(!validMsg.get("RESULTMSG").equals("0")){
						String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0090",new String[]{row.getString("SEBELN")});
						throw new Exception("*"+ msg + "*");
					}
					
					row.setModuleCommand("SajoInbound", "POCLOSING");
					commonDao.update(row);
					cnt++;
					
					if("".equals(keys.toString())){
						keys.append("'").append(head.getString("SEBELN")).append(row.getString("SEBELP")).append("'");
					}else{
						keys.append(",'").append(head.getString("SEBELN")).append(row.getString("SEBELP")).append("'");
					}
				}
				
				
			}
			rsMap.put("SAVEKEY", keys);
			rsMap.put("CNT",cnt);
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		return rsMap;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public List displayGR21Item(DataMap map) throws Exception {
		
		String GBN = map.getString("GBN");
		map.setModuleCommand("SajoInbound", "GR21_TAB"+GBN+"_ITEM");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList = new ArrayList<>();
		
		keyList.add("IF.OWNRKY");
		keyList.add("IF.WAREKY");
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.SEBELN");
		keyList.add("IF.DLVDAT");
		keyList.add("IF.SKUKEY");
		keyList.add("IF.DESC01");
		keyList.add("IF.PTNRKY");
		keyList.add("IF.BUYCDT");
		keyList.add("IF.BUYLMO");
		
		String sql = sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList);
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		keyList2.add("IF.WAREKY");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.SEBELN");
		keyList2.add("IF.DLVDAT");
		keyList2.add("IF.SKUKEY");
		keyList2.add("IF.PTNRKY");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("IF.WAREKY", "IF.WARETG");
		changeMap2.put("IF.SEBELN", "IF.SVBELN");
		changeMap2.put("IF.DLVDAT", "IF.OTRQDT");
		changeMap2.put("IF.PTNRKY", "IF.WAREKY");
		
		String sql2 = sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2);
		
		
		if(GBN.equals("1")){
			map.put("RANGE_SQL", sql);
		}else if(GBN.equals("2")){
			map.put("RANGE_SQL2", sql2);
		}
		
		//  System.out.println(map.toString());

		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR21(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> itemlist = map.getList("list");
		
		try {
			int cnt = 0;
				
			for(int j=0;j<itemlist.size();j++){
				DataMap row = itemlist.get(j).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("SajoInbound", "POCLOSING_VALIDATE");
				
				DataMap validMsg = commonDao.getMap(row);
				
				if(!validMsg.get("RESULTMSG").equals("0")){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0090",new String[]{row.getString("SEBELN")});
					throw new Exception("*"+ msg + "*");
				}
				
				row.setModuleCommand("SajoInbound", "POCLOSING");
				commonDao.insert(row);
				cnt++;
			}
			
			rsMap.put("CNT",cnt);
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		return rsMap;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR61(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> itemlist = map.getList("list");
		
		try {
			int cnt = 0;
				
			for(int j=0;j<itemlist.size();j++){
				DataMap row = itemlist.get(j).getMap("map");
				map.clonSessionData(row);
				row.put("ERRNUM","");
				row.put("ERRMSG","");
				
				
				row.setModuleCommand("SajoInbound", "CANCEL_FACRECEIPT");
				commonDao.update(row);
				
//				if(!row.getString("ERRNUM").equals("1000")){
//					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "생산입고 취소 처리에 실패 하였습니다.",new String[]{""});
//					throw new Exception("*"+ msg + "*");
//				}
				
				cnt++;
			}
			
			rsMap.put("CNT",cnt);
			
		} catch (Exception e) {
			throw new Exception( "*생산입고 취소 처리에 실패 하였습니다.*" );
		}
		
		return rsMap;
	}
	
	
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@Transactional(rollbackFor = Exception.class)
	public List displayPT01Choose(DataMap map) throws Exception {
		List<DataMap> retrunlist = new ArrayList<DataMap>();
		List<DataMap> list = map.getList("list");
		List<DataMap> dummyList = map.getList("list");
		String choosetype = map.getString("choosetype");
		int qttaor = 0;
		
		if(choosetype.equals("1")){
			for(int i=0;i<list.size();i++){
				retrunlist.add(list.get(i).getMap("map"));
			}
		}else if(choosetype.equals("2")){
			//제품을 합친다 "lotnum", "ownrky", "skukey", "locasr", "sectsr", "paidsr", "trnusr", "struty", "smeaky", "suomky", "sduoky" 조건 
			
			DataMap dupMap = new DataMap();
			DataMap dupMap2 = new DataMap();
			StringBuffer stokkys = new StringBuffer();
			for(int i=0;i<list.size();i++){
				DataMap sumMap = (DataMap)list.get(i).getMap("map").clone();
				qttaor = 0;
				String key = sumMap.getString("LOTNUM") + sumMap.getString("LOTNUM")+sumMap.getString("OWNRKY")+sumMap.getString("SKUKEY")+sumMap.getString("LOCASR")+sumMap.getString("PAIDSR")+sumMap.getString("TRNUSR")+sumMap.getString("STRUTY")
						     + sumMap.getString("SMEAKY") + sumMap.getString("SUOMKY") +sumMap.getString("SDUOKY");
				
				for(int j=0;j<dummyList.size();j++){
					DataMap dummy = dummyList.get(j).getMap("map");
					
					String key2 = dummy.getString("LOTNUM") + dummy.getString("LOTNUM")+dummy.getString("OWNRKY")+dummy.getString("SKUKEY")+dummy.getString("LOCASR")+dummy.getString("PAIDSR")+dummy.getString("TRNUSR")+dummy.getString("STRUTY")
							     + dummy.getString("SMEAKY") + dummy.getString("SUOMKY") +dummy.getString("SDUOKY");
					//제품을 합친다 "lotnum", "ownrky", "skukey", "locasr", "sectsr", "paidsr", "trnusr", "struty", "smeaky", "suomky", "sduoky" 조건  GRowNum이 중복이 아닐시 
					if(key.equals(key2) && !dupMap.containsKey(dummy.getInt("GRowNum"))){
						
						qttaor = qttaor + dummy.getInt("QTTAOR");
						dupMap.put(dummy.getInt("GRowNum"), qttaor);
						
						if(j == 0){
							stokkys.append(" SELECT '").append(dummy.getString("STOKKY")).append("' AS STOKKY FROM DUAL ");
						}else{
							stokkys.append(" UNION ALL SELECT '").append(dummy.getString("STOKKY")).append("' AS STOKKY FROM DUAL ");
						}
						
					}
				}
				
				if(!dupMap2.containsKey(key)){
					sumMap.put("QTTAOR", qttaor);
					sumMap.put("QTYUOM", qttaor);
					sumMap.put("AVAILABLEQTYUOM", qttaor);
					sumMap.put("AVAILABLEQTY", qttaor);
					sumMap.put("STOKKY", " ");
					sumMap.put("REFDKY", " ");
					sumMap.put("REFDIT", " ");
					sumMap.put("REFCAT", " ");
					sumMap.put("REFDAT", " ");
					sumMap.put("PURCKY", " ");
					sumMap.put("PURCIT", " ");
					sumMap.put("ASNDKY", " ");
					sumMap.put("ASNDIT", " ");
					sumMap.put("RECVKY", " ");
					sumMap.put("RECVIT", " ");
					sumMap.put("SHPOKY", " ");
					sumMap.put("SHPOIT", " ");
					sumMap.put("GRPOKY", " ");
					sumMap.put("GRPOIT", " ");
					sumMap.put("SADJKY", " ");
					sumMap.put("SADJIT", " ");
					sumMap.put("SDIFKY", " ");
					sumMap.put("SDIFIT", " ");
					sumMap.put("PHYIKY", " ");
					sumMap.put("PHYIIT", " ");
					sumMap.put("SEBELP", " ");
					sumMap.put("SZMBLNO", " ");
					sumMap.put("SZMIPNO", " ");
					sumMap.put("STRAID", " ");
					sumMap.put("SVBELN", " ");
					sumMap.put("SPOSNR", " ");
					sumMap.put("STKNUM", " ");
					sumMap.put("STPNUM", " ");
					sumMap.put("SWERKS", " ");
					sumMap.put("SLGORT", " ");
					sumMap.put("SDATBG", " ");
					sumMap.put("STDLNR", " ");
					sumMap.put("SSORNU", " ");
					sumMap.put("SSORIT", " ");
					sumMap.put("SMBLNR", " ");
					sumMap.put("SZEILE", " ");
					sumMap.put("SMJAHR", " ");
					sumMap.put("SSTOKKYS", stokkys);
					retrunlist.add(sumMap);
					dupMap2.put(key, key);
					
					stokkys = new StringBuffer();
				}
				
			}
		}

		return retrunlist;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveCallback(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> headlist = map.getList("list");
		
		try {
			int cnt = 0;
				
			for(int j=0;j<headlist.size();j++){
				DataMap row = headlist.get(j).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("SajoInbound", "CALLBACK");
				commonDao.update(row);
				cnt++;
			}
			
			rsMap.put("CNT",cnt);
			
		} catch (Exception e) {
			throw new Exception( "*회수지시 처리에 실패 하였습니다.*" );
		}
		
		return rsMap;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR46Adjdh(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> headlist = map.getList("headlist");
		StringBuffer keys = new StringBuffer();
		
		try {
			int cnt = 0;
				
			for(int j=0;j<headlist.size();j++){
				DataMap row = headlist.get(j).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("SajoInbound", "P_CREATE_RETURNADJDH_DATA");
				commonDao.update(row);
				cnt++;
				
				if("".equals(keys.toString())){
					keys.append("'").append(row.getString("RECVKY")).append("'");
				}else{
					keys.append(",'").append(row.getString("RECVKY")).append("'");
				}
			}
			rsMap.put("SAVEKEY", keys);
			rsMap.put("CNT",cnt);
			
		} catch (Exception e) {
			throw new Exception( "*회수지시 처리에 실패 하였습니다.*" );
		}
		
		return rsMap;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR47disposal(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> headlist = map.getList("headlist");
		StringBuffer keys = new StringBuffer("입고문서번호 ");
		
		try {
			int cnt = 0;
			int ip14cnt = 0;	
			for(int j=0;j<headlist.size();j++){
				DataMap row = headlist.get(j).getMap("map");
				map.clonSessionData(row);
				
				String tempDate = row.getString("DOCDAT").substring(6,8);
				int limiDate = Integer.parseInt(tempDate);
				
				if(limiDate < 10){
					keys.append(row.getString("RECVKY")+", ");
					ip14cnt++;
					continue;
				}
				
				row.setModuleCommand("SajoInbound", "P_CREATE_PHYSICAL_DATA");
				commonDao.update(row);
				cnt++;
			}
			keys.append("는 IP14에서 폐기처리 바랍니다.");
			rsMap.put("SAVEKEY", keys);
			rsMap.put("CNT",cnt);
			rsMap.put("IP14CNT",ip14cnt);
			
		} catch (Exception e) {
			throw new Exception( "*회수지시 처리에 실패 하였습니다.*" );
		}
		
		return rsMap;
	}

	
	
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@Transactional(rollbackFor = Exception.class)
	public List autoPal(DataMap map) throws Exception {
		List<DataMap> list = map.getList("list");
		String choosetype = map.getString("choosetype");
		List<DataMap> sortList = new ArrayList<DataMap>();
		List<DataMap> rtnList = new ArrayList<DataMap>();
		
		List<DataMap> dummyList = new ArrayList<DataMap>(); //넘어온 list 와 비교를 위해 list를 복사한다
		dummyList.addAll(list);
		
		DataMap orgMap,sortMap,pltMap;
		String trgStokky = "";
		String trgLotnum = "";
		String trgSkukey = "";
		int num = 0;

		//먼저 LOTNUM, SKUKEY 별로 정리한다.
		DataMap dupMap = new DataMap();
		for(DataMap orgRow : list){
			orgMap = orgRow.getMap("map");
			trgLotnum = orgMap.getString("LOTNUM");
			trgSkukey = orgMap.getString("SKUKEY");

			for(DataMap sortRow : dummyList){
				sortMap = sortRow.getMap("map");
				
				//현재 작업중인 Stokky와 일치할경우에만 들어간다.
				if(sortMap.getString("LOTNUM").equals(trgLotnum) && sortMap.getString("SKUKEY").equals(trgSkukey) && !dupMap.containsKey(sortMap.getInt("GRowNum"))){
					sortList.add((DataMap)sortMap.clone());
					dupMap.put(sortMap.getInt("GRowNum"), sortMap.getInt("GRowNum"));
				}
			}
			
		}
		
		//정리한 데이터를 팔렛타이징 한다 
		for(DataMap sortRow : sortList){
			sortMap = sortRow.getMap("map");
			
			num++;
			//팔렛입수보다 큰지 체크
			int pliQty = sortMap.getInt("PLIQTY");
			int qttaor = sortMap.getInt("QTTAOR");
			if(qttaor > pliQty){
				//필요 팔렛 수량
				int usePltQty =  (int)Math.ceil((double)qttaor / (double)pliQty);
				
				//팔렛타이징이 필요하다면 for문을 돌리면서 팔렛타이징을 시행한다.
				for(int i=0; i<usePltQty; i++){
					pltMap = (DataMap)sortMap.clone();
					
					int taskQty=pliQty;
					
					if(qttaor < pliQty) taskQty = qttaor; 
					
					pltMap.put("QTTAOR", taskQty);
					pltMap.put("QTYUOM", taskQty);
					pltMap.put("NUM", num);
					
					qttaor -= pliQty;
					num++;
					rtnList.add(pltMap);
				}
			}else{
				pltMap = (DataMap)sortMap.clone();
				pltMap.put("QTTAOR", sortMap.getInt("QTTAOR"));
				pltMap.put("QTYUOM", sortMap.getInt("QTTAOR"));
				pltMap.put("NUM", num);
				rtnList.add(pltMap);
			}
		}
		
		return rtnList;
	}

	
	
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@Transactional(rollbackFor = Exception.class)
	public List saveTaskData(DataMap map) throws Exception, SQLException {
		List<DataMap> list = map.getList("list");
		List<DataMap> rtnlist = new ArrayList<DataMap>();
		List<DataMap> headList = map.getList("head");
		String taskky = "";
		int taskit = 10;
		
		//헤더 한줄이라 따로 생성
		for(DataMap head : headList){
			DataMap row = head.getMap("map");
			map.clonSessionData(row);
			//헤더생성
			taskky = taskDataService.createTasdh(row);
		}

		//아이템 생성 
		for(int i=0;i<list.size();i++){
			DataMap row = list.get(i).getMap("map");
			map.clonSessionData(row);
			
			//기반 데이터 세팅
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("TASKKY", taskky);
			row.put("TASKIT", taskit);
			row.put("STATIT","NEW");
			
//			row.put("LOCATG", row.get("LOCASR"));
			row.put("LOCAAC", row.get("LOCASR"));
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
			row.put("QTSTKC", 0);	
			row.put("TASKIR", "0001");
			

			//STOKKY가 없는 경우  "LOTNUM", "OWNRKY", "SKUKEY", "LOCASR", "SECTSR", "PAIDSR", "TRNUSR", "STRUTY", "SMEAKY", "SUOMKY", "SDUOKY" 조건으로 STKKY에서 STOKKY를 찾아온다.
			if(" ".equals(row.getString("STOKKY"))){ //summary 할경우 

				row.setModuleCommand("SajoInbound", "PT01_GET_STOKKY");    
				List<DataMap> stkkyList = commonDao.getList(row);
				
				//할당처럼 돌려준다
				int qttaorOrg = row.getInt("QTTAOR");
				for(DataMap stkky : stkkyList){
					int qtsiwh = stkky.getInt("QTSIWH");
					
					//루프탈출문 써야되나 대충함
					if(qtsiwh < qttaorOrg){
						
						row.put("STOKKY", stkky.getString("STOKKY"));
						row.put("QTTAOR", qtsiwh);
						row.put("QTSTKM", qtsiwh);
						row.put("TASKIT", taskit);
						
						//TASDI 생성 
						taskDataService.createTasdi(row);
						//TASDR 생성 
						taskit = taskDataService.createTasdr(row);
						qttaorOrg = qttaorOrg - qtsiwh;
					}else{
						row.put("STOKKY", stkky.getString("STOKKY"));
						row.put("QTTAOR", qttaorOrg);
						row.put("QTSTKM", qttaorOrg);
						row.put("TASKIT", taskit);
						
						//TASDI 생성 
						taskDataService.createTasdi(row);
						//TASDR 생성 
						taskit = taskDataService.createTasdr(row);
						break;
					}
				}
				
				
			}else{ //Summary 안할경우		
				
				//TASDI 생성 
				taskDataService.createTasdi(row);
				//TASDR 생성 
				taskit = taskDataService.createTasdr(row);
			}

		}

		DataMap rtnMap = new DataMap();
		rtnMap.put("TASKKY", taskky);
		rtnMap.setModuleCommand("SajoInbound", "PT01_SAVE_ITEM");    
		rtnlist = commonDao.getList(rtnMap);
		return rtnlist;
	}

	
	
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@Transactional(rollbackFor = Exception.class)
	public List saveTaskConfirm(DataMap map) throws Exception,SQLException {
		List<DataMap> list = map.getList("list");
		List<DataMap> rtnlist = new ArrayList<DataMap>();
	
		try{
		//아이템 생성 
		for(int i=0;i<list.size();i++){
			DataMap itemRow = list.get(i).getMap("map");
			map.clonSessionData(itemRow);
			int qttaor = itemRow.getInt("QTTAOR");
			int qtcomp = itemRow.getInt("QTCOMP");
			
			//피킹수량이 0인지 체크한다
			if(itemRow.getInt("QTTAOR") < 1) 
		        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005",new String[]{qtcomp+"", qttaor+""}));  
			
			//이미 컨펌되었는지 체크 
			if (!"00000000".equals(itemRow.getString("ACTCDT")) && !itemRow.getString("ACTCDT").isEmpty()) 
				  throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0009",new String[]{itemRow.getString("TASKKY"), itemRow.getString("TASKIT")}));  
			
			//완료체크 
			if (!"NEW".equals(itemRow.getString("STATIT")) && !"PPC".equals(itemRow.getString("STATIT"))) continue;

	        //TASDR 가져온다 (삭제하기 전에 미리 끌어온다)
			itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDR");   
	        DataMap tasdrMap = commonDao.getMap(itemRow); 
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
			itemRow.put("LOCAAC", itemRow.getString("LOCATG"));
			itemRow.put("QTYUOM", itemRow.getInt("QTTAOR"));
			itemRow.setModuleCommand("Outbound", "TASDI");        
	        commonDao.insert(itemRow);
	        
	        //TASDR 피킹완료 업데이트 
	        tasdrMap.put("QTSTKM", itemRow.getInt("QTTAOR"));
	        tasdrMap.put("QTSTKC", itemRow.getInt("QTCOMP"));
			tasdrMap.setModuleCommand("Outbound", "TASDR");       
	        commonDao.update(tasdrMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		DataMap rtnMap = new DataMap();
		rtnMap.put("TASKKY", list.get(0).getMap("map").getString("TASKKY"));
		rtnMap.setModuleCommand("SajoInbound", "PT01_SAVE_ITEM");    
		rtnlist = commonDao.getList(rtnMap);
		
		return rtnlist;
	}
	
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap savePT02(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		StringBuffer appendQuery = new StringBuffer();
		DataMap dMap = new DataMap();
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("TASKKY");
		}
		
		int count = 0;
		String recvky = "";
		try {
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				map.clonSessionData(head);
				
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(key.equals(head.getString("TASKKY"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("TASKKY")) ){
					list = itemTemp.getList(head.getString("TASKKY"));
				}
				
				if(list.size() == 0){
					//dMap = 해드 + 검색조건
					head.put("menuId",map.getString("menuId"));
					dMap = (DataMap)map.clone();
					dMap.putAll(head);
					dMap.setModuleCommand("SajoInbound", itemquery);
					list = commonDao.getList(dMap);
					
				}

				for(int j=0;j<list.size();j++){
					DataMap itemRow = list.get(j).getMap("map");
					map.clonSessionData(itemRow);
					int qttaor = itemRow.getInt("QTTAOR");
					int qtcomp = itemRow.getInt("QTCOMP");
					
					//피킹수량이 0인지 체크한다
					if(itemRow.getInt("QTTAOR") < 1) 
				        throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005",new String[]{qtcomp+"", qttaor+""}));  
					
					//이미 컨펌되었는지 체크 
					if (!"00000000".equals(itemRow.getString("ACTCDT")) && !itemRow.getString("ACTCDT").isEmpty()) 
						  throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0009",new String[]{itemRow.getString("TASKKY"), itemRow.getString("TASKIT")}));  
					
					//완료체크 
					if (!"NEW".equals(itemRow.getString("STATIT")) && !"PPC".equals(itemRow.getString("STATIT"))) continue;

			        //TASDR 가져온다 (삭제하기 전에 미리 끌어온다)
					itemRow.setModuleCommand("OutBoundPicking", "DL45_TASDR");   
			        DataMap tasdrMap = commonDao.getMap(itemRow); 
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
					itemRow.put("QTYUOM", itemRow.getInt("QTTAOR"));
					itemRow.put("LOCATG", itemRow.getInt("LOCAAC"));
					itemRow.setModuleCommand("Outbound", "TASDI");        
			        commonDao.insert(itemRow);
			        
			        //TASDR 피킹완료 업데이트 
			        tasdrMap.put("QTSTKM", itemRow.getInt("QTTAOR"));
			        tasdrMap.put("QTSTKC", itemRow.getInt("QTCOMP"));
					tasdrMap.setModuleCommand("Outbound", "TASDR");       
			        commonDao.update(tasdrMap);
			        
			        
			        
					appendQuery.append(" SELECT ").append("' ' AS ROWSEQ,");
					appendQuery.append("'").append(itemRow.getString("ROWCK")).append("' AS ROWCK,");
					appendQuery.append("'").append(itemRow.getString("TASKKY")).append("' AS TASKKY,");
					appendQuery.append("'").append(itemRow.getString("TASKIT")).append("' AS TASKIT,");
					appendQuery.append("").append(itemRow.getString("QTCOMP")).append(" AS QTCOMP,");
					appendQuery.append("'").append(itemRow.getString("LOCAAC")).append("' AS LOCAAC,");
					appendQuery.append("'").append(itemRow.getString("SECTAC")).append("' AS SECTAC,");
					appendQuery.append("'").append(itemRow.getString("PAIDAC")).append("' AS PAIDAC,");
					appendQuery.append("'").append(itemRow.getString("TRNUAC")).append("' AS TRNUAC,");
					appendQuery.append("'").append(itemRow.getString("RSNCOD")).append("' AS RSNCOD,");
					appendQuery.append("'").append(itemRow.getString("TASRSN")).append("' AS TASRSN,");
					appendQuery.append("'").append(itemRow.getString("ATRUTY")).append("' AS ATRUTY");
					
					appendQuery.append(" FROM DUAL ");
					
					if(i+1 == headlist.size() && j+1 == list.size()) {
						
					}else{
						appendQuery.append(" UNION ALL\n");
					}
					
					count++;
			        
				}
				
				if("".equals(keys.toString())){
					keys.append("'").append(head.getString("TASKKY")).append("'");
				}else{
					keys.append(",'").append(head.getString("TASKKY")).append("'");
				}
			}
			
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		rsMap.put("SAVEKEY", keys);
		rsMap.put("SUBSAVEKEY", appendQuery);
		
		return rsMap;
	}
	

	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveReturned(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		DataMap dMap = new DataMap();
		
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
				
				//  System.out.println(head);
				
				head.setModuleCommand("SajoInbound", "RECIVEKEY");
				recvky = commonDao.getMap(head).getString("KEY");
				head.put("RECVKY", recvky);
				
				head.setModuleCommand("SajoInbound", "RECDH");
				commonDao.insert(head);
				
				int recvit = 0;
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(key.equals(head.getString("KEY"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("KEY")) ){
					list = itemTemp.getList(head.getString("KEY"));
				}
				
				if(list.size() == 0){
					//dMap = 해드 + 검색조건
					head.put("menuId",map.getString("menuId"));
					dMap = (DataMap)map.clone();
					dMap.putAll(head);
					dMap.setModuleCommand("SajoInbound", itemquery);
					list = commonDao.getList(dMap);
					
				}
				
				for(int j=0;j<list.size();j++){
					DataMap row = list.get(j).getMap("map");
					map.clonSessionData(row);
					String rcptty = head.getString("RCPTTY");
					int qtyrcv = (row.getInt("QTYRCV"));
					if(!rcptty.equals("131") && !rcptty.equals("133") && !rcptty.equals("134") 
							&& !rcptty.equals("135") && !rcptty.equals("136") && !rcptty.equals("137") 
							&& !rcptty.equals("138") && !rcptty.equals("139") ){
						if(qtyrcv == 0){
							continue;
						}
					}
					
					if(rcptty.equals("131") || rcptty.equals("133") || rcptty.equals("134") 
							|| rcptty.equals("135") || rcptty.equals("136") || rcptty.equals("137") 
							|| rcptty.equals("138") || rcptty.equals("139") ){

						String rsncod = row.getString("RSNCOD");
						if(rsncod.trim().equals("") || rsncod.equals(" ")){
//							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0110",new String[]{row.getString("SVBELN")});
//							String msg = commonService.getMessageParam( map.getString("SES_LANGUAGE"), "IN_M0110" ,new String[]{} );
							String msg = commonService.getMessageParam("KO", "IN_M0110",new String[]{});
							throw new Exception("*"+ msg + "*");
						}

						//완료 여부 확인 
						row.setModuleCommand("SajoInbound", "GR30_VALID");
						DataMap compMap = commonDao.getMap(row);
						
						if(compMap.getInt("CNT") > 0 ){
							String msg = commonService.getMessageParam("KO", "TASK_M0009",new String[]{""+row.getString("SVBELN")});
							throw new Exception("*"+ msg + "*");
						}
					}
					

					if(!head.getString("RCPTTY").equals("166"))
						row.put("LOTA03", head.getString("DPTNKY"));
					
					if(head.getString("SHPOKYMV").length() == 10 && (head.getString("SHPOKYMV").substring(0, 1).equals("2") && (head.getString("RCPTTY")).equals("121") || head.getString("RCPTTY").equals("122") || head.getString("RCPTTY").equals("123") ) ) {
						DataMap param = new DataMap();
						
						param.put("PERHNO", head.getString("PERHNO") );
						param.put("RECNUM", head.getString("RECNUM") );
						param.put("CASTDT", head.getString("CASTDT") );
						param.put("CASTIM", head.getString("CASTIM") );
						param.put("CARNUM", head.getString("CARNUM") );
						param.put("SHPOKY", head.getString("SHPOKYMV"));
						param.put("SHPOIT", row.getString("SHPOIT"));
						
						map.clonSessionData(param);
						
						param.setModuleCommand("SajoInbound", "CARINFO");
						
						commonDao.update(param);
						
//						super.nativeExecuteUpdate("SHPDR.CARINFO_UPDATE", params);
					}
					
					recvit += 10;
					String snum = String.valueOf(recvit);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("RECVKY", recvky);
					row.put("RECVIT", inum);
					
					
					
					row.setModuleCommand("SajoInbound", "RECDI");
					commonDao.insert(row);
					
					count++;
					
				}
				
				if("".equals(keys.toString())){
					keys.append("'").append(recvky).append("'");
				}else{
					keys.append(",'").append(recvky).append("'");
				}
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		rsMap.put("SAVEKEY", keys);
		
		return rsMap;
	}
	
		
}