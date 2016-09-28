/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: CmdErrHandler.java,v 1.2300 2003/11/24 00:54:58 nsadmin Exp $";
 */

package com.nec.sydney.service.admin;
import com.nec.sydney.net.soap.*;

public interface CmdErrHandler {
  public void errHandle(SoapResponse trans,Process proc,String[] cmds) throws Exception;
}
