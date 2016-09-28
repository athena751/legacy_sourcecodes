/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.mapd;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.Globals;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.mapd.MapdHandler;
import com.nec.nsgui.model.entity.mapd.MapdConstant;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

public class UserDBAction extends DispatchAction implements MapdConstant{
    private static final String cvsid = "@(#) $Id: UserDBAction.java,v 1.1 2005/06/13 08:10:23 liq Exp $";

    public ActionForward getMPList(ActionMapping mapping,
                                   ActionForm form,
                                   HttpServletRequest request,
                                   HttpServletResponse response)throws Exception{
        int groupN = NSActionUtil.getCurrentNodeNo(request);
        String shorteg = (NSActionUtil.getExportGroupPath(request)).substring(8);
        
        if (MapdHandler.getMPList(groupN,shorteg).size()>0){
            SortTableModel tableMode = new ListSTModel(MapdHandler.getMPList(groupN,shorteg));
            request.setAttribute(DMP, tableMode);
        }
        request.setAttribute(ISSUCCESS, MapdHandler.getIsSuccess());
        return mapping.findForward("getMPList");
    }
    
    public ActionForward getOneAuth(ActionMapping mapping,
                                    ActionForm form,
                                    HttpServletRequest request,
                                    HttpServletResponse response)throws Exception {
        int groupN = NSActionUtil.getCurrentNodeNo(request);
        String shorteg = (NSActionUtil.getExportGroupPath(request)).substring(8);
        String mp = (String)((DynaActionForm)form).get("mp");
        String fstype = (String)((DynaActionForm)form).get("fstype");
        String hasauth = (String)((DynaActionForm)form).get("hasauth");
        request.setAttribute(ONE_AUTH,MapdHandler.getDomainInfo(groupN,shorteg,fstype));
        request.setAttribute(DMOUNT_NAME,mp);
        request.setAttribute(DMOUNT_FSTYPE,fstype);
        request.setAttribute(DMOUNT_HAS_AUTH,hasauth);
        return mapping.findForward("getOneAuth");
    }
    
    public ActionForward setAuth (ActionMapping mapping,
                                  ActionForm form,
                                  HttpServletRequest request,
                                  HttpServletResponse response)throws Exception{
        int groupN = NSActionUtil.getCurrentNodeNo(request);
        String mp = (String)((DynaActionForm)form).get("mp");
        String region = (String)((DynaActionForm)form).get("region");
        int result = MapdHandler.setAuth(mp, region,groupN);
        if (result != 0 ){
            String alertMessage = getResources(request).getMessage(
                                        request.getLocale(),
                                        "udb.alert.fail");
            request.getSession().setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                                              alertMessage);
        }else{
            request.getSession().setAttribute(NSActionConst.SESSION_SUCCESS_ALERT,"true");
        }
        return mapping.findForward("setAuth");
    }
    
    public ActionForward deleteAuth(ActionMapping mapping,
                                    ActionForm form,
                                    HttpServletRequest request,
                                    HttpServletResponse response)throws Exception{
        int groupN = NSActionUtil.getCurrentNodeNo(request);
        String mp = (String)((DynaActionForm)form).get("mp");
        int result = MapdHandler.deleteAuth(mp,groupN);
        if (result != 0 ){
            String alertMessage = getResources(request).getMessage(
                            request.getLocale(),
                            "udb.alert.fail");
            request.getSession().setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                                  alertMessage);
        }else{
            request.getSession().setAttribute(NSActionConst.SESSION_SUCCESS_ALERT,"true");
        }
        return mapping.findForward("deleteAuth");
    }
}