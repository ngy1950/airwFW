package project.wms.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.CommonLabel;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.service.SystemMagService;
import project.common.util.SqlUtil;

@Service("daerimOutboundService")
public class DaerimOutboundService extends BaseService {
	
	static final Logger log = LogManager.getLogger(DaerimOutboundService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonLabel commonLabel;
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private ShipmentService shipmentService;
	
	//[DR01] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDR01(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData; // 헤더를 담는다.
		DataMap itemData; // 아이템을 담는다.

		for(DataMap head : headList){
			headData = head.getMap("map");
			//출고지시여부 체크&&할당여부체크  validateIfwms113ModifyCheckingDO validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전
			List<DataMap> validList = validIfwms113Status(headData);
			
			//수정가능 데이터가 없을 시 : * 변경 불가능한 데이터입니다.
			if(validList.size() < 1)
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M1000",new String[]{headData.getString("SVBELN"),headData.getString("SPOSNR")}));
	
			//출고지시가 안된 데이터가 있을 시 : * 출고지시가 되지 않은 데이터가 있습니다. {0} 
			for(DataMap valid : validList){
				if("N".equals(valid.getString("C00102"))) 
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_M0010",new String[]{headData.getString("SVBELN"),headData.getString("SPOSNR")}));	
			}
			
	
			//아이템 리스트 Loop
			for(DataMap item : itemList){
				itemData = item.getMap("map");

				//아이템이 없다면 (헤더만 보낸경우)
				if(!headData.getString("SVBELN").equals(itemData.getString("SVBELN"))) continue;
				
				//item그리드에서 wareky 변경 시 validation : 이고출고는 거점변경 불가
				if("266".equals(headData.getString("DOCUTY")) || "267".equals(headData.getString("DOCUTY"))){
					if(!itemData.getString("WAREKY").equals(headData.getString("WAREKY"))) 
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0012",new String[]{}));
				}
				
				//변경데이터에 사유코드가 없을 시 에러 
				//if(" ".equals(itemData.getString("C00103")))
				//	throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0013",new String[]{itemData.getString("C00103")}));
				
				//수정수량이 원주문수량보다 큰지 체크 
				if(itemData.getInt("QTYREQ") > itemData.getInt("QTYORG"))
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_QTYREQVALID2",new String[]{itemData.getString("QTYREQ"),itemData.getString("QTYORG")}));
				
				//ITEM 수정사항 저장
				map.clonSessionData(itemData);
				itemData.setModuleCommand("DaerimOutbound", "DR01_ITEM");
				commonDao.update(itemData);
			}

			//변경데이터에 사유코드가 없을 시 에러 아이템을 수정하지 않은 경우에만 사용한다 ( 거점변경시에만 사용)
			if(" ".equals(headData.getString("C00103")) && !headData.getString("WAREKYORG").equals(headData.getString("WAREKY"))){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0013",new String[]{headData.getString("C00103")}));
			}else{
				headData.put("WAREUP", "Y");
			}
			
			//HEAD 수정사항 저장 막을것
			map.clonSessionData(headData);
			headData.setModuleCommand("DaerimOutbound", "DR01_HEADER");
			commonDao.update(headData);
		}
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	//출고지시여부 체크&&할당여부체크  validateIfwms113ModifyCheckingDO validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전 (값만 가져온다 validation은 각 화면)
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> validIfwms113Status(DataMap map) throws SQLException {

		map.setModuleCommand("DaerimOutbound", "DR01_VALIDIFWMS113STATUS");
		return  commonDao.getList(map);
	}
	

	//[DR16] 그룹핑
	@Transactional(rollbackFor = Exception.class)
	public DataMap groupingDR16(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		int result = 0;
		
		//update용 rangeData 파싱
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IT.ORDDAT");
		keyList.add("IT.DOCUTY");
		keyList.add("IT.OTRQDT");
		keyList.add("IT.DIRSUP");
		keyList.add("IT.DIRDVY");
		keyList.add("BZ.PTNG01");
		keyList.add("BZ.PTNG02");
		keyList.add("BZ.PTNG03");
		keyList.add("BZ.NAME03");
		keyList.add("C.CARNUM");
		keyList.add("PK.PICGRP");
		keyList.add("SM.ASKU05");
		
		DataMap changeMap = new DataMap();
		changeMap.put("BZ.PTNG01", "B.PTNG01");
		changeMap.put("BZ.PTNG02", "B.PTNG02");
		changeMap.put("BZ.PTNG03", "B.PTNG03");
		changeMap.put("BZ.NAME03", "B2.NAME03");
		
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));
		
