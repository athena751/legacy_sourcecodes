/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.entity.cifs.CifsGlobalInfoBean;

/**
 *
 */
public class CifsSetGlobalAction
    extends DispatchAction
    implements CifsActionConst {

    private static final String cvsid =
        "@(#) $Id: CifsSetGlobalAction.java,v 1.3 2005/09/08 00:06:56 key Exp $";

    private static final String[] LOGGING_ITEMS = { "CONNECT", "LOGOFF", };
    private static final String LOGITEM_MSGKEY_PREFIX =
        "cifs.globalOption.logitem.";

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

        CifsGlobalInfoBean bean =
            CifsCmdHandler.getGlobalInfo(group, domainName, computerName);
        bean.setServerString(
            NSActionUtil.perl2Page(bean.getServerString(), request));
        bean.setAlogFile(NSActionUtil.perl2Page(bean.getAlogFile(), request));

        String useAccessLog = "no";
        if (!bean.getAlogFile().trim().equals("")) {
            useAccessLog = "yes";
        }

        Map globalLoggingItems = new TreeMap();
        for (int i = 0; i < LOGGING_ITEMS.length; i++) {
            globalLoggingItems.put(
                LOGGING_ITEMS[i],
                LOGITEM_MSGKEY_PREFIX + LOGGING_ITEMS[i]);
        }

        dynaForm.set("info", bean);
        dynaForm.set("useAccessLog", useAccessLog);        
        session.setAttribute(
            CifsActionConst.SESSION_GLOBAL_LOGITEM_MAP,
            globalLoggingItems);
        session.setAttribute(
            CifsActionConst.SESSION_NIC_LIST,
            bean.getAllInterfaces());
        session.setAttribute(
            CifsActionConst.SESSION_NICLABEL_LIST,
            bean.getAllInterfacesLabel());
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
        CifsGlobalInfoBean bean = (CifsGlobalInfoBean) dynaForm.get("info");
        CifsGlobalInfoBean bean4perl =
            (CifsGlobalInfoBean) BeanUtils.cloneBean(bean);
        changEncodingForForm(bean);
        bean4perl.setServerString(
            NSActionUtil.page2Perl(bean4perl.getServerString(), request));
        bean4perl.setAlogFile(
            NSActionUtil.page2Perl(bean4perl.getAlogFile(), request));
        CifsCmdHandler.setGlobalInfo(group, domainName, computerName, bean4perl);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("displaySuccess");
    }

    private void changEncodingForForm(CifsGlobalInfoBean bean)
        throws Exception {
        bean.setServerString(
            NSActionUtil.reqStr2EncodeStr(
                bean.getServerString(),
                NSActionConst.BROWSER_ENCODE));
        bean.setAlogFile(
            NSActionUtil.reqStr2EncodeStr(
                bean.getAlogFile(),
                NSActionConst.BROWSER_ENCODE));
    }
}
