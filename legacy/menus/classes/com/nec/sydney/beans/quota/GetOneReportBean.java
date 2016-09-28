/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;


import java.io.IOException;

import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;

public abstract class GetOneReportBean extends AbstractJSPBean
{

    private static final String     cvsid = "@(#) $Id: GetOneReportBean.java,v 1.2 2006/01/03 02:46:38 cuihw Exp $";
    public String[] getOneReport(
        boolean isDirQuota,
        String filesystem,
        String idnumber,
        String flagUser,
        String flagName)
        throws Exception, IOException {
        String flag = "";
        if(flagUser.equals("true")) {
            flag="user";
        } else if (flagUser.equals("false")) {
            flag="group";
        } else if (flagUser.equals("dir")){
            flag="dir" ;  
        }
        String tempidnumber = idnumber;
        if (flagName.equals("true")) {
            tempidnumber = QuotaSOAPClient.getIDFromName(target,idnumber,(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT),flag);
        }
        if (tempidnumber.startsWith(IMS_CTL_ERR_START)) {
            String replacements[]={idnumber.replaceAll("\"","\\\\\"")};   
            super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+
                   "\\r\\n"+NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/convert",replacements)); 
            if (isDirQuota){
                response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp"));
            } else {
                response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp"));
            }
            return new String[0];
        }
        return QuotaSOAPClient.getOneReport(target,filesystem,flag,tempidnumber); 
    }
}