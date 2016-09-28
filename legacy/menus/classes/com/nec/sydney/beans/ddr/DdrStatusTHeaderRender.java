/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrStatusTHeaderRender.java,v 1.2 2007/05/09 08:48:02 liy Exp $
 */
package com.nec.sydney.beans.ddr;
import com.nec.nsgui.taglib.nssorttab.*;
public class DdrStatusTHeaderRender extends STAbstractRender {
    
    /**
    * Get the HTML code of the table Header which specified by (rowIndex, colName)
    * 
    * @param rowIndex  
    * @param colName
    * @return HTML code
    * @throws Exception
    */
    public String getCellRender(int rowIndex, String colName){
        
        if(rowIndex!=0){
            return "";
        }
        SortTagInfo tagInfo = getSortTagInfo();
        String thMsg = tagInfo.getHeaderMsg(colName);
        
        if (thMsg == null || (thMsg.trim()).equals("")){
            return "<th rowspan=\"2\">&nbsp;</th>";
        }
        thMsg = String2HTML(thMsg);
        
        //display a button
        if (tagInfo.isSortable(colName)){
            
            String queryStr = tagInfo.getQueryString();

            if (queryStr == null ||(queryStr.trim()).equals("")){
                queryStr = "";
            }else{
                queryStr = queryStr + "&";
            }
                        
            return "<th rowspan=\"2\"><input type=\"button\" value=\"" + thMsg 
                   + "\" onclick=\"window.location=window.location.href.split('?')[0] + '?" + queryStr
                   + "SORTTABLE_ID=" + tagInfo.getId()  
                   + "&SORTTABLE_COL=" + colName + "'\" /></th>";                          
        }else{    //display the text
            return "<th rowspan=\"2\">" + thMsg + "</th>";
        }
     }
}