/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NfsClientTHeaderRender.java,v 1.1 2004/08/16 02:40:38 het Exp $
 */
package com.nec.nsgui.action.nfs;
import com.nec.nsgui.taglib.nssorttab.*;
public class NfsClientTHeaderRender extends STAbstractRender {
    
    /**
    * Get the HTML code of the table Header which specified by (rowIndex, colName)
    * 
    * @param rowIndex  
    * @param colName
    * @return HTML code
    * @throws Exception
    */
    public String getCellRender(int rowIndex, String colName){
        
        SortTagInfo tagInfo = getSortTagInfo();
        String thMsg = tagInfo.getHeaderMsg(colName);
        
        if (thMsg == null || (thMsg.trim()).equals("")){
            return "<th>&nbsp;</th>";
        }
        
        String[] twoHeader = thMsg.split(",");
        //thMsg = String2HTML(thMsg);
        //if(true)return thMsg;
        //display a button
        return "<th>" + String2HTML(twoHeader[0]) + "</th>" 
                +"<th>" + String2HTML(twoHeader[1]) + "</th>" ;
     }
}