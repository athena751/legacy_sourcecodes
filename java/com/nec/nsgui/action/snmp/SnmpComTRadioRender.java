/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnmpComTRadioRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $
 */

package com.nec.nsgui.action.snmp;

import java.util.AbstractList;
import javax.servlet.jsp.PageContext;

import com.nec.nsgui.model.entity.snmp.CommunityInfoBean;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.taglib.nssorttab.*;

public class SnmpComTRadioRender extends STAbstractRender {
    private static final String cvsid =
        "@(#) $Id: SnmpComTRadioRender.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
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
        CommunityInfoBean comInfoObj = (CommunityInfoBean) comInfoList.get(rowIndex);
        return "<td rowspan=\""
            + Integer.toString((comInfoObj.getSourceList()).size())
            + "\"><input type=\"radio\" name=\""
            + colName
            + "\" "
            + getRadioId(rowIndex)
            + " "
            + getRadioValue(comInfoObj)
            + " "
            + getRadioChecked(rowIndex, comInfoObj)
            + " /> </td> ";
    }
    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex)
     * 
     * @param rowIndex
     * @return HTML code
     */
    private String getRadioId(int rowIndex) {
        return "id=\"community" + rowIndex + "\"";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName,comInfoObj)
     * 
     * @param rowIndex
     * @param colName
     * @param comInfoObj
     * @return ""
     */
    private String getRadioChecked(
        int rowIndex,
        CommunityInfoBean comInfoObj)
        throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        String selectedCom =(String) context.getRequest().getAttribute("selectedComNanme");
        if (selectedCom == null || selectedCom.equals("")) {
            return (rowIndex == 0)? "checked":"";
        }
        else{
            return (comInfoObj.getCommunityName().equals(selectedCom))? "checked":"";
        } 
    }
    
     /**
     * Get the Radio cell's HTML code like "value=...." which specified by (comInfoObj)
     *  
     * @param comInfoObj
     * @return HTML code
     */
    private String getRadioValue(CommunityInfoBean comInfoObj) throws Exception {
        return "value=\"" + NSActionUtil.sanitize(comInfoObj.getCommunityName(),true) + "\"";
    }

}