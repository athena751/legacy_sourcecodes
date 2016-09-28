/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;



public class DiskArrayDacInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayDacInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";


    private String type;

    private String ctlName;
    private String ctlNo;
    private String state;
    private String complement;

        public DiskArrayDacInfo()
        {
            type="";
            ctlName="";
            ctlNo="";
            state="";
            complement="";
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

        public String getComplement()
        {
            return complement;
        }

        public void setType(String dac_type)
        {
            type=dac_type;
        }
        
        public void setCtlName(String dac_ctlName)
        {
            ctlName=dac_ctlName;
        }

        public void setCtlNo(String dac_ctlNo)
        {
            ctlNo=dac_ctlNo;
        }
 
        public void setState(String dac_state)
        {
            state=dac_state;
        }

        public void setComplement(String dac_complement)
        {
            complement=dac_complement;
        }  
}