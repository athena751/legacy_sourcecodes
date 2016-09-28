/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.dirquota;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*;
import com.nec.sydney.atom.admin.snapshot.*;

public class DirQuotaSOAPClient implements NasConstants,NSExceptionMsg
{
    private static final String     cvsid =
        "@(#) $Id: DirQuotaSOAPClient.java,v 1.2302 2004/04/13 03:04:46 zhangjx Exp $";
    private static final String     URN_DIRQUOTA_SERVICE = "urn:DirQuotaConf";


    public static String addDataset(String routerUrl, String path, String filesystem)throws Exception{
        Vector paramVec = new Vector();
        
        paramVec.add(path);
        paramVec.add(filesystem);
        SoapResponse trans = (SoapResponse)SoapClientBase.execSoapServerFunc(paramVec,"addDataset",URN_DIRQUOTA_SERVICE,routerUrl);
        String errMsg = trans.getErrorMessage();
        return errMsg;

    }

    public static boolean getAllowAdd(String routerUrl, String path) throws Exception{
        Vector paramVec = new Vector();
        SoapRpsBoolean soaprps = new SoapRpsBoolean();
        paramVec.add(path);
        
        soaprps =(SoapRpsBoolean)SoapClientBase.execSoapServerFunc(
            paramVec,"getAllowAdd",URN_DIRQUOTA_SERVICE,routerUrl);
        return soaprps.getBoolean();
    }

    public static Vector getDirList(String routerUrl, String path) throws Exception{
        Vector paramVec = new Vector();
        SoapRpsVector soaprpsvector = new SoapRpsVector();
        paramVec.add(path);
        
        soaprpsvector =(SoapRpsVector)SoapClientBase.execSoapServerFunc(
            paramVec,"getDirList",URN_DIRQUOTA_SERVICE,routerUrl);        
        return soaprpsvector.getVector();
    }
    public static String deleteDataset(String routerUrl , String hexDataset) throws Exception
    {
        Vector paramVec = new Vector();
        
        paramVec.add(hexDataset);
        SoapResponse trans = (SoapResponse)SoapClientBase.execSoapServerFunc(paramVec,"deleteDataset",
                                        URN_DIRQUOTA_SERVICE,routerUrl);

        String errMsg = trans.getErrorMessage();
        return errMsg;

    }
}