/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.exportroot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*;
import com.nec.sydney.atom.admin.snapshot.*;

/*******************************************************************************
 * 
 * this program is designed for the soap client of *
 * 
 * configuring ExportRoot(2002/1) *
 * 
 ******************************************************************************/

public class ExportRootSOAPClient implements NasConstants, NSExceptionMsg {
    private static final String cvsid = "@(#) $Id: ExportRootSOAPClient.java,v 1.2303 2007/04/26 06:50:32 wanghb Exp $";

    private static final String URN_EXPORT_SERVICE = "urn:ExportRootConf";

    private static final String URN_SNAPSHOT_SERVICE = "urn:SnapshotConf";

    /* none properties here */

    public static Vector getMPList(String exportGroup, String localDomain,
            String netBios, String routerUrl, String groupNo) throws Exception {
        Vector paramVec = new Vector();
        SoapRpsVector rtValue = new SoapRpsVector();
        paramVec.add(exportGroup);
        paramVec.add(localDomain);
        paramVec.add(netBios);
        if (groupNo == null) {
            rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                    paramVec, "getMPList", URN_EXPORT_SERVICE, routerUrl);

        } else {
            paramVec.add(groupNo);
            if (groupNo.equals("1")) {
                rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                        paramVec, "getMPList", URN_EXPORT_SERVICE, routerUrl,
                        WHICH_NODE_ID1);
            } else if (groupNo.equals("0")) {
                rtValue = (SoapRpsVector) SoapClientBase.execSoapServerFunc(
                        paramVec, "getMPList", URN_EXPORT_SERVICE, routerUrl,
                        WHICH_NODE_ID0);
            }
        }
        return rtValue.getVector();
    } // end function getMPList

    public static String hexMP2DevName(String mountPoint, String routerUrl,
            String groupNo) throws Exception {
        Vector paramVec = new Vector();
        SoapRpsString rtValue = new SoapRpsString();
        paramVec.add(mountPoint);
        if (groupNo == null) {
            rtValue = (SoapRpsString) SoapClientBase.execSoapServerFunc(
                    paramVec, "hexMP2DevName", URN_SNAPSHOT_SERVICE, routerUrl);

        } else {
            if (groupNo.equals("1")) {
                rtValue = (SoapRpsString) SoapClientBase.execSoapServerFunc(
                        paramVec, "hexMP2DevName", URN_SNAPSHOT_SERVICE,
                        routerUrl, WHICH_NODE_ID1);
            } else {
                rtValue = (SoapRpsString) SoapClientBase.execSoapServerFunc(
                        paramVec, "hexMP2DevName", URN_SNAPSHOT_SERVICE,
                        routerUrl, WHICH_NODE_ID0);
            }
        }
        return rtValue.getString();
    }// end function hexMP2DevName

    // Call SnapSOAPServer service "getSnapSchedule"
    public static SnapSummaryInfo getSnapSchedule(String mountPoint,
            String deviceName, String account, String routerUrl, String groupNo)
            throws Exception {
        Vector paramVec = new Vector();
        SoapRpsSnapSummaryInfo rtValue = new SoapRpsSnapSummaryInfo();
        paramVec.add(mountPoint);
        paramVec.add(deviceName);
        paramVec.add(account);
        if (groupNo == null) {
            rtValue = (SoapRpsSnapSummaryInfo) SoapClientBase
                    .execSoapServerFunc(paramVec, "getSnapSchedule",
                            URN_SNAPSHOT_SERVICE, routerUrl);

        } else {
            if (groupNo.equals("1")) {
                rtValue = (SoapRpsSnapSummaryInfo) SoapClientBase
                        .execSoapServerFunc(paramVec, "getSnapSchedule",
                                URN_SNAPSHOT_SERVICE, routerUrl, WHICH_NODE_ID1);
            } else {
                rtValue = (SoapRpsSnapSummaryInfo) SoapClientBase
                        .execSoapServerFunc(paramVec, "getSnapSchedule",
                                URN_SNAPSHOT_SERVICE, routerUrl, WHICH_NODE_ID0);
            }
        }
        return rtValue.getInfo();
    }// end function getSnapSchedule

}