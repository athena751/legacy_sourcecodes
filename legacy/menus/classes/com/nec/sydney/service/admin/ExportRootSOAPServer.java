/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;

import java.util.*;
import java.io.*;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.atom.admin.filesystem.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;

public class ExportRootSOAPServer implements NasConstants, NSExceptionMsg,
        EGNSExceptionMsg {

    private static final String cvsid = "@(#) $Id: ExportRootSOAPServer.java,v 1.2302 2007/04/26 07:37:50 wanghb Exp $";

    private static final String EG_SCRIPT_CHECK_NFS_EXPORT = "/bin/filesystem_chkNFSExport.pl";

    private static final String EG_SCRIPT_GETFILESETTYPE = "/bin/exportroot_getfilesettype.pl";

    private static final String EG_SCRIPT_CHK_USED_IN_FTP = "/bin/exportroot_checkFTPUseOrNot.pl";

    private static final String EG_SCRIPT_CHK_USED_IN_HTTP = "/bin/exportroot_checkHTTPUseOrNot.pl";

    private static final String FS_SCRIPT_GET_MPLIST = "/bin/filesystem_getMPList.pl";

    private static final String COMMAND_CIFS_HASEXPORT = "/bin/cifs_hasExport.pl";

    // constructor
    public ExportRootSOAPServer() {
    }

    /**
     * get the mount point list from specified export group
     * 
     * @param: exportGroup: selected export group localDomain: the localdomain
     *         name in the export group netBios: the net bios name in the export
     *         group return SoapRpsVector
     */
    public SoapRpsVector getMPList(String exportGroup, String localDomain,
            String netBios) throws Exception {

        SoapRpsVector trans = new SoapRpsVector();
        Vector mountPointList = new Vector();

        // 1. get the MountPointInfo from filesystem Server

        SoapRpsVector soapVector = getMountPointList(exportGroup);
        if (!soapVector.isSuccessful()) {
            trans.setSuccessful(false);
            trans.setErrorMessage(soapVector.getErrorMessage());
            trans.setErrorCode(soapVector.getErrorCode());
            return trans;
        }

        // 2. iterator SoapVector.getVector()
        Vector tmpVector = soapVector.getVector();
        MountPointInfo mountPointInfo;
        int mountPointNumber = tmpVector.size();

        if (mountPointNumber > 0) {
            for (int i = 0; i < mountPointNumber; i++) {
                mountPointInfo = (MountPointInfo) tmpVector.get(i);
                String hexMountPoint = mountPointInfo.getHexMountPoint();
                String deviceName = mountPointInfo.getDeviceName();
                // SoapRpsString rpsDeviceName =
                // SnapSOAPServer.hexMP2DevName(hexMountPoint);
                // String deviceName = rpsDeviceName.getString();
                deviceName = "/dev/" + deviceName + "/" + deviceName;
                String status = mountPointInfo.getStatus();
                String fsType = mountPointInfo.getFSType();
                String repliStatus = mountPointInfo.getRepliStatus();
                String quota = mountPointInfo.getQuota();
                boolean hasNFS = false;
                boolean hasCIFS = false;
                boolean hasAuth = false;
                boolean hasSchedule = false;
                boolean hasFtp = false;
                boolean hasHttp = false;
                String filesetType = "-";
                String region = "";

                if (status.equalsIgnoreCase("Mounted")) {
                    // boolean hasNFS = chkHasNFS(exportGroup,hexMountPoint);
                    SoapRpsBoolean rpsBoolean = chkHasNFS(exportGroup,
                            hexMountPoint);
                    if (!rpsBoolean.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsBoolean.getErrorMessage());
                        trans.setErrorCode(rpsBoolean.getErrorCode());
                        return trans;
                    }
                    hasNFS = rpsBoolean.getBoolean();

                    // boolean hasCIFS =
                    // chkHasCIFS(exportGroup,hexMountPoint,localDomain,netBios);
                    rpsBoolean = chkHasCIFS(exportGroup, hexMountPoint,
                            localDomain, netBios);
                    if (!rpsBoolean.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsBoolean.getErrorMessage());
                        trans.setErrorCode(rpsBoolean.getErrorCode());
                        return trans;
                    }
                    hasCIFS = rpsBoolean.getBoolean();

                    // boolean hasAuth = chkHasAuth(hexMountPoint);
                    SoapRpsString rpsString = chkHasAuth(hexMountPoint);
                    if (!rpsString.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsString.getErrorMessage());
                        trans.setErrorCode(rpsString.getErrorCode());
                        return trans;
                    }
                    if (rpsString.getString().trim().equals("")) {
                        hasAuth = false;
                    } else {
                        hasAuth = true;
                        region = rpsString.getString();
                    }

                    // check if the specified mountpoint has been used in ftp.
                    rpsBoolean = chkHasFtp(hexMountPoint);
                    if (!rpsBoolean.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsBoolean.getErrorMessage());
                        trans.setErrorCode(rpsBoolean.getErrorCode());
                        return trans;
                    }
                    hasFtp = rpsBoolean.getBoolean();

                    // check if the specified mountpoint has been used in http.
                    rpsBoolean = chkHasHttp(hexMountPoint);
                    if (!rpsBoolean.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsBoolean.getErrorMessage());
                        trans.setErrorCode(rpsBoolean.getErrorCode());
                        return trans;
                    }
                    hasHttp = rpsBoolean.getBoolean();

                    // boolean hasSchedule =
                    // chkHasSchedule(hexMountPoint,deviceName);
                    SoapRpsSnapSummaryInfo rpsInfo = chkHasSchedule(
                            hexMountPoint, deviceName);
                    if (!rpsInfo.isSuccessful()) {
                        trans.setSuccessful(false);
                        trans.setErrorMessage(rpsInfo.getErrorMessage());
                        trans.setErrorCode(rpsInfo.getErrorCode());
                        return trans;
                    }
                    SnapSummaryInfo tmpInfo = rpsInfo.getInfo();
                    Vector schList = tmpInfo.getSnapshotVector();
                    if (schList.size() > 0) {
                        hasSchedule = true;
                    } else {
                        hasSchedule = false;
                    }

                    if (repliStatus.equalsIgnoreCase("enable")) {
                        // filesetType = chkFilesetType(hexMountPoint);
                        rpsString = chkFilesetType(hexMountPoint);
                        if (!rpsString.isSuccessful()) {
                            trans.setSuccessful(false);
                            trans.setErrorMessage(rpsString.getErrorMessage());
                            trans.setErrorCode(rpsString.getErrorCode());
                            return trans;
                        }
                        filesetType = rpsString.getString();
                    }
                }
                EGMountPointInfo mpInfo = new EGMountPointInfo();
                mpInfo.setHexMountPoint(hexMountPoint);
                mpInfo.setFsType(fsType);
                mpInfo.setMountStatus(status);
                mpInfo.setHasNFS(hasNFS);
                mpInfo.setHasCIFS(hasCIFS);
                mpInfo.setHasAuth(hasAuth);
                mpInfo.setHasSchedule(hasSchedule);
                mpInfo.setHasFtp(hasFtp);
                mpInfo.setHasHttp(hasHttp);
                mpInfo.setQuotaStatus(quota);
                mpInfo.setFilesetType(filesetType);
                mpInfo.setRegion(region);
                mountPointList.addElement(mpInfo);
            }
        }

        trans.setVector(mountPointList);
        return trans;
    }

    public SoapRpsVector getMPList(String exportGroup, String localDomain,
            String netBios, String groupNo) throws Exception {
        SoapRpsVector trans = new SoapRpsVector();

        String origmyNumber = ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);

        try {
            trans = getMPList(exportGroup, localDomain, netBios);
        } catch (NSException e) {
            throw e;
        } finally {
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }

        return trans;

    }// end function "getMPList"

    /**
     * check has NFS or not in specified mountpoint
     * 
     * @param:exportGroup,hexMountPoint
     * @return true|false
     */
    private SoapRpsBoolean chkHasNFS(String exportGroup, String hexMountPoint)
            throws Exception {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        trans.setBoolean(false);
        String home = System.getProperty("user.home");
        String etcPath = ClusterSOAPServer.getEtcPath();
        NSReporter.getInstance().report(NSReporter.DEBUG, "etcPath:" + etcPath);

        String[] cmds = { COMMAND_SUDO, home + EG_SCRIPT_CHECK_NFS_EXPORT,
                exportGroup, hexMountPoint, etcPath };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsBoolean trans = (SoapRpsBoolean) rps;
                trans.setSuccessful(true);
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                if (line != null && line.equalsIgnoreCase("true")) {
                    trans.setBoolean(true);
                }
            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;
    }// end function "chkHasNFS"

    /**
     * check has CIFS or not in specified mountpoint
     * 
     * @param:exportGroup,hexMountPoint,localDomainName,netbiosName
     * @return true|false
     */
    private SoapRpsBoolean chkHasCIFS(String exportGroup, String hexMountPoint,
            String localDomainName, String netbiosName) throws Exception {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        trans.setBoolean(hasExport(exportGroup, localDomainName, netbiosName,
                hexMountPoint));
        return trans;
    }// end function "chkHasCIFS"

    /**
     * check has auth or not in specified mountpoint
     * 
     * @param:hexMountPoint
     * @return true|false
     */
    private SoapRpsString chkHasAuth(String hexMountPoint) throws Exception {
        MAPDSOAPServer mapdServer = new MAPDSOAPServer();
        SoapRpsString soapString = mapdServer.getAuthRegion(hexMountPoint);
        return soapString;
    }// end function "chkHasAuth"

    /**
     * check has schedule or not in specified mountpoint
     * 
     * @param:hexMountPoint, deviceName
     * @return true|false
     */
    private SoapRpsSnapSummaryInfo chkHasSchedule(String hexMountPoint,
            String deviceName) throws Exception {
        SnapSOAPServer snapServer = new SnapSOAPServer();
        SoapRpsSnapSummaryInfo soapSnapInfo = snapServer.getSnapSchedule(
                hexMountPoint, deviceName, SNAPSHOT);
        return soapSnapInfo;
    }// end function "chkHasSchedule"

    /**
     * check fileset type in specified mountpoint
     * 
     * @param:hexMountPoint
     * @return import|export|local|-
     */
    private SoapRpsString chkFilesetType(String hexMountPoint) throws Exception {
        SoapRpsString trans = new SoapRpsString();
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + EG_SCRIPT_GETFILESETTYPE + " "
                + hexMountPoint;
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                String filesettype = "";
                SoapRpsString trans = (SoapRpsString) rps;
                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                filesettype = buf.readLine().trim();
                trans.setString(filesettype);
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        // return trans.getString();
        return trans;
    }// end function "chkFilesetType"

    /**
     * Get the output of command, if it is "true", set true in SoapRpsBoolean.
     */
    class ChkHandler extends CmdHandlerBase {
        public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                throws Exception {
            SoapRpsBoolean trans = (SoapRpsBoolean) rps;
            trans.setSuccessful(true);
            BufferedReader buf = new BufferedReader(new InputStreamReader(proc
                    .getInputStream()));
            String hasUsed = buf.readLine().trim();
            if (hasUsed.equalsIgnoreCase("true")) {
                trans.setBoolean(true);
            } else {
                trans.setBoolean(false);
            }
        }
    }// end of class ChkHandler

    /**
     * check if the mountpoint has been used in ftp
     * 
     * @param: hexMountPoint
     * @return true|false -- if has been used, return true.
     */
    public SoapRpsBoolean chkHasFtp(String hexMountPoint) throws Exception {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + EG_SCRIPT_CHK_USED_IN_FTP,
                hexMountPoint, ClusterSOAPServer.getMyNumber() };

        ChkHandler chkHandler = new ChkHandler();
        SOAPServerBase.execCmd(cmds, trans, chkHandler, chkHandler);
        return trans;
    }// end function "chkHasFtp"

    /**
     * check if the mountpoint has been used in http
     * 
     * @param: hexMountPoint
     * @return true|false -- if has been used, return true.
     */
    public SoapRpsBoolean chkHasHttp(String hexMountPoint) throws Exception {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + EG_SCRIPT_CHK_USED_IN_HTTP,
                hexMountPoint, ClusterSOAPServer.getMyNumber() };
        ChkHandler chkHandler = new ChkHandler();
        SOAPServerBase.execCmd(cmds, trans, chkHandler, chkHandler);
        return trans;
    }// end function "chkHasHttp"

    // read the file "/etc/fstab" and change one or more info lines
    public SoapRpsVector getMountPointList(String exportRoot) throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String etcPath = ClusterSOAPServer.getEtcPath();
        String home = System.getProperty("user.home");
        String cmd = COMMAND_SUDO + " " + home + FS_SCRIPT_GET_MPLIST + " "
                + etcPath + " " + exportRoot;
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsVector trans = (SoapRpsVector) rps;
                trans.setSuccessful(true);
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                Vector tmplist = new Vector();
                while (line != null) {
                    StringTokenizer st = new StringTokenizer(line.trim());
                    MountPointInfo result = new MountPointInfo();
                    result.setHexMountPoint(st.nextToken().trim());
                    result.setDeviceName(st.nextToken().trim());
                    result.setStatus(st.nextToken().trim());
                    result.setFSType(st.nextToken().trim());
                    result.setRepliStatus(st.nextToken().trim());
                    result.setHasPSID(st.nextToken().trim());
                    result.setMode(st.nextToken().trim());
                    result.setQuota(st.nextToken().trim());
                    result.setUpdate(st.nextToken().trim());
                    result.setDmAPI(st.nextToken().trim());
                    tmplist.addElement(result);
                    line = inputStr.readLine();
                }
                trans.setVector(tmplist);
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }

    public boolean hasExport(String exportRoot, String localDomain,
            String netBios, String mountPoint) {
        String etcPath = ClusterSOAPServer.getEtcPath();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND,
                home + COMMAND_CIFS_HASEXPORT, etcPath,
                GLOBALDOMAIN, localDomain, netBios, mountPoint };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsBoolean hasExport = (SoapRpsBoolean) rps;
                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result = buf.readLine();
                if (result != null && result.equals("true")) {
                    hasExport.setBoolean(true);
                } else {
                    hasExport.setBoolean(false);
                }
            }
        };
        SoapRpsBoolean temp = new SoapRpsBoolean();
        SOAPServerBase.execCmd(cmds, temp, cmdHandler);
        return temp.getBoolean();
    }

}// end class
