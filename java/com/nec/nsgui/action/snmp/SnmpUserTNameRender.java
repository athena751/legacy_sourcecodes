/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpUserTNameRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $
 */

package com.nec.nsgui.action.snmp;

import com.nec.nsgui.taglib.nssorttab.*;

public class SnmpUserTNameRender extends STDataRender {
    private static final String cvsid =
        "@(#) $Id: SnmpUserTNameRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
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
        String htmlCode = "<td><label for=\"user"+rowIndex+"\">" + cellData + "</label>"+ "</td>" ;
        return htmlCode;
    }
}