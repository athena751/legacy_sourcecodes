/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SortTableModel.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 */

package com.nec.nsgui.taglib.nssorttab;

import java.util.*;

public interface SortTableModel{

    //get the value of (rowIndex, colName)
    public Object getValueAt(int rowIndex, String colName) throws Exception;
    
    //get the count of all the data         
    public int getRowCount();
    
    //sort the data
    public void sort(String colName, boolean isAscend, String sideSortOrder,Hashtable comparators);
    
}