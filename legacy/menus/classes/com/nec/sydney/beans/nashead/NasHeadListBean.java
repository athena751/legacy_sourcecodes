/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package    com.nec.sydney.beans.nashead;


import com.nec.nsgui.action.base.NSActionUtil;
import     com.nec.sydney.framework.*;
import     com.nec.sydney.beans.base.*;
import     com.nec.sydney.atom.admin.nashead.*;
import java.util.*;


public class NasHeadListBean extends TemplateBean implements NasHeadConstants {

    private static final String     cvsid = "@(#) NasHeadListBean.java,v 1.4 2004/11/12 03:48:44 liuyq Exp";
    private Vector storageVec = new Vector();
    private Vector lunVec = new Vector();
    private boolean getddmapSuccess = true;
    private String wwnn = "";
    private String storageName = "";
    private String checkedWwnn = "";
    private String checkedModel = "";
    
    public void onDelete() throws Exception {
        String devicepath = request.getParameter("selectedLun");
        String wwnn = request.getParameter("wwnn");
        //String node0Url = Soap4Cluster.makeTargetN(super.target, 0);
               
        try {
            NasHeadSOAPClient.deleteLUN(devicepath, target);
        } catch (NSException e) {
            int error_code = e.getErrorCode();

            switch (error_code) {
            case CONSTANT_LDCONF_NOT_EXIST_FOR_DELETE:
                // conf file not exist or the lun's device path has been delete from the file
                super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session,
                                "common/alert/failed")
                                        + "\\r\\n"
                                        + NSMessageDriver.getInstance().getMessage(session,
                                                "nas_nashead/alert/hasdelete"));
                break;

            case CONSTANT_FAILED_TO_RUN_LDHARDLN_1:
                // failed to delete in self
                super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session, 
                                "common/alert/failed")
                                        + "\\r\\n"
                                        + NSMessageDriver.getInstance().getMessage(session, 
                                                "nas_nashead/alert/faileddeletelun1"));
                break;

            case CONSTANT_FAILED_TO_RUN_LDHARDLN_2:
                // maintain status
                super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session, 
                                "common/alert/failed")
                                        + "\\r\\n"
                                        + NSMessageDriver.getInstance().getMessage(session, 
                                                "nas_nashead/alert/faileddeletelun2"));
                break;

            default:
                throw e;
            }
            super.setRedirectUrl(
                    "../nas/nashead/ldlistmid.jsp?operation=getLunList&needScan=yes&wwnn="
                            + wwnn);
            return;
        }
        
        super.setMsg(
                NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.setRedirectUrl(
                "../nas/nashead/ldlistmid.jsp?operation=getLunList&needScan=yes&wwnn=" + wwnn);
        
    }
    
    public void onDisplay() throws Exception {
        try {
            storageVec = NasHeadSOAPClient.getStorageList(super.target);
            sortStorageList();
            setCheckedWwnn();
        } catch (NSException e) {
            if (e.getErrorCode() == CONSTANT_GETDDMAP_FAILED) {
                this.getddmapSuccess = false;
                return;
            } else {
                throw e;
            }
        }
    }
    
    public void onGetLunList() throws Exception {
        wwnn = request.getParameter("wwnn");
        String needScan = request.getParameter("needScan");
        //String node0Url = Soap4Cluster.makeTargetN(super.target, 0);
        session.setAttribute(SESSION_NAME_WWNN, wwnn);
		boolean isNsview = NSActionUtil.isNsview(request);
        try {
            storageName = NasHeadSOAPClient.getStorageName(wwnn, target);
            lunVec = NasHeadSOAPClient.getLunList(target, wwnn, needScan, isNsview);
        } catch (NSException e) {
            if (e.getErrorCode() == CONSTANT_GETDDMAP_FAILED) {
                this.getddmapSuccess = false;
                return;
            } else {
                throw e;
            }

        }
        
    }
    
    public Vector getLunList() throws Exception {
        return this.lunVec;
    }
    
    private void setCheckedWwnn(){
        String wwnnInSession = (String)session.getAttribute(SESSION_NAME_WWNN);
        if(wwnnInSession == null){
            wwnnInSession = "";
        }
        int storageNumber = storageVec.size();
        checkedWwnn = "";
        checkedModel = "";
        for(int i = 0; i < storageNumber; i++){
            StorageInfo storage = (StorageInfo)storageVec.get(i);
            if(i == 0){
                checkedWwnn = storage.getWwnn();
                checkedModel = storage.getModel();
                continue;
            }
            if(storage.getWwnn().equals(wwnnInSession)){
                checkedWwnn = storage.getWwnn();
                checkedModel = storage.getModel();
                break;
            }
        }
    }

    public String getCheckedWwnn(){
        return this.checkedWwnn;
    }
    public String getCheckedModel(){
        return this.checkedModel;
    }
    public Vector getStorageList() throws Exception {
        return this.storageVec;
    }

    private void sortStorageList() throws Exception {
        Comparator c = new Comparator() {
            public int compare(Object o1, Object o2) {
                String wwnn1 = ((StorageInfo) o1).getWwnn();
                String wwnn2 = ((StorageInfo) o2).getWwnn();

                return wwnn1.compareTo(wwnn2);
            }
        };

        Collections.sort(storageVec, c);
    }    

    public boolean getGetddmapSuccess() throws Exception {
        return getddmapSuccess;
    }
    
    public String getWwnn() throws Exception {
        return this.wwnn;
    }
    
    public String getStorageName() throws Exception {
        return this.storageName;
    }
    
}
