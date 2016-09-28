/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;

import java.util.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;

public class QuotaChangeTypeBean extends AbstractJSPBean implements NasConstants,NasSession,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: QuotaChangeTypeBean.java,v 1.2302 2005/09/08 08:37:48 cuihw Exp $";
    
    public QuotaChangeTypeBean() {
    }
    
    public void beanProcess() throws Exception {
        String action = request.getParameter("action");
        String DirQuota = request.getParameter("DirQuota");
        String filesystem;
        boolean isDirQuota = false;
        if (DirQuota == null){
            filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
            isDirQuota = false;
        } else {
            isDirQuota = true;
            filesystem = (String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET);
        }
        String checkQuota = request.getParameter("check");
        if (checkQuota.equals("true")){
            checkQuota = "yes";
        } else {
            checkQuota = "no";
        }
            
        if (action.equals(NasConstants.REPQUOTA_STATUS_OFF)) {
            QuotaSOAPClient.startQuota(target,filesystem,isDirQuota);
        } else if (action.equals(NasConstants.REPQUOTA_STATUS_ON)) {
            QuotaSOAPClient.stopQuota(target,filesystem,isDirQuota);
        } else {
            NSException ex = new NSException(this.getClass(),NSMessageDriver.getInstance().getMessage(session, "exception/common/invalid_param"));
            ex.setDetail("action="+action);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        if (isDirQuota){
            response.sendRedirect(response.encodeRedirectURL("dirquotasettop.jsp?check="+checkQuota));              
        } else {
            response.sendRedirect(response.encodeRedirectURL("quotasettop.jsp?check="+checkQuota));  
        }
    }

}