package project.mobile.service;

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
import project.common.util.SqlUtil;

@Service("mobileService")
public class MobileService extends BaseService {
	
	static final Logger log = LogManager.getLogger(MobileService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonLabel commonLabel;
	
	@Autowired
	private CommonService commonService;
	
	//PD99T TABLE insert
	@Transactional(rollbackFor = Exception.class)
	public int savePD99T(DataMap map) throws SQLException,Exception {

		int logseq = map.getInt("LOGSEQ");
		
		//입력 여부 체크(JOBTYP)
		if(null == map.getString("JOBTYP")&& "".equals(map.getString("JOBTYP"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "JOBTYP이 없습니다.",new String[]{}));
		
		//입력 여부 체크(CHCKID)
		if(null == map.getString("CHCKID")&& "".equals(map.getString("CHCKID"))) throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "CHCKID가 없습니다.",new String[]{}));
		
		//PD99T 생성
		map.setModuleCommand("MobileCommon", "PD99T");
		commonDao.insert(map);

		logseq +=1;
		
		return logseq;
	}
}