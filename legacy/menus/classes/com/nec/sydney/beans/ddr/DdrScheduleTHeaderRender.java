/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrScheduleTHeaderRender.java,v 1.2 2007/05/09 08:48:02 liy Exp $
 */
package com.nec.sydney.beans.ddr;

import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.sydney.framework.NSMessageDriver;

public class DdrScheduleTHeaderRender extends STAbstractRender {
    
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
            if(colName.equals("day")){
                String schedule = NSMessageDriver.getInstance().getMessage(tagInfo.getPageContext().getSession(), "nas_snapshot/snapschedule/th_schedule");
                String action = NSMessageDriver.getInstance().getMessage(tagInfo.getPageContext().getSession(), "nas_ddrschedule/ddrschlist/th_action");
                return "<th colspan=\"2\">" + schedule + "</th><th rowspan=\"2\">"
                        + action + "</th></tr><tr><th>" + thMsg + "</th>";
            } else if(colName.equals("action")){
                return "";
            } else {
                return "<th>" + thMsg + "</th></tr>";
            }
        }
     }
}