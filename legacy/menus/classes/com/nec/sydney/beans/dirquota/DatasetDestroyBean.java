/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.dirquota;

import java.util.*;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;

public class DatasetDestroyBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: DatasetDestroyBean.java,v 1.2304 2006/05/16 03:04:32 zhangjun Exp $";
    private static final String     DIRQUOTA_DIR_NOT_EMPTY  = "There are some files or directories in";
    private static final String     DIRQUOTA_NOT_DATASET    = "is not a dataset directory";
    private static final String     DIRQUOTA_NO_DIRECTORY   = "No such file or directory";
    
    public DatasetDestroyBean() {
    }
    
    public void beanProcess() throws Exception {
        
        String strDataset = request.getParameter("dataset");
        //String hexDataset = NSUtil.ascii2hStr(strDataset);
        String export = (String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT);
        String codepage = APISOAPClient.getCodepage(target, export);
        //String hexDataset = NSUtil.page2Perl(strDataset ,codepage, NasConstants.CODEPAGE_UTF8);
        String hexDataset = NSActionUtil.page2Perl(strDataset ,codepage, NasConstants.CODEPAGE_UTF8);

        String errMessage = DirQuotaSOAPClient.deleteDataset(target,hexDataset);
        if(errMessage == null || errMessage.trim().equals("")){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        }else{
            if(errMessage.indexOf(DIRQUOTA_DIR_NOT_EMPTY) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/dir_not_empty"));
            }else if(errMessage.indexOf(DIRQUOTA_NOT_DATASET) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/no_dataset"));
            }else if(errMessage.indexOf(DIRQUOTA_NO_DIRECTORY) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/no_dir"));
            }else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed"));     
            }
        }
        response.sendRedirect(response.encodeRedirectURL("datasetlist.jsp?reverse=true"));  
    }

}