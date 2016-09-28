/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;



public class DiskArrayPortInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayPortInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";


    private String portNo;

    private String name;
    private String mode;
    private String state;
    private String protocol;

    public DiskArrayPortInfo()
    {
        portNo="";
        name="";
        mode="";
        state="";
    }

    public String getPortNo()
    {
        return portNo;
    }
    public String getName()
    {
        return name;
    }
    public String getMode()
    {
        return mode;
    }
    public String getState()
    {
        return state;
    }
    public String getProtocol()
    {
        return protocol;
    }

    public void setPortNo(String portNoValue)
    {
        portNo=portNoValue;
    }
    public void setName(String nameValue)
    {
        name=nameValue;
    }
    public void setMode(String modeValue)
    {
        mode=modeValue;
    }
    public void setState(String stateValue)
    {
        state=stateValue;
    }
    public void setProtocol(String protocolValue)
    {
        protocol=protocolValue;
    }
}
