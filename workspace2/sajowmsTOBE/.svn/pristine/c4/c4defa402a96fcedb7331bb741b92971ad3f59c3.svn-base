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
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;

import java.net.URL;

@Service
public class CenterCloseService extends BaseService {
	
	static final Logger log = LogManager.getLogger(CenterCloseService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveCL01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		try {
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					//그리드 로우의 값을 한줄씩 불러온다.
					DataMap row = list.get(i).getMap("map");
					//세션의 값을 로우에 세팅한다.
					map.clonSessionData(row);
					row.put("OWNRKY", map.getString("OWNRKY"));

					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					//insert "C"
					if(rowState.equals("C")){

						//유효성체크
						row.setModuleCommand("CenterClose", "CL01");
						int chk = commonDao.getMap(row).getInt("CHK"); //중복체크
						if(chk > 0 ){
							String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",new String[]{""});
							throw new Exception("* 동일한 라벨이 존재 합니다. *");
						}else{
							resultChk = (int)commonDao.insert(row);
						}
					}else if(rowState.equals("U")){
						row.setModuleCommand("CenterClose", "CL01");
						
							resultChk = (int)commonDao.update(row);
						
					}else if(rowState.equals("D")){
						row.setModuleCommand("CenterClose", "CL01");
						
							resultChk = (int)commonDao.delete(row);
					}
					
				}
				
				if(resultChk == 1){
					rsMap.put("RESULT", "OK");
				}
			}
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveCL02(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");
		
		try {
			if(list.size() > 0){
				for(int  i = 0; i < list.size(); i++){
					//그리드 로우의 값을 한줄씩 불러온다.
					DataMap row = list.get(i).getMap("map");
					//세션의 값을 로우에 세팅한다.
					/*map.clonSessionData(row);
					row.put("OWNRKY", map.getString("OWNRKY"));*/
					
					
					String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
					if(rowState.equals("U")){
						row.setModuleCommand("CenterClose", "CL02");
						
							resultChk = (int)commonDao.update(row);
							/*throw new Exception("저장 되었습니다.");*/
						
					}
					
				}
				
				if(resultChk == 1){
					rsMap.put("RESULT", "OK");
				}
			}
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		return rsMap;
	}
	


		@Transactional(rollbackFor = Exception.class)
		public DataMap displayCL02(DataMap map) throws Exception {
			DataMap rsMap = new DataMap();
			int resultChk = 0;
			List<DataMap> list = map.getList("list");
			
			try {
				map.setModuleCommand("CenterClose", "CL02");
				int chk = commonDao.getMap(map).getInt("CHK"); //중복체크
				if(chk < 1 ){
					resultChk = (int)commonDao.insert(map);
				}
			} catch (Exception e) {
				throw new Exception( ComU.getLastMsg(e.getMessage()) );
			}
			return rsMap;
		}

	
}