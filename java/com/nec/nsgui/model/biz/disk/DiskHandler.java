/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.disk;

import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.disk.*;

/**
 * handler class for nas switch module
 */
public class DiskHandler implements DiskConstant {
	private static final String cvsid ="@(#) $Id: DiskHandler.java,v 1.9 2008/11/26 09:16:30 chenb Exp $";

	public static String getPoolNumber(String arrayid) throws Exception{
	    String[] cmds ={SUDO_COMMAND,
	                    System.getProperty("user.home")+SCRIPT_GET_NEW_POOL_NUMBER,
				        arrayid};
		NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        return  (result.getStdout())[0];
    }
    
    public static String getUnUsedPD(String arrayid,String pdgn) throws Exception{
        String[] cmds ={SUDO_COMMAND,
	                    System.getProperty("user.home")+SCRIPT_GET_UNUSED_PD_INFO,
				        arrayid,pdgn};
		NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
		String[] stdout = result.getStdout(); // xxh-yyh,cccc
        StringBuffer pdall = new StringBuffer();
		for (int i = 0; i < stdout.length; i++){
		    if (i>0){
                pdall.append("#");
            }
		    pdall.append(stdout[i].trim());
		}
		return pdall.toString();
	}
	
	public static void bindPool(PoolInfoBean poolinfo,String diskarrayname, String pdgn) throws Exception{
	    //$arrayname,$pdGNO,$pd,$poolno,$poolname,$raidtype,$basepd,$rebtime
	    String raidtype = poolinfo.getRaidtype();
	    String basepd = "-";
	    if (raidtype.equals("6_6")){
	        raidtype = "6";
	        basepd = "6";
	        
	    }
	    if (raidtype.equals("6_10")){
	        raidtype = "6";
	        basepd = "10";
	    }
	    String pd = poolinfo.getUsedpd(); // xxh-yyh,cccc\nxxh-yyh,cccc
	    String[] pdinfo = pd.split("#"); //xxh-yyh,cccc
	    String pdnline ="";
	    for (int i=0;i<pdinfo.length;i++){
	        String pdn = (((pdinfo[i]).split(","))[0]).substring(4); //yyh
	        if(i>0){
			    pdnline = pdnline +",";
			}
			pdnline = pdnline + pdn;
	    }
	    String[] cmds ={SUDO_COMMAND,
	                    System.getProperty("user.home")+SCRIPT_BIND_POOL,
	                    diskarrayname,
	                    pdgn,
                        pdnline,
	                    poolinfo.getPoolnum(),
	                    poolinfo.getPoolname(),
	                    raidtype,
	                    basepd,
	                    poolinfo.getRbtime()};
	                    
		NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
    }
    
    public static Vector getRaid6PoolList(String arrayid,String pdgn)throws Exception{
        Vector raid6PoolV  = new Vector();
        String[] cmds ={SUDO_COMMAND,
                        System.getProperty("user.home")+SCRIPT_GET_RAID6_POOL_LIST,
                        arrayid,pdgn};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        String[] stdout = result.getStdout(); // name(yyh)
        for(int i = 0;i<stdout.length ; i++){
            raid6PoolV.add(stdout[i].trim());
        }
        return raid6PoolV;
    }
    
    public static String getPoolPD (String arrayid,String pooln)throws Exception{
        String[] cmds ={SUDO_COMMAND,
                        System.getProperty("user.home")+SCRIPT_GET_ONE_POOL_PD,
                        arrayid,pooln};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        String[] stdout = result.getStdout(); // xxh-yyh,cccc
        StringBuffer pdall = new StringBuffer();
        for (int i = 0; i < stdout.length; i++){
            if (i>0){
                pdall.append("#");
            }
            pdall.append(stdout[i].trim());
        }
        return pdall.toString();
    
    }
    public static String getPoolInfo (String arrayid,String pooln)throws Exception{
        String[] cmds ={SUDO_COMMAND,
                        System.getProperty("user.home")+SCRIPT_GET_ONE_POOL_INFO,
                        arrayid,pooln};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        String[] stdout = result.getStdout(); // ccc,type
        return stdout[0].trim();
    }
    
