/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package    com.nec.sydney.beans.nashead;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.nashead.UnlinkedLunInfo;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4Nashead extends STAbstractRender{
    public static final String cvsid =
        "@(#) $Id: STDataRender4Nashead.java,v 1.2 2005/10/24 06:16:59 liuyq Exp $";

    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        if(colName.equals("lun")){
            return "<td nowrap align=center>" + getCellContent(rowIndex, colName) + "</td>";
        }
        return "<td nowrap align=left>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName){
        PageContext context = getSortTagInfo().getPageContext();
        AbstractList lunList = ((ListSTModel) getTableModel()).getDataList();
        UnlinkedLunInfo lunObj = (UnlinkedLunInfo) lunList.get(rowIndex);
        
        if (colName.equals("checkbox")){
            StringBuffer cellStr = new StringBuffer(
               "<input name=\"lun\" type=\"checkbox\" id=\"radio" 
                        + rowIndex + "\" "
                        + "value=\""); 
            cellStr.append(lunObj.getWwnn()).append(",");
            cellStr.append(lunObj.getLun());
            cellStr.append("\" />");
            return cellStr.toString();
        }
        if (colName.equals("storageName")){
            StringBuffer cellStr = new StringBuffer(
                "<label for=\"radio" + rowIndex + "\" >");
            cellStr.append(lunObj.getStorageName());
            cellStr.append("</label>");
            return cellStr.toString();
        }
        if (colName.equals("wwnn")){
            return lunObj.getWwnn();
        }
        if (colName.equals("lun")){
            //conver the decimal to the hex
            String lun =lunObj.getLun();
            
            try{
                return NSActionUtil.getHexString(4, lun);
            }catch (Exception e){
                return lun;
            }
            
        }
        return "";
    }
}
