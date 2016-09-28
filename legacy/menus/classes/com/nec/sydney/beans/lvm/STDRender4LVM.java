/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.lvm;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.volume.LVMInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDRender4LVM extends STAbstractRender{
    public static final String cvsid =
        "@(#) $Id: STDRender4LVM.java,v 1.3 2007/06/11 03:38:38 xingyh Exp $";
    
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        if(colName.equals("striping")){
            return "<td valign=\"top\" nowrap align=\"center\">" + getCellContent(rowIndex, colName) + "</td>";
        }
        if(colName.equals("size")){
            return "<td nowrap valign=\"top\" align=right>" + getCellContent(rowIndex, colName) + "</td>";
        }
        if(colName.equals("lunStorage") || colName.equals("ld") || colName.equals("lunLd")){
            return "<td nowrap align=left>" + getCellContent(rowIndex, colName) + "</td>";
        }
        if (colName.equals("mountPoint") || colName.equals("deviceNo")) {
            return getCellContent(rowIndex, colName);
        }
        // radio, lvName
        return "<td valign=\"top\" nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)
        throws Exception {
            
        PageContext context = getSortTagInfo().getPageContext();
        AbstractList lvmList = ((ListSTModel) getTableModel()).getDataList();
        LVMInfoBean lvmObj = (LVMInfoBean) lvmList.get(rowIndex);
        String id = (String)(context.getSession().getAttribute("LVM_RADIO_ID"));
        
        if (colName.equals("radio")) {
            
            
            String onclickStr = "onclick=\"enablebutton(this);\"";
            String nameStr = "name=\"radioButton\" ";
            if(id.equals("otherRadioID")){
                onclickStr = "onclick=\"enableManage(this.value);\"";
                nameStr = "name=\"otherRadio\" ";
            }
            StringBuffer cellStr =
                new StringBuffer(
                    "<input type=\"radio\" "+  nameStr
                        + onclickStr +"value=\"");
            cellStr.append(lvmObj.getLvName()).append(",");
            cellStr.append(lvmObj.getMountPoint()).append(",");
            cellStr.append(lvmObj.getSize()).append(",");
            cellStr.append(lvmObj.getLunStorage()).append(",");
            cellStr.append(lvmObj.getLdList().replaceAll(",","<BR>")).append(",");
            cellStr.append(lvmObj.getAccessMode());
            cellStr.append("\"");
            
            cellStr.append(" id=\"" + id + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }

        if (colName.equals("lvName")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\""+ id + rowIndex);
            cellStr.append("\">");
            cellStr.append(lvmObj.getLvName());
            cellStr.append("</label>");
            return cellStr.toString();
        }
        
        if (colName.equals("size")) {
            try{
                Double d = new Double(lvmObj.getSize()); 
                           return (new java.text.DecimalFormat("#,##0.0")).format(d);
            }catch(NumberFormatException e){
                return lvmObj.getSize();
            }
        }
        
        if (colName.equals("mountPoint")) {
            String mp = lvmObj.getMountPoint();
            return "<td valign=\"top\" nowrap >" + mp + "</td>";
        }

        if (colName.equals("deviceNo")) {
            return "<td align=\"center\" valign=\"top\" nowrap>" + lvmObj.getDeviceNo() + "</td>";
        }

        if (colName.equals("ldList")) {
            if(lvmObj.getLdList().equals("--")){
                return lvmObj.getLdList();
            }
            String[] tmpArray = lvmObj.getLdList().split(",");
            String ld = tmpArray[0];
            String ldNo = ld.replaceFirst("/dev/ld", "");
            String ldNoHex = NSActionUtil.getHexString(4, ldNo);
            
            StringBuffer ldList = new StringBuffer();
            ldList.append("#").append(ldNoHex).append("("+ld+")");
            for(int i = 1; i<tmpArray.length; i++){
                ld = tmpArray[i];
                ldNo = ld.replaceFirst("/dev/ld", "");
                ldNoHex = NSActionUtil.getHexString(4, ldNo);
                ldList.append("<BR>").append("#").append(ldNoHex).append("("+ld+")");
            }
            
            return ldList.toString();
        }

        if (colName.equals("lunStorage")) {
            return lvmObj.getLunStorage();
        }
        if (colName.equals("lunLd")) {
            return lvmObj.getLunLd().replaceAll(",", "<BR>");
        }
        
        String on = "<img src=\"" + NSActionConst.PATH_OF_CHECKED_GIF + "\">";
        String off = "&nbsp;";

        if (colName.equals("striping")) {
            if (lvmObj.getStriping() != null
                && lvmObj.getStriping().equals("true")) {
                return on;
            }
            return off;
        }

        return " ";
    }
}
