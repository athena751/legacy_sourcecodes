/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnapStatusTDataRender.java,v 1.3 2005/10/20 02:26:17 wangw Exp $
 */

package com.nec.sydney.beans.snapshot;
import javax.servlet.http.HttpSession;

import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.sydney.framework.NSMessageDriver;

public class SnapStatusTDataRender extends STAbstractRender {
    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{

                
        String cellData = getCellData(rowIndex, colName);
        String label = getLabel(rowIndex, colName);

        String htmlCode = "<td>";
        
        if (label != null){
            htmlCode = htmlCode + label + cellData + "</label>"; 
        }else{
            htmlCode = htmlCode + cellData;
        }
           
        htmlCode = htmlCode + "</td>" ;
        
        return htmlCode;
    }
    

    /**
     * Get the HTML code between <td> and </td> which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellData(int rowIndex, String colName) throws Exception{
        
        SortTableModel tableModel = getTableModel();
        String dataStr = " ";
        
        if (tableModel != null){
            Object value = tableModel.getValueAt(rowIndex, colName);

            if (value != null){
                dataStr = value.toString();
            }
        }
        if (dataStr == null || (dataStr != null && dataStr.equals(""))){
            dataStr = " ";
        }
        SortTagInfo tagInfo = getSortTagInfo();
        HttpSession session = tagInfo.getPageContext().getSession();
        if (dataStr.equalsIgnoreCase("active")){
            dataStr = NSMessageDriver.getInstance().getMessage(session, 
                            "nas_snapshot/snapshow/status_active");
        }else if (dataStr.equalsIgnoreCase("removing")){
            dataStr = NSMessageDriver.getInstance().getMessage(session, 
                            "nas_snapshot/snapshow/status_removing");
        }else if (dataStr.equalsIgnoreCase("hold")){
            dataStr = NSMessageDriver.getInstance().getMessage(session, 
                            "nas_snapshot/snapshow/status_hold");
        }
        return STAbstractRender.String2HTML(dataStr);
    }


    /**
     * Get the HTML code like <label....> which specified by (rowIndex, colName)
     * @param rowIndex
     * @param colName
     * @return HTML code or null
     */
    public String getLabel(int rowIndex, String colName) {
                
        SortTableModel tableModel = getTableModel();
        SortTagInfo tagInfo = getSortTagInfo();
        
        //prevColName is settted by getRadioValue() of STRadioRender 
        //or by getChkValue() of STChkBoxRender
        String prevColName = (String)tagInfo.getShareObj();
        if (prevColName == null){
            return null;
        }
        
        if (colName.equals(tagInfo.getColumnName(tagInfo.getColumnIndex(prevColName) + 1 ))){
            return "<label for=\"" + prevColName + tagInfo.getId() + rowIndex + "\">"; 
        }
        
        return null;
    }
}