		//헤드리스트 LOOP
		for(DataMap row : headList){
			DataMap head = row.getMap("map");
			//그룹핑 번호 체번
			map.setModuleCommand("DaerimOutbound", "GET_PICKINGLIST_SEQ");
			String pickSeq = head.getString("WAREKY") + commonDao.getMap(map).getString("PICKSEQ");
			
			//update 값 세팅 range가 필요하므로 map에 다 세팅한다.
			map.put("TEXT03", pickSeq);
			map.put("PTNG08", head.getString("PTNG08"));
			map.put("WAREKY", head.getString("WAREKY"));
			
			map.setModuleCommand("DaerimOutbound", "DR16_TEXT03");
			result = commonDao.update(map);
			
			//업데이트 성공시에만 프로시저 가동
			if(result > 0 ){
				map.setModuleCommand("DaerimOutbound", "P_DR_PICKINGLIST_02");
				commonDao.update(map);
				result = 1;
			}else{
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_GRPERR",new String[]{head.getString("PTNG08")}));
			}
		}

		rsMap.put("REUSLT" , result);
		return rsMap;
	}

	//[DR16] 그룹핑 삭제
	@Transactional(rollbackFor = Exception.class)
	public DataMap deleteGrouping(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		int result = 0;
		
		//헤드리스트 LOOP
		for(DataMap row : headList){
			DataMap head = row.getMap("map");
			
			map.put("TEXT03", head.getString("TEXT03"));
			
			//그룹핑 삭제 
			map.setModuleCommand("DaerimOutbound", "DEL_GROUPING");
			result = commonDao.update(map);
			
			//삭제 실패시 
			if(result < 1 ){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_GRPDELERR",new String[]{head.getString("TEXT03")}));
			}else{
				result = 1;
			}
		}

		rsMap.put("REUSLT" , result);
		return rsMap;
	}
	
	//[DR19] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR19(DataMap map) throws SQLException,Exception {
		
		String result = "F";
		List<DataMap> list = map.getList("list");
		
		int count = 0;
		DataMap row;
		String rowState;
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
			map.clonSessionData(row);
			row.setModuleCommand("DaerimOutbound", "DR19");
			
			if("D".equals(rowState)){ //삭제
				count = commonDao.delete(row);
			}else if("C".equals(rowState) || "U".equals(rowState)){//insert, update Merge문으로 처리
				count = commonDao.update(row);
			}
		}
		
		if(count > 0) result = "S"; 
		
		return result;
	}
	
	//[DR20] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR20(DataMap map) throws SQLException,Exception {
		
		String result = "F";
		List<DataMap> list = map.getList("list");
		
		int count = 0;
		DataMap row;
		String rowState;
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
			map.clonSessionData(row);
			row.setModuleCommand("DaerimOutbound", "DR20");
			
			if("D".equals(rowState)){ //삭제
				count = commonDao.delete(row);
			}else if("C".equals(rowState) || "U".equals(rowState)){//insert, update Merge문으로 처리
				count = commonDao.update(row);
			}
		}
		
		if(count > 0) result = "S"; 
		
		return result;
	}

	
	//[DR31] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR31(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		List<DataMap> list = map.getList("head");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			row.setModuleCommand("DaerimOutbound", "P_BATCH_GI_COMPLET_103");

			commonDao.update(row);
		}
		
		result = "S"; 
		
		return result;
	}

	
	//[DR30] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR30(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		DataMap header = headList.get(0).getMap("map");
		int sposnr = 10;
		
		//오더체크 및 svbeln 체번
		header.put("OWNRKY", map.getString("OWNRKY"));
		header.put("WAREKY", map.getString("WARESR"));
		header.setModuleCommand("DaerimOutbound", "GET_MOVEWAREHOUSE_SEQ");
		String svbeln = commonDao.getMap(header).getString("SVBELN");
		
		if(null == svbeln || "".equals(svbeln)) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0943",new String[]{}));
		
		//아이템 저장 시작
		for(DataMap data : itemList){
			row = data.getMap("map");
			map.clonSessionData(row);
			
			//헤더에서 넣어야할 값 세팅
			row.put("SVBELN", svbeln);
			row.put("DOCUTY", header.getString("DOCUTY"));
			row.put("ORDDAT", header.getString("OTRQDT"));
			row.put("OTRQDT", header.getString("OTRQDT"));
			row.put("PTNRTO", header.getString("WARETG"));
			row.put("PTNROD", header.getString("WARETG"));
			row.put("OWNRKY", header.getString("OWNRKY"));
			row.put("WAREKY", header.getString("WAREKY"));
			row.put("WARESR", header.getString("WARESR"));
			row.put("WARETG", header.getString("WARETG"));
			row.put("REFDKY", row.getString("RECVKY"));
			row.put("REDKIT", row.getString("RECVIT"));
			row.put("SPOSNR", sposnr);
			
			//수량 계산 이고 수정 시 원수량에서 수정한 수량만큼을 뺀 값을 역이고 한다.
			int qtymod = row.getInt("QTYREQ") - row.getInt("QTYORG");
			row.put("QTYREQ", qtymod);
			row.put("QTYORG", qtymod);

			
			//ifwms113 생성 
			sposnr = shipmentService.createIFWMS113STO(row);
		}
		
		if(sposnr > 10) result = svbeln; 
		
		return result;
	}

	
	//[DR32] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR32(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		List<DataMap> headList = map.getList("head");
		List<DataMap> list = map.getList("item");
		DataMap head = headList.get(0).getMap("map");
		
		//아이템 저장 시작
		for(DataMap data : list){
			row = data.getMap("map");
			map.clonSessionData(row);
			row.put("OWNRKY", head.getString("OWNRKY"));
			row.put("WAREKY", head.getString("WAREKY"));
			row.put("PTNG08", head.getString("PTNG08"));
			row.setModuleCommand("DaerimOutbound", "P_BATCH_GI_COMPLET_SVBELN");

			commonDao.update(row);
		}
		
		result = "S"; 
		
		return result;
	}

	
	//[DR22] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR22(DataMap map) throws SQLException,Exception {
		String result = "F";

		map.setModuleCommand("DaerimOutbound", "P_DAILY_WMSSTK_DATE");
		commonDao.update(map);
		
		result = "S"; 
		
		return result;
	}
	
	//[DR25] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR25(DataMap map) throws SQLException,Exception {
		String result = "F";

		map.setModuleCommand("DaerimOutbound", "P_DAILY_WMSSTK2_DATE");
		commonDao.update(map);
		
		result = "S"; 
		
		return result;
	}
	
	//[DR16] 그룹핑
	@Transactional(rollbackFor = Exception.class)
	public List displayDR22(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("DaerimOutbound", "DR22");
		
		//Rangelot
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("SM.SKUKEY");
		keyList.add("SM.ASKU05");
		keyList.add("SM.SKUG02");
		keyList.add("SM.SKUG03");
		keyList.add("PK.PICGRP");
		keyList.add("SW.LOCARV");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
}