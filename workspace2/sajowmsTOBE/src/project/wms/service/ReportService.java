package project.wms.service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

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
import project.common.util.SqlUtil;
import project.http.po.POInterfaceManager;

@Service
public class ReportService extends BaseService {
	
	static final Logger log = LogManager.getLogger(ReportService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private AdjustmentService adjustmentService;
	
	//[RL00] 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL00(DataMap map) throws SQLException {
		
		map.setModuleCommand("Report", "RL00");

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("DOCDAT");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		

		List keyList2 = new ArrayList<>();
		keyList2.add("LOC.AREAKY");
		keyList2.add("LOC.ZONEKY");
		keyList2.add("LOC.LOCAKY");
		keyList2.add("A.SKUKEY");
		keyList2.add("A.DESC01");
		
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);
	
		return list;
	}
		
	
	//[RL06] 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL06(DataMap map) throws SQLException {
		
		map.setModuleCommand("Report", "RL06");

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("SH.WAREKY");
		keyList.add("SM.DESC01");
		keyList.add("SM.SKUKEY");
		keyList.add("SH.DOCDAT");
		keyList.add("SH.SHPMTY");
		keyList.add("SM.ASKU02");
		keyList.add("SR.CARDAT");
		
//		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		DataMap changeMap = new DataMap();
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));
		
		
			
