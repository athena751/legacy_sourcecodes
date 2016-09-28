/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STCommonRadioRender.java,v 1.3 2004/12/09 05:02:53 baiwq Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;

public class STCommonRadioRender extends STRadioRender {

    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        
        return "<td align=\"center\"><input type=\"radio\" " 
               + getRadioName(rowIndex, colName) + " "
               + getRadioId(rowIndex, colName) + " "
               + getRadioValue(rowIndex, colName) + " "
               + getRadioClick(rowIndex, colName) + " "
               + getRadioChecked(rowIndex, colName) + " /></td>";
    }

    /**
     * Get the Radio cell's HTML code like "name=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getRadioName (int rowIndex, String colName){
        return "name=\"" + colName + "\"";
    }

    /**
     * Get the Radio cell's HTML code like ""
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getRadioClick (int rowIndex, String colName){

        return "";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return "" | "checked"
     */
    public String getRadioChecked(int rowIndex, String colName)
        throws Exception {
        SortTagInfo tagInfo = getSortTagInfo();
        SortTableModel tableModel = getTableModel();
        PageContext context = getSortTagInfo().getPageContext();
        
        String selectedValue = 
            (String) context.getSession().getAttribute(tagInfo.getId() + "_" + colName);
        if(selectedValue == null){
            selectedValue = (String) context.getRequest().getParameter(colName);
            if(selectedValue != null){
                selectedValue = NSActionUtil.reqStr2EncodeStr(selectedValue,NSActionConst.BROWSER_ENCODE);
            }
        }
        
        AbstractList dataList = ((ListSTModel) tableModel).getDataList();
        if (rowIndex == 0) {
            if (selectedValue != null) {
                boolean found = false;
                for (int i = 1; i < dataList.size(); i++) {
                    Object cellVal = tableModel.getValueAt(i, colName);
                    if (cellVal != null){
                        if(cellVal.equals(selectedValue)){
                            found = true;
                            break;
                        }
                    }
                }
                if(found){
                    return "";
                }
            }
            return "checked";
        }else{
            //rowIndex > 0
            if (selectedValue != null) {
                Object cellVal = tableModel.getValueAt(rowIndex, colName);
                if (cellVal != null){
                    if(cellVal.equals(selectedValue)){
                        return "checked";
                    }
                }
            }
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
    public String getRadioValue (int rowIndex, String colName) throws Exception{
        
        String rtnValue = "value=\"";        
        SortTableModel tableModel = getTableModel();
        SortTagInfo tagInfo = getSortTagInfo();

        Object cellVal = tableModel.getValueAt(rowIndex, colName);
        if (cellVal != null){
            rtnValue = rtnValue + NSActionUtil.sanitize(cellVal.toString(), false);
        }
        tagInfo.setShareObj(colName);
        
        return rtnValue + "\"";
    }
}