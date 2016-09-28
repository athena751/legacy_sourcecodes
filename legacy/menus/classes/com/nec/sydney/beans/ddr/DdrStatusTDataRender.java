/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrStatusTDataRender.java,v 1.2 2005/08/29 09:14:53 wangw Exp $
 */
package com.nec.sydney.beans.ddr;
import com.nec.sydney.framework.*;
import com.nec.nsgui.taglib.nssorttab.*;
import javax.servlet.http.HttpSession;
public class DdrStatusTDataRender extends STAbstractRender {

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

        String htmlCode = "<td nowrap>";
        
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
    private String getCellData(int rowIndex, String colName) throws Exception{
        
        SortTableModel tableModel = getTableModel();
        String dataStr = "";
        SortTagInfo tagInfo = getSortTagInfo();
        HttpSession session = tagInfo.getPageContext().getSession();
        if (tableModel != null){
            Object ddrStatusValue = tableModel.getValueAt(rowIndex, "ddrStatus");
            Object syncModeValue = tableModel.getValueAt(rowIndex, "replicateStatus");
            if (ddrStatusValue != null){
                dataStr = (syncModeValue!=null)
                                ?NSMessageDriver.getInstance().getMessage(session,
                                            "nas_ddrschedule/pairinglist/td_"+ddrStatusValue.toString())
                                    +"("
                                    +NSMessageDriver.getInstance().getMessage(session,
                                            "nas_ddrschedule/pairinglist/td_"+syncModeValue.toString())
                                    +")"
                                :NSMessageDriver.getInstance().getMessage(session,
                                            "nas_ddrschedule/pairinglist/td_"+ddrStatusValue.toString())
                          ;
            }
        }
        
        return STAbstractRender.String2HTML(dataStr);
    }
    /**
     * Get the HTML code like <label....> which specified by (rowIndex, colName)
     * @param rowIndex
     * @param colName
     * @return HTML code or null
     */
    private String getLabel(int rowIndex, String colName) {
                
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