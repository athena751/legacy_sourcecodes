/*
 *      Copyright (c) 2001-2007 NEC Corporation
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
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.beans.mapdcommon.*;
import java.util.*;
import java.io.*;

public class DirquotaListBean extends AbstractJSPBean implements NSExceptionMsg,NasConstants,NasSession
{

    private static final String  cvsid = "@(#) $Id: DirquotaListBean.java,v 1.2305 2007/04/27 03:35:22 liul Exp $";

    private String act;
    private Vector subDir;
    private String wholePath;

    
    public void beanProcess()throws Exception {        

        act = request.getParameter("act");
        
        String frameNo = request.getParameter("frameNo");
        String hExportRoot=new String();
        wholePath = request.getParameter("wholePath");
        if(wholePath==null){
            wholePath=(String)session.getAttribute(NasConstants.MP_SESSION_HEX_MOUNTPOINT);
        }

        if (frameNo==null){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session, "exception/nfs/miss_frameNo"));
            throw ex;
        }else if(frameNo.equals("0") || frameNo.equals("2")){
            return;
        } else {
            try {                
                if (act.equals("dirquotalist")){
                    subDir = DirQuotaSOAPClient.getDirList(target,wholePath);
                }
            } catch (NSException e) {                
                    throw e;
            }
        }        
    }

    public Vector getDir(){
        return subDir;
    }

    public DirquotaListBean(){
    }

    public String getCodePage(String export) throws Exception {
        return APISOAPClient.getCodepage(target, export);
    }

    public String encoding(String path, String codepage)throws Exception{        
        //path = NSUtil.hStr2EncodeStr(path, codepage, NasConstants.CODEPAGE_UTF8);
        path = NSActionUtil.hStr2Str(path,codepage);
        
        return path;
    }
    
    public String getWholePath(){
        return wholePath;
    }

    public String getWholePathParent() throws Exception{        
        String[] piece=wholePath.split("0x2f");
        String parent="";
        int length=piece.length;
        for(int i=0;i<length-1;i++){            
            if(piece[i].equals("")){
                continue;
            }
            parent+="0x2f"+piece[i];
        }        
        return parent;
    }

}
