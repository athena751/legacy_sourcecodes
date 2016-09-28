/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.exportroot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.beans.base.*;
import java.util.*; 
import com.nec.nsgui.action.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.action.base.NSActionUtil;

/****************************************************************

* this program is designed for the ExportGroup to display CIFS share*     

* infomation.                                                        *

*******************************************************************/
public class EGCIFSShareListBean extends TemplateBean implements EGConstants
{
    private static final String     cvsid = "@(#) $Id: EGCIFSShareListBean.java,v 1.2306 2005/12/14 06:19:02 fengmh Exp $";
    private List shareList = new ArrayList();
    private String securityMode = "";
    private String mountPoint = "";
    private static final String SCIRPT_GET_SHARE_LIST_INFO_FILE
        = "/bin/cifs_getShareListInfo.pl";

    
    public void onDisplay() throws Exception{
        mountPoint = request.getParameter("mountPoint");
        String codePage = request.getParameter("codepage");
        String slashedMP = mountPoint+"/";

        String localDomain   = (String)request.getParameter(EG_REQUEST_LOCALDOMAIN);
        String netBIOS       = (String)request.getParameter(EG_REQUEST_NETBIOS);

        securityMode = (String)request.getParameter(EG_REQUEST_SECURITYMODE);
        
        List shareInfoList = getShareLists(NSActionUtil.getCurrentNodeNo(request), localDomain, netBIOS, true);
        
        for(int i=0; i<shareInfoList.size(); i++){
            ShareInfoBean sib = (ShareInfoBean)shareInfoList.get(i);
            String sharePath = (String)sib.getDirectory();
            if((sharePath.startsWith(slashedMP)||sharePath.equals(mountPoint))){
                sib.setShareName(NSActionUtil.perl2Page(sib.getShareName(),codePage));
                sib.setDirectory(NSActionUtil.perl2Page(sib.getDirectory(),codePage));
                sib.setComment(NSActionUtil.perl2Page(sib.getComment(),codePage));
                shareList.add(sib);
            }
        }	
    }
    
    public List getShareList(){
        return this.shareList;  
    }
    
    public String getSecurityMode(){
        return this.securityMode;
    }    
    
    public String getMountPoint(){
        return mountPoint;
    }
    
    private List getShareLists(int group, String domainName, String computerName, boolean doWhenMaintance)
        throws Exception {
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GET_SHARE_LIST_INFO_FILE,
                Integer.toString(group),
                domainName,
                computerName };
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
            String[] results = cmdResult.getStdout();
            
            return NSBeanUtil.createBeanList(
                    "com.nec.sydney.atom.admin.exportroot.ShareInfoBean", 
                    results, 7);
    }
    
}