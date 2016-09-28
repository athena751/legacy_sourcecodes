/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.nsgui.model.entity.base;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;


public class DirectoryInfoBean {
    private static final String     cvsid = "@(#) $Id: DirectoryInfoBean.java,v 1.3 2004/12/21 07:46:28 baiwq Exp $";
	
    private String displayedPath ;
    private String wholePath;
    private String displaySelectedPath; // wholePath - rootDirectory
    private String dateString;
    private String timeString;
    private String dirType; // "file" or "directory"
    private String mountStatus;
	
    public DirectoryInfoBean() {
	displayedPath = "";
	wholePath = "";
	displaySelectedPath = "";
	dateString = "";
	timeString = "";
	dirType = "";
	mountStatus = "";
    }
	
    public String getDisplayedPath() {
	return this.displayedPath;
    }
	
    public void setDisplayedPath(String displayedPath) {
	this.displayedPath = displayedPath;
    }
	
    public String getWholePath() {
	return this.wholePath;
    }
	
    public void setWholePath(String wholePath) {
	this.wholePath = wholePath;
    }
	
    public String getDisplaySelectedPath() {
	return this.displaySelectedPath;
    }
	
    public void setDisplaySelectedPath(String displaySelectedPath) {
	this.displaySelectedPath = displaySelectedPath;
    }
	
    public String getDateString() {
	return this.dateString;
    }
	
    public void setDateString(String dateString) {
	this.dateString = dateString;
    }
	
    public String getTimeString() {
	return this.timeString;
    }
	
    public void setTimeString(String timeString) {
	this.timeString = timeString;
    }
	
    public String getDirType() {
	return this.dirType;
    }
	
    public void setDirType(String dirType) {
	this.dirType = dirType;
    }
    
    public String getMountStatus() {
        return this.mountStatus;
    }
    
    public void setMountStatus(String mountStatus) {
        this.mountStatus = mountStatus;
    }
    
    public static void sortByDisplayedPath (List the_list){
        Collections.sort
            (the_list, new Comparator()
                {
                    public int compare(Object a, Object b){
                        DirectoryInfoBean info_a = (DirectoryInfoBean)a;
                        DirectoryInfoBean info_b = (DirectoryInfoBean)b;
                        return info_a.getDisplayedPath().compareTo(info_b.getDisplayedPath());
                    }
               }
            );
    }
}