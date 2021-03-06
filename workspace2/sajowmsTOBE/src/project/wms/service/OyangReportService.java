package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;
import project.http.po.POInterfaceManager;

import java.net.URL;

@Service
public class OyangReportService extends BaseService {
	
	static final Logger log = LogManager.getLogger(OyangReportService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	public CommonService commonService;

	@Autowired
	public POInterfaceManager poManager;

	@Autowired
	private ShipmentService shipmentService;
	
	
	//[OY08] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY08(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		String TEXT03 = "";
					
		try {
			// 헤드 아이템 데이터 가져오기
			List<DataMap> ifwms113HeaderList = map.getList("head");
			List<DataMap> ifwms113ItemList = map.getList("item");
			DataMap paramMap = (DataMap)map.clone();
			//Em메세지
//			if(headList.size() < 1){
//				rsMap.put("RESULT", "Em");
//			}
			
			for(DataMap header : ifwms113HeaderList){
				header = header.getMap("map");
				
				if("".equals(TEXT03)){
					map.setModuleCommand("OyangReport", "GET_PICKINGLIST_SEQ");					
					TEXT03 = map.getString("WAREKY") + commonDao.getMap(map).getString("PICKSEQ");
				}
				map.put("OWNRKY", header.getString("OWNRKY"));
				map.put("SVBELN", header.getString("SVBELN"));
				map.put("TEXT03", header.getString("TEXT03"));
				
				if("266".equals(header.getString("DOCUTY"))){
					map.put("PTNRTY", "0004");
     			}else{
     				map.put("PTNRTY", "0001");
     			}
				
				if(header.getString("CARNUM") == "" || header.getString("CARNUM") == " "){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "SYSTEM_M1000",new String[]{""});
					throw new Exception("*"+msg+"*");
				}
				
				map.put("TEXT03", TEXT03);
				map.setModuleCommand("OyangReport", "OY08_GROUPING");
				resultChk = (int) commonDao.update(map);
				
//				if("".equals(TEXT03)){
//					map.setModuleCommand("OyangReport", "OY08_GROUPING");
//					resultChk = (int) commonDao.update(map);
//				}
				
			}	

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
				rsMap.put("TEXT03", TEXT03);
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	//[OY09] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY09(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		String TEXT03 = "";
					
		try {
			// 헤드 아이템 데이터 가져오기
			List<DataMap> ifwms113HeaderList = map.getList("head");
			List<DataMap> ifwms113ItemList = map.getList("item");
			
			//Em메세지
//			if(headList.size() < 1){
//				rsMap.put("RESULT", "Em");
//			}
			for(DataMap header : ifwms113HeaderList){
				header = header.getMap("map");
				 //key = s/o번호 + 피킹출력번호(wareky + pickseq)으로 출력됨 
				if("".equals(TEXT03)){
					map.setModuleCommand("OyangReport", "GET_PICKINGLIST_SEQ");					
					TEXT03 = map.getString("WAREKY") + commonDao.getMap(map).getString("PICKSEQ");
				}
				map.put("OWNRKY", header.getString("OWNRKY"));
				map.put("SVBELN", header.getString("SVBELN"));
				map.put("TEXT03", header.getString("TEXT03"));
				
				if("266".equals(header.getString("DOCUTY"))){
					map.put("PTNRTY", "0004");
     			}else{
     				map.put("PTNRTY", "0001");
     			}
				
				if(header.getString("CARNUM") == "" || header.getString("CARNUM") == " "){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "SYSTEM_M1000",new String[]{""});
					throw new Exception("*"+msg+"*");
				}
				
				map.put("TEXT03", TEXT03);
				map.setModuleCommand("OyangReport", "OY09_GROUPING");
				resultChk = (int) commonDao.update(map);
				
			}	

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
				rsMap.put("TEXT03", TEXT03);
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}

