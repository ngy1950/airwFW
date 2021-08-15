package project.common.bean;

import java.io.Serializable;

public class User implements Serializable {

	private static final long serialVersionUID = 5467531524640951540L;

	private String userid;
	private String passwd;
	private String username;
	private String compid;
	private String usertype;
	private String menugid;
	private String deptid;
	private String gradeid;
	private String sortorder;
	private String logindate;
	private String logoutdate;
	private String userKey;
	private String userg1;
	private String userg2;
	private String userg3;
	private String userg4;
	private String userg5;
	private DataMap usrlo;
	private DataMap usrph;
	private DataMap usrpi;
	private DataMap userdata;
	private String usercode;
	private String lockcheck;
	private String usecheck;
	private String pwdchdate;
	private Integer pwdchdatechk;
	private Integer failcnt;
	private String llogwh;
	private String llogwhnm;

	public User() {
		this.userdata = new DataMap();
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCompid() {
		return compid;
	}

	public void setCompid(String compid) {
		this.compid = compid;
	}

	public String getUsertype() {
		return usertype;
	}

	public void setUsertype(String usertype) {
		this.usertype = usertype;
	}

	public String getMenugid() {
		return menugid;
	}

	public void setMenugid(String menugid) {
		this.menugid = menugid;
	}

	public String getDeptid() {
		return deptid;
	}

	public void setDeptid(String deptid) {
		this.deptid = deptid;
	}

	public String getGradeid() {
		return gradeid;
	}

	public void setGradeid(String gradeid) {
		this.gradeid = gradeid;
	}

	public String getSortorder() {
		return sortorder;
	}

	public void setSortorder(String sortorder) {
		this.sortorder = sortorder;
	}

	public String getLogindate() {
		return logindate;
	}

	public void setLogindate(String logindate) {
		this.logindate = logindate;
	}

	public String getLogoutdate() {
		return logoutdate;
	}

	public void setLogoutdate(String logoutdate) {
		this.logoutdate = logoutdate;
	}

	public String getUserKey() {
		return userKey;
	}

	public void setUserKey(String userKey) {
		this.userKey = userKey;
	}

	public DataMap getUsrlo() {
		return usrlo;
	}

	public void setUsrlo(DataMap usrlo) {
		this.usrlo = usrlo;
	}

	public DataMap getUsrph() {
		return usrph;
	}

	public void setUsrph(DataMap usrph) {
		this.usrph = usrph;
	}

	public DataMap getUsrpi() {
		return usrpi;
	}

	public void setUsrpi(DataMap usrpi) {
		this.usrpi = usrpi;
	}

	public DataMap getUserdata() {
		return userdata;
	}

	public Object getUserdata(String key) {
		return userdata.get(key);
	}

	public void setUserdata(DataMap userdata) {
		this.userdata = userdata;
	}

	public void addUserData(String key, Object value) {
		this.userdata.put(key, value);
	}

	public String getUsercode() {
		return usercode;
	}

	public void setUsercode(String usercode) {
		this.usercode = usercode;
	}	
	
	public String getLockcheck() {
		return lockcheck;
	}
	
	public String getUsecheck() {
		return usecheck;
	}	
	
	public String getPwcdat() {
		return pwdchdate;
	}
	
	public Integer getPwcdatchk() {
		return pwdchdatechk;
	}

	public Integer getFailcnt() {
		return failcnt;
	}

	public String getUserg1() {
		return userg1;
	}

	public void setUserg1(String userg1) {
		this.userg1 = userg1;
	}

	public String getUserg2() {
		return userg2;
	}

	public void setUserg2(String userg2) {
		this.userg2 = userg2;
	}

	public String getUserg3() {
		return userg3;
	}

	public void setUserg3(String userg3) {
		this.userg3 = userg3;
	}

	public String getUserg4() {
		return userg4;
	}

	public void setUserg4(String userg4) {
		this.userg4 = userg4;
	}

	public String getUserg5() {
		return userg5;
	}

	public void setUserg5(String userg5) {
		this.userg5 = userg5;
	}
	
	public String getLlogwh() {
		return llogwh;
	}

	public void setLlogwh(String llogwh) {
		this.llogwh = llogwh;
	}
	
	public String getLlogwhnm() {
		return llogwhnm;
	}

	public void setLlogwhnm(String llogwhnm) {
		this.llogwhnm = llogwhnm;
	}

	@Override
	public String toString() {
		return "User [userid=" + userid + ", passwd=" + passwd + ", username=" + username + ", compid=" + compid
				+ ", usertype=" + usertype + ", menugid=" + menugid + ", deptid=" + deptid + ", gradeid=" + gradeid
				+ ", sortorder=" + sortorder + ", logindate=" + logindate + ", logoutdate=" + logoutdate + ", userKey="
				+ userKey + ", userg1=" + userg1 + ", userg2=" + userg2 + ", userg3=" + userg3 + ", userg4=" + userg4
				+ ", userg5=" + userg5 + ", usrlo=" + usrlo + ", usrph=" + usrph + ", usrpi=" + usrpi + ", userdata="
				+ userdata + ", usercode=" + usercode + ", lockcheck=" + lockcheck + ", usecheck=" + usecheck
				+ ", pwdchdate=" + pwdchdate + ", pwdchdatechk=" + pwdchdatechk + ", failcnt=" + failcnt + ", llogwh="
				+ llogwh + ", llogwhnm=" + llogwhnm + "]";
	}	
}