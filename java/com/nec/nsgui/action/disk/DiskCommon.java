/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.disk;

import java.util.Vector;
import java.math.BigDecimal;
import org.apache.struts.util.LabelValueBean;
import javax.servlet.http.HttpServletRequest;
import com.nec.nsgui.model.entity.disk.DiskConstant;
import com.nec.nsgui.model.biz.disk.DiskHandler;
import com.nec.nsgui.action.base.NSActionUtil;
public class DiskCommon{
    public static final String cvsid = "@(#) $Id: DiskCommon.java,v 1.5 2007/09/07 08:22:43 liq Exp $";
    
    public static Vector getVectorforPDList(String pdinfo)throws Exception {
        Vector pdV = new Vector();
        if (pdinfo.trim().equals("") || pdinfo.equals(null)){
            return pdV;
        }
        String[] pdone = pdinfo.trim().split("#");
        for(int i=0;i<pdone.length;i++){
            //create value : xxh-yyh,cccc
            String pdvalue = pdone[i]; 
            //create label : xxh-yyh(nn.nGB)
            String[] pd = (pdone[i]).split(",");
	        double capacityGB = new Double(pd[1]).doubleValue();
	        capacityGB = capacityGB/1024/1024/1024-0.05;
            BigDecimal capcityBD = new BigDecimal(Double.toString(capacityGB));
            String pdcapacityGB = Double.toString(capcityBD.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue());
            String pdlabel = pd[0]+"("+pdcapacityGB+"GB, "+pd[2]+")";
            pdV.add(new LabelValueBean(pdlabel,pdvalue));
        }
        return pdV;
    }
    
    public static String getSmallestPdCapacity(String pdinfo)throws Exception{
        if (pdinfo.trim().equals("") || pdinfo.equals(null)){
            return "0";
        }
        String[] pdone = pdinfo.trim().split("#");
        Long small =new Long(((pdone[0]).split(","))[1]);
        for(int i=1;i<pdone.length;i++){
            Long pdc = new Long(((pdone[i]).split(","))[1]); 
            if (pdc.compareTo(small)<0){
                small =pdc;
            }
        }
        String smallc = small.toString();
        return smallc;
    }
    public static boolean isSSeries(HttpServletRequest request){
        // If machine type is Nashead, the diskarray type is meaningless. 
        boolean isNashead = NSActionUtil.isNashead(request);
        if(isNashead){
            return false;
        }
        String diskarraytpye = (String) request.getSession().getAttribute(DiskConstant.SESSION_DISKARRAY_TYPE);
        if(diskarraytpye==null||diskarraytpye.equals("")||diskarraytpye.equals("--")){
            return false;
        }
        if (diskarraytpye.equalsIgnoreCase(DiskConstant.SESSION_DISKARRAY_TYPE_S1500)||
            diskarraytpye.equalsIgnoreCase(DiskConstant.SESSION_DISKARRAY_TYPE_S1400)){
            return true;
        }else{
            return false;
        }
    }
    public static boolean isCondorLiteSeries(HttpServletRequest request){
        // If machine type is Nashead, the diskarray type is meaningless. 
        boolean isNashead = NSActionUtil.isNashead(request);
        if(isNashead){
            return false;
        }
        String diskarraytpye = (String) request.getSession().getAttribute(DiskConstant.SESSION_DISKARRAY_TYPE);
        if(diskarraytpye==null||diskarraytpye.equals("")||diskarraytpye.equals("--")){
            return false;
        }
        if (diskarraytpye.equalsIgnoreCase(DiskConstant.SESSION_DISKARRAY_TYPE_D1)||
            diskarraytpye.equalsIgnoreCase(DiskConstant.SESSION_DISKARRAY_TYPE_D3)){
            return true;
        }else{
            return false;
        }
    }
    public static void setDiskArrayTypeToSession(HttpServletRequest request) throws Exception{
        String diskarraytype=DiskHandler.getDiskArrayType();
        request.getSession().setAttribute(DiskConstant.SESSION_DISKARRAY_TYPE,diskarraytype);
    }
    
}
