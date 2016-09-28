/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicHandler.java,v 1.12 2007/08/29 00:52:25 fengmh Exp $
 */

package com.nec.nsgui.model.biz.nic;

import java.util.Vector;

import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.nic.*;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;

public class NicHandler implements NicConstant {


    private static final String cvsid =
        "@(#) $Id: NicHandler.java,v 1.12 2007/08/29 00:52:25 fengmh Exp $";

    /*
     * the handlers to delete one specified interface params interfaceName
     * ,nodeNo
     */
    public void nicDelete(String interfaceName, String ex, int nodeNo) throws Exception {
        String[] cmds =
            { SUDO_COMMAND, SCRIPT_HOME + NIC_DELETE_SCRIPY, interfaceName, ex};
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    /*
     * the handlers to get all the interface's setting information
     * @params:type,nodeNo if type is false,get all the service interfaces'
     * information if type is true,get all the administrator interfaces'
     * information return Vector of NicListBean
     */
    public Vector getNicList(int type, int nodeNo) throws Exception {
        Vector NICList = new Vector();
        String[] cmds =
            { SUDO_COMMAND, SCRIPT_HOME + Get_ALLNICLIST_SCRIPY, "-s" };
        String[] cmds_m =
            { SUDO_COMMAND, SCRIPT_HOME + Get_ALLNICLIST_SCRIPY, "-m" };            
        String[] cmds_ex =
                    { SUDO_COMMAND, SCRIPT_HOME + Get_ALLNICLIST_SCRIPY, "-ex" };
        NSCmdResult cmdResult =
            (type == 0)
                ? CmdExecBase.execCmdForce(cmds, nodeNo, true)
                : (type == 1 ) ? CmdExecBase.execCmdForce(cmds_m, nodeNo, true)
                : CmdExecBase.execCmdForce(cmds_ex, nodeNo, true);
        String[] results = cmdResult.getStdout();
        if (results.length <= 1) {
            return NICList;
        }
        for (int i = 1; i < results.length; i++) {
            try {
                NicInformationBean tmp = parseInterface(results[i]);
                NICList.add(tmp);
            } catch (Exception E) {
            }
        }
        return NICList;
    }

    /*
     * the handlers to get all the interface's routes' setting information
     * @params modify,nodeNo if modify is true,get routes besides default if
     * modify is false,get all rutes return Vector of routeList
     */
    public Vector getRouteList(boolean modify, int nodeNo) throws Exception {        
        String[] cmds =
            { SUDO_COMMAND, SCRIPT_HOME + GET_ALLROUTES_SCRIPT, "-a" };
        String[] cmds_l =
            { SUDO_COMMAND, SCRIPT_HOME + GET_ALLROUTES_SCRIPT, "-l" };
        NSCmdResult cmdResult =
            (modify == false)
                ? CmdExecBase.execCmdForce(cmds, nodeNo, true)
                : CmdExecBase.execCmd(cmds_l, nodeNo);
        String[] results = cmdResult.getStdout();
        Vector NICRouteList = new Vector();
        if(modify == true){
            for (int i = 0; i < results.length; i++) {
                NicRouteBean tmp = new NicRouteBean();
                String[] tmpStr = results[i].split("\\s+");
                if(tmpStr.length == 3){
                    tmp.setDestination(tmpStr[0]);
                    tmp.setGateway(tmpStr[1]);
                    tmp.setNicName(tmpStr[2]);
                    NICRouteList.add(tmp);
                }               
            }
        }else{
            NicRouteListBean tmpList = new NicRouteListBean();
            Vector routes = new Vector();
            for (int i = 0; i < results.length; i++) {     
                String srcIP = "srcIP:";
                String[] tmpStr = results[i].split("\\s+");
                if(results[i].startsWith(srcIP)){
                    if(!tmpList.getSource().equals("") && routes.size()>0){
                         tmpList.setRoutes(routes);
                         NICRouteList.add(tmpList);       
                    }      
                    tmpList = new NicRouteListBean();
                    results[i] = results[i].substring(srcIP.length(),results[i].length());
                    tmpList.setSource(results[i]);
                    routes = new Vector();                       
                }else if(tmpStr.length == 3){
                     NicRouteBean tmp = new NicRouteBean();
                     tmp.setDestination(tmpStr[0]);
                     tmp.setGateway(tmpStr[1]);
                     tmp.setNicName(tmpStr[2]);
                     routes.add(tmp);                   
                } 
            }
            if(!tmpList.getSource().equals("") && routes.size()>0){
                  tmpList.setRoutes(routes);
                  NICRouteList.add(tmpList);
             }
        }

         return NICRouteList;
    }

    /*
     * the handler to set routelist @Param to routes to be set return the Vector
     * of unright settings. throw Exception
     */

    public Vector setRoute(String routeSet, int nodeNo) throws Exception {
        String[] cmds =
            {
                SUDO_COMMAND,                    
                    SCRIPT_HOME +
                    SET_ROUTE_SCRIPT ,
                    routeSet};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] results = cmdResult.getStdout();
        Vector setRouteResult = new Vector();
        for (int i = 0; i < results.length; i++) {
            setRouteResult.addElement(results[i]);
        }
        if (setRouteResult.size() == 0) {
            return null;
        }
        return setRouteResult; 
    }

