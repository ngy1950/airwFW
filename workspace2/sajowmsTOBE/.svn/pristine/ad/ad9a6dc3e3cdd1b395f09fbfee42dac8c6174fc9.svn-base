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
public class AdjustmentService extends BaseService {
	
	static final Logger log = LogManager.getLogger(AdjustmentService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;


	/**
	 * WMS ADJDH 생성 - CMU  
	 * @param ownrky 화주
	 * @param wareky 거점
	 * @param adjuty 문서타입
	 * @param doctxt 비고
	 * @param docdat 문서일자
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public String createAdjdh(DataMap map)throws Exception{
		String sadjky = map.getString("SADJKY");
		
		if(null == sadjky || "".equals(sadjky)|| " ".equals(sadjky)){//문서번호가 없을시  문서 번호를 가져온다
			map.put("DOCUTY" ,map.getString("ADJUTY"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			sadjky = commonDao.getMap(map).getString("DOCNUM");
		}
		
		//문서번호 체크 - 문서번호 채번에 실패하였습니다.
		if(null == sadjky || "".equals(sadjky)) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0560",new String[]{}));
		
		//화주, 거점, 문서유형 , 문서일자의 필수 값 체크 
		map.setModuleCommand("Adjustment", "ADJDH_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));

		map.put("SADJKY", sadjky);
		map.put("DOCCAT" ,validMap.getString("DOCCAT"));
		map.put("ADJUCA" ,validMap.getString("DOCCAT"));
		
		
		//ADJDH 생성
		map.setModuleCommand("Adjustment", "ADJDH");
		commonDao.insert(map);
		
		return sadjky;
	}
	



	/**
	 * WMS ADJDI 생성 - CMU  
	 * @param sadjky 조정문서 번호
	 * @param sadjit 조정문서 아이템번호
	 * @param adjqty 조정수량
	 * @param skukey 조정수량
	 * @param adjdi.* 
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createAdjdi(DataMap map)throws Exception{
		int sadjit = map.getInt("SADJIT");
		
		//문서번호, 문서아이템번호, 제품마스터 관련 필수 값 체크 
		map.setModuleCommand("Adjustment", "ADJDI_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(validMap.getString("MSGKEY") != null && !"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));

		//STKKY에서 데이터를 가져오지 않을 경우 기반 데이터를 제품마스터에서 가져온다.
		map.setModuleCommand("Adjustment", "ADJDI_SKUMASTER");
		DataMap row = commonDao.getMap(map);
		
		//ADJDI 생성
		row.putAll(map);
		row.put("QTYUOM", map.getInt("QTADJU"));
		row.setModuleCommand("Adjustment", "ADJDI");
		commonDao.insert(row);

		sadjit +=10;
		
		return sadjit;
	}
	



	/**
	 * WMS ADJDI 생성 (특정 STKKY테이블의 ROW를 지정하여 특정 수량만큼을 차감한다) - CMU : Adjdi
	 * ADJDI 테이블용  
	 * @param sadjky 조정문서 번호
	 * @param sadjit 조정문서 아이템번호
	 * @param adjqty 조정수량
	 * @param skukuey 제품코드
	 * @param adjdi.*
	 * STKKY 테이블용 
 	 * @parma ownrky 화주
 	 * @parma wareky 거점
 	 * @parma locaky 로케이션
 	 * @parma skukey 제품코드
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createAdjdiFromSTK(DataMap map)throws Exception{
		int sadjit = map.getInt("SADJIT");
		
		//문서번호, 문서아이템번호, 제품마스터 관련 필수 값 체크 
		map.setModuleCommand("Adjustment", "ADJDI_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(validMap.getString("MSGKEY") != null && !"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
		
		//STKKY 테이블에 유형에 맞는 재고  조회 FOR UPDATE로 ROW LOCK을 걸어 동시접근 에러 방지
		map.setModuleCommand("Adjustment", "ADJDI_STKKY");
		List<DataMap> stkkyList = commonDao.getList(map);
		
		//재고를 찾을 수 없습니다.
		if(stkkyList.size() < 1) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "INV_M0002",new String[]{}));
		
		int remainqty = map.getInt("QTADJU"); // 차감해야 할 수량
		int stkqty = 0; // stkky 수량

		//stkky의 재고수량을 차감한다.
		for(DataMap row : stkkyList){
			map.clonSessionData(row);
			
			//차감 할 수량을 계산한다.
			if(remainqty > row.getInt("QTSIWH")){
				remainqty = remainqty - row.getInt("QTSIWH"); 
				stkqty = row.getInt("QTSIWH");  
				
			}else{
				stkqty = remainqty;
				remainqty = 0;
			}
			
			//ADJDI 를 생성하여 재고를 차감한다.
			row.put("SADJKY", map.getString("SADJKY"));
			row.put("SADJIT", sadjit);
			row.put("PACKID", map.getString("PACKID"));
			row.put("QTADJU", stkqty*-1);
			row.put("QTYUOM", stkqty*-1);
			row.put("RSNADJ", map.getString("RSNADJ"));
			
			row.setModuleCommand("Adjustment", "ADJDI");
			commonDao.insert(row);
			
			sadjit+=10;
			
			if(remainqty < 1) return sadjit;
		}

		//차감 수량이 0이 되었는지 확인
		if(remainqty > 0 ) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0590",new String[]{}));
		
		return sadjit;
	}
	
	
}