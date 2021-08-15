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
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

@Service
public class BoardService extends BaseService {
	
	static final Logger log = LogManager.getLogger(BoardService.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	public CommonDAO commonDao;
	
	@Transactional(rollbackFor = Exception.class)
	public String saveBD10(DataMap map) throws Exception {
		String result = "";
		List<DataMap> list = map.getList("list");

		try {
			
			// 게시글 추가, 삭제 
			for(int i=0;i<list.size();i++){	
				DataMap row = list.get(i).getMap("map");
				map.clonSessionData(row);
				
				row.setModuleCommand("Board", "BD10");
				
				String rowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				switch(rowState.charAt(0)){
					case 'D':
						commonDao.delete(row);
						break;
				}
				
				if(rowState.equals("C")){
					row.put("OWNRKY", map.getString("OWNRKY"));
					row.put("TITLE", map.getString("TITLE"));
					row.put("CONTENT", map.getString("CONTENT"));
					row.put("WRITER", map.getString("WRITER"));

					commonDao.insert(row);
				}
			}

			// 게시글 수정
			if(list.size() <= 0){
				DataMap row = new DataMap();
				row.put("TEXTNO", map.getString("TEXTNO"));
				row.put("OWNRKY", map.getString("OWNRKY"));
				row.put("TITLE", map.getString("TITLE"));
				row.put("CONTENT", map.getString("CONTENT"));
				row.put("WRITER", map.getString("WRITER"));
				
				row.setModuleCommand("Board", "BD10");
				commonDao.insert(row);	
			}
			
			result = "OK";
		}catch(Exception e){
			throw new SQLException(e.getMessage());
		}
		return result;
	}
}