	//[OY17] 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY17(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		if (map.getString("PTNRTY").equals("0001")){ //매출처
			map.setModuleCommand("OyangReport", "OY17_ITEM_1");
		} else if (map.getString("PTNRTY").equals("0007")){ //납품처 
			map.setModuleCommand("OyangReport", "OY17_ITEM_2");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	
	//[OY17] 거래명세표 출력 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY17(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		String ownkry = map.getString("OWNRKY");
		String wareky = map.getString("WAREKY"); 
		String ptnrky = map.getString("PTNRKY");
		StringBuffer keys = new StringBuffer();
		
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		DataMap dMap = new DataMap();
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("N00105");
		}
		
		for(int i=0;i<headlist.size();i++){
			DataMap head = headlist.get(i).getMap("map");
			map.clonSessionData(head);
			
			List<DataMap> list = new ArrayList<DataMap>();
			
			if(key.equals(head.getString("N00105"))){
				list = itemlist;
			}else if(itemTemp.containsKey(head.getString("N00105")) ){
				list = itemTemp.getList(head.getString("N00105"));
			}
			
			if(list.size() == 0){
				//dMap = 해드 + 검색조건
				head.put("menuId",map.getString("menuId"));
				dMap = (DataMap)map.clone();
				dMap.putAll(head);
				if (map.getString("PTNRTY").equals("0001")){ //매출처
					dMap.setModuleCommand("OyangReport", "OY17_ITEM_1");
				} else if (map.getString("PTNRTY").equals("0007")){ //납품처 
					dMap.setModuleCommand("OyangReport", "OY17_ITEM_2");
				}
				list = commonDao.getList(dMap);
				
			}
			
			for (DataMap item : list) {
				// 그리드에서 보낸 맵은 반드시 getMap("map")할것
				item = item.getMap("map");
				
				if (item.getString("TEXT02").trim().equals("") || item.getString("TEXT02").trim().equals(" ") ) {
					
					item.put("OWNRKY", ownkry);
					item.put("WAREKY", wareky);
					item.put("PTNRKY", ptnrky);
					item.put("N00105", head.getString("N00105"));
					item.put("USERID", map.getString("USERID"));
					
					item.setModuleCommand("OyangReport", "TEXT02_USERID"); //작업자 ID를 TEXT02(거래명세표출력번호)에 INSERT
					resultChk = (int)commonDao.update(item);
					
					if(ptnrky.equals("0007")){ //납품처 
						map.setModuleCommand("OyangReport", "P_ORDER_GROUPING_PTNRTO_OY"); //TEXT02 에 거래명세표출력번호 INSERT
						resultChk = (int)commonDao.update(map);
						//log.debug("5555 ==> saveOY17");
						
					}else if(ptnrky.equals("0001")){ //매출처 
						map.setModuleCommand("OyangReport", "P_ORDER_GROUPING_PTNROD_OY"); //TEXT02 에 거래명세표출력번호 INSERT	
						resultChk = (int)commonDao.update(map);
						//log.debug("6666 ==> saveOY17");
					}
				}
				
				if("".equals(keys.toString())){
					keys.append("'").append(item.getString("PTNRKY")).append("'");
				}else{
					keys.append(",'").append(item.getString("PTNRKY")).append("'");
				}
					
				if(resultChk > 0){
					rsMap.put("RESULT", "OK");
				}
					
			}
			
		}
		
		rsMap.put("PTNRKYS",keys);
		
		
