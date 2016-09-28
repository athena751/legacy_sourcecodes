/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NfsClientTDataRender.java,v 1.1 2004/09/01 07:34:06 xiaocx Exp $
 */
package com.nec.sydney.beans.exportroot;
import java.util.AbstractList;
import java.util.List;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.exportroot.EntryInfoBean;
import com.nec.sydney.atom.admin.exportroot.ClientInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;
public class NfsClientTDataRender extends STAbstractRender {
    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        EntryInfoBean exInfoObj = (EntryInfoBean) exInfoList.get(rowIndex);
        List clientsInfo = exInfoObj.getClients();
        String htmlCode = "";
        for (int i = 0; i < clientsInfo.size(); i++) {
            ClientInfoBean oneClientInfo = (ClientInfoBean) clientsInfo.get(i);
            htmlCode =
                htmlCode
                    + "<td nowrap>"
                    + String2HTML(NSActionUtil.perl2Page(oneClientInfo.getClientName(),NSActionConst.BROWSER_ENCODE))
                    + "</td>"
                    + "<td nowrap>"
                    + String2HTML(NSActionUtil.perl2Page(oneClientInfo.getOption(),NSActionConst.BROWSER_ENCODE))
                    + "</td>"
                    + ((i != clientsInfo.size() - 1) ? "</tr><tr>" : "");
        }
        return htmlCode;
    }
}