    public static void expandPool(PoolInfoBean poolinfo,String diskarrayname,String pdgn)throws Exception{
        String pd = poolinfo.getUsedpd();
        String basepd = poolinfo.getRaidtype().substring(2);//10|6
        String[] pdinfo = pd.split("#"); //xxh-yyh,cccc
        
        String emode = poolinfo.getExpandmode();
        String etime = poolinfo.getExpandtime();
        
        String pdnline ="";
        for (int i=0;i<pdinfo.length;i++){
            String pdn = (((pdinfo[i]).split(","))[0]).substring(4); //yyh
            if(i>0){
                pdnline = pdnline +",";
            }
            pdnline = pdnline + pdn;
        }
        String poolname = poolinfo.getPoolname();
        poolname = poolname.substring(0,poolname.indexOf("("));
        String[] cmds ={SUDO_COMMAND,
                        System.getProperty("user.home")+SCRIPT_EXPAND_POOL,
                        diskarrayname,
                        pdgn,
                        poolname,
                        pdnline,
                        emode,
                        etime};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true); 
    }
    
    public static String bindPoolinfo(PoolInfoBean poolinfo,String diskarrayname, String pdgn) throws Exception{
	    //$arrayname,$pdGNO,$pd,$poolno,$poolname,$raidtype,$basepd,$rebtime
	    String raidtype = poolinfo.getRaidtype();
	    String basepd = "-";
	    if (raidtype.equals("6_6")){
	        raidtype = "6";
	        basepd = "6";
	        
	    }
	    if (raidtype.equals("6_10")){
	        raidtype = "6";
	        basepd = "10";
	    }
	    String pd = poolinfo.getUsedpd(); // xxh-yyh,cccc\nxxh-yyh,cccc
	    String[] pdinfo = pd.split("#"); //xxh-yyh,cccc
	    String pdnline ="";
	    for (int i=0;i<pdinfo.length;i++){
	        String pdn = (((pdinfo[i]).split(","))[0]).substring(4); //yyh
	        if(i>0){
			    pdnline = pdnline +",";
			}
			pdnline = pdnline + pdn;
	    }
	    String[] cmds ={SUDO_COMMAND,
	                    System.getProperty("user.home")+SCRIPT_BIND_POOL_FORCAPACITY,
	                    diskarrayname,
	                    pdgn,
                        pdnline,
	                    poolinfo.getPoolnum(),
	                    poolinfo.getPoolname(),
	                    raidtype,
	                    basepd,
	                    poolinfo.getRbtime()};
	                    
		NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
		String ca = (result.getStdout())[0].trim();
        return ca;
    }
    
    public static String expandPoolinfo(PoolInfoBean poolinfo,String diskarrayname,String pdgn)throws Exception{
        String pd = poolinfo.getUsedpd();
        String basepd = poolinfo.getRaidtype().substring(2);//10|6
        String[] pdinfo = pd.split("#"); //xxh-yyh,cccc
        
        String emode = poolinfo.getExpandmode();
        String etime = poolinfo.getExpandtime();
        
        String pdnline ="";
        for (int i=0;i<pdinfo.length;i++){
            String pdn = (((pdinfo[i]).split(","))[0]).substring(4); //yyh
            if(i>0){
                pdnline = pdnline +",";
            }
            pdnline = pdnline + pdn;
        }
        String poolname = poolinfo.getPoolname();
        poolname = poolname.substring(0,poolname.indexOf("("));
        String[] cmds ={SUDO_COMMAND,
                        System.getProperty("user.home")+SCRIPT_EXPAND_POOL_FORCAPACITY,
                        diskarrayname,
                        pdgn,
                        poolname,
                        pdnline,
                        emode,
                        etime};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        String ca = (result.getStdout())[0].trim();
        return ca;
    }
    public static String getDiskArrayType()throws Exception {
        String[] cmds={SUDO_COMMAND,System.getProperty("user.home")+SCRIPT_GETDISKARRAYTYPE};
        NSCmdResult result =CmdExecBase.localExecCmd(cmds,null,true);
        String diskarraytype=(result.getStdout())[0].trim();//S1400/S1500/D1/D3
        return diskarraytype;
    }

    public static final String SCRIPT_GET_PAIREDLD = "/opt/nec/nsadmin/bin/disk_getpairedlds.pl";
    public static Map <String, String> getPairedLdMap(String diskArrayName) throws Exception{
        String[] cmds = {SUDO_COMMAND,SCRIPT_GET_PAIREDLD, diskArrayName};
        NSCmdResult result =CmdExecBase.localExecCmd(cmds,null,true);
        TreeMap <String,String> pairedLdMap = new TreeMap <String, String> () ;
        for (String tmpValue:result.getStdout()) {
            pairedLdMap.put(tmpValue.trim(), "");
        }
        return pairedLdMap;
    }
    
    public static final String SCRIPT_GETPOOLLDHASVOLCRT = "/opt/nec/nsadmin/bin/disk_getpoolldlistfromfsbatch.pl";
    public static Map <String, String> getCreatingLdMap(String diskArrayNname) throws Exception {
    	// get LD No with script[disk_getpoolldlistfromfsbatch.pl aname actionFlag 1]
    	String actionFlag = "GET_LD";
    	String[] cmds = {SUDO_COMMAND,SCRIPT_GETPOOLLDHASVOLCRT, diskArrayNname, actionFlag, "1"};
        NSCmdResult result =CmdExecBase.localExecCmd(cmds, null, true);
        
        // put LD No into creatingLdMap 
        TreeMap <String, String> creatingLdMap = new TreeMap <String, String> ();
        for (String oneLdNo:result.getStdout()) {
        	if (!oneLdNo.equalsIgnoreCase("")) {
        	    creatingLdMap.put(oneLdNo.trim(), "");
        	}
        }
    	
    	return creatingLdMap;
    }
    
    public static final String GET_POOL = "GET_POOL";
    public static String[] getRankhasVolCreating(String aname) throws Exception{     
        String[] cmds ={SUDO_COMMAND, SCRIPT_GETPOOLLDHASVOLCRT, aname, GET_POOL, "1"};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
        String[] poolList = result.getStdout();
        return poolList;
    }
}