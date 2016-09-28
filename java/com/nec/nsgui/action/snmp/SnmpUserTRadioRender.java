/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpUserTRadioRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $
 */
package com.nec.nsgui.action.snmp;

import java.util.AbstractList;
import javax.servlet.jsp.PageContext;

import com.nec.nsgui.model.entity.snmp.UserInfoBean;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.taglib.nssorttab.*;

public class SnmpUserTRadioRender extends STAbstractRender {
    private static final String cvsid =
        "@(#) $Id: SnmpUserTRadioRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
    /**
     * Get the Radio cell's HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        AbstractList comInfoList = ((ListSTModel) getTableModel()).getDataList();
        UserInfoBean userInfoObj = (UserInfoBean) comInfoList.get(rowIndex); 

        return "<td><input type=\"radio\" " 
            + "name=\""
            + colName
            + "\" "
            + getRadioId(rowIndex)
            + " "
            + getRadioValue(userInfoObj)
            + " "
            + getRadioChecked(rowIndex, userInfoObj)
            + " /> </td> ";
    }
    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @return HTML code
     */
    private String getRadioId(int rowIndex) {
        return "id=\"user" + rowIndex + "\"";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName,userInfoObj)
     * 
     * @param rowIndex
     * @param colName
     * @param userInfoObj
     * @return ""
     */
    private String getRadioChecked(
        int rowIndex,
        UserInfoBean userInfoObj)
        throws Exception {  
        PageContext context = getSortTagInfo().getPageContext();
        String selectedUser = (String) context.getRequest().getParameter("selectedUser");
        if (selectedUser == null || selectedUser.equals("")) {
            return (rowIndex == 0)? "checked":"";
        } 
        else {
            return (userInfoObj.getUser().equals(selectedUser))? "checked":"";
        }
    }
    
    /**
     * Get the Radio cell's HTML code like "value=...." which specified by (rowIndex, colName)
     *  
     * @param userInfoObj
     * @return HTML code
     */
    private String getRadioValue(UserInfoBean userInfoObj) throws Exception {
        return "value=\"" + NSActionUtil.sanitize(userInfoObj.getUser(),true) + "\"";
    }
    
}