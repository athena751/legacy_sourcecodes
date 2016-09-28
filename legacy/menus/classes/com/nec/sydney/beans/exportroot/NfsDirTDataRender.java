/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NfsDirTDataRender.java,v 1.1 2004/09/01 07:34:06 xiaocx Exp $
 */
package com.nec.sydney.beans.exportroot;
import java.util.AbstractList;
import com.nec.sydney.atom.admin.exportroot.EntryInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;
public class NfsDirTDataRender extends STDataRender {

    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        EntryInfoBean exInfoObj = (EntryInfoBean) exInfoList.get(rowIndex);
        String cellData = getCellData(rowIndex, colName);
        String label = getLabel(rowIndex, colName);

        String htmlCode = "<td rowspan=\"" + Integer.toString(exInfoObj.getClientNum()) + "\">";
        
        if (label != null){
            htmlCode = htmlCode + label + cellData + "</label>"; 
        }else{
            htmlCode = htmlCode + cellData;
        }
           
        htmlCode = htmlCode + "</td>" ;
        
        return htmlCode;
    }
}