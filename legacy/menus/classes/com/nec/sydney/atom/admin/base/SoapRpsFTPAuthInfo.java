/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      cvsid = "@(#) $Id: SoapRpsFTPAuthInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";
 */

package com.nec.sydney.atom.admin.base;
import com.nec.sydney.atom.admin.ftp.FTPAuthInfo;
import com.nec.sydney.net.soap.*;

public class SoapRpsFTPAuthInfo extends SoapResponse
{
    private FTPAuthInfo info;
    public SoapRpsFTPAuthInfo()
    {
        info=new FTPAuthInfo();
    }
    
    public FTPAuthInfo getInfo()
    {
        return info;
    }
    
    public void setInfo(FTPAuthInfo realInfo)
    {
        info=realInfo;
    }
}