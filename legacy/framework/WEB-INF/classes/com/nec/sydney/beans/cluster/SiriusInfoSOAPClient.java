/*
 *      Copyright (c) 2002 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.beans.cluster;


import	java.util.*;
import	com.nec.sydney.framework.*;
import	com.nec.sydney.net.soap.*;
import	com.nec.sydney.atom.admin.cluster.*;


public class SiriusInfoSOAPClient {
    private static final String	cvsid = "@(#) $Id: SiriusInfoSOAPClient.java,v 1.2302 2005/10/28 11:22:54 changhs Exp $";
    public SiriusInfoSOAPClient() {}

    public boolean		is1Node(String target) throws Exception {
        NSReporter.getInstance().report(NSReporter.DEBUG, "is1Node: " + target);
        String[]	addrs = { null, null, null};
        String	fip = SoapManager.getInstance().getFIPAddress(target);
        String	checkedTarget;

        if (fip == null) { // single NAS
            addrs[0] = SoapManager.getInstance().getAddress(target, -1);
            checkedTarget = addrs[0];
        } else { // cluster
            addrs[0] = fip;
            addrs[1] = SoapManager.getInstance().getAddress(target, 0); // 1:0 !!
            addrs[2] = SoapManager.getInstance().getAddress(target, 1); // 2:1 !!
            checkedTarget = addrs[0] + "/" + addrs[1] + "/" + addrs[2];
        }
        NSReporter.getInstance().report(NSReporter.DEBUG,
                "checkedTarget: " + checkedTarget);
        SiriusInfo	sirius = null;
        int	type = -1; // unknown
        int	a;

        for (a = 0; a <= 2; ++a) {
            NSReporter.getInstance().report(NSReporter.DEBUG,
                    "is 1 node sirius? " + addrs[a]);
            if (addrs[a] == null) {
                break;
            }
            try {
                sirius = getSiriusInfo(addrs[a]);
            } catch (Exception ex) {
                sirius = null;
                continue;
            }
            type = sirius.getType();
            NSReporter.getInstance().report(NSReporter.DEBUG,
                    addrs[a] + " type: " + type);
            if (type == 3 || type == 4 || type == 9 || type == 10) {
                return true;
            }
        }
        if (type == -1) { // dead
            NSReporter.getInstance().report(NSReporter.ERROR,
                    checkedTarget + ": are all down");
            Soap4Cluster.throwNSClusterException(checkedTarget, "dead");
        }
        /* modified by changhs 2005/10/26 for NAS5.1's checknode's change.
         * if (type > 100) { // unknown type
            NSReporter.getInstance().report(NSReporter.ERROR,
                    checkedTarget + ": unknown machine type");
            Soap4Cluster.throwNSClusterException(checkedTarget, "unknowntype");
        }*/
        NSReporter.getInstance().report(NSReporter.DEBUG, "not 1 node sirius");
        return false;
    }

    public SiriusInfo	getSiriusInfo(String target) throws Exception {
        NSReporter.getInstance().report(NSReporter.DEBUG, 
                "getSiriusInfo: " + target);
        SoapLite	sl = new SoapLite();

        sl.init(urn);
        NSException	ex = new NSException();

        ex.setCategory(this.getClass());
        boolean ret = sl.callTheTarget(
                SoapManager.getInstance().getRouterByAddress(target),
                "getSiriusInfo");

        if (ret == true) {
            SiriusInfo	response = (SiriusInfo) sl.getValue();

            if (response.isSuccessful()) {
                return response;
            }
            NSReporter.getInstance().report(NSReporter.ERROR, 
                    "Exception: " + response.getErrorMessage());
            ex.setReason(response.getErrorMessage());
            throw ex;
        } else {
            NSReporter.getInstance().report(NSReporter.ERROR, 
                    "Exception: " + sl.getFaultReason());
            ex.setReason(sl.getFaultReason());
            throw ex;
        }
    }
    private static final String	urn = "urn:Sirius";
}
