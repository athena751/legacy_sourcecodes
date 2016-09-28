/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: STCellRender.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

public interface STCellRender{
    
    //get the HTML code about (rowIndex,colName) 
    public String getCellRender(int rowIndex, String colName) throws Exception;
    
    public void setTableModel(SortTableModel tm);
    public SortTableModel getTableModel();
    public void setSortTagInfo(SortTagInfo  tagInfo);
    public SortTagInfo getSortTagInfo();
}