/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapdnative;

import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapd.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.beans.filesystem.*;

import java.util.*;

public class NativeListBean extends AbstractJSPBean implements NSExceptionMsg,
        NasConstants, NasSession {

    private static final String cvsid = "@(#) $Id: NativeListBean.java,v 1.2308 2007/04/26 07:53:12 wanghb Exp $";

    Vector ntList = new Vector();

    Vector unixList = new Vector();

    Hashtable nativeTable = new Hashtable();

    private String ldapServer = "";

    public String getLdapServer() throws Exception {
        if (ldapServer == null || ldapServer.equals("")) {
            AuthInfo authInfo = MapdCommon.getLDAPInfo(target);
            if (authInfo != null) {
                ldapServer = authInfo.getServerName();
            } else {
                ldapServer = "";
            }
        }
        return ldapServer;
    }

    public Vector getNtList() {
        return ntList;
    }

    public Vector getUnixList() {
        return unixList;
    }

    public Hashtable getNativeTable() {
        return nativeTable;
    }

    public NativeListBean() {
    }

    public void beanProcess() throws Exception {
        String nasAction = request.getParameter("nasAction");
        if (nasAction == null) {
            listNative();
        } else if (nasAction.equals("deleteNative")) {
            deleteNative();
        } else {
            listNative();
        }
    }

    public void listNative() throws Exception {
        List nativelist = APISOAPClient.getNativeList(target);

        NativeDomain nati = null;
        Iterator it = nativelist.iterator();
        String ludbRoot = "";
        while (it.hasNext()) {
            nati = (NativeDomain) it.next();
            MPAndAuth mp = new MPAndAuth();

            if (nati instanceof NativeNISDomain) {
                NativeNISDomain nisDomain = (NativeNISDomain) nati;
                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/unix/radio_nis"));
                String servers = nisDomain.getDomainServer();
                mp.setResource(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/nis_domain")
                        + " : "
                        + nisDomain.getDomainName()
                        + "<br>"
                        + NSMessageDriver.getInstance().getMessage(session,
                                "nas_mapd/nt/nis_server")
                        + " : <br>&nbsp;&nbsp;"
                        + servers.replaceAll("\\s+", "<br>&nbsp;&nbsp;"));

                if (nati instanceof NativeNISDomain4Win) {
                    mp.setNTDomain(nati.getNTDomain());
                    ntList.add(mp);
                } else {
                    mp.setNetwork(nati.getNetwork());
                    unixList.add(mp);
                }

            } else if (nati instanceof NativePWDDomain) {
                NativePWDDomain pwdDomain = (NativePWDDomain) nati;
                String pass = NSUtil.bytes2hStr(pwdDomain.getPasswd());
                pass = NSUtil.hStr2EncodeStr(pass, NSUtil.EUC_JP,
                        BROWSER_ENCODE);

                if (ludbRoot == null || ludbRoot.equals("")) {
                    ludbRoot = MAPDSOAPClient.getLudbRoot(target);
                }
                if (!MapdCommon.checkPwd(pass, "", "", "/passwd", target,
                        ludbRoot)) {
                    throw new Exception(NSMessageDriver.getInstance()
                            .getMessage(session, "nas_mapd/alert/old_pass"));
                }

                pass = MapdCommon.trimPwd(pass, "", "", target, ludbRoot);
                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/unix/radio_pwd"));

                mp.setResource(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/ludb_name")
                        + " : <br>&nbsp;&nbsp;" + pass);
                mp.setLudbName(pass);
                if (nati instanceof NativePWDDomain4Win) {
                    mp.setNTDomain(nati.getNTDomain());
                    ntList.add(mp);
                } else {
                    mp.setNetwork(nati.getNetwork());
                    unixList.add(mp);
                }

            } else if (nati instanceof NativeDMCDomain) {
                String domain = nati.getNTDomain();

                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/h3_auth"));

                mp.setNTDomain(domain);

                ntList.add(mp);

            } else if (nati instanceof NativeADSDomain) {
                String domain = nati.getNTDomain();

                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/h3_ads"));

                String dnsDomain = ((NativeADSDomain) nati).getDNSDomain();
                String kdcServer = ((NativeADSDomain) nati).getKDCServer();
                if (kdcServer == null || kdcServer.equals("")) {
                    String friend = Soap4Cluster.whoIsMyFriend(target);
                    if (friend != null) {
                        Vector vec = MapdCommonSOAPClient.getADSConf(friend,
                                domain);
                        if (vec != null) {
                            dnsDomain = (String) vec.get(0);
                            kdcServer = (String) vec.get(1);
                        }
                    }
                }
                if (kdcServer != null && !kdcServer.equals("")) {
                    kdcServer = kdcServer.replaceAll(" ", "<br>&nbsp;&nbsp;");
                    mp.setResource(NSMessageDriver.getInstance().getMessage(
                            session, "nas_mapd/nt/text_dnsdomain")
                            + " : <br>&nbsp;&nbsp;"
                            + dnsDomain
                            + "<br>"
                            + NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/text_kdcserver")
                            + " : <br>&nbsp;&nbsp;" + kdcServer);
                }
                mp.setNTDomain(domain);

                ntList.add(mp);

            } else if (nati instanceof NativeSHRDomain) {
                String domain = nati.getNTDomain();

                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/h3_shr"));

                mp.setNTDomain(domain);

                ntList.add(mp);

            } else if (nati instanceof NativeLDAPDomain) {
                NativeLDAPDomain ldapDomain = (NativeLDAPDomain) nati;
                String server = getLdapServer();

                mp.setDomainType(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/h3_ldap"));

                mp.setResource(NSMessageDriver.getInstance().getMessage(
                        session, "nas_mapd/nt/ldap_server")
                        + " : <br>&nbsp;&nbsp;"
                        + server.replaceAll("\\s+", "<br>&nbsp;&nbsp;"));

                if (nati instanceof NativeLDAPUDomain4Win) {
                    mp.setNTDomain(nati.getNTDomain());
                    ntList.add(mp);
                } else if (nati instanceof NativeLDAPUDomain) {
                    mp.setNetwork(nati.getNetwork());
                    unixList.add(mp);
                }
            }

            nativeTable.put(mp, nati);
        }
    }

    public void deleteNative() throws Exception {
        String type = request.getParameter("type");
        String region = request.getParameter("region");
        String network = request.getParameter("network");// parameter
                                                            // network:when the
                                                            // type is unix
                                                            // series,
        // "network" is network.
        // when the type is windows series,
        // "network" is NTDomain.

        if (type.equals(NativeDomain.NATIVE_PWDW)) {
            String ludb = request.getParameter("domain"); // parameter domain:
                                                            // when the type is
                                                            // NISW or NIS,
            // type "domain" is NIS domain name.
            // when the type is PWDW or PWD,
            // type "domain" is LUDB name.
            String netbios = request.getParameter("netbios");

            MAPDSOAPClient.rmsmbpasswd(network, netbios, ludb, target);

            String friendnode = Soap4Cluster.whoIsMyFriend(target);
            if (friendnode != null) {
                MAPDSOAPClient.rmsmbpasswd(network, netbios, ludb, friendnode);
            }
        }

        MapdCommon.deleteNativeByNode(target, type, region, network);

        try {
            String friendnode = Soap4Cluster.whoIsMyFriend(target);
            // if(true) throw new Exception(target+"<br>"+friendnode);
            if (friendnode != null) {
                String friendRegion = MapdCommon.getFriendRegion(friendnode,
                        type, network);
                MapdCommon.deleteNativeByNode(friendnode, type, friendRegion,
                        network);
            }
        } catch (Exception e) {
            NSReporter.getInstance().report(NSReporter.DEBUG,
                    "rsync error: " + e.toString());
        }

        if (type.equals(NativeDomain.NATIVE_NIS)
                || type.equals(NativeDomain.NATIVE_NISW)) {
            String domain = request.getParameter("domain");
            String server = request.getParameter("server");
            if (!MapdCommon.isUsedNISDomain(target, domain)) {
                // whether native or auth, single or cluster, it will count
                // whole nases.xml.
                MapdCommonSOAPClient.delYPConf(domain, server, target);

                try {
                    String friendnode = Soap4Cluster.whoIsMyFriend(target);
                    if (friendnode != null) {
                        MapdCommonSOAPClient.delYPConf(domain, server,
                                friendnode);
                    }
                } catch (Exception e) {
                    NSReporter.getInstance().report(NSReporter.DEBUG,
                            "rsync error: " + e.toString());
                }
            }
        }

        if (type.equals(NativeDomain.NATIVE_LDAPU)
                || type.equals(NativeDomain.NATIVE_LDAPUW)) {
            String ldapServer;
            try {
                ldapServer = MapdCommon.getLDAPInfo(target).getServerName();
            } catch (Exception e) {
                return;
            }
            MapdCommonSOAPClient.delIPTable(ldapServer, target);

            String friendNode = Soap4Cluster.whoIsMyFriend(target);
            if (friendNode != null) {
                MapdCommonSOAPClient.delIPTable(ldapServer, friendNode);
            }
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,
                "common/alert/done"));
        super.response.sendRedirect(super.response
                .encodeRedirectURL("nativelist.jsp?target=" + target));
    }
}
