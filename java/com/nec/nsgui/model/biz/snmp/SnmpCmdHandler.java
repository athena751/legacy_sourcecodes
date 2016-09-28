/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.snmp;

import java.util.ArrayList;
import java.util.HashMap;

import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.snmp.CommunityFormBean;
import com.nec.nsgui.model.entity.snmp.CommunityInfoBean;
import com.nec.nsgui.model.entity.snmp.SnmpListBean;
import com.nec.nsgui.model.entity.snmp.SourceInfoBean;
import com.nec.nsgui.model.entity.snmp.SystemInfoBean;
import com.nec.nsgui.model.entity.snmp.UserInfoBean;

/**
 *
 */
public class SnmpCmdHandler {
    private static final String cvsid = "@(#) $Id: SnmpCmdHandler.java,v 1.4 2007/09/10 01:22:11 lil Exp $";
    
    //for infolist
    private static final String SCIRPT_SNMP_GET_INFOLIST
            = "/bin/snmp_getInfoList.pl";
    private static final String SCIRPT_SNMP_APPLY_SETTINGS_INFO
            = "/bin/snmp_applySettingInfo.pl";
    //for community
    private static final String SCIRPT_SNMP_GET_COMMUNITY_INFOLIST 
            = "/bin/snmp_getCommunitiesList.pl";
    private static final String SCIRPT_SNMP_GET_COMMUNITYINFO
            = "/bin/snmp_getCommunityInfo.pl";
    private static final String SCRIPT_SNMP_ADD_COMMUNITY
            = "/bin/snmp_addCommunity.pl";
    private static final String SCRIPT_SNMP_MODIFY_COMMUNITY
            = "/bin/snmp_modifyCommunity.pl";
    private static final String SCRIPT_SNMP_DELETE_COMMUNITY
            = "/bin/snmp_deleteCommunity.pl";
    private static final String SCRIPT_SNMP_GET_SOURCELIST
            = "/bin/snmp_getSourceList.pl";
    private static final String SCRIPT_SNMP_SYNCHRONIZE_PARTNER
            = "/bin/snmp_synchronizePartner.pl";
    //for user
    private static final String SCRIPT_SNMP_GET_USERINFOLIST  
            = "/bin/snmp_getUsersList.pl";
    private static final String SCIRPT_SNMP_GET_USERINFO
            = "/bin/snmp_getUserInfo.pl";
    private static final String SCIRPT_SNMP_ADD_USER
            = "/bin/snmp_addUser.pl";
    private static final String SCIRPT_SNMP_MODIFY_USER
            = "/bin/snmp_modifyUser.pl";
    private static final String SCIRPT_SNMP_DELETE_USER
            = "/bin/snmp_deleteUser.pl";
    //for system
    private static final String SCIRPT_SNMP_GET_SYSTEMINFO
            = "/bin/snmp_getSystemInfo.pl";
    private static final String SCIRPT_SNMP_MODIFY_SYSTEMINFO
            = "/bin/snmp_setSysInfo.pl";
    
    private static final String ERRCODE_PARTNER_FAILED
            = "0x12700100";
    //for partner
    private static final String TYPE_COMMUNITIES
            = "communities";
    private static final String TYPE_USERS
            = "users";
    private static final String TYPE_SYSTEM
            = "system";
    
    /*
     * For InfoList
     * 
     * add by cuihw
     */
    public static HashMap getSnmpList(boolean throwExcep)throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={CmdExecBase.CMD_SUDO,
                        System.getProperty("user.home") + SCIRPT_SNMP_GET_INFOLIST
                        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node,false);
        
        String[] stdout = cmdResult.getStdout();
        NSException nsep = CmdExecBase.errHandle(cmdResult,throwExcep);
        
        HashMap resultInfoHash = new HashMap();
        resultInfoHash.put("exception", nsep);
        
