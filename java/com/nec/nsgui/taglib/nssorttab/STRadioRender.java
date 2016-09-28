/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STRadioRender.java,v 1.2 2004/08/23 09:03:38 baiwq Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

public class STRadioRender extends STAbstractRender {

    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        
        return "<td><input type=\"radio\" " 
               + getRadioName(rowIndex, colName) + " "
               + getRadioId(rowIndex, colName) + " "
               + getRadioValue(rowIndex, colName) + " "
               + getRadioClick(rowIndex, colName) + " "
               + getRadioChecked(rowIndex, colName) + "/></td>";
    }
    

    /**
     * Get the Radio cell's HTML code like "name=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getRadioName (int rowIndex, String colName){
        
        SortTagInfo tagInfo = getSortTagInfo();

        return "name=\"" + colName + tagInfo.getId() + "\"";
    }

    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getRadioId (int rowIndex, String colName){
                
        SortTagInfo tagInfo = getSortTagInfo();

        return "id=\"" + colName + tagInfo.getId() + rowIndex + "\"";
        
    }

    /**
     * Get the Radio cell's HTML code like "onclick=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getRadioClick (int rowIndex, String colName){
                
        SortTagInfo tagInfo = getSortTagInfo();

        return "onclick=\"onClickRadio_" + colName + tagInfo.getId() + "(this)\"";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return ""
     */
    public String getRadioChecked  (int rowIndex, String colName)throws Exception{
                
        return "";
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

        String nextColName = tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 1);
        
        if (nextColName == null){
            tagInfo.setShareObj(null);
        }else{
            Object cellVal = tableModel.getValueAt(rowIndex, nextColName);
            if (cellVal != null){
                rtnValue = rtnValue + String2HTML(cellVal.toString());
            }
            tagInfo.setShareObj(colName);
        }
        
        return rtnValue + "\"";
    }
}