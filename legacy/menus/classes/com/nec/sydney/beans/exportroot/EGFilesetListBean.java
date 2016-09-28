/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.exportroot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.nsgui.action.base.*;
import java.util.*; 

/******************************************
 * added by liyb ,   used to  get fileset list   20051010
 ******************************************/
import com.nec.nsgui.model.biz.replication.*;
import com.nec.nsgui.model.entity.replication.*;


/****************************************************************

* this program is designed for the ExportGroup to display replication*     

* fileset infomation.                                               *

*******************************************************************/

public class EGFilesetListBean extends TemplateBean implements EGConstants{
    private static final String     cvsid = "@(#) $Id: EGFilesetListBean.java,v 1.2304 2005/12/01 02:18:37 liyb Exp $";

    private String                  filesetType;
    private String                  codePage;
    private List                    filesetList;
    private static final Integer    GET_EXPORT = new Integer(1);
    private static final Integer    GET_IMPORT = new Integer(2);
        
    public void onDisplay() throws Exception{
      
       String strMountPoint = (String)request.getParameter(MP_SELECT_MOUNTPOINT_NAME);
       String exportRoot    = (String)session.getAttribute(SESSION_EXPORT_ROOT);
     
       codePage = request.getParameter("codepage");
                
       filesetType = request.getParameter(EG_REQUEST_FILESETTYPE);
        
  /*************************************************
   * begin to get filesetlist   added by liyb 20051010  MP_SELECT__MOUNTPOINT_NAME
   ************************************************/ 
        int iNode = NSActionUtil.getCurrentNodeNo(request);    
        String path;
        if(filesetType.equals("import")){
            ReplicaHandler replicaHandler = new ReplicaHandler();
            List replicaList = replicaHandler.getReplicaInfo(exportRoot, iNode);
            
            filesetList=replicaList;
            ReplicaInfoBean repli=new ReplicaInfoBean();
//index of list
            int i = (replicaList==null||replicaList.isEmpty())? 0 : replicaList.size();
            while(i>0){
                i--;
                repli = (ReplicaInfoBean)replicaList.get(i);
                path = repli.getMountPoint(); 
                
                if(!path.equals(strMountPoint)){    
                    filesetList.remove(i);
                }
            }
            
        }else{
            List originalList = OriginalHandler.getOriginalList(iNode, exportRoot);
            
            filesetList=originalList;
            OriginalBean ori=new OriginalBean();
            
//index of list
            int i = (originalList==null||originalList.isEmpty())? 0 : originalList.size();
            while(i>0){
                i--;
                ori = (OriginalBean)originalList.get(i);
                path = ori.getMountPoint(); 
                
                if(!path.equals(strMountPoint)){
                    filesetList.remove(i);
                }
            }
            
        }
        
   }
    
    public String getMountPoint(){
        String mountPointName = (String)request.getParameter(MP_SELECT_MOUNTPOINT_NAME);
        return mountPointName;        
    }
    
    public String getCodePage(){
        return this.codePage;
    }
    
    public List getFilesetList(){        
        return this.filesetList;
    }
    public String getFilesetType(){
        return this.filesetType;
    }
}