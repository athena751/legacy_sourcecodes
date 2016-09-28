/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;


public class DiskArrayPDInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayPDInfo.java,v 1.2303 2005/12/16 06:42:31 wangli Exp $";


    private String pdNo;

    private String state;
    private String capacity;
    private String poolNo;
    private String poolName;
    private String pdDivision;
    private String productID;
    private String productRevision;
    private String serialNo;
    private String spinNumber;
    private String progression;
    private String type;

        public DiskArrayPDInfo()
        {
             pdNo="";
             state="";
             capacity="";
             poolNo="";
             poolName="";
             pdDivision="";
             productID="";
             productRevision="";
             serialNo="";
             spinNumber="";
        }
 
        public String getPdNo()
        {
             return pdNo;
        }

        public String getState()
        {
             return state;
        }

        public String getCapacity()
        {
             return capacity;
        }

        public String getPdDivision()
        {
             return pdDivision;
        }

        public String getProductID()
        {
             return productID;
        }
 
        public String getProductRevision()
        {
             return productRevision;
        }

        public String getSerialNo()
        {
             return serialNo;
        }

        public String getSpinNumber()
        {
             return spinNumber;
        }

        public void setPdNo(String pd_No)
        {
             pdNo=pd_No;
        }

        public void setState(String pd_state)
        {
             state=pd_state;
        }

        public void setCapacity(String pd_capacity)
        {
             capacity=pd_capacity;
        }

        public void setPdDivision(String pd_Division)
        {
             pdDivision=pd_Division;
        }

        public void setProductID(String pd_productID)
        {
             productID=pd_productID;
        }
 
        public void setProductRevision(String pd_productRevision)
        {
             productRevision=pd_productRevision;
        }

        public void setSerialNo(String pd_serialNo)
        {
             serialNo=pd_serialNo;
        }

        public void setSpinNumber(String pd_spinNumbe)
        {
             spinNumber=pd_spinNumbe;
        }

        public String getPoolName() {
            return poolName;
        }

        public void setPoolName(String poolName) {
            this.poolName = poolName;
        }

        public String getPoolNo() {
            return poolNo;
        }

        public void setPoolNo(String poolNo) {
            this.poolNo = poolNo;
        }

        public String getProgression() {
            return progression;
        }

        public void setProgression(String progression) {
            this.progression = progression;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }
}