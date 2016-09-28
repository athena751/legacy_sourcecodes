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

import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.nfs.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;

public class MAPDSOAPServer implements NasConstants, NSExceptionMsg {

    private static final String cvsid = "@(#) $Id: MAPDSOAPServer.java,v 1.2313 2007/04/26 07:37:50 wanghb Exp $";

    private static final String SCRIPT_GET_FS_TYPE_FROM_FSTAB = "mapdcommon_getFsTypeByFstab.pl";

    private static final String SCRIPT_PWD = "mapd_pwd.pl";

    private static final String SCRIPT_IPTABLE = "nsgui_iptables.sh";

    private static final String SCRIPT_MAPD_NEW_REPLACE = "mapd_replace.pl";

    private static final String SCRIPT_BUILDSID = "/bin/mapd_buildsid.pl";

    private static final String SCRIPT_COPYSMBPWD = "/bin/mapd_cpsmbpwd.pl";

    private static final String SCRIPT_REMOVESMBPWD = "/bin/mapd_rmsmbpwd.pl";

    private static final String SCRIPT_COPYLUDB = "/bin/mapd_cpludb.pl";

    private static final String SCRIPT_REMOVELUDB = "/bin/mapd_rmludb.pl";

    private static final String SCRIPT_GETLUDBROOT = "/usr/bin/ludb_admin";

    private static final String SCRIPT_ADDLDAPIPTABLES = "/bin/mapd_addldapiptable.pl";

    private static final String SCRIPT_ADDLDAPDOMAIN = "/bin/mapd_addldapdomain.pl";

    private static final String AUTHNIS = "nis";

    private static final String AUTHPWD = "pwd";

    private static final String AUTHSHR = "shr";

    private static final String AUTHDMC = "dmc";

    private static final String GROUP = "group";

    private static final String NATIVE_COMMENT = ".";

    private String region = "";

    private ArrayList ypList = new ArrayList();

    private static final String YPBIND_CMD = "/etc/rc.d/init.d/ypbind";

    private static final String YPBIND_RESTART = "restart";

    private static final String YPBIND_START = "start";

    private static final String YPBIND_STATUS = "status";

    private void res2str(SoapResponse temp, SoapRpsString trans) {
        trans.setSuccessful(temp.isSuccessful());
        trans.setErrorCode(temp.getErrorCode());
        trans.setErrorMessage(temp.getErrorMessage());
    }

    // 4.1.3.1
    public SoapRpsString setAuthNIS(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();
        SoapResponse temp = null;

        if (auth.getAuthType().equals(AuthDomain.AUTH_NISW)) {
            auth.setHasNIS(auth.getHasNISW());
        } else {
            auth.setHasNIS(auth.getHasNISU());
        }

        // check out yp.conf

        if (!auth.getHasNIS()
                || (!auth.getHasAuth() && auth.getNameChange().equals(
                        REQUEST_PARAMETER_NAMECHANGE_VALUE))
                || auth.getHasAuth()) {
            temp = Transaction.checkout(FILE_MAPD_YPCONF);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                return trans;
            }
        }

        // 1.writeYPConf
        if (!auth.getHasNIS()) {
            writeYPConf(auth.getDomain(), auth.getServer(), null, trans);
            if (!trans.isSuccessful()) {
                // rollbackYPConf();
                return trans;
            }
        } else {
            if ((!auth.getHasAuth() && auth.getNameChange().equals(
                    REQUEST_PARAMETER_NAMECHANGE_VALUE))
                    || auth.getHasAuth()) {
                writeYPConf(auth.getDomain(), auth.getServer(), auth
                        .getOldServer(), trans);
                if (!trans.isSuccessful()) {
                    // rollbackYPConf();
                    return trans;
                }
            }
        }

        boolean bCheckout = false;// whether need deal with smb.conf
        String smbPath = "";

        // write SmbConf
        String sid = "";
        if (auth.getAuthType().equals(AuthDomain.AUTH_NISW)
                && !auth.getHasNIS()) {
            trans = smbBeforeSid(auth);
            if (!trans.isSuccessful()) {
                rollbackYPConf();
                return trans;
            }
            smbPath = trans.getString();
            bCheckout = true;

            trans = buildSID(auth);
            if (!trans.isSuccessful()) {
                rollbackYPConf();
                Transaction.rollback(smbPath);
                return trans;
            }
            sid = trans.getString();
        }

        // 2.if it's the first time, ims_domain -A

