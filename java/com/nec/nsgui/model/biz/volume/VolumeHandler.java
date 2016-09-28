/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.volume;

import java.util.*;

import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.volume.DiskArrayInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.entity.volume.LunInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoConfirmBean;
import com.nec.nsgui.model.entity.volume.VolumeAvailableNumberBean;
import com.nec.nsgui.model.biz.framework.ControllerModel;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.entity.framework.NodeInfoBean;


/**
 * @author yttx
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class VolumeHandler {
    
    public static final String cvsid =
        "@(#) $Id: VolumeHandler.java,v 1.36 2008/05/24 12:14:39 liuyq Exp $";

    public static String NAS_FSBATCH_PL = "/home/nsadmin/bin/nas_fsbatch.pl";
    public static String VOLUME_CHANGE_PL =
        "/home/nsadmin/bin/volume_modify.pl";
    public static String VOLUME_GETWWNNORLUN_PL =
        "/home/nsadmin/bin/volume_getwwnnorluninfo.pl";
    public static String VOLUME_GETPDGANDRANK_PL =
        "/home/nsadmin/bin/volume_getavailpdgandrankinfo.pl";
    public static String VOLUME_GETDISKARRAYINFO_PL =
        "/home/nsadmin/bin/volume_getdiskarrayinfo.pl";
    public static String VOLUME_LIST_PL = "/home/nsadmin/bin/volume_list.pl";
    public static String VOLUME_GETAVAILPOOL_PL = "/home/nsadmin/bin/volume_getavailpool.pl";
    
    public static String VOLUME_GETPDGMODEL_PL =
        "/home/nsadmin/bin/volume_getpdgmodel.pl";
    public static String STATIS_DELETERRDFILE_PL =
        "/home/nsadmin/bin/statis_deleteRRDFile.pl";
    public static String VOLUME_CANSETDMAPI_PL =
        "/home/nsadmin/bin/volume_cansetdmapi.pl";
    public static String VOLUME_HASASYNC_PL =
        "/home/nsadmin/bin/volume_hasasync.pl";
    public static String VOLUME_FSBATCH_ASYNC_PL =
        "/home/nsadmin/bin/volume_fsbatch_async.pl";
    public static String VOLUME_DEL_ASYNC_FILE_PL =
        "/home/nsadmin/bin/volume_delasyncfile.pl";
    public static String VOLUME_GET_POOL_PD_TYPE="/home/nsadmin/bin/volume_getpoolpdtype.pl";
    
    public static String VOLUME_CHKSYCNFS_PL="/opt/nec/nsadmin/bin/volume_isSycnFS.pl";
      
    private static String VOLUME_GETUSEDVOLUMENAMES_PL = "/home/nsadmin/bin/volume_getUsedVolumeNames.pl";
    private static String VOLUME_GETUSEDMPNAMES_PL = "/home/nsadmin/bin/volume_getallmp.pl";
    private static String VOLUME_CHECKMP_PL = "/home/nsadmin/bin/volume_mpcheck.pl";
    private static String VOLUME_MP_BASE_EXIST_PL = "/home/nsadmin/bin/volume_isbasempexist.pl";
    private static String VOLUME_GETPAIREDLDDEVS_PL = "/opt/nec/nsadmin/bin/volume_getpairedlddevs.pl";
    private static String VOLUME_MP_CORRECT = "0";
    private static String VOLUME_MP_FSTYPE_ERR = "1";
    private static String VOLUME_MP_PARENT_UMOUNT = "2";
    private static String VOLUME_MP_PARENT_RO = "3";
    private static String VOLUME_MP_HAS_REPLI = "4";
    private static String VOLUME_MP_SUB_EXIST = "5";
    private static final String PREFIX_RAID6 = "6"; // when raid6, the value of volumeInfo.getRaidType() is "64" or "68"
    
    private static String VOLUME_NAME_PREFIX = "NV_LVM_";
    /// add by liuyq in 2004.07.30 start
    public static void addVolume(VolumeInfoBean volumeInfo, int nodeNo, boolean fromBatch,boolean isSSeries)
        throws Exception {
        String createFsCmd = NAS_FSBATCH_PL;
        String diskOption, fsOption, mountOption, lvOption;
        
        lvOption = "name=" + volumeInfo.getVolumeName();
        if (volumeInfo.getMachineType().equals("NV")) {
            if(isSSeries &&(!fromBatch)) {
                createFsCmd = VOLUME_FSBATCH_ASYNC_PL;
            }
            
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
            if(!isSSeries){
                      diskOption = diskOption + ",bltime=" + volumeInfo.getBltime();
            }
        } else {
            diskOption = "lunlist=" + volumeInfo.getWwnn();
            lvOption = lvOption + ",striped=" + volumeInfo.getStriping();
        }

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
        mountOption = mountOption + ",useGfs=" + volumeInfo.getUseGfs()
                        + ",wpperiod=" + volumeInfo.getWpPeriod();
        
        String[] cmds = {
        };
        if (mountOption.equals("")) {
            cmds =
                new String[] {
                    "sudo",
                    createFsCmd,
                    "create",
                    "--do",
                    diskOption,
                    "--fs",
                    fsOption,
                    "--lo",
                    lvOption,
                    "--mp",
                    volumeInfo.getMountPoint()};
        } else {
            cmds =
                new String[] {
                    "sudo",
                    createFsCmd,
                    "create",
                    "--do",
                    diskOption,
                    "--fs",
                    fsOption,
                    "--mo",
                    mountOption,
                    "--lo",
                    lvOption,
                    "--mp",
                    volumeInfo.getMountPoint()};
        }
        CmdExecBase.execCmd(cmds, nodeNo);
    }
   
    public static void extendVolume(
        VolumeInfoBean volumeInfo,
        boolean isNashead,
        int nodeNo, boolean isCallisto)
        throws Exception {
        String extendFsCmd = NAS_FSBATCH_PL;
       
        String mp = volumeInfo.getMountPoint();

        String diskOption;
        if (isNashead) {
            diskOption = "lunlist=" + volumeInfo.getWwnn();
        } else {
            if(isCallisto &&(!volumeInfo.getRaidType().startsWith(PREFIX_RAID6))) {
                extendFsCmd = VOLUME_FSBATCH_ASYNC_PL;
            }
            String[] aidArr = volumeInfo.getAid().split(",");
            String aid = aidArr[0];

            String[] poolNoArr = (volumeInfo.getPoolNo()).split(",");
            StringBuffer poolNoSb = new StringBuffer();
            poolNoSb.append(aid).append("(").append(poolNoArr[0]).append(")");
            for (int i = 1; i < poolNoArr.length; i++) {
                poolNoSb.append("#").append(aid).append("(").append(poolNoArr[i]).append(")");
            } 
            
            float extendSize = Float.parseFloat(volumeInfo.getExtendSize());
            if (volumeInfo.getCapacityUnit().equals("TB")) {
                extendSize = extendSize * 1024;
            }
            
            diskOption = "poolno=" + poolNoSb.toString()
                       + ",volsz=" + Float.toString(extendSize);
            if(!isCallisto){
                diskOption = diskOption + ",bltime=" + volumeInfo.getBltime();
            }
        }
        String lvOption = "striped=" + volumeInfo.getStriping();
        String[] cmds =
            { "sudo", extendFsCmd, "extend", "--do", diskOption, "--lv", lvOption, "--mp", mp };
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static void delVolume(String mp, int nodeNo) throws Exception {
        String nas_fsbatch = NAS_FSBATCH_PL;
        String[] cmds = { "sudo", nas_fsbatch, "delete", "--mp", mp };
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static void modifyVolume(VolumeInfoBean volumeInfo , int nodeNo)
        throws Exception {
        String modify_cmd = VOLUME_CHANGE_PL;
        String mountOption;
        mountOption = "access=" + volumeInfo.getAccessMode();
        if(volumeInfo.getReplication().booleanValue()){
            mountOption = mountOption + ",repli=on";
        }
        
        if(volumeInfo.getQuota().booleanValue()){
            mountOption = mountOption + ",quota=on";
        }
        
        if(!volumeInfo.getNoatime().booleanValue()){//note:logic different
            mountOption = mountOption + ",noatime=on";
        }
        
        if(volumeInfo.getDmapi().booleanValue()){
            mountOption = mountOption + ",dmapi=on";
        }
        
        if(volumeInfo.getNorecovery().booleanValue()){
            mountOption = mountOption + ",norecovery=on";
        }
        
        if(volumeInfo.getAccessMode().equals("rw")){
            mountOption = mountOption + ",snapshot=" +  volumeInfo.getSnapshot();
        }
        
        mountOption = mountOption + ",usegfs=" + volumeInfo.getUseGfs()
                         + ",wpperiod=" + volumeInfo.getWpPeriod();
        
        String[] cmds =
            { "sudo", modify_cmd, "modify", "--mo", mountOption, "--mp", volumeInfo.getMountPoint()};
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static void umountVolume(String mp, int nodeNo) throws Exception {
        String modify_cmd = VOLUME_CHANGE_PL;
        String[] cmds = { "sudo", modify_cmd, "umount", "--mp", mp };
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static void mountVolume(String mp, int nodeNo) throws Exception {
        String modify_cmd = VOLUME_CHANGE_PL;
        String[] cmds = { "sudo", modify_cmd, "mount", "--mp", mp };
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static Vector getAvailLunInfo(String usage) throws Exception {
        Vector disks = new Vector();
        String cmd_lun = VOLUME_GETWWNNORLUN_PL;
        String[] cmds = { "sudo", cmd_lun, usage, "lun" };
        NSCmdResult result = CmdExecBase.execCmd(cmds);
        String[] availLuns = result.getStdout();
        for (int i = 0; i < availLuns.length; i++) {
            String infoStr =
                NSModelUtil.perl2Page(availLuns[i], NSModelUtil.EUC_JP);
            String[] infos = infoStr.split("\\s+");
            //storage wwnn 32 /dev/ld16 0.9
            LunInfoBean lunInfo = new LunInfoBean();
            lunInfo.setStorage(infos[0]);
            lunInfo.setWwnn(infos[1]);
            lunInfo.setLun(infos[2]);
            lunInfo.setLdPath(infos[3]);
            lunInfo.setSize(infos[4]);
            disks.add(lunInfo);
        }
        
        return disks;
    }

    /**
        * 
        * @return List
        *                  
        * output:       aid=0000
        *               aname=aname
        *               atype=xxh
        *               wwnn=nnnnnnnnnnnnnnnn
        *               pdgList=00h,01h 
        * @throws Exception
        */
    public static List getDiskArrayInfo() throws Exception {
        String cmd_getdiskinfo = VOLUME_GETDISKARRAYINFO_PL;
        String[] cmds = { "sudo", cmd_getdiskinfo };
        NSCmdResult result = CmdExecBase.execCmd(cmds);
        List diskArrayList = NSBeanUtil.createBeanList("com.nec.nsgui.model.entity.volume.DiskArrayInfoBean", result.getStdout());    
        sortByAname(diskArrayList);
        return diskArrayList;
    }

    private static void sortByAname(List the_list){
        Collections.sort
            (the_list, new Comparator()
                {
                    public int compare(Object a, Object b){
                        DiskArrayInfoBean info_a = (DiskArrayInfoBean)a;
                        DiskArrayInfoBean info_b = (DiskArrayInfoBean)b;
                        return info_a.getAname().compareTo(info_b.getAname());
                    }
               }
            );
    }
    
    /**
        * 
        * @return List  
        * Output:
        *   aid=0000
        *   aname=aname
        *   poolName=poolname
        *   poolNo=0001h
        *   raidType=1|5|10|50|6(4+PQ)|6(8+PQ)
        *   totalCap=100.0
        *   maxFree=80.1
        *   totalFree=90.0
        *   ldList=0001h,0003h
        *   vgList=NV_LVM_vol1,NV_LVM_vol2                                           
        * @throws Exception
        */
    public static List getPoolInfo(String aid, String raidType) throws Exception {
        
        String cmd_getpoolinfo = VOLUME_GETAVAILPOOL_PL;
        
        if (raidType.equals("64")) {
            raidType = "6(4+PQ)";   
        } else if (raidType.equals("68")) {
            raidType = "6(8+PQ)";   
        }
        
        String[] cmds = { "sudo", cmd_getpoolinfo, aid, raidType};
        NSCmdResult result = CmdExecBase.execCmd(cmds);

        return NSBeanUtil.createBeanList("com.nec.nsgui.model.entity.volume.PoolInfoBean", result.getStdout());
    }    

    /** 
      ** NV:
      *     NV:     volumeName   mountPoint  poolNameAndNo raidType  capacity    fsType  quota   replication updateAccessTime    
      *     snapshot    accessmode  isMounted norecovery dmapi useRate useGfs aid aname
      ** NASHEAD:
      *     volumeName   volumeName   mountPoint  storage lun     capacity    fsType,quota    replication updateAccessTime    
      *     snapshot    accessmode  isMounted norecovery dmapi useRate useGfs
     **/
    public static Vector getVolumeList(
        String eg,
        boolean isNashead,
        int nodeNo)
        throws Exception {
        Vector volumeInfoVec = new Vector();
        String cmd_getvolumelist = VOLUME_LIST_PL;
        String[] cmds = { "sudo", cmd_getvolumelist, eg };
        NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);
        String[] volumeList = result.getStdout();
        for (int i = 0; i < volumeList.length - 1 ; i++) {
            if (!volumeList[i].equals("")) {
                String infoStr =
                    NSModelUtil.perl2Page(volumeList[i], NSModelUtil.EUC_JP);
                String[] infos = infoStr.split("\\s+");
                VolumeInfoBean volumeInfo = new VolumeInfoBean(isNashead, infos);
                volumeInfoVec.add(volumeInfo); 
            }
        }
        String rt = volumeList[volumeList.length - 1];
        VolumeAvailableNumberBean vanb = new VolumeAvailableNumberBean();
        vanb.setLdCount(rt.split("\\s+")[0]);
        vanb.setLvCount(rt.split("\\s+")[1]);
        volumeInfoVec.add(vanb);
        return volumeInfoVec;
    }

    ///add by maojb on 2004.08.10 start
    /**
     * @return Vector: all selected volumes which have been confirmed .
     * @param  VolumeInfoBean[] : all selected volumes
     */
        public static Vector confirmSelectedVolumes(VolumeInfoBean[] selectedVolumes, int nodeNo, boolean isNashead) throws Exception{
            //generate Vector confirmVolumes , every element is VolumeInfoConfirmBean's object .
            Vector <VolumeInfoConfirmBean> confirmVolumes = new Vector <VolumeInfoConfirmBean>();
            Map <String, String> pairlddevs = null;
            if(isNashead){
                pairlddevs = getPairedLddevMap();
            }
            
            boolean usePairedLd4Syncfs = false;
            for (int i=0 ; i<selectedVolumes.length ; i++) {
                VolumeInfoConfirmBean volumeInfoConfirm = new VolumeInfoConfirmBean(selectedVolumes[i]);
                if(isNashead
                        &&  volumeInfoConfirm.getReplication().booleanValue()
                        && !volumeInfoConfirm.getLdPath().equalsIgnoreCase("")
                        && pairlddevs.containsKey(volumeInfoConfirm.getLdPath()
                )){ 
                    usePairedLd4Syncfs = true;
                    volumeInfoConfirm.setUsePairedLd4Syncfs(true);
                }
                confirmVolumes.add(volumeInfoConfirm);
            }
            if(usePairedLd4Syncfs){
                return confirmVolumes; 
            }
            
            boolean sameName = false;
            
            //check selected volumes' same name error 
            VolumeInfoConfirmBean outVolumeInfoConfirm , inVolumeInfoConfirm; // out loop variable and in loop variable
            String outMPName , outVolumeName , inMPName , inVolumeName;
            for (int i=0 ; i<confirmVolumes.size() ; i++) {
                outVolumeInfoConfirm = (VolumeInfoConfirmBean)confirmVolumes.get(i);
                outMPName = outVolumeInfoConfirm.getMountPoint();
                outVolumeName = outVolumeInfoConfirm.getVolumeName();
                
                for (int j=i+1 ; j<confirmVolumes.size() ; j++) {
                    inVolumeInfoConfirm = (VolumeInfoConfirmBean)confirmVolumes.get(j);
                    inMPName = inVolumeInfoConfirm.getMountPoint();
                    inVolumeName = inVolumeInfoConfirm.getVolumeName();
                    
                    if (outMPName.equals(inMPName)) {
                        outVolumeInfoConfirm.setMPNameExist(true);
                        inVolumeInfoConfirm.setMPNameExist(true);  
                        sameName = true;      
                    }
                    
                    if (outVolumeName.equals(inVolumeName)) {
                        outVolumeInfoConfirm.setVolumeNameExist(true);
                        inVolumeInfoConfirm.setVolumeNameExist(true); 
                        sameName = true;
                    }
                }
            }
            
            //check whether the volume name and MP name have been used .
            Set usedVolumeNames = getUsedVolumeNames(nodeNo);
            Set usedMPNames = getUsedMPNames(nodeNo);
            for (int i=0 ; i<confirmVolumes.size() ; i++) {
                VolumeInfoConfirmBean volumeInfoConfirm = (VolumeInfoConfirmBean)confirmVolumes.get(i);
                String theVolumeName = volumeInfoConfirm.getVolumeName();
                String theMPName = volumeInfoConfirm.getMountPoint();
                
                if (usedVolumeNames.contains("NV_LVM_"+theVolumeName)) {
                    volumeInfoConfirm.setVolumeNameExist(true);
                    sameName = true;
                }
                
                if (usedMPNames.contains(theMPName)) {
                    volumeInfoConfirm.setMPNameExist(true);
                    sameName = true;
                }
            }
            // if same name error occurs , then return the Vector
            if (sameName) {
                return confirmVolumes;    
            }
         
         
            //generate temp Vector to sort
            Vector tmpVec = new Vector();
            for (int i=0 ; i<confirmVolumes.size() ; i++) {
                tmpVec.add((VolumeInfoConfirmBean)confirmVolumes.get(i));
            }
         
            // Sort tmpVec with mountpoint
            Collections.sort(tmpVec,
                new Comparator() { 
                    public int compare(Object o1, Object o2) { 
                        VolumeInfoConfirmBean v1 = (VolumeInfoConfirmBean) o1; 
                        VolumeInfoConfirmBean v2 = (VolumeInfoConfirmBean) o2;         
                        return v1.getMountPoint().compareTo(v2.getMountPoint()); 
                    } 
                }); 
            
            //group all confirmVolumes by mountpoint    
            String mpStart = ((VolumeInfoConfirmBean)tmpVec.get(0)).getMountPoint();
            Vector allMPGroups = new Vector();
            Vector aMPGroup = new Vector();
            for (int i=0 ; i<tmpVec.size() ; i++) {
                VolumeInfoConfirmBean volumeInfoConfirm = (VolumeInfoConfirmBean)tmpVec.get(i);
                if(volumeInfoConfirm.getMountPoint().equals(mpStart) || volumeInfoConfirm.getMountPoint().startsWith(mpStart + "/")) {
                    aMPGroup.add(volumeInfoConfirm);
                } else {
                    allMPGroups.add(aMPGroup);
                    aMPGroup = new Vector();
                    mpStart = volumeInfoConfirm.getMountPoint();
                    i--;
                }
            }
            allMPGroups.add(aMPGroup);
            
            //check every mountpoint group  , the result is set into ht .
            // ht's key is mountpoint , ht's value is error code .
            Hashtable ht = new Hashtable();
            for (int i=0 ; i<allMPGroups.size() ; i++) {
                aMPGroup = (Vector)allMPGroups.get(i);
                checkMPGroup(aMPGroup , ht, nodeNo);
            }
            
            for (int i=0 ; i<confirmVolumes.size() ; i++) {
                VolumeInfoConfirmBean volumeInfoConfirm = (VolumeInfoConfirmBean)confirmVolumes.get(i);
                volumeInfoConfirm.setMPErrorCode((String)ht.get(volumeInfoConfirm.getMountPoint()));          
            }
            return confirmVolumes;
        }
        
        public static String generateBaseVolumeName(String eg, int nodeNo) throws Exception {
            Set usedVolumeNames = getUsedVolumeNames(nodeNo);
            String baseName = "volBase";
            String volName = "";
            String mpName;
            
            boolean hasExist = false;
            for(int i=0; i<1024; i++) {
                hasExist = false;
                volName = baseName + i;
                mpName = eg + "/" + volName;
                Iterator it = usedVolumeNames.iterator();

                String curName;
                while(it.hasNext()) {
                    curName = (String)it.next();
                    if(curName.startsWith(VOLUME_NAME_PREFIX + volName + "_")) {
                        hasExist = true;
                        break;
                    }
                }

                if (!hasExist && !isMpBaseExist(mpName, nodeNo)) {
                    break;
                }
             }//end for
            
            return volName;
        }         
        
        /**
         * 
         * @param count  nodeNo
         * @return String[] : count volume names
         * @throws Exception
         */       
        public static String [] generateAllVolumeNames(int count , String eg, int nodeNo ) throws Exception {
            int start=0;
            Set usedVolumeNames = getUsedVolumeNames(nodeNo);
            Set usedMPNames = getUsedMPNames(nodeNo);
            String prefix = "vol";
            String [] allVolumeNames = new String[count];
            for (int i=0 ; i<count ; i++) {
                String volumeName = ""+start;
                if (volumeName.length() == 1) {
                    volumeName = "00"+volumeName;
                } else if(volumeName.length() == 2) {
                    volumeName = "0"+volumeName;
                }
                
                volumeName = prefix + volumeName;
                String mpName = eg + "/" + volumeName;
                
                if (!usedVolumeNames.contains(VOLUME_NAME_PREFIX + volumeName) && !usedMPNames.contains(mpName)) {
                    allVolumeNames[i] = volumeName;
                    start++;
                } else {
                    start++;
                    i--;
                }
            }//end for
            
            return allVolumeNames;
        }
       
       
       
        /**
         * @return  Set: all volumes' names
         */
        private static Set getUsedVolumeNames(int nodeNo) throws Exception{ 
            String cmd_usedVolumeNames = VOLUME_GETUSEDVOLUMENAMES_PL;
            String []cmds = {"sudo" , cmd_usedVolumeNames};
            NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);
            String[] usedVolumeNames = result.getStdout();
            
            Set usedVolumeNamesSet = new HashSet();
            for (int i=0 ; i<usedVolumeNames.length ; i++) {
                usedVolumeNamesSet.add(usedVolumeNames[i]);
            }
            return usedVolumeNamesSet;
        }
        
        
        /**
         * @return Set: all mountpoints' names 
         * @param none
         */
        private static Set getUsedMPNames(int nodeNo) throws Exception{ 
            String cmd_usedVolumeNames = VOLUME_GETUSEDMPNAMES_PL;
            String []cmds = {"sudo" ,cmd_usedVolumeNames};
            NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);
            String[] usedMPNames = result.getStdout();
            
            Set usedMPNamesSet = new HashSet();
            for (int i=0 ; i<usedMPNames.length ; i++) {
                usedMPNamesSet.add(usedMPNames[i]);
            }
            return usedMPNamesSet;
        }
        
        
        private static void checkMPGroup(Vector MPGroup , Hashtable ht, int nodeNo) throws Exception {      
            String mountpoint = ((VolumeInfoConfirmBean)MPGroup.get(0)).getMountPoint();
            //the mountpoint's style is follows : /export/necas/nas
            int mpLevel = mountpoint.split("/").length;
            // the first mp is direct mountpoint 
            if (mpLevel == 4) {
                String fsType = ((VolumeInfoConfirmBean)MPGroup.get(0)).getFsType();
                for (int i=0 ; i<MPGroup.size(); i++) {
                    String subFsType = ((VolumeInfoConfirmBean)MPGroup.get(i)).getFsType();
                    String subMP = ((VolumeInfoConfirmBean)MPGroup.get(i)).getMountPoint();
                    
                    if (!subFsType.equals(fsType)) {
                        ht.put(subMP , VOLUME_MP_FSTYPE_ERR);
                        continue;
                    }
                    ht.put(subMP , VOLUME_MP_CORRECT);
                } //end for
            } else {// the first mp is sub mountpoint
                String subMP = ((VolumeInfoConfirmBean)MPGroup.get(0)).getMountPoint();
                String fsType = ((VolumeInfoConfirmBean)MPGroup.get(0)).getFsType();
                
                String checkResult = checkMP(subMP , fsType, nodeNo);
                ht.put(subMP , checkResult);
                
                if (VOLUME_MP_PARENT_UMOUNT.equals(checkResult) 
                    || VOLUME_MP_PARENT_RO.equals(checkResult) 
                    || VOLUME_MP_HAS_REPLI.equals(checkResult)) {
                    for (int i=1 ; i<MPGroup.size() ; i++) {
                        subMP = ((VolumeInfoConfirmBean)MPGroup.get(i)).getMountPoint();
                        ht.put(subMP , checkResult);
                    }
                } else {
                    String theErrFsTypeValue = "";
                    for (int i=1 ; i<MPGroup.size() ; i++) {
                        if (VOLUME_MP_FSTYPE_ERR.equals(checkResult)) {
                            theErrFsTypeValue = fsType;
                        }
                        
                        subMP = ((VolumeInfoConfirmBean)MPGroup.get(i)).getMountPoint();
                        fsType = ((VolumeInfoConfirmBean)MPGroup.get(i)).getFsType();
                        
                        if (fsType.equals(theErrFsTypeValue)) {
                            ht.put(subMP , VOLUME_MP_FSTYPE_ERR);
                        } else {
                            checkResult = checkMP(subMP , fsType, nodeNo);
                            ht.put(subMP , checkResult);
                        }
                    } 
                } 
            }// end else
        }// end function
        
        private static String checkMP(String mountpoint , String fsType, int nodeNo) throws Exception{
            String cmd_checkmp = VOLUME_CHECKMP_PL;
            String []cmds = {"sudo" , cmd_checkmp , mountpoint , fsType};
            NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);
            return (result.getStdout())[0];   
        }   


    // get PD list for for FC-SAN's page: Rank Bind.
    
    //for batch setting
    static String VOLUME_CREATEOTHERMP = "/home/nsadmin/bin/volume_createmponfriendnode.pl";
    public static String createMpOnFriendNode(int nodeNo) throws Exception{
            String[] cmds = {"sudo", VOLUME_CREATEOTHERMP};
            NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);
            if(result.getStdout() != null && result.getStdout().length != 0){
                return result.getStdout()[0];
            }
            return "";
    }
    
    
    private static String VOLUME_BATCH_PL  = "/home/nsadmin/bin/volume_getlvcount.pl";
    public static VolumeAvailableNumberBean getVolumeAvailableNumber()
        throws Exception {
        String[] cmds = {"sudo", VOLUME_BATCH_PL};
        NSCmdResult result = CmdExecBase.execCmd(cmds);
        String rt = result.getStdout()[0];
        VolumeAvailableNumberBean vanb = new VolumeAvailableNumberBean();
        vanb.setLdCount(rt.split("\\s+")[0]);
        vanb.setLvCount(rt.split("\\s+")[1]);
        return vanb;
    }
    
    public static void deleteRRDFile(String vgName , String collectionItem , int nodeNo) throws Exception{
        
        NodeInfoBean nodeInfoBean = ControllerModel.getInstance().getNodeInfo(nodeNo);
        String adminTarget = nodeInfoBean.getAdminTarget();
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        mc.deleteRRDFile(MonitorConfig.stripTargetID(adminTarget), collectionItem, vgName.replaceFirst("NV_LVM_", ""));
        
        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        mc2.deleteRRDFile(MonitorConfig.stripTargetID(adminTarget), collectionItem, vgName.replaceFirst("NV_LVM_", ""));
    }
    
    
    /**
     * get the string to show whether can set dmapi  
     * @param mp the specified mount point 
     * @param nodeNo node number
     * @return yes or no
     * @throws Exception
     */
    public static String canSetDmapi(String mp , int nodeNo) throws Exception{
        String[] cmds = {"sudo" , VOLUME_CANSETDMAPI_PL , mp};
        NSCmdResult result = CmdExecBase.execCmd(cmds , nodeNo);
        return result.getStdout()[0];
    }

    /**
     * @param vib
     * @return
     */
    public static VolumeInfoConfirmBean confirmSelectedVolumes(VolumeInfoBean vib, int nodeNo) throws Exception {
        VolumeInfoConfirmBean volumeInfoConfirm = new VolumeInfoConfirmBean(vib);
        String volBase = "NV_LVM_" + volumeInfoConfirm.getVolumeName();
        String mpBase = volumeInfoConfirm.getMountPoint();
        
        Set usedVolumeNames = getUsedVolumeNames(nodeNo);
        
        Iterator it = usedVolumeNames.iterator();
        String volName;
        while(it.hasNext()) {
            volName = (String)it.next();
            if(volName.startsWith(volBase + "_")) {
                volumeInfoConfirm.setVolumeNameExist(true);
                break;
            }
        }

        volumeInfoConfirm.setMPNameExist(isMpBaseExist(mpBase, nodeNo));
        
        if(volumeInfoConfirm.getVolumeNameExist()
           || volumeInfoConfirm.getMPNameExist()) {
            return volumeInfoConfirm;
        }
        
        VolumeInfoBean[] vols = {vib};
        return (VolumeInfoConfirmBean)confirmSelectedVolumes(vols, nodeNo, false).get(0);     
    }

    /**
     * @param mpBase
     * @return
     */
    private static boolean isMpBaseExist(String mpBase, int nodeNo) throws Exception {
        String[] cmds = {"sudo" , VOLUME_MP_BASE_EXIST_PL, mpBase};
        NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNo);    
        return Boolean.valueOf(result.getStdout()[0]).booleanValue();
    }
    
    /**
     * @param aid -- disk array's ID
     * 
     * @return
     *      String: get LD count that can been created on the specified diskarray
     */
    private static String VOLUME_GETAVAILLDNUMFORCREATE_PL = "/home/nsadmin/bin/volume_getavailldnumforcreate.pl";
    public static String getLdNum4Create(String aid) throws Exception{
        String[] cmds = {"sudo" ,VOLUME_GETAVAILLDNUMFORCREATE_PL, aid};
        NSCmdResult result = CmdExecBase.execCmd(cmds);    
        return (result.getStdout())[0].trim();
        
    }    

    public static Map getLdNum4Create() throws Exception{
        String[] cmds = {"sudo" ,VOLUME_GETAVAILLDNUMFORCREATE_PL};
        NSCmdResult result = CmdExecBase.execCmd(cmds);
        Map map = new TreeMap();
        String[] rt = result.getStdout();
        for(int i=0; i<rt.length; i++) {    
            map.put((rt[i].split("\\s+"))[0], (rt[i].split("\\s+"))[1]);
        }
        return map;        
    }
    
    public static void delAsyncFile(String volName, int nodeNo) throws Exception{
        String[] cmds = {"sudo", VOLUME_DEL_ASYNC_FILE_PL, volName};
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static String[] getAsyncInfo() throws Exception{
        String[] cmds = {"sudo", VOLUME_HASASYNC_PL, "1"};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null);
        if(result.getStdout().length>0) {
            return result.getStdout();
        } else {
            return new String[0];        
        }
    }
    /*poolnameno: poolname(poolNo)#poolname(poolNo)#
     * return : pdtype (SATA|SAS|FC..) 
     *          or "--"
     *          or "MIX"
     */
    public static String getpoolpdtype(String aid, String poolnameno) throws Exception{
        String[] cmds ={"sudo",VOLUME_GET_POOL_PD_TYPE,aid,poolnameno};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
        return  (result.getStdout())[0];
    }     

    /**
     * get volume license capacity  
     * @param none
     * @return licenseCap -- license capacity, return 0 if no license
     * @throws Exception
     */
    public static String LIC_GETLICENSECAPACITY = "/usr/sbin/lic_volsize";
    public static String getLicenseCap() throws Exception{
        String[] cmds ={"sudo", LIC_GETLICENSECAPACITY, "-g"};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, false);
 
        String licenseCap = "--";
        if (result.getExitValue() == 0) {
        	licenseCap = (result.getStdout())[0];
        }
        return  licenseCap;
    }
    
    /**
     * get the capacity of all filesystem in system  
     * @param none
     * @return totalFSCap -- total filesystem capacity, return 0 if failed to get filesystem capacity
     * @throws Exception
     */    
    public static String LIC_GETTOTALFSCAPACITY_PL = "/opt/nec/nsadmin/bin/lic_gettotalfscapacity.pl";
    public static String getTotalFSCap() throws Exception{
        String[] cmds ={"sudo", LIC_GETTOTALFSCAPACITY_PL};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, false);
        
        String totalFSCap = "--";  //default value
        if (result.getExitValue() == 0) {
        	totalFSCap = (result.getStdout())[0];
        }
        return  totalFSCap;
    }
    
    /**
     * check if the filesystem type of the mountpoint is "syncfs"
     * @param mp -- mountpoint
     * @return "yes" -- the filesystem type is "syncfs",else return "no"
     * @throws Exception
     */    
   
    public static String isSyncFS(String mp, int nodeNo) throws Exception{
    	String[] cmds = {"sudo" , VOLUME_CHKSYCNFS_PL , mp};
        NSCmdResult result = CmdExecBase.execCmd(cmds , nodeNo);
        String isSycnFS = result.getStdout()[0];
		return isSycnFS;
    } 
    /**
     * check snapshot options
     * @param mp -- mountpoint
     * @return "yes" -- the mountpoint has snapshot or snapshot schedule,else return "no"
     * @throws Exception
     */    
   
    public static String hasSnapshotSet(String mp, int nodeNo) throws Exception{
    	return canSetDmapi(mp,nodeNo).equals("yes")?"no":"yes";
    } 
    
    /**
     * get the lds that has been paired.
     * @param mp -- none
     * @return Map -- paired lds' map
     * @throws Exception
     */ 
    public static Map <String, String> getPairedLddevMap() throws Exception{
        String[] cmds = {"sudo", VOLUME_GETPAIREDLDDEVS_PL};
        NSCmdResult result =CmdExecBase.localExecCmd(cmds,null,true);
        TreeMap <String,String> pairedLdMap = new TreeMap <String, String> () ;
        for (String tmpValue:result.getStdout()) {
            pairedLdMap.put(tmpValue.trim(), "");
        }
        return pairedLdMap;
    }
}
