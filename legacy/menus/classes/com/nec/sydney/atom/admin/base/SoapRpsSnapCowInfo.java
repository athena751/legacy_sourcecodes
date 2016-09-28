/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.net.soap.*;
public class SoapRpsSnapCowInfo extends SoapResponse
{

    private static final String     cvsid = "@(#) $Id: SoapRpsSnapCowInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";

    private SnapCowInfo cowInfo;
    public SnapCowInfo getCowInfo()
    {
        return cowInfo;
    }
    public void setCowInfo(SnapCowInfo cowInfo)
    {
        this.cowInfo = cowInfo;
    }
}
