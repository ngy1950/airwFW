package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

@Service
public class InventoryService extends BaseService {
	
	static final Logger log = LogManager.getLogger(InventoryService.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveMV01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String tasoty = head.getString("TASOTY");
				String taskky = commonDao.getDocNum(tasoty);
				
				head.put("TASKKY", taskky);
				head.setModuleCommand("Task", "TASDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					String taskty = row.getString("TASKTY");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTTAOR")); // 작업수량
					map.clonSessionData(row);
					
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("TASKKY", taskky);
					row.put("TASKIT", inum);
					row.put("TASKTY", taskty);
					row.put("LOCAAC", row.getString("LOCATG"));
					row.put("QTCOMP", qty);
					
					row.setModuleCommand("Task", "TASDI");
					commonDao.insert(row);
					
					//재고조정
					row.setModuleCommand("Inventory", "STKKY_LOT_CHK");
					DataMap lotChk = commonDao.getMap(row);
					String stknum = "";
					Integer plsqty = 0;
					if(lotChk != null){
						stknum = lotChk.getString("STOKKY");
						plsqty = lotChk.getInt("QTSIWH");
					}

					// 재고 -
					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);

					// 재고 + 
					if(stknum.equals("")){
						row.put("QTSIWH", qty);
						row.put("QTSALO", 0);
						row.put("LOCAKY", row.getString("LOCATG"));
						row.setModuleCommand("Task", "STKKY");
						commonDao.insert(row);
					}else{
						row.put("STKNUM", stknum);
						row.put("QTSALO", -qty);
						row.setModuleCommand("Task", "STKKY_QTY");
						commonDao.update(row);
						
					}
					
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSJ04(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String adjuky = head.getString("ADJUTY");
				String sadjky = commonDao.getDocNum(adjuky);
				
				head.put("SADJKY", sadjky);
				head.setModuleCommand("Inventory", "ADJDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTADJU")); // 작업수량
					map.clonSessionData(row);
					
					// 기존재고 - //
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("QTADJU", -qty);
					
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);
					// 기존재고 - //
					
					// 재고조정 //
					itemCount += 10;
					snum = String.valueOf(itemCount);
					inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("LOTA01", row.getString("ALOTA01"));
					row.put("LOTA02", row.getString("ALOTA02"));
					row.put("LOTA03", row.getString("ALOTA03"));
					row.put("LOTA04", row.getString("ALOTA04"));
					row.put("LOTA05", row.getString("ALOTA05"));
					row.put("QTADJU", qty);

					// new lot
					String lotnum = row.getString("LOTNUM");
					row.setModuleCommand("Inventory", "LOTNUM_SET");
					String alotnum = (String) commonDao.getObject(row);
					
					row.put("LOCATG", row.getString("LOCAKY"));
					row.put("LOTNUM", alotnum);
					row.setModuleCommand("Inventory", "STKKY_LOT_CHK");
					DataMap lotChk = commonDao.getMap(row);
					String stknum = "";
					Integer plsqty = 0;
					String stokky = row.getString("STOKKY");
					if(lotChk != null){
						stknum = lotChk.getString("STOKKY");
						plsqty = lotChk.getInt("QTSIWH");
					}else{
						//새 재고키
						stokky = commonDao.getDocNum("999");
					}

					row.put("STOKKY", stokky);
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					// 재고 + 
					if(stknum.equals("")){
						row.put("QTSIWH", qty);
						row.put("QTSALO", 0);
						row.setModuleCommand("Inventory", "STKKY_AJ");
						commonDao.insert(row);
					}else{
						row.put("STKNUM", stknum);
						row.put("QTSALO", -qty);
						row.setModuleCommand("Task", "STKKY_QTY");
						commonDao.update(row);
					}
					// 재고조정 //
					
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSJ05(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		DataMap head = map.getMap("head");
		List<DataMap> list = map.getList("list");
		int listSize = list.size();
		
		try {
			if(listSize > 0){
				map.clonSessionData(head);
				
				String adjuky = head.getString("ADJUTY");
				String sadjky = commonDao.getDocNum(adjuky);
				
				head.put("SADJKY", sadjky);
				head.setModuleCommand("Inventory", "ADJDH");
				commonDao.insert(head);
				
				int itemCount = 0;
				for(int i = 0; i < listSize; i++){
					DataMap row = list.get(i).getMap("map");
					Float qtyor = Float.parseFloat(row.getString("QTSIWH")); // 기존재고
					Float qty = Float.parseFloat(row.getString("QTADJU")); // 작업수량
					map.clonSessionData(row);
					
					// 재고조정 //
					itemCount += 10;
					String snum = String.valueOf(itemCount);
					String inum = String.valueOf("000000").substring(0,(6-snum.length()))+snum;
					
					row.put("SADJKY", sadjky);
					row.put("SADJIT", inum);
					row.put("QTADJU", qty);
					
					row.setModuleCommand("Inventory", "ADJDI");
					commonDao.insert(row);

					row.put("STKNUM", row.getString("STOKKY"));
					row.put("QTSALO", -qty);
					row.setModuleCommand("Task", "STKKY_QTY");
					commonDao.update(row);
					// 기존재고 - //
					
				}
				
				rsMap.put("RESULT", "S");
			}else{
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}				
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveIP04(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		List<DataMap> temp_itemList = new ArrayList();
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		DataMap stkkyData = new DataMap(); // 아이템을 담는다.
		
		try{
			// PHYDH 재고조사번호 채번
			DataMap getDocNumber =  getDocNumber(headData);
			headData.put("PHYIKY", getDocNumber(headData).get("SZF_GETDOCNUMBER(:1)"));
			int itemNum = 100;
			
			// TRNDAT(송신일자) 현재날짜, 시간으로 셋팅
//			ComU getTime = new ComU();
//			headData.put("TRNDAT", getDateTime("DN")); // getDateTime : DN = "yyyyMMdd"
//			headData.put("TRNTIM", getDateTime("HN")); // getDateTime : HN = "hhmmss"
			headData.put("LMODAT", headData.getMap("map").get("DOCDAT"));
			headData.put("LMOTIM", headData.getMap("map").get("CRETIM"));
			headData.put("CREUSR", map.get("CREUSR"));
			headData.put("LMOUSR", map.get("CREUSR"));
			headData.put("INDDCL", map.get("INDDCL")); // ?
			
			headData.setModuleCommand("Inventory", "IP04_HEAD");
			commonDao.insert(headData);
				
			
			for(DataMap item : itemList){
				itemData = item.getMap("map");

				itemData.put("PHYIKY", headData.get("PHYIKY")); // PHYDI 재고조사번호 set
				
				String itemNumber = StringUtil.leftPad(""+ Integer.toString(itemNum), "0", 6);
				
				itemData.put("PHYIIT", itemNumber); // PHYDI.PHYIIT set
				itemData.put("QTSIWH", itemData.get("QTYSTL"));
//				itemData.put("RSNADJ",headData.get("RSNADJ")); // RSNADJ put  !! * 구버전에는 없는 부분..
				itemData.put("LMODAT",headData.get("LMODAT")); // LMODAT put  !! * 구버전에는 없는 부분..
				itemData.put("LMOTIM",headData.get("LMOTIM")); // LMOTIM put  !! * 구버전에는 없는 부분..
				itemData.put("LMOUSR",headData.get("LMOUSR")); // LMOTIM put  !! * 구버전에는 없는 부분..
				itemData.put("CREUSR",headData.get("CREUSR")); // LMOTIM put  !! * 구버전에는 없는 부분..
				itemData.put("OWNRKY",map.get("OWNRKY")); // LMOTIM put  !! * 구버전에는 없는 부분..
				itemData.put("WAREKY",map.get("WAREKY")); // LMOTIM put  !! * 구버전에는 없는 부분..
				
				List<DataMap> stkkyList = findStokky(itemData); //해당조건의 재고데이타들
				
				 //2.조정량이 마이너스라면 stokky가 낮은순서대로 재고를 stokky별로 조정량을 맞추어 입력한다.
				//    플러스라면 조정량에 그냥 프러스를 시키고 세부조정내역은 일자리수가 증가된 phyiit로 새로 생성한다.
				//  마이너스가 아니라면 굳이 stkky의 재고수량을 따져서 phydi에 입력할 필요 없음.(phydi의 조정량:qtadju)
				
				//java.math.BigDecimal qtadju = (BigDecimal) itemData.get("QTADJU");
				//java.math.BigDecimal zero = new BigDecimal("0");
				
				String qtadju = (String) itemData.get("QTADJU");
				String zero = "0";
				
				 //stkky에서 phydi로의 새 데이터 생성시 stokky는 빈값으로 받는다(같은 LOT의 여러 stokky가 합쳐서 PHYDI에 저장되기 때문임)
				DataMap insertItemData = (DataMap)itemData.clone();
				insertItemData.put("QTADJU", zero); //조정세부내역을 넣었으니 기존 백자리 phyiit의 조정량을 0으로 세팅
				insertItemData.put("QTSIWH", insertItemData.getInt("QTSIWH") + insertItemData.getInt("QTADJU")); //기존의 전산재고에 세부내역의 조정량을 모두 더한것
				insertItemData.put("RSNADJ", insertItemData.get("RSNADJ")); // RSNADJ 데이터 없음..
			
				insertItemData.setModuleCommand("Inventory", "IP04_ITEM");
				commonDao.insert(insertItemData);
				
				if( qtadju.compareTo(zero) == 0 ){ // compareTo :::: -1은 작다, 0은 같다, 1은 크다
					itemData.put("QTSPHY", itemData.get("QTSIWH"));
					
				}else if( qtadju.compareTo(zero) >= 1 ){
					DataMap temp_itemData = (DataMap)itemData.clone();
						
					temp_itemData.put("PHYIKY", itemData.get("PHYIKY"));
					String maxItem ="";

					int itemNumAdd = itemNum+1;
					String itemAdd = StringUtil.leftPad("" + Integer.toString(itemNumAdd), "0", 6);
					
					//조정량이 양수인 경우 세부조정내역에 stokky는 없고 조정량=실사수량=전산재고 이 셋이 동일하게 들어간다.
					temp_itemData.put("PHYIIT", itemAdd);
					temp_itemData.put("QTSPHY", itemData.get("QTADJU"));
					temp_itemData.put("QTSIWH", itemData.get("QTADJU"));
					
					temp_itemData.setModuleCommand("Inventory", "IP04_ITEM");
					commonDao.insert(temp_itemData);
					
					updateIfwms115(itemData);
				}else if( qtadju.compareTo(zero) <= -1 ){ // compareTo :::: -1은 작다, 0은 같다, 1은 크다, 즉 조정량이 마이너스 값일때
					int isEnough = itemData.getInt("QTADJU");
					
					for(DataMap stkky: stkkyList){
						
						stkkyData = stkky.getMap("map");
						isEnough += stkkyData.getInt("QTSIWH");

						int itemNumAdd = itemNum+1;
						DataMap temp_itemData = item.getMap("map");

						//조회해올때 stokky를 asc로 가져올테니 단순히 재고량만 가져와서 비교해서 넣자 phydi에. 
						//3.입력된 phydi의 재고량과 stkky의 재고량을 비교해서 
						///if(isEnough <= 0){//0이면 전산재고와 딱떨어지고,0보다작으면 재고가 더 남았으니 계속돌면서 Phydi에 일자리숫자로 아이템을 증가시킬것 
						

						if(itemData.getInt("QTADJU") < 0){	//조정량이 0보다 작거나 :::::::  0이면 전산재고와 딱떨어지고,0보다작으면 재고가 더 남았으니 계속돌면서 Phydi에 일자리숫자로 아이템을 증가시킬것
							/* 4.phydi에 일자리 숫자를 증가시키며 조정량을 입력하자.
							 * 
							 *   보통 다른 value들은 copy하고 
							 *   새로 입력될 값: phyiit, 
							 *                stokky(stkky의 stokky를 그대로 가져온다),
							 *                qtsiwh(stkky의 전산재고를 그대로 가져온다), 
							 *                (실수량은 조정량에 따라 전산재고를 유추해서 넣자), 
							 *                qtsphy(조정량), 
							 *                (조정사유) */
							temp_itemData.put("PHYIKY", itemData.get("PHYIKY"));
							
							
							String itemAdd = StringUtil.leftPad("" + Integer.toString(itemNumAdd), "0", 6);
										
							temp_itemData.put("PHYIIT", itemAdd); // phyit
							temp_itemData.put("STOKKY", stkky.get("STOKKY")); // Stokky
							temp_itemData.put("QTSIWH", stkky.get("QTSIWH"));
							temp_itemData.put("QTSPHY", itemData.getInt("QTADJU") + stkky.getInt("QTSIWH")); //실사수량 =조정량+전산재고
							
							if( isEnough < 0 ){ //0보다 작거나 같으면 stkky의 전산재고를 조정량에 넣자 ,조정량=전산재고-실사수량,
								temp_itemData.put("QTADJU", stkky.get("QTSIWH"));
								itemData.put("QTADJU", itemData.getInt("QTADJU") + stkky.getInt("QTSIWH"));
								temp_itemData.put("QTSPHY", zero);
							}else{
								temp_itemData.put("QTADJU", itemData.get("QTADJU")); //해당 stkky의 전산재고와 phydi에서 입력된 조정량을 더한값이 0이거나 0보다 크다면 입력한 phydi에서 입력한 조정량이 그대로 조정량으로 들어온다.
								//전산재고 + 조정량이 >= 0 조정량을 모두 조정 가능함으로 조정량을 0으로 세팅 
								//itemData.put("QTADJU", zero);
							}
							
							updateIfwms115(itemData);
							
							temp_itemList.add(temp_itemData);
							
							if(temp_itemList.size() > 0){
								temp_itemData.setModuleCommand("Inventory", "IP04_ITEM");
								commonDao.insert(temp_itemData);
							}
						}//end if(isEnough <= 0)	
					}//end for(Stkky stkky : stkkyList)
				}//end if( qtadju.compareTo(zero) == -1 )

				itemNum +=100;
			}//end for문
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		} // end try
		
		rsMap.put("PHYIKY", headData.get("PHYIKY"));
		rsMap.put("WAREKY", headData.get("WAREKY"));
		rsMap.put("LOTNUM", stkkyData.get("LOTNUM"));
		rsMap.put("LOCAKY", stkkyData.get("LOCAKY"));
		rsMap.put("STOKKY", stkkyData.get("STOKKY"));
		rsMap.put("RESULT", "S");

		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap getDocNumber(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
	
		map.setModuleCommand("Inventory", "IP04_GETDOCNUMBER");
		return commonDao.getMap(map);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap getMaxItem(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
	
		map.setModuleCommand("Inventory", "MAXITEM");
		return commonDao.getMap(map);
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> findStokky(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
	
		map.setModuleCommand("Inventory", "FINDSTOKKY");
		return commonDao.getList(map);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int updateIfwms115(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
	
		map.setModuleCommand("Inventory", "UPDATEIFWMS115");
		return commonDao.update(map);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap confirmIP02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
	
		List<DataMap> headList = map.getList("head"); 
		DataMap headData = new DataMap();
		
		for(DataMap head : headList){
			headData = head.getMap("map");
			
			headData.setModuleCommand("Inventory", "PHYDH");
			commonDao.update(headData);
		}
		
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveIP02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		DataMap tempData = map.getMap("tempItem");
		DataMap headData = new DataMap();
		DataMap itemData = new DataMap();

		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = new ArrayList();
		
		updateDocdat(map); // Docdat(전기일자)를 업데이트 해준다
		updateRsnadj(map); // phydi의 rsnadj를 먼저 업데이트 해준다.

		
		try{			
			for(DataMap head : headList){
				List<DataMap> temp_itemList = new ArrayList();
				DataMap temp_itemData = new DataMap();
				
				headData = head.getMap("map");
				itemList = map.getList("item");
				String phyiky = "";
				
				if(itemList.size() > 0){
					phyiky = itemList.get(0).getMap("map").getString("PHYIKY");
				}
				 
				if( !headData.getString("PHYIKY").equals(phyiky) ){
					//템프 사용
					itemList = tempData.getList(headData.getString("PHYIKY"));
					
					// 템프에도 없는 경우 조회
					if(itemList == null){
						headData.setModuleCommand("Inventory", "IP02_ITEM");
						itemList = commonDao.getList(headData);
						
						// validation check
						String [] valiCheck = {"RSNADJ"};
						String [] msg = {" 조정사유코드를 입력해주세요."};
						for(int j = 0; j<itemList.size(); j++){
							for(int i = 0; i<valiCheck.length; i++){
								if(itemList.get(j).getString(valiCheck[i]).trim().equals("")){
									throw new Exception("재고조사번호 : " + itemList.get(j).getString("PHYIKY")  + msg[i]);
								}
							}
						}
					}
				}
				
				for(DataMap item : itemList){
					itemData = item.getMap("map");
					
					String qtsphy = (String)itemData.get("QTSPHY");
					String qtystl = (String)itemData.get("QTYSTL");
					String qtadju = Integer.toString(Integer.parseInt(qtsphy) + Integer.parseInt(qtystl));
					
					//qtadju 조정수량
					//qtystl 전산재고
					if(qtadju.compareTo("0") != 0){
						DataMap maxItem = getMaxItem(itemData);
						
						int itemNum = maxItem.getInt("PHYIIT") + 1;
						itemData.put("PHYIIT", StringUtil.leftPad("" + Integer.toString(itemNum), "0", 6));
						
						temp_itemList.add(itemData);
						
					}
				}
				
				for(DataMap temp_item : temp_itemList){
					temp_itemData = temp_item.getMap("map");
					
					if(temp_itemList.size() > 0){
						temp_itemData.setModuleCommand("Inventory", "IP04_ITEM");
						commonDao.insert(temp_itemData);
					}
					temp_itemData.setModuleCommand("Inventory", "UPDATEORIGINALPHYDI");
					commonDao.update(temp_itemData);
				}
				
			}

		}catch (Exception e){
			throw new SQLException(e.getMessage());
		} // end try
		
		rsMap.put("RESULT", "S");
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void updateDocdat(DataMap map) throws SQLException {
		List<DataMap> headList = map.getList("head"); 
		DataMap headData  = new DataMap();
		
		for(DataMap head : headList){
			headData = head.getMap("map");
			
			try{
				headData.setModuleCommand("Inventory", "UPDATEDOCDAT");
				commonDao.update(headData);
			}catch (Exception e){
				throw new SQLException(e.getMessage());
			}
			
			//phydh.setPersistenceStatus(BaseEntity.PERSISTENCE_UPDATE);  ??? 이게 무엇인가
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void updateRsnadj(DataMap map) throws SQLException {
		List<DataMap> headList = map.getList("head");
	
		DataMap itemData  = new DataMap();
		DataMap headData = new DataMap();
		DataMap tempData = map.getMap("tempItem");
		
		for(DataMap head : headList){
			List<DataMap> itemList = map.getList("item");
			headData = head.getMap("map");
			String phyiky = "";
			
			if(itemList.size() > 0){
				phyiky = itemList.get(0).getMap("map").getString("PHYIKY");
			}
			
			if( !headData.getString("PHYIKY").equals(phyiky) ){
				// 템프 사용
				itemList = tempData.getList(headData.getString("PHYIKY"));
				
				// 템프에도 없는 경우 조회
				if(itemList == null){
					headData.setModuleCommand("Inventory", "IP02_ITEM");
					itemList = commonDao.getList(headData);
				}
			}
			
			for(DataMap item : itemList){
				itemData = item.getMap("map");
				
				try{
					itemData.setModuleCommand("Inventory", "UPDATERSNADJ");
					commonDao.update(itemData);
				}catch (Exception e){
					throw new SQLException(e.getMessage());
				}
			}
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveIP01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		
		DataMap headData = headList.get(0).getMap("map"); //IP04 헤더는 단 한줄이다.
		DataMap itemData  = new DataMap(); // 아이템을 담는다.
		String stokky = "";
		String phyiky;
		
		
		try{
			// 문서번호 채번
			map.put("DOCUTY" ,headData.getString("PHSCTY"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			map.clonSessionData(headData);
			
			phyiky = commonDao.getMap(map).getString("DOCNUM");
			int itemNum = 100;
			
			headData.put("PHYIKY", phyiky);
			headData.put("LMODAT", headData.get("DOCDAT"));
			headData.put("LMOTIM", headData.get("CRETIM"));
			headData.put("CREUSR", map.get("CREUSR"));
			headData.put("LMOUSR", map.get("CREUSR"));
			
			headData.setModuleCommand("Inventory", "IP04_HEAD");
			commonDao.insert(headData);
			
			for(DataMap item : itemList){
				
				itemData = item.getMap("map");
				String itemNumber = StringUtil.leftPad(""+ Integer.toString(itemNum), "0", 6);
				itemNum +=100;
				
				itemData.put("CREUSR", map.get("CREUSR"));
				itemData.put("LMOUSR", map.get("LMOUSR"));
				itemData.put("PHYIKY", phyiky);
				itemData.put("PHYIIT", itemNumber);
				itemData.put("OWNRKY",map.get("OWNRKY"));
				itemData.put("WAREKY",map.get("WAREKY"));
				
				map.clonSessionData(itemData);
				
				
				itemData.setModuleCommand("Inventory", "IP01_VALDATION");
				DataMap result = commonDao.getMap(itemData);
				String valdation = "";
				stokky += "'" + itemData.getString("STOKKY") + "',";
				
				// result가 null이 아닌 경우
				if( !(result == null) ){
					valdation = result.getString("RESULT"); 
				}
				
				if( !(valdation.equals("")) && map.getString("create_YN").equals("Y")){	// 생성된 데이터만 체크
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), valdation, new String[]{}));
				}
				
				itemData.setModuleCommand("Inventory", "IP04_ITEM");
				commonDao.insert(itemData);
			}
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		rsMap.put("PHYIKY", phyiky);
		rsMap.put("STOKKY", stokky.replaceFirst(".$", "")); // 재고키 문자열 마지막 값  "," 제거 
		rsMap.put("RESULT", "S");
		
		
		return rsMap;
	}
	
	//[ IP13 save => IP01 사용 ]
	
	//[IP13Item] 실행 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayIP13ItemC(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		map.setModuleCommand("Inventory", "IP13_FINDSTKKYLIST_ITEM");
		List<DataMap> list = commonDao.getList(map);
		
		//Rangelot
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA13");
		keyList.add("S.LOTA12");
		keyList.add("S.LOTA03");
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		map.put("RANGELOT_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		return list;
	}

	// [IP14] save
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveIP14(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> headList = map.getList("head"); 
		List<DataMap> itemList = map.getList("item");
		int resultChk = 0;
		
		DataMap headData = new DataMap(); 
		DataMap itemData = new DataMap(); 
		String recvky = "";
		
		for(DataMap head : headList){
			headData = head.getMap("map");
			headData.put("CREUSR", map.get("CREUSR"));
			
			headData.setModuleCommand("Inventory", "P_CREATE_PHYDI_BY_SYSLOC");
			resultChk = commonDao.update(headData);
			
			recvky += "'" + headData.getString("RECVKY") + "',";
		}
		
		
		rsMap.put("RESULT", "S");
		rsMap.put("RECVKYS", recvky.substring(0, recvky.length()-1));
		return rsMap;
	}
	
	// [IP11] 재조고정 Duomky(단위) GET
	@Transactional(rollbackFor = Exception.class)
	public DataMap getDataIP11(DataMap map) throws SQLException {
		map.setModuleCommand("Inventory", "IP11_SEARCHHELPDATA");
		DataMap duomky = commonDao.getMap(map);
		
		DataMap result = new DataMap(map);
		
		result.put("DUOMKY", duomky.getString("DUOMKY"));
		result.put("DESC02", duomky.getString("DESC02"));
		result.put("LOTA12", duomky.getString("LOTA12"));
		result.put("QTDUOM", duomky.getString("QTDUOM"));
		result.put("OUTDMT", duomky.getString("OUTDMT"));
		
		return result;
	}
	
	// [IP11] 재조고정 save
	public DataMap saveIP11(DataMap map) throws SQLException {
		final int PERSISTENCE_UPDATE = 2;
		final int PERSISTENCE_INSERT = 1;
		final int PERSISTENCE_DELETE = 3;
		
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		
		List<DataMap> tmp_phydiList = new ArrayList<DataMap>();
		
		DataMap head = headList.get(0).getMap("map");
		
		String docuty = head.getString("PHSCTY");
		
		DataMap sqlParam = new DataMap();
		sqlParam.put("PHSCTY", docuty);
		map.clonSessionData(sqlParam);
		sqlParam.setModuleCommand("Inventory", "IP04_GETDOCNUMBER");
	
		DataMap phyikyMap = commonDao.getMap(sqlParam);
		String phyiky = phyikyMap.getString("SZF_GETDOCNUMBER(:1)");
		
		try {
			int itemNum = 100;
		    //phydh새로 생성시 seq 없음 
			
			for(DataMap headMap : headList) {
				head = headMap.getMap("map");
				head.put("PHYIKY", phyiky);
				//Trndat(송신일자)를 업데이트 해준다 -TIS전송
				head.put("TRNDAT", new SimpleDateFormat("yyyyMMdd").format(new Date()));
				head.put("TRNTIM", new SimpleDateFormat("HHmmss").format(new Date()));
				head.put("LMODAT", head.getString("TRNDAT"));
				head.put("LMOTIM", head.getString("TRNTIM"));
				head.put("LMOUSR", head.getString("CREUSR"));
			}
			
			// TODO: headInsert
			map.clonSessionData(head);
			head.setModuleCommand("Inventory", "IP04_HEAD");
			commonDao.insert(head);
			
			sqlParam = new DataMap();
			sqlParam.put("WAREKY", head.getString("WAREKY"));  //거점을 뽑아온다
			for(DataMap itemMap : itemList) {
				DataMap item = itemMap.getMap("map");
				item.put("PERSISTENCESTATUS", PERSISTENCE_INSERT);
				item.put("OWNRKY", map.getString("OWNRKY"));
				item.put("WAREKY", head.getString("WAREKY"));

				DataMap phydiPk = new DataMap();
				phydiPk.put("PHYIKY", phyiky);
					
				String itemString = StringUtil.leftPad("" + itemNum, "0", 6);
				itemNum += 100;
				phydiPk.put("PHYIIT", itemString);
				
				// phydi.setPersistenceStatus(BaseEntity.PERSISTENCE_INSERT); ???
				item.put("PK", phydiPk);
				item.put("PHYIKY", phyiky);
				item.put("PHYIIT", itemString);
				item.put("QTSIWH", item.getString("QTYSTL"));
				
				sqlParam.put("LOTNUM", item.getString("LOTNUM"));
				sqlParam.put("LOCAKY", item.getString("LOCAKY"));
				sqlParam.put("TRNUID", item.getString("TRNUID"));
				sqlParam.put("STOKKY", item.getString("STOKKY"));
				
				//INVENTORY.PC06.FINDSTKKYLIST
				map.clonSessionData(sqlParam);
				sqlParam.setModuleCommand("Inventory", "IP11_FINDSTOKKY");
				List<DataMap> stkkyList = commonDao.getList(sqlParam); //해당조건의 재고데이타들

				// 필수 유효성 검사(SKU, 배치번호, S/L, 평가유형) 체크 method
				
				// CommonCode_ServerImpl - requiredValidateCheck()
				/* 상신 특유 입하 Validation 체크 로직 - 주석처리 2011.09.22 */
				
				 //2.조정량이 마이너스라면 stokky가 낮은순서대로 재고를 stokky별로 조정량을 맞추어 입력한다.
				//    플러스라면 조정량에 그냥 프러스를 시키고 세부조정내역은 일자리수가 증가된 phyiit로 새로 생성한다.
				//  마이너스가 아니라면 굳이 stkky의 재고수량을 따져서 phydi에 입력할 필요 없음.(phydi의 조정량:qtadju)
				BigDecimal qtadju = new BigDecimal(item.getString("QTADJU"));
				BigDecimal zero = new BigDecimal("0");
				if(qtadju.compareTo(zero) == 0) {// compareTo :::: -1은 작다, 0은 같다, 1은 크다
					item.put("QTSPHY", item.getString("QTSIWH"));
				} else if(qtadju.compareTo(zero) == 1) { // compareTo :::: -1은 작다, 0은 같다, 1은 크다
					DataMap tmp_phydi = new DataMap();
					tmp_phydi = (DataMap) item.clone();
					
					DataMap tmp_phydiPk = new DataMap();
					tmp_phydiPk = (DataMap) phydiPk.clone();
					
					tmp_phydiPk.put("PHYIKY", item.getMap("PK").getString("PHYIKY"));
					String maxItem ="";
					
					 /*
		            //기존 phyiit의 앞 4자리수 컬럼들중 제일 큰값을 찾아온다.
		    		String query = "SELECT max(phyiit) FROM phydi WHERE phyiky = '"
		    			           +phydi.getPk().getPhyiky()+"' AND phyiit like substr('"
		    			           +phydi.getPk().getPhyiit()+"',1,4)||'%'";
		            maxItem = server.getMaxItem(query);
		            int itemNumAdd = Integer.parseInt(maxItem)+1; //세부내역의 phyiit는 기존의 phyiit에 +1씩 더한값 =>MAX값이어야한다 !!!
		            */
					
					int itemNumAdd = Integer.parseInt(item.getMap("PK").getString("PHYIIT")) + 1; //세부내역의 phyiit는 기존의 phyiit에 +1씩 더한값 =>MAX값이어야한다 !!!
					String itemAdd = StringUtil.leftPad("" + itemNumAdd, "0", 6);
					tmp_phydiPk.put("PHYIIT", itemAdd);
					tmp_phydi.put("PERSISTENCESTATUS", PERSISTENCE_INSERT);
					tmp_phydi.put("PK", tmp_phydiPk);
					tmp_phydi.put("PHYIKY", tmp_phydiPk.getString("PHYIKY"));
					tmp_phydi.put("PHYIIT", tmp_phydiPk.getString("PHYIIT"));
					//090508
		            //tmp_phydi.setStokky(" ");
		            
		            //조정량이 양수인 경우 세부조정내역에 stokky는 없고 조정량=실사수량=전산재고 이 셋이 동일하게 들어간다.
					tmp_phydi.put("QTSPHY", item.getString("QTADJU")); //실사수량
					tmp_phydi.put("QTSIWH", item.getString("QTADJU")); //전산재고
					tmp_phydiList.add(tmp_phydi);
				} else if(qtadju.compareTo(zero) == -1) { // compareTo :::: -1은 작다, 0은 같다, 1은 크다, 즉 조정량이 마이너스 값일때
					int isEnough = item.getInt("QTADJU");
					int itemNumAdd = Integer.parseInt(item.getMap("PK").getString("PHYIIT"));
					
					for(DataMap stkkyMap : stkkyList) { // 조회조건으로 검색한 stkky의 내용
						DataMap stkky = stkkyMap.getMap("map");
						isEnough += stkky.getInt("QTSIWH");
						
						DataMap tmp_phydi = new DataMap();
						tmp_phydi = (DataMap) item.clone();
						
						//조회해올때 stokky를 asc로 가져올테니 단순히 재고량만 가져와서 비교해서 넣자 phydi에. 
						//3.입력된 phydi의 재고량과 stkky의 재고량을 비교해서 
						///if(isEnough <= 0){//0이면 전산재고와 딱떨어지고,0보다작으면 재고가 더 남았으니 계속돌면서 Phydi에 일자리숫자로 아이템을 증가시킬것
						if(item.getInt("QTADJU") < 0) { //조정량이 0보다 작거나 :::::::  0이면 전산재고와 딱떨어지고,0보다작으면 재고가 더 남았으니 계속돌면서 Phydi에 일자리숫자로 아이템을 증가시킬것
							/* 4.phydi에 일자리 숫자를 증가시키며 조정량을 입력하자.
							 *   보통 다른 value들은 copy하고 
							 *   새로 입력될 값: phyiit, 
							 *                stokky(stkky의 stokky를 그대로 가져온다),
							 *                qtsiwh(stkky의 전산재고를 그대로 가져온다), 
							 *                (실수량은 조정량에 따라 전산재고를 유추해서 넣자), 
							 *                qtsphy(조정량), 
							 *                (조정사유) */
							
							DataMap tmp_phydiPk = new DataMap();
							tmp_phydiPk = (DataMap) phydiPk.clone();
							
							itemNumAdd += 1;
							String itemAdd = StringUtil.leftPad("" + itemNumAdd, "0", 6);
							tmp_phydiPk.put("PHYIIT", itemAdd);
							tmp_phydi.put("PERSISTENCESTATUS", PERSISTENCE_INSERT);
							tmp_phydi.put("PK", tmp_phydiPk);
							tmp_phydi.put("PHYIKY", tmp_phydiPk.getString("PHYIKY"));
							tmp_phydi.put("PHYIIT", tmp_phydiPk.getString("PHYIIT"));
							tmp_phydi.put("STOKKY", stkky.getString("STOKKY"));
							// tmp_phydi.put("STOKKY", " ");
							tmp_phydi.put("QTSIWH", stkky.getString("QTSIWH")); //qtsiwh(전산재고)
							tmp_phydi.put("QTSPHY", item.getInt("QTADJU") + (stkky.getInt("QTSIWH"))); //실사수량 =조정량+전산재고, 실사수량이 QTSPHY였어!!!! // .add() ??????????????????????????????????????
							
							if(isEnough < 0) { //0보다 작거나 같으면 stkky의 전산재고를 조정량에 넣자 ,조정량=전산재고-실사수량,
								tmp_phydi.put("QTADJU", stkky.getString("QTSIWH")); //해당 stkky의 전산재고와 phydi에서 입력된 조정량을 더한값이 0보다 작으면 stkky의 전산재고에 (-)를 붙인게 조정량이 된다.
								item.put("QTADJU", item.getInt("QTADJU") + (stkky.getInt("QTSIWH"))); // .add() ??????????????????????????????????????
								tmp_phydi.put("QTSPHY", BigDecimal.ZERO);
							} else {
								tmp_phydi.put("QTADJU", item.getString("QTADJU"));//해당 stkky의 전산재고와 phydi에서 입력된 조정량을 더한값이 0이거나 0보다 크다면 입력한 phydi에서 입력한 조정량이 그대로 조정량으로 들어온다.
								//전산재고 + 조정량이 >= 0 조정량을 모두 조정 가능함으로 조정량을 0으로 세팅
								item.put("QTADJU", BigDecimal.ZERO);
							}
							tmp_phydiList.add(tmp_phydi);
						}//end if(isEnough <= 0)
					}//end for(Stkky stkky : stkkyList)
				}//end if( qtadju.compareTo(zero) == -1 )
				
				//stkky에서 phydi로의 새 데이터 생성시 stokky는 빈값으로 받는다(같은 LOT의 여러 stokky가 합쳐서 PHYDI에 저장되기 때문임)
		        //phydi.setStokky(" ");
		        //phydi.setQtsiwh(phydi.getQtystl()); //실제 전산수량을 이컬럼에 입력한다 qtystl은 없는컬럼
				item.put("QTADJU", BigDecimal.ZERO); //조정세부내역을 넣었으니 기존 백자리 phyiit의 조정량을 0으로 세팅
				item.put("QTSIWH", item.getInt("QTSIWH") + item.getInt("QTADJU"));//기존의 전산재고에 세부내역의 조정량을 모두 더한것
				item.put("RSNADJ", item.getString("RSNADJ"));
				
				// TODO: 아이템 insert
				map.clonSessionData(item);
				item.setModuleCommand("Inventory", "IP11_ITEM");
				commonDao.insert(item);
			
			} // end for item
			
			// 해드 insert (phydhList)
			// item insert (phydiList)
			// 신버전에서는 map을 보내 insert 해야 하므로 for문 안에서 insert
			
			for(DataMap itemMap : itemList) {
				DataMap item = itemMap.getMap("map");
				item.put("PERSISTENCESTATUS", PERSISTENCE_UPDATE);
				
				switch(item.getInt("PERSISTENCESTATUS")) {
				case PERSISTENCE_UPDATE :
					commonDao.update(item);
					break;
				}
			}
			
			if(tmp_phydiList.size() > 0) {
				for(DataMap tempItemMap : tmp_phydiList) {
					DataMap tempItem = tempItemMap.getMap("map");
					tempItem.setModuleCommand("Inventory", "IP11_ITEM");
		
					switch (tempItem.getInt("PERSISTENCESTATUS")) {
					case PERSISTENCE_INSERT:
						commonDao.insert(tempItem);
						break;
		
					case PERSISTENCE_UPDATE:
						commonDao.update(tempItem);
						break;
		/*					
						case PERSISTENCE_DELETE:
							
							break;*/
					}
				}
			}
			
			map.put("PHYIKYMAP", phyikyMap);
			map.put("PHYIKY", phyiky);
			map.put("TMP_PHYDILIST", tmp_phydiList);
			map.put("RESULT", "M");
			map.put("M", "S");
			map.put("C", "INV_M0052");
		} catch(Exception e) {
			map = new DataMap();
			map.put("RESULT", "M");
			map.put("M", "F");
			map.put("C", "EXECUTE_ERROR");
		}
		return map;
	} // end saveIP11()
	
	// [IP11] 재조고정 research
	public DataMap reSearchIP11(DataMap map) throws SQLException {
		DataMap result = new DataMap();
		
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		
		List<DataMap> headResultList = new ArrayList<DataMap>();
		List<DataMap> itemResultList = new ArrayList<DataMap>(); 
		
		for(DataMap headMap : headList) {
			DataMap head = headMap.getMap("map");
			
			head.setModuleCommand("Inventory", "IP11_REHEAD");
			List<DataMap> tempList = commonDao.getList(head);
			
			for(DataMap tempMap : tempList) {
				DataMap temp = tempMap.getMap("map");
				headResultList.add(temp);
			}
			
		}
		
		for(DataMap itemMap : itemList) {
			DataMap item = itemMap.getMap("map");
			
			item.setModuleCommand("Inventory", "IP11_REITEM");
			List<DataMap> tempList = commonDao.getList(item);
			
			for(DataMap tempMap : tempList) {
				DataMap temp = tempMap.getMap("map");
				itemResultList.add(temp);
			}
			
		}
		result.put("head", headResultList);
		result.put("item", itemResultList);
		return result;
	} // end reSearchIP11()
}