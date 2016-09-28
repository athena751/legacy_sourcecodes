/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.replication;

import java.util.List;
import java.util.Vector;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

/**
 *
 */
public class ReplicaHandler {
    public static final String cvsid =
        "@(#) $Id: ReplicaHandler.java,v 1.9 2008/10/09 09:49:44 chenb Exp $";
    private static ReplicaHandler instance = null;
    public static final String HOME_DIR = "/home/nsadmin";
    public static final String SUDO = "sudo";
    public static final String SCRIPT_REPLICATION_USEEXISTVOLUME4REPLICA_PL =
        "/bin/replication_initExistVolume4Replica.pl";
    public static final String SCRIPT_REPLICATION_CREATEREPLICA_PL =
        "/bin/replication_createReplica.pl";
    public static final String SCRIPT_REPLICATION_MODIFYREPLICA_PL =
        "/bin/replication_modifyReplica.pl";
    public static final String SCRIPT_REPLICATION_GETINTERFACE_PL =
            "/bin/replication_getInterface.pl";
    public static final String SCRIPT_REPLICATION_GETFREEMP_PL =
                "/bin/replication_getFreeMP.pl";
    public static final String SCRIPT_REPLICATION_SETVOLUMESYNC_PL =
    	"/bin/replication_setVolumeSync.pl";
    
    // add by jiangfx, start            
    public static final String SCRIPT_REPLICATION_GETREPLICAINFO_PL = 
                                            "/bin/replication_getReplicaList.pl";
    public static final String SCRIPT_REPLICATION_DELETEREPLICA_PL = 
                                            "/bin/replication_deleteReplica.pl";
    public static final String SCRIPT_REPLICATION_PROMOTEREPLICA_PL = 
                                            "/bin/replication_promoteReplica.pl";
    public static final String SCRIPT_REPLICATION_CTRLINNODE_PL  = 
                                            "/bin/replication_ctrlInNode.pl";
    public static final String SCRIPT_REPLICATION_GETSSLSTATUS_PL  = 
                                            "/bin/replication_getSslStatus.pl";
    public static final String SCRIPT_REPLICATION_SETSSLSTATUS_PL = 
                                            "/bin/replication_setSslStatus.pl";
    // add by jiangfx, end
    
    /**
     * @return
     */
    public static ReplicaHandler getInstance() {
        if (instance == null) {
            instance = new ReplicaHandler();
        }
        return instance;
    }

    /**
     * @param nodeNum
     * @return
     */
    public Vector getInterfaceVec(int nodeNum) throws Exception {
        Vector vec = new Vector();
        String[] cmds= {SUDO , HOME_DIR+SCRIPT_REPLICATION_GETINTERFACE_PL};
        String[] stdout = exeCmd(cmds , nodeNum).getStdout();
        if(stdout.length != 0){
            vec.addAll(java.util.Arrays.asList(stdout));
        }
        return vec;
    }

    /**
     * @param nodeNum
     * @return
     */
    
    public List getFreeMP(int nodeNum , String export , String oriOrreplica) throws Exception {
        Vector vec = new Vector();
        String[] cmds= {SUDO , HOME_DIR+SCRIPT_REPLICATION_GETFREEMP_PL , export , oriOrreplica};
        String[] stdout = exeCmd(cmds , nodeNum).getStdout();
        return NSBeanUtil.createBeanList("com.nec.nsgui.model.entity.replication.MountPointBean", stdout);

    }

    /**rw -> ro , format 
     * @param string
     * @param format
     * @param nodeNum
     */
    public void useExsitVolume4Replica(String mp, boolean format, int nodeNum)
        throws Exception {
        String[] cmds =
            {
                SUDO,
                HOME_DIR + SCRIPT_REPLICATION_USEEXISTVOLUME4REPLICA_PL,
                mp,
                format ? "true" : "false" };
        exeCmd(cmds, nodeNum);
    }

    /**
     * @param replicaInfo
     * @param nodeNum
     */
    public void createReplic(ReplicaInfoBean info, int nodeNum)
        throws Exception {
    	// get snap-keep limit, set [--] as snap-keep limit if not specified 
    	String snapKeepLimit = "--";
        String useSnapkeep = info.getUseSnapKeep();
        if ((useSnapkeep != null) && useSnapkeep.equals("on")) {
        	snapKeepLimit = info.getSnapKeepLimit();
        }
        String[] cmds =
            {
                SUDO,
                HOME_DIR + SCRIPT_REPLICATION_CREATEREPLICA_PL,
                info.getOriginalServer(),
                info.getFilesetName(),
                info.getMountPoint(),
                info.getReplicationMode(),
                info.getReplicationData(),
                snapKeepLimit,
                info.getTransInterface()};
        exeCmd(cmds, nodeNum);
    }

