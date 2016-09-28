/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;

import java.util.*;
import java.io.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.nsgui.model.biz.base.NSProcess;

//import com.nec.sydney.beans.mapd.*;

public class Transaction implements NasConstants,NSExceptionMsg{


    private static final String     cvsid = "@(#) $Id: Transaction.java,v 1.2301 2004/07/19 08:10:39 baiwq Exp $";

    private static final String     NAS_EXCEP_CHECKIN_FAILED = "Check in failed.";
    private static final String        NAS_EXCEP_FILE_ROLLBACK_FAILED="Rollback failed";
    public static SoapResponse checkout(String fileName)
    {
        SoapResponse trans    = new SoapResponse();
        int rnValue=NAS_SUCCESS;
        try
        {
            String home  =  System.getProperty("user.home");

            String[] cmd =new String[3];
            cmd[0]=COMMAND_SUDO.trim();            
            cmd[1]=(home+SCRIPT_DIR+COMMON_CHECKOUT).trim();
            cmd[2]=fileName.trim();
            Runtime run = Runtime.getRuntime();
            NSProcess proc = new NSProcess(run.exec(cmd));
            proc.waitFor();
            rnValue=proc.exitValue();

            if ( rnValue!= NAS_SUCCESS )
            {
                trans.setSuccessful(false);
                trans.setErrorCode(NAS_EXCEP_NO_CHECKOUT_FAILED);
                trans.setErrorMessage("Checkout failed."+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }else
            { 
                trans.setSuccessful(true);
            }
        }catch(Exception e)
        {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage(e.toString()+"  "+SOAPServerBase.stack2string(e));
        }
        return trans;
    }

    public static SoapResponse checkin(String fileName)
    {
        SoapResponse trans    = new SoapResponse();
        int rnValue=NAS_SUCCESS;
        try{
            String home  =  System.getProperty("user.home");

            String[] cmd =new String[3];
            cmd[0]=COMMAND_SUDO.trim();            
            cmd[1]=(home+SCRIPT_DIR+COMMON_CHECKIN).trim();
            cmd[2]=fileName.trim();
            Runtime run = Runtime.getRuntime();
            NSProcess proc = new NSProcess(run.exec(cmd));
            proc.waitFor();
            rnValue=proc.exitValue();
            
            if ( rnValue!= NAS_SUCCESS )
            {
                trans.setSuccessful(false);
                trans.setErrorCode(NAS_EXCEP_NO_CHECKIN_FAILED);
                trans.setErrorMessage(NAS_EXCEP_CHECKIN_FAILED+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }else
            { 
                trans.setSuccessful(true);
            }

        }catch(Exception e)
        {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage(e.toString()+"  "+SOAPServerBase.stack2string(e));
        }
        return trans;
    }

    public static SoapResponse rollback(String fileName)
    {
        SoapResponse trans    = new SoapResponse();
        int rnValue=NAS_SUCCESS;
        try{
            String home  =  System.getProperty("user.home");

            String[] cmd =new String[3];
            cmd[0]=COMMAND_SUDO.trim();            
            cmd[1]=(home+SCRIPT_DIR+COMMON_ROLLBACK).trim();
            cmd[2]=fileName.trim();
            Runtime run = Runtime.getRuntime();
            NSProcess proc = new NSProcess(run.exec(cmd));
            proc.waitFor();
            rnValue=proc.exitValue();
            
            if ( rnValue!= NAS_SUCCESS )
            {
                trans.setSuccessful(false);
                trans.setErrorCode(NAS_EXCEP_NO_FILE_ROLLBACK_FAILED);
                trans.setErrorMessage(NAS_EXCEP_FILE_ROLLBACK_FAILED+" "+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }else
            { 
                trans.setSuccessful(true);
            }
        }catch(Exception e)
        {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage(e.toString()+"  "+SOAPServerBase.stack2string(e));
        }
        return trans;
    }

}
