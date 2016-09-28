/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;

import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.framework.ControllerModel;
import com.nec.nsgui.model.biz.framework.ExportGroupHandler;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.NodeInfoBean;

/**
 *
 */
public class ControllerAction
    extends DispatchAction
    implements NSActionConst, FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: ControllerAction.java,v 1.14 2008/03/21 10:25:14 zhangjun Exp $";
    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HttpSession session = request.getSession();
        DynaActionForm dynaForm = (DynaActionForm) form;

        ControllerModel clModel = ControllerModel.getInstance();
        String machineType = clModel.getMachineType();
        session.setAttribute(SESSION_MACHINE_TYPE, machineType);

        String machineSeries = clModel.getMachineSeries();
        session.setAttribute(SESSION_MACHINE_SERIES,machineSeries);

        //set session for nashead
        session.setAttribute(
            SESSION_ISNASHEAD,
            new Boolean(NSActionUtil.isNashead(request)));

        int group = 0;

        //when there is no group number in session (first load)
        if (ClusterUtil.getInstance().isCluster()) {
            group = ClusterUtil.getInstance().getMyNodeNo();
        }
        //set my node number to session.
        session.setAttribute(SESSION_NODE_NUMBER, Integer.toString(group));
        
        //post login
        ControllerModel.postLogin();
        
        //set info to form.
        NodeInfoBean nodeInfo = clModel.getNodeInfo(group);
        dynaForm.set("nodeInfo", nodeInfo);
        dynaForm.set("machineType", machineType);

        //set export group list and selected export group

        Map exportMap = new TreeMap();

        if (!nodeInfo.getNodeId().equals("")) { //has node registed.
            exportMap = getExportGroup(group);
        }

        request.setAttribute("exportGroupList", exportMap.keySet());

        if (!exportMap.isEmpty()) {
            String exportGroupName =
                (String) exportMap.keySet().iterator().next();
            String encoding = (String) exportMap.get(exportGroupName);

            session.setAttribute(
                SESSION_EXPORTGROUP_PATH + group,
                PREFIX_EXPORT_GROUP + exportGroupName);

            session.setAttribute(
                SESSION_EXPORTGROUP_ENCODING + group,
                encoding);
            dynaForm.set("exportGroup", exportGroupName);
        }
        return mapping.findForward("controller");
    }

    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward changeNode(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HttpSession session = request.getSession();
        DynaActionForm dynaForm = (DynaActionForm) form;

        //change group number    
        int group = ((NodeInfoBean) dynaForm.get("nodeInfo")).getGroup();

        group = (group == 0) ? 1 : 0;
        session.setAttribute(SESSION_NODE_NUMBER, Integer.toString(group));
        NodeInfoBean nodeInfo =
            ControllerModel.getInstance().getNodeInfo(group);
        dynaForm.set("nodeInfo", nodeInfo);

        Map exportMap = getExportGroup(group);
        request.setAttribute("exportGroupList", exportMap.keySet());

        if (exportMap.isEmpty()) {
            session.setAttribute(SESSION_EXPORTGROUP_PATH + group, null);
            session.setAttribute(SESSION_EXPORTGROUP_ENCODING + group, null);
            dynaForm.set("exportGroup", "");
            return mapping.findForward("controller");
        }

        String exportGroupPath =
            (String) session.getAttribute(SESSION_EXPORTGROUP_PATH + group);

        String exportGroupName = retrieveExpgrpName(exportGroupPath);

        if (!exportMap.containsKey(exportGroupName)) { //select the first one;
            exportGroupName = (String) exportMap.keySet().iterator().next();
            exportGroupPath = PREFIX_EXPORT_GROUP + exportGroupName;
        }

        String encoding = (String) exportMap.get(exportGroupName);

        session.setAttribute(SESSION_EXPORTGROUP_PATH + group, exportGroupPath);
        session.setAttribute(SESSION_EXPORTGROUP_ENCODING + group, encoding);
        dynaForm.set("exportGroup", exportGroupName);
        return mapping.findForward("controller");
    }

    public ActionForward refresh(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        return changeExportGroup(mapping, form, request, response);
    }

    public ActionForward selectExpgrp(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        return changeExportGroup(mapping, form, request, response);
    }

    /**
         * 
         * @param mapping
         * @param form
         * @param request
         * @param response
         * @return
         * @throws Exception
         */
    private ActionForward changeExportGroup(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HttpSession session = request.getSession();
        DynaActionForm dynaForm = (DynaActionForm) form;
        int group = ((NodeInfoBean) dynaForm.get("nodeInfo")).getGroup();

        String orgExpgrpPath =
            (String) session.getAttribute(SESSION_EXPORTGROUP_PATH + group);
        String orgExpgrpName = retrieveExpgrpName(orgExpgrpPath);

        String targetExpgrpName = (String) dynaForm.get("exportGroup");

        Map exportMap = getExportGroup(group);
        request.setAttribute("exportGroupList", exportMap.keySet());

        if (exportMap.isEmpty()) {
            session.setAttribute(SESSION_EXPORTGROUP_PATH + group, null);
            session.setAttribute(SESSION_EXPORTGROUP_ENCODING + group, null);
            dynaForm.set("exportGroup", "");
            request.setAttribute("targetExpgrp", targetExpgrpName);
            return mapping.findForward("controller");
        }

        String expgrpName = "";
        if (exportMap.containsKey(targetExpgrpName)) {
            expgrpName = targetExpgrpName;
        } else {
            request.setAttribute("targetExpgrp", targetExpgrpName);
            if (exportMap.containsKey(orgExpgrpName)) {
                request.setAttribute("maintainActionFrame", "true");
                expgrpName = orgExpgrpName;
            } else {
                expgrpName = (String) exportMap.keySet().iterator().next();
            }
        }
        String encoding = (String) exportMap.get(expgrpName);

        session.setAttribute(
            SESSION_EXPORTGROUP_PATH + group,
            PREFIX_EXPORT_GROUP + expgrpName);
        session.setAttribute(SESSION_EXPORTGROUP_ENCODING + group, encoding);
        dynaForm.set("exportGroup", expgrpName);
        return mapping.findForward("controller");
    }

    private Map getExportGroup(int group) throws Exception {
        Map exportMap = new TreeMap();
        try {
            exportMap = ExportGroupHandler.getExportGroupMap(group);
        } catch (Exception e) {
        }
        return exportMap;
    }

    private String retrieveExpgrpName(String expgrpPath) {
        if (expgrpPath != null) {
            return expgrpPath.substring(PREFIX_EXPORT_GROUP.length());
        }
        return "";
    }
}