        if(stdout[0].equals("0")){
            SnmpListBean snmpList = new SnmpListBean();
            snmpList.setNodeNo(stdout[0]) ;       
            snmpList.setLocation(stdout[1]);
            snmpList.setContact(stdout[2]);
            String errorComString = stdout[3];
            if(!errorComString.equals("")){
                errorComString = "<br>"+errorComString;
            }
            int comNo = Integer.parseInt(stdout[4]);
            snmpList.setCommunityList(getCommunityListfromArray(stdout,5,4+2*comNo));
            int userNo = Integer.parseInt(stdout[5+2*comNo]);
            snmpList.setUserList(getUserListfromArray(stdout,6+2*comNo,5+2*comNo+userNo));
            HashMap snmpListInfoHash = new HashMap();
            snmpListInfoHash.put("errorComs", errorComString);
            snmpListInfoHash.put("snmpInfoList", snmpList);
            
            resultInfoHash.put("info", snmpListInfoHash);
        }else{
            String[] snmpInfoArray = stdout;
            HashMap snmpListInfoHash = new HashMap();
            for(int i = 0; i < 2; i ++){
                SnmpListBean snmpList = new SnmpListBean();
                snmpList.setNodeNo(snmpInfoArray[1]) ;       
                snmpList.setLocation(snmpInfoArray[2]);
                snmpList.setContact(snmpInfoArray[3]);
                int comNo = Integer.parseInt(snmpInfoArray[4]);
                snmpList.setCommunityList(getCommunityListfromArray(snmpInfoArray,5,4+2*comNo));
                int userNo = Integer.parseInt(snmpInfoArray[5+2*comNo]);
                snmpList.setUserList(getUserListfromArray(snmpInfoArray,6+2*comNo,5+2*comNo+userNo));
                snmpListInfoHash.put("snmpInfoList"+i, snmpList);
                String[] oldSnmpInfoArray = snmpInfoArray;
                snmpInfoArray = null;
                int lengthOfTheOtherNodeInfo = oldSnmpInfoArray.length-(5+2*comNo+userNo)-1;
                snmpInfoArray = new String[lengthOfTheOtherNodeInfo+1];
                System.arraycopy(oldSnmpInfoArray,6+2*comNo+userNo,snmpInfoArray,1,lengthOfTheOtherNodeInfo);     
            }
            resultInfoHash.put("info", snmpListInfoHash);
        }
        return resultInfoHash;
    }
    public static void applySettingsofNode(String applyNodeNo)throws Exception {
        int exeNodeNo = 1 - Integer.parseInt(applyNodeNo);
        String[] cmds ={CmdExecBase.CMD_SUDO,
                        System.getProperty("user.home") + SCIRPT_SNMP_APPLY_SETTINGS_INFO
                        };
        CmdExecBase.execCmd(cmds,exeNodeNo);
    }
    
    
    //For community list page
    public static HashMap getSnmpCommunityList(boolean throwExcep)throws Exception {
        String[] cmds ={CmdExecBase.CMD_SUDO,
                        System.getProperty("user.home") + SCIRPT_SNMP_GET_COMMUNITY_INFOLIST
                        };
        int nodeNo = ClusterUtil.getInstance().getMyNodeNo();
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,nodeNo,false);
        String[] stdout = cmdResult.getStdout();
        NSException nsep = CmdExecBase.errHandle(cmdResult,throwExcep);
        HashMap communityInfoHash = new HashMap();
        ArrayList communityList = new ArrayList();
        if(stdout[0].equals("1")){
            int comNo = Integer.parseInt(stdout[1]);
            communityList = getCommunityListfromArray(stdout,2,1+2*comNo);
            communityInfoHash.put("communityList", communityList);
        }else {
            String errorComString = stdout[1];
            if(!errorComString.equals("")){
                errorComString = "<br>"+errorComString;
            }
            communityInfoHash.put("errorComs", errorComString);
            int comNo = Integer.parseInt(stdout[2]);
            communityList = getCommunityListfromArray(stdout,3,2+2*comNo);
            communityInfoHash.put("communityList", communityList);
        }
        
        HashMap resultInfoHash = new HashMap();
        resultInfoHash.put("info", communityInfoHash);
        resultInfoHash.put("comm_max", stdout[stdout.length-1]);
        resultInfoHash.put("exception", nsep);
        return resultInfoHash;
    }
    public static String[] getCommunityInfo(String communityName) throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={CmdExecBase.CMD_SUDO,
                        System.getProperty("user.home") + SCIRPT_SNMP_GET_COMMUNITYINFO,
                        communityName
                        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node);
        String[] stdout = cmdResult.getStdout();
        return stdout;
    }
    public static void addCommunity(CommunityFormBean community)
            throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SNMP_ADD_COMMUNITY,
                community.getCommunityName(),
                community.getSourceList()};
        CmdExecBase.execCmd(cmds, node);
        processPartenerNode(TYPE_COMMUNITIES,node);
    }
    public static boolean modifyCommunity( CommunityFormBean community, String isForced)
            throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SNMP_MODIFY_COMMUNITY,
                community.getCommunityName(),
                community.getSourceList(),
                isForced };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, node);
        String[] stdout = cmdResult.getStdout();
        if(stdout[0].equals("true")){
            return true;
        }else{
            processPartenerNode(TYPE_COMMUNITIES,node);
            return false;
        }
    }
    public static boolean deleteCommunity(String communityName,String isForced)throws Exception{
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SNMP_DELETE_COMMUNITY,
                communityName,
                isForced
                };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node);
        String[] stdout = cmdResult.getStdout();
        if(stdout[0].equals("true")){
            return true;
        }else{
            processPartenerNode(TYPE_COMMUNITIES,node);
            return false;
        }
    }
    //For navigator
    public static ArrayList getSourceList() throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SNMP_GET_SOURCELIST,
                };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node);
        String[] stdout = cmdResult.getStdout();
        
        ArrayList navigatorList = new ArrayList();
        for (int i = 0; i < stdout.length; i++) {
            navigatorList.add(stdout[i]);
        }
        return navigatorList;
    }
        
    /*
     * For User
     */
    public static HashMap getSnmpUserList(boolean throwExcep)throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_SNMP_GET_USERINFOLIST
                 };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node,false);
        
        String[] stdout = cmdResult.getStdout();
        NSException nsep = CmdExecBase.errHandle(cmdResult,throwExcep);
        int userNo = Integer.parseInt(stdout[1]);
        ArrayList userList = getUserListfromArray(stdout,2,1+userNo);
        
        HashMap userInfoHash = new HashMap();
        userInfoHash.put("info", userList);
        userInfoHash.put("exception", nsep);
        
        return userInfoHash;
    }
    public static UserInfoBean getUserInfo(String userName) throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={CmdExecBase.CMD_SUDO,
                        System.getProperty("user.home") + SCIRPT_SNMP_GET_USERINFO,
                        userName
                        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,node);
        String[] stdout = cmdResult.getStdout();
        String[] protocol = stdout[0].split(" ");
        
        UserInfoBean userInfo = new UserInfoBean();
        userInfo.setUser(userName);
        userInfo.setAuthProtocol(protocol[0]);
        userInfo.setPrivProtocol(protocol[1]);
        return userInfo;
    }
    public static void addUser(UserInfoBean userInfo) throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SNMP_ADD_USER,
                userInfo.getUser(),
                userInfo.getAuthProtocol(),
                userInfo.getPrivProtocol()};
        String inputs[] = new String[2];
        inputs[0] = userInfo.getPassword();
        inputs[1] = userInfo.getPassphrase();
        CmdExecBase.execCmd(cmds, inputs, node);
        processPartenerNode(TYPE_USERS,node);
    }
    public static void modifyUser(UserInfoBean userInfo) throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SNMP_MODIFY_USER,
                userInfo.getUser(),
                userInfo.getAuthProtocol(),
                userInfo.getPrivProtocol()};
        String inputs[] = new String[2];
        inputs[0] = userInfo.getPassword();
        inputs[1] = userInfo.getPassphrase();
        CmdExecBase.execCmd(cmds, inputs, node);
        processPartenerNode(TYPE_USERS,node);
    }
    public static void deleteUser(String userName)throws Exception{
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds ={ CmdExecBase.CMD_SUDO,
                         System.getProperty("user.home") + SCIRPT_SNMP_DELETE_USER,
                         userName
                         };
        CmdExecBase.execCmd(cmds,node);
        processPartenerNode(TYPE_USERS,node);
    }
    
    /*
     * For System
     */
    public static HashMap getSystemInfo(boolean throwExcep) throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SNMP_GET_SYSTEMINFO,
                };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, node, false);
        
        String[] stdout = cmdResult.getStdout();
        NSException nsep = CmdExecBase.errHandle(cmdResult,throwExcep);
        SystemInfoBean systemInfo = new SystemInfoBean();
        systemInfo.setLocation(stdout[1]);
        systemInfo.setContact(stdout[2]);
        HashMap systemInfoHash = new HashMap();
        systemInfoHash.put("info", systemInfo);
        systemInfoHash.put("exception", nsep);
        
        return systemInfoHash;
    }
    public static void modifySysInfo(SystemInfoBean systemInfo)
            throws Exception {
        int node = ClusterUtil.getInstance().getMyNodeNo();
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SNMP_MODIFY_SYSTEMINFO,
                systemInfo.getContact(),
                systemInfo.getLocation()};
        CmdExecBase.execCmd(cmds, node);
        processPartenerNode(TYPE_SYSTEM,node);
    }
    
    /*
     * Private Function
     */
    private static ArrayList getCommunityListfromArray(String[] resultArray, int startIndex, int endIndex)throws Exception{
        ArrayList comInfoList = new ArrayList();
        for (int i = startIndex; i <= endIndex; i++) {
            CommunityInfoBean comInfo = new CommunityInfoBean();
            ArrayList sourceList = new ArrayList();        
            comInfo.setCommunityName(resultArray[i]);
            i++;
            String[] sourceArray = resultArray[i].split("\\t+");
            int n = sourceArray.length;
            for(int j = 0; j < n; j ++){
                String[] line = sourceArray[j].split("\\s+");
                SourceInfoBean sourceInfo = new SourceInfoBean();
                sourceInfo.setSource(line[0]);
                sourceInfo.setRead(line[1]);
                sourceInfo.setWrite(line[2]);
                sourceInfo.setNotify(line[3]);
                sourceInfo.setSnmpversion(line[4]);
                String filteringStatus = "-1";
                if(line.length == 6){
                    filteringStatus = line[5];
                }
                sourceInfo.setFilteringStatus(filteringStatus);
                sourceList.add(sourceInfo);
            }
            comInfo.setSourceList(sourceList);
            comInfoList.add(comInfo);
        }
        return comInfoList;
    }
    private static ArrayList getUserListfromArray(String[] resultAray, int startIndex, int endIndex)throws Exception{
        ArrayList userList = new ArrayList();  
        for (int i = startIndex; i <= endIndex; i++) {
            UserInfoBean userInfo = new UserInfoBean();
            String[] line = resultAray[i].split("\\s+");
            userInfo.setUser(line[0]);
            userInfo.setAuthProtocol(line[1]);
            userInfo.setPrivProtocol(line[2]);
            userList.add(userInfo);
        }
        return userList;
    }
    
    private static void processPartenerNode(String type, int node)throws Exception{
        if (ClusterUtil.getInstance().isCluster()) {
            String[] partnerCmds = {
                    CmdExecBase.CMD_SUDO,
                    System.getProperty("user.home") + SCRIPT_SNMP_SYNCHRONIZE_PARTNER,
                    type };
            try {
                CmdExecBase.execCmd(partnerCmds, 1 - node);
            } catch (NSException e) {
                e.setErrorCode(ERRCODE_PARTNER_FAILED);
                throw e;
            }
        }
    }
    
    
}