/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
 package com.nec.nsgui.action.statis;
 
import java.util.AbstractList;
import com.nec.nsgui.action.statis.CollectionConst;
import com.nec.nsgui.model.entity.statis.CollectionItemInfoBean;
import com.nec.nsgui.taglib.nssorttab.*;

public class STDataRenderSampling extends STAbstractRender{
    public static final String cvsid 
            = "@(#) $Id: STDataRenderSampling.java,v 1.2 2007/03/07 06:25:29 yangxj Exp $";
    int checkRowIndex = 0;
    public String getCellRender(int rowIndex, String colName)
        throws Exception{
            
            AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
            CollectionItemInfoBean exInfoObj = (CollectionItemInfoBean) exInfoList.get(rowIndex);
            if(colName.equals("collectionItem")){
                return "<td nowrap align=left>"+getCellContext(rowIndex,colName)+"</td>";
            }else if(colName.equals("dataFileSize")||colName.equals("stockPeriod")){
                return getCellContext(rowIndex,colName);
            }
            else{
                return "<td nowrap>"+getCellContext(rowIndex,colName)+"</td>";            
            }
        }
    private String getCellContext(int rowIndex,String colName)
        throws Exception{
            AbstractList itemList = ((ListSTModel) getTableModel()).getDataList();
            CollectionItemInfoBean itemObj = (CollectionItemInfoBean) itemList.get(rowIndex);
            if(colName.equals("radio")){
                StringBuffer cellStr=
                    new StringBuffer(
                        "<input type=\"radio\" name=\"itemRadio\" id=\"item"+rowIndex
                        +"\" ");
                if(itemObj.getFlag().equals("disableRadio")){
                    cellStr.append(" disabled ");
                    checkRowIndex++;
                }
                if(rowIndex==checkRowIndex){
                    cellStr.append("checked ");
                }
                cellStr.append("value=\""+itemObj.getID()+"#"+itemObj.getStockPeriod()+"#"+itemObj.getCollectionItem()+"\" ");
                cellStr.append("onclick=\"OnRadioBtnFun('"+itemObj.getDataFileSize()+"')");
                cellStr.append("\">");
                return cellStr.toString();
            }
            if(colName.equals("collectionItem")){
                StringBuffer cellStr=
                    new StringBuffer(
                        "<label for=\"item"+rowIndex
                        +"\">");
                cellStr.append(itemObj.getCollectionItem());
                cellStr.append("</label>");
                return cellStr.toString();                            
            }
            if(colName.equals("dataFileSize")){
                String size = itemObj.getDataFileSize();
                return getContext(size);
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