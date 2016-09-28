/*      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.account;

import java.util.AbstractList;
import javax.servlet.jsp.PageContext;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;
import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.nsgui.action.framework.ClientInfoBean;

public class STDataListRender4Account extends STDataRender {

    private static final String cvsid = "@(#) $Id: STDataListRender4Account.java,v 1.5 2007/04/25 02:44:25 chenbc Exp $";

    public static String accountBundle = Globals.MESSAGES_KEY + "/account";

    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception {
        // get the data model
        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        ClientInfoBean exInfoObj = (ClientInfoBean) exInfoList.get(rowIndex);
        if (colName.equals("timeout")) {
            return this.getTimeout(rowIndex, colName, exInfoObj);
        } else if (colName.equals("idleTime")) {
            return this.getIdleTime(rowIndex, colName, exInfoObj);
        } else if (colName.equals("checkboxId")) {
            return this.getCheckboxId(rowIndex, colName, exInfoObj);
        } else if (colName.equals("from")) {
            return this.getLabelFor(rowIndex, colName, exInfoObj);
        } else
            return "";
    }

    private String getTimeout(int rowIndex, String colName,
            ClientInfoBean cellData) throws Exception {
        String htmlCode = "<td>";
        SortTagInfo tagInfo = getSortTagInfo();
        PageContext context = tagInfo.getPageContext();
        htmlCode += cellData.getTimeout().equals("-1") ? (TagUtils.getInstance().message(
                context, accountBundle, null, "account.list.nolimit"))
                : cellData.getTimeout()
                        + " "
                        + ((cellData.getTimeout().equals("0") || cellData.getTimeout().equals("1")) ?
                                TagUtils.getInstance().message(context, accountBundle, null,
                                "account.list.min") : TagUtils.getInstance().message(context, accountBundle, null,
                                "account.list.mins"));
        htmlCode += "</td>";
        return htmlCode;
    }

    private String getIdleTime(int rowIndex, String colName,
            ClientInfoBean cellData) throws Exception {
        String htmlCode;
        SortTagInfo tagInfo = getSortTagInfo();
        PageContext context = tagInfo.getPageContext();
        htmlCode = "<td>"
                + cellData.getIdleTime()
                + " "
                + ((cellData.getIdleTime().equals("0") || cellData.getIdleTime().equals("1")) ?
                        TagUtils.getInstance().message(context, accountBundle, null,
                        "account.list.min") : TagUtils.getInstance().message(context, accountBundle, null,
                        "account.list.mins")) + "</td>";
        return htmlCode;
    }

    private String getCheckboxId(int rowIndex, String colName,
            ClientInfoBean cellData) throws Exception {
        SortTagInfo tagInfo = getSortTagInfo();
        String htmlCode = "<td><input type=\"checkbox\" name=\"" + colName
                + "\" " + "id=\"" + cellData.getSessionId() + "\""
                + " " + "value=\"" + cellData.getSessionId() + "\"" + " "
                + "/> </td>";

        return htmlCode;
    }

    private String getLabelFor(int rowIndex, String colName,
            ClientInfoBean cellData) throws Exception {
        String htmlCode = "<td><label for=\"" + cellData.getSessionId()
                + "\"" + ">" + cellData.getFrom() + "</label>" + "</td>";
        return htmlCode;
    }
}