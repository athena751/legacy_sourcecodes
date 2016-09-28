/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.exportroot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;
import java.util.*; 
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

/****************************************************************

* this program is designed for the ExportGroup to display*     

* mountpoint list infomation.                                  *

*******************************************************************/
public class EGMountPointListBean extends TemplateBean implements EGConstants
{
    private static final String     cvsid = "@(#) $Id: EGMountPointListBean.java,v 1.2305 2004/08/31 09:51:16 xiaocx Exp $";

    private String exportRootPath  = "";
    private String codePage  = "";
    private String localDomainName = "";
    private String netbiosName = "";
    private String securityMode = "";
    private Vector mountPointList=null;
    private static final String SCIRPT_GET_COMPUTER_INFO_FILE
        = "/bin/cifs_getComputerInfo.pl";
    
    
    public void onDisplay() throws Exception{
        

        exportRootPath = "/export/" + request.getParameter("exportgroup");
        session.setAttribute(SESSION_EXPORT_ROOT, exportRootPath);


        String groupNo;
        ClusterUtil cu = ClusterUtil.getInstance();
        groupNo = Integer.toString(NSActionUtil.getCurrentNodeNo(request));
        if(!cu.isCluster()) {
            groupNo = null;
        }
        session.setAttribute("group", groupNo);

        codePage = request.getParameter("codepage");
       
        //get local domain and netbios in the exportroot from xml;
        setDomainAndNetbios();
        //get mount point inforamtion;
        mountPointList = ExportRootSOAPClient.getMPList(this.exportRootPath,this.localDomainName,this.netbiosName, super.target, groupNo);
    }
        
    private void setDomainAndNetbios() throws Exception {
        String[] computerInfo = getComputerInfo(NSActionUtil.getCurrentNodeNo(request), exportRootPath, true);
        localDomainName = computerInfo[0];
        netbiosName = computerInfo[1];
        securityMode = computerInfo[2];
        if(localDomainName == null){
            localDomainName = "";
        }
        if(netbiosName == null){
            netbiosName = "";
        }
        if(securityMode == null){
            securityMode = "";
        }
    }
    
    public Vector getMountPointList() throws Exception {
        return mountPointList;
    }

    public String getSelectedCodePage() throws Exception {
        return codePage;
    }

    public String getLocalDomain() throws Exception {
        return localDomainName;
    }
    
    public String getNetBios() throws Exception {
        return netbiosName;
    }
    
    public String getExportRootPath() throws Exception {
        return exportRootPath;
    }

    public String getSecurityMode() throws Exception {
        return securityMode;
    }

    private String[] getComputerInfo(int group, String exportGroup, boolean doWhenMaintance)
         throws Exception {

        String[] cmds ={ CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCIRPT_GET_COMPUTER_INFO_FILE,
                 Integer.toString(group),
                 exportGroup};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
        return cmdResult.getStdout();
    }

}