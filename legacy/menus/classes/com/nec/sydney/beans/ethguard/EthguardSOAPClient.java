/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.ethguard;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.SoapLite;
import com.nec.sydney.net.soap.SoapResponse;
import java.util.*;
import com.nec.sydney.atom.admin.ethguard.*;
import com.nec.sydney.net.soap.*;

public class EthguardSOAPClient implements NasConstants, NSExceptionMsg{
    
    private static final String     cvsid = "@(#) $Id: EthguardSOAPClient.java,v 1.2303 2007/04/25 02:32:34 chenbc Exp $";
    private static final String     URN_ETHGUARD_SERVICE = "urn:EthguardConf";
    
    public EthguardSOAPClient(){}
    
    public static int setLogStatus(String type,String routerUrl)throws Exception{
        
        Vector paramVec = new Vector();
        paramVec.add(type);
        SoapRpsInteger rt =(SoapRpsInteger)SoapClientBase.execSoapServerFunc(paramVec,"setLogStatus",URN_ETHGUARD_SERVICE,routerUrl);
        return rt.getInt();
    }
    
    public static void setAvailable(String target) throws Exception{
        SoapClientBase.execSoapServerFunc("setAvailable",URN_ETHGUARD_SERVICE,target);
    }
    
    public static void setDeny(String target) throws Exception{
        SoapClientBase.execSoapServerFunc("setDeny",URN_ETHGUARD_SERVICE,target);
    }
    
    public static EthguardInfo getEthguardInfo(String target) throws Exception{
        return (EthguardInfo)SoapClientBase.execSoapServerFunc("getEthguardInfo",
                                URN_ETHGUARD_SERVICE, target);
    }
    
    public static String getAdminIp(String target, String isCluster)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(isCluster);
        SoapRpsString rtValue 
            = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec
                                        ,"getAdminIp"
                                        ,URN_ETHGUARD_SERVICE,target);
        return rtValue.getString();
    }
    
    //below, copied from nic, for soap-clean update, updated by chenbc on 2007-04-25
    public static String getFriendNode(String target)throws Exception{
        String fnode;
        if (target.startsWith("/") && target.endsWith("@IPSAN")){
            String friendIP = getIpSanFriend(target);
            if(friendIP == null){
                return null;
            }
            fnode = SoapManager.remakeTarget(target,friendIP);
        }else{
            fnode = Soap4Cluster.whoIsMyFriend(target);
        }
        return fnode;
    }

    private static String getIpSanFriend(String target)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(target);
        SoapRpsString rtValue 
            = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec
                                        ,"getIpSanFriend"
                                        ,URN_ETHGUARD_SERVICE,target);
        return rtValue.getString();
    }
}