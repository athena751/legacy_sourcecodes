/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.cifs;

import com.nec.sydney.net.soap.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.beans.mapdcommon.*;

public class ChangeNetbiosBean extends TemplateBean {
    private static final String cvsid = "@(#) $Id: ChangeNetbiosBean.java,v 1.2306 2007/04/26 07:53:54 wanghb Exp $";

    private String exportRoot = "";

    private String localDomain = "";

    private String oldNetbios = "";

    private String newNetbios = "";

    private boolean isCluster = false;

    private String friendNode;

    public void onDisplay() throws Exception {
        exportRoot = request.getParameter("exportrootname");
        localDomain = request.getParameter("domainname");
        oldNetbios = request.getParameter("selenetbios");
        newNetbios = request.getParameter("newNetbios");
        newNetbios = (newNetbios == null ? "" : newNetbios);
    }

    public void onSet() throws Exception {
        // check samba status
        String hasWarned = request.getParameter("hasWarned");
        if (hasWarned == null) {
            try {
                MapdCommonSOAPClient.getNetbiosStatus(target, localDomain,
                        oldNetbios);
            } catch (NSException ex) {
                if (ex.getErrorCode() == NAS_EXCEP_NO_SMBSTATUS_WARN) {
                    super.response
                            .sendRedirect(super.response
                                    .encodeRedirectURL("../nas/cifs/changeNetbios.jsp?warn=yes"
                                            + "&exportrootname="
                                            + exportRoot
                                            + "&domainname="
                                            + localDomain
                                            + "&selenetbios="
                                            + oldNetbios
                                            + "&newNetbios=" + newNetbios));
                    return;
                } else {
                    throw ex;
                }
            }
        }

        // get friend node url if cluster
        friendNode = Soap4Cluster.whoIsMyFriend(target);
        if (friendNode != null) {
            isCluster = true;
        }

        // check NetBIOS Name
        boolean result1 = MapdCommonSOAPClient.checkNetbios(target, newNetbios);
        boolean result2 = false;
        if (isCluster) {
            result2 = MapdCommonSOAPClient.checkNetbios(friendNode, newNetbios);
        }
        if (result1 || result2) {
            String errMsg = NSMessageDriver.getInstance().getMessage(session,
                    "common/alert/failed")
                    + "\\r\\n"
                    + NSMessageDriver.getInstance().getMessage(session,
                            "nas_cifs/alert/nb_existed");
            errHandle(errMsg);
            return;
        }

        // get security mode
        String security = MapdCommonSOAPClient.getSecurity(target, localDomain,
                oldNetbios);

        // change Name Rule
        try {
            changeNameRule(oldNetbios, newNetbios);
        } catch (NSException ex) {
            errHandle();
            return;
        }

        // change Native
        // step 1:get the old native
        // step 2:delete the old native
        // step 3:delete the new native if it already exist
        // step 4:add the new native
        NativeDomain oldNati = null;
        // step 1
        oldNati = MapdCommon.getNativeDomain(localDomain + "+" + oldNetbios,
                target);
        if (oldNati != null) {
            // step 2
            try {
                MapdCommon.delNative(localDomain, oldNetbios, target);
            } catch (NSException ex) {
                changeNameRule(newNetbios, oldNetbios);
                errHandle();
                return;
            }

            // step 3
            NativeDomain newNati = MapdCommon.getNativeDomain(localDomain + "+"
                    + newNetbios, target);
            if (newNati != null) {
                try {
                    MapdCommon.delNative(localDomain, newNetbios, target);
                } catch (NSException ex) {
                    MapdCommon.addNative(session, oldNati, target);
                    changeNameRule(newNetbios, oldNetbios);
                    errHandle();
                    return;
                }
            }

            // step 4
            oldNati.setNTDomain(localDomain + "+" + newNetbios);
            try {
                MapdCommon.addNative(session, oldNati, target);
            } catch (NSException ex) {
                changeNameRule(newNetbios, oldNetbios);
                oldNati.setNTDomain(localDomain + "+" + oldNetbios);
                MapdCommon.addNative(session, oldNati, target);
                errHandle();
                return;
            }
        }

        // change virtual servers,smb.conf,smbpasswd...
        try {
            MapdCommonSOAPClient.changeNetbios(target, exportRoot, localDomain,
                    oldNetbios, newNetbios, security);
        } catch (NSException ex) {
            if (oldNati != null) {
                MapdCommon.delNative(localDomain, newNetbios, target);
                oldNati.setNTDomain(localDomain + "+" + oldNetbios);
                MapdCommon.addNative(session, oldNati, target);
            }
            changeNameRule(newNetbios, oldNetbios);
            errHandle();
            return;
        }

        // success
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,
                "common/alert/done"));
        super.response
                .sendRedirect(super.response
                        .encodeRedirectURL("../nas/mapd/userdbdomainconf.jsp?exportGroup="
                                + exportRoot
                                + "&dispMode=\"\"&fromWhere=export"));
        return;
    }

    private void changeNameRule(String oldNetbios, String newNetbios)
            throws Exception {
        MapdCommonSOAPClient.changeNameRule(target, localDomain, oldNetbios,
                newNetbios);
        if (isCluster) {
            try {
                MapdCommonSOAPClient.changeNameRule(friendNode, localDomain,
                        oldNetbios, newNetbios);
            } catch (NSException ex) {
                MapdCommonSOAPClient.changeNameRule(target, localDomain,
                        newNetbios, oldNetbios);
                throw ex;
            }
        }
    }

    private void errHandle() throws Exception {
        String defaultErrMsg = NSMessageDriver.getInstance().getMessage(
                session, "common/alert/failed")
                + "\\r\\n"
                + NSMessageDriver.getInstance().getMessage(session,
                        "nas_cifs/alert/changeNetbios_failed");
        errHandle(defaultErrMsg);
    }

    private void errHandle(String errMsg) throws Exception {
        super.setMsg(errMsg);
        String errRedirectURL = super.response
                .encodeRedirectURL("../nas/cifs/changeNetbios.jsp?"
                        + "exportrootname=" + exportRoot + "&domainname="
                        + localDomain + "&selenetbios=" + oldNetbios
                        + "&newNetbios=" + newNetbios);
        super.response.sendRedirect(errRedirectURL);
    }

    public String getExportRoot() {
        return exportRoot;
    }

    public void setExportRoot(String er) {
        exportRoot = er;
    }

    public String getLocalDomain() {
        return localDomain;
    }

    public void setLocalDomain(String ld) {
        localDomain = ld;
    }

    public String getOldNetbios() {
        return oldNetbios;
    }

    public void setOldNetbios(String on) {
        oldNetbios = on;
    }

    public String getNewNetbios() {
        return newNetbios;
    }

    public void setNewNetbios(String nn) {
        newNetbios = nn;
    }
}