/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrTRadioRender.java,v 1.1 2004/08/24 09:50:22 wangw Exp $
 */
package com.nec.sydney.beans.ddr;
import com.nec.nsgui.taglib.nssorttab.*;
public class DdrTRadioRender extends STAbstractRender {

    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        
        return "<td><input type=\"radio\" name=\"" + colName + "\" "
               + getRadioId(rowIndex, colName) + " "
               + getRadioValue(rowIndex, colName) + " "
               + getRadioChecked(rowIndex, colName) + " /></td>";
    }
    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioId (int rowIndex, String colName){
                
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
    private String getRadioChecked  (int rowIndex, String colName){
                
        return (rowIndex==0)?"checked":"";
    }

    /**
     * Get the Radio cell's HTML code like "value=...." which specified by (rowIndex, colName)
     *  
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioValue (int rowIndex, String colName) throws Exception{
        
        String rtnValue = "value=\"";        
        SortTableModel tableModel = getTableModel();
        SortTagInfo tagInfo = getSortTagInfo();

        String mvvolumeColumn = tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 1);
        String rvvolumeColumn = tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 4);
        
        if (mvvolumeColumn == null || rvvolumeColumn==null){
            tagInfo.setShareObj(null);
        }else{
            Object cellVal1 = tableModel.getValueAt(rowIndex, mvvolumeColumn);
            Object cellVal2 = tableModel.getValueAt(rowIndex, rvvolumeColumn);
            if (cellVal1 != null && cellVal2 != null){
                rtnValue = rtnValue + String2HTML(cellVal1.toString()) 
                                + ":" + String2HTML(cellVal2.toString());
            }
            tagInfo.setShareObj(colName);
        }
        
        return rtnValue + "\"";
    }
}