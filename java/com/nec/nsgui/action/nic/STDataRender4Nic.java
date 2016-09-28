/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STDataRender4Nic.java,v 1.8 2007/09/12 06:55:56 fengmh Exp $
 */
package com.nec.nsgui.action.nic;
import java.util.AbstractList; 

import javax.servlet.jsp.PageContext;
import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.model.entity.nic.NicInformationBean;
import com.nec.nsgui.taglib.nssorttab.*;
public class STDataRender4Nic extends STDataRender {

    public static String nicBundle = Globals.MESSAGES_KEY + "/nic";
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
        //get the data model        
        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        String resultString = "";
        //the radio html source        
        if (colName.equals("radioValue")) {
            NicInformationBean exInfoObj =
                (NicInformationBean) exInfoList.get(rowIndex);
            resultString =
                "<td rowspan=\"1"
                    + "\"><input type=\"radio\" name=\""
                    + colName
                    + "\" "
                    + getRadioId(rowIndex, colName)
                    + " "
                    + getRadioValue(rowIndex, colName, exInfoObj)
                    + " "
                    + " onclick=\"onRadioChange(this.value)\" "
                    + getRadioChecked(rowIndex, colName, exInfoObj)
                    + "/> </td> ";
            //the ip,gateway,construction column html source        
        } else if (
            colName.equals("ipAddress")
                || colName.equals("gateway")
                || colName.equals("construction")) {
            String cellData = getCellData(rowIndex, colName);
            return this.getCommonValue(rowIndex, colName, cellData);
            //the status column html source      
        } else if (colName.equals("status")) {
            NicInformationBean exInfoObj =
                (NicInformationBean) exInfoList.get(rowIndex);
            return this.getStatus(rowIndex, colName, exInfoObj);
            //get the mtu html source        
        } else if (colName.equals("mtu")) {
            return this.getMTU(getCellData(rowIndex, colName));
            //get the nicname html source 
        } else if (colName.equals("nicName")) {
            return super.getCellRender(rowIndex, colName);
            //the yes or no columns html source
        } else if (colName.equals("vl")) {
            String cellData = getCellData(rowIndex, colName);
            return this.getYesOrNo(rowIndex, colName, cellData);
            //the type html source  
        }else if(colName.equals("alias")){
            String cellData = getCellData(rowIndex, colName);
            cellData = cellData.equals("&nbsp;") ? "NO" : "YES";
            return this.getYesOrNo(rowIndex, colName, cellData);
        }else if(colName.equals("mode")){
            String cellData = getCellData(rowIndex, colName);
            cellData = (cellData.equals("--"))?"NO":"YES";
            return this.getYesOrNo(rowIndex, colName, cellData);    
        } else if (colName.equals("type")) {
            String cellData = getCellData(rowIndex, colName);
            return this.getType(cellData);
        } else {
            return " ";
        }
        return resultString;
    }

    /*
      *   the function to get MTU column html source
      *   param: cellData. the column's data.
      */
    private String getMTU(String cellData) throws Exception {
        String htmlCode;
        htmlCode = "<td align=\"right\" >" + cellData + "</td>";
        return htmlCode;
    }

    /*
     *   the function to get type column html source
     *   param: cellData. the column's data.
     */
    private String getType(String cellData) throws Exception {
        SortTagInfo tagInfo = getSortTagInfo();
        PageContext context = tagInfo.getPageContext();
        String result = "<td>";
        if (cellData.equals("NORMAL")) {
            result
                += TagUtils.getInstance().message(
                    context,
                    nicBundle,
                    null,
                    "nic.list.table.data.normal");
        } else if (cellData.equals("TOE")) {
            result
                += TagUtils.getInstance().message(
                    context,
                    nicBundle,
                    null,
                    "nic.list.table.data.toe");
        } else if (cellData.equals("MIX")) {
            result
                += TagUtils.getInstance().message(
                    context,
                    nicBundle,
                    null,
                    "nic.list.table.data.normaltoe");
        }
        result = result + "</td>";
        return result;
    }
    /*
     *   the function to get Status column html source
     *   param: 
     *      rowIndex:the row Index.
     *      colName  : the column name
     *      exObj   : the data object of the page.
     */
    private String getStatus(
        int rowIndex,
        String colName,
        NicInformationBean exObj)
        throws Exception {

        String cellData = "0";
        String label = super.getLabel(rowIndex, colName);
        String htmlCode;

        if (exObj.getLinkStatus().equals("UP")
            && exObj.getWorkStatus().equals("UP")) {
            cellData = "1";
        }
        if (cellData.matches("1")) {
            htmlCode =
                "<td align=\"center\" ><img src=\"../../images/nation/correct.gif\">";
        } else {
            htmlCode =
                "<td align=\"center\" >--";
        }
        if (label != null) {
            htmlCode = htmlCode + label + "</label>";
        } else {
        }
        htmlCode = htmlCode + "</td>";
        return htmlCode;
    }

    /*
     *    the Yes or No column html source
     *    param: 
     *      rowIndex:the row Index.
     *      colName  : the column name
     *      cellData : the column's data.          
     *    return html source
     */
    private String getYesOrNo(int rowIndex, String colName, String cellData)
        throws Exception {

        String label = getLabel(rowIndex, colName);
        String htmlCode;
        if (cellData.matches("YES")) {
            htmlCode =
                "<td align=\"center\" ><img src=\"../../images/nation/check.gif\">";
        } else {
            htmlCode = "<td >&nbsp;";
        }

        if (label != null) {
            htmlCode = htmlCode + label + "</label>";
        } else {
        }
        htmlCode = htmlCode + "</td>";
        return htmlCode;
    }

    /*
    *    the common string column html source
    *    param: 
    *      rowIndex:the row Index.
    *      colName  : the column name
    *      cellData : the column's data.          
    *    return html source
    */
    private String getCommonValue(
        int rowIndex,
        String colName,
        String cellData)
        throws Exception {
        String label = getLabel(rowIndex, colName);
        String htmlCode;
        if (cellData.matches("--") && colName != "construction") {
            htmlCode = "<td align=\"center\" >";
        } else if (cellData.matches("--") && colName.equals("construction")) {
            htmlCode = "<td >";
            cellData = "&nbsp;";
        } else {
            htmlCode = "<td >";
        }
        if (label != null) {
            htmlCode = htmlCode + label + cellData + "</label>";
        } else {
            htmlCode = htmlCode + cellData;
        }
        htmlCode = htmlCode + "</td>";
        return htmlCode;
    }
    /**
     * Get the Radio cell's HTML code like "id=...." which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioId(int rowIndex, String colName) {
        SortTagInfo tagInfo = getSortTagInfo();
        return "id=\"" + colName + tagInfo.getId() + rowIndex + "\"";
    }

    /**
     * Get the Radio cell's HTML code like "checked" which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return ""
     */
    private String getRadioChecked(
        int rowIndex,
        String colName,
        NicInformationBean exInfoObj)
        throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        String selectedInterface =
            (String) context.getSession().getAttribute("selectedInterface");
        if(selectedInterface == null ){
            selectedInterface =
                        (String) context.getSession().getAttribute("selectedRedundantInterface");
        }
        if (rowIndex == 0) {
            if (selectedInterface != null) {
                AbstractList exInfoList =
                    ((ListSTModel) getTableModel()).getDataList();
                boolean found = false;
                for (int i = 0; i < exInfoList.size(); i++) {
                    NicInformationBean exObj =
                        (NicInformationBean) exInfoList.get(i);
                    if (exObj.getNicName().equals(selectedInterface)) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    return "checked=\"true\"";
                }
            } else {
                return "checked=\"true\"";
            }
        }
        if (selectedInterface != null) {
            return (exInfoObj.getNicName().equals(selectedInterface))
                ? "checked=\"true\""
                : "";
        } else {
            return "";
        }
    }

    /**
     * Get the Radio cell's HTML code like "value=...." which specified by (rowIndex, colName)
     *  
     * @param rowIndex
     * @param colName
     * @return HTML code
     */
    private String getRadioValue(
        int rowIndex,
        String colName,
        NicInformationBean exInfoObj)
        throws Exception {
        String rtnValue = "value=\"";
        SortTagInfo tagInfo = getSortTagInfo();
        String nicName =
            tagInfo.getColumnName((tagInfo.getColumnIndex(colName)) + 1);
        if (nicName == null) {
            tagInfo.setShareObj(null);
        } else {
            rtnValue = rtnValue + String2HTML(exInfoObj.getNicName());
            if (exInfoObj.getIpAddress().equals("--")) {
                rtnValue = rtnValue + String2HTML("#0");
            } else {
                rtnValue = rtnValue + String2HTML("#1");
            }
            if (exInfoObj.getVl().equals("YES")) {
                rtnValue = rtnValue + String2HTML("#1");
            } else {
                rtnValue = rtnValue + String2HTML("#0");
            }
            AbstractList exInfoList =
                ((ListSTModel) getTableModel()).getDataList();
            boolean isVlanBase = false;
            boolean isAliasBase = false;
            for (int i = 0; i < exInfoList.size(); i++) {
                NicInformationBean exObj =
                    (NicInformationBean) exInfoList.get(i);
                if (exObj.getNicName().indexOf(exInfoObj.getNicName() + ".")
                    >= 0) {
                    isVlanBase = true;
                }
                if (exObj.getNicName().matches(exInfoObj.getNicName() + ":\\d{3,}")) {
                    isAliasBase = true;
                }
            }
            if (!isVlanBase) {
                rtnValue = rtnValue + String2HTML("#0");
            } else {
                rtnValue = rtnValue + String2HTML("#1");
            }
            if (exInfoObj.getAlias().equals("")){
                rtnValue = rtnValue + String2HTML("#0");
            } else {
                rtnValue = rtnValue + String2HTML("#1");
            }
            if(!isAliasBase) {
                rtnValue = rtnValue + String2HTML("#0");
            } else  {
                rtnValue = rtnValue + String2HTML("#1");
            }
            if(exInfoObj.getType().equals("TOE")) {
                rtnValue = rtnValue + String2HTML("#1");
            } else {
                rtnValue = rtnValue + String2HTML("#0");
            }
            tagInfo.setShareObj(colName);
        }
        return rtnValue + "\"";
    }
}