/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: GfsTData4VolumeListRender.java,v 1.4 2005/12/01 01:58:12 zhangjun Exp $
 */

package com.nec.nsgui.action.gfs;

import java.util.AbstractList;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.gfs.GfsLDInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;

public class GfsTData4VolumeListRender extends STAbstractRender {
    private static final String cvsid =
        "@(#) $Id: GfsTData4VolumeListRender.java,v 1.4 2005/12/01 01:58:12 zhangjun Exp $";
    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
            if ((colName.equals("deviceLun")) || (colName.equals("deviceWwnn")) || (colName.equals("deviceSize")) || (colName.equals("serialNo")) ) {
                return getCellContent(rowIndex, colName);
            }
            if (colName.equals("gfsType")) {
                return "<td nowrap align=center>" + getCellContent(rowIndex, colName) + "</td>";
            }
            return "<td nowrap>&nbsp;</td>";
    }
    private String getCellContent(int rowIndex, String colName)
        throws Exception {
        AbstractList deviceList = ((ListSTModel) getTableModel()).getDataList();
        GfsLDInfoBean deviceInfoObj = (GfsLDInfoBean) deviceList.get(rowIndex);
           
        if (colName.equals("deviceLun")) {
            if(deviceInfoObj.getDeviceLun().equals("--")){
                return "<td nowrap align=center>" +  deviceInfoObj.getDeviceLun() + "</td>";
            }else{
                return "<td nowrap align=right>" + NSActionUtil.getHexString(4, deviceInfoObj.getDeviceLun()) + "</td>";
            }
        }

        if (colName.equals("deviceWwnn")) {
            if(deviceInfoObj.getDeviceWwnn().equals("--")){
                return "<td nowrap align=center>" + deviceInfoObj.getDeviceWwnn() + "</td>";
            }else{
                return "<td nowrap>" + deviceInfoObj.getDeviceWwnn() + "</td>";
            }
        }

        if (colName.equals("deviceSize")) {
            if(deviceInfoObj.getDeviceSize().equals("--")){
                return "<td nowrap align=center>" + deviceInfoObj.getDeviceSize() + "</td>";
            }else{
                return "<td nowrap align=right>" + getCapacity4Show(deviceInfoObj.getDeviceSize()) + "</td>";
            }
        }

        if (colName.equals("gfsType")) {
            return (((String)deviceInfoObj.getGfsType()).equals("auto")) ? "<img src='"+NSActionConst.PATH_OF_CHECKED_GIF+"'/>" : "&nbsp;";
            
        }
        //add by zhangjun
        if (colName.equals("serialNo")) {
            if(deviceInfoObj.getSerialNo().equals("--")){
                return "<td nowrap align=center>" + deviceInfoObj.getSerialNo() + "</td>";
            }else{
                return "<td nowrap>" + deviceInfoObj.getSerialNo() + "</td>";
            }
        }
        return "&nbsp;";
    }
    
    private String getCapacity4Show(String capacity) throws Exception {
        try{
            Double d = new Double(capacity); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        } catch(NumberFormatException e) {
            return capacity;  
        }      
    }
    
}