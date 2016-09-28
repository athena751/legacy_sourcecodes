/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      cvsid = "@(#) $Id: SoapRpsFTPInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.atom.admin.ftp.FTPInfo;
import com.nec.sydney.net.soap.*;

public class SoapRpsFTPInfo extends SoapResponse
{

    private FTPInfo info;
    public SoapRpsFTPInfo()
    {
        info=new FTPInfo();
    } 
    
    public void setFTPInfo(FTPInfo ftpinfo)
    {
    	info = ftpinfo;
    }
    
    public FTPInfo getFTPInfo()
    {
    	return info;
    }
}