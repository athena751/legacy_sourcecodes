/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.nashead;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.NSUtil;
import com.nec.sydney.atom.admin.nashead.NasHeadConstants;
import com.nec.sydney.beans.base.TemplateBean;

 
public class NasHeadModifyStorageNameBean extends TemplateBean implements NasHeadConstants{
    private static final String     cvsid = "@(#) NasHeadModifyStorageNameBean.java,v 1.3 2004/11/12 03:49:43 liuyq Exp";
    private String wwnn;
    private String model;
    private String storageName;
    
    public void onDisplay() throws Exception{
        //String node0Url = Soap4Cluster.makeTargetN(super.target, 0);
        session.setAttribute(SESSION_NAME_WWNN, wwnn);
        storageName = NasHeadSOAPClient.getStorageName(wwnn, target);
    }
    public void onSet () throws Exception{
        
        try{
            //String node0Url = Soap4Cluster.makeTargetN(super.target, 0);
            String storageNameForWrite = "";
            if(storageName != null && !storageName.equals("")){
                storageNameForWrite = NSUtil.reqStr2EncodeStr(storageName, BROWSER_ENCODE);
            }
            NasHeadSOAPClient.setStorageName(wwnn, storageNameForWrite, target);
        }catch(NSException e){
            int error_code = e.getErrorCode();
            switch(error_code){
                case STORAGE_NAME_EXIST_EXCEPTION:
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
    			            + NSMessageDriver.getInstance().getMessage(session, "nas_nashead/alert/storageNameExist"));
                    break;
                default:
                    throw e;
            }
            super.setRedirectUrl("../nas/nashead/ldModifyStorageName.jsp?operation=display&wwnn=" + wwnn + "&model=" + model);
            return;
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.setRedirectUrl("../nas/nashead/ldlist.jsp");
    }
    
    public void setWwnn(String wwnn){
        this.wwnn = wwnn;
    }
    
    public String getWwnn(){
        return this.wwnn;
    }
    
    public void setModel(String model){
        this.model = model;
    }

    public String getModel(){
        return this.model;
    }
    
    public void setStorageName(String storageName){
        this.storageName = storageName;
    }
    
    public String getStorageName(){
        return this.storageName;
    }
    
}
 