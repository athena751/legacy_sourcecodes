/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.ddr;

import java.util.List;
import java.util.ArrayList;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;
import com.nec.nsgui.model.entity.ddr.DdrVolInfoBean;
import com.nec.nsgui.model.entity.ddr.DdrExtendPairBean;

/**
 * 
 */
public class DdrHandler {
	public static final String cvsid = "@(#) $Id: DdrHandler.java,v 1.3 2008/05/04 05:16:43 yangxj Exp $";

	public static final String SUDO = "sudo";

	public static final String SCRIPT_DDR_GETPAIRLIST_PL = "/opt/nec/nsadmin/bin/ddr_getPairList.pl";

	public static final String DDR_GETMV_PL = "/opt/nec/nsadmin/bin/ddr_getMv.pl";
	
	private static final String DDR_ASYNC_MAKE_PAIR_PL = "/opt/nec/nsadmin/bin/ddr_asyncMakePair.pl";
	
	private static final String DDR_CHECK4CREATE_PL = "/opt/nec/nsadmin/bin/ddr_check4Create.pl";

	public static final String DDR_UNPAIR_PL = "/opt/nec/nsadmin/bin/ddr_unpair.pl";
	
	public static final String DDR_VOLSCAN = "/opt/nec/nsadmin/bin/ddr_volumeScan.pl";

    public static final String DDR_GETPAIRDETAIL_PL = "/opt/nec/nsadmin/bin/ddr_getPairDetail.pl";
    
	public static final String DDR_DEL_ASYNC_FILE_PL = "/opt/nec/nsadmin/bin/ddr_delAsyncFile.pl";

	public static final String DDR_HAS_ASYNC_PAIR_PL = "/opt/nec/nsadmin/bin/ddr_hasAsyncPair.pl";
    public static final String DDR_ISPAIRED_PL = "/opt/nec/nsadmin/bin/ddr_isPaired.pl";
    
    public static final String DDR_ASYNC_EXTEND_PAIR_PL = "/opt/nec/nsadmin/bin/ddr_asyncExtendPair.pl";
    
	public static final String ENCODE_EUC_JP = "EUC-JP";
	
	private static final String DDR_SCHEDULE_MODIFY_PL = "/opt/nec/nsadmin/bin/ddr_modifySchedule.pl";  
    public static final String DDR_CRON_FILE_NAME        = "/var/spool/cron/ddr";
    
	public static List<DdrPairInfoBean> getPairInfoList(int nodeNo) throws Exception {
		String[] cmds_getPairListInfo = {SUDO, SCRIPT_DDR_GETPAIRLIST_PL};

		NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds_getPairListInfo, nodeNo, true);
		String[] stdout = cmdResult.getStdout();
		List <DdrPairInfoBean> ddrPairInfoList = NSBeanUtil.createBeanList( "com.nec.nsgui.model.entity.ddr.DdrPairInfoBean", stdout);
		
