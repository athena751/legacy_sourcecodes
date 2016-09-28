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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.RRDGraphHandler;
import com.nec.nsgui.model.biz.statis.WatchItemDef;

/**
 * Actions for rrdgraph
 */
public class RRDGraphAction
    extends DispatchAction
    implements StatisActionConst {

    private static final String cvsid =
        "@(#) $Id: RRDGraphAction.java,v 1.4 2007/03/23 09:55:58 yangxj Exp $";

    public ActionForward init(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        //get watchItem
        DynaActionForm dForm = (DynaActionForm) form;
        String watchItem = (String) dForm.get("watchItem");
        request.getSession().setAttribute(
            SESSION_WATCHITEM_ID,
            dForm.get("watchItem"));
        //load monitorConfig and RRDGraphDef
        String user =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_USERINFO);
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        request.getSession().setAttribute(SESSION_MC, mc);
        RRDGraphDef rgd;
        if (request.getSession().getAttribute(SESSION_RGD) == null) {
            rgd = mc.loadRRDGraphDef(user, false);
            request.getSession().setAttribute(SESSION_RGD, rgd);
        } else {
            rgd = (RRDGraphDef) request.getSession().getAttribute(SESSION_RGD);
        }
        //load monitorConfig2 and RRDGraphDef
        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        request.getSession().setAttribute(SESSION_MC_4SURVEY, mc2);
        if (request.getSession().getAttribute(SESSION_RGD_4SURVEY) == null) {
            RRDGraphDef rgd2 = mc2.loadRRDGraphDef(user, false);
            request.getSession().setAttribute(SESSION_RGD_4SURVEY, rgd2);
        }
        //set targetID 
        String targetID = request.getParameter("target");
        targetID = MonitorConfig.stripTargetID(targetID);
        request.getSession().setAttribute(SESSION_TARGET_ID, targetID);
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_GRAPH_TYPE,
            rgd.getDefaultPeriod());
        //prepare h1
        request.setAttribute(
            "watchItemDesc",
            RRDGraphAssistant.getWatchItemKey(watchItem));
        NSActionUtil.setSessionAttribute(
            request,
            "watchItemDesc",
            RRDGraphAssistant.getWatchItemKey(watchItem));
        //set whether should display the investGraph
     /* WatchItemDef wid = mc2.getWatchItemDef(watchItem);
        String collectionItemId = wid.getCollectionItem();
        if (mc2.getTargetStatus(targetID, collectionItemId)) {
            request.setAttribute("investTag", "1");
        } else {
            request.setAttribute("investTag", "0");
        }*/
        return mapping.findForward("forwardToGraphList");
    }
    
    // server protect(virus scan) initialization
    public ActionForward spinit(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        int myNode = ClusterUtil.getInstance().getMyNodeNo();
        if((ClusterUtil.getMyStatus().equals("2")&&(myNode == groupNo))
                || !ClusterUtil.getMyStatus().equals("2")) {
            LicenseInfo license = LicenseInfo.getInstance();
            if ((license.checkAvailable(groupNo,"nvavs")) == 0){
                request.setAttribute("licenseKey","nvavs");
                return mapping.findForward("noLicense");
            }
        }

        DynaActionForm dForm = (DynaActionForm) form;
        String watchItem = (String) dForm.get("watchItem");
        request.getSession().setAttribute(SESSION_WATCHITEM_ID, watchItem);
        // set watchItemDesc
        request.setAttribute("watchItemDesc", 
                RRDGraphAssistant.getWatchItemKey(watchItem));
        NSActionUtil.setSessionAttribute(request, "watchItemDesc",
                RRDGraphAssistant.getWatchItemKey(watchItem));
        
        String exportGroup = NSActionUtil.getExportGroupPath(request);
        String[] computerInfo = RRDGraphHandler.getComputerInfo(groupNo,exportGroup,true);
        String domainName   = computerInfo[0];
        String computerName = computerInfo[1];
        if (domainName == null || domainName.equals("") 
                || computerName == null || computerName.equals("")) {
            return mapping.findForward("spNoNvavsSetting");
        }
        if(ServerProtectHandler.haveConfigFile(groupNo,computerName,true).equals("no")){
            return mapping.findForward("spNoNvavsSetting");
        }
        NSActionUtil.setSessionAttribute(request, SESSION_EXPORT_GROUP,exportGroup.substring(8));
        NSActionUtil.setSessionAttribute(request, SESSION_COMPUTER_NAME, computerName);
        NSActionUtil.setSessionAttribute(request, SESSION_DOMAIN_NAME, domainName);
        
        // load monitorConfig and RRDGraphDef
        String user = (String) NSActionUtil.getSessionAttribute(request,SESSION_USERINFO);
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        request.getSession().setAttribute(SESSION_MC, mc);
        RRDGraphDef rgd;
        if (request.getSession().getAttribute(SESSION_RGD) == null) {
            rgd = mc.loadRRDGraphDef(user, false);
            request.getSession().setAttribute(SESSION_RGD, rgd);
        } else {
            rgd = (RRDGraphDef) request.getSession().getAttribute(SESSION_RGD);
        }
        
        // set targetID
        String targetID = request.getParameter("target");
        targetID = MonitorConfig.stripTargetID(targetID);
        request.getSession().setAttribute(SESSION_TARGET_ID, targetID);
        NSActionUtil.setSessionAttribute(request, SESSION_GRAPH_TYPE, rgd
                .getDefaultPeriod());

        return mapping.findForward("spforwardToGraphList");
    }
    
    public ActionForward displayList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String isInvestGraph =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_IS_INVESTGRAPH);
        RRDGraphAssistant sgc = new RRDGraphAssistant();
        sgc.init(getResources(request), request, isInvestGraph);
        // set collection item
        request.setAttribute("collectionItem", sgc.getCollectionItem());
        // set auto reload info
        request.setAttribute("autoReloadInterval", sgc.getAutoReloadInterval());
        request.setAttribute("autoReloadFlag", sgc.getAutoReloadFlag());
        // set Illustration string
        request.setAttribute("illustration", sgc.getIllustration());
        // set whether cluster
        request.setAttribute("isCluster", sgc.getClusterTag());
        // set whether display the h3
        String watchItemId = (String) NSActionUtil.getSessionAttribute(request,SESSION_WATCHITEM_ID);
        if(watchItemId.trim().equals(WatchItemDef.Nvavs_Request)
                || watchItemId.trim().equals(WatchItemDef.Nvavs_TAT)){
            request.setAttribute("isDisplayH3", "false");
        }else{
            request.setAttribute("isDisplayH3", "true");
        }
        // set Graph Table
        DynaActionForm dForm = (DynaActionForm) form;
        dForm.set(
            "watchItem",
            NSActionUtil.getSessionAttribute(request, SESSION_WATCHITEM_ID));
        String graphType = (String) NSActionUtil.getSessionAttribute(
                    request,
                    SESSION_GRAPH_TYPE);
        request.setAttribute("graphInfoList", sgc.getGraphInfoList(graphType));

        //set download info
        CsvDownloadInfoBean downloadInfo = new CsvDownloadInfoBean();
        downloadInfo.setCustomEndTime(sgc.getCustomEndTime());
        downloadInfo.setCustomStartTime(sgc.getCustomStartTime());
        downloadInfo.setOriginalWatchItemID(sgc.getWatchItemId());
        downloadInfo.setDefaultPeriod(graphType);
        dForm.set("downloadInfo", downloadInfo);

        return mapping.findForward("displayList");
    }

    public ActionForward displayDetail(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String isInvestGraph =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_IS_INVESTGRAPH);
        RRDGraphAssistant sgc = new RRDGraphAssistant();
        sgc.init(getResources(request), request, isInvestGraph);
        // set watch item description
        ((DynaActionForm) form).set(
            "watchItem",
            NSActionUtil.getSessionAttribute(request, SESSION_WATCHITEM_ID));

        // set auto reload info
        request.setAttribute("autoReloadInterval", sgc.getAutoReloadInterval());
        request.setAttribute("autoReloadFlag", sgc.getAutoReloadFlag());

        // set detail graph src and mount point

        String targetId = (String) ((DynaActionForm) form).get("targetID");

        String subwatchItem =
            (String) ((DynaActionForm) form).get("subWatchItem");
        String grayBackColor =
            (String) ((DynaActionForm) form).get("grayBackColor");
        request.setAttribute(
            "mountpoint",
            sgc.getMountPoint(targetId, subwatchItem));

        request.setAttribute("isCluster", sgc.getClusterTag());

        request.setAttribute(
            "detailGraph",
            sgc.getDetailGraph(targetId, subwatchItem, grayBackColor));
        request.setAttribute("nickName", sgc.getNickName(targetId));
        
        //set whether display the h3;then set delete message
        String watchItemId = (String) NSActionUtil.getSessionAttribute(request,SESSION_WATCHITEM_ID);
        if(watchItemId.trim().equals(WatchItemDef.Nvavs_Request)
                || watchItemId.trim().equals(WatchItemDef.Nvavs_TAT)){
            int indexOfSharp = subwatchItem.indexOf("#");
            request.setAttribute("subWatchItemName", subwatchItem.substring(indexOfSharp+1));
            request.setAttribute("isDisplayNodeNo", "false");
        }else{
            request.setAttribute("subWatchItemName", subwatchItem);
            request.setAttribute("isDisplayNodeNo", "true");
        }
        // set download info
        CsvDownloadInfoBean downloadInfo = new CsvDownloadInfoBean();
        downloadInfo.setHost(targetId);
        downloadInfo.setPeriodType(Integer.toString(PERIOD_WITHIN_YEAR));

        downloadInfo.setDefaultResource(subwatchItem);
        downloadInfo.setCustomEndTime(sgc.getCustomEndTime());
        downloadInfo.setCustomStartTime(sgc.getCustomStartTime());
        downloadInfo.setOriginalWatchItemID(sgc.getWatchItemId());
        downloadInfo.setDefaultPeriod(
            (String) ((DynaActionForm) form).get("defaultGraphType"));
        ((DynaActionForm) form).set("downloadInfo", downloadInfo);

        return mapping.findForward("displayDetail");
    }

    public ActionForward filterGraph(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String flag = request.getParameter("flag");
        if (flag.trim().equals("0")) {
            request.getSession().setAttribute(SESSION_STATIS_FILTER_FLAG, "0");
        }
        if (flag.trim().equals("1")) {
            request.getSession().setAttribute(SESSION_STATIS_FILTER_FLAG, "1");
        }
        return mapping.findForward("displayRRDGraph");
    }
    public ActionForward forwardToHideFrame(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String isInvestGraph = (String) request.getParameter("isInvestGraph");
        String defaultGraphType =
            (String) request.getParameter("defaultGraphType");
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_IS_INVESTGRAPH,
            isInvestGraph);
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_GRAPH_TYPE,
            defaultGraphType);
        return mapping.findForward("displayHideFrame");
    }

}