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
public class OyangOutboundService extends BaseService {

	static final Logger log = LogManager.getLogger(OyangOutboundService.class.getName());

	@Autowired
	public CommonDAO commonDao;

	@Autowired
	public CommonService commonService;

	@Autowired
	public POInterfaceManager poManager;

	@Autowired
	private ShipmentService shipmentService;

	@Autowired
	DaerimOutboundService daerimOutboundService;

	// [OY02] 출고지시
	@Transactional(rollbackFor = Exception.class)
	public DataMap acceptShpOrder(DataMap map) throws SQLException, Exception {
		DataMap rtnMap = new DataMap();
		DataMap row;
		String result = "Y";
		int comCnt = 0;
		StringBuffer rtnString = new StringBuffer();

		List<DataMap> headList = map.getList("head");

		// 출고지시 시작
		for (DataMap data : headList) {
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("STATUS", "30"); // 출고지시(인터페이스 픞레그)
			row.put("ORDERSEQ", map.get("ORDSEQ")); // 주문차수

			// PO호출 후 리턴플래그 초기화
			result = "Y";

			// 일반 출고나 사판에 경우 TOSS에 지시를 보낸다.
			if ("1".equals(row.getString("SVBELN").substring(0, 1))
					|| "5".equals(row.getString("SVBELN").substring(0, 1)) || "216".equals(row.getString("DOCUTY"))) {
				result = poManager.TOSS_NS0090(row.getString("SVBELN"), "Y", row.getString("STATUS"));
			}

			// TOSS 성공 또는 TOSS 안보낼 시
			if ("Y".equals(result)) {

				if (!"216".equals(row.getString("DOCUTY"))) {
					result = poManager.SAP_SD0340(row.getString("SVBELN"), row.getString("STATUS")); // SAP
																										// 출고지시처리
				}

				if (!"Y".equals(result))
					throw new Exception(commonService.getMessageParam(row.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "출고지시에 실패하였습니다.(SAP)" }));

				// IFWMS113 TABLE 플래그 UPDATE
				row.setModuleCommand("OyangOutbound", "IFWMS113_ACCEPT");
				commonDao.update(row);
				comCnt++;
			}

			if ("".equals(rtnString.toString())) {
				rtnString.append("'").append(row.getString("SVBELN")).append("'");
			} else {
				rtnString.append(",'").append(row.getString("SVBELN")).append("'");
			}

		}

