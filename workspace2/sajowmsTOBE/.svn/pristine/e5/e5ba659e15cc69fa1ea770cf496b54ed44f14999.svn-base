package project.wms.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import project.common.util.ComU;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

@Service("outBoundReportService")
public class OutBoundReportService extends BaseService {

	static final Logger log = LogManager.getLogger(SystemMagService.class.getName());

	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonLabel commonLabel;

	@Autowired
	private CommonService commonService;

	// [DL51] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL51(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;

		try {

			// 헤드 아이템 데이터 가져오
			List<DataMap> headList = map.getList("head");
			List<DataMap> itemList = map.getList("item");
			List<DataMap> resultShpdhList = new ArrayList<DataMap>();
			;
			List<DataMap> shpdhUpBatchList = new ArrayList<DataMap>();
			;

			for (DataMap shpdh : headList) {
				int grpoit = 0;
				/// 그리드에서 보낸 맵은 반드시 getMap("map")할것
				shpdh = shpdh.getMap("map");

				DataMap upParams = new DataMap();
				upParams.put("SHPOKY", shpdh.getString("SHPOKY"));
				upParams.put("CARNUM", shpdh.getString("CARNUM"));
				upParams.put("CARDAT", shpdh.getString("CARDAT"));
				upParams.put("SHIPSQ", shpdh.getString("SHIPSQ"));

				if (shpdh.getString("DOCSEQ").trim().equals("") || shpdh.getString("DOCSEQ") == null || shpdh.getString("DOCSEQ").trim().equals("N")) {

					shpdh.setModuleCommand("OutBoundReport", "GET_SHPDOC_SEQ");
					upParams.put("DOCSEQ", commonDao.getMap(shpdh).getString("DOCSEQ"));

				} else {
					upParams.put("DOCSEQ", shpdh.getString("DOCSEQ"));
				}

				shpdhUpBatchList.add(upParams);
				resultShpdhList.add(shpdh);

				for (DataMap shpdhUp : shpdhUpBatchList) {
					if (shpdhUpBatchList.size() > 0) {
						shpdhUp.setModuleCommand("OutBoundReport", "SHPDR_PRINT");
						resultChk = (int) commonDao.update(shpdhUp);
						if (resultChk == 0) {
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
									new String[] { "" });
							throw new Exception("* 배차데이터가 없습니다. *");
						}
					}
				}

			}

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	// [DL51] SAVE2
	@Transactional(rollbackFor = Exception.class)
	public DataMap save2DL51(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;

		try {

			// 헤드 아이템 데이터 가져오
			List<DataMap> headList = map.getList("head");
			List<DataMap> itemList = map.getList("item");
			List<DataMap> resultShpdhList = new ArrayList<DataMap>();
			;
			List<DataMap> shpdhUpBatchList = new ArrayList<DataMap>();
			;

			String chk_cardat = ""; // 배송일자
			String chk_dptnky = ""; // 거래처코드
			String chk_shpmty = ""; // 문서타입
			String chk_pgrc02 = ""; // 직송구분
			String chk_pgrc03 = ""; // 주문구분
			String chk_docseq = ""; // 거래명세표 출력번호

			for (DataMap shpdh : headList) {
				int grpoit = 0;
				/// 그리드에서 보낸 맵은 반드시 getMap("map")할것
				shpdh = shpdh.getMap("map");

				DataMap upParams = new DataMap();
				upParams.put("SHPOKY", shpdh.getString("SHPOKY"));
				upParams.put("CARNUM", shpdh.getString("CARNUM"));
				upParams.put("CARDAT", shpdh.getString("CARDAT"));
				upParams.put("SHIPSQ", shpdh.getString("SHIPSQ"));

				if (shpdh.getString("DOCSEQ").trim().equals("")
						&& (!shpdh.getString("SHPMTY").equals("213") && !shpdh.getString("SHPMTY").equals("214"))
						&& (!shpdh.getString("PGRC03").equals("004") && !shpdh.getString("PGRC02").equals("02"))) {
					// - 문서타입(SHPMTY) : 213 할증출고/214 무상출고 / - 주문구분(PGRC03) : 4
					// 유통EDI - 직송구분(PGRC02): 02 공장 직송 제외
					if (shpdh.getString("CARDAT").equals(chk_cardat) && shpdh.getString("DPTNKY").equals(chk_dptnky)
							&& shpdh.getString("SHPMTY").equals(chk_shpmty)
							&& shpdh.getString("PGRC03").equals(chk_pgrc03)
							&& shpdh.getString("PGRC02").equals(chk_pgrc02)) { // 배송일자,
																				// 거래처코드,
																				// 문서타입,
																				// 직송구분,
																				// 주문구분이
																				// 같을
																				// 경우
						upParams.put("DOCSEQ", chk_docseq);
					} else {
						shpdh.setModuleCommand("OutBoundReport", "GET_SHPDOC_SEQ");
						chk_docseq = commonDao.getMap(shpdh).getString("DOCSEQ");
						upParams.put("DOCSEQ", chk_docseq);
					}
				}

				shpdhUpBatchList.add(upParams);
				resultShpdhList.add(shpdh);
				chk_cardat = shpdh.getString("CARDAT");
				chk_dptnky = shpdh.getString("DPTNKY");
				chk_shpmty = shpdh.getString("SHPMTY");
				chk_pgrc02 = shpdh.getString("PGRC03");
				chk_pgrc03 = shpdh.getString("PGRC02");

				/*
				 * if(shpdhUpBatchList.size() > 0){
				 * super.nativeBatchUpdate("OUTBOUND.DL51.UPDATE_SHPDR",
				 * shpdhUpBatchList); }
				 */
				for (DataMap shpdhUp : shpdhUpBatchList) {
					if (shpdhUpBatchList.size() > 0) {
						shpdhUp.setModuleCommand("OutBoundReport", "SHPDR_PRINT");
						resultChk = (int) commonDao.update(shpdhUp);
						if (resultChk == 0) {
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
									new String[] { "" });
							throw new Exception("* 배차데이터가 없습니다. *");
						}
					}
				}

			}

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	// [DL51] SAVE3
	@Transactional(rollbackFor = Exception.class)
	public DataMap save3DL51(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;

		try {

			// 헤드 아이템 데이터 가져오
			List<DataMap> headList = map.getList("head");
			List<DataMap> itemList = map.getList("item");
			List<DataMap> resultShpdhList = new ArrayList<DataMap>();
			;
			List<DataMap> shpdhUpBatchList = new ArrayList<DataMap>();
			;

			String chk_cardat = ""; // 배송일자
			String chk_dptnky = ""; // 거래처코드
			String chk_pgrc03 = ""; // 주문구분

			for (DataMap shpdh : headList) {
				int grpoit = 0;
				/// 그리드에서 보낸 맵은 반드시 getMap("map")할것
				shpdh = shpdh.getMap("map");

				DataMap upParams = new DataMap();
				upParams.put("SHPOKY", shpdh.getString("SHPOKY"));
				upParams.put("CARNUM", shpdh.getString("CARNUM"));
				upParams.put("CARDAT", shpdh.getString("CARDAT"));
				upParams.put("SHIPSQ", shpdh.getString("SHIPSQ"));

				if (shpdh.getString("DOCSEQ").trim().equals("") || shpdh.getString("SHPMTY") == null) {
					// - 문서타입(SHPMTY) : 213 할증출고/214 무상출고 / - 주문구분(PGRC03) : 4
					// 유통EDI - 직송구분(PGRC02): 02 공장 직송 제외
					if (shpdh.getString("CARDAT").equals(chk_cardat) && shpdh.getString("DPTNKY").equals(chk_dptnky)
							&& shpdh.getString("PGRC03").equals(chk_pgrc03)) { // 배송일자,
																				// 거래처코드,
																				// 문서타입,
																				// 직송구분,
																				// 주문구분이
																				// 같을
																				// 경우
						upParams.put("DOCSEQ", commonDao.getMap(shpdh).getString("DOCSEQ"));
					} else {
						shpdh.setModuleCommand("OutBoundReport", "GET_SHPDOC_SEQ");
						upParams.put("DOCSEQ", commonDao.getMap(shpdh).getString("DOCSEQ"));
					}
				} else {
					upParams.put("DOCSEQ", shpdh.getString("DOCSEQ"));
				}

				shpdhUpBatchList.add(upParams);
				resultShpdhList.add(shpdh);
				chk_cardat = shpdh.getString("CARDAT");
				chk_dptnky = shpdh.getString("DPTNKY");
				chk_pgrc03 = shpdh.getString("PGRC02");

				/*
				 * if(shpdhUpBatchList.size() > 0){
				 * super.nativeBatchUpdate("OUTBOUND.DL51.UPDATE_SHPDR",
				 * shpdhUpBatchList); }
				 */
				for (DataMap shpdhUp : shpdhUpBatchList) {
					if (shpdhUpBatchList.size() > 0) {
						shpdhUp.setModuleCommand("OutBoundReport", "SHPDR_PRINT");
						resultChk = (int) commonDao.update(shpdhUp);
						if (resultChk == 0) {
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
									new String[] { "" });
							throw new Exception("* 배차데이터가 없습니다. *");
						}
					}
				}

			}

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}
	
	// [DL52] SAVE 프린트
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL52(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		String chk_dptnky = ""; // 거래처코드

		try {
			// 헤드 아이템 데이터 가져오
			List<DataMap> list = map.getList("list");
			List<DataMap> resultShpdhList = new ArrayList<DataMap>();
			List<DataMap> shpdhUpBatchList = new ArrayList<DataMap>();

			for (DataMap shpdh : list) {
				/// 그리드에서 보낸 맵은 반드시 getMap("map")할것
				shpdh = shpdh.getMap("map");
				DataMap upParams = new DataMap();
				upParams.put("SHPOKY", shpdh.getString("SHPOKY"));
				upParams.put("CARNUM", shpdh.getString("CARNUM"));
				upParams.put("CARDAT", shpdh.getString("CARDAT"));
				upParams.put("SHIPSQ", shpdh.getString("SHIPSQ"));

				if (shpdh.getString("DOCSEQ").trim().equals("") || shpdh.getString("DOCSEQ") == null || shpdh.getString("DOCSEQ").trim().equals("N")) {
					shpdh.setModuleCommand("OutBoundReport", "GET_SHPDOC_SEQ");
					upParams.put("DOCSEQ", commonDao.getMap(shpdh).getString("DOCSEQ"));

				} else {
					upParams.put("DOCSEQ", shpdh.getString("DOCSEQ"));
				}

				shpdhUpBatchList.add(upParams);
				resultShpdhList.add(shpdh);
				chk_dptnky = shpdh.getString("DPTNKY");

				for (DataMap shpdhUp : shpdhUpBatchList) {
					if (shpdhUpBatchList.size() > 0) {
						shpdhUp.setModuleCommand("OutBoundReport", "SHPDR_PRINT");
						resultChk = (int) commonDao.update(shpdhUp);
						if (resultChk == 0) {
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
									new String[] { "" });
							throw new Exception("* 배차데이터가 없습니다. *");
						}
					}
				}

			}

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}


	// [DL33] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL33(DataMap map) throws Exception {

		map.setModuleCommand("OutBoundReport", "DL33");

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>(); //Range
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); //RangeSearch1
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("NVL(TRIM(WH.NAME01),BZ.NAME01)");/****/
		keyList2.add("BZ.PTNG01");
		keyList2.add("BZ.PTNG02");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>(); //RangeSearchItem2
		keyList3.add("S.SKUG02");
		keyList3.add("S.SKUG03");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList4 = new ArrayList<>(); //RangeSearchItem
		keyList4.add("S.SKUKEY");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));
