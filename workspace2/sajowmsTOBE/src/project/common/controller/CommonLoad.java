package project.common.controller;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import project.common.bean.CommonConfig;
import project.common.bean.CommonLabel;
import project.common.bean.FileRepository;
import project.common.bean.SystemConfig;
import project.common.service.CommonService;

public class CommonLoad implements ApplicationListener {

	static final Logger log = LogManager.getLogger(CommonLoad.class.getName());
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private CommonLabel commonLabel;
	
	@Autowired
	private SystemConfig systemConfig;
	
	@Autowired
	private FileRepository respository;
	
	public void onApplicationEvent(ApplicationEvent event){
		if(event instanceof ContextRefreshedEvent){
			try {
				String path = respository.getRoot();
				if(path == null){
					path = this.getClass().getClassLoader().getResource("/path.properties").getPath();
					path = path.substring(0, path.indexOf("WEB-INF"));
					
					log.info("path : "+path);
					respository.setRoot(path);
				}
				commonService.loadLabel();					
				commonService.loadMessage();	
				//commonService.loadSearch();
				CommonConfig.SYSTEM_THEME = systemConfig.getTheme();
				CommonConfig.SYSTEM_THEME_PATH = systemConfig.getThemePath();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("onApplicationEvent", e);
			}
			log.debug("Label size : "+commonLabel.getLagelSize());
			log.debug("Message size : "+commonLabel.getMessageSize());
			log.debug("systemConfig : " + systemConfig);
		}
	}
}