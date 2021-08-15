package project.wms.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
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
import project.common.util.ComU;
import project.http.po.POInterfaceManager;
import project.common.util.SqlUtil;

@Service
public class GoodReceiptService extends BaseService {
	
	static final Logger log = LogManager.getLogger(GoodReceiptService.class.getName());

	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	public POInterfaceManager poManager; 
	

	//GR42 출고반품명세서 인쇄
	@Transactional(rollbackFor = Exception.class)
	public DataMap printGR42(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		//운영 or 개발 여부를 확인한다.
		map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
		map.put("CMCDKY", "SERVINFO");
		String serverInfo = ((DataMap)commonDao.getList(map).get(0)).getString("VALUE_COL");
		
		try {
			for(int i =0 ; i < list.size() ;i++){
				DataMap row = list.get(i).getMap("map");
				
				//지시를 보낸다.
				String result = poManager.SAP_SD0340(row.getString("SVBELN"), map.getString("STATUS"));
				
				row.setModuleCommand("GoodReceipt", "GR42");
				commonDao.update(row);
				
				resultChk ++;
			}
			rsMap.put("CNT",resultChk);
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	
	//GR44 회송반품입고 회수지시  클릭  
	@Transactional(rollbackFor = Exception.class)
	public DataMap callbackGR44(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		
		List<DataMap> headList = map.getList("head");
		DataMap head = headList.get(0).getMap("map");
	
		for (DataMap recdh : headList) {
			// 그리드에서 보낸 맵은 반드시 getMap("map")할것
			recdh = recdh.getMap("map");
			
			recdh.setModuleCommand("GoodReceipt", "GR44_CALLBACK");
			commonDao.update(recdh);
		}			
		if(resultChk > 0){
			rsMap.put("RESULT", "OK");
		}
				
		return rsMap;
	}
	
	
	//GR44 회송반품입고 회수지시 후 저장 - 입고문서번호 생성
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveGR44(DataMap map) throws Exception {
		
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = map.getList("list"); //new ArrayList<DataMap>();
		
		String key = "";
		key = itemlist.get(0).getMap("map").getString("KEY");
		
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		DataMap dMap = new DataMap();
		
		DataMap itemTemp = map.getMap("tempItem");
//		if(!map.getList("list").isEmpty()){
//			itemlist = map.getList("list");
//			key = itemlist.get(0).getMap("map").getString("KEY");
//		}
//		
		int count = 0;
		String recvky = "";
		
		try {
			
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				DataMap validMap = headlist.get(i).getMap("map");
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
					dMap.setModuleCommand("GoodReceipt", itemquery);
					list = commonDao.getList(dMap);
					
				}
				
				for(int j=0;j<list.size();j++){
					DataMap row = list.get(j).getMap("map");
					map.clonSessionData(row);
					
					recvit += 10;
					String snum = String.valueOf(recvit);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("RECVKY", recvky);
					row.put("RECVIT", inum);
					
					//로케이션, 제품정보 유효성 체크
					row.setModuleCommand("GoodReceipt", "RECDI_VALDATION");
					if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
					
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
	
	
	//[GR44] 아이템조회 
	@Transactional(rollbackFor = Exception.class)
	public List displayGR44Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("GoodReceipt", "GR44_ITEM");
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	//[GR44] 저장 후 아이템 재조회 
	@Transactional(rollbackFor = Exception.class)
	public List returnGR44Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("GoodReceipt", "GR44_ITEM_2");
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	
		
	
}
	
	
	
			
	