package project.wms.service;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;

@Service
public class RecieptService  extends BaseService {

	static final Logger log = LogManager.getLogger(RecieptService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;
	
	


	/**
	 * WMS RECDH 생성 - CMU  
	 * @param ownrky 화주
	 * @param wareky 거점
	 * @param rcptty 문서타입
	 * @param doctxt 비고
	 * @param docdat 문서일자
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public String createRecdh(DataMap map)throws Exception{
		String recvky = map.getString("RECVKY");
		
		if(null == recvky || "".equals(recvky) || " ".equals(recvky)){//문서번호가 없을시  문서 번호를 가져온다
			map.put("DOCUTY" ,map.getString("RCPTTY"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			recvky = commonDao.getMap(map).getString("DOCNUM");
		}
		
		//문서번호 체크 - 문서번호 채번에 실패하였습니다.
		if(null == recvky || "".equals(recvky)) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0560",new String[]{}));

		map.put("RECVKY", recvky);
		//화주, 거점, 문서유형 , 문서일자, 업체코드의 필수 값 체크 
		map.setModuleCommand("Reciept", "RECDH_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));

		map.put("DOCCAT" ,validMap.getString("DOCCAT"));
		
		
		//ADJDH 생성
		map.setModuleCommand("Reciept", "RECDH");
		commonDao.insert(map);
		
		return recvky;
	}
	



	/**
	 * WMS RECDI 생성 - CMU  
	 * @param recvky 입고문서 번호
	 * @param recvit 입고문서 아이템번호
	 * @param recdi.* 
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createRecdi(DataMap map)throws Exception{
		int recvit = map.getInt("RECVIT");
		
		//문서번호, 문서아이템번호, 제품마스터 관련 필수 값 체크 
		map.setModuleCommand("Reciept", "RECDI_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(validMap.getString("MSGKEY") != null && !"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));

		//STKKY에서 데이터를 가져오지 않을 경우 기반 데이터를 제품마스터에서 가져온다.
		map.setModuleCommand("Reciept", "RECDI_SKUMASTER");
		DataMap row = commonDao.getMap(map);
		
		//RECDI 생성
		row.putAll(map);
		row.put("QTYUOM", map.getInt("QTYRCV"));
		row.setModuleCommand("Reciept", "RECDI");
		commonDao.insert(row);

		recvit +=10;
		
		return recvit;
	}
}
