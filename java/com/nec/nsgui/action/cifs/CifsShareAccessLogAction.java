/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.LinkedHashMap;
import java.util.Map;

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
import com.nec.nsgui.model.entity.cifs.CifsShareAccessLogBean;

/**
 *
 */
public class CifsShareAccessLogAction
    extends DispatchAction
    implements CifsActionConst, NSActionConst {

    private static final String cvsid =
        "@(#) $Id: CifsShareAccessLogAction.java,v 1.2 2005/06/19 06:08:37 key Exp $";

    private static final String[] LOGGING_ITEMS =
        {
            "DISCONNECT",
            "MKDIR",
            "RMDIR",
            "CREATE_OPEN",
            "UNLINK",
            "CLOSE",
            "FILECOPY",
            "MV",
            "READ",
            "WRITE",
            "SEARCH",
            "GETDISK",
            "GETINFO",
            "SETINFO",
            "LOCK",
            "UNLOCK",
            "FLUSH",
            "IOCTL",
            "OTHER" };

    private static final String LOGITEM_MSGKEY_PREFIX =
        "cifs.shareAccessLog.logitem.";

    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName =
            (String) session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName =
            (String) session.getAttribute(
                CifsActionConst.SESSION_COMPUTER_NAME);
        String sessionShareName = (String)session.getAttribute("shareName");
        String shareName = NSActionUtil.page2Perl(sessionShareName,request);
        String encShareName =
            NSActionUtil.reqStr2EncodeStr(sessionShareName, BROWSER_ENCODE);

        CifsShareAccessLogBean bean =
            CifsCmdHandler.getShareAccessLog(
                group,
                domainName,
                computerName,
                shareName);

        String[] successItems = bean.getSuccessLoggingItems();
        String[] errorItems = bean.getErrorLoggingItems();

        String logType = "all";
        if ((successItems != null
            && successItems.length > 0
            && !successItems[0].equals("COLLECTALL"))
            || (errorItems != null
                && errorItems.length > 0
                && !errorItems[0].equals("COLLECTALL"))) {
            logType = "custom";
        }

        dynaForm.set("logType", logType);
        //dynaForm.set("shareName", encShareName);
        dynaForm.set("info", bean);
        dynaForm.set("shareName", encShareName);

        Map shareLoggingItems = new LinkedHashMap();
        for (int i = 0; i < LOGGING_ITEMS.length; i++) {
            shareLoggingItems.put(
                LOGGING_ITEMS[i],
                LOGITEM_MSGKEY_PREFIX + LOGGING_ITEMS[i]);
        }
        request.setAttribute("shareLoggingItems", shareLoggingItems);
        return mapping.findForward("display");
    }

    public ActionForward set(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName =
            (String) session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName =
            (String) session.getAttribute(
                CifsActionConst.SESSION_COMPUTER_NAME);
        String shareName =
            NSActionUtil.page2Perl((String) dynaForm.get("shareName"), request);
        CifsShareAccessLogBean bean =
            (CifsShareAccessLogBean) dynaForm.get("info");
        CifsCmdHandler.setShareAccessLog(
            group,
            domainName,
            computerName,
            shareName,
            bean);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("enterCIFS");
    }
}