		return ddrPairInfoList;
	}

	public static List getFreeMvList() throws Exception {
		String[] cmds = {
				 SUDO,
				 DDR_GETMV_PL};
		NSCmdResult result = CmdExecBase.execCmd(cmds);
		String[] stdOut = result.getStdout();

		List DdrVolInfoList = NSBeanUtil.createBeanList(
				"com.nec.nsgui.model.entity.ddr.DdrVolInfoBean", stdOut);	
		return DdrVolInfoList;
	}
    /**
     * createPair: D2d always backup.Execute ddr_asyncMakePair.pl on current(fip)node.
     * 
     * @param mvInfo DdrVolInfoBean
     * @param rvInfo DdrVolInfoBean
     * @return Null
     * @throws Exception
     */
	public static void createPair(DdrVolInfoBean mvInfo,DdrVolInfoBean rvInfo,int nodeNo) throws Exception {
		String [] rv0Ary = {
			     rvInfo.getPoolName(),
			     mvInfo.getName(),
			     rvInfo.getWwnn(),
			     rvInfo.getName()
			     };
		String rv0 = join(rv0Ary, "#");
		String[] cmds = {
					 SUDO,
					 DDR_ASYNC_MAKE_PAIR_PL,
					 "always",
					 "-mv",mvInfo.getName(),
					 "-rv0",rv0
			         };	

	    CmdExecBase.execCmd(cmds,nodeNo);
	}
    /**
     * createPair: D2d always backup.Execute ddr_asyncMakePair.pl on current(fip)node.
     * 
     * @param mvInfo  
     * @param rvsInfo[](The Array of rvInfo)
     * @param schedule (The String for set schedule)
     * @return Null
     * @throws Exception
     */
	public static void createPair(DdrVolInfoBean mvInfo,DdrVolInfoBean[] rvInfoAry,String schedule,int nodeNo) throws Exception {

		ArrayList <String> cmdList = new ArrayList<String>();
		cmdList.add(SUDO);
		cmdList.add(DDR_ASYNC_MAKE_PAIR_PL);
		cmdList.add("generation");
		cmdList.add("-mv");
		cmdList.add(mvInfo.getName());
		cmdList.add("-sched");
		cmdList.add("\""+schedule+"\"");

		for(int i = 0; i < rvInfoAry.length; i++){
		    if(!rvInfoAry[i].getPoolName().equals("")){
				String [] rvInfo = {
					     rvInfoAry[i].getPoolName(),
					     mvInfo.getName(),
					     rvInfoAry[i].getWwnn(),
					     rvInfoAry[i].getName()
					     };
				// <PoolName>#<mvName>#<wwnn>#<rvName>
				String rvOption = join(rvInfo, "#");
				cmdList.add("-rv"+i);
				cmdList.add(rvOption);
		    }
		}
	    CmdExecBase.execCmd(cmdList.toArray(new String[0]),nodeNo);
	}
    /**
     * capacityCheck: Check pool capacity before create.
     * 
     * @param nodeNo  
     * @throws Exception
     */
	public static void check4Create( DdrVolInfoBean mvInfo,DdrVolInfoBean[] rvInfoAry,int nodeNo) throws Exception {
		ArrayList <String> cmdList = new ArrayList<String>();
		cmdList.add(SUDO);
		cmdList.add(DDR_CHECK4CREATE_PL);
		cmdList.add("-mv");
		cmdList.add(mvInfo.getName());
		
		for(int i = 0; i < rvInfoAry.length; i++){
		    if(!rvInfoAry[i].getPoolName().equals("")){
				String [] rvInfo = {
					     rvInfoAry[i].getPoolName(),
					     mvInfo.getName(),
					     rvInfoAry[i].getWwnn(),
					     rvInfoAry[i].getName()
					     };
				// <PoolName>#<mvName>#<wwnn>#<rvName>
				String rvOption = join(rvInfo, "#");
				cmdList.add("-rv"+i);
				cmdList.add(rvOption);
		    }
		}
	    CmdExecBase.execCmd(cmdList.toArray(new String[0]),nodeNo);
	}
    /**
     * join: Join the item of the array by split string
     * 
     * @param strAry
     * @param split(The Array joined by)
     * @return String after join item
     * @throws Exception
     */	
	public static String join(String[] strAry, String split) throws Exception{
		if((strAry == null)||(strAry.length == 0)){
			return "";
		}
		int len = strAry.length;
		StringBuffer strBuf = new StringBuffer();
		for(int i = 0 ; i < len-1; i++){
			strBuf.append(strAry[i]).append(split);
		}
		//Add the last item of the array
		strBuf.append(strAry[len-1]);
		return strBuf.toString();
	}

	public static void unpair(String mvName, String rvName, int nodeNo) throws Exception {
		String[] cmds = {SUDO, DDR_UNPAIR_PL, mvName, rvName};
		CmdExecBase.execCmd(cmds, nodeNo);
	}
	
	public static void delAsyncFile(String volName, int nodeNo) throws Exception {
		String[] cmds = { SUDO, DDR_DEL_ASYNC_FILE_PL, volName };
		CmdExecBase.execCmd(cmds, nodeNo);
	}
    public static String[] getAsyncPairInfo() throws Exception{
        String[] cmds = {SUDO, DDR_HAS_ASYNC_PAIR_PL};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null);
        if(result.getStdout().length>0) {
            return result.getStdout();
        } else {
            return new String[0];        
        }
    }
	
	public static void volScan() throws Exception{
		String[] cmds = {SUDO, DDR_VOLSCAN};
		CmdExecBase.execCmdForce(cmds,true);
	}
    
    /**
     * getPairDetail:get mv rv detail info
     * 
     * @param mvName
     * @param rvName(separated by '#' if more than one)
     * @param asyncStatus
     * @param ldNameStr(format:"mv0ld1,rv0ld1:mv0ld2,rv0ld2#mv0ld1,rv1ld1:mv0ld2,rv1ld2")
     * @param nodeNo
     * @return ArrayList
     *           [0]:mvBean
     *           [1]:rvBean 
     * @throws Exception
     */
    public static List getPairDetail(
        String mvName, 
        String rvName, 
        String asyncStatus, 
        String ldNameStr, 
        int nodeNo) throws Exception {

        // execute cmd
        String[] cmds = {
                CmdExecBase.CMD_SUDO, 
                DDR_GETPAIRDETAIL_PL, 
                String.valueOf(nodeNo),
                mvName, 
                rvName, 
                asyncStatus, 
                ldNameStr};
        NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
        String[] stdout = cmdResult.getStdout();

        // parse stdout into bean list
        List pairDetailList = NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.ddr.DdrRVDetailBean", stdout);

        return pairDetailList;
    }
    
    public static void modifySchedule( String mv, String rv, String timeStr,String newTimeStr, int nodeNo) throws Exception {
        String[] cmds = {"sudo", DDR_SCHEDULE_MODIFY_PL, DDR_CRON_FILE_NAME, mv, rv, timeStr, newTimeStr};
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    /**
     * check if the volume is paired on two node
     * @param volName -- volume name
     * @return none
     * @throws Exception
     */    
    
    public static void isPaired(String volName) throws Exception{
        String[] cmds = {"sudo" , DDR_ISPAIRED_PL, volName};
        CmdExecBase.execCmd(cmds);
    }
    
    public static List getInfo4PairExtend(
    	String mvName,
    	String rvName,
    	String asyncStatus,
    	String ldNameStr,
    	int nodeNo
    ) throws Exception{
    	String[] cmds = {
    			CmdExecBase.CMD_SUDO,
    			DDR_GETPAIRDETAIL_PL,
    			String.valueOf(nodeNo),
    			mvName,
    			rvName,
    			asyncStatus,
    			ldNameStr
    	};
    	NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
    	String[] stdout = cmdResult.getStdout();
    	
    	List pairInfoList = NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.ddr.DdrExtendPairBean", stdout);
    	
    	return pairInfoList;
    }
    
    public static void extendPair(
    	DdrExtendPairBean mvInfo,
    	DdrExtendPairBean rv0Info,
    	DdrExtendPairBean rv1Info,
    	DdrExtendPairBean rv2Info,
    	int nodeNo
    )throws Exception{
    	ArrayList <String> cmdList = new ArrayList<String>();
    	float extendSize = Float.parseFloat(mvInfo.getExtendSize());
    	if(mvInfo.getExtendUnit().equals("TB")){
    		extendSize = extendSize * 1024;
    	}
    	cmdList.add(SUDO);
    	cmdList.add(DDR_ASYNC_EXTEND_PAIR_PL);
    	cmdList.add("extend");
    	cmdList.add("-mv");
    	cmdList.add(mvInfo.getName());
    	cmdList.add("-mp");
    	cmdList.add(mvInfo.getMp());
    	cmdList.add("-exsz");
    	cmdList.add(Float.toString(extendSize));
    	cmdList.add("-mvpool");
    	String[] aidArr = mvInfo.getAid().split(",");
    	String aid = aidArr[0];
    	String[] poolNoArr = (mvInfo.getSelectedPoolNo()).split(",");
    	StringBuffer poolNoSb = new StringBuffer();
    	poolNoSb.append(aid).append("(").append(poolNoArr[0]).append(")");
    	for (int i = 1; i < poolNoArr.length; i++) {
            poolNoSb.append("#").append(aid).append("(").append(poolNoArr[i]).append(")");
        }
    	cmdList.add(poolNoSb.toString());
    	cmdList.add("-mvnode");
    	cmdList.add(mvInfo.getNode());
    	if(!(rv0Info.getName().equals(""))){
    		cmdList.add("-rv0");
    		cmdList.add(rv0Info.getName());
    		cmdList.add("-rv0pool");
    		cmdList.add(rv0Info.getSelectedPoolName());
    		cmdList.add("-rv0wwnn");
    		cmdList.add(rv0Info.getWwnn());
    	}
    	if(!(rv1Info.getName().equals(""))){
    		cmdList.add("-rv1");
    		cmdList.add(rv1Info.getName());
    		cmdList.add("-rv1pool");
    		cmdList.add(rv1Info.getSelectedPoolName());
    		cmdList.add("-rv1wwnn");
    		cmdList.add(rv1Info.getWwnn());
    	}
    	if(!(rv2Info.getName().equals(""))){
    		cmdList.add("-rv2");
    		cmdList.add(rv2Info.getName());
    		cmdList.add("-rv2pool");
    		cmdList.add(rv2Info.getSelectedPoolName());
    		cmdList.add("-rv2wwnn");
    		cmdList.add(rv2Info.getWwnn());
    	}
    	cmdList.add("-striped");
    	cmdList.add("false");

    	CmdExecBase.execCmd(cmdList.toArray(new String[0]),nodeNo);
    }

}
