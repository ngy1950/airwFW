package project.wms.service;

import java.util.List;

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
public class ShipmentService extends BaseService {
	
	static final Logger log = LogManager.getLogger(ShipmentService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;


	/**
	 * WMS IFWMS113 생성 - CMU
	 * @param ownrky 화주
	 * @param wareky 거점  
	 * @param docuty 문서유형  
	 * @param svbeln S/O번호
	 * @param skukey 제품코드
	 * @param qtyorg 오더수량
	 * @param ifwms113.*
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createIFWMS113(DataMap map)throws Exception{
		String svbeln = map.getString("SVBELN");
		int sposnr = map.getInt("SPOSNR");
		
		//화주, 거점, 문서유형 , 문서일자, 제품코드, S/O번호, 거래처, 납품처, 출고요청일자, 출고에정일자 의 필수 값 체크 
		map.setModuleCommand("Shipment", "IFWMS113_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
		
		//IFWMS113 생성
		map.setModuleCommand("Shipment", "IFWMS113");
		commonDao.insert(map);
		
		sposnr += 10;
		
		return sposnr;
	}



	/**
	 * WMS IFWMS113 생성 - CMU
	 * @param ownrky 화주
	 * @param wareky 거점  
	 * @param docuty 문서유형  
	 * @param svbeln S/O번호
	 * @param skukey 제품코드
	 * @param qtyorg 오더수량
	 * @param ifwms113.*
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createIFWMS113STO(DataMap map)throws Exception{
		String svbeln = map.getString("SVBELN");
		int sposnr = map.getInt("SPOSNR");
		
		//S/O 안넘길 시 체번
		if(null == svbeln || "".equals(svbeln)){
			map.setModuleCommand("Shipment", "SEQ_MOVEWAREHOUSE");
			svbeln = commonDao.getMap(map).getString("SVBELN");
		}
		
		//이고용 값 세팅 
		map.put("MANDT", "SAP");
		map.put("ORDTYP", "UB");
		map.put("SVBELN", svbeln);
		map.put("SPOSNR", sposnr);
		map.put("ORDSEQ", sposnr);
		map.put("CHKSEQ", svbeln);
		map.put("DIRDVY", "01");
		map.put("DIRSUP", "000");
		map.put("C00101", "IF");
		map.put("C00102", "Y");
		map.put("STATUS", "C");
		if ("266".equals(map.getString("DOCUTY"))) {
			map.put("C00104", "1011");
			map.put("C00107", "1011");
		} else if ("267".equals(map.getString("DOCUTY"))) {
			map.put("C00104", "1021");
			map.put("C00107", "1021");
		}
		
		
		//IFWMS113 생성 
		return this.createIFWMS113(map);
	}
	
	
}