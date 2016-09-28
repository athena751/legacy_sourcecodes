/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import java.util.AbstractList;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;

public class STDataRender4Replica extends STAbstractRender implements ReplicationActionConst {
    private static final String cvsid = "@(#) $Id: STDataRender4Replica.java,v 1.12 2008/06/06 07:29:55 liul Exp $";
    private static String replicationBundle  = Globals.MESSAGES_KEY + "/replication";
    private static String volumeBundle = Globals.MESSAGES_KEY + "/volume";
    private static String interface_noBindings = "NoBindings";
    private static String repliDataMsgPrefix = "replication.info.replidata.";
    
    public String getCellRender(int rowIndex, String colName) throws Exception {
        if (colName.equals("connected")) {
            return "<td nowrap align=center>" + getCellContent(rowIndex, colName) + "</td>";     
        } else if (colName.equals("syncRate") || colName.equals("transInterface")) {
            return getCellContent(rowIndex, colName);     
        } 
        return "<td nowrap align=left>" + getCellContent(rowIndex, colName) + "</td>";
    }
    
    public String getCellContent(int rowIndex, String colName) throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        HttpServletRequest request = (HttpServletRequest) context.getRequest();
        AbstractList replicaInfoList = ((ListSTModel)getTableModel()).getDataList();
        ReplicaInfoBean replicaInfo = (ReplicaInfoBean)replicaInfoList.get(rowIndex);
        
        if (colName.equals("radio")) {
            StringBuffer cellStr = 
                    new StringBuffer("<input name=\"replicaRadio\" type=\"radio\" "
                                     + "onclick=\"onRadioClick(this.value);\" value=\"");
                                     
            cellStr.append(replicaInfo.getOriginalServer()).append("$");
            cellStr.append(replicaInfo.getFilesetName()).append("$");
            cellStr.append(replicaInfo.getConnected()).append("$");
            cellStr.append(replicaInfo.getSyncRate()).append("$");
            cellStr.append(replicaInfo.getTransInterface()).append("$");
            cellStr.append(replicaInfo.getReplicationData()).append("$");
            cellStr.append(replicaInfo.getMountPoint()).append("$");
            cellStr.append(replicaInfo.getHasShared()).append("$");
            cellStr.append(replicaInfo.getHasMounted()).append("$");
            cellStr.append(replicaInfo.getOriginalMP()).append("$");
            cellStr.append(replicaInfo.getOnceConnected()).append("$");
            cellStr.append(replicaInfo.getVolumeName()).append("$");
            cellStr.append(replicaInfo.getWpCode()).append("$");
            cellStr.append(replicaInfo.getSnapKeepLimit()).append("$");
            cellStr.append(replicaInfo.getRepliMethod()).append("$");
            cellStr.append(replicaInfo.getVolSyncInFileset()).append("$");

            
            String selectedReplica = (String)NSActionUtil.getSessionAttribute(request, SESSION_MOUNT_POINT);
            cellStr.append("\" ");
            if ((selectedReplica != null)
                 && selectedReplica.equals(replicaInfo.getMountPoint())) {
                cellStr.append("checked");
                NSActionUtil.setSessionAttribute(request, SESSION_MOUNT_POINT, null);          
            }
            
            if ((selectedReplica == null) && (rowIndex == 0)) {
                cellStr.append("checked");
            }
            
            cellStr.append(" id=\"replicaRadio" + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }
        
        if (colName.equals("originalServer")) {
            StringBuffer cellStr = new StringBuffer("<label for=\"replicaRadio" + rowIndex);
            cellStr.append("\">");
            cellStr.append(replicaInfo.getOriginalServer());
            cellStr.append("</lable>");
            return cellStr.toString();
        }

        if (colName.equals("connected")) {
           if (replicaInfo.getConnected().equals("yes")) {
               return TagUtils.getInstance().message(context, replicationBundle, null, "replica.connected.yes");
           } else {
               return TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.noSomething");
           }
        }        

        if (colName.equals("syncRate")) {
           String syncRate = replicaInfo.getSyncRate();
           if (syncRate.equals("-")) {
               String msg = TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.syncRate.error");
               return "<td nowrap align=center>" + msg + "</td>";      
           } else if  (syncRate.equals("stopped")){
               String msg = TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.syncRate.stopped");
               return "<td nowrap align=center>" + msg + "</td>";    	   
           } else if  (syncRate.equals(DLINE)){
               String msg = TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.noSomething");
               return "<td nowrap align=center>" + msg + "</td>"; 
           } else {
               return "<td nowrap align=right>" + syncRate + "</td>"; 
           }
        }
                
        if (colName.equals("transInterface")) {
           if (replicaInfo.getTransInterface().equals(interface_noBindings)) {
               String msg = TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.noSomething");
               return "<td nowrap align=center>" + msg + "</td>";         
           } else {
               return "<td nowrap align=left>" + replicaInfo.getTransInterface() + "</td>";    
           }
        }
        
        if (colName.equals("replicationData")) {
           StringBuffer keyStr = new StringBuffer(repliDataMsgPrefix);
           String key = (keyStr.append(replicaInfo.getReplicationData())).toString();
           return TagUtils.getInstance().message(context, replicationBundle, null, key);
        } 
        
        if (colName.equals("snapKeepLimit")) {
        	String msg =  "&nbsp;";
        	String snapKeepLimit = replicaInfo.getSnapKeepLimit();
        	if (!snapKeepLimit.equals("--")) {
        		msg =  "<img src=\"" + NSActionConst.PATH_OF_CHECKED_GIF + "\">";
                String args[] = new String[1];
                args[0] = snapKeepLimit;        		
        		msg += TagUtils.getInstance().message(context, replicationBundle, null, "replica.info.snapKeepLimit", args);
        	}
        	return msg;
         }        
        
        String msg = "&nbsp;";
        if (colName.equals("asyncStatus")) {
            if (replicaInfo.getAsyncStatus().equals("replica")) {
                if (replicaInfo.getErrCode().equals(VolumeActionConst.ASYNC_NO_ERROR)) {
                    msg = TagUtils.getInstance().message(context, volumeBundle, null, "async.create");    
                } else {
                    msg = TagUtils.getInstance().message(context, volumeBundle, null, "async.create.error");
                }
            }
            return msg;
        }
        
        if (colName.equals("errCode")) {
            if (!replicaInfo.getErrCode().equals("0x00000000")) {
                msg = replicaInfo.getErrCode();
            }
            return msg;
        } 
        
        if (colName.equals("confirmDel")) {
            if (!replicaInfo.getErrCode().equals("0x00000000")) {
                String btnMsg = TagUtils.getInstance().message(context, volumeBundle, null, "async.delBtn");
                String filesetName = replicaInfo.getFilesetName();
                String volName = replicaInfo.getVolumeName();
                msg = "<input name=\"confirmDelBtn\" type=\"button\" " 
                        + "onclick=\"onDelAsyncVol(\'" + filesetName +"\',\'" +  volName + "\');\" "
                        + "value=\""+ btnMsg + "\">";
            }
            return msg;
        }        
        
        return "";
        
    }
}