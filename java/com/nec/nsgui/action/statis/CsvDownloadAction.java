/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.statis.CsvDownloadHandler;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.CsvDownloadOption;
import com.nec.nsgui.model.entity.statis.CsvDownloadUtil;

/**
 *
 */
public class CsvDownloadAction
    extends DispatchAction
    implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: CsvDownloadAction.java,v 1.3 2008/05/16 11:48:11 zhangjun Exp $";
    public static final String ERROR_MSG_INVALID_PERIOD =
        "The period type that you have chosen does not exist.\n";
    public static final String ERROR_MSG_INVALID_WATCHITEMID =
        "The watchItemID that you have chosen does not exist.\n";

    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm downloadForm = (DynaActionForm) form;
        CsvDownloadInfoBean downloadInfo =
            (CsvDownloadInfoBean) downloadForm.get("downloadInfo");

        String downloading = CsvDownloadHelper.processPreviousDownload(request);
        request.setAttribute("downloading", downloading);

        String targetId =
            (String) request.getSession().getAttribute(SESSION_TARGET_ID);
        MonitorConfigBase mc =
            (MonitorConfigBase) request.getSession().getAttribute(
                StatisActionConst.SESSION_MC);
        String version = "1";
        if (downloadInfo.getIsSurvey().equals("true")) {
            mc =
                (MonitorConfigBase) request.getSession().getAttribute(
                    StatisActionConst.SESSION_MC_4SURVEY);
            version = "2";
        }

        //prepare resourcelist and default selected resource
        String defaultResource = downloadInfo.getDefaultResource();
        String originalWatchItemID = downloadInfo.getOriginalWatchItemID();
        
        //is Nvavs_Request or Nvavs_TAT
        if(originalWatchItemID.equals(WATCHITEM_NVAVS_REQUEST) || originalWatchItemID.equals(WATCHITEM_NVAVS_TAT)) {
            request.setAttribute("needDispExpgrp","yes");
            String exportGroup = NSActionUtil.getExportGroupPath(request);
            exportGroup = exportGroup.substring(PREFIX_EXPORT_GROUP.length());
            downloadInfo.setExprgroup(exportGroup);
            String domainName = (String)request.getSession().getAttribute(StatisActionConst.SESSION_DOMAIN_NAME);
            String cpName = (String)request.getSession().getAttribute(StatisActionConst.SESSION_COMPUTER_NAME);
            downloadInfo.setCpName(cpName);
            downloadInfo.setDomainName(domainName);
        }
        Vector resourceList =
            CsvDownloadHandler.getResourceList(downloadInfo, version);

        // set resource list
        defaultResource =
            CsvDownloadHelper.prepareResources(
                resourceList,
                defaultResource,
                originalWatchItemID);
        downloadInfo.setDefaultResource(defaultResource);
        request.setAttribute("resourceList", resourceList);

        //prepare default selected period
        String defaultPeriod = downloadInfo.getDefaultPeriod();
        defaultPeriod =
            CsvDownloadHelper.correctDefaultPeriod(
                defaultPeriod,
                downloadInfo.getPeriodType(),
                request);
        downloadInfo.setDefaultPeriod(defaultPeriod);

        CsvDownloadOption downloadOption = new CsvDownloadOption();
        //prepare list of items 
        String[] itemList =
            CsvDownloadHelper.prepareItemList(mc, originalWatchItemID);
        downloadOption.setItemList(itemList);

        //prepare watchItemDesc
        String watchItemDescKey = "h1." + originalWatchItemID;
        request.setAttribute("watchItemDescKey", watchItemDescKey);
        // downloadOption.setWatchItemDesc(watchItemDesc);

        //set default selected option for resource list
        if (defaultResource.equals("")) {
            String[] selected =
                {((LabelValueBean) resourceList.get(0)).getValue()};
            downloadOption.setSelectedResources(selected);
        } else {
            String[] tmp = { defaultResource };
            downloadOption.setSelectedResources(tmp);
        }

        if (!downloadInfo.getIsSurvey().equals("true")) {
            // prepare and set period options for period select
            int periodType = Integer.parseInt(downloadInfo.getPeriodType());
            Vector tmplist =
                CsvDownloadHelper.preparePeriodOption(
                    periodType,
                    getResources(request),
                    request.getLocale());
            request.setAttribute("periodList", tmplist);
        } else {
            String collectionId =
                mc.getWatchItemDef(originalWatchItemID).getCollectionItem();
            String stockPeriod =
                ((MonitorConfig2) mc).getStockPeriod(targetId, collectionId);
            downloadInfo.setCustomStartTime("-" + stockPeriod + "d");
            downloadInfo.setCustomEndTime("now");
            request.setAttribute("displayPeriod", stockPeriod);
            request.setAttribute("isForSurvey", "true");
        }

        //set all or selected
        if (defaultResource.equals("")) {
            downloadOption.setAllOrSelected("all");
        } else {
            downloadOption.setAllOrSelected("specific");
        }

        //set itemlist
        downloadForm.set("options", downloadOption);
        downloadForm.set("downloadInfo", downloadInfo);

        //set downloadInfo into session, 4 heartbeat display
        HttpSession session = request.getSession();
        String downloadWinKey = (String) request.getParameter("downloadWinKey");
        HashMap downloadFormHash = new HashMap();
        downloadFormHash.put("downloadInfo", downloadInfo);
        SyncDownloadSession.putInfoHashToSession(session,SESSION_STATIS_DOWNLOAD_INFO,downloadWinKey,downloadFormHash);
        
        return mapping.findForward("display");
    }

    /**
        * @param string
        * @return
        */
    public ActionForward download(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HttpSession session = request.getSession();
        String downloadWinKey = (String) request.getParameter("downloadWinKey");
        // get downloadForm from Form
        DynaActionForm downloadForm = (DynaActionForm) form;
        CsvDownloadInfoBean downloadInfo =
            (CsvDownloadInfoBean) downloadForm.get("downloadInfo");
        CsvDownloadOption downloadOption =
            (CsvDownloadOption) downloadForm.get("options");
        
        //set waitsign to "" to sign this download process is doing
        SyncDownloadSession.putInfoHashToSession(session,STATIS_DOWNLOAD_END_WAIT,downloadWinKey,"");
        session.setAttribute("statis_download_ended"+downloadWinKey,"");
        
        //download process
        try{
            MessageResources msgResource = getResources(request);
            CsvDownloadHelper.processDownload(
                request,
                msgResource,
                downloadInfo,
                downloadOption);
        }catch(NSException ne){
            session.setAttribute("statis_download_ended"+downloadWinKey,"yes");
            SyncDownloadSession.putInfoHashToSession(
                    session,
                    STATIS_DOWNLOAD_END_WAIT,
                    downloadWinKey,
                    STATIS_DOWNLOAD_FINISHED);
            throw ne;
        }
        session.setAttribute("statis_download_ended"+downloadWinKey,"yes");

        //set waitsign to finished to sign this download is already finished
        SyncDownloadSession.putInfoHashToSession(
            session,
            STATIS_DOWNLOAD_END_WAIT,
            downloadWinKey,
            STATIS_DOWNLOAD_FINISHED);
        
        StringBuffer defaultFilename = new StringBuffer();
        String collectionItemId =
            (String) request.getSession().getAttribute(SESSION_COLLECTION_ID);
        if (collectionItemId != null) {
            defaultFilename
                .append(
                    CsvDownloadUtil.changeCollectionItem2Infotype(
                        collectionItemId))
                .append(".csv");
        } else {
            String watchItemID = downloadInfo.getOriginalWatchItemID();
            if (watchItemID.equals(WATCHITEM_NVAVS_REQUEST) || watchItemID.equals(WATCHITEM_NVAVS_TAT)) {
                defaultFilename.append(downloadInfo.getHost()).append("_").append(downloadInfo.getCpName()).append("_").append(watchItemID).append(".csv");
            } else {
                defaultFilename
                    .append(downloadInfo.getHost())
                    .append("_")
                    .append(
                        CsvDownloadUtil.changeWatchItem2Infotype(
                            downloadInfo.getOriginalWatchItemID()))
                    .append(".csv");
            }
        }
        //clear waitSign in session
        SyncDownloadSession.removeHashInfoFromSession(
            session,
            STATIS_DOWNLOAD_END_WAIT,
            downloadWinKey);
        
        request.setAttribute("defaultFilename", defaultFilename.toString());
        return mapping.findForward("download");
    }
    
    public ActionForward displaytime(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        String downloadWinKey = (String) request.getParameter("downloadWinKey");
        //get downloadInfo from session
        HashMap downloadFormHash =(HashMap) SyncDownloadSession.getInfoHashFromSession(session,SESSION_STATIS_DOWNLOAD_INFO,downloadWinKey);
        CsvDownloadInfoBean downloadInfo = (CsvDownloadInfoBean) downloadFormHash.get("downloadInfo");
        if (!downloadInfo.getCpName().equals("")){
            //is Nvavs_Request or Nvavs_TAT
            request.setAttribute("needexpgrp","yes");
            request.setAttribute("expgrp",downloadInfo.getExprgroup());
            request.setAttribute("cpName",downloadInfo.getCpName());
            request.setAttribute("domainName",downloadInfo.getDomainName());
        }
        request.setAttribute("host",downloadInfo.getHost());
        return mapping.findForward("displaytime");
    }
}
