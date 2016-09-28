/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
 package com.nec.nsgui.action.statis;
 
import java.util.AbstractList;

import com.nec.nsgui.model.entity.statis.CollectionItemInfoBean2;
import com.nec.nsgui.taglib.nssorttab.*;
public class STDataRenderSurvey extends STAbstractRender{
    public static final String cvsid 
            = "@(#) $Id: STDataRenderSurvey.java,v 1.1 2005/10/18 16:24:27 het Exp $";
    public String getCellRender(int rowIndex, String colName)
        throws Exception{
            
            AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
            CollectionItemInfoBean2 exInfoObj = (CollectionItemInfoBean2) exInfoList.get(rowIndex);
            if(colName.equals("status")){
                return "<td nowrap align=center>"+getCellContext(rowIndex,colName)+"</td>";
            }else if(colName.equals("stockPeriod")||colName.equals("interval")||colName.equals("dataFileSize")){
                return getCellContext(rowIndex,colName);
            }else{
                return "<td nowrap>"+getCellContext(rowIndex,colName)+"</td>";            
            }
        }
    private String getCellContext(int rowIndex,String colName)
        throws Exception{
            AbstractList itemList = ((ListSTModel) getTableModel()).getDataList();
            CollectionItemInfoBean2 itemObj = (CollectionItemInfoBean2) itemList.get(rowIndex);
            if(colName.equals("radio")){
                StringBuffer cellStr=
                    new StringBuffer(
                        "<input type=\"radio\" name=\"surveyRadio\" id=\"survey"+rowIndex
                        +"\" ");
                if(rowIndex==0){
                    cellStr.append("checked ");
                }
                cellStr.append("value=\""+itemObj.getCollectionItem()+"#"+itemObj.getStatus()
                +"#"+itemObj.getInterval()+"#"+itemObj.getStockPeriod()+"#"+itemObj.getID()+"\" ");
                cellStr.append("onclick=\"OnRadioBtnFun('"+itemObj.getDataFileSize()+"')");
                cellStr.append("\">");
                return cellStr.toString();
            }
            if(colName.equals("collectionItem")){
                StringBuffer cellStr=
                    new StringBuffer(
                        "<label for=\"survey"+rowIndex
                        +"\">");
                cellStr.append(itemObj.getCollectionItem());
                cellStr.append("</label>");
                return cellStr.toString();                            
            }
            if(colName.equals("status")){
                String on = "<img src=\"" + CollectionConst.PATH_OF_CHECKED_GIF + "\">";
                if(itemObj.getStatus()!=null
                    &&itemObj.getStatus().booleanValue()){
                        return on;
                    }
                return "&nbsp;";
            }
            if(colName.equals("dataFileSize")){
                String size = itemObj.getDataFileSize();
                return getContext(size);
            }
            if(colName.equals("interval")){
                String interval = itemObj.getInterval();
                return getContext(interval);
            }
            if(colName.equals("stockPeriod")){
                String period = itemObj.getStockPeriod();
                return getContext(period);
            }
            return "";
        }
    private String getContext(String value) {
        String result = "";
        if (value.equals(CollectionConst.DLINE)) {
            result = "<td nowrap align=center>" + value + "</td>";
        } else {
            result = "<td nowrap align=right>" + value + "</td>";
        }
        return result;
    }        
}