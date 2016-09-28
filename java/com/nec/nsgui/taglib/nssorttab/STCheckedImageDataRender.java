/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STCheckedImageDataRender.java,v 1.2 2007/02/12 03:41:40 wanghb Exp $
 */
package com.nec.nsgui.taglib.nssorttab;
import com.nec.nsgui.action.base.NSActionConst;
public class STCheckedImageDataRender extends STDataRender implements NSActionConst{

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

        String htmlCode = "<td align=\"center\">";
        
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
        String dataStr = "";
        
        if (tableModel != null){
            Object value = tableModel.getValueAt(rowIndex, colName);

            if (value != null){
                String tmpValue = value.toString();
                if(tmpValue.equalsIgnoreCase("true")
                    || tmpValue.equalsIgnoreCase("yes")
                    || tmpValue.equalsIgnoreCase("checked")
                    || tmpValue.equalsIgnoreCase("on")){
                    dataStr = "<img border=\"0\" src=\""+ PATH_OF_CHECKED_GIF +"\" />";
                }else{
                    dataStr = "&nbsp;";
                }
            }
        }
        
        return dataStr;
    }

}