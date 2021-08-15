package project.common.service;

import java.sql.SQLException;
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

@Service("sysmagtemService")
public class SystemMagService extends BaseService {
	
	static final Logger log = LogManager.getLogger(SystemMagService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonLabel commonLabel;
	
	@Autowired
	private CommonService commonService;
	
	/**
	 * 라벨저장
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public String saveYL01(DataMap map) throws Exception {
		
		String result = "";
		List<DataMap> list = map.getList("list");
		
		int count = 0;
		
		try {
			for(int i=0;i<list.size();i++){			
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("SajoSystem", "JLBLM");
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				switch(rowState.charAt(0)){
					case 'D':
						commonDao.delete(row);
						break;
				}
			}
			
			for(int i=0;i<list.size();i++){			
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				row.setModuleCommand("SajoSystem", "JLBLM");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				if(rowState.equals("C")){
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						throw new Exception("동일한 라벨이 존재 합니다.");
					}else{
						commonDao.insert(row);
					}
				}else if(rowState.equals("U")){
					commonDao.update(row);
				}
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception("저장이 실패하였습니다.");
		}
		
		return result;
	}


	/**
	 * 메세지 저장
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public String saveYM01(DataMap map) throws Exception {
		
		String result = "";
		List<DataMap> list = map.getList("list");
		
		int count = 0;
		
		try {
			for(int i=0;i<list.size();i++){			
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("SajoSystem", "JMSGM");
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				switch(rowState.charAt(0)){
					case 'D':
						commonDao.delete(row);
						break;
				}
			}
			
			for(int i=0;i<list.size();i++){			
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				row.setModuleCommand("SajoSystem", "JMSGM");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				
				if(rowState.equals("C")){
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						throw new Exception("동일한 라벨이 존재 합니다.");
					}else{
						commonDao.insert(row);
					}
				}else if(rowState.equals("U")){
					commonDao.update(row);
				}
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * 사유코드 저장
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	public String saveRC01(DataMap map) throws Exception {
		String result = "";
		List<DataMap> list = map.getList("list");
		
		
		int count = 0;
		
		try {
			for(int i=0;i<list.size();i++){			
				DataMap row = list.get(i).getMap("map");
				row.put("SHORTX", row.get("SHORTX2"));
				
				map.clonSessionData(row);
				row.setModuleCommand("SajoSystem", "RSNCD");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				switch(rowState.charAt(0)){
				case 'D':
					commonDao.delete(row);
					break;
				}
				
				if(rowState.equals("C")){
					int chk = commonDao.getMap(row).getInt("CHK");
							//.getInt("CHK");
					if(chk > 0 ){
						throw new Exception("동일한 코드가 존재 합니다.");
					}else{
						commonDao.insert(row);
					}
				 }else if(rowState.equals("U")){
					commonDao.update(row);
				 }
				result = "OK";
			}
		}catch(Exception e){
			throw new SQLException(e.getMessage());
		}
		return result;
	}
	
	
}