    /*
     * the function to get  interface names 
     * params:
     *   nodeNo
     *   nameListType: if the type is 0,then get the nicnames for routing
     *                    else if the type is 1 ,get the nicnames for creating vlan
     * return : the vector
     * of interfaceNames
     */
    public Vector getNicNames(int nodeNo,int nameListType) throws Exception {
        Vector NICNames = new Vector();
        String[] cmds = { SUDO_COMMAND, SCRIPT_HOME + GET_NICNAMES_SCRIPT };
        String[] cmds_ex = { SUDO_COMMAND, SCRIPT_HOME + GET_AVAILNICLIST };
        NSCmdResult cmdResult = ( nameListType == 0 )? 
            CmdExecBase.execCmd(cmds, nodeNo):
        CmdExecBase.execCmd(cmds_ex, nodeNo);
        String[] results = cmdResult.getStdout();
        for (int i = 0; i < results.length; i++) {
            try {
                NICNames.add(results[i]);
            } catch (Exception E) {
            }
        }
        return NICNames;
    }

    public static Vector getLinkStatus(String interfaceName, int nodeNo)
        throws Exception {
        /*
         * Parameters IN: interfaceName nodeNo OUT style:nicName nicType
         * linkStatus autoNego speed communicationStatus linkAggregation nicName :
         * NIC name nicType : NIC type(e.g.:Copper) linkStatus: link
         * status(Up/Down) autoNego : allow auto negotiation or
         * not(enable/disable) speed : transfer speed communicationStatus :
         * duplex(Full-Duplex/Half-Duplex) linkAggregation : link
         * aggregation(detached/waiting/attached/collecting/distributing)
         */
         return getLinkInformation(interfaceName,nodeNo,false);
    }

    public static void setLinkStatus(Vector listToSet, int nodeNo)
        throws Exception {
        /*
         * Parameters IN nicName : NIC name options : setting
         * options(autonego/10full/10half/100full/1000full) nodeNo
         */
        for (int i = 0; i < listToSet.size(); i++) {
            String options = null;
            NicDetailLinkBean linkStatusSet =
                (NicDetailLinkBean) listToSet.get(i);
            String communicationMode = linkStatusSet.getCommunicationStatus();
            String autoNego = linkStatusSet.getAutoNego();
            if (autoNego.equals("enable")) {
                options = "autonego";
            } else {
                options = communicationMode;
            }
            
            int exitValue = setStatus(linkStatusSet.getNicName(), options, nodeNo);
            if(exitValue != 0){
                NSException exc = new NSException();
                exc.setErrorCode("0x18A000FF");
                exc.setCommandErrorCode(COMMON_NIC_SET_LINKSTATUS+"_"+ Integer.toString(exitValue));
                throw exc;
            }
        }
    }