        if ((auth.getAuthType().equals(AuthDomain.AUTH_NIS))
                && (!auth.getHasNISU())
                || (auth.getAuthType().equals(AuthDomain.AUTH_NISW))
                && (!auth.getHasNISW())) {
            setNISMapdDomain(auth.getExportRoot(), auth.getDomain(), auth
                    .getAuthType(), sid, trans);
            if (!trans.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }
                rollbackYPConf();
                return trans;
            }
        } else {
            region = auth.getRegion();
        }

        // 3.setMapdAuth
        if (!auth.isFromCIFS()) {
            setMapdAuth(region, auth.getPath(), trans);
            if (!trans.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }

                if (!auth.getHasNIS()
                        || (!auth.getHasAuth() && auth.getNameChange().equals(
                                REQUEST_PARAMETER_NAMECHANGE_VALUE)))
                    rollbackYPConf();

                if (!auth.getHasNIS())
                    setMapdDelete(region);

                return trans;
            }
        }

        // check in yp.conf
        if (!auth.getHasNIS()
                || (!auth.getHasAuth() && auth.getNameChange().equals(
                        REQUEST_PARAMETER_NAMECHANGE_VALUE))
                || auth.getHasAuth()) {
            temp = Transaction.checkin(FILE_MAPD_YPCONF);
            if (!temp.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }

                if (!auth.getHasNIS() && !auth.isFromCIFS())
                    setMapdDelete(region);

                rollbackYPConf();
                res2str(temp, trans);
                return trans;
            }
            if (bCheckout) {
                temp = Transaction.checkin(smbPath);
                if (!temp.isSuccessful()) {
                    if (!auth.getHasNIS() && !auth.isFromCIFS())
                        setMapdDelete(region);
                    res2str(temp, trans);
                    return trans;
                }
                execXsmbd();
            }
        }

        // return
        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    }

    public SoapRpsString smbBeforeSid(AuthInfo auth) {
        // check out files
        SoapRpsString trans = getSMBConf(auth.getGlobalDomain(), auth
                .getLocalDomain(), auth.getNetBios());
        if (!trans.isSuccessful()) {
            return trans;
        }

        String smbPath = trans.getString();
        SoapResponse temp = Transaction.checkout(smbPath);
        if (!temp.isSuccessful()) {
            res2str(temp, trans);
            return trans;
        }

        // Write the files
        String content = "workgroup = " + auth.getLocalDomain() + "\n"
                + "security = user\n";

        if (auth.getAuthType().equals(AuthDomain.AUTH_NISW)) {
            content = content + "#user database type = nis\n"
                    + "smb passwd file = %r/%D/smbpasswd.%L\n"
                    + "pam service name = xsmbd_ims\n";
        } else if (auth.getAuthType().equals(AuthDomain.AUTH_PWDW)) {
            SoapRpsString tempRps = getLUDBRoot();
            if (!tempRps.isSuccessful()) {
                return tempRps;
            }
            String ludbRoot = ((SoapRpsString) tempRps).getString();
            content = content + "#user database type = passwd\n"
                    + "smb passwd file = " + ludbRoot
                    + "/.nas_cifs/%r/%D/smbpasswd.%L\n";
        } else if (auth.getAuthType().equals(AuthDomain.AUTH_LDAPUW)) {
            content = content + "#user database type=ldap\n"
                    + "smb passwd file =  %r/%D/smbpasswd.%L\n"
                    + "pam service name = xsmbd_ldap\n";
        }
        writeSmbConf(auth.getGlobalDomain(), auth.getLocalDomain(), auth
                .getNetBios(), content, trans);
        if (!trans.isSuccessful()) {
            Transaction.rollback(smbPath);
            return trans;
        }
        return trans;
    }

    // 4.1.3.2
    public SoapRpsString setAuthPWD(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();
        SoapResponse temp = null;
        String ludbInfoFile = ClusterSOAPServer.getEtcPath() + "ludb.info";
        boolean ludbCheckOut = false;
        if (auth.getAuthType().equals(AuthDomain.AUTH_PWDW)
                && !auth.getHasPWDW()
                || auth.getAuthType().equals(AuthDomain.AUTH_PWD)
                && !auth.getHasPWD()) {
            temp = Transaction.checkout(ludbInfoFile);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                return trans;
            }
            ludbCheckOut = true;
            SoapResponse tempRps = copyLUDB(auth, "true");
            if (!tempRps.isSuccessful()) {
                Transaction.rollback(ludbInfoFile);
                res2str(tempRps, trans);
                return trans;
            }
        }

        boolean bCheckout = false;// whether need deal with smb.conf
        String smbPath = "";

        // write SmbConf
        String sid = "";
        if (auth.getAuthType().equals(AuthDomain.AUTH_PWDW)
                && !auth.getHasPWDW()) {
            trans = smbBeforeSid(auth);
            if (!trans.isSuccessful()) {
                if (ludbCheckOut) {
                    Transaction.rollback(ludbInfoFile);
                }
                removeLUDB(auth);
                return trans;
            }
            smbPath = trans.getString();
            bCheckout = true;

            trans = buildSID(auth);
            if (!trans.isSuccessful()) {
                Transaction.rollback(smbPath);
                if (ludbCheckOut) {
                    Transaction.rollback(ludbInfoFile);
                }
                removeLUDB(auth);
                return trans;
            }
            sid = trans.getString();
        }

        // 1.if it's the first time, ims_domain -A
        if ((auth.getAuthType().equals(AuthDomain.AUTH_PWD))
                && (!auth.getHasPWDU())
                || (auth.getAuthType().equals(AuthDomain.AUTH_PWDW))
                && (!auth.getHasPWDW())) {
            setPWDMapdDomain(auth, sid, trans);
            if (!trans.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }
                if (ludbCheckOut) {
                    Transaction.rollback(ludbInfoFile);
                }
                removeLUDB(auth);
                return trans;
            }
        } else {
            region = auth.getRegion();
        }

        // 2.setMapdAuth
        if (!auth.isFromCIFS()) {
            setMapdAuth(region, auth.getPath(), trans);

            if (!trans.isSuccessful()) {
                if (auth.getAuthType().equals(AuthDomain.AUTH_PWDW)
                        && !auth.getHasPWDW()
                        || auth.getAuthType().equals(AuthDomain.AUTH_PWD)
                        && !auth.getHasPWD()) {
                    removeLUDB(auth);
                }

                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }

                if (ludbCheckOut) {
                    Transaction.rollback(ludbInfoFile);
                }
                if (!auth.getHasPWD())
                    setMapdDelete(region);

                return trans;
            }
        }
        if (bCheckout) {
            temp = Transaction.checkin(smbPath);
            if (!temp.isSuccessful()) {
                if (!auth.getHasPWD() && !auth.isFromCIFS())
                    setMapdDelete(region);
                res2str(temp, trans);
                return trans;
            }
            execXsmbd();
        }
        if (ludbCheckOut) {
            temp = Transaction.checkin(ludbInfoFile);
        }
        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    }

    public SoapResponse removeSHRFile(AuthInfo auth) {
        SoapResponse trans = new SoapResponse();
        String cmdsTouch[] = {
                COMMAND_SUDO,
                "rm",
                "-f",
                "/etc/group" + ClusterSOAPServer.getMyNumber()
                        + "/nas_cifs/DEFAULT/" + auth.getLocalDomain()
                        + "/smbpasswd." + auth.getNetBios() };
        SOAPServerBase.execCmd(cmdsTouch, trans);
        return trans;
    }

    // 4.1.3.3
    public SoapRpsString setAuthSHR(AuthInfo auth) throws Exception {
        SoapRpsString trans = new SoapRpsString();
        SoapResponse temp = null;
        boolean bCheckout = false;// whether need deal with smb.conf
        String smbPath = "";

        // 1 write SmbConf
        if (!auth.getHasSHR()) {
            // check out files
            trans = getSMBConf(auth.getGlobalDomain(), auth.getLocalDomain(),
                    auth.getNetBios());
            if (!trans.isSuccessful()) {
                return trans;
            }

            smbPath = trans.getString();
            temp = Transaction.checkout(smbPath);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                return trans;
            }
            bCheckout = true;

            SoapRpsString tmpRps = (new MapdCommonSOAPServer()).getSecurity(
                    auth.getLocalDomain(), auth.getNetBios());
            if (!tmpRps.isSuccessful()) {
                Transaction.rollback(smbPath);
                return tmpRps;
            }

            if (tmpRps.getString() == null
                    || tmpRps.getString().trim().equals("")) {
                String cmdsTouch[] = {
                        COMMAND_SUDO,
                        "touch",
                        "/etc/group" + ClusterSOAPServer.getMyNumber()
                                + "/nas_cifs/DEFAULT/" + auth.getLocalDomain()
                                + "/smbpasswd." + auth.getNetBios() };
                SOAPServerBase.execCmd(cmdsTouch, trans);
                if (!trans.isSuccessful()) {
                    Transaction.rollback(smbPath);
                    return trans;
                }
            }
            // Write the files
            String content = "workgroup = " + auth.getLocalDomain() + "\n"
                    + "smb passwd file = %r/%D/smbpasswd.%L\n"
                    + "security = share\n";
            writeSmbConf(auth.getGlobalDomain(), auth.getLocalDomain(), auth
                    .getNetBios(), content, trans);
            if (!trans.isSuccessful()) {
                Transaction.rollback(smbPath);
                return trans;
            }

        }

        // 2 if it's the first time, ims_domain -A
        if (!auth.getHasSHR()) {
            trans = setSHRMapdDomain(auth.getExportRoot(), auth.getUserName(),
                    auth.getUID(), auth.getGroupName(), auth.getGID());
            if (!trans.isSuccessful()) {
                if (bCheckout)
                    Transaction.rollback(smbPath);
                return trans;
            }

        } else {
            region = auth.getRegion();
        }

        // 3.setMapdAuth
        setMapdAuth(region, auth.getPath(), trans);
        if (!trans.isSuccessful()) {
            if (bCheckout)
                Transaction.rollback(smbPath);
            if (!auth.getHasSHR())
                setMapdDelete(region);
            return trans;
        }

        if (bCheckout) {
            temp = Transaction.checkin(smbPath);
            if (!temp.isSuccessful()) {
                Transaction.rollback(smbPath);
                if (!auth.getHasSHR())
                    setMapdDelete(region);
                res2str(temp, trans);
                return trans;
            }
            execXsmbd();
        }

        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    }

    // 4.1.3.4
    public SoapRpsString setAuthDMC(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();

        SoapResponse temp = null;
        SoapRpsString transTemp = null;
        String smbPath = "";

        boolean bCheckout = false;

        boolean smbNeed = auth.getSmbNeed();

        // 1.write SmbConf
        if (!auth.getHasDMC()) {
            // check out files
            transTemp = getSMBConf(auth.getGlobalDomain(), auth
                    .getLocalDomain(), auth.getNetBios());
            if (!transTemp.isSuccessful()) {
                return transTemp;
            }
            smbPath = transTemp.getString();
            temp = Transaction.checkout(smbPath);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                return trans;
            }

            bCheckout = true;
            // Write the files
            String content = "workgroup = " + auth.getLocalDomain() + "\n"
                    + "security = domain\n" + "password server = *\n";
            writeSmbConf(auth.getGlobalDomain(), auth.getLocalDomain(), auth
                    .getNetBios(), content, trans);
            if (!trans.isSuccessful()) {
                Transaction.rollback(smbPath);
                return trans;
            }

        }
        String username = auth.getUserName();
        // 2.execute smbpasswd
        if (smbNeed && (!auth.getHasDMC()) && username != null
                && !username.trim().equals("")) {
            temp = MapdCommonSOAPServer.joinDomain(AuthDomain.AUTH_DMC, auth
                    .getDomain(), username, auth.getPassword(), auth
                    .getNetBios(), "");
            if (!temp.isSuccessful()) {
                Transaction.rollback(smbPath);
                res2str(temp, trans);
                return trans;
            }
        }

        // 3.if it's the first time, ims_domain -A
        if (!auth.getHasDMC()) {
            // String param2=auth.getLocalDomain()+":"+auth.getNetBios();
            setDMCMapdDomain(auth.getExportRoot(), auth.getGlobalDomain(), auth
                    .getLocalDomain(), trans);
            if (!trans.isSuccessful()) {
                Transaction.rollback(smbPath);
                return trans;
            }
        } else {
            region = auth.getRegion();
        }

        // 4.setMapdAuth
        setMapdAuth(region, auth.getPath(), trans);
        if (!trans.isSuccessful()) {
            if (bCheckout)
                Transaction.rollback(smbPath);

            if (!auth.getHasDMC())
                setMapdDelete(region);

            return trans;
        }

        if (bCheckout) {
            temp = Transaction.checkin(smbPath);
            if (!temp.isSuccessful()) {
                Transaction.rollback(smbPath);

                if (!auth.getHasDMC())
                    setMapdDelete(region);

                res2str(temp, trans);
                return trans;
            }
            execXsmbd();
        }

        // return
        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    }

    private void execXsmbd() {
        String home = System.getProperty("user.home");
        String[] cmd = { COMMAND_SUDO, home + COMMAND_CIFSSTART_SH };
        SOAPServerBase.execCmd(cmd, new SoapResponse());
    }

    private void execYPBind(SoapResponse trans) {
        // Exec /etc/init.d/ypbind status
        String[] ypCmd = new String[3];
        ypCmd[0] = COMMAND_SUDO;
        ypCmd[1] = YPBIND_CMD;
        ypCmd[2] = YPBIND_STATUS;

        SOAPServerBase.execCmd(ypCmd, trans);

        if (trans.isSuccessful()) {
            ypCmd[2] = YPBIND_RESTART;
        } else {
            ypCmd[2] = YPBIND_START;
        }

        trans.setSuccessful(false);

        // CmdHandlerBase cmdhandler = new
        // CmdHandlerBase(NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED);
        CmdErrHandler errhandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(false);
                rps.setErrorCode(NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED);
                String back[] = { COMMAND_SUDO, YPBIND_CMD, YPBIND_START };
                SOAPServerBase.execCmd(back, new SoapResponse());
            }
        };

        SOAPServerBase.execCmd(ypCmd, trans, errhandler);

    }

    // 4.1.3.7
    public SoapResponse writeYPConf(String i_domain, String i_server,
            String oldServer) throws Exception {
        SoapResponse trans = null;

        if (oldServer == "") {
            oldServer = null;
        }
        // check out yp.conf
        trans = Transaction.checkout(FILE_MAPD_YPCONF);
        if (!trans.isSuccessful()) {
            return trans;
        }
        // 1.writeYPConf
        i_domain = i_domain.trim();
        i_server = i_server.trim();
        writeYPConf(i_domain, i_server, oldServer, trans);
        if (!trans.isSuccessful()) {
            // rollbackYPConf();
            return trans;
        } else {
            trans = Transaction.checkin(FILE_MAPD_YPCONF);
            if (!trans.isSuccessful()) {
                rollbackYPConf();
                return trans;
            }
        }

        trans.setSuccessful(true);
        return trans;
    }

    public void writeYPConf(String i_domain, String i_server,
            String i_oldServer, SoapResponse trans) {

        // Exec write YP Conf
        String home = System.getProperty("user.home");
        final String[] cmd = { COMMAND_SUDO,
                home + SCRIPT_DIR + SCRIPT_MAPD_NEW_REPLACE,
                home + SCRIPT_DIR + SCRIPT_IPTABLE, FILE_MAPD_YPCONF, i_domain,
                i_server };

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(true);

                BufferedReader bufferReader = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String line = null;
                while ((line = bufferReader.readLine()) != null) {
                    ypList.add(line);
                }
                if (ypList.size() == 0
                        || !(((String) ypList.get(0)).equals("0"))) {
                    rps.setSuccessful(false);
                    rps.setErrorCode(NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED);
                }
            }
        };
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);

        if (!trans.isSuccessful()) {
            rollbackYPConf();
            return;
        }

        execYPBind(trans);

        if (!trans.isSuccessful()) {
            rollbackYPConf();
        }
        return;
    }

    private void rollbackYPConf() {
        // if(true) return;
        Transaction.rollback(FILE_MAPD_YPCONF);
        if (ypList.size() <= 2) {
            return;
        }

        Iterator it = ypList.iterator();
        it.next();
        String serv = (String) it.next();
        while (!serv.equals("")) {
            iptablesAdd(serv);
            serv = (String) it.next();
        }

        while (it.hasNext()) {
            serv = (String) it.next();
            iptablesDel(serv);
        }
    }

    private void iptablesAdd(String i_server) {
        String home = System.getProperty("user.home");
        String cmds[] = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_IPTABLE,
                "-A", "-s", i_server, "512:65535/udp" };
        SOAPServerBase.execCmd(cmds, new SoapResponse());
    }

    private void iptablesDel(String i_server) {
        String home = System.getProperty("user.home");
        String back[] = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_IPTABLE,
                "-D", "-s", i_server, "512:65535/udp" };
        SOAPServerBase.execCmd(back, new SoapResponse());
    }

    /* Get the Region from proc */
    class RegionHandler implements CmdHandler {
        public void cmdHandle(SoapResponse trans, Process proc, String[] cmds)
                throws Exception {

            InputStreamReader bufReader = new InputStreamReader(proc
                    .getInputStream());
            BufferedReader buf = new BufferedReader(bufReader);
            String tmp = (buf.readLine()).trim();
            // region in the front of output
            int mark = tmp.indexOf(" ");
            region = tmp.substring(0, mark);
            // region in the front of output (end)

            // region in the end of output
            /*
             * StringTokenizer st = new StringTokenizer(tmp,"/");
             * while(st.hasMoreTokens()){ region = st.nextToken(); }
             */
            // region in the end of output (end)
            if (trans instanceof SoapRpsString) {
                SoapRpsString trans1 = (SoapRpsString) trans;
                trans1.setSuccessful(true);
                trans1.setString(region);
            } else {
                trans.setSuccessful(true);
            }
        }

    }

    // The following 4 methods need refactoring
    // ims_domain -A Comment nis -o "domain=NISDomainName" -f
    private void setNISMapdDomain(String i_export, String i_domain,
            String type, String sid, SoapResponse trans) {
        int rnValue = NAS_SUCCESS;
        i_export = NSUtil.trimExport(i_export);

        if (type.equals(AuthDomain.AUTH_NIS)) {
            String cmd[] = { COMMAND_SUDO, COMMAND_IMS_DOMAIN, "-A", i_export,
                    AUTHNIS, "-o", "domain=" + i_domain, "-f", "-c",
                    ClusterSOAPServer.getImsPath() };
            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        } else {
            String cmd[] = { COMMAND_SUDO, COMMAND_IMS_DOMAIN, "-A", i_export,
                    MAPDSOAPServer.AUTHNIS, "-o", "domain=" + i_domain, "-o",
                    "sidprefix=" + sid, "-f", "-c",
                    ClusterSOAPServer.getImsPath() };
            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        }
    }

    private void setNISNativeDomain(String i_domain, String nodeNum,
            SoapResponse trans) {
        String cmd[] = { COMMAND_SUDO, COMMAND_IMS_DOMAIN, "-A", "." + nodeNum,
                AUTHNIS, "-o", "domain=" + i_domain, "-f", "-c",
                ClusterSOAPServer.getImsPath() };
        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
    }

    private void setPWDNativeDomain(NativeInfo nati, String nodeNum,
            SoapResponse trans) {
        String cmd[] = { COMMAND_SUDO, COMMAND_IMS_DOMAIN, "-A", "." + nodeNum,
                AUTHPWD, "-o", "passwd=" + nati.getPath(), "-o",
                "group=" + nati.getGroup(), "-f", "-c",
                ClusterSOAPServer.getImsPath() };
        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
    }

    private void setDMCMapdDomain(String i_export, String i_globaldomain,
            String i_localdomain, SoapResponse trans) {
        int rnValue = NAS_SUCCESS;
        i_export = NSUtil.trimExport(i_export);

        // according to [nas-dev-necas:02078]
        String cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -A "
                + i_export + " " + MAPDSOAPServer.AUTHDMC + " -o zone="
                + i_globaldomain + " -o workgroup=" + i_localdomain
                + " -o separator=+ -f " + " -c "
                + ClusterSOAPServer.getImsPath();
        // String cmd= COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN +" -A " +
        // i_export+ " " + MAPDSOAPServer.AUTHDMC + " -o "+
        // i_globaldomain+":"+i_localdomain +" -f ";

        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
    }

    public void setSHRMapdDomain(String i_export, SoapResponse trans) {

        i_export = NSUtil.trimExport(i_export);
        /*
         * String cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN +" -A " +
         * i_export+ " " + AUTHSHR + " -o uname="+ uname + " -o uid="+uid+ " -o
         * gname="+gname+ " -o gid="+ gid+" -f " + " -c " +
         * ClusterSOAPServer.getImsPath();
         */

        String cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -A "
                + i_export + " " + AUTHSHR + " -f " + " -c "
                + ClusterSOAPServer.getImsPath();

        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);

    }

    public SoapRpsString setSHRMapdDomain(String i_export, String i_uname,
            String i_uid, String i_gname, String i_gid) {
        SoapRpsString trans = new SoapRpsString();
        setSHRMapdDomain(i_export, trans);
        return trans;
    }

    private void setPWDMapdDomain(String export, String Passwdfilepath,
            String Groupfilepath, String type, String sid, SoapResponse trans) {
        if (type.equals(NativeDomain.NATIVE_PWD)) {

            String home = System.getProperty("user.home");
            String[] cmds = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_PWD,
                    export, MAPDSOAPServer.AUTHPWD, Passwdfilepath,
                    Groupfilepath, "-f", "-c " + ClusterSOAPServer.getImsPath() };

            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmds, trans, cmdHandler);

        } else {
            String home = System.getProperty("user.home");
            String[] cmds = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_PWD,
                    export, MAPDSOAPServer.AUTHPWD, Passwdfilepath,
                    Groupfilepath, "-o", "sidprefix=" + sid, "-f",
                    "-c " + ClusterSOAPServer.getImsPath() };

            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        }
    }

    private void setPWDMapdDomain(AuthInfo auth, String sid, SoapResponse trans) {
        String Passwdfilepath = "";
        String Groupfilepath = "";
        String export = "";
        try {
            Passwdfilepath = auth.getPWDPath();
            Groupfilepath = auth.getGroupPath();
            export = NSUtil.trimExport(auth.getExportRoot());
        } catch (Exception e) {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage("Exec Cmd failed:\n" + e);
            return;
        }
        if (auth.getAuthType().equals(AuthDomain.AUTH_PWD)) {

            String home = System.getProperty("user.home");
            String[] cmds = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_PWD,
                    export, MAPDSOAPServer.AUTHPWD, Passwdfilepath,
                    Groupfilepath, ClusterSOAPServer.getImsPath() };

            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmds, trans, cmdHandler);

        } else {
            String home = System.getProperty("user.home");
            String[] cmds = { COMMAND_SUDO, home + SCRIPT_DIR + SCRIPT_PWD,
                    export, MAPDSOAPServer.AUTHPWD, Passwdfilepath,
                    Groupfilepath, ClusterSOAPServer.getImsPath(),
                    "-o sidprefix=" + sid };

            RegionHandler cmdHandler = new RegionHandler();
            SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        }
        // setPWDMapdDomain(export, Passwdfilepath, Groupfilepath, sid,trans);
    }

    // 4.1.3.11
    private void setMapdAuth(String i_region, String i_path, SoapResponse trans) {

        String home = System.getProperty("user.home");

        String[] cmd = new String[5];
        cmd[0] = COMMAND_SUDO;
        cmd[1] = home + SCRIPT_DIR + SCRIPT_MAPD_AUTH;
        cmd[2] = ClusterSOAPServer.getImsPath();
        cmd[3] = i_region.trim();
        cmd[4] = i_path.trim();

        SOAPServerBase.execCmd(cmd, trans);
    }

    // 4.1.3.12
    private void writeSmbConf(String i_global, String i_local,
            String i_netbios, String content, SoapResponse trans) {

        String home = System.getProperty("user.home");

        String[] cmd = new String[8];
        cmd[0] = COMMAND_SUDO.trim();
        // cmd[1]=(home+SCRIPT_DIR+SCRIPT_CIFS_SET_SMB_GLOBAL_OPTION).trim();
        cmd[1] = (home + SCRIPT_DIR + SCRIPT_CIFS_SET_SMB_GLOBAL_OPTION_NOCHECK)
                .trim();
        cmd[2] = ClusterSOAPServer.getEtcPath();
        cmd[3] = "0";
        cmd[4] = i_global;
        cmd[5] = i_local;
        cmd[6] = i_netbios;
        cmd[7] = content;

        SOAPServerBase.execCmd(cmd, trans);

    }

    // 4.1.3.14
    public SoapResponse setMapdDelete(String i_region) {
        SoapResponse trans = new SoapResponse();

        String cmd;
        cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -D " + i_region
                + " -af " + " -c " + ClusterSOAPServer.getImsPath();

        SOAPServerBase.execCmd(cmd, trans);
        return trans;
    }

    // for cluster failover
    public SoapRpsString getAuthRegion(String path, String groupNo)
            throws Exception {
        String origmyNumber = ClusterSOAPServer.getMyNumber();
        SoapRpsString trans;
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);

        try {
            trans = getAuthRegion(path);
        } catch (NSException e) {
            throw e;
        } finally {
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return trans;

    }

    // 4.1.3.5
    public SoapRpsString getAuthRegion(String path) throws Exception {
        SoapRpsString trans = new SoapRpsString();

        int resultNo = 0;

        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_DIR
                + SCRIPT_MAPD_GETREGION + " " + ClusterSOAPServer.getImsPath()
                + " " + path;

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                String region = "";
                SoapRpsString trans = (SoapRpsString) rps;
                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                region = buf.readLine().trim();
                trans.setString(region);
                trans.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }

    // 4.1.3.6
    public SoapRpsString getFsType(String path) {
        SoapRpsString trans = new SoapRpsString();
        int resultNo = 0;

        String home = System.getProperty("user.home");
        String cmd = COMMAND_SUDO + " " + home + SCRIPT_DIR
                + SCRIPT_GET_FS_TYPE + " " + path;

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsString trans = (SoapRpsString) rps;

                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String fsType = buf.readLine();
                trans.setString(fsType);
                trans.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;

    }// end of getFsType

    //
    public SoapResponse setAuthNISAgain(AuthInfo auth) {

        SoapResponse trans = null;

        // check out yp.conf
        trans = Transaction.checkout(FILE_MAPD_YPCONF);
        if (!trans.isSuccessful()) {
            return trans;
        }

        // 1.writeYPConf
        writeYPConf(auth.getDomain(), auth.getServer(), auth.getOldServer(),
                trans);

        if (!trans.isSuccessful()) {
            // rollbackYPConf();
            return trans;
        } else {
            trans = Transaction.checkin(FILE_MAPD_YPCONF);
            if (!trans.isSuccessful()) {
                rollbackYPConf();
                return trans;
            }
        }
        trans.setSuccessful(true);
        return trans;
    }

    public SoapRpsString addLocalDomain(String export, String globaldomain,
            String localdomain) {
        SoapRpsString trans = new SoapRpsString();

        setDMCMapdDomain(export, globaldomain, localdomain, trans);
        if (!trans.isSuccessful()) {
            return trans;
        }

        trans.setString(region);
        trans.setSuccessful(true);
        return trans;

    }

    private SoapRpsString getSMBConf(String global, String local, String netbios) {
        SoapRpsString trans = new SoapRpsString();
        int rnValue = NAS_SUCCESS;
        String home = System.getProperty("user.home");
        String etcPath = ClusterSOAPServer.getEtcPath();

        String[] cmd = new String[6];
        cmd[0] = COMMAND_SUDO.trim();
        cmd[1] = (home + SCRIPT_DIR + SCRIPT_COMMON_GETSMBCONF).trim();
        cmd[2] = etcPath;
        cmd[3] = global;
        cmd[4] = local;
        cmd[5] = netbios;

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsString trans = (SoapRpsString) rps;
                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);

                trans.setSuccessful(true);
                trans.setString((buf.readLine()).trim());
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }

    public SoapResponse delNative(String type, String network) {
        return delNative(type, network, "");
    }

    public SoapResponse delNative(String type, String network, String region) {
        SoapResponse trans = new SoapResponse();
        String cmd;

        if (type.equals(NativeDomain.NATIVE_SHR)) {
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + network + " -o shr -f -c "
                    + ClusterSOAPServer.getImsPath();
        } else if (type.equals(NativeDomain.NATIVE_NIS)
                || type.equals(NativeDomain.NATIVE_PWD)
                || type.equals(NativeDomain.NATIVE_LDAPU)) {
            if (network.equals("*")) {
                cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D " + region
                        + " -f -c " + ClusterSOAPServer.getImsPath();
                ;
            } else {
                cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n "
                        + network + " -f -c " + ClusterSOAPServer.getImsPath();
            }
        } else if (type.equals(NativeDomain.NATIVE_NISW)
                || type.equals(NativeDomain.NATIVE_PWDW)
                || type.equals(NativeDomain.NATIVE_LDAPUW)) {
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + network + " -f -c " + ClusterSOAPServer.getImsPath();
        } else if (type.equals(NativeDomain.NATIVE_DMC)) {
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + network + " -o dmc -f -c "
                    + ClusterSOAPServer.getImsPath();
        } else if (type.equals(NativeDomain.NATIVE_ADS)) {
            // wait ims_utils
            cmd = SUDO_COMMAND + " " + COMMAND_IMS_NATIVE + " -D -n . -r "
                    + network + " -o ads -f -c "
                    + ClusterSOAPServer.getImsPath();
        } else {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            trans.setErrorMessage("Invalid parameter: type=" + type);
            return trans;
        }

        SOAPServerBase.execCmd(cmd, trans);
        return trans;
    }

    public static int ERR_MSG_ERROR_IP = 0x0000200b;

    public SoapRpsString addNative(NativeInfo nativeInfo, String writeLudbInfo)
            throws Exception {
        SoapResponse temp = new SoapResponse();
        SoapRpsString trans = new SoapRpsString();
        // when network is "",means all ip allowed.
        if ((nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_PWD) || nativeInfo
                .getType().equals(NativeDomain.NATIVE_LDAPU))
                && nativeInfo.getEffcNetwork().equals("")) {
            if (hasSpecifiedAllIp().getBoolean()) {
                trans.setSuccessful(false);
                trans.setErrorCode(ERR_MSG_ERROR_IP);
                return trans;
            }
        }
        String nodeNum = ClusterSOAPServer.getMyNumber();
        boolean ludbCheckout = false;
        String ludbInfoFile = ClusterSOAPServer.getEtcPath() + "ludb.info";

        // smbpasswd
        if (nativeInfo.getType().equals(NativeDomain.NATIVE_PWDW)) {
            ludbCheckout = true;
            temp = Transaction.checkout(ludbInfoFile);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                return trans;
            }
            StringTokenizer tempToken = new StringTokenizer(nativeInfo
                    .getDomain(), "+");
            temp = cpsmbpasswd(tempToken.nextToken(), nativeInfo.getNetBios(),
                    nativeInfo.getLUDB(), writeLudbInfo);
            if (!temp.isSuccessful()) {
                Transaction.rollback(ludbInfoFile);
                res2str(temp, trans);
                return trans;
            }
        }

        // write yp.conf
        if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_NISW)) {

            // check out yp.conf
            temp = Transaction.checkout(FILE_MAPD_YPCONF);
            if (!temp.isSuccessful()) {
                res2str(temp, trans);
                if (ludbCheckout) {
                    Transaction.rollback(ludbInfoFile);
                }
                return trans;
            }

            // writeYPConf
            writeYPConf(nativeInfo.getNisDomain(), nativeInfo.getServer(),
                    null, trans);
            if (!trans.isSuccessful()) {
                if (ludbCheckout) {
                    Transaction.rollback(ludbInfoFile);
                }
                // rollbackYPConf();
                trans.setErrorCode(NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED);
                return trans;
            }
        }

        // 3-1) ims_domain
        String cmd = null;
        if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                || (nativeInfo.getType().equals(NativeDomain.NATIVE_NISW))) {
            setNISNativeDomain(nativeInfo.getNisDomain(), nodeNum, trans);
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_LDAPU)) {
            setLDAPMapdDomainNative(nativeInfo, nodeNum, trans);
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_LDAPUW)) {
            setLDAPMapdDomainNative(nativeInfo, nodeNum, trans);
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_PWD)
                || (nativeInfo.getType().equals(NativeDomain.NATIVE_PWDW))) {
            setPWDNativeDomain(nativeInfo, nodeNum, trans);
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_DMC)) {
            setDMCMapdDomain(NATIVE_COMMENT + nodeNum, GLOBALDOMAIN, nativeInfo
                    .getDomain(), trans);
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_ADS)) {
            // wait ims_utils
            trans = setAuthADSDomain(NATIVE_COMMENT + nodeNum, nativeInfo
                    .getDomain());
        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_SHR)) {
            setSHRMapdDomain(NATIVE_COMMENT + nodeNum, trans);
        } else {
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            trans.setErrorMessage("Wrong native type!" + nativeInfo.getType());
            NSReporter.getInstance().report(NSReporter.DEBUG,
                    "Wrong native type!");
            return trans;
        }

        if (!trans.isSuccessful()) {
            if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                    || nativeInfo.getType().equals(NativeDomain.NATIVE_NISW)) {
                rollbackYPConf();
            }
            if (ludbCheckout) {
                Transaction.rollback(ludbInfoFile);
            }
            return trans;
        }

        // 3-2) ims_native
        if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_PWD)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_LDAPU)) {
            if (nativeInfo.getEffcNetwork().equals("")) {
                cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                        + " -f -c " + ClusterSOAPServer.getImsPath();
                ;
            } else {
                cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                        + " -n " + nativeInfo.getEffcNetwork() + " -f -c "
                        + ClusterSOAPServer.getImsPath();
            }

        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_NISW)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_PWDW)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_LDAPUW)) {
            cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                    + " -n " + " . -r " + nativeInfo.getDomain() + " -f -c "
                    + ClusterSOAPServer.getImsPath();

        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_DMC)) {

            cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                    + " -n . -r " + nativeInfo.getDomain() + " -o dmc -f -c "
                    + ClusterSOAPServer.getImsPath();

        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_ADS)) {
            // wait ims_utils
            cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                    + " -n . -r " + nativeInfo.getDomain() + " -o ads -f -c "
                    + ClusterSOAPServer.getImsPath();

        } else if (nativeInfo.getType().equals(NativeDomain.NATIVE_SHR)) {

            cmd = COMMAND_SUDO + " " + COMMAND_IMS_NATIVE + " -A " + region
                    + " -n . -r " + nativeInfo.getDomain() + " -o shr -f -c "
                    + ClusterSOAPServer.getImsPath();

        }

        SOAPServerBase.execCmd(cmd, trans);
        if (!trans.isSuccessful()) {
            if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                    || nativeInfo.getType().equals(NativeDomain.NATIVE_NISW)) {
                rollbackYPConf();
            }
            if (ludbCheckout) {
                Transaction.rollback(ludbInfoFile);
            }
            // this step should be moved outside --fun
            cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -D " + region
                    + " -af" + " -c " + ClusterSOAPServer.getImsPath();
            SOAPServerBase.execCmd(cmd, new SoapResponse());
            return trans;
        }
        if (nativeInfo.getType().equals(NativeDomain.NATIVE_NIS)
                || nativeInfo.getType().equals(NativeDomain.NATIVE_NISW)) {
            temp = Transaction.checkin(FILE_MAPD_YPCONF);
            if (!temp.isSuccessful()) {
                rollbackYPConf();
                res2str(temp, trans);
                return trans;
            }
            if (ludbCheckout) {
                Transaction.rollback(ludbInfoFile);
            }
        }

        if (ludbCheckout) {
            Transaction.checkin(ludbInfoFile);
        }
        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    } // end of addNative method.

    public SoapRpsString getFsTypeFromFstab(String path) {
        SoapRpsString trans = new SoapRpsString();

        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                home + SCRIPT_DIR + SCRIPT_GET_FS_TYPE_FROM_FSTAB,
                ClusterSOAPServer.getEtcPath(), path };

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                SoapRpsString trans = (SoapRpsString) rps;

                InputStreamReader bufReader = new InputStreamReader(proc
                        .getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String fsType = buf.readLine();
                trans.setString(fsType);
                trans.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;

    }// end of getFsTypeFromFstab

    public SoapResponse remoteSyncYPConf(String domain, String server,
            String oldserver) {
        SoapResponse trans = new SoapResponse();
        if (oldserver.equals("")) {
            oldserver = null;
        }

        writeYPConf(domain, server, oldserver, trans);
        return trans;
    }

    // Add by WangLi, 2002/8/30
    public SoapRpsString setAuthPWD4CIFS(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();

        String smbConfFile = ClusterSOAPServer.getEtcPath() + "nas_cifs" + "/"
                + GLOBALDOMAIN + "/" + auth.getLocalDomain() + "/"
                + "smb.conf." + auth.getNetBios();

        String ludbInfoFile = ClusterSOAPServer.getEtcPath() + "ludb.info";

        SoapResponse tempRps;
        tempRps = Transaction.checkout(smbConfFile);
        if (!tempRps.isSuccessful()) {
            res2str(tempRps, trans);
            return trans;
        }
        tempRps = Transaction.checkout(ludbInfoFile);
        if (!tempRps.isSuccessful()) {
            Transaction.rollback(smbConfFile);
            res2str(tempRps, trans);
            return trans;
        }
        trans = setPWDMapdDomain4CIFS(auth);
        if (!trans.isSuccessful()) {
            removeLUDB(auth);
            Transaction.rollback(smbConfFile);
            Transaction.rollback(ludbInfoFile);
            return trans;
        }
        Transaction.checkin(smbConfFile);
        Transaction.checkin(ludbInfoFile);
        return trans;
    }

    private SoapRpsString setPWDMapdDomain4CIFS(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();

        SoapResponse tempRps = copyLUDB(auth, "true");
        if (!tempRps.isSuccessful()) {
            res2str(tempRps, trans);
            return trans;
        }

        tempRps = getLUDBRoot();
        if (!tempRps.isSuccessful()) {
            return (SoapRpsString) tempRps;
        }
        String ludbRoot = ((SoapRpsString) tempRps).getString();

        tempRps = buildSID(auth);
        if (!tempRps.isSuccessful()) {
            return (SoapRpsString) tempRps;
        }

        execXsmbd(); // restart smb

        String sid = ((SoapRpsString) tempRps).getString();

        String ludbDir = ludbRoot + "/.expgrp/"
                + NSUtil.trimExport(auth.getExportRoot()) + "/sxfsfw/"
                + auth.getLUDB();
        String pwdFile = ludbDir + "/passwd";
        String grpFile = ludbDir + "/group";

        String cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -A "
                + NSUtil.trimExport(auth.getExportRoot()) + " " + AUTHPWD
                + " -o passwd=" + pwdFile + " -o group=" + grpFile
                + " -o sidprefix=" + sid + " -f -c "
                + ClusterSOAPServer.getImsPath();

        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;
    }

    public SoapResponse cpsmbpasswd(String ntdomain, String netbios,
            String ludbName, String writeLudbInfo) {
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        SoapResponse tempRps = getLUDBRoot();
        if (!tempRps.isSuccessful()) {
            return tempRps;
        }
        String ludbRoot = ((SoapRpsString) tempRps).getString();

        String[] cmds = { COMMAND_SUDO, home + SCRIPT_COPYSMBPWD, ludbRoot,
                GLOBALDOMAIN, ntdomain, netbios, ludbName,
                ClusterSOAPServer.getEtcPath(), "true" };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    public SoapResponse rmsmbpasswd(String ntdomain, String netbios,
            String ludbName) {
        StringTokenizer tempToken = new StringTokenizer(ntdomain, "+");
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        SoapResponse tempRps = getLUDBRoot();
        if (!tempRps.isSuccessful()) {
            return tempRps;
        }
        String ludbRoot = ((SoapRpsString) tempRps).getString();

        String[] cmds = { COMMAND_SUDO, home + SCRIPT_REMOVESMBPWD, ludbRoot,
                GLOBALDOMAIN, tempToken.nextToken(), netbios, ludbName,
                ClusterSOAPServer.getEtcPath() };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    public SoapResponse copyLUDB(AuthInfo auth, String writeLudbInfo) {
        SoapResponse trans = new SoapResponse();
        SoapResponse tempRps = getLUDBRoot();
        if (!tempRps.isSuccessful()) {
            return tempRps;
        }
        String ludbRoot = ((SoapRpsString) tempRps).getString();

        String authType = auth.getAuthType();
        String fsType;
        if (authType.equals(AuthDomain.AUTH_NIS)
                || authType.equals(AuthDomain.AUTH_PWD)
                || authType.equals(AuthDomain.AUTH_LDAPU)) {
            fsType = "sxfs";
        } else {
            fsType = "sxfsfw";
        }
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, home + SCRIPT_COPYLUDB, ludbRoot,
                NSUtil.trimExport(auth.getExportRoot()), fsType,
                auth.getLUDB(), writeLudbInfo, ClusterSOAPServer.getEtcPath() };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    public SoapResponse removeLUDB(AuthInfo auth) {
        SoapResponse trans = new SoapResponse();
        SoapResponse tempRps = getLUDBRoot();
        if (!tempRps.isSuccessful()) {
            return tempRps;
        }
        String ludbRoot = ((SoapRpsString) tempRps).getString();
        String authType = auth.getAuthType();
        String fsType;
        if (authType.equals(AuthDomain.AUTH_NIS)
                || authType.equals(AuthDomain.AUTH_PWD)
                || authType.equals(AuthDomain.AUTH_LDAPU)) {
            fsType = "sxfs";
        } else if (authType.equals(AuthDomain.AUTH_NISW)
                || authType.equals(AuthDomain.AUTH_PWDW)
                || authType.equals(AuthDomain.AUTH_LDAPUW)) {
            fsType = "sxfsfw";
        } else {
            return trans;
        }
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, home + SCRIPT_REMOVELUDB, ludbRoot,
                NSUtil.trimExport(auth.getExportRoot()), fsType,
                auth.getLUDB(), ClusterSOAPServer.getEtcPath() };
        SOAPServerBase.execCmd(cmds, trans);
        return trans;
    }

    class HandlerGetOneLine implements CmdHandler {
        public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
                throws Exception {
            SoapRpsString trans = (SoapRpsString) rps;
            trans.setSuccessful(true);
            BufferedReader br = new BufferedReader(new InputStreamReader(proc
                    .getInputStream()));
            String line = br.readLine();
            if (line == null || line.trim().equals("")) {
                trans.setSuccessful(false);
            } else {
                trans.setString(line);
            }
        }
    }

    private SoapRpsString buildSID(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, home + SCRIPT_BUILDSID,
                ClusterSOAPServer.getEtcPath(), GLOBALDOMAIN,
                auth.getLocalDomain(), auth.getNetBios() };
        HandlerGetOneLine cmdHandler = new HandlerGetOneLine();
        CmdErrHandler cmdErrHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)
                    throws Exception {
                rps.setSuccessful(false);
                rps.setErrorCode(proc.exitValue());
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc
                        .getErrorStream()));

            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler, cmdErrHandler);
        return trans;
    }

    public SoapRpsString getLUDBRoot() {
        SoapRpsString trans = new SoapRpsString();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO, SCRIPT_GETLUDBROOT, "root" };
        HandlerGetOneLine cmdHandler = new HandlerGetOneLine();
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;
    }

    public SoapRpsString setAuthLDAP(AuthInfo auth) {
        SoapRpsString trans = new SoapRpsString();

        SoapResponse temp = null;

        boolean bCheckout = false;// whether need deal with smb.conf
        String smbPath = "";

        // write SmbConf
        String sid = "";
        if (auth.getAuthType().equals(AuthDomain.AUTH_LDAPUW)
                && !auth.getHasLDAPW()) {
            trans = smbBeforeSid(auth);
            if (!trans.isSuccessful()) {
                return trans;
            }
            smbPath = trans.getString();
            bCheckout = true;

            trans = buildSID(auth);
            if (!trans.isSuccessful()) {
                Transaction.rollback(smbPath);
                return trans;
            }
            sid = trans.getString();
        }

        // 1.if it's the first time, ims_domain -A
        if ((auth.getAuthType().equals(AuthDomain.AUTH_LDAPU))
                && (!auth.getHasLDAPU())
                || (auth.getAuthType().equals(AuthDomain.AUTH_LDAPUW))
                && (!auth.getHasLDAPW())) {
            setLDAPMapdDomain(auth, sid, trans);
            if (!trans.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }
                return trans;
            }
        } else {
            region = auth.getRegion();
        }

        // 2.setMapdAuth
        if (!auth.isFromCIFS()) {
            setMapdAuth(region, auth.getPath(), trans);
            if (!trans.isSuccessful()) {
                if (bCheckout) {
                    Transaction.rollback(smbPath);
                }

                if (!auth.getHasLDAPW() && !auth.getHasLDAPU())
                    setMapdDelete(region);

                return trans;
            }
        }

        if (bCheckout) {
            temp = Transaction.checkin(smbPath);
            if (!temp.isSuccessful()) {
                if (!auth.getHasLDAPW() && !auth.getHasLDAPU()
                        && !auth.isFromCIFS())
                    setMapdDelete(region);
                res2str(temp, trans);
                return trans;
            }
            execXsmbd();
        }

        trans.setString(region);
        trans.setSuccessful(true);
        return trans;
    }

    private void setLDAPMapdDomain(AuthInfo auth, String sid, SoapResponse trans) {
        String i_export = auth.getExportRoot();
        String type = auth.getAuthType();
        i_export = NSUtil.trimExport(i_export);
        String authenType = auth.getAuthenticateType();
        String[] inputs = {};
        String home = System.getProperty("user.home");
        Vector cmdVec = new Vector();
        cmdVec.add(COMMAND_SUDO);
        cmdVec.add(COMMAND_IMS_DOMAIN);
        cmdVec.add("-A");
        cmdVec.add(i_export);
        cmdVec.add("ldu");
        cmdVec.add("-o");
        cmdVec.add("host=" + auth.getServerName());
        cmdVec.add("-o");
        cmdVec.add("basedn=" + auth.getDistinguishedName());
        cmdVec.add("-o");
        cmdVec
                .add("mech="
                        + (authenType.equals(AuthLDAPDomain.TYPE_ANON) ? AuthLDAPDomain.TYPE_SIMPLE
                                : authenType));
        cmdVec.add("-o");
        if (auth.getTLS().equals("yes")) {
            cmdVec.add("useldaps=y");
        } else if (auth.getTLS().equals("start_tls")) {
            cmdVec.add("usetls=y");
        } else {
            cmdVec.add("usetls=n");
        }

        if (!auth.getUserFilter().equals("")) {
            cmdVec.add("-o");
            cmdVec.add("userfilter=" + auth.getUserFilter());
        }
        if (!auth.getGroupFilter().equals("")) {
            cmdVec.add("-o");
            cmdVec.add("groupfilter=" + auth.getGroupFilter());
        }

        if (!authenType.equals(AuthLDAPDomain.TYPE_ANON)) {
            String temp1 = auth.getAuthenticateID();
            if (temp1 != null && !temp1.equals("")) {
                cmdVec.add("-o");
                cmdVec.add("bindname=" + temp1);
            }
            String temp = auth.getAuthenticatePasswd();
            if (temp != null && !temp.equals("")) {
                inputs = new String[] { "bindpasswd=" + temp };
                // if it need passwd, use the wrapper
                cmdVec.set(1, home + SCRIPT_ADDLDAPDOMAIN);
            }
        }
        if (auth.getCAType().equals(AuthLDAPDomain.CATYPE_FILE)) {
            cmdVec.add("-o");
            cmdVec.add("certfile=" + auth.getCA());
        } else if (auth.getCAType().equals(AuthLDAPDomain.CATYPE_DIR)) {
            cmdVec.add("-o");
            cmdVec.add("certdir=" + auth.getCA());
        }
        if (type.equals(AuthDomain.AUTH_LDAPUW)) {
            cmdVec.add("-o");
            cmdVec.add("sidprefix=" + sid);
        }
        cmdVec.add("-f");
        cmdVec.add("-c");
        cmdVec.add(ClusterSOAPServer.getImsPath());

        RegionHandler cmdHandler = new RegionHandler();
        String[] commandArray = new String[cmdVec.size()];
        for (int i = 0; i < cmdVec.size(); i++) {
            commandArray[i] = (String) cmdVec.get(i);
        }
        SOAPServerBase.execCmd(commandArray, trans, cmdHandler, inputs);

        if (trans.isSuccessful()) {
            SoapResponse temp = new SoapResponse();
            String[] cmdArray = { COMMAND_SUDO,
                    System.getProperty("user.home") + SCRIPT_ADDLDAPIPTABLES,
                    auth.getServerName() };
            SOAPServerBase.execCmd(cmdArray, temp);
            if (!temp.isSuccessful()) {
                setMapdDelete(region);
                temp.setErrorCode(NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED);
                res2str(temp, (SoapRpsString) trans);
            }
        }

    }

    private void setLDAPMapdDomainNative(NativeInfo nati, String nodeNum,
            SoapResponse trans) {
        String authenType = nati.getAuthenticateType();

        Vector cmdVec = new Vector();
        String home = System.getProperty("user.home");
        String[] inputs = {};
        cmdVec.add(COMMAND_SUDO);
        cmdVec.add(COMMAND_IMS_DOMAIN);
        cmdVec.add("-A");
        cmdVec.add("." + nodeNum);
        cmdVec.add("ldu");
        cmdVec.add("-o");
        cmdVec.add("host=" + nati.getServerName());
        cmdVec.add("-o");
        cmdVec.add("basedn=" + nati.getDistinguishedName());
        cmdVec.add("-o");
        cmdVec
                .add("mech="
                        + (authenType.equals(NativeLDAPDomain.TYPE_ANON) ? NativeLDAPDomain.TYPE_SIMPLE
                                : authenType));
        cmdVec.add("-o");
        if (nati.getTLS().equals("yes")) {
            cmdVec.add("useldaps=y");
        } else if (nati.getTLS().equals("start_tls")) {
            cmdVec.add("usetls=y");
        } else {
            cmdVec.add("usetls=n");
        }

        if (!nati.getUserFilter().equals("")) {
            cmdVec.add("-o");
            cmdVec.add("userfilter=" + nati.getUserFilter());
        }
        if (!nati.getGroupFilter().equals("")) {
            cmdVec.add("-o");
            cmdVec.add("groupfilter=" + nati.getGroupFilter());
        }

        if (!authenType.equals(NativeLDAPDomain.TYPE_ANON)) {
            String temp1 = nati.getAuthenticateID();
            if (temp1 != null && !temp1.equals("")) {
                cmdVec.add("-o");
                cmdVec.add("bindname=" + temp1);
            }
            String temp = nati.getAuthenticatePasswd();
            if (temp != null && !temp.equals("")) {
                inputs = new String[] { "bindpasswd=" + temp };
                // if it need passwd, use the wrapper
                cmdVec.set(1, home + SCRIPT_ADDLDAPDOMAIN);
            }
        }
        if (nati.getCAType().equals(NativeLDAPDomain.CATYPE_FILE)) {
            cmdVec.add("-o");
            cmdVec.add("certfile=" + nati.getCA());
        } else if (nati.getCAType().equals(NativeLDAPDomain.CATYPE_DIR)) {
            cmdVec.add("-o");
            cmdVec.add("certdir=" + nati.getCA());
        }
        cmdVec.add("-f");
        cmdVec.add("-c");
        cmdVec.add(ClusterSOAPServer.getImsPath());

        String[] commandArray = new String[cmdVec.size()];
        for (int i = 0; i < cmdVec.size(); i++) {
            commandArray[i] = (String) cmdVec.get(i);
        }
        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(commandArray, trans, cmdHandler, inputs);

        if (trans.isSuccessful()) {
            SoapResponse temp = new SoapResponse();
            String[] cmdArray = { COMMAND_SUDO,
                    System.getProperty("user.home") + SCRIPT_ADDLDAPIPTABLES,
                    nati.getServerName() };
            SOAPServerBase.execCmd(cmdArray, temp);
            if (!temp.isSuccessful()) {
                setMapdDelete(region);
                temp.setErrorCode(NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED);
                res2str(temp, (SoapRpsString) trans);
            }
        }

    }

    public SoapResponse writeSMB4ADS(AuthInfo auth) {
        SoapResponse rps = new SoapResponse();
        rps = getSMBConf(auth.getGlobalDomain(), auth.getLocalDomain(), auth
                .getNetBios());
        if (!rps.isSuccessful()) {
            return rps;
        }
        String smbPath = ((SoapRpsString) rps).getString();
        rps = Transaction.checkout(smbPath);
        if (!rps.isSuccessful()) {
            return rps;
        }
        String content = "workgroup = " + auth.getLocalDomain() + "\n"
                + "security = ads\n" + "realm = " + auth.getDNSDomain() + "\n"
                + "password server = *\n";
        writeSmbConf(auth.getGlobalDomain(), auth.getLocalDomain(), auth
                .getNetBios(), content, rps);
        if (!rps.isSuccessful()) {
            Transaction.rollback(smbPath);
            return rps;
        }
        rps = Transaction.checkin(smbPath);
        if (!rps.isSuccessful()) {
            Transaction.rollback(smbPath);
            return rps;
        }
        execXsmbd();
        return rps;
    }

    public SoapResponse setAuthADS(AuthInfo auth) {
        SoapResponse rps = new SoapResponse();

        boolean smbNeed = auth.getSmbNeed();

        String username = auth.getUserName();
        // 1.execute nascifsjoin
        if (smbNeed && (!auth.getHasADS()) && username != null
                && !username.trim().equals("")) {
            rps = MapdCommonSOAPServer.joinDomain(AuthDomain.AUTH_ADS, auth
                    .getLocalDomain(), username, auth.getPassword(), auth
                    .getNetBios(), auth.getDNSDomain());
            if (!rps.isSuccessful()) {
                return rps;
            }
        }

        // 2.ims_domain -A when the first time
        if (!auth.getHasADS()) {
            // wait for ims_utils
            // getADSConf maybe be called here if dnsDomain or kdcServer is
            // necessary
            // because it will auto set auth in ShareInfoBean
            rps = setAuthADSDomain(auth.getExportRoot(), auth.getLocalDomain());
            if (!rps.isSuccessful()) {
                return rps;
            }
        } else {
            region = auth.getRegion();
        }

        // 3.ims_auth -A
        if (region == null || region.equals("")) {
            return rps;
        }
        setMapdAuth(region, auth.getPath(), rps);
        if (!rps.isSuccessful()) {
            if (!auth.getHasADS())
                setMapdDelete(region);
            return rps;
        }
        return rps;
    }

    public SoapRpsString setAuthADSDomain(String export, String ntdomain) {
        SoapRpsString rps = new SoapRpsString();

        export = NSUtil.trimExport(export);
        // wait for ims_utils
        String cmd = COMMAND_SUDO + " " + COMMAND_IMS_DOMAIN + " -A " + export
                + " ads" + " -o zone=" + GLOBALDOMAIN + " -o workgroup="
                + ntdomain + " -o separator=+ -f " + "-c "
                + ClusterSOAPServer.getImsPath();

        RegionHandler cmdHandler = new RegionHandler();
        SOAPServerBase.execCmd(cmd, rps, cmdHandler);
        return rps;
    }

    private static final String SCRIPT_HASSPECIFIEDALLIP = "mapd_hasspecifiedallip.pl";

    public SoapRpsBoolean hasSpecifiedAllIp() throws Exception {
        SoapRpsBoolean rt = new SoapRpsBoolean();
        String home = System.getProperty("user.home");
        String[] cmd = { "sudo", home + SCRIPT_DIR + SCRIPT_HASSPECIFIEDALLIP,
                ClusterSOAPServer.getMyNumber() };
        com.nec.nsgui.model.biz.base.NSCmdResult result = com.nec.nsgui.model.biz.base.CmdExecBase
                .execCmd(cmd);
        String[] info = result.getStdout();
        rt.setBoolean(info[0].trim().equals("true"));
        return rt;
    }
}