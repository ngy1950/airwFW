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
import project.common.util.DasStringFormat;
import project.common.util.StringUtil;

@Service("daerimDASService")
public class DaerimDASService extends BaseService {
	
	static final Logger log = LogManager.getLogger(DaerimDASService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonLabel commonLabel;
	
	@Autowired
	private CommonService commonService;
	
	//[DR11] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR11(DataMap map) throws SQLException,Exception {
		
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
			row.setModuleCommand("DaerimDAS", "DR11");
			
			if("D".equals(rowState)){ //삭제
				count = commonDao.delete(row);
			}else if("C".equals(rowState) || "U".equals(rowState)){//insert, update Merge문으로 처리
				count = commonDao.update(row);
			}
		}
		
		if(count > 0) result = "S"; 
		
		return result;
	}
	
	//[DR12] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR12(DataMap map) throws SQLException,Exception {
		
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
			row.setModuleCommand("DaerimDAS", "DR12");
			
			if("D".equals(rowState)){ //삭제
				count = commonDao.delete(row);
			}else if("C".equals(rowState)){

				//중복체크
				if(commonDao.getMap(row).getInt("CHK") > 0 ) throw new Exception("동일한 데이터가 존재합니다. 다스유형 : "+row.get("DASTYP") +" 셀번호 : "+row.get("CELLNO")+" 업체코드 : "+row.get("PTNRKY")+ " 업체명 : "+ row.get("PTNRNM"));
				
				count = (int)commonDao.insert(row);
			}else if("U".equals(rowState)){
				count = commonDao.update(row);
			}
		}
		
		if(count > 0) result = "S"; 
		
		return result;
	}

	
	//[DR13] DAS 파일 생성 
	@Transactional(rollbackFor = Exception.class)
	public DataMap createDasFileDR13(DataMap map) throws SQLException,Exception {
		DataMap rsMap = new DataMap();
		List keyList = new ArrayList();

		String optype = map.getString("OPTYPE");
		map.put("DASTYP", optype);
		
		if("01".equals(optype)){
			//DAS 기반데이터 생성 프로시저 콜 
			map.setModuleCommand("DaerimDAS", "P_DAS_PICKINGLIST_01");
			commonDao.update(map);
			
			rsMap.put("DSBT85",this.createDasFile01_1(map));
			rsMap.put("DSBT86",this.createDasFile01_2(map));
			rsMap.put("DSBT87",this.createDasFile01_3(map));
			rsMap.put("DSBT88",this.createDasFile01_4(map));

			keyList.add("DSBT85" );
			keyList.add("DSBT86" );
			keyList.add("DSBT87" );
			keyList.add("DSBT88" );
		}else if("02".equals(optype)){
			//DAS 기반데이터 생성 프로시저 콜 
			map.setModuleCommand("DaerimDAS", "P_DAS_PICKINGLIST_02");
			commonDao.update(map);
			
			rsMap.put("DSBT76A",this.createDasFile02_1(map));
			rsMap.put("DSBT76B",this.createDasFile02_2(map));
			rsMap.put("DSBT76C",this.createDasFile02_3(map));
			rsMap.put("DSBT76",this.createDasFile02_4(map));
			
			keyList.add("DSBT76A");
			keyList.add("DSBT76B");
			keyList.add("DSBT76C");
			keyList.add("DSBT76" );
		}
		
		rsMap.put("KEY", keyList);
		rsMap.put("RESULT", "S");
		
		return rsMap;
	}
	

	// [DR13] CREATE DAS FILE01_1(안산 거래처 25)
	public DataMap createDasFile01_1(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE01_1");
		list = commonDao.getList(param);
		
		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSBT85");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DR13] CREATE DAS FILE01_2(안산 제품 67)
	public DataMap createDasFile01_2(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE01_2");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 6, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKL04"), 14, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			//구버전은 기본적으로 BigDecimal로 가져오므로 숫자 컬럼은 숫자로 가져와야 한다.
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(" ");
			sb.append(StringUtil.leftPad(""+row.getInt("QTDUOM"), "0", 3));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
		}

		rtnMap.put("fileName", "DSBT86");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}

	// [DR13] CREATE DAS FILE01_3(안산 코스 22)
	public DataMap createDasFile01_3(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE01_3");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("CARNUM"), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("CARNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSBT87");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}

	// [DR13] CREATE DAS FILE01_4(안산 피킹자료 37)
	public DataMap createDasFile01_4(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE01_4");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(" ");
			//구버전은 기본적으로 BigDecimal로 가져오므로 숫자 컬럼은 숫자로 가져와야 한다.
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("LOCADK"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("SHIPSQ"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("CARNUM"), "0", 2), 2, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("SORTSQ"), "0", 2), 2, 2));
		}

		rtnMap.put("fileName", "DSBT88");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DR13] CREATE DAS FILE02_1(안산 여주이마트 거래처 25)
	public DataMap createDasFile02_1(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE02_1");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSBT76A");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}

	// [DR13] CREATE DAS FILE02_2(안산 여주이마트 제품 67)
	public DataMap createDasFile02_2(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE02_2");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 6, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKL04"), 14, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			//구버전은 기본적으로 BigDecimal로 가져오므로 숫자 컬럼은 숫자로 가져와야 한다.
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getString("SKUKEY"), "0", 7), 7, 2));
		}

		rtnMap.put("fileName", "DSBT76B");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}

	// [DR13] CREATE DAS FILE02_3(안산 여주이마트 코스 22)
	public DataMap createDasFile02_3(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE02_3");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("CARNUM"), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("CARNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSBT76C");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}

	// [DR13] CREATE DAS FILE02_4(안산 여주이마트 피킹자료 37)
	public DataMap createDasFile02_4(DataMap param) throws SQLException,Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		//다스파일 기반데이터 select
		param.setModuleCommand("DaerimDAS", "CREATE_DASFILE02_4");
		list = commonDao.getList(param);

		for(DataMap row : list){
			//첫 줄 아닐씨 줄 바꿈
			if (sb.toString().length() > 0) 
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("LOCADK"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(""+row.getInt("SHIPSQ"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("CARNUM"), "0", 2), 2, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(""+row.getInt("SORTSQ"), "0", 2), 2, 2));
		}

		rtnMap.put("fileName", "DSBT76");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);
		
		return rtnMap;
	}
	
	//[DR18] SAVE 
	@Transactional(rollbackFor = Exception.class)
	public String saveDR18(DataMap map) throws SQLException,Exception {
		
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
			row.setModuleCommand("DaerimDAS", "DR18");
			
			if("D".equals(rowState)){ //삭제
				count = commonDao.delete(row);
			}else if("C".equals(rowState) || "U".equals(rowState)){//insert, update Merge문으로 처리
				count = commonDao.update(row);
			}
		}
		
		if(count > 0) result = "S"; 
		
		return result;
	}
}