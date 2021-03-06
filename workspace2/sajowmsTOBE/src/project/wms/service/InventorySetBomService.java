package project.wms.service;

import java.math.BigDecimal;
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
import project.http.po.POInterfaceManager;

@Service
public class InventorySetBomService extends BaseService {
	
	static final Logger log = LogManager.getLogger(InventorySetBomService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;
	
	@Autowired
	public POInterfaceManager poManager; 

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
	
	
	@Transactional(rollbackFor = Exception.class)
	public List disjoinSJ02(DataMap map) throws SQLException,Exception {
		List rsList = new ArrayList();
		List<DataMap> itemList = map.getList("item");
		//String sadjky = "";
		
		DataMap row = new DataMap();
		
		for(DataMap item : itemList){
			row = item.getMap("map");
			
			map.clonSessionData(row);
			row.put("OWNRKY", map.getString("OWNRKY"));
			row.put("WAREKY", map.getString("WAREKY"));
			row.put("DOCTXT", map.getString("DOCTXT"));
			row.put("ADJUTY", map.getString("ADJUTY"));
			row.put("DOCDAT", map.getString("DOCDAT"));
			
			map.put("DOCUTY" ,map.getString("ADJUTY"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			String sadjky = commonDao.getMap(map).getString("DOCNUM");
			row.put("SADJKY", sadjky);
			
			//PAKMA를 체크하여 없을 경우 에러메시지 출력 [ 세트정보가 없습니다.] 
			/*row.setModuleCommand("InventorySetBom", "SJ01_VALID_PAKMA");
			int cnt = commonDao.getMap(row).getInt("CNT");
			if(cnt < 1){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0074",new String[]{}));
			}	*/
			
			//헤더 생성(ADJDH)
/*			row.put("SADJKY", sadjky);
			sadjky = adjustmentService.createAdjdh(row);*/
			
			//입력한 세트품의 세트구성품 정보와 stkky테이블에 있는 구성품 수량을 가져온다.
			row.setModuleCommand("InventorySetBom", "SJ02_DISJOIN");
			List list = commonDao.getList(row);

			//PAKMA를 체크하여 없을 경우 에러메시지 출력 [ 세트정보가 없습니다.] 
			if(list.size() < 1){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0074",new String[]{}));
			}
			
			//그리드에 출력정보 입력 
			rsList.addAll(list);
		}
		
		return rsList;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSJ02(DataMap map) throws Exception {
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		List<DataMap> itemList2 = map.getList("item2");
		
		DataMap rsMap = new DataMap();
		DataMap adjdh = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap adjdi = new DataMap();
		DataMap adjdi2 = new DataMap();
		DataMap stock = new DataMap();
		
		int sadjit = 10;
		String rtnStr = "E";
		String sadjky = "";
		String sadjkyChk = "";
		String adjdi2Sadjky = ""; //ADJDI2 SADJKY 가져옴
    	String adjdi2Refdky = ""; //ADJDI2 REFDKY 가져옴
    	String adjdi2Packid = ""; //ADJDI2 PACKID 가져옴
    	String adjdi2Stokky = ""; //ADJDI2 STOKKY 가져옴
    	
    	
    	String sendSadjky = "";
		String sendSkukey = "";
		String RTNSTS = "";
		String SDOCNO = "";
		String RTNMSG ="";
		String sdocnoCheck = "";
		DataMap rtnMap = new DataMap();
    	for(DataMap item2 : itemList2){
			adjdi2 = item2.getMap("map");
			String roofSadjky = adjdi2.getString("SADJKY");
			if(!sendSadjky.equals(roofSadjky)){
				sendSkukey = adjdi2.getString("SKUKEY");
				adjdi2.put("REFCAT", "101");
				
				// SAP_PP0100 인터페이스 송신
				rtnMap =  poManager.SAP_PP0100(adjdi2.getString("SADJKY"), map.getString("WAREKY"), adjdi2.getString("SKUKEY"), map.getString("DOCDAT"));
				String result = rtnMap.getString("RTNSTS");
				if("E".equals(result)){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "오더를 SAP전송 시 ERROR 발생",new String[]{}));
				}
				sendSadjky = roofSadjky;
			}else{
				adjdi2.put("REFCAT", "531");
			}
			adjdi2.put("REFDKY", rtnMap.get("SDOCNO"));
		}
    	
		for(DataMap item : itemList){
			adjdi = item.getMap("map");
			
			for(DataMap item2 : itemList2){
				adjdi2 = item2.getMap("map");
				
				if(adjdi2.get("LOTA13").equals("") || adjdi2.get("LOTA13").equals(" ")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0324",new String[]{}));
				}
				
				adjdi2Sadjky = adjdi2.getString("SADJKY");  //ADJDI2 SADJKY
    			adjdi2Stokky = adjdi2.getString("STOKKY"); 
				adjdi2Refdky = adjdi2.getString("REFDKY");
    			
				if(!adjdi2.getString("SADJKY").equals(sadjkyChk)){
					adjdi2Refdky = adjdi2.getString("REFDKY");
					adjdi2Packid = adjdi2.getString("PACKID");
					
					if(adjdi.getString("PACKID").equals(adjdi2Packid) && (" ".equals(adjdi.getString("STOKKY")) || adjdi.getString("STOKKY").equals(adjdi2Stokky))){ // ADJDI PACKID와 ADJDI2 PACKID 같은지 체크해서 같으면 ADJDI에 SADJKY INSERT
						adjdi.put("SADJKY", adjdi2Sadjky);
						adjdi.put("QTYUOM", adjdi.get("QTADJU"));
						adjdi.put("REFDKY", adjdi2Refdky);	//ASJDI2 만큼 ADJDI 만듬 
						
						map.clonSessionData(adjdh);
						adjdh.put("SADJKY", adjdi.get("SADJKY"));
						
						sadjky = adjustmentService.createAdjdh(adjdh);
					}// end if
				}// end if
				
				sadjkyChk = adjdi2Sadjky;
				
			}// end for
			
			if(adjdh.getString("ADJUTY").equals("402") || adjdh.getString("ADJUTY").equals("403")){
				adjdi.put("QTADJU", adjdi.getInt("QTADJU") * -1);
			}
			
			//세트조림 안씀
			if(adjdh.getString("ADJUTY").equals("401")){
				if(adjdi.getString("LOTA13").equals("") || adjdi.getString("LOTA13").equals("")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0324",new String[]{}));
				}
			}
			map.clonSessionData(adjdi);
			
			adjdi.put("SADJIT", sadjit);
			adjdi.put("SADJKY", sadjky);
			adjdi.put("WAREKY", map.get("WAREKY"));
			adjdi.put("REFDKY", adjdi2Refdky);
			sadjit = adjustmentService.createAdjdi(adjdi);
			
			for(DataMap item2 : itemList2){
				adjdi2 = item2.getMap("map");
				if(adjdi.getString("PACKID").equals(adjdi2.getString("PACKID")) && adjdi.getString("STOKKY").equals(adjdi2.getString("STOKKY"))){
					map.clonSessionData(adjdi2);
					adjdi2.put("WAREKY", map.get("WAREKY"));
					adjdi2.put("STOKKY", " ");
					adjdi2.put("SADJIT", sadjit);
					sadjit = adjustmentService.createAdjdi(adjdi2);		
				}
			}
			
		}// end for
		
		
		if(adjdh.getString("ADJUTY").equals("401")){
	
			for(DataMap item2 : itemList2){
				adjdi2 = item2.getMap("map");
				int StockCNT = 0;
				
				adjdi2.put("WAREKY", map.getString("WAREKY"));
				map.setModuleCommand("InventorySetBom", "SJ02_STOKKY");
				List<DataMap> stockList = commonDao.getList(adjdi2);
				
				for(DataMap item : stockList){
					stock = item.getMap("map");
					StockCNT += 1;

					if(adjdi2.getString("QTNEED").compareTo("0") <= 0){
						break;
					}
					
					DataMap temp_adjdi2 = new DataMap();
					
					stock.put("SADJIT", sadjit);
					stock.put("AWMSNO", " ");
					map.clonSessionData(stock);
					
					if(adjdi2.getString("QTNEED").compareTo(stock.getString("QTSIWH")) <= 0){
						stock.put("QTADJU",adjdi2.getInt("QTNEED") * -1);
						stock.put("QTYUOM",adjdi2.getInt("QTNEED") * -1);
						stock.put("QTADJU","0");
					}else{
						stock.put("QTADJU", stock.getInt("QTSIWH") * -1);
						stock.put("QTADJU", stock.getInt("QTSIWH") * -1);
					}
					
					
					sadjit = adjustmentService.createAdjdi(stock);	
					
					if(StockCNT == stockList.size()){
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "세트 조립 오류로 다시 조회하여 주시기 바랍니다.",new String[]{}));
					}
					
				} // end for
			}//end for
			adjdi2.put("QTNEED", adjdi2.get("QTSIWH")); 
		}else if(adjdh.getString("ADJUTY").equals("403")){
			for(DataMap item2 : itemList2){
				adjdi2 = item2.getMap("map");
				
				if(adjdi2.getString("LOTA13").equals("") || adjdi2.getString("LOTA13").equals(" ")){
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0324",new String[]{}));
				}
				
				adjdi2.put("SADJIT", sadjit);
				adjdi2.put("LOTA06", "20");
				map.clonSessionData(adjdi2);
				
				sadjit = adjustmentService.createAdjdi(adjdi2);	
				
			}
		}
		
		rsMap.put("RESULT", "S");
		rsMap.put("SADJKY", sadjky);
		
		return rsMap;
	}
}