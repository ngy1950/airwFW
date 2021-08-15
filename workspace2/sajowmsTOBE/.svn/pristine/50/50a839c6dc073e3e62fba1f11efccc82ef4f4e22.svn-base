package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;


import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

import java.net.URL;

@Service
public class DaerimService extends BaseService {
	
	static final Logger log = LogManager.getLogger(DaerimService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	//[DR03] 헤드 1 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDR03(DataMap map) throws Exception {

		map.setModuleCommand("Daerim", "DR03_HEAD");
		
		SqlUtil sqlUtil = new SqlUtil();

		List keyList2 = new ArrayList<>();
		keyList2.add("IT.WAREKY");
		keyList2.add("IT.OTRQDT");
		keyList2.add("IT.DIRSUP");
		keyList2.add("BZ2.PTNG08");
		keyList2.add("SM.SKUKEY");
		keyList2.add("SM.ASKU05");
		keyList2.add("SM.SKUG03");
		keyList2.add("PK.PICGRP");
		keyList2.add("SW.LOCARV");
		keyList2.add("IT.DIRDVY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	//[DR03] 헤드 2 조회
	@Transactional(rollbackFor = Exception.class)
	public List display2DR03(DataMap map) throws Exception {
		
		//map.setModuleCommand("Daerim", "DR03_HEAD2");
		if (map.getString("SES_USER_ID").equals("SJ220361")) {
			map.setModuleCommand("Daerim", "DR03_HEAD2_SJ");
		} else {
			map.setModuleCommand("Daerim", "DR03_HEAD2");
		}
		//SJ220361
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList2 = new ArrayList<>();
		keyList2.add("IT.WAREKY");
		keyList2.add("IT.OTRQDT");
		keyList2.add("IT.DIRSUP");
		keyList2.add("BZ2.PTNG08");
		keyList2.add("SM.SKUKEY");
		keyList2.add("SM.ASKU05");
		keyList2.add("SM.SKUG03");
		keyList2.add("PK.PICGRP");
		keyList2.add("SW.LOCARV");
		keyList2.add("IT.DIRDVY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	//[DR03] 헤드 3 조회
	@Transactional(rollbackFor = Exception.class)
	public List display3DR03(DataMap map) throws Exception {
		
		map.setModuleCommand("Daerim", "DR03_HEAD3");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList2 = new ArrayList<>();
		keyList2.add("IT.WAREKY");
		keyList2.add("IT.OTRQDT");
		keyList2.add("IT.DIRSUP");
		keyList2.add("BZ2.PTNG08");
		keyList2.add("SM.SKUKEY");
		keyList2.add("SM.ASKU05");
		keyList2.add("SM.SKUG03");
		keyList2.add("PK.PICGRP");
		keyList2.add("SW.LOCARV");
		keyList2.add("IT.DIRDVY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	//[DR03] 아이템조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDR03Item(DataMap map) throws Exception {
		
		map.setModuleCommand("Daerim", "DR03_ITEM");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList2 = new ArrayList<>();
		keyList2.add("IT.WAREKY");
		keyList2.add("IT.OTRQDT");
		keyList2.add("IT.DIRSUP");
		keyList2.add("BZ2.PTNG08");
		keyList2.add("SM.SKUKEY");
		keyList2.add("SM.ASKU05");
		keyList2.add("SM.SKUG03");
		keyList2.add("PK.PICGRP");
		keyList2.add("SW.LOCARV");
		keyList2.add("IT.DIRDVY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	
	//DR06 그룹핑
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDR06(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head"); 
		int resultChk = 0;
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.WAREKY");
		keyList.add("B2.NAME03");
		keyList.add("I.DOCUTY");
		keyList.add("I.ORDDAT");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.OWNRKY");
		keyList.add("C.CARNUM");
		keyList.add("SM.ASKU05");
		keyList.add("B.PTNG01");
		keyList.add("B.PTNG02");
		keyList.add("B.PTNG03");
		keyList.add("SM.SKUG03");
		keyList.add("SW.LOCARV");
		keyList.add("PK.PICGRP");
		keyList.add("B2.PTNG08");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

			
		try {
			StringBuffer sb = new StringBuffer();
			
			for(DataMap header : headList){
				header = header.getMap("map");
				
				map.setModuleCommand("Daerim", "GET_PICKINGLIST_SEQ");
				String text03 = header.getString("WAREKY") + commonDao.getMap(map).getString("PICKSEQ");
				
				
				if(sb.toString().length()<1){
     				sb.append("AND (").append("( I.SVBELN = '").append( header.getString("SVBELN")).append("')");
     			}else{
     				sb.append("OR ( I.SVBELN = '").append( header.getString("SVBELN")).append("')");
     			}
				
				if(!" ".equals(header.getString("TEXT03"))){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
					throw new Exception("* 이미 그룹핑 되어 있습니다. *");
				}
				if(header.getString("CARNUM") == "" || header.getString("CARNUM") == null){
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
					throw new Exception("* 차량번호(코스)가 없는 데이터가 있습니다. *");
					
				}
				map.put("TEXT03", text03);
			}	
			sb.append(")");
			map.put("appendQuery", sb.toString());
			
			map.setModuleCommand("Daerim", "DR06_GROUPING");
			resultChk = (int) commonDao.update(map);

			map.setModuleCommand("Daerim", "P_DR_PICKINGLIST_01");
			commonDao.update(map);

			if(resultChk > 0){
				rsMap.put("RESULT", "OK");
			}
				
		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	
	//DR06 그룹핑삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap delGroupDR06(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		try {
			// 피킹그룹키
			String grpoky = "";	
			
			
			List<DataMap> headList = map.getList("head"); 
			List<DataMap> itemList = map.getList("item");
			DataMap dMap = new DataMap();
			
			for(DataMap tasdh : headList){
				///그리드에서 보낸 맵은 반드시 getMap("map")할것
				tasdh = tasdh.getMap("map");
				String wareky = map.getString("SES_WAREKY");
				tasdh.put("SES_WAREKY", wareky);
				
				//아이템 조회  구버전 /신버전 큰 차이
				dMap = (DataMap)map.clone();
				dMap.putAll(tasdh);
				dMap.setModuleCommand("Daerim", "DR06_ITEM");
				itemList = commonDao.getList(dMap);
			
				for (DataMap item:itemList) {
					if(item.getString("TEXT03").trim().equals("") || item.getString("TEXT03").isEmpty()){
						continue;
						}
					item.setModuleCommand("Daerim", "DR06_DELGROUP");
					resultChk = (int)commonDao.update(item);
					
					if(resultChk > 0){
						rsMap.put("RESULT", "DEL");
					}
				}
							
					
			}

		}catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	// [DR09] SAVE
		@Transactional(rollbackFor = Exception.class)
		public DataMap saveDR09(DataMap map) throws Exception {
			DataMap rsMap = new DataMap();
			int resultChk = 0;

			try {

				// 헤드 아이템 데이터 가져오
				List<DataMap> headList = map.getList("head");
				List<DataMap> itemList = map.getList("item");
				List<DataMap> shpdhUpBatchList = new ArrayList<DataMap>();

				String key = ""; // 거래처+문서유형+배송유형+납품요청일 : KEY, 시퀀스: VALUE  → 주문서별로 수정(20170609)
				
				for (DataMap header : headList) {
					int grpoit = 0;
					/// 그리드에서 보낸 맵은 반드시 getMap("map")할것
					header = header.getMap("map");

					if (header.getString("TEXT02").trim().equals("") || header.getString("TEXT02") == null) {

						header.setModuleCommand("Daerim", "GET_SHPDOC_SEQ");
						key = commonDao.getMap(header).getString("DOCSEQ");
						
						DataMap sqlParams = new DataMap();
						sqlParams.put("SVBELN", header.getString("SVBELN"));
						sqlParams.put("TEXT02", key);
						shpdhUpBatchList.add(sqlParams);
					}
					
					if(shpdhUpBatchList.size() > 0){
						for (DataMap update : shpdhUpBatchList) {
							update.setModuleCommand("Daerim", "DR09_GROUPING");
							resultChk = (int) commonDao.update(update);
						
							if(resultChk > 0){
								rsMap.put("RESULT", "OK");
							}
						}
					}	
				}

			} catch (Exception e) {
				throw new Exception(ComU.getLastMsg(e.getMessage()));
			}
			return rsMap;
		}
	
}