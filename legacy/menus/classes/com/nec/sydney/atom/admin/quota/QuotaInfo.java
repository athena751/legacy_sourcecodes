/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.quota;

public class QuotaInfo

{
    private static final String     cvsid = "@(#) $Id: QuotaInfo.java,v 1.2301 2004/11/12 02:37:46 zhangjx Exp $";
    
    private String ID ;
    private String dataset;
    private String blockSoftLimit;
    private String blockHardLimit;
    private String blockGraceTime;
    private String blockUsed;
    private String fileSoftLimit;
    private String fileHardLimit;
    private String fileGraceTime;
    private String fileUsed;
 
    public QuotaInfo()
    {
        ID = "&nbsp;";
        dataset = "&nbsp;";
        blockSoftLimit = "&nbsp;";
        blockHardLimit = "&nbsp;";
        blockGraceTime = "&nbsp;";
        blockUsed = "&nbsp;";
        fileSoftLimit = "&nbsp;";
        fileHardLimit = "&nbsp;";
        fileGraceTime = "&nbsp;";
        fileUsed = "&nbsp;";
    } 
    
    public String getID()
    {
        return ID;
    }
    public void setID(String ID)
    {
        this.ID=ID;
    }
    public String getDataSet()
    {
        return dataset;
    }
    public void setDataSet(String dataset)
    {
        this.dataset=dataset;
    }
    public String getBlockSoftLimit()
    {
        return blockSoftLimit;
    }
    public void setBlockSoftLimit(String blockSoftLimit)
    {
        this.blockSoftLimit=blockSoftLimit;
    }
    public String getBlockHardLimit()
    {
        return blockHardLimit;
    }
    public void setBlockHardLimit(String blockHardLimit)
    {
        this.blockHardLimit=blockHardLimit;
    }
    public String getBlockGraceTime()
    {
        return blockGraceTime;
    }
    public void setBlockGraceTime(String blockGraceTime)
    {
        this.blockGraceTime=blockGraceTime;
    }
    public String getBlockUsed()
    {
        return blockUsed;
    }
    public void setBlockUsed(String blockUsed)
    {
        this.blockUsed=blockUsed;
    }

    public String getFileSoftLimit()
    {
        return fileSoftLimit;
    }
    public void setFileSoftLimit(String fileSoftLimit)
    {
        this.fileSoftLimit=fileSoftLimit;
    }
    public String getFileHardLimit()
    {
        return fileHardLimit;
    }
    public void setFileHardLimit(String fileHardLimit)
    {
        this.fileHardLimit=fileHardLimit;
    }
    public String getFileGraceTime()
    {
        return fileGraceTime;
    }
    public void setFileGraceTime(String fileGraceTime)
    {
        this.fileGraceTime=fileGraceTime;
    }
    public String getFileUsed()
    {
        return fileUsed;
    }
    public void setFileUsed(String fileUsed)
    {
        this.fileUsed=fileUsed;
    }
}