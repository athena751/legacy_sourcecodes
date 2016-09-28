/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

public interface PartnerFailedProcessor{
    public static final String cvsid 
            = "@(#) $Id: PartnerFailedProcessor.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
    public void process()throws Exception;
}