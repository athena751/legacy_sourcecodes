/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrDiskarrayTDataRender.java,v 1.1 2004/09/09 07:06:12 wangw Exp $
 */

package com.nec.sydney.beans.ddr;
import com.nec.nsgui.taglib.nssorttab.*;
public class DdrDiskarrayTDataRender extends STAbstractRender {

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
        if(cellData.equals("--")){
            htmlCode = "<td align=\"center\">";
        }
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