    /**
     * @param volumeInfo
     * @param replicaInfo
     * @param nodeNum
     */
    public static final String REPLICATION_ASYNC_CREATEREPLICA_PL = 
                                            "/home/nsadmin/bin/replication_async_createreplica.pl";
    public void createVolAndReplica(VolumeInfoBean volumeInfo, ReplicaInfoBean replicaInfo, int nodeNum)
        throws Exception {
          
          // get option for creating volume 
          String diskOption, fsOption, mountOption, lvOption;
        
          lvOption = "name=" + volumeInfo.getVolumeName();

          String aid = volumeInfo.getAid();

          String[] poolNoArr = (volumeInfo.getPoolNo()).split(",");
          StringBuffer poolNoSb = new StringBuffer();
          poolNoSb.append(aid).append("(").append(poolNoArr[0]).append(")");
          for (int i = 1; i < poolNoArr.length; i++) {
              poolNoSb.append("#").append(aid).append("(").append(poolNoArr[i]).append(")");
          }

          float volSize = Float.parseFloat(volumeInfo.getCapacity());
          if (volumeInfo.getCapacityUnit().equals("TB")) {
              volSize = volSize * 1024;
          }
       
          diskOption = "poolno=" + poolNoSb.toString()
                     + ",volsz=" + Float.toString(volSize);

          if (volumeInfo.getReplication().booleanValue()) {
              fsOption =
                  "ftype="
                      + volumeInfo.getFsType()
                      + ",repli="
                      + volumeInfo.getReplicType();
          } else {
              fsOption = "ftype=" + volumeInfo.getFsType();
          }
        
          if(volumeInfo.getJournal().equals("expand")){
              fsOption = fsOption + ",journal=expand";
          }
        
          mountOption = "";
          if (volumeInfo.getReplicType() == null
              || !volumeInfo.getReplicType().equals("replic")) {
              mountOption = "snapshot=" + volumeInfo.getSnapshot();
          }
          if (volumeInfo.getQuota().booleanValue()) {
              mountOption = mountOption + ",quota=on";
          }
          if (!volumeInfo.getNoatime().booleanValue()) {//logic different
              mountOption = mountOption + ",noatime=on";
          }
        
          if (volumeInfo.getDmapi().booleanValue()) {
              mountOption = mountOption + ",dmapi=on";
          }
          mountOption = mountOption + ",useGfs=" + volumeInfo.getUseGfs();
          mountOption = mountOption + ",wpperiod=" + volumeInfo.getWpPeriod();

      	  // get snap-keep limit, set [--] as snap-keep limit if not specified 
      	  String snapKeepLimit = "--";
          String useSnapkeep = replicaInfo.getUseSnapKeep();
          if ((useSnapkeep != null) && useSnapkeep.equals("on")) {
          	snapKeepLimit = replicaInfo.getSnapKeepLimit();
          }          
          // get option for creating replica
          String replicaOption = replicaInfo.getOriginalServer() + ","
                                + replicaInfo.getFilesetName()+ ","
                                + replicaInfo.getMountPoint()+ ","
                                + replicaInfo.getReplicationMode()+ ","
                                + replicaInfo.getReplicationData()+ ","
                                + snapKeepLimit + ","
                                + replicaInfo.getTransInterface();
                        
          // execute command
          String[] cmds = {SUDO, REPLICATION_ASYNC_CREATEREPLICA_PL, 
                          "create",
                          "--do", diskOption,
                          "--fs", fsOption,
                          "--mo", mountOption,
                          "--lo", lvOption,
                          "--mp", volumeInfo.getMountPoint(),
                          "--replication", replicaOption};

        exeCmd(cmds, nodeNum);
    }

    /**
     * @param replicaInfo
     * @param nodeNum
     */
    public void modifyReplic(ReplicaInfoBean info, int nodeNum)
        throws Exception {
    	// get snap-keep limit, set [--] as snap-keep limit if not specified 
    	String snapKeepLimit = "--";
        String useSnapkeep = info.getUseSnapKeep();
        if ((useSnapkeep != null) && useSnapkeep.equals("on")) {
        	snapKeepLimit = info.getSnapKeepLimit();
        } 
        String[] cmds =
            {
                SUDO,
                HOME_DIR + SCRIPT_REPLICATION_MODIFYREPLICA_PL,
                info.getTransInterface(),
                info.getMountPoint(),
                info.getOriginalServer(),
                info.getReplicationData(),
                snapKeepLimit};
        exeCmd(cmds, nodeNum);
    }
    
