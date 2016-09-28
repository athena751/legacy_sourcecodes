/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: ListSTModel.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *      
 */

package com.nec.nsgui.taglib.nssorttab;

import java.util.*;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.beanutils.BeanComparator;

public class ListSTModel implements SortTableModel{
    
    private AbstractList dataList = null;
    
    public ListSTModel(AbstractList dataList){
        this.dataList = dataList;
    }
    
    public void setDataList(AbstractList dataList){
        this.dataList = dataList;
    }
    
    public AbstractList getDataList(){
        return this.dataList;
    }
    
    public Object getValueAt(int rowIndex, String colName) throws Exception
    {                  
        Object object; 
        Object rtnValue = null;
        
        if (dataList == null || dataList.size() == 0 || colName == null || colName.trim().equals("")){
            return null;
        }
        
        if (rowIndex<0 || rowIndex >= getRowCount()){
            return null;
        }
        
        object = dataList.get(rowIndex);
        if (object == null){
            return null;
        }
        try {
            rtnValue = PropertyUtils.getProperty(object,colName);
        }catch (Exception e){
            throw e;
        }
        
        return rtnValue;
    }
    
    public int getRowCount(){
        
        if (dataList != null){
            return dataList.size();
        }else{
            return 0;
        }
    }
    
    public void sort(String colName, boolean isAscend, String sideSortOrder,Hashtable comparators){
        
        if (colName == null || colName.trim().equals("")){
            return;
        }
        
        if (comparators == null){
            return;
        }
        
        if (dataList.size() <= 1){
            return;
        }
        Vector sortData = new Vector();        
        
        sortData.add(colName);
        sortData.add((comparators.get(colName)));
        
        if (sideSortOrder != null){
            String[] orders = sideSortOrder.split(" ");
            
            for(int i=0; i<orders.length; i++){
                String order = orders[i];
                if (!(order.trim().equals(""))){
                    sortData.add(order);
                    sortData.add((comparators.get(order)));
                }
            }
        }
        
        SortComparator comp = new SortComparator(isAscend, sortData);
        Collections.sort(dataList, comp);
        
        return;
    }
    
}


//The comparator used by ListSTModel
class SortComparator implements Comparator{
    
    private Vector sortData;         //the colName and the related comparator
    private boolean isAscend;        //the primary sortting is ascend or descend
    
    public SortComparator(boolean isAscend, Vector sortData) {
        this.isAscend = isAscend;
        this.sortData = sortData;        
    }
    
    public int compare(Object o1, Object o2) {
        
        if(o1==null && o2 == null) return 0;
        
        if (o1 == null ) {
            return isAscend?-1:1;            
        }else if (o2 == null){
            return isAscend?1:-1;            
        }
        
        int result = 0;   //the result of compare
        int size = sortData.size();    //the size of sortData 
 
        
        for (int i = 0;i<size && result==0; i+=2){
            String colName = (String)sortData.get(i);
            Object prop1 = null, prop2 = null;
            try {
                prop1 = PropertyUtils.getProperty(o1,colName);
                prop2 = PropertyUtils.getProperty(o2,colName);
            }catch (Exception e){
            }
            
            if (prop1 == null && prop2 == null){
                return 0;
            }
            if (prop1 == null) {
                result = -1;            
            }else if (prop2 == null){
                result = 1;            
            }else{
                Comparator comparator = (Comparator)sortData.get(i+1);
                BeanComparator beanComp;
                
                if (comparator != null){
                    beanComp = new BeanComparator(colName, comparator);
                }else{
                    beanComp = new BeanComparator(colName);
                }
                
                result = beanComp.compare(o1,o2);
            }
            if (i == 0 && !isAscend){
                result = -result;
            }
        }
        
        return result;
    } 
}