/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package  com.nec.sydney.atom.admin.ddr;

public interface DdrConstants {
    public static final String     cvsid = "@(#) $Id: DdrConstants.java,v 1.5 2008/04/20 06:57:18 liy Exp $";
    
    public static final String DDR_CRON_FILE_NAME        = "/var/spool/cron/ddr";
    
    public static final String DDR_EXCEP_NO_SAME_SCHEDULE        = "0x13711111";
    public static final String DDR_EXCEP_NO_CRONTAB_FAILED       = "0x13711112";
    public static int DDR_CRON_PERIOD_WEEKDAY   = 1;
    public static int DDR_CRON_PERIOD_MONTHDAY  = 2;
    public static int DDR_CRON_PERIOD_DAILY     = 3;
    public static int DDR_CRON_PERIOD_DIRECT    = 4;
        
    public static final String DDR_SESSION_ALL_PAIR = "ddr_session_all_pair";
   
}