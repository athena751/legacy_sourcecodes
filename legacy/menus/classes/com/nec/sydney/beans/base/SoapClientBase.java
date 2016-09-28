/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

import java.util.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.base.NSExceptionMsg;

public class SoapClientBase implements NSExceptionMsg{

    private static final String     cvsid = "@(#) $Id: SoapClientBase.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";

    public static SoapResponse execSoapServerFunc(String funcStr,String urnStr,String routerUrl) throws Exception{
        return execSoapServerFunc(null,funcStr,urnStr,routerUrl);
    }

    /*whichNode = 0: soapLite.call()   
      whichNode = 1: soapLite.callFirstNode()
      whichNode = 2: soapLite.callSecondNode()*/
    public static SoapResponse execSoapServerFunc(String funcStr,String urnStr,String routerUrl,int whichNode) throws Exception{
        return execSoapServerFunc(null,funcStr,urnStr,routerUrl,whichNode);
    }

    public static SoapResponse     execSoapServerFunc(Vector paramVec,String funcStr,String urnStr,String routerUrl) throws Exception{
        return execSoapServerFunc(paramVec,funcStr,urnStr,routerUrl,0);
    }

    /*whichNode = 0: soapLite.call()   
      whichNode = 1: soapLite.callFirstNode()
      whichNode = 2: soapLite.callSecondNode()*/
    public static SoapResponse     execSoapServerFunc(Vector paramVec,String funcStr,String urnStr,String routerUrl, int whichNode) throws Exception{
        return execSoapServerFunc(paramVec,funcStr,urnStr,routerUrl,true,whichNode);
    }

    public static SoapResponse execSoapServerFunc(Vector paramVec,String funcStr,String urnStr,String routerUrl,boolean bThrowsEx) throws Exception{
        return execSoapServerFunc(paramVec,funcStr,urnStr,routerUrl,bThrowsEx,0);
    }

    public static SoapResponse     execSoapServerFunc(Vector paramVec,String funcStr,String urnStr,String routerUrl,boolean bThrowsEx,int whichNode) throws Exception
    {
    
        boolean rtVal;
             
        if ( funcStr == null || funcStr.equals("") ||
             urnStr == null || urnStr.equals("") ||
             routerUrl == null || routerUrl.equals("") )
        {
            NSException ex = new NSException(SoapClientBase.class,NSMessageDriver.getInstance().getMessage("exception/common/invalid_param"));
            ex.setDetail("execSoapServerFunc: " + "funcStr = " + funcStr + ",urnStr = " + urnStr + ",routerUrl ="+routerUrl+".");
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        // Init the SoapLite
        SoapLite soapLite = new SoapLite();
        if(!soapLite.init(urnStr))
        {
            NSException ex = new NSException(soapLite.getClass(),NSMessageDriver.getInstance().getMessage("exception/common/soap_call"));
            ex.setDetail(soapLite.getFaultReason());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_SOAP_INIT_FAULT);
            NSReporter.getInstance().report(ex);
            throw ex;    
        }
        
        // Set the paramet 
        if (paramVec != null){
            for (int i = 0; i < paramVec.size(); i++){
                Object paramObj = paramVec.get(i);
                if (paramObj == null || 
                    !soapLite.setParameter(i+1,paramObj.getClass(),paramObj) ) {
                    NSException ex = new NSException(soapLite.getClass(),NSMessageDriver.getInstance().getMessage("exception/common/soap_param"));
                    ex.setDetail("Set parameter["+ i+"] failed. Param = " + paramObj +",method="+funcStr+",urnStr"+urnStr+",routerUrl="+routerUrl+"\n SoapLite Reason:\n" +soapLite.getFaultReason());
                    ex.setReportLevel(NSReporter.ERROR);
                    ex.setErrorCode(NAS_EXCEP_NO_SOAP_INIT_FAULT);
                    NSReporter.getInstance().report(ex);
                    throw ex;    
                } // end of if 
            } // end of for 
        }// end of paramVec
        
        //Exec the soap server function
        /*whichNode = 0: soapLite.call()   
          whichNode = 1: soapLite.callFirstNode()
          whichNode = 2: soapLite.callSecondNode()
          whichNode = 512: soapLite.callByIPAddress()*/
        switch (whichNode){
        case 1: 
            rtVal = soapLite.callFirstNode(routerUrl,funcStr);
            break;
        case 2: 
            rtVal = soapLite.callSecondNode(routerUrl,funcStr);
            break;
         case 256:
            rtVal = soapLite.callClusterGroupN(routerUrl,funcStr,0);
            break;
        case 257:
            rtVal = soapLite.callClusterGroupN(routerUrl,funcStr,1);
            break;
        case 512:
            rtVal = soapLite.callByIPAddress(routerUrl,funcStr);
            break;
       default:
            rtVal = soapLite.call(routerUrl,funcStr);
        }
        
        if(!rtVal)
        {
            NSException ex = new NSException(soapLite.getClass(),NSMessageDriver.getInstance().getMessage("exception/common/soap_call"));
            ex.setDetail(soapLite.getFaultReason());            
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_SOAP_CALL_FAULT);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        // Get the return value
        SoapResponse rtValue = (SoapResponse)soapLite.getValue();
        if (!rtValue.isSuccessful() && bThrowsEx){
            NSException ex = new NSException(soapLite.getClass(),NSMessageDriver.getInstance().getMessage("exception/common/soap_call"));
            ex.setDetail(rtValue.getErrorMessage());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(rtValue.getErrorCode());
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        return rtValue;        
    }
    
}