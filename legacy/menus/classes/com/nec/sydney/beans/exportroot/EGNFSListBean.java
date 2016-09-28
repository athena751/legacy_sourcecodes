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
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapdcommon.*;
import java.util.*; 
import com.nec.nsgui.action.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;


/****************************************************************

* this program is designed for the ExportGroup to display NFS   *

* export infomation.                                            *

*******************************************************************/
public class EGNFSListBean extends TemplateBean{
    private static final String     cvsid = "@(#) $Id: EGNFSListBean.java,v 1.2304 2004/09/01 04:10:54 xiaocx Exp $";
    private static final String     GET_ENTRY_SCRIPT = "/bin/nfs_getentries.pl";    
    private List exportList;
    
    
    public void onDisplay() throws Exception{
        String mountPoint = request.getParameter("mountPoint");
        exportList = getEntryList(mountPoint, NSActionUtil.getCurrentNodeNo(request), true);
    } 
             
    public List getExportList(){
        return exportList;
    }
        
    public String getMountPoint(){
        return request.getParameter("mountPoint");
    }
    
    private List getEntryList(String exportGroup, int groupNo, boolean doWhenMaintance)
        throws Exception {
        List entryList = new Vector();
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + GET_ENTRY_SCRIPT,
                exportGroup,
                Integer.toString(groupNo)};
        NSCmdResult result = CmdExecBase.execCmd(cmds, groupNo,true,doWhenMaintance);
        String[] stdout = result.getStdout();

        for (int i = 0; i < stdout.length;) {
            EntryInfoBean eib = new EntryInfoBean();
            List clients = new Vector();
            String[] line = stdout[i].split("\\s+");
            eib.setDirectory(line[0]);
            eib.setIsNormal(line[1].equals("1"));
            int clientsCount = Integer.parseInt(line[2]);
            eib.setClientNum(clientsCount);
            for (int j = ++i; i < j + clientsCount; i++) {
                String curLine = stdout[i];
                ClientInfoBean cib = new ClientInfoBean();
                cib.setClientName(curLine.substring(0, curLine.indexOf("(")));
                String option =
                    curLine.substring(
                        curLine.indexOf("(") + 1,
                        curLine.length() - 1);
                if (option != null && !option.equals("")) {
                    cib.setOption(option);
                } else {
                    cib.setOption(" ");
                }
                clients.add(cib);
            }
            eib.setClients(clients);
            entryList.add(eib);
        }
        return entryList;
    }
    
    
}