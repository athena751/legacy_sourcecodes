/*
 *      Copyright (c) 2001-2008 NEC Corporation
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
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.nfs.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;

public class MapdCommonSOAPServer implements NasConstants, NSExceptionMsg {

    private static final String cvsid = "@(#) $Id: MapdCommonSOAPServer.java,v 1.2314 2008/02/29 11:46:49 liy Exp $";

    private static final String NAS_EXCEP_MSG_MAPD_SET_SMB_DOMAIN_CMD = "set smb domain failed";

    private static final String SNAP_MODIFY_CRON = "/bin/snap_modifyCron.pl";

    private static final String SCRIPT_CREATE_SMBDIR = "mapnative_create_smbdir.pl";

    private static final String SCRIPT_GET_LUDB_LIST = "mapd_getludblist.pl";

    private static final String FS_CHKCONF_MASK = "unused domain";

    private static final String CMD_IMS_CHKCONF = "/bin/mapd_ims_chkconf_wrapper.pl";

    private static final String SET_LDAPINFO = "/bin/ftp_setLdapInfo.pl";

    private static final String FTP_SCRIPT_LDAP_SMBCONF_UPDATE = "/bin/ftp_ldapSmbConfUpdate.pl";

    private static final String DEL_IPTABLE = "/bin/mapd_deliptable.pl";

    private static final String SCRIPT_SMBPASSWD = "/usr/bin/smbpasswd";

    private static final String SCRIPT_CIFS_JOIN = "/bin/mapd_joindomain.pl";

    private static final String SCRIPT_SET_ADS_CONF = "mapd_setadsconf.pl";

    private static final String SCRIPT_GET_ADS_CONF = "mapd_getadsconf.pl";

    private static final String SCRIPT_LIST_ADS_CONF = "mapd_adsfilelist.pl";

    private static final String SCRIPT_GET_NIS_LIST = "/bin/mapd_getnisdomainlist.pl";

    private static final String SCRIPT_NIS_USED_BY_NFS = "/bin/mapd_nisdomainusedbynfs.pl";

    private static final String SCRIPT_GET_HAS_LDAP_SAM = "/bin/mapdcommon_getHasLdapSam.pl";

    private static final String SCRIPT_DEL_YPCONF = "mapd_delete.pl";

    private static final String SCRIPT_IPTABLE = "nsgui_iptables.sh";

    private static final String FS_SCRIPT_CHECK_NFS_EXPORT = "/bin/filesystem_chkNFSExport.pl";

    private static final String COMMAND_SMB_STATUS = "/usr/bin/smbstatus";

    private static final String SCRIPT_CHECK_NBT = "/bin/cifs_checkNetbios.pl";

    private static final String SCRIPT_CHANGE_NBT = "/bin/cifs_changeNetbios.pl";

    private static final String SCRIPT_CHANGE_NAME_RULE = "/bin/cifs_changeNameRule.pl";

    private static final String SCRIPT_CIFS_GET_SECURITY = "/bin/cifs_getSecurity.pl";

    private static final String FILE_KRB5 = "/etc/krb5.conf";

    // constructor
    public MapdCommonSOAPServer() {
    }

    private void delNative(SoapResponse trans, String localDomain,
            String authType) throws Exception {
        String cmd = "";
        if (authType.equalsIgnoreCase(AuthDomain.AUTH_SHR)) {
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + localDomain + " -o shr -f" + " " + "-c" + " "
                    + ClusterSOAPServer.getImsPath();
        } else if (authType.equalsIgnoreCase(AuthDomain.AUTH_DMC)) {
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + localDomain + " -o dmc -f" + " " + "-c" + " "
                    + ClusterSOAPServer.getImsPath();
        } else {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_CMD_FAILED);
            trans
                    .setErrorMessage("The native type should be AUTH_SHR or AUTH_DMC!");
            NSReporter.getInstance().report(NSReporter.ERROR,
                    trans.getErrorMessage());
        }

        SOAPServerBase.execCmd(cmd, trans);
    }

    private void delDomain(SoapResponse trans, String region) throws Exception {
        String cmd = SUDO_COMMAND + " " + COMMAND_IMS_DOMAIN + " -D " + region
                + " -af" + " -c " + ClusterSOAPServer.getImsPath();
        SOAPServerBase.execCmd(cmd, trans);
    }

    public SoapResponse deleteDomain(String localDomain, String region,
            String authType) throws Exception {
        SoapResponse trans = new SoapResponse();

        delNative(trans, localDomain, authType);
        if (!trans.isSuccessful()) {
            return trans;
        }

        if (!(region == null | region.equals("")))
            delDomain(trans, region);

        return trans;
    }// end function "deleteDomain"

    public SoapResponse deleteConf(String exportRoot, String localDomain,
            String hasNativeDomain) throws Exception {
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        String globeDomain = "DEFAULT";
        String[] cmds = { SUDO_COMMAND,
                home + SCRIPT_DIR + SCRIPT_DEL_LOCAL_DOMAIN_PATH,
                ClusterSOAPServer.getEtcPath(), globeDomain, localDomain,
                exportRoot, hasNativeDomain };

        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }// end function "deleteConf"

    public SoapResponse deleteAuth(String region) throws Exception {
        SoapResponse trans = new SoapResponse();
        String cmd = SUDO_COMMAND + " " + COMMAND_IMS_DOMAIN + " -D " + region
                + " -af" + " -c " + ClusterSOAPServer.getImsPath();
        SOAPServerBase.execCmd(cmd, trans);
        return trans;
    }// end function "deleteAuth"

    public SoapRpsVector getDirectMP(String exportRoot, String shift)
            throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_DIR
                + SCRIPT_GETDIRECTMP + " " + shift + " " + exportRoot + " "
                + ClusterSOAPServer.getEtcPath();

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsVector trans = (SoapRpsVector) rps;
                Vector mountPointList = new Vector();
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                while (line != null) {
                    mountPointList.addElement(line);
                    line = inputStr.readLine();
                }
                trans.setVector(mountPointList);
                trans.setSuccessful(true);
            }
        };
        
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                rps.setErrorCode(proc.exitValue());
                rps.setErrorMessage("Exec command failed! Command = "+ cmds[1]+"\n"+SOAPServerBase.getCmdErrMsg(proc.getErrorStream())+"\n");
           }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler,cmdErrHandler);
        return trans;
    }// end function "getDirectMP"

    public SoapRpsBoolean isSubMount(String path, String shift)
            throws Exception {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_DIR + SCRIPT_ISSUBMOUNT
                + " " + shift + " " + path;
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsBoolean trans = (SoapRpsBoolean) rps;
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                if (line.equalsIgnoreCase("true")) {
                    trans.setBoolean(true);
                }
                trans.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }// end function "isSubMount"

    public SoapResponse setNative(String region, String localdomain, String type)
            throws Exception {
        SoapResponse trans = new SoapResponse();

        // String cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A "
        // +region+ " -n . -f";
        String cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                + " -n . -r " + localdomain + " -o " + type + " -f" + " "
                + "-c" + " " + ClusterSOAPServer.getImsPath();

        SOAPServerBase.execCmd(cmd, trans);
        return trans;
    }

    // modify snapshot cron file when unmount a mountPoint forever and delete a
    // exportroot
    // Add by Wang Zhoufei, 2002/5/29
    public SoapResponse snapModifyCron(String path, String deviceName) {
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, home + SNAP_MODIFY_CRON, path,
                deviceName };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    public SoapRpsVector getLUDBList() throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_DIR
                + SCRIPT_GET_LUDB_LIST;

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsVector trans = (SoapRpsVector) rps;
                Vector ludblist = new Vector();
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                while (line != null) {
                    ludblist.add(line);
                    line = inputStr.readLine();
                }
                trans.setVector(ludblist);
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }

    // for filesystem and usermapping
    public SoapRpsBoolean delAuth(String mountPoint, String region) {
        SoapRpsBoolean trans = new SoapRpsBoolean();
        trans.setSuccessful(true);
        trans.setBoolean(false);
        // The auth isn't set.
        if (region.equals("")) {
            return trans;
        }

        String home = System.getProperty("user.home");
        // Delete Mapd/Auth Info

        // /home/nsadmin/filesystem_authcmd.pl for ims_auth -D -d path -f
        String[] cmd = new String[4];
        cmd[0] = COMMAND_SUDO;
        cmd[1] = home + SCRIPT_DIR + FS_SCRIPT_FILESYSTEM_AUTHCMD;
        cmd[2] = ClusterSOAPServer.getImsPath();
        cmd[3] = mountPoint;

        SOAPServerBase.execCmd(cmd, trans);
        if (!trans.isSuccessful()) {
            return trans;
        }

        // Check unused domian
        // "sudo /usr/bin/ims_chkconf -v"
        String[] chkCmd = { COMMAND_SUDO, home + CMD_IMS_CHKCONF, region,
                ClusterSOAPServer.getImsPath() };

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsBoolean transBoolean = (SoapRpsBoolean) trans;
                transBoolean.setSuccessful(true);
                transBoolean.setBoolean(false);

                BufferedReader bufferReader = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = bufferReader.readLine().trim();
                if (line.equals("true")) {
                    transBoolean.setBoolean(true);
                }
            }// end of cmdHandle
        };
        SOAPServerBase.execCmd(chkCmd, trans, cmdHandler);
        return trans;
    }

    public SoapResponse setLDAPInfo4Auth(AuthInfo info) {
        SoapResponse trans = new SoapResponse();
        String certFile = "";
        String certDir = "";
        if (info.getCAType().equals(NativeLDAPDomain.CATYPE_FILE)) {
            certFile = info.getCA();
        } else if (info.getCAType().equals(NativeLDAPDomain.CATYPE_DIR)) {
            certDir = info.getCA();
        }
        String home = System.getProperty("user.home");
        String[] cmds = {
                COMMAND_SUDO,
                home + SET_LDAPINFO,
                info.getServerName(),// ftpAuthinfo.getLdapServer(),
                info.getDistinguishedName(),// ftpAuthinfo.getLdapBaseDN(),
                info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? AuthLDAPDomain.TYPE_SIMPLE
                        : info.getAuthenticateType(),// ftpAuthinfo.getLdapMethod(),
                info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? ""
                        : info.getAuthenticateID(),// ftpAuthinfo.getLdapBindName(),
                // info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON)?
                // "":info.getAuthenticatePasswd(),//ftpAuthinfo.getLdapBindPasswd(),
                certFile,// ftpAuthinfo.getLdapCertFile(),
                certDir,// ftpAuthinfo.getLdapCertDir(),
                info.getTLS(),// ftpAuthinfo.getLdapUseTls(),
                info.getUserFilter(), info.getGroupFilter(), info.getUtoa(),
                "",// ftpAuthinfo.getLdapUserInput(),
                ClusterSOAPServer.getMyNumber(),// nodeNo,
                ClusterSOAPServer.getMyNumber(),// groupNo
                "MAPD"// ???????????????
        };
        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(false);
                int exitCode = proc.exitValue();
                if (exitCode == 101) {
                    rps.setErrorCode(NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED);
                } else {
                    rps.setErrorCode(exitCode);
                }
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc
                        .getErrorStream()));
            }
        };
        String[] inputs = { info.getAuthenticateType().equals(
                AuthLDAPDomain.TYPE_ANON) ? "" : info.getAuthenticatePasswd() };
        SOAPServerBase.execCmd(cmds, trans, errHandler, inputs);
        if (trans.isSuccessful()) {
            // set the ldapsam parameter into the smb.conf
            String[] cmds_updateSmbConf = {
                    COMMAND_SUDO,
                    home + FTP_SCRIPT_LDAP_SMBCONF_UPDATE,
                    ClusterSOAPServer.getEtcPath() + "nas_cifs/DEFAULT",// "/etc/group[0|1]/nas_cifs/DEFAULT"
                    info.getServerName(),
                    info.getTLS(),
                    info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? ""
                            : info.getAuthenticateID(),// ldap admin dn =
                    // "cn=Manager,dc=example,dc=com"
                    info.getDistinguishedName(),// ldap suffix =
                    // dc=example,dc=com
                    info.getUserFilter(),
                    info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? AuthLDAPDomain.TYPE_SIMPLE
                            : info.getAuthenticateType(),// ldap bind =
                    // simple |
                    // sasl_dmd5 |
                    // sasl_cmd5
                    certFile };
            SOAPServerBase.execCmd(cmds_updateSmbConf, trans, inputs);
        }
        return trans;
    }

    public SoapResponse setLDAPInfo4Nati(NativeInfo info) {
        SoapResponse trans = new SoapResponse();
        String certFile = "";
        String certDir = "";
        if (info.getCAType().equals(NativeLDAPDomain.CATYPE_FILE)) {
            certFile = info.getCA();
        } else if (info.getCAType().equals(NativeLDAPDomain.CATYPE_DIR)) {
            certDir = info.getCA();
        }
        String home = System.getProperty("user.home");
        String[] cmds = {
                COMMAND_SUDO,
                home + SET_LDAPINFO,
                info.getServerName(),// ftpAuthinfo.getLdapServer(),
                info.getDistinguishedName(),// ftpAuthinfo.getLdapBaseDN(),
                info.getAuthenticateType().equals(NativeLDAPDomain.TYPE_ANON) ? NativeLDAPDomain.TYPE_SIMPLE
                        : info.getAuthenticateType(),// ftpAuthinfo.getLdapMethod(),
                info.getAuthenticateType().equals(NativeLDAPDomain.TYPE_ANON) ? ""
                        : info.getAuthenticateID(),// ftpAuthinfo.getLdapBindName(),
                // info.getAuthenticateType().equals(NativeLDAPDomain.TYPE_ANON)?
                // "":info.getAuthenticatePasswd(),//ftpAuthinfo.getLdapBindPasswd(),
                certFile,// ftpAuthinfo.getLdapCertFile(),
                certDir,// ftpAuthinfo.getLdapCertDir(),
                info.getTLS(),// ftpAuthinfo.getLdapUseTls(),
                info.getUserFilter(), info.getGroupFilter(), info.getUtoa(),
                "",// ftpAuthinfo.getLdapUserInput(),
                ClusterSOAPServer.getMyNumber(),// nodeNo,
                ClusterSOAPServer.getMyNumber(),// groupNo
                "MAPD"// ???????????????????
        };

        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(false);
                int exitCode = proc.exitValue();
                if (exitCode == 101) {
                    rps.setErrorCode(NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED);
                } else {
                    rps.setErrorCode(exitCode);
                }
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc
                        .getErrorStream()));
            }
        };
        String[] inputs = { info.getAuthenticateType().equals(
                NativeLDAPDomain.TYPE_ANON) ? "" : info.getAuthenticatePasswd() };
        SOAPServerBase.execCmd(cmds, trans, errHandler, inputs);
        if (trans.isSuccessful()) {
            // set the ldapsam parameter into the smb.conf
            String[] cmds_updateSmbConf = {
                    COMMAND_SUDO,
                    home + FTP_SCRIPT_LDAP_SMBCONF_UPDATE,
                    ClusterSOAPServer.getEtcPath() + "nas_cifs/DEFAULT",// "/etc/group[0|1]/nas_cifs/DEFAULT"
                    info.getServerName(),
                    info.getTLS(),
                    info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? ""
                            : info.getAuthenticateID(),// ldap admin dn =
                    // "cn=Manager,dc=example,dc=com"
                    info.getDistinguishedName(),// ldap suffix =
                    // dc=example,dc=com
                    info.getUserFilter(),
                    info.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) ? AuthLDAPDomain.TYPE_SIMPLE
                            : info.getAuthenticateType(),// ldap bind =
                    // simple |
                    // sasl_dmd5 |
                    // sasl_cmd5
                    certFile };
            SOAPServerBase.execCmd(cmds_updateSmbConf, trans, inputs);
        }
        return trans;
    }

    public SoapResponse delIPTable(String server) {
        SoapResponse trans = new SoapResponse();
        String nodeNo = ClusterSOAPServer.getMyNumber();
        String home = System.getProperty("user.home");
        String[] cmds = { home + DEL_IPTABLE, server, nodeNo };
        SOAPServerBase.execCmd(cmds, trans);
        trans.setSuccessful(true);
        return trans;
    }

    public static SoapResponse joinDomain(String type, String domain,
            String username, String passwd, String netbiosname, String dnsServer) {
        SoapResponse trans = new SoapResponse();
        String typeOpt = "rpc";
        if (type.equals(AuthDomain.AUTH_ADS)
                || type.equals(NativeDomain.NATIVE_ADS)) {
            typeOpt = "ads";
        }

        String etcPath = ClusterSOAPServer.getEtcPath();

        String home = System.getProperty("user.home");
        String[] cmds_mkdir = {
                COMMAND_SUDO,
                home + SCRIPT_DIR + SCRIPT_CREATE_SMBDIR,
                ClusterSOAPServer.getEtcPath() + COMMAND_SMB_RM_PATH + "/"
                        + GLOBALDOMAIN + "/" + domain };
        SOAPServerBase.execCmd(cmds_mkdir, trans);
        if (!trans.isSuccessful()) {
            return trans;
        }

        String[] cifsStartCmd = { COMMAND_SUDO, home + COMMAND_CIFSSTART_SH };
        SOAPServerBase.execCmd(cifsStartCmd, new SoapResponse());
        String[] cmds = { COMMAND_SUDO, home + SCRIPT_CIFS_JOIN, "-t", typeOpt,
                "-j", domain, "-G", etcPath + COMMAND_SMB_RM_PATH, "-U",
                dnsServer, netbiosname };
        String[] inputs = { username + "%" + passwd };

        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                trans.setSuccessful(false);
                trans.setErrorCode(NAS_EXCEP_NO_MAPD_DMC_SMBPASSWD_FAILED);

                StringBuffer output = new StringBuffer();
                for (int index = 0; index < cmds.length; index++) {
                    output.append(cmds[index]).append(" ");
                }
                trans.setErrorMessage("Exec command failed! Command = "
                        + output + "\n"
                        + SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                NSReporter.getInstance().report(NSReporter.ERROR,
                        trans.getErrorMessage());
            }
        };

        SOAPServerBase.execCmd(cmds, trans, errHandler, inputs);

        return trans;
    }

    public SoapResponse setADSConf(String ntdomain, String dnsDomain,
            String kdcServer) {
        SoapResponse rps = new SoapResponse();
        String home = System.getProperty("user.home");
        String path = ClusterSOAPServer.getEtcPath() + COMMAND_SMB_RM_PATH
                + "/" + GLOBALDOMAIN + "/" + ntdomain + "/";
        String[] cmds = { SUDO_COMMAND,
                home + SCRIPT_DIR + SCRIPT_SET_ADS_CONF, path, dnsDomain,
                kdcServer };
        SOAPServerBase.execCmd(cmds, rps);
        return rps;
    }

    public SoapRpsVector getADSConf(String ntdomain, String groupNo)
            throws Exception {
        SoapRpsVector trans = new SoapRpsVector();

        String origmyNumber = ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);
        try {
            trans = getADSConf(ntdomain);
        } catch (NSException e) {
            throw e;
        } finally {
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return trans;
    }

    public SoapRpsVector getADSConf(String ntdomain) throws Exception {
        SoapRpsVector rps = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String path = ClusterSOAPServer.getEtcPath() + COMMAND_SMB_RM_PATH
                + "/" + GLOBALDOMAIN + "/" + ntdomain + "/";
        String[] cmds = { SUDO_COMMAND,
                home + SCRIPT_DIR + SCRIPT_GET_ADS_CONF, path };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsVector transRpsVec = (SoapRpsVector) trans;
                Vector v = new Vector();
                BufferedReader b = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                String dnsDomain = b.readLine();
                String kdcServer = b.readLine();
                v.add(dnsDomain == null ? "" : dnsDomain);
                v.add(kdcServer == null ? "" : kdcServer);
                transRpsVec.setVector(v);
                transRpsVec.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, rps, cmdHandler);
        return rps;
    }

    public SoapResponse checkoutADSFiles(String ntdomain) {
        SoapResponse rps = new SoapRpsVector();
        String etcPath = ClusterSOAPServer.getEtcPath();
        rps = adsFileList(ntdomain);
        if (!rps.isSuccessful()) {
            return rps;
        }
        Vector files = ((SoapRpsVector) rps).getVector();
        String krbFile = FILE_KRB5;
        files.add(krbFile);
        String home = System.getProperty("user.home");
        // create <ntdomain> dir when it doesn't exist
        String[] cmds_mkdir = {
                COMMAND_SUDO,
                home + SCRIPT_DIR + SCRIPT_CREATE_SMBDIR,
                etcPath + COMMAND_SMB_RM_PATH + "/" + GLOBALDOMAIN + "/"
                        + ntdomain };
        SOAPServerBase.execCmd(cmds_mkdir, rps);
        if (!rps.isSuccessful()) {
            return rps;
        }

        return checkoutFiles(files);
    }

    public SoapResponse checkinADSFiles(String ntdomain) {
        SoapResponse rps = new SoapRpsVector();
        rps = adsFileList(ntdomain);
        if (!rps.isSuccessful()) {
            return rps;
        }
        Vector files = ((SoapRpsVector) rps).getVector();
        String krbFile = FILE_KRB5;
        files.add(krbFile);
        checkinFiles(files);
        rps.setSuccessful(true);
        return rps;
    }

    public SoapResponse rollbackADSFiles(String ntdomain) {
        SoapResponse rps = new SoapRpsVector();
        rps = adsFileList(ntdomain);
        if (!rps.isSuccessful()) {
            return rps;
        }
        Vector files = ((SoapRpsVector) rps).getVector();
        String krbFile = FILE_KRB5;
        files.add(krbFile);
        rollbackFiles(files);
        rps.setSuccessful(true);
        return rps;
    }

    private SoapRpsVector adsFileList(String ntdomain) {
        SoapRpsVector rps = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String path = ClusterSOAPServer.getEtcPath() + COMMAND_SMB_RM_PATH
                + "/" + GLOBALDOMAIN + "/" + ntdomain + "/";
        String[] cmds = { SUDO_COMMAND,
                home + SCRIPT_DIR + SCRIPT_LIST_ADS_CONF, path };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsVector transRpsVec = (SoapRpsVector) trans;
                Vector files = new Vector();
                BufferedReader b = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                for (String f = b.readLine(); f != null; f = b.readLine()) {
                    files.add(f);
                }
                transRpsVec.setVector(files);
                transRpsVec.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, rps, cmdHandler);
        return rps;
    }

    private SoapResponse checkoutFiles(Vector files) {
        SoapResponse rps = new SoapResponse();
        for (int i = 0; i < files.size(); i++) {
            rps = Transaction.checkout((String) files.get(i));
            if (!rps.isSuccessful()) {
                for (int j = 0; j < i; j++) {
                    Transaction.rollback((String) files.get(j));
                }
                return rps;
            }
        }
        return rps;
    }

    private void checkinFiles(Vector files) {
        for (int i = 0; i < files.size(); i++) {
            Transaction.checkin((String) files.get(i));
        }
    }

    private void rollbackFiles(Vector files) {
        for (int i = 0; i < files.size(); i++) {
            Transaction.rollback((String) files.get(i));
        }
    }

    public SoapRpsVector getNISDomainList() throws Exception {
        SoapRpsVector rps = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_GET_NIS_LIST };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsVector transRpsVec = (SoapRpsVector) trans;
                Set nisSet = new TreeSet();
                BufferedReader b = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                for (String f = b.readLine(); f != null; f = b.readLine()) {
                    nisSet.add(f);
                }
                Iterator it = nisSet.iterator();
                Vector nisVec = new Vector();
                while (it.hasNext()) {
                    nisVec.add(it.next());
                }
                transRpsVec.setVector(nisVec);
                transRpsVec.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, rps, cmdHandler);
        return rps;
    }

    public SoapRpsBoolean isUsedNISDomainByNFS(String nisDomain)
            throws Exception {
        SoapRpsBoolean rps = new SoapRpsBoolean();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_NIS_USED_BY_NFS,
                ClusterSOAPServer.getEtcPath(), nisDomain };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsBoolean transRpsBln = (SoapRpsBoolean) trans;
                BufferedReader b = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                String ret = b.readLine();
                transRpsBln.setBoolean(ret.equals("yes"));
                transRpsBln.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, rps, cmdHandler);
        return rps;
    }

    public SoapRpsString getHasLdapSam(String localdomain, String netbios)
            throws Exception {
        SoapRpsString trans = new SoapRpsString();

        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_GET_HAS_LDAP_SAM,
                ClusterSOAPServer.getEtcPath() + "nas_cifs/DEFAULT",
                localdomain, netbios };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc,
                    String[] cmds) throws Exception {
                SoapRpsString transStr = (SoapRpsString) trans;
                BufferedReader buf = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                String result = buf.readLine();
                transStr.setString(result);
                transStr.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;
    }

    public SoapResponse delYPConf(String domain, String server)
            throws Exception {
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_DEL_YPCONF,
                home + SCRIPT_DIR + SCRIPT_IPTABLE, FILE_MAPD_YPCONF, domain,
                server };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    public SoapRpsInteger checkExport(String exportGroup,
            String localDomainName, String netbiosName, String mountPoint)
            throws Exception {
        SoapRpsInteger trans = new SoapRpsInteger();
        trans.setInt(0);

        // check if the mountpoint has been used in nfs
        String home = System.getProperty("user.home");
        String etcPath = ClusterSOAPServer.getEtcPath();
        String[] cmds = { COMMAND_SUDO, home + FS_SCRIPT_CHECK_NFS_EXPORT,
                exportGroup, mountPoint, etcPath };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsInteger trans = (SoapRpsInteger) rps;
                trans.setSuccessful(true);
                BufferedReader inputStr = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                if (line != null && line.equalsIgnoreCase("true")) {
                    trans.setInt(1);
                }
            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);

        if (!trans.isSuccessful() || trans.getInt() != 0) {
            return trans;
        }

        // check if the mountpoint has been used in cifs
        ExportRootSOAPServer erServer = new ExportRootSOAPServer();
        if (erServer.hasExport(exportGroup, localDomainName, netbiosName,
                mountPoint)) {
            trans.setInt(2);
            return trans;
        }
        // check if the mountpoint has been used in ftp
        SoapRpsBoolean tmp = erServer.chkHasFtp(mountPoint);
        if (tmp.getBoolean()) {
            trans.setInt(3);
            return trans;
        }
        // check if the mountpoint has been used in http
        /*
         * Reference: nsgui-necas-sv4 1059, delete this check. tmp =
         * erServer.chkHasHttp(mountPoint); if(tmp.getBoolean()) {
         * trans.setInt(4); }
         */
        return trans;
    }

    public SoapResponse getNetbiosStatus(String localDomain, String netbios)
            throws Exception {
        // modified by zhangjx 2006.8.21 for 10000 cifs share
        /*
         * SoapRpsVector tmp = getSharesList(GLOBALDOMAIN, localDomain,
         * netbios); if (!tmp.isSuccessful()){ return tmp; } Vector shares =
         * tmp.getVector(); if (shares != null){ for(int i=0; i<shares.size();
         * i++){ SMBShareInfo tempShare = (SMBShareInfo)shares.get(i); String
         * sharename = tempShare.getShareName(); sharename = new String
         * (NSUtil.hStr2Bytes (sharename), NSUtil.ISO8859); SoapResponse rps=
         * getStatus(localDomain,netbios,sharename); if (!rps.isSuccessful()){
         * return rps; } } }
         */
        SoapResponse rps = getStatus(localDomain, netbios, ".+");
        if (!rps.isSuccessful()) {
            return rps;
        }
        SoapResponse rt = new SoapResponse();
        rt.setSuccessful(true);
        return rt;
    }

    public SoapResponse getStatus(String localDomain, String netBios,
            String shareName) {
        SoapResponse trans = new SoapResponse();
        // /usr/bin/smbstatus's parameter is .+ for 10000 cifs share
        // modified by zhangjx 2006.8.21
        String all_shareName = ".+";
        String etcPath = ClusterSOAPServer.getEtcPath();
        String cifsPath = etcPath + COMMAND_SMB_RM_PATH;
        String[] cmds = { SUDO_COMMAND, COMMAND_SMB_STATUS, "-L0", "-g",
                cifsPath, "-l", localDomain, "-n", netBios, "-k", all_shareName };

        // if the output line >4 ,some user is using the cifs
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(true);
                parseSmbStatus(rps, proc);
            }
        };

        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                int ret = proc.exitValue();
                if (ret == -1) {
                    rps.setSuccessful(false);
                    rps.setErrorCode(NAS_EXCEP_NO_SMBSTATUS_ERROR);
                    CmdHandlerBase.setCmdErrorMessage(rps, proc, cmds);
                } else {
                    rps.setSuccessful(true);
                    parseSmbStatus(rps, proc);
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler, errHandler);
        return trans;
    }

    private void parseSmbStatus(SoapResponse rps, Process proc)
            throws Exception {
        InputStreamReader bufReader = new InputStreamReader(proc
                .getInputStream());
        BufferedReader buf = new BufferedReader(bufReader);
        String result = buf.readLine();
        int lineCount = 0;
        while (result != null) {
            lineCount++;
            if (lineCount > 4) {
                rps.setSuccessful(false);
                rps.setErrorCode(NAS_EXCEP_NO_SMBSTATUS_WARN);
                break;
            }

            result = buf.readLine();
        }
    }

    public SoapRpsBoolean checkNetbios(String netbios) throws Exception {
        String etcPath = ClusterSOAPServer.getEtcPath();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_CHECK_NBT, etcPath,
                GLOBALDOMAIN, netbios };
        SoapRpsBoolean rt = new SoapRpsBoolean();
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsBoolean trans = (SoapRpsBoolean) rps;
                BufferedReader buf = new BufferedReader(new InputStreamReader(
                        proc.getInputStream()));
                String result = buf.readLine();
                if (result != null && result.trim().equals("exist")) {
                    trans.setBoolean(true);
                } else {
                    trans.setBoolean(false);
                }
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, rt, cmdHandler);
        return rt;
    }

    public SoapResponse changeNetbios(String exportRoot, String localDomain,
            String oldNetbios, String newNetbios, String security)
            throws Exception {
        SoapResponse rt = new SoapResponse();
        String etcPath = ClusterSOAPServer.getEtcPath();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_CHANGE_NBT, etcPath,
                GLOBALDOMAIN, exportRoot, localDomain, oldNetbios, newNetbios,
                security };
        SOAPServerBase.execCmd(cmds, rt);
        return rt;
    }

    public SoapResponse changeNameRule(String localDomain, String oldNetbios,
            String newNetbios) throws Exception {
        SoapResponse rt = new SoapResponse();
        String etcPath = ClusterSOAPServer.getEtcPath();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_CHANGE_NAME_RULE,
                etcPath, localDomain, oldNetbios, newNetbios };
        SOAPServerBase.execCmd(cmds, rt);
        return rt;
    }

    public SoapRpsString getSecurity(String localdomain, String netbios)
            throws Exception {
        SoapRpsString trans = new SoapRpsString();
        String home = System.getProperty("user.home");
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_CIFS_GET_SECURITY,
                ClusterSOAPServer.getEtcPath(), GLOBALDOMAIN, localdomain,
                netbios };
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsString trans = (SoapRpsString) rps;
                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result = buf.readLine().trim();
                trans.setString(result);
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;
    }

}// end class
