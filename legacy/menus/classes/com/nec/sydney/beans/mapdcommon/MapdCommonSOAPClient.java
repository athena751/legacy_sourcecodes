/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapdcommon;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.nfs.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*;

/*******************************************************************************
 * 
 * this program is designed for the soap client of *
 * 
 * configuring ExportRoot(2002/1) *
 * 
 ******************************************************************************/

public class MapdCommonSOAPClient implements NasConstants, NSExceptionMsg {
    private static final String cvsid = "@(#) $Id: MapdCommonSOAPClient.java,v 1.2308 2007/04/27 05:12:46 wanghb Exp $";

    private static final String URN_COMMON_SERVICE = "urn:MapdCommonConf";

    /* none properties here */

    // constructor
    public MapdCommonSOAPClient() {
    }

    // Call ExportRootSOAPServer service "deleteDomain"
    public static void deleteDomain(String localDomain, String region,
            String authType, String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(localDomain);
        paramVec.add(region);
        paramVec.add(authType);
        SoapClientBase.execSoapServerFunc(paramVec, "deleteDomain",
                URN_COMMON_SERVICE, routerUrl);
    }// end function "deleteDomain"

    // Call SnapSOAPServer service "deleteConf"
    public static void deleteConf(String exportRoot, String localDomain,
            String hasNativeDomain, String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(exportRoot);
        paramVec.add(localDomain);
        paramVec.add(hasNativeDomain);
        SoapClientBase.execSoapServerFunc(paramVec, "deleteConf",
                URN_COMMON_SERVICE, routerUrl);
    } // end function "deleteConf"

    public static void deleteAuth(String region, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(region);
        SoapClientBase.execSoapServerFunc(paramVec, "deleteAuth",
                URN_COMMON_SERVICE, routerUrl);
    } // end function "deleteAuth"

    public static Vector getDirectMP(String exportRoot, String shift,
            String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(exportRoot);
        paramVec.add(shift);
        SoapRpsVector rtValue = (SoapRpsVector) SoapClientBase
                .execSoapServerFunc(paramVec, "getDirectMP",
                        URN_COMMON_SERVICE, routerUrl);

        return rtValue.getVector();
    } // end function "getDirectMP"

    public static boolean isSubMount(String path, String shift, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(path);
        paramVec.add(shift);
        SoapRpsBoolean rtValue = (SoapRpsBoolean) SoapClientBase
                .execSoapServerFunc(paramVec, "isSubMount", URN_COMMON_SERVICE,
                        routerUrl);

        return rtValue.getBoolean();
    } // end function "isSubMount"

