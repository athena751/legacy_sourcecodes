/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;



public class DiskArrayDeInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayDeInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";


    private String type;

    private String ctlName;
    private String ctlNo;
    private String state;

        public DiskArrayDeInfo() 
        {
            type="";
            ctlName="";
            ctlNo="";
            state="";
        }

        public String getType()
        {
            return type;
        }
        
        public String getCtlName()
        {
            return ctlName;
        }

        public String getCtlNo()
        {
            return ctlNo;
        }
 
        public String getState()
        {
            return state;
        }

        public void setType(String de_type)
        {
            type=de_type;
        }
        
        public void setCtlName(String de_ctlName)
        {
            ctlName=de_ctlName;
        }

        public void setCtlNo(String de_ctlNo)
        {
            ctlNo=de_ctlNo;
        }
 
        public void setState(String de_state)
        {
            state=de_state;
        }

}