//		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList2 = new ArrayList<>();
		keyList2.add("SH.WAREKY");
		keyList2.add("SM.DESC01");
		keyList2.add("SM.SKUKEY");
		keyList2.add("SM.ASKU02");
		keyList2.add("SR.CARDAT");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("SH.WAREKY", "RH.WAREKY");
		changeMap2.put("SR.CARDAT", "RH.DOCDAT");
		
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2));
		
		List<DataMap> list = commonDao.getList(map);
	
		return list;
	}
	
	//[RL07] 1번 탭 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL07_01(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL07_01");
		
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("RH.DOCDAT");
		keyList.add("RI.SKUKEY");
		keyList.add("RI.DESC01");
		
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	
	//[RL07] 2번 탭 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL07_02(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL07_02");
		
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("RH.DOCDAT");
		keyList.add("RI.SKUKEY");
		keyList.add("RI.DESC01");
		
		DataMap changeMap = new DataMap();
		changeMap.put("RH.DOCDAT", "SH.DOCDAT");
		changeMap.put("RI.SKUKEY", "SI.SKUKEY");
		changeMap.put("RI.DESC01", "SI.DESC01");
		
		map.put("RANGE_SQL",sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	
	//[RL07] 3번 탭 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL07_03(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL07_03");
		
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("RH.DOCDAT");
		keyList.add("RI.SKUKEY");
		keyList.add("RI.DESC01");
		
		DataMap changeMap = new DataMap();
		changeMap.put("RH.DOCDAT", "AH.DOCDAT");
		changeMap.put("RI.SKUKEY", "AI.SKUKEY");
		changeMap.put("RI.DESC01", "AI.DESC01");
		
		map.put("RANGE_SQL",sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}

	
	//[RL23] 1번 탭 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL23_01(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL23_01");
		
		/* RANGE_SQL */
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("DR.CARDAT");
		keyList.add("DR.SHIPSQ");
		keyList.add("DR.CARNUM");
		keyList.add("DI.SKUKEY");
		
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		
		keyList2.add("PH.DOCDAT");
		
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	
	//[RL23] 2번 탭 조회
	@Transactional(rollbackFor = Exception.class)
	public List getListRL23_02(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL23_02");
		
		/* RANGE_SQL */
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("DR.CARDAT");
		keyList.add("DR.SHIPSQ");
		keyList.add("DR.CARNUM");
		keyList.add("DI.SKUKEY");
		
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		
		keyList2.add("PH.DOCDAT");
		
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}

	//[RL21] 1 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayRL21_1(DataMap map) throws Exception {
		
		map.setModuleCommand("Report", "RL21_1");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList1 = new ArrayList<>();
		keyList1.add("SVBELN2");
		keyList1.add("SHPOKY");
		keyList1.add("SHPMTYK");
		keyList1.add("SKUKEY");
		keyList1.add("DESC01");
		keyList1.add("DOCDAT");
		keyList1.add("CARDAT");
		keyList1.add("SHIPSQ");
		keyList1.add("PGRC03");
		keyList1.add("PGRC02");
		keyList1.add("OWNRKY");
		keyList1.add("WAREKY");
		keyList1.add("DPTNKY");
		keyList1.add("DPTNKYNM");
		keyList1.add("CARINFO");
		keyList1.add("NAME03");
		keyList1.add("NAME03NM");
		keyList1.add("PGRC04");
		/*keyList1.add("PG04NM");*/
		keyList1.add("SKUG05");
		keyList1.add("UNAME4");
		keyList1.add("DNAME4");
		keyList1.add("DCNDTN");
		keyList1.add("CARNBR");
		keyList1.add("RECNUM");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	//[RL21] 2 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayRL21_2(DataMap map) throws Exception {
		
		map.setModuleCommand("Report", "RL21_2");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList2 = new ArrayList<>();
		keyList2.add("SHPOKY");
		keyList2.add("SHPMTYK");
		keyList2.add("CARDAT");
		keyList2.add("CARINFO");
		keyList2.add("SHIPSQ");
		keyList2.add("OWNRKY");
		keyList2.add("WAREKY");
		keyList2.add("DPTNKY");
		keyList2.add("DPTNKYNM");
		keyList2.add("CARNUM");
		keyList2.add("NAME03");
		keyList2.add("NAME03NM");
		keyList2.add("PGRC02");
		keyList2.add("PGRC03");
		keyList2.add("PGRC04");
		keyList2.add("PG04NM");
		keyList2.add("SKUG05");
		keyList2.add("UNAME4");
		keyList2.add("DNAME4");
		keyList2.add("DCNDTN");
		keyList2.add("CARNBR");
		keyList2.add("RECNUM");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	//[RL21] 3 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayRL21_3(DataMap map) throws Exception {
		
		map.setModuleCommand("Report", "RL21_3");
		
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList3 = new ArrayList<>();
		keyList3.add("SVBELN2");
		keyList3.add("SHPOKY");
		keyList3.add("SHPMTYK");
		keyList3.add("SKUKEY");
		keyList3.add("DESC01");
		keyList3.add("CARDAT");
		keyList3.add("SHIPSQ");
		keyList3.add("PGRC03");
		keyList3.add("PGRC02");
		keyList3.add("OWNRKY");
		keyList3.add("WAREKY");
		keyList3.add("DPTNKY");
		keyList3.add("DPTNKYNM");
		keyList3.add("CARINFO");
		keyList3.add("NAME03");
		keyList3.add("NAME03NM");
		keyList3.add("PGRC04");
		keyList3.add("PG04NM");
		keyList3.add("SKUG05");
		keyList3.add("LOTA11");
		keyList3.add("LOTA12");
		keyList3.add("LOTA13");
		keyList3.add("UNAME4");
		keyList3.add("DNAME4");
		keyList3.add("DCNDTN");
		keyList3.add("CARNBR");
		keyList3.add("RECNUM");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}
	
	// [SU01] WMS_SAP 수불 - 실행
	@Transactional(rollbackFor = Exception.class)
	public DataMap excuteSU01(DataMap map) throws SQLException {
		
		DataMap result = new DataMap();
		
		try {
			String from =  map.getString("FROM");
			String to = map.getString("TO");
			
			from = from.replaceAll("\\.", "");
			to = to.replaceAll("\\.", "");
			
			map.put("FROM", from);
			map.put("TO", to);
			
			map.setModuleCommand("Report", "SU01_P_REBUILD_SUBUL");
			commonDao.update(map);
			

			result.put("RESULT", "C");
			result.put("C", "S");
			result.put("M", "HHT_T0008");
		} catch(Exception e) {
			result.put("RESULT", "C");
			result.put("C", "E");
			result.put("M", "HHT_T0008");
			// result.put("M", "TASK_M0001");
			result.put("E", e.getMessage());
		}
		
		return result;
		
	} // excuteSU01()
	
	//[RL25] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayRL25(DataMap map) throws SQLException{
		map.setModuleCommand("Report", "RL25");
		
		/* RANGE_SQL */
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		
		keyList.add("DH.DOCDAT");
		keyList.add("DH.RCPTTY");
		keyList.add("DI.SKUKEY");
		keyList.add("SM.DESC01");
		keyList.add("DH.DNAME1");
		keyList.add("SM.SKUG05");
		String sql = sqlUtil.getRangeSqlFromList((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList);
		sql = sql.substring(5);	 //  AND (  (  ( DH.DOCDAT = '20210414' )  )  )   - AND 절삭
		map.put("RANGE_SQL", sql);
		
		
		/* RANGE_SQL2 */
		List keyList2 = new ArrayList<>();
		keyList2.add("DH.DOCDAT");
//		keyList2.add("DR.CARDAT");
		keyList2.add("DH.SHPMTY");
		keyList2.add("DI.SKUKEY");
		keyList2.add("SM.DESC01");
		keyList2.add("I3.DIRSUP");
		keyList2.add("I3.DIRDVY");
		keyList2.add("SM.SKUG05");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("DH.DOCDAT", "DR.CARDAT");	
		
		String sql2 = sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2);
		sql2 = sql2.substring(5);	 //  AND (  (  ( DH.DOCDAT = '20210414' )  )  )   - AND 절삭
		map.put("RANGE_SQL2", sql2);
		
		/* RANGE_SQL3 */
		List keyList3 = new ArrayList<>();
		keyList3.add("DH.DOCDAT");
		keyList3.add("DH.ARCPTD");
		keyList3.add("DH.RCPTTY");
		keyList3.add("DI.SKUKEY");
		keyList3.add("SM.DESC01");
		keyList3.add("SM.SKUG05");
		keyList3.add("DH.ARCPTD");
		
		DataMap changeMap3 = new DataMap();
		changeMap3.put("DH.DOCDAT", "DH.ARCPTD");
		
		String sql3 =  sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList3, changeMap3);
		sql3 = sql3.substring(5);	 //  AND (  (  ( DH.DOCDAT = '20210414' )  )  )   - AND 절삭
		sql3 = "OR " + sql3; // AND 절삭 후 OR
		map.put("RANGE_SQL3", sql3);
		
		/* RANGE_SQL4 */
		List keyList4 = new ArrayList<>();
		keyList4.add("DH.DOCDAT");
