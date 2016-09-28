/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.exception.NSExceptionMessage;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.action.base.NSActionConst;

/**
 *
 */
public class DisplayErrorAction extends DispatchAction{
    public static final String cvsid = "@(#) $Id: DisplayErrorAction.java,v 1.2 2004/08/11 04:42:40 baiwq Exp $";
    
    public ActionForward execute(ActionMapping mapping,
                                   ActionForm form,
                                   HttpServletRequest request,
                                   HttpServletResponse response)
                           throws Exception{
        
        HttpSession session = request.getSession();
        
        NSExceptionMessage nsExceptionMessage = (NSExceptionMessage)session.getAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE_DETAIL);
        if(nsExceptionMessage != null){
            ((DynaActionForm)form).set("generalInfo", nsExceptionMessage.getGeneralInfo());
            ((DynaActionForm)form).set("detailInfo", nsExceptionMessage.getDetailInfo());
            ((DynaActionForm)form).set("detailDeal", nsExceptionMessage.getDetailDeal());
            NSException nsException = nsExceptionMessage.getCauseException();
            ((DynaActionForm)form).set("errorID", nsException.getErrorCode());
            String stdErr = nsException.getDetail();
            ((DynaActionForm)form).set("logInfo", stdErr+"\n");
            ((DynaActionForm)form).set("nsException", nsException);
            ((DynaActionForm)form).set("h1_key", request.getParameter("h1_key"));
        }
        
        return mapping.findForward("displayError");
    }
    
}
