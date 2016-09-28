/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.gfs;

import java.util.ArrayList;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.gfs.GfsLDInfoBean;
import com.nec.nsgui.model.entity.gfs.GfsVolumeInfoBean;

/**
 *
 */
public class GfsCmdHandler {
    private static final String cvsid
            = "@(#) $Id: GfsCmdHandler.java,v 1.4 2005/12/16 12:53:27 zhangjun Exp $";
    
    private static final String SCIRPT_GFS_GET_GFSFILE
            = "/bin/gfs_getFileContent.pl";
    private static final String SCIRPT_GFS_MODIFY_GFSFILE
            = "/bin/gfs_modifyFileContent.pl";
    private static final String SCIRPT_GFS_GET_VOLUME_INFOLIST
            = "/bin/gfs_getVolumeInfoList.pl";
    
    /**
     * get file content from the gfs file
     */
    public static String getGfsFile(int nodeNo) throws Exception {
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GFS_GET_GFSFILE};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return getFileContentFromArray(cmdResult.getStdout());
    }
    /**
     * modify the gfs file content
     */
    public static void modifyGfsFile(String fileContent,int nodeNo) throws Exception {
        String tempFileName = NFSModel.createTempFile(nodeNo, fileContent);
        if (tempFileName == null) {
            throw new Exception();
        }
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GFS_MODIFY_GFSFILE,
                tempFileName};
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    /**
     * get the volume list information
     */
    public static ArrayList getVolumeList(int nodeNo) throws Exception{
        String[] cmds = {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GFS_GET_VOLUME_INFOLIST
                };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return getVolumeListfromArray(cmdResult.getStdout());
    }
    
    /*
     * Private Function
     */
    private static ArrayList getVolumeListfromArray(String[] resultArray)throws Exception{
        ArrayList volumeInfoList = new ArrayList();
        for (int i = 0; i < resultArray.length; i++) {
            GfsVolumeInfoBean volumeObj = new GfsVolumeInfoBean();
            if(!resultArray[i].equals("")){
                String[] volumeInfo = resultArray[i].split("\\s+");
                volumeObj.setVolumeName(volumeInfo[0]);
                volumeObj.setVolumeSize(getCapacity4Show(volumeInfo[1]));
                volumeObj.setVolumeMountPoint(volumeInfo[2]);
                i ++;
                ArrayList deviceList = new ArrayList();
                while(i < resultArray.length){
                    if(!resultArray[i].equals("")){
                        GfsLDInfoBean ldObj = new GfsLDInfoBean();
                        String[] ldInfo = resultArray[i].split("\\s+");
                        ldObj.setDeviceName(ldInfo[0]);
                        ldObj.setDeviceLun(ldInfo[1]);
                        ldObj.setDeviceWwnn(ldInfo[2]);
                        ldObj.setDeviceSize(ldInfo[3]);
                        ldObj.setGfsType(ldInfo[4]);
                        //add by zhangjun
                        ldObj.setSerialNo(ldInfo[5]);
                        deviceList.add(ldObj);
                        i ++;
                    }else {
                        break;
                    }
                }
                volumeObj.setDeviceList(deviceList);
                volumeInfoList.add(volumeObj); 
            }
        }
        return volumeInfoList;
    }
    private static String getCapacity4Show(String capacity){
        try{
            Double d = new Double(capacity); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        }catch(NumberFormatException e){
            return capacity;
        }
    }
    private static String getFileContentFromArray(String[] fileContentArray) throws Exception{
        int fileLength = fileContentArray.length;
        StringBuffer strBuf = new StringBuffer();
        if(fileLength==0){
            return "";
        }
        if(fileContentArray[0].equals("")){
            strBuf.append("\n");
        }
        strBuf.append(fileContentArray[0]);
        for( int i=1; i<fileLength; i++ ){
            strBuf.append("\n");
            strBuf.append(fileContentArray[i]);
        }
        return strBuf.toString();
    }
}
