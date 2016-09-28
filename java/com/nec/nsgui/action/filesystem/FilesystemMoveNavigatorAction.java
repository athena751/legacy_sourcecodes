/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.filesystem;


import java.util.Locale;
import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class FilesystemMoveNavigatorAction extends DispatchAction {
    
    private static final String cvsid = "@(#) $Id: FilesystemMoveNavigatorAction.java,v 1.1 2005/06/10 09:43:23 jiangfx Exp $";
    
    public ActionForward call(ActionMapping mapping, 
                              ActionForm form,
                              HttpServletRequest request,
                              HttpServletResponse response)throws Exception {
        
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory  = (String)((DynaActionForm)form).get("nowDirectory");
        String fsType        = (String)((DynaActionForm)form).get("fsType");
              
        NSActionUtil.setSessionAttribute(request, "rootDirectory", rootDirectory);
        NSActionUtil.setSessionAttribute(request, "nowDirectory", nowDirectory);
        NSActionUtil.setSessionAttribute(request, "fsType", fsType);
        NSActionUtil.setSessionAttribute(request, "displayDirectory", "");
        
        Locale locale   = request.getLocale();
        boolean check   = true;
        String codepage = NSActionUtil.getExportGroupEncoding(request);
        
        int partnerNodeNo = (NSActionUtil.getCurrentNodeNo(request) == 0) ? 1 : 0;
        FilesystemHandler filesystemHandler = new FilesystemHandler();
        Vector allDirectoryInfo = filesystemHandler.getMoveNavigatorList(rootDirectory, nowDirectory, 
                                                    check, codepage, fsType, locale, partnerNodeNo);
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        ((DynaActionForm)form).set("nowDirectory" , nowDirTrue);
        
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo); //sort in java     
        
        NSActionUtil.setSessionAttribute(request, "fsMoveAllDirectoryInfo" , allDirectoryInfo); 
        return mapping.findForward("success_call");
    }
    
    
    public ActionForward list(ActionMapping mapping, 
                              ActionForm form , 
                              HttpServletRequest request,
                              HttpServletResponse response) throws Exception {                          
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory  = (String)((DynaActionForm)form).get("nowDirectory");   
        String fsType        = (String)((DynaActionForm)form).get("fsType");
                            
        Locale locale   = request.getLocale();
        boolean check   = false;
        String codepage = NSActionUtil.getExportGroupEncoding(request);
        
        int partnerNodeNo = (NSActionUtil.getCurrentNodeNo(request) == 0) ? 1 : 0;
        FilesystemHandler filesystemHandler = new FilesystemHandler();
        Vector allDirectoryInfo = filesystemHandler.getMoveNavigatorList(rootDirectory, nowDirectory, 
                                                    check, codepage, fsType, locale, partnerNodeNo);
                                                    
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);//sort in java
        
        NSActionUtil.setSessionAttribute(request, "fsMoveAllDirectoryInfo" , allDirectoryInfo);      
        return mapping.findForward("success_list");
    }
}