/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;
import java.util.*;

public class DiskArrayLinkInfo{
    private static final String     cvsid = "@(#) $Id: DiskArrayLinkInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";

    private String linkDiskArrayName;
    private String linkNo;
    private String pathNo;
    private String pathState;
    private String directorNo;

    public String getLinkDiskArrayName(){
        return linkDiskArrayName;
    }
    public void setLinkDiskArrayName(String linkDiskArrayName){
        this.linkDiskArrayName = linkDiskArrayName;
    }
    public String  getLinkNo(){
        return linkNo;
    }
    public void setLinkNo(String linkNo){
        this.linkNo = linkNo;
    }
    public String getPathNo(){
        return pathNo;
    }
    public void setPathNo(String pathNo){
        this.pathNo = pathNo;
    }
    public String  getPathState(){
        return pathState;
    }
    public void setPathState(String pathState){
        this.pathState = pathState;
    }
    public String getDirectorNo(){
        return directorNo;
    }
    public void setDirectorNo(String directorNo){
        this.directorNo = directorNo;
    }
}
