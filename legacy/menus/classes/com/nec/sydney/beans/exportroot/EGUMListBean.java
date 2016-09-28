/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.exportroot;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapd.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;
import java.util.*;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.biz.base.*;

/****************************************************************

* this program is designed for the ExportGroup to display *     

* userMapping(data)information.                                  *

*******************************************************************/


public class EGUMListBean extends TemplateBean{
    private static final String     cvsid = "@(#) $Id: EGUMListBean.java,v 1.2308 2004/08/31 08:21:46 xiaocx Exp $";
    
    private static final String     CMD_GET_DOMAIN_INFO = "/bin/userdb_getdomaininfo.pl";
    
    private DomainInfo domainInfo = null; //Unix Domain Information
    
    
    public void onDisplay() throws Exception {
        String exportRootName = (String)session.getAttribute(SESSION_EXPORT_ROOT);
        String fsType = request.getParameter("fsType");
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds;
        UserDBDomainConfBean userdbBean = new UserDBDomainConfBean();
        NSCmdResult cmdResult;
        //get domain's information
        cmds = new String[] {
                      SUDO_COMMAND,
                      System.getProperty("user.home")+
                      CMD_GET_DOMAIN_INFO,
                      exportRootName,
                      fsType,
                      (new Integer(groupNo)).toString()};
        cmdResult = CmdExecBase.execCmd(cmds,groupNo,true,true);

        if (cmdResult.getExitValue() == 0) {
            domainInfo = userdbBean.fillDomainInfo(cmdResult.getStdout());
        }
        return;
    }

    public DomainInfo getDomainInfo(){
        return domainInfo;
    }
    
    public String getMountPoint(){
        return request.getParameter(MP_SELECT_MOUNTPOINT_NAME);
    }
    
}