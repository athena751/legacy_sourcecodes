/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.gfs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.gfs.GfsCmdHandler;

/**
 *For System
 */
public class GfsEditAction extends DispatchAction implements GfsActionConst {
    private static final String cvsid = "@(#) $Id: GfsEditAction.java,v 1.6 2005/11/23 06:02:04 cuihw Exp $";
    
    public ActionForward displayTop(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        String fileContents = (String)NSActionUtil.getSessionAttribute( request, SESSION_GFS_FORM);
        if( fileContents == null ){
            int nodeNo = NSActionUtil.getCurrentNodeNo(request);
            ((DynaActionForm) form).set("fileInfo",
                NSActionUtil.perl2Page(GfsCmdHandler.getGfsFile(nodeNo), NSActionConst.BROWSER_ENCODE));
        }else{
            ((DynaActionForm) form).set("fileInfo",
                NSActionUtil.perl2Page(getRightString4Show(fileContents), NSActionConst.BROWSER_ENCODE));
        }
        return mapping.findForward("displayTop");
    }
    
    public ActionForward modify(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        String content = (String)((DynaActionForm)form).get("fileInfo");
        String fileContent = NSActionUtil.page2Perl(content, NSActionConst.BROWSER_ENCODE, NSActionConst.BROWSER_ENCODE);
        
        NSActionUtil.setSessionAttribute(request, SESSION_GFS_FORM, fileContent);
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        GfsCmdHandler.modifyGfsFile(fileContent,nodeNo);
        NSActionUtil.setSessionAttribute(request, SESSION_GFS_FORM, null);
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("enterGfsEdit");
    }
    private String getRightString4Show(String sourceString)
    {
        if(sourceString.startsWith("\r\n")){
            sourceString = "\r\n"+sourceString;
        }
        return sourceString;
    }
}