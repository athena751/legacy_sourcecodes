/*
 *      Copyright (c) 2005-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.disk;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.util.LabelValueBean;

import com.nec.nsgui.model.entity.disk.PoolInfoBean;
import com.nec.nsgui.model.biz.disk.DiskHandler;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.disk.DiskConstant;

/** 
 * @struts:action-forward name="/nas/disk/poolexpand.jsp" 
 +
 */
public class ExpandPoolDisplayAction extends Action implements DiskConstant{
    public static final String cvsid = "@(#) $Id: ExpandPoolDisplayAction.java,v 1.3 2006/01/06 00:36:57 liq Exp $";
    
    
    public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String arrayid = request.getParameter("diskarrayid");
        String arrayname = request.getParameter("diskarrayname");
        String pdgnum = request.getParameter("pdgroupnumber");
        String from = (String)(dynaForm.get("from"));
        PoolInfoBean poolinfo = (PoolInfoBean)(dynaForm.get("poolinfo"));
        String onepooltype ="--";
        String onepoolc ="0";
        String onepdc = "0";
        Vector oldPDList = new Vector();
        Vector notUsePDList = new Vector();
        Vector usePDList = new Vector();
        String specifyedPool = poolinfo.getPoolname();
        Vector poolforshow = new Vector();
        Vector poollist = DiskHandler.getRaid6PoolList(arrayid,pdgnum); //name(number h)
        if (poollist.size()>0){
                for (int i=0 ; i<poollist.size() ; i++) {
                poolforshow.add(new LabelValueBean((String)poollist.get(i),(String)poollist.get(i)));
            }
            if (specifyedPool==null||specifyedPool.equals("")){
                specifyedPool = (String)poollist.get(0);
            }
            
            String pooln = specifyedPool.substring(specifyedPool.indexOf("(")+1,specifyedPool.length()-2);
            String onepoolinfo = DiskHandler.getPoolInfo(arrayid,pooln);
            onepoolc = onepoolinfo.split(",")[0];
            onepooltype = onepoolinfo.split(",")[1];
            
            String updinfo = DiskHandler.getPoolPD(arrayid,pooln);
            oldPDList = DiskCommon.getVectorforPDList(updinfo);
            
            onepdc = DiskCommon.getSmallestPdCapacity(updinfo);
        }else{
            poolforshow.add(new LabelValueBean("--------","--------"));
        }
        String pdinfo = DiskHandler.getUnUsedPD(arrayid,pdgnum); //xxh-yyh,cccc\nxxh-yyh,cccc
        notUsePDList = DiskCommon.getVectorforPDList(pdinfo);
        poolinfo.setPoolname(specifyedPool);
        poolinfo.setRaidtype(onepooltype);
        
        request.setAttribute("notusepdlist",notUsePDList);//not used pd
        NSActionUtil.setSessionAttribute(request,SESSION_OLD_POOL_PD,oldPDList);//old pd
        request.setAttribute("usepdlist",usePDList);//new add first load has none
        request.setAttribute("pdq",Integer.toString(notUsePDList.size())); 
        request.setAttribute("poolpdnumber",Integer.toString(oldPDList.size()));
        NSActionUtil.setSessionAttribute(request,SESSION_RAID6_POOL_LIST,poolforshow);//raid6 pool list
        NSActionUtil.setSessionAttribute(request,SESSION_SMALL_POOL_PD_CAPACITY,onepdc);//pool small pd capacity
        NSActionUtil.setSessionAttribute(request,SESSION_OLD_POOL_CAPACITY,onepoolc);//raid6 pool capacity
        return mapping.findForward("display"); 
    }
}