//		keyList4.add("DH.LSHPCD");
		keyList4.add("DH.SHPMTY");
		keyList4.add("DI.SKUKEY");
		keyList4.add("SM.DESC01");
		keyList4.add("I3.DIRSUP");
		keyList4.add("I3.DIRDVY");
		keyList4.add("I3.WARESR");
		keyList4.add("SM.SKUG05");
		
		DataMap changeMap4 = new DataMap();
		changeMap4.put("DH.DOCDAT", "DH.LSHPCD");
		
		String sql4 =  sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList4, changeMap4);
		sql4 = sql4.substring(5);	 //  AND (  (  ( DH.DOCDAT = '20210414' )  )  )   - AND 절삭
		sql4 = "OR " + sql4; // AND 절삭 후 OR
		map.put("RANGE_SQL4", sql4);
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	} // end getListRL25
	
	//[RL09] 이동
	@Transactional(rollbackFor = Exception.class)
	public DataMap moveRL09(DataMap map) throws Exception,SQLException {
		DataMap rsMap = new DataMap();
		
		List<DataMap> itemList = map.getList("list");
		List<DataMap> adjdhList = new ArrayList();
		List<DataMap> adjdiList = new ArrayList();
		List<DataMap> negativeAdjdiList = new ArrayList();
		String sadjky = "";
		int sadjit=10;
		
		//헤더 필요데이터 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar c1 = Calendar.getInstance();
		
		map.put("ADJUTY", "998");
		map.put("DOCCAT", "400");
		map.put("ADJUCA", "400");
		map.put("DOCDAT", sdf.format(c1.getTime()));
		
		//헤더 미리 체번 
		sadjky = adjustmentService.createAdjdh(map);

		for(DataMap item : itemList){
			// 가용재고 재고수량이 음수이면 이동수량이 음수만 가능, 양수이면 양수만 가능 
			DataMap row = item.getMap("map");
			row.put("RSNADJ", "MOVE");
			map.clonSessionData(row);

			//VALIDATION 가용재고수량(availableQty)이 양수일때 작업수량(QTTAOR)이 1보다 작으면 에러
			if(row.getInt("QTTAOR") < 1)
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0019", new String[]{row.getString("QTTAOR")}));

			//VALIDATION 가용수량보다 작업수량이 큰지 체크 
			if(row.getInt("QTTAOR") > row.getInt("AVAILABLEQTY"))
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_RL09QTY", new String[]{row.getString("QTTAOR")}));
			

			row.put("QTADJU", row.getInt("QTTAOR"));
			row.put("SADJKY", sadjky);
			row.put("SADJIT", sadjit);
			//차감 대상을 먼저 돌린다 조회쿼리애 STOKKY가 존재하므로 재조회는 생략  내부에서 FOR UPDATE르 재고를 잡으니 기타벨리데이션 생략
			sadjit = adjustmentService.createAdjdiFromSTK(row);

			DataMap adjdi = (DataMap)row.clone();
			adjdi.put("STOKKY", "");
			adjdi.put("LOTNUM", "");
			adjdi.put("SADJKY", sadjky);
			adjdi.put("SADJIT", sadjit);
			adjdi.put("LOCAKY", row.getString("LOCATG"));
			 
			//이동할 위치로 ADJDI  생성 
			sadjit = adjustmentService.createAdjdi(adjdi);
		}
		
		rsMap.put("RESULT", sadjky);
		
		return rsMap;
	}
	
	//[RL09] 이동 validate 체크
	@Transactional(rollbackFor = Exception.class)
	public void validateMove(DataMap map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map.getList("list");;
		String appendQuery = "";
		
		for(DataMap adjdi : itemList){
			
			if (!appendQuery.toString().equals("")) {
				appendQuery += " UNION \n";
			}
			
			appendQuery += "SELECT '" + adjdi.getString("ROWSEQUENCE") + "' AS ROWSEQ,";
			appendQuery += "'" + adjdi.getString("QTADJU") + "' AS QTADJU,";
			appendQuery += "'" + adjdi.getString("STOKKY") + "' AS STOKKY,";
			appendQuery += "'" + adjdi.getString("SKUKEY") + "' AS SKUKEY,";
			appendQuery += "'" + adjdi.getString("WAREKY") + "' AS WAREKY,";
			appendQuery += "'" + adjdi.getString("LOCAKY") + "' AS LOCAKY,";
			appendQuery += "'" + adjdi.getString("TRUNTY") + "' AS TRUNTY";
			appendQuery += " FROM DUAL";
		}
		
		map.put("APPENDQUERY", appendQuery);
		map.setModuleCommand("Report", "RL09_VALIDATE_ADJDI");
		List<DataMap> resultValidate = commonDao.getList(map);
		
		for(DataMap resultMap : resultValidate){
			String rowseq = resultMap.getString("ROWSEQ");
			
			double qtadju = Double.valueOf(resultMap.getString("QTADJU"));
			double qtsavl = 0d;//재고 가용 재고
			
			String locaky = resultMap.getString("LOCAKY");
			String locma_locaky  = resultMap.getString("LOCMA_LOCAKY");
			
			String trunty = resultMap.getString("TRUNTY");
			String tutma_trnuty = resultMap.getString("TUTMA_TRNUTY");
			
			String shpcmpyn = resultMap.getString("SHPCMPYN");
			String skukey = resultMap.getString("SKUKEY");
			String shpoky = resultMap.getString("SHPOKY");
			
			//수량 검사
			//조정수량이 음수이면 가용재고 수량을 검사한다.
			if (qtadju < 0) {
				qtsavl = Double.valueOf(resultMap.getString("QTSAVL"));
				if ((qtsavl - qtadju) < 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005", new String[]{}));
				}
			}
			// Target location검사
			if (locma_locaky.isEmpty()) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0011", new String[]{}));
			}
			// Target ttruty 검사
			if (!trunty.trim().isEmpty() && tutma_trnuty.trim().isEmpty()) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0012", new String[]{}));
			}
			if(shpcmpyn == null || shpcmpyn.equals("N")){
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0142", new String[]{}));
			}
		}
	}
	
	//[SD04] 배차이력조회
	@Transactional(rollbackFor = Exception.class)
	public List displaySD04(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		map.setModuleCommand("InventoryReport", "SD04");
			
		//RANGE_SQL
		SqlUtil sqlUtil = new SqlUtil();
		
		List keyList1 = new ArrayList<>();
		keyList1.add("B.DEPART");
		keyList1.add("B.CARDAT");
		keyList1.add("B.CARNUM");	
		keyList1.add("A.OWNRKY");
		keyList1.add("A.WAREKY");
		
		DataMap changeMap = new DataMap();
		changeMap.put("B.CARDAT", "B.RECDAT");
		changeMap.put("B.CARNUM", "B.RECNUM");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1, changeMap));
		
		List keyList = new ArrayList<>();
		keyList.add("B.DEPART");
		keyList.add("B.CARDAT");
		keyList.add("B.CARNUM");	
		keyList.add("A.OWNRKY");
		keyList.add("A.WAREKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
																
		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	  // [RL38] 조회
	  @Transactional(rollbackFor = Exception.class)
	  public List displayRL38(DataMap map) throws SQLException {
	  
	    SqlUtil sqlUtil = new SqlUtil();

	    List keyList2 = new ArrayList<>();
	    keyList2.add("PP.STDDAT");
	    DataMap changeMap2 = new DataMap();
	    changeMap2.put("PP.STDDAT", "SR.CARDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2));

	    map.setModuleCommand("Report", "RL38");
	    List<DataMap> list = commonDao.getList(map);
	    
	    return list;

	  }
	  
	  // [RL38] 조회
	  @Transactional(rollbackFor = Exception.class)
	  public List displayHP28(DataMap map) throws SQLException {
	  
	    SqlUtil sqlUtil = new SqlUtil();

	    List keyList2 = new ArrayList<>();
	    keyList2.add("SR.CARDAT");
	    DataMap changeMap2 = new DataMap();
	    changeMap2.put("SR.CARDAT", "RH.DOCDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2));

	    map.setModuleCommand("Report", "HP28");
	    List<DataMap> list = commonDao.getList(map);
	    
	    return list;

	  }
	  
	  // [HP22] 조회
	  @Transactional(rollbackFor = Exception.class)
	  public List displayHP22(DataMap map) throws SQLException {
	  
	    SqlUtil sqlUtil = new SqlUtil();

	    List keyList2 = new ArrayList<>();
	    keyList2.add("SR.CARDAT");
	    DataMap changeMap2 = new DataMap();
	    changeMap2.put("SR.CARDAT", "RH.DOCDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2));

	    map.setModuleCommand("Report", "HP22");
	    List<DataMap> list = commonDao.getList(map);
	    
	    return list;

	  }
	  
	  // [HP26] 조회
	  @Transactional(rollbackFor = Exception.class)
	  public List displayHP26(DataMap map) throws SQLException {
	  
		String sqlId  = "HP26_"+map.getString("TABNUM");
		  
	    SqlUtil sqlUtil = new SqlUtil();
	    List keyList = new ArrayList<>();
	    keyList.add("SKY.SKUKEY");
	    keyList.add("SKY.DESC01");
	    keyList.add("SMA.SKUG03");
	    keyList.add("SMA.ASKU02");
	    
	    DataMap changeMap = new DataMap();
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));

	    List keyList2 = new ArrayList<>();
	    keyList2.add("SKY.SKUKEY");
	    keyList2.add("SKY.DESC01");
	    keyList2.add("Z1T.CLASS1||Z1T.CLASS2||Z1T.CLASS3||Z1T.CLASS4");
	    keyList2.add("Z1T.USE_TYPE");
	    DataMap changeMap2 = new DataMap();
	    changeMap2.put("SKY.SKUKEY", "L2T.PRODCD");
	    changeMap2.put("SKY.DESC01", "SF_GET_PRODNM(L2T.PRODCD)");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromListChangeAlias((DataMap)map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap2));

	    map.setModuleCommand("Report", sqlId);
	    List<DataMap> list = commonDao.getList(map);
	    
	    return list;

	  }
	  
	 //[HP34] SAVE /// 생성, 추가, 삭제  
	   @SuppressWarnings("unchecked")
	   @Transactional(rollbackFor = Exception.class)
	   public String saveHP34(DataMap map) throws Exception {
	      String result = "F";
	      DataMap row;
	      String rowState;
	      List<DataMap> gridList = map.getList("list");
	      
	      int count = 0;
	      String wareky = gridList.get(0).getMap("map").getString("WAREKY");
//	      String wareky = "";
//	      String addr01 = "";
//	      String teln01 = "";
//	      String i_sampky = "";
	      int itemNum = 0;
	      String item = "";
	        
	      //그리드1 저장 시작
	      for(int  i = 0; i < gridList.size(); i++){
	          DataMap param = new DataMap();
	          
	          row = gridList.get(i).getMap("map");
	          rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
	          map.clonSessionData(row);
	          row.setModuleCommand("Report", "HP34");
	          
	          if( rowState.equals("C")){
	             item = row.getString("SAMSEQ");
	             //SAMSEQ 구하기
	             if(item.equals("")){
//	                itemNum = Integer.parseInt(item);
//	                itemNum += 100;
//	                item = String.valueOf(itemNum);
	                map.setModuleCommand("Report", "GETSAMSEQ");
	                item = commonDao.getMap(map).getString("SAMSEQ");
	             }
	             
	             row.put("SAMSEQ", item);
	             commonDao.insert(row);
	             count++;
	            
	         }else if(rowState.equals("U")){
	            commonDao.update(row);
	            count++;
	         }
	      
	         if(rowState.equals("D")){
	            commonDao.delete(row);
	            count++;
	         }
	      }   
	      
	      if(count > 0) result = "OK"; 
	      return result;
	   }

	   
}
