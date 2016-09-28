/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.license;

import java.util.HashMap;
import java.util.StringTokenizer;

import com.nec.nsgui.model.biz.base.CmdExecBase;

public class LicenseInfo {
    private static final String cvsid = "@(#) $Id: LicenseInfo.java,v 1.4 2004/09/03 05:17:30 huj Exp $";
        
    private static final String chkcmd = "/home/nsadmin/bin/getLicenseInfo.sh";
    static private LicenseInfo _instance = null;
    private HashMap licenseMap0;   //the license info of Node0
    private HashMap licenseMap1;   //the license info of Node1
    
    private LicenseInfo(){
        licenseMap0 = null;
        licenseMap1 = null;
    }
    
    static public LicenseInfo getInstance() {
        if (_instance == null){
            _instance = new LicenseInfo();
        }
        return _instance;
    }
    
    /** check the component specified by key whether has the licence.
        @param nodeNo: the node/group number   
        @return:  the license number. >0, has license; <=0, no license   
    */
    public int checkAvailable(int nodeNo, String key) throws Exception{
        return checkAvailable(nodeNo, key, true);
    }

    /** check the component specified by key whether has the licence.
        @param nodeNo: the node/group number   
               refreshInfo: 
                  ture: if there is no licence now, then get the license infomation again
        @return:  the license number. >0, has license; <=0, no license   
    */    
    public int checkAvailable(int nodeNo, String key, boolean refreshInfo ) throws Exception{
        HashMap licenseMap;
        if (nodeNo == 0){
            if (licenseMap0 == null){
                this.licenseMap0 = getLicenseByNode(0);    
            }
            licenseMap = licenseMap0;
        }else{
            if (licenseMap1 == null){
                this.licenseMap1 = getLicenseByNode(1); 
            }
            licenseMap = licenseMap1;
        }
        
        int license = -1;        
        if (licenseMap.containsKey(key)) {
            license = ((Integer) licenseMap.get(key)).intValue();
        }
        if (license == 0 && refreshInfo){  //if no license,get License and  check again
            licenseMap = getLicenseByNode(nodeNo);
            if (licenseMap.containsKey(key)) {
                license = ((Integer) licenseMap.get(key)).intValue();
            }
        }
        return license;
    }
    
    public void setLicenseInfo(int nodeNo) throws Exception{
        if (nodeNo == 0){
            this.licenseMap0 = getLicenseByNode(0);
        }else {
            this.licenseMap1 = getLicenseByNode(1);    
        }
    }
    
    private HashMap getLicenseByNode(int nodeNo) throws Exception{
        HashMap licenseMap = new HashMap();
        String[] cmds = { CmdExecBase.CMD_SUDO, chkcmd };
        String[] liInfos = CmdExecBase.execCmdForce(cmds,nodeNo,true).getStdout();
        
        for (int i = 0; i < liInfos.length; i++) {
            if (liInfos[i] == null || liInfos[i].trim().equals("")){
                continue;
            }
            StringTokenizer st = new StringTokenizer(liInfos[i], ":");
            if (st.countTokens() != 2){
                continue;
            }
            licenseMap.put(st.nextToken(), new Integer(st.nextToken()));   
        }
        return licenseMap;
    }  
}
