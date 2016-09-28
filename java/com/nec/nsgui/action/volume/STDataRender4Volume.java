/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.AbstractList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

public class STDataRender4Volume extends STAbstractRender implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: STDataRender4Volume.java,v 1.22 2007/07/06 08:59:33 xingyh Exp $";
    
    public static String volumeBundle = Globals.MESSAGES_KEY + "/volume";
     
    public String getCellRender(int rowIndex, String colName)
        throws Exception {
        if(colName.equals("quota") || colName.equals("noatime") || colName.equals("dmapi")|| colName.equals("mountStatus")){
            return "<td nowrap align=center>" + getCellContent(rowIndex, colName) + "</td>";
        }
        if(colName.equals("capacity") || colName.equals("fsSize") || colName.equals("useRate")){
            return "<td nowrap align=right>" + getCellContent(rowIndex, colName) + "</td>";
        }
        if(colName.equals("lunStorage") || colName.equals("pdgRank")){
            return "<td nowrap align=center>" + getCellContent(rowIndex, colName) + "</td>";
        }
        if (colName.equals("mountPoint")) {
            return getCellContent(rowIndex, colName);
        }

        return "<td nowrap>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)
        throws Exception {

        PageContext context = getSortTagInfo().getPageContext();
        AbstractList volumeList = ((ListSTModel) getTableModel()).getDataList();
        VolumeInfoBean volumeObj = (VolumeInfoBean) volumeList.get(rowIndex);

        if (colName.equals("radio")) {
            StringBuffer cellStr =
                new StringBuffer(
                    "<input name=\"volumeRadio\" type=\"radio\" "
                        + "onclick=\"onRadioClick(this.value);\" value=\"");
            cellStr.append(volumeObj.getVolumeName()).append("#");
            cellStr.append(volumeObj.getMountPoint()).append("#");
            cellStr.append(volumeObj.getCapacity()).append("#");
            cellStr.append(volumeObj.getQuota().toString()).append("#");
            cellStr.append(volumeObj.getNoatime().toString()).append("#");
            cellStr.append(volumeObj.getSnapshot()).append("#");
            cellStr.append(volumeObj.getAccessMode()).append("#");
            cellStr.append(volumeObj.getMountStatus()).append("#");
            cellStr.append(volumeObj.getReplication().toString()).append("#");
            cellStr.append(volumeObj.getReplicType()).append("#");
            cellStr.append(volumeObj.getNorecovery().toString()).append("#");
            cellStr.append(volumeObj.getDmapi().toString()).append("#");
            cellStr.append(volumeObj.getFsType()).append("#");
            cellStr.append(volumeObj.getUseRate()).append("#");
            cellStr.append(volumeObj.getUseGfs()).append("#");
            cellStr.append(volumeObj.getReplication4Show()).append("#");
            if (volumeObj.getMachineType().equals("NASHEAD")) {
                cellStr.append(volumeObj.getLun()).append("#"); 
                cellStr.append(volumeObj.getStorage()).append("#");     
            } else {
                cellStr.append(volumeObj.getRaidType()).append("#");
                cellStr.append(volumeObj.getPoolNameAndNo()).append("#");
                cellStr.append(volumeObj.getAid()).append("#");
                cellStr.append(volumeObj.getAname()).append("#");
                cellStr.append(volumeObj.getAsyncStatus()).append("#");
                cellStr.append(volumeObj.getErrCode()).append("#");                
            }
            cellStr.append(volumeObj.getUseCode()).append("#"); 
            cellStr.append(volumeObj.getFsSize()).append("#");
            cellStr.append(volumeObj.getWpPeriod()).append("#");
            
            String selectedVol =
                (String) context.getSession().getAttribute(VOLUME_INFO_VOLUME_NAME);
            cellStr.append("\" ");
            if (selectedVol != null
                && selectedVol.equals(volumeObj.getVolumeName())) {
                cellStr.append("checked");
                context.getSession().setAttribute(VOLUME_INFO_VOLUME_NAME,null);
            }
            if (selectedVol == null && rowIndex == 0) {
                cellStr.append("checked");
            }
            cellStr.append(" id=\"volumeRadio" + rowIndex);
            cellStr.append("\">");
            return cellStr.toString();
        }

        if (colName.equals("volumeName")) {
            StringBuffer cellStr =
                new StringBuffer("<label for=\"volumeRadio" + rowIndex);
            cellStr.append("\">");
            cellStr.append(
                volumeObj.getVolumeName().replaceFirst("NV_LVM_", ""));
            cellStr.append("</label>");
            return cellStr.toString();
        }
        
        if (colName.equals("mountPoint")) {
            String mp = volumeObj.getMountPoint();
            String mpShow = mp;
            if(mp.length() > 21){
                mpShow = mp.substring(0 , 21) + TagUtils.getInstance().message(context, volumeBundle, null,"button.dot");
            }
            return "<td nowrap title=\"" + mp +"\">" + mpShow + "</td>";
        }

        if (colName.equals("storage")) {
            return volumeObj.getStorage().replaceAll(",", "<br>");
        }

        if (colName.equals("lun")) {
            String[] luns = volumeObj.getLun().split(",");
            StringBuffer sb =
                new StringBuffer(luns[0])
                    .append("(")
                    .append(NSActionUtil.getHexString(4, luns[0]))
                    .append(")");
            for (int i = 1; i < luns.length; i++) {
                sb
                    .append("<br>")
                    .append(luns[i])
                    .append("(")
                    .append(NSActionUtil.getHexString(4, luns[i]))
                    .append(")");
            }
            return sb.toString();
        }
        
        if (colName.equals("lunStorage")) {
            return volumeObj.getLunStorage();
        }
        
        if (colName.equals("capacity")) {
            try{
                Double d = new Double(volumeObj.getCapacity()); 
                           return (new java.text.DecimalFormat("#,##0.0")).format(d);
            }catch(NumberFormatException e){
                return volumeObj.getCapacity();
            }
           
        }
        
        if (colName.equals("fsSize")) {
            try{
                Double d = new Double(volumeObj.getFsSize()); 
                           return (new java.text.DecimalFormat("#,##0.0")).format(d);
            }catch(NumberFormatException e){
                return volumeObj.getFsSize();
            }
   
        }
        
        if (colName.equals("useRate")) {
            return volumeObj.getUseRate();
        }

        String on = "<img src=\"" + NSActionConst.PATH_OF_CHECKED_GIF + "\">";
        String off = "&nbsp;";
        if (colName.equals("replication4Show")) {
            if (volumeObj.getReplication4Show().equals("--")) {
                return TagUtils.getInstance().message(context, volumeBundle, null, "info.off");
            }
            if (volumeObj.getReplication4Show().equals("notset")) {
                return TagUtils.getInstance().message(
                    context,
                    volumeBundle,
                    null,
                    "info.replication.notSet");
            }
            if (volumeObj.getReplication4Show().equals("original")) {
                return TagUtils.getInstance().message(
                    context,
                    volumeBundle,
                    null,
                    "info.replication.original");
            }
            return TagUtils.getInstance().message(
                context,
                volumeBundle,
                null,
                "info.replication.replic");
        }

        if (colName.equals("quota")) {
            if (volumeObj.getQuota() != null
                && volumeObj.getQuota().booleanValue()) {
                return on;
            }
            return off;
        }

        if (colName.equals("noatime")) {
            if (volumeObj.getNoatime() != null
                && volumeObj.getNoatime().booleanValue()) {
                return on;
            }
            return off;
        }
        
        if (colName.equals("dmapi")) {
            if (volumeObj.getDmapi() != null
                && volumeObj.getDmapi().booleanValue()) {
                return on;
            }
            return off;
        }
        
        if (colName.equals("accessMode")) {
            if (volumeObj.getAccessMode() != null
                && volumeObj.getAccessMode().equals("ro")) {
                return TagUtils.getInstance().message(context, volumeBundle, null, "info.access.ro");
            }
            return TagUtils.getInstance().message(context, volumeBundle, null, "info.access.rw");
        }
        
        if (colName.equals("mountStatus")) {
            if (volumeObj.getMountStatus() != null
                && volumeObj.getMountStatus().equals("mount")) {
                return on;
            }
            return off;
        }
        
        if (colName.equals("asyncStatus")) {
            String ret = off;
            if (volumeObj.getAsyncStatus() != null ) {
                if(volumeObj.getAsyncStatus().equals("create") || volumeObj.getAsyncStatus().equals("replica")) {
                    if (volumeObj.getErrCode().equals(ASYNC_NO_ERROR)) {
                        ret = TagUtils.getInstance().message(context, volumeBundle, null, "async.create");
                    } else {
                        ret = TagUtils.getInstance().message(context, volumeBundle, null, "async.create.error");
                    }
                }else if(volumeObj.getAsyncStatus().equals("extend")) {
                    if (volumeObj.getErrCode().equals(ASYNC_NO_ERROR)) {
                        ret = TagUtils.getInstance().message(context, volumeBundle, null, "async.extend");
                    } else {
                        ret = TagUtils.getInstance().message(context, volumeBundle, null, "async.extend.error");
                    }
                }
            }
            return ret;
        }
        if (colName.equals("errCode")) {
            String ret=off;
            if(!volumeObj.getErrCode().equals(ASYNC_NO_ERROR)) {
               ret=volumeObj.getErrCode();     
            }
            return ret;
        }
        if (colName.equals("button")) {
            String ret=off;
            if(!volumeObj.getErrCode().equals(ASYNC_NO_ERROR)) {
               String label = TagUtils.getInstance().message(context, volumeBundle, null, "async.delBtn");
               String volName = volumeObj.getVolumeName();
               ret="<input name=\"confirmDelBtn\" type=\"button\" onclick=\"onDelAsyncVol(\'"
                    + volName + "\');\" value=\"" + label + "\">";     
            }
            return ret;
        }

        return " ";
    }
}
