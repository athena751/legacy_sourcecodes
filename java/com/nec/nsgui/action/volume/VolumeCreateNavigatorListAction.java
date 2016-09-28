/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.volume;


import java.util.Locale;
import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.volume.VolumeCreateNavigatorList;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class VolumeCreateNavigatorListAction extends DispatchAction {
    
    private static final String     cvsid = "@(#) $Id: VolumeCreateNavigatorListAction.java,v 1.3 2005/01/05 06:33:15 liuyq Exp $";
    
    public ActionForward call(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");
        String displayDirectory ;
        if (rootDirectory.equals(nowDirectory)) {
            displayDirectory = "";
        } else {
            displayDirectory = nowDirectory.substring(rootDirectory.length() + 1);
        }
        
        HttpSession session = request.getSession(false);
        session.setAttribute("rootDirectory" , rootDirectory);
        session.setAttribute("nowDirectory" , nowDirectory);
        session.setAttribute("displayDirectory" , displayDirectory);
        
        Locale locale = request.getLocale();
        
        VolumeCreateNavigatorList vcNL = new VolumeCreateNavigatorList();
        
        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = vcNL.onList(rootDirectory , nowDirectory , locale , check , nodeNo);
        
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        ((DynaActionForm)form).set("nowDirectory" , nowDirTrue);
        
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);//sort in java     
        
        session.setAttribute("VolumeCreateAllDirectoryInfo" , allDirectoryInfo);
        return mapping.findForward("success_call");
    }
    
    
    public ActionForward list(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {                      	
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");   
                           	
        Locale locale = request.getLocale();
        
        VolumeCreateNavigatorList vcNL = new VolumeCreateNavigatorList();
        
        boolean check = false;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = vcNL.onList(rootDirectory , nowDirectory , locale , check , nodeNo);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);//sort in java
        
        request.setAttribute("VolumeCreateAllDirectoryInfo" , allDirectoryInfo);      
        return mapping.findForward("success_list");
    }
}