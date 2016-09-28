/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.atom.admin.nfs.*;
import com.nec.sydney.net.soap.*;

public class SoapRpsExportInfo extends SoapResponse
{

    private static final String     cvsid = "@(#) $Id: SoapRpsExportInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";

    private ExportsInfo info;
    public SoapRpsExportInfo()
    {
        info=new ExportsInfo();
    }
    public ExportsInfo getInfo()
    {
        return info;
    }
    public void setInfo(ExportsInfo realInfo)
    {
        info=realInfo;
    }
}
