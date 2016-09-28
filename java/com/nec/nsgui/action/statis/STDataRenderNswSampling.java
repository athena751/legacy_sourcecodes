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
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.base.NSActionConst;

import com.nec.nsgui.model.entity.statis.NswSamplingInfoBeanBase;
import com.nec.nsgui.model.entity.statis.VirtualPathInfoBean;
import com.nec.nsgui.model.entity.statis.NodeInfoBean;
import com.nec.nsgui.action.statis.CollectionConst3;
import com.nec.nsgui.taglib.nssorttab.*;

public class STDataRenderNswSampling extends STAbstractRender {
    public static final String cvsid 
            = "@(#) $Id: STDataRenderNswSampling.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
    public String getCellRender(int rowIndex, String colName)
        throws Exception {

        AbstractList exInfoList = ((ListSTModel) getTableModel()).getDataList();
        NswSamplingInfoBeanBase exInfoObj =
            (NswSamplingInfoBeanBase) exInfoList.get(rowIndex);
        if (colName.equals("id")) {
            return "<td nowrap align=left>"
                + getCellContext(rowIndex, colName)
                + "</td>";
        } else if (colName.equals("interval") || colName.equals("period")||colName.equals("size")) {
            return getCellContext(rowIndex, colName);
        } else if(colName.equals("samplingStatus")){
            return "<td nowrap align=center>"+getCellContext(rowIndex,colName)+"</td>";
        }else {
            return "<td nowrap>" + getCellContext(rowIndex, colName) + "</td>";
        }
    }
    private String getCellContext(int rowIndex, String colName)
        throws Exception {
        AbstractList itemList = ((ListSTModel) getTableModel()).getDataList();
        NswSamplingInfoBeanBase itemObjBase =
            (NswSamplingInfoBeanBase) itemList.get(rowIndex);
        if (colName.equals("checkbox")) {
            StringBuffer cellStr =
                new StringBuffer(
                    "<input type=\"checkbox\" name=\"idList\" id=\"item"
                        + rowIndex
                        + "\" ");
            cellStr.append("value=\"" + itemObjBase.getIndexID() + "#");
            if (itemObjBase.getSamplingStatus().booleanValue()) {
                cellStr.append("on");
            } else {
                cellStr.append("off");
            }
            cellStr.append("\">");
            return cellStr.toString();
        }
        if (colName.equals("id")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"item" + rowIndex + "\">");
            if(itemList.get(rowIndex) instanceof NodeInfoBean){
                NodeInfoBean nodeBean = (NodeInfoBean)itemList.get(rowIndex);
                cellStr.append(nodeBean.getNickName());
            }else{
                cellStr.append(getTranslateContext(itemObjBase.getId()));
            }
            cellStr.append("</label>");
            return cellStr.toString();
        }
        if (colName.equals("samplingStatus")) {
            String on =
                "<img src=\"" + CollectionConst3.PATH_OF_CHECKED_GIF + "\">";
            if (itemObjBase.getSamplingStatus() != null
                && itemObjBase.getSamplingStatus().booleanValue()) {
                return on;
            }
            return "&nbsp;";
        }
        if(colName.equals("size")){
            String size = itemObjBase.getSize();
            return getContext(size);
        }
        if (colName.equals("interval")) {
            String intervalValue = itemObjBase.getInterval();
            return getContext(intervalValue);
        }
        if (colName.equals("period")) {
            String periodValue = itemObjBase.getPeriod();
            return getContext(periodValue);
        }
        if (colName.equals("exportPath")) {
            VirtualPathInfoBean vpBean =
                (VirtualPathInfoBean) itemList.get(rowIndex);
            String exportStr = vpBean.getExportPath();
            return getTranslateContext(exportStr);
        }
        return "";
    }
    private String getContext(String value) {
        String result = "";
        if (value.equals(CollectionConst3.DLINE)) {
            result = "<td nowrap align=center>" + value + "</td>";
        } else {
            result = "<td nowrap align=right>" + value + "</td>";
        }
        return result;
    }
    private String getTranslateContext(String value) throws Exception {
        String result =
            NSActionUtil.perl2Page(value, NSActionConst.ENCODING_EUC_JP);
        return NSActionUtil.sanitize(result);
    }
}