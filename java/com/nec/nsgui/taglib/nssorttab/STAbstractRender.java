/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STAbstractRender.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

public abstract class STAbstractRender implements STCellRender{
    
    private SortTableModel tabModel;
    private SortTagInfo tagInfo;
    
    public void setTableModel(SortTableModel tm){
        this.tabModel = tm;
    }
    public SortTableModel getTableModel(){
        return this.tabModel;
    }
    
    public void setSortTagInfo(SortTagInfo  tagInfo){
        this.tagInfo = tagInfo;
    }
    
    public SortTagInfo getSortTagInfo(){
        return this.tagInfo;
    }
    
    public static String String2HTML(String src){
        
        if (src == null){
            return null;
        }
        
        src = src.replaceAll("&", "&amp;").replaceAll("<", "&lt;").
                  replaceAll(">", "&gt;").replaceAll("\"", "&quot;").
                  replaceAll("'", "&#39;");
        
        src = src.replaceAll("\\s","&nbsp;");
        
        return src;
    }
}