//		System.out.println(map.getString("CHKMAK"));
		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	/*
	 * // [DL41] 조회
	 * 
	 * @Transactional(rollbackFor = Exception.class) public List
	 * displayDL41(DataMap map) throws Exception {
	 * 
	 * map.setModuleCommand("OutBoundReport", "DL41_HEAD");
	 * 
	 * SqlUtil sqlUtil = new SqlUtil(); List keyList = new ArrayList<>();
	 * keyList.add("TASDH.TASOTY"); keyList.add("S.AREAKY");
	 * keyList.add("TASDH.TASKKY"); keyList.add("TASDH.DOCDAT");
	 * keyList.add("TASDH.STATDO"); keyList.add("S.SHPOKY");
	 * keyList.add("SR.CARDAT"); keyList.add("SR.SHIPSQ");
	 * keyList.add("SR.CARNUM"); keyList.add("S.SVBELN");
	 * keyList.add("S.STKNUM"); map.put("RANGE_SQL",
	 * sqlUtil.getRangeSqlFromList((DataMap)
	 * map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
	 * 
	 * List<DataMap> list = commonDao.getList(map);
	 * 
	 * return list; }
	 */

	// [DL97] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL97(DataMap map) throws Exception {

		String str = map.get("rangeItem").toString();
		String sqlKey = "";

		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);

		if (map.getString("OWNRKY").equals("2200")) {
			map.setModuleCommand("OutBoundReport", "DL97_HEAD_DR");
		} else {
			map.setModuleCommand("OutBoundReport", "DL97_HEAD");
		}
		// List<IFWMS113Entity> resultList = super.nativeQueryForList(sqlKey,
		// map, IFWMS113Entity.class);

		SqlUtil sqlUtil = new SqlUtil();

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.WARESR");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// rangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("I.SKUKEY");
		keyList3.add("S.ASKU02");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	// [DL97] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL97Item(DataMap map) throws Exception {
	
		map.setModuleCommand("OutBoundReport", "DL97_ITEM");

		SqlUtil sqlUtil = new SqlUtil();
		
		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.WARESR");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
		
		List<DataMap> list = commonDao.getList(map);
		
		return list;
	}

	// [DL97] 저장
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL97(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		DataMap itemData; // 아이템을 담는다.
		int resultChk = 0;
		// List<DataMap> list = map.getList("list");
		HashMap<String, String> sqlParams = new HashMap<String, String>();

		try {

			List<DataMap> itemList = map.getList("item");
			String skukeys = ""; 
			String svbelns = ""; 

			for (int i=0;i<itemList.size();i++) {
				itemData = itemList.get(i).getMap("map");
				map.clonSessionData(itemData);
				
				// validateIfwms113ModifyCheckingS(item);
				itemData.setModuleCommand("OutBoundReport", "DL97_VALI");
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

				itemData.setModuleCommand("OutBoundReport", "DL97");
				commonDao.update(itemData);
				rsMap.put("RESULT", "S");
				
				String skukey = itemData.getString("SKUKEY");
		        if (i==0) {
		        	skukeys = "'"+skukey+"'";
		        } else {
		        	skukeys += (","+"'"+skukey+"'"); 
		        }
		        String svbeln = itemData.getString("SVBELN");
		        if (i==0) {
		        	svbelns = "'"+svbeln+"'";
		        } else {
		        	svbelns += (","+"'"+svbeln+"'"); 
		        }
			}
			rsMap.put("gridItemList", itemList);
			rsMap.put("SKUKEYS", skukeys);
			rsMap.put("SVBELNS", svbelns);

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	// [dl98] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL98(DataMap map) throws Exception {

		if (map.getString("SOGUBN").equals("ALL")) {
			map.setModuleCommand("OutBoundReport", "DL98_ALL");
		} else if (map.getString("SOGUBN").equals("WMS")) {
			map.setModuleCommand("OutBoundReport", "DL98_WMS");
		} else if (map.getString("SOGUBN").equals("S/O")) {
			map.setModuleCommand("OutBoundReport", "DL98_SO");
		}

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList1 = new ArrayList<>();
		keyList1.add("DH.UNAME4");
		keyList1.add("DH.DNAME4");
		keyList1.add("SM.ASKU02");
		keyList1.add("BZ.NAME03");
		keyList1.add("DH.SHPOKY");
		keyList1.add("DH.PGRC02");
		keyList1.add("DI.SVBELN");
		keyList1.add("DH.DOCUTY");
		keyList1.add("DH.RQSHPD");
		keyList1.add("DH.RQARRD");
		keyList1.add("DH.DPTNKY");
		keyList1.add("DH.PTRCVR");
		keyList1.add("DH.PGRC04");
		keyList1.add("SA.NAME01");
		keyList1.add("DI.SKUKEY");
		keyList1.add("SM.DESC01");
		keyList1.add("DH.PGRC03");
		keyList1.add("DR.CARDAT");
		keyList1.add("DR.CARNUM");
		keyList1.add("DR.SHIPSQ");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList1));

		// RangeSearch2
		List keyList2 = new ArrayList<>();
		keyList2.add("DH.UNAME4");
		keyList2.add("DH.DNAME4");
		keyList2.add("SM.ASKU02");
		keyList2.add("BZ.NAME03");
		keyList2.add("DH.PGRC02");
		keyList2.add("DH.SHPOKY");
		keyList2.add("DI.SVBELN");
		keyList2.add("DH.DOCUTY");
		keyList2.add("DH.RQSHPD");
		keyList2.add("DH.RQARRD");
		keyList2.add("DH.DPTNKY");
		keyList2.add("DH.PTRCVR");
		keyList2.add("DH.PGRC04");
		keyList2.add("SA.NAME01");
		keyList2.add("DI.SKUKEY");
		keyList2.add("SM.DESC01");
		keyList2.add("DH.PGRC03");
		keyList2.add("DR.CARDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [DL99] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL99(DataMap map) throws Exception {

		String str = map.get("rangeItem").toString();
		String ownrky = map.get("OWNRKY").toString();
		String sqlKey = "";
		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!=")){
			map.put("FLAG", "NOT");}
		else{
			map.put("FLAG", "IN");}

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);
		if (map.getString("OWNRKY").equals("2100") || map.getString("OWNRKY").equals("2500")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD");
		} else if (map.getString("OWNRKY").equals("2200")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD_DR");
		}

		SqlUtil sqlUtil = new SqlUtil();

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		// RangeItem2
		List keyList4 = new ArrayList<>();
		keyList4.add("S.OWNRKY");
		keyList4.add("W.WAREKY");
		//keyList4.add("C.CARNUM");
		keyList4.add("S.SKUG02");
		keyList4.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));
		
		
		List keyList5 = new ArrayList<>();
		keyList5.add("S.ASKU02");
		map.put("RANGE_SQL5", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5));

		// RangeItem
		List keyList6 = new ArrayList<>();
		keyList6.add("SKUKEY");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("SKUKEY", "S.SKUKEY");
		map.put("RANGE_SQL6", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList6, changeMap2));

		
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL99] 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL99Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");

		String str = map.get("rangeItem").toString();

		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!=")){
			map.put("FLAG", "NOT");
		}else{
			map.put("FLAG", "IN");
		}	
		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);

		map.setModuleCommand("OutBoundReport", "DL99_ITEM");

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList6 = new ArrayList<>();
		keyList6.add("S.ASKU02");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("S.ASKU02", "SM.ASKU02");
		map.put("RANGE_SQL6", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList6, changeMap2));

		List<DataMap> list1 = commonDao.getList(map);

		return list1;
	}

	// [DL99] 저장
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL99(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		DataMap itemData; // 아이템을 담는다.
		int resultChk = 0;
		// List<DataMap> list = map.getList("list");
		HashMap<String, String> sqlParams = new HashMap<String, String>();

		try {

			List<DataMap> itemList = map.getList("item");
			String skukeys = ""; 
			String svbelns = ""; 

			for (int i=0;i<itemList.size();i++) {
				itemData = itemList.get(i).getMap("map");
				map.clonSessionData(itemData);
				// validateIfwms113ModifyCheckingS(item);
				itemData.setModuleCommand("OutBoundReport", "DL97_VALI");
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

				itemData.setModuleCommand("OutBoundReport", "DL99");
				commonDao.update(itemData);

				rsMap.put("RESULT", "S");
				
				String skukey = itemData.getString("SKUKEY");
				if (i==0) {
					skukeys = "'"+skukey+"'";
				} else {
					skukeys += (","+"'"+skukey+"'"); 
				}
				String svbeln = itemData.getString("SVBELN");
				if (i==0) {
					svbelns = "'"+svbeln+"'";
				} else {
					svbelns += (","+"'"+svbeln+"'"); 
				}
				rsMap.put("SKUKEYS", skukeys);
				rsMap.put("SVBELNS", svbelns);
				
			}
			rsMap.put("gridItemList", itemList);

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	
	// [DL99] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL55(DataMap map) throws Exception {

		String str = map.get("rangeItem").toString();
		String ownrky = map.get("ownrky").toString();
		String sqlKey = "";
		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);

		if (map.getString("OWNRKY").equals("2100") || map.getString("OWNRKY").equals("2500")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD");
		} else if (map.getString("OWNRKY").equals("2200")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD_DR");
		}

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		// RangeItem
		List keyList4 = new ArrayList<>();
		keyList3.add("C.CARNUM");
		keyList3.add("S.SKUG02");
		keyList3.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.ASKU02");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		
		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	
	// [DL88] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL88(DataMap map) throws Exception {

		String str = map.get("rangeItem").toString();
		String ownrky = map.get("ownrky").toString();
		String sqlKey = "";
		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);

		if (map.getString("OWNRKY").equals("2100") || map.getString("OWNRKY").equals("2500")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD");
		} else if (map.getString("OWNRKY").equals("2200")) {
			map.setModuleCommand("OutBoundReport", "DL99_HEAD_DR");
		}

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");

		DataMap changeMap = new DataMap();
		changeMap.put("SKUKEY", "S.SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList3, changeMap));

		// RangeItem
		List keyList4 = new ArrayList<>();
		keyList4.add("C.CARNUM");
		keyList4.add("S.SKUG02");
		keyList4.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.ASKU02");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		// RangeItem
		List keyList5 = new ArrayList<>();
		keyList5.add("SKUKEY");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("SKUKEY", "S.SKUKEY");
		map.put("RANGE_SQL6", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList5, changeMap2));

		//List keyList6 = new ArrayList<>();
		//keyList6.add("S.ASKU02");
		//map.put("RANGE_SQL7", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList6));
		
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	// [DL99] 아이템 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayDL55Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");

		String str = map.get("rangeItem").toString();

		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);

		map.setModuleCommand("OutBoundReport", "DL99_ITEM");

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("NVL(TRIM(WH.NAME01),BZ.NAME01)");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		// RangeItem2
		List keyList4 = new ArrayList<>();
		keyList4.add("S.OWNRKY");
		keyList4.add("W.WAREKY");
		keyList4.add("C.CARNUM");
		keyList4.add("S.SKUG02");
		keyList4.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY"); 
		keyList.add("S.ASKU02");
		keyList.add("SKUKEY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList6 = new ArrayList<>();
		keyList6.add("S.ASKU02");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("S.ASKU02", "SM.ASKU02");
		map.put("RANGE_SQL6", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList6, changeMap2));

		
		List<DataMap> list1 = commonDao.getList(map);

		return list1;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List displayDL84(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> list = map.getList("list");
		  
		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.QTYORG");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.WARESR");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		keyList2.add("ASKU05");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));
			
		map.setModuleCommand("Outbound", "ORDER_NOT_CLOSED_ITEM");
		List<DataMap> list1 = commonDao.getList(map);
		  
		return list1;
	  }
	
	// [DL99] 부족수량 오더 리스트(All)
	@Transactional(rollbackFor = Exception.class)
	public List displayDL88Item2(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");

		String str = map.get("rangeItem").toString();

		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);
			
		String sbChk = "";
		sbChk += "AND  I.SKUKEY IN ( " + map.getString("SKUKEY") + ")";

		map.setModuleCommand("OutBoundReport", "DL88_ITEM2");

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("NVL(TRIM(WH.NAME01),BZ.NAME01)");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		// RangeItem2
		List keyList4 = new ArrayList<>();
		keyList4.add("S.OWNRKY");
		keyList4.add("W.WAREKY");
		keyList4.add("C.CARNUM");
		keyList4.add("S.SKUG02");
		keyList4.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY"); 
		keyList.add("S.ASKU02");
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));
		


		List keyList6 = new ArrayList<>();
		keyList6.add("S.ASKU02");
		
		DataMap changeMap2 = new DataMap();
		changeMap2.put("S.ASKU02", "SM.ASKU02");
		map.put("RANGE_SQL5", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList6, changeMap2));
		
		List<DataMap> list1 = commonDao.getList(map);

		return list1;
	}
	
	// [DL88] 오더 리스트(All)
	@Transactional(rollbackFor = Exception.class)
	public List displayDL88Item3(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");

		String str = map.get("rangeItem").toString();

		String beginStr = "<";
		String endStr = ">";
		String strSqlFlag = "";
		int beginIndex = str.indexOf(beginStr);
		if (beginIndex != -1) {
			int endIndex = str.indexOf(endStr, beginIndex);
			if (endIndex != -1) {
				strSqlFlag = str.substring(beginIndex, endIndex + 1);
			}
		}

		String beginStr2 = "!";
		String endStr2 = "=";
		String strSqlFlag2 = "";
		int beginIndex2 = str.indexOf(beginStr2);
		if (beginIndex2 != -1) {
			int endIndex2 = str.indexOf(endStr2, beginIndex2);
			if (endIndex2 != -1) {
				strSqlFlag2 = str.substring(beginIndex2, endIndex2 + 1);
			}
		}

		if (strSqlFlag.equals("<>") || strSqlFlag2.equals("!="))
			map.put("FLAG", "NOT");
		else
			map.put("FLAG", "IN");

		String strTemp = str.replace("<>", "=");
		String strSql = strTemp.replace("!=", "=");
		String strSql2 = strSql.replace(">=", "=");
		String strSql3 = strSql2.replace("AND", "OR");
		map.put("rangeItem", strSql3);
			
		String sbChk = "";
		sbChk += "AND  I.SKUKEY IN ( " + map.getString("SKUKEY") + ")";

		map.setModuleCommand("OutBoundReport", "DL88_ITEM3");

		SqlUtil sqlUtil = new SqlUtil();

		// RangeSearch1
		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.WARESR");
		keyList2.add("NVL(TRIM(WH.NAME01),BZ.NAME01)");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		// RangeItem
		List keyList3 = new ArrayList<>();
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		// RangeItem2
		List keyList4 = new ArrayList<>();
		keyList4.add("S.OWNRKY");
		keyList4.add("W.WAREKY");
		keyList4.add("C.CARNUM");
		keyList4.add("S.SKUG02");
		keyList4.add("S.SKUG03");
		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		// Range
		List keyList = new ArrayList<>();
		keyList.add("S.LOTA05");
		keyList.add("S.LOTA06");
		keyList.add("S.LOCAKY"); 
		keyList.add("S.ASKU02");
		keyList3.add("SKUKEY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList6 = new ArrayList<>();
		keyList6.add("S.ASKU02");
		DataMap changeMap2 = new DataMap();
		changeMap2.put("S.ASKU02", "SM.ASKU02");
		map.put("RANGE_SQL5", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),keyList6, changeMap2));
		
		List<DataMap> list1 = commonDao.getList(map);

		return list1;
	}
	
	// [DL88] 저장
	@Transactional(rollbackFor = Exception.class)
	public List allocSaveDL88(DataMap map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		DataMap clsMap = new DataMap();
		
		try {
			List<DataMap> itemList = map.getList("item");
			DataMap ifwms = new DataMap();
			DataMap sqlParams = new DataMap();
			
			String appendQuery = "";
			String temp_ide = "";
			
			for(DataMap item : itemList){
				ifwms = item.getMap("map");
				
				if(appendQuery.length() > 0){
					appendQuery += ("\nUNION ALL\n");
				}else{ //첫바퀴 

			    	  //사용중인지 체크 
			    	  clsMap.put("WAREKY", ifwms.getString("WAREKY"));
			    	  clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
			    	  DataMap clsChk = commonDao.getMap(clsMap);
			    	  if(clsChk!=null && "Y".equals(clsChk.getString("CLSYN"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0155",new String[]{"* 다른 사용자가 작업중 입니다.. *"}));
			    	  
			    	  //clsyn update 활당중 접근불가(차수 구분위함)
			    	  clsMap.setModuleCommand("Outbound", "CLSYN"); 
			    	  clsMap.put("CLS_YN", "Y"); 
			          map.clonSessionData(clsMap);
			    	  commonDao.update(clsMap);
					
				}
				appendQuery += "SELECT '" + ifwms.getString("OWNRKY") + "' AS OWNRKY, "
						            + "'" + ifwms.getString("WAREKY") + "' AS WAREKY, "
						            + "'" + ifwms.getString("SVBELN") + "' AS SVBELN "
						            + "FROM DUAL";	
				
				sqlParams.put("SVBELN", ifwms.get("SVBELN"));
				sqlParams.put("SPOSNR", ifwms.get("SPOSNR"));
				sqlParams.put("ORDDAT", ifwms.get("ORDDAT"));
				sqlParams.put("SKUKEY", ifwms.get("SKUKEY"));
				sqlParams.put("CREUSR", map.get("CREUSR"));
				
				if(ifwms.getString("SVBELN").length() == 19){
					sqlParams.put("CHKSEQ", ifwms.getString("SVBELN").substring(9, 15));
					sqlParams.put("ORDTYP", ifwms.getString("SVBELN").substring(16, 19));
				}
				
				//영업시스템 주문서(길이19)을 재조회하여 삭제 여부 확인(정소명, 20160414)
				if(ifwms.getString("OWNRKY").equals("SAJOHP") && ifwms.getString("SVBELN").length() == 19){
					sqlParams.setModuleCommand("OutBoundReport", "DL97_VALI");
					DataMap result = commonDao.getMap(sqlParams);
					
					if(result == null){
						temp_ide += "아이템번호 : " + ifwms.getString("SPOSNR") + ", 제품코드 : " + ifwms.getString("SKUKEY") + " , \n";
					}
				}
				
				if(!temp_ide.equals("")){
					temp_ide = "S/O : " + ifwms.getString("SVBELN") + "\n" + temp_ide + "영업시스템 내 해당 주문서의 주문이 삭제되었습니다.\n미출 등록(영업오더관리)으로 주문을 삭제하시기 바랍니다.";
					throw new Exception(temp_ide);
				}
			}
			
			sqlParams.put("APPENDQUERY", appendQuery.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_SVBELN");
			List<DataMap> svbelnList = commonDao.getList(sqlParams);
			
			String searchkey = "";
			for(DataMap svbelnData : svbelnList){
				svbelnData = svbelnData.getMap("map");
				String msgStr = "";
				int outParamCnt = 0;	
				
				svbelnData.put("CREUSR", map.get("CREUSR"));
				svbelnData.setModuleCommand("OutBoundReport", "P_IFWMS113_CREATE_SHIPMENT");
				commonDao.update(svbelnData);
				
				if(searchkey.length() > 0){
					searchkey += " or";
				}
				searchkey += " svbeln='" + svbelnData.getString("SVBELN") + "'";
			}
			
			sqlParams.put("SVBELNS", searchkey.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI");
			rsList = commonDao.getList(sqlParams);

			clsMap.put("CLS_YN", "N"); 
			commonDao.update(clsMap);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		
		return rsList;
	}
	
	// [DL88] 미작업삭제
	@Transactional(rollbackFor = Exception.class)
	public List deleteNewDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		
		rsMap = removeShipmentOrderDocumentNEW(groupingShpokyList);
		
		return rsMap;
	}
	
	// [DL88] 미작업삭제 저장
	@Transactional(rollbackFor = Exception.class)
	public List removeShipmentOrderDocumentNEW(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}
				shpokys += " shpoky='" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_REMOVE_SHIPMENT_NEW");
				commonDao.update(sqlParams);
			}
			
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}
	
	// [DL88] 부분할당삭제 저장
	@Transactional(rollbackFor = Exception.class)
	public List deletePalDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		
		rsMap = removeShipmentOrderDocumentPAL(groupingShpokyList);
		
		return rsMap;
	}
	
	// [DL88] 부분할당삭제
	@Transactional(rollbackFor = Exception.class)
	public List removeShipmentOrderDocumentPAL(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}
				shpokys += " si.shpoky='" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_REMOVE_SHIPMENT_PAL");
				commonDao.update(sqlParams);
			}
			
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}	
	
	// [DL88] 전체삭제 저장
	@Transactional(rollbackFor = Exception.class)
	public List deleteDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		
		rsMap = removeShipmentOrderDocumentAll(groupingShpokyList);
		
		return rsMap;
	}
	
	// [DL88] 전체삭제
	@Transactional(rollbackFor = Exception.class)
	public List removeShipmentOrderDocumentAll(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}
				shpokys += " si.shpoky='" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_REMOVE_SHIPMENT");
				commonDao.update(sqlParams);
			}
			
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}
	
	// [DL88] 할당 저장
	@Transactional(rollbackFor = Exception.class)
	public List realLocDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		

		rsMap = doShipmentOrderReAllocateItem(groupingShpokyList, map);
		
		return rsMap;
	}
	
	// [DL88] 할당
	@Transactional(rollbackFor = Exception.class)
	public List doShipmentOrderReAllocateItem(List map, DataMap dataMap) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		DataMap clsMap = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}else{

			    	  //사용중인지 체크 
			    	  clsMap.put("WAREKY", item.getString("WAREKY"));
			    	  clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
			    	  DataMap clsChk = commonDao.getMap(clsMap);
			    	  if(clsChk!=null && "Y".equals(clsChk.getString("CLSYN"))) throw new Exception(commonService.getMessageParam("KO", "OUT_M0155",new String[]{"* 다른 사용자가 작업중 입니다.. *"}));
			    	  
			    	  //clsyn update 활당중 접근불가(차수 구분위함)
			    	  clsMap.setModuleCommand("Outbound", "CLSYN"); 
			    	  clsMap.put("CLS_YN", "Y"); 
			    	  clsMap.put("SES_USER_ID", dataMap.get("CREUSR")); 
			    	  commonDao.update(clsMap);
				}
				shpokys += " shpoky='" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.put("CREUSR", dataMap.get("CREUSR"));
				sqlParams.setModuleCommand("OutBoundReport", "P_BATCH_ALLOCATION");
				commonDao.update(sqlParams);
			}
			
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);

	    	  clsMap.put("CLS_YN", "N"); 
	    	  commonDao.update(clsMap);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}
	
	
	// [DL88] 할당취소 저장
	@Transactional(rollbackFor = Exception.class)
	public List unalLocDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		

		rsMap = doShipmentOrderUnAllocateItem(groupingShpokyList);
		
		return rsMap;
	}
	
	// [DL88] 할당취소
	@Transactional(rollbackFor = Exception.class)
	public List doShipmentOrderUnAllocateItem(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}
				shpokys += " shpoky='" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_UNALLO_SHIPMENT");
				commonDao.update(sqlParams);
			}
			
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}
	
	// [DL88] D/O전송 저장
	@Transactional(rollbackFor = Exception.class)
	public List drelinDL88(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		

		rsMap = doShipmentOrderUnAllocateItem(groupingShpokyList, map);
		
		return rsMap;
	}
	
	// [DL88] D/O전송
	@Transactional(rollbackFor = Exception.class)
	public List doShipmentOrderUnAllocateItem(List map, DataMap dataMap) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " or";
				}
				shpokys += " shpoky='" + item.getString("SHPOKY") + "'";
			}
			sqlParams.put("SHPOKYS", shpokys.toString());
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_SHPDH_DRELIN");
			List<DataMap> shpdhListTemp = commonDao.getList(sqlParams);
			
			for(DataMap shpdh: shpdhListTemp){
				shpdh = shpdh.getMap("map");
				
				if(shpdh.getString("DRELIN").equals("Y")){
					throw new Exception(commonService.getMessageParam(dataMap.getString("SES_LANGUAGE"), "OUT_M0134",new String[]{})); /* 이미 할당 컨펌 된 출하오더 입니다. */
					
				}else{
					shpdh.put("DRELIN", "V");
					shpdh.put("CREUSR", dataMap.get("CREUSR"));
					
					shpdh.setModuleCommand("OutBoundReport", "SHPDI");
					commonDao.update(shpdh);
					
					shpdh.setModuleCommand("OutBoundReport", "SHPDH");
					commonDao.update(shpdh);
				}
			}
			
			sqlParams.setModuleCommand("OutBoundReport", "DL88_FIND_SHPDI_SHPOKYS");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return rsList;
	}
	
	// [DL88] groupingShpoky
	@Transactional(rollbackFor = Exception.class)
	public List groupingShpoky(DataMap map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map.getList("item");
		
		String appendQuery = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(appendQuery.length() > 0){
					appendQuery += "\nUNION ALL\n";
				}
				appendQuery += "SELECT '" + item.getString("SHPOKY") + "' AS SHPOKY " + "FROM DUAL";
			}
			sqlParams.put("APPENDQUERY", appendQuery.toString());

			sqlParams.setModuleCommand("OutBoundReport", "DL88_GROUPING_SHPOKY");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){			
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}

		
		return rsList;
	}
}

