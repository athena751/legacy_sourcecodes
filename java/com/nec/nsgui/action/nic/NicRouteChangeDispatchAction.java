/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicRouteChangeDispatchAction.java,v 1.5 2005/10/24 04:51:16 dengyp Exp $
 */

package com.nec.nsgui.action.nic;

import org.apache.struts.Globals;

import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.*;
import com.nec.nsgui.model.biz.nic.*;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.entity.nic.NicConstant;
import java.util.*;

public class NicRouteChangeDispatchAction extends DispatchAction {
    private static final String cvsid =
        "@(#) NICRouteDispatchAction.java,v 1.0 2005/06/21 07:16:49 dengyp Exp";

    /*
     * the action to set a list of routes
     * 
     * @param none
     * @successful to go forward to nicroutelist.jsp
     * @failed to go forward to nicroutechange.jsp
     *@throw exception
     */
    public ActionForward RouteSet(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        
        DynaActionForm dynaForm = (DynaActionForm) form;
        String nicNames[] = ((String) dynaForm.get("nicNames")).split(",");
        String destinations[] =
            ((String) dynaForm.get("destinations")).split(",");
        String gateways[] = ((String) dynaForm.get("gateways")).split(",");
        String set = "";
        Vector routeNotSetList;
        //get all the routes to be set          
        for (int i = 0; i < nicNames.length; i++) {
            set += destinations[i]
                + " "
                + gateways[i]
                + " "
                + nicNames[i]
                + ",";
        }
        if (set.length() > 1) {
            set = set.substring(0, set.length() - 1);

        }
        NicHandler routeHandler = new NicHandler();
        //get the routeresultlist        
        routeNotSetList = routeHandler.setRoute(set, nodeNo);
        if (routeNotSetList == null) {
            NSActionUtil.setSuccess(request);
            return mapping.findForward("changeMain");
        } else {
            String strRouteNotSetList = "";
            Locale locale =
                (Locale) request.getSession().getAttribute(Globals.LOCALE_KEY);
            for (int i = 0; i < routeNotSetList.size(); i++) {
                String tmp = (String) routeNotSetList.get(i);
                if (tmp.equals("(A)")) {
                    tmp =
                        (String) this.getResources(request).getMessage(
                            locale,
                            "error.nicrouteset.failed.add");
                } else if (tmp.equals("(D)")) {
                    tmp =
                        (String) this.getResources(request).getMessage(
                            locale,
                            "error.nicrouteset.failed.delete");
                } else {
                    String[] str = tmp.split("#");
                    if (str.length >= 2) {
                        String encoding =
                            (NSActionUtil.getLang(request.getSession()).equals(NSActionConst.LANGUAGE_JAPANESE))
                                ? NSActionConst.ENCODING_EUC_JP
                                : NSActionConst.ENCODING_ISO8859_1;
                        String fileName =NSActionConst.RESOURPATH_NIC + NicConstant.COMMON_NIC_SET_ROUTE; 
                        if(NSActionUtil.getLang(request.getSession()).equals(NSActionConst.LANGUAGE_JAPANESE)){
                            fileName += "_" + NSActionConst.LANGUAGE_JAPANESE;
                        }
                        tmp = NSActionUtil
                        .getMessage(
                            fileName,
                            "Mess_" + str[1],                                           
                            encoding);
                        if( tmp == null){
                           tmp = (String) this.getResources(request).getMessage(
                           locale,
                           "exception.th.error.unknown",NicConstant.COMMON_NIC_SET_ROUTE+"_"+str[1]);                       
                        }
                        tmp = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + str[0]
                                + " ("
                                + tmp + ")";
                    }
                }
                strRouteNotSetList += "<br>" + tmp;
            }
            NSActionUtil.setSessionAttribute(
                request,
                "routeNotSetList",
                strRouteNotSetList);
            NSException e = new NSException();
            e.setErrorCode("0x18A00001");
            throw e;
        }
    }
    /*
     *the Operation to show the route change's top page    
     *forward to nicroutechangetop.jsp
     *throw Exception
     */
    public ActionForward LoadRouteChangeTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicHandler routeHandler = new NicHandler();
        Vector routeList = routeHandler.getRouteList(true, nodeNo);
        request.setAttribute("routeList", routeList);
        Vector nicList = routeHandler.getNicNames(nodeNo,0);
        request.setAttribute("nicList", nicList);
        return mapping.findForward("changeTop");
    }

}