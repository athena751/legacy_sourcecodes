/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.mapd;


import java.util.Locale;
import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.mapd.MapdNavigatorList;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class MapdNavigatorListAction extends DispatchAction {
    
    private static final String     cvsid = "@(#) $Id: MapdNavigatorListAction.java,v 1.2 2004/12/30 09:28:10 xingh Exp $";
    
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
        
        MapdNavigatorList mapdNL = new MapdNavigatorList();
        
        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = mapdNL.onList(rootDirectory , nowDirectory , locale , check , nodeNo);
        
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        ((DynaActionForm)form).set("nowDirectory" , nowDirTrue);
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
                 
        session.setAttribute("MapdAllDirectoryInfo" , allDirectoryInfo);
        return mapping.findForward("success_call");
    }
    
    
    public ActionForward list(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {                          
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");   
                            
        Locale locale = request.getLocale();
        
        MapdNavigatorList mapdNL = new MapdNavigatorList();
        
        boolean check = false;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = mapdNL.onList(rootDirectory , nowDirectory , locale , check , nodeNo);
        
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);        
        request.setAttribute("MapdAllDirectoryInfo" , allDirectoryInfo);      
        return mapping.findForward("success_list");
    }
}