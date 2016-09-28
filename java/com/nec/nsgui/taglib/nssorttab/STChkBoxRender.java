/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STChkBoxRender.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

public class STChkBoxRender extends STAbstractRender {

    private SortTagInfo tagInfo;
        
    /**
     * Get the ChkBox cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        
        return "<td><input type=\"checkbox\" " 
               + getChkName(rowIndex, colName) + " "
               + getChkId(rowIndex, colName) + " "
               + getChkValue(rowIndex, colName) + " "
               + getChkClick(rowIndex, colName) + " "
               + getChkChecked(rowIndex, colName) + "/></td>";
    }
    

    /**
     * Get the ChkBox cell's HTML code like "name=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getChkName (int rowIndex, String colName){
        
        tagInfo = getSortTagInfo();                
        return "name=\"" + colName + tagInfo.getId() + "\"";
        
    }

    /**
     * Get the ChkBox cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getChkId (int rowIndex, String colName){
                
        tagInfo = getSortTagInfo();
        return "id=\"" + colName + tagInfo.getId() + rowIndex + "\"";
        
    }

    /**
     * Get the ChkBox cell's HTML code like "onclick=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getChkClick (int rowIndex, String colName){
                
        tagInfo = getSortTagInfo();
        return "onclick=\"onClickChk_" + colName + tagInfo.getId() + "(this)\"";
    }

    /**
     * Get the ChkBox cell's HTML code like "checked" which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return ""
     */
    public String getChkChecked  (int rowIndex, String colName){
                
        return "";
    }

    /**
     * Get the ChkBox cell's HTML code like "value=...." which specified by (rowIndex, colName)
     *  
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    public String getChkValue (int rowIndex, String colName) throws Exception{
        
        String rtnValue = "value=\"";        
        SortTableModel tableModel = getTableModel();
        tagInfo = getSortTagInfo();

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