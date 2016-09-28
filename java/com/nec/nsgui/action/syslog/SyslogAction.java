/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.syslog;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.statis.CollectionConst;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.syslog.SyslogCmdHandler;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.syslog.SyslogCacheFileInfo;
import com.nec.nsgui.model.entity.syslog.SyslogCategoryInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogCifsLogInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogCifsSearchInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogCommonInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogHttpLogInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogLogFileInfo;
import com.nec.nsgui.model.entity.syslog.SyslogLogviewInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogSearchConditions;
import com.nec.nsgui.model.entity.syslog.SyslogSystemSearchInfoBean;


/**
 *Actions for direct edit page
 */
public class SyslogAction extends DispatchAction implements SyslogActionConst{
    private static final String cvsid = "@(#) $Id: SyslogAction.java,v 1.21 2008/09/23 09:22:28 penghe Exp $";
    
    public ActionForward enterSyslog(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        
        String logType = request.getParameter("logType");
        
        //check license
        if(!hasLicense(logType, nodeNo, request)){
            return mapping.findForward("noLicense");
        }
        
        HttpSession session = request.getSession();
        session.setAttribute(SESSION_NAME_H1_KEY, getH1Key(logType));
        
        String[] sharePartitionLogs = { LOG_TYPE_CIFS_LOG };
        for(int i = 0; i < sharePartitionLogs.length; i++){
            if(logType.equals(sharePartitionLogs[i])){
                //the log is in the share fileSystem
                return mapping.findForward(logType);
            }
        }
        
        if(ClusterUtil.getMyStatus().equals("2")){
            //the status of the machine is maintaining, the remote node is not active
            int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
            if (myNodeNo == nodeNo || myNodeNo == -1) {
                //the target node is the local node
                return mapping.findForward(logType);
            }else{
                //the target node is the remote node
                return mapping.findForward("displayMaintain");
            }
        }else{
            //both node is active
            return mapping.findForward(logType);
        }
    }

    private boolean hasLicense(String logType, int nodeNo, HttpServletRequest request)throws Exception{
       if(ClusterUtil.getMyStatus().equals("2")){
            int myNode = ClusterUtil.getInstance().getMyNodeNo();
            if((myNode != -1 && myNode != nodeNo  )){
               return true;
            }
        }
        HashMap licenseKeysMapping = new HashMap();
        licenseKeysMapping.put(LOG_TYPE_HTTP_LOG,    LICENSE_KEY_HTTP);
        licenseKeysMapping.put(LOG_TYPE_FTP_LOG,     LICENSE_KEY_FTP);
        licenseKeysMapping.put(LOG_TYPE_CIFS_LOG,    LICENSE_KEY_CIFS);
        licenseKeysMapping.put(LOG_TYPE_NFS_LOG,     LICENSE_KEY_NFS);
        if(licenseKeysMapping.containsKey(logType)){
            String licenseKey = (String)licenseKeysMapping.get(logType);
            LicenseInfo license = LicenseInfo.getInstance();
            if (license.checkAvailable(nodeNo, licenseKey) == 0){
                request.setAttribute("licenseKey", licenseKey);
                return false;
            }else{
                return true;
            }
        }else{
            return true;
        }
    }

    private String getH1Key(String logType){
        HashMap logPage_h1Mapping = new HashMap();
        logPage_h1Mapping.put(LOG_TYPE_SYSTEM_LOG,  H1_KEY_SYSTEM_LOG);
        logPage_h1Mapping.put(LOG_TYPE_HTTP_LOG,    H1_KEY_HTTP_LOG);
        logPage_h1Mapping.put(LOG_TYPE_FTP_LOG,     H1_KEY_FTP_LOG);
        logPage_h1Mapping.put(LOG_TYPE_CIFS_LOG,    H1_KEY_CIFS_LOG);
        logPage_h1Mapping.put(LOG_TYPE_NFS_LOG,     H1_KEY_NFS_LOG);
        return (String)logPage_h1Mapping.get(logType);
    }
    
