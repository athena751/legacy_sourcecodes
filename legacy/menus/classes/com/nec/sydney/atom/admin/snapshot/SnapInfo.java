/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.snapshot;



public class SnapInfo

{


    private static final String     cvsid = "@(#) $Id: SnapInfo.java,v 1.2301 2005/08/29 05:26:35 wangzf Exp $";


    //the subItems of snapshot info

    private String name;
    private String date;
    private String time;
    private String status;
   
    //constructor
    public SnapInfo()
    {
        name    = "";
        date    = "";
        time    = "";
        status    = "";
    }
    
    // the GET methods
    public String getName()
    {
        return name;
    }
    public String getDate()
    {
        return date;
    }
    public String getTime()
    {
        return time;
    }
    public String getStatus()
    {
        return status;
    }
    
    //the SET methods
    public void setName(String paramName)
    {
        name    = paramName;
    }
    public void setDate(String paramDate)
    {
        date    = paramDate;
    }
    public void setTime(String paramTime)
    {
        time    = paramTime;
    }
    public void setStatus(String paramStatus)
    {
        status    = paramStatus;
    }
        
    /**
     * @return
     */
    public String getDateTime() {
        return date + "  " + time;
    }
}
