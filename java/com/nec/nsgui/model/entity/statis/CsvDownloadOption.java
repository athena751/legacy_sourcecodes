/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 *
 */
public class CsvDownloadOption {
    private static final String cvsid =
               "@(#) $Id: CsvDownloadOption.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String displayFSType="device"; //display device or mountpoint.
    private String allOrSelected; //store the selected radio button's value
    private String[] selectedResources=new String[0]; //  store the selected resources 
    private String[] itemList= new String[0]; //   store the selected items
    private String tmpCsvFileName;
    private String csvdownloadMsg; //the error message

 


    /**
     * @return
     */
    public String getAllOrSelected() {
        return allOrSelected;
    }

    /**
     * @return
     */
    public String getCsvdownloadMsg() {
        return csvdownloadMsg;
    }

    /**
     * @return
     */
    public String getDisplayFSType() {
        return displayFSType;
    }

    /**
     * @return
     */
    public String[] getItemList() {
        return itemList;
    }

    /**
     * @return
     */
    public String[] getSelectedResources() {
        return selectedResources;
    }

    /**
     * @return
     */
    public String getTmpCsvFileName() {
        return tmpCsvFileName;
    }

    
    /**
     * @param string
     */
    public void setAllOrSelected(String string) {
        allOrSelected = string;
    }

    /**
     * @param string
     */
    public void setCsvdownloadMsg(String string) {
        csvdownloadMsg = string;
    }

    /**
     * @param string
     */
    public void setDisplayFSType(String string) {
        displayFSType = string;
    }

    /**
     * @param strings
     */
    public void setItemList(String[] strings) {
        itemList = strings;
    }

    /**
     * @param strings
     */
    public void setSelectedResources(String[] strings) {
        selectedResources = strings;
    }

    /**
     * @param string
     */
    public void setTmpCsvFileName(String string) {
        tmpCsvFileName = string;
    }

   
}
