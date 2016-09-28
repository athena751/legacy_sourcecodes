/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpSrcTDataRender.java,v 1.2 2007/07/11 11:57:50 hetao Exp $
 */

package com.nec.nsgui.action.snmp;

import java.util.AbstractList;
import java.util.ArrayList;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.entity.snmp.CommunityInfoBean;
import com.nec.nsgui.model.entity.snmp.SourceInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;

public class SnmpSrcTDataRender extends STAbstractRender {
    private static final String cvsid =
        "@(#) $Id: SnmpSrcTDataRender.java,v 1.2 2007/07/11 11:57:50 hetao Exp $";
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
        AbstractList comInfoList = ((ListSTModel) getTableModel()).getDataList();
        CommunityInfoBean comInfoObj = (CommunityInfoBean) comInfoList.get(rowIndex);
        ArrayList sourcesInfo = ((ArrayList)(comInfoObj.getSourceList()));
        
        String htmlCode = "";
        for (int i = 0; i < sourcesInfo.size(); i++) {
            SourceInfoBean oneSourceInfo = (SourceInfoBean) sourcesInfo.get(i);
            htmlCode =
                htmlCode
                    + "<td nowrap>"
                    + oneSourceInfo.getSource()
                    + "</td>"
                    + "<td nowrap align=\"center\">"
                    + getTransferString(oneSourceInfo.getRead())
                    + "</td>"
                    + "<td nowrap align=\"center\">"
                    + getTransferString(oneSourceInfo.getWrite())
                    + "</td>"
                    + "<td nowrap align=\"center\">"
                    + getTransferString(oneSourceInfo.getNotify())
                    + "</td>"
                    + "<td nowrap align=\"center\">"
                    + oneSourceInfo.getSnmpversion()
                    + "</td>"
                    + getTransferStringforFilterstatus(oneSourceInfo.getFilteringStatus())
                    + ((i != sourcesInfo.size() - 1) ? "</tr><tr>" : "");
        }
        return htmlCode;
    }
    private String getTransferString(String result){
        return (result.equals("true")) ? "<img src='"+NSActionConst.PATH_OF_CHECKED_GIF+"'/>" : "&nbsp;";
    }
    private String getTransferStringforFilterstatus(String result){
        if(result.equals("1")) {
            return "<td nowrap align=\"center\">" + "<img src='"+NSActionConst.PATH_OF_CHECKED_GIF+"'/>" + "</td>";
        }else if(result.equals("0")) {
            return "<td nowrap align=\"center\">&nbsp;</td>";
        }else {
            return "";
        }
    }
}