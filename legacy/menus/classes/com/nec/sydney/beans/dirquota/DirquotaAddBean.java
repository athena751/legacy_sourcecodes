/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 

package com.nec.sydney.beans.dirquota;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.filesystem.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.beans.mapdcommon.*;
import java.util.*;
import java.io.*;

public class DirquotaAddBean extends TemplateBean implements NSExceptionMsg,NasConstants,NasSession{

    private static final String     cvsid = "@(#) $Id: DirquotaAddBean.java,v 1.2307 2006/05/16 03:04:32 zhangjun Exp $";
    private static final String     DIRQUOTA_DATASET_REGISTERED = "is already registered as dataset";
    private static final String     DIRQUOTA_NO_SUCH_EXPORT = "The export root doesn't exist";
    private static final String     DIRQUOTA_NO_SUCH_FS = "No such mount point";
    private boolean allowAdd=true;

    public void onDisplay() throws Exception {
        String isFailed = request.getParameter("isfailed");
        if (isFailed!=null){
            return;   
        }
        String path=(String)session.getAttribute(NasConstants.MP_SESSION_HEX_MOUNTPOINT);
        if(!DirQuotaSOAPClient.getAllowAdd(target,path)){
            allowAdd=false;
        }
    }   

    public void onAdd() throws Exception {
        String dirText=request.getParameter("dirText");
        
        String export = (String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT);
        String filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        String codepage = APISOAPClient.getCodepage(target, export);

        //String path=NSUtil.str2hStr(dirText,codepage);
        //String path = NSUtil.page2Perl(dirText ,codepage, NasConstants.CODEPAGE_UTF8);
        String path = NSActionUtil.page2Perl(dirText ,codepage, NasConstants.CODEPAGE_UTF8);
        
        String errMessage = (String)DirQuotaSOAPClient.addDataset(target,path,filesystem);
        String redirectURL;
        if(errMessage == null || errMessage.trim().equals("")){ 
            //super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
            redirectURL = super.response.encodeRedirectURL("../nas/dirquota/dirquotadatasetmain.jsp?nextAction=dirquota&action=selected&hasAlert=yes");
        }else {
            if(errMessage.indexOf(DIRQUOTA_DATASET_REGISTERED) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/registered"));
            } else if(errMessage.indexOf(DIRQUOTA_NO_SUCH_EXPORT) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/no_such_export"));
            } else if(errMessage.indexOf(DIRQUOTA_NO_SUCH_FS) > 0){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_dataset/alert/no_such_fs"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed"));
            }
            redirectURL = super.response.encodeRedirectURL("../nas/dirquota/dirquotaadd.jsp?isfailed='fail'");
        }
        super.response.sendRedirect(redirectURL);
    }   

    public boolean getAllowAdd(){
        return allowAdd;
    }
}
