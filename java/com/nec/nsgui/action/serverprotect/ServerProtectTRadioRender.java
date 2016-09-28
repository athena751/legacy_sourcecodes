/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: ServerProtectTRadioRender.java,v 1.1 2007/03/23 09:47:17 wanghui Exp $
 */
package com.nec.nsgui.action.serverprotect;
import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.model.entity.serverprotect.ServerProtectScanTargetBean;
import com.nec.nsgui.taglib.nssorttab.*;
public class ServerProtectTRadioRender extends STAbstractRender {
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
        ServerProtectScanTargetBean exInfoObj = (ServerProtectScanTargetBean) exInfoList.get(rowIndex);
        
        SortTagInfo tagInfo = getSortTagInfo();

        String nextColName = tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 1);
        
        if (nextColName == null){
            tagInfo.setShareObj(null);
        }else{
            tagInfo.setShareObj(colName);
        }
        
        return "<td><input type=\"radio\" name=\""
            + colName
            + "\" "
            + getRadioId(rowIndex, colName)
            + " "
            + getRadioChecked(rowIndex, colName, exInfoObj)
            + " onclick=\"onSelect('"
            + exInfoObj.getShareName()
            + "','"
            + exInfoObj.getReadCheck()
            + "','"
            + exInfoObj.getWriteCheck()
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
        ServerProtectScanTargetBean exInfoObj)
        throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        String selectedShareName =
            (String) context.getRequest().getParameter("selectedShareName");
        if (rowIndex == 0) {
            if (selectedShareName != null) {
                AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
                boolean found = false;
                for (int i = 0; i < exInfoList.size(); i++) {
                    ServerProtectScanTargetBean exObj = (ServerProtectScanTargetBean) exInfoList.get(i);
                    if (exObj.getShareName().equals(selectedShareName)) {
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
        if (selectedShareName != null) {
            return (exInfoObj.getShareName().equals(selectedShareName))? "checked":"";
        } else {
            return "";
        }
    }

}