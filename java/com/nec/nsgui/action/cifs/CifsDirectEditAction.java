/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;

/**
 *Actions for direct edit page
 */
public class CifsDirectEditAction extends DispatchAction implements CifsActionConst, NSActionConst{
    
    private static final String cvsid = "@(#) $Id: CifsDirectEditAction.java,v 1.3 2005/06/19 06:10:37 key Exp $";
    
    private ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response,
        String targetFileType)
        throws Exception {
        int group = NSActionUtil.getCurrentNodeNo(request);
		HttpSession session = request.getSession();
		session.setAttribute(CifsActionConst.SESSION_TARGAET_FILETYPE, targetFileType);
        return mapping.findForward("cifsDirectEdit");
    }
    
	public ActionForward loadTop(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response
		)
		throws Exception {
		int group = NSActionUtil.getCurrentNodeNo(request);
		HttpSession session = request.getSession();
		String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
		String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
		String targetFileType = (String)session.getAttribute(CifsActionConst.SESSION_TARGAET_FILETYPE);
		String fileContent = CifsCmdHandler.getFileContent(group, domainName, computerName, targetFileType);
		fileContent = NSActionUtil.perl2Page(fileContent, request);
		((DynaValidatorForm)form).set("fileContent", fileContent);
		request.setAttribute("targetFileType", targetFileType);
		return mapping.findForward("direct_top_page");
	}
	
	public ActionForward loadBottom(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
       
		return mapping.findForward("direct_bottom_page");
	}
    
    private ActionForward save(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response,
        String targetFileType)
        throws Exception {
            
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String content = (String)((DynaValidatorForm) form).get("fileContent");
        String contentForDisplay = NSActionUtil.reqStr2EncodeStr(content, BROWSER_ENCODE);
        content = NSActionUtil.page2Perl(content, request);
        CifsCmdHandler.saveFileContent(group, content, domainName, computerName, targetFileType);
        NSActionUtil.setSuccess(request);
		session.setAttribute(SESSION_NEED_WARNING,"true");
        request.setAttribute("targetFileType", targetFileType);
        ((DynaValidatorForm)form).set("fileContent", contentForDisplay);
        return mapping.findForward("cifsDirectEdit");
    }
    
    public ActionForward displayForSmbConf (
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{
            return display(mapping, form, request, response, "smbConf");
    }

    public ActionForward displayForDirAccessConf (
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{
            return display(mapping, form, request, response, "dirAccessConf");
    }

    public ActionForward saveForSmbConf (
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{
            return save(mapping, form, request, response, "smbConf");
    }

    public ActionForward saveForDirAccessConf (
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{
            return save(mapping, form, request, response, "dirAccessConf");
    }

}
