/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.quota.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;

import java.util.*;
import java.io.*;

public class GetQuotaStatusBean extends AbstractJSPBean implements NasConstants,NasSession,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: GetQuotaStatusBean.java,v 1.2301 2004/03/04 01:24:19 zhangjx Exp $";


    public GetQuotaStatusBean()
    {    
     }

    public void beanProcess() throws Exception
    {
    }    
    
    public String getQuotaStatus() throws Exception
    {
        return getQuotaStatus(false);   
    }
    
    public String getQuotaStatus(boolean isDirQuota) throws Exception
    {
        
        String filesystem = isDirQuota?(String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET):(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        return QuotaSOAPClient.getQuotaStatus(target,filesystem,isDirQuota);
    }
}