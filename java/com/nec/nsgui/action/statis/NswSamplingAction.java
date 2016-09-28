/*
 *      Copyright (c) 2005 NEC Corporation
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
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.model.entity.statis.NswSamplingInfoBeanBase;
import com.nec.nsgui.model.biz.statis.MonitorConfig3;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.NswSamplingHandler;
import java.util.*;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;

public class NswSamplingAction
    extends DispatchAction
    implements CollectionConst3 {
    public static final String cvsid 
            = "@(#) $Id: NswSamplingAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";        
    public ActionForward initList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            (String) NSActionUtil.getSessionAttribute(request,CollectionConst.STATIS_SAMPLING_TARGETID);
        NswSamplingAssistant nsa = new NswSamplingAssistant();
        String colItemID =
            (String) NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID);
        List tableList = new ArrayList();
        if (colItemID.equals(STATIS_NFS_VIRTUAL_PATH)) {
            tableList = nsa.getVirtualPathList(targetID, colItemID);
            nsa.putResourceList2SessionMap(request,tableList);
            SortTableModel tableMode =
                new ListSTModel((AbstractList) tableList);
            request.setAttribute("tableList", tableMode);
            request.setAttribute("tableLength",String.valueOf(tableList.size()));
            return mapping.findForward("nswvirtualpathlist");
        } else if (colItemID.equals(STATIS_NFS_SEVER)) {
            tableList = nsa.getSeverList(targetID, colItemID);
            nsa.putResourceList2SessionMap(request,tableList);
            SortTableModel tableMode =
                new ListSTModel((AbstractList) tableList);
            request.setAttribute("tableList", tableMode);
            request.setAttribute("tableLength",String.valueOf(tableList.size()));
            return mapping.findForward("nswserverlist");
        } else {
            tableList = nsa.getNodeList(targetID, colItemID);
            nsa.putResourceList2SessionMap(request,tableList);
            SortTableModel tableMode =
                new ListSTModel((AbstractList) tableList);
            request.setAttribute("tableList", tableMode); 
            return mapping.findForward("nswnodelist");
        }
    }
    public ActionForward tabSwitch(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String colItemID = request.getParameter("colItemID");
        NSActionUtil.setSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID,colItemID);
        return mapping.findForward("nswsamplingframe");
    }
    public ActionForward toSettingFrame(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String colItemID =
            (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID); 
        List indexList = new ArrayList();
        if (colItemID.equals(STATIS_NFS_NODE)) {
            Map sessionMap = (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP);
            for(int i=0;i<sessionMap.size();i++){
                indexList.add(String.valueOf(i));                
            }
        } else {
            String[] idList = (String[]) dynaForm.get("idList");
            for (int i = 0; i < idList.length; i++) {
                String[] tmpStr = idList[i].split("#");
                indexList.add(tmpStr[0]);
            }
        }
        NSActionUtil.setSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST,indexList);
        return mapping.findForward("nswsamplingsettingframe");
    }
    public ActionForward initSettingList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        List indexIdList =
            (List)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST);
        Map infoMap =
            (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP);
        List tableList = new ArrayList();
        String idName = "";
        String colItemID =
            (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID); 
        for(int i=0;i<indexIdList.size();i++){
            NswSamplingInfoBeanBase nsBase = (NswSamplingInfoBeanBase)infoMap.get(indexIdList.get(i));
            tableList.add(nsBase);
        }
        if(colItemID.equals(STATIS_NFS_VIRTUAL_PATH)){
            idName = STATIS_NFS_VIRTUAL_PATH_TH;
        }else if(colItemID.equals(STATIS_NFS_SEVER)){
            idName = STATIS_NFS_SEVER_TH;
        }else{
            idName = STATIS_NFS_NODE_TH;
        }
        SortTableModel tableMode = new ListSTModel((AbstractList) tableList);
        request.setAttribute("tableList", tableMode);
        request.setAttribute("idName", idName);
        return mapping.findForward("nswsamplingsettingtop");
    }
    public ActionForward initSettingMid(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        List indexList =
            (List)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST); 
        Map infoMap =
            (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP); 
        NswSamplingInfoBeanBase nsBase = (NswSamplingInfoBeanBase)infoMap.get(indexList.get(0));
        String interval = nsBase.getInterval().equals(DLINE)?DEFAULT_INTERVAL:nsBase.getInterval();
        String period = nsBase.getPeriod().equals(DLINE)?DEFAULT_PERIOD:nsBase.getPeriod();
        request.setAttribute("interval", interval);
        request.setAttribute("period", period);
        return mapping.findForward("nswsamplingsettingmid");
    }
    public ActionForward stopSampling(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        List idList = new ArrayList();
        List indexIDList = new ArrayList();
        String colItemID =
            (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID);
        Map infoMap =
            (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP);  
        if (colItemID.equals(STATIS_NFS_NODE)) {
            for(int i=0;i<infoMap.size();i++){
                indexIDList.add(String.valueOf(i));
            }
        } else {
            String[] jspIdList = (String[]) dynaForm.get("idList");
            for (int i = 0; i < jspIdList.length; i++) {
                String[] tmpStr = jspIdList[i].split("#");
                indexIDList.add(tmpStr[0]);
            }
        }               
        
        for (int i = 0; i < indexIDList.size(); i++) {
            NswSamplingInfoBeanBase nsBase =
                (NswSamplingInfoBeanBase) infoMap.get(indexIDList.get(i));
            idList.add(nsBase.getId());
        }
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs();
        String targetID =
            (String)NSActionUtil.getSessionAttribute(request,CollectionConst.STATIS_SAMPLING_TARGETID); 
        mc3.deleteSamplingConfs(targetID, colItemID, idList);
        NSActionUtil.setSuccess(request);
        if (NSActionUtil.isCluster(request)) {
            NswSamplingHandler.syncSampling();
        }
        return mapping.findForward("nswsamplingframe");
    }
    public ActionForward modifyData(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String interval = (String) dynaForm.get("interval");
        String period = (String) dynaForm.get("period");
        NswSamplingAssistant nsa = new NswSamplingAssistant();
        boolean isCluster = NSActionUtil.isCluster(request);
        if (!nsa.checkCapacity(request, interval, period, isCluster)) {
            // is low space
            MessageResources commonMsgResource =
                (MessageResources) getServlet()
                    .getServletContext()
                    .getAttribute(
                    "common");
            String commonMsg =
                commonMsgResource.getMessage(
                    request.getLocale(),
                    RESOURCE_KEY_COMMON_FAILED);
            MessageResources msgResource =
                (MessageResources) getResources(request);
            String msg =
                msgResource.getMessage(
                    request.getLocale(),
                    RESOURCE_KEY_LOWSPACE);
            NSActionUtil.setSessionAttribute(
                request,
                NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE,
                commonMsg + "\\r\\n" + msg);
            return mapping.findForward("nswsamplingsettingframe");
        }
        nsa.setSamplingConfs(request, interval, period);
        NSActionUtil.setSuccess(request);
        if (NSActionUtil.isCluster(request)) {
            NswSamplingHandler.syncSampling();
        }
        return mapping.findForward("nswsamplingframe");
    }
}