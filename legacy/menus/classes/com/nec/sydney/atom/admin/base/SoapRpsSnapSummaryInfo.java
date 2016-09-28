/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.atom.admin.snapshot.SnapSummaryInfo;
import com.nec.sydney.net.soap.*;

public class SoapRpsSnapSummaryInfo extends SoapResponse{

    private static final String     cvsid = "@(#) $Id: SoapRpsSnapSummaryInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private SnapSummaryInfo info;
    public SoapRpsSnapSummaryInfo(){
    }
    public SnapSummaryInfo getInfo(){
        return info;
    }
    public void setInfo(SnapSummaryInfo realInfo){
        info=realInfo;
    }
}