/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 *      $Id: STHeaderRender.java,v 1.4 2007/05/09 05:48:28 liul Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

public class STHeaderRender extends STAbstractRender {

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
        ColumnInfo columnInfo = (ColumnInfo)(tagInfo.getColumn(tagInfo.getColumnIndex(colName))); 
        String thMsg = tagInfo.getHeaderMsg(colName);

        if (thMsg == null || (thMsg.trim()).equals("")){
            return "<th>&nbsp;</th>";
        }

        thMsg = String2HTML(thMsg);
        
        //display a button
        if (tagInfo.isSortable(colName)){

            String queryStr = tagInfo.getQueryString();
            String beforeSort = columnInfo.getBeforeSort();
            
            if (queryStr == null ||(queryStr.trim()).equals("")){
                queryStr = "";
            }else{
                queryStr = queryStr + "&";
            }

            return "<th><input type=\"button\" value=\"" + thMsg
                   + "\" onclick=\""+beforeSort+";window.location=window.location.href.split('?')[0] + '?" + queryStr
                   + "SORTTABLE_ID=" + tagInfo.getId()
                   + "&SORTTABLE_COL=" + colName + "'\" /></th>";
        }else{    //display the text
            return "<th nowrap>" + thMsg + "</th>";
        }
     }
}