package project.wms.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.StringUtil;

@Service
public class InventoryAdjustmentService extends BaseService {
	
	static final Logger log = LogManager.getLogger(InventoryAdjustmentService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;

	@Autowired
	private AdjustmentService adjustmentService;
	
	@Transactional(rollbackFor = Exception.class)
	public List setJoinSJ01(DataMap map) throws SQLException,Exception {
		List rsList = new ArrayList();
		List<DataMap> itemList = map.getList("item");
		
		DataMap row;
		for(DataMap item : itemList){
			row = item.getMap("map");
			map.clonSessionData(row);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("DOCTXT", map.getString("DOCTXT"));
			row.put("ADJUTY", map.getString("ADJUTY"));
			row.put("DOCDAT", map.getString("DOCDAT"));

			//PAKMA를 체크하여 없을 경우 에러메시지 출력 [ 세트정보가 없습니다.] 
			row.setModuleCommand("InventorySetBom", "SJ01_VALID_PAKMA");
			int cnt = commonDao.getMap(row).getInt("CNT");
			if(cnt < 1){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0074",new String[]{}));
			}
			
			//입력한 세트품의 세트구성품 정보와 stkky테이블에 있는 구성품 수량을 가져온다.
			row.setModuleCommand("InventorySetBom", "SJ01ITEM");
			List setList =  commonDao.getList(row);
			
			//그리드에 출력정보 입력 
			rsList.addAll(setList);
		}
		
		return rsList;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public String saveSJ01(DataMap map) throws Exception {
		String rtnStr = "E";
		List<DataMap> itemList = map.getList("item");
		String sadjky = "";
		int sadjit = 10;
		DataMap row = new DataMap();
		
		//헤더 생성(ADJDH)
		sadjky = adjustmentService.createAdjdh(map);
		
		for(DataMap item : itemList){
			row = item.getMap("map");
			map.clonSessionData(row);
			
			//기반 데이터 세팅
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("SADJKY", sadjky);
			row.put("SADJIT", sadjit);
			
			//세트 제품 생성 
			sadjit = adjustmentService.createAdjdi(row);
			
			//세트 구성품 정보 가져오기 
			row.setModuleCommand("InventorySetBom", "SJ01_PAKMA");
			List<DataMap> packList = commonDao.getList(row);
			
			int qtadju = row.getInt("QTADJU");
			//세트 구성품 제품 차감 
			for(DataMap pack : packList){
				row.put("SADJIT", sadjit);
				row.put("SKUKEY", pack.getString("SKUKEY"));
				row.put("QTADJU", pack.getInt("UOMQTY")*qtadju);
				row.put("LOCAKY", "SETLOC");
				sadjit = adjustmentService.createAdjdiFromSTK(row);
			}
		}
		
		rtnStr = row.getString("SADJKY");
				
		return rtnStr;
	}
	
	//SJ03, SJ04, SJ05 공통으로 사용
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSJ04(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		rsMap.put("RESULT", "Fl");

		String progid = map.get("PROG_ID").toString();
		String sadjky = "";
		//조정사유
		String rsnadj = "";
		int sadjit = 10;
		
		List<DataMap> itemList = map.getList("item");
		DataMap row = new DataMap();
		
		try{
			sadjky = adjustmentService.createAdjdh(map);
			
			for(DataMap item : itemList){
				row = item.getMap("map");
				map.clonSessionData(row);
				row.put("SES_USER_ID", map.get("SES_USER_ID"));
				row.put("OWNRKY", map.getString("OWNRKY"));
				row.put("WAREKY", map.getString("WAREKY"));
				row.put("DOCTXT", map.getString("DOCTXT"));
				row.put("ADJUTY", map.getString("ADJUTY"));
				row.put("DOCDAT", map.getString("DOCDAT"));
				row.put("SADJIT", sadjit);
				row.put("SADJKY", sadjky);
				row.put("AWMSNO", row.getString("SKUKEY"));
				if(row.get("SKUKEY").equals(" ")) 
					continue;
				
				if(row.get("SBKTXT").toString().length() > 25){
				  throw new Exception("비고란의 길이가 25자를 초과할 수 없습니다.");
				}
				
				row.setModuleCommand("InventoryAdjustment", "SJ04_VALIDATE");
				DataMap check = commonDao.getMap(row);
				
				// 1. 속성변경 체크, 2.skukey가 SKUMA에 있는지,locaky가 LOCMA에 있는지 조회. 3. 해당 stokky로 STKKY에서 수량을 검색해 재고수량이 조정수량이 많은지를 검색.(DB검색)
				if(!check.get("RESULT").equals(" ")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), check.get("RESULT").toString(),new String[]{}));
				}	
				
				//차감프로시저 createAdjdiFromSTK 에 stokky(재고키), ownrky 화주   ,wareky 거점   ,locaky 로케이션 , skukey 제품코드, qtadju(조정수량을) 를 던진다.				
				sadjit = adjustmentService.createAdjdiFromSTK(row);
				row.put("SADJKY", sadjky);
				row.put("SADJIT", sadjit);
				
				DataMap adjdi = (DataMap)row.clone();
				adjdi.put("STOKKY", "");
				adjdi.put("LOTNUM", "");
				
				if(map.getString("PROGID").equals("SJ03")){
					row.setModuleCommand("SajoCommon", "INVENTORY_SKUMA_GETINFO_MTOM");
					DataMap sku = commonDao.getMap(row);
					row.setModuleCommand("SajoCommon", "INVENTORY_LOCMA_GETINFO");
					DataMap loc = commonDao.getMap(row); 
					
					adjdi.putAll(sku);
					adjdi.putAll(loc);
					
				}
				 
				//증감프로시저 createAdjdi 에 수정된 데이터 전부 lota05 .... (item row전체)를 던진다.
				sadjit = adjustmentService.createAdjdi(adjdi);

			}
			// ADJDI update
			row.put("SADJIT", sadjit-10);
			row.setModuleCommand("InventoryAdjustment", "SJ04");
			commonDao.update(row);
			
			rsMap.put("RESULT", "S");
			rsMap.put("SADJKY", sadjky);
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		
		return rsMap;
	}
	
	
	
}