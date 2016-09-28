/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.serverprotect;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectGlobalOptionBean;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectScanServerBean;

public class ServerProtectScanServerAction extends DispatchAction 
        implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectScanServerAction.java,v 1.2 2007/08/23 04:56:00 fengmh Exp $";
    
    public ActionForward load(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_SERVERPROTECT_DOMAINNAME);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        
        String[] ludbUsers = ServerProtectHandler.getLudbUsers(nodeNumber, 
                domainName, computerName, CONST_SCAN_SHARE_TYPE_REALTIME);
        if(ludbUsers != null && ludbUsers.length != 0) {
            request.setAttribute(REQUEST_LUDB_USERS, ludbUsers);
        } 
        
        request.setAttribute(REQUEST_HASCONFIGFILE,
                ServerProtectHandler.haveConfigFile(nodeNumber, computerName, false));
        
        //get service interfaces
        String[] serviceInterfaces = ServerProtectHandler.getServiceInterfaces(nodeNumber); 
        if(!serviceInterfaces[0].equals("")) { 
            String[] nic = serviceInterfaces[0].split("\\s+");
            String[] nicLabel = serviceInterfaces[1].split("\\s+");   
            request.setAttribute(REQUEST_NIC, nic);
            request.setAttribute(REQUEST_NICLABEL, nicLabel);
        }
        
        DynaActionForm scanServerForm = (DynaActionForm) form;
        
        //get global option information from '[export]' section in config file
        ServerProtectGlobalOptionBean globalOption = ServerProtectHandler
                .getGlobalOptionBean(nodeNumber, computerName, false);
        scanServerForm.set(CONST_SCANSERVER_FORM_GLOBALOPTION, 
                globalOption);
        
        //get scan server info list from '[server]' section in config file,
        //and put them into a string for page use
        List scanServerList = ServerProtectHandler.getScanServerList(
                nodeNumber, computerName);
        ServerProtectScanServerBean[] scanServer = {};        
        scanServer = (ServerProtectScanServerBean[]) scanServerList.toArray(scanServer);
        String scanServerInfo = "";
        for(int i = 0; i < scanServer.length; i++){
            if(i != 0) {
                scanServerInfo = scanServerInfo + ';';
            }
            scanServerInfo = scanServerInfo 
                    + scanServer[i].getHost() + " <=> "
                    + scanServer[i].getInterfaces();
        }        
        scanServerForm.set(CONST_SCANSERVER_FORM_SCANSERVER, 
                scanServerInfo);
        
        return mapping.findForward("scanservertop");
    }
    
    public ActionForward set(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        DynaActionForm scanServerForm = (DynaActionForm) form;
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String exportName = NSActionUtil.getExportGroupPath(request)
                .trim().replaceAll("\\/*$", "");
        String domainName = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_SERVERPROTECT_DOMAINNAME);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        String fileExtension = ((ServerProtectGlobalOptionBean)
                scanServerForm.get(CONST_SCANSERVER_FORM_GLOBALOPTION))
                .getExtension();
        String ludbUser = ((ServerProtectGlobalOptionBean)
                scanServerForm.get(CONST_SCANSERVER_FORM_GLOBALOPTION))
                .getLudbUser();
        String scanServerInfo = ((String)scanServerForm.get(CONST_SCANSERVER_FORM_SCANSERVER))
                .replaceAll("\\s*<=>\\s*", ",");           
        String scanUserChange = (String)scanServerForm.get(CONST_SCANSERVER_FORM_SCANUSERCHANGE);
        String scanServerChange = (String)scanServerForm.get(CONST_SCANSERVER_FORM_SCANSERVERCHANGE);
        
        ServerProtectHandler.setScanServer(nodeNumber, exportName, domainName,
                computerName, fileExtension, ludbUser, scanServerInfo, 
                scanUserChange, scanServerChange);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setsuccess");
    }
    
    public ActionForward delete(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{        
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);               
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);              
        ServerProtectHandler.deleteConfigFile(nodeNumber, computerName);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setsuccess");
    }

}
