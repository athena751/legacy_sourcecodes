/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.nfs;

import java.util.Locale;
import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nfs.NfsNavigatorList;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class NfsNavigatorListAction extends DispatchAction implements NSActionConst{

    private static final String cvsid =
        "@(#) $Id: NfsNavigatorListAction.java,v 1.4 2005/06/22 08:02:03 wangzf Exp $";

    public ActionForward call(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String rootDirectory =
            (String) ((DynaActionForm) form).get("rootDirectory");
        String nowDirectory =
            (String) ((DynaActionForm) form).get("nowDirectory");
        String fsType  =
            (String) ((DynaActionForm) form).get("fsType");

        String isSubMount =
            (String) ((DynaActionForm) form).get("isSubMount");

        String hasDomain =
            (String) ((DynaActionForm) form).get("hasDomain");
                        
        String displayDirectory;
        if (rootDirectory.equals(nowDirectory)) {
            displayDirectory = "";
        } else {
            displayDirectory =
                nowDirectory.substring(rootDirectory.length() + 1);
        }

        NSActionUtil.setSessionAttribute(request, "nfs_rootDirectory", rootDirectory);
        NSActionUtil.setSessionAttribute(request, "nfs_nowDirectory", nowDirectory);
        NSActionUtil.setSessionAttribute(request, "nfs_displayDirectory", displayDirectory);
        NSActionUtil.setSessionAttribute(request, "nfs_fsType", fsType);
        NSActionUtil.setSessionAttribute(request, "nfs_isSubMount", isSubMount);
        NSActionUtil.setSessionAttribute(request, "nfs_hasDomain", hasDomain);

        Locale locale = request.getLocale();

        NfsNavigatorList nfsNL = new NfsNavigatorList();

        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo =
            nfsNL.onList(rootDirectory, nowDirectory, locale, check, nodeNo);

        String isMount = (String) allDirectoryInfo.remove(0);
        String nowDirTrue = (String) allDirectoryInfo.remove(0);
        ((DynaActionForm) form).set("nowDirectory", nowDirTrue);
        ((DynaActionForm) form).set("isSubMount", isMount);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);

        NSActionUtil.setSessionAttribute(request, "allDirectoryInfo", allDirectoryInfo);
        return mapping.findForward("success_call");
    }

    public ActionForward callLog(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String rootDirectory =
            (String) ((DynaActionForm) form).get("rootDirectory");
        String nowDirectory =
            (String) ((DynaActionForm) form).get("nowDirectory");
        String type  =
            (String) ((DynaActionForm) form).get("type");

        String displayNowDirectory = NSActionUtil.sanitize(NSActionUtil.reqStr2EncodeStr(nowDirectory , BROWSER_ENCODE));

        NSActionUtil.setSessionAttribute(request, "nfslog_rootDirectory", rootDirectory);
        NSActionUtil.setSessionAttribute(request, "nfslog_nowDirectory", displayNowDirectory);
        NSActionUtil.setSessionAttribute(request, "nfslog_displayDirectory", displayNowDirectory);
        NSActionUtil.setSessionAttribute(request, "nfslog_type", type);

        Locale locale = request.getLocale();

        NfsNavigatorList nfsNL = new NfsNavigatorList();

        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo =
            nfsNL.onListLog(rootDirectory, nowDirectory, locale, check, nodeNo);

        String nowDirTrue = (String) allDirectoryInfo.remove(0);
        ((DynaActionForm) form).set("nowDirectory", nowDirTrue);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        
        NSActionUtil.setSessionAttribute(request, "allDirectoryInfo", allDirectoryInfo);
        return mapping.findForward("success_call");
    }

    public ActionForward list(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String rootDirectory =
            (String) ((DynaActionForm) form).get("rootDirectory");
        String nowDirectory =
            (String) ((DynaActionForm) form).get("nowDirectory");

        Locale locale = request.getLocale();

        NfsNavigatorList nfsNL = new NfsNavigatorList();

        boolean check = false;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo =
            nfsNL.onList(rootDirectory, nowDirectory, locale, check, nodeNo);
        String isSubMount = (String) allDirectoryInfo.remove(0);
        ((DynaActionForm) form).set("isSubMount", isSubMount);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        
        request.setAttribute("allDirectoryInfo", allDirectoryInfo);
        return mapping.findForward("success_list");
    }

    public ActionForward listLog(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String rootDirectory =
            (String) ((DynaActionForm) form).get("rootDirectory");
        String nowDirectory =
            (String) ((DynaActionForm) form).get("nowDirectory");

        Locale locale = request.getLocale();

        NfsNavigatorList nfsNL = new NfsNavigatorList();

        boolean check = false;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo =
            nfsNL.onListLog(rootDirectory, nowDirectory, locale, check, nodeNo);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
            
        request.setAttribute("allDirectoryInfo", allDirectoryInfo);
        return mapping.findForward("success_list");
    }
}