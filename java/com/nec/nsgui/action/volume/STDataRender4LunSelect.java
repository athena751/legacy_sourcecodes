/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.volume.LunInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4LunSelect extends STAbstractRender {
    private static final String cvsid = "@(#) $Id: STDataRender4LunSelect.java,v 1.2 2005/10/24 05:45:27 liuyq Exp $";

    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        
        if ((colName.equals("lun")) || (colName.equals("size"))) {
            return "<td nowrap align=right>" + getCellContent(rowIndex, colName) + "</td>";
        }
        return "<td nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)
        throws Exception {

        PageContext context = getSortTagInfo().getPageContext();
        AbstractList lunInfoVector = ((ListSTModel) getTableModel()).getDataList();
        LunInfoBean lunInfoObj = (LunInfoBean) lunInfoVector.get(rowIndex);

        if (colName.equals("checkbox")) {
            StringBuffer cellStr =
                new StringBuffer(
                    "<input name=\"lunCheckbox\" type=\"checkbox\" "
                        + "onclick=\"changeButtonStatus();\" value=\"");

            cellStr.append(lunInfoObj.getWwnn()).append("#");
            cellStr.append(lunInfoObj.getLun()).append("#");
            cellStr.append(lunInfoObj.getSize()).append("#");
            cellStr.append(lunInfoObj.getLdPath()).append("#");
            cellStr.append(lunInfoObj.getStorage()).append("#");
            
            cellStr.append("\" ");
            
            cellStr.append(" id=\"lunCheckbox" + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }

        if (colName.equals("lun")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"lunCheckbox" + rowIndex);
            cellStr.append("\">");
            cellStr.append(NSActionUtil.getHexString(4, lunInfoObj.getLun()));  
            cellStr.append("</label>");
            return cellStr.toString();
        }

        if (colName.equals("storage")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"lunCheckbox" + rowIndex);
            cellStr.append("\">");
            cellStr.append(lunInfoObj.getStorage());
            cellStr.append("</label>");
            return cellStr.toString();
        }

        if (colName.equals("size")) {
            Double d = new Double(lunInfoObj.getSize()); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        }
        //liq add for ld select
        if (colName.equals("ldcheckbox")) {
            StringBuffer cellStr =
            new StringBuffer(
                "<input name=\"lunCheckbox\" type=\"checkbox\" "
                + "onclick=\"changeButtonStatus();\" value=\"");
                cellStr.append(lunInfoObj.getLdPath());
                cellStr.append("#");
                cellStr.append(lunInfoObj.getSize());
                cellStr.append("\" ");
                cellStr.append(" id=\"lunCheckbox" + rowIndex);
                cellStr.append("\">");
                return cellStr.toString();
        }
                
        if (colName.equals("ldPath")) {
            StringBuffer cellStr =
            new StringBuffer("<label for=\"lunCheckbox" + rowIndex);
            new StringBuffer("");
            cellStr.append("\">");
            cellStr.append(lunInfoObj.getLdPath());  
            cellStr.append("</label>");
            return cellStr.toString();
        }
        // end of liq
        return " ";
    }
}