    // add by jiangfx, begin
    public List getReplicaInfo(String exportGroup, int nodeNo) throws Exception {
        String[] cmds_getReplicaInfo = {SUDO, HOME_DIR + SCRIPT_REPLICATION_GETREPLICAINFO_PL, exportGroup, String.valueOf(nodeNo)};
        
        // execCmd(String[] cmds, int nodeNo, boolean errHandle, boolean doWhenMaintance)
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds_getReplicaInfo, nodeNo, true, true);
        String[]    stdout    = cmdResult.getStdout();
        return NSBeanUtil.createBeanList("com.nec.nsgui.model.entity.replication.ReplicaInfoBean", stdout);    
    }
    
    
    public static void delReplica(String mountPoint, int nodeNo) throws Exception {
        String[] cmds_delReplica = {SUDO, HOME_DIR + SCRIPT_REPLICATION_DELETEREPLICA_PL, mountPoint};
        CmdExecBase.execCmd(cmds_delReplica, nodeNo);
    }
    
    private static String CONST_REPLI_METHOD_FULL  = "FullFCL";
    private static String CONST_REPLI_METHOD_SPLIT = "SplitFCL";
    public static void promoteReplica(String mountPoint, String repliMethod, String hour, String minute, int nodeNo) throws Exception {
    	String chekptSchedule = "";
    	if (repliMethod.equals(CONST_REPLI_METHOD_SPLIT)) {
    		chekptSchedule = OriginalHandler.getSchedule(hour, minute);
    	}
        String[] cmds_promoteReplica = {SUDO, HOME_DIR + SCRIPT_REPLICATION_PROMOTEREPLICA_PL, mountPoint, chekptSchedule};
        CmdExecBase.execCmd(cmds_promoteReplica, nodeNo);
    } 

    public static void ctrlInNode(String operation, String replicaMP, String originalMP, int nodeNo) throws Exception {
        String[] cmds_ctrlInNode = {SUDO, HOME_DIR + SCRIPT_REPLICATION_CTRLINNODE_PL, operation, replicaMP, originalMP};
        CmdExecBase.execCmd(cmds_ctrlInNode, nodeNo);        
    }
    
    public static void setVolumeSync(String replicaMP, String syncType, int nodeNo) throws Exception {
        String[] cmds_sync = {SUDO, HOME_DIR + SCRIPT_REPLICATION_SETVOLUMESYNC_PL, replicaMP, syncType};
        CmdExecBase.execCmd(cmds_sync, nodeNo);
    }
    
    public String getSslStatus(int nodeNo) throws Exception {
        String[] cmds_getSslStatus = {SUDO, HOME_DIR + SCRIPT_REPLICATION_GETSSLSTATUS_PL};
        
        NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds_getSslStatus, nodeNo, true);
        String[]    stdout    = cmdResult.getStdout();
        return stdout[0];        
    }
    
    public static void setSslStatus(String status, int nodeNo) throws Exception {
        String[] cmds_getSslStatus = {SUDO, HOME_DIR + SCRIPT_REPLICATION_SETSSLSTATUS_PL, status};
        CmdExecBase.execCmd(cmds_getSslStatus, nodeNo);        
    }
    // add by jiangfx, end
    
    private static String SCRIPT_REPLICATION_CHECK_VOL_SYNC_IN_FILESET_PL 
    	                          = "/opt/nec/nsadmin/bin/replication_checkVolSyncInFileset.pl";
    public static void checkVolSyncInFileset(String originalServer, String filesetName, String showNoOriErr, int nodeNo) throws Exception {
        String[] cmds_checkSyncVol = {SUDO, SCRIPT_REPLICATION_CHECK_VOL_SYNC_IN_FILESET_PL,
        		                      originalServer, 
        		                      filesetName,
        		                      showNoOriErr};
        
        CmdExecBase.execCmd(cmds_checkSyncVol, nodeNo);
    }
    /**
     * @param cmds
     * @return
     * @throws Exception
    */
    protected NSCmdResult exeCmd(String[] cmds, int nodeNum) throws Exception {
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNum);
        return cmdResult;
    }
    
    
}
