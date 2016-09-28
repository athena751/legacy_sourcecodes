/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 
 
package    com.nec.sydney.atom.admin.nashead;

public class UnlinkedLunInfo{
    private static final String     cvsid = "@(#) $Id: UnlinkedLunInfo.java,v 1.1 2004/11/22 02:02:46 xiaocx Exp $";
    String lun="";
    String wwnn="";
    String storageName="";
    
    public UnlinkedLunInfo(){}
    
    public String getLun(){
        return this.lun;
    }
    public String getWwnn(){
        return this.wwnn;
    }
    public String getStorageName(){
        return this.storageName;
    }
    
    public void setWwnn(String wwnn){
        this.wwnn = wwnn;
    }
    public void setStorageName(String storageName){
        this.storageName =storageName;
    }
    public void setLun(String lun){
        this.lun =lun;
    }
}
