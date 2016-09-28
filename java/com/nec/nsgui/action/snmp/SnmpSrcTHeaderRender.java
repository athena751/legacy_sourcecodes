/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpSrcTHeaderRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $
 */

package com.nec.nsgui.action.snmp;

import com.nec.nsgui.taglib.nssorttab.*;

public class SnmpSrcTHeaderRender extends STAbstractRender {
    private static final String cvsid =
        "@(#) $Id: SnmpSrcTHeaderRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
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
        String[] fourHeader = thMsg.split(",");
        String htmlCode = "";
        for(int i = 0; i < fourHeader.length; i ++){
            htmlCode = htmlCode + "<th>" + String2HTML(fourHeader[i]) + "</th>";
        }
        return htmlCode;        
     }
}