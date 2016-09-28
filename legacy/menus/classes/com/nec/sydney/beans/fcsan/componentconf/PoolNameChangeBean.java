/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import java.io.*;
import java.util.*;

public class PoolNameChangeBean
    extends FcsanAbstractBean
    implements FCSANConstants {

    private static final String cvsid =
        "@(#) $Id: PoolNameChangeBean.java,v 1.1 2005/12/16 05:07:28 liyb Exp $";

    private int result;
    public PoolNameChangeBean() {
        result = 0;
    }

    public void beanProcess() throws Exception {
        //get all parameters from request
        String diskarrayname = request.getParameter("diskarrayname");
        String diskarrayid = request.getParameter("diskarrayid");
        String poololdname = request.getParameter("poololdname");
        String poolnewname = request.getParameter("poolnewname");

        if (diskarrayname == null
            || diskarrayname.equals("")
            || diskarrayid == null
            || diskarrayid.equals("")
            || poololdname == null
            || poololdname.equals("")
            || poolnewname == null
            || poolnewname.equals("")) {
            NSException ex =
                new NSException(
                    NSMessageDriver.getInstance().getMessage(
                        session,
                        "fcsan_common/exception/invalid_param"));
            throw ex;
        }

        //get pools' info
        String cmd = CMD_DISKLIST_POOL + " " + diskarrayid;
        BufferedReader resultbuf = execCmd(cmd);
   
        if (resultbuf != null) {
            //if poolnew name has already exist 
            String resultOneLine = resultbuf.readLine();
           
            //to find record below "-----------"
            while (resultOneLine != null) {
                execCmd(CMD_DISKLIST_D);
                if (resultOneLine.startsWith(SEPARATED_LINE)) {
                    break;
                }
                resultOneLine = resultbuf.readLine();
            
            }

            resultOneLine = resultbuf.readLine();           

            while (resultOneLine != null) {
              
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME))) {

                    StringTokenizer poolPropertys =
                        new StringTokenizer(resultOneLine.trim());
                    String strPoolProperty=poolPropertys.nextToken();
                    strPoolProperty=poolPropertys.nextToken();
                   
                    //  the pool has already existed
                    if (poolnewname.equals(strPoolProperty)) {
                        setErrorCode(FCSANConstants.iSMSM_ALREADY);
                        result = 1;
                        return;
                    }

                    resultOneLine = resultbuf.readLine();
                }else{
                    break;    //go on to change pool name 
                }
               
            } // end of while
        } else {
            result = 1;
            return;
        }

        //change name ,sudo /opt/nec/nsadmin/sbin/iSAsetname -spool -aname array_name -oldname pool_oldname -newname pool_newname -restart
        cmd =
            CMD_DISKSETNAME_SPOOL
                + " "
                + diskarrayname
                + "  -oldname   "
                + poololdname
                + "  -newname   "
                + poolnewname
                + "  -restart   ";
        resultbuf = execCmd(cmd);
        if (resultbuf != null) {
            result = 0;
        } else {
            result = 1;
        }
    }

    public int getResult() {
        return result;
    }

}