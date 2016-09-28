/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NfsTRadioRender.java,v 1.1 2004/08/16 02:40:38 het Exp $
 */
package com.nec.nsgui.action.nfs;
import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.model.entity.nfs.EntryInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;
public class NfsTRadioRender extends STAbstractRender {
    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        EntryInfoBean exInfoObj = (EntryInfoBean) exInfoList.get(rowIndex);
        return "<td rowspan=\""
            + Integer.toString(exInfoObj.getClientNum())
            + "\"><input type=\"radio\" name=\""
            + colName
            + "\" "
            + getRadioId(rowIndex, colName)
            + " "
            + getRadioValue(rowIndex, colName, exInfoObj)
            + " "
            + getRadioChecked(rowIndex, colName, exInfoObj)
            + " onclick=\"onSelect('"
            + exInfoObj.getDirectory()
            + "','"
            + exInfoObj.getIsNormal()
            + "');\" /> </td> ";
    }
    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioId(int rowIndex, String colName) {
        SortTagInfo tagInfo = getSortTagInfo();
        return "id=\"" + colName + tagInfo.getId() + rowIndex + "\"";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return ""
     */
    private String getRadioChecked(
        int rowIndex,
        String colName,
        EntryInfoBean exInfoObj)
        throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        String selectedDir =
            (String) context.getRequest().getParameter("selectedDir");
        if (rowIndex == 0) {
            if (selectedDir != null) {
                AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
                boolean found = false;
                for (int i = 0; i < exInfoList.size(); i++) {
                    EntryInfoBean exObj = (EntryInfoBean) exInfoList.get(i);
                    if (exObj.getDirectory().equals(selectedDir)) {
                        found = true;
                        break;
                    }
                }
                if(!found){
                    return "checked";
                }
            } else {
                return "checked";
            }
        }
        if (selectedDir != null) {
            return (exInfoObj.getDirectory().equals(selectedDir))? "checked":"";
        } else {
            return "";
        }
    }

    /**
     * Get the Radio cell's HTML code like "value=...." which specified by (rowIndex, colName)
     *  
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioValue(
        int rowIndex,
        String colName,
        EntryInfoBean exInfoObj)
        throws Exception {

        String rtnValue = "value=\"";
        SortTableModel tableModel = getTableModel();
        SortTagInfo tagInfo = getSortTagInfo();

        String dirPath =
            tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 1);

        if (dirPath == null) {
            tagInfo.setShareObj(null);
        } else {
            Object cellVal1 = tableModel.getValueAt(rowIndex, dirPath);
            if (cellVal1 != null) {
                rtnValue =
                    rtnValue
                        + String2HTML(cellVal1.toString())
                        + "#"
                        + exInfoObj.getIsNormal();
            }
            tagInfo.setShareObj(colName);
        }
        return rtnValue + "\"";
    }
}