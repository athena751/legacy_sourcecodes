/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.ethguard;
import com.nec.sydney.net.soap.SoapResponse;

public class EthguardInfo extends SoapResponse{
    private static final String     cvsid = "@(#) $Id: EthguardInfo.java,v 1.1 2004/03/02 00:54:13 baiwq Exp $";

    private String loggingStatus    = "";
    private String connectionLimits = "";
    
    public EthguardInfo() {
    }
    
    public void setLoggingStatus (String loggingStatus) {
        this.loggingStatus  = loggingStatus ;
    }
    public String getLoggingStatus(){
        return this.loggingStatus;
    }
    
    public void setConnectionLimits (String connectionLimits) {
        this.connectionLimits  = connectionLimits ;
    }
    public String getConnectionLimits(){
        return this.connectionLimits;
    }

}