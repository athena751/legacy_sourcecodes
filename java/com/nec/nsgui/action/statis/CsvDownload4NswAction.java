/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.model.biz.statis.CsvDownloadHandler;
import com.nec.nsgui.model.biz.statis.MonitorConfig3;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.CsvDownloadOption;

/**
 *
 */
public class CsvDownload4NswAction extends CsvDownloadAction {
    public static final String cvsid 
            = "@(#) $Id: CsvDownload4NswAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
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

        //prepare resourcelist
        Vector resourceList =
            CsvDownloadHandler.getResourceList4NSW(downloadInfo);
        String collectionItemId = downloadInfo.getCollectionItemId();
        MonitorConfig3 mc =
            (MonitorConfig3) request.getSession().getAttribute(SESSION_MC);
        String targetId =
            (String) request.getSession().getAttribute(SESSION_TARGET_ID);
        CsvDownloadOption downloadOption = new CsvDownloadOption();
        MessageResources mr = getResources(request);
        Map samplingConfs = mc.loadSamplingConfs(targetId, collectionItemId);

        //get checked list
        Vector checkedList =
            CsvDownloadHelper.getAllCheckItems(
                request,
                downloadInfo,
                downloadOption);

        //set default interval
        String interval = downloadInfo.getInterval();
        if (interval.equals("")) {
            interval =
                CsvDownloadHelper.getDefaultInterval(
                    samplingConfs,
                    checkedList);
        }
        if (interval.equals("")) {
            interval =
                CsvDownloadHelper.getDefaultInterval(
                    samplingConfs,
                    resourceList);
        }
        downloadInfo.setInterval(interval);

        //set interval list
        Vector intervalList =
            CsvDownloadHelper.getIntervalList(samplingConfs, resourceList);
        CsvDownloadHelper.prepareIntervalOptions(intervalList);
        request.setAttribute("intervalList", intervalList);

        // set resource list 
        resourceList =
            CsvDownloadHelper.getResouceList(
                samplingConfs,
                resourceList,
                interval);

        //set stock period list
        int periodNeedShow =
            CsvDownloadHelper.getPeriodNeedShow(samplingConfs, resourceList);
        Vector periodList =
            CsvDownloadHelper.preparePeriodOption(
                periodNeedShow,
                mr,
                request.getLocale());
        request.setAttribute("periodList", periodList);

        //prepare default selected period
        String defaultPeriod = downloadInfo.getDefaultPeriod();
        defaultPeriod =
            CsvDownloadHelper.correctDefaultPeriod(
                defaultPeriod,
                Integer.toString(periodNeedShow),
                request);
        downloadInfo.setDefaultPeriod(defaultPeriod);

        //set radio box && selected resource.
        CsvDownloadHelper.setSelectedResource(
            checkedList,
            resourceList,
            downloadOption);

        //prepare list of items 
        String[] itemList =
            CsvDownloadHelper.prepareItemList4NSW(mc, collectionItemId);
        downloadOption.setItemList(itemList);

        CsvDownloadHelper.prepareOptions(resourceList);
        request.setAttribute("resourceList", resourceList);

        //prepare watchItemDesc
        String watchItemDescKey = "h1." + collectionItemId;
        request.setAttribute("watchItemDescKey", watchItemDescKey);

        downloadForm.set("options", downloadOption);
        downloadForm.set("downloadInfo", downloadInfo);
        return mapping.findForward("display");
    }

    public ActionForward download(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        //get downloadForm from session
        HttpSession session = request.getSession();
        String downloadWinKey = request.getParameter("downloadWinKey");
        HashMap downloadFormHash =
            (HashMap) SyncDownloadSession.getInfoHashFromSession(
                session,
                SESSION_STATIS_DOWNLOAD_INFO,
                downloadWinKey);

        //set waitsign to "" to sign this download process is doing  
        SyncDownloadSession.putInfoHashToSession(
            session,
            STATIS_DOWNLOAD_END_WAIT,
            downloadWinKey,
            "");

        //download process
        CsvDownloadInfoBean downloadInfo =
            (CsvDownloadInfoBean) downloadFormHash.get("downloadInfo");
        CsvDownloadOption downloadOption =
            (CsvDownloadOption) downloadFormHash.get("options");

        try {
            MessageResources msgResource = getResources(request);
            CsvDownloadHelper.processDownload4NSW(
                request,
                msgResource,
                downloadInfo,
                downloadOption);
        } catch (Exception e) {
            SyncDownloadSession.putInfoHashToSession(
                session,
                SESSION_STATIS_DOWNLOAD_EXCEPTION,
                downloadWinKey,
                e);
        }

        //set waitsign to finished to sign this download is already finished
        SyncDownloadSession.putInfoHashToSession(
            session,
            STATIS_DOWNLOAD_END_WAIT,
            downloadWinKey,
            STATIS_DOWNLOAD_FINISHED);

        //set information to request for download ready page
        //   request.setAttribute("downloadWinKey", downloadWinKey);
        //goto downloadfinished
        return mapping.findForward("downloadfinished");

    }

}