    public static void setNative(String routerUrl, String region,
            String localdomain, String type) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(region);
        paramVec.add(localdomain);
        paramVec.add(type);
        SoapClientBase.execSoapServerFunc(paramVec, "setNative",
                URN_COMMON_SERVICE, routerUrl);
    }

    // modify snapshot cron file when unmount a mountPoint forever and delete a
    // exportroot
    // Add by Wang Zhoufei, 2002/5/29
    public static void snapModifyCron(String path, String deviceName,
            String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(path);
        paramVec.add(deviceName);
        SoapClientBase.execSoapServerFunc(paramVec, "snapModifyCron",
                URN_COMMON_SERVICE, routerUrl);
    }

    public static Vector getLUDBList(String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        SoapRpsVector rtValue = (SoapRpsVector) SoapClientBase
                .execSoapServerFunc(paramVec, "getLUDBList",
                        URN_COMMON_SERVICE, routerUrl);
        return rtValue.getVector();
    }

    public static SoapRpsBoolean delAuth(String mountPoint, String region,
            String routerUrl) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(mountPoint);
        paramVec.add(region);
        SoapRpsBoolean rtValue = (SoapRpsBoolean) SoapClientBase
                .execSoapServerFunc(paramVec, "delAuth", URN_COMMON_SERVICE,
                        routerUrl);
        return rtValue;
    }

    public static void setLDAPInfo(Object obj, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(obj);
        if (obj instanceof AuthInfo) {
            SoapClientBase.execSoapServerFunc(paramVec, "setLDAPInfo4Auth",
                    URN_COMMON_SERVICE, routerUrl);
        } else if (obj instanceof NativeInfo) {
            SoapClientBase.execSoapServerFunc(paramVec, "setLDAPInfo4Nati",
                    URN_COMMON_SERVICE, routerUrl);
        }
        return;
    }

    public static void delIPTable(String server, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(server);
        SoapClientBase.execSoapServerFunc(paramVec, "delIPTable",
                URN_COMMON_SERVICE, routerUrl);
        return;
    }

    public static void joinDomain(String target, String type, String domain,
            String username, String passwd, String netbiosname, String dnsServer)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(type);
        paramVec.add(domain);
        paramVec.add(username);
        paramVec.add(passwd);
        paramVec.add(netbiosname);
        paramVec.add(dnsServer);
        SoapClientBase.execSoapServerFunc(paramVec, "joinDomain",
                URN_COMMON_SERVICE, target);
    }

    public static void setADSConf(String target, String ntdomain,
            String dnsDomain, String kdcServer) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(ntdomain);
        paramVec.add(dnsDomain);
        paramVec.add(kdcServer);
        SoapClientBase.execSoapServerFunc(paramVec, "setADSConf",
                URN_COMMON_SERVICE, target);
    }

    public static Vector getADSConf(String target, String ntdomain)
            throws Exception {
        Vector paramVec = getADSConf(target, ntdomain, null);
        return paramVec;
    }

    public static Vector getADSConf(String target, String ntdomain,
            String groupNo) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(ntdomain);
        SoapRpsVector rtValue = null;
        if (groupNo == null) {
            rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                    paramVec, "getADSConf", URN_COMMON_SERVICE, target);
        } else {
            paramVec.add(groupNo);
            if (groupNo.equals("1")) {
                rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                        paramVec, "getADSConf", URN_COMMON_SERVICE, target,
                        WHICH_NODE_ID1);
            } else if (groupNo.equals("0")) {
                rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                        paramVec, "getADSConf", URN_COMMON_SERVICE, target,
                        WHICH_NODE_ID0);
            }
        }

        return rtValue.getVector();
    }

    public static void checkoutADSFiles(String target, String ntdomain)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(ntdomain);
        SoapClientBase.execSoapServerFunc(paramVec, "checkoutADSFiles",
                URN_COMMON_SERVICE, target);
    }

    public static void checkinADSFiles(String target, String ntdomain)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(ntdomain);
        SoapClientBase.execSoapServerFunc(paramVec, "checkinADSFiles",
                URN_COMMON_SERVICE, target);
    }

    public static void rollbackADSFiles(String target, String ntdomain)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(ntdomain);
        SoapClientBase.execSoapServerFunc(paramVec, "rollbackADSFiles",
                URN_COMMON_SERVICE, target);
    }

    public static Vector getNISDomainList(String target) throws Exception {
        Vector paramVec = new Vector();
        SoapRpsVector rtValue = (SoapRpsVector) SoapClientBase
                .execSoapServerFunc(paramVec, "getNISDomainList",
                        URN_COMMON_SERVICE, target);
        return rtValue.getVector();
    }

    public static boolean isUsedNISDomainByNFS(String target, String nisDomain)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(nisDomain);
        SoapRpsBoolean rtValue = (SoapRpsBoolean) SoapClientBase
                .execSoapServerFunc(paramVec, "isUsedNISDomainByNFS",
                        URN_COMMON_SERVICE, target);
        return rtValue.getBoolean();
    }

    public static String getHasLdapSam(String routerUrl, String localdomain,
            String netbios) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(localdomain);
        paramVec.add(netbios);
        SoapRpsString rtValue = (SoapRpsString) SoapClientBase
                .execSoapServerFunc(paramVec, "getHasLdapSam",
                        URN_COMMON_SERVICE, routerUrl);
        return (String) rtValue.getString();
    }

    public static void delYPConf(String domain, String server, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(domain);
        paramVec.add(server);
        SoapClientBase.execSoapServerFunc(paramVec, "delYPConf",
                URN_COMMON_SERVICE, routerUrl);
    }

    public static int checkExport(String exportGroup, String localDomainName,
            String netbiosName, String mountPoint, String routerUrl)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(exportGroup);
        paramVec.add(localDomainName);
        paramVec.add(netbiosName);
        paramVec.add(mountPoint);
        SoapRpsInteger rtValue = (SoapRpsInteger) SoapClientBase
                .execSoapServerFunc(paramVec, "checkExport",
                        URN_COMMON_SERVICE, routerUrl);
        return rtValue.getInt();
    }

    public static void getNetbiosStatus(String routerUrl, String localDomain,
            String oldNetbios) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(localDomain);
        paramVec.add(oldNetbios);
        SoapClientBase.execSoapServerFunc(paramVec, "getNetbiosStatus",
                URN_COMMON_SERVICE, routerUrl);
        return;
    }

    public static boolean checkNetbios(String routerUrl, String newNetbios)
            throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(newNetbios);
        SoapRpsBoolean rtValue = (SoapRpsBoolean) SoapClientBase
                .execSoapServerFunc(paramVec, "checkNetbios",
                        URN_COMMON_SERVICE, routerUrl);
        return rtValue.getBoolean();
    }

    public static void changeNetbios(String routerUrl, String exportRoot,
            String localDomain, String oldNetbios, String newNetbios,
            String security) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(exportRoot);
        paramVec.add(localDomain);
        paramVec.add(oldNetbios);
        paramVec.add(newNetbios);
        paramVec.add(security);
        SoapClientBase.execSoapServerFunc(paramVec, "changeNetbios",
                URN_COMMON_SERVICE, routerUrl);
        return;
    }

    public static void changeNameRule(String routerUrl, String localDomain,
            String oldNetbios, String newNetbios) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(localDomain);
        paramVec.add(oldNetbios);
        paramVec.add(newNetbios);
        SoapClientBase.execSoapServerFunc(paramVec, "changeNameRule",
                URN_COMMON_SERVICE, routerUrl);
        return;
    }

    public static String getSecurity(String routerUrl, String localDomain,
            String netBios) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(localDomain);
        paramVec.add(netBios);
        SoapRpsString rtValue = (SoapRpsString) SoapClientBase
                .execSoapServerFunc(paramVec, "getSecurity",
                        URN_COMMON_SERVICE, routerUrl);
        return (String) rtValue.getString();
    }
}