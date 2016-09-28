/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STHeaderRender4IP.java,v 1.2 2007/04/26 06:20:55 wanghb Exp $
 */
package com.nec.nsgui.action.nic;
import com.nec.nsgui.taglib.nssorttab.*;
import javax.servlet.jsp.PageContext;
import org.apache.struts.taglib.TagUtils;

public class STHeaderRender4IP extends STAbstractRender {   

    /**
    * Get the HTML code of the table Header which specified by (rowIndex, colName)
    * 
    * @param rowIndex  
    * @param colName
    * @return HTML code
    * @throws Exception
    */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        SortTagInfo tagInfo = getSortTagInfo();
        PageContext context = tagInfo.getPageContext();
        String result =
                "<th >"
                + TagUtils.getInstance().message(
                    context,
                    null,
                    null,
                    "nic.list.table.head.ipaddress")
                + "</th>";                
        return result;
    }
}