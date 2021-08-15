package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
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
import project.common.util.StringUtil;

@Service
public class TaskDataService extends BaseService {
	
	static final Logger log = LogManager.getLogger(TaskDataService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;



	/**
	 * WMS TASDH 생성 - CMU
	 * @return taskky
	 */
	@Transactional(rollbackFor = Exception.class)
	public String createTasdh(DataMap map) throws SQLException {
		String taskky = map.getString("TASKKY");
		
		if(null == taskky || "".equals(taskky)|| " ".equals(taskky)){//문서번호가 없을시  문서 번호를 가져온다
			map.put("DOCUTY" ,map.getString("TASOTY"));
			map.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			taskky = commonDao.getMap(map).getString("DOCNUM");
		}
		
		try{
			//문서번호 체크 - 문서번호 채번에 실패하였습니다.
			if(null == taskky || "".equals(taskky)) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0560",new String[]{}));
			
			//화주, 거점, 문서유형 , 문서일자의 필수 값 체크 
			map.setModuleCommand("TASK", "TASDH_VALDATION");
			DataMap validMap = commonDao.getMap(map);
	
			if(!"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));
	
			map.put("TASKKY", taskky);
			map.put("DOCCAT" ,validMap.getString("DOCCAT"));
			
			
			//TASDH 생성
			map.setModuleCommand("TASK", "TASDH");
			commonDao.insert(map);
		}catch(Exception e){
			
		}
		return taskky;
	}

	



	/**
	 * WMS TASDI 생성 - CMU  
	 * @param tasdi.* 
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public void createTasdi(DataMap map)throws Exception{
		int taskit = map.getInt("TASKIT");
		
		//문서번호, 문서아이템번호, 제품마스터 관련 필수 값 체크 
		map.setModuleCommand("TASK", "TASDI_VALDATION");
		DataMap validMap = commonDao.getMap(map);

		if(validMap.getString("MSGKEY") != null && !"".equals(validMap.getString("MSGKEY"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), validMap.getString("MSGKEY"),new String[]{}));

		//TASDI 생성
		map.setModuleCommand("TASK", "TASDI");
		commonDao.insert(map);
	}

	



	/**
	 * WMS TASDR 생성 - CMU  
	 * @param tasdi.* 
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int createTasdr(DataMap map)throws Exception{
		int taskit = map.getInt("TASKIT");
		
		//TASDR 생성
		map.setModuleCommand("TASK", "TASDR");
		commonDao.insert(map);

		taskit +=10;
		
		return taskit;

	}
}