/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 
 
package    com.nec.sydney.atom.admin.nashead;

import com.nec.sydney.net.soap.*;
import java.util.*;
public class StorageInfo extends SoapResponse{
    private static final String     cvsid = "@(#) $Id: StorageInfo.java,v 1.1 2004/06/02 12:12:34 liq Exp $";
    String wwnn="";
    String storageName="";
    String model="";
    
    public StorageInfo(){}
    
    public String getWwnn(){
        return this.wwnn;
    }
    public String getStorageName(){
        return this.storageName;
    }
    public String getModel(){
        return this.model;
    }
    
    public void setWwnn(String wwnn){
        this.wwnn = wwnn;
    }
    public void setStorageName(String storageName){
        this.storageName =storageName;
    }
    public void setModel(String model){
        this.model =model;
    }   
}