    public ActionForward loadCifsTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector cifsComputerList = SyslogCmdHandler.getCifsComputerList(nodeNo);
        ArrayList displayValidList  = (ArrayList)cifsComputerList.get(0);
        ArrayList displayInvalidList  = (ArrayList)cifsComputerList.get(1);
        for(int i = 0 ; i < displayValidList.size(); i++){
        	SyslogCifsLogInfoBean info = (SyslogCifsLogInfoBean)displayValidList.get(i);
        	info.setFileSizeForDisplay(formatSizeStr(info.getFileSize()));
        	List rotateFileList = info.getRotateLogFiles();
        	for(int j = 0 ; j < rotateFileList.size(); j++){
        		SyslogLogFileInfo rInfo = (SyslogLogFileInfo)rotateFileList.get(j);
        		rInfo.setFileSizeForDisplay(formatSizeStr(rInfo.getFileSize()));
        	}
        }
        for(int i = 0 ; i < displayInvalidList.size(); i++){
        	SyslogCifsLogInfoBean info = (SyslogCifsLogInfoBean)displayInvalidList.get(i);
        	info.setFileSizeForDisplay(formatSizeStr(info.getFileSize()));
        	List rotateFileList = info.getRotateLogFiles();
        	for(int j = 0 ; j < rotateFileList.size(); j++){
        		SyslogLogFileInfo rInfo = (SyslogLogFileInfo)rotateFileList.get(j);
        		rInfo.setFileSizeForDisplay(formatSizeStr(rInfo.getFileSize()));
        	}
        }
        changEncodingForPage(displayValidList);
        sortByComputerName(displayValidList);
        request.setAttribute("displayValidList", displayValidList);
        changEncodingForPage(displayInvalidList);
        sortByComputerName(displayInvalidList);
        request.setAttribute("displayInvalidList", displayInvalidList);
        
