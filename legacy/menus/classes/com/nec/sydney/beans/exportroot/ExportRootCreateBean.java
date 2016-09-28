/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.exportroot;

import java.util.regex.*;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.beans.base.*;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import javax.servlet.*;

public class ExportRootCreateBean extends TemplateBean
{
    private static final String cvsid = "@(#) $Id: ExportRootCreateBean.java,v 1.8 2005/08/22 05:40:17 wangzf Exp $";
    private static final String EG_EXPORTROOT_CREATE_RESULT_JSP = "/menu/nas/exportroot/exportrootcreateresult.jsp";
    private static final String EG_EXPORTROOT_CREATE_JSP = "../nas/exportroot/exportrootcreate.jsp";
    private static final String REQUEST_PARAMETER_EXPORT_ROOT_NAME = "exportGroupName";
    private static final String REQUEST_PARAMETER_CODEPAGE_NAME = "codePage";
    private static final String SCIRPT_ADD_EXPORT_GROUP = "/bin/exportgroup_add.pl";
    private static final String COMMAND_GET_HOSTNAME = "/bin/hostname";
    
    private static final String ERR_CODE_ADD_EXISTED_SELF = "0x10600002";
    private static final String ERR_CODE_ADD_EXISTED_PARTNER = "0x10600003";
    private static final String ERR_CODE_ADD_EXPORTGROUP_DIR = "0x10600004";
    private static final String ERR_CODE_ADD_LUDB_PATH = "0x10600005";
    private static final String ERR_CODE_ADD_EXPORTGROUP_IN_PARTNER = "0x10600006";
    private static final String ERR_CODE_ADD_LUDB_IN_PARTNER = "0x1060000C";
    private static final String ERR_CODE_ADD_EXPORTGROUP_FILE = "0x1060000E";

    private String hostname = "";
    
    public ExportRootCreateBean(){}
    
    public void onDisplay() throws Exception{
        String eg = request.getParameter("hasExportGroup");
        if(eg!=null && eg.equals("0")){
            setHostName();
        }
    }
    
    public void onSet() throws Exception{
        String exportRootName = request.getParameter(REQUEST_PARAMETER_EXPORT_ROOT_NAME);
        String codePage = request.getParameter(REQUEST_PARAMETER_CODEPAGE_NAME);
        String[] msgArray = new String[1];
        msgArray[0] = exportRootName;
        exportRootName = "/export/"+exportRootName;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+
                        SCIRPT_ADD_EXPORT_GROUP,
                        Integer.toString(groupNo),
                        exportRootName,
                        codePage};
        try {
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,groupNo);
        }catch(NSException e){
            if(e.getErrorCode().equals(ERR_CODE_ADD_EXISTED_PARTNER)){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/exist_in_friendTarget", msgArray));
                response.sendRedirect(response.encodeRedirectURL(EG_EXPORTROOT_CREATE_JSP));
                return;
            }else if(e.getErrorCode().equals(ERR_CODE_ADD_EXISTED_SELF)){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
			+ NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/exportexist", msgArray));
                response.sendRedirect(response.encodeRedirectURL(EG_EXPORTROOT_CREATE_JSP));
                return;
            }else if(e.getErrorCode().equals(ERR_CODE_ADD_LUDB_PATH)||e.getErrorCode().equals(ERR_CODE_ADD_LUDB_IN_PARTNER)){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
			+ NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/addexport_local", msgArray));
                response.sendRedirect(response.encodeRedirectURL(EG_EXPORTROOT_CREATE_JSP));
                return;
            }else if(e.getErrorCode().equals(ERR_CODE_ADD_EXPORTGROUP_DIR)||e.getErrorCode().equals(ERR_CODE_ADD_EXPORTGROUP_IN_PARTNER)||e.getErrorCode().equals(ERR_CODE_ADD_EXPORTGROUP_FILE)){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
			+ NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/addexport_path", msgArray));
                response.sendRedirect(response.encodeRedirectURL(EG_EXPORTROOT_CREATE_JSP));
                return;
            }else{
                throw e;
            }
        }
        RequestDispatcher  dispatcher = request.getRequestDispatcher(EG_EXPORTROOT_CREATE_RESULT_JSP);
        dispatcher.forward(request, response);
        return;
    }
    
    private void setHostName() throws Exception{
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = {SUDO_COMMAND,
                        COMMAND_GET_HOSTNAME,
                        "-s"};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,groupNo);
        String[] result = cmdResult.getStdout();
        if (result.length>0){
            hostname = result[0];
        }

        if (hostname.length()>15){
            hostname = hostname.substring(0,15);
        }
        
        Pattern p = Pattern.compile("[^0-9a-zA-Z_]");
        Matcher m = p.matcher(hostname);
        hostname = m.replaceAll("_");
    }

    public String getHostName(){
        return hostname;
   }
}