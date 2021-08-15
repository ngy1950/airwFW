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
public class ConsignOutboundService extends BaseService {
	
	static final Logger log = LogManager.getLogger(ConsignOutboundService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	public CommonService commonService;

	@Autowired
	private ShipmentService shipmentService;

	@Autowired
	private RecieptService recieptService; 

	@Autowired
	private AdjustmentService adjustmentService;

	@Autowired
	private TaskDataService taskService;


	//[OD01] 저장 
	@Transactional(rollbackFor = Exception.class)
	public String saveOD01(DataMap map) throws SQLException,Exception {
		String result = "F";
		DataMap row;
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		DataMap header = headList.get(0).getMap("map");
		int sposnr = 10;
		
		//오더체크 및 svbeln 체번
		header.put("WAREKY", header.getString("WARESR"));
		header.setModuleCommand("ConsignOutbound", "OD01_CONSIGN_SEQ");
		String svbeln = commonDao.getMap(header).getString("DOCSEQ");
		
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
			row.put("QTYREQ", row.getInt("QTYORG"));
			row.put("USRID1", map.getString(CommonConfig.SES_USER_ID_KEY));
			row.put("SPOSNR", sposnr);

			
			//ifwms113 생성 
			sposnr = shipmentService.createIFWMS113STO(row);
		}
		
		if(sposnr > 10) result = svbeln; 
		
		return result;
	}


	//[OD02] 저장 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOD02(DataMap map) throws SQLException,Exception {
		String result = "F";
		String recvky;
		int recvit = 10;
		DataMap headRow, itemRow, rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		StringBuffer rtnString = new StringBuffer();
		

		//헤더 LOOP
		for(DataMap head : headList){
			headRow = head.getMap("map");
			List<DataMap> saveItemList = null;
			map.clonSessionData(headRow);
			
			headRow.put("RCPTTY", map.getString("RCPTTY"));
			//헤더저장 
			recvky = recieptService.createRecdh(headRow);
			
			if(itemList.size() > 0 && headRow.getString("SHPOKY").equals(itemList.get(0).getMap("map").getString("SHPOKY"))){//ITEM은 조회중인 것만 보낼 수 있으므로 이고출고번호가 일차하는것만 체크
				//입력한 아이템으로 저장
				saveItemList = itemList;
			}else{
				//조회하여 저장
				headRow.setModuleCommand("ConsignOutbound", "OD02_ITEM");
				saveItemList = commonDao.getList(headRow);
			}
			
			//아이템 생성을 위한 loop
			for(DataMap item : saveItemList){
				itemRow = item.getMap("map");
				map.clonSessionData(itemRow);

				//아이템저장 
				itemRow.put("OWNRKY", map.getString("OWNRKY"));
				itemRow.put("WAREKY", map.getString("WAREKY"));
				itemRow.put("RECVKY", recvky);
				itemRow.put("RECVIT", recvit);
				itemRow.put("LOTA07", "21SV");
				itemRow.put("LOTA08", "OD");
				recvit = recieptService.createRecdi(itemRow);
				
			}
			
			//재배차 업데이트
			headRow.setModuleCommand("ConsignOutbound", "OD02_SHPDR");
			commonDao.update(headRow);

			if("".equals(rtnString.toString())){
				rtnString.append("'").append(headRow.getString("SHPOKY")).append("'");
			}else{
				rtnString.append(",'").append(headRow.getString("SHPOKY")).append("'");
			}
		}


		rtnMap.put("RESULT", "Y");
		rtnMap.put("SHPOKYS", rtnString.toString());
		