//		for (DataMap item : itemList) {
//			// 그리드에서 보낸 맵은 반드시 getMap("map")할것
//			item = item.getMap("map");
//			
//			if (item.getString("TEXT02").trim().equals("") || item.getString("TEXT02").trim().equals(" ") ) {
//				
//				item.put("OWNRKY", ownkry);
//				item.put("WAREKY", wareky);
//				item.put("PTNRKY", ptnrky);
//				item.put("N00105", head.getString("N00105"));
//				item.put("USERID", map.getString("USERID"));
//				
//				item.setModuleCommand("OyangReport", "TEXT02_USERID"); //작업자 ID를 TEXT02(거래명세표출력번호)에 INSERT
//				resultChk = (int)commonDao.update(item);
//				
//				if(ptnrky.equals("0007")){ //납품처 
//					map.setModuleCommand("OyangReport", "P_ORDER_GROUPING_PTNRTO_OY"); //TEXT02 에 거래명세표출력번호 INSERT
//					resultChk = (int)commonDao.update(map);
//					//log.debug("5555 ==> saveOY17");
//					
//				}else if(ptnrky.equals("0001")){ //매출처 
//					map.setModuleCommand("OyangReport", "P_ORDER_GROUPING_PTNROD_OY"); //TEXT02 에 거래명세표출력번호 INSERT	
//					resultChk = (int)commonDao.update(map);
//					//log.debug("6666 ==> saveOY17");
//				}
//			}
//				
//			if(resultChk > 0){
//				rsMap.put("RESULT", "OK");
//			}
//				
//		}
			return rsMap;
	}
	
	//[OY24] 헤더 조회
		@Transactional(rollbackFor = Exception.class)
		public List displayOY24(DataMap map) throws Exception {
			DataMap rsMap = new DataMap();
			
			map.setModuleCommand("OyangReport", "OY24_HEADER");
				
			//RANGE_SQL1
			SqlUtil sqlUtil = new SqlUtil();
			List keyList1 = new ArrayList<>();
			keyList1.add("I.OWNRKY");
			keyList1.add("I.WAREKY");
			keyList1.add("I.ORDTYP");
			keyList1.add("I.SVBELN");
			keyList1.add("I.DOCUTY");
			keyList1.add("I.OTRQDT");
			keyList1.add("I.WARESR");
			keyList1.add("I.PTNRTO");
			keyList1.add("I.PTNROD");
			keyList1.add("I.SKUKEY");
			keyList1.add("I.DIRSUP");
			keyList1.add("S.SKUG03");
			keyList1.add("SM.ASKU05");
			keyList1.add("C.CARNUM");
			
			map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
			
			List<DataMap> list = commonDao.getList(map);

			return list;
		}
		
	//[OY24] 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY24Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("OyangReport", "OY24_ITEM");
			
		//RANGE_SQL2
		SqlUtil sqlUtil = new SqlUtil();
		List keyList2 = new ArrayList<>();
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		keyList2.add("I.ORDTYP");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.WARESR");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("S.SKUG03");
		keyList2.add("SM.ASKU05");
		keyList2.add("C.CARNUM");
		
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	
	//[OY25] 아이템 조회 RANGE OY25_1
	@Transactional(rollbackFor = Exception.class)
	public List displayOY25(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
				
		map.setModuleCommand("OyangReport", "OY25_1");
			
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList1 = new ArrayList<>();
		keyList1.add("I.OTRQDT");
		keyList1.add("I.WAREKY");
		keyList1.add("CM.CARNUM");
		keyList1.add("CM.DESC01");
		keyList1.add("SM.ASKU05");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	//[OY25] 아이템 조회 RANGE OY25_2
	@Transactional(rollbackFor = Exception.class)
	public List display2OY25(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
				
		map.setModuleCommand("OyangReport", "OY25_2");
			
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList1 = new ArrayList<>();
		keyList1.add("I.OTRQDT");
		keyList1.add("I.WAREKY");
		keyList1.add("CM.CARNUM");
		keyList1.add("CM.DESC01");
		keyList1.add("SM.ASKU05");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	//[OY25] 아이템 조회  RANGE OY25_3
	@Transactional(rollbackFor = Exception.class)
	public List display3OY25(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
				
		map.setModuleCommand("OyangReport", "OY25_3");
			
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList1 = new ArrayList<>();
		keyList1.add("I.OTRQDT");
		keyList1.add("I.WAREKY");
		keyList1.add("CM.CARNUM");
		keyList1.add("CM.DESC01");
		keyList1.add("SM.ASKU05");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	//[OY25] 아이템 조회  RANGE OY25_4
	@Transactional(rollbackFor = Exception.class)
	public List display4OY25(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
				
		map.setModuleCommand("OyangReport", "OY25_4");
			
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList1 = new ArrayList<>();
		keyList1.add("I.OTRQDT");
		keyList1.add("I.WAREKY");
		keyList1.add("CM.CARNUM");
		keyList1.add("CM.DESC01");
		keyList1.add("SM.ASKU05");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
		
	//[OY26] 헤더 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY26Head(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("OyangReport", "OY26_HEADER");
			
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		keyList.add("I.ORDTYP");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("SM.SKUG03");
		keyList.add("SM.ASKU05");
		keyList.add("C.CARNUM");
		keyList.add("I.N00105");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		//RANGE_SQL2
		List keyList2 = new ArrayList<>();
		keyList2.add("I.WAREKY");
		keyList2.add("I.OTRQDT");
		
		DataMap changeMap = new DataMap();
		changeMap.put("I.WAREKY", "WAREKY");
		changeMap.put("I.OTRQDT", "EXPDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap));	
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	//[OY26] 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY26Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("OyangReport", "OY26_ITEM");
		
		//RANGE_SQL1
		SqlUtil sqlUtil = new SqlUtil();
		List keyList1 = new ArrayList<>();
		keyList1.add("I.OWNRKY");
		keyList1.add("I.WAREKY");
		keyList1.add("I.ORDTYP");
		keyList1.add("I.SVBELN");
		keyList1.add("I.DOCUTY");
		keyList1.add("I.OTRQDT");
		keyList1.add("I.PTNRTO");
		keyList1.add("I.PTNROD");
		keyList1.add("I.SKUKEY");
		keyList1.add("I.DIRSUP");
		keyList1.add("I.DIRDVY");
		keyList1.add("SM.SKUG03");
		keyList1.add("SM.ASKU05");
		keyList1.add("C.CARNUM");
		keyList1.add("I.N00105");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		List<DataMap> list = commonDao.getList(map);
		return list;
	}
	
	
	//OY26 save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY26(DataMap map) throws Exception{
		DataMap rsMap = new DataMap();
		DataMap itemData; // 아이템을 담는다.
		int resultChk = 0;
		// List<DataMap> list = map.getList("list");
		HashMap<String, String> sqlParams = new HashMap<String, String>();
		
		try {
			List<DataMap> itemList = map.getList("item");
		
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				//validateIfwms113ModifyCheckingS
				itemData.setModuleCommand("OyangReport", "OY26_VALI");
				commonDao.getMap(itemData);
				
				if (itemData.getString("XSTAT").equals("D")) {
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
							new String[] { "" });
					throw new Exception("* IFWMS113 테이블의 S/O : [{0}][{1}] 번호는 현재 WMS 출고문서를 생성하여 수정할 수 없습니다. *");
				}
				
				if (itemData.getInt("QTYORG") < itemData.getInt("QTYREQ")) {

					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
							new String[] { "" });
					throw new Exception("* 원주문수량 [{0}] 납품요청수량[{1}]  원주문 수량을 초과할 수 없습니다. *");
				}
				
				itemData.setModuleCommand("OyangReport", "OY26");
				resultChk = (int) commonDao.update(itemData);
				
				if (resultChk > 0) {

					rsMap.put("RESULT", "S");
				}
			}
			rsMap.put("gridItemList", itemList);

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
		
	}
	
	
//	//OY26 save
//	@Transactional(rollbackFor = Exception.class)
//	public String saveOY26(DataMap map) throws Exception{
//	DataMap rsMap = new DataMap();
//	
//	List<DataMap> head = map.getList("head");
//    List<DataMap> item = map.getList("item");
//	DataMap itemTemp = map.getMap("tempItem"); //템프
//	
//	String skukey = "";
//	String result = "";
//	
//	//item 수정update
//	for(int i=0;i<item.size();i++){
//		
//		DataMap row = item.get(i).getMap("map");        
//		map.clonSessionData(row);
//		row.setModuleCommand("OyangReport", "SKUKEY");
//		
//		skukey = (String)row.get("SKUKEY");
//		
//		String itemSkukey = "";
//		if (item.size() > 0){
//			itemSkukey = item.get(0).getMap("map").getString("SKUKEY");
//		}
//		if (skukey.equals(itemSkukey)){
//		    //그리드에서 넘어온 Item List 저장
//			updateItem(map, row, item);
//			
//		} else {
//			//템프 사용
//			List<DataMap> itemByHead = itemTemp.getList(row.getString("SKUKEY"));
//			if(itemByHead == null){
//				row.setModuleCommand("Outbound", "OY26_ITEM");
//				itemByHead = commonDao.getList(row);
//			}
//			
//			updateItem(map, row, itemByHead);
//		  }
//		}
//		
//		result = "OK";
//		return result;
//	}
//	
//	//OY26
//	 private void updateItem(DataMap map, DataMap head, List<DataMap> items) throws Exception{
//		List<DataMap> itemList = map.getList("item");	
//		DataMap itemData;
//		String svbeln = (String)head.get("SVBELN");
//		String ownrky = (String)head.get("OWNRKY");
//		String wareky = (String)head.get("WAREKY");
//		String otrqdt = (String)head.get("OTRQDT");
//		String dirsup = (String)head.get("DIRSUP");
//		String skukey = (String)head.get("SKUKEY");
//		String sponsr = (String)head.get("SPOSNR");
//		String coo103 = (String)head.get("C00103");
//		String qtyreq = (String)head.get("QTYREQ");
//		 
//		//그리드에서 넘어온 Item List 저장
//        for(int i=0;i<items.size();i++){
////		 for (DataMap item : itemList) {
//        	DataMap row = items.get(i).getMap("map");
//			
//			//출고지시여부 체크&&할당여부체크  validateIfwms113ModifyCheckingS validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전
//			List<DataMap> validList = validIfwms113Status(row);
//			
//			//출고지시가 안된 데이터가 있을 시 : * 출고지시가 되지 않은 데이터가 있습니다. {0} 
//			for(DataMap valid : validList){
//				if("D".equals(valid.getString("IFFLG"))) 
//					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IFWMS_M0010",new String[]{row.getString("SVBELN"),row.getString("SPOSNR")}));	
//			}
//			//변경데이터에 사유코드가 없을 시 에러 
//			if (" ".equals(row.getString("C00103"))) {
//				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OYANG_C00103NVL",new String[]{row.getString("C00103")}));
//			}
//			//수정수량이 원주문수량보다 큰지 체크 
//			if(row.getInt("QTYREQ") > row.getInt("QTYORG")){
//				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OYANG_QTYREQVALID",new String[]{row.getString("QTYREQ"),row.getString("QTYORG")}));
//			}
//			//ITEM 수정사항 저장
//			map.clonSessionData(row);
//			row.setModuleCommand("OyangReport", "OY26");
//			commonDao.update(row);
//		}
//	 }
//
//	//출고지시여부 체크&&할당여부체크  validateIfwms113ModifyCheckingDO validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전 (값만 가져온다 validation은 각 화면)
//	@Transactional(rollbackFor = Exception.class)
//	public List<DataMap> validIfwms113Status(DataMap map) throws Exception {
//
//		map.setModuleCommand("OyangReport", "OY26_VALIDIFWMS113STATUS");
//		return commonDao.getList(map);
//	}
	
	//[OY10] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY10(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		String TEXT03 = "";
					
		try {
			// 헤드 아이템 데이터 가져오기
			List<DataMap> ifwms113HeaderList = map.getList("head");
			List<DataMap> ifwms113ItemList = map.getList("item");
			
			for(DataMap header : ifwms113HeaderList){
				header = header.getMap("map");
				
				if("".equals(TEXT03)){
					map.setModuleCommand("OyangReport", "GET_PICKINGLIST_SEQ");					
					TEXT03 = map.getString("WAREKY") + commonDao.getMap(map).getString("PICKSEQ");
				}
				
				map.put("OWNRKY", header.getString("OWNRKY"));
				map.put("SVBELN", header.getString("SVBELN"));
				map.put("TEXT03", header.getString("TEXT03"));
				if("266".equals(header.getString("DOCUTY"))){
					map.put("PTNRTY", "0004");
     			}else{
     				map.put("PTNRTY", "0001");
     			}
									
				if(header.getString("CARNUM") == "" || header.getString("CARNUM") == null){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "SYSTEM_M1000",new String[]{""});
					throw new Exception("*"+msg+"*");
					
				}
				map.put("TEXT03", TEXT03);

				map.setModuleCommand("OyangReport", "OY08_GROUPING");
				resultChk = (int) commonDao.update(map);
			}	

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
				rsMap.put("TEXT03", TEXT03);
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayOY11(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		if (map.getString("OPTYPE").equals("01")){
			map.setModuleCommand("OyangReport", "OY11_HEAD");
		} else if (map.getString("OPTYPE").equals("02")){
			map.setModuleCommand("OyangReport", "OY11_HEAD2");
		}
				
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayOY11Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		if (map.getString("OPTYPE").equals("01")){
			map.setModuleCommand("OyangReport", "OY11_ITEM"); 
		} else if (map.getString("OPTYPE").equals("02")){
			map.setModuleCommand("OyangReport", "OY11_ITEM2");
		}
				
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	//[OY11] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY11(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		String C00110 = "";
					
		try {
			// 헤드 아이템 데이터 가져오기
			List<DataMap> ifwms113HeaderList = map.getList("head");
			List<DataMap> ifwms113ItemList = map.getList("item");
			map.setModuleCommand("OyangReport", "OY11_PICKINGLIST_SEQ");					
			C00110 = commonDao.getMap(map).getString("PICKSEQ");

			
			for(DataMap header : ifwms113HeaderList){
				header = header.getMap("map");
				
				map.put("C00110", C00110);
				map.put("SVBELN", header.getString("SVBELN"));
				map.put("SPOSNR", header.getString("SPOSNR"));

				map.setModuleCommand("OyangReport", "OY11");
				resultChk = (int) commonDao.update(map);
				
			}	

			map.setModuleCommand("OyangReport", "P_INSERT_YANGSANBARCODE");
			commonDao.update(map);

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
				rsMap.put("C00110", C00110);
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	
	//[OY12] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY12(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		String key = "";
					
		try {
			// 헤드 아이템 데이터 가져오기
			List<DataMap> ifwms113HeaderList = map.getList("head");
			List<DataMap> ifwms113ItemList = map.getList("item");

			
			for(DataMap header : ifwms113HeaderList){
				header = header.getMap("map");
				
				header.setModuleCommand("OyangReport", "GET_SHPDOC_SEQ");					
				key = commonDao.getMap(header).getString("DOCSEQ");
				
				map.put("TEXT02", key);
				map.put("SVBELN", header.getString("SVBELN"));

				map.setModuleCommand("OyangReport", "OY12");
				resultChk = (int) commonDao.update(map);

			}	

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	//[OY12_ASN] POPUP 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY12_ASN(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("OyangReport", "OY12_ANS");
				
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	//[OY12_ASN] POPUPsave
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY12_ASN(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		try {
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					//그리드 로우의 값을 한줄씩 불러온다.
					DataMap row = list.get(i).getMap("map");
					//세션의 값을 로우에 세팅한다.
					map.clonSessionData(row);
					
					row.setModuleCommand("OyangReport", "OY12_ANSSAVE");
					resultChk = (int) commonDao.update(row);
				
				}
			}
			
			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
			}
			
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}

}
