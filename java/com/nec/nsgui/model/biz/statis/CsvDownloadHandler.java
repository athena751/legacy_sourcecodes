/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.statis;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import java.util.Vector;

import com.nec.nsgui.action.statis.StatisActionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSProcess;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.entity.statis.CsvDownloadCmdOpts;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.CsvDownloadUtil;
import com.nec.nsgui.model.entity.statis.StatisConst;
/**
 *
 */
public class CsvDownloadHandler implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: CsvDownloadHandler.java,v 1.2 2007/03/07 06:27:13 yangxj Exp $";
    public static final String PERL_SCRIPT_RRDLIST = "/bin/rrdlist";

    public static final String PERL_SCRIPT_GET_CSV_FILE =
        "/bin/statis_createTmpCsvFile.pl";

    public static final String RRDLIST_RESOURCES_OPTION = "resources";
    public static final String RRDLIST_VERSION_OPTION = "-v";
    public static final String RRDLIST_CPNAME_OPTION  = "-c";

    public static Vector getResourceList(
        CsvDownloadInfoBean downloadInfo,
        String version)
        throws Exception {
        String host = downloadInfo.getHost();
        //target id such as "hawk"
        String originalWatchItemID = downloadInfo.getOriginalWatchItemID();
        String home = System.getProperty("user.home");
        if(downloadInfo.getCpName().equals("")){
        String[] cmd =
            {
                home + PERL_SCRIPT_RRDLIST,
                RRDLIST_VERSION_OPTION,
                version,
                RRDLIST_RESOURCES_OPTION,
                host,
                CsvDownloadUtil.changeWatchItem2Infotype(originalWatchItemID)};
        return getResources(cmd);
        }else{
        String[] cmd =
            {
                home + PERL_SCRIPT_RRDLIST,
                RRDLIST_VERSION_OPTION,
                version,
                RRDLIST_CPNAME_OPTION,
                downloadInfo.getCpName(),
                RRDLIST_RESOURCES_OPTION,
                host,
                CsvDownloadUtil.changeWatchItem2Infotype(originalWatchItemID)};
        return getResources(cmd);
        }
    }

    public static NSCmdResult downloadCsv(CsvDownloadCmdOpts opts)
        throws Exception {

        //execute rrd2csv
        String home = System.getProperty("user.home");
        String[] cmd =
            {
                home + PERL_SCRIPT_GET_CSV_FILE,
                opts.getHost(),
                opts.getInfotype(),
                opts.getStartTimeOption(),
                opts.getEndTimeOption(),
                opts.getResourceOption(),
                opts.getItemsOption(),
                opts.getUseMountpointOption(),
                opts.getVersion(),
                opts.getCpName()
                };
        NSCmdResult result = CmdExecBase.localExecCmd(cmd, null, false);
        return result;
    }

    public static Vector getResourceList4NSW(
        CsvDownloadInfoBean downloadInfo
        )
        throws Exception {
        String collectionItemId = downloadInfo.getCollectionItemId();
        String home = System.getProperty("user.home");
        String[] cmd =
            {
                home + PERL_SCRIPT_RRDLIST,
                RRDLIST_VERSION_OPTION,
                "3",RRDLIST_RESOURCES_OPTION,
                CsvDownloadUtil.changeCollectionItem2Infotype(
                    collectionItemId)};
        return getResources(cmd);
    }

    private static Vector getResources(String[] cmd) throws Exception {
        NSCmdResult result = CmdExecBase.localExecCmd(cmd, null, true);
        Vector resourceList = new Vector();
        if (result.getExitValue() == CSV_DOWNLOAD_PERL_SCRIPT_EXEC_SUCCEED) {
            String[] stdout = result.getStdout();
            for (int i = 0; i < stdout.length; i++) {
                resourceList.add(stdout[i]);
            }
            if (resourceList.size() == 0) {
                CsvDownloadUtil.makeNSException(
                    CsvDownloadHandler.class,
                    StatisConst.ERROR_MSG_NO_RESOURCES,
                    cmd,
                    NSReporter.FATAL);
            }
        } else {
            StringBuffer sb = new StringBuffer();
            String[] stderr = result.getStderr();
            for (int i = 0; i < stderr.length; i++) {
                sb.append(stderr[i]);
            }
            CsvDownloadUtil.makeNSException(
                CsvDownloadHandler.class,
                sb.toString(),
                cmd,
                NSReporter.FATAL);

        }
        return resourceList;
    }

}