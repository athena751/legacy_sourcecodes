/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.statis.*;
import com.nec.nsgui.action.base.*;

import org.apache.struts.util.MessageResources;
import java.util.*;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

public class SurveyAction extends DispatchAction implements CollectionConst {
    public static final String cvsid 
            = "@(#) $Id: SurveyAction.java,v 1.4 2007/04/03 02:08:43 yangxj Exp $";    
    public ActionForward init(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) (request
                .getSession()
                .getAttribute(STATIS_SAMPLING_TARGETID));
        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc2, targetID);
        List list = colAssistant.getItemInfoList(targetID,request);
        SortTableModel tableMode = new ListSTModel((AbstractList) list);
        request.setAttribute("itemList", tableMode);
        request.setAttribute("alertList", list);
        return mapping.findForward("surveytop");
    }
    public ActionForward forwardModify(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        return mapping.findForward("surveymodify");
    }
    public ActionForward modifytopInit(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        return mapping.findForward("surveymodifytop");
    }
    public ActionForward surveySet(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) (request
                .getSession()
                .getAttribute(STATIS_SAMPLING_TARGETID));
        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc2, targetID);
        DynaActionForm dynaForm = (DynaActionForm) form;
        String status = (String) dynaForm.get("status");
        boolean active = (status.equals("true")) ? true : false;
        String itemID = (String) dynaForm.get("id");
        String item = (String) dynaForm.get("itemKey");
        String interval = (String) dynaForm.get("interval");
        String stockPeriod = (String) dynaForm.get("stockPeriod");
        String originalStatus = request.getParameter("originalStatus");
        String originalPeriod = request.getParameter("originalPeriod");
        String originalInterval = request.getParameter("originalInterval");
        MessageResources msgResource = (MessageResources) getResources(request);
        //cancle to check capacity
        //2005-09-26
        /*
        if (status.equals("true")
            && ((originalStatus.equals("false"))
                || (Integer.parseInt(interval)
                    <= Integer.parseInt(originalInterval))
                || (Integer.parseInt(stockPeriod)
                    >= Integer.parseInt(originalPeriod)))
            && (!(colAssistant
                .checkItemSize(itemID, item, stockPeriod, "survey")))) {
            //low space                   
            MessageResources commonMsgResource =
                (MessageResources) getServlet()
                    .getServletContext()
                    .getAttribute(
                    "common");
            String commonMsg =
                commonMsgResource.getMessage(
                    request.getLocale(),
                    CollectionConst.RESOURCE_KEY_COMMON_FAILED);
            String msg =
                msgResource.getMessage(
                    request.getLocale(),
                    CollectionConst.RESOURCE_KEY_LOWSPACE);
            NSActionUtil.setSessionAttribute(
                request,
                NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE,
                commonMsg + "\\r\\n" + msg);
            return mapping.findForward("surveymodify");
        }
        */
        try{
        colAssistant.changeStatus(active, itemID);
        colAssistant.changeStockPeriod(itemID, stockPeriod);
        colAssistant.changeInterval(itemID, interval);
        }catch(NSException ex){
        	String errmsg = ex.getMessage();
        	if(errmsg.equals(EXCEPTION_MSG1) || errmsg.substring(0,errmsg.length()-1).endsWith(EXCEPTION_MSG2)){
        		ex.setErrorCode(EXCEPTION_ERRCODE_06);
        		NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_EXCEPTION_MESSAGE, "true");
        	}
        	throw ex;
        }
        if (NSActionUtil.isCluster(request)) {
            SamplingHandler.syncSampling();
        }
        NSActionUtil.setSuccess(request);
        return mapping.findForward("survey");
    }
    public ActionForward deleteData(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) (request
                .getSession()
                .getAttribute(STATIS_SAMPLING_TARGETID));
        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc2, targetID);
        DynaActionForm dynaForm = (DynaActionForm) form;
        String itemID = (String) dynaForm.get("id");
        try{
        colAssistant.deleteData(itemID);
        }catch(NSException ex){
        	String errmsg = ex.getMessage();
        	errmsg = errmsg.substring(0,errmsg.length()-1);
        	if(errmsg.endsWith(EXCEPTION_MSG2)){
        		ex.setErrorCode(EXCEPTION_ERRCODE_05);
        		NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_EXCEPTION_MESSAGE, "true");
        	}
        	throw ex;
        }
        if (NSActionUtil.isCluster(request)) {
            SamplingHandler.syncSampling();
        }
        NSActionUtil.setSuccess(request);
        return mapping.findForward("survey");
    } 
}