		return rtnMap;
	}


	//[OD03] 저장 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOD03(DataMap map) throws SQLException,Exception {
		DataMap headRow, itemRow, rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		
		
		//헤더 LOOP
		for(DataMap head : headList){
			headRow = head.getMap("map");
			List<DataMap> saveItemList = null;
			map.clonSessionData(headRow);
			
			if(itemList.size() > 0 && headRow.getString("RECVKY").equals(itemList.get(0).getMap("map").getString("RECVKY"))){//ITEM은 조회중인 것만 보낼 수 있으므로 이고출고번호가 일차하는것만 체크
				//입력한 아이템으로 저장
				saveItemList = itemList;
			}else{
				//조회하여 저장
				headRow.setModuleCommand("ConsignOutbound", "OD03_ITEM");
				saveItemList = commonDao.getList(headRow);
			}
			
			//아이템 처리를 위한 loop
			for(DataMap item : saveItemList){
				itemRow = item.getMap("map");
				map.clonSessionData(itemRow);

				//취소 프로시저 호출 
				itemRow.setModuleCommand("ConsignOutbound", "P_CANCEL_CONRECEIPT");
				commonDao.update(itemRow);
			}
		}
		
		rtnMap.put("RESULT", "Y");
		
		return rtnMap;
	
	}


	//[OD06] 저장 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOD06(DataMap map) throws SQLException,Exception {
		DataMap headRow, itemRow = new DataMap(), rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		String sadjky = "";
		int sadjit = 10;
		int itemCnt = 0;
		
		//헤더 LOOP
		for(DataMap head : headList){
			headRow = head.getMap("map");
			List<DataMap> saveItemList = null;
			map.clonSessionData(headRow);
			
			headRow.put("OWNRKY", map.getString("OWNRKY"));
			headRow.put("WAREKY", map.getString("WAREKY"));
			//ADJDH 생성
			sadjky = adjustmentService.createAdjdh(headRow);

			//아이템 처리를 위한 loop
			for(DataMap item : itemList){
				itemRow = item.getMap("map");
				map.clonSessionData(itemRow);
				itemCnt++;
				
				itemRow.put("SPOSNR", " ");
				itemRow.put("SADJKY", sadjky);
				itemRow.put("SADJIT", sadjit);
				//기존 대상 차감 	
				sadjit = adjustmentService.createAdjdiFromSTK(itemRow);
				
				//처리대상 생성
				itemRow.put("SADJIT", sadjit);
				itemRow.put("SPOSNR", sadjit);
				itemRow.put("LOTA07", " ");
				itemRow.put("LOTA08", " ");
				itemRow.put("STOKKY", " ");
				itemRow.put("LOTNUM", " ");
				sadjit = adjustmentService.createAdjdi(itemRow);
				
				//인터페이스 전송 603
				itemRow.setModuleCommand("IFWMS603", "IFWMS603");
				itemRow.put("WAREKY", headRow.getString("WAREKY"));
				itemRow.put("SHPOKY", headRow.getString("SADJKY"));
				itemRow.put("SEQNO", commonDao.getMap(itemRow).getString("SEQNO"));
				itemRow.put("SPOSNR", itemCnt);
				itemRow.put("QTSHPD", itemRow.getInt("QTADJU"));
				commonDao.insert(itemRow);
				
				//인터페이스 전송 623
				itemRow.setModuleCommand("IFWMS623", "IFWMS623");
				commonDao.insert(itemRow);
				
			}
			
			//SUBSFL업데이트 기존로직 계승
			itemRow.setModuleCommand("ConsignOutbound", "OD06_SUBSFL");
			commonDao.update(itemRow);
			
			
		}
		rtnMap.put("RESULT", "Y");
		rtnMap.put("SADJKY", sadjky);
		
		return rtnMap;
	}
	
	//[OD07 -> OY12 save 사용]	

	//[OD09] 저장 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOD09(DataMap map) throws SQLException,Exception {
		DataMap headRow, itemRow = new DataMap(), rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		String taskky = "";
		
		int taskit = 10;
		DataMap row = new DataMap();
		headRow = headList.get(0).getMap("map");
		map.clonSessionData(headRow);
		
		//헤더 생성(TASDH)
		taskky = taskService.createTasdh(headRow);
		
		for(DataMap item : itemList){
			row = item.getMap("map");
			map.clonSessionData(row);
			
			//기반 데이터 세팅
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("TASKKY", taskky);
			row.put("TASKIT", taskit);
			row.put("STATIT","FPC");
			
			row.put("QTCOMP", row.get("QTTAOR"));
			row.put("LOCAAC", row.get("LOCATG"));
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
			row.put("QTSTKC", row.get("QTSTKM"));	
			row.put("TASKIR", "0001");		
			
			//TASDI 생성 
			taskService.createTasdi(row);
			//TASDR 생성 
			taskit = taskService.createTasdr(row);
			
		}
		
		
		rtnMap.put("RESULT", "Y");
		rtnMap.put("TASKKY", taskky);
		
		return rtnMap;
	}


	//[OD10] 저장 
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOD10(DataMap map) throws SQLException,Exception {
		DataMap headRow, itemRow = new DataMap(), rtnMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		String taskky = "";
		
		int taskit = 10;
		DataMap row = new DataMap();
		headRow = headList.get(0).getMap("map");
		map.clonSessionData(headRow);
		
		//헤더 생성(TASDH)
		taskky = taskService.createTasdh(headRow);
		
		for(DataMap item : itemList){
			row = item.getMap("map");
			map.clonSessionData(row);
			
			//기반 데이터 세팅
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("TASKKY", taskky);
			row.put("TASKIT", taskit);
			row.put("STATIT","FPC");
			

			row.put("QTYUOM", row.get("QTTAOR"));
			row.put("QTCOMP", row.get("QTTAOR"));
			row.put("LOCAAC", row.get("LOCATG"));
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
			row.put("QTSTKC", row.get("QTSTKM"));	
			row.put("TASKIR", "0001");
			
			//lota 속성 변경
			row.put("PTLT01", " ");
			row.put("PTLT03", row.getString("LOTA03"));
			row.put("PTLT05", row.getString("LOTA05"));
			row.put("PTLT06", row.getString("LOTA06"));
			row.put("PTLT11", row.getString("LOTA11"));
			row.put("PTLT12", row.getString("LOTA12"));
			row.put("PTLT13", row.getString("LOTA13"));
			
			row.put("LOTA03", " ");
			row.put("LOTA05", " ");
			row.put("LOTA11", " ");
			row.put("LOTA12", " ");
			row.put("LOTA13", " ");
			
			row.put("TRNUSR", " ");
			row.put("TRNUTG", " ");
			row.put("TRNUAC", " ");
			row.put("PAIDAC", " ");
			row.put("PAIDSR", " ");
			row.put("PAIDTG", " ");
			
			//TASDI 생성 
			taskService.createTasdi(row);
			//TASDR 생성 
			taskit = taskService.createTasdr(row);
			
		}
		
		
		rtnMap.put("RESULT", "Y");
		rtnMap.put("TASKKY", taskky);
		
		return rtnMap;
	}
}