		rtnMap.put("COMCNT", comCnt);
		rtnMap.put("RTNMSG", "총주문: '" + headList.size() + "'건 중에서 '" + comCnt + "'건이 성공했고 '"
				+ (headList.size() - comCnt) + "'건이 실패했습니다.");
		rtnMap.put("RESULT", "Y");
		rtnMap.put("SVBELNS", rtnString.toString());
		return rtnMap;
	}

	// [OY03] 출고지시 취소
	@Transactional(rollbackFor = Exception.class)
	public DataMap cancelAcceptShpOrder(DataMap map) throws SQLException, Exception {
		DataMap rtnMap = new DataMap();
		DataMap row;
		String result = "Y";
		int comCnt = 0;
		StringBuffer rtnString = new StringBuffer();

		List<DataMap> headList = map.getList("head");

		// 출고지시 시작
		for (DataMap data : headList) {
			row = data.getMap("map");
			map.clonSessionData(row);

			row.put("STATUS", "35"); // 출고지시 해제(인터페이스 픞레그)
			row.put("ORDERSEQ", map.get("ORDSEQ")); // 주문차수

			// PO호출 후 리턴플래그 초기화
			result = "Y";

			// 해제 가능여부 VALDATION
			row.setModuleCommand("OyangOutbound", "OY03_VALID");
			DataMap validMap = commonDao.getMap(row);
			if (validMap != null && !"".equals(validMap.getString("VALIDMSG")))
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { validMap.getString("VALIDMSG") }));

			// 일반 출고나 사판에 경우 TOSS에 지시를 보낸다.
			if ("1".equals(row.getString("SVBELN").substring(0, 1))
					|| "5".equals(row.getString("SVBELN").substring(0, 1)) || "216".equals(row.getString("DOCUTY"))) {
				result = poManager.TOSS_NS0090(row.getString("SVBELN"), "Y", row.getString("STATUS"));
			}

			// TOSS 성공 또는 TOSS 안보낼 시
			if ("Y".equals(result)) {

				if (!"216".equals(row.getString("DOCUTY"))) {
					result = poManager.SAP_SD0340(row.getString("SVBELN"), row.getString("STATUS")); // SAP
																										// 출고지시처리
				}

				if (!"Y".equals(result))
					throw new Exception(commonService.getMessageParam(row.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "출고지시에 실패하였습니다.(SAP) S/O번호 : " + row.getString("SVBELN") }));

				// IFWMS113 TABLE 플래그 UPDATE
				row.setModuleCommand("OyangOutbound", "IFWMS113_CANCEL_ACCEPT");
				commonDao.update(row);
				comCnt++;
			} else {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "출고지시 해제에 실패하였습니다.(TOSS) S/O번호 : " + row.getString("SVBELN") }));
			}

			if ("".equals(rtnString.toString())) {
				rtnString.append("'").append(row.getString("SVBELN")).append("'");
			} else {
				rtnString.append(",'").append(row.getString("SVBELN")).append("'");
			}

		}

		rtnMap.put("RESULT", "Y");
		rtnMap.put("SVBELNS", rtnString.toString());
		return rtnMap;
	}

	// [OY01] 조회
	@Transactional(rollbackFor = Exception.class)
	public List displayOY01(DataMap map) throws SQLException, Exception {

		// RANGE_SQL
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("V.EXPDAT");

		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		// RANGE_SQL2
		List keyList2 = new ArrayList<>();
		keyList2.add("V.WAREKY");

		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("OyangOutbound", "OY01_ITEM");

		return commonDao.getList(map);
	}

	// [OY01] 저장
	@Transactional(rollbackFor = Exception.class)
	public String saveOY01(DataMap map) throws SQLException, Exception {
		String result = "F";
		DataMap row;
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		DataMap header = headList.get(0).getMap("map");
		int sposnr = 10;

		// 오더체크 및 svbeln 체번
		header.put("WAREKY", header.getString("WARESR"));
		header.setModuleCommand("DaerimOutbound", "GET_MOVEWAREHOUSE_SEQ");
		String svbeln = commonDao.getMap(header).getString("SVBELN");

		if (null == svbeln || "".equals(svbeln))
			throw new Exception(
					commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0943", new String[] {}));

		// 아이템 저장 시작
		for (DataMap data : itemList) {
			row = data.getMap("map");
			map.clonSessionData(row);

			// 헤더에서 넣어야할 값 세팅
			row.put("SVBELN", svbeln);
			row.put("ORDDAT", header.getString("ORDDAT"));
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

			// ifwms113 생성
			sposnr = shipmentService.createIFWMS113STO(row);
		}

		if (sposnr > 10)
			result = svbeln;

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public List displayOY03(DataMap map) throws Exception {

		map.setModuleCommand("OyangOutbound", "OY03_HEAD");

		SqlUtil sqlUtil = new SqlUtil();

		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.WAREKY");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG / SM2.QTDUOM");
		keyList2.add("I.QTYORG");
		keyList2.add("I.OWNRKY");
		keyList2.add("SM2.SKUG05");
		keyList2.add("I.N00105");
		keyList2.add("B.PTNG01");
		keyList2.add("B2.PTNG01");
		keyList2.add("B.PTNG02");
		keyList2.add("B2.PTNG02");
		keyList2.add("SM2.SKUG02");
		keyList2.add("SM2.SKUG03");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [OY04] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY04(DataMap map) throws SQLException, Exception {
		DataMap rsMap = new DataMap();
		StringBuffer rtnString = new StringBuffer();
		DataMap iMap = new DataMap();

		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		DataMap itemTemp = map.getMap("tempItem");
		String svbeln = "";
		if (!map.getList("item").isEmpty()) {
			itemList = map.getList("item");
			svbeln = itemList.get(0).getMap("map").getString("SVBELN");
		}

		// DataMap headData = headList.get(0).getMap("map"); //DR01 헤더는 단 한줄이다.
		// DataMap itemData; // 아이템을 담는다.

		// //출고지시여부 체크&&할당여부체크 validateIfwms113ModifyCheckingDO
		// validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전
		// List<DataMap> validList =
		// daerimOutboundService.validIfwms113Status(headData);
		//
		// //수정가능 데이터가 없을 시 : * 변경 불가능한 데이터입니다.
		// if(validList.size() < 1)
		// throw new
		// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
		// "VALID_M1000",new
		// String[]{headData.getString("SVBELN"),headData.getString("SPOSNR")}));
		//
		// //출고지시가 안된 데이터가 있을 시 : * 출고지시가 되지 않은 데이터가 있습니다. {0}
		// for(DataMap valid : validList){
		// if("N".equals(valid.getString("C00102")))
		// throw new
		// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
		// "DAERIM_M0010",new
		// String[]{headData.getString("SVBELN"),headData.getString("SPOSNR")}));
		// }
		try {
			for (int i = 0; i < headList.size(); i++) {
				// 그리드 로우의 값을 한줄씩 불러온다.
				DataMap head = headList.get(i).getMap("map");
				// 세션의 값을 로우에 세팅한다.
				map.clonSessionData(head);

				// 출고지시여부 체크&&할당여부체크 validateIfwms113ModifyCheckingDO
				// validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전
				List<DataMap> validList = daerimOutboundService.validIfwms113Status(head);

				// 수정가능 데이터가 없을 시 : * 변경 불가능한 데이터입니다.
				if (validList.size() < 1)
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M1000",
							new String[] { head.getString("SVBELN"), head.getString("SPOSNR") }));

				// 출고지시가 안된 데이터가 있을 시 : * 출고지시가 되지 않은 데이터가 있습니다. {0}
				for (DataMap valid : validList) {
					if ("N".equals(valid.getString("C00102")))
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_M0010",
								new String[] { head.getString("SVBELN"), head.getString("SPOSNR") }));
				}

				List<DataMap> list = new ArrayList<DataMap>();

				if (svbeln.equals(head.getString("SVBELN"))) {
					list = itemList;
				} else if (itemTemp.containsKey(head.getString("SVBELN"))) {
					list = itemTemp.getList(head.getString("SVBELN"));
				}else{
					iMap = (DataMap)map.clone();
					iMap.putAll(head);
					iMap.setModuleCommand("OyangOutbound", "OY04_ITEM");
					list = commonDao.getList(iMap);
				}
				
				// 아이템 리스트 Loop
				for (int j = 0; j < list.size(); j++) {

					DataMap row = list.get(j).getMap("map");
					map.clonSessionData(row);
					// item그리드에서 wareky 변경 시 validation : 이고출고는 거점변경 불가
					if ("266".equals(head.getString("DOCUTY")) || "267".equals(head.getString("DOCUTY"))) {
						if (!row.getString("WAREKY").equals(head.getString("WAREKY")))
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
									"VALID_M0012", new String[] {}));
					}

					// 변경데이터에 사유코드가 없을 시 에러
					if (" ".equals(row.getString("C00103")))
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0013",
								new String[] { row.getString("C00103") }));

					// 수정수량이 원주문수량보다 큰지 체크
					if (row.getInt("QTYREQ") > row.getInt("QTYORG"))
						throw new Exception(
								commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_QTYREQVALID2",
										new String[] { row.getString("QTYREQ"), row.getString("QTYORG") }));

					// ITEM 수정사항 저장
					map.clonSessionData(row);
					row.setModuleCommand("OyangOutbound", "OY04_ITEM");
					commonDao.update(row);
				}

				// HEAD 수정사항 저장
				head.setModuleCommand("OyangOutbound", "OY04_HEAD");
				commonDao.update(head);

				if ("".equals(rtnString.toString())) {
					rtnString.append("'").append(head.getString("SVBELN")).append("'");
				} else {
					rtnString.append(",'").append(head.getString("SVBELN")).append("'");
				}

				rsMap.put("RESULT", "OK");
				rsMap.put("SVBELN", rtnString.toString());
			}
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public List displayHeadOY05(DataMap map) throws Exception {

		map.setModuleCommand("OyangOutbound", "OY05_HEAD");

		SqlUtil sqlUtil = new SqlUtil();

		List keyList = new ArrayList<>();
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		keyList.add("I.ORDTYP");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.WARESR");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("SM.ASKU05");
		keyList.add("C.CARNUM");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		return commonDao.getList(map);
	}

	// [OY05] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY05(DataMap map) throws SQLException, Exception {
		DataMap rsMap = new DataMap();

		List<DataMap> itemList = map.getList("item");

		DataMap itemData; // 아이템을 담는다.

		// 아이템 리스트 Loop
		for (DataMap item : itemList) {
			itemData = item.getMap("map");

			// 출고지시여부 체크&&할당여부체크 validateIfwms113ModifyCheckingDO
			// validateIfwms113ModifyCheckingC00102 구버전 두 함수를 합친 버전
			List<DataMap> validList = daerimOutboundService.validIfwms113Status(itemData);

			// 수정가능 데이터가 없을 시 : * 변경 불가능한 데이터입니다.
			if (validList.size() < 1)
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M1000",
						new String[] { itemData.getString("SVBELN"), itemData.getString("SPOSNR") }));

			// 출고지시가 안된 데이터가 있을 시 : * 출고지시가 되지 않은 데이터가 있습니다. {0}
			for (DataMap valid : validList) {
				if ("N".equals(valid.getString("C00102")))
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_M0010",
							new String[] { itemData.getString("SVBELN"), itemData.getString("SPOSNR") }));
			}

			// 수정수량이 원주문수량보다 큰지 체크 또는 0이ㅏㄴ경우
			if (itemData.getInt("QTYREQ") > itemData.getInt("QTYORG") || itemData.getInt("QTYORG") < 1)
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "DAERIM_QTYREQVALID2",
						new String[] { itemData.getString("QTYREQ"), itemData.getString("QTYORG") }));

			// ITEM 수정사항 저장
			map.clonSessionData(itemData);
			itemData.setModuleCommand("OyangOutbound", "OY05_IFWMS113");
			commonDao.update(itemData);
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	// [OY06] search
	@Transactional(rollbackFor = Exception.class)
	public List displayOY06(DataMap map) throws Exception {

		String gridid = map.getString("GRIDID");

		if (gridid.equals("gridList1")) {
			map.setModuleCommand("OyangOutbound", "OY06");
		} else if (gridid.equals("gridList2")) {
			map.setModuleCommand("OyangOutbound", "OY06_02");
		} else if (gridid.equals("gridList3")) {
			map.setModuleCommand("OyangOutbound", "OY06_03");
		}

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>(); // RangeSearch
		keyList.add("SM.SKUKEY");
		keyList.add("SM.ASKU05");
		keyList.add("SM.SKUG03");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("STDDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [OY07] search
	@Transactional(rollbackFor = Exception.class)
	public List displayOY07(DataMap map) throws Exception {

		String gridid = map.getString("GRIDID");

		if (gridid.equals("gridList1")) {
			map.setModuleCommand("OyangOutbound", "OY07");
		} else if (gridid.equals("gridList2")) {
			map.setModuleCommand("OyangOutbound", "OY07_02");
		} else if (gridid.equals("gridList3")) {
			map.setModuleCommand("OyangOutbound", "OY07_03");
		}

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>(); // RangeSearch
		keyList.add("SM.SKUKEY");
		keyList.add("SM.ASKU05");
		keyList.add("SM.SKUG03");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("STDDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [OY06] SAVE
	@Transactional(rollbackFor = Exception.class)
	public String saveOY06(DataMap map) throws SQLException, Exception {
		String result = "F";

		map.setModuleCommand("OyangOutbound", "P_DAILY_WMSSTK_OY_DATE");
		commonDao.update(map);

		result = "S";

		return result;
	}

	// [OY14] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY14(DataMap map) throws SQLException, Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		DataMap headData; // 아이템을 담는다.

		// 아이템 리스트 Loop
		for (DataMap item : headList) {
			headData = item.getMap("map");
			map.clonSessionData(headData);

			// 프로시저 콜
			headData.setModuleCommand("OyangOutbound", "P_BATCH_GI_COMPLET_N00105");
			commonDao.update(headData);
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	// [OY15] SAVE
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveOY15(DataMap map) throws SQLException, Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headList = map.getList("head");
		DataMap headData; // 아이템을 담는다.

		// 아이템 리스트 Loop
		for (DataMap item : headList) {
			headData = item.getMap("map");
			map.clonSessionData(headData);

			// 프로시저 콜
			headData.setModuleCommand("OyangOutbound", "P_BATCH_GI_COMPLET_TRFIT");
			commonDao.update(headData);
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	// [OY18_1] SAVE /// 요청사항 : 추가, 삭제 쿼리 변경 후
	@Transactional(rollbackFor = Exception.class)
	public String saveOY18(DataMap map) throws SQLException, Exception {
		String result = "F";
		List<DataMap> gridList1 = map.getList("list");
		int count = 0;
		DataMap row;
		String rowState;

		// 그리드1 저장 시작
		for (DataMap data : gridList1) {
			row = data.getMap("map");
			rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);

			map.clonSessionData(row);
			row.setModuleCommand("OyangOutbound", "OY18_1");

			if (rowState.equals("C") || rowState.equals("U")) {
				commonDao.update(row);
				count++;
			}
			// }else if(rowState.equals("D")){
			// commonDao.delete(row);
			// count++;
			// }
		}

		if (count > 0)
			result = "OK";
		return result;
	}

	// [OY18_2] SAVE /// 요청사항 : 추가, 삭제 쿼리 변경 후
	@Transactional(rollbackFor = Exception.class)
	public String saveOY18_2(DataMap map) throws SQLException, Exception {
		String result = "F";
		List<DataMap> gridList2 = map.getList("list");
		int count = 0;
		DataMap row;
		String rowState;

		// 그리드1 저장 시작
		for (DataMap data : gridList2) {
			row = data.getMap("map");
			rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
			map.clonSessionData(row);
			row.setModuleCommand("OyangOutbound", "OY18_2");

			if (rowState.equals("U")) {
				commonDao.update(row);
				count++;
			}
		}

		if (count > 0)
			result = "OK";
		return result;
	}

	// [OY22] SAVE
	@Transactional(rollbackFor = Exception.class)
	public String saveOY22(DataMap map) throws SQLException, Exception {

		String result = "F";
		List<DataMap> list = map.getList("list");

		int count = 0;
		DataMap row;
		String rowState;

		// 아이템 저장 시작
		for (DataMap data : list) {
			row = data.getMap("map");
			rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
			map.clonSessionData(row);
			row.setModuleCommand("OyangOutbound", "OY22");

			if ("D".equals(rowState)) { // 삭제
				count = commonDao.delete(row);
			} else {
				// 제품코드 유효성 체크
				row.setModuleCommand("OyangOutbound", "OY22_SKU");
				if (commonDao.getMap(row).getInt("CHK") < 1)
					throw new Exception("제품코드가 유효하지 않습니다. 거점 : " + row.get("WAREKY") + " 제품구분 : " + row.get("SKUTYP")
							+ " 제품코드 : " + row.get("SKUKEY"));

				row.setModuleCommand("OyangOutbound", "OY22");
				if ("C".equals(rowState)) {
					// 중복체크
					if (commonDao.getMap(row).getInt("CHK") > 0)
						throw new Exception("동일한 데이터가 존재합니다. 거점 : " + row.get("WAREKY") + " 제품구분 : " + row.get("SKUTYP")
								+ " 제품코드 : " + row.get("SKUKEY"));

					count = (int) commonDao.insert(row);
				} else if ("U".equals(rowState)) {
					count = commonDao.update(row);
				}
			}
		}

		if (count > 0)
			result = "S";

		return result;
	}

	// [OY27] search
	@Transactional(rollbackFor = Exception.class)
	public List displayOY27(DataMap map) throws Exception {

		String gridid = map.getString("GRIDID");

		if (gridid.equals("gridList1")) {
			map.setModuleCommand("OyangOutbound", "OY27");
		} else if (gridid.equals("gridList2")) {
			map.setModuleCommand("OyangOutbound", "OY27_02");
		} else if (gridid.equals("gridList3")) {
			map.setModuleCommand("OyangOutbound", "OY27_03");
		}

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>(); // RangeSearch
		keyList.add("SW.SKUKEY");
		keyList.add("SM.ASKU05");
		keyList.add("SM.SKUG03");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("STDDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [OY28] search
	@Transactional(rollbackFor = Exception.class)
	public List displayOY28(DataMap map) throws Exception {

		String gridid = map.getString("GRIDID");

		if (gridid.equals("gridList1")) {
			map.setModuleCommand("OyangOutbound", "OY28");
		} else if (gridid.equals("gridList2")) {
			map.setModuleCommand("OyangOutbound", "OY28_02");
		} else if (gridid.equals("gridList3")) {
			map.setModuleCommand("OyangOutbound", "OY28_03");
		}

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>(); // RangeSearch
		keyList.add("SW.SKUKEY");
		keyList.add("SM.ASKU05");
		keyList.add("SM.SKUG03");
		keyList.add("SW.WAREKY");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("STDDAT");
		map.put("RANGE_SQL2", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>(); // RangeSearch2
		keyList3.add("SW.WAREKY");
		map.put("RANGE_SQL3", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList4 = new ArrayList<>(); // RangeSearch4
		keyList4.add("STDDAT");

		DataMap changeMap = new DataMap();
		changeMap.put("STDDAT", "TF.DOCDAT");

		map.put("RANGE_SQL4", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList4, changeMap));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	// [OY30] SAVE
	@Transactional(rollbackFor = Exception.class)
	public String saveOY30(DataMap map) throws SQLException, Exception {
		String result = "F";
		DataMap row;
		List<DataMap> headList = map.getList("head");
		List<DataMap> itemList = map.getList("item");
		DataMap header = headList.get(0).getMap("map");
		int sposnr = 10;

		// 오더체크 및 svbeln 체번
		header.put("OWNRKY", map.getString("OWNRKY"));
		header.put("WAREKY", map.getString("WARESR"));
		header.setModuleCommand("DaerimOutbound", "GET_MOVEWAREHOUSE_SEQ");
		String svbeln = commonDao.getMap(header).getString("SVBELN");

		if (null == svbeln || "".equals(svbeln))
			throw new Exception(
					commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0943", new String[] {}));

		// 아이템 저장 시작
		for (DataMap data : itemList) {
			row = data.getMap("map");
			map.clonSessionData(row);

			// 헤더에서 넣어야할 값 세팅
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

			// 수량 계산 이고 수정 시 원수량에서 수정한 수량만큼을 뺀 값을 역이고 한다.
			int qtymod = row.getInt("QTYREQ") - row.getInt("QTYORG");
			row.put("QTYREQ", qtymod);
			row.put("QTYORG", qtymod);

			// ifwms113 생성
			sposnr = shipmentService.createIFWMS113STO(row);
		}

		if (sposnr > 10)
			result = svbeln;

		return result;
	}

}