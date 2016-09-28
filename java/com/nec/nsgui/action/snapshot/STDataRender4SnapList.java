/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snapshot;

import java.util.AbstractList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.model.entity.snapshot.SnapshotInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4SnapList extends STAbstractRender implements SnapshotActionConst {
    private static final String cvsid = 
        "@(#) $Id: STDataRender4SnapList.java,v 1.1 2008/05/28 02:13:37 lil Exp $";

    private static final String snapBundle = Globals.MESSAGES_KEY + "/snapshot";
    
    /**
     * 
     */
    public String getCellRender(int rowIndex, String colName) throws Exception {        
        return "<td nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    /**
     * getCellContent
     * 
     * @param rowIndex
     * @param colName
     * @return
     * @throws Exception
     */
    private String getCellContent(int rowIndex, String colName) throws Exception {

        PageContext context = getSortTagInfo().getPageContext();
        AbstractList snapInfoList = ((ListSTModel) getTableModel()).getDataList();
        SnapshotInfoBean snapInfoBean = (SnapshotInfoBean) snapInfoList.get(rowIndex);
        StringBuffer cellStr = new StringBuffer();
     
        if (colName.equals("snapshotCb")) {
            String snapName = snapInfoBean.getName();
            cellStr.append("<input name=\"snapshotCb\" type=\"checkbox\" value=\"");
            cellStr.append(snapName);           
            cellStr.append("\"");            
            cellStr.append(" id=\"snapshotCb" + rowIndex);
            if (snapName.toUpperCase().startsWith(CONST_CHECKPOINT_PREFIX)) {
                cellStr.append("\" disabled/>");
                return cellStr.toString();
            }
            if ("active".equalsIgnoreCase(snapInfoBean.getStatus())) {
                if (snapInfoBean.isChecked()) {
                    cellStr.append("\" checked/>");
                } else {
                    cellStr.append("\"/>");
                }
            } else {
                cellStr.append("\" disabled/>");
            }
        } else if (colName.equals("name")) {
            cellStr.append("<label for=\"snapshotCb" + rowIndex + "\">");
            cellStr.append(snapInfoBean.getName());  
            cellStr.append("</label>");
        } else if (colName.equals("createTime")) {
            cellStr.append("<label for=\"snapshotCb" + rowIndex + "\">");
            cellStr.append(snapInfoBean.getCreateTime());  
            cellStr.append("</label>");            
        } else if (colName.equals("status")) {
            cellStr.append("<label for=\"snapshotCb" + rowIndex + "\">");
            String msgKey = 
                SNAPSHOT_LIST_MSGKEY_PREFIX_STATUS + snapInfoBean.getStatus().toLowerCase();
            cellStr.append(TagUtils.getInstance().message(context, snapBundle, null, msgKey));
            cellStr.append("</label>");
        }

        return cellStr.toString();
    }
}
