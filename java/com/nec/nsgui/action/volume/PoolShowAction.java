/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.validator.DynaValidatorForm;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.DiskArrayInfoBean;
import com.nec.nsgui.model.entity.volume.PoolInfoBean;
import com.nec.nsgui.action.disk.DiskCommon;

public class PoolShowAction extends Action {
    public static final String cvsid =
        "@(#) $Id: PoolShowAction.java,v 1.11 2008/05/05 08:36:35 liuyq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
   
        String aid = (String) ((DynaValidatorForm) form).get("aid");       
        String raidType = (String) ((DynaValidatorForm) form).get("raidType");  
        String poolnameno = request.getParameter("poolnameno");

       String moduleName = (String)NSActionUtil.getSessionAttribute(request, "moduleName");
       String unusablePoolNo = (String)NSActionUtil.getSessionAttribute(request, "unusablePoolNo");
       if (moduleName != null && moduleName.startsWith("ddr")) {
    	   //moduleName is ddrCreate or ddrExtend,aid is same to MV's aid
    	   aid = (String)NSActionUtil.getSessionAttribute(request, "aid");
       }

       try{
        Vector diskArrayVector = new Vector();
        DiskArrayInfoBean diskArrayInfo;
        List diskArrayList = VolumeHandler.getDiskArrayInfo();
        
        for (int i = 0; i < diskArrayList.size(); i++) {
            diskArrayInfo = (DiskArrayInfoBean)diskArrayList.get(i);
            diskArrayVector.add(new LabelValueBean(diskArrayInfo.getAname(), diskArrayInfo.getAid()));
        }
        request.setAttribute("diskArrayVector", diskArrayVector);
        
        if ((aid == null) || (aid.equals("")) 
            || (raidType == null) || (raidType.equals(""))) {
            diskArrayInfo = (DiskArrayInfoBean)diskArrayList.get(0);
            aid = diskArrayInfo.getAid();
            raidType = "68";

            ((DynaValidatorForm) form).set("aid", aid);
            ((DynaValidatorForm) form).set("raidType", raidType);              
        } 

        List poolList = VolumeHandler.getPoolInfo(aid, raidType);
        
        if (moduleName != null && moduleName.startsWith("ddr")) {
        	//get MV's pools, multi-pool is joined by comma 
        	if (unusablePoolNo !=null && !unusablePoolNo.equals("--")) {
	        	String[] unusablePoolNoArr = unusablePoolNo.split(",");
	        	//moduleName is ddrCreate or ddrExtend, ,MV's pools can not be shown
	      	    for (int i = 0; i < unusablePoolNoArr.length; i++) {
	               for (int j = 0; j < poolList.size(); j++) {
	           		  PoolInfoBean tmpPoolInfo = (PoolInfoBean) poolList.get(j);
	          		  String poolNo = tmpPoolInfo.getPoolNo();
	             	  if (unusablePoolNoArr[i].equals(poolNo)) {
	             		  poolList.remove(j);
	             		  continue;
	             	  }
	               }
	      	    }
        	}
        }        
        request.setAttribute("poolList", poolList);
        
        // get LD count that can been created on the specified diskarray
        String availLdCount = VolumeHandler.getLdNum4Create(aid);
        request.setAttribute("availLdCount", availLdCount);
       }catch(NSException e){
           if (DiskCommon.isSSeries(request)){
               VolumeListAction.setISAdiskListErrorCode(e, "83", request);
           }
           throw e;
       }
        String poolpdtype="";
        if (poolnameno!=null && !poolnameno.equals("")){
            poolpdtype = VolumeHandler.getpoolpdtype(aid,poolnameno);
        }
        request.setAttribute("poolpdtype",poolpdtype);//old pd type 
        return mapping.findForward("showPoolInfo");
    }
}