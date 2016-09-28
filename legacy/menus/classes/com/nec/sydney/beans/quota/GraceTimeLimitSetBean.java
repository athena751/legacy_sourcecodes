/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.quota.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;

import java.util.*;
import java.io.*;

public class GraceTimeLimitSetBean extends AbstractJSPBean implements NasConstants,NasSession,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: GraceTimeLimitSetBean.java,v 1.2302 2005/09/08 08:37:48 cuihw Exp $";
    private Vector graceTime;


    public GraceTimeLimitSetBean()
    {    
    }

    public void beanProcess() throws Exception
    {
        String DirQuota = request.getParameter("DirQuota");
        boolean isDirQuota = DirQuota==null?false:true;
        String filesystem; 
        filesystem = isDirQuota?(String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET):(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        //QuotaInfo quotainfo = new QuotaInfo();
        String actStr = request.getParameter("act");
        if (actStr == null){ //First load or refresh
            graceTime = QuotaSOAPClient.getGraceTime(filesystem, isDirQuota, super.target);
            return;
        }
        
        String userblock = request.getParameter("userblock");
        String userfile = request.getParameter("userfile");
        String groupblock = request.getParameter("groupblock");
        String groupfile = request.getParameter("groupfile");
        String dirblock = "";
        String dirfile = "";
        if (isDirQuota){
            dirblock = request.getParameter("dirblock");
            dirfile = request.getParameter("dirfile");   
        }
                
        int seconds = 0;
        if(userblock == null || userfile == null || groupblock == null || groupfile == null){          
            NSException ex = new NSException(this.getClass(),NSMessageDriver.getInstance().getMessage(session, "exception/common/invalid_param"));
            ex.setDetail("userblocktime="+userblock+",userfiletime="+userfile+",groupblocktime="+groupblock+",groupfiletime="+groupfile);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        seconds = ((new Integer(userblock)).intValue())*DAY_SECONDS;
        Integer secondsInteger = new Integer(seconds);
        userblock = secondsInteger.toString();

        seconds = ((new Integer(userfile)).intValue())*DAY_SECONDS;
        secondsInteger = new Integer(seconds);
        userfile = secondsInteger.toString();
        
        seconds = ((new Integer(groupblock)).intValue())*DAY_SECONDS;
        secondsInteger = new Integer(seconds);
        groupblock = secondsInteger.toString();

        seconds = ((new Integer(groupfile)).intValue())*DAY_SECONDS;
        secondsInteger = new Integer(seconds);
        groupfile = secondsInteger.toString();
        
        if (isDirQuota){
            seconds = ((new Integer(dirblock)).intValue())*DAY_SECONDS;
            secondsInteger = new Integer(seconds);
            dirblock = secondsInteger.toString();

            seconds = ((new Integer(dirfile)).intValue())*DAY_SECONDS;
            secondsInteger = new Integer(seconds);
            dirfile = secondsInteger.toString();
        }
 
        QuotaSOAPClient.setGraceTime(target, userblock, userfile, groupblock, groupfile, dirblock, dirfile, filesystem, isDirQuota);
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        if (isDirQuota){
            response.sendRedirect(response.encodeRedirectURL("dirgracetime.jsp?DirQuota=yes"));
              
        } else{
            response.sendRedirect(response.encodeRedirectURL("gracetime.jsp"));
        }
    }
    
    public Vector getGraceTime() {
        return graceTime;
    }
}