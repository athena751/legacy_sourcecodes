/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;
//import javax.servlet.http.HttpServletRequest;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.filesystem.FreeLdInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4Filesystem extends STAbstractRender {
    private static final String cvsid = "@(#) $Id: STDataRender4Filesystem.java,v 1.2 2005/10/24 05:20:30 jiangfx Exp $";

    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        
        if ((colName.equals("lun")) || (colName.equals("ldSize")) || (colName.equals("ldNo"))) {
            return "<td nowrap align=right>" + getCellContent(rowIndex, colName) + "</td>";
        }
        return "<td nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)
        throws Exception {

        PageContext context = getSortTagInfo().getPageContext();
        AbstractList freeLdList = ((ListSTModel) getTableModel()).getDataList();
        FreeLdInfoBean freeLdObj = (FreeLdInfoBean) freeLdList.get(rowIndex);

        if (colName.equals("checkbox")) {
            StringBuffer cellStr =
                new StringBuffer(
                    "<input name=\"ldCheckbox\" type=\"checkbox\" "
                        + "onclick=\"changeButton();\" value=\"");

            cellStr.append(freeLdObj.getLdPath()).append("#");
            cellStr.append(freeLdObj.getLdSize()).append("#");

            cellStr.append("\" ");
            
            cellStr.append(" id=\"ldCheckbox" + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }

        if (colName.equals("lun")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"ldCheckbox" + rowIndex);
            cellStr.append("\">");
            cellStr.append(NSActionUtil.getHexString(4, freeLdObj.getLun()));
            cellStr.append("</label>");
            return cellStr.toString();
        }
        if (colName.equals("ldNo")) {
            StringBuffer cellStr =
            new StringBuffer("<label for=\"ldCheckbox" + rowIndex);
            cellStr.append("\">");
            cellStr.append(NSActionUtil.getHexString(4, freeLdObj.getLdNo()));
            cellStr.append("</label>");
            return cellStr.toString();
        }

        if (colName.equals("ldSize")) {
            Double d = new Double(freeLdObj.getLdSize()); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        }

        return " ";
    }
}
