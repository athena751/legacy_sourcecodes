/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpComTDataRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $
 */
package com.nec.nsgui.action.snmp;

import java.util.AbstractList;

import com.nec.nsgui.model.entity.snmp.CommunityInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STDataRender;

public class SnmpComTDataRender extends STDataRender {
    private static final String cvsid =
        "@(#) $Id: SnmpComTDataRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        AbstractList comInfoList = ((ListSTModel) getTableModel()).getDataList();
        CommunityInfoBean comInfoObj = (CommunityInfoBean) comInfoList.get(rowIndex);

        String cellData = getCellData(rowIndex, colName);
        String htmlCode = "<td rowspan=\"" + Integer.toString(comInfoObj.getSourceList().size()) + "\">";  
        htmlCode = htmlCode + "<label for=\"community"+rowIndex+"\">" + cellData + "</label>"+ "</td>" ;
        return htmlCode;
    }
}