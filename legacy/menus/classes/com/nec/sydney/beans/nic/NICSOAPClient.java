/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nic;

import java.util.*; 

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.*;

public class NICSOAPClient implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: NICSOAPClient.java,v 1.2302 2005/09/06 06:36:56 fengmh Exp $";
    private static final String     URN_NIC_SERVICE = "urn:NICConf";
    private static final int    SWICH_NODE_CALL_SERVER_BY_IP = 512;
    
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
                                        ,URN_NIC_SERVICE,target);
        return rtValue.getString();
    }
}