        return mapping.findForward("displayCifsTop");
    }

    public ActionForward loadSystemTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        List categoryList = SyslogCmdHandler.getCategoryList(nodeNo);
        setCategoryLabel(categoryList, request);
        sortForCategory(categoryList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("maxLinesSet", getMaxLinesSet());

        SyslogCommonInfoBean commonInfo = getInitCommonInfo(LOG_TYPE_SYSTEM_LOG);
        commonInfo.setLogFile(SYSTEM_LOG_FILE_NAME);
        ((DynaValidatorForm)form).set("commonInfo", commonInfo);
        String[] filename = {SYSTEM_LOG_FILE_NAME};
        String[] filesize = SyslogCmdHandler.getFileSizeList(filename,LOG_TYPE_SYSTEM_LOG, nodeNo);
        request.setAttribute("fileSize", filesize[0]);
        request.setAttribute("fileSizeForDisplay", formatSizeStr(filesize[0]));
               
        return mapping.findForward("displaySystemTop");
    }

	private String formatSizeStr(String size){
		if(size.compareTo("")==0){
    		return "";
    	}
    	double dataSize = Double.parseDouble(size); 
        dataSize = dataSize / (1024 * 1024);
        String dataFileSize =
                Double.toString(Math.round(dataSize * 100) / 100.00);
        if (dataFileSize.length() - dataFileSize.indexOf(".") < 3) {
            dataFileSize = dataFileSize + "0";
        }
        return dataFileSize;
	}

    private void setCategoryLabel(List categoryList, HttpServletRequest request){
        
        MessageResources resources = retrieveResources(request);
        Locale userLocale = retrieveUserLocale(request);
        int size =  categoryList.size();
        for(int i = 0; i< size; i++){
            SyslogCategoryInfoBean categoryInfo = (SyslogCategoryInfoBean)categoryList.get(i);
            String category = categoryInfo.getCategory();
            String message = null;
            if(resources != null){
                message = resources.getMessage(userLocale,
                         "syslog.system.categoryLabel." + category);
            }
            if(message == null){
                message = category;
            }
            categoryInfo.setCategoryLabel(message);
        }
    }

    private void sortForCategory (List the_list){
        Collections.sort
            (the_list, new Comparator()
                {
                    public int compare(Object a, Object b){
                        SyslogCategoryInfoBean info_a = (SyslogCategoryInfoBean)a;
                        SyslogCategoryInfoBean info_b = (SyslogCategoryInfoBean)b;
                        return info_a.getCategory().compareTo(info_b.getCategory());
                    }
               }
            );
    }

    private Locale retrieveUserLocale(HttpServletRequest request) {
        Locale userLocale = null;
        HttpSession session = request.getSession();

        // Only check session if sessions are enabled
        if (session != null) {
            userLocale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
        }

        if (userLocale == null) {
            // Returns Locale based on Accept-Language header or the server default
            userLocale = request.getLocale();
        }

        return userLocale;
    }

    private MessageResources retrieveResources(HttpServletRequest request){
        String bundle = Globals.MESSAGES_KEY;
        MessageResources resources =
            (MessageResources) request.getAttribute(bundle);
        if (resources == null) {
            resources = (MessageResources) request.getSession()
                .getServletContext().getAttribute(bundle);
        }
        return resources;
    }

    private Vector getMaxLinesSet(){
        //return the set such as [2000,4000,6000,....,20000]
        Vector maxLinesSet = new Vector();
        for(int i = 1; i < 11; i++){
            String maxLines = String.valueOf(2000 * i);
            maxLinesSet.add(new LabelValueBean(maxLines, maxLines));
        }
        return maxLinesSet;
    }

    private Vector getDisplayEncodingSet(HttpServletRequest request){
        
        String displayEncodings[] = {NSActionConst.ENCODING_UTF_8_NFC 
                                ,NSActionConst.ENCODING_UTF_8
        		                ,NSActionConst.ENCODING_EUC_JP
                                ,NSActionConst.ENCODING_SJIS
                                ,NSActionConst.ENCODING_English
        };
        Vector displayEncodingSet = new Vector();
        MessageResources resources = retrieveResources(request);
        Locale userLocale = retrieveUserLocale(request);
        String machineType = (String)request.getSession().getAttribute(FrameworkConst.SESSION_MACHINE_SERIES);
        for(int i = 0; i < displayEncodings.length; i++){
            String label;
            if(displayEncodings[i].equals(NSActionConst.ENCODING_UTF_8) 
        			&& machineType != null && machineType.equals(FrameworkConst.MACHINE_SERIES_PROCYON)){
        		label = resources.getMessage(userLocale,"syslog.common.encoding.UTF-8_MAC");
        	}else{
                label = resources.getMessage(userLocale,
                    "syslog.common.encoding." + displayEncodings[i]);
            }
            if(label == null){
                label = displayEncodings[i];
            }
            displayEncodingSet.add(new LabelValueBean(label, displayEncodings[i]));
        }
        return displayEncodingSet;
    }

    public ActionForward loadFtpTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String[] ftpLogFiles = SyslogCmdHandler.getFtpLogFiles(nodeNo);
        request.setAttribute("ftpLogFiles", ftpLogFiles);
        request.setAttribute("maxLinesSet", getMaxLinesSet());
        request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
        
        ((DynaValidatorForm)form).set("commonInfo",
                                    getInitCommonInfo(LOG_TYPE_FTP_LOG));
        if(ftpLogFiles.length!=0){
        	String[] filesize = SyslogCmdHandler.getFileSizeList(ftpLogFiles, LOG_TYPE_FTP_LOG, nodeNo);
        	request.setAttribute("fileSize", filesize[0]);
        	request.setAttribute("fileSizeForDisplay", formatSizeStr(filesize[0]));
        }
        return mapping.findForward("displayFtpTop");
    }



    public ActionForward loadHttpTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String[] httpLogFiles = SyslogCmdHandler.getHttpLogFiles(nodeNo);
        if(httpLogFiles[0].equals("")){
            request.setAttribute("accessLogEixst", "false");
        }else{
            request.setAttribute("accessLogEixst", "true");
        }
        if(httpLogFiles[1].equals("")){
            request.setAttribute("errorLogEixst", "false");
        }else{
            request.setAttribute("errorLogEixst", "true");
        }
        Vector restFileList = getRestHttpLogInfo(httpLogFiles);
                
        for(int i = 0; i < restFileList.size(); i++){
        	httpLogFiles[i+2] = ((SyslogHttpLogInfoBean)restFileList.get(i)).getLogFileName();
        }
        String[] filesize = SyslogCmdHandler.getFileSizeList(httpLogFiles, LOG_TYPE_HTTP_LOG, nodeNo);
    	for(int i = 0; i < restFileList.size(); i++){
        	((SyslogHttpLogInfoBean)restFileList.get(i)).setFileSizeForDisplay(formatSizeStr(filesize[2+i]));
        	((SyslogHttpLogInfoBean)restFileList.get(i)).setFileSize(filesize[2+i]);
        }
    	request.setAttribute("accessLogFileSizeForDisplay", formatSizeStr(filesize[0]));
    	request.setAttribute("errorLogFileSizeForDisplay", formatSizeStr(filesize[1]));
    	request.setAttribute("accessLogFileSize", filesize[0]);
    	request.setAttribute("errorLogFileSize", filesize[1]);
    	request.setAttribute("restHttpLogFiles", restFileList);
    	
        return mapping.findForward("displayHttpTop");
    }

    private Vector getRestHttpLogInfo(String[] result){
        Vector listResult = new Vector();
        int httpLogFilesSize = result.length;
        if(httpLogFilesSize > 2){
            for(int i = 2; i < httpLogFilesSize; i++){
                String logfile = result[i];
                SyslogHttpLogInfoBean logInfo = new SyslogHttpLogInfoBean();
                logInfo.setLogLabel(logfile.substring(logfile.lastIndexOf("/")+1));
                logInfo.setLogFileName(logfile);
                listResult.add(logInfo);
            }
            sortByHttpLogName(listResult);            
        }
        return listResult;
    }
    
    private void changEncodingForPage(ArrayList cifsComputerList)throws Exception{
        int size =  cifsComputerList.size();
        for(int i = 0; i< size; i++){
            SyslogCifsLogInfoBean computerInfo = (SyslogCifsLogInfoBean)cifsComputerList.get(i);
            String encoding = computerInfo.getEncoding();
            if(encoding.equalsIgnoreCase(FrameworkConst.ENCODING_UTF8)){
                //change the "UTF8" to "UTF-8"
                encoding = FrameworkConst.ENCODING_UTF_8;
                computerInfo.setEncoding(encoding);
            }
            if(!encoding.equals("")){
                computerInfo.setAccessLogFile(
                    NSActionUtil.perl2Page(
                        computerInfo.getAccessLogFile(), encoding)
                );
            }
        }
    }

    private void sortByHttpLogName (Vector the_list){
        Collections.sort
            (the_list, new Comparator()
                {
                    public int compare(Object a, Object b){
                        SyslogHttpLogInfoBean info_a = (SyslogHttpLogInfoBean)a;
                        SyslogHttpLogInfoBean info_b = (SyslogHttpLogInfoBean)b;
                        return info_a.getLogLabel().compareTo(info_b.getLogLabel());
                    }
               }
            );
    }

    private void sortByComputerName (ArrayList the_list){
        Collections.sort
            (the_list, new Comparator()
                {
                    public int compare(Object a, Object b){
                        SyslogCifsLogInfoBean info_a = (SyslogCifsLogInfoBean)a;
                        SyslogCifsLogInfoBean info_b = (SyslogCifsLogInfoBean)b;
                        return info_a.getComputerName().compareTo(info_b.getComputerName());
                    }
               }
            );
    }

    public ActionForward loadCifsMiddle(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        request.setAttribute("maxLinesSet", getMaxLinesSet());
        request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
        ((DynaValidatorForm)form).set("commonInfo",
                                    getInitCommonInfo(LOG_TYPE_CIFS_LOG));
        
        return mapping.findForward("displayCommonInfo");
    }

    public ActionForward loadHttpMiddle(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        request.setAttribute("maxLinesSet", getMaxLinesSet());
        request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
        ((DynaValidatorForm)form).set("commonInfo",
                                        getInitCommonInfo(LOG_TYPE_HTTP_LOG));
        
        return mapping.findForward("displayCommonInfo");
    }


    private SyslogCommonInfoBean getInitCommonInfo (String logType){
        SyslogCommonInfoBean commonInfoBean = new SyslogCommonInfoBean();
        commonInfoBean.setLogType(logType);
        return commonInfoBean;
    }

    public ActionForward loadNfsMiddle(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        request.setAttribute("maxLinesSet", getMaxLinesSet());
        request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
        ((DynaValidatorForm)form).set("commonInfo", getInitCommonInfo(LOG_TYPE_NFS_LOG));
        return mapping.findForward("displayNfsMiddle");
    }
    
    public ActionForward loadNfsTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int group = NSActionUtil.getCurrentNodeNo(request);
   
        String accessFile ="";
        String isAccessExist ="false";
        String accessFileSize = "";

        Vector nfsLogInfo = SyslogCmdHandler.getNfsLogInfo(group);
        if (nfsLogInfo != null){
            accessFile = (String)nfsLogInfo.get(0);
            accessFileSize = (String)nfsLogInfo.get(1);
            isAccessExist = (String)nfsLogInfo.get(2);
        }
        
        List accessLogFilesInfo = (List)nfsLogInfo.get(3);
        changeDate_TimeInfo(accessLogFilesInfo,request);
        
    	for(int i = 0; i < accessLogFilesInfo.size(); i++){
    		SyslogLogFileInfo info = (SyslogLogFileInfo)accessLogFilesInfo.get(i);
        	info.setFileSizeForDisplay(formatSizeStr(info.getFileSize()));
        }

    	request.setAttribute("accessFileSizeForDisplay", formatSizeStr(accessFileSize));
    	request.setAttribute("accessFileSize", accessFileSize);
    	request.setAttribute("accessFile_RotateList", accessLogFilesInfo);
        
        String accessLogNeedDisplayTime = (String)nfsLogInfo.get(4);
        
        request.setAttribute("accessLogFile", accessFile);
        request.setAttribute("isAccessExist", isAccessExist);
        request.setAttribute("needDisplayTime", accessLogNeedDisplayTime);
        return mapping.findForward("displayNfsTop");
    }

    private void changeDate_TimeInfo(List logFileList, HttpServletRequest request){
        int size = logFileList.size();
        String[] date_timeInfo;
        for(int i = 0; i < size; i++){
            SyslogLogFileInfo logFileInfo = (SyslogLogFileInfo)logFileList.get(i);
            date_timeInfo = NSActionUtil.getLocalDate_Time(logFileInfo.getDateString(),
                                                 logFileInfo.getTimeString(), request);
            logFileInfo.setDateString(date_timeInfo[0]);
            logFileInfo.setTimeString(date_timeInfo[1]);
        }
    }

    public ActionForward beginSearch(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
            DynaValidatorForm dynaForm = (DynaValidatorForm) form;
            SyslogSearchConditions conditions = new SyslogSearchConditions();
            SyslogCommonInfoBean commonInfoBean = (SyslogCommonInfoBean)((DynaValidatorForm)form).get("commonInfo");
            SyslogCifsSearchInfoBean cifsInfoBean = (SyslogCifsSearchInfoBean)((DynaValidatorForm)form).get("cifsSearchInfo");
            conditions.setCifsSearchInfo(cifsInfoBean);
            if(commonInfoBean.getLogType().equals(LOG_TYPE_CIFS_LOG)){
                if(!cifsInfoBean.getEncoding().equals("")){
                    commonInfoBean.setLogFile(
                                NSActionUtil.page2Perl(
                                commonInfoBean.getLogFile(),cifsInfoBean.getEncoding(),NSActionConst.BROWSER_ENCODE)
                                );
                }
            }
            commonInfoBean.setLogName(
                        NSActionUtil.reqStr2EncodeStr(
                            commonInfoBean.getLogName(),NSActionConst.BROWSER_ENCODE)
                     );
            conditions.setCommonInfo(commonInfoBean);
            SyslogSystemSearchInfoBean systemInfoBean = (SyslogSystemSearchInfoBean)((DynaValidatorForm)form).get("systemSearchInfo");
            conditions.setSystemlogSearchInfo(systemInfoBean);
            
            request.getSession().setAttribute(SESSION_LOGVIEW_SEARCHCONDTION,conditions);
            return mapping.findForward("beginSearch");
    }
    
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        SyslogSearchConditions conditions = (SyslogSearchConditions)session.getAttribute(SESSION_LOGVIEW_SEARCHCONDTION);
        DynaValidatorForm dynaForm = (DynaValidatorForm)form;
        SyslogLogviewInfoBean viewInfo = (SyslogLogviewInfoBean)dynaForm.get("viewInfo");
        String displayEncoding = viewInfo.getDisplayEncoding();
        SyslogCommonInfoBean commonInfo = conditions.getCommonInfo();
        int viewLines = Integer.parseInt(commonInfo.getViewLines());
        if(displayEncoding == null || displayEncoding.equals("")){
            //called by [Display All...] or [Search...]
            displayEncoding = commonInfo.getDisplayEncoding();
            viewInfo.setDisplayEncoding(conditions.getCommonInfo().getDisplayEncoding());
        }else{
            //called by [Refresh]
            commonInfo.setDisplayEncoding(displayEncoding); 
        }
        SyslogCacheFileInfo cacheFileInfo = SyslogCmdHandler.makeCacheFile(nodeNo,conditions,session.getId());
        if(cacheFileInfo == null){
            return mapping.findForward("display");
        } else if(!cacheFileInfo.getErrorType().equals("")) {
            String errorMessage = "";
            if(cacheFileInfo.getErrorType().equals("DiskIsFull")) {
                errorMessage = "syslog.logview.diskIsFull";
            } else if(cacheFileInfo.getErrorType().equals("rotate")) {
                errorMessage = "syslog.logview.rotate";
            }
            request.setAttribute(REQUEST_LOGVIEW_ERRORTYPE, errorMessage);
            return mapping.findForward("display");
        }
        NSActionUtil.setSessionAttribute(request, SESSION_LOGVIEW_FILENAME, cacheFileInfo.getLogFileName());
        NSActionUtil.setSessionAttribute(request, "logview_viewDownloadFile", cacheFileInfo.getLogFileName());
        viewInfo.setDownloadFileName(cacheFileInfo.getLogFileName());
        long pageCount = cacheFileInfo.getTotalLine()%viewLines == 0 ? cacheFileInfo.getTotalLine()/viewLines : cacheFileInfo.getTotalLine()/viewLines+1;
        viewInfo.setPageCount(Long.toString(pageCount));
        int currentPage = Integer.parseInt(viewInfo.getCurrentPage());
        if(pageCount < currentPage){
            currentPage = 1;
            viewInfo.setCurrentPage("1");
        }
        if(pageCount != 0){
            long startLine = (currentPage - 1) * viewLines + 1;
            String logContents = SyslogCmdHandler.readLogFile(cacheFileInfo.getLogFileName(), startLine, viewLines - 1, conditions);
            viewInfo.setLogContents(getChangedLogContEncoding(logContents, displayEncoding));
        }
        
        request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
        request.setAttribute("needAutoDownload", request.getParameter("needAutoDownload"));
        return mapping.findForward("display");
    }

    private String getChangedLogContEncoding(String logContents, String encoding)throws Exception {
        if((encoding != null) && (!encoding.equals(""))){
            return NSActionUtil.perl2Page(logContents, encoding);
        }else{
            return logContents;
        }
    }

    public ActionForward redisplay(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        SyslogSearchConditions conditions = (SyslogSearchConditions)session.getAttribute(SESSION_LOGVIEW_SEARCHCONDTION);
        String viewLogFileName = (String)NSActionUtil.getSessionAttribute(request, SESSION_LOGVIEW_FILENAME);
        int viewLines = Integer.parseInt((String)conditions.getCommonInfo().getViewLines());
        if(!SyslogCmdHandler.fileExist(viewLogFileName)){
            return display(mapping,form,request,response);
        }else{
            DynaValidatorForm dynaForm = (DynaValidatorForm)form;
            SyslogLogviewInfoBean viewInfo = (SyslogLogviewInfoBean)dynaForm.get("viewInfo");
            int currentPage = Integer.parseInt(viewInfo.getCurrentPage());
            long startLine = (currentPage - 1) * viewLines + 1;

            String logContents = SyslogCmdHandler.readLogFile(viewLogFileName, startLine, viewLines -1, conditions);
            viewInfo.setLogContents(getChangedLogContEncoding(logContents, viewInfo.getDisplayEncoding()));
            request.setAttribute("displayEncodingSet", getDisplayEncodingSet(request));
            return mapping.findForward("redisplay");
        }
   }

    public ActionForward autoConnectServer(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        return mapping.findForward("autoConnectServer");
    }

    public ActionForward download(
       ActionMapping mapping,
       ActionForm form,
       HttpServletRequest request,
       HttpServletResponse response)
       throws Exception {

       return mapping.findForward("download");
    }

    public ActionForward cancelSearch(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String logType = (String)NSActionUtil.getSessionAttribute(request, "logview_search_logType");
        if(logType.equals("nfsPerformLog")){
            int nodeNo = NSActionUtil.getCurrentNodeNo(request);            
            String logFileName = (String)NSActionUtil.getSessionAttribute(request, SESSION_NAME_NFS_PERFORM_LOG_FILE);
            
            SyslogCmdHandler.cancelNfsPerformLogSearch(logFileName, nodeNo);
        }   
        
        NSActionUtil.setSessionAttribute(request, SESSION_NAME_NFS_PERFORM_SEARCH_ENDED, NFS_PERFORM_SEARCH_ENDED);
        
        return mapping.findForward("cancelSearch");
    }

    public ActionForward popupHeartbeat(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) 
        throws Exception {

        HttpSession session = request.getSession();
        String popupFor = (String)((DynaValidatorForm)form).get("popupFor");
        if(popupFor.equals("logview")){
            session.setAttribute(SESSION_NAME_NFS_PERFORM_LOG_FILE, (String)((DynaValidatorForm)form).get("logFileName"));
            session.setAttribute("nfslog_perform_startTime", (String)((DynaValidatorForm)form).get("startTime"));
            session.setAttribute("logview_log_file_size", (String)((DynaValidatorForm)form).get("fileSize"));
            session.setAttribute(SESSION_NAME_NFS_PERFORM_SEARCH_ENDED, "");
            NSActionUtil.setSessionAttribute(request, "logview_search_logType", (String)((DynaValidatorForm)form).get("logType"));
            return mapping.findForward("popupHearbeat");
        }else {
        	session.setAttribute("logview_directDown_startTime", (String)((DynaValidatorForm)form).get("startTime"));
        	session.setAttribute("logview_log_file_size", (String)((DynaValidatorForm)form).get("fileSize"));
        	session.setAttribute(SESSION_NAME_DIRECTDOWNLOAD_MAKEFILE_ENDED,"");
        	NSActionUtil.setSessionAttribute(request, "logview_search_logType", (String)((DynaValidatorForm)form).get("logType"));
        	return mapping.findForward("popupDirectHearbeat");
        }
    }
    
    public ActionForward directDownload(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{
    	int nodeNo = NSActionUtil.getCurrentNodeNo(request); 
    	String sessionID = request.getSession().getId(); 
    	
    	DynaValidatorForm dynaForm = (DynaValidatorForm)form;
        
        String logType = (String)request.getParameter("logType4directDown");
        String logFile = (String)request.getParameter("logFile4directDown");
        String encoding = "";
        if(!logType.equals(LOG_TYPE_SYSTEM_LOG)){
            encoding = (String)request.getParameter("displayEncoding4directDown");
        }
        
        String downloadFile = null;
        
        SyslogCommonInfoBean commonInfoBean = new SyslogCommonInfoBean();
        commonInfoBean.setLogType(logType);
        commonInfoBean.setLogFile(logFile);
        commonInfoBean.setDisplayEncoding(encoding);
        
        SyslogCifsSearchInfoBean cifsInfoBean = new SyslogCifsSearchInfoBean();
        
        if(logType.equals(LOG_TYPE_CIFS_LOG)){
            String cifsSearchEncoding = (String)request.getParameter("cifsSearchEncoding");
            if(cifsSearchEncoding != null && !cifsSearchEncoding.equals("")){
                cifsInfoBean.setEncoding(cifsSearchEncoding);
                commonInfoBean.setLogFile(
                            NSActionUtil.page2Perl(
                            logFile,cifsSearchEncoding,NSActionConst.BROWSER_ENCODE)
                            );
            }else{
                cifsInfoBean.setEncoding("");
            }
        }
        SyslogSystemSearchInfoBean  systemlogSearchInfo = new SyslogSystemSearchInfoBean();
        if(logType.equals(LOG_TYPE_SYSTEM_LOG)){
            systemlogSearchInfo.setAllKeywords((String)request.getParameter("systemAllSearchKeywords"));
        }
        SyslogSearchConditions conditions = new SyslogSearchConditions();
        conditions.setCommonInfo(commonInfoBean);
        conditions.setCifsSearchInfo(cifsInfoBean);
        conditions.setSystemlogSearchInfo(systemlogSearchInfo);
        
        SyslogCacheFileInfo cacheFileInfo = SyslogCmdHandler.makeCacheFile(nodeNo, 
            conditions, sessionID, "isDirectDown");
        NSActionUtil.setSessionAttribute(request, SESSION_NAME_DIRECTDOWNLOAD_MAKEFILE_ENDED, 
        		DIRECTDOWN_MAKEFILE_ENDED);
        if(cacheFileInfo == null){
            String alertMessage = getResources(request).getMessage(
                        request.getLocale(),
                        "syslog.directDownload.msg.fileSize_zero");
            NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                    alertMessage);            
            return mapping.findForward(logType);
        }else if(!cacheFileInfo.getErrorType().equals("")){
         	String alertMessage = null;
          	if(cacheFileInfo.getErrorType().equals("DiskIsFull")) {
           		alertMessage = getResources(request).getMessage(
                        request.getLocale(),
                        "syslog.directDownload.diskIsFull");
            } else if(cacheFileInfo.getErrorType().equals("rotate")) {
             	alertMessage = getResources(request).getMessage(
                        request.getLocale(),
                        "syslog.logview.rotate");
            }
            NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                 alertMessage);
            return mapping.findForward(logType);
        }else{
          	downloadFile = cacheFileInfo.getLogFileName();
          	NSActionUtil.setSessionAttribute(request, "logview_directDownloadFile", downloadFile);
        }         	
    	request.setAttribute("from", "directDownload");
    	request.setAttribute("logType", logType);
    	return mapping.findForward("downloadframe");
    	//return mapping.findForward(logType);
    }
}