    public static int setStatus(String nicName, String options, int nodeNo)throws Exception{
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                SCIRPT_NIC_SET_LINKSTATUS,
                nicName,
                options };    
        NSCmdResult cmdResult = null;
        cmdResult = CmdExecBase.execCmd(cmds, nodeNo,false);              
        return cmdResult.getExitValue();
    }

    /*
     * Parameters IN interfaceName : NIC name nodeNo OUT
     */
    public static NicInformationBean getInterfaceInfo(
        String interfaceName,
        int nodeNo,
        boolean getInMaintain)
        throws Exception {
        String tmpVec[] = interfaceName.split("\\:");
        String specifiedInterfaceName = "";
        if(tmpVec.length >=2){
            specifiedInterfaceName = tmpVec[0];
        }else{
            specifiedInterfaceName = interfaceName;
        }
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + Get_ALLNICLIST_SCRIPY,
                "-dev",
                specifiedInterfaceName };
        NSCmdResult cmdResult;
        if (!getInMaintain) {
            cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        } else {
            cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
        }
        String[] stdout = cmdResult.getStdout();        
        if (stdout.length <= 1) {
            return null;
        }else{
            NicInformationBean interfaceInfo = new NicInformationBean();
            boolean isAliasBase = false;
            for(int i=1;i<stdout.length;i++){
                NicInformationBean tmpInterfaceInfo = parseInterface(stdout[i]);
                if(tmpInterfaceInfo != null && tmpInterfaceInfo.getNicName().equals(interfaceName)){
                    interfaceInfo = tmpInterfaceInfo;
                }
                if(tmpInterfaceInfo != null && tmpInterfaceInfo.getNicName().matches(interfaceName + ":\\d{3,}")) {
                    isAliasBase = true;
                }
            }
            if(isAliasBase) {
                interfaceInfo.setIsAliasBase("yes");
            } else {
                interfaceInfo.setIsAliasBase("no");
            }
            return interfaceInfo.getNicName().equals("") ? null : interfaceInfo;
        }
    }

    public static NicInformationBean getInterfaceInfo(
        String interfaceName,
        int nodeNo)
        throws Exception {
        return getInterfaceInfo(interfaceName, nodeNo, false);
    }

    private static NicInformationBean parseInterface(String outStr)
        throws Exception {
        NicInformationBean nicInfo = new NicInformationBean();
        String[] tmpStr = outStr.trim().split("\\s+");
        nicInfo.setNicName(tmpStr[0]);
        nicInfo.setWorkStatus(tmpStr[1]);
        nicInfo.setLinkStatus(tmpStr[2]);
        nicInfo.setIpAddress(tmpStr[3]);
        nicInfo.setBroadcast(tmpStr[4]);
        nicInfo.setGateway(tmpStr[5]);
        nicInfo.setMacAddress(tmpStr[6]);
        nicInfo.setMtu(tmpStr[7]);
        nicInfo.setType(tmpStr[8]);
        nicInfo.setMode(tmpStr[9]);        
        nicInfo.setVl(tmpStr[10]);
        nicInfo.setAlias("");
        if(tmpStr[0].indexOf(":") != -1) {
            String aliasNum = tmpStr[0].substring(tmpStr[0].indexOf(":") + 1, tmpStr[0].length());
            if(aliasNum.length() > 2) {
                nicInfo.setAlias(aliasNum);
            }
        }
        nicInfo.setConstruction(tmpStr[12]);
        return nicInfo;
    }

    public static void setInterfaceStatus(
        NicInformationBean ifInfo,
        int nodeNo)
        throws Exception {
        /*
         * Parameters IN (NicInterfaceBean)interfaceStatus include following
         * parameter: interfaceName IP netmask gateway MTU OUT STDERR 0x18A00004 :
         * for VL,if parents of VL's MTU < interfaceStatus.MTU,error. 0x18A00005 :
         * IP has bean used. 0x18A00006 : exec command "nv_ifconfig" error.
         */
        String gw = ifInfo.getGateway();      
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home")
                    + SCIRPT_NIC_SET_INTERFACESTATUS,
                ifInfo.getNicName(),
                ifInfo.getIpAddress(),
                gw,
                ifInfo.getMtu()};

        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static NicInformationBean getDetail(
        String interfaceName,
        int nodeNo)
        throws Exception {
        return getInterfaceInfo(interfaceName, nodeNo, true);
    }

    public static Vector getDetailLink(String interfaceName, int nodeNo)
        throws Exception {       
        return getLinkInformation(interfaceName,nodeNo,true);
    }

    private static Vector getLinkInformation(String interfaceName, int nodeNo,boolean bForce)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_NIC_GET_LINKSTATUS,
                interfaceName };
        Vector link = new Vector();        
        NSCmdResult cmdResult = (bForce == true)? 
             CmdExecBase.execCmdForce(cmds, nodeNo, true): CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        for (int i = 1; i < stdout.length; i++) {
            NicDetailLinkBean detailLink = new NicDetailLinkBean();
            stdout[i] = stdout[i].trim();
            String[] tmpStr = stdout[i].split("\\s+");
            if(tmpStr.length < 8){
                continue;
            }
            detailLink.setNicName(tmpStr[0]);
            detailLink.setLinkStatus(tmpStr[1]);
            detailLink.setAutoNego(tmpStr[2]);
            detailLink.setSpeed(tmpStr[3]);            
            if(tmpStr[3].equals("Unknown") && tmpStr[4].equals("Unknown")){
                detailLink.setCommunicationStatus(tmpStr[3]);
            }else{
                detailLink.setCommunicationStatus(tmpStr[3] + " " + tmpStr[4]);
            }
            detailLink.setIfStatus(tmpStr[5]);
            detailLink.setMacAddress(tmpStr[6]);
            detailLink.setActive(tmpStr[7]);
            link.add(detailLink);
        }
        return link;
    }
    /*
     *  setVlan fucntion: to add new vlan information
     *  param:
     *      interfaceName: the constructive interface name 
     *      vid:the vid number
     */
    
    public static void setVlan(String interfaceName, String vid,int nodeNo)throws Exception {
        String[] cmds =
           {
               CmdExecBase.CMD_SUDO,
               System.getProperty("user.home")
                    +SCIRPT_NIC_SET_VLAN,               
               interfaceName,
               vid };            
            CmdExecBase.execCmd(cmds, nodeNo);
    }

    /*
      * the function to get all interface names params:nodeNo return : the vector
      * of interfaceNames
      */
     public Vector getAvailNicList4Vlan(int nodeNo) throws Exception {
         Vector NICNames = new Vector();        
         String[] cmds = { SUDO_COMMAND, SCRIPT_HOME + GET_NICNAMES_SCRIPT,"-ex" };       
         NSCmdResult cmdResult =CmdExecBase.execCmd(cmds, nodeNo);
         String[] results = cmdResult.getStdout();
         for (int i = 0; i < results.length; i++) {
             try {
                 NICNames.add(results[i]);
             } catch (Exception E) {
             }
         }
         return NICNames;
     } 
    /*
     *     *
     */ 
    public static String getNewBondName(int nodeNo) throws Exception {
        BondingInfoBean info = new BondingInfoBean();
        String[] cmds = { SUDO_COMMAND, SCRIPT_HOME + SCIRPT_NIC_GET_NEW_BOND_NAME, "-s" };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return cmdResult.getStdout()[0];
    }
    
    public static Vector getAvaiNicForCreatingBond(int nodeNo) throws Exception {
        Vector NICList = new Vector();
        String[] cmds =
            { SUDO_COMMAND, SCRIPT_HOME + SCIRPT_NIC_GET_AVAI_NIC_FOR_CREATING_BOND, "-s" };
        
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        
        String[] results = cmdResult.getStdout();
        
        for (int i = 0; i < results.length; i++) {
            NICList.add(results[i]);
        }
        return NICList;
    }

    public static void createBondingIF(BondingInfoBean infoBean, int nodeNo)
            throws Exception {

        String mode = infoBean.getMode();      
        String[] cmds ={
                    SUDO_COMMAND,
                    SCRIPT_HOME + SCIRPT_NIC_CREATE_BOND,
                    infoBean.getMode(),
                    infoBean.getSelectedIFs(),
                    infoBean.getInterval(),
                    infoBean.getPrimaryIF()};

        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    /* 
     *  the function to get the soecified bonning interface's mode,primary interface name and interval information
     * param:
     *      bondName:the bonding interface name.
     * return 
     */
    public static BondingInfoBean getBondInfo(String bondName,int nodeNo)throws Exception{       
        
        String[] cmds = { SUDO_COMMAND, SCRIPT_HOME + SCIRPT_NIC_GET_BONDINFO ,bondName};        
         NSCmdResult cmdResult =  CmdExecBase.execCmdForce(cmds, nodeNo,true);       
         String[] results = cmdResult.getStdout();
        BondingInfoBean bondInfo = new BondingInfoBean();
        bondInfo.setMode("--");
        bondInfo.setPrimaryIF("--");
        bondInfo.setInterval("--");
         if(results.length>0){
              String tmpBondInfo[] = results[0].split("\\s+");
              if(tmpBondInfo.length>=6){                  
                  bondInfo.setMode(tmpBondInfo[2]);
                  bondInfo.setInterval(tmpBondInfo[5]);
                  bondInfo.setPrimaryIF(tmpBondInfo[3]); 
              }
         }
        return bondInfo;     
    }
    
    public static String getIgnoreList(int nodeNum)throws Exception{
        String [] cmds =
        {CmdExecBase.CMD_SUDO, 
         System.getProperty("user.home") + SCIRPT_LINKDOWN_IGNORELIST_GET};
        NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNum, true);
        return cmdResult.getStdout().length > 0 ? cmdResult.getStdout()[0] : "";
        
    }
    
    public static Vector getNicForAlias(int nodeNo) throws Exception {
        Vector NICList = new Vector();
        String[] cmds = { SUDO_COMMAND, SCRIPT_HOME + GET_NIC_FOR_IPALIAS };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] results = cmdResult.getStdout();
        if (results.length < 1) {
            return NICList;
        }
        for (int i = 0; i < results.length; i++) {
            try {
                NicInformationBean nicInfo = new NicInformationBean();
                String[] tmpStr = results[i].trim().split("\\,");
                nicInfo.setNicName(tmpStr[0]);
                nicInfo.setIpAddress(tmpStr[1]);
                nicInfo.setAlias(tmpStr[2]);
                NICList.add(nicInfo);
            } catch (Exception E) {
            }
        }
        return NICList;
    }

    public static void setIPAlias(int nodeNo, String nicName, String ipAddress,
            String gateway, String alias) throws Exception {
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SET_NIC_IPALIAS, nicName,
                ipAddress, gateway, alias };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static NicLinkDownInfoBean getLinkDownInfo(int nodeNum)throws Exception{
        String [] cmds =
                {CmdExecBase.CMD_SUDO, 
                 System.getProperty("user.home") + SCIRPT_LINKDOWN_INFO_GET};
        NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNum, true);
        NicLinkDownInfoBean linkdownInfo = new NicLinkDownInfoBean();
        NSBeanUtil.setProperties(linkdownInfo, cmdResult.getStdout());
        return linkdownInfo;
    }
    
    public static String[] getInterface4Linkdown(int nodeNum)throws Exception{
        String [] cmds =
                {CmdExecBase.CMD_SUDO, 
                  System.getProperty("user.home") + SCIRPT_LINKDOWN_INTERFACES_GET};
        NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNum, true);
        return cmdResult.getStdout();        
    }
    
    public static void setLinkDownInfo(int nodeNum, 
            NicLinkDownInfoBean linkdownInfo)throws Exception{        
        String status = ClusterUtil.getMyStatus();
        //   "0": normal status
        //   "1": TakeOver status (can connect to other node; other node is active)
        //   "2": Maintain status (can not connect to other node)
        if(status.equals("2")){
            NSException e =new NSException();
            e.setErrorCode("0x10000006");
            throw e;
        }else{
            String takeOver = linkdownInfo.getTakeOver();
            String bondDown = linkdownInfo.getBondDown();
            String checkInterval = linkdownInfo.getCheckInterval();
            String ignoreList = linkdownInfo.getIgnoreList();
            String [] cmds =
                    {CmdExecBase.CMD_SUDO, 
                     System.getProperty("user.home") + SCIRPT_LINKDOWN_INFO_SET,
                     takeOver, bondDown, checkInterval, ignoreList
                     };
            CmdExecBase.execCmdForce(cmds, nodeNum, true);
        }
        
    }
    
}