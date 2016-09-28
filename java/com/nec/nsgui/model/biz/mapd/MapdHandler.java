/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.mapd;

import java.util.Vector;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.mapd.*;

public class MapdHandler implements MapdConstant {
    private static final String     cvsid = "@(#) $Id: MapdHandler.java,v 1.1 2005/06/13 08:10:40 liq Exp $";
    private static String isSuccess = "true";
    private static String home = System.getProperty("user.home");
    
    
    public static Vector getMPList(int groupN,String shorteg) throws Exception{
        Vector dminfo =  new Vector();
        NSCmdResult ret;
        String[] cmds = new String[] {SUDO_COMMAND, 
                             home+SCRIPT_GET_DMOUNT_INFO,
                             shorteg,
                             Integer.toString(groupN),
                             "all"};
        ret = CmdExecBase.execCmd(cmds,groupN);
        if (ret.getExitValue() != 0) {
            isSuccess = "false";
            return dminfo;
        }
        Vector tmpdminfo = fillDMountInfo(ret.getStdout());
        DomainInfoBean uDomain = getDomainInfo(groupN,shorteg,"sxfs");
        DomainInfoBean wDomain = getDomainInfo(groupN,shorteg,"sxfsfw");
        if (isSuccess.equals("false")){
            return dminfo;
        }
        for (int i=0;i<tmpdminfo.size();i++){
            DMountInfoBean oneDMountInfo = (DMountInfoBean)tmpdminfo.get(i);
            if((oneDMountInfo.getHasAuth()).equals("y")){
                if ((oneDMountInfo.getFsType()).equals("sxfsfw")){
                    oneDMountInfo.setDinfo(wDomain);
                }else{
                    oneDMountInfo.setDinfo(uDomain);
                }
            }
            dminfo.addElement(oneDMountInfo);
        }
        return dminfo;
    }
    
    
    public static int setAuth(String mp, String region, int groupN) throws Exception{
        String[] cmds = new String[] {SUDO_COMMAND,
                                      SCRIPT_AUTH,
                                      "-A",
                                      region,
                                      "-d",
                                      mp,
                                      "-f",
                                      "-c",
                                      "/etc/group"+Integer.toString(groupN)+"/ims.conf"};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupN);
        return ret.getExitValue();
    }
    
    public static int deleteAuth(String mp, int groupN) throws Exception{
        String[] cmds = new String[] {SUDO_COMMAND,
                                      SCRIPT_AUTH,
                                      "-D",
                                      "-d",
                                      mp,
                                      "-f",
                                      "-c",
                                      "/etc/group"+Integer.toString(groupN)+"/ims.conf"};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupN);
        return ret.getExitValue();
    }
    
    public static DomainInfoBean getDomainInfo(int groupN,String shorteg,String type)throws Exception{
        DomainInfoBean domaininfo = new DomainInfoBean();
        String[] cmds = new String[] {SUDO_COMMAND,
                             home + SCRIPT_GET_DOMAIN_INFO,
                             shorteg,
                             type,
                             Integer.toString(groupN)};
        NSCmdResult ret =CmdExecBase.execCmd(cmds,groupN);
        if (ret.getExitValue() != 0) {
            isSuccess = "false";
            return domaininfo;
        }
        return fillDomainInfo(ret.getStdout());
    }
    
    public static String getIsSuccess(){
        return isSuccess;
    }
    
    private static Vector fillDMountInfo(String[] stdOut){
        Vector tmpV = new Vector();
        
        for (int i=0;i<stdOut.length;i++){
            String[] DMount=stdOut[i].split(","); 
            DMountInfoBean info = new DMountInfoBean();
            info.setMp(DMount[0]);
            info.setFsType(DMount[1]);
            info.setHasAuth(DMount[2]);
            info.setDomainType(DMount[3]);
            tmpV.addElement(info);
        }
        return tmpV;    
    }
    
    private static DomainInfoBean fillDomainInfo(String[] stdOut) throws Exception{
        if (stdOut.length < 21){
            return null;
        }
        DomainInfoBean tmpInfo= new DomainInfoBean();
        tmpInfo.setDomaintype(stdOut[0].trim());
        tmpInfo.setRegion(stdOut[1].trim());
        tmpInfo.setNetbios(stdOut[2].trim());
        tmpInfo.setNtdomain(stdOut[3].trim());
        tmpInfo.setNisdomain(stdOut[4].trim());
        tmpInfo.setNisserver(stdOut[5].trim());
        tmpInfo.setLudb(stdOut[6].trim());
        tmpInfo.setLdapserver(stdOut[7].trim());
        tmpInfo.setBasedn(stdOut[8].trim());
        tmpInfo.setMech(stdOut[9].trim());
        tmpInfo.setTls(stdOut[10].trim());
        tmpInfo.setAuthname(NSActionUtil.perl2Page(stdOut[11].trim(),NSActionConst.BROWSER_ENCODE));
        tmpInfo.setAuthpwd(NSActionUtil.perl2Page(stdOut[12].trim(),NSActionConst.BROWSER_ENCODE));
        tmpInfo.setCa(NSActionUtil.perl2Page(stdOut[13].trim(),NSActionConst.BROWSER_ENCODE));
        tmpInfo.setUfilter(stdOut[14].trim());
        tmpInfo.setGfilter(stdOut[15].trim());
        tmpInfo.setDns(stdOut[16].trim());
        tmpInfo.setKdcserver(stdOut[17].trim());
        tmpInfo.setUsername(stdOut[18].trim());
        tmpInfo.setPasswd(stdOut[19].trim());
        tmpInfo.setUn2dn(stdOut[20].trim());
        return tmpInfo;
    }
}
