/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.statis.*;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

public class SamplingAction extends DispatchAction implements CollectionConst {
    public static final String cvsid 
            = "@(#) $Id: SamplingAction.java,v 1.4 2007/04/03 02:06:53 yangxj Exp $";    
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
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        String status = mc.getTargetStatus(targetID) ? "true" : "false";
        request.setAttribute("active", status);
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc, targetID);
        List list = colAssistant.getItemInfoList("sampling",request);
        SortTableModel tableMode = new ListSTModel((AbstractList) list);
        request.setAttribute("itemList", tableMode);
        request.setAttribute("alertList", list);
        return mapping.findForward("samplingtop");
    }
    public ActionForward changeStatus(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) (request
                .getSession()
                .getAttribute(STATIS_SAMPLING_TARGETID));
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc, targetID);
        DynaActionForm dynaForm = (DynaActionForm) form;
        String status = (String) dynaForm.get("status");
        boolean active = status.equals("true") ? true : false;
        MessageResources msgResource = (MessageResources) getResources(request);
    	try{
            colAssistant.changeStatus(active, null);
        	}catch(NSException ex){
        		String errmsg = ex.getMessage();
        		if(errmsg.equals(EXCEPTION_MSG1)){
        			ex.setErrorCode(EXCEPTION_ERRCODE_03);
        			NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_EXCEPTION_MESSAGE, "true");
        		}
        		throw ex;
        	}
        if (status.equals("true")) {
            String commonMsg;
            String msg;
            //cancle to check capacity
            //2005-09-26 
            /*
            if (!colAssistant.checkTotalSize()) { //low space
                MessageResources commonMsgResource =
                    (MessageResources) getServlet()
                        .getServletContext()
                        .getAttribute(
                        "common");
                commonMsg =
                    commonMsgResource.getMessage(
                        request.getLocale(),
                        CollectionConst.RESOURCE_KEY_COMMON_FAILED);
                msg =
                    msgResource.getMessage(
                        request.getLocale(),
                        CollectionConst.RESOURCE_KEY_LOWSPACE);
                NSActionUtil.setSessionAttribute(
                    request,
                    NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE,
                    commonMsg + "\\r\\n" + msg);
                return mapping.findForward("sampling");
            } else { //enough space
            */
            
                MessageResources commonMsgResource =
                    (MessageResources) getServlet()
                        .getServletContext()
                        .getAttribute(
                        "common");
                commonMsg =
                    commonMsgResource.getMessage(
                        request.getLocale(),
                        CollectionConst.RESOURCE_KEY_COMMON_SUCCESS);
                msg =
                    msgResource.getMessage(
                        request.getLocale(),
                        CollectionConst.RESOURCE_KEY_OFF2ON_INFO);

                NSActionUtil.setSessionAttribute(
                    request,
                    NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE,
                    commonMsg + "\\r\\n" + msg);
         //   }
        } else {
            NSActionUtil.setSuccess(request);
        }
        if (NSActionUtil.isCluster(request)) {
            SamplingHandler.syncSampling();
        }
        return mapping.findForward("sampling");
    }
    public ActionForward forwardModify(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {            
        return mapping.findForward("samplingmodify");
    }
    public ActionForward modifytopInit(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {           
        return mapping.findForward("samplingmodifytop");
    }
    public ActionForward changePeriod(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) (request
                .getSession()
                .getAttribute(STATIS_SAMPLING_TARGETID));
        DynaActionForm dynaForm = (DynaActionForm) form;
        String itemKey = (String) dynaForm.get("itemKey");
        String stockPeriod = (String) dynaForm.get("stockPeriod");
        String itemID = (String) dynaForm.get("id");
        MessageResources msgResource = (MessageResources) getResources(request);
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc, targetID);
        int period = Integer.parseInt(stockPeriod);
        String original = request.getParameter("originalPeriod");
        int originalPeriod = Integer.parseInt(original);
        //cancle to check capacity
        //2005-09-26
        /*
        if (mc.getTargetStatus(targetID)
            && (period > originalPeriod)
            && (!colAssistant
                .checkItemSize(itemID, itemKey, stockPeriod, "sampling"))) {
            //failed
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
            return mapping.findForward("samplingmodify");
        }
        */
        try{
        colAssistant.changeStockPeriod(itemID, stockPeriod);
        }catch(NSException ex){
        	String errmsg = ex.getMessage();
        	errmsg = errmsg.substring(0,errmsg.length()-1);
        	if(errmsg.endsWith(EXCEPTION_MSG2)){
        		ex.setErrorCode(EXCEPTION_ERRCODE_04);
        		NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_EXCEPTION_MESSAGE, "true");
        	}
        	throw ex;
        }
        if (NSActionUtil.isCluster(request)) {
            SamplingHandler.syncSampling();
        }
        NSActionUtil.setSuccess(request);
        return mapping.findForward("sampling");
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
        DynaActionForm dynaForm = (DynaActionForm) form;
        String itemID = (String) dynaForm.get("id");
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        CollectionAssistant colAssistant = new CollectionAssistant();
        colAssistant.init(mc, targetID);
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
        return mapping.findForward("sampling");
    }
}