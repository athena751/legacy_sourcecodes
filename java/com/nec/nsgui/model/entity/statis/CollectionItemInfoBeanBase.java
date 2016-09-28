/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.statis;

public class CollectionItemInfoBeanBase{
    private static final String cvsid ="@(#) $Id: CollectionItemInfoBeanBase.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String ID;
    private String collectionItem;
    private String dataFileSize;
    private String stockPeriod;
    private String interval="10";
    
    public void fillProperties(String id,String item,String size,String period){        
        ID = id;
        collectionItem = item;
        dataFileSize = size;
        stockPeriod = period;
    }
    public String getInterval(){
        return interval;
    }
    protected void setInterval(String string){
        interval = string;
    }
    
    /**
     * @return
     */
    public String getCollectionItem() {
        return collectionItem;
    }

    /**
     * @return
     */
    public String getDataFileSize() {
        return dataFileSize;
    }

    /**
     * @return
     */
    public String getID() {
        return ID;
    }
    /**
     * @return
     */
    public String getStockPeriod() {
        return stockPeriod;
    }
    
    public static String sec2min(String seconds){
        int second = Integer.parseInt(seconds);
        int minute = second / 60;
        String result = String.valueOf(minute);
        return result;        
    }
}