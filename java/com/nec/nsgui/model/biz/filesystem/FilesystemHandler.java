/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.biz.filesystem;

import java.util.Vector;
import java.util.StringTokenizer;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.filesystem.FilesystemInfoBean;
import com.nec.nsgui.model.entity.filesystem.FreeLvInfoBean;
import com.nec.nsgui.action.base.NSActionUtil; 
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.action.volume.VolumeActionConst;

import java.util.Locale;
import java.util.Date;
import java.util.GregorianCalendar;
import java.text.DateFormat;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.entity.filesystem.FreeLdInfoBean;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class FilesystemHandler implements VolumeActionConst {
	public static final String cvsid =
        "@(#) $Id: FilesystemHandler.java,v 1.10 2008/05/24 12:14:11 liuyq Exp $";
	private static String CMD_SUDO = "sudo";
	private static String FILESYSTEM_MOUNT_PL = "/home/nsadmin/bin/filesystem_mount.pl";
	private static String FILESYSTEM_CHECKBEFOREMOUNT_PL = "/home/nsadmin/bin/filesystem_checkBeforeMount.pl";
	private static String FILESYSTEM_GETFREELV_PL = "/home/nsadmin/bin/filesystem_getFreeLV.pl";
	private static String FILESYSTEM_CREATFS_PL = "/home/nsadmin/bin/filesystem_createFS.pl";
	private static String FILESYSTEM_DELFS_PL = "/home/nsadmin/bin/filesystem_delFS.pl";
	private static String ENCODE_EUC_JP = "EUC-JP";
	private static String UNIT_GB = "GB";
	
	// add const by jiangfx begin
	private static final String FILESYSTEM_GETFREELD_PL 
                                           = "/home/nsadmin/bin/filesystem_getFreeLd.pl";
    private static final String FILESYSTEM_EXTEND_PL
                                           = "/home/nsadmin/bin/filesystem_extend.pl";
    private static final String FILESYSTEM_CHECKBEFOREMOVE_PL
                                           = "/home/nsadmin/bin/filesystem_checkBeforeMove.pl";
    private static final String FILESYSTEM_CHECKBEFOREEXTEND_PL
                                           = "/home/nsadmin/bin/filesystem_checkBeforeExtend.pl";                                           
    private static final String FILESYSTEM_MOVE_PL           
                                           = "/home/nsadmin/bin/filesystem_move.pl";
    private static final String FILESYSTEM_GETMOVENAVIGATORLIST_PL 
                                           = "/home/nsadmin/bin/filesystem_getMoveNavigatorList.pl";
    private static final String FILESYSTEM_CHECKDESTINATIONDIR_PL 
                                           = "/home/nsadmin/bin/filesystem_checkDestinationDir.pl";
	
	private static final String DEV_PREFIX = "/dev/";
    private static final String EXPORT     = "/export/";                                             
	// add const by jiangfx end
	
	public static Vector getFreeLvVec(int nodeNum) throws Exception {
		Vector freeLvVec = new Vector();
		String[] cmds = {
				 CMD_SUDO,
			     FILESYSTEM_GETFREELV_PL};
		NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNum);
		String[] stdOut = result.getStdout();
		for(int i=0; i<stdOut.length; i++){
			FreeLvInfoBean freeLv = new FreeLvInfoBean();
			String line = NSActionUtil.perl2Page(stdOut[i],ENCODE_EUC_JP);

			StringTokenizer st = new StringTokenizer(line.trim());
			if (st.countTokens() >= 4){
				freeLv.setLvPath(st.nextToken());
				freeLv.setLvSize(st.nextToken());
				freeLv.setLvNickName(st.nextToken());
                freeLv.setVgPairFlag(st.nextToken());
				String lvName = freeLv.getLvPath();
				if (lvName.startsWith("NV_LVM_")){
					lvName = lvName.substring(7,lvName.length());
				}
				String lvSize = freeLv.getLvSize();
				try{
				    Double d = new Double(lvSize); 
					lvSize = (new java.text.DecimalFormat("#,##0.0")).format(d);
			    }catch(NumberFormatException e) {}
				
				String value4Show = lvName
				 					+" ("
				 					+lvSize
				 					+UNIT_GB
				 					+")";
				freeLv.setValue4Show(value4Show);
				
			}
			
			freeLvVec.add(freeLv);
		}	
		return freeLvVec;
	}
	
	public static void delFS(String mp, String licence, String force, int nodeNum) throws Exception {
		String cmds[] = {
			CMD_SUDO,
			FILESYSTEM_DELFS_PL,
		    mp,
		    licence,
		    force};
		CmdExecBase.execCmd(cmds, nodeNum);
	}
	
	public static void createFS(FilesystemInfoBean fsInfo, int nodeNum) throws Exception {
		StringBuffer fsOpt = new StringBuffer();
		StringBuffer mountOpt = new StringBuffer();
        String lvPath = fsInfo.getLvPath().split("#")[0];
        String lvSize = fsInfo.getLvPath().split("#")[1];

		fsOpt.append("fstype=");
		fsOpt.append(fsInfo.getFsType());
		if (fsInfo.getFormat()!=null && (fsInfo.getFormat()).booleanValue()){
			fsOpt.append(",format=yes");
		}
		if (fsInfo.getRepli()!=null && (fsInfo.getRepli()).booleanValue()){
			fsOpt.append(",repli=");
			fsOpt.append(fsInfo.getReplicationType());
		}
		if (fsInfo.getJournalType()!=null && fsInfo.getJournalType().equals("expand")){
			fsOpt.append(",journal=expand");
		}
		
		mountOpt.append("access=");
		String accessMode = fsInfo.getAccessMode();
		String repliType = fsInfo.getReplicationType();
		
		if (fsInfo.getRepli()!=null && (fsInfo.getRepli()).booleanValue()){ 
		    accessMode = repliType.equals("replic")?"ro":"rw";
		}
		mountOpt.append(accessMode);
		if (fsInfo.getRepli()==null || !fsInfo.getReplicationType().equals("replic")){
			mountOpt.append(",snapshot=");
			mountOpt.append(fsInfo.getSnapshotArea());
		}
	    if (fsInfo.getQuota()!=null && (fsInfo.getQuota()).booleanValue()){
	    	mountOpt.append(",quota=on");
	    }
	    if (fsInfo.getUpdateAccessTime()!= null && !(fsInfo.getUpdateAccessTime()).booleanValue()){
	    	mountOpt.append(",noatime=on");
	    }
	    if (fsInfo.getDmapi()!=null && (fsInfo.getDmapi()).booleanValue()){
	    	mountOpt.append(",dmapi=on");
	    }
	    if (fsInfo.getNorecovery()!=null && (fsInfo.getNorecovery()).booleanValue()){
	    	mountOpt.append(",norecovery=on");
	    }
		mountOpt.append(",usegfs=").append(fsInfo.getUseGfs());
		mountOpt.append(",wpperiod=").append(fsInfo.getWpPeriod());
        
		String cmds[] = {
			CMD_SUDO,
			FILESYSTEM_CREATFS_PL,
			"--fs",
			fsOpt.toString(),
			"--mount",
			mountOpt.toString(),
			"--lv",
			lvPath,
			"--mp",
		    fsInfo.getMountPoint()};
		CmdExecBase.execCmd(cmds, nodeNum);
		
	}
	
	public static void checkBeforMount(String mp,int nodeNum)throws Exception {
		String[] cmds = {
			CMD_SUDO,
			FILESYSTEM_CHECKBEFOREMOUNT_PL,
			mp};
            CmdExecBase.execCmd(cmds, nodeNum);
	}
	
	
	public static void mountFS(VolumeInfoBean fsInfo, int nodeNum)throws Exception {
		StringBuffer mountOpt = new StringBuffer();
		
		if (fsInfo.getReplicType() != null && fsInfo.getReplicType().equals("replic")) {
			mountOpt.append("access=ro");
			mountOpt.append(",repli=on");
		}else if (fsInfo.getReplicType() != null && fsInfo.getReplicType().equals("original")){
			mountOpt.append("access=rw");
			mountOpt.append(",repli=on");
		}else {
			mountOpt.append("access="+fsInfo.getAccessMode());
			if (fsInfo.getReplication() != null && (fsInfo.getReplication()).booleanValue()){
				mountOpt.append(",repli=on");	
			}			   
		}		
		
		if (fsInfo.getQuota() != null && (fsInfo.getQuota()).booleanValue()){
			mountOpt.append(",quota=on");
		}
		if (fsInfo.getNoatime()!= null && !(fsInfo.getNoatime()).booleanValue()){
			mountOpt.append(",noatime=on");
		}
		if (fsInfo.getDmapi()!=null && (fsInfo.getDmapi()).booleanValue()){
			mountOpt.append(",dmapi=on");
		}
		if (fsInfo.getNorecovery()!=null && (fsInfo.getNorecovery()).booleanValue()){
			mountOpt.append(",norecovery=on");
		}
		
        mountOpt.append(",usegfs=").append(fsInfo.getUseGfs());
        
		String cmds[] = {
			CMD_SUDO,
			FILESYSTEM_MOUNT_PL,
			"--mp",
			fsInfo.getMountPoint(),
			"--mo",
			mountOpt.toString()};
			
		CmdExecBase.execCmd(cmds, nodeNum);
	}
	
	// add method by jiangfx begin
    /**
     * get all free LD for extend filesystem
     * @param  isNashead -- true is NASHead, false is NV
     * @param  nodeNo    -- node on which to execute cmd
     * @return
     * @throws Exception
     */
    public Vector getFreeLd(boolean isNashead, int nodeNo, String usage) throws Exception {
        // get all free LD info
        String[] cmd_getFreeLd = {"sudo", FILESYSTEM_GETFREELD_PL, usage};
        NSCmdResult cmdResult = getCmdResult(cmd_getFreeLd, nodeNo);
        String[] freeLdArr = cmdResult.getStdout();
        
        Vector freeLdVector = new Vector();
        
        // get lun, storage, ldSize and ldPath
        for (int i = 0; i < freeLdArr.length; i++) {
            String freeLdStr = NSModelUtil.perl2Page(freeLdArr[i], NSModelUtil.EUC_JP);
            String[] tmpArr = freeLdStr.split("\\s+");
            FreeLdInfoBean lunInfo = new FreeLdInfoBean();
            lunInfo.setLun(tmpArr[0]);
            lunInfo.setLdNo(tmpArr[0]);
            lunInfo.setStorage(tmpArr[1]);
            lunInfo.setLdSize(tmpArr[2]);
            lunInfo.setLdPath(tmpArr[3]);
            freeLdVector.add(lunInfo);
        }
        
        return freeLdVector;
    }
    
    /**
     * extend the specified filesystem
     * @param fsInfo  -- the specified filesystem's information
     * @param ldList  -- LD path list used to extend the specified filesystem 
     * @param nodeNo  -- node on which to execute cmd
     * @throws Exception
     */
    public static void extendFS(VolumeInfoBean fsInfo, String ldList, int nodeNo) throws Exception {
        String volumeName = fsInfo.getVolumeName();
        StringBuffer lvPathBuf = new StringBuffer(DEV_PREFIX);
        lvPathBuf.append(volumeName).append("/").append(volumeName);
        String lvPath = lvPathBuf.toString();
        
        String[] cmd_extend = {"sudo", FILESYSTEM_EXTEND_PL, fsInfo.getMountPoint(), lvPath, ldList, fsInfo.getStriping()};
        CmdExecBase.execCmd(cmd_extend, nodeNo);
    }
    
    /**
     * check if mount point can be move
     * @param mountPoint -- mount point will be move
     * @param nodeNo     -- node on which to execute cmd
     * @throws Exception
     */
    public static void checkBeforeMove(String mountPoint, int nodeNo) throws Exception {
        String[] cmd_checkBeforeMove = {"sudo", FILESYSTEM_CHECKBEFOREMOVE_PL, mountPoint};
        CmdExecBase.execCmd(cmd_checkBeforeMove, nodeNo);         
    }
    
    /**
     * check if mount point can be extend
     * @param mountPoint -- mount point will be extend
     * @param nodeNo     -- node on which to execute cmd
     * @throws Exception
     */
    public static void checkBeforeExtend(String mountPoint, int nodeNo) throws Exception {
        String[] cmd_checkBeforeExtend = {"sudo", FILESYSTEM_CHECKBEFOREEXTEND_PL, mountPoint};
        CmdExecBase.execCmd(cmd_checkBeforeExtend, nodeNo);         
    }
    
    /**
     * move the specified filesystem
     * @param filesystemInfo
     * @param codepage
     * @param desMountPoint
     * @param nodeNo
     * @throws Exception
     */
    public static void moveFS(VolumeInfoBean fsInfo, String codepage, String mountPointShow, int nodeNo)
                                                                      throws Exception {
        
        StringBuffer desMountPointBuf = new StringBuffer(EXPORT);
        desMountPointBuf.append(mountPointShow);
        String desMountPoint = desMountPointBuf.toString();
        
        String srcMountPoint = fsInfo.getMountPoint();
        String fsType = fsInfo.getFsType();
        
        // check destination mount point
        int partnerNodeNo = (nodeNo == 0) ? 1 : 0;
        String[] cmd_checkDestinationDir = {"sudo", FILESYSTEM_CHECKDESTINATIONDIR_PL, desMountPoint, fsType, codepage};        
        CmdExecBase.execCmd(cmd_checkDestinationDir, partnerNodeNo);
        
        // originize mount point options
        StringBuffer optionStr =new StringBuffer("access=");
        optionStr.append(fsInfo.getAccessMode());
        if((fsInfo.getReplication()!= null) && (fsInfo.getReplication().booleanValue())){
            optionStr.append(",repli=on");
        }
        
        if((fsInfo.getQuota()!= null) && (fsInfo.getQuota().booleanValue())){
           optionStr.append(",quota=on");
        }
        
        if((fsInfo.getNoatime()!= null) && (!(fsInfo.getNoatime().booleanValue()))){//note:logic different
            optionStr.append(",noatime=on");
        }
        
        if((fsInfo.getDmapi()!= null) && (fsInfo.getDmapi().booleanValue())){
            optionStr.append(",dmapi=on");
        }
        
        if((fsInfo.getNorecovery()!= null) && (fsInfo.getNorecovery().booleanValue())){
            optionStr.append(",norecovery=on");
        } 

        String options = optionStr.toString();        
        // execute move script       
        String[] cmd_move = {"sudo", FILESYSTEM_MOVE_PL, "-s", srcMountPoint, "-d", desMountPoint, 
                             "-o", options, "-t", fsType, "-e", codepage};
        CmdExecBase.execCmd(cmd_move, nodeNo);    
    }
    
    /**
     * get destination mount point for the specified filesystem to move
     * @param rootDirectory
     * @param nowDirectory
     * @param check
     * @param codepage
     * @param fsType
     * @param locale
     * @param nodeNo
     * @return
     * @throws Exception
     */
    public Vector getMoveNavigatorList(String rootDirectory, String nowDirectory, boolean check,  
                                    String codepage, String fsType, Locale locale, int nodeNo) throws Exception {

        String checkOrNot = (check) ? "check" : "uncheck";
        String[] cmd_getMoveNavigatorList = {"sudo", FILESYSTEM_GETMOVENAVIGATORLIST_PL, rootDirectory,
                                              nowDirectory, checkOrNot, codepage, fsType};
        NSCmdResult cmdResult = getCmdResult(cmd_getMoveNavigatorList, nodeNo);
        String[] allLines = cmdResult.getStdout();
        
        Vector allDirectoryInfo = new Vector();
        int start;
        if (check) {
            nowDirectory = allLines[0];
            allDirectoryInfo.add(allLines[0]);
            start = 1;
        } else {
            start = 0;
        }
        
        for (int i = start; i <allLines.length; i++) {
            DirectoryInfoBean oneDirInfo = new DirectoryInfoBean();
            analyseOneLine(allLines[i], oneDirInfo, rootDirectory, nowDirectory, locale);
            allDirectoryInfo.add(oneDirInfo);
        }
        
        return allDirectoryInfo;
    }
    
    /**
     * analyse one directory info, and store these info to DirectoryInfoBean
     * @param line
     * @param oneDirInfo
     * @param rootDirectory
     * @param nowDirectory
     * @param locale
     * @throws Exception
     */
    private void analyseOneLine(String line, DirectoryInfoBean oneDirInfo, String rootDirectory,
                                String nowDirectory, Locale locale) throws Exception {
        StringTokenizer st = new StringTokenizer(line);
       
        // must be 12 tokens
        String mountStatus = st.nextToken();  //directory status
        
        st.nextToken();  //directory type
        st.nextToken();  //a number
        st.nextToken();  //owner
        st.nextToken();  //group
        st.nextToken();  //size
        st.nextToken();  //week
        
        String month         = st.nextToken();
        String day           = st.nextToken();
        String time          = st.nextToken();
        String year          = st.nextToken();
        String displayedPath = st.nextToken();  //directory name
        
        // set mountStatus, displayeedPath and wholePath to oneDirInfo
        oneDirInfo.setMountStatus(mountStatus);
        oneDirInfo.setDisplayedPath(displayedPath);
        oneDirInfo.setWholePath(nowDirectory + "/" + displayedPath);
        
        // get selected Path used to display in navigator textarea
        String displaySelectedPath;
        if (nowDirectory.equals(rootDirectory)) {
            displaySelectedPath = displayedPath;
        } else {
            displaySelectedPath = nowDirectory.substring(rootDirectory.length() + 1) + "/" + displayedPath;
        }
        
        oneDirInfo.setDisplaySelectedPath(displaySelectedPath);
        
        // get gregporian calendar date and time
        String[] timeArray = time.split(":");
        String hour        = timeArray[0];
        String minute      = timeArray[1];
        String second      = timeArray[2];
        
        GregorianCalendar gregorianCalendar = new GregorianCalendar(Integer.parseInt(year), 
                                   NSModelUtil.getMonthInt(month), Integer.parseInt(day),
                                   Integer.parseInt(hour), Integer.parseInt(minute) , Integer.parseInt(second));
        
        Date date = gregorianCalendar.getTime();
        
        DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.MEDIUM, locale);
    
        String dateString = dateFormat.format(date);
        
        dateFormat = DateFormat.getTimeInstance(DateFormat.MEDIUM, locale);
        String timeString = dateFormat.format(date);
        
        // set dateString, timeString and dirType to oneDirInfo 
        oneDirInfo.setDateString(dateString);
        oneDirInfo.setTimeString(timeString);
        oneDirInfo.setDirType("directory");
    }
    
    /**
     * call CmdExecBase.execCmd to get cmd's result
     * @param cmds
     * @param nodeNo
     * @return cmdResult
     * @throws Exception
     */
    protected NSCmdResult getCmdResult(String[] cmds, int nodeNo) throws Exception {
              NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
              return cmdResult;
    } 		
	// add method by jiangfx end

}