package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;


import javax.servlet.http.HttpServletRequest;

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
import project.common.util.ComU;

import java.net.URL;

@Service
public class AdvancedShipmentNoticeService extends BaseService {
	
	static final Logger log = LogManager.getLogger(AdvancedShipmentNoticeService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private AdvancedShipmentNoticeService advancedShipmentNoticeService;
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap createAS10(DataMap map) throws Exception {
		boolean saveCk = false;
		DataMap rsMap = new DataMap();
		int validCnt;
		
		try {
			map.setModuleCommand("AdvancedShipmentNotice", "AS10");
			validCnt = commonDao.getMap(map).getInt("CNT");
			
			if(validCnt > 0){
				
				rsMap.put("saveCk", saveCk);
				rsMap.put("COL_VALUE", map.getString("COMMPOPID"));
				rsMap.put("ERROR_MSG", "VALID_duplication");
				return rsMap;
			}else {
				map.clonSessionData(map);
				map.setModuleCommand("AdvancedShipmentNotice", "AS10");
				commonDao.insert(map);
			}
			
			saveCk = true;
			
			rsMap.put("saveCk", saveCk);
			return rsMap;
		} catch (Exception e) {
			 throw new Exception( ComU.getLastMsg(e.getMessage()) );
			// TODO: handle exception
		}
		
		
	}
	}
			
		