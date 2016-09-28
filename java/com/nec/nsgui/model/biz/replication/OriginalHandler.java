/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.replication;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.*;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.replication.OriginalBean;
import com.nec.nsgui.model.entity.replication.MountPointBean;
import java.util.*;

/**
 *
 */
public class OriginalHandler {
    public static final String cvsid =
        "@(#) $Id: OriginalHandler.java,v 1.6 2008/06/17 06:49:42 liy Exp $";
    private static final String PERLFILE_GETORILIST =
        "/bin/replication_getOriginalList.pl";
    //  private static final String     PERLFILE_GETINTERFACE = "/bin/replication_getInterface.pl";
    private static final String PERLFILE_CREATEORI =
        "/bin/replication_createOriginal.pl";
    private static final String PERLFILE_DETETEORI =
        "/bin/replication_deleteOriginal.pl";
    private static final String PERLFILE_MODIFYORI =
        "/bin/replication_modifyOriginal.pl";
    private static final String PERLFILE_DEMOTEORI =
        "/bin/replication_demoteOriginal.pl";
    private static final String CONST_REPLI_METHOD_SPLIT =
    	"SplitFCL";
    public static List getOriginalList(int node, String exportgroup)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + PERLFILE_GETORILIST,
                exportgroup ,String.valueOf(node)};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, node, true, true);
        String[] results = cmdResult.getStdout();
        List oriList = new ArrayList();
        oriList =
            NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.replication.OriginalBean",
                results);

        return oriList;

    }

    public static List getFreeMP(
        int node,
        String exportgroup,
        String strCodePage)
        throws Exception {

        ReplicaHandler repliHandler = ReplicaHandler.getInstance();

        //get mountpointList ----but those moutpoint has no mountPointLast property
        List mpList = repliHandler.getFreeMP(node, exportgroup, "original");

        int iCount = mpList.size();

        //get new moutpointList with the property-mountPointLast
        for (int i = 0; i < iCount; i++) {
            MountPointBean mp = (MountPointBean) (mpList.get(i));
            String strMP = mp.getMountPoint();
            
            strMP=strMP.replaceFirst(exportgroup+"/", "");
            mp.setMountPointLast(strMP);

            String strFstype = mp.getFsType();
            if (strFstype.equals("sxfsfw")) {
                mp.setFsType("sxfsfw#" + strCodePage);
            }

        }

        return mpList;
    }

    //create original
    public static void create(int node, OriginalBean originalvalue)
        throws Exception {
    	String tempFileName = NFSModel.createTempFile(node, originalvalue.getReplicaHost());
        if (tempFileName == null) {
            throw new Exception("Failed to create tempfile in creating original.");
        }
        
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + PERLFILE_CREATEORI,
                originalvalue.getFilesetName(),
                originalvalue.getTransInterface(),
                originalvalue.getBandWidth(),
                originalvalue.getMountPoint(),
                tempFileName,
				getSchedule(originalvalue.getHour(),originalvalue.getMinute())
            	};
        CmdExecBase.execCmd(cmds, node);
    }
    
    // modify Original
    public static void modify(int node, OriginalBean originalvalue, String convert)
        throws Exception {
    	String tempFileName = NFSModel.createTempFile(node, originalvalue.getReplicaHost());
        if (tempFileName == null) {
            throw new Exception("Failed to create tempfile in modifing original.");
        }
        String schedule = "";
        if(originalvalue.getRepliMethod().equals(CONST_REPLI_METHOD_SPLIT) || convert.equals("on")){
        	schedule = OriginalHandler.getSchedule(originalvalue.getHour(),originalvalue.getMinute());
        }
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + PERLFILE_MODIFYORI,
                originalvalue.getFilesetName(),
                originalvalue.getTransInterface(),
                originalvalue.getBandWidth(),
                originalvalue.getMountPoint(),
                tempFileName,
				schedule,
                convert
                };
        CmdExecBase.execCmd(cmds, node);

    }
    
    //demote original
    public static void demote(int node, OriginalBean originalvalue) throws Exception {

        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + PERLFILE_DEMOTEORI,
                originalvalue.getFilesetName(),
                originalvalue.getMountPoint()
                };

        CmdExecBase.execCmd(cmds, node);
    }
    //delete original
    public static void delete(int node, OriginalBean originalvalue) throws Exception {

        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + PERLFILE_DETETEORI,
                originalvalue.getFilesetName(), 
                originalvalue.getMountPoint()
                };

        CmdExecBase.execCmd(cmds, node);
    }
    public static String getSchedule(String hour, String minute){
    	return minute + " " + hour + " * * *";
    }

}
