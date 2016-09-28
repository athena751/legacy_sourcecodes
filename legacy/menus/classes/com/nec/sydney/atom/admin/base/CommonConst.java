/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: CommonConst.java,v 1.2300 2003/11/24 00:54:39 nsadmin Exp $";
 */


package  com.nec.sydney.atom.admin.base;

public interface CommonConst{

    public static int NAS_SUCCESS                     = 0;
    public static int NAS_ERROR_INVALID_PARAMETER     = 1;
    public static int NAS_ERROR_SOAP_FAULT            = 2;
    public static int NAS_ERROR_SERVICE_FAIL          = 3;

    public static String CSSFILE                    = "menu/common/default.css";
    public static String BROWSER_ENCODE             = "EUC-JP";

    public static String SCRIPT_DIR                 = "/bin/";
    public static String COMMAND_SUDO               = "sudo";
    public static String SUDO_COMMAND               = "sudo";

}
