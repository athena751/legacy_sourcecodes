/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.text.DecimalFormat;
import java.util.AbstractList;
import javax.servlet.jsp.PageContext;

import com.nec.nsgui.model.entity.volume.PoolInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4Pool extends STAbstractRender {
    private static final String cvsid = "@(#) $Id: STDataRender4Pool.java,v 1.2 2007/06/12 14:43:59 liq Exp $";

    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        
        if ((colName.equals("totalCap")) 
            || (colName.equals("usedCap"))
            || (colName.equals("maxFreeCap"))) {
            return "<td nowrap align=right>" + getCellContent(rowIndex, colName) + "</td>";
        }
        return "<td nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)
        throws Exception {

        PageContext context = getSortTagInfo().getPageContext();
        AbstractList poolInfoVector = ((ListSTModel)getTableModel()).getDataList();
        PoolInfoBean poolInfoObj = (PoolInfoBean)poolInfoVector.get(rowIndex);

        if (colName.equals("checkbox")) {
            StringBuffer cellStr =
                new StringBuffer(
                    "<input name=\"poolCheckbox\" type=\"checkbox\" "
                        + "onclick=\"changeButtonStatus();\" value=\"");

            cellStr.append(poolInfoObj.getPoolName()).append("#");
            cellStr.append(poolInfoObj.getPoolNo()).append("#");
            cellStr.append(poolInfoObj.getMaxFreeCap()).append("#");
            cellStr.append(poolInfoObj.getPdtype()).append("#");
            cellStr.append("\" ");
            cellStr.append(" id=\"poolCheckbox" + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }

        if (colName.equals("poolName")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"poolCheckbox" + rowIndex);
            cellStr.append("\">");
            cellStr.append(poolInfoObj.getPoolName());
            cellStr.append("</label>");
            return cellStr.toString();
        }


        if (colName.equals("totalCap")) {
            return formatStr(poolInfoObj.getTotalCap());
        }
        
        if (colName.equals("usedCap")) {
            return formatStr(poolInfoObj.getUsedCap());
        }
        
        if (colName.equals("maxFreeCap")) {
            return formatStr(poolInfoObj.getMaxFreeCap());
        }

        return " ";
    }
    
    private String formatStr(String str) {
        try {
            Double d = new Double(str);
            return (new DecimalFormat("#,##0.0")).format(d);
        } catch (NumberFormatException e) {
            return str;
        }
        
    }
}